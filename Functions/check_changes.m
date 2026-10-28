function changes = check_changes(app, stage, dialog_figure)
% CHECK_CHANGES  Gate in front of every edit in a module: asks before results that depend on
% the edit are thrown away, resets them, and marks the session as changed.
%
%   changes = check_changes(app, 'interval');
%   if changes == false, return, end
%   app.editstatus = true;
%
% app            the module app whose session is edited (for a submodule: its parent module,
%                for example check_changes(app.source, 'interval', app.UIFigure))
% stage          which module the edit happens in. It decides what is reset. See reset_rules below.
% dialog_figure  optional, the figure the dialog appears on (default app.UIFigure)
%
% changes = false  the user pressed Cancel, nothing was changed, the caller must not go on
% changes = true   the caller may go on with the edit
%
% HOW TO ADD A MODULE
%   1. add a row to reset_rules (below): which stages count as "done", which statuses are reset,
%      which field groups are removed, the dialog text and the GUI refresh methods
%   2. new spot fields that a reset must remove go into a group in field_groups
%   3. call changes = check_changes(app, '<newmodule>') in the module
%
% Needs in the module app: base, UIFigure, sourceapp, project_id, session_id and the public
% method update_progress_buttons. The refresh methods named in reset_rules must be public too.

    if nargin < 3 || isempty(dialog_figure)
        dialog_figure = app.UIFigure;
    end

    stage  = char(stage);
    rules  = reset_rules();
    groups = field_groups();

    if ~isfield(rules, stage)
        error('check_changes:unknownStage', ...
            'Unknown stage "%s". Add a row for it to reset_rules in check_changes.m.', stage);
    end
    rule = rules.(stage);

    % ---- nothing that depends on this edit is done yet: just mark the session as changed ----
    module_status = app.base.project.session.config.module_status;

    if ~any_stage_is_done(module_status, rule.dialog_if_done)
        app.base.project.session.config.synced = false;
        if isfield(rule, 'outdated_flag')
            app.base.project.session.config.(rule.outdated_flag) = true;
        end
        changes = true;
        return
    end

    % ---- ask ----
    selection = uiconfirm(dialog_figure, rule.message, rule.title, ...
        "Options", ["Yes", "Cancel"], ...
        "DefaultOption", 1, "CancelOption", 2);

    if strcmp(selection, 'Cancel')
        call_module_method(app, rule.refresh_after_cancel);
        changes = false;
        return
    end

    % ---- reset ----
    session = app.base.project.session;

    for stage_number = 1:numel(rule.reset_status)
        session.config.module_status.(rule.reset_status{stage_number}) = false;
    end

    spot_fields_to_remove = {};
    is_inclusion_session = isequal(session.config.reductiontype, 'Inclusion');

    for group_number = 1:numel(rule.field_groups)
        group = groups.(rule.field_groups{group_number});
        spot_fields_to_remove = [spot_fields_to_remove, group.matrix]; %#ok<AGROW>
        if is_inclusion_session
            spot_fields_to_remove = [spot_fields_to_remove, group.inclusion]; %#ok<AGROW>
        end
    end

    session.spot    = remove_fields_if_present(session.spot, spot_fields_to_remove);
    session         = remove_fields_if_present(session, rule.session_fields);

    if isfield(rule, 'config_fields')
        session.config = remove_fields_if_present(session.config, rule.config_fields);
    end
    
    session.config.synced = false;
    if isfield(rule, 'outdated_flag')
        session.config.(rule.outdated_flag) = true;
    end
    app.base.project.session = session;

    settings.ICP_Base_GUI_update_state = true;
    [app.project_id, app.session_id] = save_to_base(app.sourceapp, app.project_id, app.base.project.session, app.session_id, app.base.project_name, settings);

    changes = true;

    update_progress_buttons(app)
    call_module_method(app, rule.refresh_after_reset);
end


%% What is reset for which module ------------------------------------------------------------

