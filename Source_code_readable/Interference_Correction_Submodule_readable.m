% GENERATED from Interference_Correction_Submodule.mlapp on 2026-10-28 15:37 by export_mlapp_to_m. This file is for reading purposes, any real changes need to be applied to the .mlapp files and exported again.
classdef Interference_Correction_Submodule_readable < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        TabGroup                     matlab.ui.container.TabGroup
        BlankCorrectionTab           matlab.ui.container.Tab
        ShowPlotButton               matlab.ui.control.Button
        BlanktoallspotscontainingEditField_2  matlab.ui.control.EditField
        toallICMcontainingLabel_3    matlab.ui.control.Label
        BlankAssignSpotButton        matlab.ui.control.Button
        SpotAssignmentTable          matlab.ui.control.Table
        BlanktoallspotscontainingEditField  matlab.ui.control.EditField
        toallICMcontainingLabel      matlab.ui.control.Label
        BlankAssignIDEditField       matlab.ui.control.NumericEditField
        AssignIDEditField_2Label     matlab.ui.control.Label
        BlankICMIDDropDown           matlab.ui.control.DropDown
        ICMIDDropDown_2Label         matlab.ui.control.Label
        BlankAssignButton            matlab.ui.control.Button
        BlankAnalyteListBox          matlab.ui.control.ListBox
        BlankAssignmentTable         matlab.ui.control.Table
        BlankICMTable                matlab.ui.control.Table
        BlankProceedtoDriftModuleButton  matlab.ui.control.Button
        PolyatomicInterferencesTab   matlab.ui.container.Tab
        ShowPlotButton_2             matlab.ui.control.Button
        toallICMcontainingEditField  matlab.ui.control.EditField
        toallICMcontainingLabel_2    matlab.ui.control.Label
        AssignIDEditField            matlab.ui.control.NumericEditField
        AssignIDEditFieldLabel       matlab.ui.control.Label
        ICMIDDropDown                matlab.ui.control.DropDown
        ICMIDLabel                   matlab.ui.control.Label
        AssignButton                 matlab.ui.control.Button
        RemoveCorrectionButton       matlab.ui.control.Button
        AddCorrectionButton          matlab.ui.control.Button
        AnalyteListBox               matlab.ui.control.ListBox
        AssignmentTable              matlab.ui.control.Table
        ICMTable                     matlab.ui.control.Table
        ProceedtoDriftModuleButton   matlab.ui.control.Button
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

    properties (Access = private)
        source
        icm_progress

        icm_bracket_id
        correction_pairs
        selected_assignment_cell

        blank_bracket_id
        blank_correction_elements
        blank_spot_assignment

        changes_made = false 

    end

    methods (Access = private)

        %%%%%%%%%%% Polyatomic %%%%%%%%%%%%%%

        function update_icm_table(app)
            sess         = app.source.base.project.session;
            icm_mask     = sess.spot.type == "ICM";
            spot_numbers = num2cell(find(icm_mask));
            spotnames    = cellstr(sess.spot.name(icm_mask));
            ids          = num2cell(app.icm_bracket_id(icm_mask));

            T = cell2table([spot_numbers, spotnames, ids], ...
                'VariableNames', {'#', 'Spotname', 'ID'});

            app.ICMTable.Data           = T;
            app.ICMTable.ColumnName     = {'#', 'Spotname', 'ID'};
            app.ICMTable.ColumnEditable = [false, false, true];
        end

        function update_id_dropdown(app)
            sess     = app.source.base.project.session;
            icm_mask = sess.spot.type == "ICM";
            ids      = unique(app.icm_bracket_id(icm_mask));
            ids      = ids(ids ~= 0);

            app.ICMIDDropDown.Items     = cellstr(string(ids));
            app.ICMIDDropDown.ItemsData = num2cell(ids);
        end

        function update_analyte_listbox(app)
            analytes                 = cellstr(app.source.base.project.session.spot.analytes);
            app.AnalyteListBox.Items = analytes;
        end

        function update_assignment_table(app)
            if isempty(app.ICMIDDropDown.Items)
                app.AssignmentTable.Data           = table(string.empty(0,1), string.empty(0,1), ...
                    'VariableNames', {'Interferer', 'Target'});
                app.AssignmentTable.ColumnName     = {'Interferer', 'Target'};
                app.AssignmentTable.ColumnEditable = [false, false];
                return
            end

            selected_id = app.ICMIDDropDown.Value;
            mask        = app.correction_pairs.ID == selected_id;
            pairs       = app.correction_pairs(mask, {'Interferer', 'Target'});

            app.AssignmentTable.Data           = pairs;
            app.AssignmentTable.ColumnName     = {'Interferer', 'Target'};
            app.AssignmentTable.ColumnEditable = [false, false];
        end

        %%%%%%%%%%% Laser Backgrounds %%%%%%%%%%%%%%

        function update_blank_table(app)
            sess         = app.source.base.project.session;
            icm_mask     = sess.spot.type == "ICM";
            spot_numbers = num2cell(find(icm_mask));
            spotnames    = cellstr(sess.spot.name(icm_mask));
            ids          = num2cell(app.blank_bracket_id(icm_mask));
            T = cell2table([spot_numbers, spotnames, ids], ...
                'VariableNames', {'#', 'Spotname', 'ID'});
            app.BlankICMTable.Data           = T;
            app.BlankICMTable.ColumnName     = {'#', 'Spotname', 'ID'};
            app.BlankICMTable.ColumnEditable = [false, false, true];
        end

        function update_blank_id_dropdown(app)
            sess     = app.source.base.project.session;
            icm_mask = sess.spot.type == "ICM";
            ids      = unique(app.blank_bracket_id(icm_mask));
            ids      = ids(ids ~= 0);
            app.BlankICMIDDropDown.Items     = cellstr(string(ids));
            app.BlankICMIDDropDown.ItemsData = num2cell(ids);
        end

        function update_blank_element_listbox(app)
            analytes = cellstr(app.source.base.project.session.spot.analytes);
            app.BlankAnalyteListBox.Items = analytes;
            if isempty(app.BlankICMIDDropDown.Items)
                app.BlankAnalyteListBox.Value = {};
                return
            end
            selected_id = app.BlankICMIDDropDown.Value;
            mask        = app.blank_correction_elements.ID == selected_id;
            assigned    = cellstr(app.blank_correction_elements.Element(mask));
            app.BlankAnalyteListBox.Value = intersect(assigned, analytes);
        end

        function update_spot_assignment_table(app)
            sess         = app.source.base.project.session;
            non_icm_mask = sess.spot.type ~= "ICM";
            spot_numbers = num2cell(find(non_icm_mask));
            spotnames    = cellstr(sess.spot.name(non_icm_mask));

            if isempty(app.BlankICMIDDropDown.Items)
                assigned = num2cell(false(sum(non_icm_mask), 1));
            else
                selected_id = app.BlankICMIDDropDown.Value;
                if selected_id <= size(app.blank_spot_assignment, 2)
                    assigned = num2cell(logical(app.blank_spot_assignment(non_icm_mask, selected_id)));
                else
                    assigned = num2cell(false(sum(non_icm_mask), 1));
                end
            end

            T = cell2table([spot_numbers, spotnames, assigned], ...
                'VariableNames', {'#', 'Spotname', 'Assigned'});
            app.SpotAssignmentTable.Data           = T;
            app.SpotAssignmentTable.ColumnName     = {'#', 'Spotname', 'Assigned'};
            app.SpotAssignmentTable.ColumnEditable = [false, false, true];
        end

        function update_blank_assignment_table(app)
            if isempty(app.BlankICMIDDropDown.Items)
                app.BlankAssignmentTable.Data       = table(string.empty(0,1), 'VariableNames', {'Zero Analyte'});
                app.BlankAssignmentTable.ColumnName = {'Zero Analyte'};
                return
            end
            selected_id = app.BlankICMIDDropDown.Value;
            mask        = app.blank_correction_elements.ID == selected_id;
            elements    = app.blank_correction_elements.Element(mask);
            app.BlankAssignmentTable.Data       = table(elements, 'VariableNames', {'Zero Analyte'});
            app.BlankAssignmentTable.ColumnName = {'Zero Analyte'};
        end


    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, sourceapp, icm_progress)
            app.source       = sourceapp;
            app.icm_progress = icm_progress;
            sess     = app.source.base.project.session;
            icm_mask = sess.spot.type == "ICM";

            % --- ICM ---
            if isfield(sess.spot, 'icm_bracket_id')
                app.icm_bracket_id = sess.spot.icm_bracket_id;
            else
                app.icm_bracket_id = zeros(numel(sess.spot.name), 1);
                app.icm_bracket_id(icm_mask) = 1;
            end
            new_icm = icm_mask & (app.icm_bracket_id == 0);
            if any(new_icm)
                app.icm_bracket_id(new_icm) = 1;
            end

            if isfield(sess.spot, 'icm_correction_pairs') && ~isempty(sess.spot.icm_correction_pairs)
                raw      = sess.spot.icm_correction_pairs;
                expected = {'ID', 'Interferer', 'Target'};
                if all(ismember(expected, raw.Properties.VariableNames))
                    app.correction_pairs = raw(:, expected);
                else
                    app.correction_pairs = table(double.empty(0,1), string.empty(0,1), string.empty(0,1), ...
                        'VariableNames', {'ID', 'Interferer', 'Target'});
                end
            else
                app.correction_pairs = table(double.empty(0,1), string.empty(0,1), string.empty(0,1), ...
                    'VariableNames', {'ID', 'Interferer', 'Target'});
            end

            % --- Blank ---
            if isfield(sess.spot, 'blank_bracket_id')
                app.blank_bracket_id = sess.spot.blank_bracket_id;
            else
                app.blank_bracket_id = zeros(numel(sess.spot.name), 1);
                app.blank_bracket_id(icm_mask) = 1;
            end
            new_blank = icm_mask & (app.blank_bracket_id == 0);
            if any(new_blank)
                app.blank_bracket_id(new_blank) = 1;
            end

            if isfield(sess.spot, 'blank_correction_elements') && ~isempty(sess.spot.blank_correction_elements)
                raw      = sess.spot.blank_correction_elements;
                expected = {'ID', 'Element'};
                if all(ismember(expected, raw.Properties.VariableNames))
                    app.blank_correction_elements = raw(:, expected);
                else
                    app.blank_correction_elements = table(double.empty(0,1), string.empty(0,1), ...
                        'VariableNames', {'ID', 'Element'});
                end
            else
                app.blank_correction_elements = table(double.empty(0,1), string.empty(0,1), ...
                    'VariableNames', {'ID', 'Element'});
            end

            if isfield(sess.spot, 'blank_spot_assignment')
                app.blank_spot_assignment = logical(sess.spot.blank_spot_assignment);
            else
                icm_ids = unique(app.blank_bracket_id(sess.spot.type == "ICM"));
                icm_ids = icm_ids(icm_ids ~= 0);
                max_id  = max([1; icm_ids(:)]);
                app.blank_spot_assignment = false(numel(sess.spot.name), max_id);
            end

            % --- Update GUI ---
            update_icm_table(app);
            update_id_dropdown(app);
            update_analyte_listbox(app);
            update_assignment_table(app);

            update_blank_table(app);
            update_blank_id_dropdown(app);
            update_blank_element_listbox(app);
            update_spot_assignment_table(app);
            update_blank_assignment_table(app) 
        end

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            
            
            selection = uiconfirm(app.UIFigure, ...
                ['Closing discards the changes made in this window. ' ...
                'An interference correction configuration that was saved before remains unchanged.'], ...
                'Discard Changes', ...
                'Options', {'Close', 'Cancel'}, ...
                'DefaultOption', 1, ...
                'CancelOption', 2);

            if strcmp(selection, 'Close')
                delete(app)
            end
        end

        % Button pushed function: BlankProceedtoDriftModuleButton, 
        % ProceedtoDriftModuleButton
        function ProceedtoDriftModuleButtonPushed(app, event)

            sess    = app.source.base.project.session;
            has_icm = any(sess.spot.type == "ICM");

            no_isobaric = isempty(app.correction_pairs) || height(app.correction_pairs) == 0;
            no_blank    = isempty(app.blank_correction_elements) || height(app.blank_correction_elements) == 0;

            if has_icm && no_isobaric && no_blank
                uialert(app.UIFigure, ...
                    'At least one correction must be configured — either an isobaric interference or a blank correction.', ...
                    'No Correction Configured');
                return
            end

            % --- Isobaric validation ---
            if has_icm && ~no_isobaric
                pairs = app.correction_pairs;

                incomplete = pairs.Interferer == "" | pairs.Target == "";
                if any(incomplete)
                    uialert(app.UIFigure, 'One or more rows have an empty Interferer or Target.', 'Incomplete Assignment');
                    return
                end

                if any(pairs.Interferer == pairs.Target)
                    uialert(app.UIFigure, 'One or more rows have the same analyte as both Interferer and Target.', 'Invalid Assignment');
                    return
                end

                interferer_mass = str2double(regexp(pairs.Interferer, '\d+$', 'match', 'once'));
                target_mass     = str2double(regexp(pairs.Target,     '\d+$', 'match', 'once'));
                if any(target_mass <= interferer_mass)
                    uialert(app.UIFigure, 'Target must have a higher mass number than the interferer.', 'Invalid Mass Order');
                    return
                end

                unique_pairs = unique(pairs(:, {'Interferer', 'Target'}), 'rows');
                if height(unique_pairs) < height(pairs)
                    uialert(app.UIFigure, 'The same Interferer → Target pair is assigned to multiple IDs.', 'Duplicate Assignment');
                    return
                end

                icm_ids       = app.icm_bracket_id(sess.spot.type == "ICM");
                unique_ids    = unique(icm_ids);
                singleton_ids = unique_ids(arrayfun(@(id) sum(icm_ids == id) == 1, unique_ids));
                if ~isempty(singleton_ids)
                    id_str    = strjoin(string(singleton_ids), ', ');
                    selection = uiconfirm(app.UIFigure, ...
                        sprintf(['ICM ID(s) %s have only one spot assigned. No regression possible — ' ...
                        'the same correction factor will be applied to all spots. Proceed anyway?'], id_str), ...
                        'Single ICM Spot', 'Options', {'Proceed', 'Cancel'}, ...
                        'DefaultOption', 2, 'CancelOption', 2);
                    if strcmp(selection, 'Cancel'), return; end
                end
            end

            % --- Blank validation ---
            if has_icm && ~no_blank

                if ~any(app.blank_spot_assignment(:))
                    uialert(app.UIFigure, 'Elements are assigned to blank IDs but no spots have been assigned for blank correction.', 'No Spots Assigned');
                    return
                end

                % Check spots assigned to IDs with no elements defined
                assigned_ids = find(any(app.blank_spot_assignment, 1));
                element_ids  = unique(app.blank_correction_elements.ID)';
                missing_ids  = assigned_ids(~ismember(assigned_ids, element_ids));
                if ~isempty(missing_ids)
                    id_str = strjoin(string(missing_ids), ', ');
                    uialert(app.UIFigure, ...
                        sprintf('Blank ID(s) %s are assigned to spots but have no elements defined.', id_str), ...
                        'Missing Elements');
                    return
                end

                % Check double correction — same element assigned to two IDs that both correct the same spot
                for spot = 1:size(app.blank_spot_assignment, 1)
                    spot_ids = find(app.blank_spot_assignment(spot, :));
                    if numel(spot_ids) < 2, continue; end
                    spot_elements = app.blank_correction_elements.Element( ...
                        ismember(app.blank_correction_elements.ID, spot_ids));
                    if numel(spot_elements) ~= numel(unique(spot_elements))
                        uialert(app.UIFigure, ...
                            sprintf('Spot %d is assigned to multiple blank IDs that correct the same element. Each element can only be blank-corrected once per spot.', spot), ...
                            'Double Correction');
                        return
                    end
                end

                blank_ids     = app.blank_bracket_id(sess.spot.type == "ICM");
                unique_ids    = unique(blank_ids);
                singleton_ids = unique_ids(arrayfun(@(id) sum(blank_ids == id) == 1, unique_ids));
                if ~isempty(singleton_ids)
                    id_str    = strjoin(string(singleton_ids), ', ');
                    selection = uiconfirm(app.UIFigure, ...
                        sprintf(['Blank ID(s) %s have only one spot assigned. The same blank signal will be ' ...
                        'applied to all spots regardless of drift. Proceed anyway?'], id_str), ...
                        'Single Blank Spot', 'Options', {'Proceed', 'Cancel'}, ...
                        'DefaultOption', 2, 'CancelOption', 2);
                    if strcmp(selection, 'Cancel'), return; end
                end
            end

            % --- Inclusion warning ---
            if isequal(sess.config.reductiontype, 'Inclusion')
                if isfield(sess.spot, 'unmixing_via') && any(sess.spot.unmixing_via == "Matrix-only tracer")
                    msg = ['This session uses matrix-only tracer unmixing. Applying an isobaric interference ' ...
                        'or blank correction will modify the background-corrected signals used to separate ' ...
                        'host and inclusion contributions. This can render the unmixing erroneous leading to wrong quantification results. ' ...
                        'Only proceed if you fully understand the consequences.'];
                else
                    msg = ['Applying an isobaric interference or blank correction will modify the ' ...
                        'background-corrected signals used to separate host and inclusion contributions. ' ...
                        'This can render the unmixing erroneous leading to wrong quantification results. ' ...
                        'Only proceed if you fully understand the consequences.'];
                end
                selection = uiconfirm(app.UIFigure, msg, 'Inclusion Unmixing Warning', ...
                    'Options', {'Proceed', 'Cancel'}, ...
                    'DefaultOption', 2, 'CancelOption', 2, ...
                    'Icon', 'warning');
                if strcmp(selection, 'Cancel'), return; end
            end



            % --- Invalidate downstream stages if isobaric/blank correction changed ---
            if (~no_isobaric || ~no_blank) && app.changes_made
                changes = check_changes(app.source, 'interference_correction', app.UIFigure);
                if changes == false
                    return
                end
            end



                       % --- Write to session (only what actually changed) ---
            % an empty category removes its stored settings, otherwise Drift keeps applying the old ones
            spot = app.source.base.project.session.spot;

            isobaric_fields = {'icm_bracket_id', 'icm_correction_pairs'};
            if no_isobaric
                stored = isobaric_fields(isfield(spot, isobaric_fields));
                if ~isempty(stored)
                    app.source.base.project.session.spot = rmfield(app.source.base.project.session.spot, stored);
                end
            else
                isobaric_unchanged = isfield(spot, 'icm_bracket_id') && isfield(spot, 'icm_correction_pairs') ...
                    && isequal(spot.icm_bracket_id, app.icm_bracket_id) ...
                    && isequal(spot.icm_correction_pairs, app.correction_pairs);
                if ~isobaric_unchanged
                    app.source.base.project.session.spot.icm_bracket_id       = app.icm_bracket_id;
                    app.source.base.project.session.spot.icm_correction_pairs = app.correction_pairs;
                end
            end

            blank_fields = {'blank_bracket_id', 'blank_correction_elements', 'blank_spot_assignment'};
            if no_blank
                stored = blank_fields(isfield(spot, blank_fields));
                if ~isempty(stored)
                    app.source.base.project.session.spot = rmfield(app.source.base.project.session.spot, stored);
                end
            else
                blank_unchanged = isfield(spot, 'blank_bracket_id') && isfield(spot, 'blank_correction_elements') ...
                    && isfield(spot, 'blank_spot_assignment') ...
                    && isequal(spot.blank_bracket_id, app.blank_bracket_id) ...
                    && isequal(spot.blank_correction_elements, app.blank_correction_elements) ...
                    && isequal(spot.blank_spot_assignment, app.blank_spot_assignment);
                if ~blank_unchanged
                    app.source.base.project.session.spot.blank_bracket_id          = app.blank_bracket_id;
                    app.source.base.project.session.spot.blank_correction_elements = app.blank_correction_elements;
                    app.source.base.project.session.spot.blank_spot_assignment     = app.blank_spot_assignment;
                end
            end

            delete(app.icm_progress)
            source_app = app.source.sourceapp;
            app.source.launch_drift_module()
            delete(app.source)
            delete(app)
            refresh_session_buttons(source_app)
        end

        % Cell edit callback: ICMTable
        function ICMTableCellEdit(app, event)
            newData = event.NewData;
            indices = event.Indices;

            if ~isnumeric(newData) || newData < 1 || floor(newData) ~= newData
                uialert(app.UIFigure, 'ID must be a positive integer.', 'Invalid Input');
                update_icm_table(app);
                return
            end

            app.changes_made = true;

            % Find which spot this row corresponds to
            spot_num = app.ICMTable.Data{indices(1), '#'};
            app.icm_bracket_id(spot_num) = newData;

            valid_ids = unique(app.icm_bracket_id(app.source.base.project.session.spot.type == "ICM"));
            app.correction_pairs = app.correction_pairs(ismember(app.correction_pairs.ID, valid_ids), :);

            update_icm_table(app);
            update_id_dropdown(app);
            update_assignment_table(app);
        end

        % Value changed function: ICMIDDropDown
        function ICMIDDropDownValueChanged(app, event)
           update_assignment_table(app);
        end

        % Button pushed function: AddCorrectionButton
        function AddCorrectionButtonPushed(app, event)
            app.changes_made = true;
            selected_id = app.ICMIDDropDown.Value;
            new_row     = table(selected_id, string(""), string(""), ...
                'VariableNames', {'ID', 'Interferer', 'Target'});
            app.correction_pairs = [app.correction_pairs; new_row];
            update_assignment_table(app);
        end

        % Button pushed function: RemoveCorrectionButton
        function RemoveCorrectionButtonPushed(app, event)
            
            if isempty(app.AssignmentTable.Selection)
                return
            end

            selected_id  = app.ICMIDDropDown.Value;
            selected_row = app.AssignmentTable.Selection(1, 1);
            mask         = app.correction_pairs.ID == selected_id;
            id_rows      = find(mask);

            if selected_row > numel(id_rows)
                return
            end
