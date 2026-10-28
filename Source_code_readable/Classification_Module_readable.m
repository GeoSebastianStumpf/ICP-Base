% GENERATED from Classification_Module.mlapp on 2026-10-28 16:53 by export_mlapp_to_m. This file is for reading purposes, any real changes need to be applied to the .mlapp files and exported again.
classdef Classification_Module_readable < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        BaseMenu                    matlab.ui.container.Menu
        ExitMenu                    matlab.ui.container.Menu
        SettingsMenu                matlab.ui.container.Menu
        ChangereferencematerialfolderMenu  matlab.ui.container.Menu
        GridLayout                  matlab.ui.container.GridLayout
        ShowdwelltimesButton        matlab.ui.control.Button
        GetRMfilesButton            matlab.ui.control.Button
        ChosenEditField             matlab.ui.control.EditField
        ChooseButton                matlab.ui.control.Button
        GroupbyspotsizeButton       matlab.ui.control.Button
        ContainsEditField           matlab.ui.control.EditField
        ContainsEditFieldLabel      matlab.ui.control.Label
        ProgressPanel               matlab.ui.container.Panel
        ResultsButton               matlab.ui.control.Button
        QuantificationButton        matlab.ui.control.Button
        DriftButton                 matlab.ui.control.Button
        ClassificationButton        matlab.ui.control.Button
        ImportButton                matlab.ui.control.Button
        IntervalButton              matlab.ui.control.Button
        UnknownButton               matlab.ui.control.Button
        ProceedtoDriftModuleButton  matlab.ui.control.Button
        InterferenceCorrectionMaterialOptionalButton  matlab.ui.control.Button
        QualityControlReferenceMaterialOptionalButton  matlab.ui.control.Button
        CalibratorButton            matlab.ui.control.Button
        ResetButton                 matlab.ui.control.Button
        RMListBox                   matlab.ui.control.ListBox
        ReferenceMaterialTable      matlab.ui.control.Table
        ContextMenu2                matlab.ui.container.ContextMenu
        ShowRMvaluesMenu            matlab.ui.container.Menu
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

properties (Access = public, SetObservable)
    base