function rules = reset_rules()
% One row per module. Everything a module resets is read from here.
%
%   dialog_if_done        the dialog only appears if one of these stages is done
%   reset_status          stages whose status is set to false
%   field_groups          names of groups in field_groups whose fields are removed from session.spot
%   session_fields        fields removed from the session itself (not from spot)
%   message, title        dialog text
%   refresh_after_cancel  public method of the module that restores the GUI after Cancel ('' = none)
%   refresh_after_reset   public method of the module that updates the GUI after the reset ('' = none)

    % ---- Import: resets everything ----
    rules.import.dialog_if_done       = {'interval', 'classification', 'drift', 'quantification'};
    rules.import.reset_status         = {'interval', 'classification', 'drift', 'quantification', 'results'};
    rules.import.field_groups         = {'intervals', 'spot_classification', 'spikes', 'correction_setups', ...
                                         'quantification_inputs', 'drift_outputs', 'quantification_outputs', ...
                                         'results_products'};
    rules.import.session_fields       = {'plotstyles', 'referencematerials'};
    rules.import.config_fields        = {'manual_intervals', 'quantification_outdated'};
    rules.import.message              = "You changed something, do you want to reset everything?";
    rules.import.title                = "Attention";
    rules.import.refresh_after_cancel = '';
    rules.import.refresh_after_reset  = 'refresh_panels_after_reset';

    % ---- Interval: resets the calculated results, keeps the quantification inputs ----
    rules.interval.dialog_if_done       = {'drift', 'quantification'};
    rules.interval.reset_status         = {'drift', 'quantification', 'results'};
    rules.interval.field_groups         = {'drift_outputs', 'quantification_outputs', 'results_products'};
    rules.interval.session_fields       = {};
    rules.interval.message              = "You changed something, repeat the Drift and Quantification calculations";
    rules.interval.title                = "Changes were made";
    rules.interval.refresh_after_cancel = 'update_Interval_Module_GUI';
    rules.interval.refresh_after_reset  = '';

    % ---- Classification: as Interval, plus the correction setups and the quantification inputs ----
    rules.classification.dialog_if_done       = {'drift', 'quantification'};
    rules.classification.reset_status         = {'drift', 'quantification', 'results'};
    rules.classification.field_groups         = {'correction_setups', 'quantification_inputs', 'drift_outputs', ...
                                                 'quantification_outputs', 'results_products'};
    rules.classification.session_fields       = {};
    rules.classification.message              = "You changed something, do you want to reset drift and quantification?";
    rules.classification.title                = "Attention";
    rules.classification.refresh_after_cancel = 'update_Classification_Module_GUI';
    rules.classification.refresh_after_reset  = '';

    % ---- Interference correction submodule (opened from Classification) ----
    % The corrections only configure; drift applies them. So everything drift and later produce is reset.
    rules.interference_correction.dialog_if_done       = {'drift', 'quantification'};
    rules.interference_correction.reset_status         = {'drift', 'quantification', 'results'};
    rules.interference_correction.field_groups         = {'drift_outputs', 'quantification_outputs', 'results_products'};
    rules.interference_correction.session_fields       = {};
    rules.interference_correction.message              = "You changed something, do you want to reset drift and quantification?";
    rules.interference_correction.title                = "Attention";
    rules.interference_correction.refresh_after_cancel = '';
    rules.interference_correction.refresh_after_reset  = '';

    % ---- Quantification: resets only the calculated results ----
    rules.quantification.dialog_if_done       = {'results'};
    rules.quantification.reset_status         = {'results'};
    rules.quantification.field_groups         = {'quantification_outputs'};
    rules.quantification.session_fields       = {};
    rules.quantification.message              = "You changed something, do you want to reset the results?";
    rules.quantification.title                = "Attention";
    rules.quantification.refresh_after_cancel = 'update_quantification_module_GUI';
    rules.quantification.refresh_after_reset  = '';
    rules.quantification.outdated_flag        = 'quantification_outdated';

    % ---- Switching Matrix <-> Inclusion (Import, Proceed): the unmixing changes all calculated results ----
    rules.reductiontype.dialog_if_done       = {'drift', 'quantification'};
    rules.reductiontype.reset_status         = {'drift', 'quantification', 'results'};
    rules.reductiontype.field_groups         = {'drift_outputs', 'quantification_outputs', 'results_products'};
    rules.reductiontype.session_fields       = {};
    rules.reductiontype.message              = "You switched between Matrix and Inclusion mode. Drift, Quantification and Results have to be calculated again. Continue?";
    rules.reductiontype.title                = "Attention";
    rules.reductiontype.refresh_after_cancel = '';
    rules.reductiontype.refresh_after_reset  = '';