app.changes_made = true;
            app.correction_pairs(id_rows(selected_row), :) = [];
            update_assignment_table(app);
        end

        % Value changed function: AnalyteListBox
        function AnalyteListBoxValueChanged(app, event)
            if isempty(app.selected_assignment_cell)
                return
            end

            selected_analyte = app.AnalyteListBox.Value;
            selected_row     = app.selected_assignment_cell(1);
            selected_col     = app.selected_assignment_cell(2);

            selected_id = app.ICMIDDropDown.Value;
            mask        = app.correction_pairs.ID == selected_id;
            id_rows     = find(mask);

            if selected_row > numel(id_rows)
                return
            end

            global_row = id_rows(selected_row);

            switch selected_col
                case 1
                    app.correction_pairs.Interferer(global_row) = string(selected_analyte);
                case 2
                    app.correction_pairs.Target(global_row) = string(selected_analyte);
            end
app.changes_made = true;
            update_assignment_table(app);
        end

        % Callback function: AssignmentTable
        function AssignmentTableSelectionChanged(app, event)
            if ~isempty(app.AssignmentTable.Selection)
                app.selected_assignment_cell = app.AssignmentTable.Selection(1, :);
            end
        end

        % Button pushed function: AssignButton
        function AssignButtonPushed(app, event)
            pattern = app.toallICMcontainingEditField.Value;
            id_val  = app.AssignIDEditField.Value;

            if isnan(id_val) || id_val < 1 || floor(id_val) ~= id_val
                uialert(app.UIFigure, 'ID must be a positive integer.', 'Invalid Input');
                return
            end

            sess        = app.source.base.project.session;
            icm_mask    = sess.spot.type == "ICM";
            icm_indices = find(icm_mask);
            icm_names   = sess.spot.name(icm_mask);

            match_mask = contains(icm_names, pattern, 'IgnoreCase', true);
            if ~any(match_mask)
                uialert(app.UIFigure, 'No ICM spots found containing that string.', 'No Match');
                return
            end

            app.icm_bracket_id(icm_indices(match_mask)) = id_val;
