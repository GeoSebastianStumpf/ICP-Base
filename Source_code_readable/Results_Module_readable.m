% GENERATED from Results_Module.mlapp on 2026-10-28 16:53 by export_mlapp_to_m. This file is for reading purposes, any real changes need to be applied to the .mlapp files and exported again.
classdef Results_Module_readable < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        BaseMenu                        matlab.ui.container.Menu
        ExitMenu                        matlab.ui.container.Menu
        SettingsMenu                    matlab.ui.container.Menu
        AdjustQCRMAxisFontsizeMenu      matlab.ui.container.Menu
        AdjustQCRMAxisMarkersizeMenu    matlab.ui.container.Menu
        GridLayout                      matlab.ui.container.GridLayout
        TabGroup                        matlab.ui.container.TabGroup
        AllResultsTab                   matlab.ui.container.Tab
        GridLayout2                     matlab.ui.container.GridLayout
        ShowCommentsCheckBox            matlab.ui.control.CheckBox
        ShowDropDown                    matlab.ui.control.DropDown
        ShowDropDownLabel               matlab.ui.control.Label
        BracketidDropDown               matlab.ui.control.DropDown
        BracketidDropDownLabel          matlab.ui.control.Label
        CalibratorDropDown              matlab.ui.control.DropDown
        CalibratorDropDownLabel         matlab.ui.control.Label
        CreateOutputTableButton         matlab.ui.control.Button
        HostInclusionDropDown           matlab.ui.control.DropDown
        ResultsTable                    matlab.ui.control.Table
        OutputTableTab                  matlab.ui.container.Tab
        TabGroup3                       matlab.ui.container.TabGroup
        AnalyteCalibratorAssignmentTab  matlab.ui.container.Tab
        UpdateTablePreviewButton        matlab.ui.control.Button
        Label_3                         matlab.ui.control.Label
        Label_2                         matlab.ui.control.Label
        Label                           matlab.ui.control.Label
        CALTree                         matlab.ui.container.CheckBoxTree
        AnalyteTable                    matlab.ui.control.Table
        OutputTablePreview              matlab.ui.container.Tab
        AllvaluesinggunlessexpressedasoxidesmassLabel  matlab.ui.control.Label
        SendtoVisModuleButton           matlab.ui.control.Button
        IncludeMetadataCheckBox         matlab.ui.control.CheckBox
        MajorsasOxideswtCheckBox        matlab.ui.control.CheckBox
        RemovemassesfromanalytenameCheckBox  matlab.ui.control.CheckBox
        CreateOutputTableButton_2       matlab.ui.control.Button
        EnddataprocessingButton_2       matlab.ui.control.Button
        HostInclusionDropDown_2         matlab.ui.control.DropDown
        AssignedTable                   matlab.ui.control.Table
        QualityControlOptionalTab       matlab.ui.container.Tab
        TabGroup2                       matlab.ui.container.TabGroup
        QCReferenceMaterialsTab         matlab.ui.container.Tab
        ShowuncertaintiesCheckBox       matlab.ui.control.CheckBox
        LogscaleCheckBox_2              matlab.ui.control.CheckBox
        QualityControlReferenceMaterialDropDown  matlab.ui.control.DropDown
        QualityControlReferenceMaterialDropDownLabel  matlab.ui.control.Label
        BracketidDropDown_2             matlab.ui.control.DropDown
        BracketidDropDown_2Label        matlab.ui.control.Label
        CalibratorDropDown_2            matlab.ui.control.DropDown
        CalibratorDropDown_2Label       matlab.ui.control.Label
        GotoCorrectionModuleButton      matlab.ui.control.Button
        QCRMAxes                        matlab.ui.control.UIAxes
        MatrixSensitivityFactorMSFTab   matlab.ui.container.Tab
        ExportTableButton               matlab.ui.control.Button
        ShowLegendCheckBox              matlab.ui.control.CheckBox
        DenominatorListBox              matlab.ui.control.ListBox
        ComparetoDropDown               matlab.ui.control.DropDown
        ComparetoDropDownLabel          matlab.ui.control.Label
        RatioListBox                    matlab.ui.control.ListBox
        SensitivitybasedonDropDown      matlab.ui.control.DropDown
        SensitivitybasedonDropDownLabel  matlab.ui.control.Label
        MSFAxes                         matlab.ui.control.UIAxes
        AddMetadataOptionalTab          matlab.ui.container.Tab
        AddtextcolumnButton             matlab.ui.control.Button
        CustomcolumnnameEditField       matlab.ui.control.EditField
        CustomcolumnnameEditFieldLabel  matlab.ui.control.Label
        ResetButton                     matlab.ui.control.Button
        Panel                           matlab.ui.container.Panel
        GridLayout_2                    matlab.ui.container.GridLayout
        MetadataInputEditField          matlab.ui.control.EditField
        SpotnamecontainsEditField       matlab.ui.control.EditField
        SpotnamecontainsEditFieldLabel  matlab.ui.control.Label
        StringCompareDropDown           matlab.ui.control.DropDown
        ApplyButton                     matlab.ui.control.Button
        AddnumericcolumnButton          matlab.ui.control.Button
        MetadataTable                   matlab.ui.control.Table
        ProgressPanel                   matlab.ui.container.Panel
        ResultsButton                   matlab.ui.control.Button
        QuantificationButton            matlab.ui.control.Button
        DriftButton                     matlab.ui.control.Button
        ClassificationButton            matlab.ui.control.Button
        ImportButton                    matlab.ui.control.Button
        IntervalButton                  matlab.ui.control.Button
        ContextMenu2                    matlab.ui.container.ContextMenu
        OutputallmatrixmassfractionsggMenu  matlab.ui.container.Menu
        OutputallinclusionmassfractionsggMenu  matlab.ui.container.Menu
        OutputallmatrixLODsggMenu       matlab.ui.container.Menu
        OutputallinclusionLODsggMenu    matlab.ui.container.Menu
        ContextMenu3                    matlab.ui.container.ContextMenu
        ShowuncertaintybudgetMenu       matlab.ui.container.Menu
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
    project_id
    session_id