end


%% Which fields belong together --------------------------------------------------------------

function groups = field_groups()
% Fields of session.spot, grouped by what they are. 'matrix' fields are always removed,
% 'inclusion' fields only in Inclusion sessions.

    groups.intervals = make_group( ...
        {'background_starts', 'background_ends', 'matrix_1_starts', 'matrix_1_ends', ...
         'matrix_2_starts', 'matrix_2_ends', 'matrix_3_starts', 'matrix_3_ends'}, ...
        {'inclusion_1_starts', 'inclusion_1_ends'});

    groups.spot_classification = make_group( ...
        {'type', 'referencematerial', 'bracket_id', 'integer_time_points'}, ...
        {});

    groups.spikes = make_group( ...
        {'eliminated_spikes'}, ...
        {});

    groups.correction_setups = make_group( ...
        {'icm_bracket_id', 'icm_correction_pairs', 'blank_bracket_id', 'blank_correction_elements', 'blank_spot_assignment'}, ...
        {});

    % what the user enters in the quantification module (inputs, including the +- columns)
    groups.quantification_inputs = make_group( ...
        {'internal_standard', 'internal_standard_mass_fraction', 'internal_standard_oxide_wt', 'Fe_ratio_for_total_oxide', ...
         'internal_standard_mass_fraction_uncertainty', 'internal_standard_oxide_wt_uncertainty'}, ...
        {'internal_standard_inclusion', 'internal_standard_mass_fraction_inclusion', ...
         'second_internal_standard_inclusion', 'second_internal_standard_mass_fraction_inclusion', ...
         'internal_standard_oxide_wt_inclusion', 'Fe_ratio_for_total_oxide_inclusion', ...
         'internal_standard_mass_fraction_uncertainty_inclusion', 'internal_standard_oxide_wt_uncertainty_inclusion', ...
         'second_internal_standard_mass_fraction_uncertainty_inclusion', ...
         'mixing_ratio', 'mixing_ratio_uncertainty_inclusion'});

    % what the drift module calculates
    groups.drift_outputs = make_group( ...
        {'bkgd_corrected_cps', 'background_cps', 'sensitivities', 'cal_sensitivities', ...
         'sem_bkgd_cps', 'sem_matrix_cps', 'sem_bkgd_corrected_cps', ...
         'sensitivities_uncertainty', 'sensitivities_uncertainty_rm', 'cal_sensitivities_uncertainty'}, ...
        {'bkgd_corrected_cps_mix', 'bkgd_corrected_cps_incl', 'bkgd_corrected_cps_host', ...
         'sem_bkgd_corrected_cps_mix', 'sem_bkgd_corrected_cps_incl', 'sem_bkgd_corrected_cps_host'});

    % what the quantification module calculates
    groups.quantification_outputs = make_group( ...
        {'matrix_composition', 'matrix_limits_of_detection', 'Fe_2_3', 'matrix_composition_uncertainty'}, ...
        {'inclusion_composition', 'inclusion_limits_of_detection', 'mix_composition', 'Fe_2_3_incl', ...
         'inclusion_composition_uncertainty'});

    % what the results module creates
    groups.results_products = make_group( ...
        {'analyte_calibrator_assignment'}, ...
        {});

end

function group = make_group(matrix_fields, inclusion_fields)
    group.matrix    = matrix_fields;
    group.inclusion = inclusion_fields;
end


%% Helpers -----------------------------------------------------------------------------------

function done = any_stage_is_done(module_status, stage_names)
    done = false;
    for stage_number = 1:numel(stage_names)
        stage_name = stage_names{stage_number};
        if isfield(module_status, stage_name) && isequal(module_status.(stage_name), true)
            done = true;
            return
        end
    end
end

function data = remove_fields_if_present(data, field_names)
    is_present = isfield(data, field_names);
    if any(is_present)
        data = rmfield(data, field_names(is_present));
    end
end

function call_module_method(app, method_name)
    if isempty(method_name)
        return
    end
    try
        feval(method_name, app);
    catch method_error
        warning('check_changes:methodFailed', ...
            'The module method "%s" could not be called. Is it public? (%s)', method_name, method_error.message);
    end
end