app.changes_made = true;
            update_icm_table(app);
            update_id_dropdown(app);
            update_assignment_table(app);

        end

        % Cell edit callback: BlankICMTable
        function BlankICMTableCellEdit(app, event)
            newData = event.NewData;
            indices = event.Indices;

            if ~isnumeric(newData) || newData < 1 || floor(newData) ~= newData
                uialert(app.UIFigure, 'ID must be a positive integer.', 'Invalid Input');
                update_blank_table(app);
                return
            end

            if any(app.blank_spot_assignment(:))
                selection = uiconfirm(app.UIFigure, ...
                    'Changing a Blank ID will reset all spot assignments. Continue?', ...
                    'Reset Spot Assignments', ...
                    'Options', {'Continue', 'Cancel'}, ...
                    'DefaultOption', 2, 'CancelOption', 2);
                if strcmp(selection, 'Cancel')
                    update_blank_table(app);
                    return
                end
                app.blank_spot_assignment = false(size(app.blank_spot_assignment));
            end

            spot_num = app.BlankICMTable.Data{indices(1), '#'};
            app.blank_bracket_id(spot_num) = newData;

            valid_ids = unique(app.blank_bracket_id(app.source.base.project.session.spot.type == "ICM"));
            app.blank_correction_elements = app.blank_correction_elements(ismember(app.blank_correction_elements.ID, valid_ids), :);
