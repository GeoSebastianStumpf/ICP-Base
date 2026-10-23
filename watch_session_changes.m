function watcher = watch_session_changes(module_app, verbose)
% WATCH_SESSION_CHANGES  Mark the session of a module as unsynced as soon as anything writes to it.
%
% Call this once, at the very start of the startupFcn of a module:
%
%       watch_session_changes(app)          % normal use
%       watch_session_changes(app, true)    % testing: prints where the first write came from
%
% Requirement: the module property 'base' must be declared with the SetObservable attribute:
%
%       properties (Access = public, SetObservable)
%           base
%       end
%
% How it works: every assignment into app.base (app.base.project.session...., including nested
% fields, removed fields, indexed writes and table writes) fires the PostSet event of 'base'.
% The first time that happens, config.synced of the module's copy of the session is set to false.
% save_to_base then hands that copy to the base module, which shows the session as unsynced.
% Reading app.base does not fire the event, so merely looking at a session keeps it synced.
%
% The listener lives as long as the module app (addlistener ties it to the source object).

    if nargin < 2
        verbose = false;
    end

    % The listener handle is returned so that a module can pause the watcher around a calculation
    % (watcher.Enabled = false) and decide afterwards whether the result counts as a change.
    % Calls that ignore the output work as before.
    session_listener = addlistener(module_app, 'base', 'PostSet', @(~, ~) mark_session_unsynced(module_app, verbose));

    % Only hand the listener back if the caller asked for it. A call without an output and
    % without a semicolon then prints nothing.
    if nargout > 0
        watcher = session_listener;
    end
end


function mark_session_unsynced(module_app, verbose)

    try
        session_config = module_app.base.project.session.config;

        if isfield(session_config, 'synced') && ~session_config.synced
            return    % already unsynced, nothing to do
        end

        module_app.base.project.session.config.synced = false;

        if verbose
            call_stack = dbstack;
            fprintf('[watch_session_changes] first write detected, session set to unsynced. Call stack:\n');
            for level = 1:min(numel(call_stack), 8)
                fprintf('    %s (line %d)\n', call_stack(level).name, call_stack(level).line);
            end
        end

    catch watcher_error
        % The watcher must never break a module. Before base.project.session exists (early in
        % startup) there is simply nothing to mark yet.
        if verbose
            fprintf('[watch_session_changes] watcher skipped: %s\n', watcher_error.message);
        end
    end
end
