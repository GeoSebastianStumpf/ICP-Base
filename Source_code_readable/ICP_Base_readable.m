% GENERATED from ICP_Base.mlapp on 2026-10-28 10:32 by export_mlapp_to_m. This file is for reading purposes, any real changes need to be applied to the .mlapp files and exported again.
classdef ICP_Base_readable < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        BaseMenu                      matlab.ui.container.Menu
        OpenBaseMenu                  matlab.ui.container.Menu
        NewBaseMenu                   matlab.ui.container.Menu
        CompactBaseMenu               matlab.ui.container.Menu
        ProjectMenu                   matlab.ui.container.Menu
        ImportProjectsMenu            matlab.ui.container.Menu
        ExportProjectMenu             matlab.ui.container.Menu
        SessionMenu                   matlab.ui.container.Menu
        ImportSessionsMenu            matlab.ui.container.Menu
        ExportSessionMenu             matlab.ui.container.Menu
        GridLayout                    matlab.ui.container.GridLayout
        RestoreselectedSessionButton  matlab.ui.control.Button
        SaveselectedSessiontoBaseButton  matlab.ui.control.Button
        TableBuilderVisModuleButton   matlab.ui.control.Button
        DuplicateProjectButton        matlab.ui.control.Button
        DuplicateSessionButton        matlab.ui.control.Button
        SelectButton                  matlab.ui.control.Button
        WorkingDirectoryEditField     matlab.ui.control.EditField
        WorkingDirectoryLabel         matlab.ui.control.Label
        ResultsButton                 matlab.ui.control.Button
        QuantificationButton          matlab.ui.control.Button
        DriftButton                   matlab.ui.control.Button
        ClassificationButton          matlab.ui.control.Button
        DeleteProjectButton           matlab.ui.control.Button
        AddProjectButton              matlab.ui.control.Button
        ProjectTable                  matlab.ui.control.Table
        IntervalButton                matlab.ui.control.Button
        DeleteSessionButton           matlab.ui.control.Button
        SessionTable                  matlab.ui.control.Table
        AddSessionButton              matlab.ui.control.Button
        ImportButton                  matlab.ui.control.Button
    end

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     %%%%%%%%%%%%%%%%%%%%%%%%%                        %
%                     %%%      ICP-Base     %%%                        %
%                     %%%%%%%%%%%%%%%%%%%%%%%%%                        %
%                                                                      %
%  Copyright (C) 2026 Sebastian Stumpf                                 %
%                                                                      %
%  This program is free software: you can redistribute it and/or       %
%  modify it under the terms of the GNU General Public License as      %
%  published by the Free Software Foundation, either version 3 of      %
%  the License, or any later version.                                  %
%                                                                      %
%  This program is distributed in the hope that it will be useful,     %
%  but WITHOUT ANY WARRANTY; without even the implied warranty of      %
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the        %
%  GNU General Public License for more details.                        %
%                                                                      %
%  You should have received a copy of the GNU General Public License   %
%  along with this program. If not, see <https://www.gnu.org/licenses/>%
%                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    properties (Access = public)
        base

        installpath
        diarypath
        workingdirectory

        default_plotstyle_path
        default_RM_path
        default_oxides_path
        default_VisModule_path

        basepath string = ""
        LastSelectedProjectRow
    end

    properties (Access = private)

        CleanupInterval = 1800;

        ICP_Base_version ='1.4.0';
        
    end


    methods (Access = private)


        function update_base_GUI(app, project_id)

            update_project_table(app)

            
            update_session_table(app, project_id)


        end

        function update_project_table(app)

            % preallocate the columns
            project_name=cell(1,numel(app.base));
            %project_comment=cell(1,numel(app.base));

            % get the session names and other variables
            for i = 1:numel(app.base)
                % since the project name is now initialzed at
                % AddSessionButtonDown it will always have 'New Project'
                if isfield(app.base(i), 'project_name') && ~isempty(app.base(i).project_name)

                    project_name{i} = app.base(i).project_name;

                else
                    project_name{i}='New Project';
                end

            end

            % generate a table with the variables
            T=table((1:numel(project_name))', project_name');
            T.Properties.VariableNames={'#', 'Project Name'};

            %push this table to the displayed SessionTable and give them
            %the same column names
            app.ProjectTable.Data = T;
            app.ProjectTable.ColumnName = T.Properties.VariableNames;

        end


        function update_progress_buttons(app, project_id, session_id)

            app.DuplicateSessionButton.Visible = "on";
            app.DeleteSessionButton.Visible = "on";

            status = app.base(project_id).project(session_id).session.config.module_status;

            green = [204/255, 1, 204/255];
            orange = [1, 229/255, 204/255];
            red = [1, 204/255, 204/255];

            app.ImportButton.Visible = "on";
            app.IntervalButton.Visible = "on";
            app.ClassificationButton.Visible = "on";
            app.DriftButton.Visible = "on";
            app.QuantificationButton.Visible = "on";
            app.ResultsButton.Visible = "on";

            if isfield(status, 'import') && status.import == true
                app.ImportButton.Enable = "on";
                app.ImportButton.BackgroundColor = green;
            else
                app.ImportButton.Enable = "off";
                app.ImportButton.BackgroundColor = red;
            end

            if isfield(status, 'interval') && status.interval == true
                app.IntervalButton.Enable = "on";
                app.IntervalButton.BackgroundColor = green;
            else
                app.IntervalButton.Enable = "off";
                app.IntervalButton.BackgroundColor = red;
            end

            if isfield(status, 'classification') && status.classification == true
                app.ClassificationButton.Enable = "on";
                app.ClassificationButton.BackgroundColor = green;
            else
                app.ClassificationButton.Enable = "off";
                app.ClassificationButton.BackgroundColor = red;
            end

            if isfield(status, 'drift') && status.drift == true
                app.DriftButton.Enable = "on";
                app.DriftButton.BackgroundColor = green;
            else
                app.DriftButton.Enable = "off";
                app.DriftButton.BackgroundColor = red;
            end

            if isfield(status, 'quantification') && status.quantification == true
                app.QuantificationButton.Enable = "on";
                app.QuantificationButton.BackgroundColor = green;
            else
                app.QuantificationButton.Enable = "off";
                app.QuantificationButton.BackgroundColor = red;
            end

            if isfield(status, 'results') && status.results == true
                app.ResultsButton.Enable = "on";
                app.ResultsButton.BackgroundColor = green;
            else
                app.ResultsButton.Enable = "off";
                app.ResultsButton.BackgroundColor = red;
            end
        end


        %%%%%%%%%%%%%%% Tracking open modules %%%%%%%%%%%%%%%%%%%%        
        function tf = session_has_open_module(app, pid, sid)
            figs = findall(groot, 'Type', 'figure');
            tags = get(figs, 'Tag');
            if ~iscell(tags), tags = {tags}; end
            tf = any(strcmp(tags, sprintf('%d_%d', pid, sid)));
        end

        function tf = project_has_open_module(app, pid)
            figs = findall(groot, 'Type', 'figure');
            tags = get(figs, 'Tag');
            if ~iscell(tags), tags = {tags}; end
            tf = any(startsWith(tags, sprintf('%d_', pid)));
        end

        %%%%%%%%%%%%%%% Cleaning up RAM %%%%%%%%%%%%%%%%%%%%
        function cleanup_unused_sessions(app)

            if ~isvalid(app)
                return
            end

            figs = findall(groot, 'Type', 'figure');
            tags = get(figs, 'Tag');
            if ~iscell(tags), tags = {tags}; end

            displayed_project_changed = false;

            for pid = 1:numel(app.base)
                for sid = 1:numel(app.base(pid).project)
                    try
                        evicted = restore_session_to_skeleton(app, pid, sid, tags);
                        if evicted && isequal(app.LastSelectedProjectRow, pid)
                            displayed_project_changed = true;
                        end
                    catch ME
                        DisplayError(ME, 'Session cleanup sweep failed');
                    end
                end
            end

            if displayed_project_changed
                update_session_table(app, app.LastSelectedProjectRow);
            end

        end

        function evicted = restore_session_to_skeleton(app, pid, sid, open_tags)
            evicted = false;

            if pid > numel(app.base) || sid > numel(app.base(pid).project)
                return
            end

            if ~isfield(app.base(pid).project(sid), 'session')
                return
            end

            sess = app.base(pid).project(sid).session;
            cfg  = sess.config;

            in_h5 = ~isfield(cfg, 'in_h5') || cfg.in_h5;
            if ~isfield(cfg, 'loaded') || ~cfg.loaded || ~cfg.synced || ~in_h5
                return  % unsafe: unsaved edits, or not backed by H5
            end

            % don't evict if it was accessed too recently (still actively being compared/used)
            if isfield(cfg, 'last_accessed') && seconds(datetime('now') - cfg.last_accessed) < app.CleanupInterval
                return
            end

            % don't evict the session currently shown in the SessionTable
            if isequal(app.LastSelectedProjectRow, pid) ...
                    && ~isempty(app.SessionTable.Selection) && app.SessionTable.Selection(1) == sid
                return
            end

            % don't evict if a module window for this session is open
            if any(strcmp(open_tags, sprintf('%d_%d', pid, sid)))
                return
            end

            skeleton.session_name = sess.session_name;
            if isfield(sess, 'meta'), skeleton.meta = sess.meta; end
            skeleton.config.synced = true;
            skeleton.config.loaded = false;
            skeleton.config.in_h5  = true;
            if isfield(cfg, 'module_status')
                skeleton.config.module_status = cfg.module_status;
            end
            if isfield(cfg, 'reductiontype')
                skeleton.config.reductiontype = cfg.reductiontype;
            end

            app.base(pid).project(sid).session = skeleton;
            evicted = true;
        end

        %%%%%%%%%%%%%%% Startup function stuff %%%%%%%%%%%%%%%%%%%%

        function check_for_update_fun(app,state)
            if not(exist("state","var"))
                state=false;
            end
            try
                % Define the owner and repo for your GitHub repository

                owner = 'GeoSebastianStumpf';
                repo = 'ICP-Base';
                url = sprintf('https://api.github.com/repos/%s/%s/releases', owner, repo);

                % Make the GET request to the GitHub API without authentication
                releaseData = webread(url);

                % If you want to extract specific fields, such as the tag name:
                if ~isempty(releaseData)
                    latestReleaseTag = releaseData(1).tag_name; % The first release in the array (latest)
                    %disp(['Latest release tag: ' latestReleaseTag]);

                    if not(strcmp(latestReleaseTag, app.ICP_Base_version))

                        message = sprintf(['A new version of ICP-Base is available: <b>%s</b><br><br>'...
                            'You can download it from the following link: <a href="%s">https://github.com/GeoSebastianStumpf/ICP-Base/releases/latest</a>'], ...
                            latestReleaseTag, 'https://github.com/GeoSebastianStumpf/ICP-Base/releases/latest');

                        uialert(app.UIFigure,message,'New Version Available','Interpreter','html','Icon','info');
                    elseif state==true
                        message = sprintf('You have the latest version of ICP-Base installed: <b>%s</b><br><br>' , ...
                            latestReleaseTag);
                        uialert(app.UIFigure,message,'Latest Version Installed','Interpreter','html','Icon','success');

                    end

                else
                    disp('No releases found.');
                end
            catch ME
                if contains(ME.message, 'timeout') || contains(ME.message, 'Unable to resolve host') || contains(ME.message, 'Could not access server. https://api.github.com/repos/GeoSebastianStumpf/ICP-Base/releases.')
                    disp('New Version Check Failed - Unable to connect to GitHub. Please check your internet connection and try again.');
                elseif contains(ME.message, '404')
                    disp('New Version Check Failed - Repository not found. Please check the repository details.');
                else
                    DisplayError(ME,'Startup New Version Check Failed')
                end

            end
        end

        function startup_time_and_ver_fun(app)

            disp('')

            disp('_______________________________________')

            disp('=======================================')

            disp('              ICP-Base')

            disp('=======================================')

            disp(['Version: ' app.ICP_Base_version])

                disp(['Launch Time: ' datestr(now,'dd-mmm-yyyy HH:MM:SS')])

            disp('---------------------------------------')

        end


        %%%%%%%%%%%%%%% Backwards compatibility %%%%%%%%%%%%%%%

        function migrate_base(app)
            for i = 1:numel(app.base)

                if isfield(app.base(i), 'meta')
                    app.base(i).meta = migrateStruct(app, app.base(i).meta);
                end

                for j = 1:numel(app.base(i).project)

                    if ~isfield(app.base(i).project(j), 'session')
                        continue
                    end
    
                    sess = app.base(i).project(j).session;
                    sess = migrateStruct(app, sess);

                    if isfield(sess, 'plotstyles')
                        sess = rmfield(sess, 'plotstyles');
                    end

                    if isfield(sess, 'spot') && isfield(sess.spot, 'comment')
                        c = sess.spot.comment;
                        if iscell(c)
                            result = strings(size(c));
                            for k = 1:numel(c)
                                v = c{k};
                                if ischar(v) || isstring(v)
                                    result(k) = string(v);
                                end
                            end
                            c = result;
                        elseif ischar(c)
                            c = string(c);
                        end
                        sess.meta.comment = c;
                        sess.spot = rmfield(sess.spot, 'comment');
                    end

                    if isfield(sess, 'oxides') && isfield(sess.oxides, 'conversion_factors')
                        sess.oxides = migrateOxides(app, sess.oxides);
                    end

                    app.base(i).project(j).session = sess;
                end
            end
        end

        % =========================================================
        function s = migrateStruct(app, s)
            if ~isscalar(s)
                for i = 1:numel(s)
                    s(i) = migrateStruct(app, s(i));
                end
                return;
            end

            %These stay cell arrays as they can hold mixed data
            skipFields = {'internal_standard_mass_fraction', ...
                'internal_standard_mass_fraction_inclusion', ...
                'second_internal_standard_mass_fraction_inclusion'};

            fields = fieldnames(s);
            for i = 1:numel(fields)
                fname = fields{i};
                if ismember(fname, skipFields)
                    continue;
                end
                s.(fname) = migrateValue(app, s.(fname));
            end

            % Group 1 — direct cell → double array
            g1 = {'matrix_1_starts','matrix_1_ends','matrix_2_starts','matrix_2_ends', ...
                'matrix_3_starts','matrix_3_ends','background_starts','background_ends', ...
                'inclusion_1_starts','inclusion_1_ends'};
            for f = 1:numel(g1)
                fn = g1{f};
                if isfield(s, fn) && iscell(s.(fn))
                    c = s.(fn);
                    for k = 1:numel(c)
                        if isempty(c{k}), c{k} = NaN; end
                    end
                    try
                        s.(fn) = cell2mat(c);
                    catch
                    end
                end
            end

            % Group 2 — wrapper cell, inner cell → string array
            g2 = {'internal_standard','internal_standard_inclusion','second_internal_standard_inclusion'};
            for f = 1:numel(g2)
                fn = g2{f};
                if isfield(s, fn) && iscell(s.(fn))
                    outer = s.(fn);
                    for k = 1:numel(outer)
                        if iscell(outer{k})
                            inner = outer{k};
                            result = strings(size(inner));
                            for j = 1:numel(inner)
                                if ~isempty(inner{j})
                                    result(j) = string(inner{j});
                                end
                            end
                            outer{k} = result;
                        end
                    end
                    s.(fn) = outer;
                end
            end

            % Group 3 — wrapper cell, inner cell → double array
            g3 = {'internal_standard_oxide_wt','internal_standard_oxide_wt_inclusion', ...
                'Fe_ratio_for_total_oxide','Fe_ratio_for_total_oxide_inclusion'};
            for f = 1:numel(g3)
                fn = g3{f};
                if isfield(s, fn) && iscell(s.(fn))
                    outer = s.(fn);
                    for k = 1:numel(outer)
                        if iscell(outer{k})
                            inner = outer{k};
                            result = NaN(size(inner));
                            for j = 1:numel(inner)
                                if ~isempty(inner{j})
                                    result(j) = double(inner{j});
                                end
                            end
                            outer{k} = result;
                        end
                    end
                    s.(fn) = outer;
                end
            end
        end

        % =========================================================
        function val = migrateValue(app, val)
            if isstruct(val)
                val = migrateStruct(app, val);
            elseif iscell(val)
                val = migrateCell(app, val);
            end
            % numeric, string, char, table, containers.Map → return as-is
        end

        % =========================================================
        function c = migrateCell(app, c)
            nonEmpty = {};
            for i = 1:numel(c)
                if ~isempty(c{i})
                    nonEmpty{end+1} = c{i};
                end
            end

            if isempty(nonEmpty)
                return;
            end

            firstVal = nonEmpty{1};

            % Mixed numeric + string → mass_fraction type, leave as-is
            hasNum = any(cellfun(@(x) isnumeric(x) && ~isempty(x), c(:)));
            hasStr = any(cellfun(@(x) (ischar(x) || isstring(x)) && ~isempty(x), c(:)));
            if hasNum && hasStr
                return;
            end

            if ischar(firstVal)
                result = strings(size(c));
                for i = 1:numel(c)
                    if isempty(c{i})
                        result(i) = "";
                    else
                        result(i) = string(c{i});
                    end
                end
                c = result;
            elseif isnumeric(firstVal) && isscalar(firstVal)
                cFilled = c;
                for ii = 1:numel(cFilled)
                    if isempty(cFilled{ii})
                        cFilled{ii} = NaN;
                    end
                end
                try
                    c = cell2mat(cFilled);
                catch
                end
            elseif iscell(firstVal)
                % Cell of cells → recurse into each
                for i = 1:numel(c)
                    if ~isempty(c{i})
                        c{i} = migrateCell(app, c{i});
                    end
                end
            end
            % tables, string arrays, numeric arrays → leave as-is
        end

        % =========================================================
        function oxides = migrateOxides(app, oxides)
            en  = oxides.element_names;   % already string array after migrateStruct
            map = oxides.conversion_factors;

            cf = zeros(numel(en), 1);
            for k = 1:numel(en)
                key = char(en(k));
                if isKey(map, key)
                    cf(k) = map(key);
                end
            end
            oxides.conversion_factor_values = cf;
            oxides = rmfield(oxides, 'conversion_factors');

            if ~isfield(oxides, 'considered_major')
                majors = ["Si", "Al", "Fe", "Mg", "Na", "K", "Ca", "Mn", "Ti"];
                considered = strings(numel(en), 1);
                for k = 1:numel(en)
                    if ismember(en(k), majors)
                        considered(k) = "Yes";
                    else
                        considered(k) = "No";
                    end
                end
                oxides.considered_major = considered;
            end
        end


        %%%%%%%%%%%%%%% full .mat base to h5 export %%%%%%%%%%%%%%%

        function base2h5(app, base, filepath)

            [~, name, ext] = fileparts(filepath);
            if isempty(name) || isempty(ext)
                uialert(app.UIFigure, 'Invalid file path — select a file, not a folder.', 'Error');
                return;
            end

            if exist(filepath, 'file') == 2
                delete(filepath);
            end

            for i = 1:numel(base)
                projectpath = ['/' sprintf('%d_project', i)];

                writeValue(app, base(i).project_name, filepath, [projectpath '/project_name']);
                if isfield(base(i), 'meta') && ~isempty(base(i).meta)
                    writeStructToH5(app, base(i).meta, filepath, [projectpath '/meta']);
                end

                for j = 1:numel(base(i).project)

                    if ~isfield(base(i).project(j), 'session')
                        continue
                    end
                    sesh = base(i).project(j).session;

                    if isfield(sesh, 'config') && isfield(sesh.config, 'last_accessed')
                        sesh.config = rmfield(sesh.config, 'last_accessed');
                    end

                    if isfield(sesh, 'spot') && isfield(sesh.spot, 'eliminated_spikes') && iscell(sesh.spot.eliminated_spikes)
                        sesh.spot.eliminated_spikes = flatten_eliminated_spikes(app, sesh.spot.eliminated_spikes);
                    end
                    if isfield(sesh, 'spot') && isfield(sesh.spot, 'signal_data') && iscell(sesh.spot.signal_data)
                        sesh.spot.signal_data = flatten_signal_data(app, sesh.spot.signal_data);
                    end
                    if isfield(sesh, 'referencematerials') && isfield(sesh.referencematerials, 'data') && isfield(sesh.referencematerials, 'uncertainty')
                        sesh.referencematerials = flatten_referencematerials(app, sesh.referencematerials);
                    end
                    spath = [projectpath '/' sprintf('%d_session', j)];
                    writeStructToH5(app, sesh, filepath, spath);
                end
            end

        end

        % =========================================================
        function writeStructToH5(app, s, filepath, grouppath)
            if ~isscalar(s)
                for i = 1:numel(s)
                    ipath = sprintf('%s/item_%d', grouppath, i);
                    writeStructToH5(app, s(i), filepath, ipath);
                end
                csizepath = [grouppath '/__struct_size__'];
                h5create(filepath, csizepath, [1 2]);
                h5write(filepath,  csizepath, double(size(s)));
                if ~isempty(grouppath)
                    h5writeatt(filepath, grouppath, 'original_type', 'struct_array');
                end
                return;
            end
            fields = fieldnames(s);
            for i = 1:numel(fields)
                fname = fields{i};
                val   = s.(fname);
                fpath = [grouppath '/' fname];
                writeValue(app, val, filepath, fpath);
            end
        end

        % =========================================================
        function writeValue(app, val, filepath, path)
            if isstruct(val)
                writeStructToH5(app, val, filepath, path);
            elseif istable(val)
                writeTable(app, val, filepath, path);
            elseif iscell(val)
                writeCellArray(app, val, filepath, path);
            elseif isnumeric(val) || islogical(val)
                writeNumeric(app, val, filepath, path);
            elseif isstring(val) || ischar(val)
                writeString(app, val, filepath, path);
            elseif isdatetime(val)
                writeString(app, string(val, 'yyyy-MM-dd HH:mm:ss.SSS'), filepath, path);
            elseif isduration(val)
                writeNumeric(app, seconds(val), filepath, path);
            elseif iscategorical(val)
                writeString(app, string(val), filepath, path);
            else
                warning('base2h5: skipping unsupported type at %s (%s)', path, class(val));
            end
        end

        % =========================================================
        function writeNumeric(~, val, filepath, path)
            if isempty(val)
                h5create(filepath, path, [1 1]);
                h5write(filepath,  path, 0);
                h5writeatt(filepath, path, 'is_empty', int32(1));
            else
                data = double(val);
                h5create(filepath, path, size(data));
                h5write(filepath,  path, data);
            end
            h5writeatt(filepath, path, 'original_type', 'double');
        end

        % =========================================================

        function writeString(~, val, filepath, path)
            if ischar(val)
                if isempty(val)
                    h5create(filepath, path, [1 1], 'Datatype', 'string');
                    evalc('h5write(filepath, path, {''''})');
                    h5writeatt(filepath, path, 'is_empty', int32(1));
                else
                    h5create(filepath, path, [1 1], 'Datatype', 'string');
                    evalc('h5write(filepath, path, {val})');
                end
            else
                if isempty(val)
                    h5create(filepath, path, [1 1], 'Datatype', 'string');
                    evalc('h5write(filepath, path, {''''})');
                    h5writeatt(filepath, path, 'is_empty', int32(1));
                else
                    cs = cellstr(val);
                    h5create(filepath, path, size(cs), 'Datatype', 'string');
                    evalc('h5write(filepath, path, cs)');
                end
            end
            h5writeatt(filepath, path, 'original_type', 'string');
        end

        % =========================================================
        function writeTable(app, t, filepath, path)
            colnames = t.Properties.VariableNames;

            if isempty(colnames)
                h5create(filepath, [path '/colnames'], [1 1], 'Datatype', 'string');
                evalc('h5write(filepath, [path ''/colnames''], {''''})');
            else
                h5create(filepath, [path '/colnames'], [1 numel(colnames)], 'Datatype', 'string');
                evalc('h5write(filepath, [path ''/colnames''], colnames)');
            end

            if isempty(t)
                h5create(filepath, [path '/data'], [1 1]);
                h5write(filepath,  [path '/data'], 0);
                h5writeatt(filepath, path, 'is_empty',      int32(1));
                h5writeatt(filepath, path, 'original_type', 'table');
                h5writeatt(filepath, path, 'table_size',    double([0 width(t)]));
                return;
            end

            allNum = true;
            for j = 1:width(t)
                col = t{:, j};
                if ~isnumeric(col) && ~islogical(col)
                    allNum = false;
                    break;
                end
            end

            if allNum
                data = double(table2array(t));
                h5create(filepath, [path '/data'], size(data));
                h5write(filepath,  [path '/data'], data);
            else
                for j = 1:width(t)
                    cn  = colnames{j};
                    col = t.(cn);
                    writeValue(app, col, filepath, [path '/col_' cn]);
                end
            end

            h5writeatt(filepath, path, 'original_type', 'table');
            h5writeatt(filepath, path, 'table_size', double([height(t) width(t)]));
        end

        % =========================================================
        function writeCellArray(app, c, filepath, path)
            firstVal = [];
            for i = 1:numel(c)
                if ~isempty(c{i})
                    firstVal = c{i};
                    break;
                end
            end

            if isempty(firstVal)
                h5create(filepath, [path '/__cell_empty__'], [1 1]);
                h5write(filepath,  [path '/__cell_empty__'], 0);
                h5writeatt(filepath, path, 'original_type', 'cell_empty');
                h5writeatt(filepath, path, 'cell_size', double(size(c)));
                return;
            end

            if istable(firstVal)
                cellType = 'cell_of_tables';
            elseif iscell(firstVal)
                cellType = 'cell_of_cells';
            else
                cellType = 'cell_of_arrays';
            end

            for i = 1:numel(c)
                ipath = sprintf('%s/item_%d', path, i);
                if isempty(c{i})
                    h5create(filepath, [ipath '/__empty__'], [1 1]);
                    h5write(filepath,  [ipath '/__empty__'], 0);
                    h5writeatt(filepath, ipath, 'is_empty', int32(1));
                else
                    switch cellType
                        case 'cell_of_tables'
                            writeTable(app, c{i}, filepath, ipath);
                        case 'cell_of_cells'
                            writeMixedCell(app, c{i}, filepath, ipath);
                        case 'cell_of_arrays'
                            writeValue(app, c{i}, filepath, ipath);
                    end
                end
            end

            csizepath = [path '/__cell_size__'];
            h5create(filepath, csizepath, [1 2]);
            h5write(filepath,  csizepath, double(size(c)));
            h5writeatt(filepath, path, 'original_type', cellType);
            h5writeatt(filepath, path, 'cell_size', double(size(c)));
        end

        % =========================================================
        function writeMixedCell(~, innerCell, filepath, path)
            strVals  = cell(size(innerCell));
            isDouble = false(size(innerCell));

            for j = 1:numel(innerCell)
                v = innerCell{j};
                if isempty(v)
                    strVals{j}  = '';
                    isDouble(j) = false;
                elseif isnumeric(v)
                    isDouble(j) = true;
                    strVals{j}  = num2str(v, '%.15g');
                else
                    strVals{j} = char(v);
                end
            end

            h5create(filepath, [path '/values'],    size(strVals), 'Datatype', 'string');
            evalc('h5write(filepath, [path ''/values''], strVals)');
            h5create(filepath, [path '/is_double'], size(isDouble));
            h5write(filepath,  [path '/is_double'], double(isDouble));
            h5writeatt(filepath, path, 'original_type', 'mixed_cell');
            h5writeatt(filepath, path, 'cell_size', double(size(innerCell)));
        end

        % =========================================================
        function flat = flatten_eliminated_spikes(~, c)
            flat = table('Size', [0, 6], ...
                'VariableTypes', repmat({'double'}, 1, 6), ...
                'VariableNames', {'SpotIndex','RowIndex','ColumnIndex','OriginalValue','ReplacementValue','SweepIndex'});
            for i = 1:numel(c)
                if ~isempty(c{i})
                    t = c{i};
                    t.SpotIndex = repmat(double(i), height(t), 1);
                    if ~ismember('ReplacementValue', t.Properties.VariableNames)
                        t.ReplacementValue = nan(height(t), 1);
                    end
                    if ~ismember('SweepIndex', t.Properties.VariableNames)
                        t.SweepIndex = nan(height(t), 1);
                    end
                    flat = [flat; t(:, {'SpotIndex','RowIndex','ColumnIndex','OriginalValue','ReplacementValue','SweepIndex'})];
                end
            end
        end

        % =========================================================
        function converted = flatten_signal_data(~, c)
            colnames = {};
            for i = 1:numel(c)
                if ~isempty(c{i})
                    colnames = c{i}.Properties.VariableNames;
                    break;
                end
            end
            parts = cell(numel(c), 1);
            ncols = numel(colnames);
            for i = 1:numel(c)
                if isempty(c{i})
                    parts{i} = zeros(0, ncols + 1);
                else
                    parts{i} = [repmat(double(i), height(c{i}), 1), double(table2array(c{i}))];
                end
            end
            converted.flat_data = vertcat(parts{:});
            converted.colnames  = string(colnames);
            converted.nspots    = double(numel(c));
            converted.is_flat_signal_data = int32(1);
        end

        % =========================================================
        function rm_out = flatten_referencematerials(~, rm)
            if ~isfield(rm, 'uncertainty')
                rm.uncertainty = {};
            end

            n = numel(rm.data);

            if numel(rm.uncertainty) < n
                rm.uncertainty(end+1:n) = {[]};
            end

            combined = cell(n, 1);
            for i = 1:n
                d = rm.data{i};
                u = rm.uncertainty{i};
                if isempty(u) || ~istable(u)
                    u = array2table(NaN(1, width(d)), 'VariableNames', d.Properties.VariableNames);
                end
                combined{i} = [d; u];
            end
            rm_out = rm;
            rm_out.data = combined;
            rm_out = rmfield(rm_out, 'uncertainty');
            rm_out.is_flat_referencematerials = int32(1);
        end

        %%%%%%%%%%%%%%% full base h5 import %%%%%%%%%%%%%%%%%%%%

        function ok = connect_h5_safely(app, filepath)
            ok = true;
            try
                connect_h5(app, filepath);
            catch ME
                ok = false;
                DisplayError(ME, 'Opening base failed');

                % leave a clean, empty app instead of a half-connected one
                app.base     = struct([]);
                app.basepath = "";
                app.SessionTable.Data = {};
                app.LastSelectedProjectRow = [];
                app.SaveselectedSessiontoBaseButton.Enable = false;
                app.RestoreselectedSessionButton.Enable    = false;
                app.ImportButton.Visible = "off";
                app.IntervalButton.Visible = "off";
                app.ClassificationButton.Visible = "off";
                app.DriftButton.Visible = "off";
                app.QuantificationButton.Visible = "off";
                app.ResultsButton.Visible = "off";
                app.DuplicateSessionButton.Visible = "off";
                app.DeleteSessionButton.Visible = "off";

                uialert(app.UIFigure, ...
                    ['The base could not be opened. Nothing in the file was changed. Details: ' ME.message], ...
                    'Opening Base Failed', 'Icon', 'error');
            end
        end

        function connect_h5(app, filepath)
            app.basepath = filepath;
    
            renumber_h5_fully(app);

            topNames = h5_child_names(app, filepath, '/');
            pNames = topNames(~cellfun(@isempty, regexp(topNames, '^\d+_project$', 'once')));
            pNums  = cellfun(@(s) sscanf(s, '%d'), pNames);
            [~, ix] = sort(pNums);
            pNames = pNames(ix);

            if isempty(pNames), return; end

            for i = 1:numel(pNames)
                ppath = ['/' pNames{i}];

                app.base(i).project_name = h5readStr(app, filepath, [ppath '/project_name']);

                sessNames = h5_child_names(app, filepath, ppath);
                sNames = sessNames(~cellfun(@isempty, regexp(sessNames, '^\d+_session$', 'once')));
                sNums  = cellfun(@(s) sscanf(s, '%d'), sNames);
                [~, sx] = sort(sNums);
                sNames = sNames(sx);

                for j = 1:numel(sNames)
                    spath = [ppath '/' sNames{j}];

                    app.base(i).project(j).session.session_name = h5readStr(app, filepath, [spath '/session_name']);

                    for fn = ["session_comment", "date", "analyst", "processed_by"]
                        try
                            raw = h5read(filepath, [spath '/meta/' char(fn)]);
                            if iscell(raw), raw = raw{1}; end
                            app.base(i).project(j).session.meta.(char(fn)) = string(raw);
                        catch
                        end
                    end

                    msPath = [spath '/config/module_status'];
                    try
                        msInfo = h5info(filepath, msPath);
                        for k = 1:numel(msInfo.Datasets)
                            dsname = msInfo.Datasets(k).Name;
                            app.base(i).project(j).session.config.module_status.(dsname) = ...
                                h5read(filepath, [msPath '/' dsname]);
                        end
                    catch
                    end

                    try
                        raw = h5read(filepath, [spath '/config/reductiontype']);
                        if iscell(raw), raw = raw{1}; end
                        app.base(i).project(j).session.config.reductiontype = string(raw);
                    catch
                    end

                    app.base(i).project(j).session.config.synced = true;
                    app.base(i).project(j).session.config.loaded = false;
                end
            end
        end


        % =========================================================
        % Read a scalar string from H5, return "" on failure/empty
        function val = h5readStr(~, filepath, path)
            try
                raw = h5read(filepath, path);
                if iscell(raw), raw = raw{1}; end
                val = string(raw);
            catch
                val = "";
            end
        end

        % =========================================================
        % Sort H5 group struct array by numeric prefix (1_Name, 2_Name, ...)
        function sorted = h5sortGroups(~, groups)
            if isempty(groups)
                sorted = groups;
                return;
            end
            idx = zeros(numel(groups), 1);
            for k = 1:numel(groups)
                parts = strsplit(groups(k).Name, '/');
                tok = regexp(parts{end}, '^(\d+)', 'tokens', 'once');
                if ~isempty(tok)
                    idx(k) = str2double(tok{1});
                end
            end
            [~, order] = sort(idx);
            sorted = groups(order);
        end

        % =========================================================
        % Filter subgroups to session groups only (numeric-prefixed)
        function sGroups = h5sessionGroups(app, groups)
            keep = false(numel(groups), 1);
            for k = 1:numel(groups)
                parts = strsplit(groups(k).Name, '/');
                keep(k) = ~isempty(regexp(parts{end}, '^\d+_', 'once'));
            end
            sGroups = h5sortGroups(app, groups(keep));
        end

        % =========================================================
        function names = h5_child_names(~, filepath, grouppath)
            fid = H5F.open(filepath, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');
            gid = [];
            try
                gid = H5G.open(fid, grouppath);
                n   = H5G.get_info(gid).nlinks;
                names = cell(1, n);
                for k = 0:n-1
                    names{k+1} = H5L.get_name_by_idx(gid, '.', 'H5_INDEX_NAME', 'H5_ITER_INC', k, 'H5P_DEFAULT');
                end
                H5G.close(gid);
                H5F.close(fid);
            catch ME
                % close what was opened, then pass the error on as before
                if ~isempty(gid), H5G.close(gid); end
                H5F.close(fid);
                rethrow(ME)
            end
        end


        %%%%%%%%%%%%%%% h5 GUI shit %%%%%%%%%%%%%%%%%%%%

        % =========================================================
        % Write or overwrite a scalar string dataset in H5
        % Like project and session names and session metadata
        function h5writeStrVal(~, filepath, path, val)
            try
                h5create(filepath, path, [1 1], 'Datatype', 'string');
            catch
            end
            evalc('h5write(filepath, path, {char(val)})');
            h5writeatt(filepath, path, 'original_type', 'string');
            h5writeatt(filepath, path, 'is_empty', int32(val == ""));
        end



        %%%%%%%%%% Renumber h5 stuff %%%%%%%%%%%%%%%%%%

        function renumber_h5_fully(app)
            if isempty(app.basepath) || ~isfile(app.basepath), return; end
            try
                topNames = h5_child_names(app, app.basepath, '/');
                pNames = topNames(~cellfun(@isempty, regexp(topNames, '^\d+_project$', 'once')));
                if isempty(pNames), return; end
                pNums = cellfun(@(s) sscanf(s, '%d'), pNames);
                [~, ix] = sort(pNums);
                pNames = pNames(ix);

                % Collect session names using each project's actual current name
                sNamesByProject = cell(1, numel(pNames));
                for ii = 1:numel(pNames)
                    ppath = ['/' pNames{ii}];
                    sAll = h5_child_names(app, app.basepath, ppath);
                    sFiltered = sAll(~cellfun(@isempty, regexp(sAll, '^\d+_session$', 'once')));
                    sNums = cellfun(@(s) sscanf(s, '%d'), sFiltered);
                    [~, sx] = sort(sNums);
                    sNamesByProject{ii} = sFiltered(sx);
                end

                fid = H5F.open(app.basepath, 'H5F_ACC_RDWR', 'H5P_DEFAULT');
                try
                    for ii = 1:numel(pNames)
                        expected = sprintf('/%d_project', ii);
                        actual   = ['/' pNames{ii}];
                        if ~strcmp(actual, expected)
                            H5L.move(fid, actual, fid, expected, 'H5P_DEFAULT', 'H5P_DEFAULT');
                        end
                    end
                    for ii = 1:numel(pNames)
                        sNames = sNamesByProject{ii};
                        for jj = 1:numel(sNames)
                            expected = sprintf('/%d_project/%d_session', ii, jj);
                            actual   = sprintf('/%d_project/%s', ii, sNames{jj});
                            if ~strcmp(actual, expected)
                                H5L.move(fid, actual, fid, expected, 'H5P_DEFAULT', 'H5P_DEFAULT');
                            end
                        end
                    end
                catch ME
                    DisplayError(ME, 'Renumbering H5 base on open failed');
                end
                H5F.close(fid);
            catch ME
                DisplayError(ME, 'Renumbering H5 base on open failed');
            end
        end

        function tf = h5_link_exists(~, fid, path)
            try
                tf = logical(H5L.exists(fid, path, 'H5P_DEFAULT'));
            catch
                tf = false;
            end
        end

        function [ok, message] = remove_h5_entry_and_shift(app, paths, expected_present, remove_idx)
            % Removes paths{remove_idx} from the h5 and moves every later entry one position down.
            % Nothing irreversible happens first: the removed entry is renamed to a *_deleted_<time>
            % group (invisible to the app), the later entries are moved down, and only then is the
            % renamed group deleted. If any step fails, every move is rolled back and ok = false,
            % so the caller must leave memory untouched.
            %   paths             cell array, paths{k} = location of entry k in the h5
            %   expected_present  logical vector: entry k is expected to exist on disk ([] = accept what is there)
            %   remove_idx        entry to remove
            ok = true;
            message = '';
            n = numel(paths);

            try
                fid = H5F.open(char(app.basepath), 'H5F_ACC_RDWR', 'H5P_DEFAULT');
            catch ME
                ok = false;
                message = ['The base file could not be opened for writing: ' ME.message];
                return
            end
            closer = onCleanup(@() H5F.close(fid)); %#ok<NASGU>

            exists_now = false(1, n);
            for k = 1:n
                exists_now(k) = h5_link_exists(app, fid, paths{k});
            end
            if isempty(expected_present)
                expected_present = exists_now;
            end

            % the entries that will be moved must be exactly where the app expects them
            for k = remove_idx+1:n
                if exists_now(k) ~= expected_present(k)
                    ok = false;
                    message = sprintf(['The base file does not match what ICP-Base expects at %s. ' ...
                        'Nothing was deleted. Save your work, then close and reopen the base ' ...
                        '(this repairs the numbering) and try again.'], paths{k});
                    return
                end
            end

            trash = '';
            moves = cell(0, 2);   % [from, to] of every move that was done
            try
                if exists_now(remove_idx)
                    trash = sprintf('%s_deleted_%s', paths{remove_idx}, char(datetime('now', 'Format', 'yyyyMMddHHmmssSSS')));
                    H5L.move(fid, paths{remove_idx}, fid, trash, 'H5P_DEFAULT', 'H5P_DEFAULT');
                    moves(end+1, :) = {paths{remove_idx}, trash};
                end
                for k = remove_idx+1:n
                    if expected_present(k)
                        H5L.move(fid, paths{k}, fid, paths{k-1}, 'H5P_DEFAULT', 'H5P_DEFAULT');
                        moves(end+1, :) = {paths{k}, paths{k-1}};
                    end
                end
            catch ME
                rollback_failed = false;
                for m = size(moves, 1):-1:1
                    try
                        H5L.move(fid, moves{m, 2}, fid, moves{m, 1}, 'H5P_DEFAULT', 'H5P_DEFAULT');
                    catch
                        rollback_failed = true;
                    end
                end
                ok = false;
                if rollback_failed
                    message = ['Deleting failed and the numbering in the base file could not be restored (' ME.message '). ' ...
                        'Make a copy of the .h5 file now, then close ICP-Base and reopen the base.'];
                else
                    message = ['Deleting failed, nothing was changed (' ME.message ').'];
                end
                return
            end

            if ~isempty(trash)
                try
                    H5L.delete(fid, trash, 'H5P_DEFAULT');
                catch
                    message = sprintf(['The entry was removed, but the leftover group "%s" could not be deleted. ' ...
                        'It is harmless and is removed by Compact Base.'], trash);
                end
            end
        end







    end



    methods (Access = public)


        function [project_id, session_id] = save_to_base(app, project_id, session, session_id, project_name, settings)
           stored = false;
            try
                if isequal(project_id, 0) || isempty(project_id)
                    project_id = numel(app.base) + 1;
                end

                if project_id > numel(app.base)
                    app.base(project_id).project = struct();
                end

                is_new = false;
                if numel(app.base) == 0
                    session_id = 1;
                    is_new = true;
                elseif isempty(fieldnames(app.base(project_id).project)) || ~isfield(app.base(project_id).project, 'session') || isempty(app.base(project_id).project)
                    session_id = 1;
                    is_new = true;
                elseif isequal(session_id, 0) || isempty(session_id)
                    session_id = numel(app.base(project_id).project) + 1;
                    is_new = true;
                end
            
                % reset the last accessed to to have a long editing session
                % be removed by accident.
                session.config.last_accessed = datetime('now');

                app.base(project_id).project(session_id).session = session;

                if is_new
                    app.base(project_id).project(session_id).session.config.in_h5  = false;
                    app.base(project_id).project(session_id).session.config.loaded = true;
                    app.base(project_id).project(session_id).session.config.synced = false;
                end

                app.base(project_id).project_name = project_name;

                if ~isfield(app.base(project_id).project(session_id).session, 'session_name') || isempty(app.base(project_id).project(session_id).session.session_name)
                    app.base(project_id).project(session_id).session.session_name = 'New Session';
                end

                stored = true;   % the session is in the base, what follows is only GUI

                if isfield(settings, 'ICP_Base_GUI_update_state') && settings.ICP_Base_GUI_update_state == true
                    if ~isempty(app.LastSelectedProjectRow) && app.LastSelectedProjectRow == project_id
                        update_session_table(app, project_id)
                        if ~isempty(app.SessionTable.Selection) && app.SessionTable.Selection(1) == session_id
                            refresh_session_buttons(app)
                        end
                    end
                end
            catch ME
                DisplayError(ME, 'Error - save_to_base')
                % the session did not reach the base: stop the caller, so the module stays open and keeps its edits
                if ~stored
                    rethrow(ME)
                end
            end
        end

        function refresh_session_buttons(app)
            % Sets the buttons of the selected session. While a module window is open for that
            % session, everything that could work on it in parallel is disabled.

            if isempty(app.LastSelectedProjectRow) || isempty(app.SessionTable.Selection) ...
                    || isequal(app.SessionTable.Selection(1), 0)
                return
            end

            pid = app.LastSelectedProjectRow;
            sid = app.SessionTable.Selection(1);

            if pid > numel(app.base) || sid > numel(app.base(pid).project)
                return
            end

            update_progress_buttons(app, pid, sid)

            cfg   = app.base(pid).project(sid).session.config;
            in_h5 = ~isfield(cfg, 'in_h5') || cfg.in_h5;
            app.SaveselectedSessiontoBaseButton.Enable = ~cfg.synced;
            app.RestoreselectedSessionButton.Enable    = ~cfg.synced && in_h5;

            if session_has_open_module(app, pid, sid)
                app.ImportButton.Enable                    = "off";
                app.IntervalButton.Enable                  = "off";
                app.ClassificationButton.Enable            = "off";
                app.DriftButton.Enable                     = "off";
                app.QuantificationButton.Enable            = "off";
                app.ResultsButton.Enable                   = "off";
                app.SaveselectedSessiontoBaseButton.Enable = "off";
                app.RestoreselectedSessionButton.Enable    = "off";
                app.DuplicateSessionButton.Enable          = "off";
                app.DeleteSessionButton.Enable             = "off";
            else
                app.DuplicateSessionButton.Enable          = "on";
                app.DeleteSessionButton.Enable             = "on";
            end
        end



        %%%%%%%%%%%% Get single session from h5 %%%%%%%

        function h52session(app, pid, sid)
            [~,~,ext] = fileparts(app.basepath);
            if ~strcmp(ext, '.h5') || ~isfile(app.basepath), return; end
            spath = sprintf('/%d_project/%d_session', pid, sid);
            skeleton = app.base(pid).project(sid).session;
            try
                sess = readH5Group(app, app.basepath, spath);

                if isempty(fieldnames(sess))
                    error('ICP_Base:sessionLoadFailed', ...
                        ['No session data found at %s. The session list is out of sync with the H5 file; ' ...
                        'the session was not loaded.'], spath);
                end

                if isfield(sess, 'spot') && isfield(sess.spot, 'eliminated_spikes') && istable(sess.spot.eliminated_spikes)
                    nSpots = numel(sess.spot.name);
                    sess.spot.eliminated_spikes = unflatten_eliminated_spikes(app, sess.spot.eliminated_spikes, nSpots);
                end
                if isfield(sess, 'spot') && isfield(sess.spot, 'signal_data') && isstruct(sess.spot.signal_data) && isfield(sess.spot.signal_data, 'is_flat_signal_data')
                    sess.spot.signal_data = unflatten_signal_data(app, sess.spot.signal_data);
                end
                if isfield(sess, 'referencematerials') && isfield(sess.referencematerials, 'is_flat_referencematerials')
                    sess.referencematerials = unflatten_referencematerials(app, sess.referencematerials);
                end

                if ~isfield(sess, 'meta'), sess.meta = struct(); end

                sess.config.synced = true;
                sess.config.loaded = true;
                sess.config.last_accessed = datetime('now');

                app.base(pid).project(sid).session = sess;
            catch ME
                app.base(pid).project(sid).session = skeleton;
                DisplayError(ME, 'Loading session from H5 failed');
            end
        end

        function val = readH5Group(app, filepath, grouppath)
            try
                info = h5info(filepath, grouppath);
            catch
                val = struct();
                return;
            end

            otype = h5getAttr(app, info.Attributes, 'original_type');

            switch otype
                case 'table'
                    val = readH5Table(app, filepath, grouppath, info);
                case 'cell_of_tables'
                    val = readH5CellOfTables(app, filepath, info);
                case 'mixed_cell'
                    val = readH5MixedCell(app, filepath, grouppath);
                case 'cell_of_arrays'
                    val = readH5CellOfArrays(app, filepath, grouppath, info);
                case 'cell_of_cells'
                    val = readH5CellOfCells(app, filepath, info);
                case 'cell_empty'
                    cellSz = h5getAttr(app, info.Attributes, 'cell_size');
                    cellSz = cellSz(:)';
                    if isnumeric(cellSz) && ~isempty(cellSz)
                        val = cell(cellSz);
                    else
                        val = {};
                    end
                case 'struct_array'
                    items = {};
                    for k = 1:numel(info.Groups)
                        parts = strsplit(info.Groups(k).Name, '/');
                        tok   = regexp(parts{end}, '^item_(\d+)$', 'tokens', 'once');
                        if isempty(tok), continue; end
                        items{str2double(tok{1})} = readH5Group(app, filepath, info.Groups(k).Name); %#ok<AGROW>
                    end
                    if isempty(items)
                        val = struct([]);
                    else
                        try
                            val = [items{:}];
                            sz  = h5read(filepath, [grouppath '/__struct_size__']);
                            val = reshape(val, sz(:)');
                        catch
                            val = items; % items with different fields: keep them as a cell
                        end
                    end
                otherwise
                    val = struct();
                    for k = 1:numel(info.Datasets)
                        dsname = info.Datasets(k).Name;
                        if startsWith(dsname, '__'), continue; end
                        val.(dsname) = readH5Dataset(app, filepath, ...
                            [grouppath '/' dsname], info.Datasets(k).Attributes);
                    end
                    for k = 1:numel(info.Groups)
                        parts = strsplit(info.Groups(k).Name, '/');
                        gname = parts{end};
                        if startsWith(gname, '__'), continue; end
                        val.(gname) = readH5Group(app, filepath, info.Groups(k).Name);
                    end
            end
        end

        function val = readH5Dataset(app, filepath, dspath, attrs)
            otype = h5getAttr(app, attrs, 'original_type');

            switch otype
                case {'string', 'string_array'}
                    raw = h5read(filepath, dspath);
                    val = string(raw);
                otherwise
                    if isequal(h5getAttr(app, attrs, 'is_empty'), int32(1))
                        val = [];
                    else
                        val = h5read(filepath, dspath);
                    end
            end
        end

        function val = readH5Table(app, filepath, grouppath, info)
            if isequal(h5getAttr(app, info.Attributes, 'is_empty'), int32(1))
                try
                    cnRaw    = h5read(filepath, [grouppath '/colnames']);
                    colnames = cellstr(string(cnRaw));
                    val      = array2table(zeros(0, numel(colnames)), 'VariableNames', colnames);
                catch
                    val = table();
                end
                return;
            end

            dsNames = arrayfun(@(d) d.Name, info.Datasets, 'UniformOutput', false);

            try
                cnRaw    = h5read(filepath, [grouppath '/colnames']);
                colnames = cellstr(string(cnRaw));
            catch
                val = table();
                return;
            end

            if any(strcmp(dsNames, 'data'))
                data = h5read(filepath, [grouppath '/data']);
                val  = array2table(data, 'VariableNames', colnames);
            else
                % columns are datasets (numeric, string) or groups (cell columns)
                grpNames  = arrayfun(@(g) g.Name, info.Groups, 'UniformOutput', false);
                tableSize = h5getAttr(app, info.Attributes, 'table_size');
                colData   = {};
                colKept   = {};
                for j = 1:numel(colnames)
                    colPath = [grouppath '/col_' colnames{j}];
                    dsIdx   = find(strcmp(dsNames, ['col_' colnames{j}]), 1);
                    if ~isempty(dsIdx)
                        colVal = readH5Dataset(app, filepath, colPath, info.Datasets(dsIdx).Attributes);
                    elseif any(strcmp(grpNames, colPath))
                        colVal = readH5Group(app, filepath, colPath);
                    else
                        warning('h52base: column %s in %s is missing and is skipped', colnames{j}, grouppath);
                        continue
                    end
                    % a column with the wrong length would make table() fail and lose the whole session
                    if isnumeric(tableSize) && ~isempty(tableSize) && size(colVal, 1) ~= tableSize(1)
                        warning('h52base: column %s in %s has the wrong length and is skipped', colnames{j}, grouppath);
                        continue
                    end
                    colData{end+1} = colVal; %#ok<AGROW>
                    colKept{end+1} = colnames{j}; %#ok<AGROW>
                end
                val = table(colData{:}, 'VariableNames', colKept);
            end
        end

        function val = readH5CellOfTables(app, filepath, info)
            cellSz = h5getAttr(app, info.Attributes, 'cell_size');
            cellSz = cellSz(:)';
            if ~isnumeric(cellSz) || isempty(cellSz)
                cellSz = [1 numel(info.Groups)];
            end
            val = cell(cellSz);
            for k = 1:numel(info.Groups)
                parts = strsplit(info.Groups(k).Name, '/');
                tok   = regexp(parts{end}, '^item_(\d+)$', 'tokens', 'once');
                if isempty(tok), continue; end
                idx = str2double(tok{1});
                if idx < 1 || idx > numel(val), continue; end
                try
                    iinfo = h5info(filepath, info.Groups(k).Name);
                    if isequal(h5getAttr(app, iinfo.Attributes, 'is_empty'), int32(1))
                        val{idx} = [];
                    else
                        val{idx} = readH5Table(app, filepath, info.Groups(k).Name, iinfo);
                    end
                catch
                    val{idx} = [];
                end
            end
        end

        function val = readH5MixedCell(~, filepath, grouppath)
            try
                strVals  = string(h5read(filepath, [grouppath '/values']));
                isDouble = logical(h5read(filepath, [grouppath '/is_double']));
                val      = cell(size(strVals));
                for k = 1:numel(strVals)
                    if isDouble(k)
                        val{k} = str2double(char(strVals(k)));
                    else
                        s = char(strVals(k));
                        if isempty(s)
                            val{k} = [];
                        else
                            val{k} = string(s);
                        end
                    end
                end
            catch
                val = {};
            end
        end

        function val = readH5CellOfArrays(app, filepath, grouppath, info)
            cellSz = h5getAttr(app, info.Attributes, 'cell_size');
            cellSz = cellSz(:)';
            if ~isnumeric(cellSz) || isempty(cellSz)
                cellSz = [1 numel(info.Groups) + numel(info.Datasets)];
            end
            val = cell(cellSz);

            for k = 1:numel(info.Datasets)
                dsname = info.Datasets(k).Name;
                if startsWith(dsname, '__'), continue; end
                tok = regexp(dsname, '^item_(\d+)$', 'tokens', 'once');
                if isempty(tok), continue; end
                idx = str2double(tok{1});
                if idx < 1 || idx > numel(val), continue; end
                val{idx} = readH5Dataset(app, filepath, [grouppath '/' dsname], info.Datasets(k).Attributes);
            end

            for k = 1:numel(info.Groups)
                parts = strsplit(info.Groups(k).Name, '/');
                tok   = regexp(parts{end}, '^item_(\d+)$', 'tokens', 'once');
                if isempty(tok), continue; end
                idx = str2double(tok{1});
                if idx < 1 || idx > numel(val), continue; end
                try
                    iinfo = h5info(filepath, info.Groups(k).Name);
                    if isequal(h5getAttr(app, iinfo.Attributes, 'is_empty'), int32(1))
                        val{idx} = [];
                    else
                        val{idx} = readH5Group(app, filepath, info.Groups(k).Name);
                    end
                catch
                    val{idx} = [];
                end
            end
        end

        function val = readH5CellOfCells(app, filepath, info)
            cellSz = h5getAttr(app, info.Attributes, 'cell_size');
            cellSz = cellSz(:)';
            if ~isnumeric(cellSz) || isempty(cellSz)
                cellSz = [1 numel(info.Groups)];
            end
            val = cell(cellSz);
            for k = 1:numel(info.Groups)
                parts = strsplit(info.Groups(k).Name, '/');
                tok   = regexp(parts{end}, '^item_(\d+)$', 'tokens', 'once');
                if isempty(tok), continue; end
                idx = str2double(tok{1});
                if idx < 1 || idx > numel(val), continue; end
                val{idx} = readH5MixedCell(app, filepath, info.Groups(k).Name);
            end
        end

        function attrval = h5getAttr(~, attrs, attrname)
            attrval = '';
            if isempty(attrs), return; end
            for k = 1:numel(attrs)
                if strcmp(attrs(k).Name, attrname)
                    v = attrs(k).Value;
                    if iscell(v), v = v{1}; end
                    attrval = v;
                    return;
                end
            end
        end

        function c = unflatten_eliminated_spikes(~, flat, nSpots)
            c = cell(nSpots, 1);
            for i = 1:nSpots
                rows = flat(flat.SpotIndex == i, :);
                if ~isempty(rows)
                    c{i} = rows(:, {'RowIndex','ColumnIndex','OriginalValue','ReplacementValue','SweepIndex'});
                end
            end
        end

        function c = unflatten_signal_data(~, s)
            nSpots   = s.nspots;
            colnames = cellstr(s.colnames);
            flat     = s.flat_data;
            c        = cell(nSpots, 1);
            for i = 1:nSpots
                rows = flat(flat(:,1) == i, 2:end);
                c{i} = array2table(rows, 'VariableNames', colnames);
            end
        end

        function rm = unflatten_referencematerials(~, rm)
            n = numel(rm.data);
            data_out  = cell(n, 1);
            uncert_out = cell(n, 1);
            for i = 1:n
                t = rm.data{i};
                data_out{i}   = t(1, :);
                uncert_out{i} = t(2, :);
                % restore empty uncertainty if all NaN
                if all(isnan(table2array(uncert_out{i})))
                    uncert_out{i} = [];
                end
            end
            rm.data = data_out;
            rm.uncertainty = uncert_out;
            rm = rmfield(rm, 'is_flat_referencematerials');
        end

        %%%%%%%%%%%% Write single session to h5 %%%%%%%

        function save_session_to_h5(app, pid, sid)
            spath     = sprintf('/%d_project/%d_session', pid, sid);
            spath_tmp = sprintf('/%d_project/%d_session_tmp', pid, sid);

            % Clean up leftover temp from any previous failed save
            fid = H5F.open(app.basepath, 'H5F_ACC_RDWR', 'H5P_DEFAULT');
            try
                H5L.delete(fid, spath_tmp, 'H5P_DEFAULT');
            catch
            end
            H5F.close(fid);

            sess = app.base(pid).project(sid).session;

            if isfield(sess, 'config') && isfield(sess.config, 'in_h5')
                sess.config = rmfield(sess.config, 'in_h5');
            end

            if isfield(sess, 'config') && isfield(sess.config, 'last_accessed')
                sess.config = rmfield(sess.config, 'last_accessed');
            end

            if isfield(sess, 'spot') && isfield(sess.spot, 'eliminated_spikes') && iscell(sess.spot.eliminated_spikes)
                sess.spot.eliminated_spikes = flatten_eliminated_spikes(app, sess.spot.eliminated_spikes);
            end
            if isfield(sess, 'spot') && isfield(sess.spot, 'signal_data') && iscell(sess.spot.signal_data)
                sess.spot.signal_data = flatten_signal_data(app, sess.spot.signal_data);
            end
            if isfield(sess, 'referencematerials') && isfield(sess.referencematerials, 'data') && isfield(sess.referencematerials, 'uncertainty')
                sess.referencematerials = flatten_referencematerials(app, sess.referencematerials);
            end

            % Write to temp path first — old session untouched until success
            writeStructToH5(app, sess, app.basepath, spath_tmp);

            % Swap: old -> *_deleted_<time>, temp -> final, then delete the old copy.
            % If the move fails, the old copy is moved back, so one complete copy is always on disk.
            spath_old = sprintf('%s_deleted_%s', spath, char(datetime('now', 'Format', 'yyyyMMddHHmmssSSS')));

            fid    = H5F.open(app.basepath, 'H5F_ACC_RDWR', 'H5P_DEFAULT');
            closer = onCleanup(@() H5F.close(fid)); %#ok<NASGU>

            had_old = h5_link_exists(app, fid, spath);
            if had_old
                H5L.move(fid, spath, fid, spath_old, 'H5P_DEFAULT', 'H5P_DEFAULT');
            end

            try
                H5L.move(fid, spath_tmp, fid, spath, 'H5P_DEFAULT', 'H5P_DEFAULT');
            catch ME
                if had_old
                    try
                        H5L.move(fid, spath_old, fid, spath, 'H5P_DEFAULT', 'H5P_DEFAULT');
                    catch
                    end
                end
                try
                    H5L.delete(fid, spath_tmp, 'H5P_DEFAULT');
                catch
                end
                rethrow(ME);
            end

            if had_old
                try
                    H5L.delete(fid, spath_old, 'H5P_DEFAULT');
                catch
                    % a leftover *_deleted_ group is invisible to the app and removed by Compact Base
                end
            end
        end

        function update_session_table(app, project_id)

            % preallocate the columns
            session_name=cell(1,numel(app.base(project_id).project));
            session_comment=cell(1,numel(app.base(project_id).project));
            session_date = cell(1,numel(app.base(project_id).project));
            session_analyst = cell(1,numel(app.base(project_id).project));
            session_processor = cell(1,numel(app.base(project_id).project));

            % get the session names and other variables
            for i = 1:numel(app.base(project_id).project)

                if isfield(app.base(project_id).project(i).session, 'session_name') ...
                        && ~isempty(app.base(project_id).project(i).session.session_name)
                    session_name{i} = app.base(project_id).project(i).session.session_name;
                end

                if isfield(app.base(project_id).project(i).session, 'meta')...
                        && isfield(app.base(project_id).project(i).session.meta, 'session_comment')...
                        && ~isempty(app.base(project_id).project(i).session.meta.session_comment)
                    session_comment{i} = char(app.base(project_id).project(i).session.meta.session_comment);
                else
                    session_comment{i}='';
                end

                if isfield(app.base(project_id).project(i).session, 'meta')...
                        && isfield(app.base(project_id).project(i).session.meta, 'date')...
                        && ~isempty(app.base(project_id).project(i).session.meta.date)
                    session_date{i} = char(app.base(project_id).project(i).session.meta.date);
                else
                    session_date{i}='';
                end

                if isfield(app.base(project_id).project(i).session, 'meta')...
                        && isfield(app.base(project_id).project(i).session.meta, 'analyst')...
                        && ~isempty(app.base(project_id).project(i).session.meta.analyst)
                    session_analyst{i} = char(app.base(project_id).project(i).session.meta.analyst);
                else
                    session_analyst{i}='';
                end

                if isfield(app.base(project_id).project(i).session, 'meta')...
                        && isfield(app.base(project_id).project(i).session.meta, 'processed_by')...
                        && ~isempty(app.base(project_id).project(i).session.meta.processed_by)
                    session_processor{i} = char(app.base(project_id).project(i).session.meta.processed_by);
                else
                    session_processor{i}='';
                end

            end

            % generate a table with the variables
            T=table((1:numel(session_name))', session_name', session_date', session_comment', session_analyst', session_processor');
            T.Properties.VariableNames={'#', 'Session Name', 'Date YYYYMMDD', 'Comment', 'Analyst', 'Processed by'};

            %push this table to the displayed SessionTable and give them
            %the same column names
            app.SessionTable.Data = T;
            app.SessionTable.ColumnName = T.Properties.VariableNames;

            removeStyle(app.SessionTable);
            green  = [204/255, 1, 204/255];
            orange = [1, 229/255, 204/255];

            synced = arrayfun(@(p) isfield(p.session, 'config') && ...
                isfield(p.session.config, 'synced') && p.session.config.synced, ...
                app.base(project_id).project);

            if any(synced)
                addStyle(app.SessionTable, uistyle('BackgroundColor', green), 'row', find(synced));
            end
            if any(~synced)
                addStyle(app.SessionTable, uistyle('BackgroundColor', orange), 'row', find(~synced));
            end
        end



        %%%%%%%%%%%% Repack/Compact h5 file  %%%%%%%

        function [before_bytes, after_bytes] = repack_h5(app, progress)
            % Rewrite the base into a fresh file, copying only reachable
            % objects. Orphaned (deleted/overwritten) blocks and leftover
            % *_tmp groups are left behind, reclaiming their space.
            % Names/numbering are copied verbatim, so the in-memory <-> on-disk
            % position invariant (including intentional gaps) is preserved.

            src = char(app.basepath);
            [fdir, fname, fext] = fileparts(src);
            dst = fullfile(fdir, [fname '_repack' fext]);
            bak = fullfile(fdir, [fname '_backup_' char(datetime('now', 'Format', 'yyyyMMdd_HHmmss')) fext]);    % e.g. MyBase_backup_20261028_101500.h5

            d = dir(src); before_bytes = d.bytes; after_bytes = before_bytes;

            if isfile(dst), delete(dst); end

            top    = h5_child_names(app, src, '/');
            pNames = top(~cellfun(@isempty, regexp(top, '^\d+_project$', 'once')));
            if isempty(pNames)
                error('ICP_Base:repackEmpty', 'The base contains no projects to compact.');
            end
            pNums = cellfun(@(s) sscanf(s, '%d'), pNames);
            [~, ix] = sort(pNums); pNames = pNames(ix);

            src_fid = H5F.open(src, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');
            dst_fid = H5F.create(dst, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');
            ocpypl  = H5P.create('H5P_OBJECT_COPY');
            lcpl    = H5P.create('H5P_LINK_CREATE');
            H5P.set_create_intermediate_group(lcpl, 1);

            try
                for ii = 1:numel(pNames)
                    if nargin > 1 && ~isempty(progress) && isvalid(progress)
                        progress.Value   = (ii - 1) / numel(pNames);
                        progress.Message = sprintf('Compacting project %d of %d...', ii, numel(pNames));
                    end
                    ppath = ['/' pNames{ii}];
                    gid = H5G.create(dst_fid, ppath, lcpl, 'H5P_DEFAULT', 'H5P_DEFAULT');
                    H5G.close(gid);
                    children = h5_child_names(app, src, ppath);
                    for jj = 1:numel(children)
                        cn = children{jj};
                                                if endsWith(cn, '_tmp') || contains(cn, '_deleted_'), continue; end   % drop interrupted-save and deleted leftovers
                        H5O.copy(src_fid, [ppath '/' cn], dst_fid, [ppath '/' cn], ocpypl, lcpl);
                    end
                end
            catch ME
                H5P.close(ocpypl); H5P.close(lcpl);
                H5F.close(src_fid); H5F.close(dst_fid);
                if isfile(dst), delete(dst); end
                rethrow(ME);
            end

            H5P.close(ocpypl); H5P.close(lcpl);
            H5F.close(src_fid); H5F.close(dst_fid);

            % --- verify counts before committing (old file still intact) ---
            [np_old, ns_old] = repack_count(app, src);
            [np_new, ns_new] = repack_count(app, dst);
            if np_old ~= np_new || ns_old ~= ns_new
                if isfile(dst), delete(dst); end
                error('ICP_Base:repackVerifyFailed', ...
                    ['Compaction verification failed (original: %d projects / %d sessions, ' ...
                    'compacted: %d / %d). The base was NOT changed.'], np_old, ns_old, np_new, ns_new);
            end

            % --- safe swap: old -> .bak, new -> real name, delete .bak ---
            movefile(src, bak);
            try
                movefile(dst, src);
            catch ME
                movefile(bak, src);   % restore original on failure
                rethrow(ME);
            end
            if isfile(bak), delete(bak); end

            d = dir(src); after_bytes = d.bytes;
        end

        function [nProjects, nSessions] = repack_count(app, filepath)
            top    = h5_child_names(app, filepath, '/');
            pNames = top(~cellfun(@isempty, regexp(top, '^\d+_project$', 'once')));
            nProjects = numel(pNames);
            nSessions = 0;
            for ii = 1:numel(pNames)
                ch = h5_child_names(app, filepath, ['/' pNames{ii}]);
                nSessions = nSessions + sum(~cellfun(@isempty, regexp(ch, '^\d+_session$', 'once')));
            end
        end








    end



    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            movegui(app.UIFigure, 'center');

            if isdeployed %standalone mode.
                try
                    if ispc

                        [~, result] = system('path');
                        app.installpath = char(regexpi(result, 'Path=(.*?);', 'tokens', 'once'));

                    elseif ismac

                        path=ctfroot;
                        disp('ctfroot:')
                        disp(path)

                        path_split=split(path,{'ICP_Base.app'});
                        disp('path_split')
                        disp(path_split)

                        app.installpath=path_split{1};
                        disp('Installation Directory 0:')
                        disp(app.installpath)
                        disp('')

                        if not(exist(fullfile(app.installpath,'Total_Oxide_Calculations','Oxides.csv'),'file')) % this is shit and needs to be changed
                            answer = uiconfirm(app.UIFigure,{'Application directory not found - Select ICP-Base directory'},'Select directory','Options',"OK",'Icon','warning');
                            app.installpath=uigetdir(pwd,'select application directory');
                        end

                    elseif isunix

                        try
                            app.installpath=pwd;
                        catch
                            answer = uiconfirm(app.UIFigure,{'Application directory not found - Select ICP-Base directory'},'Select directory','Options',"OK",'Icon','warning');
                            app.installpath=uigetdir(pwd,'select application directory');

                        end

                    end

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    user_path=userpath;
                    disp('Userpath -2:')
                    disp(user_path)

                    user_path=replace(user_path,'/MATLAB','');
                    user_path=replace(user_path,'\MATLAB','');
                    disp('Userpath -1:')
                    disp(user_path)
                    user_path=fullfile(user_path,'ICP-Base');

                    disp('Userpath 0:')
                    disp(user_path)

                    if ~exist(user_path,'dir')
                        try
                            disp('Userpath does not exist')
                            [status, msg, ~] = mkdir(user_path);
                            if status==0
                                answer = uiconfirm(app.UIFigure,{'Working directory not found - Select working directory'},'Select directory','Options',"OK",'Icon','warning');

                                disp('Userpath folder could not be created:')
                                disp(msg)
                                f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]); %create a dummy figure so that uigetfile doesn't minimize our GUI
                                user_path=uigetdir(pwd,'select working directory with read/write permission');
                                delete(f)
                                %   disp('Userpath folder could not be created')
                            else
                                disp('Userpath folder created:')
                                disp(user_path)
                            end

                        catch ME
                            DisplayError(ME,'Startup Error mkdir')

                            if ~exist(user_path,'dir')
                                answer = uiconfirm(app.UIFigure,{'Working directory not found - Select working directory'},'Select directory','Options',"OK",'Icon','warning');
                                % uialert(app.UIFigure,'To avoide this message create a folder called ICP-Base in your Documents folder',' Error');
                                user_path=uigetdir(pwd,'select working directory with read/write permission');
                            end
                        end
                    end

                    try
                        app.diarypath = fullfile(user_path, 'ICP-Base_log.txt');
                        diary(app.diarypath);
                    catch ME
                        DisplayError(ME, 'Starting diary log failed');
                    end

                    startup_time_and_ver_fun(app)

                    disp('Logfile Directory:')
                    disp(user_path)

                    disp('Installation Directory:')
                    disp(app.installpath)
                    disp('')

                    app.WorkingDirectoryEditField.Value=user_path;
                    app.WorkingDirectoryEditField.Tooltip=user_path;
                   
                catch ME
                    DisplayError(ME,'Startup Error 1')
                end

            else % undeployed

                % Set install path to the location of the .mlapp file
                app.installpath = fileparts(which('ICP_Base.mlapp'));

                % --- Define user_path to be Documents/ICP-Base ---
                user_path = userpath;
                user_path = replace(user_path,'/MATLAB','');
                user_path = replace(user_path,'\MATLAB','');
                user_path = fullfile(user_path,'ICP-Base');

                % Create the directory if it doesn't exist
                if ~exist(user_path, 'dir')
                    try
                        mkdir(user_path);
                        disp(['Created working directory for logging: ' user_path]);
                    catch
                        disp('Could not create log directory. Log will be written to current folder.');
                        user_path = pwd; % Fallback to current directory
                    end
                end

                try
                    app.diarypath = fullfile(user_path, 'ICP-Base_log.txt');
                    diary(app.diarypath);
                catch ME
                    DisplayError(ME, 'Starting diary log failed');
                end

                startup_time_and_ver_fun(app)

                disp('Logfile Directory:')
                disp(user_path)

                disp('Installation Directory:')
                disp(app.installpath)
                disp('')

                % Set the UI to show the *current* MATLAB directory as the working folder
                app.WorkingDirectoryEditField.Value = pwd;
                app.WorkingDirectoryEditField.Tooltip = app.WorkingDirectoryEditField.Value;

            end

            if ~exist('user_path', 'var') || isempty(user_path) || ~(ischar(user_path) || isstring(user_path)) || ~exist(char(user_path), 'dir')
                user_path = tempdir;
                disp('Could not determine a valid working directory — falling back to system temp directory.');
            end


            % -------------------------------------------------------------
            % PLOT STYLE INITIALIZATION
            % -------------------------------------------------------------

            source_styles = fullfile(app.installpath, 'Plot_Styles');
            app.default_plotstyle_path = fullfile(user_path, 'Plot_Styles');

            % Logic: Check if user folder exists. If NOT, copy from installation.
            if ~exist(app.default_plotstyle_path, 'dir')
                if exist(source_styles, 'dir')
                    try
                        disp('Initialized Plot_Styles folder in:');
                        disp( app.default_plotstyle_path)
                        [status, msg] = copyfile(source_styles, app.default_plotstyle_path);

                        if ~status
                            disp(['Error copying Plot_Styles: ' msg]);
                            % Fallback to source (read-only) if copy fails
                            app.default_plotstyle_path = source_styles;
                        end
                    catch ME
                        DisplayError(ME,'Error intitializing Plot_Styles folder')
                        app.default_plotstyle_path = source_styles;
                    end
                end
            else
                disp('Plot Styles Directory:');
                disp( app.default_plotstyle_path)
            end
            % -------------------------------------------------------------


            % -------------------------------------------------------------
            % RM FILES INITIALIZATION
            % -------------------------------------------------------------

            source_rms = fullfile(app.installpath, 'RM_Files');
            app.default_RM_path = fullfile(user_path, 'RM_Files');

            % Logic: Check if user folder exists. If NOT, copy from installation.
            if ~exist(app.default_RM_path, 'dir')
                if exist(source_rms, 'dir')
                    try
                        disp('Initialized RM_Files folder in:');
                        disp( app.default_RM_path)
                        [status, msg] = copyfile(source_rms, app.default_RM_path);

                        if ~status
                            disp(['Error copying RM_Files folder: ' msg]);
                            % Fallback to source (read-only) if copy fails
                            app.default_RM_path = source_rms;
                        end
                    catch ME
                        DisplayError(ME,'Error intitializing RM_Files folder')
                        app.default_RM_path = source_rms;
                    end
                end
            else
                disp('RM Files Directory:');
                disp( app.default_RM_path)
            end
            % -------------------------------------------------------------


            % -------------------------------------------------------------
            % Total_Oxide_Calculations INITIALIZATION
            % -------------------------------------------------------------

            source_oxide = fullfile(app.installpath, 'Total_Oxide_Calculations');
            app.default_oxides_path = fullfile(user_path, 'Total_Oxide_Calculations');

            % Logic: Check if user folder exists. If NOT, copy from installation.
            if ~exist(app.default_oxides_path, 'dir')
                if exist(source_oxide, 'dir')
                    try
                        disp('Initialized Total_Oxide_Calculations folder in:');
                        disp( app.default_oxides_path)
                        [status, msg] = copyfile(source_oxide, app.default_oxides_path);

                        if ~status
                            disp(['Error copying Total_Oxide_Calculations folder: ' msg]);
                            % Fallback to source (read-only) if copy fails
                            app.default_oxides_path = source_oxide;
                        end
                    catch ME
                        DisplayError(ME,'Error intitializing Total_Oxide_Calculations folder')
                        app.default_oxides_path = source_oxide;
                    end
                end
            else
                disp('Total Oxide Calculations Directory:');
                disp( app.default_oxides_path)
            end
            % -------------------------------------------------------------


            % -------------------------------------------------------------
            % MinPlotX's VisModule INITIALIZATION
            % -------------------------------------------------------------

            % 1. Define Source FOLDER (Where the original files live)
            source_folder = fullfile(app.installpath, 'Modules', 'VisModule');

            % 2. Define Destination FOLDER (User Documents)
            app.default_VisModule_path = fullfile(user_path, 'VisModule_Resources');

            % Files to copy
            file1 = 'XMap_SpiderNormalizations.txt';
            file2 = 'XMap_ColorMaps.txt';

            % Logic: Check if user FOLDER exists.
            if ~exist(app.default_VisModule_path, 'dir')
                try
                    % Create the new folder
                    [status_mkdir, msg_mkdir] = mkdir(app.default_VisModule_path);

                    if status_mkdir
                        disp('Created VisModule Resources folder in:');
                        disp(app.default_VisModule_path);

                        % Copy File 1
                        if exist(fullfile(source_folder, file1), 'file')
                            copyfile(fullfile(source_folder, file1), app.default_VisModule_path);
                        end

                        % Copy File 2
                        if exist(fullfile(source_folder, file2), 'file')
                            copyfile(fullfile(source_folder, file2), app.default_VisModule_path);
                        end

                    else
                        disp(['Error creating directory: ' msg_mkdir]);
                        app.default_VisModule_path = source_folder; % Fallback
                    end

                catch ME
                    DisplayError(ME, 'Error initializing VisModule Resources');
                    app.default_VisModule_path = source_folder; % Fallback
                end
            else
                disp('VisModule Resources Directory:');
                disp(app.default_VisModule_path);
            end
            % -------------------------------------------------------------



            % check for new version
            check_for_update_fun(app)

            disp('---------------------------------------')
            disp('=======================================')
            disp('                                       ')

        end

        % Button pushed function: AddSessionButton
        function AddSessionButtonPushed(app, event)

            % get the project_id as the selection of the ProjectTable

            project_id = app.LastSelectedProjectRow;

            if isempty(project_id)
                message = "Select a Project first";
                uialert(app.UIFigure,message,"Warning", ...
                    "Icon","warning");
                return
            end

            progress = uiprogressdlg(app.UIFigure, 'Title', 'Adding new session...',...
                'Message', 'Please wait', 'Cancelable', 'off', 'Indeterminate', 'on');


            session_id = 0;
            Import_Module(app, app.base(project_id).project_name, project_id, session_id)

            delete(progress)

        end

        % Button pushed function: ClassificationButton, DriftButton, 
        % ImportButton, IntervalButton, QuantificationButton, ResultsButton
        function ImportButtonPushed(app, event)
            try
                progress = uiprogressdlg(app.UIFigure, 'Title', 'Fetching session data from base...',...
                    'Message', 'Please wait', 'Cancelable', 'off', 'Indeterminate', 'on');

                % check if selection is not empty
                if ~isempty(app.SessionTable.Selection) && not(isequal(app.SessionTable.Selection(1),0))

                    % session_id is the selection
                    session_id = app.SessionTable.Selection(1);
                    % the project_id is the last selected project in the
                    % project table
                    project_id = app.LastSelectedProjectRow;

                    if session_has_open_module(app, project_id, session_id)
                        delete(progress)
                        uialert(app.UIFigure, ...
                            'A module window for this session is already open. Use that window, or close it first.', ...
                            'Session in Use', 'Icon', 'warning');
                        return
                    end

                    cfg = app.base(project_id).project(session_id).session.config;

                    if ~cfg.loaded
                        if ~cfg.synced
                            pending = app.base(project_id).project(session_id).session;
                            h52session(app, project_id, session_id);
                            app.base(project_id).project(session_id).session.session_name = pending.session_name;
                            for fn = ["session_comment", "date", "analyst", "processed_by"]
                                if isfield(pending, 'meta') && isfield(pending.meta, fn)
                                    app.base(project_id).project(session_id).session.meta.(fn) = pending.meta.(fn);
                                end
                            end
                            app.base(project_id).project(session_id).session.config.synced = false;
                        else
                            h52session(app, project_id, session_id);
                        end
                    end


                    switch event.Source.Parent.Parent.Parent.CallbackObject.Text
                        case 'Show Session in Import Module'
                            Import_Module(app, app.base(project_id).project_name, project_id, session_id)
                        case 'Show Session in Interval Module'
                            Interval_Module(app, app.base(project_id).project_name, project_id, session_id)
                        case 'Show Session in Classification Module'
                            Classification_Module(app, app.base(project_id).project_name, project_id, session_id)
                        case 'Show Session in Drift Module'
                            Drift_Module(app, app.base(project_id).project_name, project_id, session_id)
                        case 'Show Session in Quantification Module'
                            Quantification_Module(app, app.base(project_id).project_name, project_id, session_id)
                        case 'Show Session in Results Module'
                            Results_Module(app, app.base(project_id).project_name, project_id, session_id)
                    end

                    refresh_session_buttons(app)

                end

                delete(progress)

            catch ME
                delete(progress)
                DisplayError(ME,'Error when proceeding from the module buttons')
            end


        end

        % Cell edit callback: SessionTable
        function SessionTableCellEdit(app, event)

            sel_row_session = event.Indices(1);
            sel_col_session = event.Indices(2);
            pid     = app.LastSelectedProjectRow;
            colname = app.SessionTable.ColumnName{sel_col_session};

            % a module window works on its own copy and would overwrite this edit when it closes
            if session_has_open_module(app, pid, sel_row_session)
                uialert(app.UIFigure, ...
                    'A module window for this session is open. Close it before editing the session details.', ...
                    'Session in Use', 'Icon', 'warning');
                update_session_table(app, pid)      % puts the old value back into the table
                return
            end

            switch colname
                case 'Session Name'
                    app.base(pid).project(sel_row_session).session.session_name = event.NewData;
                case 'Comment'
                    app.base(pid).project(sel_row_session).session.meta.session_comment = event.NewData;
                case 'Date YYYYMMDD'
                    app.base(pid).project(sel_row_session).session.meta.date = event.NewData;
                case 'Analyst'
                    app.base(pid).project(sel_row_session).session.meta.analyst = event.NewData;
                case 'Processed by'
                    app.base(pid).project(sel_row_session).session.meta.processed_by = event.NewData;
            end

            app.base(pid).project(sel_row_session).session.config.synced = false;

            refresh_session_buttons(app)
 
            update_session_table(app, pid)
            
        end

        % Button pushed function: AddProjectButton
        function AddProjectButtonPushed(app, event)
            % If no H5 connected yet, ask user to create one first
            if app.basepath == ""
                answer = uiconfirm(app.UIFigure, ...
                    ['This base is currently empty. A new base (.h5) will be created to store all your projects and sessions.' ...
                    ' Please choose a location and filename for the new base.'], ...
                    'Create New Base', 'Options', {'OK', 'Cancel'}, ...
                    'DefaultOption', 'OK', 'CancelOption', 'Cancel', 'Icon', 'info');
                if strcmp(answer, 'Cancel'), return; end

                f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
                [filename, filepath] = uiputfile('*.h5', 'Create new base file:');
                delete(f);
                figure(app.UIFigure);
                if isequal(filename, 0), return; end
                [~, fname, ~] = fileparts(filename);
                app.basepath = fullfile(filepath, [fname '.h5']);
                if isfile(app.basepath)
                    delete(app.basepath);
                end
            end

            if ~isfield(app.base, 'project')
                new_pid = 1;
            else
                new_pid = numel(app.base) + 1;
            end

            app.base(new_pid).project      = struct();
            app.base(new_pid).project_name = 'New Project';

            h5writeStrVal(app, app.basepath, sprintf('/%d_project/project_name', new_pid), "New Project");

            update_project_table(app)
        end

        % Callback function: ProjectTable
        function ProjectTableSelectionChanged(app, event)
            %% updates the session table when a project is selected
            if ~isempty(app.ProjectTable.Selection)
                if not(isempty(app.ProjectTable.Selection(1)))
                    selection = app.ProjectTable.Selection(1);
                else
                    return
                end

                if ~isstruct(app.base(selection).project)
                    app.base(selection).project = struct([]);
                end

                if not(isempty(fieldnames(app.base(selection).project))) && isfield(app.base(selection).project, 'session')
                    update_session_table(app, selection)
                else
                    app.SessionTable.Data = {};
                end
            else
                return
            end

            %% failsafe if a project is clicked on but then it is clicked
            % somewhere in the ProjectTable where there is no project, the
            % selection gets set to [] and the conncection to the project
            % is lost
            % so the last clicked on row is always saved to always get back
            % to the project
            % Check if there is a selection in the ProjectTable
            if isempty(app.ProjectTable.Selection)
                % Use the last stored selection if the current selection is empty
                app.LastSelectedProjectRow = app.LastSelectedProjectRow;
            else
                % Update the last stored selection with the current selection
                app.LastSelectedProjectRow = app.ProjectTable.Selection(1);
            end

            % if Tableselection changed make all buttons just grey

            app.ImportButton.Visible = "off";
            app.IntervalButton.Visible = "off";
            app.ClassificationButton.Visible = "off";
            app.DriftButton.Visible = "off";
            app.QuantificationButton.Visible = "off";
            app.ResultsButton.Visible = "off";
            app.DuplicateSessionButton.Visible = "off";
            app.DeleteSessionButton.Visible = "off";

            app.SessionTable.Selection = [];
            app.SaveselectedSessiontoBaseButton.Enable = false;
            app.RestoreselectedSessionButton.Enable    = false;

           cleanup_unused_sessions(app);
        end

        % Callback function
        function SaveBaseMenuSelected(app, event)

            progress = uiprogressdlg(app.UIFigure, 'Title', 'Saving Base...', ...
                'Message', 'This may take a few seconds', 'Cancelable', 'off', 'Indeterminate','on');


            if isfield(app.base, 'meta') && isfield(app, 'basepath') && not(isempty(app.basepath))
                app.UIFigure.Name = [app.basepath ' [... Saving Base]'] ;

                data2save.base = app.base;
                try

                    save(app.basepath, 'data2save', '-v7.3', '-nocompression'); %

                catch

                    message = "Saving the base failed. Did you change the file location of the base (.mat) file? Use the 'Save Base as' option.";
                    uialert(app.UIFigure,message,"Warning", ...
                        "Icon","warning");

                end

                app.UIFigure.Name = app.basepath;

            else
                SaveBaseasMenuSelected(app)
            end

            if isfield(app.base,'meta') && isfield(app, 'basepath')

                app.UIFigure.Name = app.basepath;

            end

            delete(progress)
        end

        % Menu selected function: OpenBaseMenu
        function OpenBaseMenuSelected(app, event)

            % --- 1. No module windows or Table Builder may be open ---
            figs = findall(groot, 'Type', 'figure');
            tags = get(figs, 'Tag');
            if ~iscell(tags), tags = {tags}; end
            if any(~cellfun(@isempty, tags) & ...
                    (cellfun(@(t) ~isempty(regexp(t, '^\d+_\d+$', 'once')), tags) | strcmp(tags, "tablebuilder")))
                uialert(app.UIFigure, ...
                    'Close all open module windows (and the Table Builder, if open) before opening a different base. Switching bases while a module is open can corrupt data if that module is saved afterward.', ...
                    'Cannot Open Base', 'Icon', 'warning');
                return
            end

            % --- 2. Choose the file (nothing is touched before the user has committed to one) ---
            f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
            [file, path] = uigetfile({'*.mat;*.h5', 'Base Files (*.mat, *.h5)'}, "MultiSelect", "off", 'Open Base');
            delete(f);
            figure(app.UIFigure);

            if isequal(file, 0)
                return
            end

            % --- 3. Uncommitted sessions of the base that is about to be replaced ---
            msg_lines    = {};
            unsynced     = zeros(0, 2);   % rows of [pid, sid]
            unsynced_nm  = {};
            if ~isempty(app.base) && isfield(app.base, 'project')
                for i = 1:numel(app.base)
                    names = {};
                    for j = 1:numel(app.base(i).project)
                        if ~isfield(app.base(i).project(j), 'session') ...
                                || ~isfield(app.base(i).project(j).session, 'config')
                            continue
                        end
                        cfg = app.base(i).project(j).session.config;
                        if isfield(cfg, 'synced') && ~cfg.synced
                            if isfield(app.base(i).project(j).session, 'session_name')
                                sname = char(app.base(i).project(j).session.session_name);
                            else
                                sname = sprintf('(session %d)', j);
                            end
                            names{end+1}       = sname;
                            unsynced(end+1, :) = [i, j];
                            unsynced_nm{end+1} = sname;
                        end
                    end
                    if ~isempty(names)
                        if isfield(app.base(i), 'project_name') && ~isempty(app.base(i).project_name)
                            pname = char(app.base(i).project_name);
                        else
                            pname = sprintf('(project %d)', i);
                        end
                        msg_lines{end+1} = sprintf('  %s: %s', pname, strjoin(names, ', '));
                    end
                end
            end

            if ~isempty(msg_lines)
                msg = sprintf(['The following sessions have uncommitted changes:\n\n%s\n\n' ...
                    'Do you want to save them to the base (h5 file) before opening another base?'], strjoin(msg_lines, '\n'));
                answer = uiconfirm(app.UIFigure, msg, 'Uncommitted Sessions', ...
                    'Options', {'Save all', 'Open without saving', 'Cancel'}, ...
                    'DefaultOption', 'Save all', 'CancelOption', 'Cancel', 'Icon', 'warning');

                switch answer
                    case 'Cancel'
                        return

                    case 'Save all'
                        if app.basepath == "" || ~isfile(app.basepath)
                            uialert(app.UIFigure, ...
                                'No base file is connected, so the sessions cannot be saved. Create a base first (Add Project), or open the other base without saving.', ...
                                'Cannot Save', 'Icon', 'warning');
                            return
                        end

                        progress = uiprogressdlg(app.UIFigure, 'Title', 'Saving sessions...', ...
                            'Message', 'Saving all unsaved sessions to the base.', ...
                            'Cancelable', 'off', 'Indeterminate', 'on');

                        failed = {};
                        for r = 1:size(unsynced, 1)
                            pid = unsynced(r,1);
                            sid = unsynced(r,2);
                            try
                                sess = app.base(pid).project(sid).session;

                                if isfield(sess.config, 'loaded') && sess.config.loaded
                                    save_session_to_h5(app, pid, sid);

                                    skeleton.session_name = sess.session_name;
                                    if isfield(sess, 'meta'), skeleton.meta = sess.meta; end
                                    skeleton.config.synced = true;
                                    skeleton.config.loaded = false;
                                    skeleton.config.in_h5  = true;
                                    if isfield(sess.config, 'module_status')
                                        skeleton.config.module_status = sess.config.module_status;
                                    end
                                    if isfield(sess.config, 'reductiontype')
                                        skeleton.config.reductiontype = sess.config.reductiontype;
                                    end
                                    app.base(pid).project(sid).session = skeleton;
                                    clear skeleton

                                else
                                    spath = sprintf('/%d_project/%d_session', pid, sid);
                                    h5writeStrVal(app, app.basepath, [spath '/session_name'], sess.session_name);
                                    if isfield(sess, 'meta')
                                        for fn = ["session_comment", "date", "analyst", "processed_by"]
                                            if isfield(sess.meta, char(fn))
                                                h5writeStrVal(app, app.basepath, [spath '/meta/' char(fn)], sess.meta.(char(fn)));
                                            end
                                        end
                                    end
                                    app.base(pid).project(sid).session.config.synced = true;
                                    app.base(pid).project(sid).session.config.in_h5  = true;
                                end

                            catch ME
                                DisplayError(ME, sprintf('Saving session [%d,%d] failed', pid, sid));
                                failed{end+1} = unsynced_nm{r};
                            end
                        end
                        delete(progress)

                        if ~isempty(failed)
                            sel2 = uiconfirm(app.UIFigure, ...
                                sprintf(['These sessions could not be saved:\n\n%s\n\n' ...
                                'Open the other base anyway (their unsaved changes will be lost), or cancel and stay here?'], ...
                                strjoin(failed, '\n')), ...
                                'Save Incomplete', 'Options', {'Open anyway', 'Cancel'}, ...
                                'DefaultOption', 'Cancel', 'CancelOption', 'Cancel', 'Icon', 'warning');
                            if strcmp(sel2, 'Cancel'), return; end
                        end

                    case 'Open without saving'
                        % fall through to opening
                end
            end

            % --- 4. Open the chosen base ---
            [~, fname, ext] = fileparts(file);

            if strcmp(ext, '.mat')

                h5path = fullfile(path, [fname '.h5']);

                if isfile(h5path)
                    answer1 = uiconfirm(app.UIFigure, ...
                        sprintf(['An HDF5 file already exists at:\n\n%s\n\n' ...
                        'Opening from the .mat file will overwrite it — any work done in the ' ...
                        'HDF5 file since the last export will be lost.\n\n' ...
                        'Do you want to open the existing .h5 file instead?'], h5path), ...
                        'HDF5 File Already Exists', ...
                        'Options', {'Open existing .h5', 'Overwrite with .mat', 'Cancel'}, ...
                        'DefaultOption', 'Open existing .h5', 'CancelOption', 'Cancel');
                    switch answer1
                        case 'Open existing .h5'

                            app.base = struct([]);

                            app.SessionTable.Data = {};
                            app.LastSelectedProjectRow = [];
                            app.SaveselectedSessiontoBaseButton.Enable = false;
                            app.RestoreselectedSessionButton.Enable    = false;
                            app.ImportButton.Visible = "off";
                            app.IntervalButton.Visible = "off";
                            app.ClassificationButton.Visible = "off";
                            app.DriftButton.Visible = "off";
                            app.QuantificationButton.Visible = "off";
                            app.ResultsButton.Visible = "off";
                            app.DuplicateSessionButton.Visible = "off";
                            app.DeleteSessionButton.Visible = "off";

                            
                            connect_h5_safely(app, h5path);
                            update_project_table(app);
                            return;
                        case 'Cancel'
                            return;
                            % 'Overwrite with .mat' falls through
                    end
                end


                answer = uiconfirm(app.UIFigure, ...
                    sprintf('ICP-Base (v1.3.0 and higher) exclusively uses the HDF5 format to load and store data. This base will be converted to HDF5 format and saved as:\n\n%s\n\nThe original .mat file will no longer be used (but can be kept as a backup).', h5path), ...
                    'Convert to HDF5', ...
                    'Options', {'OK', 'Cancel'}, ...
                    'DefaultOption', 'OK', ...
                    'CancelOption', 'Cancel');

                if strcmp(answer, 'Cancel')
                    return
                end

                progress = uiprogressdlg(app.UIFigure, 'Title', 'Loading, migrating and saving to HDF5...', ...
                    'Message', 'Depending on the size of the base, this can take a few minutes.', ...
                    'Cancelable', 'off', 'Indeterminate', 'on');

                % Import original .mat file
                data2import = load(fullfile(path, file));
                app.base = data2import.data2save.base;

                app.basepath = h5path;
                % update the base to string and double arrays
                migrate_base(app);
                % write to h5
                base2h5(app, app.base, h5path);
                % empty the base
                app.base = struct([]);

                app.SessionTable.Data = {};
                app.LastSelectedProjectRow = [];
                app.SaveselectedSessiontoBaseButton.Enable = false;
                app.RestoreselectedSessionButton.Enable    = false;
                app.ImportButton.Visible = "off";
                app.IntervalButton.Visible = "off";
                app.ClassificationButton.Visible = "off";
                app.DriftButton.Visible = "off";
                app.QuantificationButton.Visible = "off";
                app.ResultsButton.Visible = "off";
                app.DuplicateSessionButton.Visible = "off";
                app.DeleteSessionButton.Visible = "off";

                % fill it with the data from h5
                connect_h5_safely(app, h5path);

                update_project_table(app)

                delete(progress)

            elseif strcmp(ext, '.h5')

                progress = uiprogressdlg(app.UIFigure, 'Title', 'Loading base...', ...
                    'Message', 'Depending on the size of the base, this can take some time.', ...
                    'Cancelable', 'off', 'Indeterminate', 'on');

                app.base = struct([]);

                app.SessionTable.Data = {};
                app.LastSelectedProjectRow = [];
                app.SaveselectedSessiontoBaseButton.Enable = false;
                app.RestoreselectedSessionButton.Enable    = false;
                app.ImportButton.Visible = "off";
                app.IntervalButton.Visible = "off";
                app.ClassificationButton.Visible = "off";
                app.DriftButton.Visible = "off";
                app.QuantificationButton.Visible = "off";
                app.ResultsButton.Visible = "off";
                app.DuplicateSessionButton.Visible = "off";
                app.DeleteSessionButton.Visible = "off";

                connect_h5_safely(app, fullfile(path, file));

                update_project_table(app)

                delete(progress)

            end
        end

        % Cell edit callback: ProjectTable
        function ProjectTableCellEdit(app, event)
            sel_row_project = app.ProjectTable.Selection(1);
            sel_col_project = app.ProjectTable.Selection(2);

            if project_has_open_module(app, sel_row_project)
                uialert(app.UIFigure, ...
                    'A module window for a session of this project is open. Close it before renaming the project.', ...
                    'Project in Use', 'Icon', 'warning');
                update_project_table(app)           % puts the old name back
                return
            end


            if strcmp(app.ProjectTable.ColumnName{sel_col_project}, 'Project Name')
                try
   
                    [~,~,bext] = fileparts(app.basepath);
                    if strcmp(bext, '.h5') && isfile(app.basepath)
                        ppath = sprintf('/%d_project', sel_row_project);
                        h5writeStrVal(app, app.basepath, [ppath '/project_name'], string(event.NewData));
                    end
                    app.base(sel_row_project).project_name = string(event.NewData);
                catch ME
                    DisplayError(ME,'Writing project name to h5 failed')
                end
            end
        end

        % Callback function
        function SaveBaseasMenuSelected(app, event)
% 
%             f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
%             [filename, filepath] = uiputfile('*.mat', 'Save the base file:');
%             delete(f);
%             figure(app.UIFigure);
% 
%             if not(isequal(filename,0))
% 
%                 progress = uiprogressdlg(app.UIFigure, 'Title', 'Saving Base...', ...
%                     'Message', 'This may take a few seconds', 'Cancelable', 'off', 'Indeterminate','on');
% 
%                 FileName = fullfile(filepath, filename);
%                 app.basepath = FileName;
%                 app.UIFigure.Name = [app.basepath ' [... Saving Base]'] ;
% 
%                 data2save.base = app.base;
% 
%                 save(FileName, 'data2save', '-v7.3', '-nocompression');
% 
%                 app.UIFigure.Name = app.basepath;
% 
%                 delete(progress)
%             end
        end

        % Button pushed function: DuplicateProjectButton
        function DuplicateProjectButtonPushed(app, event)
            if isempty(app.ProjectTable.Selection)
                return
            end

            sel_project = app.ProjectTable.Selection(1);
            new_pid     = numel(app.base) + 1;

            progress = uiprogressdlg(app.UIFigure, 'Title', 'Duplicating Project...', ...
                'Message', 'This may take a few seconds.', 'Indeterminate', 'on', 'Cancelable', 'off');

            try
                [~,~,bext] = fileparts(app.basepath);
                if strcmp(bext, '.h5') && isfile(app.basepath)
                    src    = sprintf('/%d_project', sel_project);
                    dst    = sprintf('/%d_project', new_pid);
                    fid    = H5F.open(app.basepath, 'H5F_ACC_RDWR', 'H5P_DEFAULT');
                    ocpypl = H5P.create('H5P_OBJECT_COPY');
                    lcpl   = H5P.create('H5P_LINK_CREATE');
                    try
                        H5O.copy(fid, src, fid, dst, ocpypl, lcpl);
                    catch ME
                        H5P.close(ocpypl);
                        H5P.close(lcpl);
                        H5F.close(fid);
                        rethrow(ME);
                    end
                    H5P.close(ocpypl);
                    H5P.close(lcpl);
                    H5F.close(fid);
                end
                % possible to replace this with a connecth5
                app.base(new_pid) = app.base(sel_project);
            catch ME
                DisplayError(ME, 'Duplicating project in H5 failed')
            end

            delete(progress)
            update_project_table(app)
        end

        % Button pushed function: DeleteProjectButton
        function DeleteProjectButtonPushed(app, event)
             if isempty(app.ProjectTable.Selection)
                return
            end

            selection = app.ProjectTable.Selection(1);
            n         = numel(app.base);
            pname     = char(app.base(selection).project_name);

            for p = selection:n
                if project_has_open_module(app, p)
                    uialert(app.UIFigure, ...
                        'Close all open module windows for this project and any projects after it before deleting this project.', ...
                        'Cannot Delete Project', 'Icon', 'warning');
                    return
                end
            end

            figs = findall(groot, 'Type', 'figure');
            tags = get(figs, 'Tag');
            if ~iscell(tags), tags = {tags}; end
            if any(strcmp(tags, "tablebuilder"))
                uialert(app.UIFigure, ...
                    'Close the Table Builder window before deleting any project, since it holds a snapshot of the base that could become misaligned.', ...
                    'Cannot Delete Project', 'Icon', 'warning');
                return
            end

            [~,~,bext] = fileparts(app.basepath);
            project_in_h5 = strcmp(bext, '.h5') && isfile(app.basepath);

            if project_in_h5
                msg = sprintf(['Are you sure you want to delete project %d "%s"?\n\nThis will permanently remove the project and ALL its sessions from the base (i.e. the .h5 file stored on your computer).\n\nThis action CANNOT be undone and the data CANNOT be recovered.\n\n' ...
                    'Make sure you have a backup if you need this data. You can export and import a single project using the "Project" Menu.'], selection, pname);
            else
                msg = sprintf('Are you sure you want to delete project %d "%s"?', selection, pname);
            end

            answer = uiconfirm(app.UIFigure, msg, 'Delete Project', ...
                'Options', {'Delete', 'Cancel'}, ...
                'DefaultOption', 'Cancel', ...
                'CancelOption', 'Cancel', ...
                'Icon', 'error');

            if strcmp(answer, 'Cancel')
                return
            end

            % disk first; memory only changes if the disk steps worked
            try
                if project_in_h5
                    paths = arrayfun(@(k) sprintf('/%d_project', k), 1:n, 'UniformOutput', false);
                    [ok, message] = remove_h5_entry_and_shift(app, paths, [], selection);

                    if ~ok
                        uialert(app.UIFigure, message, 'Delete Failed', 'Icon', 'error');
                        return
                    end
                    if ~isempty(message)
                        uialert(app.UIFigure, message, 'Delete Project', 'Icon', 'warning');
                    end
                end

                app.base(selection) = [];

            catch ME
                DisplayError(ME, 'Deleting project failed')
                return
            end

            app.LastSelectedProjectRow = [];
            app.SessionTable.Data = {};
            app.SessionTable.Selection = [];
            app.SaveselectedSessiontoBaseButton.Enable = false;
            app.RestoreselectedSessionButton.Enable    = false;
            app.ImportButton.Visible = "off";
            app.IntervalButton.Visible = "off";
            app.ClassificationButton.Visible = "off";
            app.DriftButton.Visible = "off";
            app.QuantificationButton.Visible = "off";
            app.ResultsButton.Visible = "off";
            app.DuplicateSessionButton.Visible = "off";
            app.DeleteSessionButton.Visible = "off";

            update_project_table(app)
        end

        % Callback function: SessionTable
        function SessionTableSelectionChanged(app, event)
            % session_id is the selection

            if ~isempty(app.SessionTable.Selection) && not(isequal(app.SessionTable.Selection(1),0))

               refresh_session_buttons(app)

            else
                app.SaveselectedSessiontoBaseButton.Enable = false;
                app.RestoreselectedSessionButton.Enable    = false;
                app.ImportButton.Visible = "off";
                app.IntervalButton.Visible = "off";
                app.ClassificationButton.Visible = "off";
                app.DriftButton.Visible = "off";
                app.QuantificationButton.Visible = "off";
                app.ResultsButton.Visible = "off";
                app.DuplicateSessionButton.Visible = "off";
                app.DeleteSessionButton.Visible = "off";
            end


           cleanup_unused_sessions(app);
        end

        % Button pushed function: SelectButton
        function SelectButtonPushed(app, event)
            f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]); %create a dummy figure so that uigetfile doesn't minimize our GUI
            path=uigetdir(pwd,'select export directory with read/write permission');
            delete(f)
            figure(app.UIFigure);

            if path==0
                app.WorkingDirectoryEditField.Value=pwd;
            else
                app.WorkingDirectoryEditField.Value = path;
                app.workingdirectory = path;
            end
            app.WorkingDirectoryEditField.Tooltip = app.WorkingDirectoryEditField.Value;

            WorkingDirectoryEditFieldValueChanged(app)


        end

        % Value changed function: WorkingDirectoryEditField
        function WorkingDirectoryEditFieldValueChanged(app, event)
            value = app.WorkingDirectoryEditField.Value;

            if not(exist(value,'dir'))

                uiconfirm(app.UIFigure,{'Directory not found - Select working directory'},'Select directory','Options',"OK",'Icon','warning');
                f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]); %create a dummy figure so that uigetfile doesn't minimize our GUI
                path=uigetdir(pwd,'select working directory with read/write permission');
                delete(f)
                figure(app.UIFigure);

                if ~isequal(path,0)
                    cd(path)
                    app.WorkingDirectoryEditField.Value = path;
                else
                    app.WorkingDirectoryEditField.Value=pwd;
                end

                app.WorkingDirectoryEditField.Tooltip=app.WorkingDirectoryEditField.Value;

            end
        end

        % Button pushed function: DeleteSessionButton
        function DeleteSessionButtonPushed(app, event)
            if isempty(app.SessionTable.Selection) || isempty(app.LastSelectedProjectRow)
                return
            end

            selection = app.SessionTable.Selection(1);
            pid       = app.LastSelectedProjectRow;
            n         = numel(app.base(pid).project);

            for sid = selection:n
                if session_has_open_module(app, pid, sid)
                    uialert(app.UIFigure, ...
                        'Close all open module windows for this session and any sessions after it before deleting this session.', ...
                        'Cannot Delete Session', 'Icon', 'warning');
                    return
                end
            end

            figs = findall(groot, 'Type', 'figure');
            tags = get(figs, 'Tag');
            if ~iscell(tags), tags = {tags}; end
            if any(strcmp(tags, "tablebuilder"))
                uialert(app.UIFigure, ...
                    'Close the Table Builder window before deleting any session, since it holds a snapshot of the base that could become misaligned.', ...
                    'Cannot Delete Session', 'Icon', 'warning');
                return
            end

            if isfield(app.base(pid).project(selection).session, 'session_name')
                sname = char(app.base(pid).project(selection).session.session_name);
            else
                sname = sprintf('(session %d)', selection);
            end

            cfg    = app.base(pid).project(selection).session.config;
            in_h5  = ~isfield(cfg, 'in_h5') || cfg.in_h5;

            if in_h5
                msg = sprintf(['Are you sure you want to delete session %d "%s"?\n\nThis will permanently remove the session from the base (i.e. the .h5 file stored on your computer).\n\nThis action CANNOT be undone and the data CANNOT be recovered.\n\n' ...
                    'Make sure you have a backup if you need this data. You can export and import a single session using the "Session" Menu.'], selection, sname);
            else
                msg = sprintf('Are you sure you want to delete session %d "%s"?', selection, sname);
            end

            answer = uiconfirm(app.UIFigure, msg, 'Delete Session', ...
                'Options', {'Delete permanently', 'Cancel'}, ...
                'DefaultOption', 'Cancel', ...
                'CancelOption', 'Cancel', ...
                'Icon', 'error');

            if strcmp(answer, 'Cancel')
                return
            end

            % disk first; memory only changes if the disk steps worked
            try
                [~,~,bext] = fileparts(app.basepath);
                if strcmp(bext, '.h5') && isfile(app.basepath)

                    paths = arrayfun(@(k) sprintf('/%d_project/%d_session', pid, k), 1:n, 'UniformOutput', false);
                    expected_present = false(1, n);
                    for k = 1:n
                        cfg_k = app.base(pid).project(k).session.config;
                        expected_present(k) = ~isfield(cfg_k, 'in_h5') || cfg_k.in_h5;
                    end

                    [ok, message] = remove_h5_entry_and_shift(app, paths, expected_present, selection);

                    if ~ok
                        uialert(app.UIFigure, message, 'Delete Failed', 'Icon', 'error');
                        return
                    end
                    if ~isempty(message)
                        uialert(app.UIFigure, message, 'Delete Session', 'Icon', 'warning');
                    end
                end

                app.base(pid).project(selection) = [];

            catch ME
                DisplayError(ME, 'Deleting session failed')
                return
            end

            app.SessionTable.Selection = [];
            update_session_table(app, pid)
        end

        % Button pushed function: DuplicateSessionButton
        function DuplicateSessionButtonPushed(app, event)
            if isempty(app.SessionTable.Selection)
                return
            end

            pid = app.LastSelectedProjectRow;
            sel_session = app.SessionTable.Selection(1);
            new_sid     = numel(app.base(pid).project) + 1;

            try
                cfg = app.base(pid).project(sel_session).session.config;

                if ~cfg.loaded
                    progress = uiprogressdlg(app.UIFigure, 'Title', 'Duplicating Session...', ...
                        'Message', 'Please wait.', 'Cancelable', 'off', 'Indeterminate', 'on');

                    spath        = sprintf('/%d_project/%d_session', pid, sel_session);
                    temp_session = readH5Group(app, app.basepath, spath);

                    if isempty(fieldnames(temp_session))
                        error('ICP_Base:sessionLoadFailed', ...
                            ['No session data found at %s. The session list is out of sync with the H5 file; ' ...
                            'the session was not loaded.'], spath);
                    end

                    if isfield(temp_session, 'spot') && isfield(temp_session.spot, 'eliminated_spikes') && istable(temp_session.spot.eliminated_spikes)
                        nSpots = numel(temp_session.spot.name);
                        temp_session.spot.eliminated_spikes = unflatten_eliminated_spikes(app, temp_session.spot.eliminated_spikes, nSpots);
                    end
                    if isfield(temp_session, 'spot') && isfield(temp_session.spot, 'signal_data') && isstruct(temp_session.spot.signal_data) && isfield(temp_session.spot.signal_data, 'is_flat_signal_data')
                        temp_session.spot.signal_data = unflatten_signal_data(app, temp_session.spot.signal_data);
                    end
                    if isfield(temp_session, 'referencematerials') && isfield(temp_session.referencematerials, 'is_flat_referencematerials')
                        temp_session.referencematerials = unflatten_referencematerials(app, temp_session.referencematerials);
                    end

                    skel = app.base(pid).project(sel_session).session;
                    temp_session.session_name = skel.session_name;

                    % the skeleton only holds the four session-table fields; the rest of meta
                    % (laser/ICP-MS parameters, comments, ...) comes from the file and must stay
                    for fn = ["session_comment", "date", "analyst", "processed_by"]
                        if isfield(skel, 'meta') && isfield(skel.meta, fn)
                            temp_session.meta.(fn) = skel.meta.(fn);
                        end
                    end

                    if ~isfield(temp_session, 'meta'), temp_session.meta = struct(); end

                    if isfield(skel.config, 'module_status')
                        temp_session.config.module_status = skel.config.module_status;
                    end
                    temp_session.config.synced  = false;
                    temp_session.config.loaded  = true;
                    temp_session.config.in_h5   = false;

                    app.base(pid).project(new_sid)         = app.base(pid).project(sel_session);
                    app.base(pid).project(new_sid).session = temp_session;

                    delete(progress)
                else
                    app.base(pid).project(new_sid) = app.base(pid).project(sel_session);
                    app.base(pid).project(new_sid).session.config.synced = false;
                    app.base(pid).project(new_sid).session.config.loaded = true;
                    app.base(pid).project(new_sid).session.config.in_h5  = false;
                end

            catch ME
                if exist('progress', 'var') && isvalid(progress)
                    delete(progress)
                end
                DisplayError(ME, 'Duplicating session failed')
            end

            update_session_table(app, pid)

        end

        % Button pushed function: TableBuilderVisModuleButton
        function TableBuilderVisModuleButtonPushed(app, event)

            Table_builder_Submodule(app)
        
        end

        % Menu selected function: ExportProjectMenu
        function ExportProjectMenuSelected2(app, event)

            pid = app.LastSelectedProjectRow;
            if isempty(pid), return; end

            if project_has_open_module(app, pid)
                uialert(app.UIFigure, ...
                    'A module window for a session of this project is open. Close it first, so the export contains your latest changes.', ...
                    'Project in Use', 'Icon', 'warning');
                return
            end

            [fname, fpath] = uiputfile('*.h5', 'Export project to');
            if isequal(fname, 0), return; end

            [~, fname_clean, ~] = fileparts(fname);
            outpath = fullfile(fpath, [fname_clean '_project.h5']);

            n = numel(app.base(pid).project);
            needed_load = false(1, n);   % before try
            pending_sessions = cell(1, n);

            progress = uiprogressdlg(app.UIFigure, 'Title', 'Exporting project', ...
                'Message', 'Writing sessions...', 'Indeterminate', 'on');

            try
                % start from an empty file, an existing one would make the writes fail halfway
                if isfile(outpath), delete(outpath); end

                for j = 1:n
                    if ~app.base(pid).project(j).session.config.loaded
                        pending_sessions{j} = app.base(pid).project(j).session;
                        h52session(app, pid, j);

                        % h52session only reports a failed load on screen and puts the skeleton back
                        if ~app.base(pid).project(j).session.config.loaded
                            error('ICP_Base:sessionLoadFailed', ...
                                'Session %d "%s" could not be loaded from the base file.', ...
                                j, char(pending_sessions{j}.session_name));
                        end

                        app.base(pid).project(j).session.session_name = pending_sessions{j}.session_name;
                        for fn = ["session_comment", "date", "analyst", "processed_by"]
                            if isfield(pending_sessions{j}, 'meta') && isfield(pending_sessions{j}.meta, fn)
                                app.base(pid).project(j).session.meta.(fn) = pending_sessions{j}.meta.(fn);
                            end
                        end
                        needed_load(j) = true;
                    end
                    sess = app.base(pid).project(j).session;
                    if isfield(sess, 'config') && isfield(sess.config, 'last_accessed')
                        sess.config = rmfield(sess.config, 'last_accessed');
                    end
                    if isfield(sess, 'spot') && isfield(sess.spot, 'eliminated_spikes') && iscell(sess.spot.eliminated_spikes)
                        sess.spot.eliminated_spikes = flatten_eliminated_spikes(app, sess.spot.eliminated_spikes);
                    end
                    if isfield(sess, 'spot') && isfield(sess.spot, 'signal_data') && iscell(sess.spot.signal_data)
                        sess.spot.signal_data = flatten_signal_data(app, sess.spot.signal_data);
                    end
                    if isfield(sess, 'referencematerials') && isfield(sess.referencematerials, 'data') && isfield(sess.referencematerials, 'uncertainty')
                        sess.referencematerials = flatten_referencematerials(app, sess.referencematerials);
                    end
                    spath = sprintf('/1_project/%d_session', j);
                    writeStructToH5(app, sess, outpath, spath);
                end
                pname = app.base(pid).project_name;
                h5writeStrVal(app, outpath, '/1_project/project_name', pname);

                for j = find(needed_load)
                    sess = app.base(pid).project(j).session;
                    skeleton = struct();
                    skeleton.session_name = sess.session_name;
                    if isfield(sess, 'meta'), skeleton.meta = sess.meta; end
                    skeleton.config.synced = pending_sessions{j}.config.synced;
                    skeleton.config.loaded = false;
                    skeleton.config.in_h5  = true;
                    if isfield(sess.config, 'module_status')
                        skeleton.config.module_status = sess.config.module_status;
                    end
                    app.base(pid).project(j).session = skeleton;
                end
                delete(progress);
            catch ME
                for j = find(needed_load)
                    sess = app.base(pid).project(j).session;
                    skeleton = struct();
                    skeleton.session_name = sess.session_name;
                    if isfield(sess, 'meta'), skeleton.meta = sess.meta; end
                    skeleton.config.synced = pending_sessions{j}.config.synced;
                    skeleton.config.loaded = false;
                    skeleton.config.in_h5  = true;
                    if isfield(sess.config, 'module_status')
                        skeleton.config.module_status = sess.config.module_status;
                    end
                    app.base(pid).project(j).session = skeleton;
                end
                delete(progress);

                % never leave an incomplete export file behind
                if isfile(outpath)
                    try delete(outpath), catch, end
                end
                DisplayError(ME, 'Exporting project failed');
                uialert(app.UIFigure, ['The project was not exported. ' ME.message], ...
                    'Export Failed', 'Icon', 'error');
            end

        end

        % Menu selected function: ImportProjectsMenu
        function ImportProjectsMenuSelected(app, event)
            if app.basepath == ""
                answer = uiconfirm(app.UIFigure, ...
                    ['No base is currently open. A base (.h5) is needed to import projects into.' ...
                    ' Please choose a location and filename for the base.'], ...
                    'Create New Base', 'Options', {'OK', 'Cancel'}, ...
                    'DefaultOption', 'OK', 'CancelOption', 'Cancel', 'Icon', 'info');
                if strcmp(answer, 'Cancel'), return; end

                f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
                [filename, filepath] = uiputfile('*.h5', 'Create new base file:');
                delete(f);
                figure(app.UIFigure);
                if isequal(filename, 0), return; end
                [~, fname, ~] = fileparts(filename);
                app.basepath = fullfile(filepath, [fname '.h5']);
                if isfile(app.basepath)
                    delete(app.basepath);
                end

                uiconfirm(app.UIFigure, ...
                    sprintf('New base created at:\n\n%s\n\nNow select the project file(s) to import.', app.basepath), ...
                    'Base Created', 'Options', {'OK'}, 'DefaultOption', 'OK', 'Icon', 'info');
            end


            f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
            [file, path] = uigetfile({'*.h5', 'H5 Base Files (*.h5)'}, "MultiSelect", "on", 'Import Project(s)');
            delete(f);
            figure(app.UIFigure);

            if isequal(file, 0), return; end
            if ischar(file), file = {file}; end

            badFiles = {};
            for i = 1:numel(file)
                try
                    h5info(fullfile(path, file{i}), '/1_project');
                catch
                    badFiles{end+1} = file{i};
                end
            end
            if ~isempty(badFiles)
                uialert(app.UIFigure, ...
                    sprintf('The following files do not appear to be exported project files:\n\n%s', ...
                    strjoin(badFiles, '\n')), ...
                    'Invalid File(s)', 'Icon', 'error');
                return;
            end

            progress = uiprogressdlg(app.UIFigure, 'Title', 'Importing Project(s)...', ...
                'Message', 'This may take a few seconds.', 'Cancelable', 'off', 'Indeterminate', 'on');

            try
                base_count = numel(app.base);

                for i = 1:numel(file)
                    new_pid  = base_count + i;
                    src_path = fullfile(path, file{i});

                    app.base(new_pid).project_name = h5readStr(app, src_path, '/1_project/project_name');
                    h5writeStrVal(app, app.basepath, sprintf('/%d_project/project_name', new_pid), app.base(new_pid).project_name);

                    pInfo   = h5info(src_path, '/1_project');
                    sGroups = h5sessionGroups(app, pInfo.Groups);

                    for j = 1:numel(sGroups)
                        temp_session = readH5Group(app, src_path, sGroups(j).Name);
                        if isfield(temp_session, 'spot') && isfield(temp_session.spot, 'eliminated_spikes') && istable(temp_session.spot.eliminated_spikes)
                            nSpots = numel(temp_session.spot.name);
                            temp_session.spot.eliminated_spikes = unflatten_eliminated_spikes(app, temp_session.spot.eliminated_spikes, nSpots);
                        end
                        if isfield(temp_session, 'spot') && isfield(temp_session.spot, 'signal_data') && isstruct(temp_session.spot.signal_data) && isfield(temp_session.spot.signal_data, 'is_flat_signal_data')
                            temp_session.spot.signal_data = unflatten_signal_data(app, temp_session.spot.signal_data);
                        end
                        if isfield(temp_session, 'referencematerials') && isfield(temp_session.referencematerials, 'is_flat_referencematerials')
                            temp_session.referencematerials = unflatten_referencematerials(app, temp_session.referencematerials);
                        end

                        if ~isfield(temp_session, 'meta'), temp_session.meta = struct(); end

                        temp_session.config.synced = false;
                        temp_session.config.loaded = true;
                        temp_session.config.in_h5 = false;

                        app.base(new_pid).project(j).session = temp_session;
                    end

                    if ~isfield(app.base(new_pid), 'project') || isempty(app.base(new_pid).project)
                        app.base(new_pid) = [];  % remove the incomplete entry

                        % the H5 group for this empty project (project_name only) was
                        % already written — remove it so the slot is free for the
                        % next file in this batch, keeping in-memory/H5 indices aligned
                        try
                            fid = H5F.open(app.basepath, 'H5F_ACC_RDWR', 'H5P_DEFAULT');
                            try
                                H5L.delete(fid, sprintf('/%d_project', new_pid), 'H5P_DEFAULT');
                            catch
                            end
                            H5F.close(fid);
                        catch
                        end

                        uialert(app.UIFigure, ...
                            sprintf('"%s" contains no sessions and was not imported.', file{i}), ...
                            'Empty Project', 'Icon', 'warning');
                        base_count = base_count - 1;  % keep the counter consistent
                    end

                end

            catch ME
                delete(progress)
                DisplayError(ME, 'Importing project(s) failed')
                return
            end

            delete(progress)
            update_project_table(app)
        end

        % Menu selected function: ImportSessionsMenu
        function ImportSessionsMenuSelected(app, event)
            if isempty(app.LastSelectedProjectRow)
                uialert(app.UIFigure, "No project selected", "Warning", "Icon", "warning");
                return
            end

            f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
            [file, path] = uigetfile({'*.h5', 'H5 Session Files (*.h5)'}, "MultiSelect", "on", 'Import Session(s)');
            delete(f);
            figure(app.UIFigure);

            if isequal(file, 0), return; end
            if ischar(file), file = {file}; end

            badFiles = {};
            for i = 1:numel(file)
                try
                    h5info(fullfile(path, file{i}), '/1_session');
                catch
                    badFiles{end+1} = file{i};
                end
            end
            if ~isempty(badFiles)
                uialert(app.UIFigure, ...
                    sprintf('The following files do not appear to be exported session files:\n\n%s', ...
                    strjoin(badFiles, '\n')), ...
                    'Invalid File(s)', 'Icon', 'error');
                return;
            end

            progress = uiprogressdlg(app.UIFigure, 'Title', 'Importing Session(s)...', ...
                'Message', 'This may take a few seconds.', 'Cancelable', 'off', 'Indeterminate', 'on');

            try
                pid           = app.LastSelectedProjectRow;
                session_count = numel(app.base(pid).project);
                if ~isfield(app.base(pid).project, 'session'), session_count = 0; end

                for i = 1:numel(file)
                    new_sid      = session_count + i;
                    temp_session = readH5Group(app, fullfile(path, file{i}), '/1_session');
                    if isfield(temp_session, 'spot') && isfield(temp_session.spot, 'eliminated_spikes') && istable(temp_session.spot.eliminated_spikes)
                        nSpots = numel(temp_session.spot.name);
                        temp_session.spot.eliminated_spikes = unflatten_eliminated_spikes(app, temp_session.spot.eliminated_spikes, nSpots);
                    end
                    if isfield(temp_session, 'spot') && isfield(temp_session.spot, 'signal_data') && isstruct(temp_session.spot.signal_data) && isfield(temp_session.spot.signal_data, 'is_flat_signal_data')
                        temp_session.spot.signal_data = unflatten_signal_data(app, temp_session.spot.signal_data);
                    end
                    if isfield(temp_session, 'referencematerials') && isfield(temp_session.referencematerials, 'is_flat_referencematerials')
                        temp_session.referencematerials = unflatten_referencematerials(app, temp_session.referencematerials);
                    end

                    if ~isfield(temp_session, 'meta'), temp_session.meta = struct(); end

                    temp_session.config.synced = false;
                    temp_session.config.loaded = true;
                    temp_session.config.in_h5 = false;
                    app.base(pid).project(new_sid).session = temp_session;
                end

            catch ME
                delete(progress)
                DisplayError(ME, 'Importing session(s) failed')
                return
            end

            delete(progress)
            update_session_table(app, pid)
        end

        % Menu selected function: ExportSessionMenu
        function ExportSessionMenuSelected(app, event)
                       if isempty(app.LastSelectedProjectRow)
                uialert(app.UIFigure, "No project selected", "Warning", "Icon", "warning");
                return
            end
            if isempty(app.SessionTable.Selection)
                uialert(app.UIFigure, "No session selected", "Warning", "Icon", "warning");
                return
            end

            pid = app.LastSelectedProjectRow;
            sid = app.SessionTable.Selection(1);

            if session_has_open_module(app, pid, sid)
                uialert(app.UIFigure, ...
                    'A module window for this session is open. Close it first, so the export contains your latest changes.', ...
                    'Session in Use', 'Icon', 'warning');
                return
            end

            f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
            [filename, filepath] = uiputfile('*.h5', 'Save the session file:');
            delete(f);
            figure(app.UIFigure);

            if isequal(filename, 0), return; end

            [~, fname, ~] = fileparts(filename);
            dst_path = fullfile(filepath, [fname '_session.h5']);

            progress = uiprogressdlg(app.UIFigure, 'Title', 'Exporting Session...', ...
                'Message', 'This may take a few seconds.', 'Cancelable', 'off', 'Indeterminate', 'on');

            export_started = false;
            try
                needed_load = ~app.base(pid).project(sid).session.config.loaded;
                pending = [];
                if needed_load
                    pending = app.base(pid).project(sid).session;
                    h52session(app, pid, sid);

                    % h52session only reports a failed load on screen and puts the skeleton back
                    if ~app.base(pid).project(sid).session.config.loaded
                        error('ICP_Base:sessionLoadFailed', ...
                            'The session could not be loaded from the base file.');
                    end

                    app.base(pid).project(sid).session.session_name = pending.session_name;
                    for fn = ["session_comment", "date", "analyst", "processed_by"]
                        if isfield(pending, 'meta') && isfield(pending.meta, fn)
                            app.base(pid).project(sid).session.meta.(fn) = pending.meta.(fn);
                        end
                    end
                end

                if exist(dst_path, 'file') == 2, delete(dst_path); end
                export_started = true;

                sess = app.base(pid).project(sid).session;
                if isfield(sess, 'config') && isfield(sess.config, 'last_accessed')
                    sess.config = rmfield(sess.config, 'last_accessed');
                end
                if isfield(sess, 'spot') && isfield(sess.spot, 'eliminated_spikes') && iscell(sess.spot.eliminated_spikes)
                    sess.spot.eliminated_spikes = flatten_eliminated_spikes(app, sess.spot.eliminated_spikes);
                end
                if isfield(sess, 'spot') && isfield(sess.spot, 'signal_data') && iscell(sess.spot.signal_data)
                    sess.spot.signal_data = flatten_signal_data(app, sess.spot.signal_data);
                end
                if isfield(sess, 'referencematerials') && isfield(sess.referencematerials, 'data') && isfield(sess.referencematerials, 'uncertainty')
                    sess.referencematerials = flatten_referencematerials(app, sess.referencematerials);
                end

                writeStructToH5(app, sess, dst_path, '/1_session');

                if needed_load
                    skeleton = struct();
                    skeleton.session_name = sess.session_name;
                    if isfield(sess, 'meta'), skeleton.meta = sess.meta; end
                    skeleton.config.synced = pending.config.synced;
                    skeleton.config.loaded = false;
                    if isfield(sess.config, 'module_status')
                        skeleton.config.module_status = sess.config.module_status;
                    end
                    app.base(pid).project(sid).session = skeleton;
                end

                delete(progress)
            catch ME
                delete(progress)
                % never leave an incomplete export file behind
                if export_started && isfile(dst_path)
                    try delete(dst_path), catch, end
                end
                DisplayError(ME, 'Exporting session failed')
                uialert(app.UIFigure, ['The session was not exported. ' ME.message], ...
                    'Export Failed', 'Icon', 'error');
            end
        end

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            try

                % no module windows or Table Builder may be open
                figs = findall(groot, 'Type', 'figure');
                tags = get(figs, 'Tag');
                if ~iscell(tags), tags = {tags}; end
                if any(~cellfun(@isempty, tags) & ...
                        (cellfun(@(t) ~isempty(regexp(t, '^\d+_\d+$', 'once')), tags) | strcmp(tags, "tablebuilder")))
                    uialert(app.UIFigure, ...
                        'Close all open module windows (and the Table Builder, if open) before closing ICP-Base. Otherwise their unsaved changes are lost.', ...
                        'Cannot Close', 'Icon', 'warning');
                    return
                end

                msg_lines    = {};
                unsynced     = zeros(0, 2);   % rows of [pid, sid]
                unsynced_nm  = {};
                if ~isempty(app.base) && isfield(app.base, 'project')
                    for i = 1:numel(app.base)
                        names = {};
                        for j = 1:numel(app.base(i).project)
                            if ~isfield(app.base(i).project(j), 'session') ...
                                    || ~isfield(app.base(i).project(j).session, 'config')
                                continue
                            end
                            cfg = app.base(i).project(j).session.config;
                            if isfield(cfg, 'synced') && ~cfg.synced
                                if isfield(app.base(i).project(j).session, 'session_name')
                                    sname = char(app.base(i).project(j).session.session_name);
                                else
                                    sname = sprintf('(session %d)', j);
                                end
                                names{end+1}       = sname;
                                unsynced(end+1, :) = [i, j];
                                unsynced_nm{end+1} = sname;
                            end
                        end
                        if ~isempty(names)
                            if isfield(app.base(i), 'project_name') && ~isempty(app.base(i).project_name)
                                pname = char(app.base(i).project_name);
                            else
                                pname = sprintf('(project %d)', i);
                            end
                            msg_lines{end+1} = sprintf('  %s: %s', pname, strjoin(names, ', '));
                        end
                    end
                end

                if ~isempty(msg_lines)
                    msg = sprintf(['The following sessions have uncommitted changes:\n\n%s\n\n' ...
                        'Do you want to save them to the base (h5 file) before closing?'], strjoin(msg_lines, '\n'));
                    answer = uiconfirm(app.UIFigure, msg, 'Uncommitted Sessions', ...
                        'Options', {'Save all', 'Close without saving', 'Cancel'}, ...
                        'DefaultOption', 'Save all', 'CancelOption', 'Cancel', 'Icon', 'warning');

                    switch answer
                        case 'Cancel'
                            return

                        case 'Save all'
                            if app.basepath == "" || ~isfile(app.basepath)
                                uialert(app.UIFigure, ...
                                    'No base file is connected, so the sessions cannot be saved. Create a base first (Add Project), or close without saving.', ...
                                    'Cannot Save', 'Icon', 'warning');
                                return
                            end

                            progress = uiprogressdlg(app.UIFigure, 'Title', 'Saving sessions...', ...
                                'Message', 'Saving all unsaved sessions to the base.', ...
                                'Cancelable', 'off', 'Indeterminate', 'on');

                            failed = {};
                            for r = 1:size(unsynced, 1)
                                pid = unsynced(r,1);
                                sid = unsynced(r,2);
                                try
                                    sess = app.base(pid).project(sid).session;

                                    if isfield(sess.config, 'loaded') && sess.config.loaded
                                        save_session_to_h5(app, pid, sid);

                                        skeleton.session_name = sess.session_name;
                                        if isfield(sess, 'meta'), skeleton.meta = sess.meta; end
                                        skeleton.config.synced = true;
                                        skeleton.config.loaded = false;
                                        skeleton.config.in_h5  = true;
                                        if isfield(sess.config, 'module_status')
                                            skeleton.config.module_status = sess.config.module_status;
                                        end
                                        if isfield(sess.config, 'reductiontype')
                                            skeleton.config.reductiontype = sess.config.reductiontype;
                                        end
                                        app.base(pid).project(sid).session = skeleton;
                                        clear skeleton

                                    else
                                        spath = sprintf('/%d_project/%d_session', pid, sid);
                                        h5writeStrVal(app, app.basepath, [spath '/session_name'], sess.session_name);
                                        if isfield(sess, 'meta')
                                            for fn = ["session_comment", "date", "analyst", "processed_by"]
                                                if isfield(sess.meta, char(fn))
                                                    h5writeStrVal(app, app.basepath, [spath '/meta/' char(fn)], sess.meta.(char(fn)));
                                                end
                                            end
                                        end
                                        app.base(pid).project(sid).session.config.synced = true;
                                        app.base(pid).project(sid).session.config.in_h5  = true;
                                    end

                                catch ME
                                    DisplayError(ME, sprintf('Saving session [%d,%d] failed', pid, sid));
                                    failed{end+1} = unsynced_nm{r};
                                end
                            end
                            delete(progress)

                            if ~isempty(failed)
                                sel2 = uiconfirm(app.UIFigure, ...
                                    sprintf(['These sessions could not be saved:\n\n%s\n\n' ...
                                    'Close anyway (their unsaved changes will be lost), or cancel and stay open?'], ...
                                    strjoin(failed, '\n')), ...
                                    'Save Incomplete', 'Options', {'Close anyway', 'Cancel'}, ...
                                    'DefaultOption', 'Cancel', 'CancelOption', 'Cancel', 'Icon', 'warning');
                                if strcmp(sel2, 'Cancel'), return; end
                            end

                        case 'Close without saving'
                            % fall through to close
                    end
                end

                renumber_h5_fully(app)
                delete(app);

            catch ME
                DisplayError(ME, 'Closing ICP-Base failed');
                try
                    answer_error = uiconfirm(app.UIFigure, ...
                        ['Closing ICP-Base ran into an error, so unsaved changes may not have been saved. ' ...
                        'Close anyway? Details: ' ME.message], ...
                        'Closing Failed', 'Options', {'Stay open', 'Close anyway'}, ...
                        'DefaultOption', 'Stay open', 'CancelOption', 'Stay open', 'Icon', 'warning');
                    if strcmp(answer_error, 'Close anyway')
                        delete(app)
                    end
                catch
                    delete(app)     % even the dialog failed: do not leave an app that cannot be closed
                end
            end
        end

        % Callback function
        function Saveh5MenuSelected(app, event)
            
            progress = uiprogressdlg(app.UIFigure, 'Title', 'Saving Base...', ...
                'Message', 'This may take a few seconds', 'Cancelable', 'off', 'Indeterminate','on');


            if isfield(app.base, 'meta') && isfield(app, 'basepath') && not(isempty(app.basepath))
                app.UIFigure.Name = [app.basepath ' [... Saving Base]'] ;

                data2save.base = app.base;
                try


                    save(app.basepath, 'data2save', '-v7.3', '-nocompression'); %



                catch

                    message = "Saving the base failed. Did you change the file location of the base (.h5) file? Use the 'Save Base as' option.";
                    uialert(app.UIFigure,message,"Warning", ...
                        "Icon","warning");

                end

                app.UIFigure.Name = app.basepath;

            else
                SaveBaseasMenuSelected(app)
            end

            if isfield(app.base,'meta') && isfield(app, 'basepath')

                app.UIFigure.Name = app.basepath;

            end

            delete(progress)




        end

        % Callback function
        function Saveash5MenuSelected(app, event)
            
            f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
            [filename, filepath] = uiputfile('*.h5', 'Save the base file:');
            delete(f);
            figure(app.UIFigure);

            if not(isequal(filename,0))

                %progress = uiprogressdlg(app.UIFigure, 'Title', 'Saving Base...', ...
                %    'Message', 'This may take a few seconds', 'Cancelable', 'off', 'Indeterminate','on');

                FileName = fullfile(filepath, filename);
                app.basepath = FileName;
                app.UIFigure.Name = [app.basepath ' [... Saving Base]'] ;


                base2h5(app, app.base, FileName)

                

                app.UIFigure.Name = app.basepath;

                %delete(progress)
            end
        end

        % Button pushed function: SaveselectedSessiontoBaseButton
        function SaveselectedSessiontoBaseButtonPushed(app, event)
            if isempty(app.SessionTable.Selection) || isequal(app.SessionTable.Selection(1), 0)
                return
            end

            session_id = app.SessionTable.Selection(1);
            project_id = app.LastSelectedProjectRow;

            if isempty(project_id) || app.basepath == ""
                return
            end

            try
                progress = uiprogressdlg(app.UIFigure, 'Title', 'Saving Session...', ...
                    'Message', 'Please wait.', 'Cancelable', 'off', 'Indeterminate', 'on');

                sess = app.base(project_id).project(session_id).session;

                if sess.config.loaded
                    save_session_to_h5(app, project_id, session_id);

                    skeleton.session_name = sess.session_name;
                    if isfield(sess, 'meta')
                        skeleton.meta = sess.meta;
                    end
                    skeleton.config.synced = true;
                    skeleton.config.loaded = false;
                    skeleton.config.in_h5  = true;
                    if isfield(sess.config, 'module_status')
                        skeleton.config.module_status = sess.config.module_status;
                    end
                    if isfield(sess.config, 'reductiontype')
                        skeleton.config.reductiontype = sess.config.reductiontype;
                    end
                    app.base(project_id).project(session_id).session = skeleton;

                else
                    spath = sprintf('/%d_project/%d_session', project_id, session_id);
                    h5writeStrVal(app, app.basepath, [spath '/session_name'], sess.session_name);
                    if isfield(sess, 'meta')
                        for fn = ["session_comment", "date", "analyst", "processed_by"]
                            if isfield(sess.meta, char(fn))
                                h5writeStrVal(app, app.basepath, [spath '/meta/' char(fn)], sess.meta.(char(fn)));
                            end
                        end
                    end
                    app.base(project_id).project(session_id).session.config.synced = true;
                    app.base(project_id).project(session_id).session.config.in_h5  = true;
                end

                update_session_table(app, project_id);
                app.SaveselectedSessiontoBaseButton.Enable = false;
                app.RestoreselectedSessionButton.Enable    = false;

                delete(progress)
            catch ME
                DisplayError(ME, 'Saving session failed');
                delete(progress)
            end
        end

        % Button pushed function: RestoreselectedSessionButton
        function RestoreselectedSessionButtonPushed(app, event)
            if isempty(app.SessionTable.Selection) || isequal(app.SessionTable.Selection(1), 0)
                return
            end

            session_id = app.SessionTable.Selection(1);
            project_id = app.LastSelectedProjectRow;

            if isempty(project_id) || app.basepath == ""
                return
            end

            sname = char(app.base(project_id).project(session_id).session.session_name);

            answer = uiconfirm(app.UIFigure, ...
                sprintf(['Restore session %d "%s"?\n\nAll changes since this session was last saved to the base (h5 file) ' ...
                'are discarded and the saved version is loaded back.\n\nThis cannot be undone.'], session_id, sname), ...
                'Restore Session', ...
                'Options', {'Restore', 'Cancel'}, ...
                'DefaultOption', 'Cancel', 'CancelOption', 'Cancel', 'Icon', 'warning');

            if strcmp(answer, 'Cancel')
                return
            end

            try
                spath = sprintf('/%d_project/%d_session', project_id, session_id);

                % the saved version must exist, otherwise there is nothing to restore
                try
                    h5info(app.basepath, spath);
                catch
                    uialert(app.UIFigure, ...
                        'This session was not found in the base file, so it cannot be restored. Nothing was changed.', ...
                        'Restore Failed', 'Icon', 'error');
                    return
                end

                skeleton.session_name = h5readStr(app, app.basepath, [spath '/session_name']);

                skeleton.meta = struct();
                for fn = ["session_comment", "date", "analyst", "processed_by"]
                    try
                        raw = h5read(app.basepath, [spath '/meta/' char(fn)]);
                        if iscell(raw), raw = raw{1}; end
                        skeleton.meta.(char(fn)) = string(raw);
                    catch
                    end
                end

                msPath = [spath '/config/module_status'];
                try
                    msInfo = h5info(app.basepath, msPath);
                    for k = 1:numel(msInfo.Datasets)
                        dsname = msInfo.Datasets(k).Name;
                        skeleton.config.module_status.(dsname) = h5read(app.basepath, [msPath '/' dsname]);
                    end
                catch
                end

                try
                    raw = h5read(app.basepath, [spath '/config/reductiontype']);
                    if iscell(raw), raw = raw{1}; end
                    skeleton.config.reductiontype = string(raw);
                catch
                end

                skeleton.config.synced = true;
                skeleton.config.loaded = false;

                app.base(project_id).project(session_id).session = skeleton;
                update_session_table(app, project_id);
                update_progress_buttons(app, project_id, session_id)

                app.SaveselectedSessiontoBaseButton.Enable = false;
                app.RestoreselectedSessionButton.Enable    = false;

            catch ME
                DisplayError(ME, 'Restoring session failed');
            end
        end

        % Menu selected function: NewBaseMenu
        function NewBaseMenuSelected(app, event)
            

            figs = findall(groot, 'Type', 'figure');
            tags = get(figs, 'Tag');
            if ~iscell(tags), tags = {tags}; end
            if any(~cellfun(@isempty, tags) & ...
                    (cellfun(@(t) ~isempty(regexp(t, '^\d+_\d+$', 'once')), tags) | strcmp(tags, "tablebuilder")))
                uialert(app.UIFigure, ...
                    'Close all open module windows (and the Table Builder, if open) before starting a new base. Switching bases while a module is open can corrupt data if that module is saved afterward.', ...
                    'Cannot Start New Base', 'Icon', 'warning');
                return
            end

            msg_lines = {};
            if ~isempty(app.base) && isfield(app.base, 'project')
                for i = 1:numel(app.base)
                    names = {};
                    for j = 1:numel(app.base(i).project)
                        if ~isfield(app.base(i).project(j), 'session') ...
                                || ~isfield(app.base(i).project(j).session, 'config')
                            continue
                        end

                        cfg = app.base(i).project(j).session.config;
                        if isfield(cfg, 'synced') && ~cfg.synced
                            if isfield(app.base(i).project(j).session, 'session_name')
                                names{end+1} = char(app.base(i).project(j).session.session_name);
                            else
                                names{end+1} = sprintf('(session %d)', j);
                            end
                        end

                    end
                    if ~isempty(names)
                        msg_lines{end+1} = sprintf('  %s: %s', char(app.base(i).project_name), strjoin(names, ', '));
                    end
                end
            end

            if ~isempty(msg_lines)
                msg = sprintf('The following sessions have unsaved changes. Starting a new base will discard them (the current base file on disk is not affected, but anything not yet saved will be lost):\n\n%s', strjoin(msg_lines, '\n'));
                answer = uiconfirm(app.UIFigure, msg, 'Unsaved Sessions', ...
                    'Options', {'Start new base anyway', 'Cancel'}, ...
                    'DefaultOption', 'Cancel', 'CancelOption', 'Cancel', 'Icon', 'warning');
                if strcmp(answer, 'Cancel'), return; end
            else
                answer = uiconfirm(app.UIFigure, ...
                    'This will close the current base and start a fresh, empty one. Are you sure?', ...
                    'Start New Base', 'Options', {'Start new base', 'Cancel'}, ...
                    'DefaultOption', 'Cancel', 'CancelOption', 'Cancel');
                if strcmp(answer, 'Cancel'), return; end
            end

            app.base = struct([]);
            app.basepath = "";

            app.SessionTable.Data = {};
            app.LastSelectedProjectRow = [];
            app.SaveselectedSessiontoBaseButton.Enable = false;
            app.RestoreselectedSessionButton.Enable    = false;
            app.ImportButton.Visible = "off";
            app.IntervalButton.Visible = "off";
            app.ClassificationButton.Visible = "off";
            app.DriftButton.Visible = "off";
            app.QuantificationButton.Visible = "off";
            app.ResultsButton.Visible = "off";
            app.DuplicateSessionButton.Visible = "off";
            app.DeleteSessionButton.Visible = "off";

            update_project_table(app)


        end

        % Menu selected function: CompactBaseMenu
        function CompactBaseMenuSelected(app, event)
                       % must have a real .h5 base connected
            [~,~,bext] = fileparts(app.basepath);
            if app.basepath == "" || ~strcmp(bext, '.h5') || ~isfile(app.basepath)
                uialert(app.UIFigure, 'No base file is connected, so there is nothing to compact.', ...
                    'Compact Base', 'Icon', 'warning');
                return
            end

            % same guard as Open/New Base: no module windows or Table Builder open
            figs = findall(groot, 'Type', 'figure');
            tags = get(figs, 'Tag');
            if ~iscell(tags), tags = {tags}; end
            if any(~cellfun(@isempty, tags) & ...
                    (cellfun(@(t) ~isempty(regexp(t, '^\d+_\d+$', 'once')), tags) | strcmp(tags, "tablebuilder")))
                uialert(app.UIFigure, ...
                    'Close all open module windows (and the Table Builder, if open) before compacting the base.', ...
                    'Cannot Compact Base', 'Icon', 'warning');
                return
            end

            % refuse if any session has unsaved changes (must be saved or discarded first)
            unsaved = {};
            if ~isempty(app.base) && isfield(app.base, 'project')
                for i = 1:numel(app.base)
                    for j = 1:numel(app.base(i).project)
                        if ~isfield(app.base(i).project(j), 'session') ...
                                || ~isfield(app.base(i).project(j).session, 'config')
                            continue
                        end
                        cfg = app.base(i).project(j).session.config;
                        if isfield(cfg, 'synced') && ~cfg.synced
                            if isfield(app.base(i).project(j).session, 'session_name')
                                unsaved{end+1} = char(app.base(i).project(j).session.session_name); %#ok
                            else
                                unsaved{end+1} = sprintf('(session %d)', j); %#ok
                            end
                        end
                    end
                end
            end
            if ~isempty(unsaved)
                uialert(app.UIFigure, ...
                    sprintf(['These sessions have unsaved changes:\n\n%s\n\n' ...
                    'Save them (Save selected Session to Base) or discard them (Restore selected Session) ' ...
                    'before compacting.'], strjoin(unsaved, '\n')), ...
                    'Unsaved Changes', 'Icon', 'warning');
                return
            end

            % sizes and free space
            d = dir(app.basepath); srcBytes = d.bytes;
            [fdir, fname, fext] = fileparts(char(app.basepath));
            try
                freeBytes = double(java.io.File(fdir).getUsableSpace());
            catch
                freeBytes = -1;
            end

            % free-space precheck (need up to the current file size, temporarily)
            if freeBytes >= 0 && freeBytes < srcBytes
                uialert(app.UIFigure, ...
                    sprintf(['Not enough free disk space to compact safely.\n\nNeeded (temporarily): %.2f GB\n' ...
                    'Available: %.2f GB\n\nFree up space and try again.'], srcBytes/1024^3, freeBytes/1024^3), ...
                    'Insufficient Disk Space', 'Icon', 'error');
                return
            end

            onedrive_note = '';
            if contains(lower(app.basepath), 'onedrive')
                onedrive_note = sprintf(['\n\nNote: this base is in a OneDrive folder. Compacting rewrites the ' ...
                    'whole file, which OneDrive will then re-upload in full — this can take a long time and use ' ...
                    'a lot of bandwidth.']);
            end

            msg = sprintf(['Compacting reclaims space wasted by past saves and deletions by rewriting the base ' ...
                'into a fresh file. Your data is unchanged.\n\nCurrent size: %.2f GB\n' ...
                'Free space used temporarily: up to %.2f GB\n\nThis can take several minutes for a large base. ' ...
                'A backup copy is kept until it completes successfully.%s\n\nProceed?'], ...
                srcBytes/1024^3, srcBytes/1024^3, onedrive_note);

            answer = uiconfirm(app.UIFigure, msg, 'Compact Base', ...
                'Options', {'Compact', 'Cancel'}, 'DefaultOption', 'Cancel', ...
                'CancelOption', 'Cancel', 'Icon', 'question');
            if ~strcmp(answer, 'Compact'), return; end

            progress = uiprogressdlg(app.UIFigure, 'Title', 'Compacting Base...', ...
                'Message', 'Preparing...', 'Cancelable', 'off', 'Indeterminate', 'off');
            try
                [before_bytes, after_bytes] = repack_h5(app, progress);
                delete(progress)
                reclaimed = max(0, before_bytes - after_bytes);
                uialert(app.UIFigure, ...
                    sprintf('Base compacted successfully.\n\nBefore: %.2f GB\nAfter:  %.2f GB\nReclaimed: %.2f GB (%.0f%%).', ...
                    before_bytes/1024^3, after_bytes/1024^3, reclaimed/1024^3, ...
                    100 * reclaimed / max(before_bytes, 1)), ...
                    'Compact Base', 'Icon', 'success');
            catch ME
                if exist('progress', 'var') && isvalid(progress), delete(progress); end
                DisplayError(ME, 'Compacting base failed');
                       uialert(app.UIFigure, ...
                    ['Compacting the base failed — your base was NOT modified. A file named "' fname '_backup_<date_time>' fext ...
                    '" may remain next to it; that is a complete copy of your original base and can be opened via ' ...
                    'Open Base if needed. Delete it once you have confirmed the base still opens. Details: ' ME.message], ...
                    'Compact Failed', 'Icon', 'error');
            end





        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1040 666];
            app.UIFigure.Name = 'ICP-Base v1.4.0';
            app.UIFigure.Icon = 'icon_48.png';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create BaseMenu
            app.BaseMenu = uimenu(app.UIFigure);
            app.BaseMenu.Text = 'Base';

            % Create OpenBaseMenu
            app.OpenBaseMenu = uimenu(app.BaseMenu);
            app.OpenBaseMenu.MenuSelectedFcn = createCallbackFcn(app, @OpenBaseMenuSelected, true);
            app.OpenBaseMenu.Text = 'Open Base';

            % Create NewBaseMenu
            app.NewBaseMenu = uimenu(app.BaseMenu);
            app.NewBaseMenu.MenuSelectedFcn = createCallbackFcn(app, @NewBaseMenuSelected, true);
            app.NewBaseMenu.Text = 'New Base';

            % Create CompactBaseMenu
            app.CompactBaseMenu = uimenu(app.BaseMenu);
            app.CompactBaseMenu.MenuSelectedFcn = createCallbackFcn(app, @CompactBaseMenuSelected, true);
            app.CompactBaseMenu.Text = 'Compact Base';

            % Create ProjectMenu
            app.ProjectMenu = uimenu(app.UIFigure);
            app.ProjectMenu.Text = 'Project';

            % Create ImportProjectsMenu
            app.ImportProjectsMenu = uimenu(app.ProjectMenu);
            app.ImportProjectsMenu.MenuSelectedFcn = createCallbackFcn(app, @ImportProjectsMenuSelected, true);
            app.ImportProjectsMenu.Text = 'Import Project(s)';

            % Create ExportProjectMenu
            app.ExportProjectMenu = uimenu(app.ProjectMenu);
            app.ExportProjectMenu.MenuSelectedFcn = createCallbackFcn(app, @ExportProjectMenuSelected2, true);
            app.ExportProjectMenu.Text = 'Export Project';

            % Create SessionMenu
            app.SessionMenu = uimenu(app.UIFigure);
            app.SessionMenu.Text = 'Session';

            % Create ImportSessionsMenu
            app.ImportSessionsMenu = uimenu(app.SessionMenu);
            app.ImportSessionsMenu.MenuSelectedFcn = createCallbackFcn(app, @ImportSessionsMenuSelected, true);
            app.ImportSessionsMenu.Text = 'Import Session(s)';

            % Create ExportSessionMenu
            app.ExportSessionMenu = uimenu(app.SessionMenu);
            app.ExportSessionMenu.MenuSelectedFcn = createCallbackFcn(app, @ExportSessionMenuSelected, true);
            app.ExportSessionMenu.Text = 'Export Session';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {5, 90, '2.48x', 112, 108, '2.5x', '2.5x', 10};
            app.GridLayout.RowHeight = {5, 56, 10, 60, 10, 55, 10, 55, 10, 55, 10, 55, 10, 44, 10, 24, '1x', 25, 5};
            app.GridLayout.RowSpacing = 6.5;
            app.GridLayout.Padding = [10 6.5 10 6.5];

            % Create ImportButton
            app.ImportButton = uibutton(app.GridLayout, 'push');
            app.ImportButton.ButtonPushedFcn = createCallbackFcn(app, @ImportButtonPushed, true);
            app.ImportButton.WordWrap = 'on';
            app.ImportButton.Layout.Row = 4;
            app.ImportButton.Layout.Column = 4;
            app.ImportButton.Text = 'Show Session in Import Module';

            % Create AddSessionButton
            app.AddSessionButton = uibutton(app.GridLayout, 'push');
            app.AddSessionButton.ButtonPushedFcn = createCallbackFcn(app, @AddSessionButtonPushed, true);
            app.AddSessionButton.WordWrap = 'on';
            app.AddSessionButton.Layout.Row = 2;
            app.AddSessionButton.Layout.Column = 4;
            app.AddSessionButton.Text = 'Add Session';

            % Create SessionTable
            app.SessionTable = uitable(app.GridLayout);
            app.SessionTable.ColumnName = '';
            app.SessionTable.RowName = {};
            app.SessionTable.ColumnEditable = [false true true true true true];
            app.SessionTable.CellEditCallback = createCallbackFcn(app, @SessionTableCellEdit, true);
            app.SessionTable.SelectionChangedFcn = createCallbackFcn(app, @SessionTableSelectionChanged, true);
            app.SessionTable.Multiselect = 'off';
            app.SessionTable.Layout.Row = [2 17];
            app.SessionTable.Layout.Column = [5 7];

            % Create DeleteSessionButton
            app.DeleteSessionButton = uibutton(app.GridLayout, 'push');
            app.DeleteSessionButton.ButtonPushedFcn = createCallbackFcn(app, @DeleteSessionButtonPushed, true);
            app.DeleteSessionButton.Layout.Row = 17;
            app.DeleteSessionButton.Layout.Column = 4;
            app.DeleteSessionButton.Text = 'Delete Session';

            % Create IntervalButton
            app.IntervalButton = uibutton(app.GridLayout, 'push');
            app.IntervalButton.ButtonPushedFcn = createCallbackFcn(app, @ImportButtonPushed, true);
            app.IntervalButton.WordWrap = 'on';
            app.IntervalButton.Layout.Row = 6;
            app.IntervalButton.Layout.Column = 4;
            app.IntervalButton.Text = 'Show Session in Interval Module';

            % Create ProjectTable
            app.ProjectTable = uitable(app.GridLayout);
            app.ProjectTable.ColumnName = '';
            app.ProjectTable.RowName = {};
            app.ProjectTable.ColumnEditable = [false true];
            app.ProjectTable.CellEditCallback = createCallbackFcn(app, @ProjectTableCellEdit, true);
            app.ProjectTable.SelectionChangedFcn = createCallbackFcn(app, @ProjectTableSelectionChanged, true);
            app.ProjectTable.Multiselect = 'off';
            app.ProjectTable.Layout.Row = [2 17];
            app.ProjectTable.Layout.Column = 3;

            % Create AddProjectButton
            app.AddProjectButton = uibutton(app.GridLayout, 'push');
            app.AddProjectButton.ButtonPushedFcn = createCallbackFcn(app, @AddProjectButtonPushed, true);
            app.AddProjectButton.Layout.Row = 2;
            app.AddProjectButton.Layout.Column = 2;
            app.AddProjectButton.Text = 'Add Project';

            % Create DeleteProjectButton
            app.DeleteProjectButton = uibutton(app.GridLayout, 'push');
            app.DeleteProjectButton.ButtonPushedFcn = createCallbackFcn(app, @DeleteProjectButtonPushed, true);
            app.DeleteProjectButton.Layout.Row = 6;
            app.DeleteProjectButton.Layout.Column = 2;
            app.DeleteProjectButton.Text = 'Delete Project';

            % Create ClassificationButton
            app.ClassificationButton = uibutton(app.GridLayout, 'push');
            app.ClassificationButton.ButtonPushedFcn = createCallbackFcn(app, @ImportButtonPushed, true);
            app.ClassificationButton.WordWrap = 'on';
            app.ClassificationButton.Layout.Row = 8;
            app.ClassificationButton.Layout.Column = 4;
            app.ClassificationButton.Text = 'Show Session in Classification Module';

            % Create DriftButton
            app.DriftButton = uibutton(app.GridLayout, 'push');
            app.DriftButton.ButtonPushedFcn = createCallbackFcn(app, @ImportButtonPushed, true);
            app.DriftButton.WordWrap = 'on';
            app.DriftButton.Layout.Row = 10;
            app.DriftButton.Layout.Column = 4;
            app.DriftButton.Text = 'Show Session in Drift Module';

            % Create QuantificationButton
            app.QuantificationButton = uibutton(app.GridLayout, 'push');
            app.QuantificationButton.ButtonPushedFcn = createCallbackFcn(app, @ImportButtonPushed, true);
            app.QuantificationButton.WordWrap = 'on';
            app.QuantificationButton.Layout.Row = 12;
            app.QuantificationButton.Layout.Column = 4;
            app.QuantificationButton.Text = 'Show Session in Quantification Module';

            % Create ResultsButton
            app.ResultsButton = uibutton(app.GridLayout, 'push');
            app.ResultsButton.ButtonPushedFcn = createCallbackFcn(app, @ImportButtonPushed, true);
            app.ResultsButton.WordWrap = 'on';
            app.ResultsButton.Layout.Row = 14;
            app.ResultsButton.Layout.Column = 4;
            app.ResultsButton.Text = 'Show Session in Results Module';

            % Create WorkingDirectoryLabel
            app.WorkingDirectoryLabel = uilabel(app.GridLayout);
            app.WorkingDirectoryLabel.HorizontalAlignment = 'right';
            app.WorkingDirectoryLabel.FontSize = 10;
            app.WorkingDirectoryLabel.Layout.Row = 18;
            app.WorkingDirectoryLabel.Layout.Column = 2;
            app.WorkingDirectoryLabel.Text = 'Working Directory:';

            % Create WorkingDirectoryEditField
            app.WorkingDirectoryEditField = uieditfield(app.GridLayout, 'text');
            app.WorkingDirectoryEditField.ValueChangedFcn = createCallbackFcn(app, @WorkingDirectoryEditFieldValueChanged, true);
            app.WorkingDirectoryEditField.Editable = 'off';
            app.WorkingDirectoryEditField.HorizontalAlignment = 'right';
            app.WorkingDirectoryEditField.FontColor = [0.502 0.502 0.502];
            app.WorkingDirectoryEditField.Layout.Row = 18;
            app.WorkingDirectoryEditField.Layout.Column = 3;

            % Create SelectButton
            app.SelectButton = uibutton(app.GridLayout, 'push');
            app.SelectButton.ButtonPushedFcn = createCallbackFcn(app, @SelectButtonPushed, true);
            app.SelectButton.FontSize = 11;
            app.SelectButton.Layout.Row = 18;
            app.SelectButton.Layout.Column = 4;
            app.SelectButton.Text = 'Select';

            % Create DuplicateSessionButton
            app.DuplicateSessionButton = uibutton(app.GridLayout, 'push');
            app.DuplicateSessionButton.ButtonPushedFcn = createCallbackFcn(app, @DuplicateSessionButtonPushed, true);
            app.DuplicateSessionButton.Layout.Row = 16;
            app.DuplicateSessionButton.Layout.Column = 4;
            app.DuplicateSessionButton.Text = 'Duplicate Session';

            % Create DuplicateProjectButton
            app.DuplicateProjectButton = uibutton(app.GridLayout, 'push');
            app.DuplicateProjectButton.ButtonPushedFcn = createCallbackFcn(app, @DuplicateProjectButtonPushed, true);
            app.DuplicateProjectButton.WordWrap = 'on';
            app.DuplicateProjectButton.Layout.Row = 4;
            app.DuplicateProjectButton.Layout.Column = 2;
            app.DuplicateProjectButton.Text = 'Duplicate Project';

            % Create TableBuilderVisModuleButton
            app.TableBuilderVisModuleButton = uibutton(app.GridLayout, 'push');
            app.TableBuilderVisModuleButton.ButtonPushedFcn = createCallbackFcn(app, @TableBuilderVisModuleButtonPushed, true);
            app.TableBuilderVisModuleButton.WordWrap = 'on';
            app.TableBuilderVisModuleButton.Layout.Row = [16 17];
            app.TableBuilderVisModuleButton.Layout.Column = 2;
            app.TableBuilderVisModuleButton.Text = 'Table Builder & VisModule';

            % Create SaveselectedSessiontoBaseButton
            app.SaveselectedSessiontoBaseButton = uibutton(app.GridLayout, 'push');
            app.SaveselectedSessiontoBaseButton.ButtonPushedFcn = createCallbackFcn(app, @SaveselectedSessiontoBaseButtonPushed, true);
            app.SaveselectedSessiontoBaseButton.Enable = 'off';
            app.SaveselectedSessiontoBaseButton.Layout.Row = 18;
            app.SaveselectedSessiontoBaseButton.Layout.Column = [5 6];
            app.SaveselectedSessiontoBaseButton.Text = 'Save selected Session to Base';

            % Create RestoreselectedSessionButton
            app.RestoreselectedSessionButton = uibutton(app.GridLayout, 'push');
            app.RestoreselectedSessionButton.ButtonPushedFcn = createCallbackFcn(app, @RestoreselectedSessionButtonPushed, true);
            app.RestoreselectedSessionButton.Enable = 'off';
            app.RestoreselectedSessionButton.Layout.Row = 18;
            app.RestoreselectedSessionButton.Layout.Column = 7;
            app.RestoreselectedSessionButton.Text = 'Restore selected Session';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ICP_Base_readable

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end