app.changes_made = true;
            update_blank_table(app);
            update_blank_id_dropdown(app);
            update_blank_element_listbox(app);
            update_spot_assignment_table(app);
        end

        % Value changed function: BlankICMIDDropDown
        function BlankICMIDDropDownValueChanged(app, event)
            update_blank_element_listbox(app);
            update_blank_assignment_table(app);
            update_spot_assignment_table(app);
        end

        % Value changed function: BlankAnalyteListBox
        function BlankAnalyteListBoxValueChanged(app, event)
            if isempty(app.BlankICMIDDropDown.Items), return; end

            selected_id       = app.BlankICMIDDropDown.Value;
            selected_elements = string(app.BlankAnalyteListBox.Value);

            % Update backend
            app.blank_correction_elements = app.blank_correction_elements( ...
                app.blank_correction_elements.ID ~= selected_id, :);
            if ~isempty(selected_elements)
                new_rows = table(repmat(selected_id, numel(selected_elements), 1), selected_elements(:), ...
                    'VariableNames', {'ID', 'Element'});
                app.blank_correction_elements = [app.blank_correction_elements; new_rows];
            end
app.changes_made = true;
            % Update display table
            app.BlankAssignmentTable.Data       = table(selected_elements(:), 'VariableNames', {'Zero Analyte'});
            app.BlankAssignmentTable.ColumnName = {'Zero Analyte'};
        end

        % Cell edit callback: SpotAssignmentTable
        function SpotAssignmentTableCellEdit(app, event)
            if isempty(app.BlankICMIDDropDown.Items), return; end

            selected_id = app.BlankICMIDDropDown.Value;
            spot_num    = app.SpotAssignmentTable.Data{event.Indices(1), '#'};

            if selected_id > size(app.blank_spot_assignment, 2)
                app.blank_spot_assignment(:, end+1:selected_id) = false;
            end
app.changes_made = true;
            app.blank_spot_assignment(spot_num, selected_id) = event.NewData;
        end

        % Button pushed function: BlankAssignButton
        function BlankAssignButtonPushed(app, event)
            pattern = app.BlanktoallspotscontainingEditField.Value;
            id_val  = str2double(app.BlankAssignIDEditField.Value);

            if isnan(id_val) || id_val < 1 || floor(id_val) ~= id_val
                uialert(app.UIFigure, 'ID must be a positive integer.', 'Invalid Input');
                return
            end

            sess        = app.source.base.project.session;
            icm_mask    = sess.spot.type == "ICM";
            icm_indices = find(icm_mask);
            icm_names   = sess.spot.name(icm_mask);

            match_mask = contains(icm_names, pattern, 'IgnoreCase', true);
            if ~any(match_mask)
                uialert(app.UIFigure, 'No ICM spots found containing that string.', 'No Match');
                return
            end

            app.blank_bracket_id(icm_indices(match_mask)) = id_val;
app.changes_made = true;
            update_blank_table(app);
            update_blank_id_dropdown(app);
            update_blank_element_listbox(app);
        end

        % Button pushed function: BlankAssignSpotButton
        function BlankAssignSpotButtonPushed(app, event)
            if isempty(app.BlankICMIDDropDown.Items)
                uialert(app.UIFigure, 'No Blank IDs defined yet.', 'No IDs');
                return
            end

            pattern     = strtrim(app.BlanktoallspotscontainingEditField.Value);
            selected_id = app.BlankICMIDDropDown.Value;

            sess             = app.source.base.project.session;
            non_icm_mask     = sess.spot.type ~= "ICM";
            non_icm_indices  = find(non_icm_mask);
            non_icm_names    = sess.spot.name(non_icm_mask);

            match_mask = contains(cellstr(non_icm_names), pattern, 'IgnoreCase', true);
            if ~any(match_mask)
                uialert(app.UIFigure, 'No spots found containing that string.', 'No Match');
                return
            end

            if selected_id > size(app.blank_spot_assignment, 2)
                app.blank_spot_assignment(:, end+1:selected_id) = false;
            end

            app.blank_spot_assignment(non_icm_indices(match_mask), selected_id) = true;