end


    properties (Access = public)
        sourceapp
        project_id
        session_id
    end

    properties (Access = private)
        
        selected_spot
        selected_referencematerial
        selected_string


        editstatus = false
        icm_submodule

    end

    methods (Access = private)



        % Custom function to center the figure
        function center_figure(app, hfig)
            try
                screenSize = get(0,'ScreenSize');
                figPos = hfig.Position;
                figWidth = figPos(3);
                figHeight = figPos(4);
                newX = (screenSize(3) - figWidth) / 2;
                newY = (screenSize(4) - figHeight) / 2;
                hfig.Position=[newX, newY, figWidth, figHeight];
                figure(hfig)
            catch
                ME
                disp('CenterFig_fun failed!')
                disp(ME.message)
            end
        end
        
        function updateDwellTime(app, src, event)

            newValue = str2double(event.EditData);

            % validate first, so an invalid entry never triggers a reset
            if isnan(newValue) || newValue <= 0
                src.Data(event.Indices(1), event.Indices(2)) = event.PreviousData;
                return
            end

            % dwell times only affect drift and later, not the quantification inputs
            changes = check_changes(app, 'interval');
            if changes == false
                src.Data(event.Indices(1), event.Indices(2)) = event.PreviousData;
                return
            end
            app.editstatus = true;

            app.base.project.session.spot.dwelltimes{1, event.Indices(2)} = newValue;
        end

        
        %%%%%%%%%%% functions for the spots %%%%%%%%%%%%%%

        function get_RM_Files(app)

            RM_files = dir(fullfile(app.base.project.session.config.RM_folder_path, '*.csv'));

            filenames        = string([]);
            allTables        = {};
            alluncertainites = {};

            for i = 1:length(RM_files)
                filePath = fullfile(app.base.project.session.config.RM_folder_path, RM_files(i).name);
                fname    = RM_files(i).name;

                try
                    opts = detectImportOptions(filePath, 'TextType', 'string');
                    raw  = readtable(filePath, opts);
                catch
                    uialert(app.UIFigure, sprintf('Could not read file "%s". Make sure it is a valid CSV.', fname), 'RM File Error');
                    return
                end

                if height(raw) == 0
                    uialert(app.UIFigure, sprintf('File "%s" is empty.', fname), 'RM File Error');
                    return
                end

                if width(raw) < 2 || width(raw) > 3
                    uialert(app.UIFigure, sprintf('File "%s" must have 2 or max 3 columns (element name, mass fractions, uncertainties) (found %d).', fname, width(raw)), 'RM File Error');
                    return
                end

                elements      = raw{:, 1};
                massfractions = table2array(raw(:, 2));

                % No empty element names
                if any(elements == "" | ismissing(elements))
                    uialert(app.UIFigure, sprintf('File "%s" contains empty element names.', fname), 'RM File Error');
                    return
                end

                % No duplicate element names
                if numel(unique(elements)) < numel(elements)
                    uialert(app.UIFigure, sprintf('File "%s" contains duplicate element names.', fname), 'RM File Error');
                    return
                end

                % Element names must contain only letters (no numbers like Si29 or 208Pb)
                onlyLetters = arrayfun(@(x) all(isletter(char(x))), elements);
                if any(~onlyLetters)
                    uialert(app.UIFigure, sprintf('File "%s" contains invalid element names (letters only, e.g. "Si" not "Si29").', fname), 'RM File Error');
                    return
                end

                % Mass fractions: no missing values allowed
                if any(isnan(massfractions))
                    uialert(app.UIFigure, sprintf('File "%s": column 2 (mass fractions) has missing values — every element must have a mass fraction.', fname), 'RM File Error');
                    return
                end

                % Mass fractions: must be non-negative
                if any(massfractions < 0)
                    uialert(app.UIFigure, sprintf('File "%s": column 2 (mass fractions) must contain non-negative numbers only.', fname), 'RM File Error');
                    return
                end

                dataTable = array2table(massfractions', 'VariableNames', cellstr(elements'));

                filename = string(RM_files(i).name);
                filename = extractBefore(filename, strlength(filename) - 3);

                filenames(end+1) = filename;
                allTables{end+1} = dataTable;

                if size(raw, 2) == 3
                    uncertainties = table2array(raw(:, 3));
                    if any(uncertainties < 0)
                        uialert(app.UIFigure, sprintf('File "%s": column 3 (uncertainties) must contain non-negative numbers only.', fname), 'RM File Error');
                        return
                    end
                    uncertaintiesTable = array2table(uncertainties', 'VariableNames', cellstr(elements'));
                    alluncertainites{i} = uncertaintiesTable;
                else
                    alluncertainites{i} = [];
                end
            end

            app.base.project.session.referencematerials.names = filenames';
            app.base.project.session.referencematerials.data  = allTables';

            if ~isempty(alluncertainites)
                app.base.project.session.referencematerials.uncertainty = alluncertainites';
            end

        end


        function update_reference_material_table(app)
            % Get spot data
            spot = app.base.project.session.spot;
            numSpots = numel(spot.name);

            % Direct assignment (cell arrays for names, bracket_id; string arrays for type/refmat)
            spotname = spot.name(:);
            type = spot.type(:);
            refmat = spot.referencematerial(:);
            bracket_id = spot.bracket_id(:);

            % Create table
            T = table((1:numSpots)', spotname, refmat, type, bracket_id);
            T.Properties.VariableNames = {'#', 'Spotname', 'Reference Material', 'Type', 'Bracket id'};

            % Update UI table
            app.ReferenceMaterialTable.Data = T;
            app.ReferenceMaterialTable.ColumnName = T.Properties.VariableNames;
        end


        function update_refmat_table_colours(app)
            refmat = app.base.project.session.spot.referencematerial;
            type   = app.base.project.session.spot.type;
            nRows  = height(app.ReferenceMaterialTable.Data);

            bg = ones(nRows, 3);
            orange = [1, 229/255, 204/255];

            no_refmat = refmat == "None" | refmat == "Select Reference Material";
            no_type   = type == "Unknown" | type == "Select Type";

            % RM set but no type yet: orange, and ask for the type
            idx_refmat_no_type = ~no_refmat & no_type;
            bg(idx_refmat_no_type, :) = repmat(orange, sum(idx_refmat_no_type), 1);
            idx_set_select_type = ~no_refmat & type == "Unknown";
            if any(idx_set_select_type)
                app.base.project.session.spot.type(idx_set_select_type) = "Select Type";
            end

            % type set but no RM yet: orange, and ask for the RM
            idx_type_no_refmat = no_refmat & ~no_type & type ~= "ICM";
            bg(idx_type_no_refmat, :) = repmat(orange, sum(idx_type_no_refmat), 1);
            idx_set_select_rm = idx_type_no_refmat & refmat ~= "Select Reference Material";
            if any(idx_set_select_rm)
                app.base.project.session.spot.referencematerial(idx_set_select_rm) = "Select Reference Material";
            end

            idx_cal  = ~no_refmat & type == "CAL";
            idx_qcrm = ~no_refmat & type == "QCRM";
            idx_icm  = type == "ICM";

            bg(idx_cal,  :) = repmat([204/255, 1,        204/255], sum(idx_cal),  1);
            bg(idx_qcrm, :) = repmat([204/255, 1,        1      ], sum(idx_qcrm), 1);
            bg(idx_icm, :)  = repmat([204/255, 204/255,  1      ], sum(idx_icm),  1);
            if any(refmat(idx_icm) ~= "None")
                app.base.project.session.spot.referencematerial(idx_icm) = "None";
            end

            app.ReferenceMaterialTable.BackgroundColor = bg;
        end

        function update_bracket_id(app)
            type   = app.base.project.session.spot.type;
            refmat = app.base.project.session.spot.referencematerial;
            old_bracket_id = app.base.project.session.spot.bracket_id;

            no_refmat = refmat == "None" | refmat == "Select Reference Material";

            idx_cal  = ~no_refmat & type == "CAL" & ~(old_bracket_id > 1);
            idx_zero = type == "QCRM" | type == "ICM" | type == "None" | type == "Unknown";

            new_bracket_id = old_bracket_id;
            new_bracket_id(idx_cal)  = 1;
            new_bracket_id(idx_zero) = 0;

            if ~isequal(new_bracket_id, old_bracket_id)
                app.base.project.session.spot.bracket_id = new_bracket_id;
            end
        end

    end

    methods (Access = public)

        %%%%%%%%%%%%%%%%%%%%%%%%% API function  %%%%%%%%%%%%%%%%%%%%%%%%%

        function [settings] = assign_spots_to_reference_materials(app, settings)
            try
                test_state = true; % is needed later as a failsafe so that no broken data gets into the data structure

                % if settings is not sent or something wrong is put in
                if not(exist('settings', 'var')) || not(isstruct(settings))
                    settings = struct();
                end

                % if the type is not input
                if not(isfield(settings,'type')) || isempty(settings.type)
                    % now return the settings with the options for type:
                    settings.type.Options={"CAL", "QCRM", "ICM"};
                    disp('Types must be provided in settings.type');
                    test_state = false;
                end

                % if the referencematerial is not input
                if not(isfield(settings,'referencematerial')) || isempty(settings.referencematerial)
                    settings.referencematerial.Options=string(app.RMListBox.Items(2:end)); % these options need to be the items of the RMListBox but as strings
                    test_state = false;
                    disp('Reference Materials must be provided in settings.referencematerial');
                end

                % if the spotnumber is not input
                if not(isfield(settings,'spotnumber')) || isempty(settings.spotnumber)
                    disp('Spot numbers must be provided in settings.spotnumber');
                    return
                    test_state = false;
                end

                % if the spotnumber is not input
                if not(isfield(settings,'bracket_id')) || isempty(settings.bracket_id)
                    disp('bracket_id can be set via settings.bracket_id. If no input is given the bracket_id will be 1 for all CALs')
                    bracket_id_not_given = true;
                else
                    bracket_id_not_given = false;
                    bracket_id = settings.bracket_id;
                end

                spotnumber = settings.spotnumber;
                type = settings.type;
                referencematerial = settings.referencematerial;

                % if test_state = false, push the data from the cache to the
                % data structure
                if test_state == false
                    return
                else
                    % Store the results in the app structure
                    app.base.project.session.spot.referencematerial(spotnumber) = referencematerial;
                    app.base.project.session.spot.type(spotnumber) = type;

                    if bracket_id_not_given == true
                        update_bracket_id(app)
                    elseif bracket_id_not_given == false
                        app.base.project.session.spot.bracket_id(spotnumber) = bracket_id;
                        update_bracket_id(app)
                    end

                end

                if isfield(settings, 'classification_module_GUI_update_state') && settings.classification_module_GUI_update_state == true
                    update_Classification_Module_GUI(app)
                end

            catch ME
                DisplayError(ME,'assign_spots_to_reference_material')

                message = "assign_spots_to_reference_material failed";
                uialert(app.UIFigure,message,"Warning", ...
                    "Icon","warning");
                disp("assign_spots_to_reference_material failed")
            end

        end

        function launch_drift_module(app)
            settings.ICP_Base_GUI_update_state = true;
            [app.project_id, app.session_id] = save_to_base( ...
                app.sourceapp, app.project_id, ...
                app.base.project.session, app.session_id, ...
                app.base.project_name, settings);
            Drift_Module(app.sourceapp, app.base.project_name, ...
                app.project_id, app.session_id)

        end


        function update_progress_buttons(app)

            status = app.base.project.session.config.module_status;

            green = [204/255, 1, 204/255];
            orange = [1, 229/255, 204/255];
            red = [1, 204/255, 204/255];

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

            app.ClassificationButton.Enable = "on";
            app.ClassificationButton.BackgroundColor = orange; % orange because this is the active module
            app.ClassificationButton.FontWeight = "bold";

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

        function update_Classification_Module_GUI(app)

            % assign spots to reference materials
            % Ensure the first item is a cell array of character vectors
            app.RMListBox.Items = {'---------'};
            app.RMListBox.ItemsData = 0;
            % Convert the names to a cell array of character vectors
            if isfield(app.base.project.session, 'referencematerials')

                names = cellstr(app.base.project.session.referencematerials.names);
                if isempty(names)
                    message = "The chosen RM file folder contains no RM files. Maybe the folder was renamed or moved. You can change the folder path in this module in the Settings menu.";
                    uialert(app.UIFigure,message,"Warning", ...
                        "Icon","warning");
                end
                % Append the rest of the items from the referencematerials.names
                app.RMListBox.Items = [app.RMListBox.Items, names'];
                app.RMListBox.ItemsData = [app.RMListBox.ItemsData, 1:numel(names)];

            end

            if any(app.base.project.session.spot.type == "ICM")
                app.ProceedtoDriftModuleButton.Text            = 'Configure Interference Correction';
                app.ProceedtoDriftModuleButton.BackgroundColor = [204/255, 204/255, 1];
                app.ProceedtoDriftModuleButton.FontSize        = 11;
            else
                app.ProceedtoDriftModuleButton.Text            = 'Proceed to Drift Module';
                app.ProceedtoDriftModuleButton.BackgroundColor = [0.96, 0.96, 0.96];
                app.ProceedtoDriftModuleButton.FontSize        = 12;
            end

            update_bracket_id(app)
            update_reference_material_table(app)
            update_refmat_table_colours(app)
            update_reference_material_table(app)

        end


    end



    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, sourceapp, project_name, project_id, session_id, data)
            center_figure(app, app.UIFigure)


            if exist("sourceapp","var")
                app.sourceapp = sourceapp;
            end% input argument of startupfcn

            if exist("project_name", "var")
                app.base.project_name = project_name;
            end

            if  exist("data", "var") % e.g. for API call

                app.base.project.session =  app.sourceapp.base(project_id).project(session_id).session;
                app.base.project.session.config.module_status.classification = true;


            elseif exist("project_id","var") && exist("session_id","var") % coming from the base, GUI stuff

                app.base.project.session =  app.sourceapp.base(project_id).project(session_id).session;

            end

            app.project_id = project_id;
            app.session_id = session_id;
            app.UIFigure.Name = [char(app.base.project_name) ' - ' char(app.base.project.session.session_name)]; %string(app.base.project.session.session_name);


            % Only set default values if fields don't exist or are empty
            if ~isfield(app.base.project.session.spot, 'type') || isempty(app.base.project.session.spot.type)
                app.base.project.session.spot.type = repmat("Unknown", 1, numel(app.base.project.session.spot.name))';
            end

            if ~isfield(app.base.project.session.spot, 'referencematerial') || isempty(app.base.project.session.spot.referencematerial)
                app.base.project.session.spot.referencematerial = repmat("None", 1, numel(app.base.project.session.spot.name))';
            end

            if ~isfield(app.base.project.session.spot, 'bracket_id') || isempty(app.base.project.session.spot.bracket_id)
                app.base.project.session.spot.bracket_id = zeros(1, numel(app.base.project.session.spot.name))';
            end


            update_progress_buttons(app)


            % Change "PRM" to "CAL" & "SRM" to "QCRM"-Backwards compatibility
            app.base.project.session.spot.type(app.base.project.session.spot.type == "PRM") = "CAL";
            app.base.project.session.spot.type(app.base.project.session.spot.type == "SRM") = "QCRM";

            % Change session.spot.prm_sensitivities to session.spot.cal_sensitivities
            if isfield(app.base.project.session.spot, 'prm_sensitivities')
                % Copy data to the new field
                [app.base.project.session.spot.cal_sensitivities] = app.base.project.session.spot.prm_sensitivities;
                % Remove the old field
                app.base.project.session.spot = rmfield(app.base.project.session.spot, 'prm_sensitivities');
            end

            %update GUI
            update_Classification_Module_GUI(app)
            
            app.UIFigure.Tag = sprintf('%d_%d', app.project_id, app.session_id);

            watch_session_changes(app);
        end

        % Button pushed function: ProceedtoDriftModuleButton
        function ProceedtoDriftModuleButtonPushed(app, event)

            if ~any(app.base.project.session.spot.type == "CAL")
                uialert(app.UIFigure, "Assign at least one calibrator (CAL) with a reference material.", "Warning", "Icon", "warning");
                return
            end

            if any(contains(unique(app.base.project.session.spot.referencematerial), 'Select Reference Material'))...
                    || any(contains(unique(app.base.project.session.spot.type), 'Select Type'))
                message = "Select Reference Material and Type for all QCRM and CAL";
                uialert(app.UIFigure, message, "Warning", "Icon", "warning");
                disp("Select Reference Material and Type for all QCRM and CAL")
                return
            end

            if app.editstatus == true
                fig = app.UIFigure;
                msg = "Do you want to proceed?";
                title = "ICP-Base";
                selection = uiconfirm(fig, msg, title, ...
                    "Options", ["Yes","Cancel"], ...
                    "DefaultOption", 1, "CancelOption", 2);
            else
                selection = 'Yes';
            end

            switch selection
                case 'Yes'

                    session_config = app.base.project.session.config;
                    if ~isfield(session_config, 'module_status') ...
                            || ~isfield(session_config.module_status, 'classification') ...
                            || ~isequal(session_config.module_status.classification, true)
                        app.base.project.session.config.module_status.classification = true;
                    end

                    if any(app.base.project.session.spot.type == "ICM")
                        icm_progress = uiprogressdlg(app.UIFigure, 'Title', 'Configure interference correction settings...', ...
                            'Message', 'Close the Interference Correction Configuration Submodule to access the Classification Module again', ...
                            'Cancelable', 'off', 'Indeterminate', 'on');
                        app.icm_submodule = Interference_Correction_Submodule(app, icm_progress);
                    else
                        progress = uiprogressdlg(app.UIFigure, 'Title', 'Correcting drift...', ...
                            'Message', 'Calculating...', 'Cancelable', 'off', 'Indeterminate', 'on');
                        source_app = app.sourceapp; 
                        launch_drift_module(app)
                        delete(progress)
                        delete(app)

                        refresh_session_buttons(source_app)
                    end
                case 'Cancel'
                    return
            end

        end

        % Button pushed function: CalibratorButton
        function CalibratorButtonPushed(app, event)
            changes = check_changes(app, 'classification');
            if changes == false
                return
            end
            app.editstatus = true;

            app.base.project.session.spot.type(app.selected_spot) = "CAL";

            % deselect the analytes to cirumvent weird behaviour
            %app.selected_analytes = [];

            update_Classification_Module_GUI(app)
        end

        % Value changed function: RMListBox
        function RMListBoxValueChanged(app, event)
            if isequal(app.RMListBox.Value, 0)
                return
            end
            
            changes = check_changes(app, 'classification');
            if changes == false
                return
            end
            app.editstatus = true;

            app.selected_referencematerial = app.RMListBox.Value;

            app.base.project.session.spot.referencematerial(app.selected_spot) = app.base.project.session.referencematerials.names(app.selected_referencematerial);

            % deselect the analytes to cirumvent weird behaviour
            %app.selected_analytes = [];

            update_Classification_Module_GUI(app)
        end

        % Button pushed function: 
        % QualityControlReferenceMaterialOptionalButton
        function QualityControlReferenceMaterialOptionalButtonPushed(app, event)
            changes = check_changes(app, 'classification');
            if changes == false
                return
            end
            app.editstatus = true;

            app.base.project.session.spot.type(app.selected_spot) = "QCRM";

            update_Classification_Module_GUI(app)
        end

        % Button pushed function: 
        % InterferenceCorrectionMaterialOptionalButton
        function InterferenceCorrectionMaterialOptionalButtonPushed(app, event)

            changes = check_changes(app, 'classification');
            if changes == false
                return
            end
            app.editstatus = true;

            app.base.project.session.spot.type(app.selected_spot) = "ICM";
            app.base.project.session.spot.referencematerial(app.selected_spot) = "None";

            update_Classification_Module_GUI(app)
        end

        % Button pushed function: UnknownButton
        function UnknownButtonPushed(app, event)
            changes = check_changes(app, 'classification');
            if changes == false
                return
            end
            app.editstatus = true;

            app.base.project.session.spot.type(app.selected_spot) = "Unknown";
            app.base.project.session.spot.referencematerial(app.selected_spot) = "None";

            update_Classification_Module_GUI(app)

        end

        % Callback function: ReferenceMaterialTable
        function ReferenceMaterialTableSelectionChanged(app, event)
            app.selected_spot = unique(app.ReferenceMaterialTable.Selection(:,1));

            app.ChosenEditField.Value = '';
            app.ContainsEditField.Value = '';
            %update_Classification_Module_GUI(app)
        end

        % Button pushed function: ResetButton
        function ResetButtonPushed(app, event)
            changes = check_changes(app, 'classification');
            if changes == false
                return
            end
            app.editstatus = true;
            
            app.base.project.session.spot.type = repmat("Unknown", 1, numel(app.base.project.session.spot.name))';
            app.base.project.session.spot.referencematerial = repmat("None", 1, numel(app.base.project.session.spot.name))';
            app.base.project.session.spot.bracket_id = zeros(1, numel(app.base.project.session.spot.name))';

            update_Classification_Module_GUI(app)

        end

        % Value changed function: ContainsEditField
        function ContainsEditFieldValueChanged(app, event)
            %ChooseButtonPushed(app, event)

            %             app.selected_string = app.ContainsEditField.Value;
            %
            %             % Initialize an empty array to store the indices of the selected spots
            %             selected_spot_indices = [];
            %
            %             % Iterate through the spot names
            %             for i = 1:length(app.base.project.session.spot.name)
            %                 % Check if the spot name contains the selected string
            %                 if contains(app.base.project.session.spot.name(i), app.selected_string)
            %                     % If it does, add the index to the selected_spot_indices array
            %                     selected_spot_indices(end+1) = i;
            %                 end
            %             end
            %
            %             % Store the selected spot indices in the app property
            %             app.selected_spot = selected_spot_indices;

        end

        % Callback function: ExitMenu, UIFigure
        function ExitMenuSelected(app, event)
            if ~isempty(app.icm_submodule) && isvalid(app.icm_submodule)
                uialert(app.UIFigure, 'Close the Interference Correction Configuration Submodule first.', 'Cannot Close');
                return
            end

            if isempty(app.base) || isempty(app.base.project)
                source_app = app.sourceapp;
                delete(app)
                try
                    refresh_session_buttons(source_app)
                catch ME
                    DisplayError(ME, 'Refreshing session buttons after closing a module');
                end
                return
            end

            settings.ICP_Base_GUI_update_state = true;

              session_config = app.base.project.session.config;
            if ~isfield(session_config, 'module_status') ...
                    || ~isfield(session_config.module_status, 'classification') ...
                    || ~session_config.module_status.classification
                app.base.project.session.config.module_status.classification = true;
            end

            save_to_base(app.sourceapp, app.project_id, app.base.project.session, app.session_id, app.base.project_name, settings);

            source_app = app.sourceapp;      % must be taken before delete(app)
            delete(app)

            % the window is gone now, so the base can enable the session buttons again
            try
                refresh_session_buttons(source_app)
            catch ME
                DisplayError(ME, 'Refreshing session buttons after closing a module');
            end
        end

        % Button pushed function: DriftButton, ImportButton, 
        % IntervalButton, QuantificationButton, ResultsButton
        function ImportButtonPushed(app, event)
            try
                if any(contains(unique(app.base.project.session.spot.referencematerial), 'Select Reference Material'))...
                        || any(contains(unique(app.base.project.session.spot.type), 'Select Type'))

                    message = "Select Reference Material and Type for all QCRM and CAL";
                    uialert(app.UIFigure,message,"Warning", ...
                        "Icon","warning");
                    disp("Select Reference Material and Type for all QCRM and CAL")
                    return
                end

                if app.editstatus == true
                    % uiconfirm ask user if finished
                    fig = app.UIFigure;
                    msg = "Do you want to jump modules?";
                    title = "ICP-Base";
                selection = uiconfirm(fig,msg,title, ...
                    "Options",["Yes","Cancel"], ...
                    "DefaultOption",1,"CancelOption",2);
                else
                    selection = 'Yes';
                end

                switch selection
                    case 'Yes'
                        settings.ICP_Base_GUI_update_state = true;
                        [app.project_id, app.session_id] = save_to_base(app.sourceapp, app.project_id, app.base.project.session, app.session_id, app.base.project_name, settings);

                        switch event.Source.Parent.Parent.Parent.Parent.CallbackObject.Text
                            case 'Import'
                                Import_Module(app.sourceapp, app.base.project_name, app.project_id, app.session_id)
                            case 'Interval'
                                Interval_Module(app.sourceapp, app.base.project_name, app.project_id, app.session_id)
                            case 'Classification'
                                Classification_Module(app.sourceapp, app.base.project_name, app.project_id, app.session_id)
                            case 'Drift'
                                Drift_Module(app.sourceapp, app.base.project_name, app.project_id, app.session_id)
                            case 'Quantification'
                                Quantification_Module(app.sourceapp, app.base.project_name, app.project_id, app.session_id)
                            case 'Results'
                                Results_Module(app.sourceapp, app.base.project_name, app.project_id, app.session_id)
                        end

                        delete(app)

                    case 'Cancel'

                        return
                end
            catch ME
                DisplayError(ME,'Proceed to other module failed')
                message = "Proceeding to other module failed";
                uialert(app.UIFigure,message,"Warning", ...
                    "Icon","warning");

                return
            end
        end

        % Cell edit callback: ReferenceMaterialTable
        function ReferenceMaterialTableCellEdit(app, event)
            %indices = event.Indices;
            newData = event.NewData;

            if ~isnumeric(newData) || newData < 1 || floor(newData) ~= newData
                uialert(app.UIFigure, 'Bracket ID must be a positive integer.', 'Invalid Input');
                update_Classification_Module_GUI(app)
                return
            end

            changes = check_changes(app, 'classification');
            if changes == false
                return
            end
            app.editstatus = true;

            for spot_idx = app.selected_spot'

                if ~isequal(app.base.project.session.spot.bracket_id(spot_idx), 0)
                    app.base.project.session.spot.bracket_id(spot_idx) = newData;
                else
                    app.base.project.session.spot.bracket_id(spot_idx) = 0;
                end

            end

            update_Classification_Module_GUI(app)
        end

        % Button pushed function: GroupbyspotsizeButton
        function GroupbyspotsizeButtonPushed(app, event)

            changes = check_changes(app, 'classification');
            if changes == false
                return
            end
            app.editstatus = true;

            if all(app.base.project.session.spot.bracket_id == 0)
                uialert(app.UIFigure, 'No Calibrators have been assigned. Please classify your spots first.', 'Warning', 'Icon', 'warning');
                return
            end

            if ~isfield(app.base.project.session.meta, 'laser_parameters') || ...
                    ~isfield(app.base.project.session.meta.laser_parameters, 'spotsize') || ...
                    isempty(app.base.project.session.meta.laser_parameters.spotsize)
                uialert(app.UIFigure, 'No laser metadata was imported. Spot sizes are not available.', 'Warning', 'Icon', 'warning');
                return
            end


            spotsize = app.base.project.session.meta.laser_parameters.spotsize;
            spot_type = app.base.project.session.spot.type;
            bracket_id = app.base.project.session.spot.bracket_id;

            % Initialize a new bracket_id array
            new_bracket_id = zeros(size(bracket_id));

            % Get unique spotsizes
            unique_spotsizes = unique(spotsize(spot_type == "CAL"));

            % Initialize a counter for each spotsize
            counter = 1;

            % Loop through each unique spotsize
            for i = 1:length(unique_spotsizes)
                current_spotsize = unique_spotsizes(i);

                % Find indices where the spotsize matches and the type is "CAL"
                indices = (spotsize == current_spotsize) & (spot_type == "CAL");

                % Assign sequential bracket_id values for these indices
                new_bracket_id(indices) = counter;

                % Increment the counter
                counter = counter + 1;
            end

            % Update the original bracket_id with the new values
            app.base.project.session.spot.bracket_id = new_bracket_id;

            update_Classification_Module_GUI(app)
        end

        % Button pushed function: ChooseButton
        function ChooseButtonPushed(app, event)
            
            app.selected_string = app.ContainsEditField.Value;

            % Initialize an empty array to store the indices of the selected spots
            selected_spot_indices = [];

            % Iterate through the spot names
            for i = 1:length(app.base.project.session.spot.name)
                % Check if the spot name contains the selected string
                if contains(app.base.project.session.spot.name(i), app.selected_string)
                    % If it does, add the index to the selected_spot_indices array
                    selected_spot_indices(end+1) = i;
                end
            end

            % Store the selected spot indices in the app property
            app.selected_spot = selected_spot_indices;

            app.ChosenEditField.Value = app.selected_string;
            app.ContainsEditField.Value = '';

            %update_Classification_Module_GUI(app)
        end

        % Menu selected function: ChangereferencematerialfolderMenu
        function ChangereferencematerialfolderMenuSelected(app, event)

            changes = check_changes(app, 'classification');
            if changes == false
                return
            end
            app.editstatus = true;

            % Open folder selection dialog
            selectedFolder = uigetdir('', 'Select Reference Material Folder');

            % Check if user selected a folder (not cancelled)
            if selectedFolder == 0
                return
            end

            % Store the selected folder path (adjust property name as needed)
            app.base.project.session.config.RM_folder_path = selectedFolder;

            % Call your existing function
            get_RM_Files(app)

            update_Classification_Module_GUI(app)
        end

        % Button pushed function: GetRMfilesButton
        function GetRMfilesButtonPushed(app, event)
            changes = check_changes(app, 'classification');
            if changes == false
                return
            end
            app.editstatus = true;


            % read in the RM Files
            try
                if ~isfield(app.base.project.session.config, 'RM_folder_path')

                    % Check if the main app has the path property set (User Documents)
                    if isprop(app.sourceapp, 'default_RM_path') && ~isempty(app.sourceapp.default_RM_path)
                        app.base.project.session.config.RM_folder_path = app.sourceapp.default_RM_path;

                        % Fallback (Installation Directory)
                    elseif exist(fullfile(app.sourceapp.installpath, 'RM_Files'), 'dir')
                        app.base.project.session.config.RM_folder_path = fullfile(app.sourceapp.installpath, 'RM_Files');
                    end
                end
            catch ME
                DisplayError(ME,'Error reading RM files')
                message={'Error getting the RM folder path.'};
                uialert(app.UIFigure,message,' Error');
            end

                get_RM_Files(app)


            update_Classification_Module_GUI(app)
        end

        % Menu selected function: ShowRMvaluesMenu
        function ShowRMvaluesMenuSelected(app, event)
           
            if isempty(app.selected_spot)
                uialert(app.UIFigure, "Click on a spot first", "No spot selected");
                return;
            end

            if ~isequal(numel(app.selected_spot), 1)
                uialert(app.UIFigure, "Only select one spot!", "Too many spots selected");
                return;
            end

            % Selected reference material name for the current spot
            rm_name = string(app.base.project.session.spot.referencematerial(app.selected_spot));

            if isequal(rm_name, "None")
                uialert(app.UIFigure, "Don't select None", "None is not a reference material");
                return;
            end

            % All available RM names
            rm_names = string(app.base.project.session.referencematerials.names);

            % Find matching RM
            idx = find(rm_names == rm_name, 1);

            if isempty(idx)
                uialert(app.UIFigure, "Reference material '" + rm_name + "' was not found.", "RM not found");
                return;
            end

            % Reference values
            rmRefData = app.base.project.session.referencematerials.data{idx};

            % Uncertainty values
            % Adjust this line if your uncertainty is stored under a different field
            rmUncData = app.base.project.session.referencematerials.uncertainty{idx};

            if isempty(rmUncData)

                % Build display cell array with a first label column
                displayData = [
                    [{'µg/g'}, table2cell(rmRefData)]
                    ];

            else

                % Build display cell array with a first label column
                displayData = [
                    [{'µg/g'}, table2cell(rmRefData)];
                    [{'± µg/g'   }, table2cell(rmUncData)]
                    ];

            end

            % Column names
            colNames = [{''}, rmRefData.Properties.VariableNames];

            % Create popup window
            figWidth = min(max(120 * numel(colNames), 700), 1800);
            fig = uifigure( ...
                'Name', rm_name + " - These values can be changed in the .csv files in: " + app.base.project.session.config.RM_folder_path, ...
                'Position', [100 100 figWidth 170]);

            % Create table
            uit = uitable(fig);
            uit.Position = [20 20 figWidth - 40 130];
            uit.Data = displayData;
            uit.ColumnName = colNames;
            uit.RowName = {};
            uit.ColumnEditable = false(1, numel(colNames));
            uit.ColumnWidth = repmat({'auto'}, 1, numel(colNames));


        end

        % Button pushed function: ClassificationButton
        function ClassificationButtonPushed(app, event)
            
        end

        % Callback function
        function UIFigureCloseRequest(app, event)
 
        end

        % Button pushed function: ShowdwelltimesButton
        function ShowdwelltimesButtonPushed(app, event)
              % Create a new figure window
            fig = uifigure('Name', 'Dwell Times', 'Position', [100 100 1200 100]);

            % Create a uitable
            uit = uitable(fig);
            uit.Position = [20 20 1160 70];

            % Get the dwell times data
            dwellData = app.base.project.session.spot.dwelltimes;

            % Set the data and column names
            uit.Data = table2array(dwellData);
            uit.ColumnName = dwellData.Properties.VariableNames;

            % Make table editable
            uit.ColumnEditable = true(1, width(dwellData));

            % Add cell edit callback to validate and update values
            uit.CellEditCallback = @(src, event) updateDwellTime(app, src, event);

            % Adjust column widths
            uit.ColumnWidth = repmat({50}, 1, width(dwellData));


        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 788 723];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.Icon = 'icon_48.png';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @ExitMenuSelected, true);

            % Create BaseMenu
            app.BaseMenu = uimenu(app.UIFigure);
            app.BaseMenu.Text = 'Base';

            % Create ExitMenu
            app.ExitMenu = uimenu(app.BaseMenu);
            app.ExitMenu.MenuSelectedFcn = createCallbackFcn(app, @ExitMenuSelected, true);
            app.ExitMenu.Text = 'Exit';

            % Create SettingsMenu
            app.SettingsMenu = uimenu(app.UIFigure);
            app.SettingsMenu.Text = 'Settings';

            % Create ChangereferencematerialfolderMenu
            app.ChangereferencematerialfolderMenu = uimenu(app.SettingsMenu);
            app.ChangereferencematerialfolderMenu.MenuSelectedFcn = createCallbackFcn(app, @ChangereferencematerialfolderMenuSelected, true);
            app.ChangereferencematerialfolderMenu.Text = 'Change reference material folder';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {5, '1x', 56, 52, 43, 52, 64, 95, 103, 99, 120, 5};
            app.GridLayout.RowHeight = {36, 58, 25, '1x', 27, 5};
            app.GridLayout.ColumnSpacing = 7.4;
            app.GridLayout.RowSpacing = 13;
            app.GridLayout.Padding = [7.4 13 7.4 13];

            % Create ReferenceMaterialTable
            app.ReferenceMaterialTable = uitable(app.GridLayout);
            app.ReferenceMaterialTable.ColumnName = {'#'; 'Spotname'; 'Type'; 'RM Name'; 'Bracket id'};
            app.ReferenceMaterialTable.ColumnWidth = {'fit'};
            app.ReferenceMaterialTable.RowName = {};
            app.ReferenceMaterialTable.ColumnSortable = [true true true true true];
            app.ReferenceMaterialTable.ColumnEditable = [false false false false true];
            app.ReferenceMaterialTable.CellEditCallback = createCallbackFcn(app, @ReferenceMaterialTableCellEdit, true);
            app.ReferenceMaterialTable.SelectionChangedFcn = createCallbackFcn(app, @ReferenceMaterialTableSelectionChanged, true);
            app.ReferenceMaterialTable.Layout.Row = [3 4];
            app.ReferenceMaterialTable.Layout.Column = [2 10];

            % Create RMListBox
            app.RMListBox = uilistbox(app.GridLayout);
            app.RMListBox.Items = {''};
            app.RMListBox.ValueChangedFcn = createCallbackFcn(app, @RMListBoxValueChanged, true);
            app.RMListBox.Layout.Row = 4;
            app.RMListBox.Layout.Column = 11;
            app.RMListBox.Value = '';

            % Create ResetButton
            app.ResetButton = uibutton(app.GridLayout, 'push');
            app.ResetButton.ButtonPushedFcn = createCallbackFcn(app, @ResetButtonPushed, true);
            app.ResetButton.Layout.Row = 5;
            app.ResetButton.Layout.Column = 10;
            app.ResetButton.Text = 'Reset';

            % Create CalibratorButton
            app.CalibratorButton = uibutton(app.GridLayout, 'push');
            app.CalibratorButton.ButtonPushedFcn = createCallbackFcn(app, @CalibratorButtonPushed, true);
            app.CalibratorButton.WordWrap = 'on';
            app.CalibratorButton.Layout.Row = 2;
            app.CalibratorButton.Layout.Column = [10 11];
            app.CalibratorButton.Text = 'Calibrator';

            % Create QualityControlReferenceMaterialOptionalButton
            app.QualityControlReferenceMaterialOptionalButton = uibutton(app.GridLayout, 'push');
            app.QualityControlReferenceMaterialOptionalButton.ButtonPushedFcn = createCallbackFcn(app, @QualityControlReferenceMaterialOptionalButtonPushed, true);
            app.QualityControlReferenceMaterialOptionalButton.WordWrap = 'on';
            app.QualityControlReferenceMaterialOptionalButton.Layout.Row = 2;
            app.QualityControlReferenceMaterialOptionalButton.Layout.Column = [8 9];
            app.QualityControlReferenceMaterialOptionalButton.Text = 'Quality Control Reference Material (Optional)';

            % Create InterferenceCorrectionMaterialOptionalButton
            app.InterferenceCorrectionMaterialOptionalButton = uibutton(app.GridLayout, 'push');
            app.InterferenceCorrectionMaterialOptionalButton.ButtonPushedFcn = createCallbackFcn(app, @InterferenceCorrectionMaterialOptionalButtonPushed, true);
            app.InterferenceCorrectionMaterialOptionalButton.WordWrap = 'on';
            app.InterferenceCorrectionMaterialOptionalButton.Layout.Row = 2;
            app.InterferenceCorrectionMaterialOptionalButton.Layout.Column = [5 7];
            app.InterferenceCorrectionMaterialOptionalButton.Text = 'Interference Correction Material (Optional)';

            % Create ProceedtoDriftModuleButton
            app.ProceedtoDriftModuleButton = uibutton(app.GridLayout, 'push');
            app.ProceedtoDriftModuleButton.ButtonPushedFcn = createCallbackFcn(app, @ProceedtoDriftModuleButtonPushed, true);
            app.ProceedtoDriftModuleButton.WordWrap = 'on';
            app.ProceedtoDriftModuleButton.Layout.Row = [5 6];
            app.ProceedtoDriftModuleButton.Layout.Column = 11;
            app.ProceedtoDriftModuleButton.Text = 'Proceed to Drift Module';

            % Create UnknownButton
            app.UnknownButton = uibutton(app.GridLayout, 'push');
            app.UnknownButton.ButtonPushedFcn = createCallbackFcn(app, @UnknownButtonPushed, true);
            app.UnknownButton.Layout.Row = 2;
            app.UnknownButton.Layout.Column = [3 4];
            app.UnknownButton.Text = 'Unknown';

            % Create ProgressPanel
            app.ProgressPanel = uipanel(app.GridLayout);
            app.ProgressPanel.Layout.Row = 1;
            app.ProgressPanel.Layout.Column = [2 11];

            % Create IntervalButton
            app.IntervalButton = uibutton(app.ProgressPanel, 'push');
            app.IntervalButton.ButtonPushedFcn = createCallbackFcn(app, @ImportButtonPushed, true);
            app.IntervalButton.Position = [131 7 100 23];
            app.IntervalButton.Text = 'Interval';

            % Create ImportButton
            app.ImportButton = uibutton(app.ProgressPanel, 'push');
            app.ImportButton.ButtonPushedFcn = createCallbackFcn(app, @ImportButtonPushed, true);
            app.ImportButton.Position = [11 7 100 23];
            app.ImportButton.Text = 'Import';

            % Create ClassificationButton
            app.ClassificationButton = uibutton(app.ProgressPanel, 'push');
            app.ClassificationButton.ButtonPushedFcn = createCallbackFcn(app, @ClassificationButtonPushed, true);
            app.ClassificationButton.Position = [263 7 100 23];
            app.ClassificationButton.Text = 'Classification';

            % Create DriftButton
            app.DriftButton = uibutton(app.ProgressPanel, 'push');
            app.DriftButton.ButtonPushedFcn = createCallbackFcn(app, @ImportButtonPushed, true);
            app.DriftButton.Position = [389 7 100 23];
            app.DriftButton.Text = 'Drift';

            % Create QuantificationButton
            app.QuantificationButton = uibutton(app.ProgressPanel, 'push');
            app.QuantificationButton.ButtonPushedFcn = createCallbackFcn(app, @ImportButtonPushed, true);
            app.QuantificationButton.Position = [509 7 100 23];
            app.QuantificationButton.Text = 'Quantification';

            % Create ResultsButton
            app.ResultsButton = uibutton(app.ProgressPanel, 'push');
            app.ResultsButton.ButtonPushedFcn = createCallbackFcn(app, @ImportButtonPushed, true);
            app.ResultsButton.Position = [633 7 100 23];
            app.ResultsButton.Text = 'Results';

            % Create ContainsEditFieldLabel
            app.ContainsEditFieldLabel = uilabel(app.GridLayout);
            app.ContainsEditFieldLabel.HorizontalAlignment = 'right';
            app.ContainsEditFieldLabel.Layout.Row = 5;
            app.ContainsEditFieldLabel.Layout.Column = 3;
            app.ContainsEditFieldLabel.Text = 'Contains:';

            % Create ContainsEditField
            app.ContainsEditField = uieditfield(app.GridLayout, 'text');
            app.ContainsEditField.ValueChangedFcn = createCallbackFcn(app, @ContainsEditFieldValueChanged, true);
            app.ContainsEditField.Layout.Row = 5;
            app.ContainsEditField.Layout.Column = [4 5];

            % Create GroupbyspotsizeButton
            app.GroupbyspotsizeButton = uibutton(app.GridLayout, 'push');
            app.GroupbyspotsizeButton.ButtonPushedFcn = createCallbackFcn(app, @GroupbyspotsizeButtonPushed, true);
            app.GroupbyspotsizeButton.FontSize = 11;
            app.GroupbyspotsizeButton.Layout.Row = 5;
            app.GroupbyspotsizeButton.Layout.Column = 9;
            app.GroupbyspotsizeButton.Text = 'Group by spotsize';

            % Create ChooseButton
            app.ChooseButton = uibutton(app.GridLayout, 'push');
            app.ChooseButton.ButtonPushedFcn = createCallbackFcn(app, @ChooseButtonPushed, true);
            app.ChooseButton.Layout.Row = 5;
            app.ChooseButton.Layout.Column = 6;
            app.ChooseButton.Text = 'Choose';

            % Create ChosenEditField
            app.ChosenEditField = uieditfield(app.GridLayout, 'text');
            app.ChosenEditField.Editable = 'off';
            app.ChosenEditField.FontAngle = 'italic';
            app.ChosenEditField.FontColor = [0.502 0.502 0.502];
            app.ChosenEditField.Layout.Row = 5;
            app.ChosenEditField.Layout.Column = 7;

            % Create GetRMfilesButton
            app.GetRMfilesButton = uibutton(app.GridLayout, 'push');
            app.GetRMfilesButton.ButtonPushedFcn = createCallbackFcn(app, @GetRMfilesButtonPushed, true);
            app.GetRMfilesButton.BackgroundColor = [0.9412 0.9412 0.9412];
            app.GetRMfilesButton.Layout.Row = 3;
            app.GetRMfilesButton.Layout.Column = 11;
            app.GetRMfilesButton.Text = 'Get RM files';

            % Create ShowdwelltimesButton
            app.ShowdwelltimesButton = uibutton(app.GridLayout, 'push');
            app.ShowdwelltimesButton.ButtonPushedFcn = createCallbackFcn(app, @ShowdwelltimesButtonPushed, true);
            app.ShowdwelltimesButton.FontSize = 11;
            app.ShowdwelltimesButton.Layout.Row = 5;
            app.ShowdwelltimesButton.Layout.Column = 8;
            app.ShowdwelltimesButton.Text = 'Show dwelltimes';

            % Create ContextMenu2
            app.ContextMenu2 = uicontextmenu(app.UIFigure);

            % Create ShowRMvaluesMenu
            app.ShowRMvaluesMenu = uimenu(app.ContextMenu2);
            app.ShowRMvaluesMenu.MenuSelectedFcn = createCallbackFcn(app, @ShowRMvaluesMenuSelected, true);
            app.ShowRMvaluesMenu.Text = 'Show RM values';
            
            % Assign app.ContextMenu2
            app.ReferenceMaterialTable.ContextMenu = app.ContextMenu2;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Classification_Module_readable(varargin)

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