end

    properties (Access = private)
        sourceapp
        selected_CAL
        selected_bracket_id
        selected_host_inclusion
        selected_QCRM
        selected_analytes

        MSF_ratios

        folderPath
        export_lod_table
        export_uncertainty_table

        selected_results_cell

        editstatus = false
    end


    methods (Access = public)



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

            app.ResultsButton.Enable = "on";
            app.ResultsButton.BackgroundColor = orange;
            app.ResultsButton.FontWeight = 'bold';

        end

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

        function d = defaultStartDir(app)
            % Prefer the app's working directory, else fall back to pwd
            d = pwd;
            try
                if isfolder(app.sourceapp.workingdirectory)
                    d = app.sourceapp.workingdirectory;
                end
            catch
                % ignore and keep pwd
            end
        end




        %%%%%%%%%%%%%%%%%%%%%%%%%% GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function update_results_module_GUI(app)

            % % Get unique reference materials
            % uniqueCALs = unique(app.base.project.session.spot.referencematerial);
            % validCALs = uniqueCALs(strcmp(uniqueCALs, 'CAL'));
            %
            % % Populate CAL dropdown
            % app.CalibratorDropDown.Items = validCALs;
            % app.CalibratorDropDown.ItemsData = 1:numel(app.CalibratorDropDown.Items);

            % Get indices where type is "CAL"
            cal_indices = strcmp(app.base.project.session.spot.type, "CAL");
            % Get reference materials only for CAL spots
            cal_materials = app.base.project.session.spot.referencematerial(cal_indices);
            % Get unique names, excluding "None" and "Select Reference Material"
            unique_names = unique(cal_materials);
            unique_names = unique_names(~strcmp(unique_names, 'None'));
            validCALs = unique_names(~strcmp(unique_names, 'Select Reference Material'));

            % Populate CAL dropdown
            app.CalibratorDropDown.Items = validCALs;
            app.CalibratorDropDown.ItemsData = 1:numel(app.CalibratorDropDown.Items);

            % Get selected reference material and find matching indices
            selectedRM = validCALs(app.CalibratorDropDown.Value);
            rmIndices = strcmp(app.base.project.session.spot.referencematerial, selectedRM);

            % Filter bracket IDs for selected reference material
            filteredBracketIds = app.base.project.session.spot.bracket_id(rmIndices);
            uniqueBracketIds = unique(filteredBracketIds);
            uniqueBracketIds = uniqueBracketIds(uniqueBracketIds ~= 0);

            % Update bracket ID dropdown
            app.BracketidDropDown.Items = string(uniqueBracketIds);
            app.BracketidDropDown.ItemsData = uniqueBracketIds;

            % at startup the selected_CAL is empty, make it 1 so that
            % something is plotted anyways
            if isempty(app.selected_CAL)
                app.selected_CAL = 1;
            end
            % Set default bracket_id if empty - use first available bracket_id
            if isempty(app.selected_bracket_id)
                app.selected_bracket_id = uniqueBracketIds(1);
                app.BracketidDropDown.Value = uniqueBracketIds(1);
            end

            if isequal(app.base.project.session.config.reductiontype, 'Inclusion')
                app.HostInclusionDropDown.Items = ["Host", "Inclusion"];
                app.HostInclusionDropDown_2.Items = app.HostInclusionDropDown.Items;

                app.HostInclusionDropDown.ItemsData = app.HostInclusionDropDown.Items;
                app.HostInclusionDropDown_2.ItemsData = app.HostInclusionDropDown.Items;

            elseif isequal(app.base.project.session.config.reductiontype, 'Matrix')
                app.HostInclusionDropDown.Visible = 'off';
                app.HostInclusionDropDown.Enable = 'off';
                app.HostInclusionDropDown.Items = "Host";
                app.HostInclusionDropDown.ItemsData = app.HostInclusionDropDown.Items;

                app.HostInclusionDropDown_2.Visible = 'off';
                app.HostInclusionDropDown_2.Items = app.HostInclusionDropDown.Items;
                app.HostInclusionDropDown_2.ItemsData = app.HostInclusionDropDown.Items;
            end

            if isempty(app.selected_host_inclusion)
                app.selected_host_inclusion = app.HostInclusionDropDown.ItemsData{1};
                update_show_dropdown_items(app)
            end

            app.BracketidDropDown.Visible = 'on';
            app.BracketidDropDown.Enable = 'on';
            app.BracketidDropDownLabel.Visible = 'on';
            app.CalibratorDropDown.Visible = 'on';
            app.CalibratorDropDown.Enable = 'on';
            app.CalibratorDropDownLabel.Visible = 'on';

            if isequal(app.ShowDropDown.Value,'CPS')

                app.HostInclusionDropDown.Visible = 'on';
                app.HostInclusionDropDown.Enable = 'on';
                app.BracketidDropDown.Visible = 'off';
                app.BracketidDropDown.Enable = 'off';
                app.BracketidDropDownLabel.Visible = 'off';
                app.CalibratorDropDown.Visible = 'off';
                app.CalibratorDropDown.Enable = 'off';
                app.CalibratorDropDownLabel.Visible = 'off';

            elseif isequal(app.ShowDropDown.Value,'Sensitivities')

                app.HostInclusionDropDown.Visible = 'off';
                app.HostInclusionDropDown.Enable = 'off';

            elseif isequal(app.ShowDropDown.Value,'Background CPS')

                app.HostInclusionDropDown.Visible = 'off';
                app.HostInclusionDropDown.Enable = 'off';
                app.BracketidDropDown.Visible = 'off';
                app.BracketidDropDown.Enable = 'off';
                app.BracketidDropDownLabel.Visible = 'off';
                app.CalibratorDropDown.Visible = 'off';
                app.CalibratorDropDown.Enable = 'off';
                app.CalibratorDropDownLabel.Visible = 'off';

            end


            %%%%%%%%%%%%%%%%%%%%
            update_results_table(app)
            update_progress_buttons(app)

            %%%%%%%%%%%%%%%%%%%%%%%%%% Quality Control %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %%% Quality Control Standard Plots
            qcrm_indices = strcmp(app.base.project.session.spot.type, "QCRM");

            % populate the CAL and bracket_id dropdown
            app.CalibratorDropDown_2.Items = app.CalibratorDropDown.Items;
            app.CalibratorDropDown_2.ItemsData = app.CalibratorDropDown.ItemsData;
            app.BracketidDropDown_2.Items = string(uniqueBracketIds);
            app.BracketidDropDown_2.ItemsData = uniqueBracketIds;

            if any(qcrm_indices)
                % Get reference materials only for QCRM spots
                qcrm_materials = app.base.project.session.spot.referencematerial(qcrm_indices);
                % Get unique names, excluding "None" and "Select Reference Material"
                unique_names = unique(qcrm_materials);
                unique_names = unique_names(~strcmp(unique_names, 'None'));
                validQCRMs = unique_names(~strcmp(unique_names, 'Select Reference Material'));

                % Populate QCRM dropdown
                app.QualityControlReferenceMaterialDropDown.Items = validQCRMs;
                app.QualityControlReferenceMaterialDropDown.ItemsData = app.QualityControlReferenceMaterialDropDown.Items;

                update_qcrm_plot(app)
            else
                app.QualityControlReferenceMaterialDropDown.Visible = false;
            end


            %%% Matrix Sensitivity Factor
            refmat = unique(app.base.project.session.spot.referencematerial);
            app.ComparetoDropDown.Items = refmat(refmat ~= "None");
            app.ComparetoDropDown.ItemsData = app.ComparetoDropDown.Items;

            app.DenominatorListBox.Items = app.base.project.session.spot.analytes;
            app.DenominatorListBox.ItemsData = app.DenominatorListBox.Items;



            update_metadata_table(app)
        end

        function update_results_table(app)

            spotnames   = app.base.project.session.spot.name(:);
            spotNumbers = (1:numel(spotnames))';
            T = table(spotNumbers, spotnames, 'VariableNames', {'#', 'Spotname'});

            % Add comments if checkbox is checked
            if app.ShowCommentsCheckBox.Value
                if isfield(app.base.project.session.meta, 'comment')
                    comments = app.base.project.session.meta.comment(:);
                    T = [T, table(comments, 'VariableNames', {'Comments'})];
                else
                    app.ShowCommentsCheckBox.Value = false;
                    uialert(app.UIFigure, {'No Comments'}, 'Warning');
                end
            end

            if isequal(app.ShowDropDown.Value, 'CPS')

                if isequal(app.selected_host_inclusion, 'Host')
                    cps = app.base.project.session.spot.bkgd_corrected_cps;
                elseif isequal(app.selected_host_inclusion, 'Inclusion')
                    cps = app.base.project.session.spot.bkgd_corrected_cps_incl;
                end

                cps_array        = table2array(cps);
                non_zero_row_mask = any(cps_array ~= 0, 2);
                T   = T(non_zero_row_mask, :);
                cps = cps(non_zero_row_mask, :);
                T   = [T, cps];

            elseif isequal(app.ShowDropDown.Value, 'Mass Fractions [µg/g]')

                if isequal(app.selected_host_inclusion, 'Host')
                    compositions        = app.base.project.session.spot.matrix_composition{app.BracketidDropDown.Value, app.selected_CAL};
                    limits_of_detection = app.base.project.session.spot.matrix_limits_of_detection{app.BracketidDropDown.Value, app.selected_CAL};

                elseif isequal(app.selected_host_inclusion, 'Inclusion')
                    if ~isempty(app.base.project.session.spot.inclusion_composition{app.BracketidDropDown.Value, app.selected_CAL}) && ...
                            ~isempty(app.base.project.session.spot.inclusion_limits_of_detection{app.BracketidDropDown.Value, app.selected_CAL})

                        lod_table  = app.base.project.session.spot.inclusion_limits_of_detection{app.BracketidDropDown.Value, app.selected_CAL};
                        comp_table = app.base.project.session.spot.inclusion_composition{app.BracketidDropDown.Value, app.selected_CAL};

                        zero_rows = all(lod_table{:,:} == 0, 2);
                        comp_table{zero_rows, :} = 0;
                        compositions        = comp_table;
                        limits_of_detection = lod_table;

                        if all(lod_table{:,:} == 0, 'all')
                            uialert(app.UIFigure, {'There are no limits of detection to filter the data with, probably because the matrix-only tracer element was not defined in the RM file for this CAL.'}, 'Warning');
                            compositions        = table();
                            limits_of_detection = table();
                        end
                    else
                        uialert(app.UIFigure, {'No inclusion was quantified'}, 'Warning');
                        app.HostInclusionDropDown.Value = app.HostInclusionDropDown.Items(1);
                        return
                    end
                end

                comp_array = table2array(compositions);
                lod_array  = table2array(limits_of_detection);
                below_lod  = comp_array < lod_array;

                display_values = num2cell(comp_array);
                display_values(below_lod) = arrayfun(@(x) ['<' num2str(x)], lod_array(below_lod), 'UniformOutput', false);
                display_compositions = array2table(display_values, 'VariableNames', compositions.Properties.VariableNames);

                T = [T, display_compositions];

                non_zero_mask      = any(lod_array ~= 0, 2);
                T                  = T(non_zero_mask, :);
                non_zero_comp_cols = any(lod_array ~= 0, 1);
                nMetaCols          = width(T) - width(display_compositions);
                T                  = T(:, [true(1, nMetaCols), non_zero_comp_cols]);

            elseif isequal(app.ShowDropDown.Value, 'Mass Fractions [µg/g] unfiltered')

                if isequal(app.selected_host_inclusion, 'Host')
                    compositions        = app.base.project.session.spot.matrix_composition{app.BracketidDropDown.Value, app.selected_CAL};
                    limits_of_detection = app.base.project.session.spot.matrix_limits_of_detection{app.BracketidDropDown.Value, app.selected_CAL};

                elseif isequal(app.selected_host_inclusion, 'Inclusion')
                    if ~isempty(app.base.project.session.spot.inclusion_composition{app.BracketidDropDown.Value, app.selected_CAL})
                        compositions        = app.base.project.session.spot.inclusion_composition{app.BracketidDropDown.Value, app.selected_CAL};
                        limits_of_detection = app.base.project.session.spot.inclusion_limits_of_detection{app.BracketidDropDown.Value, app.selected_CAL};
                    else
                        uialert(app.UIFigure, {'No inclusion was quantified'}, 'Warning');
                        app.HostInclusionDropDown.Value = app.HostInclusionDropDown.Items(1);
                        return
                    end
                end

                T         = [T, compositions];
                comp_array = table2array(compositions);
                lod_array  = table2array(limits_of_detection);

                non_zero_mask      = any(lod_array ~= 0, 2);
                T                  = T(non_zero_mask, :);
                non_zero_comp_cols = any(lod_array ~= 0, 1);
                nMetaCols          = width(T) - width(compositions);
                T                  = T(:, [true(1, nMetaCols), non_zero_comp_cols]);

            elseif isequal(app.ShowDropDown.Value, 'Majors as Oxides')

                if isequal(app.selected_host_inclusion, 'Host')
                    compositions        = app.base.project.session.spot.matrix_composition{app.BracketidDropDown.Value, app.selected_CAL};
                    limits_of_detection = app.base.project.session.spot.matrix_limits_of_detection{app.BracketidDropDown.Value, app.selected_CAL};

                elseif isequal(app.selected_host_inclusion, 'Inclusion')
                    if ~isempty(app.base.project.session.spot.inclusion_composition{app.BracketidDropDown.Value, app.selected_CAL}) && ...
                            ~isempty(app.base.project.session.spot.inclusion_limits_of_detection{app.BracketidDropDown.Value, app.selected_CAL})

                        lod_table  = app.base.project.session.spot.inclusion_limits_of_detection{app.BracketidDropDown.Value, app.selected_CAL};
                        comp_table = app.base.project.session.spot.inclusion_composition{app.BracketidDropDown.Value, app.selected_CAL};

                        zero_rows = all(lod_table{:,:} == 0, 2);
                        comp_table{zero_rows, :} = 0;
                        compositions        = comp_table;
                        limits_of_detection = lod_table;

                        if all(lod_table{:,:} == 0, 'all')
                            uialert(app.UIFigure, {'There are no limits of detection to filter the data with, probably because the matrix-only tracer element was not defined in the RM file for this CAL.'}, 'Warning');
                            compositions        = table();
                            limits_of_detection = table();
                        end
                    else
                        uialert(app.UIFigure, {'No inclusion was quantified'}, 'Warning');
                        app.HostInclusionDropDown.Value = app.HostInclusionDropDown.Items(1);
                        return
                    end
                end

                ox_elements      = app.base.project.session.oxides.element_names;
                oxide_names      = app.base.project.session.oxides.oxide_names;
                considered_major = app.base.project.session.oxides.considered_major;
                ox_values        = app.base.project.session.oxides.conversion_factor_values;

                var_names         = compositions.Properties.VariableNames;
                new_var_names     = var_names;
                comp_array        = table2array(compositions);
                lod_array         = table2array(limits_of_detection);
                oxide_comp_array  = comp_array;
                oxide_lod_array   = lod_array;
                converted_columns = false(1, length(var_names));

                for j = 1:length(var_names)
                    base_element = regexp(var_names{j}, '^[A-Za-z]+', 'match');
                    if ~isempty(base_element)
                        element     = base_element{1};
                        element_idx = find(ox_elements == string(element), 1);

                        if ~isempty(element_idx) && considered_major(element_idx) == "Yes"
                            factor     = ox_values(element_idx);
                            oxide_name = char(oxide_names(element_idx));

                            oxide_comp_array(:, j) = comp_array(:, j) * factor;
                            oxide_lod_array(:, j)  = lod_array(:, j)  * factor;
                            converted_columns(j)   = true;

                            isotope_part = regexp(var_names{j}, '\d+', 'match');
                            if ~isempty(isotope_part)
                                new_var_names{j} = [oxide_name, '_', isotope_part{1}];
                            else
                                new_var_names{j} = oxide_name;
                            end
                        end
                    end
                end

                oxide_comp_array(:, converted_columns) = oxide_comp_array(:, converted_columns) / 10000;
                oxide_lod_array(:, converted_columns)  = oxide_lod_array(:, converted_columns)  / 10000;

                below_lod      = oxide_comp_array < oxide_lod_array;
                display_values = num2cell(oxide_comp_array);
                display_values(below_lod) = arrayfun(@(x) ['<' num2str(x)], oxide_lod_array(below_lod), 'UniformOutput', false);
                display_compositions = array2table(display_values, 'VariableNames', new_var_names);

                T = [T, display_compositions];

                non_zero_mask      = any(oxide_lod_array ~= 0, 2);
                T                  = T(non_zero_mask, :);
                non_zero_comp_cols = any(oxide_lod_array ~= 0, 1);
                nMetaCols          = width(T) - width(display_compositions);
                T                  = T(:, [true(1, nMetaCols), non_zero_comp_cols]);

            elseif isequal(app.ShowDropDown.Value, 'Sensitivities')

                sensitivities    = app.base.project.session.spot.sensitivities{app.BracketidDropDown.Value, app.selected_CAL};
                non_zero_mask    = any(table2array(sensitivities) ~= 0, 2);
                sensitivities    = sensitivities(non_zero_mask, :);
                T                = T(non_zero_mask, :);
                T                = [T, sensitivities];

            elseif isequal(app.ShowDropDown.Value, 'CAL Sensitivities')

                cal_sens      = app.base.project.session.spot.cal_sensitivities;
                non_zero_mask = any(table2array(cal_sens) ~= 0, 2);
                cal_sens      = cal_sens(non_zero_mask, :);
                T             = T(non_zero_mask, :);
                T             = [T, cal_sens];

            elseif isequal(app.ShowDropDown.Value, 'Limits of detection')

                if isequal(app.selected_host_inclusion, 'Host')
                    lods = app.base.project.session.spot.matrix_limits_of_detection{app.BracketidDropDown.Value, app.selected_CAL};

                elseif isequal(app.selected_host_inclusion, 'Inclusion')
                    if ~isempty(app.base.project.session.spot.inclusion_composition{app.BracketidDropDown.Value, app.selected_CAL}) && ...
                            ~isempty(app.base.project.session.spot.inclusion_limits_of_detection{app.BracketidDropDown.Value, app.selected_CAL})

                        lods = app.base.project.session.spot.inclusion_limits_of_detection{app.BracketidDropDown.Value, app.selected_CAL};

                        if all(lods{:,:} == 0, 'all')
                            uialert(app.UIFigure, {'There are no limits of detection to filter the data with, probably because the matrix-only tracer element was not defined in the RM file for this CAL.'}, 'Warning');
                            lods = table();
                        end
                    else
                        uialert(app.UIFigure, {'No inclusion was quantified'}, 'Warning');
                        app.HostInclusionDropDown.Value = app.HostInclusionDropDown.Items(1);
                        return
                    end
                end

                lod_array         = table2array(lods);
                non_zero_row_mask = any(lod_array ~= 0, 2);
                non_zero_col_mask = any(lod_array ~= 0, 1);
                T                 = T(non_zero_row_mask, :);
                lods              = lods(non_zero_row_mask, non_zero_col_mask);
                T                 = [T, lods];

            elseif isequal(app.ShowDropDown.Value, 'Fe2+ and Fe3+')

                if ~isfield(app.base.project.session.spot, 'Fe_2_3')
                    uialert(app.UIFigure, {'There is no Fe2+ and Fe3+ data'}, 'Warning');
                    app.ShowDropDown.Value = app.ShowDropDown.Items(1);
                    update_results_module_GUI(app)
                    return
                end

                if isequal(app.selected_host_inclusion, 'Host')
                    compositions = app.base.project.session.spot.Fe_2_3{app.BracketidDropDown.Value, app.selected_CAL};

                elseif isequal(app.selected_host_inclusion, 'Inclusion')
                    if isfield(app.base.project.session.spot, 'Fe_2_3_incl') && ~isempty(app.base.project.session.spot.Fe_2_3_incl)
                        compositions = app.base.project.session.spot.Fe_2_3_incl{app.BracketidDropDown.Value, app.selected_CAL};
                    else
                        uialert(app.UIFigure, {'There is no Fe2+ and Fe3+ data'}, 'Warning');
                        app.ShowDropDown.Value = app.ShowDropDown.Items(1);
                        update_results_module_GUI(app)
                        return
                    end
                end

                if isempty(compositions)
                    uialert(app.UIFigure, {'There is no Fe2+ and Fe3+ data for this calibrator/bracket.'}, 'Warning');
                    app.ShowDropDown.Value = app.ShowDropDown.Items(1);
                    update_results_module_GUI(app)
                    return
                end

                T          = [T, compositions];
                comp_array = table2array(compositions);

                non_zero_mask      = any(comp_array ~= 0, 2);
                T                  = T(non_zero_mask, :);
                non_zero_comp_cols = any(comp_array ~= 0, 1);
                nMetaCols          = width(T) - width(compositions);
                T                  = T(:, [true(1, nMetaCols), non_zero_comp_cols]);

            elseif isequal(app.ShowDropDown.Value, 'Background CPS')

                if ~isfield(app.base.project.session.spot, 'background_cps')
                    uialert(app.UIFigure, {'No background CPS data available.'}, 'Warning');
                    app.ShowDropDown.Value = app.ShowDropDown.Items(1);
                    update_results_module_GUI(app)
                    return
                end

                bg_cps = app.base.project.session.spot.background_cps;
                bg_array = table2array(bg_cps);
                non_zero_row_mask = any(bg_array ~= 0, 2);
                T      = T(non_zero_row_mask, :);
                bg_cps = bg_cps(non_zero_row_mask, :);
                T      = [T, bg_cps];

            elseif isequal(app.ShowDropDown.Value, 'Mixing ratios')

                if ~isequal(app.base.project.session.config.reductiontype, 'Inclusion')
                    uialert(app.UIFigure, {'Mixing ratios are only available in Inclusion mode.'}, 'Warning');
                    app.ShowDropDown.Value = app.ShowDropDown.Items{1};
                    update_results_module_GUI(app)
                    return
                end

                if ~isfield(app.base.project.session.spot, 'mixing_ratio') || ...
                        isempty(app.base.project.session.spot.mixing_ratio)
                    uialert(app.UIFigure, {'No mixing ratios available. Run quantification first.'}, 'Warning');
                    app.ShowDropDown.Value = app.ShowDropDown.Items{1};
                    update_results_module_GUI(app)
                    return
                end

                mr = app.base.project.session.spot.mixing_ratio{app.BracketidDropDown.Value, app.selected_CAL};

                if isempty(mr) || isequal(mr, zeros(0,0))
                    uialert(app.UIFigure, {'No mixing ratios for this bracket/calibrator.'}, 'Warning');
                    app.ShowDropDown.Value = app.ShowDropDown.Items{1};
                    update_results_module_GUI(app)
                    return
                end

                valid_mask  = ~isnan(mr) & mr ~= 0;
                mr_cell     = num2cell(mr);
                T           = [T, table(mr_cell, 'VariableNames', {'Mixing Ratio (x)'})];
                T           = T(valid_mask, :);

            elseif isequal(app.ShowDropDown.Value, 'Mix mass fractions [µg/g]')

                if ~isequal(app.base.project.session.config.reductiontype, 'Inclusion')
                    uialert(app.UIFigure, {'Mix compositions are only available in Inclusion mode.'}, 'Warning');
                    app.ShowDropDown.Value = app.ShowDropDown.Items{1};
                    update_results_module_GUI(app); return
                end

                if ~isfield(app.base.project.session.spot, 'mix_composition') || ...
                        isempty(app.base.project.session.spot.mix_composition) || ...
                        isempty(app.base.project.session.spot.mix_composition{app.BracketidDropDown.Value, app.selected_CAL})
                    uialert(app.UIFigure, {'No mix compositions available. Run quantification first.'}, 'Warning');
                    app.ShowDropDown.Value = app.ShowDropDown.Items{1};
                    update_results_module_GUI(app); return
                end

                compositions      = app.base.project.session.spot.mix_composition{app.BracketidDropDown.Value, app.selected_CAL};
                comp_array        = table2array(compositions);
                non_zero_row_mask = any(comp_array ~= 0, 2);
                non_zero_col_mask = any(comp_array ~= 0, 1);
                T                 = [T, compositions];
                T                 = T(non_zero_row_mask, :);
                nMetaCols         = width(T) - width(compositions);
                T                 = T(:, [true(1, nMetaCols), non_zero_col_mask]);

            elseif isequal(app.ShowDropDown.Value, 'Matrix uncertainties [µg/g]')

                if ~isfield(app.base.project.session.spot, 'matrix_composition_uncertainty') || ...
                        isempty(app.base.project.session.spot.matrix_composition_uncertainty) || ...
                        isempty(app.base.project.session.spot.matrix_composition_uncertainty{app.BracketidDropDown.Value, app.selected_CAL})
                    uialert(app.UIFigure, {'No matrix uncertainties available. Enable uncertainty propagation and run quantification.'}, 'Warning');
                    app.ShowDropDown.Value = app.ShowDropDown.Items{1};
                    update_results_module_GUI(app)
                    return
                end

                uncertainties       = app.base.project.session.spot.matrix_composition_uncertainty{app.BracketidDropDown.Value, app.selected_CAL};
                limits_of_detection = app.base.project.session.spot.matrix_limits_of_detection{app.BracketidDropDown.Value, app.selected_CAL};

                T         = [T, uncertainties];
                lod_array = table2array(limits_of_detection);

                non_zero_mask      = any(lod_array ~= 0, 2);
                T                  = T(non_zero_mask, :);
                non_zero_comp_cols = any(lod_array ~= 0, 1);
                nMetaCols          = width(T) - width(uncertainties);
                T                  = T(:, [true(1, nMetaCols), non_zero_comp_cols]);

            elseif isequal(app.ShowDropDown.Value, 'Inclusion uncertainties [µg/g]')

                if ~isequal(app.base.project.session.config.reductiontype, 'Inclusion')
                    uialert(app.UIFigure, {'Inclusion uncertainties are only available in Inclusion mode.'}, 'Warning');
                    app.ShowDropDown.Value = app.ShowDropDown.Items{1};
                    update_results_module_GUI(app)
                    return
                end

                if ~isfield(app.base.project.session.spot, 'inclusion_composition_uncertainty') || ...
                        isempty(app.base.project.session.spot.inclusion_composition_uncertainty) || ...
                        ~istable(app.base.project.session.spot.inclusion_composition_uncertainty{app.BracketidDropDown.Value, app.selected_CAL})
                    uialert(app.UIFigure, {'No inclusion uncertainties available. Enable uncertainty propagation and run quantification.'}, 'Warning');
                    app.ShowDropDown.Value = app.ShowDropDown.Items{1};
                    update_results_module_GUI(app)
                    return
                end

                uncertainties       = app.base.project.session.spot.inclusion_composition_uncertainty{app.BracketidDropDown.Value, app.selected_CAL};
                limits_of_detection = app.base.project.session.spot.inclusion_limits_of_detection{app.BracketidDropDown.Value, app.selected_CAL};

                T         = [T, uncertainties];
                lod_array = table2array(limits_of_detection);

                non_zero_mask      = any(lod_array ~= 0, 2);
                T                  = T(non_zero_mask, :);
                non_zero_comp_cols = any(lod_array ~= 0, 1);
                nMetaCols          = width(T) - width(uncertainties);
                T                  = T(:, [true(1, nMetaCols), non_zero_comp_cols]);

            end

            app.ResultsTable.Data       = T;
            app.ResultsTable.ColumnName = T.Properties.VariableNames;

        end

        function update_show_dropdown_items(app)

            previous_view = app.ShowDropDown.Value;

            views_for_both               = {'CPS', 'Mass Fractions [µg/g]', 'Mass Fractions [µg/g] unfiltered', ...
                'Majors as Oxides', 'Limits of detection', 'Fe2+ and Fe3+'};
            views_without_host_inclusion = {'Sensitivities', 'CAL Sensitivities', 'Background CPS'};

            if isequal(app.selected_host_inclusion, 'Inclusion')
                views_of_selection = {'Mixing ratios', 'Mix mass fractions [µg/g]', 'Inclusion uncertainties [µg/g]'};
            else
                views_of_selection = {'Matrix uncertainties [µg/g]'};
            end

            app.ShowDropDown.Items     = [views_for_both, views_of_selection, views_without_host_inclusion];
            app.ShowDropDown.ItemsData = app.ShowDropDown.Items;

            % keep the current view if it still exists, otherwise pick the closest equivalent
            if ismember(previous_view, app.ShowDropDown.Items)
                app.ShowDropDown.Value = previous_view;
            elseif isequal(previous_view, 'Inclusion uncertainties [µg/g]')
                app.ShowDropDown.Value = 'Matrix uncertainties [µg/g]';
            elseif isequal(previous_view, 'Matrix uncertainties [µg/g]') && isequal(app.selected_host_inclusion, 'Inclusion')
                app.ShowDropDown.Value = 'Inclusion uncertainties [µg/g]';
            else
                app.ShowDropDown.Value = app.ShowDropDown.Items{1};
            end
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%% Export %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function export_displayed_table(app, outputpath)
            % Get the currently displayed table
            displayed_table = app.ResultsTable.Data;

            % Get column names
            column_names = app.ResultsTable.ColumnName;

            % Convert to table if it's not already
            if ~istable(displayed_table)
                displayed_table = array2table(displayed_table, 'VariableNames', column_names);
            end

            % Write the table to csv
            writetable(displayed_table, outputpath);
        end

        function export_all_matrix_lods(app, outputpath)
            bracket_ids = app.BracketidDropDown.Items;
            cals = app.CalibratorDropDown.Items;

            data_to_output = app.base.project.session.spot.matrix_limits_of_detection;
            spotnames = app.base.project.session.spot.name(:);
            spotNumbers = (1:numel(spotnames))';

            for i = 1:numel(bracket_ids)
                for j = 1:numel(cals)
                    tbl = data_to_output{i, j};
                    if ~istable(tbl) || isempty(tbl); continue; end

                    tbl_numeric = table2array(tbl);
                    nonzero_rows = any(tbl_numeric ~= 0, 2);
                    nonzero_cols = any(tbl_numeric ~= 0, 1);
                    tbl_clean = tbl(nonzero_rows, nonzero_cols);

                    row_idx = find(nonzero_rows);
                    tbl_clean = addvars(tbl_clean, spotNumbers(row_idx), spotnames(row_idx), 'Before', 1, ...
                        'NewVariableNames', {'SpotNumber', 'SpotName'});

                    sheet_name = sprintf('%s - ID%s', char(cals(j)), char(bracket_ids(i)));
                    writetable(tbl_clean, outputpath, 'Sheet', sheet_name, 'WriteRowNames', false);
                end
            end
        end

        function export_all_inclusion_lods(app, outputpath)
            bracket_ids = app.BracketidDropDown.Items;
            cals = app.CalibratorDropDown.Items;

            if isfield(app.base.project.session.spot, 'inclusion_limits_of_detection')
                data_to_output = app.base.project.session.spot.inclusion_limits_of_detection;
            else
                uialert(app.UIFigure, {'No Inclusion was quantified'}, ' Warning');
                return
            end

            spotnames = app.base.project.session.spot.name(:);
            spotNumbers = (1:numel(spotnames))';

            for i = 1:numel(bracket_ids)
                for j = 1:numel(cals)
                    tbl = data_to_output{i, j};
                    if ~istable(tbl) || isempty(tbl); continue; end

                    tbl_numeric = table2array(tbl);
                    nonzero_rows = any(tbl_numeric ~= 0, 2);
                    nonzero_cols = any(tbl_numeric ~= 0, 1);
                    tbl_clean = tbl(nonzero_rows, nonzero_cols);

                    row_idx = find(nonzero_rows);
                    tbl_clean = addvars(tbl_clean, spotNumbers(row_idx), spotnames(row_idx), 'Before', 1, ...
                        'NewVariableNames', {'SpotNumber', 'SpotName'});

                    sheet_name = sprintf('%s - ID%s', char(cals(j)), char(bracket_ids(i)));
                    writetable(tbl_clean, outputpath, 'Sheet', sheet_name, 'WriteRowNames', false);
                end
            end
        end

        function export_all_matrix_mass_fractions(app, outputpath)
            bracket_ids = app.BracketidDropDown.Items;
            cals = app.CalibratorDropDown.Items;

            data_to_output = app.base.project.session.spot.matrix_composition;
            lod_to_output  = app.base.project.session.spot.matrix_limits_of_detection;
            spotnames = app.base.project.session.spot.name(:);
            spotNumbers = (1:numel(spotnames))';

            for i = 1:numel(bracket_ids)
                for j = 1:numel(cals)
                    tbl     = data_to_output{i, j};
                    lod_tbl = lod_to_output{i, j};
                    if ~istable(tbl) || isempty(tbl) || ~istable(lod_tbl) || isempty(lod_tbl); continue; end

                    tbl_numeric = table2array(tbl);
                    nonzero_rows = any(tbl_numeric ~= 0, 2);
                    nonzero_cols = any(tbl_numeric ~= 0, 1);
                    tbl_clean = tbl(nonzero_rows, nonzero_cols);
                    lod_clean = lod_tbl(nonzero_rows, nonzero_cols);

                    comp_array = table2array(tbl_clean);
                    lod_array  = table2array(lod_clean);

                    below_lod = comp_array < lod_array;
                    display_values = num2cell(comp_array);
                    display_values(below_lod) = arrayfun(@(x) ['<' num2str(x)], lod_array(below_lod), 'UniformOutput', false);

                    display_tbl = array2table(display_values, 'VariableNames', tbl_clean.Properties.VariableNames);

                    row_idx = find(nonzero_rows);
                    display_tbl = addvars(display_tbl, spotNumbers(row_idx), spotnames(row_idx), 'Before', 1, ...
                        'NewVariableNames', {'SpotNumber', 'SpotName'});

                    sheet_name = sprintf('%s - ID%s', char(cals(j)), char(bracket_ids(i)));
                    writetable(display_tbl, outputpath, 'Sheet', sheet_name, 'WriteRowNames', false);
                end
            end
        end

        function export_all_inclusion_mass_fractions(app, outputpath)
            bracket_ids = app.BracketidDropDown.Items;
            cals = app.CalibratorDropDown.Items;

            if isfield(app.base.project.session.spot, 'inclusion_limits_of_detection')
                data_to_output = app.base.project.session.spot.inclusion_composition;
                lod_to_output  = app.base.project.session.spot.inclusion_limits_of_detection;
            else
                uialert(app.UIFigure, {'No Inclusion was quantified'}, ' Warning');
                return
            end

            spotnames = app.base.project.session.spot.name(:);
            spotNumbers = (1:numel(spotnames))';

            for i = 1:numel(bracket_ids)
                for j = 1:numel(cals)
                    tbl     = data_to_output{i, j};
                    lod_tbl = lod_to_output{i, j};
                    if ~istable(tbl) || isempty(tbl) || ~istable(lod_tbl) || isempty(lod_tbl); continue; end

                    tbl_numeric = table2array(tbl);
                    nonzero_rows = any(tbl_numeric ~= 0, 2);
                    nonzero_cols = any(tbl_numeric ~= 0, 1);
                    tbl_clean = tbl(nonzero_rows, nonzero_cols);
                    lod_clean = lod_tbl(nonzero_rows, nonzero_cols);

                    comp_array = table2array(tbl_clean);
                    lod_array  = table2array(lod_clean);

                    below_lod = comp_array < lod_array;
                    display_values = num2cell(comp_array);
                    display_values(below_lod) = arrayfun(@(x) ['<' num2str(x)], lod_array(below_lod), 'UniformOutput', false);

                    display_tbl = array2table(display_values, 'VariableNames', tbl_clean.Properties.VariableNames);

                    row_idx = find(nonzero_rows);
                    display_tbl = addvars(display_tbl, spotNumbers(row_idx), spotnames(row_idx), 'Before', 1, ...
                        'NewVariableNames', {'SpotNumber', 'SpotName'});

                    sheet_name = sprintf('%s - ID%s', char(cals(j)), char(bracket_ids(i)));
                    writetable(display_tbl, outputpath, 'Sheet', sheet_name, 'WriteRowNames', false);
                end
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%% Add Metadata %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function update_metadata_table(app)

            spotnames   = app.base.project.session.spot.name(:);
            spotNumbers = (1:numel(spotnames))';
            nRows       = numel(spotnames);

            T = table(spotNumbers, spotnames, 'VariableNames', {'#', 'Spotname'});

            if isfield(app.base.project.session, 'meta') && isstruct(app.base.project.session.meta)
                metaStruct = app.base.project.session.meta;
                metaFields = fieldnames(metaStruct);

                for i = 1:numel(metaFields)
                    fieldName  = metaFields{i};
                    fieldValue = metaStruct.(fieldName);

                    if isnumeric(fieldValue) && size(fieldValue, 1) == nRows
                        displayCol = num2cell(fieldValue(:));
                        displayCol(isnan(fieldValue(:))) = {[]};
                        T.(fieldName) = displayCol;
                    elseif (isstring(fieldValue) || iscell(fieldValue)) && size(fieldValue, 1) == nRows
                        T.(fieldName) = fieldValue(:);
                    end
                end
            end

            app.MetadataTable.Data       = T;
            app.MetadataTable.ColumnName = T.Properties.VariableNames;

            numCols = width(T);
            if numCols > 2
                app.MetadataTable.ColumnEditable = [false, false, true(1, numCols - 2)];
            else
                app.MetadataTable.ColumnEditable = false(1, numCols);
            end

            columnNames = T.Properties.VariableNames;
            if numel(columnNames) > 2
                app.StringCompareDropDown.Items = columnNames(3:end);
            else
                app.StringCompareDropDown.Items = {};
            end

        end
        
        function [colType, isDetermined] = getColumnInfo(~, columnData)

            isDetermined = false;
            colType = 'char';

            if isstring(columnData)
                firstValidIdx = find(columnData ~= "Unknown" & columnData ~= "", 1);
                if ~isempty(firstValidIdx)
                    isDetermined = true;
                    colType = 'char';
                end

            elseif isnumeric(columnData)
                isDetermined = true;
                colType = 'numeric';

            elseif iscell(columnData)
                firstValidIdx = find(~strcmp(columnData, 'Unknown') & ~cellfun('isempty', columnData), 1);
                if ~isempty(firstValidIdx)
                    firstValidValue = columnData{firstValidIdx};
                    isDetermined = true;
                    if isnumeric(firstValidValue)
                        colType = 'numeric';
                    else
                        colType = 'char';
                    end
                end
            end

        end


        %%%%%%%%%%%%%%%%%%%%%%%%%% Quality Control %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function update_qcrm_plot(app)

            % get the Indices of the chosen QCRM from the dropdown
            % from spot.referencematerials
            refMaterial = app.QualityControlReferenceMaterialDropDown.Value;

            if isempty(refMaterial)
                return
            end

                 % also removes objects with hidden handles (the error bars), which cla leaves behind
            delete(allchild(app.QCRMAxes))

            indices = find(strcmp(app.base.project.session.spot.referencematerial, refMaterial));

            % Get the corresponding time points
            time_points = app.base.project.session.spot.integer_time_points(indices);


            %%%%%%%%%% calculate the ratios %%%%%%%
            % of the measured values vs the published values

            values = app.base.project.session.spot.matrix_composition{app.BracketidDropDown_2.Value, app.CalibratorDropDown_2.Value}(indices,:);
            lods = app.base.project.session.spot.matrix_limits_of_detection{app.BracketidDropDown_2.Value, app.CalibratorDropDown_2.Value}(indices,:);

            if all(table2array(values) == 0, 'all')
                % if the values contain all zeros means that the CAL was
                % not used
                %message={'Primary Reference Material was not used for quantification'};
                %uialert(app.UIFigure,message,' Warning');
                cla(app.QCRMAxes)
                return
            end

            % Find indices of rows and columns that have at least one non-zero value
            nonZeroRows = any(table2array(values) ~= 0, 2);  % check rows
            nonZeroCols = any(table2array(values) ~= 0, 1);     % check columns

            % Keep only rows and columns that have non-zero values
            qcrm_massfractions = values(nonZeroRows, nonZeroCols);

            qcrm_pub_idx = find(strcmp(app.base.project.session.referencematerials.names, refMaterial));
            qcrm_pub_data = app.base.project.session.referencematerials.data{qcrm_pub_idx};
            qcrm_pub_unc = app.base.project.session.referencematerials.uncertainty{qcrm_pub_idx};

            % Get base element names by removing numbers from mass_fraction column names
            base_elements = regexprep(qcrm_massfractions.Properties.VariableNames, '\d+', '');

            % Find matching elements in pub_data
            [~, pub_indices] = ismember(base_elements, qcrm_pub_data.Properties.VariableNames);

            % Get only the columns where we found matches
            valid_matches = pub_indices > 0;
            mass_cols = qcrm_massfractions(:, valid_matches);
            pref_vals = repmat(table2array(qcrm_pub_data(:, pub_indices(valid_matches))), size(mass_cols, 1), 1);

            % Calculate ratios
            ratio_values = table2array(mass_cols) ./ pref_vals;

            % Create results table with original isotope names
            ratios = array2table(ratio_values, 'VariableNames', qcrm_massfractions.Properties.VariableNames(valid_matches));

            % these ratios are that I would need for the secondary standard
            % correction

            %%%%%%%%%% plot that shit %%%%%%%%

            % Get the lods corresponding to the ratio values
            lods_filtered = lods(nonZeroRows, nonZeroCols);
            lods_for_ratios = lods_filtered(:, valid_matches);

            % Create a logical matrix where true means the value is below LOD
            is_below_lod = table2array(mass_cols) < table2array(lods_for_ratios);

            % measured-composition uncertainty in ratio space (error bars), if available
            show_unc = app.ShowuncertaintiesCheckBox.Value && ...
                isfield(app.base.project.session.spot, 'matrix_composition_uncertainty') && ...
                ~isempty(app.base.project.session.spot.matrix_composition_uncertainty) && ...
                numel(app.base.project.session.spot.matrix_composition_uncertainty) >= ...
                app.BracketidDropDown_2.Value * app.CalibratorDropDown_2.Value && ...
                ~isempty(app.base.project.session.spot.matrix_composition_uncertainty{app.BracketidDropDown_2.Value, app.CalibratorDropDown_2.Value});

            if show_unc
                unc_all      = app.base.project.session.spot.matrix_composition_uncertainty{app.BracketidDropDown_2.Value, app.CalibratorDropDown_2.Value}(indices, :);
                unc_filtered = unc_all(nonZeroRows, nonZeroCols);
                unc_cols     = unc_filtered(:, valid_matches);
                sigma_ratio  = abs(table2array(unc_cols)) ./ pref_vals;   % same denominator as ratio_values
                sigma_ratio(~isfinite(sigma_ratio)) = NaN;                % missing/zero-pub -> no bar for that point
            else
                sigma_ratio = [];
            end

            if ~isempty(qcrm_pub_unc)
                pref_vals_for_calc = table2array(qcrm_pub_data(:, pub_indices(valid_matches)));
                max_vals = table2array(qcrm_pub_data(:, pub_indices(valid_matches))) + table2array(qcrm_pub_unc(:, pub_indices(valid_matches)));
                min_vals = table2array(qcrm_pub_data(:, pub_indices(valid_matches))) - table2array(qcrm_pub_unc(:, pub_indices(valid_matches)));

                ratio_max_values = max_vals ./ pref_vals_for_calc;
                ratio_min_values = min_vals ./ pref_vals_for_calc;

                ratio_min_values(isnan(ratio_min_values)) = 0.9;
                ratio_max_values(isnan(ratio_max_values)) = 1.1;

                cla(app.QCRMAxes)
                delete(allchild(app.QCRMAxes)) 
                hold(app.QCRMAxes, 'on');

                % Set y-axis to log scale
                if app.LogscaleCheckBox_2.Value
                    app.QCRMAxes.YScale = 'log';
                else
                    app.QCRMAxes.YScale = 'linear';
                end

                %%%%%%%

                xVals = 1:size(ratio_min_values, 2);

                % Extend x-values for full coverage
                xExtended = [0.5, xVals, max(xVals) + 0.5];

                % Build band bounds
                L50 = min(ratio_min_values*0.01, [], 1);
                U50 = max(ratio_max_values*10,   [], 1);

                L20 = min(ratio_min_values*0.8,  [], 1);
                U20 = max(ratio_max_values*1.2,  [], 1);

                L10 = min(ratio_min_values*0.9,  [], 1);
                U10 = max(ratio_max_values*1.1,  [], 1);

                L00 = min(ratio_min_values,      [], 1);
                U00 = max(ratio_max_values,      [], 1);

                % Extend bounds to edges
                L50_ext = [L50(1), L50, L50(end)];
                U50_ext = [U50(1), U50, U50(end)];
                L20_ext = [L20(1), L20, L20(end)];
                U20_ext = [U20(1), U20, U20(end)];
                L10_ext = [L10(1), L10, L10(end)];
                U10_ext = [U10(1), U10, U10(end)];
                L00_ext = [L00(1), L00, L00(end)];
                U00_ext = [U00(1), U00, U00(end)];

                % Ensure positivity for log-scale
                mask50 = (L50_ext>0) & (U50_ext>0);
                mask20 = (L20_ext>0) & (U20_ext>0);
                mask10 = (L10_ext>0) & (U10_ext>0);
                mask00 = (L00_ext>0) & (U00_ext>0);

                L50_ext(~mask50) = NaN; U50_ext(~mask50) = NaN;
                L20_ext(~mask20) = NaN; U20_ext(~mask20) = NaN;
                L10_ext(~mask10) = NaN; U10_ext(~mask10) = NaN;
                L00_ext(~mask00) = NaN; U00_ext(~mask00) = NaN;

                warning('off', 'MATLAB:polyshape:repairedBySimplify');

                % Helper to make a band polyshape from lower/upper arrays
                mkPoly = @(lo,hi) polyshape([xExtended, fliplr(xExtended)], [lo, fliplr(hi)], 'Simplify', true);

                % Full bands
                p50 = mkPoly(L50_ext, U50_ext);
                p20 = mkPoly(L20_ext, U20_ext);
                p10 = mkPoly(L10_ext, U10_ext);
                p00 = mkPoly(L00_ext, U00_ext);

                % Non-overlapping rings (outer minus inner)
                r50 = subtract(p50, p20);
                r20 = subtract(p20, p10);
                r10 = subtract(p10, p00);
                r00 = p00;

                % Plot rings (no overlap => no alpha stacking)
                plot(app.QCRMAxes, r50, 'FaceColor', [1 0.8 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
                plot(app.QCRMAxes, r20, 'FaceColor', [1 0.9 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
                plot(app.QCRMAxes, r10, 'FaceColor', [1 1 0.8],   'EdgeColor', 'none', 'FaceAlpha', 0.5);
                plot(app.QCRMAxes, r00, 'FaceColor', [0.9 1 0.9], 'EdgeColor', 'none', 'FaceAlpha', 0.5);

                % Get current y-limits with padding
                ymin = min(min(table2array(ratios)));
                ymax = max(max(table2array(ratios)));

                % Calculate symmetric limits in log space around y=1 with 10% padding
                maxDistance = max(abs(log10(ymin)), abs(log10(ymax))) * 1.1;
                app.QCRMAxes.YLim = [10^(-maxDistance) 10^maxDistance];

                % Plot horizontal line at y=1
                yline(app.QCRMAxes, 1, 'k--', 'LineWidth', 1);

                % Create a colormap based on time points
                cmap = jet(256);
                min_time = min(time_points);
                max_time = max(time_points);

                % Plot data with colors based on time
                for i = 1:height(ratios)
                    % Normalize time to map to colormap
                    if max_time > min_time
                        norm_time = (time_points(i) - min_time) / (max_time - min_time);
                    else
                        norm_time = 0.5; % All points have the same time
                    end
                    color_idx = floor(norm_time * (size(cmap, 1) - 1)) + 1;
                    point_color = cmap(color_idx, :);

                    x_data = 1:width(ratios);
                    y_data = table2array(ratios(i,:));

                    % Plot line connecting all points
                    plot(app.QCRMAxes, x_data, y_data, '-', 'Color', [0.7 0.7 0.7]);

                    if show_unc
                        errorbar(app.QCRMAxes, x_data, y_data, sigma_ratio(i,:), ...
                            'LineStyle', 'none', 'Color', [0.4 0.4 0.4], 'CapSize', 3, ...
                            'HandleVisibility', 'off');
                    end

                    % Separate points based on LOD
                    is_below = is_below_lod(i, :);
                    is_above = ~is_below;

                    % Plot points below LOD in grey
                    if any(is_below)
                        plot(app.QCRMAxes, x_data(is_below), y_data(is_below), 'o', ...
                            'MarkerFaceColor', [0.5 0.5 0.5], ...
                            'MarkerEdgeColor', [0.0 0.0 0.0]);
                    end

                    % Plot points above LOD with time-based color
                    if any(is_above)
                        plot(app.QCRMAxes, x_data(is_above), y_data(is_above), 'o', ...
                            'MarkerFaceColor', point_color, ...
                            'MarkerEdgeColor', [0.0 0.0 0.0]);
                    end
                end

                % Add grids with solid lines
                app.QCRMAxes.YGrid = 'on';
                app.QCRMAxes.XGrid = 'on';
                app.QCRMAxes.GridAlpha = 0.15;
                app.QCRMAxes.MinorGridLineStyle = '-';  % Solid lines for minor grid
                app.QCRMAxes.LineWidth = 1;      % Thin lines

                % Customize the plot
                app.QCRMAxes.XTick = 1:width(ratios);
                app.QCRMAxes.XTickLabel = ratios.Properties.VariableNames;
                app.QCRMAxes.XTickLabelRotation = 45;  % Rotate labels for better readability
                app.QCRMAxes.XLim = [0.5, width(ratios) + 0.5];

                hold(app.QCRMAxes, 'off');


            else
                cla(app.QCRMAxes)
                hold(app.QCRMAxes, 'on');

                % Set y-axis to log scale
                if app.LogscaleCheckBox_2.Value
                    app.QCRMAxes.YScale = 'log';
                else
                    app.QCRMAxes.YScale = 'linear';
                end

                % Add shaded regions around y=1
                xCoord = [0.5 width(ratios)+0.5 width(ratios)+0.5 0.5];

                % Light green region (±10%)
                yCoord = [0.9 0.9 1.1 1.1];
                fill(app.QCRMAxes, xCoord, yCoord, [0.9 1 0.9], 'EdgeColor', 'none', 'FaceAlpha', 0.5);

                % Yellow regions (10-20%)
                yCoordLower = [0.8 0.8 0.9 0.9];
                yCoordUpper = [1.1 1.1 1.2 1.2];
                fill(app.QCRMAxes, xCoord, yCoordLower, [1 1 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
                fill(app.QCRMAxes, xCoord, yCoordUpper, [1 1 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);

                % Light orange regions (20-30%)
                yCoordLower = [0.7 0.7 0.8 0.8];
                yCoordUpper = [1.2 1.2 1.3 1.3];
                fill(app.QCRMAxes, xCoord, yCoordLower, [1 0.9 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
                fill(app.QCRMAxes, xCoord, yCoordUpper, [1 0.9 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);

                % Light red regions (>30% and <70%)
                yCoordLower = [0.00001 0.00001 0.7 0.7];
                yCoordUpper = [1.3 1.3 10000 10000];
                fill(app.QCRMAxes, xCoord, yCoordLower, [1 0.8 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.4);
                fill(app.QCRMAxes, xCoord, yCoordUpper, [1 0.8 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.4);

                % Get current y-limits with padding
                ymin = min(min(table2array(ratios)));
                ymax = max(max(table2array(ratios)));

                % Calculate symmetric limits in log space around y=1 with 10% padding
                maxDistance = max(abs(log10(ymin)), abs(log10(ymax))) * 1.1;
                app.QCRMAxes.YLim = [10^(-maxDistance) 10^maxDistance];

                % Plot horizontal line at y=1
                yline(app.QCRMAxes, 1, 'k--', 'LineWidth', 1);

                % Create a colormap based on time points
                cmap = jet(256);
                min_time = min(time_points);
                max_time = max(time_points);

                % Plot data with colors based on time
                for i = 1:height(ratios)
                    % Normalize time to map to colormap
                    if max_time > min_time
                        norm_time = (time_points(i) - min_time) / (max_time - min_time);
                    else
                        norm_time = 0.5; % All points have the same time
                    end
                    color_idx = floor(norm_time * (size(cmap, 1) - 1)) + 1;
                    point_color = cmap(color_idx, :);

                    x_data = 1:width(ratios);
                    y_data = table2array(ratios(i,:));

                    % Plot line connecting all points
                    plot(app.QCRMAxes, x_data, y_data, '-', 'Color', [0.7 0.7 0.7]);

                    if show_unc
                        errorbar(app.QCRMAxes, x_data, y_data, sigma_ratio(i,:), ...
                            'LineStyle', 'none', 'Color', [0.4 0.4 0.4], 'CapSize', 3, ...
                            'HandleVisibility', 'off');
                    end

                    % Separate points based on LOD
                    is_below = is_below_lod(i, :);
                    is_above = ~is_below;

                    % Plot points below LOD in grey
                    if any(is_below)
                        plot(app.QCRMAxes, x_data(is_below), y_data(is_below), 'o', ...
                            'MarkerFaceColor', [0.5 0.5 0.5], ...
                            'MarkerEdgeColor', [0.0 0.0 0.0]);
                    end

                    % Plot points above LOD with time-based color
                    if any(is_above)
                        plot(app.QCRMAxes, x_data(is_above), y_data(is_above), 'o', ...
                            'MarkerFaceColor', point_color, ...
                            'MarkerEdgeColor', [0.0 0.0 0.0]);
                    end
                end

                % Add grids with solid lines
                app.QCRMAxes.YGrid = 'on';
                app.QCRMAxes.XGrid = 'on';
                app.QCRMAxes.GridAlpha = 0.15;
                app.QCRMAxes.MinorGridLineStyle = '-';  % Solid lines for minor grid
                app.QCRMAxes.LineWidth = 1;      % Thin lines

                % Customize the plot
                app.QCRMAxes.XTick = 1:width(ratios);
                app.QCRMAxes.XTickLabel = ratios.Properties.VariableNames;
                app.QCRMAxes.XTickLabelRotation = 45;  % Rotate labels for better readability
                app.QCRMAxes.XLim = [0.5, width(ratios) + 0.5];

                hold(app.QCRMAxes, 'off');
            end
        end

        function update_MSF_plot(app)

            % preallocate the columns
            spotnames = app.base.project.session.spot.name(:);  % ensure column vector
            spotNumbers = (1:numel(spotnames))';  % create column vector of numbers
            ref_mat = app.base.project.session.spot.referencematerial(:);

            if numel(unique(setdiff(ref_mat, "None"))) == 1
                message={'At least two reference materials (CAL or QCRM) are needed for calculation of the MSF.'};
                uialert(app.UIFigure, message,' Warning','Icon','warning');
                return
            end

            % Generate initial table with spot numbers and names
            all_sensitivities = table(spotNumbers, spotnames,ref_mat, 'VariableNames', {'#', 'Spotname', 'Reference Material'});

            initial_sensitivities = zeros(numel(app.base.project.session.spot.type), numel(app.base.project.session.spot.analytes));
            all_RM = [];

            % let all_RM be all spots which spot.type = all_RM
            for i = 1:numel(app.base.project.session.spot.type)
                if strcmp(app.base.project.session.spot.type(i), "CAL") || strcmp(app.base.project.session.spot.type(i), "QCRM")
                    all_RM = [all_RM,i];
                end
            end

            for i = 1:numel(all_RM)

                bg_corrected_cps_matrix = app.base.project.session.spot.bkgd_corrected_cps(all_RM(i) , :);

                %%%%%%%% Calculate the sensitivity %%%%%%%%%

                % get the name of the corresponding referencematerial that has been
                % chosen
                referencematerial = app.base.project.session.spot.referencematerial{all_RM(i)};

                % find the index of the corresponding referencematerial
                idx = find(strcmp(app.base.project.session.referencematerials.names, referencematerial));

                if ~isempty(idx)
                    % get the table for the corresponding referencematerial
                    RM_table = app.base.project.session.referencematerials.data{idx};

                    % get the column headers (elements) of the table
                    CAL_elements = RM_table.Properties.VariableNames;

                    % Remove numbers from analytes
                    cleaned_analytes = cellfun(@(x) regexprep(x, '\d', ''), app.base.project.session.spot.analytes, 'UniformOutput', false);

                    for j = 1:numel(cleaned_analytes)
                        if ismember(cleaned_analytes{j}, CAL_elements)
                            % Store directly in the matrix instead of cell array
                            initial_sensitivities(all_RM(i), j) = bg_corrected_cps_matrix.(j) / RM_table.(cleaned_analytes{j});
                        end
                    end
                end
            end

            initial_sensitivities = array2table(initial_sensitivities, "VariableNames", app.base.project.session.spot.analytes);

            all_sensitivities = [all_sensitivities, initial_sensitivities];

            %%%%%%%%%%%%%

            % Extract unique reference materials
            referenceMaterials = unique(all_sensitivities.("Reference Material"));

            % Initialize a new table to store results
            processed_sensitivities = table();

            % Loop through each reference material
            for i = 1:length(referenceMaterials)
                refMaterial = referenceMaterials{i};

                % Filter rows for the current reference material
                rows = all_sensitivities(strcmp(all_sensitivities.("Reference Material"), refMaterial), :);

                % Calculate min, max, and mean for each element (numeric columns only)
                numericData = rows{:, 4:end}; % Assuming element data starts from the 4th column
                minValues = min(numericData, [], 1);
                maxValues = max(numericData, [], 1);
                meanValues = mean(numericData, 1, 'omitnan');

                % Create a temporary table for the current reference material
                tempTable = table(minValues', maxValues', meanValues', ...
                    'VariableNames', {'Min', 'Max', 'Mean'});
                tempTable.Element = rows.Properties.VariableNames(4:end)'; % Add element names
                tempTable.ReferenceMaterial = repmat({refMaterial}, size(tempTable, 1), 1);

                % Append to the results table
                processed_sensitivities = [processed_sensitivities; tempTable];
            end

            % Reorder columns for better readability
            processed_sensitivities = processed_sensitivities(:, {'ReferenceMaterial', 'Element', 'Min', 'Max', 'Mean'});

            %%%%%%%%%%%%%
            % Identify rows where all numeric columns are zero
            emptyRows = all(processed_sensitivities{:, 3:end} == 0, 2);

            % Remove those rows
            processed_sensitivities = processed_sensitivities(~emptyRows, :);

            denominators = app.DenominatorListBox.Value;
            % Initialize an empty cell array to store the ratios
            ratios = {};
            elements = unique(processed_sensitivities.Element);
            % Generate ratios with the chosen denominators
            for i = 1:length(elements)
                for j = 1:length(denominators)
                    if ~strcmp(elements{i}, denominators{j}) % Avoid self-ratios
                        ratios{end+1} = [elements{i} '/' denominators{j}];
                    end
                end
            end

            app.RatioListBox.Items = ratios;
            app.RatioListBox.ItemsData = app.RatioListBox.Items;

            %%%%%%%%%%%%

            sensitivityType = app.SensitivitybasedonDropDown.Value;

            % Get the selected ratios from the RatioListBox
            selected_ratios = app.RatioListBox.Value;

            if isempty(selected_ratios)
                return
            end

            % Initialize a new table to store the calculated ratios
            calculated_ratios = table();

            % Loop through each reference material
            for i = 1:length(referenceMaterials)
                refMaterial = referenceMaterials{i};

                % Filter rows for the current reference material
                rows = processed_sensitivities(strcmp(processed_sensitivities.ReferenceMaterial, refMaterial), :);

                % Loop through each selected ratio
                for j = 1:length(selected_ratios)
                    % Split the ratio into numerator and denominator
                    elements = split(selected_ratios{j}, '/');
                    numerator = elements{1};
                    denominator = elements{2};

                    % Check if both elements exist in the current reference material
                    if any(strcmp(rows.Element, numerator)) && any(strcmp(rows.Element, denominator))
                        % Get the mean values for the numerator and denominator
                        numeratorValue = rows.(sensitivityType)(strcmp(rows.Element, numerator));
                        denominatorValue = rows.(sensitivityType)(strcmp(rows.Element, denominator));

                        % Calculate the ratio
                        ratioValue = numeratorValue / denominatorValue;

                        % Append the result to the calculated_ratios table
                        calculated_ratios = [calculated_ratios; table({refMaterial}, {selected_ratios{j}}, ratioValue, ...
                            'VariableNames', {'ReferenceMaterial', 'Ratio', 'Value'})];
                    end
                end
            end

            %%%%%%%%%%%%%%%%%%%%%%

            compareToMaterial = app.ComparetoDropDown.Value;

            % Filter rows for the reference material to compare to
            referenceRows = calculated_ratios(strcmp(calculated_ratios.ReferenceMaterial, compareToMaterial), :);

            % Extract the list of ratios available in the reference material
            availableRatios = referenceRows.Ratio;

            % Filter the calculated_ratios table to keep only rows with these ratios
            filtered_ratios = calculated_ratios(ismember(calculated_ratios.Ratio, availableRatios), :);

            if isempty(filtered_ratios)
                return
            end

            %%%%%%
            % Filter rows for the chosen reference material
            referenceRows = filtered_ratios(strcmp(filtered_ratios.ReferenceMaterial, compareToMaterial), :);

            % Initialize a new table to store the normalized ratios
            app.MSF_ratios = table();

            % Loop through each reference material in the filtered_ratios table
            uniqueMaterials = unique(filtered_ratios.ReferenceMaterial);

            for i = 1:length(uniqueMaterials)
                currentMaterial = uniqueMaterials{i};

                % Skip the chosen reference material itself
                if strcmp(currentMaterial, compareToMaterial)
                    continue;
                end

                % Filter rows for the current reference material
                currentRows = filtered_ratios(strcmp(filtered_ratios.ReferenceMaterial, currentMaterial), :);

                % Initialize a temporary table to store the ratios for this material
                tempTable = table();

                % Loop through each ratio in the current material
                for j = 1:height(currentRows)
                    currentRatio = currentRows.Ratio{j};

                    % Find the corresponding ratio in the chosen reference material
                    refRow = referenceRows(strcmp(referenceRows.Ratio, currentRatio), :);

                    if ~isempty(refRow)
                        % Calculate the normalized ratio
                        normalizedValue = currentRows.Value(j) / refRow.Value;

                        % Append the result to the temporary table
                        tempTable = [tempTable; table({currentMaterial}, {currentRatio}, normalizedValue, ...
                            'VariableNames', {'ReferenceMaterial', 'Ratio', 'NormalizedValue'})];
                    end
                end

                % Append the temporary table to the app.MSF_ratios table
                app.MSF_ratios = [app.MSF_ratios; tempTable];
            end

            app.MSF_ratios = addvars(app.MSF_ratios, ...
                repmat({char(compareToMaterial)}, height(app.MSF_ratios), 1), ...
                'NewVariableNames','ComparedTo', ...
                'After','NormalizedValue');

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            if isempty(app.MSF_ratios)
                return
            end

            % Get the unique ratios and reference materials
            uniqueRatios = unique(app.MSF_ratios.Ratio);
            uniqueMaterials = unique(app.MSF_ratios.ReferenceMaterial);

            % Prepare the figure
            cla(app.MSFAxes); % Clear the axes
            hold(app.MSFAxes, 'on'); % Hold on to plot multiple points

            % Define a colormap for different ratios
            colors = lines(length(uniqueRatios)); % Generate distinct colors for each ratio

            % Loop through each ratio and plot the points
            for i = 1:length(uniqueRatios)
                currentRatio = uniqueRatios{i};

                % Filter rows for the current ratio
                ratioRows = app.MSF_ratios(strcmp(app.MSF_ratios.Ratio, currentRatio), :);

                % Get the x and y values
                xValues = find(ismember(uniqueMaterials, ratioRows.ReferenceMaterial)); % Map materials to x-axis indices
                yValues = ratioRows.NormalizedValue;

                % Plot the points for the current ratio
                scatter(app.MSFAxes, xValues, yValues, 60, 'filled', 'MarkerFaceColor', colors(i, :), ...
                    'DisplayName', currentRatio, 'MarkerEdgeColor', 'black'); % Add legend entry
            end

            % Plot the horizontal dashed line at y = 1 (exclude from legend)
            yline(app.MSFAxes, 1, '--', 'LineWidth', 1.5, 'Color', 'k', 'HandleVisibility', 'off');

            % Set x-axis labels to the reference materials
            set(app.MSFAxes, 'XTick', 1:length(uniqueMaterials), 'XTickLabel', uniqueMaterials, 'TickLabelInterpreter', 'none');

            % Add space between the first/last x-axis entries and the plot borders
            xlim(app.MSFAxes, [0.5, length(uniqueMaterials) + 0.5]);

            % Add labels
            xlabel(app.MSFAxes, 'Reference Materials', 'Interpreter', 'none');
            ylabel(app.MSFAxes, compareToMaterial, 'Interpreter', 'none'); % Use the chosen reference material as the y-axis label

            % Show or delete the legend based on the checkbox value
            if app.ShowLegendCheckBox.Value
                legend(app.MSFAxes, 'show', 'Location', 'northeast', 'Interpreter', 'none'); % Show the legend
            else
                legend(app.MSFAxes, 'off'); % Delete the legend
            end

            % Add a grid
            grid(app.MSFAxes, 'on');

            hold(app.MSFAxes, 'off');




        end

        %%%%%%%%%%%%%%%%%%%%%%%%%% Analyte-Calibrator Assignment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function update_CAL_tree(app)

            delete(app.CALTree.Children);

            cal_indices   = strcmp(app.base.project.session.spot.type, "CAL");
            cal_materials = app.base.project.session.spot.referencematerial(cal_indices);
            unique_names  = unique(cal_materials);
            unique_names  = unique_names(~strcmp(unique_names, 'None'));
            validCALs     = unique_names(~strcmp(unique_names, 'Select Reference Material'));

            matrix_comp = app.base.project.session.spot.matrix_composition;
            matrix_lod  = app.base.project.session.spot.matrix_limits_of_detection;
            [numRows, ~] = size(matrix_comp);

            for c = 1:length(validCALs)
                calName    = validCALs(c);
                parentNode = uitreenode(app.CALTree, 'Text', char(calName));

                firstTable = [];
                for r = 1:numRows
                    candidate = matrix_comp{r, c};
                    if istable(candidate) && ~isempty(candidate)
                        firstTable = candidate;
                        break;
                    end
                end
                if isempty(firstTable)
                    continue;
                end
                allAnalytes = firstTable.Properties.VariableNames;

                isValidAnalyteTracker = false(1, length(allAnalytes));
                for r = 1:numRows
                    lodTable = matrix_lod{r, c};
                    if istable(lodTable) && ~isempty(lodTable)
                        hasNonZeroLOD         = any(lodTable{:,:} ~= 0, 1);
                        isValidAnalyteTracker = isValidAnalyteTracker | hasNonZeroLOD;
                    end
                end

                validAnalytes = allAnalytes(isValidAnalyteTracker);
                for j = 1:length(validAnalytes)
                    uitreenode(parentNode, 'Text', validAnalytes{j});
                end
            end

            if ~isfield(app.base.project.session.spot, 'analyte_calibrator_assignment')
                analytes       = app.base.project.session.spot.analytes;
                numAnalytes    = length(analytes);
                tableData      = [analytes(:), strings(numAnalytes, 1)];

                app.AnalyteTable.Data = tableData;
                app.base.project.session.spot.analyte_calibrator_assignment = tableData;
                update_analyte_table(app);

                % Auto-select all nodes if only one CAL — no ambiguity
                if numel(validCALs) == 1 && ~isempty(app.CALTree.Children) && ~isempty(app.CALTree.Children(1).Children)
                    app.CALTree.CheckedNodes = app.CALTree.Children(1).Children;
                    CALTreeCheckedNodesChanged(app, []);
                end

            else
                tableData = app.base.project.session.spot.analyte_calibrator_assignment;
                app.AnalyteTable.Data = tableData;
                update_analyte_table(app);
                update_assigned_table(app);

                nodesToRecheck = [];
                allParentNodes = app.CALTree.Children;

                for r = 1:size(tableData, 1)
                    analyteName = char(tableData(r, 1));
                    calName     = char(tableData(r, 2));

                    if ~isempty(calName)
                        for p = 1:numel(allParentNodes)
                            if strcmp(char(allParentNodes(p).Text), calName)
                                childNodes = allParentNodes(p).Children;
                                for ch = 1:numel(childNodes)
                                    if strcmp(char(childNodes(ch).Text), analyteName)
                                        nodesToRecheck = [nodesToRecheck, childNodes(ch)];
                                        break;
                                    end
                                end
                                break;
                            end
                        end
                    end
                end

                app.CALTree.CheckedNodes = nodesToRecheck;
            end

        end

        function update_analyte_table(app)

            analyteData  = app.AnalyteTable.Data;
            nRowsAnalyte = size(analyteData, 1);

            bg_analyte = ones(nRowsAnalyte, 3);

            idx_empty     = analyteData(:, 2) == "";
            idx_not_empty = ~idx_empty;

            if any(idx_empty)
                bg_analyte(idx_empty, :) = repmat([1, 229/255, 204/255], sum(idx_empty), 1);
            end

            if any(idx_not_empty)
                bg_analyte(idx_not_empty, :) = repmat([204/255, 1, 204/255], sum(idx_not_empty), 1);
            end

            app.AnalyteTable.BackgroundColor = bg_analyte;

        end

        function update_assigned_table(app)

            spotnames = app.base.project.session.spot.name(:);
            numSpots  = numel(spotnames);

            rawBracketIDs    = app.base.project.session.spot.bracket_id(:);
            uniqueBracketIds = unique(rawBracketIDs);
            uniqueBracketIds = uniqueBracketIds(uniqueBracketIds ~= 0);
            numBrackets      = length(uniqueBracketIds);

            if numBrackets == 0
                numBrackets      = 1;
                uniqueBracketIds = 1;
            end

            rep_spotNumbers = repmat((1:numSpots)', numBrackets, 1);
            rep_spotNumbers = rep_spotNumbers(:);
            rep_spotnames   = repmat(spotnames(:), numBrackets, 1);
            rep_spotnames   = rep_spotnames(:);
            rep_bracketIDs  = cellstr(string(repelem(uniqueBracketIds(:), numSpots)));
            rep_bracketIDs  = rep_bracketIDs(:);

            is_oxide_mode = app.MajorsasOxideswtCheckBox.Value;

            if is_oxide_mode
                ox_elements      = app.base.project.session.oxides.element_names;
                oxide_names      = app.base.project.session.oxides.oxide_names;
                considered_major = app.base.project.session.oxides.considered_major;
                ox_values        = app.base.project.session.oxides.conversion_factor_values;
            end

            T     = table(rep_spotNumbers, rep_spotnames, rep_bracketIDs, ...
                'VariableNames', {'#', 'Spotname', 'Bracket_id'});
            T_lod = T;
            T_unc = T;

            if ~isfield(app.base.project.session.spot, 'analyte_calibrator_assignment') || ...
                    isempty(app.base.project.session.spot.analyte_calibrator_assignment)
                app.AssignedTable.Data       = T;
                app.export_lod_table         = T;
                app.export_uncertainty_table = table();
                return;
            end

            assignments = app.base.project.session.spot.analyte_calibrator_assignment;

            cal_indices   = strcmp(app.base.project.session.spot.type, "CAL");
            cal_materials = app.base.project.session.spot.referencematerial(cal_indices);
            unique_names  = unique(cal_materials);
            unique_names  = unique_names(~strcmp(unique_names, 'None'));
            validCALs     = unique_names(~strcmp(unique_names, 'Select Reference Material'));

            % uncertainties only exist if the propagation was run
            if isequal(app.selected_host_inclusion, 'Host')
                uncertainty_field = 'matrix_composition_uncertainty';
            else
                uncertainty_field = 'inclusion_composition_uncertainty';
            end
            has_uncertainty_field = isfield(app.base.project.session.spot, uncertainty_field) && ...
                ~isempty(app.base.project.session.spot.(uncertainty_field));
            any_uncertainty_found = false;

            lod_array_all = [];

            for i = 1:size(assignments, 1)
                analyteName = char(assignments(i, 1));
                calName     = char(assignments(i, 2));

                if isempty(calName)
                    continue;
                end

                calIdx = find(strcmp(validCALs, calName));
                if isempty(calIdx)
                    continue;
                end

                comp_col = zeros(numSpots * numBrackets, 1);
                lod_col  = zeros(numSpots * numBrackets, 1);
                unc_col  = zeros(numSpots * numBrackets, 1);

                for b = 1:numBrackets
                    if isequal(app.selected_host_inclusion, 'Host')
                        compTab = app.base.project.session.spot.matrix_composition{b, calIdx};
                        lodTab  = app.base.project.session.spot.matrix_limits_of_detection{b, calIdx};
                    elseif isequal(app.selected_host_inclusion, 'Inclusion')
                        compTab = app.base.project.session.spot.inclusion_composition{b, calIdx};
                        lodTab  = app.base.project.session.spot.inclusion_limits_of_detection{b, calIdx};
                    end

                    uncTab = [];
                    if has_uncertainty_field
                        uncTab = app.base.project.session.spot.(uncertainty_field){b, calIdx};
                    end

                    startIdx = (b - 1) * numSpots + 1;
                    endIdx   = b * numSpots;

                    if ~isempty(compTab) && ismember(analyteName, compTab.Properties.VariableNames)
                        comp_col(startIdx:endIdx) = compTab.(analyteName);
                        if ismember(analyteName, lodTab.Properties.VariableNames)
                            lod_col(startIdx:endIdx) = lodTab.(analyteName);
                        end
                        % sigma of the matrix keeps the sign of the mass fraction, export the magnitude
                        if istable(uncTab) && ismember(analyteName, uncTab.Properties.VariableNames)
                            unc_col(startIdx:endIdx) = abs(uncTab.(analyteName));
                        end
                    end
                end

                if is_oxide_mode
                    base_element = regexp(analyteName, '^[A-Z][a-z]?', 'match', 'once');
                    if ~isempty(base_element)
                        element_idx = find(ox_elements == string(base_element), 1);
                        if ~isempty(element_idx) && considered_major(element_idx) == "Yes"
                            factor   = ox_values(element_idx);
                            comp_col = comp_col .* factor ./ 10000;
                            lod_col  = lod_col  .* factor ./ 10000;
                            unc_col  = unc_col  .* factor ./ 10000;
                        end
                    end
                end

                below_lod      = comp_col < lod_col;
                display_values = num2cell(comp_col);
                if any(below_lod)
                    display_values(below_lod) = arrayfun(@(x) ['<' num2str(x)], lod_col(below_lod), 'UniformOutput', false);
                end

                if any(unc_col ~= 0)
                    any_uncertainty_found = true;
                end
                unc_col(below_lod) = 0;     % no uncertainty shown where the mass fraction is below LOD

                T.(analyteName)     = display_values;
                T_lod.(analyteName) = num2cell(lod_col);
                T_unc.(analyteName) = num2cell(unc_col);
                lod_array_all       = [lod_array_all, lod_col];
            end

            if ~isempty(lod_array_all)
                non_zero_row_mask = any(lod_array_all ~= 0, 2);
                T             = T(non_zero_row_mask, :);
                T_lod         = T_lod(non_zero_row_mask, :);
                T_unc         = T_unc(non_zero_row_mask, :);
                lod_array_all = lod_array_all(non_zero_row_mask, :);

                if ~isempty(T)
                    non_zero_comp_cols = any(lod_array_all ~= 0, 1);
                    col_mask = [true(1, 3), non_zero_comp_cols];
                    T     = T(:, col_mask);
                    T_lod = T_lod(:, col_mask);
                    T_unc = T_unc(:, col_mask);
                end
            end

            num_meta_cols = 3;

            if app.IncludeMetadataCheckBox.Value && isfield(app.base.project.session, 'meta')
                metaStruct           = app.base.project.session.meta;
                metaFields           = fieldnames(metaStruct);
                current_spot_numbers = T.('#');
                metaTableToInsert    = table();

                for f = 1:length(metaFields)
                    fieldName = metaFields{f};
                    fieldData = metaStruct.(fieldName);

                    if (iscell(fieldData) || isstring(fieldData) || isnumeric(fieldData)) && numel(fieldData) == numSpots
                        colData = fieldData(:);
                        metaTableToInsert.(fieldName) = colData(current_spot_numbers);
                    end
                end

                if width(metaTableToInsert) > 0
                    T             = [T(:, 1:3),     metaTableToInsert, T(:, 4:end)];
                    T_lod         = [T_lod(:, 1:3), metaTableToInsert, T_lod(:, 4:end)];
                    T_unc         = [T_unc(:, 1:3), metaTableToInsert, T_unc(:, 4:end)];
                    num_meta_cols = 3 + width(metaTableToInsert);
                end
            end

            if app.RemovemassesfromanalytenameCheckBox.Value && width(T) > num_meta_cols
                colNames    = T.Properties.VariableNames;
                analyteCols = colNames(num_meta_cols + 1:end);

                preferred_isotopes = app.base.project.session.oxides.preferred_isotopes;
                prefStruct = struct();
                if ~isempty(preferred_isotopes)
                    toks_pref = regexp(preferred_isotopes, '^([A-Z][a-z]?)(\d+)$', 'tokens', 'once');
                    for idx = 1:numel(toks_pref)
                        if ~isempty(toks_pref{idx})
                            prefStruct.(toks_pref{idx}{1}) = toks_pref{idx}{2};
                        end
                    end
                end

                toks_cols       = regexp(analyteCols, '^([A-Z][a-z]?)(\d+)(.*)$', 'tokens', 'once');
                keepColsLogical = true(1, width(T));
                newColNames     = colNames;
                seenGroups      = struct();

                for idx = 1:numel(analyteCols)
                    cIdx = idx + num_meta_cols;
                    t    = toks_cols{idx};
                    if isempty(t), continue; end

                    elem     = t{1}; mass = t{2}; suffix = t{3};
                    groupKey = matlab.lang.makeValidName([elem, '_', suffix]);
                    isPref   = isfield(prefStruct, elem) && strcmp(prefStruct.(elem), mass);

                    if ~isfield(seenGroups, groupKey)
                        seenGroups.(groupKey) = struct('bestColIdx', cIdx, 'isPref', isPref, 'newBaseName', [elem, suffix]);
                    else
                        prev = seenGroups.(groupKey);
                        if isPref && ~prev.isPref
                            keepColsLogical(prev.bestColIdx) = false;
                            seenGroups.(groupKey).bestColIdx = cIdx;
                            seenGroups.(groupKey).isPref     = true;
                        else
                            keepColsLogical(cIdx) = false;
                        end
                    end
                end

                groupKeys = fieldnames(seenGroups);
                for k = 1:numel(groupKeys)
                    info = seenGroups.(groupKeys{k});
                    if keepColsLogical(info.bestColIdx)
                        newColNames{info.bestColIdx} = info.newBaseName;
                    end
                end

                T     = T(:, keepColsLogical);
                T_lod = T_lod(:, keepColsLogical);
                T_unc = T_unc(:, keepColsLogical);
                T.Properties.VariableNames     = newColNames(keepColsLogical);
                T_lod.Properties.VariableNames = newColNames(keepColsLogical);
                T_unc.Properties.VariableNames = newColNames(keepColsLogical);
            end

            if is_oxide_mode && width(T) > num_meta_cols
                colNames = T.Properties.VariableNames;
                for c = (num_meta_cols + 1):length(colNames)
                    base_element = regexp(colNames{c}, '^[A-Z][a-z]?', 'match', 'once');
                    if ~isempty(base_element)
                        element_idx = find(ox_elements == string(base_element), 1);
                        if ~isempty(element_idx) && considered_major(element_idx) == "Yes"
                            oxide_name   = char(oxide_names(element_idx));
                            isotope_part = regexp(colNames{c}, '\d+', 'match', 'once');
                            if ~isempty(isotope_part)
                                newName = [oxide_name, '_', isotope_part];
                            else
                                newName = oxide_name;
                            end
                            T.Properties.VariableNames{c}     = newName;
                            T_lod.Properties.VariableNames{c} = newName;
                            T_unc.Properties.VariableNames{c} = newName;
                        end
                    end
                end
            end

            for col = (num_meta_cols + 1):width(T)
                colData = T{:, col};
                isZeroCell = cellfun(@(x) isnumeric(x) && isscalar(x) && x == 0, colData);
                colData(isZeroCell) = {[]};
                T{:, col} = colData;

                lodData = T_lod{:, col};
                isZeroLOD = cellfun(@(x) isnumeric(x) && isscalar(x) && x == 0, lodData);
                lodData(isZeroLOD) = {[]};
                T_lod{:, col} = lodData;

                uncData = T_unc{:, col};
                isZeroUnc = cellfun(@(x) isnumeric(x) && isscalar(x) && x == 0, uncData);
                uncData(isZeroUnc) = {[]};
                T_unc{:, col} = uncData;
            end

            app.AssignedTable.Data       = T;
            app.AssignedTable.ColumnName = T.Properties.VariableNames;
            app.export_lod_table         = T_lod;

            % empty table if the uncertainty propagation was not run, so the export skips the sheet
            if any_uncertainty_found
                app.export_uncertainty_table = T_unc;
            else
                app.export_uncertainty_table = table();
            end

        end

        function export_displayed_assigned_table(app, outputpath)
            writetable(app.AssignedTable.Data, outputpath, 'Sheet', 'Compositions');
            writetable(app.export_lod_table,   outputpath, 'Sheet', 'LOD');

            if ~isempty(app.export_uncertainty_table)
                writetable(app.export_uncertainty_table, outputpath, 'Sheet', 'Uncertainty');
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%% Uncertainty budget %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function show_uncertainty_budget(app)

            if isempty(app.selected_results_cell)
                uialert(app.UIFigure, {'Click a cell first, then right-click.'}, 'Uncertainty budget'); return
            end

            if ~isfield(app.base.project.session.spot, 'matrix_composition_uncertainty') || ...
                    isempty(app.base.project.session.spot.matrix_composition_uncertainty) || ...
                    ~isfield(app.base.project.session.spot, 'sensitivities_uncertainty') || ...
                    ~isfield(app.base.project.session.spot, 'sensitivities_uncertainty_rm')
                uialert(app.UIFigure, {'No uncertainties available. Enable propagation and re-run quantification.'}, 'Uncertainty budget'); return
            end

            selected_row    = app.selected_results_cell(1);
            selected_column = app.selected_results_cell(2);
            element_name    = app.ResultsTable.ColumnName{selected_column};

            if ismember(element_name, {'#', 'Spotname', 'Comments'})
                uialert(app.UIFigure, {'Right-click an element cell, not a label column.'}, 'Uncertainty budget'); return
            end

            results_table_data = app.ResultsTable.Data;
            spot_index         = double(results_table_data{selected_row, 1});   % '#' column = spot index
            bracket_index      = app.BracketidDropDown.Value;
            cal_index          = app.selected_CAL;

            % stored tables the budget reads from
            tables.cps      = app.base.project.session.spot.bkgd_corrected_cps;
            tables.sem      = app.base.project.session.spot.sem_bkgd_corrected_cps;
            tables.sens     = app.base.project.session.spot.sensitivities{bracket_index, cal_index};
            tables.sens_unc = app.base.project.session.spot.sensitivities_uncertainty{bracket_index, cal_index};
            tables.sens_rm  = app.base.project.session.spot.sensitivities_uncertainty_rm{bracket_index, cal_index};

            internal_standard_name = app.base.project.session.spot.internal_standard{bracket_index, cal_index}(spot_index);
            composition            = app.base.project.session.spot.matrix_composition{bracket_index, cal_index}{spot_index, element_name};
            is_mass_fraction_entry = app.base.project.session.spot.internal_standard_mass_fraction{bracket_index, cal_index}{spot_index};

            is_total_oxide = isequal(char(internal_standard_name), 'Total Oxides');
            is_from_cal    = ~is_total_oxide && ~isempty(is_mass_fraction_entry) && startsWith(string(is_mass_fraction_entry), 'from');

            if ~is_total_oxide
                % ===== DIRECT / from-CAL =====
                internal_standard = char(internal_standard_name);

                if strcmp(element_name, internal_standard)
                    % internal standard column: the measurement terms cancel (ratios are 1)
                    relative_variance_unknown_counting = 0;
                    relative_variance_cal_counting     = 0;
                    relative_variance_rm               = 0;
                else
                    [unknown_counting_analyte, cal_counting_analyte, rm_analyte] = app.analyte_relative_variances(spot_index, element_name, tables);
                    [unknown_counting_is,      cal_counting_is,      rm_is]      = app.analyte_relative_variances(spot_index, internal_standard, tables);

                    relative_variance_unknown_counting = unknown_counting_analyte + unknown_counting_is;
                    relative_variance_cal_counting     = cal_counting_analyte     + cal_counting_is;
                    relative_variance_rm               = rm_analyte              + rm_is;
                end

                % inherited measurement uncertainty when the IS mass fraction came 'from CAL'
                relative_variance_inherited = 0;
                if is_from_cal
                    source_reference_material = extractAfter(string(is_mass_fraction_entry), 'from ');
                    source_cal_index          = find(app.CalibratorDropDown.Items == source_reference_material, 1);
                    if ~isempty(source_cal_index)
                        source_value       = app.base.project.session.spot.matrix_composition{bracket_index, source_cal_index}{spot_index, internal_standard};
                        source_uncertainty = app.base.project.session.spot.matrix_composition_uncertainty{bracket_index, source_cal_index}{spot_index, internal_standard};
                        if source_value > 0
                            relative_variance_inherited = (source_uncertainty / source_value)^2;
                        end
                    end
                end

                relative_variance_is_input = 0;
                if ~is_from_cal && isfield(app.base.project.session.spot, 'internal_standard_mass_fraction_uncertainty')
                    IS_unc = app.base.project.session.spot.internal_standard_mass_fraction_uncertainty{bracket_index, cal_index}(spot_index);
                    if ~isnan(IS_unc) && isnumeric(is_mass_fraction_entry) && is_mass_fraction_entry > 0
                        relative_variance_is_input = (IS_unc / is_mass_fraction_entry)^2;
                    end
                end

                variance_contributions = [relative_variance_unknown_counting, ...
                    relative_variance_cal_counting, ...
                    relative_variance_rm, ...
                    relative_variance_inherited, ...
                    relative_variance_is_input] * composition^2;

            else
                % ===== TOTAL OXIDES (closure propagation, split per root) =====
                oxide_terms          = recompute_oxide_terms(app, bracket_index, cal_index, spot_index);
                normalization_factor = oxide_terms.T / oxide_terms.D;   % lambda = T / D

                variance_unknown_counting = 0;
                variance_cal_counting     = 0;
                variance_rm               = 0;

                for major = 1:numel(oxide_terms.major_names)
                    major_name = oxide_terms.major_names{major};
                    [var_unknown, var_cal, var_rm] = app.analyte_sigma_p_variances(spot_index, major_name, tables);

                    closure_weight   = double(strcmp(major_name, element_name)) - ...
                        (composition * oxide_terms.c_eff(major) / oxide_terms.T);
                    closure_variance = (normalization_factor * closure_weight)^2;   % (lambda*w)^2, no p here

                    variance_unknown_counting = variance_unknown_counting + closure_variance * var_unknown;
                    variance_cal_counting     = variance_cal_counting     + closure_variance * var_cal;
                    variance_rm               = variance_rm               + closure_variance * var_rm;
                end

                if ~ismember(element_name, oxide_terms.major_names)
                    [var_unknown, var_cal, var_rm] = app.analyte_sigma_p_variances(spot_index, element_name, tables);
                    closure_variance = normalization_factor^2;   % delta = 1, c = 0  -> weight = 1
                    variance_unknown_counting = variance_unknown_counting + closure_variance * var_unknown;
                    variance_cal_counting     = variance_cal_counting     + closure_variance * var_cal;
                    variance_rm               = variance_rm               + closure_variance * var_rm;
                end

                variance_is_input = 0;
                if isfield(app.base.project.session.spot, 'internal_standard_oxide_wt_uncertainty')
                    ox_unc = app.base.project.session.spot.internal_standard_oxide_wt_uncertainty{bracket_index, cal_index}(spot_index);
                    ox_val = app.base.project.session.spot.internal_standard_oxide_wt{bracket_index, cal_index}(spot_index);
                    if ~isnan(ox_unc) && ox_val > 0
                        variance_is_input = (composition * ox_unc / ox_val)^2;
                    end
                end

                variance_contributions = [variance_unknown_counting, variance_cal_counting, variance_rm, 0, variance_is_input];


            end

            total_variance = sum(variance_contributions);
            if ~(total_variance > 0)
                uialert(app.UIFigure, {'No decomposable uncertainty for this cell.'}, 'Uncertainty budget'); return
            end

            % ---- pop-up plot: one boxed stacked bar, coloured segments, legend with percentages ----
            root_labels = {'Unknown cps', 'Calibrator cps', 'Calibrator uncertainty', 'Inherited (from CAL)', 'IS concentration'};
            root_colors = [0.29 0.51 0.71;   % Unknown cps       — steel blue
                0.84 0.62 0.22;   % Calibrator cps    — warm amber
                0.44 0.66 0.53;   % Cal uncertainty   — eucalyptus
                0.72 0.48 0.62;   % Inherited         — dusty mauve
                0.80 0.42 0.33];  % IS concentration  — canyon terracotta

            percentages = 100 * variance_contributions / total_variance;
            keep        = percentages > 0;

            kept_percentages = percentages(keep);
            kept_labels      = root_labels(keep);
            kept_colors      = root_colors(keep, :);

            legend_labels = arrayfun(@(k) sprintf('%s (%.0f%%)', kept_labels{k}, kept_percentages(k)), ...
                1:numel(kept_percentages), 'UniformOutput', false);

            spot_name = char(app.base.project.session.spot.name(spot_index));

            budget_figure = figure('Name', 'Uncertainty budget', 'NumberTitle', 'off', ...
                'Color', 'w', 'Position', [100 100 560 250]);
            budget_axes = axes('Parent', budget_figure);

            bar_handles = barh(budget_axes, 1, kept_percentages, 'stacked');
            for k = 1:numel(bar_handles)
                bar_handles(k).FaceColor = kept_colors(k, :);
                bar_handles(k).EdgeColor = 'none';
                bar_handles(k).BarWidth  = 0.5;
            end

            box(budget_axes, 'on');
            budget_axes.YTick = [];
            budget_axes.XLim  = [0 100];
            budget_axes.YLim  = [0.5 1.5];
            xlabel(budget_axes, '% of total variance');
            title(budget_axes, sprintf('%s  @  %s   (%.4g µg/g  ±  %.3g,  %.1f%% 1σ)', ...
                element_name, spot_name, composition, sqrt(total_variance), ...
                100 * sqrt(total_variance) / abs(composition)), 'Interpreter', 'none');

            legend(budget_axes, bar_handles, legend_labels, 'Location', 'southoutside', ...
                'NumColumns', 2, 'Interpreter', 'none');
        end

        function [unknown_counting, cal_counting, rm] = analyte_relative_variances(app, spot_index, name, tables)
            intensity            = tables.cps.(name)(spot_index);
            counting_sem         = tables.sem.(name)(spot_index);
            sensitivity          = tables.sens.(name)(spot_index);
            sensitivity_combined = tables.sens_unc.(name)(spot_index);
            sensitivity_rm       = tables.sens_rm.(name)(spot_index);

            % CAL counting recovered exactly from the two stored components
            sensitivity_counting = sqrt(max(sensitivity_combined^2 - sensitivity_rm^2, 0));

            unknown_counting = (counting_sem         / intensity)^2;   % unknown intensity counting
            cal_counting     = (sensitivity_counting / sensitivity)^2; % sensitivity counting part
            rm               = (sensitivity_rm       / sensitivity)^2; % sensitivity RM part
        end

        function oxide_terms = recompute_oxide_terms(app, bracket_index, cal_index, spot_index)

            oxides             = app.base.project.session.oxides;
            element_names      = oxides.element_names;
            preferred_isotopes = oxides.preferred_isotopes;
            conversion_factors = oxides.conversion_factor_values;

            sensitivities            = app.base.project.session.spot.sensitivities{bracket_index, cal_index};
            sensitivity_columns      = sensitivities.Properties.VariableNames;
            background_corrected_cps = app.base.project.session.spot.bkgd_corrected_cps;

            % --- oxide-forming isotopes actually measured, one preferred per element ---
            candidate_isotopes = {};
            for i = 1:numel(sensitivity_columns)
                base_element = sensitivity_columns{i}(isstrprop(sensitivity_columns{i}, 'alpha'));
                if ismember(base_element, element_names)
                    candidate_isotopes{end+1} = sensitivity_columns{i};
                end
            end

            elements_to_total = {};
            for i = 1:numel(element_names)
                this_element      = element_names(i);
                measured_isotopes = candidate_isotopes(cellfun(@(x) isequal(x(isstrprop(x, 'alpha')), this_element), candidate_isotopes));
                if ~isempty(measured_isotopes)
                    preferred_isotope = char(preferred_isotopes(i));
                    if ~isempty(preferred_isotope) && any(strcmp(measured_isotopes, preferred_isotope))
                        elements_to_total{end+1} = preferred_isotope;
                    else
                        elements_to_total{end+1} = measured_isotopes{1};
                    end
                end
            end

            % --- preliminary mass fractions p = max(I,0)/S over the majors ---
            major_intensities   = table2array(background_corrected_cps(spot_index, elements_to_total));
            major_sensitivities = table2array(sensitivities(spot_index, elements_to_total));
            preliminary_mass_fraction = max(major_intensities, 0) ./ major_sensitivities;

            % --- effective oxide factors (Fe folded to FeO + Fe2O3) ---
            fe_constant   = 0.699480 / 0.777314;
            fe_ratio      = app.base.project.session.spot.Fe_ratio_for_total_oxide{bracket_index, cal_index}(spot_index);
            feo_factor    = conversion_factors(element_names == "Fe");
            fe_is_split   = any(contains(oxides.oxide_names, 'FeO')) && ~isnan(fe_ratio) && ~isequal(fe_ratio, 1);

            effective_oxide_factors = zeros(1, numel(elements_to_total));
            for j = 1:numel(elements_to_total)
                isotope      = elements_to_total{j};
                base_element = regexp(isotope, '^[A-Za-z]+', 'match', 'once');
                if contains(isotope, 'Fe')
                    if fe_is_split
                        feo_fraction               = 1 / (1 + fe_constant * ((1 - fe_ratio) / fe_ratio));
                        effective_oxide_factors(j) = feo_fraction * feo_factor + (1 - feo_fraction) * 1.4297;
                    else
                        effective_oxide_factors(j) = feo_factor;
                    end
                else
                    effective_oxide_factors(j) = conversion_factors(element_names == string(base_element));
                end
            end

            oxide_terms.major_names = elements_to_total;
            oxide_terms.p           = preliminary_mass_fraction;
            oxide_terms.c_eff       = effective_oxide_factors;
            oxide_terms.D           = sum(preliminary_mass_fraction .* effective_oxide_factors);
            oxide_terms.T           = 1e4 * app.base.project.session.spot.internal_standard_oxide_wt{bracket_index, cal_index}(spot_index);
        end

        function [var_unknown, var_cal, var_rm] = analyte_sigma_p_variances(app, spot_index, name, tables)
            intensity            = tables.cps.(name)(spot_index);
            counting_sem         = tables.sem.(name)(spot_index);
            sensitivity          = tables.sens.(name)(spot_index);
            sensitivity_combined = tables.sens_unc.(name)(spot_index);
            sensitivity_rm       = tables.sens_rm.(name)(spot_index);

            sensitivity_counting = sqrt(max(sensitivity_combined^2 - sensitivity_rm^2, 0));
            p = max(intensity, 0) / sensitivity;

            var_unknown = (counting_sem / sensitivity)^2;              % survives I <= 0
            var_cal     = (p * sensitivity_counting / sensitivity)^2;
            var_rm      = (p * sensitivity_rm / sensitivity)^2;
        end

        %%%%%%% Inclusion uncertainty budget %%%%%
        function show_inclusion_uncertainty_budget(app)

            if isempty(app.selected_results_cell)
                uialert(app.UIFigure, {'Click a cell first, then right-click.'}, 'Uncertainty budget'); return
            end

            spot_data = app.base.project.session.spot;

            if ~isfield(spot_data, 'inclusion_composition_uncertainty') || isempty(spot_data.inclusion_composition_uncertainty) || ...
                    ~isfield(spot_data, 'sensitivities_uncertainty') || ~isfield(spot_data, 'sensitivities_uncertainty_rm') || ...
                    ~isfield(spot_data, 'sem_bkgd_corrected_cps_incl') || ~isfield(spot_data, 'sem_bkgd_corrected_cps_mix')
                uialert(app.UIFigure, {'No uncertainties available. Enable propagation and re-run quantification.'}, 'Uncertainty budget'); return
            end

            selected_row    = app.selected_results_cell(1);
            selected_column = app.selected_results_cell(2);
            element_name    = app.ResultsTable.ColumnName{selected_column};

            if ismember(element_name, {'#', 'Spotname', 'Comments'})
                uialert(app.UIFigure, {'Right-click an element cell, not a label column.'}, 'Uncertainty budget'); return
            end

            results_table_data = app.ResultsTable.Data;
            spot_index         = double(results_table_data{selected_row, 1});   % '#' column = spot index
            bracket_index      = app.BracketidDropDown.Value;
            cal_index          = app.selected_CAL;

            unmixing_mode          = spot_data.unmixing_via(spot_index);
            internal_standard_name = char(spot_data.internal_standard_inclusion{bracket_index, cal_index}(spot_index));

            if unmixing_mode == "Mixing ratio"
                show_inclusion_budget_mixing_ratio(app, spot_index, element_name, bracket_index, cal_index)
                return
            elseif unmixing_mode == "Two internal standards"
                show_inclusion_budget_two_IS(app, spot_index, element_name, bracket_index, cal_index)
                return
            elseif unmixing_mode ~= "Matrix-only tracer"
                uialert(app.UIFigure, {'The budget for this unmixing mode is not available.'}, 'Uncertainty budget'); return
            end

            tracer_name = char(spot_data.matrix_only_tracer(spot_index));
            if strcmp(element_name, tracer_name)
                uialert(app.UIFigure, {'The matrix-only tracer has no inclusion signal by construction.'}, 'Uncertainty budget'); return
            end

            host_spot_index = find(strcmp(spot_data.name, spot_data.matrix_from_spot(spot_index)), 1);

            % stored tables the budget reads from
            inclusion_cps_table = spot_data.bkgd_corrected_cps_incl;
            mix_sem_table       = spot_data.sem_bkgd_corrected_cps_mix;
            host_cps_table      = spot_data.bkgd_corrected_cps;
            host_sem_table      = spot_data.sem_bkgd_corrected_cps;

            tables.cps      = inclusion_cps_table;
            tables.sem      = spot_data.sem_bkgd_corrected_cps_incl;
            tables.sens     = spot_data.sensitivities{bracket_index, cal_index};
            tables.sens_unc = spot_data.sensitivities_uncertainty{bracket_index, cal_index};
            tables.sens_rm  = spot_data.sensitivities_uncertainty_rm{bracket_index, cal_index};

            % ratio r = tracer in the mix / tracer in the host, and its relative variance
            mix_tracer  = spot_data.bkgd_corrected_cps_mix.(tracer_name)(spot_index);
            host_tracer = host_cps_table.(tracer_name)(host_spot_index);

            ratio_r = mix_tracer / host_tracer;
            ratio_relative_variance = (mix_sem_table.(tracer_name)(spot_index) / mix_tracer)^2 + ...
                (host_sem_table.(tracer_name)(host_spot_index) / host_tracer)^2;

            composition = spot_data.inclusion_composition{bracket_index, cal_index}{spot_index, element_name};

            if ~strcmp(internal_standard_name, 'Total Oxides')

                % ===== DIRECT / from-CAL =====
                is_mass_fraction_entry = spot_data.internal_standard_mass_fraction_inclusion{bracket_index, cal_index}{spot_index};
                is_from_cal            = ~isempty(is_mass_fraction_entry) && startsWith(string(is_mass_fraction_entry), 'from');

                if strcmp(element_name, internal_standard_name)
                    % internal standard column: the measurement terms cancel
                    relative_variance_mix_counting  = 0;
                    relative_variance_host_counting = 0;
                    relative_variance_ratio         = 0;
                    relative_variance_cal_counting  = 0;
                    relative_variance_rm            = 0;
                else
                    % the inclusion cps is mix - host * r, so its variance is
                    %   sem_mix^2 + (r * sem_host)^2 + (host * r)^2 * relative_variance_of_r
                    analyte_inclusion_cps  = inclusion_cps_table.(element_name)(spot_index);
                    standard_inclusion_cps = inclusion_cps_table.(internal_standard_name)(spot_index);

                    mix_analyte   = (mix_sem_table.(element_name)(spot_index) / analyte_inclusion_cps)^2;
                    host_analyte  = (ratio_r * host_sem_table.(element_name)(host_spot_index) / analyte_inclusion_cps)^2;
                    ratio_analyte = (ratio_r * host_cps_table.(element_name)(host_spot_index))^2 * ratio_relative_variance / analyte_inclusion_cps^2;

                    mix_standard   = (mix_sem_table.(internal_standard_name)(spot_index) / standard_inclusion_cps)^2;
                    host_standard  = (ratio_r * host_sem_table.(internal_standard_name)(host_spot_index) / standard_inclusion_cps)^2;
                    ratio_standard = (ratio_r * host_cps_table.(internal_standard_name)(host_spot_index))^2 * ratio_relative_variance / standard_inclusion_cps^2;

                    % calibrator parts of the two sensitivities
                    sensitivity_analyte  = tables.sens.(element_name)(spot_index);
                    sensitivity_standard = tables.sens.(internal_standard_name)(spot_index);

                    rm_unc_analyte  = tables.sens_rm.(element_name)(spot_index);
                    rm_unc_standard = tables.sens_rm.(internal_standard_name)(spot_index);

                    counting_unc_analyte  = sqrt(max(tables.sens_unc.(element_name)(spot_index)^2 - rm_unc_analyte^2, 0));
                    counting_unc_standard = sqrt(max(tables.sens_unc.(internal_standard_name)(spot_index)^2 - rm_unc_standard^2, 0));

                    relative_variance_mix_counting  = mix_analyte + mix_standard;
                    relative_variance_host_counting = host_analyte + host_standard;
                    relative_variance_ratio         = ratio_analyte + ratio_standard;
                    relative_variance_cal_counting  = (counting_unc_analyte / sensitivity_analyte)^2 + (counting_unc_standard / sensitivity_standard)^2;
                    relative_variance_rm            = (rm_unc_analyte / sensitivity_analyte)^2 + (rm_unc_standard / sensitivity_standard)^2;
                end

                % inherited measurement uncertainty when the IS mass fraction came 'from CAL'
                relative_variance_inherited = 0;
                if is_from_cal
                    source_reference_material = extractAfter(string(is_mass_fraction_entry), 'from ');
                    source_cal_index          = find(app.CalibratorDropDown.Items == source_reference_material, 1);
                    if ~isempty(source_cal_index)
                        source_value       = spot_data.inclusion_composition{bracket_index, source_cal_index}{spot_index, internal_standard_name};
                        source_uncertainty = spot_data.inclusion_composition_uncertainty{bracket_index, source_cal_index}{spot_index, internal_standard_name};
                        if source_value > 0
                            relative_variance_inherited = (source_uncertainty / source_value)^2;
                        end
                    end
                end

                % user-input uncertainty of the IS mass fraction
                relative_variance_is_input = 0;
                if ~is_from_cal && isfield(spot_data, 'internal_standard_mass_fraction_uncertainty_inclusion')
                    IS_unc = spot_data.internal_standard_mass_fraction_uncertainty_inclusion{bracket_index, cal_index}(spot_index);
                    if ~isnan(IS_unc) && isnumeric(is_mass_fraction_entry) && is_mass_fraction_entry > 0
                        relative_variance_is_input = (IS_unc / is_mass_fraction_entry)^2;
                    end
                end

                variance_contributions = [relative_variance_mix_counting, ...
                    relative_variance_host_counting, ...
                    relative_variance_ratio, ...
                    relative_variance_cal_counting, ...
                    relative_variance_rm, ...
                    relative_variance_inherited, ...
                    relative_variance_is_input] * composition^2;

            else

                % ===== TOTAL OXIDES (closure propagation, split per root) =====
                oxide_terms          = recompute_oxide_terms_inclusion(app, bracket_index, cal_index, spot_index);
                normalization_factor = oxide_terms.T / oxide_terms.D;   % lambda = T / D

                variance_mix_counting  = 0;
                variance_host_counting = 0;
                variance_ratio         = 0;
                variance_cal_counting  = 0;
                variance_rm            = 0;

                % every major contributes with its closure weight; a non-oxide element adds its own term once
                names_to_add = oxide_terms.major_names;
                if ~ismember(element_name, oxide_terms.major_names)
                    names_to_add{end+1} = element_name;
                end

                for name_number = 1:numel(names_to_add)
                    name_to_add = names_to_add{name_number};
                    sensitivity = tables.sens.(name_to_add)(spot_index);
                    p_value     = max(inclusion_cps_table.(name_to_add)(spot_index), 0) / sensitivity;

                    if name_number <= numel(oxide_terms.major_names)
                        closure_weight = double(strcmp(name_to_add, element_name)) - ...
                            composition * oxide_terms.c_eff(name_number) / oxide_terms.T;
                    else
                        closure_weight = 1;   % non-oxide element: delta = 1, oxide factor = 0
                    end
                    closure_variance = (normalization_factor * closure_weight)^2;

                    % counting error of the inclusion cps, split into mix, host and tracer ratio
                    % (the tracer itself has no inclusion signal and no error)
                    if strcmp(name_to_add, tracer_name)
                        part_mix = 0; part_host = 0; part_ratio = 0;
                    else
                        part_mix   = (mix_sem_table.(name_to_add)(spot_index) / sensitivity)^2;
                        part_host  = (ratio_r * host_sem_table.(name_to_add)(host_spot_index) / sensitivity)^2;
                        part_ratio = (ratio_r * host_cps_table.(name_to_add)(host_spot_index))^2 * ratio_relative_variance / sensitivity^2;
                    end

                    % calibrator parts of the sensitivity
                    rm_uncertainty       = tables.sens_rm.(name_to_add)(spot_index);
                    counting_uncertainty = sqrt(max(tables.sens_unc.(name_to_add)(spot_index)^2 - rm_uncertainty^2, 0));
                    part_cal = (p_value * counting_uncertainty / sensitivity)^2;
                    part_rm  = (p_value * rm_uncertainty / sensitivity)^2;

                    variance_mix_counting  = variance_mix_counting  + closure_variance * part_mix;
                    variance_host_counting = variance_host_counting + closure_variance * part_host;
                    variance_ratio         = variance_ratio         + closure_variance * part_ratio;
                    variance_cal_counting  = variance_cal_counting  + closure_variance * part_cal;
                    variance_rm            = variance_rm            + closure_variance * part_rm;
                end

                % user-input uncertainty of the total oxide sum
                variance_is_input = 0;
                if isfield(spot_data, 'internal_standard_oxide_wt_uncertainty_inclusion')
                    oxide_sum_unc = spot_data.internal_standard_oxide_wt_uncertainty_inclusion{bracket_index, cal_index}(spot_index);
                    oxide_sum     = spot_data.internal_standard_oxide_wt_inclusion{bracket_index, cal_index}(spot_index);
                    if ~isnan(oxide_sum_unc) && oxide_sum > 0
                        variance_is_input = (composition * oxide_sum_unc / oxide_sum)^2;
                    end
                end

                variance_contributions = [variance_mix_counting, variance_host_counting, variance_ratio, ...
                    variance_cal_counting, variance_rm, 0, variance_is_input];
            end

            total_variance = sum(variance_contributions);
            if ~(total_variance > 0)
                uialert(app.UIFigure, {'No decomposable uncertainty for this cell.'}, 'Uncertainty budget'); return
            end

            % ---- pop-up plot: one boxed stacked bar, coloured segments, legend with percentages ----
            root_labels = {'Mix cps', 'Host cps', 'Tracer ratio', 'Calibrator cps', 'Calibrator uncertainty', ...
                'Inherited (from CAL)', 'IS concentration'};
            root_colors = [0.29 0.51 0.71;   % Mix cps           — steel blue
                0.62 0.78 0.90;   % Host cps          — pale steel
                0.17 0.30 0.50;   % Tracer ratio      — deep navy
                0.84 0.62 0.22;   % Calibrator cps    — warm amber
                0.44 0.66 0.53;   % Cal uncertainty   — eucalyptus
                0.72 0.48 0.62;   % Inherited         — dusty mauve
                0.80 0.42 0.33];  % IS concentration  — canyon terracotta

            spot_name = char(spot_data.name(spot_index));
            plot_inclusion_uncertainty_budget(app, variance_contributions, root_labels, root_colors, element_name, spot_name, composition)

        end

        function oxide_terms = recompute_oxide_terms_inclusion(app, bracket_index, cal_index, spot_index)

            spot_data          = app.base.project.session.spot;
            oxides             = app.base.project.session.oxides;
            element_names      = oxides.element_names;
            preferred_isotopes = oxides.preferred_isotopes;
            conversion_factors = oxides.conversion_factor_values;

            sensitivities       = spot_data.sensitivities{bracket_index, cal_index};
            sensitivity_columns = sensitivities.Properties.VariableNames;
            inclusion_cps       = spot_data.bkgd_corrected_cps_incl;

            % --- oxide-forming isotopes actually measured, one preferred per element ---
            candidate_isotopes = {};
            for column_number = 1:numel(sensitivity_columns)
                base_element = sensitivity_columns{column_number}(isstrprop(sensitivity_columns{column_number}, 'alpha'));
                if ismember(base_element, element_names)
                    candidate_isotopes{end+1} = sensitivity_columns{column_number};
                end
            end

            major_names = {};
            for element_number = 1:numel(element_names)
                this_element      = element_names(element_number);
                measured_isotopes = candidate_isotopes(cellfun(@(x) isequal(x(isstrprop(x, 'alpha')), this_element), candidate_isotopes));
                if ~isempty(measured_isotopes)
                    preferred_isotope = char(preferred_isotopes(element_number));
                    if ~isempty(preferred_isotope) && any(strcmp(measured_isotopes, preferred_isotope))
                        major_names{end+1} = preferred_isotope;
                    else
                        major_names{end+1} = measured_isotopes{1};
                    end
                end
            end

            % --- preliminary mass fractions p = max(I,0)/S over the majors ---
            major_intensities         = table2array(inclusion_cps(spot_index, major_names));
            major_sensitivities       = table2array(sensitivities(spot_index, major_names));
            preliminary_mass_fraction = max(major_intensities, 0) ./ major_sensitivities;

            % --- effective oxide factors (iron folded into FeO and Fe2O3) ---
            iron_constant        = 0.699480 / 0.777314;
            iron_oxidation_ratio = spot_data.Fe_ratio_for_total_oxide_inclusion{bracket_index, cal_index}(spot_index);
            iron_oxide_factor    = conversion_factors(element_names == "Fe");
            iron_is_split        = any(contains(oxides.oxide_names, 'FeO')) && ~isnan(iron_oxidation_ratio) && ~isequal(iron_oxidation_ratio, 1);

            effective_oxide_factors = zeros(1, numel(major_names));
            for major_number = 1:numel(major_names)
                isotope      = major_names{major_number};
                base_element = regexp(isotope, '^[A-Za-z]+', 'match', 'once');
                if contains(isotope, 'Fe')
                    if iron_is_split
                        feo_share = 1 / (1 + iron_constant * ((1 - iron_oxidation_ratio) / iron_oxidation_ratio));
                        effective_oxide_factors(major_number) = feo_share * iron_oxide_factor + (1 - feo_share) * 1.4297;
                    else
                        effective_oxide_factors(major_number) = iron_oxide_factor;
                    end
                else
                    effective_oxide_factors(major_number) = conversion_factors(element_names == string(base_element));
                end
            end

            oxide_terms.major_names = major_names;
            oxide_terms.p           = preliminary_mass_fraction;
            oxide_terms.c_eff       = effective_oxide_factors;
            oxide_terms.D           = sum(preliminary_mass_fraction .* effective_oxide_factors);
            oxide_terms.T           = 1e4 * spot_data.internal_standard_oxide_wt_inclusion{bracket_index, cal_index}(spot_index);
        end

        function plot_inclusion_uncertainty_budget(app, variance_contributions, root_labels, root_colors, element_name, spot_name, composition)

            total_variance = sum(variance_contributions);
            if ~(total_variance > 0)
                uialert(app.UIFigure, {'No decomposable uncertainty for this cell.'}, 'Uncertainty budget'); return
            end

            percentages = 100 * variance_contributions / total_variance;
            keep        = percentages > 0;

            kept_percentages = percentages(keep);
            kept_labels      = root_labels(keep);
            kept_colors      = root_colors(keep, :);

            legend_labels = arrayfun(@(k) sprintf('%s (%.0f%%)', kept_labels{k}, kept_percentages(k)), ...
                1:numel(kept_percentages), 'UniformOutput', false);

            budget_figure = figure('Name', 'Uncertainty budget (inclusion)', 'NumberTitle', 'off', ...
                'Color', 'w', 'Position', [100 100 560 250]);
            budget_axes = axes('Parent', budget_figure);

            bar_handles = barh(budget_axes, 1, kept_percentages, 'stacked');
            for k = 1:numel(bar_handles)
                bar_handles(k).FaceColor = kept_colors(k, :);
                bar_handles(k).EdgeColor = 'none';
                bar_handles(k).BarWidth  = 0.5;
            end

            box(budget_axes, 'on');
            budget_axes.YTick = [];
            budget_axes.XLim  = [0 100];
            budget_axes.YLim  = [0.5 1.5];
            xlabel(budget_axes, '% of total variance');
            title(budget_axes, sprintf('%s  @  %s   (%.4g µg/g  ±  %.3g,  %.1f%% 1σ)', ...
                element_name, spot_name, composition, sqrt(total_variance), ...
                100 * sqrt(total_variance) / abs(composition)), 'Interpreter', 'none');

            legend(budget_axes, bar_handles, legend_labels, 'Location', 'southoutside', ...
                'NumColumns', 2, 'Interpreter', 'none');
        end

        function show_inclusion_budget_mixing_ratio(app, spot_index, element_name, bracket_index, cal_index)

            % Same partial derivatives as calculate_inclusion_uncertainties_mixing_ratio, for one cell,
            % grouped by source: mix cps, calibrator (counting and RM), host composition,
            % IS mass fraction (own input or inherited) and the mixing ratio input.

            spot_data     = app.base.project.session.spot;
            standard_name = char(spot_data.internal_standard_inclusion{bracket_index, cal_index}(spot_index));

            if isempty(standard_name) || strcmp(standard_name, 'Total Oxides')
                uialert(app.UIFigure, {'The budget is not available for this internal standard.'}, 'Uncertainty budget'); return
            end

            host_composition_table = spot_data.matrix_composition{bracket_index, cal_index};
            host_uncertainty_table = spot_data.matrix_composition_uncertainty{bracket_index, cal_index};
            host_spot_index        = find(strcmp(spot_data.name, spot_data.matrix_from_spot(spot_index)), 1);

            if isempty(host_composition_table) || isempty(host_uncertainty_table) || isempty(host_spot_index)
                uialert(app.UIFigure, {'The host of this spot has no quantified composition and uncertainty.'}, 'Uncertainty budget'); return
            end

            composition  = spot_data.inclusion_composition{bracket_index, cal_index}{spot_index, element_name};
            mixing_ratio = spot_data.mixing_ratio{bracket_index, cal_index}(spot_index);

            mixing_ratio_unc = spot_data.mixing_ratio_uncertainty_inclusion{bracket_index, cal_index}(spot_index);
            if isnan(mixing_ratio_unc), mixing_ratio_unc = 0; end

            % the IS mass fraction: own input, or inherited from another calibrator
            mass_fraction_entry = spot_data.internal_standard_mass_fraction_inclusion{bracket_index, cal_index}{spot_index};
            if isempty(mass_fraction_entry)
                uialert(app.UIFigure, {'No internal standard mass fraction for this spot.'}, 'Uncertainty budget'); return
            end

            mass_fraction_is_inherited = startsWith(string(mass_fraction_entry), 'from');
            if mass_fraction_is_inherited
                source_cal_index = find(app.CalibratorDropDown.Items == extractAfter(string(mass_fraction_entry), 'from '), 1);
                if isempty(source_cal_index)
                    uialert(app.UIFigure, {'The source calibrator was not found.'}, 'Uncertainty budget'); return
                end
                standard_mass_fraction     = spot_data.inclusion_composition{bracket_index, source_cal_index}{spot_index, standard_name};
                standard_mass_fraction_unc = spot_data.inclusion_composition_uncertainty{bracket_index, source_cal_index}{spot_index, standard_name};
            else
                standard_mass_fraction     = mass_fraction_entry;
                standard_mass_fraction_unc = spot_data.internal_standard_mass_fraction_uncertainty_inclusion{bracket_index, cal_index}(spot_index);
                if isnan(standard_mass_fraction_unc), standard_mass_fraction_unc = 0; end
            end

            if strcmp(element_name, standard_name)
                % by construction the inclusion value of the standard is its mass fraction
                variance_mix_cps = 0; variance_cal_counting = 0; variance_rm = 0; variance_host = 0;
                variance_mixing_ratio = 0;
                variance_standard_fraction = standard_mass_fraction_unc^2;
            else
                sensitivity_table     = spot_data.sensitivities{bracket_index, cal_index};
                sensitivity_unc_table = spot_data.sensitivities_uncertainty{bracket_index, cal_index};
                sensitivity_rm_table  = spot_data.sensitivities_uncertainty_rm{bracket_index, cal_index};

                % inputs
                analyte_mix_cps     = spot_data.bkgd_corrected_cps_mix.(element_name)(spot_index);
                analyte_mix_cps_sem = spot_data.sem_bkgd_corrected_cps_mix.(element_name)(spot_index);
                standard_mix_cps     = spot_data.bkgd_corrected_cps_mix.(standard_name)(spot_index);
                standard_mix_cps_sem = spot_data.sem_bkgd_corrected_cps_mix.(standard_name)(spot_index);

                analyte_sensitivity  = sensitivity_table.(element_name)(spot_index);
                standard_sensitivity = sensitivity_table.(standard_name)(spot_index);

                analyte_rm_unc  = sensitivity_rm_table.(element_name)(spot_index);
                standard_rm_unc = sensitivity_rm_table.(standard_name)(spot_index);
                analyte_counting_unc  = sqrt(max(sensitivity_unc_table.(element_name)(spot_index)^2  - analyte_rm_unc^2, 0));
                standard_counting_unc = sqrt(max(sensitivity_unc_table.(standard_name)(spot_index)^2 - standard_rm_unc^2, 0));

                host_standard_composition = host_composition_table.(standard_name)(host_spot_index);
                host_standard_unc         = host_uncertainty_table.(standard_name)(host_spot_index);
                host_analyte_composition  = host_composition_table.(element_name)(host_spot_index);
                host_analyte_unc          = host_uncertainty_table.(element_name)(host_spot_index);

                % intermediate values
                analyte_factor = (analyte_mix_cps / standard_mix_cps) * (standard_sensitivity / analyte_sensitivity);
                mixed_standard_composition = (1 - mixing_ratio) * host_standard_composition + mixing_ratio * standard_mass_fraction;

                % partial derivatives of the inclusion composition
                effect_of_factor         = mixed_standard_composition / mixing_ratio;
                d_analyte_mix_cps        = effect_of_factor * standard_sensitivity / (standard_mix_cps * analyte_sensitivity);
                d_analyte_sensitivity    = -effect_of_factor * analyte_factor / analyte_sensitivity;
                d_standard_mix_cps       = -effect_of_factor * analyte_factor / standard_mix_cps;
                d_standard_sensitivity   = effect_of_factor * analyte_factor / standard_sensitivity;
                d_host_standard          = analyte_factor * (1 - mixing_ratio) / mixing_ratio;
                d_host_analyte           = -(1 - mixing_ratio) / mixing_ratio;
                d_standard_mass_fraction = analyte_factor;
                d_mixing_ratio           = (host_analyte_composition - analyte_factor * host_standard_composition) / mixing_ratio^2;

                % variance per source
                variance_mix_cps           = (d_analyte_mix_cps * analyte_mix_cps_sem)^2 + (d_standard_mix_cps * standard_mix_cps_sem)^2;
                variance_cal_counting      = (d_analyte_sensitivity * analyte_counting_unc)^2 + (d_standard_sensitivity * standard_counting_unc)^2;
                variance_rm                = (d_analyte_sensitivity * analyte_rm_unc)^2 + (d_standard_sensitivity * standard_rm_unc)^2;
                variance_host              = (d_host_standard * host_standard_unc)^2 + (d_host_analyte * host_analyte_unc)^2;
                variance_standard_fraction = (d_standard_mass_fraction * standard_mass_fraction_unc)^2;
                variance_mixing_ratio      = (d_mixing_ratio * mixing_ratio_unc)^2;
            end

            % the standard's mass fraction counts as inherited or as the user's input
            if mass_fraction_is_inherited
                variance_inherited = variance_standard_fraction;
                variance_is_input  = 0;
            else
                variance_inherited = 0;
                variance_is_input  = variance_standard_fraction;
            end

            variance_contributions = [variance_mix_cps, variance_cal_counting, variance_rm, variance_host, ...
                variance_inherited, variance_is_input, variance_mixing_ratio];

            root_labels = {'Mix cps', 'Calibrator cps', 'Calibrator uncertainty', 'Host composition', ...
                'Inherited (from CAL)', 'IS concentration', 'Mixing ratio'};
            root_colors = [0.29 0.51 0.71;   % Mix cps               — steel blue
                0.84 0.62 0.22;   % Calibrator cps        — warm amber
                0.44 0.66 0.53;   % Calibrator uncertainty — eucalyptus
                0.62 0.78 0.90;   % Host composition      — pale steel
                0.72 0.48 0.62;   % Inherited             — dusty mauve
                0.80 0.42 0.33;   % IS concentration      — canyon terracotta
                0.76 0.70 0.52];  % Mixing ratio          — warm sand

            spot_name = char(spot_data.name(spot_index));
            plot_inclusion_uncertainty_budget(app, variance_contributions, root_labels, root_colors, element_name, spot_name, composition)
        end

        function show_inclusion_budget_two_IS(app, spot_index, element_name, bracket_index, cal_index)

            % Same partial derivatives as calculate_inclusion_uncertainties_two_IS, for one cell,
            % grouped by source. The mixing ratio is computed from the inputs, so its effect is
            % included in the groups of the inputs it depends on (there is no separate bar for it).

            spot_data            = app.base.project.session.spot;
            first_standard_name  = char(spot_data.internal_standard_inclusion{bracket_index, cal_index}(spot_index));
            second_standard_name = char(spot_data.second_internal_standard_inclusion{bracket_index, cal_index}(spot_index));

            if isempty(first_standard_name) || isempty(second_standard_name) || strcmp(first_standard_name, 'Total Oxides')
                uialert(app.UIFigure, {'The budget is not available for these internal standards.'}, 'Uncertainty budget'); return
            end

            host_composition_table = spot_data.matrix_composition{bracket_index, cal_index};
            host_uncertainty_table = spot_data.matrix_composition_uncertainty{bracket_index, cal_index};
            host_spot_index        = find(strcmp(spot_data.name, spot_data.matrix_from_spot(spot_index)), 1);

            if isempty(host_composition_table) || isempty(host_uncertainty_table) || isempty(host_spot_index)
                uialert(app.UIFigure, {'The host of this spot has no quantified composition and uncertainty.'}, 'Uncertainty budget'); return
            end

            composition = spot_data.inclusion_composition{bracket_index, cal_index}{spot_index, element_name};

            % first standard: own input, or inherited from another calibrator
            first_entry = spot_data.internal_standard_mass_fraction_inclusion{bracket_index, cal_index}{spot_index};
            if isempty(first_entry)
                uialert(app.UIFigure, {'No mass fraction for the first internal standard.'}, 'Uncertainty budget'); return
            end
            first_is_inherited = startsWith(string(first_entry), 'from');
            if first_is_inherited
                source_cal_index = find(app.CalibratorDropDown.Items == extractAfter(string(first_entry), 'from '), 1);
                if isempty(source_cal_index)
                    uialert(app.UIFigure, {'The source calibrator was not found.'}, 'Uncertainty budget'); return
                end
                first_fraction     = spot_data.inclusion_composition{bracket_index, source_cal_index}{spot_index, first_standard_name};
                first_fraction_unc = spot_data.inclusion_composition_uncertainty{bracket_index, source_cal_index}{spot_index, first_standard_name};
            else
                first_fraction     = first_entry;
                first_fraction_unc = spot_data.internal_standard_mass_fraction_uncertainty_inclusion{bracket_index, cal_index}(spot_index);
                if isnan(first_fraction_unc), first_fraction_unc = 0; end
            end

            % second standard: own input, or inherited from another calibrator
            second_entry = spot_data.second_internal_standard_mass_fraction_inclusion{bracket_index, cal_index}{spot_index};
            if isempty(second_entry)
                uialert(app.UIFigure, {'No mass fraction for the second internal standard.'}, 'Uncertainty budget'); return
            end
            second_is_inherited = startsWith(string(second_entry), 'from');
            if second_is_inherited
                source_cal_index = find(app.CalibratorDropDown.Items == extractAfter(string(second_entry), 'from '), 1);
                if isempty(source_cal_index)
                    uialert(app.UIFigure, {'The source calibrator was not found.'}, 'Uncertainty budget'); return
                end
                second_fraction     = spot_data.inclusion_composition{bracket_index, source_cal_index}{spot_index, second_standard_name};
                second_fraction_unc = spot_data.inclusion_composition_uncertainty{bracket_index, source_cal_index}{spot_index, second_standard_name};
            else
                second_fraction     = second_entry;
                second_fraction_unc = spot_data.second_internal_standard_mass_fraction_uncertainty_inclusion{bracket_index, cal_index}(spot_index);
                if isnan(second_fraction_unc), second_fraction_unc = 0; end
            end

            variance_mix_cps = 0; variance_cal_counting = 0; variance_rm = 0; variance_host = 0;
            variance_first_fraction = 0; variance_second_fraction = 0;

            if strcmp(element_name, first_standard_name)
                % by construction the inclusion value of a standard is its mass fraction
                variance_first_fraction = first_fraction_unc^2;

            elseif strcmp(element_name, second_standard_name)
                variance_second_fraction = second_fraction_unc^2;

            else
                sensitivity_table     = spot_data.sensitivities{bracket_index, cal_index};
                sensitivity_unc_table = spot_data.sensitivities_uncertainty{bracket_index, cal_index};
                sensitivity_rm_table  = spot_data.sensitivities_uncertainty_rm{bracket_index, cal_index};
                mix_cps_table         = spot_data.bkgd_corrected_cps_mix;
                mix_sem_table         = spot_data.sem_bkgd_corrected_cps_mix;

                % inputs: analyte
                analyte_mix_cps     = mix_cps_table.(element_name)(spot_index);
                analyte_mix_cps_sem = mix_sem_table.(element_name)(spot_index);
                analyte_sensitivity = sensitivity_table.(element_name)(spot_index);
                analyte_rm_unc      = sensitivity_rm_table.(element_name)(spot_index);
                analyte_counting_unc = sqrt(max(sensitivity_unc_table.(element_name)(spot_index)^2 - analyte_rm_unc^2, 0));
                host_analyte        = host_composition_table.(element_name)(host_spot_index);
                host_analyte_unc    = host_uncertainty_table.(element_name)(host_spot_index);

                % inputs: first standard
                first_mix_cps       = mix_cps_table.(first_standard_name)(spot_index);
                first_mix_cps_sem   = mix_sem_table.(first_standard_name)(spot_index);
                first_sensitivity   = sensitivity_table.(first_standard_name)(spot_index);
                first_rm_unc        = sensitivity_rm_table.(first_standard_name)(spot_index);
                first_counting_unc  = sqrt(max(sensitivity_unc_table.(first_standard_name)(spot_index)^2 - first_rm_unc^2, 0));
                first_host          = host_composition_table.(first_standard_name)(host_spot_index);
                first_host_unc      = host_uncertainty_table.(first_standard_name)(host_spot_index);

                % inputs: second standard
                second_mix_cps      = mix_cps_table.(second_standard_name)(spot_index);
                second_mix_cps_sem  = mix_sem_table.(second_standard_name)(spot_index);
                second_sensitivity  = sensitivity_table.(second_standard_name)(spot_index);
                second_rm_unc       = sensitivity_rm_table.(second_standard_name)(spot_index);
                second_counting_unc = sqrt(max(sensitivity_unc_table.(second_standard_name)(spot_index)^2 - second_rm_unc^2, 0));
                second_host         = host_composition_table.(second_standard_name)(host_spot_index);
                second_host_unc     = host_uncertainty_table.(second_standard_name)(host_spot_index);

                % ratio of the two standards in the mix, and the mixing ratio
                standards_ratio     = (first_mix_cps / second_mix_cps) * (second_sensitivity / first_sensitivity);
                closure_numerator   = first_host - standards_ratio * second_host;
                closure_denominator = first_host - first_fraction - standards_ratio * second_host + standards_ratio * second_fraction;
                if closure_denominator == 0
                    uialert(app.UIFigure, {'The mixing ratio cannot be determined for this spot.'}, 'Uncertainty budget'); return
                end
                mixing_ratio = closure_numerator / closure_denominator;

                analyte_factor = (analyte_mix_cps / second_mix_cps) * (second_sensitivity / analyte_sensitivity);
                mixed_second   = (1 - mixing_ratio) * second_host + mixing_ratio * second_fraction;

                % partials of the inclusion composition with the mixing ratio held fixed
                effect_of_factor         = mixed_second / mixing_ratio;
                d_second_host_direct     = analyte_factor * (1 - mixing_ratio) / mixing_ratio;
                d_second_fraction_direct = analyte_factor;
                d_host_analyte           = -(1 - mixing_ratio) / mixing_ratio;
                d_mixing_ratio           = (host_analyte - analyte_factor * second_host) / mixing_ratio^2;

                % partials of the mixing ratio
                x_d_first_host      = (standards_ratio * second_fraction - first_fraction) / closure_denominator^2;
                x_d_second_host     = standards_ratio * (first_fraction - standards_ratio * second_fraction) / closure_denominator^2;
                x_d_first_fraction  = closure_numerator / closure_denominator^2;
                x_d_second_fraction = -standards_ratio * closure_numerator / closure_denominator^2;
                x_d_standards_ratio = (second_host * (first_fraction - standards_ratio * second_fraction) - closure_numerator * second_fraction) / closure_denominator^2;

                % partials of the standards ratio
                ratio_d_first_mix_cps  = standards_ratio / first_mix_cps;
                ratio_d_second_mix_cps = -standards_ratio / second_mix_cps;
                ratio_d_first_sens     = -standards_ratio / first_sensitivity;
                ratio_d_second_sens    = standards_ratio / second_sensitivity;

                % partials of the analyte factor
                factor_d_analyte_mix_cps = second_sensitivity / (second_mix_cps * analyte_sensitivity);
                factor_d_second_mix_cps  = -analyte_factor / second_mix_cps;
                factor_d_analyte_sens    = -analyte_factor / analyte_sensitivity;
                factor_d_second_sens     = analyte_factor / second_sensitivity;

                % total derivatives: direct part + part through the mixing ratio
                via_standards_ratio = d_mixing_ratio * x_d_standards_ratio;

                d_analyte_mix_cps     = effect_of_factor * factor_d_analyte_mix_cps;
                d_analyte_sensitivity = effect_of_factor * factor_d_analyte_sens;
                d_first_mix_cps       = via_standards_ratio * ratio_d_first_mix_cps;
                d_first_sensitivity   = via_standards_ratio * ratio_d_first_sens;
                d_second_mix_cps      = effect_of_factor * factor_d_second_mix_cps + via_standards_ratio * ratio_d_second_mix_cps;
                d_second_sensitivity  = effect_of_factor * factor_d_second_sens    + via_standards_ratio * ratio_d_second_sens;
                d_first_host          = d_mixing_ratio * x_d_first_host;
                d_second_host         = d_second_host_direct + d_mixing_ratio * x_d_second_host;
                d_first_fraction      = d_mixing_ratio * x_d_first_fraction;
                d_second_fraction     = d_second_fraction_direct + d_mixing_ratio * x_d_second_fraction;

                % variance per source
                variance_mix_cps = (d_analyte_mix_cps * analyte_mix_cps_sem)^2 + (d_first_mix_cps * first_mix_cps_sem)^2 + ...
                    (d_second_mix_cps * second_mix_cps_sem)^2;
                variance_cal_counting = (d_analyte_sensitivity * analyte_counting_unc)^2 + (d_first_sensitivity * first_counting_unc)^2 + ...
                    (d_second_sensitivity * second_counting_unc)^2;
                variance_rm = (d_analyte_sensitivity * analyte_rm_unc)^2 + (d_first_sensitivity * first_rm_unc)^2 + ...
                    (d_second_sensitivity * second_rm_unc)^2;
                variance_host = (d_host_analyte * host_analyte_unc)^2 + (d_first_host * first_host_unc)^2 + ...
                    (d_second_host * second_host_unc)^2;
                variance_first_fraction  = (d_first_fraction * first_fraction_unc)^2;
                variance_second_fraction = (d_second_fraction * second_fraction_unc)^2;
            end

            % each standard's mass fraction counts as inherited or as the user's input
            variance_inherited = 0;
            variance_is_input  = 0;
            if first_is_inherited
                variance_inherited = variance_inherited + variance_first_fraction;
            else
                variance_is_input = variance_is_input + variance_first_fraction;
            end
            if second_is_inherited
                variance_inherited = variance_inherited + variance_second_fraction;
            else
                variance_is_input = variance_is_input + variance_second_fraction;
            end

            variance_contributions = [variance_mix_cps, variance_cal_counting, variance_rm, variance_host, ...
                variance_inherited, variance_is_input, 0];

            root_labels = {'Mix cps', 'Calibrator cps', 'Calibrator uncertainty', 'Host composition', ...
                'Inherited (from CAL)', 'IS concentration', 'Mixing ratio'};
            root_colors = [0.29 0.51 0.71;   % Mix cps               — steel blue
                0.84 0.62 0.22;   % Calibrator cps        — warm amber
                0.44 0.66 0.53;   % Calibrator uncertainty — eucalyptus
                0.62 0.78 0.90;   % Host composition      — pale steel
                0.72 0.48 0.62;   % Inherited             — dusty mauve
                0.80 0.42 0.33;   % IS concentration      — canyon terracotta
                0.76 0.70 0.52];  % Mixing ratio          — warm sand

            spot_name = char(spot_data.name(spot_index));
            plot_inclusion_uncertainty_budget(app, variance_contributions, root_labels, root_colors, element_name, spot_name, composition)
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

            %% when the show session button is pressed & when the Interval_Module is called from another Module
            if  exist("data", "var") % e.g. for API call

                app.base.project.session =  app.sourceapp.base(project_id).project(session_id).session;
                app.base.project.session.config.module_status.results = true;


            elseif exist("project_id","var") && exist("session_id","var") % coming from the base

                app.base.project.session =  app.sourceapp.base(project_id).project(session_id).session;
                app.base.project.session.config.module_status.results = true;

            end

            app.project_id = project_id;
            app.session_id = session_id;
            app.UIFigure.Name = [char(app.base.project_name) ' - ' char(app.base.project.session.session_name)]; %string(app.base.project.session.session_name);


            if isfield(app.base.project.session, 'meta')
                if ~isfield(app.base.project.session.meta, 'sample') || isempty(app.base.project.session.meta.sample)
                    app.base.project.session.meta.sample = strings(size(app.base.project.session.spot.name));
                end

                if ~isfield(app.base.project.session.meta, 'material') || isempty(app.base.project.session.meta.material)
                    app.base.project.session.meta.material = strings(size(app.base.project.session.spot.name));
                end

                if ~isfield(app.base.project.session.meta, 'location') || isempty(app.base.project.session.meta.location)
                    app.base.project.session.meta.location = strings(size(app.base.project.session.spot.name));
                end
            end


            % Change "PRM" to "CAL" & "SRM" to "QCRM"-Backwards compatibility
            app.base.project.session.spot.type(app.base.project.session.spot.type == "PRM") = "CAL";
            app.base.project.session.spot.type(app.base.project.session.spot.type == "SRM") = "QCRM";

            if isfield(app.base.project.session.spot, 'prm_sensitivities')
                % Copy data to the new field
                [app.base.project.session.spot.cal_sensitivities] = app.base.project.session.spot.prm_sensitivities;
                % Remove the old field
                app.base.project.session.spot = rmfield(app.base.project.session.spot, 'prm_sensitivities');
            end

            update_results_module_GUI(app)
            update_CAL_tree(app)

            app.UIFigure.Tag = sprintf('%d_%d', app.project_id, app.session_id);

            watch_session_changes(app);
        end

        % Value changed function: CalibratorDropDown
        function CalibratorDropDownValueChanged(app, event)
            app.CalibratorDropDown.Value = event.Source.Value;
            app.selected_CAL = app.CalibratorDropDown.Value;

            app.CalibratorDropDown_2.Value = event.Source.Value;

            update_results_module_GUI(app)


        end

        % Value changed function: BracketidDropDown
        function BracketidDropDownValueChanged(app, event)

            app.BracketidDropDown.Value = event.Source.Value;
            app.selected_bracket_id = app.BracketidDropDown.Value;

            app.BracketidDropDown_2.Value = event.Source.Value;

            update_results_module_GUI(app)

        end

        % Callback function
        function EnddataprocessingButtonPushed(app, event)
            app.base.project.session.config.module_status.results = true;

            settings.ICP_Base_GUI_update_state = true;
            [app.project_id, app.session_id] = save_to_base(app.sourceapp, app.project_id, app.base.project.session, app.session_id, app.base.project_name, settings);
            delete(app)


        end

        % Value changed function: HostInclusionDropDown
        function HostInclusionDropDownValueChanged(app, event)
            
            app.HostInclusionDropDown.Value = event.Source.Value;
            app.selected_host_inclusion = app.HostInclusionDropDown.Value;

            update_show_dropdown_items(app)
            update_results_module_GUI(app)
        end

        % Button pushed function: ClassificationButton, DriftButton, 
        % ImportButton, IntervalButton, QuantificationButton
        function QuantificationButtonPushed(app, event)
            try

                quantified = false;
                for c = 1:numel(app.base.project.session.spot.matrix_composition)
                    tbl = app.base.project.session.spot.matrix_composition{c};
                    if isempty(tbl)
                        continue
                    end
                    vals = table2array(tbl);
                    if any(vals(:) ~= 0 & ~isnan(vals(:)))
                        quantified = true;
                        break
                    end
                end

                if quantified && all(app.base.project.session.spot.analyte_calibrator_assignment(:, 2) == "")
                    uialert(app.UIFigure, ...
                        'The analytes must be assigned to a calibrator before closing. This can be done in the "Configure Output Table" tab.', ...
                        'Assignment Required', 'Icon', 'warning');
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

        % Button pushed function: CreateOutputTableButton
        function CreateOutputTableButtonPushed(app, event)
            f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
            [filename, pathname] = uiputfile('*.csv', 'Save CSV file', defaultStartDir(app));
            delete(f);
            figure(app.UIFigure);

            outputpath = fullfile(pathname, filename);
            if isequal(filename, 0) || isequal(pathname, 0)
                return; % User canceled file selection
            end

            export_displayed_table(app, outputpath)


        end

        % Value changed function: ShowDropDown
        function ShowDropDownValueChanged(app, event)
            update_results_module_GUI(app)

        end

        % Button pushed function: GotoCorrectionModuleButton
        function GotoCorrectionModuleButtonPushed(app, event)

            app.base.project.session.config.module_status.results = true;

            Correction_Module(app.sourceapp, app.base.project_name, app.project_id, app.session_id)
            %delete(app)


        end

        % Callback function
        function RefreshMenuSelected(app, event)
            assign_sample_to_spot(app)
            assign_material_to_spot(app)
            assign_location_to_spot(app)
            
            update_metadata_table(app)
        end

        % Value changed function: QualityControlReferenceMaterialDropDown
        function QualityControlReferenceMaterialDropDownValueChanged(app, event)
            app.selected_QCRM = app.QualityControlReferenceMaterialDropDown.Value;

            update_qcrm_plot(app)
        end

        % Value changed function: CalibratorDropDown_2
        function CalibratorDropDown_2ValueChanged(app, event)

            app.CalibratorDropDown.Value = event.Source.Value;
            app.selected_CAL = app.CalibratorDropDown.Value;

            app.CalibratorDropDown_2.Value = event.Source.Value;

            update_qcrm_plot(app)
        end

        % Value changed function: BracketidDropDown_2
        function BracketidDropDown_2ValueChanged(app, event)
            app.BracketidDropDown.Value = event.Source.Value;
            app.selected_bracket_id = app.BracketidDropDown.Value;

            app.BracketidDropDown_2.Value = event.Source.Value;

            update_qcrm_plot(app)
        end

        % Value changed function: ShowCommentsCheckBox
        function ShowCommentsCheckBoxValueChanged(app, event)
            %value = app.ShowCommentsCheckBox.Value;
            update_results_table(app)
        end

        % Callback function
        function CalculateButtonPushed(app, event)

            update_MSF_plot(app)

        end

        % Value changed function: ComparetoDropDown
        function ComparetoDropDownValueChanged(app, event)
            update_MSF_plot(app)

        end

        % Value changed function: SensitivitybasedonDropDown
        function SensitivitybasedonDropDownValueChanged(app, event)
            update_MSF_plot(app)
        end

        % Value changed function: RatioListBox
        function RatioListBoxValueChanged(app, event)
            update_MSF_plot(app)
        end

        % Value changed function: DenominatorListBox
        function DenominatorListBoxValueChanged(app, event)
            update_MSF_plot(app)
        end

        % Value changed function: ShowLegendCheckBox
        function ShowLegendCheckBoxValueChanged(app, event)
            update_MSF_plot(app)
        end

        % Menu selected function: OutputallmatrixmassfractionsggMenu
        function OutputallmatrixmassfractionsggMenuSelected(app, event)

            f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
            [filename, pathname] = uiputfile('*.xlsx', 'Save Excel file', defaultStartDir(app));
            delete(f);
            figure(app.UIFigure);


            outputpath = fullfile(pathname, filename);
            if isequal(filename, 0) || isequal(pathname, 0)
                return; % User canceled file selection
            end

            export_all_matrix_mass_fractions(app,outputpath)


        end

        % Button pushed function: ExportTableButton
        function ExportTableButtonPushed(app, event)


            if isempty(app.MSF_ratios)
                message={'No Data to be exported'};
                uialert(app.UIFigure, message,' Warning','Icon','warning');
                return
            end


            f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
            [filename, pathname] = uiputfile('*.xlsx', 'Save Excel file');
            delete(f);
            figure(app.UIFigure);


            outputpath = fullfile(pathname, filename);
            if isequal(filename, 0) || isequal(pathname, 0)
                return; % User canceled file selection
            end

            writetable(app.MSF_ratios, outputpath, 'Sheet', 'MSF ratios', 'WriteRowNames', false);



        end

        % Value changed function: LogscaleCheckBox_2
        function LogscaleCheckBox_2ValueChanged(app, event)

            update_qcrm_plot(app)
        end

        % Menu selected function: OutputallinclusionmassfractionsggMenu
        function OutputallinclusionmassfractionsggMenuSelected(app, event)
            f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
            [filename, pathname] = uiputfile('*.xlsx', 'Save Excel file', defaultStartDir(app));
            delete(f);
            figure(app.UIFigure);

            outputpath = fullfile(pathname, filename);
            if isequal(filename, 0) || isequal(pathname, 0)
                return; % User canceled file selection
            end

            export_all_inclusion_mass_fractions(app, outputpath);
        end

        % Menu selected function: OutputallmatrixLODsggMenu
        function OutputallmatrixLODsggMenuSelected(app, event)
            f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
            [filename, pathname] = uiputfile('*.xlsx', 'Save Excel file', defaultStartDir(app));
            delete(f);
            figure(app.UIFigure);

            outputpath = fullfile(pathname, filename);
            if isequal(filename, 0) || isequal(pathname, 0)
                return; % User canceled file selection
            end

            export_all_matrix_lods(app,outputpath)
        end

        % Menu selected function: OutputallinclusionLODsggMenu
        function OutputallinclusionLODsggMenuSelected(app, event)
            f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
            [filename, pathname] = uiputfile('*.xlsx', 'Save Excel file', defaultStartDir(app));
            delete(f);
            figure(app.UIFigure);

            outputpath = fullfile(pathname, filename);
            if isequal(filename, 0) || isequal(pathname, 0)
                return; % User canceled file selection
            end

            export_all_inclusion_lods(app,outputpath)
        end

        % Button pushed function: AddnumericcolumnButton
        function AddnumericcolumnButtonPushed(app, event)
              
                
            % Get the new column name from the Edit Field
            requestedName = strtrim(app.CustomcolumnnameEditField.Value);

            % Check if the name is empty
            if requestedName == ""
                uialert(app.UIFigure, 'Column name cannot be empty.', 'Invalid Name');
                return;
            end

            if contains(requestedName, '/')
                uialert(app.UIFigure, 'Column name cannot contain "/".' , 'Invalid Name');
                return;
            end

            % Current table data
            T = app.MetadataTable.Data;
            if ~istable(T)
                uialert(app.UIFigure, 'MetadataTable.Data is not a table.', 'Type Error');
                return;
            end

            % Ensure meta struct exists
            if ~isfield(app.base.project.session, 'meta') || ~isstruct(app.base.project.session.meta)
                app.base.project.session.meta = struct();
            end

            % Make valid + unique field/column name (check both table and meta fields)
            validName = matlab.lang.makeValidName(requestedName);
            usedNames = [T.Properties.VariableNames, fieldnames(app.base.project.session.meta)'];
            validName = matlab.lang.makeUniqueStrings(validName, usedNames);

            % Row count
            nRows = height(T);

            % 1) Add field in app structure with empty cells for a neutral state
            app.base.project.session.meta.(validName) = NaN(nRows, 1);
            app.base.project.session.config.synced = false;

            % 2) Add column in UI table from structure field
            T.(validName) = app.base.project.session.meta.(validName);

            % Update table
            app.MetadataTable.Data = T;
            app.MetadataTable.ColumnName = T.Properties.VariableNames;

            % Make all columns editable except the first two
            numCols = width(T);
            if numCols > 2
                app.MetadataTable.ColumnEditable = [false, false, true(1, numCols - 2)];
            else
                app.MetadataTable.ColumnEditable = false(1, numCols);
            end

            % Clear the input field after adding the column
            app.CustomcolumnnameEditField.Value = '';

            update_metadata_table(app)
            
            
        end

        % Button pushed function: ApplyButton
        function ApplyButtonPushed(app, event)

            selected_string = app.SpotnamecontainsEditField.Value;

            if contains(selected_string, '&&')
                substrings = strtrim(strsplit(selected_string, '&&'));
                selected_spot_indices = find(all(contains(app.base.project.session.spot.name, substrings), 2));
            elseif contains(selected_string, '||')
                substrings = strtrim(strsplit(selected_string, '||'));
                selected_spot_indices = find(any(contains(app.base.project.session.spot.name, substrings), 2));
            else
                selected_spot_indices = find(contains(app.base.project.session.spot.name, selected_string));
            end

            if isempty(selected_spot_indices)
                return; % No spots matched, do nothing
            end

            targetColumn = app.StringCompareDropDown.Value;
            inputValue   = app.MetadataInputEditField.Value;

            currentColumnData = app.base.project.session.meta.(targetColumn);

            % the column type is set when the column is created (numeric or text button)
            if isnumeric(currentColumnData)
                processedValue = str2double(inputValue);
                % empty input = NaN, anything that is not a single number is rejected
                if isnan(processedValue) && strlength(strtrim(string(inputValue))) > 0
                    uialert(app.UIFigure, ['Column "' targetColumn '" requires a numeric value.'], 'Invalid Data Type');
                    return
                end
                app.base.project.session.meta.(targetColumn)(selected_spot_indices) = processedValue;
            elseif isstring(currentColumnData)
                app.base.project.session.meta.(targetColumn)(selected_spot_indices) = string(inputValue);
            else
                app.base.project.session.meta.(targetColumn)(selected_spot_indices) = {inputValue};
            end

            app.base.project.session.config.synced = false;

            update_metadata_table(app)

        end

        % Button pushed function: ResetButton
        function ResetButtonPushed(app, event)

 
            % Check if the meta struct exists and is a struct
            if isfield(app.base.project.session, 'meta') && isstruct(app.base.project.session.meta)

                metaStruct = app.base.project.session.meta;
                metaFields = fieldnames(metaStruct);

                % Get the number of spots, which corresponds to the required number of rows for a column
                nRows = numel(app.base.project.session.spot.name);

                % Iterate through each metadata field
                for i = 1:numel(metaFields)
                    fieldName = metaFields{i};
                    fieldValue = metaStruct.(fieldName);

                    % Reset the field only if it's a cell array with the same number of rows as spots
                    % This mirrors the logic in update_metadata_table
                    if iscell(fieldValue) && size(fieldValue, 1) == nRows
                        % Use dynamic field naming to reset the field
                        app.base.project.session.meta.(fieldName) = repmat({'Unknown'}, nRows, 1);
                        app.base.project.session.config.synced = false;
                    end
                end
            end

            % Refresh the table to reflect the reset values
            update_metadata_table(app);


        end

        % Cell edit callback: MetadataTable
        function MetadataTableCellEdit(app, event)
            indices = event.Indices;
            newData = event.NewData;

            col        = indices(2);
            columnName = app.MetadataTable.ColumnName{col};

            currentColumnData = app.base.project.session.meta.(columnName);

            % the column type is set when the column is created (numeric or text button)
            if isnumeric(currentColumnData)
                if isnumeric(newData)
                    processedData = newData;
                else
                    processedData = str2double(newData);
                    % empty cell = NaN, anything that is not a single number is rejected
                    if isnan(processedData) && strlength(strtrim(string(newData))) > 0
                        uialert(app.UIFigure, ['Column "' columnName '" requires a numeric value.'], 'Invalid Data Type');
                        app.MetadataTable.Data{indices(1), indices(2)} = {event.PreviousData};
                        return
                    end
                end
            else
                processedData = newData; % text column: everything is stored as text
            end

            row          = indices(1);
            selectedRows = unique(app.MetadataTable.Selection(:, 1));
            if isempty(selectedRows) || ~any(selectedRows == row)
                targetRows = row;
            else
                targetRows = selectedRows;
            end

            if isnumeric(currentColumnData)
                app.base.project.session.meta.(columnName)(targetRows) = processedData;
            elseif isstring(currentColumnData)
                app.base.project.session.meta.(columnName)(targetRows) = string(processedData);
            else
                app.base.project.session.meta.(columnName)(targetRows) = {processedData};
            end

            app.base.project.session.config.synced = false;
            update_metadata_table(app);
        end

        % Menu selected function: AdjustQCRMAxisFontsizeMenu
        function AdjustQCRMAxisFontsizeMenuSelected(app, event)
            fontsizevalue = inputdlg('Enter Fontsize:','Set Fontsize', 1,{'12'});
            figure(app.UIFigure);

            if ~isempty(fontsizevalue)
                fontsizevalue=unique(str2num(fontsizevalue{1})); %#ok<ST2NM>
            else
                return
            end

            if isnumeric(fontsizevalue) && not(isnan(fontsizevalue)) && not(isinf(fontsizevalue))

                app.QCRMAxes.FontSize = fontsizevalue;

            end


        end

        % Menu selected function: AdjustQCRMAxisMarkersizeMenu
        function AdjustQCRMAxisMarkersizeMenuSelected(app, event)
            markersizevalue = inputdlg('Enter Marker Size:', 'Set Marker Size', 1, {'6'});
            figure(app.UIFigure);

            if ~isempty(markersizevalue)
                markersizevalue = unique(str2num(markersizevalue{1})); %#ok<ST2NM>
            else
                return
            end

            if isnumeric(markersizevalue) && ~isnan(markersizevalue) && ~isinf(markersizevalue) && markersizevalue > 0
                % Find all line objects in the axes that have markers
                lines = findobj(app.QCRMAxes, 'Type', 'line', 'Marker', 'o');

                % Set the marker size for all found line objects
                for i = 1:length(lines)
                    lines(i).MarkerSize = markersizevalue;
                end
            end
        end

        % Button pushed function: AddtextcolumnButton
        function AddtextcolumnButtonPushed(app, event)
            
     
            % Get the new column name from the Edit Field
            requestedName = strtrim(app.CustomcolumnnameEditField.Value);

            % Check if the name is empty
            if requestedName == ""
                uialert(app.UIFigure, 'Column name cannot be empty.', 'Invalid Name');
                return;
            end

            if contains(requestedName, '/')
                uialert(app.UIFigure, 'Column name cannot contain "/".' , 'Invalid Name');
                return;
            end

            % Current table data
            T = app.MetadataTable.Data;
            if ~istable(T)
                uialert(app.UIFigure, 'MetadataTable.Data is not a table.', 'Type Error');
                return;
            end

            % Ensure meta struct exists
            if ~isfield(app.base.project.session, 'meta') || ~isstruct(app.base.project.session.meta)
                app.base.project.session.meta = struct();
            end

            % Make valid + unique field/column name (check both table and meta fields)
            validName = matlab.lang.makeValidName(requestedName);
            usedNames = [T.Properties.VariableNames, fieldnames(app.base.project.session.meta)'];
            validName = matlab.lang.makeUniqueStrings(validName, usedNames);

            % Row count
            nRows = height(T);

            % 1) Add field in app structure with empty cells for a neutral state
            app.base.project.session.meta.(validName) = strings(nRows, 1);
            app.base.project.session.config.synced = false;

            % 2) Add column in UI table from structure field
            T.(validName) = app.base.project.session.meta.(validName);

            % Update table
            app.MetadataTable.Data = T;
            app.MetadataTable.ColumnName = T.Properties.VariableNames;

            % Make all columns editable except the first two
            numCols = width(T);
            if numCols > 2
                app.MetadataTable.ColumnEditable = [false, false, true(1, numCols - 2)];
            else
                app.MetadataTable.ColumnEditable = false(1, numCols);
            end

            % Clear the input field after adding the column
            app.CustomcolumnnameEditField.Value = '';

            update_metadata_table(app)

            
        end

        % Callback function: CALTree
        function CALTreeCheckedNodesChanged(app, event)

% 1. Get ONLY the leaf nodes (analytes) from the Tree
            checkedNodes = app.CALTree.CheckedNodes;
            leafNodes = [];
            for i = 1:numel(checkedNodes)
                if isprop(checkedNodes(i).Parent, 'Text')
                    leafNodes = [leafNodes, checkedNodes(i)];
                end
            end
            
            % 2. Grab the known "truth" from the table BEFORE making changes
            tableData = app.AnalyteTable.Data;
            
            % 3. Group the currently checked nodes by their Analyte name
            newChecks = containers.Map(); 
            for i = 1:numel(leafNodes)
                aName = char(leafNodes(i).Text);
                if ~isKey(newChecks, aName)
                    newChecks(aName) = [];
                end
                newChecks(aName) = [newChecks(aName), leafNodes(i)];
            end
            
            % 4. Resolve conflicts and build final nodes list
            finalNodes = [];
            
            analyteKeys = keys(newChecks);
            for k = 1:numel(analyteKeys)
                aName = analyteKeys{k};
                nodesForAnalyte = newChecks(aName);
                
                if numel(nodesForAnalyte) == 1
                    % No conflict. 1-to-1 rule is respected.
                    finalNodes = [finalNodes, nodesForAnalyte(1)];
                else
                    % CONFLICT: The user checked multiple CALs for this same analyte!
                    % Find out which one was ALREADY assigned (the "old" one)
                    rowIdx = find(strcmp(tableData(:, 1), aName));
                    oldCal = '';
                    if ~isempty(rowIdx)
                        oldCal = char(tableData{rowIdx, 2});
                    end
                    
                    % Keep the node that is genuinely NEW (i.e. NOT the oldCal)
                    keptNode = [];
                    for n = 1:numel(nodesForAnalyte)
                        if ~strcmp(char(nodesForAnalyte(n).Parent.Text), oldCal)
                            keptNode = nodesForAnalyte(n);
                            break;
                        end
                    end
                    
                    % Fallback (safety)
                    if isempty(keptNode)
                        keptNode = nodesForAnalyte(1);
                    end
                    
                    finalNodes = [finalNodes, keptNode];
                end
            end
            
            % 5. Overwrite the UI! This instantly unchecks any conflicting duplicates.
            app.CALTree.CheckedNodes = finalNodes;
            
            % 6. Clean the table completely, and re-assign based on the final winners
            tableData(:, 2) = {''}; 
            for i = 1:numel(finalNodes)
                aName = char(finalNodes(i).Text);
                cName = char(finalNodes(i).Parent.Text);
                
                rowIdx = find(strcmp(tableData(:, 1), aName));
                if ~isempty(rowIdx)
                    tableData{rowIdx, 2} = cName;
                end
            end
            
            % 7. Instantly save the state so queued clicks don't break the logic!
            app.AnalyteTable.Data = tableData;
            app.base.project.session.spot.analyte_calibrator_assignment = tableData;

            app.base.project.session.config.synced = false;
            
            % 8. Update colors and build the large data table
            update_analyte_table(app);
       
        
        end

        % Callback function
        function DevButtonPushed(app, event)
            update_CAL_tree(app)
        end

        % Value changed function: HostInclusionDropDown_2
        function HostInclusionDropDown_2ValueChanged(app, event)

            %app.HostInclusionDropDown.Value = event.Source.Value;
            app.HostInclusionDropDown_2.Value = event.Source.Value;
            app.selected_host_inclusion = app.HostInclusionDropDown_2.Value;

            update_assigned_table(app)
        end

        % Button pushed function: CreateOutputTableButton_2
        function CreateOutputTableButton_2Pushed(app, event)
            f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
            [filename, pathname] = uiputfile('*.xlsx', 'Save table', defaultStartDir(app));
            delete(f);
            figure(app.UIFigure);

            if isequal(filename, 0) || isequal(pathname, 0)
                return;
            end

            outputpath = fullfile(pathname, filename);
            export_displayed_assigned_table(app, outputpath)

        end

        % Value changed function: RemovemassesfromanalytenameCheckBox
        function RemovemassesfromanalytenameCheckBoxValueChanged(app, event)

            if app.RemovemassesfromanalytenameCheckBox.Value == 0
                message = "Be aware that the quantified results are not isotope-resolved! For example, ‘Pb206’ indicates that Pb was measured on mass 206 a.m.u., not that a specific amount of the isotope ²⁰⁶Pb (in e.g., µg/g) is present in the sample.";
                uialert(app.UIFigure,message,"Warning", ...
                    "Icon","warning");
            end

            update_assigned_table(app);

        end

        % Value changed function: MajorsasOxideswtCheckBox
        function MajorsasOxideswtCheckBoxValueChanged(app, event)

            
            update_assigned_table(app)
        end

        % Value changed function: IncludeMetadataCheckBox
        function IncludeMetadataCheckBoxValueChanged(app, event)
            update_assigned_table(app)
        end

        % Button pushed function: SendtoVisModuleButton
        function SendtoVisModuleButtonPushed(app, event)
            


            if isempty(app.AssignedTable.Data)
                message = "Proceeding to the VisModule failed.";
                uialert(app.UIFigure,message,"Warning", ...
                    "Icon","warning");
                return
            end

            progress = uiprogressdlg(app.UIFigure, 'Title', 'ICP-Base', ...
                'Message', 'Sending table to VisModule', 'Cancelable', 'off', 'Indeterminate','on');
            closer = onCleanup(@() delete(progress(isvalid(progress))));

            VisModule(app.AssignedTable.Data, app.sourceapp);
            delete(progress)
        end

        % Callback function: EnddataprocessingButton_2, ExitMenu, UIFigure
        function UIFigureCloseRequest(app, event)
            
            source_app = app.sourceapp; 
            
            try

                quantified = false;
                for c = 1:numel(app.base.project.session.spot.matrix_composition)
                    tbl = app.base.project.session.spot.matrix_composition{c};
                    if isempty(tbl)
                        continue
                    end
                    vals = table2array(tbl);
                    if any(vals(:) ~= 0 & ~isnan(vals(:)))
                        quantified = true;
                        break
                    end
                end

                if quantified && all(app.base.project.session.spot.analyte_calibrator_assignment(:, 2) == "")
                    uialert(app.UIFigure, ...
                        'The analytes must be assigned to a calibrator before closing. This can be done in the "Configure Output Table" tab.', ...
                        'Assignment Required', 'Icon', 'warning');
                    return
                end

                session_config = app.base.project.session.config;
                if ~isfield(session_config, 'module_status') ...
                        || ~isfield(session_config.module_status, 'results') ...
                        || ~session_config.module_status.results
                    app.base.project.session.config.module_status.results = true;
                end

                settings.ICP_Base_GUI_update_state = true;
                [app.project_id, app.session_id] = save_to_base(app.sourceapp, app.project_id, app.base.project.session, app.session_id, app.base.project_name, settings);

                % Only ask about saving to H5 if something actually changed this session
                if ~app.base.project.session.config.synced
                    selection = uiconfirm(app.UIFigure, ...
                        'Do you want to save this session to the base (h5 file) now?', ...
                        'Save to Base', 'Options', {'Save now', 'Save later', 'Cancel'}, ...
                        'DefaultOption', 1, 'CancelOption', 3);

                    if strcmp(selection, 'Cancel')
                        return
                    end

                    if strcmp(selection, 'Save now')
                        progress_base = uiprogressdlg(app.sourceapp.UIFigure, 'Title', 'ICP-Base', ...
                            'Message', 'Saving session to the base (h5 file)...', ...
                            'Cancelable', 'off', 'Indeterminate', 'on');
                        progress_results = uiprogressdlg(app.UIFigure, 'Title', 'ICP-Base', ...
                            'Message', 'Saving session to the base (h5 file)...', ...
                            'Cancelable', 'off', 'Indeterminate', 'on');
                        try
                            app.sourceapp.save_session_to_h5(app.project_id, app.session_id);

                            sess = app.sourceapp.base(app.project_id).project(app.session_id).session;
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
                            app.sourceapp.base(app.project_id).project(app.session_id).session = skeleton;

                            app.sourceapp.update_session_table(app.project_id);

                            if isequal(app.sourceapp.LastSelectedProjectRow, app.project_id) && ...
                                    ~isempty(app.sourceapp.SessionTable.Selection) && ...
                                    app.sourceapp.SessionTable.Selection(1) == app.session_id
                                app.sourceapp.SaveselectedSessiontoBaseButton.Enable = false;
                                app.sourceapp.RestoreselectedSessionButton.Enable    = false;
                            end

                            delete(progress_base)
                            delete(progress_results)
                        catch ME
                            DisplayError(ME, 'Saving session to base failed');
                            uialert(app.UIFigure, 'Saving the session to the base failed. The session will close without saving to the h5 file — you can save it later from ICP-Base.', 'Save Failed', 'Icon', 'warning');
                            delete(progress_base)
                            delete(progress_results)
                        end
                    end
                end

                delete(app)

                % the window is gone now, so the base can enable the session buttons again
                try
                    refresh_session_buttons(source_app)
                catch ME
                    DisplayError(ME, 'Refreshing session buttons after closing a module');
                end

            catch ME
                DisplayError(ME, 'Closing Results Module failed');
                try
                    delete(app)
                catch
                end
                try
                    refresh_session_buttons(source_app)
                catch
                end
            end
        end

        % Button pushed function: UpdateTablePreviewButton
        function UpdateTablePreviewButtonPushed(app, event)
            
            update_assigned_table(app)

            uialert(app.UIFigure, ...
                'The table preview has been updated. You can view it in the "Output Table Preview" tab.', ...
                'Table Updated', 'Icon', 'success');

        end

        % Value changed function: ShowuncertaintiesCheckBox
        function ShowuncertaintiesCheckBoxValueChanged(app, event)
            update_qcrm_plot(app)
            
        end

        % Menu selected function: ShowuncertaintybudgetMenu
        function ShowuncertaintybudgetMenuSelected(app, event)

            if isequal(app.selected_host_inclusion, 'Inclusion')
                show_inclusion_uncertainty_budget(app)
            else
                show_uncertainty_budget(app)
            end

            
        end

        % Cell selection callback: ResultsTable
        function ResultsTableCellSelection(app, event)
            if ~isempty(event.Indices)
                app.selected_results_cell = event.Indices(1, :);   % [row col]
            end

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1027 723];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.Icon = 'icon_48.png';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create BaseMenu
            app.BaseMenu = uimenu(app.UIFigure);
            app.BaseMenu.Text = 'Base';

            % Create ExitMenu
            app.ExitMenu = uimenu(app.BaseMenu);
            app.ExitMenu.MenuSelectedFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);
            app.ExitMenu.Text = 'Exit';

            % Create SettingsMenu
            app.SettingsMenu = uimenu(app.UIFigure);
            app.SettingsMenu.Text = 'Settings';

            % Create AdjustQCRMAxisFontsizeMenu
            app.AdjustQCRMAxisFontsizeMenu = uimenu(app.SettingsMenu);
            app.AdjustQCRMAxisFontsizeMenu.MenuSelectedFcn = createCallbackFcn(app, @AdjustQCRMAxisFontsizeMenuSelected, true);
            app.AdjustQCRMAxisFontsizeMenu.Text = 'Adjust QCRM Axis Fontsize';

            % Create AdjustQCRMAxisMarkersizeMenu
            app.AdjustQCRMAxisMarkersizeMenu = uimenu(app.SettingsMenu);
            app.AdjustQCRMAxisMarkersizeMenu.MenuSelectedFcn = createCallbackFcn(app, @AdjustQCRMAxisMarkersizeMenuSelected, true);
            app.AdjustQCRMAxisMarkersizeMenu.Text = 'Adjust QCRM Axis Markersize';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {5, 764, '1x', 111, 5};
            app.GridLayout.RowHeight = {35, '1x', 48, 5};
            app.GridLayout.ColumnSpacing = 9.5;
            app.GridLayout.RowSpacing = 5.5;
            app.GridLayout.Padding = [9.5 5.5 9.5 5.5];

            % Create ProgressPanel
            app.ProgressPanel = uipanel(app.GridLayout);
            app.ProgressPanel.Layout.Row = 1;
            app.ProgressPanel.Layout.Column = [2 4];

            % Create IntervalButton
            app.IntervalButton = uibutton(app.ProgressPanel, 'push');
            app.IntervalButton.ButtonPushedFcn = createCallbackFcn(app, @QuantificationButtonPushed, true);
            app.IntervalButton.Position = [131 6 100 23];
            app.IntervalButton.Text = 'Interval';

            % Create ImportButton
            app.ImportButton = uibutton(app.ProgressPanel, 'push');
            app.ImportButton.ButtonPushedFcn = createCallbackFcn(app, @QuantificationButtonPushed, true);
            app.ImportButton.Position = [11 6 100 23];
            app.ImportButton.Text = 'Import';

            % Create ClassificationButton
            app.ClassificationButton = uibutton(app.ProgressPanel, 'push');
            app.ClassificationButton.ButtonPushedFcn = createCallbackFcn(app, @QuantificationButtonPushed, true);
            app.ClassificationButton.Position = [263 6 100 23];
            app.ClassificationButton.Text = 'Classification';

            % Create DriftButton
            app.DriftButton = uibutton(app.ProgressPanel, 'push');
            app.DriftButton.ButtonPushedFcn = createCallbackFcn(app, @QuantificationButtonPushed, true);
            app.DriftButton.Position = [389 6 100 23];
            app.DriftButton.Text = 'Drift';

            % Create QuantificationButton
            app.QuantificationButton = uibutton(app.ProgressPanel, 'push');
            app.QuantificationButton.ButtonPushedFcn = createCallbackFcn(app, @QuantificationButtonPushed, true);
            app.QuantificationButton.Position = [509 6 100 23];
            app.QuantificationButton.Text = 'Quantification';

            % Create ResultsButton
            app.ResultsButton = uibutton(app.ProgressPanel, 'push');
            app.ResultsButton.Position = [633 6 100 23];
            app.ResultsButton.Text = 'Results';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.GridLayout);
            app.TabGroup.Layout.Row = [2 3];
            app.TabGroup.Layout.Column = [2 4];

            % Create AllResultsTab
            app.AllResultsTab = uitab(app.TabGroup);
            app.AllResultsTab.Title = 'All Results';

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.AllResultsTab);
            app.GridLayout2.ColumnWidth = {40, 35, 69, '1.19x', '1x', '3.97x', 59, '3.06x', '1.65x', '3.71x', 62, 60};
            app.GridLayout2.RowHeight = {24, '2.33x', '31.73x', 29};
            app.GridLayout2.ColumnSpacing = 8.38461538461539;
            app.GridLayout2.Padding = [8.38461538461539 10 8.38461538461539 10];

            % Create ResultsTable
            app.ResultsTable = uitable(app.GridLayout2);
            app.ResultsTable.ColumnName = '';
            app.ResultsTable.RowName = {};
            app.ResultsTable.CellSelectionCallback = createCallbackFcn(app, @ResultsTableCellSelection, true);
            app.ResultsTable.Layout.Row = [2 3];
            app.ResultsTable.Layout.Column = [1 12];

            % Create HostInclusionDropDown
            app.HostInclusionDropDown = uidropdown(app.GridLayout2);
            app.HostInclusionDropDown.Items = {};
            app.HostInclusionDropDown.ValueChangedFcn = createCallbackFcn(app, @HostInclusionDropDownValueChanged, true);
            app.HostInclusionDropDown.Layout.Row = 1;
            app.HostInclusionDropDown.Layout.Column = [10 11];
            app.HostInclusionDropDown.Value = {};

            % Create CreateOutputTableButton
            app.CreateOutputTableButton = uibutton(app.GridLayout2, 'push');
            app.CreateOutputTableButton.ButtonPushedFcn = createCallbackFcn(app, @CreateOutputTableButtonPushed, true);
            app.CreateOutputTableButton.Layout.Row = 4;
            app.CreateOutputTableButton.Layout.Column = [8 9];
            app.CreateOutputTableButton.Text = 'Create Output Table';

            % Create CalibratorDropDownLabel
            app.CalibratorDropDownLabel = uilabel(app.GridLayout2);
            app.CalibratorDropDownLabel.HorizontalAlignment = 'right';
            app.CalibratorDropDownLabel.Layout.Row = 1;
            app.CalibratorDropDownLabel.Layout.Column = [2 4];
            app.CalibratorDropDownLabel.Text = 'Calibrator';

            % Create CalibratorDropDown
            app.CalibratorDropDown = uidropdown(app.GridLayout2);
            app.CalibratorDropDown.Items = {};
            app.CalibratorDropDown.ValueChangedFcn = createCallbackFcn(app, @CalibratorDropDownValueChanged, true);
            app.CalibratorDropDown.Layout.Row = 1;
            app.CalibratorDropDown.Layout.Column = [5 6];
            app.CalibratorDropDown.Value = {};

            % Create BracketidDropDownLabel
            app.BracketidDropDownLabel = uilabel(app.GridLayout2);
            app.BracketidDropDownLabel.HorizontalAlignment = 'right';
            app.BracketidDropDownLabel.Layout.Row = 1;
            app.BracketidDropDownLabel.Layout.Column = 7;
            app.BracketidDropDownLabel.Text = 'Bracket id';

            % Create BracketidDropDown
            app.BracketidDropDown = uidropdown(app.GridLayout2);
            app.BracketidDropDown.Items = {};
            app.BracketidDropDown.ValueChangedFcn = createCallbackFcn(app, @BracketidDropDownValueChanged, true);
            app.BracketidDropDown.Layout.Row = 1;
            app.BracketidDropDown.Layout.Column = 8;
            app.BracketidDropDown.Value = {};

            % Create ShowDropDownLabel
            app.ShowDropDownLabel = uilabel(app.GridLayout2);
            app.ShowDropDownLabel.HorizontalAlignment = 'right';
            app.ShowDropDownLabel.Layout.Row = 4;
            app.ShowDropDownLabel.Layout.Column = 1;
            app.ShowDropDownLabel.Text = 'Show';

            % Create ShowDropDown
            app.ShowDropDown = uidropdown(app.GridLayout2);
            app.ShowDropDown.Items = {'Mass Fractions [µg/g]', 'Mass Fractions [µg/g] unfiltered', 'Sensitivities', 'CAL Sensitivities', 'CPS', 'Background CPS', 'Limits of detection', 'Majors as Oxides', 'Fe2+ and Fe3+', 'Mixing ratios', 'Mix mass fractions [µg/g]', 'Matrix uncertainties [µg/g]', 'Inclusion uncertainties [µg/g]'};
            app.ShowDropDown.ValueChangedFcn = createCallbackFcn(app, @ShowDropDownValueChanged, true);
            app.ShowDropDown.Layout.Row = 4;
            app.ShowDropDown.Layout.Column = [2 4];
            app.ShowDropDown.Value = 'Mass Fractions [µg/g]';

            % Create ShowCommentsCheckBox
            app.ShowCommentsCheckBox = uicheckbox(app.GridLayout2);
            app.ShowCommentsCheckBox.ValueChangedFcn = createCallbackFcn(app, @ShowCommentsCheckBoxValueChanged, true);
            app.ShowCommentsCheckBox.Text = 'Show Comments';
            app.ShowCommentsCheckBox.Layout.Row = 4;
            app.ShowCommentsCheckBox.Layout.Column = 6;

            % Create OutputTableTab
            app.OutputTableTab = uitab(app.TabGroup);
            app.OutputTableTab.Title = 'Configure Output Table';

            % Create TabGroup3
            app.TabGroup3 = uitabgroup(app.OutputTableTab);
            app.TabGroup3.Position = [2 2 977 635];

            % Create AnalyteCalibratorAssignmentTab
            app.AnalyteCalibratorAssignmentTab = uitab(app.TabGroup3);
            app.AnalyteCalibratorAssignmentTab.Title = 'Analyte-Calibrator Assignment';

            % Create AnalyteTable
            app.AnalyteTable = uitable(app.AnalyteCalibratorAssignmentTab);
            app.AnalyteTable.ColumnName = {'Analyte'; 'Calibrator'};
            app.AnalyteTable.ColumnWidth = {'fit'};
            app.AnalyteTable.RowName = {};
            app.AnalyteTable.ColumnSortable = [false false];
            app.AnalyteTable.ColumnEditable = [false false];
            app.AnalyteTable.Position = [327 16 235 573];

            % Create CALTree
            app.CALTree = uitree(app.AnalyteCalibratorAssignmentTab, 'checkbox');
            app.CALTree.Position = [60 17 238 572];

            % Assign Checked Nodes
            app.CALTree.CheckedNodesChangedFcn = createCallbackFcn(app, @CALTreeCheckedNodesChanged, true);

            % Create Label
            app.Label = uilabel(app.AnalyteCalibratorAssignmentTab);
            app.Label.WordWrap = 'on';
            app.Label.Position = [597 221 361 252];
            app.Label.Text = {'Be aware that the quantified results are not isotope-resolved! For example, ‘Pb206’ indicates that Pb was measured on mass 206 a.m.u., not that a specific amount of the isotope ²⁰⁶Pb (in e.g., µg/g) is present in the sample.'; ''; 'You can remove the masses from the element name in the "Output Table Preview" Tab. If multiple masses were measured, this feature will use the preferred isotopes defined in the Oxides.csv file found in Documents/ICP-Base. '; ''; 'To change the preferred isotopes, edit (but don''t rename) this .csv file and rerun the quantification. You can check which preferred isotopes are used in the Settings Menu in the Quantifcation Module.'; ''; 'This .csv file also defines which elements are treated as majors although this is purely cosmetic and does not influence the quantification.'};

            % Create Label_2
            app.Label_2 = uilabel(app.AnalyteCalibratorAssignmentTab);
            app.Label_2.WordWrap = 'on';
            app.Label_2.FontSize = 15;
            app.Label_2.FontWeight = 'bold';
            app.Label_2.Position = [598 550 347 34];
            app.Label_2.Text = 'Use the tree to choose the desired calibrator for each analyte.';

            % Create Label_3
            app.Label_3 = uilabel(app.AnalyteCalibratorAssignmentTab);
            app.Label_3.WordWrap = 'on';
            app.Label_3.Position = [597 492 347 28];
            app.Label_3.Text = 'The output table can be previewed and exported in the "Output Table Preview" Tab.';

            % Create UpdateTablePreviewButton
            app.UpdateTablePreviewButton = uibutton(app.AnalyteCalibratorAssignmentTab, 'push');
            app.UpdateTablePreviewButton.ButtonPushedFcn = createCallbackFcn(app, @UpdateTablePreviewButtonPushed, true);
            app.UpdateTablePreviewButton.Position = [597 108 361 56];
            app.UpdateTablePreviewButton.Text = 'Update Table Preview';

            % Create OutputTablePreview
            app.OutputTablePreview = uitab(app.TabGroup3);
            app.OutputTablePreview.Title = 'Output Table Preview';

            % Create AssignedTable
            app.AssignedTable = uitable(app.OutputTablePreview);
            app.AssignedTable.ColumnName = '';
            app.AssignedTable.RowName = {};
            app.AssignedTable.Position = [9 37 960 534];

            % Create HostInclusionDropDown_2
            app.HostInclusionDropDown_2 = uidropdown(app.OutputTablePreview);
            app.HostInclusionDropDown_2.Items = {};
            app.HostInclusionDropDown_2.ValueChangedFcn = createCallbackFcn(app, @HostInclusionDropDown_2ValueChanged, true);
            app.HostInclusionDropDown_2.Position = [799 578 164 24];
            app.HostInclusionDropDown_2.Value = {};

            % Create EnddataprocessingButton_2
            app.EnddataprocessingButton_2 = uibutton(app.OutputTablePreview, 'push');
            app.EnddataprocessingButton_2.ButtonPushedFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);
            app.EnddataprocessingButton_2.WordWrap = 'on';
            app.EnddataprocessingButton_2.Position = [837 4 130 29];
            app.EnddataprocessingButton_2.Text = 'End data processing';

            % Create CreateOutputTableButton_2
            app.CreateOutputTableButton_2 = uibutton(app.OutputTablePreview, 'push');
            app.CreateOutputTableButton_2.ButtonPushedFcn = createCallbackFcn(app, @CreateOutputTableButton_2Pushed, true);
            app.CreateOutputTableButton_2.Position = [204 3 184 29];
            app.CreateOutputTableButton_2.Text = 'Create Output Table';

            % Create RemovemassesfromanalytenameCheckBox
            app.RemovemassesfromanalytenameCheckBox = uicheckbox(app.OutputTablePreview);
            app.RemovemassesfromanalytenameCheckBox.ValueChangedFcn = createCallbackFcn(app, @RemovemassesfromanalytenameCheckBoxValueChanged, true);
            app.RemovemassesfromanalytenameCheckBox.Text = 'Remove masses from analyte name';
            app.RemovemassesfromanalytenameCheckBox.Position = [20 578 215 24];
            app.RemovemassesfromanalytenameCheckBox.Value = true;

            % Create MajorsasOxideswtCheckBox
            app.MajorsasOxideswtCheckBox = uicheckbox(app.OutputTablePreview);
            app.MajorsasOxideswtCheckBox.ValueChangedFcn = createCallbackFcn(app, @MajorsasOxideswtCheckBoxValueChanged, true);
            app.MajorsasOxideswtCheckBox.Text = 'Majors as Oxides (wt%)';
            app.MajorsasOxideswtCheckBox.Position = [258 578 149 24];

            % Create IncludeMetadataCheckBox
            app.IncludeMetadataCheckBox = uicheckbox(app.OutputTablePreview);
            app.IncludeMetadataCheckBox.ValueChangedFcn = createCallbackFcn(app, @IncludeMetadataCheckBoxValueChanged, true);
            app.IncludeMetadataCheckBox.Text = 'Include Metadata';
            app.IncludeMetadataCheckBox.Position = [427 578 122 24];

            % Create SendtoVisModuleButton
            app.SendtoVisModuleButton = uibutton(app.OutputTablePreview, 'push');
            app.SendtoVisModuleButton.ButtonPushedFcn = createCallbackFcn(app, @SendtoVisModuleButtonPushed, true);
            app.SendtoVisModuleButton.Position = [10 3 184 29];
            app.SendtoVisModuleButton.Text = 'Send to VisModule';

            % Create AllvaluesinggunlessexpressedasoxidesmassLabel
            app.AllvaluesinggunlessexpressedasoxidesmassLabel = uilabel(app.OutputTablePreview);
            app.AllvaluesinggunlessexpressedasoxidesmassLabel.HorizontalAlignment = 'center';
            app.AllvaluesinggunlessexpressedasoxidesmassLabel.FontSize = 15;
            app.AllvaluesinggunlessexpressedasoxidesmassLabel.FontWeight = 'bold';
            app.AllvaluesinggunlessexpressedasoxidesmassLabel.FontColor = [0.8588 0.1216 0.2549];
            app.AllvaluesinggunlessexpressedasoxidesmassLabel.Position = [407 7 404 23];
            app.AllvaluesinggunlessexpressedasoxidesmassLabel.Text = 'All values in µg/g unless expressed as oxides (mass%)';

            % Create QualityControlOptionalTab
            app.QualityControlOptionalTab = uitab(app.TabGroup);
            app.QualityControlOptionalTab.Title = 'Quality Control (Optional)';

            % Create TabGroup2
            app.TabGroup2 = uitabgroup(app.QualityControlOptionalTab);
            app.TabGroup2.Position = [0 1 978 636];

            % Create QCReferenceMaterialsTab
            app.QCReferenceMaterialsTab = uitab(app.TabGroup2);
            app.QCReferenceMaterialsTab.Title = 'QC Reference Materials';

            % Create QCRMAxes
            app.QCRMAxes = uiaxes(app.QCReferenceMaterialsTab);
            xlabel(app.QCRMAxes, 'Analyte')
            ylabel(app.QCRMAxes, 'Measured Values/Accepted Values')
            zlabel(app.QCRMAxes, 'Z')
            app.QCRMAxes.XLim = [0 1];
            app.QCRMAxes.Colormap = [];
            app.QCRMAxes.Box = 'on';
            app.QCRMAxes.Position = [5 38 941 514];

            % Create GotoCorrectionModuleButton
            app.GotoCorrectionModuleButton = uibutton(app.QCReferenceMaterialsTab, 'push');
            app.GotoCorrectionModuleButton.ButtonPushedFcn = createCallbackFcn(app, @GotoCorrectionModuleButtonPushed, true);
            app.GotoCorrectionModuleButton.Enable = 'off';
            app.GotoCorrectionModuleButton.Position = [801 4 172 29];
            app.GotoCorrectionModuleButton.Text = 'Go to Correction Module';

            % Create CalibratorDropDown_2Label
            app.CalibratorDropDown_2Label = uilabel(app.QCReferenceMaterialsTab);
            app.CalibratorDropDown_2Label.HorizontalAlignment = 'right';
            app.CalibratorDropDown_2Label.Position = [57 584 157 24];
            app.CalibratorDropDown_2Label.Text = 'Calibrator';

            % Create CalibratorDropDown_2
            app.CalibratorDropDown_2 = uidropdown(app.QCReferenceMaterialsTab);
            app.CalibratorDropDown_2.Items = {};
            app.CalibratorDropDown_2.ValueChangedFcn = createCallbackFcn(app, @CalibratorDropDown_2ValueChanged, true);
            app.CalibratorDropDown_2.Position = [222 583 178 24];
            app.CalibratorDropDown_2.Value = {};

            % Create BracketidDropDown_2Label
            app.BracketidDropDown_2Label = uilabel(app.QCReferenceMaterialsTab);
            app.BracketidDropDown_2Label.HorizontalAlignment = 'right';
            app.BracketidDropDown_2Label.Position = [431 582 59 24];
            app.BracketidDropDown_2Label.Text = 'Bracket id';

            % Create BracketidDropDown_2
            app.BracketidDropDown_2 = uidropdown(app.QCReferenceMaterialsTab);
            app.BracketidDropDown_2.Items = {};
            app.BracketidDropDown_2.ValueChangedFcn = createCallbackFcn(app, @BracketidDropDown_2ValueChanged, true);
            app.BracketidDropDown_2.Position = [498 582 102 24];
            app.BracketidDropDown_2.Value = {};

            % Create QualityControlReferenceMaterialDropDownLabel
            app.QualityControlReferenceMaterialDropDownLabel = uilabel(app.QCReferenceMaterialsTab);
            app.QualityControlReferenceMaterialDropDownLabel.HorizontalAlignment = 'right';
            app.QualityControlReferenceMaterialDropDownLabel.Position = [22 552 191 22];
            app.QualityControlReferenceMaterialDropDownLabel.Text = 'Quality Control Reference Material';

            % Create QualityControlReferenceMaterialDropDown
            app.QualityControlReferenceMaterialDropDown = uidropdown(app.QCReferenceMaterialsTab);
            app.QualityControlReferenceMaterialDropDown.Items = {};
            app.QualityControlReferenceMaterialDropDown.ValueChangedFcn = createCallbackFcn(app, @QualityControlReferenceMaterialDropDownValueChanged, true);
            app.QualityControlReferenceMaterialDropDown.Position = [222 549 178 28];
            app.QualityControlReferenceMaterialDropDown.Value = {};

            % Create LogscaleCheckBox_2
            app.LogscaleCheckBox_2 = uicheckbox(app.QCReferenceMaterialsTab);
            app.LogscaleCheckBox_2.ValueChangedFcn = createCallbackFcn(app, @LogscaleCheckBox_2ValueChanged, true);
            app.LogscaleCheckBox_2.Text = 'Log-scale';
            app.LogscaleCheckBox_2.Position = [865 571 82 26];

            % Create ShowuncertaintiesCheckBox
            app.ShowuncertaintiesCheckBox = uicheckbox(app.QCReferenceMaterialsTab);
            app.ShowuncertaintiesCheckBox.ValueChangedFcn = createCallbackFcn(app, @ShowuncertaintiesCheckBoxValueChanged, true);
            app.ShowuncertaintiesCheckBox.Text = 'Show uncertainties';
            app.ShowuncertaintiesCheckBox.Position = [731 571 123 26];

            % Create MatrixSensitivityFactorMSFTab
            app.MatrixSensitivityFactorMSFTab = uitab(app.TabGroup2);
            app.MatrixSensitivityFactorMSFTab.Title = 'Matrix Sensitivity Factor (MSF)';

            % Create MSFAxes
            app.MSFAxes = uiaxes(app.MatrixSensitivityFactorMSFTab);
            xlabel(app.MSFAxes, 'X')
            ylabel(app.MSFAxes, 'Y')
            zlabel(app.MSFAxes, 'Z')
            app.MSFAxes.Box = 'on';
            app.MSFAxes.Position = [21 24 844 528];

            % Create SensitivitybasedonDropDownLabel
            app.SensitivitybasedonDropDownLabel = uilabel(app.MatrixSensitivityFactorMSFTab);
            app.SensitivitybasedonDropDownLabel.HorizontalAlignment = 'right';
            app.SensitivitybasedonDropDownLabel.Position = [293 573 116 22];
            app.SensitivitybasedonDropDownLabel.Text = 'Sensitivity based on:';

            % Create SensitivitybasedonDropDown
            app.SensitivitybasedonDropDown = uidropdown(app.MatrixSensitivityFactorMSFTab);
            app.SensitivitybasedonDropDown.Items = {'Mean', 'Min', 'Max'};
            app.SensitivitybasedonDropDown.ValueChangedFcn = createCallbackFcn(app, @SensitivitybasedonDropDownValueChanged, true);
            app.SensitivitybasedonDropDown.Position = [415 569 74 30];
            app.SensitivitybasedonDropDown.Value = 'Mean';

            % Create RatioListBox
            app.RatioListBox = uilistbox(app.MatrixSensitivityFactorMSFTab);
            app.RatioListBox.Items = {};
            app.RatioListBox.Multiselect = 'on';
            app.RatioListBox.ValueChangedFcn = createCallbackFcn(app, @RatioListBoxValueChanged, true);
            app.RatioListBox.Position = [884 24 82 411];
            app.RatioListBox.Value = {};

            % Create ComparetoDropDownLabel
            app.ComparetoDropDownLabel = uilabel(app.MatrixSensitivityFactorMSFTab);
            app.ComparetoDropDownLabel.HorizontalAlignment = 'right';
            app.ComparetoDropDownLabel.Position = [13 573 72 22];
            app.ComparetoDropDownLabel.Text = 'Compare to:';

            % Create ComparetoDropDown
            app.ComparetoDropDown = uidropdown(app.MatrixSensitivityFactorMSFTab);
            app.ComparetoDropDown.Items = {'', ''};
            app.ComparetoDropDown.ValueChangedFcn = createCallbackFcn(app, @ComparetoDropDownValueChanged, true);
            app.ComparetoDropDown.Position = [91 569 177 30];
            app.ComparetoDropDown.Value = '';

            % Create DenominatorListBox
            app.DenominatorListBox = uilistbox(app.MatrixSensitivityFactorMSFTab);
            app.DenominatorListBox.Items = {};
            app.DenominatorListBox.Multiselect = 'on';
            app.DenominatorListBox.ValueChangedFcn = createCallbackFcn(app, @DenominatorListBoxValueChanged, true);
            app.DenominatorListBox.Position = [884 444 81 155];
            app.DenominatorListBox.Value = {};

            % Create ShowLegendCheckBox
            app.ShowLegendCheckBox = uicheckbox(app.MatrixSensitivityFactorMSFTab);
            app.ShowLegendCheckBox.ValueChangedFcn = createCallbackFcn(app, @ShowLegendCheckBoxValueChanged, true);
            app.ShowLegendCheckBox.Text = 'Show Legend';
            app.ShowLegendCheckBox.Position = [764 573 100 22];
            app.ShowLegendCheckBox.Value = true;

            % Create ExportTableButton
            app.ExportTableButton = uibutton(app.MatrixSensitivityFactorMSFTab, 'push');
            app.ExportTableButton.ButtonPushedFcn = createCallbackFcn(app, @ExportTableButtonPushed, true);
            app.ExportTableButton.Position = [532 569 102 31];
            app.ExportTableButton.Text = 'Export Table';

            % Create AddMetadataOptionalTab
            app.AddMetadataOptionalTab = uitab(app.TabGroup);
            app.AddMetadataOptionalTab.Title = 'Add Metadata (Optional)';

            % Create MetadataTable
            app.MetadataTable = uitable(app.AddMetadataOptionalTab);
            app.MetadataTable.ColumnName = '';
            app.MetadataTable.RowName = {};
            app.MetadataTable.ColumnEditable = [false false true true true];
            app.MetadataTable.CellEditCallback = createCallbackFcn(app, @MetadataTableCellEdit, true);
            app.MetadataTable.Position = [16 21 949 517];

            % Create AddnumericcolumnButton
            app.AddnumericcolumnButton = uibutton(app.AddMetadataOptionalTab, 'push');
            app.AddnumericcolumnButton.ButtonPushedFcn = createCallbackFcn(app, @AddnumericcolumnButtonPushed, true);
            app.AddnumericcolumnButton.Position = [21 554 149 25];
            app.AddnumericcolumnButton.Text = 'Add numeric column';

            % Create Panel
            app.Panel = uipanel(app.AddMetadataOptionalTab);
            app.Panel.BorderType = 'none';
            app.Panel.Position = [600 558 360 53];

            % Create GridLayout_2
            app.GridLayout_2 = uigridlayout(app.Panel);
            app.GridLayout_2.ColumnWidth = {114, '1x', 78};
            app.GridLayout_2.RowHeight = {23, 22};
            app.GridLayout_2.RowSpacing = 2;
            app.GridLayout_2.Padding = [10 2 10 2];

            % Create ApplyButton
            app.ApplyButton = uibutton(app.GridLayout_2, 'push');
            app.ApplyButton.ButtonPushedFcn = createCallbackFcn(app, @ApplyButtonPushed, true);
            app.ApplyButton.Layout.Row = 2;
            app.ApplyButton.Layout.Column = 3;
            app.ApplyButton.Text = 'Apply';

            % Create StringCompareDropDown
            app.StringCompareDropDown = uidropdown(app.GridLayout_2);
            app.StringCompareDropDown.Items = {};
            app.StringCompareDropDown.Layout.Row = 2;
            app.StringCompareDropDown.Layout.Column = 1;
            app.StringCompareDropDown.Value = {};

            % Create SpotnamecontainsEditFieldLabel
            app.SpotnamecontainsEditFieldLabel = uilabel(app.GridLayout_2);
            app.SpotnamecontainsEditFieldLabel.HorizontalAlignment = 'right';
            app.SpotnamecontainsEditFieldLabel.Layout.Row = 1;
            app.SpotnamecontainsEditFieldLabel.Layout.Column = 1;
            app.SpotnamecontainsEditFieldLabel.Text = 'Spotname contains:';

            % Create SpotnamecontainsEditField
            app.SpotnamecontainsEditField = uieditfield(app.GridLayout_2, 'text');
            app.SpotnamecontainsEditField.Layout.Row = 1;
            app.SpotnamecontainsEditField.Layout.Column = 2;

            % Create MetadataInputEditField
            app.MetadataInputEditField = uieditfield(app.GridLayout_2, 'text');
            app.MetadataInputEditField.Layout.Row = 2;
            app.MetadataInputEditField.Layout.Column = 2;

            % Create ResetButton
            app.ResetButton = uibutton(app.AddMetadataOptionalTab, 'push');
            app.ResetButton.ButtonPushedFcn = createCallbackFcn(app, @ResetButtonPushed, true);
            app.ResetButton.Position = [416 556 104 31];
            app.ResetButton.Text = 'Reset';

            % Create CustomcolumnnameEditFieldLabel
            app.CustomcolumnnameEditFieldLabel = uilabel(app.AddMetadataOptionalTab);
            app.CustomcolumnnameEditFieldLabel.HorizontalAlignment = 'right';
            app.CustomcolumnnameEditFieldLabel.Position = [26 590 126 23];
            app.CustomcolumnnameEditFieldLabel.Text = 'Custom column name:';

            % Create CustomcolumnnameEditField
            app.CustomcolumnnameEditField = uieditfield(app.AddMetadataOptionalTab, 'text');
            app.CustomcolumnnameEditField.Position = [162 590 128 23];

            % Create AddtextcolumnButton
            app.AddtextcolumnButton = uibutton(app.AddMetadataOptionalTab, 'push');
            app.AddtextcolumnButton.ButtonPushedFcn = createCallbackFcn(app, @AddtextcolumnButtonPushed, true);
            app.AddtextcolumnButton.Position = [176 554 149 25];
            app.AddtextcolumnButton.Text = 'Add text column';

            % Create ContextMenu2
            app.ContextMenu2 = uicontextmenu(app.UIFigure);

            % Create OutputallmatrixmassfractionsggMenu
            app.OutputallmatrixmassfractionsggMenu = uimenu(app.ContextMenu2);
            app.OutputallmatrixmassfractionsggMenu.MenuSelectedFcn = createCallbackFcn(app, @OutputallmatrixmassfractionsggMenuSelected, true);
            app.OutputallmatrixmassfractionsggMenu.Text = 'Output all matrix mass fractions [µg/g]';

            % Create OutputallinclusionmassfractionsggMenu
            app.OutputallinclusionmassfractionsggMenu = uimenu(app.ContextMenu2);
            app.OutputallinclusionmassfractionsggMenu.MenuSelectedFcn = createCallbackFcn(app, @OutputallinclusionmassfractionsggMenuSelected, true);
            app.OutputallinclusionmassfractionsggMenu.Text = 'Output all inclusion mass fractions [µg/g]';

            % Create OutputallmatrixLODsggMenu
            app.OutputallmatrixLODsggMenu = uimenu(app.ContextMenu2);
            app.OutputallmatrixLODsggMenu.MenuSelectedFcn = createCallbackFcn(app, @OutputallmatrixLODsggMenuSelected, true);
            app.OutputallmatrixLODsggMenu.Text = 'Output all matrix LODs [µg/g]';

            % Create OutputallinclusionLODsggMenu
            app.OutputallinclusionLODsggMenu = uimenu(app.ContextMenu2);
            app.OutputallinclusionLODsggMenu.MenuSelectedFcn = createCallbackFcn(app, @OutputallinclusionLODsggMenuSelected, true);
            app.OutputallinclusionLODsggMenu.Text = 'Output all inclusion LODs [µg/g]';
            
            % Assign app.ContextMenu2
            app.CreateOutputTableButton.ContextMenu = app.ContextMenu2;
            app.CreateOutputTableButton_2.ContextMenu = app.ContextMenu2;
            app.SendtoVisModuleButton.ContextMenu = app.ContextMenu2;

            % Create ContextMenu3
            app.ContextMenu3 = uicontextmenu(app.UIFigure);

            % Create ShowuncertaintybudgetMenu
            app.ShowuncertaintybudgetMenu = uimenu(app.ContextMenu3);
            app.ShowuncertaintybudgetMenu.MenuSelectedFcn = createCallbackFcn(app, @ShowuncertaintybudgetMenuSelected, true);
            app.ShowuncertaintybudgetMenu.Text = 'Show uncertainty budget';
            
            % Assign app.ContextMenu3
            app.ResultsTable.ContextMenu = app.ContextMenu3;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Results_Module_readable(varargin)

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