app.changes_made = true;
            update_spot_assignment_table(app);
        end

        % Button pushed function: ShowPlotButton
        function ShowPlotButtonPushed(app, event)

            % --- Adjust figure size here ---
            fig_width  = 900;
            fig_height = 700;

            sess = app.source.base.project.session;

            % --- Compute integer_time_points ---
            if strcmp(sess.config.datatype, 'Continuous')
                time_pts = sess.spot.signal_starts;
            elseif strcmp(sess.config.datatype, 'Single') && isfield(sess.spot, 'acquisition_datetime') && ~isempty(sess.spot.acquisition_datetime)
                dt = datetime(sess.spot.acquisition_datetime, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
                time_pts = minutes(dt - dt(1)) + 1;
            elseif strcmp(sess.config.datatype, 'Single') && isfield(sess.spot, 'acquisition_time')
                total_minutes = zeros(numel(sess.spot.acquisition_time), 1);
                for i = 1:numel(sess.spot.acquisition_time)
                    parts = split(sess.spot.acquisition_time(i), ':');
                    total_minutes(i) = str2double(parts(1)) * 60 + str2double(parts(2));
                end
                for i = 2:numel(total_minutes)
                    if total_minutes(i) < total_minutes(i-1)
                        total_minutes(i:end) = total_minutes(i:end) + 1440;
                    end
                end
                time_pts = total_minutes - total_minutes(1) + 1;
            else
                time_pts = (1:numel(sess.spot.name))';
            end

            % --- Compute bkgd_corrected_cps ---
            nSpots    = numel(sess.spot.name);
            nAnalytes = numel(sess.spot.analytes);
            bg_corr_matrix = zeros(nSpots, nAnalytes);

            for spot = 1:nSpots
                if isequal(sess.config.datatype, 'Single')
                    signal = sess.spot.signal_data{spot};
                else
                    signal = sess.spot.signal_data;
                end

                bs = sess.spot.background_starts(spot);
                be = sess.spot.background_ends(spot);
                if isnan(bs) || isnan(be), continue; end
                mean_bg = mean(table2array(signal(bs:be, 2:end)), 1);

                all_matrix_data = [];
                starts = [sess.spot.matrix_1_starts(spot), sess.spot.matrix_2_starts(spot), sess.spot.matrix_3_starts(spot)];
                ends   = [sess.spot.matrix_1_ends(spot),   sess.spot.matrix_2_ends(spot),   sess.spot.matrix_3_ends(spot)];
                for m = 1:3
                    if ~isnan(starts(m)) && ~isnan(ends(m))
                        all_matrix_data = [all_matrix_data; table2array(signal(starts(m):ends(m), 2:end))];
                    end
                end

                if ~isempty(all_matrix_data)
                    bg_corr_matrix(spot, :) = mean(all_matrix_data - mean_bg, 1);
                end
            end

            if isequal(sess.config.datatype, 'Single')
                varNames = sess.spot.signal_data{1}.Properties.VariableNames(2:end);
            else
                varNames = sess.spot.signal_data.Properties.VariableNames(2:end);
            end
            cps       = array2table(bg_corr_matrix, 'VariableNames', varNames);
            col_names = cps.Properties.VariableNames;

            % --- Get selected blank ID and elements ---
            selected_id = app.BlankICMIDDropDown.Value;
            if isempty(selected_id) || selected_id == 0, return; end

            elements = app.blank_correction_elements.Element(app.blank_correction_elements.ID == selected_id);
            if isempty(elements), return; end

            icm_mask    = sess.spot.type == "ICM";
            id_mask     = icm_mask & (app.blank_bracket_id == selected_id);
            icm_indices = find(id_mask);
            icm_times   = time_pts(id_mask);
            icm_names   = cellstr(sess.spot.name(id_mask));

            if selected_id <= size(app.blank_spot_assignment, 2)
                assigned_mask = logical(app.blank_spot_assignment(:, selected_id)) & ~icm_mask;
            else
                assigned_mask = false(nSpots, 1);
            end
            assigned_names = cellstr(sess.spot.name(assigned_mask));

            % --- Group breaks ---
            group_breaks = 0;
            for k = 1:length(icm_indices)-1
                spots_between = icm_indices(k)+1 : icm_indices(k+1)-1;
                if ~isempty(spots_between) && ...
                        (any(sess.spot.type(spots_between) ~= "ICM") || any(app.blank_bracket_id(spots_between) ~= selected_id))
                    group_breaks(end+1) = k;
                end
            end
            group_breaks = [group_breaks(:); length(icm_indices)];
            n_groups = length(group_breaks) - 1;
            
            % --- Open figure ---
            fig = uifigure('Name', sprintf('Blank Correction Preview — ID %d', selected_id), ...
                'Position', [100 100 fig_width fig_height]);
            tl  = tiledlayout(fig, 2, 1, 'TileSpacing', 'compact', 'Padding', 'compact');
            ax1 = nexttile(tl);
            ax2 = nexttile(tl);
            hold(ax1, 'on');
            hold(ax2, 'on');

            cmap = lines(numel(elements));

            for e = 1:numel(elements)
                el = char(elements(e));
                if ~ismember(el, col_names), continue; end
                color = cmap(e, :);

                % --- Compute group averages ---
                avg_times   = zeros(n_groups, 1);
                avg_signals = zeros(n_groups, 1);

                for g = 1:n_groups
                    s_idx = group_breaks(g) + 1;
                    e_idx = group_breaks(g+1);
                    grp   = s_idx:e_idx;
                    gtimes = icm_times(grp);
                    if mod(numel(grp), 2) == 0
                        mid = numel(grp)/2;
                        avg_times(g) = (gtimes(mid) + gtimes(mid+1)) / 2;
                    else
                        avg_times(g) = gtimes(ceil(numel(grp)/2));
                    end
                    gidx  = icm_indices(grp);
                    gsig  = cps{gidx, el};
                    valid = gsig > 0;
                    if any(valid), avg_signals(g) = mean(gsig(valid)); end
                end

                % --- ax1: correction curve ---
                s = scatter(ax1, icm_times, cps{id_mask, el}, 25, color, 'filled', 'HandleVisibility', 'off');
                s.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Spot', icm_names);

                if numel(avg_times) == 1
                    yline(ax1, avg_signals(1), '-', 'Color', color, 'LineWidth', 1.5, 'DisplayName', el);
                else
                    plot(ax1, avg_times, avg_signals, '-', 'Color', color, 'LineWidth', 1.5, 'DisplayName', el);
                end
                scatter(ax1, avg_times, avg_signals, 55, color, 's', 'filled', 'HandleVisibility', 'off');

                if any(assigned_mask)
                    at = time_pts(assigned_mask);
                    if numel(avg_times) == 1
                        isig = repmat(avg_signals(1), sum(assigned_mask), 1);
                    else
                        isig = interp1(avg_times, avg_signals, at, 'linear', 'extrap');
                    end

                    s = scatter(ax1, at, isig, 25, color, 'o', 'HandleVisibility', 'off');
                    s.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Spot', assigned_names);

                    if numel(avg_times) > 1
                        left_mask  = at < min(avg_times);
                        right_mask = at > max(avg_times);
                        if any(left_mask)
                            xt = [min(at(left_mask)); min(avg_times)];
                            xs = interp1(avg_times, avg_signals, xt, 'linear', 'extrap');
                            plot(ax1, xt, xs, '--', 'Color', color, 'LineWidth', 1.5, 'HandleVisibility', 'off');
                        end
                        if any(right_mask)
                            xt = [max(avg_times); max(at(right_mask))];
                            xs = interp1(avg_times, avg_signals, xt, 'linear', 'extrap');
                            plot(ax1, xt, xs, '--', 'Color', color, 'LineWidth', 1.5, 'HandleVisibility', 'off');
                        end
                    end

                    % --- ax2: before and after correction ---
                    original  = cps{assigned_mask, el};
                    corrected = original - isig;

                    s = scatter(ax2, at, original, 25, color, 'o', 'HandleVisibility', 'off');
                    s.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Spot', assigned_names);

                    s = scatter(ax2, at, corrected, 25, color, 'filled', 'DisplayName', el);
                    s.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Spot', assigned_names);
                end
            end

            hold(ax1, 'off');
            hold(ax2, 'off');

            yline(ax1, 0, '--k', 'LineWidth', 2, 'HandleVisibility', 'off');
            yline(ax2, 0, '--k', 'LineWidth', 2, 'HandleVisibility', 'off');

            xlabel(ax1, 'Time');
            ylabel(ax1, 'Blank signal (cps)');
            legend(ax1, 'Location', 'northeast');
            title(ax1, sprintf('Blank correction curve — ID %d', selected_id));
            ax1.YMinorGrid         = 'on';
            ax1.MinorGridLineStyle = '-';
            ax1.MinorGridAlpha     = 0.05;
            ax1.Box                = 'on';

            xlabel(ax2, 'Time');
            ylabel(ax2, 'Intensity (cps)');
            legend(ax2, 'Location', 'northeast');
            title(ax2, 'Assigned spots — open: before, filled: after correction');
            ax2.YMinorGrid         = 'on';
            ax2.MinorGridLineStyle = '-';
            ax2.MinorGridAlpha     = 0.05;
            ax2.Box                = 'on';

        end

        % Button pushed function: ShowPlotButton_2
        function ShowPlotButton_2Pushed(app, event)
            % --- Adjust figure size here ---
            fig_width  = 900;
            fig_height = 700;

            sess = app.source.base.project.session;

            % --- Compute integer_time_points ---
             if strcmp(sess.config.datatype, 'Continuous')
                time_pts = sess.spot.signal_starts;
            elseif strcmp(sess.config.datatype, 'Single') && isfield(sess.spot, 'acquisition_datetime') && ~isempty(sess.spot.acquisition_datetime)
                dt = datetime(sess.spot.acquisition_datetime, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
                time_pts = minutes(dt - dt(1)) + 1;
            elseif strcmp(sess.config.datatype, 'Single') && isfield(sess.spot, 'acquisition_time')
                total_minutes = zeros(numel(sess.spot.acquisition_time), 1);
                for i = 1:numel(sess.spot.acquisition_time)
                    parts = split(sess.spot.acquisition_time(i), ':');
                    total_minutes(i) = str2double(parts(1)) * 60 + str2double(parts(2));
                end
                for i = 2:numel(total_minutes)
                    if total_minutes(i) < total_minutes(i-1)
                        total_minutes(i:end) = total_minutes(i:end) + 1440;
                    end
                end
                time_pts = total_minutes - total_minutes(1) + 1;
            else
                time_pts = (1:numel(sess.spot.name))';
            end

            % --- Compute bkgd_corrected_cps ---
            nSpots    = numel(sess.spot.name);
            nAnalytes = numel(sess.spot.analytes);
            bg_corr_matrix = zeros(nSpots, nAnalytes);

            for spot = 1:nSpots
                if isequal(sess.config.datatype, 'Single')
                    signal = sess.spot.signal_data{spot};
                else
                    signal = sess.spot.signal_data;
                end

                bs = sess.spot.background_starts(spot);
                be = sess.spot.background_ends(spot);
                if isnan(bs) || isnan(be), continue; end
                mean_bg = mean(table2array(signal(bs:be, 2:end)), 1);

                all_matrix_data = [];
                starts = [sess.spot.matrix_1_starts(spot), sess.spot.matrix_2_starts(spot), sess.spot.matrix_3_starts(spot)];
                ends   = [sess.spot.matrix_1_ends(spot),   sess.spot.matrix_2_ends(spot),   sess.spot.matrix_3_ends(spot)];
                for m = 1:3
                    if ~isnan(starts(m)) && ~isnan(ends(m))
                        all_matrix_data = [all_matrix_data; table2array(signal(starts(m):ends(m), 2:end))];
                    end
                end

                if ~isempty(all_matrix_data)
                    bg_corr_matrix(spot, :) = mean(all_matrix_data - mean_bg, 1);
                end
            end

            if isequal(sess.config.datatype, 'Single')
                varNames = sess.spot.signal_data{1}.Properties.VariableNames(2:end);
            else
                varNames = sess.spot.signal_data.Properties.VariableNames(2:end);
            end
            cps       = array2table(bg_corr_matrix, 'VariableNames', varNames);
            col_names = cps.Properties.VariableNames;

            % --- Get correction pairs ---
            pairs = app.correction_pairs;
            if isempty(pairs) || height(pairs) == 0, return; end

            icm_mask      = sess.spot.type == "ICM";
            non_icm_mask  = ~icm_mask;
            non_icm_times = time_pts(non_icm_mask);
            non_icm_names = cellstr(sess.spot.name(non_icm_mask));

            % --- Open figure ---
            fig = uifigure('Name', 'Isobaric Correction Preview', ...
                'Position', [100 100 fig_width fig_height]);
            tl  = tiledlayout(fig, 2, 1, 'TileSpacing', 'compact', 'Padding', 'compact');
            ax1 = nexttile(tl);
            ax2 = nexttile(tl);
            hold(ax1, 'on');
            hold(ax2, 'on');

            cmap = lines(height(pairs));

            for p = 1:height(pairs)
                id         = pairs.ID(p);
                interferer = char(pairs.Interferer(p));
                target     = char(pairs.Target(p));
                color      = cmap(p, :);
                label      = sprintf('%s → %s', interferer, target);

                id_mask     = icm_mask & (app.icm_bracket_id == id);
                icm_indices = find(id_mask);
                icm_times   = time_pts(id_mask);
                icm_names   = cellstr(sess.spot.name(id_mask));

                if ~any(id_mask), continue; end
                if ~ismember(interferer, col_names) || ~ismember(target, col_names), continue; end

                % --- Compute ratios ---
                int_sig = cps{id_mask, interferer};
                tgt_sig = cps{id_mask, target};
                valid   = int_sig > 0;
                if ~any(valid), continue; end

                valid_indices = icm_indices(valid);
                valid_times   = icm_times(valid);
                valid_names   = icm_names(valid);
                ratios        = tgt_sig(valid) ./ int_sig(valid);

                % Individual ICM ratio points
                s = scatter(ax1, valid_times, ratios, 25, color, 'filled', 'HandleVisibility', 'off');
                s.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Spot', valid_names);

                % --- Group breaks ---
                group_breaks = 0;
                for k = 1:length(valid_indices)-1
                    spots_between = valid_indices(k)+1 : valid_indices(k+1)-1;
                    if ~isempty(spots_between) && ...
                            (any(sess.spot.type(spots_between) ~= "ICM") || any(app.icm_bracket_id(spots_between) ~= id))
                        group_breaks(end+1) = k;
                    end
                end
                group_breaks = [group_breaks(:); length(valid_indices)];
                n_groups = length(group_breaks) - 1;

                avg_times  = zeros(n_groups, 1);
                avg_ratios = zeros(n_groups, 1);

                for g = 1:n_groups
                    s_idx = group_breaks(g) + 1;
                    e_idx = group_breaks(g+1);
                    grp   = s_idx:e_idx;
                    gtimes = valid_times(grp);
                    if mod(numel(grp), 2) == 0
                        mid = numel(grp)/2;
                        avg_times(g) = (gtimes(mid) + gtimes(mid+1)) / 2;
                    else
                        avg_times(g) = gtimes(ceil(numel(grp)/2));
                    end
                    avg_ratios(g) = mean(ratios(grp));
                end

                % Group average line
                if numel(avg_times) == 1
                    yline(ax1, avg_ratios(1), '-', 'Color', color, 'LineWidth', 1.5, 'DisplayName', label);
                else
                    plot(ax1, avg_times, avg_ratios, '-', 'Color', color, 'LineWidth', 1.5, 'DisplayName', label);
                end
                scatter(ax1, avg_times, avg_ratios, 55, color, 's', 'filled', 'HandleVisibility', 'off');

                % Interpolate to non-ICM spots
                if numel(avg_times) == 1
                    interp_ratios = repmat(avg_ratios(1), sum(non_icm_mask), 1);
                else
                    interp_ratios = interp1(avg_times, avg_ratios, non_icm_times, 'linear', 'extrap');
                end

                s = scatter(ax1, non_icm_times, interp_ratios, 25, color, 'o', 'HandleVisibility', 'off');
                s.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Spot', non_icm_names);

                % Dashed extrapolation
                if numel(avg_times) > 1
                    left_mask  = non_icm_times < min(avg_times);
                    right_mask = non_icm_times > max(avg_times);
                    if any(left_mask)
                        xt = [min(non_icm_times(left_mask)); min(avg_times)];
                        xs = interp1(avg_times, avg_ratios, xt, 'linear', 'extrap');
                        plot(ax1, xt, xs, '--', 'Color', color, 'LineWidth', 1.5, 'HandleVisibility', 'off');
                    end
                    if any(right_mask)
                        xt = [max(avg_times); max(non_icm_times(right_mask))];
                        xs = interp1(avg_times, avg_ratios, xt, 'linear', 'extrap');
                        plot(ax1, xt, xs, '--', 'Color', color, 'LineWidth', 1.5, 'HandleVisibility', 'off');
                    end
                end

                % --- ax2: target before and after correction ---
                before = cps{non_icm_mask, target};
                after  = before - cps{non_icm_mask, interferer} .* interp_ratios;

                s = scatter(ax2, non_icm_times, before, 25, color, 'o', 'HandleVisibility', 'off');
                s.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Spot', non_icm_names);

                s = scatter(ax2, non_icm_times, after, 25, color, 'filled', 'DisplayName', label);
                s.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Spot', non_icm_names);
            end

            hold(ax1, 'off');
            hold(ax2, 'off');

            yline(ax1, 0, '--k', 'LineWidth', 2, 'HandleVisibility', 'off');
            yline(ax2, 0, '--k', 'LineWidth', 2, 'HandleVisibility', 'off');

            xlabel(ax1, 'Time');
            ylabel(ax1, 'Ratio (Target / Interferer)');
            legend(ax1, 'Location', 'northeast');
            title(ax1, 'Isobaric correction ratios');
            ax1.YMinorGrid         = 'on';
            ax1.MinorGridLineStyle = '-';
            ax1.MinorGridAlpha     = 0.05;
            ax1.Box                = 'on';

            xlabel(ax2, 'Time');
            ylabel(ax2, 'Intensity (cps)');
            legend(ax2, 'Location', 'northeast');
            title(ax2, 'Target element — open: before, filled: after correction');
            ax2.YMinorGrid         = 'on';
            ax2.MinorGridLineStyle = '-';
            ax2.MinorGridAlpha     = 0.05;
            ax2.Box                = 'on';

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 701 640];
            app.UIFigure.Name = 'Interference Correction Configuration';
            app.UIFigure.Icon = 'icon_48.png';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 1 701 640];

            % Create BlankCorrectionTab
            app.BlankCorrectionTab = uitab(app.TabGroup);
            app.BlankCorrectionTab.Title = 'Blank Correction';

            % Create BlankProceedtoDriftModuleButton
            app.BlankProceedtoDriftModuleButton = uibutton(app.BlankCorrectionTab, 'push');
            app.BlankProceedtoDriftModuleButton.ButtonPushedFcn = createCallbackFcn(app, @ProceedtoDriftModuleButtonPushed, true);
            app.BlankProceedtoDriftModuleButton.Position = [541 8 142 45];
            app.BlankProceedtoDriftModuleButton.Text = 'Proceed to Drift Module';

            % Create BlankICMTable
            app.BlankICMTable = uitable(app.BlankCorrectionTab);
            app.BlankICMTable.ColumnName = '';
            app.BlankICMTable.RowName = {};
            app.BlankICMTable.CellEditCallback = createCallbackFcn(app, @BlankICMTableCellEdit, true);
            app.BlankICMTable.Position = [18 290 318 315];

            % Create BlankAssignmentTable
            app.BlankAssignmentTable = uitable(app.BlankCorrectionTab);
            app.BlankAssignmentTable.ColumnName = '';
            app.BlankAssignmentTable.RowName = {};
            app.BlankAssignmentTable.Position = [19 8 108 234];

            % Create BlankAnalyteListBox
            app.BlankAnalyteListBox = uilistbox(app.BlankCorrectionTab);
            app.BlankAnalyteListBox.Items = {};
            app.BlankAnalyteListBox.Multiselect = 'on';
            app.BlankAnalyteListBox.ValueChangedFcn = createCallbackFcn(app, @BlankAnalyteListBoxValueChanged, true);
            app.BlankAnalyteListBox.Position = [137 8 75 235];
            app.BlankAnalyteListBox.Value = {};

            % Create BlankAssignButton
            app.BlankAssignButton = uibutton(app.BlankCorrectionTab, 'push');
            app.BlankAssignButton.ButtonPushedFcn = createCallbackFcn(app, @BlankAssignButtonPushed, true);
            app.BlankAssignButton.Position = [270 251 66 29];
            app.BlankAssignButton.Text = 'Assign';

            % Create ICMIDDropDown_2Label
            app.ICMIDDropDown_2Label = uilabel(app.BlankCorrectionTab);
            app.ICMIDDropDown_2Label.HorizontalAlignment = 'right';
            app.ICMIDDropDown_2Label.FontWeight = 'bold';
            app.ICMIDDropDown_2Label.FontColor = [0.3922 0.8314 0.0745];
            app.ICMIDDropDown_2Label.Position = [211 214 47 22];
            app.ICMIDDropDown_2Label.Text = 'ICM ID:';

            % Create BlankICMIDDropDown
            app.BlankICMIDDropDown = uidropdown(app.BlankCorrectionTab);
            app.BlankICMIDDropDown.Items = {};
            app.BlankICMIDDropDown.ValueChangedFcn = createCallbackFcn(app, @BlankICMIDDropDownValueChanged, true);
            app.BlankICMIDDropDown.FontWeight = 'bold';
            app.BlankICMIDDropDown.FontColor = [0.3922 0.8314 0.0745];
            app.BlankICMIDDropDown.Position = [266 208 70 33];
            app.BlankICMIDDropDown.Value = {};

            % Create AssignIDEditField_2Label
            app.AssignIDEditField_2Label = uilabel(app.BlankCorrectionTab);
            app.AssignIDEditField_2Label.HorizontalAlignment = 'right';
            app.AssignIDEditField_2Label.FontSize = 10;
            app.AssignIDEditField_2Label.Position = [6 255 48 22];
            app.AssignIDEditField_2Label.Text = 'Assign ID';

            % Create BlankAssignIDEditField
            app.BlankAssignIDEditField = uieditfield(app.BlankCorrectionTab, 'numeric');
            app.BlankAssignIDEditField.Limits = [1 Inf];
            app.BlankAssignIDEditField.Position = [61 251 25 30];
            app.BlankAssignIDEditField.Value = 1;

            % Create toallICMcontainingLabel
            app.toallICMcontainingLabel = uilabel(app.BlankCorrectionTab);
            app.toallICMcontainingLabel.HorizontalAlignment = 'right';
            app.toallICMcontainingLabel.FontSize = 10;
            app.toallICMcontainingLabel.Position = [86 255 96 22];
            app.toallICMcontainingLabel.Text = 'to all ICM containing';

            % Create BlanktoallspotscontainingEditField
            app.BlanktoallspotscontainingEditField = uieditfield(app.BlankCorrectionTab, 'text');
            app.BlanktoallspotscontainingEditField.Position = [188 251 69 29];

            % Create SpotAssignmentTable
            app.SpotAssignmentTable = uitable(app.BlankCorrectionTab);
            app.SpotAssignmentTable.ColumnName = '';
            app.SpotAssignmentTable.RowName = {};
            app.SpotAssignmentTable.CellEditCallback = createCallbackFcn(app, @SpotAssignmentTableCellEdit, true);
            app.SpotAssignmentTable.Position = [351 107 331 498];

            % Create BlankAssignSpotButton
            app.BlankAssignSpotButton = uibutton(app.BlankCorrectionTab, 'push');
            app.BlankAssignSpotButton.ButtonPushedFcn = createCallbackFcn(app, @BlankAssignSpotButtonPushed, true);
            app.BlankAssignSpotButton.Position = [630 64 52 29];
            app.BlankAssignSpotButton.Text = 'Assign';

            % Create toallICMcontainingLabel_3
            app.toallICMcontainingLabel_3 = uilabel(app.BlankCorrectionTab);
            app.toallICMcontainingLabel_3.HorizontalAlignment = 'right';
            app.toallICMcontainingLabel_3.WordWrap = 'on';
            app.toallICMcontainingLabel_3.FontSize = 11;
            app.toallICMcontainingLabel_3.Position = [369 61 115 35];
            app.toallICMcontainingLabel_3.Text = 'Assign current ICM ID to all spots containing';

            % Create BlanktoallspotscontainingEditField_2
            app.BlanktoallspotscontainingEditField_2 = uieditfield(app.BlankCorrectionTab, 'text');
            app.BlanktoallspotscontainingEditField_2.Position = [498 65 121 29];

            % Create ShowPlotButton
            app.ShowPlotButton = uibutton(app.BlankCorrectionTab, 'push');
            app.ShowPlotButton.ButtonPushedFcn = createCallbackFcn(app, @ShowPlotButtonPushed, true);
            app.ShowPlotButton.Position = [224 7 117 46];
            app.ShowPlotButton.Text = 'Show Plot';

            % Create PolyatomicInterferencesTab
            app.PolyatomicInterferencesTab = uitab(app.TabGroup);
            app.PolyatomicInterferencesTab.Title = 'Polyatomic Interferences';

            % Create ProceedtoDriftModuleButton
            app.ProceedtoDriftModuleButton = uibutton(app.PolyatomicInterferencesTab, 'push');
            app.ProceedtoDriftModuleButton.ButtonPushedFcn = createCallbackFcn(app, @ProceedtoDriftModuleButtonPushed, true);
            app.ProceedtoDriftModuleButton.Position = [541 8 142 45];
            app.ProceedtoDriftModuleButton.Text = 'Proceed to Drift Module';

            % Create ICMTable
            app.ICMTable = uitable(app.PolyatomicInterferencesTab);
            app.ICMTable.ColumnName = '';
            app.ICMTable.RowName = {};
            app.ICMTable.CellEditCallback = createCallbackFcn(app, @ICMTableCellEdit, true);
            app.ICMTable.Position = [80 290 500 315];

            % Create AssignmentTable
            app.AssignmentTable = uitable(app.PolyatomicInterferencesTab);
            app.AssignmentTable.ColumnName = '';
            app.AssignmentTable.RowName = {};
            app.AssignmentTable.SelectionChangedFcn = createCallbackFcn(app, @AssignmentTableSelectionChanged, true);
            app.AssignmentTable.Position = [81 50 265 192];

            % Create AnalyteListBox
            app.AnalyteListBox = uilistbox(app.PolyatomicInterferencesTab);
            app.AnalyteListBox.Items = {};
            app.AnalyteListBox.ValueChangedFcn = createCallbackFcn(app, @AnalyteListBoxValueChanged, true);
            app.AnalyteListBox.Position = [356 7 75 235];
            app.AnalyteListBox.Value = {};

            % Create AddCorrectionButton
            app.AddCorrectionButton = uibutton(app.PolyatomicInterferencesTab, 'push');
            app.AddCorrectionButton.ButtonPushedFcn = createCallbackFcn(app, @AddCorrectionButtonPushed, true);
            app.AddCorrectionButton.Position = [214 7 132 34];
            app.AddCorrectionButton.Text = 'Add Correction';

            % Create RemoveCorrectionButton
            app.RemoveCorrectionButton = uibutton(app.PolyatomicInterferencesTab, 'push');
            app.RemoveCorrectionButton.ButtonPushedFcn = createCallbackFcn(app, @RemoveCorrectionButtonPushed, true);
            app.RemoveCorrectionButton.Position = [81 7 132 34];
            app.RemoveCorrectionButton.Text = 'Remove Correction';

            % Create AssignButton
            app.AssignButton = uibutton(app.PolyatomicInterferencesTab, 'push');
            app.AssignButton.ButtonPushedFcn = createCallbackFcn(app, @AssignButtonPushed, true);
            app.AssignButton.Position = [461 251 120 29];
            app.AssignButton.Text = 'Assign';

            % Create ICMIDLabel
            app.ICMIDLabel = uilabel(app.PolyatomicInterferencesTab);
            app.ICMIDLabel.HorizontalAlignment = 'right';
            app.ICMIDLabel.FontWeight = 'bold';
            app.ICMIDLabel.FontColor = [0.3922 0.8314 0.0745];
            app.ICMIDLabel.Position = [430 214 65 22];
            app.ICMIDLabel.Text = 'ICM ID:';

            % Create ICMIDDropDown
            app.ICMIDDropDown = uidropdown(app.PolyatomicInterferencesTab);
            app.ICMIDDropDown.Items = {};
            app.ICMIDDropDown.ValueChangedFcn = createCallbackFcn(app, @ICMIDDropDownValueChanged, true);
            app.ICMIDDropDown.FontWeight = 'bold';
            app.ICMIDDropDown.FontColor = [0.3922 0.8314 0.0745];
            app.ICMIDDropDown.Position = [503 208 78 33];
            app.ICMIDDropDown.Value = {};

            % Create AssignIDEditFieldLabel
            app.AssignIDEditFieldLabel = uilabel(app.PolyatomicInterferencesTab);
            app.AssignIDEditFieldLabel.HorizontalAlignment = 'right';
            app.AssignIDEditFieldLabel.Position = [85 255 57 22];
            app.AssignIDEditFieldLabel.Text = 'Assign ID';

            % Create AssignIDEditField
            app.AssignIDEditField = uieditfield(app.PolyatomicInterferencesTab, 'numeric');
            app.AssignIDEditField.Limits = [1 Inf];
            app.AssignIDEditField.Position = [149 251 40 30];
            app.AssignIDEditField.Value = 1;

            % Create toallICMcontainingLabel_2
            app.toallICMcontainingLabel_2 = uilabel(app.PolyatomicInterferencesTab);
            app.toallICMcontainingLabel_2.HorizontalAlignment = 'right';
            app.toallICMcontainingLabel_2.Position = [199 255 114 22];
            app.toallICMcontainingLabel_2.Text = 'to all ICM containing';

            % Create toallICMcontainingEditField
            app.toallICMcontainingEditField = uieditfield(app.PolyatomicInterferencesTab, 'text');
            app.toallICMcontainingEditField.Position = [319 251 119 29];

            % Create ShowPlotButton_2
            app.ShowPlotButton_2 = uibutton(app.PolyatomicInterferencesTab, 'push');
            app.ShowPlotButton_2.ButtonPushedFcn = createCallbackFcn(app, @ShowPlotButton_2Pushed, true);
            app.ShowPlotButton_2.Position = [439 107 143 57];
            app.ShowPlotButton_2.Text = 'Show Plot';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Interference_Correction_Submodule_readable(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

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