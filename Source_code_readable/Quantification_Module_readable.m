% GENERATED from Quantification_Module.mlapp on 2026-10-27 16:55 by export_mlapp_to_m. This file is for reading purposes, any real changes need to be applied to the .mlapp files and exported again.
classdef Quantification_Module_readable < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        BaseMenu                       matlab.ui.container.Menu
        ExitMenu                       matlab.ui.container.Menu
        SettingsMenu                   matlab.ui.container.Menu
        ChangeTotalOxidesFolderMenu    matlab.ui.container.Menu
        ShowOxidesthatwillbeusedMenu   matlab.ui.container.Menu
        PropagateuncertaintiesMenu     matlab.ui.container.Menu
        EnableinternalstandarduncertaintyMenu  matlab.ui.container.Menu
        GridLayout2                    matlab.ui.container.GridLayout
        ProgressPanel                  matlab.ui.container.Panel
        GridLayout3                    matlab.ui.container.GridLayout
        ResultsButton                  matlab.ui.control.Button
        QuantificationButton           matlab.ui.control.Button
        DriftButton                    matlab.ui.control.Button
        ClassificationButton           matlab.ui.control.Button
        ImportButton                   matlab.ui.control.Button
        IntervalButton                 matlab.ui.control.Button
        TabGroup                       matlab.ui.container.TabGroup
        InternalStandardizationTab     matlab.ui.container.Tab
        ImportTableButton              matlab.ui.control.Button
        ExportTableButton_2            matlab.ui.control.Button
        ProceedtoResultsModuleButton   matlab.ui.control.Button
        CalibratorDropDown             matlab.ui.control.DropDown
        CalibratorDropDownLabel        matlab.ui.control.Label
        BracketidDropDown              matlab.ui.control.DropDown
        BracketidDropDownLabel         matlab.ui.control.Label
        HostInclusionDropDown          matlab.ui.control.DropDown
        InclusionTable                 matlab.ui.control.Table
        MatrixTable                    matlab.ui.control.Table
        fromCALListBox                 matlab.ui.control.ListBox
        AnalyteListBox                 matlab.ui.control.ListBox
        Panel                          matlab.ui.container.Panel
        GridLayout                     matlab.ui.container.GridLayout
        SpotnamecontainsEditField      matlab.ui.control.EditField
        ContainsLabel                  matlab.ui.control.Label
        ChooseButton                   matlab.ui.control.Button
        StringCompareDropDown          matlab.ui.control.DropDown
        StringCompareInputEditField    matlab.ui.control.NumericEditField
        ApplyButton                    matlab.ui.control.Button
        ResetButton                    matlab.ui.control.Button
        ApplytoallCalibratorsButton    matlab.ui.control.Button
        MatrixSensitivityFactorMSFTab  matlab.ui.container.Tab
        ExportTableButton              matlab.ui.control.Button
        ComparetoDropDown              matlab.ui.control.DropDown
        ComparetoDropDownLabel         matlab.ui.control.Label
        SensitivitybasedonDropDown     matlab.ui.control.DropDown
        SensitivitybasedonDropDownLabel  matlab.ui.control.Label
        ShowLegendCheckBox             matlab.ui.control.CheckBox
        DenominatorListBox             matlab.ui.control.ListBox
        RatioListBox                   matlab.ui.control.ListBox
        MSFAxes                        matlab.ui.control.UIAxes
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


        selected_CAL
        selected_bracket_id

        selected_spot
        selected_spot_inclusion
        selected_table
        selected_host_inclusion
        selected_column
        two_IS_rows
        MSF_ratios

        %%%%%%%%%%


        %%%% for quantification %%%%
        sensitivity_relative_to_internal_standard
        sensitivity_relative_to_internal_standard_inclusion
        sensitivity_relative_to_second_internal_standard_inclusion

        %%% for total oxides %%%%
        Fe2_3
        internal_standard_name_total_oxides 
        internal_standard_name_total_oxides_inclusion
        total_oxide_terms
        total_oxide_terms_inclusion

        %%%
        editstatus = false % once this is true it asks if the data should be saved

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


        %%%%%%%%%%%%%%%%%%%%%%%%%% GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function update_matrix_table(app)
            nonCALIndices = app.base.project.session.spot.type ~= "CAL";
            spotnames     = app.base.project.session.spot.name(nonCALIndices);
            spotNumbers   = find(nonCALIndices);

            b = app.BracketidDropDown.Value;
            c = app.selected_CAL;

            internal_std   = app.base.project.session.spot.internal_standard{b, c}(nonCALIndices);
            mass_fraction  = app.base.project.session.spot.internal_standard_mass_fraction{b, c}(nonCALIndices);
            oxide_fraction = app.base.project.session.spot.internal_standard_oxide_wt{b, c}(nonCALIndices);
            fe_ratio       = app.base.project.session.spot.Fe_ratio_for_total_oxide{b, c}(nonCALIndices);

            oxide_cell = num2cell(oxide_fraction); oxide_cell(isnan(oxide_fraction)) = {[]};
            fe_cell    = num2cell(fe_ratio);       fe_cell(isnan(fe_ratio))          = {[]};

            show_unc = strcmp(app.EnableinternalstandarduncertaintyMenu.Checked, 'on') && ...
                isfield(app.base.project.session.spot, 'internal_standard_mass_fraction_uncertainty');

            if show_unc
                mf_unc = app.base.project.session.spot.internal_standard_mass_fraction_uncertainty{b, c}(nonCALIndices);
                ox_unc = app.base.project.session.spot.internal_standard_oxide_wt_uncertainty{b, c}(nonCALIndices);
                mf_unc_cell = num2cell(mf_unc); mf_unc_cell(isnan(mf_unc)) = {[]};
                ox_unc_cell = num2cell(ox_unc); ox_unc_cell(isnan(ox_unc)) = {[]};

                data     = [num2cell(spotNumbers), cellstr(spotnames), cellstr(internal_std), ...
                    mass_fraction, mf_unc_cell, oxide_cell, ox_unc_cell, fe_cell];
                colNames = {'#', 'Spotname', 'Analyte', '[µg/g]', '± 1σ [µg/g]', ...
                    '% Total Oxides', '± 1σ [%]', 'FeO/(FeO + Fe2O3)'};
                editable = [false false false true true true true true];
            else
                data     = [num2cell(spotNumbers), cellstr(spotnames), cellstr(internal_std), ...
                    mass_fraction, oxide_cell, fe_cell];
                colNames = {'#', 'Spotname', 'Analyte', '[µg/g]', '% Total Oxides', 'FeO/(FeO + Fe2O3)'};
                editable = [false false false true true true];
            end

            T = cell2table(data, 'VariableNames', colNames);

            sens_data = table2array(app.base.project.session.spot.sensitivities{b, c}(nonCALIndices, :));
            zero_rows = sum(sens_data, 2) == 0;
            T(zero_rows, :) = [];

            app.MatrixTable.Data       = T;
            app.MatrixTable.ColumnName = colNames;

            s_center = uistyle('HorizontalAlignment', 'center');
            addStyle(app.MatrixTable, s_center);

            app.MatrixTable.ColumnEditable = editable;

            editableCols = colNames(logical(editable));
            app.StringCompareDropDown.Items     = editableCols;
            app.StringCompareDropDown.ItemsData = editableCols;

        end

        function update_inclusion_table(app)

            bracket_id       = app.BracketidDropDown.Value;
            calibrator_index = app.selected_CAL;
            spot_data        = app.base.project.session.spot;

            is_unknown_spot = spot_data.type ~= "CAL";
            spot_names      = spot_data.name(is_unknown_spot);
            spot_numbers    = find(is_unknown_spot);

            internal_standard_1_names         = spot_data.internal_standard_inclusion{bracket_id, calibrator_index}(is_unknown_spot);
            internal_standard_1_mass_fraction = spot_data.internal_standard_mass_fraction_inclusion{bracket_id, calibrator_index}(is_unknown_spot);
            total_oxide_percent               = spot_data.internal_standard_oxide_wt_inclusion{bracket_id, calibrator_index}(is_unknown_spot);
            iron_oxidation_ratio              = spot_data.Fe_ratio_for_total_oxide_inclusion{bracket_id, calibrator_index}(is_unknown_spot);
            internal_standard_2_names         = spot_data.second_internal_standard_inclusion{bracket_id, calibrator_index}(is_unknown_spot);
            internal_standard_2_mass_fraction = spot_data.second_internal_standard_mass_fraction_inclusion{bracket_id, calibrator_index}(is_unknown_spot);

            number_of_spots = size(spot_data.signal_starts, 1);

            if ~isfield(app.base.project.session.spot, 'mixing_ratio') || isempty(app.base.project.session.spot.mixing_ratio)
                number_of_sensitivity_rows    = size(spot_data.sensitivities, 1);
                number_of_sensitivity_columns = size(spot_data.sensitivities, 2);
                app.base.project.session.spot.mixing_ratio = repmat({NaN(number_of_spots, 1)}, number_of_sensitivity_rows, number_of_sensitivity_columns);
                spot_data = app.base.project.session.spot;
            end

            mixing_ratio_all_spots = spot_data.mixing_ratio{bracket_id, calibrator_index};
            if numel(mixing_ratio_all_spots) == number_of_spots
                mixing_ratio = mixing_ratio_all_spots(is_unknown_spot);
            else
                mixing_ratio = NaN(sum(is_unknown_spot), 1);
            end

            % the mixing ratio column only shows the user input of spots in "Mixing ratio" mode
            unmixing_mode_of_unknowns = spot_data.unmixing_via(is_unknown_spot);
            uses_mixing_ratio_mode    = unmixing_mode_of_unknowns == "Mixing ratio";
            mixing_ratio(~uses_mixing_ratio_mode) = NaN;

            total_oxide_percent_cells  = num2cell(total_oxide_percent);  total_oxide_percent_cells(isnan(total_oxide_percent))   = {[]};
            iron_oxidation_ratio_cells = num2cell(iron_oxidation_ratio); iron_oxidation_ratio_cells(isnan(iron_oxidation_ratio)) = {[]};
            mixing_ratio_cells         = num2cell(mixing_ratio);         mixing_ratio_cells(isnan(mixing_ratio))                 = {[]};

            uncertainty_field_names = {'internal_standard_mass_fraction_uncertainty_inclusion', ...
                'internal_standard_oxide_wt_uncertainty_inclusion', ...
                'second_internal_standard_mass_fraction_uncertainty_inclusion', ...
                'mixing_ratio_uncertainty_inclusion'};
            uncertainty_menu_is_on = strcmp(app.EnableinternalstandarduncertaintyMenu.Checked, 'on');
            show_uncertainty_columns = uncertainty_menu_is_on && all(isfield(spot_data, uncertainty_field_names));

            if show_uncertainty_columns

                internal_standard_1_uncertainty = spot_data.internal_standard_mass_fraction_uncertainty_inclusion{bracket_id, calibrator_index}(is_unknown_spot);
                total_oxide_uncertainty         = spot_data.internal_standard_oxide_wt_uncertainty_inclusion{bracket_id, calibrator_index}(is_unknown_spot);
                internal_standard_2_uncertainty = spot_data.second_internal_standard_mass_fraction_uncertainty_inclusion{bracket_id, calibrator_index}(is_unknown_spot);
                mixing_ratio_uncertainty        = spot_data.mixing_ratio_uncertainty_inclusion{bracket_id, calibrator_index}(is_unknown_spot);
                mixing_ratio_uncertainty(~uses_mixing_ratio_mode) = NaN;

                internal_standard_1_uncertainty_cells = num2cell(internal_standard_1_uncertainty); internal_standard_1_uncertainty_cells(isnan(internal_standard_1_uncertainty)) = {[]};
                total_oxide_uncertainty_cells         = num2cell(total_oxide_uncertainty);         total_oxide_uncertainty_cells(isnan(total_oxide_uncertainty))                 = {[]};
                internal_standard_2_uncertainty_cells = num2cell(internal_standard_2_uncertainty); internal_standard_2_uncertainty_cells(isnan(internal_standard_2_uncertainty)) = {[]};
                mixing_ratio_uncertainty_cells        = num2cell(mixing_ratio_uncertainty);        mixing_ratio_uncertainty_cells(isnan(mixing_ratio_uncertainty))               = {[]};

                table_data = [num2cell(spot_numbers), cellstr(spot_names), cellstr(internal_standard_1_names), ...
                    internal_standard_1_mass_fraction, internal_standard_1_uncertainty_cells, ...
                    total_oxide_percent_cells, total_oxide_uncertainty_cells, iron_oxidation_ratio_cells, ...
                    cellstr(internal_standard_2_names), internal_standard_2_mass_fraction, internal_standard_2_uncertainty_cells, ...
                    mixing_ratio_cells, mixing_ratio_uncertainty_cells];

                column_names = {'#', 'Spotname', 'Analyte (I.S.1)', '[µg/g] (I.S.1)', '± 1σ [µg/g] (I.S.1)', ...
                    '% Total Oxides', '± 1σ [%]', 'FeO/(FeO + Fe2O3)', ...
                    'Analyte (I.S.2)', '[µg/g] (I.S.2)', '± 1σ [µg/g] (I.S.2)', ...
                    'Mixing Ratio (x)', '± 1σ (x)'};

                column_is_editable = [false false false true true true true true false true true true true];

            else

                table_data = [num2cell(spot_numbers), cellstr(spot_names), cellstr(internal_standard_1_names), ...
                    internal_standard_1_mass_fraction, total_oxide_percent_cells, iron_oxidation_ratio_cells, ...
                    cellstr(internal_standard_2_names), internal_standard_2_mass_fraction, mixing_ratio_cells];

                column_names = {'#', 'Spotname', 'Analyte (I.S.1)', '[µg/g] (I.S.1)', '% Total Oxides', ...
                    'FeO/(FeO + Fe2O3)', 'Analyte (I.S.2)', '[µg/g] (I.S.2)', 'Mixing Ratio (x)'};

                column_is_editable = [false false false true true true false true true];
            end

            inclusion_table = cell2table(table_data, 'VariableNames', column_names);

            sensitivities_of_unknowns = table2array(spot_data.sensitivities{bracket_id, calibrator_index}(is_unknown_spot, :));
            spots_without_sensitivity = sum(sensitivities_of_unknowns, 2) == 0;
            inclusion_table(spots_without_sensitivity, :) = [];

            app.InclusionTable.Data           = inclusion_table;
            app.InclusionTable.ColumnName     = column_names;
            app.InclusionTable.ColumnEditable = column_is_editable;

            center_aligned_style = uistyle('HorizontalAlignment', 'center');
            addStyle(app.InclusionTable, center_aligned_style);

            editable_column_names = column_names(logical(column_is_editable));
            app.StringCompareDropDown.Items     = editable_column_names;
            app.StringCompareDropDown.ItemsData = editable_column_names;
        end

        function update_inclusion_table_style(app)

            unmixing_mode_of_all_spots = app.base.project.session.spot.unmixing_via;

            app.two_IS_rows        = find(unmixing_mode_of_all_spots == "Two internal standards");
            spots_without_unmixing = find(unmixing_mode_of_all_spots == "None");
            spots_with_mixing_ratio = find(unmixing_mode_of_all_spots == "Mixing ratio");

            spot_number_of_each_displayed_row = table2array(app.InclusionTable.DisplayData(:, 1));

            displayed_rows_two_IS        = find(ismember(spot_number_of_each_displayed_row, app.two_IS_rows));
            displayed_rows_not_two_IS    = find(~ismember(spot_number_of_each_displayed_row, app.two_IS_rows));
            displayed_rows_no_unmixing   = find(ismember(spot_number_of_each_displayed_row, spots_without_unmixing));
            displayed_rows_not_mixing_ratio = find(~ismember(spot_number_of_each_displayed_row, spots_with_mixing_ratio));

            % columns are looked up by name, so the layout may change with the uncertainty menu
            column_names = app.InclusionTable.ColumnName;
            internal_standard_1_columns = find(ismember(column_names, {'Analyte (I.S.1)', '[µg/g] (I.S.1)', '± 1σ [µg/g] (I.S.1)'}));
            total_oxide_columns         = find(ismember(column_names, {'% Total Oxides', '± 1σ [%]', 'FeO/(FeO + Fe2O3)'}));
            internal_standard_2_columns = find(ismember(column_names, {'Analyte (I.S.2)', '[µg/g] (I.S.2)', '± 1σ [µg/g] (I.S.2)'}));
            mixing_ratio_columns        = find(ismember(column_names, {'Mixing Ratio (x)', '± 1σ (x)'}));

            % each row of this list says: grey these displayed rows in these columns
            grey_rules = {
                displayed_rows_not_two_IS,       internal_standard_2_columns;
                displayed_rows_two_IS,           total_oxide_columns;
                displayed_rows_no_unmixing,      internal_standard_1_columns;
                displayed_rows_not_mixing_ratio, mixing_ratio_columns};

            cells_to_grey = [];
            for rule_number = 1:size(grey_rules, 1)
                rows_to_grey    = grey_rules{rule_number, 1};
                columns_to_grey = grey_rules{rule_number, 2};
                columns_to_grey = columns_to_grey(:).';   % row vector, so the loop visits one column at a time

                for column_number = columns_to_grey
                    column_of_cells = repmat(column_number, numel(rows_to_grey), 1);
                    cells_to_grey   = [cells_to_grey; rows_to_grey(:), column_of_cells];
                end
            end

            removeStyle(app.InclusionTable);

            grey_background_style = uistyle('BackgroundColor', [0.9, 0.9, 0.9]);
            if ~isempty(cells_to_grey)
                addStyle(app.InclusionTable, grey_background_style, 'cell', cells_to_grey);
            end

            center_aligned_style = uistyle('HorizontalAlignment', 'center');
            addStyle(app.InclusionTable, center_aligned_style);
        end

        %%%%%%%%%%%%%%%% Mass Fraction Calculation %%%%%%%%%%%%%%%%%%%%%

        % these are basically the same functions twice every time, once
        % for matrix and once for inclusion.
        % There is probably a smoother way to do this but ¯\_(ツ)_/¯


        %%%% 2. %%%
        function calculate_sensitivity_relative_to_the_internal_standard(app)

            sensitivities = app.base.project.session.spot.sensitivities;
            internal_std  = app.base.project.session.spot.internal_standard;

            app.sensitivity_relative_to_internal_standard = cell(size(sensitivities,1), size(sensitivities,2));

            element_names      = app.base.project.session.oxides.element_names;
            preferred_isotopes = app.base.project.session.oxides.preferred_isotopes;

            for cal_idx = 1:size(sensitivities,2)
                for bracket_idx = 1:size(sensitivities,1)
                    if ~isempty(sensitivities{bracket_idx,cal_idx})
                        curr_sens = sensitivities{bracket_idx,cal_idx};
                        curr_std  = internal_std{bracket_idx,cal_idx};
                    else
                        continue
                    end

                    colNames      = curr_sens.Properties.VariableNames;
                    sens_matrix   = table2array(curr_sens);
                    relative_sens = zeros(size(sens_matrix));
                    internal_standard_names = cell(size(sens_matrix, 1), 1);

                    if any(curr_std == "Total Oxides")
                        temp_elements = {};
                        for i = 1:length(colNames)
                            current      = colNames{i};
                            element_name = current(isstrprop(current, 'alpha'));
                            if ismember(element_name, element_names)
                                temp_elements{end+1} = current;
                            end
                        end

                        filtered_elements = {};
                        for i = 1:length(element_names)
                            element_name      = element_names(i);
                            measured_isotopes = temp_elements( ...
                                cellfun(@(x) isequal(x(isstrprop(x, 'alpha')), element_name), temp_elements));
                            if ~isempty(measured_isotopes)
                                preferred = preferred_isotopes{i};
                                if ~isempty(preferred)
                                    idx = find(strcmp(measured_isotopes, preferred), 1);
                                    if ~isempty(idx)
                                        filtered_elements{end+1} = preferred;
                                    else
                                        filtered_elements{end+1} = measured_isotopes{1};
                                    end
                                else
                                    filtered_elements{end+1} = measured_isotopes{1};
                                end
                            end
                        end
                        elements_to_total = filtered_elements(:)';
                    end

                    for unk = 1:size(sens_matrix, 1)
                        if curr_std(unk) ~= ""
                            std_element = curr_std(unk);

                            if isequal(std_element, 'Total Oxides')
                                if all(app.base.project.session.spot.bkgd_corrected_cps{unk, :} == 0)
                                    continue
                                end

                                [~, intstd_element_idx]       = max(app.base.project.session.spot.bkgd_corrected_cps{unk, elements_to_total});
                                intstd_element_name            = elements_to_total{intstd_element_idx};
                                internal_standard_sensitivity  = sens_matrix(unk, strcmp(colNames, intstd_element_name));
                                relative_sens(unk,:)           = sens_matrix(unk,:) ./ internal_standard_sensitivity;
                                internal_standard_names{unk}   = intstd_element_name;
                            else
                                std_col              = find(strcmp(colNames, std_element));
                                std_value            = sens_matrix(unk, std_col);
                                relative_sens(unk,:) = sens_matrix(unk,:) ./ std_value;
                            end
                        end
                    end

                    app.sensitivity_relative_to_internal_standard{bracket_idx,cal_idx} = ...
                        array2table(relative_sens, 'VariableNames', colNames);
                    app.internal_standard_name_total_oxides{bracket_idx,cal_idx} = internal_standard_names;
                end
            end
        end

        function calculate_sensitivity_relative_to_the_internal_standard_incl(app)

            if isequal(app.base.project.session.config.reductiontype, 'Inclusion')

                sensitivities = app.base.project.session.spot.sensitivities;
                internal_std  = app.base.project.session.spot.internal_standard_inclusion;

                app.sensitivity_relative_to_internal_standard_inclusion = cell(size(sensitivities,1), size(sensitivities,2));

                element_names      = app.base.project.session.oxides.element_names;
                preferred_isotopes = app.base.project.session.oxides.preferred_isotopes;

                for cal_idx = 1:size(sensitivities,2)
                    for bracket_idx = 1:size(sensitivities,1)
                        if ~isempty(sensitivities{bracket_idx,cal_idx})
                            curr_sens = sensitivities{bracket_idx,cal_idx};
                            curr_std  = internal_std{bracket_idx,cal_idx};
                        else
                            continue
                        end

                        colNames      = curr_sens.Properties.VariableNames;
                        sens_matrix   = table2array(curr_sens);
                        relative_sens = zeros(size(sens_matrix));
                        internal_standard_names = cell(size(sens_matrix, 1), 1);

                        if any(curr_std == "Total Oxides")
                            temp_elements = {};
                            for i = 1:length(colNames)
                                current      = colNames{i};
                                element_name = current(isstrprop(current, 'alpha'));
                                if ismember(element_name, element_names)
                                    temp_elements{end+1} = current;
                                end
                            end

                            filtered_elements = {};
                            for i = 1:length(element_names)
                                element_name      = element_names(i);
                                measured_isotopes = temp_elements( ...
                                    cellfun(@(x) isequal(x(isstrprop(x, 'alpha')), element_name), temp_elements));
                                if ~isempty(measured_isotopes)
                                    preferred = preferred_isotopes{i};
                                    if ~isempty(preferred)
                                        idx = find(strcmp(measured_isotopes, preferred), 1);
                                        if ~isempty(idx)
                                            filtered_elements{end+1} = preferred;
                                        else
                                            filtered_elements{end+1} = measured_isotopes{1};
                                        end
                                    else
                                        filtered_elements{end+1} = measured_isotopes{1};
                                    end
                                end
                            end
                            elements_to_total = filtered_elements(:)';
                        end

                        for unk = 1:size(sens_matrix, 1)
                            if curr_std(unk) ~= ""
                                std_element = curr_std(unk);

                                if isequal(std_element, 'Total Oxides')
                                    if all(app.base.project.session.spot.bkgd_corrected_cps_incl{unk, :} == 0)
                                        continue
                                    end

                                    [~, intstd_element_idx]       = max(app.base.project.session.spot.bkgd_corrected_cps_incl{unk, elements_to_total});
                                    intstd_element_name            = elements_to_total{intstd_element_idx};
                                    internal_standard_sensitivity  = sens_matrix(unk, strcmp(colNames, intstd_element_name));
                                    relative_sens(unk,:)           = sens_matrix(unk,:) ./ internal_standard_sensitivity;
                                    internal_standard_names{unk}   = intstd_element_name;
                                else
                                    std_col              = find(strcmp(colNames, std_element));
                                    std_value            = sens_matrix(unk, std_col);
                                    relative_sens(unk,:) = sens_matrix(unk,:) ./ std_value;
                                end
                            end
                        end

                        app.sensitivity_relative_to_internal_standard_inclusion{bracket_idx,cal_idx} = ...
                            array2table(relative_sens, 'VariableNames', colNames);
                        app.internal_standard_name_total_oxides_inclusion{bracket_idx,cal_idx} = internal_standard_names;
                    end
                end
            end
        end

        function calculate_sensitivity_relative_to_sec_internal_standard_incl(app)

            if isequal(app.base.project.session.config.reductiontype, 'Inclusion')

                % Get input sensitivities and internal standards
                sensitivities = app.base.project.session.spot.sensitivities;
                internal_std = app.base.project.session.spot.second_internal_standard_inclusion;

                % Initialize output cell array
                app.sensitivity_relative_to_second_internal_standard_inclusion = cell(size(sensitivities,1), size(sensitivities,2));

                % Process each table in the cell array
                for cal_idx = 1:size(sensitivities,2)
                    for bracket_idx = 1:size(sensitivities,1)
                        if ~isempty(sensitivities{bracket_idx,cal_idx})
                            % Get current sensitivity table and internal standards
                            curr_sens = sensitivities{bracket_idx,cal_idx};
                            curr_std = internal_std{bracket_idx,cal_idx};
                        else
                            continue
                        end
                        % Get column names
                        colNames = curr_sens.Properties.VariableNames;

                        % Convert to matrix for calculations
                        sens_matrix = table2array(curr_sens);
                        relative_sens = zeros(size(sens_matrix));

                        % Process each row
                        for unk = 1:size(sens_matrix, 1)
                            % Check if internal standard exists
                            if curr_std(unk) ~= ""
                                std_element = curr_std(unk);
                                if isequal(std_element, 'Total Oxides')
                                    continue
                                end
                                std_col = find(strcmp(colNames, std_element));

                                % Get internal standard value
                                std_value = sens_matrix(unk, std_col);

                                % Calculate relative sensitivities for this row
                                relative_sens(unk,:) = sens_matrix(unk,:) ./ std_value;
                            end
                        end

                        % Convert result back to table and store in cell array
                        app.sensitivity_relative_to_second_internal_standard_inclusion{bracket_idx,cal_idx} = ...
                            array2table(relative_sens, 'VariableNames', colNames);
                    end
                end
            end
        end


        %%%% 3. %%%

        % for "normal" mineral spot analysis calculations and the hosts of
        % inclusions
        function calculate_matrix_mass_fractions(app)

            % Identify calibration and unknown spots
            cal_mask    = strcmp(app.base.project.session.spot.type, "CAL");
            unique_CALs = unique(app.base.project.session.spot.referencematerial(cal_mask));
            all_UNK     = find(~cal_mask);

            % Constants used across all loops
            bkgd_varnames = app.base.project.session.spot.bkgd_corrected_cps.Properties.VariableNames;
            n_bkgd_cols   = width(app.base.project.session.spot.bkgd_corrected_cps);
            n_spots       = length(app.base.project.session.spot.signal_starts);
            element_names = app.base.project.session.oxides.element_names;
            pref_isotopes = app.base.project.session.oxides.preferred_isotopes;

            is_continuous = isequal(app.base.project.session.config.datatype, 'Continuous');
            if is_continuous
                signal_data = app.base.project.session.spot.signal_data;
            end

            for cal_idx = 1:size(app.base.project.session.spot.sensitivities, 2)
                for bracket_idx = 1:size(app.base.project.session.spot.sensitivities, 1)

                    % Skip empty sensitivity tables
                    if isempty(app.base.project.session.spot.sensitivities{bracket_idx,cal_idx}) || ...
                            isequal(app.base.project.session.spot.sensitivities{bracket_idx,cal_idx}, zeros(0,0))
                        app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}         = zeros(0,0);
                        app.base.project.session.spot.matrix_limits_of_detection{bracket_idx,cal_idx} = zeros(0,0);
                        continue
                    end

                    % Sensitivity columns and per-spot internal standard assignments for this bracket/cal
                    sensitivity_cols   = app.sensitivity_relative_to_internal_standard{bracket_idx,cal_idx}.Properties.VariableNames;
                    internal_standards = app.base.project.session.spot.internal_standard{bracket_idx,cal_idx};

                    % Map sensitivity columns to positions in bkgd_corrected_cps
                    [in_bkgd_table, bkgd_col_positions] = ismember(sensitivity_cols, bkgd_varnames);
                    shared_analyte_cols  = sensitivity_cols(in_bkgd_table);
                    shared_col_positions = bkgd_col_positions(in_bkgd_table);
                    dwelltimes           = cellfun(@(c) app.base.project.session.spot.dwelltimes.(c), shared_analyte_cols);

                    % Pre-compute filtered element list for Total Oxides (only if needed)
                    if any(internal_standards == "Total Oxides")
                        temp_elements = {};
                        for i = 1:length(sensitivity_cols)
                            current      = sensitivity_cols{i};
                            element_name = current(isstrprop(current, 'alpha'));
                            if ismember(element_name, element_names)
                                temp_elements{end+1} = current;
                            end
                        end
                        filtered_elements = {};
                        for i = 1:length(element_names)
                            element_name      = element_names(i);
                            measured_isotopes = temp_elements( ...
                                cellfun(@(x) isequal(x(isstrprop(x, 'alpha')), element_name), temp_elements));
                            if ~isempty(measured_isotopes)
                                preferred = pref_isotopes{i};
                                if ~isempty(preferred)
                                    idx = find(strcmp(measured_isotopes, preferred), 1);
                                    if ~isempty(idx)
                                        filtered_elements{end+1} = preferred;
                                    else
                                        filtered_elements{end+1} = measured_isotopes{1};
                                    end
                                else
                                    filtered_elements{end+1} = measured_isotopes{1};
                                end
                            end
                        end
                        elements_to_total = filtered_elements(:)';
                    else
                        elements_to_total = {};
                    end

                    % Pre-allocate output matrices (converted to tables at the end)
                    mass_fractions_mat = zeros(n_spots, n_bkgd_cols);
                    LOD_mat            = zeros(n_spots, n_bkgd_cols);

                    for i = 1:numel(all_UNK)
                        unk = all_UNK(i);

                        % Skip spots with no internal standard assigned
                        if internal_standards(unk) == "", continue; end

                        % Skip spots missing required inputs
                        if isempty(app.base.project.session.spot.internal_standard_mass_fraction{bracket_idx,cal_idx}{unk}) && ...
                                ~isequal(internal_standards(unk), 'Total Oxides')
                            continue
                        end

                        if isequal(internal_standards(unk), 'Total Oxides')
                            if isnan(app.base.project.session.spot.internal_standard_oxide_wt{bracket_idx,cal_idx}(unk)) || ...
                                    isnan(app.base.project.session.spot.Fe_ratio_for_total_oxide{bracket_idx,cal_idx}(unk))
                                continue
                            end
                        end

                        if ~isempty(app.base.project.session.spot.internal_standard_mass_fraction{bracket_idx,cal_idx}{unk}) && ...
                                startsWith(string(app.base.project.session.spot.internal_standard_mass_fraction{bracket_idx,cal_idx}{unk}), 'from') && ...
                                ~isequal(internal_standards(unk), 'Total Oxides')
                            continue
                        end

                        if all(app.base.project.session.spot.bkgd_corrected_cps{unk, :} == 0)
                            continue
                        end

                        % Resolve internal standard intensity and mass fraction
                        if isequal(internal_standards(unk), 'Total Oxides')
                            [IS_intensity, IS_mass_fraction, IS_name] = total_oxide_calculation(app, bracket_idx, cal_idx, unk, elements_to_total);
                        else
                            IS_name          = internal_standards(unk);
                            IS_intensity     = app.base.project.session.spot.bkgd_corrected_cps.(char(IS_name))(unk);
                            IS_mass_fraction = app.base.project.session.spot.internal_standard_mass_fraction{bracket_idx,cal_idx}{unk};
                        end

                        % Background-corrected CPS and relative sensitivity for shared columns
                        cps_row  = table2array(app.base.project.session.spot.bkgd_corrected_cps(unk, shared_analyte_cols));
                        sens_row = table2array(app.sensitivity_relative_to_internal_standard{bracket_idx,cal_idx}(unk, shared_analyte_cols));

                        % Mass fraction: (analyte_cps / IS_cps) * (IS_mass_fraction / relative_sensitivity)
                        mass_fractions_mat(unk, shared_col_positions) = (cps_row / IS_intensity) .* (IS_mass_fraction ./ sens_row);

                        % --- Limits of detection ---
                        bg_start = app.base.project.session.spot.background_starts(unk);
                        bg_end   = app.base.project.session.spot.background_ends(unk);
                        n_bg     = bg_end - bg_start + 1;

                        m1s = app.base.project.session.spot.matrix_1_starts(unk); m1e = app.base.project.session.spot.matrix_1_ends(unk);
                        m2s = app.base.project.session.spot.matrix_2_starts(unk); m2e = app.base.project.session.spot.matrix_2_ends(unk);
                        m3s = app.base.project.session.spot.matrix_3_starts(unk); m3e = app.base.project.session.spot.matrix_3_ends(unk);
                        n1 = 0; if ~isnan(m1s); n1 = m1e - m1s + 1; end
                        n2 = 0; if ~isnan(m2s); n2 = m2e - m2s + 1; end
                        n3 = 0; if ~isnan(m3s); n3 = m3e - m3s + 1; end
                        n_matrix = n1 + n2 + n3;

                        if ~is_continuous
                            signal_data = app.base.project.session.spot.signal_data{unk};
                        end

                        % Mean background CPS per analyte over the background window
                        mean_bg_cps     = mean(table2array(signal_data(bg_start:bg_end, shared_analyte_cols)), 1);
                        % Absolute sensitivity = relative sensitivity * (IS_cps / IS_mass_fraction)
                        abs_sensitivity = sens_row .* (IS_intensity / IS_mass_fraction);

                        LOD_vals = (3.29 * sqrt(mean_bg_cps .* dwelltimes .* n_matrix .* (1 + n_matrix / n_bg)) + 2.71) ./ ...
                            (n_matrix .* dwelltimes .* abs_sensitivity);
                        LOD_mat(unk, shared_col_positions) = LOD_vals;
                    end

                    app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}         = array2table(mass_fractions_mat, 'VariableNames', bkgd_varnames);
                    app.base.project.session.spot.matrix_limits_of_detection{bracket_idx,cal_idx} = array2table(LOD_mat, 'VariableNames', bkgd_varnames);
                end
            end

            % --- Iterative passes to resolve 'from <CAL>' internal standard mass fractions ---
            % Some spots reference another CAL material's computed composition as their IS mass fraction.
            % Iterate until convergence (no further changes) or max passes reached.
            max_passes = length(unique_CALs);
            for pass = 1:max_passes
                changes_made = false;

                for cal_idx = 1:size(app.base.project.session.spot.sensitivities, 2)
                    for bracket_idx = 1:size(app.base.project.session.spot.sensitivities, 1)

                        if isempty(app.base.project.session.spot.sensitivities{bracket_idx,cal_idx}) || ...
                                isequal(app.base.project.session.spot.sensitivities{bracket_idx,cal_idx}, zeros(0,0))
                            continue
                        end

                        sensitivity_cols   = app.sensitivity_relative_to_internal_standard{bracket_idx,cal_idx}.Properties.VariableNames;
                        internal_standards = app.base.project.session.spot.internal_standard{bracket_idx,cal_idx};

                        [in_bkgd_table, bkgd_col_positions] = ismember(sensitivity_cols, bkgd_varnames);
                        shared_analyte_cols  = sensitivity_cols(in_bkgd_table);
                        shared_col_positions = bkgd_col_positions(in_bkgd_table);
                        dwelltimes           = cellfun(@(c) app.base.project.session.spot.dwelltimes.(c), shared_analyte_cols);

                        % Start from current computed values; only update spots with resolved 'from' references
                        mass_fractions_mat = table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx});
                        LOD_mat            = table2array(app.base.project.session.spot.matrix_limits_of_detection{bracket_idx,cal_idx});

                        for i = 1:numel(all_UNK)
                            unk = all_UNK(i);

                            if internal_standards(unk) == "", continue; end

                            IS_element = internal_standards(unk);

                            % Only process spots whose IS mass fraction references another CAL material
                            if ~isempty(app.base.project.session.spot.internal_standard_mass_fraction{bracket_idx,cal_idx}{unk}) && ...
                                    startsWith(string(app.base.project.session.spot.internal_standard_mass_fraction{bracket_idx,cal_idx}{unk}), 'from') && ...
                                    ~isequal(internal_standards(unk), 'Total Oxides')

                                source_cal     = extractAfter(string(app.base.project.session.spot.internal_standard_mass_fraction{bracket_idx,cal_idx}{unk}), 'from ');
                                source_cal_idx = find(strcmp(unique_CALs, source_cal));

                                if ~isempty(source_cal_idx) && ~isempty(app.base.project.session.spot.matrix_composition{bracket_idx,source_cal_idx})

                                    % Look up the IS element's computed value from the source CAL composition
                                    IS_mass_fraction = app.base.project.session.spot.matrix_composition{bracket_idx,source_cal_idx}{unk, char(IS_element)};

                                    if IS_mass_fraction > 0
                                        original_IS_mass_fraction = app.base.project.session.spot.internal_standard_mass_fraction{bracket_idx,cal_idx}{unk};
                                        old_row      = mass_fractions_mat(unk,:);
                                        IS_name      = IS_element;
                                        IS_intensity = app.base.project.session.spot.bkgd_corrected_cps.(char(IS_name))(unk);

                                        % Temporarily set the resolved IS mass fraction for computation
                                        app.base.project.session.spot.internal_standard_mass_fraction{bracket_idx,cal_idx}{unk} = IS_mass_fraction;

                                        cps_row  = table2array(app.base.project.session.spot.bkgd_corrected_cps(unk, shared_analyte_cols));
                                        sens_row = table2array(app.sensitivity_relative_to_internal_standard{bracket_idx,cal_idx}(unk, shared_analyte_cols));
                                        new_row  = zeros(1, n_bkgd_cols);
                                        new_row(shared_col_positions) = (cps_row / IS_intensity) .* (IS_mass_fraction ./ sens_row);

                                        % LOD for this spot
                                        bg_start = app.base.project.session.spot.background_starts(unk);
                                        bg_end   = app.base.project.session.spot.background_ends(unk);
                                        n_bg     = bg_end - bg_start + 1;

                                        m1s = app.base.project.session.spot.matrix_1_starts(unk); m1e = app.base.project.session.spot.matrix_1_ends(unk);
                                        m2s = app.base.project.session.spot.matrix_2_starts(unk); m2e = app.base.project.session.spot.matrix_2_ends(unk);
                                        m3s = app.base.project.session.spot.matrix_3_starts(unk); m3e = app.base.project.session.spot.matrix_3_ends(unk);
                                        n1 = 0; if ~isnan(m1s); n1 = m1e - m1s + 1; end
                                        n2 = 0; if ~isnan(m2s); n2 = m2e - m2s + 1; end
                                        n3 = 0; if ~isnan(m3s); n3 = m3e - m3s + 1; end
                                        n_matrix = n1 + n2 + n3;

                                        if ~is_continuous
                                            signal_data = app.base.project.session.spot.signal_data{unk};
                                        end

                                        mean_bg_cps     = mean(table2array(signal_data(bg_start:bg_end, shared_analyte_cols)), 1);
                                        abs_sensitivity = sens_row .* (IS_intensity / IS_mass_fraction);
                                        LOD_vals        = (3.29 * sqrt(mean_bg_cps .* dwelltimes .* n_matrix .* (1 + n_matrix / n_bg)) + 2.71) ./ ...
                                            (n_matrix .* dwelltimes .* abs_sensitivity);
                                        LOD_row = zeros(1, n_bkgd_cols);
                                        LOD_row(shared_col_positions) = LOD_vals;

                                        % Restore original 'from ...' reference string
                                        app.base.project.session.spot.internal_standard_mass_fraction{bracket_idx,cal_idx}{unk} = original_IS_mass_fraction;

                                        mass_fractions_mat(unk,:) = new_row;
                                        LOD_mat(unk,:)            = LOD_row;

                                        if any(abs(new_row - old_row) > 1e-10)
                                            changes_made = true;
                                        end
                                    end
                                end
                            end
                        end

                        mass_fractions_mat(isnan(mass_fractions_mat)) = 0;
                        LOD_mat(isnan(LOD_mat))                       = 0;

                        app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}         = array2table(mass_fractions_mat, 'VariableNames', bkgd_varnames);
                        app.base.project.session.spot.matrix_limits_of_detection{bracket_idx,cal_idx} = array2table(LOD_mat, 'VariableNames', bkgd_varnames);
                    end
                end

                if ~changes_made
                    break
                end
            end
        end

        % for the inclusions
        function inclusion_quantification_failed = calculate_inclusion_mass_fractions(app)

            inclusion_quantification_failed = false;

            cal_mask      = strcmp(app.base.project.session.spot.type, "CAL");
            unique_CALs   = unique(app.base.project.session.spot.referencematerial(cal_mask));
            all_UNK       = find(~cal_mask);

            n_spots       = length(app.base.project.session.spot.signal_starts);
            n_analytes    = numel(app.base.project.session.spot.analytes);
            incl_varnames = app.base.project.session.spot.bkgd_corrected_cps_incl.Properties.VariableNames;
            mix_varnames  = app.base.project.session.spot.bkgd_corrected_cps_mix.Properties.VariableNames;
            element_names      = app.base.project.session.oxides.element_names;
            preferred_isotopes = app.base.project.session.oxides.preferred_isotopes;

            % first pass
            for cal_idx = 1:size(app.base.project.session.spot.sensitivities, 2)
                for bracket_idx = 1:size(app.base.project.session.spot.sensitivities, 1)

                    if isempty(app.base.project.session.spot.sensitivities{bracket_idx,cal_idx}) || ...
                            isequal(app.base.project.session.spot.sensitivities{bracket_idx,cal_idx}, zeros(0,0))
                        app.base.project.session.spot.inclusion_composition{bracket_idx,cal_idx} = zeros(0,0);
                        app.base.project.session.spot.mixing_ratio{bracket_idx,cal_idx}          = zeros(0,0);
                        app.base.project.session.spot.mix_composition{bracket_idx,cal_idx}       = zeros(0,0);
                        continue
                    end

                    sensitivity_table = app.sensitivity_relative_to_internal_standard_inclusion{bracket_idx,cal_idx};
                    sensitivity_cols  = sensitivity_table.Properties.VariableNames;

                    [in_incl_table, incl_col_positions] = ismember(sensitivity_cols, incl_varnames);
                    in_mix_table = ismember(sensitivity_cols, mix_varnames);

                    mot_sens_cols      = sensitivity_cols(in_incl_table);
                    mot_incl_positions = incl_col_positions(in_incl_table);

                    mix_sens_cols      = sensitivity_cols(in_incl_table & in_mix_table);
                    mix_incl_positions = incl_col_positions(in_incl_table & in_mix_table);

                    % elements_to_total for Total Oxides — once per bracket/cal
                    elements_to_total = {};
                    any_total_oxides = any(strcmp(app.base.project.session.spot.internal_standard_inclusion{bracket_idx,cal_idx}(all_UNK), 'Total Oxides'));
                    if any_total_oxides
                        all_sens_cols = app.base.project.session.spot.sensitivities{bracket_idx,cal_idx}.Properties.VariableNames;
                        temp_elements = {};
                        for k = 1:length(all_sens_cols)
                            ename = all_sens_cols{k}(isstrprop(all_sens_cols{k}, 'alpha'));
                            if ismember(ename, element_names), temp_elements{end+1} = all_sens_cols{k}; end
                        end
                        for k = 1:length(element_names)
                            ename      = char(element_names(k));
                            candidates = temp_elements(cellfun(@(x) isequal(x(isstrprop(x,'alpha')), ename), temp_elements));
                            if ~isempty(candidates)
                                pref = preferred_isotopes(k);
                                if pref ~= "" && ~isempty(find(strcmp(candidates, pref), 1))
                                    elements_to_total{end+1} = char(pref);
                                else
                                    elements_to_total{end+1} = candidates{1};
                                end
                            end
                        end
                        elements_to_total = elements_to_total(:)';
                    end

                    inclusion_composition_mat = zeros(n_spots, n_analytes);
                    mix_composition_mat       = zeros(n_spots, n_analytes);

                    if numel(app.base.project.session.spot.mixing_ratio{bracket_idx, cal_idx}) == n_spots
                        mixing_ratio_vec = app.base.project.session.spot.mixing_ratio{bracket_idx, cal_idx};
                    else
                        mixing_ratio_vec = NaN(n_spots, 1);
                    end

                    for i = 1:numel(all_UNK)
                        unk       = all_UNK(i);
                        IS        = app.base.project.session.spot.internal_standard_inclusion{bracket_idx,cal_idx}(unk);
                        IS_mf_raw = app.base.project.session.spot.internal_standard_mass_fraction_inclusion{bracket_idx,cal_idx}{unk};
                        unmix_via = app.base.project.session.spot.unmixing_via(unk);

                        if IS == "", continue; end
                        if isempty(IS_mf_raw) && ~isequal(IS, 'Total Oxides'), continue; end
                        if isequal(IS, 'Total Oxides') && isnan(app.base.project.session.spot.internal_standard_oxide_wt_inclusion{bracket_idx,cal_idx}(unk)), continue; end
                        if isequal(IS, 'Total Oxides') && isnan(app.base.project.session.spot.Fe_ratio_for_total_oxide_inclusion{bracket_idx,cal_idx}(unk)), continue; end
                        if ~isempty(IS_mf_raw) && startsWith(string(IS_mf_raw), 'from') && ~isequal(IS, 'Total Oxides'), continue; end
                        if isequal(unmix_via, 'None'), continue; end
                        if isequal(unmix_via, 'Mixing ratio') && isnan(mixing_ratio_vec(unk)), continue; end

                        second_IS    = "";
                        second_IS_mf = [];
                        if isequal(unmix_via, 'Two internal standards')
                            second_IS    = app.base.project.session.spot.second_internal_standard_inclusion{bracket_idx,cal_idx}(unk);
                            second_IS_mf = app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion{bracket_idx,cal_idx}{unk};
                            if second_IS == "" || isempty(second_IS_mf) || startsWith(string(second_IS_mf), 'from'), continue; end
                        end

                        if all(app.base.project.session.spot.bkgd_corrected_cps_mix{unk,:} == 0), continue; end

                        % resolve IS intensity and mass fraction
                        if isequal(IS, 'Total Oxides') && isequal(unmix_via, 'Matrix-only tracer')
                            [IS_intensity, IS_mf, IS_name] = total_oxide_calculation_inclusion_MOT(app, bracket_idx, cal_idx, unk, elements_to_total);
                        else
                            IS_name      = IS;
                            IS_intensity = app.base.project.session.spot.bkgd_corrected_cps_incl.(char(IS_name))(unk);
                            IS_mf        = IS_mf_raw;
                        end

                        mass_fractions_inclusion = zeros(1, n_analytes);
                        mass_fractions_mix       = zeros(1, n_analytes);
                        mixing_ratio_unk         = 0;

                        if isequal(unmix_via, 'Matrix-only tracer')
                            matrix_only_tracer = app.base.project.session.spot.matrix_only_tracer(unk);

                            % inclusion mass fractions — always computed for valid cols (matches original)
                            cps_incl_row = table2array(app.base.project.session.spot.bkgd_corrected_cps_incl(unk, mot_sens_cols));
                            sens_row     = table2array(sensitivity_table(unk, mot_sens_cols));
                            mass_fractions_inclusion(mot_incl_positions) = (cps_incl_row ./ IS_intensity) .* (IS_mf ./ sens_row);

                            % mix computation only when tracer is in sensitivity (matches original)
                            if any(ismember(sensitivity_cols, matrix_only_tracer))

                                if isequal(app.base.project.session.spot.matrix_from_spot(unk), app.base.project.session.spot.name(unk))
                                    if isequal(sum(table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}(unk,:))), 0)
                                        uialert(app.UIFigure, {['The quantification for spot #' num2str(unk) ' for calibrator ' char(unique_CALs(cal_idx)) ' failed. Make sure that the host for this spot is quantified.']}, 'Warning');
                                        inclusion_quantification_failed = true; return
                                    end
                                    host_from_spot_index = unk;
                                else
                                    host_from_spot_index = find(strcmp(app.base.project.session.spot.name, app.base.project.session.spot.matrix_from_spot(unk)));
                                    if isequal(sum(table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}(host_from_spot_index,:))), 0)
                                        uialert(app.UIFigure, {['The quantification for spot #' num2str(unk) ' for calibrator ' char(unique_CALs(cal_idx)) ' failed. Make sure that the host ' num2str(host_from_spot_index) ' for this spot is quantified.']}, 'Warning');
                                        inclusion_quantification_failed = true; return
                                    end
                                end
                                mixing_ratio_unk = calculate_mixing_ratio_x_via_MOT(app, bracket_idx, cal_idx, unk, host_from_spot_index, IS_name, IS_mf, matrix_only_tracer);
                                matrix_mf_row    = table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}(host_from_spot_index, mot_sens_cols));
                                mass_fractions_mix(mot_incl_positions) = mass_fractions_inclusion(mot_incl_positions) .* mixing_ratio_unk + (1 - mixing_ratio_unk) .* matrix_mf_row;
                            end

                        elseif isequal(unmix_via, 'Two internal standards') && ~isempty(mix_sens_cols)

                            if isequal(app.base.project.session.spot.matrix_from_spot(unk), app.base.project.session.spot.name(unk))
                                if isequal(sum(table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}(unk,:))), 0)
                                    uialert(app.UIFigure, {['The quantification for spot #' num2str(unk) ' for calibrator ' char(unique_CALs(cal_idx)) ' failed. Make sure that the host for this spot is quantified.']}, 'Warning');
                                    inclusion_quantification_failed = true; return
                                end
                                host_from_spot_index = unk;
                            else
                                host_from_spot_index = find(strcmp(app.base.project.session.spot.name, app.base.project.session.spot.matrix_from_spot(unk)));
                                if isequal(sum(table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}(host_from_spot_index,:))), 0)
                                    uialert(app.UIFigure, {['The quantification for spot #' num2str(unk) ' for calibrator ' char(unique_CALs(cal_idx)) ' failed. Make sure that the host ' num2str(host_from_spot_index) ' for this spot is quantified.']}, 'Warning');
                                    inclusion_quantification_failed = true; return
                                end
                            end

                            mixing_ratio_unk       = calculate_mixing_ratio_via_two_IS(app, bracket_idx, cal_idx, unk, host_from_spot_index, IS_name, IS_mf);
                            intensity_mix_is2      = app.base.project.session.spot.bkgd_corrected_cps_mix.(char(second_IS))(unk);
                            mass_fraction_host_is2 = app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}.(char(second_IS))(host_from_spot_index);
                            mass_fraction_mix_is2  = (1 - mixing_ratio_unk) * mass_fraction_host_is2 + mixing_ratio_unk * second_IS_mf;
                            intensity_mix_row   = table2array(app.base.project.session.spot.bkgd_corrected_cps_mix(unk, mix_sens_cols));
                            sensitivity_is2_row = table2array(app.sensitivity_relative_to_second_internal_standard_inclusion{bracket_idx,cal_idx}(unk, mix_sens_cols));
                            matrix_host_row     = table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}(host_from_spot_index, mix_sens_cols));
                            mf_mix_row  = (intensity_mix_row ./ intensity_mix_is2) .* (mass_fraction_mix_is2 ./ sensitivity_is2_row);
                            mf_incl_row = (1 / mixing_ratio_unk) .* mf_mix_row - ((1 - mixing_ratio_unk) / mixing_ratio_unk) .* matrix_host_row;
                            mass_fractions_inclusion(mix_incl_positions) = mf_incl_row;
                            mass_fractions_mix(mix_incl_positions)       = mf_mix_row;


                        elseif isequal(unmix_via, 'Mixing ratio') && ~isempty(mix_sens_cols)

                            if isequal(app.base.project.session.spot.matrix_from_spot(unk), app.base.project.session.spot.name(unk))
                                if isequal(sum(table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}(unk,:))), 0)
                                    uialert(app.UIFigure, {['The quantification for spot #' num2str(unk) ' for calibrator ' char(unique_CALs(cal_idx)) ' failed. Make sure that the host for this spot is quantified.']}, 'Warning');
                                    inclusion_quantification_failed = true; return
                                end
                                host_from_spot_index = unk;
                            else
                                host_from_spot_index = find(strcmp(app.base.project.session.spot.name, app.base.project.session.spot.matrix_from_spot(unk)));
                                if isequal(sum(table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}(host_from_spot_index,:))), 0)
                                    uialert(app.UIFigure, {['The quantification for spot #' num2str(unk) ' for calibrator ' char(unique_CALs(cal_idx)) ' failed. Make sure that the host ' num2str(host_from_spot_index) ' for this spot is quantified.']}, 'Warning');
                                    inclusion_quantification_failed = true; return
                                end
                            end

                            mixing_ratio_unk       = mixing_ratio_vec(unk);
                            mass_fraction_host_is1 = app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}.(char(IS_name))(host_from_spot_index);
                            mass_fraction_mix_is1  = (1 - mixing_ratio_unk) * mass_fraction_host_is1 + mixing_ratio_unk * IS_mf;
                            intensity_mix_is1      = app.base.project.session.spot.bkgd_corrected_cps_mix.(char(IS_name))(unk);
                            intensity_mix_row      = table2array(app.base.project.session.spot.bkgd_corrected_cps_mix(unk, mix_sens_cols));
                            sensitivity_is1_row    = table2array(sensitivity_table(unk, mix_sens_cols));
                            matrix_host_row        = table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}(host_from_spot_index, mix_sens_cols));
                            mf_mix_row  = (intensity_mix_row ./ intensity_mix_is1) .* (mass_fraction_mix_is1 ./ sensitivity_is1_row);

                            mf_incl_row = (1 / mixing_ratio_unk) .* mf_mix_row - ((1 - mixing_ratio_unk) / mixing_ratio_unk) .* matrix_host_row;

                            mass_fractions_inclusion(mix_incl_positions) = mf_incl_row;
                            mass_fractions_mix(mix_incl_positions)       = mf_mix_row;

                        end

                        inclusion_composition_mat(unk,:) = mass_fractions_inclusion;
                        mixing_ratio_vec(unk)            = mixing_ratio_unk;
                        mix_composition_mat(unk,:)       = mass_fractions_mix;

                    end

                    app.base.project.session.spot.inclusion_composition{bracket_idx,cal_idx} = array2table(inclusion_composition_mat, 'VariableNames', incl_varnames);
                    app.base.project.session.spot.mixing_ratio{bracket_idx,cal_idx}          = mixing_ratio_vec;
                    app.base.project.session.spot.mix_composition{bracket_idx,cal_idx}       = array2table(mix_composition_mat, 'VariableNames', incl_varnames);
                end
            end

            % dynamic passes
            max_passes = length(unique_CALs);
            for pass_incl = 1:max_passes
                changes_made_incl = false;

                for cal_idx = 1:size(app.base.project.session.spot.sensitivities, 2)
                    for bracket_idx = 1:size(app.base.project.session.spot.sensitivities, 1)

                        if isempty(app.base.project.session.spot.sensitivities{bracket_idx,cal_idx}) || ...
                                isequal(app.base.project.session.spot.sensitivities{bracket_idx,cal_idx}, zeros(0,0))
                            continue
                        end

                        sensitivity_table = app.sensitivity_relative_to_internal_standard_inclusion{bracket_idx,cal_idx};
                        sensitivity_cols  = sensitivity_table.Properties.VariableNames;

                        [in_incl_table, incl_col_positions] = ismember(sensitivity_cols, incl_varnames);
                        in_mix_table = ismember(sensitivity_cols, mix_varnames);

                        mot_sens_cols      = sensitivity_cols(in_incl_table);
                        mot_incl_positions = incl_col_positions(in_incl_table);

                        mix_sens_cols      = sensitivity_cols(in_incl_table & in_mix_table);
                        mix_incl_positions = incl_col_positions(in_incl_table & in_mix_table);

                        elements_to_total = {};
                        any_total_oxides = any(strcmp(app.base.project.session.spot.internal_standard_inclusion{bracket_idx,cal_idx}(all_UNK), 'Total Oxides'));
                        if any_total_oxides
                            all_sens_cols = app.base.project.session.spot.sensitivities{bracket_idx,cal_idx}.Properties.VariableNames;
                            temp_elements = {};
                            for k = 1:length(all_sens_cols)
                                ename = all_sens_cols{k}(isstrprop(all_sens_cols{k}, 'alpha'));
                                if ismember(ename, element_names), temp_elements{end+1} = all_sens_cols{k}; end
                            end
                            for k = 1:length(element_names)
                                ename      = char(element_names(k));
                                candidates = temp_elements(cellfun(@(x) isequal(x(isstrprop(x,'alpha')), ename), temp_elements));
                                if ~isempty(candidates)
                                    pref = preferred_isotopes(k);
                                    if pref ~= "" && ~isempty(find(strcmp(candidates, pref), 1))
                                        elements_to_total{end+1} = char(pref);
                                    else
                                        elements_to_total{end+1} = candidates{1};
                                    end
                                end
                            end
                            elements_to_total = elements_to_total(:)';
                        end

                        inclusion_composition_mat = zeros(n_spots, n_analytes);
                        mix_composition_mat       = zeros(n_spots, n_analytes);

                        if numel(app.base.project.session.spot.mixing_ratio{bracket_idx, cal_idx}) == n_spots
                            mixing_ratio_vec = app.base.project.session.spot.mixing_ratio{bracket_idx, cal_idx};
                        else
                            mixing_ratio_vec = NaN(n_spots, 1);
                        end

                        for i = 1:numel(all_UNK)
                            unk       = all_UNK(i);
                            IS        = app.base.project.session.spot.internal_standard_inclusion{bracket_idx,cal_idx}(unk);
                            IS_mf_raw = app.base.project.session.spot.internal_standard_mass_fraction_inclusion{bracket_idx,cal_idx}{unk};
                            unmix_via = app.base.project.session.spot.unmixing_via(unk);

                            if IS == "", continue; end

                            second_IS    = "";
                            second_IS_mf = [];
                            if isequal(unmix_via, 'Two internal standards')
                                second_IS    = app.base.project.session.spot.second_internal_standard_inclusion{bracket_idx,cal_idx}(unk);
                                second_IS_mf = app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion{bracket_idx,cal_idx}{unk};
                            end

                            first_is_from  = ~isempty(IS_mf_raw) && startsWith(string(IS_mf_raw), 'from') && ~isequal(IS, 'Total Oxides');
                            second_is_from = second_IS ~= "" && ~isempty(second_IS_mf) && startsWith(string(second_IS_mf), 'from');

                            if first_is_from
                                % CASE 1: IS1 is 'from <CAL>'
                                source_cal_idx_1 = find(strcmp(unique_CALs, extractAfter(string(IS_mf_raw), 'from ')));
                                calculated_is_value_1 = 0;
                                if ~isempty(source_cal_idx_1) && ~isempty(app.base.project.session.spot.inclusion_composition{bracket_idx,source_cal_idx_1})
                                    calculated_is_value_1 = app.base.project.session.spot.inclusion_composition{bracket_idx,source_cal_idx_1}{unk, char(IS)};
                                end

                                calculated_is_value_2 = [];
                                if second_is_from
                                    source_cal_idx_2 = find(strcmp(unique_CALs, extractAfter(string(second_IS_mf), 'from ')));
                                    calculated_is_value_2 = 0;
                                    if ~isempty(source_cal_idx_2) && ~isempty(app.base.project.session.spot.inclusion_composition{bracket_idx,source_cal_idx_2})
                                        calculated_is_value_2 = app.base.project.session.spot.inclusion_composition{bracket_idx,source_cal_idx_2}{unk, char(second_IS)};
                                    end
                                end

                                if isequal(calculated_is_value_1, 0) || (second_is_from && (isempty(calculated_is_value_2) || isequal(calculated_is_value_2, 0)))
                                    inclusion_composition_mat(unk,:) = table2array(app.base.project.session.spot.inclusion_composition{bracket_idx,cal_idx}(unk,:));
                                    mixing_ratio_vec(unk)            = app.base.project.session.spot.mixing_ratio{bracket_idx,cal_idx}(unk);
                                    mix_composition_mat(unk,:)       = table2array(app.base.project.session.spot.mix_composition{bracket_idx,cal_idx}(unk,:));
                                    continue
                                end

                                old_values       = table2array(app.base.project.session.spot.inclusion_composition{bracket_idx,cal_idx}(unk,:));
                                original_IS_mf_1 = IS_mf_raw;
                                app.base.project.session.spot.internal_standard_mass_fraction_inclusion{bracket_idx,cal_idx}{unk} = calculated_is_value_1;
                                if second_is_from
                                    original_IS_mf_2 = second_IS_mf;
                                    app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion{bracket_idx,cal_idx}{unk} = calculated_is_value_2;
                                    second_IS_mf = calculated_is_value_2;
                                end

                                IS_name      = IS;
                                IS_intensity = app.base.project.session.spot.bkgd_corrected_cps_incl.(char(IS_name))(unk);
                                IS_mf        = calculated_is_value_1;

                                mass_fractions_inclusion = zeros(1, n_analytes);
                                mass_fractions_mix       = zeros(1, n_analytes);
                                mixing_ratio_unk         = 0;

                                if isequal(unmix_via, 'Matrix-only tracer')
                                    matrix_only_tracer = app.base.project.session.spot.matrix_only_tracer(unk);
                                    cps_incl_row = table2array(app.base.project.session.spot.bkgd_corrected_cps_incl(unk, mot_sens_cols));
                                    sens_row     = table2array(sensitivity_table(unk, mot_sens_cols));
                                    mass_fractions_inclusion(mot_incl_positions) = (cps_incl_row ./ IS_intensity) .* (IS_mf ./ sens_row);
                                    if any(ismember(sensitivity_cols, matrix_only_tracer))
                                        if isequal(app.base.project.session.spot.matrix_from_spot(unk), app.base.project.session.spot.name(unk))
                                            if isequal(sum(table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}(unk,:))), 0)
                                                uialert(app.UIFigure, {['The quantification for spot #' num2str(unk) ' for calibrator ' char(unique_CALs(cal_idx)) ' failed. Make sure that the host for this spot is quantified.']}, 'Warning');
                                                inclusion_quantification_failed = true; return
                                            end
                                            host_from_spot_index = unk;
                                        else
                                            host_from_spot_index = find(strcmp(app.base.project.session.spot.name, app.base.project.session.spot.matrix_from_spot(unk)));
                                            if isequal(sum(table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}(host_from_spot_index,:))), 0)
                                                uialert(app.UIFigure, {['The quantification for spot #' num2str(unk) ' for calibrator ' char(unique_CALs(cal_idx)) ' failed. Make sure that the host ' num2str(host_from_spot_index) ' for this spot is quantified.']}, 'Warning');
                                                inclusion_quantification_failed = true; return
                                            end
                                        end
                                        mixing_ratio_unk = calculate_mixing_ratio_x_via_MOT(app, bracket_idx, cal_idx, unk, host_from_spot_index, IS_name, IS_mf, matrix_only_tracer);
                                        matrix_mf_row    = table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}(host_from_spot_index, mot_sens_cols));
                                        mass_fractions_mix(mot_incl_positions) = mass_fractions_inclusion(mot_incl_positions) .* mixing_ratio_unk + (1 - mixing_ratio_unk) .* matrix_mf_row;
                                    end

                                elseif isequal(unmix_via, 'Two internal standards') && ~isempty(mix_sens_cols)
                                    if isequal(app.base.project.session.spot.matrix_from_spot(unk), app.base.project.session.spot.name(unk))
                                        if isequal(sum(table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}(unk,:))), 0)
                                            uialert(app.UIFigure, {['The quantification for spot #' num2str(unk) ' for calibrator ' char(unique_CALs(cal_idx)) ' failed. Make sure that the host for this spot is quantified.']}, 'Warning');
                                            inclusion_quantification_failed = true; return
                                        end
                                        host_from_spot_index = unk;
                                    else
                                        host_from_spot_index = find(strcmp(app.base.project.session.spot.name, app.base.project.session.spot.matrix_from_spot(unk)));
                                        if isequal(sum(table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}(host_from_spot_index,:))), 0)
                                            uialert(app.UIFigure, {['The quantification for spot #' num2str(unk) ' for calibrator ' char(unique_CALs(cal_idx)) ' failed. Make sure that the host ' num2str(host_from_spot_index) ' for this spot is quantified.']}, 'Warning');
                                            inclusion_quantification_failed = true; return
                                        end
                                    end
                                    mixing_ratio_unk       = calculate_mixing_ratio_via_two_IS(app, bracket_idx, cal_idx, unk, host_from_spot_index, IS_name, IS_mf);
                                    intensity_mix_is2      = app.base.project.session.spot.bkgd_corrected_cps_mix.(char(second_IS))(unk);
                                    mass_fraction_host_is2 = app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}.(char(second_IS))(host_from_spot_index);
                                    mass_fraction_mix_is2  = (1 - mixing_ratio_unk) * mass_fraction_host_is2 + mixing_ratio_unk * second_IS_mf;
                                    intensity_mix_row   = table2array(app.base.project.session.spot.bkgd_corrected_cps_mix(unk, mix_sens_cols));
                                    sensitivity_is2_row = table2array(app.sensitivity_relative_to_second_internal_standard_inclusion{bracket_idx,cal_idx}(unk, mix_sens_cols));
                                    matrix_host_row     = table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}(host_from_spot_index, mix_sens_cols));
                                    mf_mix_row  = (intensity_mix_row ./ intensity_mix_is2) .* (mass_fraction_mix_is2 ./ sensitivity_is2_row);
                                    mf_incl_row = (1 / mixing_ratio_unk) .* mf_mix_row - ((1 - mixing_ratio_unk) / mixing_ratio_unk) .* matrix_host_row;
                                    mass_fractions_inclusion(mix_incl_positions) = mf_incl_row;
                                    mass_fractions_mix(mix_incl_positions)       = mf_mix_row;

                                elseif isequal(unmix_via, 'Mixing ratio') && ~isempty(mix_sens_cols)

                                    if isequal(app.base.project.session.spot.matrix_from_spot(unk), app.base.project.session.spot.name(unk))
                                        if isequal(sum(table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}(unk,:))), 0)
                                            uialert(app.UIFigure, {['The quantification for spot #' num2str(unk) ' for calibrator ' char(unique_CALs(cal_idx)) ' failed. Make sure that the host for this spot is quantified.']}, 'Warning');
                                            inclusion_quantification_failed = true; return
                                        end
                                        host_from_spot_index = unk;
                                    else
                                        host_from_spot_index = find(strcmp(app.base.project.session.spot.name, app.base.project.session.spot.matrix_from_spot(unk)));
                                        if isequal(sum(table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}(host_from_spot_index,:))), 0)
                                            uialert(app.UIFigure, {['The quantification for spot #' num2str(unk) ' for calibrator ' char(unique_CALs(cal_idx)) ' failed. Make sure that the host ' num2str(host_from_spot_index) ' for this spot is quantified.']}, 'Warning');
                                            inclusion_quantification_failed = true; return
                                        end
                                    end

                                    mixing_ratio_unk       = mixing_ratio_vec(unk);
                                    mass_fraction_host_is1 = app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}.(char(IS_name))(host_from_spot_index);
                                    mass_fraction_mix_is1  = (1 - mixing_ratio_unk) * mass_fraction_host_is1 + mixing_ratio_unk * IS_mf;
                                    intensity_mix_is1      = app.base.project.session.spot.bkgd_corrected_cps_mix.(char(IS_name))(unk);
                                    intensity_mix_row      = table2array(app.base.project.session.spot.bkgd_corrected_cps_mix(unk, mix_sens_cols));
                                    sensitivity_is1_row    = table2array(sensitivity_table(unk, mix_sens_cols));
                                    matrix_host_row        = table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}(host_from_spot_index, mix_sens_cols));
                                    mf_mix_row  = (intensity_mix_row ./ intensity_mix_is1) .* (mass_fraction_mix_is1 ./ sensitivity_is1_row);

                                    mf_incl_row = (1 / mixing_ratio_unk) .* mf_mix_row - ((1 - mixing_ratio_unk) / mixing_ratio_unk) .* matrix_host_row;

                                    mass_fractions_inclusion(mix_incl_positions) = mf_incl_row;
                                    mass_fractions_mix(mix_incl_positions)       = mf_mix_row;

                                end

                                app.base.project.session.spot.internal_standard_mass_fraction_inclusion{bracket_idx,cal_idx}{unk} = original_IS_mf_1;
                                if second_is_from, app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion{bracket_idx,cal_idx}{unk} = original_IS_mf_2; end

                                inclusion_composition_mat(unk,:) = mass_fractions_inclusion;
                                mixing_ratio_vec(unk)            = mixing_ratio_unk;
                                mix_composition_mat(unk,:)       = mass_fractions_mix;

                                if any(abs(mass_fractions_inclusion - old_values) > 1e-10)
                                    changes_made_incl = true;
                                end

                            elseif second_is_from
                                % CASE 2: IS1 numeric, IS2 is 'from <CAL>'
                                source_cal_idx_2 = find(strcmp(unique_CALs, extractAfter(string(second_IS_mf), 'from ')));
                                calculated_is_value_2 = 0;
                                if ~isempty(source_cal_idx_2) && ~isempty(app.base.project.session.spot.inclusion_composition{bracket_idx,source_cal_idx_2})
                                    calculated_is_value_2 = app.base.project.session.spot.inclusion_composition{bracket_idx,source_cal_idx_2}{unk, char(second_IS)};
                                end

                                if isequal(calculated_is_value_2, 0)
                                    inclusion_composition_mat(unk,:) = table2array(app.base.project.session.spot.inclusion_composition{bracket_idx,cal_idx}(unk,:));
                                    mixing_ratio_vec(unk)            = app.base.project.session.spot.mixing_ratio{bracket_idx,cal_idx}(unk);
                                    mix_composition_mat(unk,:)       = table2array(app.base.project.session.spot.mix_composition{bracket_idx,cal_idx}(unk,:));
                                    continue
                                end

                                old_values       = table2array(app.base.project.session.spot.inclusion_composition{bracket_idx,cal_idx}(unk,:));
                                original_IS_mf_2 = second_IS_mf;
                                app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion{bracket_idx,cal_idx}{unk} = calculated_is_value_2;
                                second_IS_mf = calculated_is_value_2;

                                IS_name      = IS;
                                IS_intensity = app.base.project.session.spot.bkgd_corrected_cps_incl.(char(IS_name))(unk);
                                IS_mf        = IS_mf_raw;

                                mass_fractions_inclusion = zeros(1, n_analytes);
                                mass_fractions_mix       = zeros(1, n_analytes);
                                mixing_ratio_unk         = 0;

                                if isequal(unmix_via, 'Matrix-only tracer')
                                    matrix_only_tracer = app.base.project.session.spot.matrix_only_tracer(unk);
                                    cps_incl_row = table2array(app.base.project.session.spot.bkgd_corrected_cps_incl(unk, mot_sens_cols));
                                    sens_row     = table2array(sensitivity_table(unk, mot_sens_cols));
                                    mass_fractions_inclusion(mot_incl_positions) = (cps_incl_row ./ IS_intensity) .* (IS_mf ./ sens_row);
                                    if any(ismember(sensitivity_cols, matrix_only_tracer))
                                        if isequal(app.base.project.session.spot.matrix_from_spot(unk), app.base.project.session.spot.name(unk))
                                            if isequal(sum(table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}(unk,:))), 0)
                                                uialert(app.UIFigure, {['The quantification for spot #' num2str(unk) ' for calibrator ' char(unique_CALs(cal_idx)) ' failed. Make sure that the host for this spot is quantified.']}, 'Warning');
                                                inclusion_quantification_failed = true; return
                                            end
                                            host_from_spot_index = unk;
                                        else
                                            host_from_spot_index = find(strcmp(app.base.project.session.spot.name, app.base.project.session.spot.matrix_from_spot(unk)));
                                            if isequal(sum(table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}(host_from_spot_index,:))), 0)
                                                uialert(app.UIFigure, {['The quantification for spot #' num2str(unk) ' for calibrator ' char(unique_CALs(cal_idx)) ' failed. Make sure that the host ' num2str(host_from_spot_index) ' for this spot is quantified.']}, 'Warning');
                                                inclusion_quantification_failed = true; return
                                            end
                                        end
                                        mixing_ratio_unk = calculate_mixing_ratio_x_via_MOT(app, bracket_idx, cal_idx, unk, host_from_spot_index, IS_name, IS_mf, matrix_only_tracer);
                                        matrix_mf_row    = table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}(host_from_spot_index, mot_sens_cols));
                                        mass_fractions_mix(mot_incl_positions) = mass_fractions_inclusion(mot_incl_positions) .* mixing_ratio_unk + (1 - mixing_ratio_unk) .* matrix_mf_row;
                                    end

                                elseif isequal(unmix_via, 'Two internal standards') && ~isempty(mix_sens_cols)
                                    if isequal(app.base.project.session.spot.matrix_from_spot(unk), app.base.project.session.spot.name(unk))
                                        if isequal(sum(table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}(unk,:))), 0)
                                            uialert(app.UIFigure, {['The quantification for spot #' num2str(unk) ' for calibrator ' char(unique_CALs(cal_idx)) ' failed. Make sure that the host for this spot is quantified.']}, 'Warning');
                                            inclusion_quantification_failed = true; return
                                        end
                                        host_from_spot_index = unk;
                                    else
                                        host_from_spot_index = find(strcmp(app.base.project.session.spot.name, app.base.project.session.spot.matrix_from_spot(unk)));
                                        if isequal(sum(table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}(host_from_spot_index,:))), 0)
                                            uialert(app.UIFigure, {['The quantification for spot #' num2str(unk) ' for calibrator ' char(unique_CALs(cal_idx)) ' failed. Make sure that the host ' num2str(host_from_spot_index) ' for this spot is quantified.']}, 'Warning');
                                            inclusion_quantification_failed = true; return
                                        end
                                    end
                                    mixing_ratio_unk       = calculate_mixing_ratio_via_two_IS(app, bracket_idx, cal_idx, unk, host_from_spot_index, IS_name, IS_mf);
                                    intensity_mix_is2      = app.base.project.session.spot.bkgd_corrected_cps_mix.(char(second_IS))(unk);
                                    mass_fraction_host_is2 = app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}.(char(second_IS))(host_from_spot_index);
                                    mass_fraction_mix_is2  = (1 - mixing_ratio_unk) * mass_fraction_host_is2 + mixing_ratio_unk * second_IS_mf;
                                    intensity_mix_row   = table2array(app.base.project.session.spot.bkgd_corrected_cps_mix(unk, mix_sens_cols));
                                    sensitivity_is2_row = table2array(app.sensitivity_relative_to_second_internal_standard_inclusion{bracket_idx,cal_idx}(unk, mix_sens_cols));
                                    matrix_host_row     = table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}(host_from_spot_index, mix_sens_cols));
                                    mf_mix_row  = (intensity_mix_row ./ intensity_mix_is2) .* (mass_fraction_mix_is2 ./ sensitivity_is2_row);
                                    mf_incl_row = (1 / mixing_ratio_unk) .* mf_mix_row - ((1 - mixing_ratio_unk) / mixing_ratio_unk) .* matrix_host_row;
                                    mass_fractions_inclusion(mix_incl_positions) = mf_incl_row;
                                    mass_fractions_mix(mix_incl_positions)       = mf_mix_row;
                                end

                                app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion{bracket_idx,cal_idx}{unk} = original_IS_mf_2;

                                inclusion_composition_mat(unk,:) = mass_fractions_inclusion;
                                mixing_ratio_vec(unk)            = mixing_ratio_unk;
                                mix_composition_mat(unk,:)       = mass_fractions_mix;

                                if any(abs(mass_fractions_inclusion - old_values) > 1e-10)
                                    changes_made_incl = true;
                                end

                            else
                                % CASE 3: no 'from' — keep existing values
                                inclusion_composition_mat(unk,:) = table2array(app.base.project.session.spot.inclusion_composition{bracket_idx,cal_idx}(unk,:));
                                mixing_ratio_vec(unk)            = app.base.project.session.spot.mixing_ratio{bracket_idx,cal_idx}(unk);
                                mix_composition_mat(unk,:)       = table2array(app.base.project.session.spot.mix_composition{bracket_idx,cal_idx}(unk,:));
                            end
                        end

                        app.base.project.session.spot.inclusion_composition{bracket_idx,cal_idx} = array2table(inclusion_composition_mat, 'VariableNames', incl_varnames);
                        app.base.project.session.spot.mixing_ratio{bracket_idx,cal_idx}          = mixing_ratio_vec;
                        app.base.project.session.spot.mix_composition{bracket_idx,cal_idx}       = array2table(mix_composition_mat, 'VariableNames', incl_varnames);
                    end
                end

                if ~changes_made_incl
                    break
                end
            end
        end

        %%%%%%%%%%%%%%%% Total Oxides %%%%%%%%%%%%%%%%%%%%%

        function get_oxides_from_file(app)

            if isfield(app.base.project.session, 'oxides')
                app.base.project.session = rmfield(app.base.project.session, 'oxides');
            end

            try
                oxide_file = dir(fullfile(app.base.project.session.config.total_oxides_path, 'Oxides.csv'));
                filePath   = fullfile(app.base.project.session.config.total_oxides_path, oxide_file.name);
                opts       = detectImportOptions(filePath);
                raw        = readtable(filePath, opts);
            catch ME
                DisplayError(ME, 'Error reading oxides from Oxides.csv. Close it if it is open in another program. Make sure the Total Oxide folder was not moved or renamed.')
                message = {'Error reading oxides from Oxides.csv. Did you rename or move the folder? Close the Oxides.csv if it is open in another program. If you got the base/project/session from someone else, adjust the total oxides folder path.'};
                uialert(app.UIFigure, message, ' Error');
            end

            element_names      = raw(:, 1);
            oxide_names        = raw(:, 2);
            conversion_factors = raw(:, 3);
            preferred_isotope  = raw(:, 4);
            considered_major   = raw(:, 5);

            app.base.project.session.oxides.conversion_factor_values   = double(conversion_factors.Variables);
            app.base.project.session.oxides.oxide_names                = string(oxide_names.Variables);
            app.base.project.session.oxides.element_names              = string(element_names.Variables);
            app.base.project.session.oxides.preferred_isotopes         = string(preferred_isotope.Variables);
            app.base.project.session.oxides.considered_major           = string(considered_major.Variables);

        end

        function [intstd_elements_intensity, internal_standard_mass_fraction, intstd_elements_name] = total_oxide_calculation(app, bracket_idx, cal_idx, unk, elements_to_total)

            ox_elements = app.base.project.session.oxides.element_names;
            ox_values   = app.base.project.session.oxides.conversion_factor_values;

            orig_elements = elements_to_total;   % isotope names, before Fe2O3 is appended/renamed

            % Step 1: Preliminary normalized mass fractions relative to internal standard
            sensitivity               = table2array(app.base.project.session.spot.sensitivities{bracket_idx, cal_idx}(unk, elements_to_total));
            intensity                 = table2array(app.base.project.session.spot.bkgd_corrected_cps(unk, elements_to_total));
            preliminary_mass_fraction = max(intensity, 0) ./ sensitivity;

            intstd_elements_name     = app.internal_standard_name_total_oxides{bracket_idx, cal_idx}{unk};
            intstd_element_idx       = find(strcmp(elements_to_total, intstd_elements_name), 1);
            normalized_mass_fraction = preliminary_mass_fraction ./ preliminary_mass_fraction(intstd_element_idx);

            % Step 2: Handle Fe2+/Fe3+ partitioning if FeO is in the oxide list
            if any(contains(app.base.project.session.oxides.oxide_names, 'FeO')) && any(contains(elements_to_total, 'Fe'))
                fe_idx   = find(contains(elements_to_total, 'Fe'));
                fe_ratio = app.base.project.session.spot.Fe_ratio_for_total_oxide{bracket_idx, cal_idx}(unk);

                if ~isnan(fe_ratio) && ~isequal(fe_ratio, 1) && any(fe_idx)
                    fe_total    = normalized_mass_fraction(fe_idx);
                    fe_constant = 0.699480 / 0.777314;

                    fe2o3_fraction = fe_total * (1 - (1 / (1 + fe_constant * ((1 - fe_ratio) / fe_ratio))));
                    feo_fraction   = fe_total * (1 / (1 + fe_constant * ((1 - fe_ratio) / fe_ratio)));

                    normalized_mass_fraction(fe_idx) = feo_fraction;
                    normalized_mass_fraction         = [normalized_mass_fraction fe2o3_fraction];
                    elements_to_total                = [elements_to_total {'Fe2O3'}];
                end
            end

            % Step 3: Convert normalized mass fractions to oxide wt%
            oxide_wt_percent = zeros(size(normalized_mass_fraction));
            for j = 1:length(elements_to_total)
                element      = elements_to_total{j};
                base_element = regexp(element, '^[A-Za-z]+', 'match');
                if ~isempty(base_element) && ismember(base_element{1}, ox_elements) && ~strcmp(element, 'Fe2O3')
                    oxide_wt_percent(j) = normalized_mass_fraction(j) * ox_values(ox_elements == string(base_element{1}));
                elseif strcmp(element, 'Fe2O3')
                    oxide_wt_percent(j) = normalized_mass_fraction(j) * 1.4297;
                end
            end

            % Step 4: Normalize to user-defined total oxide wt%
            if ~isnan(app.base.project.session.spot.Fe_ratio_for_total_oxide{bracket_idx, cal_idx}(unk))
                std_value = app.base.project.session.spot.internal_standard_oxide_wt{bracket_idx, cal_idx}(unk);
                if ~isnan(std_value)
                    oxide_wt_percent = oxide_wt_percent * (std_value / sum(oxide_wt_percent));
                end
            end

            % Step 5: Convert oxide wt% back to µg/g element concentrations
            mass_fractions_ugg = zeros(size(oxide_wt_percent));
            for j = 1:length(elements_to_total)
                element      = elements_to_total{j};
                base_element = regexp(element, '^[A-Za-z]+', 'match');
                if ~isempty(base_element)
                    if contains(element, 'Fe') && ~strcmp(element, 'Fe2O3')
                        mass_fractions_ugg(j) = (oxide_wt_percent(j) / ox_values(ox_elements == "Fe")) * 10000;
                    elseif strcmp(element, 'Fe2O3')
                        mass_fractions_ugg(j)  = (oxide_wt_percent(j) / 1.4297) * 10000;
                        elements_to_total{j}   = 'Fe3';
                    elseif ismember(base_element{1}, ox_elements)
                        mass_fractions_ugg(j) = (oxide_wt_percent(j) / ox_values(ox_elements == string(base_element{1}))) * 10000;
                    end
                end
            end

            % Single-row table for named column access in Fe2/Fe3 handling below
            mass_fractions = array2table(mass_fractions_ugg, 'VariableNames', elements_to_total);

            % Store Fe2+/Fe3+ split if applicable
            if any(contains(app.base.project.session.oxides.oxide_names, 'FeO')) && any(contains(elements_to_total, 'Fe'))
                fe_col = find(contains(mass_fractions.Properties.VariableNames, 'Fe') & ...
                    ~strcmp(mass_fractions.Properties.VariableNames, 'Fe2') & ...
                    ~strcmp(mass_fractions.Properties.VariableNames, 'Fe3'));

                mass_fractions.Fe2 = table2array(mass_fractions(:, fe_col));

                if any(contains(mass_fractions.Properties.VariableNames, 'Fe3'))
                    mass_fractions{:, fe_col} = mass_fractions.Fe2 + mass_fractions.Fe3;
                end

                if ~isfield(app.base.project.session.spot, 'Fe_2_3')
                    app.base.project.session.spot.Fe_2_3 = cell(size(app.base.project.session.spot.sensitivities));
                end

                if isempty(app.base.project.session.spot.Fe_2_3{bracket_idx, cal_idx})
                    num_rows = size(app.base.project.session.spot.bkgd_corrected_cps, 1);
                    app.base.project.session.spot.Fe_2_3{bracket_idx, cal_idx} = array2table(zeros(num_rows, 2), 'VariableNames', {'Fe2', 'Fe3'});
                end

                if ismember('Fe2', mass_fractions.Properties.VariableNames)
                    app.base.project.session.spot.Fe_2_3{bracket_idx, cal_idx}.Fe2(unk) = mass_fractions.Fe2(1);
                else
                    app.base.project.session.spot.Fe_2_3{bracket_idx, cal_idx}.Fe2(unk) = 0;
                end

                if ismember('Fe3', mass_fractions.Properties.VariableNames)
                    app.base.project.session.spot.Fe_2_3{bracket_idx, cal_idx}.Fe3(unk) = mass_fractions.Fe3(1);
                else
                    app.base.project.session.spot.Fe_2_3{bracket_idx, cal_idx}.Fe3(unk) = 0;
                end

                mass_fractions.Fe2 = [];
                if any(contains(mass_fractions.Properties.VariableNames, 'Fe3'))
                    mass_fractions.Fe3 = [];
                end
            end

            intstd_elements_intensity       = app.base.project.session.spot.bkgd_corrected_cps.(intstd_elements_name)(unk);
            internal_standard_mass_fraction = mass_fractions.(intstd_elements_name)(1);

            % ---- stash the closure-propagation inputs (only when uncertainty is on) ----
            if isequal(app.PropagateuncertaintiesMenu.Checked, 'on')

                fe_constant = 0.699480 / 0.777314;
                fe_ratio    = app.base.project.session.spot.Fe_ratio_for_total_oxide{bracket_idx, cal_idx}(unk);
                c_Fe        = ox_values(ox_elements == "Fe");

                fe_is_split = any(contains(app.base.project.session.oxides.oxide_names, 'FeO')) && ...
                    ~isnan(fe_ratio) && ~isequal(fe_ratio, 1);

                % effective oxide factor per original major (Fe folded to FeO+Fe2O3)
                c_eff = zeros(1, numel(orig_elements));
                for j = 1:numel(orig_elements)
                    element      = orig_elements{j};
                    base_element = regexp(element, '^[A-Za-z]+', 'match', 'once');
                    if contains(element, 'Fe')
                        if fe_is_split
                            a        = 1 / (1 + fe_constant * ((1 - fe_ratio) / fe_ratio));
                            c_eff(j) = a * c_Fe + (1 - a) * 1.4297;
                        else
                            c_eff(j) = c_Fe;                              % all FeO
                        end
                    else
                        c_eff(j) = ox_values(ox_elements == string(base_element));
                    end
                end

                terms.major_names = orig_elements;                       % isotope names matching table columns
                terms.p           = preliminary_mass_fraction;           % p_n = max(I,0)/S over the majors
                terms.c_eff       = c_eff;                                % effective oxide factors
                terms.D           = sum(terms.p .* c_eff);               % closure sum  D = Σ p_n·c_eff
                terms.T           = 1e4 * app.base.project.session.spot.internal_standard_oxide_wt{bracket_idx, cal_idx}(unk);

                if isempty(app.total_oxide_terms)
                    app.total_oxide_terms = cell(size(app.base.project.session.spot.sensitivities));
                end
                app.total_oxide_terms{bracket_idx, cal_idx}{unk} = terms;

            end

        end

        function [intstd_elements_intensity, internal_standard_mass_fraction, intstd_elements_name] = total_oxide_calculation_inclusion_MOT(app, bracket_idx, cal_idx, unk, elements_to_total)

            ox_elements = app.base.project.session.oxides.element_names;
            ox_values   = app.base.project.session.oxides.conversion_factor_values;
            original_element_names = elements_to_total;   % isotope names, before Fe2O3 is appended/renamed

            % Step 1
            sensitivity               = table2array(app.base.project.session.spot.sensitivities{bracket_idx,cal_idx}(unk, elements_to_total));
            intensity                 = table2array(app.base.project.session.spot.bkgd_corrected_cps_incl(unk, elements_to_total));
            preliminary_mass_fraction = max(intensity, 0) ./ sensitivity;

            intstd_elements_name     = app.internal_standard_name_total_oxides_inclusion{bracket_idx,cal_idx}{unk};
            intstd_element_index     = find(strcmp(elements_to_total, intstd_elements_name), 1);
            normalized_mass_fraction = preliminary_mass_fraction ./ preliminary_mass_fraction(intstd_element_index);

            % Step 2 — Fe ratio
            if any(contains(app.base.project.session.oxides.oxide_names, 'FeO')) && any(contains(elements_to_total, 'Fe'))
                fe_idx   = find(contains(elements_to_total, 'Fe'));
                fe_ratio = app.base.project.session.spot.Fe_ratio_for_total_oxide_inclusion{bracket_idx,cal_idx}(unk);
                if ~isnan(fe_ratio) && ~isequal(fe_ratio, 1) && any(fe_idx)
                    fe_constant    = 0.699480 / 0.777314;
                    fe_total       = normalized_mass_fraction(fe_idx);
                    feo_fraction   = fe_total * (1 / (1 + fe_constant * ((1 - fe_ratio) / fe_ratio)));
                    fe2o3_fraction = fe_total * (1 - (1 / (1 + fe_constant * ((1 - fe_ratio) / fe_ratio))));
                    normalized_mass_fraction(fe_idx) = feo_fraction;
                    normalized_mass_fraction         = [normalized_mass_fraction fe2o3_fraction];
                    elements_to_total                = [elements_to_total {'Fe2O3'}];
                end
            end

            % Step 3 — oxide wt%
            oxide_wt_percent = zeros(size(normalized_mass_fraction));
            for j = 1:length(elements_to_total)
                element      = elements_to_total{j};
                base_element = regexp(element, '^[A-Za-z]+', 'match');
                if ~isempty(base_element) && ismember(base_element{1}, ox_elements) && ~strcmp(element, 'Fe2O3')
                    oxide_wt_percent(j) = normalized_mass_fraction(j) * ox_values(ox_elements == string(base_element{1}));
                elseif strcmp(element, 'Fe2O3')
                    oxide_wt_percent(j) = normalized_mass_fraction(j) * 1.4297;
                end
            end

            % Step 4 — normalize to standard
            if ~isnan(app.base.project.session.spot.Fe_ratio_for_total_oxide_inclusion{bracket_idx,cal_idx}(unk))
                std_value = app.base.project.session.spot.internal_standard_oxide_wt_inclusion{bracket_idx,cal_idx}(unk);
                if ~isnan(std_value)
                    oxide_wt_percent = oxide_wt_percent * (std_value / sum(oxide_wt_percent));
                end
            end

            % Step 5 — convert to ug/g
            mass_fractions_ugg = zeros(size(oxide_wt_percent));
            for j = 1:length(elements_to_total)
                element      = elements_to_total{j};
                base_element = regexp(element, '^[A-Za-z]+', 'match');
                if ~isempty(base_element)
                    if contains(element, 'Fe') && ~strcmp(element, 'Fe2O3')
                        mass_fractions_ugg(j) = (oxide_wt_percent(j) / ox_values(ox_elements == "Fe")) * 10000;
                    elseif strcmp(element, 'Fe2O3')
                        mass_fractions_ugg(j)   = (oxide_wt_percent(j) / 1.4297) * 10000;
                        elements_to_total{j}    = 'Fe3';
                    elseif ismember(base_element{1}, ox_elements)
                        mass_fractions_ugg(j) = (oxide_wt_percent(j) / ox_values(ox_elements == string(base_element{1}))) * 10000;
                    end
                end
            end

            % single-row table
            mass_fractions = array2table(mass_fractions_ugg, 'VariableNames', elements_to_total);

            % Fe2/Fe3 handling
            if any(contains(app.base.project.session.oxides.oxide_names, 'FeO')) && any(contains(elements_to_total, 'Fe'))
                fe_col = find(contains(mass_fractions.Properties.VariableNames, 'Fe') & ...
                    ~strcmp(mass_fractions.Properties.VariableNames, 'Fe2') & ...
                    ~strcmp(mass_fractions.Properties.VariableNames, 'Fe3'));
                mass_fractions.Fe2 = table2array(mass_fractions(:, fe_col));
                if any(contains(mass_fractions.Properties.VariableNames, 'Fe3'))
                    mass_fractions{:, fe_col} = mass_fractions.Fe2 + mass_fractions.Fe3;
                end

                if ~isfield(app.base.project.session.spot, 'Fe_2_3_incl')
                    app.base.project.session.spot.Fe_2_3_incl = cell(size(app.base.project.session.spot.sensitivities));
                end
                if isempty(app.base.project.session.spot.Fe_2_3_incl{bracket_idx,cal_idx})
                    num_rows = size(app.base.project.session.spot.bkgd_corrected_cps_incl, 1);
                    app.base.project.session.spot.Fe_2_3_incl{bracket_idx,cal_idx} = array2table(zeros(num_rows, 2), 'VariableNames', {'Fe2','Fe3'});
                end
                if any(ismember(mass_fractions.Properties.VariableNames, 'Fe2'))
                    app.base.project.session.spot.Fe_2_3_incl{bracket_idx,cal_idx}.Fe2(unk) = mass_fractions.Fe2(1);
                end
                if any(ismember(mass_fractions.Properties.VariableNames, 'Fe3'))
                    app.base.project.session.spot.Fe_2_3_incl{bracket_idx,cal_idx}.Fe3(unk) = mass_fractions.Fe3(1);
                end
                mass_fractions.Fe2 = [];
                if any(contains(mass_fractions.Properties.VariableNames, 'Fe3'))
                    mass_fractions.Fe3 = [];
                end
            end

            intstd_elements_intensity       = app.base.project.session.spot.bkgd_corrected_cps_incl.(intstd_elements_name)(unk);
            internal_standard_mass_fraction = mass_fractions.(intstd_elements_name)(1);

            % stash the closure inputs for the uncertainty propagation (only when it is switched on)
            if isequal(app.PropagateuncertaintiesMenu.Checked, 'on')

                iron_constant        = 0.699480 / 0.777314;
                iron_oxidation_ratio = app.base.project.session.spot.Fe_ratio_for_total_oxide_inclusion{bracket_idx, cal_idx}(unk);
                iron_oxide_factor    = ox_values(ox_elements == "Fe");

                iron_is_split = any(contains(app.base.project.session.oxides.oxide_names, 'FeO')) && ...
                    ~isnan(iron_oxidation_ratio) && ~isequal(iron_oxidation_ratio, 1);

                % effective oxide factor per major element (iron is folded into FeO and Fe2O3)
                effective_oxide_factors = zeros(1, numel(original_element_names));
                for element_number = 1:numel(original_element_names)
                    element_name = original_element_names{element_number};
                    base_element = regexp(element_name, '^[A-Za-z]+', 'match', 'once');

                    if contains(element_name, 'Fe')
                        if iron_is_split
                            feo_share = 1 / (1 + iron_constant * ((1 - iron_oxidation_ratio) / iron_oxidation_ratio));
                            effective_oxide_factors(element_number) = feo_share * iron_oxide_factor + (1 - feo_share) * 1.4297;
                        else
                            effective_oxide_factors(element_number) = iron_oxide_factor;
                        end
                    else
                        effective_oxide_factors(element_number) = ox_values(ox_elements == string(base_element));
                    end
                end

                closure_terms.major_names = original_element_names;
                closure_terms.p           = preliminary_mass_fraction;
                closure_terms.c_eff       = effective_oxide_factors;
                closure_terms.D           = sum(closure_terms.p .* closure_terms.c_eff);
                closure_terms.T           = 1e4 * app.base.project.session.spot.internal_standard_oxide_wt_inclusion{bracket_idx, cal_idx}(unk);

                if isempty(app.total_oxide_terms_inclusion)
                    app.total_oxide_terms_inclusion = cell(size(app.base.project.session.spot.sensitivities));
                end
                app.total_oxide_terms_inclusion{bracket_idx, cal_idx}{unk} = closure_terms;
            end
        end

        %%%%%%%%%%%%%%%% Mixing ratio and mix/inclusion mass fraction calculations %%%%%%%%%%%%%%%%%%%%%

        function mixing_ratio = calculate_mixing_ratio_x_via_MOT(app, bracket_idx, cal_idx, unk, host_from_spot_index, internal_standard_name, internal_standard_mass_fraction, matrix_only_tracer)

            relative_sensitivity = app.sensitivity_relative_to_internal_standard_inclusion{bracket_idx,cal_idx}.(char(matrix_only_tracer))(unk);

            Cishost = app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}.(char(internal_standard_name))(host_from_spot_index);
            Cthost  = app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}.(char(matrix_only_tracer))(host_from_spot_index);
            Cisinc  = internal_standard_mass_fraction;

            Iismix = app.base.project.session.spot.bkgd_corrected_cps_mix.(char(internal_standard_name))(unk);
            Itmix  = app.base.project.session.spot.bkgd_corrected_cps_mix.(char(matrix_only_tracer))(unk);

            cr = (Itmix/Iismix)/relative_sensitivity;

            mixing_ratio = (Cthost - cr*Cishost)/(Cthost - cr*Cishost + cr*Cisinc);

        end

        function mass_fractions_mix = calculate_mix_mass_fractions_via_MOT(app, bracket_idx, cal_idx, unk, host_from_spot_index, col_idx, mixing_ratio, mass_fractions_inclusion)

            matrix_mass_fraction = app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}{host_from_spot_index, col_idx};

            inclusion_mass_fraction = mass_fractions_inclusion(col_idx);

            x = mixing_ratio(unk);

            mass_fractions_mix = inclusion_mass_fraction * x + (1 - x) * matrix_mass_fraction;

        end

        function mixing_ratio = calculate_mixing_ratio_via_two_IS(app, bracket_idx, cal_idx, unk, host_from_spot_index, internal_standard_name, internal_standard_mass_fraction)

            second_internal_standard_name            = app.base.project.session.spot.second_internal_standard_inclusion{bracket_idx,cal_idx}(unk);
            second_internal_standard_mass_fraction   = app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion{bracket_idx,cal_idx}{unk};

            intensity_mix_is1 = app.base.project.session.spot.bkgd_corrected_cps_mix.(char(internal_standard_name))(unk);
            intensity_mix_is2 = app.base.project.session.spot.bkgd_corrected_cps_mix.(char(second_internal_standard_name))(unk);

            mass_fraction_host_is1 = app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}.(char(internal_standard_name))(host_from_spot_index);
            mass_fraction_host_is2 = app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}.(char(second_internal_standard_name))(host_from_spot_index);

            sensitivity_of_is1_relative_to_is2 = app.sensitivity_relative_to_second_internal_standard_inclusion{bracket_idx,cal_idx}.(char(internal_standard_name))(unk);

            a_mix_is1_is2 = (intensity_mix_is1 / intensity_mix_is2) * (1 / sensitivity_of_is1_relative_to_is2);

            mixing_ratio = (mass_fraction_host_is1 - a_mix_is1_is2 * mass_fraction_host_is2) / ...
                (mass_fraction_host_is1 - internal_standard_mass_fraction - a_mix_is1_is2 * mass_fraction_host_is2 + a_mix_is1_is2 * second_internal_standard_mass_fraction);

        end

        function [mass_fraction_incl_i, mass_fraction_mix_i] = calculate_mass_fractions_via_two_IS(app, bracket_idx, cal_idx, unk, host_from_spot_index, col, col_idx, mixing_ratio)

            second_internal_standard_name          = app.base.project.session.spot.second_internal_standard_inclusion{bracket_idx,cal_idx}(unk);
            second_internal_standard_mass_fraction = app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion{bracket_idx,cal_idx}{unk};

            intensity_mix_is2      = app.base.project.session.spot.bkgd_corrected_cps_mix.(char(second_internal_standard_name))(unk);
            mass_fraction_host_is2 = app.base.project.session.spot.matrix_composition{bracket_idx, cal_idx}.(char(second_internal_standard_name))(host_from_spot_index);

            intensity_mix_i                  = app.base.project.session.spot.bkgd_corrected_cps_mix{unk, col_idx};
            sensitivity_of_i_relative_to_is2 = app.sensitivity_relative_to_second_internal_standard_inclusion{bracket_idx,cal_idx}{unk, col};
            mass_fraction_host_i             = app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx}{host_from_spot_index, col_idx};

            mass_fraction_mix_is2 = (1 - mixing_ratio(unk)) * mass_fraction_host_is2 + mixing_ratio(unk) * second_internal_standard_mass_fraction;

            mass_fraction_mix_i = (intensity_mix_i / intensity_mix_is2) * (mass_fraction_mix_is2 / sensitivity_of_i_relative_to_is2);

            mass_fraction_incl_i = (1 / mixing_ratio(unk)) * mass_fraction_mix_i - ((1 - mixing_ratio(unk)) / mixing_ratio(unk)) * mass_fraction_host_i;

        end

        %%%%%%%%%%%%%%%% Limits of Detection %%%%%%%%%%%%%%%%%%%%%

        function user_stopped_lod_calc = calculate_all_inclusion_limits_of_detection(app)

            user_stopped_lod_calc = false;

            if ~isequal(app.base.project.session.config.reductiontype, 'Inclusion')
                return
            end

            all_UNK  = find(app.base.project.session.spot.type ~= "CAL");
            nRows    = length(app.base.project.session.spot.signal_starts);
            varNames = app.base.project.session.spot.bkgd_corrected_cps_incl.Properties.VariableNames;
            n_vars   = numel(varNames);

            unique_CALs = unique(app.base.project.session.spot.referencematerial);
            unique_CALs = unique_CALs(unique_CALs ~= "None");

            for cal_idx = 1:size(app.base.project.session.spot.sensitivities, 2)
                for bracket_idx = 1:size(app.base.project.session.spot.sensitivities, 1)

                    sensitivities = app.base.project.session.spot.sensitivities{bracket_idx,cal_idx};
                    if isempty(sensitivities) || isequal(sensitivities, zeros(0,0))
                        app.base.project.session.spot.inclusion_limits_of_detection{bracket_idx,cal_idx} = zeros(0,0);
                        continue
                    end

                    mix_composition = app.base.project.session.spot.mix_composition{bracket_idx,cal_idx};
                    if all(mix_composition{:,:} == 0)
                        % existing warning logic
                        app.base.project.session.spot.inclusion_limits_of_detection{bracket_idx,cal_idx} = ...
                            array2table(zeros(nRows, n_vars), 'VariableNames', varNames);
                        continue
                    end

                    sensitivity_table = app.sensitivity_relative_to_internal_standard_inclusion{bracket_idx,cal_idx};
                    sensitivity_cols  = sensitivity_table.Properties.VariableNames;

                    [in_var_table, var_col_positions] = ismember(sensitivity_cols, varNames);
                    valid_sens_cols     = sensitivity_cols(in_var_table);
                    valid_var_positions = var_col_positions(in_var_table);

                    % dwelltimes — once per bracket/cal
                    dwelltimes = cellfun(@(c) app.base.project.session.spot.dwelltimes.(c), valid_sens_cols);

                    lod_mat = zeros(nRows, n_vars);

                    for i = 1:numel(all_UNK)
                        unk = all_UNK(i);

                        if app.base.project.session.spot.internal_standard_inclusion{bracket_idx,cal_idx}(unk) == "", continue; end
                        if app.base.project.session.spot.unmixing_via(unk) == "Two internal standards"
                            if app.base.project.session.spot.second_internal_standard_inclusion{bracket_idx,cal_idx}(unk) == "", continue; end
                            if isempty(app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion{bracket_idx,cal_idx}{unk}), continue; end
                        end

                        matrix_only_tracer = app.base.project.session.spot.matrix_only_tracer(unk);
                        if app.base.project.session.spot.unmixing_via(unk) == "Matrix-only tracer" && ...
                                ~any(ismember(sensitivity_table.Properties.VariableNames, char(matrix_only_tracer)))
                            msg = {['The limits of detection for spot #' num2str(unk) ' for calibrator ' char(unique_CALs(cal_idx)) ...
                                ' could not be calculated. Make sure that the matrix-only tracer element ' char(matrix_only_tracer) ...
                                ' has a known mass fraction (i.e. the element is defined in the RM file) for this CAL.']};
                            selection_lods = uiconfirm(app.UIFigure, msg, "ICP-Base", ...
                                "Options", ["I want to continue with missing limits of detection","Cancel"], ...
                                "DefaultOption", 1, "CancelOption", 2);
                            switch selection_lods
                                case 'I want to continue with missing limits of detection', continue
                                case 'Cancel', user_stopped_lod_calc = true; return
                            end
                        end

                        if all(app.base.project.session.spot.mix_composition{bracket_idx,cal_idx}{unk,:} == 0), continue; end

                        inclusion_start = app.base.project.session.spot.inclusion_1_starts(unk);
                        inclusion_end   = app.base.project.session.spot.inclusion_1_ends(unk);
                        if isnan(inclusion_start) || isnan(inclusion_end), continue; end

                        background_start = app.base.project.session.spot.background_starts(unk);
                        background_end   = app.base.project.session.spot.background_ends(unk);

                        if isequal(app.base.project.session.config.datatype, 'Continuous')
                            signal = app.base.project.session.spot.signal_data;
                        else
                            signal = app.base.project.session.spot.signal_data{unk};
                        end

                        n_sweeps_bg        = numel(background_start:background_end);
                        n_sweeps_inclusion = numel(inclusion_start:inclusion_end);

                        IS_name = app.base.project.session.spot.internal_standard_inclusion{bracket_idx,cal_idx}(unk);
                        if IS_name == "Total Oxides"
                            IS_name = app.internal_standard_name_total_oxides_inclusion{bracket_idx,cal_idx}{unk};
                        end

                        IS_intensity_mix = app.base.project.session.spot.bkgd_corrected_cps_mix.(char(IS_name))(unk);
                        IS_mf_mix        = app.base.project.session.spot.mix_composition{bracket_idx,cal_idx}.(char(IS_name))(unk);

                        % vectorized background CPS and absolute sensitivity
                        mean_background_cps = mean(table2array(signal(background_start:background_end, valid_sens_cols)), 1);
                        abs_sensitivity     = table2array(sensitivity_table(unk, valid_sens_cols)) .* (IS_intensity_mix / IS_mf_mix);

                        lod_row = (3.29 * sqrt(mean_background_cps .* dwelltimes .* n_sweeps_inclusion .* ...
                            (1 + n_sweeps_inclusion ./ n_sweeps_bg)) + 2.71) ./ ...
                            (n_sweeps_inclusion .* dwelltimes .* abs_sensitivity);

                        lod_mat(unk, valid_var_positions) = lod_row;
                    end

                    app.base.project.session.spot.inclusion_limits_of_detection{bracket_idx,cal_idx} = ...
                        array2table(lod_mat, 'VariableNames', varNames);
                end
            end
        end


        %%%%%%%%%%%%%%%% Matrix uncertainty propagation %%%%%%%%%%%%%%%%%%%%%

        function calculate_matrix_uncertainties_internal_standard(app)

            % Measurement uncertainty on the host mass fractions (direct + 'from CAL').
            % Propagates: counting SEM of the analyte and IS CPS, the sensitivity
            % uncertainty of the analyte and IS, and the user-input 1σ on the IS
            % mass fraction - summed in quadrature as relative terms.
            % For 'from CAL' spots the inherited IS mass fraction is itself a computed
            % value, so it carries the source CAL's own measurement sigma as a fifth term.
            % Total-oxide spots are skipped and handled separately (closure Jacobian).
            % Runs AFTER calculate_matrix_mass_fractions.

            if ~isequal(app.PropagateuncertaintiesMenu.Checked, 'on')
                return
            end

            % backwards compatibility: old sessions were drift-corrected before the
            % uncertainty feature existed, so the sensitivity/counting uncertainty
            % tables are absent. Skip propagation rather than error.
            if ~isfield(app.base.project.session.spot, 'sensitivities_uncertainty') || ...
                    ~isfield(app.base.project.session.spot, 'sem_bkgd_corrected_cps')
                return
            end

            cal_mask    = strcmp(app.base.project.session.spot.type, "CAL");
            unique_CALs = unique(app.base.project.session.spot.referencematerial(cal_mask));
            all_UNK     = find(~cal_mask);

            bkgd_varnames = app.base.project.session.spot.bkgd_corrected_cps.Properties.VariableNames;
            n_bkgd_cols   = width(app.base.project.session.spot.bkgd_corrected_cps);
            n_spots       = length(app.base.project.session.spot.signal_starts);

            % =====================================================================
            % MAIN PASS: direct spots only
            % =====================================================================
            for cal_idx = 1:size(app.base.project.session.spot.sensitivities, 2)
                for bracket_idx = 1:size(app.base.project.session.spot.sensitivities, 1)

                    sens_tbl = app.base.project.session.spot.sensitivities{bracket_idx,cal_idx};

                    if isempty(sens_tbl) || isequal(sens_tbl, zeros(0,0))
                        app.base.project.session.spot.matrix_composition_uncertainty{bracket_idx,cal_idx} = zeros(0,0);
                        continue
                    end

                    internal_standards = app.base.project.session.spot.internal_standard{bracket_idx,cal_idx};
                    sens_unc_tbl       = app.base.project.session.spot.sensitivities_uncertainty{bracket_idx,cal_idx};

                    sens_cols = sens_tbl.Properties.VariableNames;
                    [in_bkgd_table, bkgd_col_positions] = ismember(sens_cols, bkgd_varnames);
                    shared_cols    = sens_cols(in_bkgd_table);
                    shared_col_pos = bkgd_col_positions(in_bkgd_table);

                    cps_all      = table2array(app.base.project.session.spot.bkgd_corrected_cps(:, shared_cols));
                    sem_cps_all  = table2array(app.base.project.session.spot.sem_bkgd_corrected_cps(:, shared_cols));
                    sens_all     = table2array(sens_tbl(:, shared_cols));
                    sens_unc_all = table2array(sens_unc_tbl(:, shared_cols));

                    mass_fractions = table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx});
                    sigma_mat      = zeros(n_spots, n_bkgd_cols);

                    for i = 1:numel(all_UNK)
                        unk = all_UNK(i);

                        if internal_standards(unk) == "", continue; end
                        if isequal(internal_standards(unk), 'Total Oxides'), continue; end   % separate function

                        IS_mass_fraction = app.base.project.session.spot.internal_standard_mass_fraction{bracket_idx,cal_idx}{unk};
                        if isempty(IS_mass_fraction), continue; end
                        if startsWith(string(IS_mass_fraction), 'from'), continue; end        % resolved in iterative passes
                        if all(app.base.project.session.spot.bkgd_corrected_cps{unk, :} == 0), continue; end

                        is_col = find(strcmp(shared_cols, internal_standards(unk)), 1);
                        if isempty(is_col), continue; end

                        % --- four measurement terms (relative variances) ---
                        rel_var = (sem_cps_all(unk,:)  ./ cps_all(unk,:) ).^2 + ...    % analyte counting
                            (sens_unc_all(unk,:) ./ sens_all(unk,:)).^2 + ...    % analyte sensitivity
                            (sem_cps_all(unk,is_col)  / cps_all(unk,is_col) )^2 + ... % IS counting
                            (sens_unc_all(unk,is_col) / sens_all(unk,is_col))^2;      % IS sensitivity

                        % IS column: intensity and sensitivity ratios are identically 1,
                        % so the measurement terms cancel (fully correlated).
                        rel_var(is_col) = 0;

                        % fifth term: user-input IS mass fraction uncertainty
                        if isfield(app.base.project.session.spot, 'internal_standard_mass_fraction_uncertainty')
                            IS_unc = app.base.project.session.spot.internal_standard_mass_fraction_uncertainty{bracket_idx,cal_idx}(unk);
                            if ~isnan(IS_unc) && IS_mass_fraction > 0
                                rel_var = rel_var + (IS_unc / IS_mass_fraction)^2;
                            end
                        end

                        sigma_mat(unk, shared_col_pos) = sqrt(rel_var) .* mass_fractions(unk, shared_col_pos);
                    end

                    app.base.project.session.spot.matrix_composition_uncertainty{bracket_idx,cal_idx} = ...
                        array2table(sigma_mat, 'VariableNames', bkgd_varnames);
                end
            end
        end

        function calculate_matrix_uncertainties_total_oxides(app)

            % Closure propagation for total-oxide spots. Every analyte:
            %   sigma_Ci^2 = lambda^2 * sum_n (delta_in - C_i*c_n/T)^2 * sigma_pn^2
            % with lambda = T/D, sigma_pn the absolute uncertainty of p_n = max(I,0)/S,
            % and c_n the oxide factor (0 for non-oxide analytes). The uncertainty on the user-input total oxide sum propagates as a
            % relative term (sigma_ox/ox_val) applied to all concentrations in quadrature. Fills the spots the direct function skipped,
            % so it must run AFTER calculate_matrix_mass_fraction_uncertainties.

            if ~isequal(app.PropagateuncertaintiesMenu.Checked, 'on')
                return
            end

            % backwards compatibility: old sessions were drift-corrected before the
            % uncertainty feature existed, so the sensitivity/counting uncertainty
            % tables are absent. Skip propagation rather than error.
            if ~isfield(app.base.project.session.spot, 'sensitivities_uncertainty') || ...
                    ~isfield(app.base.project.session.spot, 'sem_bkgd_corrected_cps')
                return
            end

            cal_mask = strcmp(app.base.project.session.spot.type, "CAL");
            all_UNK  = find(~cal_mask);

            bkgd_varnames = app.base.project.session.spot.bkgd_corrected_cps.Properties.VariableNames;

            for cal_idx = 1:size(app.base.project.session.spot.sensitivities, 2)
                for bracket_idx = 1:size(app.base.project.session.spot.sensitivities, 1)

                    sens_tbl = app.base.project.session.spot.sensitivities{bracket_idx,cal_idx};
                    if isempty(sens_tbl) || isequal(sens_tbl, zeros(0,0))
                        continue
                    end

                    internal_standards = app.base.project.session.spot.internal_standard{bracket_idx,cal_idx};
                    sens_unc_tbl       = app.base.project.session.spot.sensitivities_uncertainty{bracket_idx,cal_idx};

                    sens_cols = sens_tbl.Properties.VariableNames;
                    [in_bkgd, bkgd_pos] = ismember(sens_cols, bkgd_varnames);
                    shared_cols = sens_cols(in_bkgd);
                    shared_pos  = bkgd_pos(in_bkgd);

                    cps_all      = table2array(app.base.project.session.spot.bkgd_corrected_cps(:, shared_cols));
                    sem_cps_all  = table2array(app.base.project.session.spot.sem_bkgd_corrected_cps(:, shared_cols));
                    sens_all     = table2array(sens_tbl(:, shared_cols));
                    sens_unc_all = table2array(sens_unc_tbl(:, shared_cols));

                    comp  = table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx});
                    sigma = table2array(app.base.project.session.spot.matrix_composition_uncertainty{bracket_idx,cal_idx});

                    % absolute sigma of p_n = max(I,0)/S for every analyte (no 0/0 blow-up)
                    I_clamped   = max(cps_all, 0);
                    sigma_p_all = sqrt( (sem_cps_all ./ sens_all).^2 + ...
                        (I_clamped .* sens_unc_all ./ sens_all.^2).^2 );

                    for ii = 1:numel(all_UNK)
                        unk = all_UNK(ii);
                        if ~isequal(internal_standards(unk), 'Total Oxides'), continue; end

                        % fetch stashed closure terms (guard the auto-grown cell)
                        if bracket_idx > size(app.total_oxide_terms,1) || cal_idx > size(app.total_oxide_terms,2) || ...
                                isempty(app.total_oxide_terms{bracket_idx,cal_idx}) || ...
                                unk > numel(app.total_oxide_terms{bracket_idx,cal_idx}) || ...
                                isempty(app.total_oxide_terms{bracket_idx,cal_idx}{unk})
                            continue
                        end
                        terms = app.total_oxide_terms{bracket_idx,cal_idx}{unk};

                        T = terms.T;
                        D = terms.D;
                        if ~(D > 0), continue; end
                        lambda = T / D;

                        % positions of the oxide-forming majors within shared_cols
                        [is_maj, maj_pos] = ismember(terms.major_names, shared_cols);
                        if ~all(is_maj), continue; end          % majors must be measured (safety)
                        c_maj       = terms.c_eff;               % 1 x nMaj
                        sigma_p_maj = sigma_p_all(unk, maj_pos); % 1 x nMaj

                        is_major_col = false(1, numel(shared_cols));
                        is_major_col(maj_pos) = true;

                        sigma_row = zeros(1, numel(shared_cols));

                        for k = 1:numel(shared_cols)
                            C_i   = comp(unk, shared_pos(k));
                            delta = double(maj_pos == k);                 % 1 at the major that is column k
                            dev   = delta - (C_i * c_maj / T);            % 1 x nMaj
                            base_sum = sum( (dev.^2) .* (sigma_p_maj.^2) );

                            if ~is_major_col(k)
                                % non-oxide analyte: add its own measurement term (delta=1, c_i=0)
                                base_sum = base_sum + sigma_p_all(unk, k)^2;
                            end

                            sigma_row(k) = lambda * sqrt(base_sum);
                        end

                        % user-input total oxide uncertainty
                        if isfield(app.base.project.session.spot, 'internal_standard_oxide_wt_uncertainty')
                            ox_unc = app.base.project.session.spot.internal_standard_oxide_wt_uncertainty{bracket_idx,cal_idx}(unk);
                            ox_val = app.base.project.session.spot.internal_standard_oxide_wt{bracket_idx,cal_idx}(unk);
                            if ~isnan(ox_unc) && ox_val > 0
                                C_row = comp(unk, shared_pos);
                                sigma_row = sqrt(sigma_row.^2 + (C_row .* ox_unc / ox_val).^2);
                            end
                        end

                        sigma(unk, shared_pos) = sigma_row;
                    end

                    app.base.project.session.spot.matrix_composition_uncertainty{bracket_idx,cal_idx} = ...
                        array2table(sigma, 'VariableNames', bkgd_varnames);
                end
            end
        end

        function calculate_matrix_uncertainties_from_cal_passes(app)

            % Resolves 'from CAL' spots. Their inherited IS mass fraction is a computed
            % value, so it carries the source quantification's measurement sigma as a
            % fifth term. Source sigma is read back from matrix_composition_uncertainty,
            % which by now holds BOTH direct and total-oxide results -> must run LAST.

            if ~isequal(app.PropagateuncertaintiesMenu.Checked, 'on')
                return
            end

            % backwards compatibility: old sessions were drift-corrected before the
            % uncertainty feature existed, so the sensitivity/counting uncertainty
            % tables are absent. Skip propagation rather than error.
            if ~isfield(app.base.project.session.spot, 'sensitivities_uncertainty') || ...
                    ~isfield(app.base.project.session.spot, 'sem_bkgd_corrected_cps')
                return
            end

            cal_mask    = strcmp(app.base.project.session.spot.type, "CAL");
            unique_CALs = unique(app.base.project.session.spot.referencematerial(cal_mask));
            all_UNK     = find(~cal_mask);

            bkgd_varnames = app.base.project.session.spot.bkgd_corrected_cps.Properties.VariableNames;
            n_bkgd_cols   = width(app.base.project.session.spot.bkgd_corrected_cps);

            max_passes = length(unique_CALs);
            for pass = 1:max_passes
                changes_made = false;

                for cal_idx = 1:size(app.base.project.session.spot.sensitivities, 2)
                    for bracket_idx = 1:size(app.base.project.session.spot.sensitivities, 1)

                        sens_tbl = app.base.project.session.spot.sensitivities{bracket_idx,cal_idx};
                        if isempty(sens_tbl) || isequal(sens_tbl, zeros(0,0))
                            continue
                        end

                        internal_standards = app.base.project.session.spot.internal_standard{bracket_idx,cal_idx};
                        sens_unc_tbl       = app.base.project.session.spot.sensitivities_uncertainty{bracket_idx,cal_idx};

                        sens_cols = sens_tbl.Properties.VariableNames;
                        [in_bkgd_table, bkgd_col_positions] = ismember(sens_cols, bkgd_varnames);
                        shared_cols    = sens_cols(in_bkgd_table);
                        shared_col_pos = bkgd_col_positions(in_bkgd_table);

                        cps_all      = table2array(app.base.project.session.spot.bkgd_corrected_cps(:, shared_cols));
                        sem_cps_all  = table2array(app.base.project.session.spot.sem_bkgd_corrected_cps(:, shared_cols));
                        sens_all     = table2array(sens_tbl(:, shared_cols));
                        sens_unc_all = table2array(sens_unc_tbl(:, shared_cols));

                        mass_fractions = table2array(app.base.project.session.spot.matrix_composition{bracket_idx,cal_idx});
                        sigma_mat      = table2array(app.base.project.session.spot.matrix_composition_uncertainty{bracket_idx,cal_idx});

                        for i = 1:numel(all_UNK)
                            unk = all_UNK(i);
                            if internal_standards(unk) == "", continue; end

                            IS_element = internal_standards(unk);
                            IS_frac    = app.base.project.session.spot.internal_standard_mass_fraction{bracket_idx,cal_idx}{unk};

                            if isempty(IS_frac) || ~startsWith(string(IS_frac), 'from') || isequal(IS_element, 'Total Oxides')
                                continue
                            end

                            source_cal     = extractAfter(string(IS_frac), 'from ');
                            source_cal_idx = find(strcmp(unique_CALs, source_cal));
                            if isempty(source_cal_idx) || isempty(app.base.project.session.spot.matrix_composition{bracket_idx,source_cal_idx})
                                continue
                            end

                            source_val = app.base.project.session.spot.matrix_composition{bracket_idx,source_cal_idx}{unk, char(IS_element)};
                            source_unc = app.base.project.session.spot.matrix_composition_uncertainty{bracket_idx,source_cal_idx}{unk, char(IS_element)};
                            if ~(source_val > 0), continue; end

                            is_col = find(strcmp(shared_cols, IS_element), 1);
                            if isempty(is_col), continue; end

                            % own four measurement terms
                            rel_var = (sem_cps_all(unk,:)  ./ cps_all(unk,:) ).^2 + ...
                                (sens_unc_all(unk,:) ./ sens_all(unk,:)).^2 + ...
                                (sem_cps_all(unk,is_col)  / cps_all(unk,is_col) )^2 + ...
                                (sens_unc_all(unk,is_col) / sens_all(unk,is_col))^2;
                            rel_var(is_col) = 0;

                            % fifth term: inherited measurement sigma of the source value
                            % (source may be direct OR total-oxide - both are ready by now)
                            rel_var = rel_var + (source_unc / source_val)^2;

                            new_row = zeros(1, n_bkgd_cols);
                            new_row(shared_col_pos) = sqrt(rel_var) .* mass_fractions(unk, shared_col_pos);

                            if any(abs(new_row - sigma_mat(unk,:)) > 1e-10)
                                changes_made = true;
                            end
                            sigma_mat(unk,:) = new_row;
                        end

                        app.base.project.session.spot.matrix_composition_uncertainty{bracket_idx,cal_idx} = ...
                            array2table(sigma_mat, 'VariableNames', bkgd_varnames);
                    end
                end

                if ~changes_made
                    break
                end
            end
        end


        %%%%%%%%%%%%%%%% Inclusion uncertainty propagation %%%%%%%%%%%%%%%%%%%%%

        function calculate_inclusion_uncertainties_MOT(app)

            % Measurement uncertainty of the inclusion composition for spots unmixed via
            % the matrix-only tracer (direct IS, not Total Oxides, not 'from CAL').
            % Same form as the matrix: analyte counting, analyte sensitivity, IS counting and
            % IS sensitivity as relative variances, plus the user-input uncertainty of the IS
            % mass fraction. The IS column cancels. The tracer column is set to 0.
            % Runs AFTER calculate_inclusion_mass_fractions.

            if ~isequal(app.PropagateuncertaintiesMenu.Checked, 'on')
                return
            end

            % old sessions have no inclusion SEM tables yet
            if ~isfield(app.base.project.session.spot, 'sensitivities_uncertainty') || ...
                    ~isfield(app.base.project.session.spot, 'sem_bkgd_corrected_cps_incl')
                return
            end

            spot_data       = app.base.project.session.spot;
            is_unknown_spot = spot_data.type ~= "CAL";
            unknown_spots   = find(is_unknown_spot);

            inclusion_column_names = spot_data.bkgd_corrected_cps_incl.Properties.VariableNames;
            number_of_spots        = size(spot_data.signal_starts, 1);

            for calibrator_index = 1:size(spot_data.sensitivities, 2)
                for bracket_id = 1:size(spot_data.sensitivities, 1)

                    sensitivity_table = spot_data.sensitivities{bracket_id, calibrator_index};

                    if isempty(sensitivity_table) || isequal(sensitivity_table, zeros(0,0))
                        app.base.project.session.spot.inclusion_composition_uncertainty{bracket_id, calibrator_index} = zeros(0,0);
                        continue
                    end

                    sensitivity_uncertainty_table = spot_data.sensitivities_uncertainty{bracket_id, calibrator_index};
                    internal_standard_names       = spot_data.internal_standard_inclusion{bracket_id, calibrator_index};
                    composition_table             = spot_data.inclusion_composition{bracket_id, calibrator_index};

                    % analytes that have a sensitivity and exist in the inclusion tables
                    sensitivity_column_names = sensitivity_table.Properties.VariableNames;
                    [is_in_inclusion_table, inclusion_column_positions] = ismember(sensitivity_column_names, inclusion_column_names);
                    analyte_names     = sensitivity_column_names(is_in_inclusion_table);
                    analyte_positions = inclusion_column_positions(is_in_inclusion_table);

                    inclusion_cps         = table2array(spot_data.bkgd_corrected_cps_incl(:, analyte_names));
                    inclusion_cps_sem     = table2array(spot_data.sem_bkgd_corrected_cps_incl(:, analyte_names));
                    sensitivities         = table2array(sensitivity_table(:, analyte_names));
                    sensitivity_unc       = table2array(sensitivity_uncertainty_table(:, analyte_names));
                    inclusion_composition = table2array(composition_table);

                    composition_uncertainty = zeros(number_of_spots, numel(inclusion_column_names));

                    for unknown_number = 1:numel(unknown_spots)
                        spot_number = unknown_spots(unknown_number);

                        internal_standard_name = internal_standard_names(spot_number);
                        internal_standard_mass_fraction = spot_data.internal_standard_mass_fraction_inclusion{bracket_id, calibrator_index}{spot_number};

                        % same skip conditions as the composition calculation, restricted to the MOT path
                        if internal_standard_name == "", continue; end
                        if isequal(internal_standard_name, 'Total Oxides'), continue; end
                        if spot_data.unmixing_via(spot_number) ~= "Matrix-only tracer", continue; end
                        if isempty(internal_standard_mass_fraction), continue; end
                        if startsWith(string(internal_standard_mass_fraction), 'from'), continue; end
                        if all(spot_data.bkgd_corrected_cps_mix{spot_number, :} == 0), continue; end

                        internal_standard_column = find(strcmp(analyte_names, internal_standard_name), 1);
                        if isempty(internal_standard_column), continue; end

                        % four measurement terms, as relative variances
                        analyte_counting     = (inclusion_cps_sem(spot_number, :) ./ inclusion_cps(spot_number, :)).^2;
                        analyte_sensitivity  = (sensitivity_unc(spot_number, :)   ./ sensitivities(spot_number, :)).^2;
                        standard_counting    = (inclusion_cps_sem(spot_number, internal_standard_column) / inclusion_cps(spot_number, internal_standard_column))^2;
                        standard_sensitivity = (sensitivity_unc(spot_number, internal_standard_column)   / sensitivities(spot_number, internal_standard_column))^2;

                        relative_variance = analyte_counting + analyte_sensitivity + standard_counting + standard_sensitivity;

                        % the IS column cancels in both ratios
                        relative_variance(internal_standard_column) = 0;

                        % user-input uncertainty of the IS mass fraction
                        internal_standard_unc = spot_data.internal_standard_mass_fraction_uncertainty_inclusion{bracket_id, calibrator_index}(spot_number);
                        if ~isnan(internal_standard_unc) && internal_standard_mass_fraction > 0
                            relative_variance = relative_variance + (internal_standard_unc / internal_standard_mass_fraction)^2;
                        end

                        spot_uncertainty = sqrt(relative_variance) .* inclusion_composition(spot_number, analyte_positions);

                        % the tracer has no inclusion signal by construction: composition 0, uncertainty 0
                        tracer_column = find(strcmp(analyte_names, spot_data.matrix_only_tracer(spot_number)), 1);
                        if ~isempty(tracer_column)
                            spot_uncertainty(tracer_column) = 0;
                        end

                        composition_uncertainty(spot_number, analyte_positions) = spot_uncertainty;
                    end

                    app.base.project.session.spot.inclusion_composition_uncertainty{bracket_id, calibrator_index} = ...
                        array2table(composition_uncertainty, 'VariableNames', inclusion_column_names);
                end
            end
        end

        function calculate_inclusion_uncertainties_MOT_total_oxides(app)

            % Closure propagation for inclusion spots unmixed via the matrix-only tracer whose
            % internal standard is Total Oxides. Same formula as the matrix version:
            %   sigma_Ci^2 = lambda^2 * sum_n (delta_in - C_i*c_n/T)^2 * sigma_pn^2
            % with lambda = T/D and sigma_pn the absolute uncertainty of p_n = max(I,0)/S.
            % The user-input uncertainty of the total oxide sum is added afterwards as a relative term.
            % Fills the spots that calculate_inclusion_uncertainties_MOT skipped, so it runs AFTER it.

            if ~isequal(app.PropagateuncertaintiesMenu.Checked, 'on')
                return
            end

            if ~isfield(app.base.project.session.spot, 'sensitivities_uncertainty') || ...
                    ~isfield(app.base.project.session.spot, 'sem_bkgd_corrected_cps_incl') || ...
                    ~isfield(app.base.project.session.spot, 'inclusion_composition_uncertainty')
                return
            end

            spot_data     = app.base.project.session.spot;
            unknown_spots = find(spot_data.type ~= "CAL");

            inclusion_column_names = spot_data.bkgd_corrected_cps_incl.Properties.VariableNames;

            for calibrator_index = 1:size(spot_data.sensitivities, 2)
                for bracket_id = 1:size(spot_data.sensitivities, 1)

                    sensitivity_table = spot_data.sensitivities{bracket_id, calibrator_index};
                    if isempty(sensitivity_table) || isequal(sensitivity_table, zeros(0,0))
                        continue
                    end

                    internal_standard_names       = spot_data.internal_standard_inclusion{bracket_id, calibrator_index};
                    sensitivity_uncertainty_table = spot_data.sensitivities_uncertainty{bracket_id, calibrator_index};

                    sensitivity_column_names = sensitivity_table.Properties.VariableNames;
                    [is_in_inclusion_table, inclusion_column_positions] = ismember(sensitivity_column_names, inclusion_column_names);
                    analyte_names     = sensitivity_column_names(is_in_inclusion_table);
                    analyte_positions = inclusion_column_positions(is_in_inclusion_table);

                    inclusion_cps     = table2array(spot_data.bkgd_corrected_cps_incl(:, analyte_names));
                    inclusion_cps_sem = table2array(spot_data.sem_bkgd_corrected_cps_incl(:, analyte_names));
                    sensitivities     = table2array(sensitivity_table(:, analyte_names));
                    sensitivity_unc   = table2array(sensitivity_uncertainty_table(:, analyte_names));

                    inclusion_composition   = table2array(spot_data.inclusion_composition{bracket_id, calibrator_index});
                    composition_uncertainty = table2array(spot_data.inclusion_composition_uncertainty{bracket_id, calibrator_index});

                    % absolute uncertainty of p_n = max(I,0)/S for every analyte
                    clamped_inclusion_cps = max(inclusion_cps, 0);
                    sigma_p_all = sqrt( (inclusion_cps_sem ./ sensitivities).^2 + ...
                        (clamped_inclusion_cps .* sensitivity_unc ./ sensitivities.^2).^2 );

                    for unknown_number = 1:numel(unknown_spots)
                        spot_number = unknown_spots(unknown_number);

                        if ~isequal(internal_standard_names(spot_number), 'Total Oxides'), continue; end
                        if spot_data.unmixing_via(spot_number) ~= "Matrix-only tracer", continue; end

                        % fetch the stashed closure terms (guard against a missing or short cell)
                        if isempty(app.total_oxide_terms_inclusion) || ...
                                bracket_id > size(app.total_oxide_terms_inclusion, 1) || ...
                                calibrator_index > size(app.total_oxide_terms_inclusion, 2) || ...
                                isempty(app.total_oxide_terms_inclusion{bracket_id, calibrator_index}) || ...
                                spot_number > numel(app.total_oxide_terms_inclusion{bracket_id, calibrator_index}) || ...
                                isempty(app.total_oxide_terms_inclusion{bracket_id, calibrator_index}{spot_number})
                            continue
                        end
                        closure_terms = app.total_oxide_terms_inclusion{bracket_id, calibrator_index}{spot_number};

                        total_oxide_target = closure_terms.T;
                        closure_sum        = closure_terms.D;
                        if ~(closure_sum > 0), continue; end
                        scale_factor = total_oxide_target / closure_sum;

                        % positions of the oxide-forming majors within the analyte columns
                        [major_is_measured, major_columns] = ismember(closure_terms.major_names, analyte_names);
                        if ~all(major_is_measured), continue; end

                        major_oxide_factors = closure_terms.c_eff;
                        major_sigma_p       = sigma_p_all(spot_number, major_columns);

                        column_is_major = false(1, numel(analyte_names));
                        column_is_major(major_columns) = true;

                        spot_uncertainty = zeros(1, numel(analyte_names));

                        for analyte_column = 1:numel(analyte_names)
                            composition_of_analyte = inclusion_composition(spot_number, analyte_positions(analyte_column));

                            is_this_major = double(major_columns == analyte_column);
                            deviation     = is_this_major - (composition_of_analyte * major_oxide_factors / total_oxide_target);
                            variance_sum  = sum( (deviation.^2) .* (major_sigma_p.^2) );

                            if ~column_is_major(analyte_column)
                                % non-oxide analyte: add its own measurement term
                                variance_sum = variance_sum + sigma_p_all(spot_number, analyte_column)^2;
                            end

                            spot_uncertainty(analyte_column) = scale_factor * sqrt(variance_sum);
                        end

                        % user-input uncertainty of the total oxide sum
                        oxide_sum_unc = spot_data.internal_standard_oxide_wt_uncertainty_inclusion{bracket_id, calibrator_index}(spot_number);
                        oxide_sum     = spot_data.internal_standard_oxide_wt_inclusion{bracket_id, calibrator_index}(spot_number);
                        if ~isnan(oxide_sum_unc) && oxide_sum > 0
                            spot_composition = inclusion_composition(spot_number, analyte_positions);
                            spot_uncertainty = sqrt(spot_uncertainty.^2 + (spot_composition .* oxide_sum_unc / oxide_sum).^2);
                        end

                        composition_uncertainty(spot_number, analyte_positions) = spot_uncertainty;
                    end

                    app.base.project.session.spot.inclusion_composition_uncertainty{bracket_id, calibrator_index} = ...
                        array2table(composition_uncertainty, 'VariableNames', inclusion_column_names);
                end
            end
        end

        function calculate_inclusion_uncertainties_mixing_ratio(app)

            % Inclusion composition uncertainty for spots in "Mixing ratio" mode.
            %   mixed_standard = (1 - x) * host_standard + x * standard_mass_fraction
            %   analyte_factor = (mix_cps / standard_mix_cps) * (standard_sensitivity / analyte_sensitivity)
            %   inclusion      = analyte_factor * mixed_standard / x - (1 - x) / x * host_analyte
            % First-order propagation with explicit partial derivatives, all inputs independent.
            % Runs AFTER calculate_inclusion_uncertainties_MOT (it fills the rows that function leaves at 0)
            % and after the matrix uncertainties (the host composition uncertainty is needed).

            if ~isequal(app.PropagateuncertaintiesMenu.Checked, 'on')
                return
            end

            if ~isfield(app.base.project.session.spot, 'sensitivities_uncertainty') || ...
                    ~isfield(app.base.project.session.spot, 'sem_bkgd_corrected_cps_mix') || ...
                    ~isfield(app.base.project.session.spot, 'matrix_composition_uncertainty') || ...
                    ~isfield(app.base.project.session.spot, 'inclusion_composition_uncertainty')
                return
            end

            spot_data     = app.base.project.session.spot;
            unknown_spots = find(spot_data.type ~= "CAL");

            inclusion_column_names = spot_data.bkgd_corrected_cps_incl.Properties.VariableNames;
            mix_column_names       = spot_data.bkgd_corrected_cps_mix.Properties.VariableNames;

            for calibrator_index = 1:size(spot_data.sensitivities, 2)
                for bracket_id = 1:size(spot_data.sensitivities, 1)

                    sensitivity_table = spot_data.sensitivities{bracket_id, calibrator_index};
                    if isempty(sensitivity_table) || isequal(sensitivity_table, zeros(0,0))
                        continue
                    end

                    host_composition_table = spot_data.matrix_composition{bracket_id, calibrator_index};
                    host_uncertainty_table = spot_data.matrix_composition_uncertainty{bracket_id, calibrator_index};
                    if isempty(host_composition_table) || isempty(host_uncertainty_table)
                        continue
                    end

                    sensitivity_uncertainty_table = spot_data.sensitivities_uncertainty{bracket_id, calibrator_index};
                    internal_standard_names       = spot_data.internal_standard_inclusion{bracket_id, calibrator_index};
                    mixing_ratios                 = spot_data.mixing_ratio{bracket_id, calibrator_index};

                    % analytes that have a sensitivity and exist in the inclusion and mix tables
                    sensitivity_column_names = sensitivity_table.Properties.VariableNames;
                    [is_in_inclusion_table, inclusion_column_positions] = ismember(sensitivity_column_names, inclusion_column_names);
                    is_in_mix_table   = ismember(sensitivity_column_names, mix_column_names);
                    analyte_selection = is_in_inclusion_table & is_in_mix_table;
                    analyte_names     = sensitivity_column_names(analyte_selection);
                    analyte_positions = inclusion_column_positions(analyte_selection);

                    mix_cps              = table2array(spot_data.bkgd_corrected_cps_mix(:, analyte_names));
                    mix_cps_sem          = table2array(spot_data.sem_bkgd_corrected_cps_mix(:, analyte_names));
                    sensitivities        = table2array(sensitivity_table(:, analyte_names));
                    sensitivity_unc      = table2array(sensitivity_uncertainty_table(:, analyte_names));
                    host_composition     = table2array(host_composition_table(:, analyte_names));
                    host_composition_unc = table2array(host_uncertainty_table(:, analyte_names));

                    composition_uncertainty = table2array(spot_data.inclusion_composition_uncertainty{bracket_id, calibrator_index});

                    for unknown_number = 1:numel(unknown_spots)
                        spot_number = unknown_spots(unknown_number);

                        if spot_data.unmixing_via(spot_number) ~= "Mixing ratio", continue; end

                        standard_name          = internal_standard_names(spot_number);
                        standard_mass_fraction = spot_data.internal_standard_mass_fraction_inclusion{bracket_id, calibrator_index}{spot_number};
                        mixing_ratio           = mixing_ratios(spot_number);

                        if standard_name == "", continue; end
                        if isequal(standard_name, 'Total Oxides'), continue; end
                        if isempty(standard_mass_fraction), continue; end
                        if startsWith(string(standard_mass_fraction), 'from'), continue; end
                        if isnan(mixing_ratio), continue; end
                        if all(spot_data.bkgd_corrected_cps_mix{spot_number, :} == 0), continue; end

                        standard_column = find(strcmp(analyte_names, standard_name), 1);
                        if isempty(standard_column), continue; end

                        host_spot_number = find(strcmp(spot_data.name, spot_data.matrix_from_spot(spot_number)), 1);
                        if isempty(host_spot_number), continue; end
                        if all(host_composition(host_spot_number, :) == 0), continue; end

                        % user-input uncertainties (not set means 0)
                        standard_mass_fraction_unc = spot_data.internal_standard_mass_fraction_uncertainty_inclusion{bracket_id, calibrator_index}(spot_number);
                        mixing_ratio_unc           = spot_data.mixing_ratio_uncertainty_inclusion{bracket_id, calibrator_index}(spot_number);
                        if isnan(standard_mass_fraction_unc), standard_mass_fraction_unc = 0; end
                        if isnan(mixing_ratio_unc),           mixing_ratio_unc = 0; end

                        % inputs of this spot
                        analyte_mix_cps        = mix_cps(spot_number, :);
                        analyte_mix_cps_sem    = mix_cps_sem(spot_number, :);
                        analyte_sensitivity    = sensitivities(spot_number, :);
                        analyte_sensitivity_unc = sensitivity_unc(spot_number, :);

                        standard_mix_cps         = mix_cps(spot_number, standard_column);
                        standard_mix_cps_sem     = mix_cps_sem(spot_number, standard_column);
                        standard_sensitivity     = sensitivities(spot_number, standard_column);
                        standard_sensitivity_unc = sensitivity_unc(spot_number, standard_column);

                        host_standard_composition = host_composition(host_spot_number, standard_column);
                        host_standard_unc         = host_composition_unc(host_spot_number, standard_column);
                        host_analyte_composition  = host_composition(host_spot_number, :);
                        host_analyte_unc          = host_composition_unc(host_spot_number, :);

                        % intermediate values
                        analyte_factor = (analyte_mix_cps / standard_mix_cps) .* (standard_sensitivity ./ analyte_sensitivity);
                        mixed_standard_composition = (1 - mixing_ratio) * host_standard_composition + mixing_ratio * standard_mass_fraction;

                        % partial derivatives of the inclusion composition
                        effect_of_factor         = mixed_standard_composition / mixing_ratio;
                        d_analyte_mix_cps        = effect_of_factor * standard_sensitivity ./ (standard_mix_cps * analyte_sensitivity);
                        d_analyte_sensitivity    = -effect_of_factor * analyte_factor ./ analyte_sensitivity;
                        d_standard_mix_cps       = -effect_of_factor * analyte_factor / standard_mix_cps;
                        d_standard_sensitivity   = effect_of_factor * analyte_factor / standard_sensitivity;
                        d_host_standard          = analyte_factor * (1 - mixing_ratio) / mixing_ratio;
                        d_host_analyte           = -(1 - mixing_ratio) / mixing_ratio;
                        d_standard_mass_fraction = analyte_factor;
                        d_mixing_ratio           = (host_analyte_composition - analyte_factor * host_standard_composition) / mixing_ratio^2;

                        variance = (d_analyte_mix_cps        .* analyte_mix_cps_sem).^2 + ...
                            (d_analyte_sensitivity    .* analyte_sensitivity_unc).^2 + ...
                            (d_standard_mix_cps       .* standard_mix_cps_sem).^2 + ...
                            (d_standard_sensitivity   .* standard_sensitivity_unc).^2 + ...
                            (d_host_standard          .* host_standard_unc).^2 + ...
                            (d_host_analyte           .* host_analyte_unc).^2 + ...
                            (d_standard_mass_fraction .* standard_mass_fraction_unc).^2 + ...
                            (d_mixing_ratio           .* mixing_ratio_unc).^2;

                        spot_uncertainty = sqrt(variance);

                        % the standard itself: inclusion value = its mass fraction exactly
                        spot_uncertainty(standard_column) = standard_mass_fraction_unc;

                        composition_uncertainty(spot_number, analyte_positions) = spot_uncertainty;
                    end

                    app.base.project.session.spot.inclusion_composition_uncertainty{bracket_id, calibrator_index} = ...
                        array2table(composition_uncertainty, 'VariableNames', inclusion_column_names);
                end
            end
        end

        function calculate_inclusion_uncertainties_two_IS(app)

            % Inclusion composition uncertainty for spots in "Two internal standards" mode.
            %   standards_ratio = (first_mix_cps / second_mix_cps) * (second_sensitivity / first_sensitivity)
            %   mixing_ratio    = (first_host - a*second_host) / (first_host - first_fraction - a*second_host + a*second_fraction)
            %   mixed_second    = (1 - mixing_ratio) * second_host + mixing_ratio * second_fraction
            %   analyte_factor  = (analyte_mix_cps / second_mix_cps) * (second_sensitivity / analyte_sensitivity)
            %   inclusion       = analyte_factor * mixed_second / mixing_ratio - (1 - mixing_ratio) / mixing_ratio * host_analyte
            % (host = host composition of a standard, fraction = its mass fraction in the inclusion).
            % First-order propagation with explicit partial derivatives, all inputs independent.
            % The mixing ratio itself depends on the inputs, so several partials have a direct part
            % and a part that goes through the mixing ratio.

            if ~isequal(app.PropagateuncertaintiesMenu.Checked, 'on')
                return
            end

            if ~isfield(app.base.project.session.spot, 'sensitivities_uncertainty') || ...
                    ~isfield(app.base.project.session.spot, 'sem_bkgd_corrected_cps_mix') || ...
                    ~isfield(app.base.project.session.spot, 'matrix_composition_uncertainty') || ...
                    ~isfield(app.base.project.session.spot, 'inclusion_composition_uncertainty')
                return
            end

            spot_data     = app.base.project.session.spot;
            unknown_spots = find(spot_data.type ~= "CAL");

            inclusion_column_names = spot_data.bkgd_corrected_cps_incl.Properties.VariableNames;
            mix_column_names       = spot_data.bkgd_corrected_cps_mix.Properties.VariableNames;

            for calibrator_index = 1:size(spot_data.sensitivities, 2)
                for bracket_id = 1:size(spot_data.sensitivities, 1)

                    sensitivity_table = spot_data.sensitivities{bracket_id, calibrator_index};
                    if isempty(sensitivity_table) || isequal(sensitivity_table, zeros(0,0))
                        continue
                    end

                    host_composition_table = spot_data.matrix_composition{bracket_id, calibrator_index};
                    host_uncertainty_table = spot_data.matrix_composition_uncertainty{bracket_id, calibrator_index};
                    if isempty(host_composition_table) || isempty(host_uncertainty_table)
                        continue
                    end

                    sensitivity_uncertainty_table = spot_data.sensitivities_uncertainty{bracket_id, calibrator_index};
                    first_standard_names          = spot_data.internal_standard_inclusion{bracket_id, calibrator_index};
                    second_standard_names         = spot_data.second_internal_standard_inclusion{bracket_id, calibrator_index};

                    sensitivity_column_names = sensitivity_table.Properties.VariableNames;
                    [is_in_inclusion_table, inclusion_column_positions] = ismember(sensitivity_column_names, inclusion_column_names);
                    is_in_mix_table   = ismember(sensitivity_column_names, mix_column_names);
                    analyte_selection = is_in_inclusion_table & is_in_mix_table;
                    analyte_names     = sensitivity_column_names(analyte_selection);
                    analyte_positions = inclusion_column_positions(analyte_selection);

                    mix_cps              = table2array(spot_data.bkgd_corrected_cps_mix(:, analyte_names));
                    mix_cps_sem          = table2array(spot_data.sem_bkgd_corrected_cps_mix(:, analyte_names));
                    sensitivities        = table2array(sensitivity_table(:, analyte_names));
                    sensitivity_unc      = table2array(sensitivity_uncertainty_table(:, analyte_names));
                    host_composition     = table2array(host_composition_table(:, analyte_names));
                    host_composition_unc = table2array(host_uncertainty_table(:, analyte_names));

                    composition_uncertainty = table2array(spot_data.inclusion_composition_uncertainty{bracket_id, calibrator_index});

                    for unknown_number = 1:numel(unknown_spots)
                        spot_number = unknown_spots(unknown_number);

                        if spot_data.unmixing_via(spot_number) ~= "Two internal standards", continue; end

                        first_standard_name  = first_standard_names(spot_number);
                        second_standard_name = second_standard_names(spot_number);
                        first_fraction       = spot_data.internal_standard_mass_fraction_inclusion{bracket_id, calibrator_index}{spot_number};
                        second_fraction      = spot_data.second_internal_standard_mass_fraction_inclusion{bracket_id, calibrator_index}{spot_number};

                        if first_standard_name == "" || second_standard_name == "", continue; end
                        if isequal(first_standard_name, 'Total Oxides'), continue; end
                        if isempty(first_fraction) || isempty(second_fraction), continue; end
                        if startsWith(string(first_fraction), 'from'), continue; end
                        if startsWith(string(second_fraction), 'from'), continue; end
                        if all(spot_data.bkgd_corrected_cps_mix{spot_number, :} == 0), continue; end

                        first_column  = find(strcmp(analyte_names, first_standard_name), 1);
                        second_column = find(strcmp(analyte_names, second_standard_name), 1);
                        if isempty(first_column) || isempty(second_column), continue; end

                        host_spot_number = find(strcmp(spot_data.name, spot_data.matrix_from_spot(spot_number)), 1);
                        if isempty(host_spot_number), continue; end
                        if all(host_composition(host_spot_number, :) == 0), continue; end

                        % user-input uncertainties of the two mass fractions (not set means 0)
                        first_fraction_unc  = spot_data.internal_standard_mass_fraction_uncertainty_inclusion{bracket_id, calibrator_index}(spot_number);
                        second_fraction_unc = spot_data.second_internal_standard_mass_fraction_uncertainty_inclusion{bracket_id, calibrator_index}(spot_number);
                        if isnan(first_fraction_unc),  first_fraction_unc = 0; end
                        if isnan(second_fraction_unc), second_fraction_unc = 0; end

                        % inputs of this spot: analyte
                        analyte_mix_cps         = mix_cps(spot_number, :);
                        analyte_mix_cps_sem     = mix_cps_sem(spot_number, :);
                        analyte_sensitivity     = sensitivities(spot_number, :);
                        analyte_sensitivity_unc = sensitivity_unc(spot_number, :);
                        host_analyte            = host_composition(host_spot_number, :);
                        host_analyte_unc        = host_composition_unc(host_spot_number, :);

                        % inputs of this spot: first and second standard
                        first_mix_cps         = mix_cps(spot_number, first_column);
                        first_mix_cps_sem     = mix_cps_sem(spot_number, first_column);
                        first_sensitivity     = sensitivities(spot_number, first_column);
                        first_sensitivity_unc = sensitivity_unc(spot_number, first_column);
                        first_host            = host_composition(host_spot_number, first_column);
                        first_host_unc        = host_composition_unc(host_spot_number, first_column);

                        second_mix_cps         = mix_cps(spot_number, second_column);
                        second_mix_cps_sem     = mix_cps_sem(spot_number, second_column);
                        second_sensitivity     = sensitivities(spot_number, second_column);
                        second_sensitivity_unc = sensitivity_unc(spot_number, second_column);
                        second_host            = host_composition(host_spot_number, second_column);
                        second_host_unc        = host_composition_unc(host_spot_number, second_column);

                        % ratio of the two standards in the mix, and the mixing ratio
                        standards_ratio     = (first_mix_cps / second_mix_cps) * (second_sensitivity / first_sensitivity);
                        closure_numerator   = first_host - standards_ratio * second_host;
                        closure_denominator = first_host - first_fraction - standards_ratio * second_host + standards_ratio * second_fraction;
                        if closure_denominator == 0, continue; end
                        mixing_ratio = closure_numerator / closure_denominator;

                        analyte_factor = (analyte_mix_cps / second_mix_cps) .* (second_sensitivity ./ analyte_sensitivity);
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
                        factor_d_analyte_mix_cps = second_sensitivity ./ (second_mix_cps * analyte_sensitivity);
                        factor_d_second_mix_cps  = -analyte_factor / second_mix_cps;
                        factor_d_analyte_sens    = -analyte_factor ./ analyte_sensitivity;
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

                        variance = (d_analyte_mix_cps     .* analyte_mix_cps_sem).^2 + ...
                            (d_analyte_sensitivity .* analyte_sensitivity_unc).^2 + ...
                            (d_host_analyte        .* host_analyte_unc).^2 + ...
                            (d_first_mix_cps       .* first_mix_cps_sem).^2 + ...
                            (d_first_sensitivity   .* first_sensitivity_unc).^2 + ...
                            (d_second_mix_cps      .* second_mix_cps_sem).^2 + ...
                            (d_second_sensitivity  .* second_sensitivity_unc).^2 + ...
                            (d_first_host          .* first_host_unc).^2 + ...
                            (d_second_host         .* second_host_unc).^2 + ...
                            (d_first_fraction      .* first_fraction_unc).^2 + ...
                            (d_second_fraction     .* second_fraction_unc).^2;

                        spot_uncertainty = sqrt(variance);

                        % by construction the inclusion value of each standard is its own mass fraction
                        spot_uncertainty(first_column)  = first_fraction_unc;
                        spot_uncertainty(second_column) = second_fraction_unc;

                        composition_uncertainty(spot_number, analyte_positions) = spot_uncertainty;
                    end

                    app.base.project.session.spot.inclusion_composition_uncertainty{bracket_id, calibrator_index} = ...
                        array2table(composition_uncertainty, 'VariableNames', inclusion_column_names);
                end
            end
        end

        function calculate_inclusion_uncertainties_from_cal_passes(app)

            % Resolves inclusion spots whose IS mass fraction (IS1 and/or IS2) is 'from <CAL>'.
            % The inherited mass fraction and its uncertainty are read from the source calibrator's
            % composition and uncertainty tables and temporarily written into the IS input fields.
            % The three mode functions then treat them like a direct value with a user-entered ±.
            % The original entries are restored after every pass. Passes are repeated until nothing
            % changes, so chains of 'from' spots settle. Must run LAST, after all other inclusion
            % uncertainty functions, because the source rows must be complete.

            if ~isequal(app.PropagateuncertaintiesMenu.Checked, 'on')
                return
            end

            if ~isequal(app.base.project.session.config.reductiontype, 'Inclusion')
                return
            end

            if ~isfield(app.base.project.session.spot, 'inclusion_composition_uncertainty') || ...
                    ~isfield(app.base.project.session.spot, 'inclusion_composition')
                return
            end

            calibrator_mask = strcmp(app.base.project.session.spot.type, "CAL");
            unique_CALs     = unique(app.base.project.session.spot.referencematerial(calibrator_mask));
            unknown_spots   = find(~calibrator_mask);

            number_of_calibrators = size(app.base.project.session.spot.sensitivities, 2);
            number_of_brackets    = size(app.base.project.session.spot.sensitivities, 1);

            maximum_passes = length(unique_CALs);

            % nothing to resolve if no spot takes an IS mass fraction from another calibrator
            any_from_cal = false;
            for calibrator_index = 1:number_of_calibrators
                for bracket_id = 1:number_of_brackets
                    first_fractions  = app.base.project.session.spot.internal_standard_mass_fraction_inclusion{bracket_id, calibrator_index};
                    second_fractions = app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion{bracket_id, calibrator_index};

                    for unknown_number = 1:numel(unknown_spots)
                        spot_number  = unknown_spots(unknown_number);
                        first_entry  = first_fractions{spot_number};
                        second_entry = second_fractions{spot_number};

                        if (~isempty(first_entry) && startsWith(string(first_entry), 'from')) || ...
                                (~isempty(second_entry) && startsWith(string(second_entry), 'from'))
                            any_from_cal = true;
                        end
                    end
                end
            end

            if ~any_from_cal
                return
            end

            for pass_number = 1:maximum_passes

                uncertainty_before_pass = app.base.project.session.spot.inclusion_composition_uncertainty;

                % remember the original input fields so they can be restored after the pass
                original_first_fraction  = app.base.project.session.spot.internal_standard_mass_fraction_inclusion;
                original_first_unc       = app.base.project.session.spot.internal_standard_mass_fraction_uncertainty_inclusion;
                original_second_fraction = app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion;
                original_second_unc      = app.base.project.session.spot.second_internal_standard_mass_fraction_uncertainty_inclusion;

                for calibrator_index = 1:number_of_calibrators
                    for bracket_id = 1:number_of_brackets

                        sensitivity_table = app.base.project.session.spot.sensitivities{bracket_id, calibrator_index};
                        if isempty(sensitivity_table) || isequal(sensitivity_table, zeros(0,0))
                            continue
                        end

                        first_standard_names  = app.base.project.session.spot.internal_standard_inclusion{bracket_id, calibrator_index};
                        second_standard_names = app.base.project.session.spot.second_internal_standard_inclusion{bracket_id, calibrator_index};

                        for unknown_number = 1:numel(unknown_spots)
                            spot_number = unknown_spots(unknown_number);

                            if app.base.project.session.spot.unmixing_via(spot_number) == "None", continue; end

                            first_standard_name  = first_standard_names(spot_number);
                            second_standard_name = second_standard_names(spot_number);
                            if first_standard_name == "", continue; end
                            if isequal(first_standard_name, 'Total Oxides'), continue; end

                            first_entry  = original_first_fraction{bracket_id, calibrator_index}{spot_number};
                            second_entry = original_second_fraction{bracket_id, calibrator_index}{spot_number};

                            first_is_from_cal  = ~isempty(first_entry) && startsWith(string(first_entry), 'from');
                            second_is_from_cal = second_standard_name ~= "" && ~isempty(second_entry) && ...
                                startsWith(string(second_entry), 'from');

                            if ~first_is_from_cal && ~second_is_from_cal, continue; end

                            % look up the inherited IS1 value and its uncertainty in the source calibrator
                            first_source_found = true;
                            if first_is_from_cal
                                first_source_found = false;
                                source_calibrator_index = find(strcmp(unique_CALs, extractAfter(string(first_entry), 'from ')));

                                if ~isempty(source_calibrator_index)
                                    source_composition_table = app.base.project.session.spot.inclusion_composition{bracket_id, source_calibrator_index};
                                    source_uncertainty_table = app.base.project.session.spot.inclusion_composition_uncertainty{bracket_id, source_calibrator_index};

                                    if istable(source_composition_table) && istable(source_uncertainty_table) && ...
                                            ismember(char(first_standard_name), source_composition_table.Properties.VariableNames)
                                        inherited_first_fraction = source_composition_table{spot_number, char(first_standard_name)};
                                        inherited_first_unc      = source_uncertainty_table{spot_number, char(first_standard_name)};
                                        first_source_found       = inherited_first_fraction ~= 0;
                                    end
                                end
                            end

                            % look up the inherited IS2 value and its uncertainty in the source calibrator
                            second_source_found = true;
                            if second_is_from_cal
                                second_source_found = false;
                                source_calibrator_index = find(strcmp(unique_CALs, extractAfter(string(second_entry), 'from ')));

                                if ~isempty(source_calibrator_index)
                                    source_composition_table = app.base.project.session.spot.inclusion_composition{bracket_id, source_calibrator_index};
                                    source_uncertainty_table = app.base.project.session.spot.inclusion_composition_uncertainty{bracket_id, source_calibrator_index};

                                    if istable(source_composition_table) && istable(source_uncertainty_table) && ...
                                            ismember(char(second_standard_name), source_composition_table.Properties.VariableNames)
                                        inherited_second_fraction = source_composition_table{spot_number, char(second_standard_name)};
                                        inherited_second_unc      = source_uncertainty_table{spot_number, char(second_standard_name)};
                                        second_source_found       = inherited_second_fraction ~= 0;
                                    end
                                end
                            end

                            % only substitute if every 'from' value of this spot could be resolved
                            if ~first_source_found || ~second_source_found, continue; end

                            if first_is_from_cal
                                app.base.project.session.spot.internal_standard_mass_fraction_inclusion{bracket_id, calibrator_index}{spot_number} = inherited_first_fraction;
                                app.base.project.session.spot.internal_standard_mass_fraction_uncertainty_inclusion{bracket_id, calibrator_index}(spot_number) = inherited_first_unc;
                            end
                            if second_is_from_cal
                                app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion{bracket_id, calibrator_index}{spot_number} = inherited_second_fraction;
                                app.base.project.session.spot.second_internal_standard_mass_fraction_uncertainty_inclusion{bracket_id, calibrator_index}(spot_number) = inherited_second_unc;
                            end
                        end
                    end
                end

                % run the mode functions with the inherited values in place, then restore the inputs
                try
                    calculate_inclusion_uncertainties_MOT(app)
                    calculate_inclusion_uncertainties_MOT_total_oxides(app)
                    calculate_inclusion_uncertainties_mixing_ratio(app)
                    calculate_inclusion_uncertainties_two_IS(app)
                catch error_in_pass
                    app.base.project.session.spot.internal_standard_mass_fraction_inclusion                        = original_first_fraction;
                    app.base.project.session.spot.internal_standard_mass_fraction_uncertainty_inclusion            = original_first_unc;
                    app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion                 = original_second_fraction;
                    app.base.project.session.spot.second_internal_standard_mass_fraction_uncertainty_inclusion     = original_second_unc;
                    rethrow(error_in_pass)
                end

                app.base.project.session.spot.internal_standard_mass_fraction_inclusion                        = original_first_fraction;
                app.base.project.session.spot.internal_standard_mass_fraction_uncertainty_inclusion            = original_first_unc;
                app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion                 = original_second_fraction;
                app.base.project.session.spot.second_internal_standard_mass_fraction_uncertainty_inclusion     = original_second_unc;

                % stop when this pass changed nothing
                uncertainty_after_pass = app.base.project.session.spot.inclusion_composition_uncertainty;
                changes_made = false;

                for cell_number = 1:numel(uncertainty_after_pass)
                    table_before = uncertainty_before_pass{cell_number};
                    table_after  = uncertainty_after_pass{cell_number};

                    if istable(table_before) && istable(table_after)
                        values_before = table2array(table_before);
                        values_after  = table2array(table_after);

                        if ~isequal(size(values_before), size(values_after)) || ...
                                any(abs(values_after(:) - values_before(:)) > 1e-10)
                            changes_made = true;
                        end
                    end
                end

                if ~changes_made
                    break
                end
            end
        end



    end


    methods (Access = public)

        %%%%%%%%%%%%%%%%%%%%%%%%%% API %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function [settings] = assign_internal_standard(app, settings)
            try
                test_state = true; % is needed later as a failsafe so that no broken data gets into the data structure

                % if settings is not sent or something wrong is put in
                if not(exist('settings', 'var')) || not(isstruct(settings))
                    settings = struct();
                end

                % if the internal_standard is not input
                if not(isfield(settings,'internal_standard')) || isempty(settings.internal_standard)
                    % now return the settings with the options for type:
                    settings.internal_standard.Options={"All Analyte Names or Total Oxides"};
                    disp('The internal standard must be provided in settings.internal_standard');
                    test_state = false;
                end

                % if the internal_standard_mass_fraction is not input
                if not(isfield(settings,'internal_standard_mass_fraction')) || isempty(settings.internal_standard_mass_fraction)
                    settings.internal_standard_mass_fraction.Options={"Mass fraction in µg/g or wt% total oxides"};
                    test_state = false;
                    disp('Internal standard mass fractions must be provided in settings.internal_standard_mass_fraction');
                end

                % if the internal_standard is not input
                if not(isfield(settings,'spotnumber_for_internal_standard')) || isempty(settings.spotnumber_for_internal_standard)
                    settings.spotnumber_for_internal_standard.Options={"Array of spotnumbers"};
                    disp('Spotnumbers for the internal standard must be provided in settings.spotnumber_for_internal_standard');
                    return
                end

                if not(isfield(settings,'internal_standard_for_primary_reference_material')) || isempty(settings.internal_standard_for_primary_reference_material)
                    settings.internal_standard_for_primary_reference_material.Options=string(unique(app.base.project.session.spot.referencematerial));
                    test_state = false;
                    disp('Calibrator name for internal standard mass fractions must be provided in settings.internal_standard_for_primary_reference_material');
                end


                if not(isfield(settings,'internal_standard_for_bracket_id')) || isempty(settings.internal_standard_for_bracket_id)
                    settings.internal_standard_for_bracket_id.Options=string(unique(settings.bracket_id));
                    test_state = false;
                    disp('Bracket_id for internal standard mass fractions must be provided in settings.internal_standard_for_bracket_id');
                end

                % if not(isfield(settings,'internal_standard_oxide_wt')) || isempty(settings.internal_standard_oxide_wt)
                %     settings.internal_standard_oxide_wt.Options = 1:100;
                %     test_state = false;
                %     disp('wt% total oxide must be provided in settings.internal_standard_oxide_wt');
                % end
                %
                % if not(isfield(settings,'Fe_ratio_for_total_oxide')) || isempty(settings.Fe_ratio_for_total_oxide)
                %     settings.Fe_ratio_for_total_oxide.Options = 0:0.01:1;
                %     test_state = false;
                %     disp('FeO/(FeO + Fe2O3) ratio must be provided in settings.Fe_ratio_for_total_oxide');
                % end

                internal_standard_for_primary_reference_material = settings.internal_standard_for_primary_reference_material;
                spotnumber_for_internal_standard = settings.spotnumber_for_internal_standard;
                internal_standard = settings.internal_standard;
                internal_standard_mass_fraction = settings.internal_standard_mass_fraction;
                bracket_ids = settings.internal_standard_for_bracket_id;

                % I will implement this total oxide shit if it is really
                % needed
                %oxide_wt = settings.internal_standard_oxide_wt;
                %fe_ratio = settings.Fe_ratio_for_total_oxide;

                % if test_state = false, push the data from the cache to the
                % data structure
                if test_state == false
                    return
                else

                    % Get unique CALs
                    unique_CALs = unique(app.base.project.session.spot.referencematerial);
                    unique_CALs = unique_CALs(~strcmp(unique_CALs, 'None'));
                    unique_brackets = unique(bracket_ids);

                    % Process each entry
                    for i = 1:length(internal_standard_for_primary_reference_material)
                        % Find corresponding CAL index
                        cal_idx = find(strcmp(unique_CALs, internal_standard_for_primary_reference_material(i)), 1);
                        if isempty(cal_idx)
                            continue;
                        end

                        % Get bracket ID for this entry
                        current_bracket = bracket_ids(i);

                        % Find spot index within the bracket
                        spot_idx = spotnumber_for_internal_standard(i);

                        % Store data in appropriate location
                        app.base.project.session.spot.internal_standard{current_bracket, cal_idx}(spot_idx) = internal_standard(i);
                        app.base.project.session.spot.internal_standard_mass_fraction{current_bracket, cal_idx}{spot_idx} = internal_standard_mass_fraction(i);


                    end
                end

                if isfield(settings, 'quantification_module_GUI_update_state') && settings.quantification_module_GUI_update_state == true
                    update_quantification_module_GUI(app)
                end

            catch ME
                DisplayError(ME,'assign_internal_standard')

                message = "assign_internal_standard failed";
                uialert(app.UIFigure,message,"Warning", ...
                    "Icon","warning");
                disp("assign_internal_standard failed")
            end

        end

        %%%%%%%%%%%%%% Quantification Wrapper %%%%%%%%%%%%%

        function quantification_failed = quantification_wrapper(app)

            quantification_failed = false;

            progress = uiprogressdlg(app.UIFigure, 'Title', 'Quantification', ...
                'Message', 'Calculating...', 'Cancelable', 'off', 'Indeterminate','on');


            % load in the Oxide.xlsx
            get_oxides_from_file(app)


            %%%%%%%%%% Matrix/Host

            calculate_sensitivity_relative_to_the_internal_standard(app)

            calculate_matrix_mass_fractions(app)

            if isequal(app.PropagateuncertaintiesMenu.Checked, 'on')
                calculate_matrix_uncertainties_internal_standard(app)
                calculate_matrix_uncertainties_total_oxides(app)
                calculate_matrix_uncertainties_from_cal_passes(app)
            end

            %%%%%%%%%% Inclusion
            if isequal(app.base.project.session.config.reductiontype, 'Inclusion')

                calculate_sensitivity_relative_to_the_internal_standard_incl(app)
                calculate_sensitivity_relative_to_sec_internal_standard_incl(app)

                inclusion_quantification_failed = calculate_inclusion_mass_fractions(app);

                if inclusion_quantification_failed == true
                    quantification_failed = true;
                    delete(progress)
                    return
                end

                if isequal(app.PropagateuncertaintiesMenu.Checked, 'on')
                    calculate_inclusion_uncertainties_MOT(app)
                    calculate_inclusion_uncertainties_MOT_total_oxides(app)
                    calculate_inclusion_uncertainties_mixing_ratio(app)
                    calculate_inclusion_uncertainties_two_IS(app)
                    calculate_inclusion_uncertainties_from_cal_passes(app)
                end

                lods_failed = calculate_all_inclusion_limits_of_detection(app);

                if lods_failed
                    quantification_failed = true;
                end
            end

            delete(progress)

        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function update_MSF_plot(app)

            spotnames   = app.base.project.session.spot.name(:);
            spotNumbers = (1:numel(spotnames))';
            ref_mat     = app.base.project.session.spot.referencematerial(:);

            if numel(unique(setdiff(ref_mat, "None"))) == 1
                message = {'At least two reference materials (CAL or QCRM) are needed for calculation of the MSF.'};
                uialert(app.UIFigure, message, ' Warning', 'Icon', 'warning');
                return
            end

            all_sensitivities = table(spotNumbers, spotnames, ref_mat, 'VariableNames', {'#', 'Spotname', 'Reference Material'});

            initial_sensitivities = zeros(numel(app.base.project.session.spot.type), numel(app.base.project.session.spot.analytes));
            all_RM = [];

            for i = 1:numel(app.base.project.session.spot.type)
                if strcmp(app.base.project.session.spot.type(i), "CAL") || strcmp(app.base.project.session.spot.type(i), "QCRM")
                    all_RM = [all_RM, i];
                end
            end

            for i = 1:numel(all_RM)
                bg_corrected_cps_matrix = app.base.project.session.spot.bkgd_corrected_cps(all_RM(i), :);

                referencematerial = app.base.project.session.spot.referencematerial(all_RM(i));

                idx = find(strcmp(app.base.project.session.referencematerials.names, referencematerial));

                if ~isempty(idx)
                    RM_table      = app.base.project.session.referencematerials.data{idx};
                    CAL_elements  = RM_table.Properties.VariableNames;
                    cleaned_analytes = regexprep(app.base.project.session.spot.analytes, '\d', '');

                    for j = 1:numel(cleaned_analytes)
                        if ismember(char(cleaned_analytes(j)), CAL_elements)
                            initial_sensitivities(all_RM(i), j) = bg_corrected_cps_matrix.(j) / RM_table.(char(cleaned_analytes(j)));
                        end
                    end
                end
            end

            initial_sensitivities = array2table(initial_sensitivities, "VariableNames", cellstr(app.base.project.session.spot.analytes));
            all_sensitivities = [all_sensitivities, initial_sensitivities];

            %%%%%%%%%%%%%

            referenceMaterials = unique(all_sensitivities.("Reference Material"));  % string array

            processed_sensitivities = table();

            for i = 1:length(referenceMaterials)
                refMaterial = referenceMaterials(i);  % string scalar

                rows = all_sensitivities(strcmp(all_sensitivities.("Reference Material"), refMaterial), :);

                numericData = rows{:, 4:end};
                minValues   = min(numericData, [], 1);
                maxValues   = max(numericData, [], 1);
                meanValues  = mean(numericData, 1, 'omitnan');

                tempTable = table(minValues', maxValues', meanValues', 'VariableNames', {'Min', 'Max', 'Mean'});
                tempTable.Element           = rows.Properties.VariableNames(4:end)';
                tempTable.ReferenceMaterial = repmat({char(refMaterial)}, size(tempTable, 1), 1);

                processed_sensitivities = [processed_sensitivities; tempTable];
            end

            processed_sensitivities = processed_sensitivities(:, {'ReferenceMaterial', 'Element', 'Min', 'Max', 'Mean'});

            %%%%%%%%%%%%%

            emptyRows = all(processed_sensitivities{:, 3:end} == 0, 2);
            processed_sensitivities = processed_sensitivities(~emptyRows, :);

            denominators = app.DenominatorListBox.Value;
            ratios   = {};
            elements = unique(processed_sensitivities.Element);

            for i = 1:length(elements)
                for j = 1:length(denominators)
                    if ~strcmp(elements{i}, denominators{j})
                        ratios{end+1} = [elements{i} '/' denominators{j}];
                    end
                end
            end

            app.RatioListBox.Items     = ratios;
            app.RatioListBox.ItemsData = app.RatioListBox.Items;

            %%%%%%%%%%%%

            sensitivityType  = app.SensitivitybasedonDropDown.Value;
            selected_ratios  = app.RatioListBox.Value;

            if isempty(selected_ratios)
                return
            end

            calculated_ratios = table();

            for i = 1:length(referenceMaterials)
                refMaterial = referenceMaterials(i);  % string scalar

                rows = processed_sensitivities(strcmp(processed_sensitivities.ReferenceMaterial, char(refMaterial)), :);

                for j = 1:length(selected_ratios)
                    parts       = split(selected_ratios{j}, '/');
                    numerator   = parts{1};
                    denominator = parts{2};

                    if any(strcmp(rows.Element, numerator)) && any(strcmp(rows.Element, denominator))
                        numeratorValue   = rows.(sensitivityType)(strcmp(rows.Element, numerator));
                        denominatorValue = rows.(sensitivityType)(strcmp(rows.Element, denominator));
                        ratioValue       = numeratorValue / denominatorValue;

                        calculated_ratios = [calculated_ratios; table({char(refMaterial)}, {selected_ratios{j}}, ratioValue, ...
                            'VariableNames', {'ReferenceMaterial', 'Ratio', 'Value'})];
                    end
                end
            end

            %%%%%%%%%%%%%%%%%%%%%%

            compareToMaterial = app.ComparetoDropDown.Value;

            referenceRows   = calculated_ratios(strcmp(calculated_ratios.ReferenceMaterial, compareToMaterial), :);
            availableRatios = referenceRows.Ratio;
            filtered_ratios = calculated_ratios(ismember(calculated_ratios.Ratio, availableRatios), :);

            if isempty(filtered_ratios)
                return
            end

            referenceRows  = filtered_ratios(strcmp(filtered_ratios.ReferenceMaterial, compareToMaterial), :);
            app.MSF_ratios = table();
            uniqueMaterials = unique(filtered_ratios.ReferenceMaterial);

            for i = 1:length(uniqueMaterials)
                currentMaterial = uniqueMaterials{i};

                if strcmp(currentMaterial, compareToMaterial)
                    continue
                end

                currentRows = filtered_ratios(strcmp(filtered_ratios.ReferenceMaterial, currentMaterial), :);
                tempTable   = table();

                for j = 1:height(currentRows)
                    currentRatio = currentRows.Ratio{j};
                    refRow       = referenceRows(strcmp(referenceRows.Ratio, currentRatio), :);

                    if ~isempty(refRow)
                        normalizedValue = currentRows.Value(j) / refRow.Value;
                        tempTable = [tempTable; table({currentMaterial}, {currentRatio}, normalizedValue, ...
                            'VariableNames', {'ReferenceMaterial', 'Ratio', 'NormalizedValue'})];
                    end
                end

                app.MSF_ratios = [app.MSF_ratios; tempTable];
            end

            app.MSF_ratios = addvars(app.MSF_ratios, ...
                repmat({compareToMaterial}, height(app.MSF_ratios), 1), ...
                'NewVariableNames', 'ComparedTo', ...
                'After', 'NormalizedValue');

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            if isempty(app.MSF_ratios)
                return
            end

            uniqueRatios    = unique(app.MSF_ratios.Ratio);
            uniqueMaterials = unique(app.MSF_ratios.ReferenceMaterial);

            cla(app.MSFAxes);
            hold(app.MSFAxes, 'on');
            colors = lines(length(uniqueRatios));

            for i = 1:length(uniqueRatios)
                currentRatio = uniqueRatios{i};
                ratioRows    = app.MSF_ratios(strcmp(app.MSF_ratios.Ratio, currentRatio), :);
                xValues      = find(ismember(uniqueMaterials, ratioRows.ReferenceMaterial));
                yValues      = ratioRows.NormalizedValue;
                scatter(app.MSFAxes, xValues, yValues, 60, 'filled', 'MarkerFaceColor', colors(i, :), ...
                    'DisplayName', currentRatio, 'MarkerEdgeColor', 'black');
            end

            yline(app.MSFAxes, 1, '--', 'LineWidth', 1.5, 'Color', 'k', 'HandleVisibility', 'off');
            set(app.MSFAxes, 'XTick', 1:length(uniqueMaterials), 'XTickLabel', uniqueMaterials, 'TickLabelInterpreter', 'none');
            xlim(app.MSFAxes, [0.5, length(uniqueMaterials) + 0.5]);
            xlabel(app.MSFAxes, 'Reference Materials', 'Interpreter', 'none');
            ylabel(app.MSFAxes, compareToMaterial, 'Interpreter', 'none');

            if app.ShowLegendCheckBox.Value
                legend(app.MSFAxes, 'show', 'Location', 'northeast', 'Interpreter', 'none');
            else
                legend(app.MSFAxes, 'off');
            end

            grid(app.MSFAxes, 'on');
            hold(app.MSFAxes, 'off');
        end


        function update_quantification_module_GUI(app)

            cal_indices   = app.base.project.session.spot.type == "CAL";
            cal_materials = app.base.project.session.spot.referencematerial(cal_indices);
            unique_names  = unique(cal_materials);
            unique_names  = unique_names(unique_names ~= "None");
            validCALs     = unique_names(unique_names ~= "Select Reference Material");

            app.CalibratorDropDown.Items     = validCALs;
            app.CalibratorDropDown.ItemsData = 1:numel(app.CalibratorDropDown.Items);

            selectedRM        = validCALs(app.CalibratorDropDown.Value);
            rmIndices         = app.base.project.session.spot.referencematerial == selectedRM;
            filteredBracketIds = app.base.project.session.spot.bracket_id(rmIndices);
            uniqueBracketIds  = unique(filteredBracketIds);
            uniqueBracketIds  = uniqueBracketIds(uniqueBracketIds ~= 0);

            app.BracketidDropDown.Items     = string(uniqueBracketIds);
            app.BracketidDropDown.ItemsData = uniqueBracketIds;

            if isempty(app.selected_CAL)
                app.selected_CAL = 1;
            end
            if isempty(app.selected_bracket_id)
                app.selected_bracket_id      = uniqueBracketIds(1);
                app.BracketidDropDown.Value  = uniqueBracketIds(1);
            end

            if isequal(app.base.project.session.config.reductiontype, 'Inclusion')
                app.HostInclusionDropDown.Items     = ["Host", "Inclusion"];
                app.HostInclusionDropDown.ItemsData = app.HostInclusionDropDown.Items;
            elseif isequal(app.base.project.session.config.reductiontype, 'Matrix')
                app.HostInclusionDropDown.Visible   = 'off';
                app.HostInclusionDropDown.Enable    = 'off';
                app.HostInclusionDropDown.Items     = "Host";
                app.HostInclusionDropDown.ItemsData = app.HostInclusionDropDown.Items;
            end

            if isempty(app.selected_host_inclusion)
                app.selected_host_inclusion = app.HostInclusionDropDown.ItemsData(1);
            end

            if app.selected_host_inclusion == "Inclusion"
                app.MatrixTable.Visible    = 'off';
                app.InclusionTable.Visible = 'on';
                update_inclusion_table(app)

            elseif app.selected_host_inclusion == "Host"
                app.MatrixTable.Visible    = 'on';
                app.InclusionTable.Visible = 'off';
                update_matrix_table(app)
            end

            if strcmp(app.selected_table, 'InclusionTable')
                if ~isempty(app.InclusionTable.Selection)
                    selectedCol = unique(app.InclusionTable.Selection(:, 2));
                    colName     = app.InclusionTable.ColumnName{selectedCol};
                else
                    return;
                end
            elseif strcmp(app.selected_table, 'MatrixTable')
                if ~isempty(app.MatrixTable.Selection)
                    selectedCol = unique(app.MatrixTable.Selection(:, 2));
                    colName     = app.MatrixTable.ColumnName{selectedCol};
                else
                    return;
                end
            end

            if isempty(app.selected_spot)
                app.selected_spot = 1;
            end

            if ~exist('colName') %#ok
                colName = 'Analyte';
            end

            sensVarNames = string(app.base.project.session.spot.sensitivities{app.BracketidDropDown.Value, app.selected_CAL}.Properties.VariableNames');

            if contains(colName, 'Analyte') && strcmp(app.selected_table, 'MatrixTable')

                if ~isempty(app.selected_CAL)
                    app.AnalyteListBox.Visible   = 'on';
                    app.AnalyteListBox.Items     = ["=================="; "Total Oxides"; sensVarNames];
                    app.AnalyteListBox.ItemsData = app.AnalyteListBox.Items;
                    app.fromCALListBox.Visible   = 'off';
                end

            elseif contains(colName, '% Total Oxides') || contains(colName, 'FeO/(FeO + Fe2O3)')

                app.AnalyteListBox.Visible = 'off';
                app.fromCALListBox.Visible = 'off';

            elseif contains(colName, 'Analyte (I.S.1)') && strcmp(app.selected_table, 'InclusionTable')

                if ~isempty(app.selected_CAL)
                    app.AnalyteListBox.Visible = 'on';

                    if app.base.project.session.spot.unmixing_via(app.selected_spot) ~= "Two internal standards"
                        app.AnalyteListBox.Items = ["=================="; "Total Oxides"; sensVarNames];
                    else
                        app.AnalyteListBox.Items = ["=================="; sensVarNames];
                    end

                    app.AnalyteListBox.ItemsData = app.AnalyteListBox.Items;
                    app.fromCALListBox.Visible   = 'off';
                end

            elseif contains(colName, 'Analyte (I.S.2)') && strcmp(app.selected_table, 'InclusionTable')

                if ~isempty(app.selected_CAL)
                    app.AnalyteListBox.Visible   = 'on';
                    app.AnalyteListBox.Items     = ["=================="; sensVarNames];
                    app.AnalyteListBox.ItemsData = app.AnalyteListBox.Items;
                    app.fromCALListBox.Visible   = 'off';
                end

            elseif contains(colName, '± 1σ')
                app.AnalyteListBox.Visible = 'off';
                app.fromCALListBox.Visible = 'off';

            elseif contains(colName, 'µg/g') && strcmp(app.selected_table, 'MatrixTable')

                app.AnalyteListBox.Visible = 'off';

                internalStandardValues = app.base.project.session.spot.internal_standard{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot);

                if any(internalStandardValues == "Total Oxides")
                    app.fromCALListBox.Visible = 'off';
                else
                    availableCALs = [];
                    for cal = 1:numel(validCALs)
                        if validCALs(cal) == validCALs(app.selected_CAL)
                            continue;
                        end
                        sens = app.base.project.session.spot.sensitivities{app.BracketidDropDown.Value, cal};
                        if ~isempty(sens) && ~isequal(sens, 0) && istable(sens)
                            sens_data = table2array(sens);
                            row_sums  = sum(sens_data(app.selected_spot, :), 2);
                            if all(row_sums ~= 0)
                                availableCALs = [availableCALs; validCALs(cal)];
                            end
                        end
                    end

                    if ~isempty(availableCALs)
                        app.fromCALListBox.Visible = 'on';
                        app.fromCALListBox.Items   = ["=================="; "from " + availableCALs];
                    else
                        app.fromCALListBox.Visible = 'off';
                    end
                end

            elseif contains(colName, 'µg/g') && strcmp(app.selected_table, 'InclusionTable')

                app.AnalyteListBox.Visible = 'off';

                if contains(colName, '(I.S.1)')
                    internalStandardValues = app.base.project.session.spot.internal_standard_inclusion{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot);
                elseif contains(colName, '(I.S.2)')
                    internalStandardValues = app.base.project.session.spot.second_internal_standard_inclusion{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot);
                end

                if any(internalStandardValues == "Total Oxides")
                    app.fromCALListBox.Visible = 'off';
                else
                    availableCALs = [];
                    for cal = 1:numel(validCALs)
                        if validCALs(cal) == validCALs(app.selected_CAL)
                            continue;
                        end
                        sens = app.base.project.session.spot.sensitivities{app.BracketidDropDown.Value, cal};
                        if ~isempty(sens) && ~isequal(sens, 0) && istable(sens)
                            sens_data = table2array(sens);
                            row_sums  = sum(sens_data(app.selected_spot, :), 2);
                            if all(row_sums ~= 0)
                                availableCALs = [availableCALs; validCALs(cal)];
                            end
                        end
                    end

                    if ~isempty(availableCALs)
                        app.fromCALListBox.Visible = 'on';
                        app.fromCALListBox.Items   = ["=================="; "from " + availableCALs];
                    else
                        app.fromCALListBox.Visible = 'off';
                    end
                end
            end

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

            app.QuantificationButton.Enable = "on";
            app.QuantificationButton.BackgroundColor = orange;
            app.QuantificationButton.FontWeight = 'bold';

            if isfield(status, 'results') && status.results == true
                app.ResultsButton.Enable = "on";
                app.ResultsButton.BackgroundColor = green;
            else
                app.ResultsButton.Enable = "off";
                app.ResultsButton.BackgroundColor = red;
            end

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
                app.base.project.session.config.module_status.quantification = true;
                app.editstatus = true; % always set to true so that the quantification triggers at the end
                %% Att this might be bullshit and has to be revisited


            elseif exist("project_id","var") && exist("session_id","var") % coming from the base, GUI stuff

                app.base.project.session =  app.sourceapp.base(project_id).project(session_id).session;

            end

            app.project_id = project_id;
            app.session_id = session_id;
            app.UIFigure.Name = [char(app.base.project_name) ' - ' char(app.base.project.session.session_name)]; %string(app.base.project.session.session_name);

            n         = size(app.base.project.session.spot.signal_starts, 1);
            sens_rows = size(app.base.project.session.spot.sensitivities, 1);
            sens_cols = size(app.base.project.session.spot.sensitivities, 2);

            if ~isfield(app.base.project.session.spot, 'internal_standard') || ...
                    isempty(app.base.project.session.spot.internal_standard)
                app.base.project.session.spot.internal_standard = ...
                    repmat({repmat("", n, 1)}, sens_rows, sens_cols);
            end

            if ~isfield(app.base.project.session.spot, 'internal_standard_mass_fraction') || ...
                    isempty(app.base.project.session.spot.internal_standard_mass_fraction)
                app.base.project.session.spot.internal_standard_mass_fraction = ...
                    repmat({cell(n, 1)}, sens_rows, sens_cols);
            end

            if ~isfield(app.base.project.session.spot, 'internal_standard_oxide_wt') || ...
                    isempty(app.base.project.session.spot.internal_standard_oxide_wt)
                app.base.project.session.spot.internal_standard_oxide_wt = ...
                    repmat({NaN(n, 1)}, sens_rows, sens_cols);
            end

            if ~isfield(app.base.project.session.spot, 'Fe_ratio_for_total_oxide') || ...
                    isempty(app.base.project.session.spot.Fe_ratio_for_total_oxide)
                app.base.project.session.spot.Fe_ratio_for_total_oxide = ...
                    repmat({NaN(n, 1)}, sens_rows, sens_cols);
            end

            if ~isfield(app.base.project.session.spot, 'internal_standard_mass_fraction_uncertainty') || ...
                    isempty(app.base.project.session.spot.internal_standard_mass_fraction_uncertainty)
                app.base.project.session.spot.internal_standard_mass_fraction_uncertainty = ...
                    repmat({NaN(n, 1)}, sens_rows, sens_cols);
            end

            if ~isfield(app.base.project.session.spot, 'internal_standard_oxide_wt_uncertainty') || ...
                    isempty(app.base.project.session.spot.internal_standard_oxide_wt_uncertainty)
                app.base.project.session.spot.internal_standard_oxide_wt_uncertainty = ...
                    repmat({NaN(n, 1)}, sens_rows, sens_cols);
            end

            if ~isfield(app.base.project.session.spot, 'matrix_composition')
                app.base.project.session.spot.matrix_composition = ...
                    cell(sens_rows, sens_cols);
            end

            if ~isfield(app.base.project.session.spot, 'matrix_limits_of_detection')
                app.base.project.session.spot.matrix_limits_of_detection = ...
                    cell(sens_rows, sens_cols);
            end

            if ~isfield(app.base.project.session.spot, 'matrix_composition_uncertainty')
                app.base.project.session.spot.matrix_composition_uncertainty = ...
                    cell(sens_rows, sens_cols);
            end



            if isequal(app.base.project.session.config.reductiontype, 'Inclusion')

                if ~isfield(app.base.project.session.spot, 'internal_standard_inclusion') || ...
                        isempty(app.base.project.session.spot.internal_standard_inclusion)
                    app.base.project.session.spot.internal_standard_inclusion = ...
                        repmat({repmat("", n, 1)}, sens_rows, sens_cols);
                end

                if ~isfield(app.base.project.session.spot, 'internal_standard_mass_fraction_inclusion') || ...
                        isempty(app.base.project.session.spot.internal_standard_mass_fraction_inclusion)
                    app.base.project.session.spot.internal_standard_mass_fraction_inclusion = ...
                        repmat({cell(n, 1)}, sens_rows, sens_cols);
                end

                if ~isfield(app.base.project.session.spot, 'second_internal_standard_inclusion') || ...
                        isempty(app.base.project.session.spot.second_internal_standard_inclusion)
                    app.base.project.session.spot.second_internal_standard_inclusion = ...
                        repmat({repmat("", n, 1)}, sens_rows, sens_cols);
                end

                if ~isfield(app.base.project.session.spot, 'second_internal_standard_mass_fraction_inclusion') || ...
                        isempty(app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion)
                    app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion = ...
                        repmat({cell(n, 1)}, sens_rows, sens_cols);
                end

                if ~isfield(app.base.project.session.spot, 'internal_standard_oxide_wt_inclusion') || ...
                        isempty(app.base.project.session.spot.internal_standard_oxide_wt_inclusion)
                    app.base.project.session.spot.internal_standard_oxide_wt_inclusion = ...
                        repmat({NaN(n, 1)}, sens_rows, sens_cols);
                end

                if ~isfield(app.base.project.session.spot, 'Fe_ratio_for_total_oxide_inclusion') || ...
                        isempty(app.base.project.session.spot.Fe_ratio_for_total_oxide_inclusion)
                    app.base.project.session.spot.Fe_ratio_for_total_oxide_inclusion = ...
                        repmat({NaN(n, 1)}, sens_rows, sens_cols);
                end

                if ~isfield(app.base.project.session.spot, 'inclusion_composition')
                    app.base.project.session.spot.inclusion_composition = ...
                        cell(sens_rows, sens_cols);
                end

                if ~isfield(app.base.project.session.spot, 'inclusion_limits_of_detection')
                    app.base.project.session.spot.inclusion_limits_of_detection = ...
                        cell(sens_rows, sens_cols);
                end

                if ~isfield(app.base.project.session.spot, 'mixing_ratio') || ...
                        isempty(app.base.project.session.spot.mixing_ratio)
                    app.base.project.session.spot.mixing_ratio = ...
                        repmat({NaN(n, 1)}, sens_rows, sens_cols);
                end


                n_spots   = size(app.base.project.session.spot.signal_starts, 1);

                if ~isfield(app.base.project.session.spot, 'internal_standard_mass_fraction_uncertainty_inclusion')
                    app.base.project.session.spot.internal_standard_mass_fraction_uncertainty_inclusion = repmat({NaN(n_spots, 1)}, sens_rows, sens_cols);
                end
                if ~isfield(app.base.project.session.spot, 'internal_standard_oxide_wt_uncertainty_inclusion')
                    app.base.project.session.spot.internal_standard_oxide_wt_uncertainty_inclusion = repmat({NaN(n_spots, 1)}, sens_rows, sens_cols);
                end
                if ~isfield(app.base.project.session.spot, 'second_internal_standard_mass_fraction_uncertainty_inclusion')
                    app.base.project.session.spot.second_internal_standard_mass_fraction_uncertainty_inclusion = repmat({NaN(n_spots, 1)}, sens_rows, sens_cols);
                end
                if ~isfield(app.base.project.session.spot, 'mixing_ratio_uncertainty_inclusion')
                    app.base.project.session.spot.mixing_ratio_uncertainty_inclusion = repmat({NaN(n_spots, 1)}, sens_rows, sens_cols);
                end


            end

            % read in the Oxide.xlsx
            try
                if ~isfield(app.base.project.session.config, 'total_oxides_path')

                    % Check if the main app has the path property set (User Documents)
                    if isprop(app.sourceapp, 'default_oxides_path') && ~isempty(app.sourceapp.default_oxides_path)
                        app.base.project.session.config.total_oxides_path = app.sourceapp.default_oxides_path;

                        % Fallback (Installation Directory)
                    elseif exist(fullfile(app.sourceapp.installpath, 'Total_Oxide_Calculations'), 'dir')
                        app.base.project.session.config.total_oxides_path = fullfile(app.sourceapp.installpath, 'Total_Oxide_Calculations');
                    end
                end

            catch ME
                DisplayError(ME,'Error reading Total Oxides Path')
                message={'Error reading Total Oxides Path'};
                uialert(app.UIFigure,message,' Error');
            end

            if isfield(app.base.project.session.config, 'internal_standard_uncertainty') && ...
                    app.base.project.session.config.internal_standard_uncertainty
                app.EnableinternalstandarduncertaintyMenu.Checked = 'on';
            else
                app.EnableinternalstandarduncertaintyMenu.Checked = 'off';
            end

            app.selected_table = 'MatrixTable';

            % Change "PRM" to "CAL" & "SRM" to "QCRM"-Backwards compatibility
            app.base.project.session.spot.type(app.base.project.session.spot.type == "PRM") = "CAL";
            app.base.project.session.spot.type(app.base.project.session.spot.type == "SRM") = "QCRM";
            
            if isfield(app.base.project.session.spot, 'prm_sensitivities')
                % Copy data to the new field
                [app.base.project.session.spot.cal_sensitivities] = app.base.project.session.spot.prm_sensitivities;
                % Remove the old field
                app.base.project.session.spot = rmfield(app.base.project.session.spot, 'prm_sensitivities');
            end


            update_progress_buttons(app)
            update_quantification_module_GUI(app)


            %%% Relative Sensitivity Factor
            refmat = unique(app.base.project.session.spot.referencematerial);
            app.ComparetoDropDown.Items = refmat(refmat ~= "None");
            app.ComparetoDropDown.ItemsData = app.ComparetoDropDown.Items;
            app.DenominatorListBox.Items = app.base.project.session.spot.analytes;
            app.DenominatorListBox.ItemsData = app.DenominatorListBox.Items;

            app.UIFigure.Tag = sprintf('%d_%d', app.project_id, app.session_id);

            watch_session_changes(app);
        end

        % Button pushed function: ResetButton
        function ResetButtonPushed(app, event)
            changes = check_changes(app, 'quantification');
            if changes == false
                return
            end
            app.editstatus = true;

            n         = size(app.base.project.session.spot.signal_starts, 1);
            sens_rows = size(app.base.project.session.spot.sensitivities, 1);
            sens_cols = size(app.base.project.session.spot.sensitivities, 2);

            app.base.project.session.spot.internal_standard                                = repmat({repmat("", n, 1)}, sens_rows, sens_cols);
            app.base.project.session.spot.internal_standard_mass_fraction                  = repmat({cell(n, 1)},       sens_rows, sens_cols);
            app.base.project.session.spot.internal_standard_mass_fraction_uncertainty      = repmat({NaN(n, 1)},        sens_rows, sens_cols);
            app.base.project.session.spot.internal_standard_oxide_wt                       = repmat({NaN(n, 1)},        sens_rows, sens_cols);
            app.base.project.session.spot.internal_standard_oxide_wt_uncertainty           = repmat({NaN(n, 1)},        sens_rows, sens_cols);
            app.base.project.session.spot.Fe_ratio_for_total_oxide                         = repmat({NaN(n, 1)},        sens_rows, sens_cols);


            if isequal(app.base.project.session.config.reductiontype, 'Inclusion')
                app.base.project.session.spot.internal_standard_inclusion                      = repmat({repmat("", n, 1)}, sens_rows, sens_cols);
                app.base.project.session.spot.internal_standard_mass_fraction_inclusion        = repmat({cell(n, 1)},       sens_rows, sens_cols);
                app.base.project.session.spot.internal_standard_oxide_wt_inclusion             = repmat({NaN(n, 1)},        sens_rows, sens_cols);
                app.base.project.session.spot.Fe_ratio_for_total_oxide_inclusion               = repmat({NaN(n, 1)},        sens_rows, sens_cols);
                app.base.project.session.spot.second_internal_standard_inclusion               = repmat({repmat("", n, 1)}, sens_rows, sens_cols);
                app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion = repmat({cell(n, 1)},       sens_rows, sens_cols);
                app.base.project.session.spot.mixing_ratio                                     = repmat({NaN(n, 1)},        sens_rows, sens_cols);

                app.base.project.session.spot.internal_standard_mass_fraction_uncertainty_inclusion        = repmat({NaN(n, 1)}, sens_rows, sens_cols);
                app.base.project.session.spot.internal_standard_oxide_wt_uncertainty_inclusion             = repmat({NaN(n, 1)}, sens_rows, sens_cols);
                app.base.project.session.spot.second_internal_standard_mass_fraction_uncertainty_inclusion = repmat({NaN(n, 1)}, sens_rows, sens_cols);
                app.base.project.session.spot.mixing_ratio_uncertainty_inclusion                           = repmat({NaN(n, 1)}, sens_rows, sens_cols);
            end


            update_quantification_module_GUI(app)

        end

        % Callback function: MatrixTable
        function MatrixTableSelectionChanged(app, event)
            % Update selected_spot based on spotnumber instead of cell index
            if ~isempty(app.MatrixTable.Selection)
                selectedRows = unique(app.MatrixTable.Selection(:, 1));
                app.selected_spot = app.MatrixTable.Data{selectedRows, '#'}; % Use spotnumber from the table
                app.selected_table = 'MatrixTable';

                update_quantification_module_GUI(app);
            end
        end

        % Cell edit callback: MatrixTable
        function MatrixTableCellEdit(app, event)
            changes = check_changes(app, 'quantification');
            if changes == false
                return
            end
            app.editstatus = true;

            indices = event.Indices;
            newData = event.NewData;

            if ischar(newData) || isstring(newData)
                if ~startsWith(lower(newData), 'from')
                    try
                        newData = str2double(newData);
                        if isnan(newData), newData = NaN; end
                    catch
                        newData = NaN;
                    end
                end
            elseif ~isnumeric(newData);  newData = NaN;
            elseif isnan(newData);       newData = NaN;
            elseif isequal(newData, 0);  newData = NaN;
            elseif newData < 0;          newData = NaN;
            elseif strcmp(app.MatrixTable.ColumnName{indices(2)}, 'FeO/(FeO + Fe2O3)') && (newData < 0 || newData > 1);   newData = NaN;
            elseif strcmp(app.MatrixTable.ColumnName{indices(2)}, '% Total Oxides')     && (newData < 0 || newData > 100); newData = NaN;
            end

            b = app.BracketidDropDown.Value;
            c = app.selected_CAL;

            for spot_idx = app.selected_spot'
                switch app.MatrixTable.ColumnName{indices(2)}
                    case '[µg/g]'
                        app.base.project.session.spot.internal_standard_mass_fraction{b, c}{spot_idx} = newData;
                    case '± 1σ [µg/g]'
                        is_frac = app.base.project.session.spot.internal_standard_mass_fraction{b, c}{spot_idx};
                        is_val  = app.base.project.session.spot.internal_standard{b, c}(spot_idx);
                        if ~isequal(is_val, 'Total Oxides') && ~startsWith(string(is_frac), 'from')
                            app.base.project.session.spot.internal_standard_mass_fraction_uncertainty{b, c}(spot_idx) = newData;
                        end
                    case '% Total Oxides'
                        app.base.project.session.spot.internal_standard_oxide_wt{b, c}(spot_idx) = newData;
                    case '± 1σ [%]'
                        app.base.project.session.spot.internal_standard_oxide_wt_uncertainty{b, c}(spot_idx) = newData;
                    case 'FeO/(FeO + Fe2O3)'
                        app.base.project.session.spot.Fe_ratio_for_total_oxide{b, c}(spot_idx) = newData;
                end
            end

            update_quantification_module_GUI(app)
        end

        % Value changed function: AnalyteListBox
        function AnalyteListBoxValueChanged(app, event)


            newValues = repmat(string(app.AnalyteListBox.Value), length(app.selected_spot), 1);

            if all(newValues == "==================")
                return
            end

            changes = check_changes(app, 'quantification');
            if changes == false
                return
            end
            app.editstatus = true;

            if strcmp(app.selected_table, 'InclusionTable') && contains(app.selected_column, '(I.S.1)')
                app.base.project.session.spot.internal_standard_inclusion{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot) = newValues;

                if any(contains(newValues, 'Total Oxides'))
                    app.base.project.session.spot.internal_standard_oxide_wt_inclusion{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot)     = 100;
                    app.base.project.session.spot.Fe_ratio_for_total_oxide_inclusion{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot)       = 1;
                    app.base.project.session.spot.internal_standard_mass_fraction_inclusion{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot) = {[]};

                    % the µg/g value is emptied here, so its uncertainty goes too; the oxide uncertainty starts fresh
                    app.base.project.session.spot.internal_standard_mass_fraction_uncertainty_inclusion{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot) = NaN;
                    app.base.project.session.spot.internal_standard_oxide_wt_uncertainty_inclusion{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot)      = NaN;
                else
                    app.base.project.session.spot.internal_standard_oxide_wt_inclusion{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot) = NaN;
                    app.base.project.session.spot.Fe_ratio_for_total_oxide_inclusion{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot)   = NaN;

                    % leaving Total Oxides: the oxide uncertainty no longer applies
                    app.base.project.session.spot.internal_standard_oxide_wt_uncertainty_inclusion{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot) = NaN;
                end

            elseif strcmp(app.selected_table, 'InclusionTable') && contains(app.selected_column, '(I.S.2)')

                if any(~ismember(app.selected_spot, app.two_IS_rows))
                    app.fromCALListBox.Value = "==================";
                    return
                else
                    app.base.project.session.spot.second_internal_standard_inclusion{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot) = newValues;
                end

            elseif strcmp(app.selected_table, 'MatrixTable')
                app.base.project.session.spot.internal_standard{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot) = newValues;

                if any(contains(newValues, 'Total Oxides'))
                    app.base.project.session.spot.internal_standard_oxide_wt{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot)     = 100;
                    app.base.project.session.spot.Fe_ratio_for_total_oxide{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot)       = 1;
                    app.base.project.session.spot.internal_standard_mass_fraction{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot) = {[]};
                    if isfield(app.base.project.session.spot, 'internal_standard_mass_fraction_uncertainty')
                        app.base.project.session.spot.internal_standard_mass_fraction_uncertainty{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot) = NaN;
                    end
                    if isfield(app.base.project.session.spot, 'internal_standard_oxide_wt_uncertainty')
                        app.base.project.session.spot.internal_standard_oxide_wt_uncertainty{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot) = NaN;
                    end

                else
                    app.base.project.session.spot.internal_standard_oxide_wt{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot) = NaN;
                    app.base.project.session.spot.Fe_ratio_for_total_oxide{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot)   = NaN;
                    if isfield(app.base.project.session.spot, 'internal_standard_mass_fraction_uncertainty')
                        app.base.project.session.spot.internal_standard_mass_fraction_uncertainty{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot) = NaN;
                    end
                    if isfield(app.base.project.session.spot, 'internal_standard_oxide_wt_uncertainty')
                        app.base.project.session.spot.internal_standard_oxide_wt_uncertainty{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot) = NaN;
                    end

                    cleaned_IS = regexprep(newValues, '\d', '');

                    for i = 1:length(app.selected_spot)
                        if app.base.project.session.spot.type(app.selected_spot(i)) == "QCRM"
                            current_qcrm = app.base.project.session.spot.referencematerial(app.selected_spot(i));
                            qcrm_idx     = find(app.base.project.session.referencematerials.names == current_qcrm, 1);

                            if ~isempty(qcrm_idx)
                                qcrm_data = app.base.project.session.referencematerials.data{qcrm_idx};

                                if ismember(char(cleaned_IS(1)), qcrm_data.Properties.VariableNames)
                                    app.base.project.session.spot.internal_standard_mass_fraction{app.BracketidDropDown.Value, app.selected_CAL}{app.selected_spot(i)} = qcrm_data.(char(cleaned_IS(1)));
                                else
                                    app.base.project.session.spot.internal_standard_mass_fraction{app.BracketidDropDown.Value, app.selected_CAL}{app.selected_spot(i)} = [];
                                end

                                if strcmp(app.EnableinternalstandarduncertaintyMenu.Checked, 'on') && ...
                                        isfield(app.base.project.session.spot, 'internal_standard_mass_fraction_uncertainty')
                                    unc_tbl = app.base.project.session.referencematerials.uncertainty{qcrm_idx};
                                    if ~isempty(unc_tbl) && ismember(char(cleaned_IS(1)), unc_tbl.Properties.VariableNames)
                                        app.base.project.session.spot.internal_standard_mass_fraction_uncertainty{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot(i)) = unc_tbl.(char(cleaned_IS(1)));
                                    else
                                        app.base.project.session.spot.internal_standard_mass_fraction_uncertainty{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot(i)) = NaN;
                                    end
                                end

                            else
                                app.base.project.session.spot.internal_standard_mass_fraction{app.BracketidDropDown.Value, app.selected_CAL}{app.selected_spot(i)} = [];
                            end
                        else
                            app.base.project.session.spot.internal_standard_mass_fraction{app.BracketidDropDown.Value, app.selected_CAL}{app.selected_spot(i)} = [];
                        end
                    end
                end
            end

            app.AnalyteListBox.Value = "==================";

            update_quantification_module_GUI(app)
        end

        % Value changed function: fromCALListBox
        function fromCALListBoxValueChanged(app, event)


            newValue = string(app.fromCALListBox.Value);

            if newValue == "=================="
                return
            end

            changes = check_changes(app, 'quantification');
            if changes == false
                return
            end
            app.editstatus = true;

            newValues = repmat({newValue}, length(app.selected_spot), 1);

            if app.selected_table == "InclusionTable" && contains(app.selected_column, '(I.S.1)')
                app.base.project.session.spot.internal_standard_mass_fraction_inclusion{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot) = newValues;

                % the value now comes from another calibrator and carries its own uncertainty
                app.base.project.session.spot.internal_standard_mass_fraction_uncertainty_inclusion{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot) = NaN;

            elseif app.selected_table == "InclusionTable" && contains(app.selected_column, '(I.S.2)')
                if any(~ismember(app.selected_spot, app.two_IS_rows))
                    app.fromCALListBox.Value = "==================";
                    return
                else
                    app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot) = newValues;
                    app.base.project.session.spot.second_internal_standard_mass_fraction_uncertainty_inclusion{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot) = NaN;
                end

            elseif app.selected_table == "MatrixTable"
                app.base.project.session.spot.internal_standard_mass_fraction{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot) = newValues;
                if isfield(app.base.project.session.spot, 'internal_standard_mass_fraction_uncertainty')
                    app.base.project.session.spot.internal_standard_mass_fraction_uncertainty{app.BracketidDropDown.Value, app.selected_CAL}(app.selected_spot) = NaN;
                end
            end

            app.fromCALListBox.Value = "==================";

            update_quantification_module_GUI(app)
        end

        % Value changed function: SpotnamecontainsEditField
        function SpotnamecontainsEditFieldValueChanged(app, event)
 

        end

        % Button pushed function: ApplyButton
        function ApplyButtonPushed(app, event)
            changes = check_changes(app, 'quantification');
            if changes == false
                return
            end
            app.editstatus = true;

            newData = app.StringCompareInputEditField.Value;
            colName = app.StringCompareDropDown.Value;

            if ischar(newData) || isstring(newData)
                if ~startsWith(lower(newData), 'from')
                    try
                        newData = str2double(newData);
                        if isnan(newData), newData = NaN; end
                    catch
                        newData = NaN;
                    end
                end
            elseif ~isnumeric(newData);  newData = NaN;
            elseif isnan(newData);       newData = NaN;
            elseif isequal(newData, 0);  newData = NaN;
            elseif newData < 0;          newData = NaN;
            elseif strcmp(colName, 'FeO/(FeO + Fe2O3)') && (newData < 0 || newData > 1);   newData = NaN;
            elseif strcmp(colName, '% Total Oxides')     && (newData < 0 || newData > 100); newData = NaN;
            end

            bracket_id       = app.BracketidDropDown.Value;
            calibrator_index = app.selected_CAL;

            editing_inclusion_table = app.selected_host_inclusion == "Inclusion";

            if editing_inclusion_table

                % numeric columns accept numbers only; text such as "from ..." becomes NaN there
                if isnumeric(newData)
                    numeric_value = newData;
                else
                    numeric_value = NaN;
                end

                % mass fraction cells keep "from ..." text, and use [] instead of NaN for "not set"
                mass_fraction_value = newData;
                if isnumeric(mass_fraction_value) && isnan(mass_fraction_value)
                    mass_fraction_value = [];
                end

                % uncertainty columns store a plain positive number, NaN means "not set"
                if isnumeric(newData) && ~isnan(newData)
                    uncertainty_value = newData;
                else
                    uncertainty_value = NaN;
                end

                for spot_idx = app.selected_spot'
                    switch colName

                        case '[µg/g] (I.S.1)'
                            app.base.project.session.spot.internal_standard_mass_fraction_inclusion{bracket_id, calibrator_index}{spot_idx} = mass_fraction_value;

                        case '% Total Oxides'
                            app.base.project.session.spot.internal_standard_oxide_wt_inclusion{bracket_id, calibrator_index}(spot_idx) = numeric_value;

                        case 'FeO/(FeO + Fe2O3)'
                            app.base.project.session.spot.Fe_ratio_for_total_oxide_inclusion{bracket_id, calibrator_index}(spot_idx) = numeric_value;

                        case '[µg/g] (I.S.2)'
                            if ismember(spot_idx, app.two_IS_rows)
                                app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion{bracket_id, calibrator_index}{spot_idx} = mass_fraction_value;
                            else
                                app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion{bracket_id, calibrator_index}{spot_idx} = [];
                            end

                        case 'Mixing Ratio (x)'
                            mixing_ratio_value = numeric_value;
                            if ~isnan(mixing_ratio_value) && (mixing_ratio_value <= 0 || mixing_ratio_value > 1)
                                mixing_ratio_value = NaN;
                            end

                            number_of_spots = size(app.base.project.session.spot.signal_starts, 1);
                            if ~isfield(app.base.project.session.spot, 'mixing_ratio') || isempty(app.base.project.session.spot.mixing_ratio)
                                number_of_sensitivity_rows    = size(app.base.project.session.spot.sensitivities, 1);
                                number_of_sensitivity_columns = size(app.base.project.session.spot.sensitivities, 2);
                                app.base.project.session.spot.mixing_ratio = repmat({NaN(number_of_spots, 1)}, number_of_sensitivity_rows, number_of_sensitivity_columns);
                            elseif numel(app.base.project.session.spot.mixing_ratio{bracket_id, calibrator_index}) ~= number_of_spots
                                app.base.project.session.spot.mixing_ratio{bracket_id, calibrator_index} = NaN(number_of_spots, 1);
                            end
                            app.base.project.session.spot.mixing_ratio{bracket_id, calibrator_index}(spot_idx) = mixing_ratio_value;

                        case '± 1σ [µg/g] (I.S.1)'
                            internal_standard_1_name          = app.base.project.session.spot.internal_standard_inclusion{bracket_id, calibrator_index}(spot_idx);
                            internal_standard_1_mass_fraction = app.base.project.session.spot.internal_standard_mass_fraction_inclusion{bracket_id, calibrator_index}{spot_idx};

                            uses_total_oxides = isequal(internal_standard_1_name, 'Total Oxides');
                            takes_value_from_other_calibrator = ~isempty(internal_standard_1_mass_fraction) && ...
                                startsWith(string(internal_standard_1_mass_fraction), 'from');

                            if ~uses_total_oxides && ~takes_value_from_other_calibrator
                                app.base.project.session.spot.internal_standard_mass_fraction_uncertainty_inclusion{bracket_id, calibrator_index}(spot_idx) = uncertainty_value;
                            end

                        case '± 1σ [%]'
                            app.base.project.session.spot.internal_standard_oxide_wt_uncertainty_inclusion{bracket_id, calibrator_index}(spot_idx) = uncertainty_value;

                        case '± 1σ [µg/g] (I.S.2)'
                            internal_standard_2_mass_fraction = app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion{bracket_id, calibrator_index}{spot_idx};

                            takes_value_from_other_calibrator = ~isempty(internal_standard_2_mass_fraction) && ...
                                startsWith(string(internal_standard_2_mass_fraction), 'from');

                            if ismember(spot_idx, app.two_IS_rows) && ~takes_value_from_other_calibrator
                                app.base.project.session.spot.second_internal_standard_mass_fraction_uncertainty_inclusion{bracket_id, calibrator_index}(spot_idx) = uncertainty_value;
                            end

                        case '± 1σ (x)'
                            spot_uses_mixing_ratio_mode = app.base.project.session.spot.unmixing_via(spot_idx) == "Mixing ratio";

                            if spot_uses_mixing_ratio_mode
                                app.base.project.session.spot.mixing_ratio_uncertainty_inclusion{bracket_id, calibrator_index}(spot_idx) = uncertainty_value;
                            end
                    end
                end

            else

                for spot_idx = app.selected_spot'
                    switch colName
                        case '[µg/g]'
                            app.base.project.session.spot.internal_standard_mass_fraction{app.BracketidDropDown.Value, app.selected_CAL}{spot_idx} = newData;
                        case '± 1σ [µg/g]'
                            app.base.project.session.spot.internal_standard_mass_fraction_uncertainty{app.BracketidDropDown.Value, app.selected_CAL}(spot_idx) = newData;
                        case '% Total Oxides'
                            app.base.project.session.spot.internal_standard_oxide_wt{app.BracketidDropDown.Value, app.selected_CAL}(spot_idx) = newData;
                        case '± 1σ [%]'
                            app.base.project.session.spot.internal_standard_oxide_wt_uncertainty{app.BracketidDropDown.Value, app.selected_CAL}(spot_idx) = newData;
                        case 'FeO/(FeO + Fe2O3)'
                            app.base.project.session.spot.Fe_ratio_for_total_oxide{app.BracketidDropDown.Value, app.selected_CAL}(spot_idx) = newData;
                    end
                end

            end

            update_quantification_module_GUI(app)
        end

        % Button pushed function: ProceedtoResultsModuleButton
        function ProceedtoResultsModuleButtonPushed(app, event)


            session_config = app.base.project.session.config;
            inputs_changed = isfield(session_config, 'quantification_outdated') && session_config.quantification_outdated;

            if app.editstatus == true || inputs_changed || all(all(cellfun(@isempty, app.base.project.session.spot.matrix_composition)))

                quantification_failed = quantification_wrapper(app);

                if quantification_failed == true
                    return
                end

                app.base.project.session.config.quantification_outdated = false;

            end

            try

                if app.editstatus == true
                    % uiconfirm ask user if finished
                    fig = app.UIFigure;
                    msg = "Do you want to proceed?";
                    title = "ICP-Base";
                    selection = uiconfirm(fig,msg,title, ...
                        "Options",["Yes","Cancel"], ...
                        "DefaultOption",1,"CancelOption",2);
                else
                    selection = 'Yes';
                end

                switch selection
                    case 'Yes'


                        session_config = app.base.project.session.config;
                        if ~isfield(session_config, 'module_status') ...
                                || ~isfield(session_config.module_status, 'quantification') ...
                                || ~isequal(session_config.module_status.quantification, true)
                            app.base.project.session.config.module_status.quantification = true;
                        end

                        settings.ICP_Base_GUI_update_state = true;
                        [app.project_id, app.session_id] = save_to_base(app.sourceapp, app.project_id, app.base.project.session, app.session_id, app.base.project_name, settings);
                        Results_Module(app.sourceapp, app.base.project_name, app.project_id, app.session_id)
                        delete(app)

                    case 'Cancel'
                        return
                end
                
            catch ME
                DisplayError(ME,'Proceeding to Results Module failed')
                message = "Proceeding to Results Module failed";
                uialert(app.UIFigure,message,"Warning", ...
                    "Icon","warning");

                return
            end


        end

        % Callback function: ExitMenu, UIFigure
        function ExitMenuSelected(app, event)

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
                    || ~isfield(session_config.module_status, 'quantification') ...
                    || ~session_config.module_status.quantification
                app.base.project.session.config.module_status.quantification = true;
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

        % Value changed function: CalibratorDropDown
        function CalibratorDropDownValueChanged(app, event)
            app.selected_CAL = app.CalibratorDropDown.Value;
            update_quantification_module_GUI(app)
        end

        % Value changed function: BracketidDropDown
        function BracketidDropDownValueChanged(app, event)
            app.selected_bracket_id = app.BracketidDropDown.Value;
            update_quantification_module_GUI(app)
        end

        % Cell edit callback: InclusionTable
        function InclusionTableCellEdit(app, event)
            changes = check_changes(app, 'quantification');
            if changes == false
                return
            end
            app.editstatus = true;

            indices = event.Indices;
            newData = event.NewData;

            % Validate newData
            if ischar(newData) || isstring(newData)
                if ~startsWith(lower(string(newData)), 'from')
                    newData = str2double(newData);
                    if isnan(newData) || newData == 0
                        newData = [];
                    end
                end
            elseif ~isnumeric(newData)
                newData = [];
            elseif isnan(newData) || newData == 0
                newData = [];
            end

            bracket_id       = app.BracketidDropDown.Value;
            calibrator_index = app.selected_CAL;

            % uncertainty columns store a plain positive number; empty, zero, negative or text input means "not set"
            if isnumeric(newData) && ~isempty(newData) && newData > 0
                uncertainty_value = newData;
            else
                uncertainty_value = NaN;
            end

            for spot_idx = app.selected_spot'
                switch app.InclusionTable.ColumnName{indices(2)}
                    case '[µg/g] (I.S.1)'
                        app.base.project.session.spot.internal_standard_mass_fraction_inclusion{app.BracketidDropDown.Value, app.selected_CAL}{spot_idx} = newData;
                    case '% Total Oxides'
                        val = newData; if isempty(val); val = NaN; end
                        app.base.project.session.spot.internal_standard_oxide_wt_inclusion{app.BracketidDropDown.Value, app.selected_CAL}(spot_idx) = val;
                    case 'FeO/(FeO + Fe2O3)'
                        val = newData; if isempty(val); val = NaN; end
                        app.base.project.session.spot.Fe_ratio_for_total_oxide_inclusion{app.BracketidDropDown.Value, app.selected_CAL}(spot_idx) = val;
                    case '[µg/g] (I.S.2)'
                        if ~ismember(spot_idx, app.two_IS_rows)
                            app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion{app.BracketidDropDown.Value, app.selected_CAL}{spot_idx} = [];
                        else
                            app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion{app.BracketidDropDown.Value, app.selected_CAL}{spot_idx} = newData;
                        end
                    case 'Mixing Ratio (x)'
                        val = newData; if isempty(val); val = NaN; end
                        if ~isnan(val) && (val <= 0 || val > 1); val = NaN; end
                        bi = app.BracketidDropDown.Value;
                        ci = app.selected_CAL;
                        n_total = size(app.base.project.session.spot.signal_starts, 1);
                        if ~isfield(app.base.project.session.spot, 'mixing_ratio') || isempty(app.base.project.session.spot.mixing_ratio)
                            sens_rows = size(app.base.project.session.spot.sensitivities, 1);
                            sens_cols = size(app.base.project.session.spot.sensitivities, 2);
                            app.base.project.session.spot.mixing_ratio = repmat({NaN(n_total, 1)}, sens_rows, sens_cols);
                        elseif numel(app.base.project.session.spot.mixing_ratio{bi, ci}) ~= n_total
                            app.base.project.session.spot.mixing_ratio{bi, ci} = NaN(n_total, 1);
                        end
                        app.base.project.session.spot.mixing_ratio{bi, ci}(spot_idx) = val;

                    case '± 1σ [µg/g] (I.S.1)'
                        internal_standard_1_name          = app.base.project.session.spot.internal_standard_inclusion{bracket_id, calibrator_index}(spot_idx);
                        internal_standard_1_mass_fraction = app.base.project.session.spot.internal_standard_mass_fraction_inclusion{bracket_id, calibrator_index}{spot_idx};

                        uses_total_oxides = isequal(internal_standard_1_name, 'Total Oxides');
                        takes_value_from_other_calibrator = ~isempty(internal_standard_1_mass_fraction) && ...
                            startsWith(string(internal_standard_1_mass_fraction), 'from');

                        % a value inherited from another calibrator carries its own uncertainty, so an input here is discarded
                        if ~uses_total_oxides && ~takes_value_from_other_calibrator
                            app.base.project.session.spot.internal_standard_mass_fraction_uncertainty_inclusion{bracket_id, calibrator_index}(spot_idx) = uncertainty_value;
                        end

                    case '± 1σ [%]'
                        app.base.project.session.spot.internal_standard_oxide_wt_uncertainty_inclusion{bracket_id, calibrator_index}(spot_idx) = uncertainty_value;

                    case '± 1σ [µg/g] (I.S.2)'
                        internal_standard_2_mass_fraction = app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion{bracket_id, calibrator_index}{spot_idx};

                        takes_value_from_other_calibrator = ~isempty(internal_standard_2_mass_fraction) && ...
                            startsWith(string(internal_standard_2_mass_fraction), 'from');

                        if ismember(spot_idx, app.two_IS_rows) && ~takes_value_from_other_calibrator
                            app.base.project.session.spot.second_internal_standard_mass_fraction_uncertainty_inclusion{bracket_id, calibrator_index}(spot_idx) = uncertainty_value;
                        end

                    case '± 1σ (x)'
                        spot_uses_mixing_ratio_mode = app.base.project.session.spot.unmixing_via(spot_idx) == "Mixing ratio";

                        if spot_uses_mixing_ratio_mode
                            app.base.project.session.spot.mixing_ratio_uncertainty_inclusion{bracket_id, calibrator_index}(spot_idx) = uncertainty_value;
                        end
                end
            end

            update_quantification_module_GUI(app)
        end

        % Callback function: InclusionTable
        function InclusionTableSelectionChanged(app, event)
            % Update selected_spot based on spotnumber instead of cell index
            if ~isempty(app.InclusionTable.Selection)
                selectedRows = unique(app.InclusionTable.Selection(:, 1));
                app.selected_spot = app.InclusionTable.Data{selectedRows, '#'}; % Use spotnumber from the table
                app.selected_table = 'InclusionTable';

                app.selected_column = app.InclusionTable.ColumnName{unique(event.Selection(:,2))};

                update_quantification_module_GUI(app);
            end
        end

        % Button pushed function: ClassificationButton, DriftButton, 
        % ImportButton, IntervalButton, ResultsButton
        function ImportButtonPushed(app, event)
            try

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

                        session_config = app.base.project.session.config;
                        if ~isfield(session_config, 'module_status') ...
                                || ~isfield(session_config.module_status, 'quantification') ...
                                || ~isequal(session_config.module_status.quantification, true)
                            app.base.project.session.config.module_status.quantification = true;
                        end

                        settings.ICP_Base_GUI_update_state = true;
                        [app.project_id, app.session_id] = save_to_base(app.sourceapp, app.project_id, app.base.project.session, app.session_id, app.base.project_name, settings);

                        switch event.Source.Parent.Parent.Parent.Parent.Parent.CallbackObject.Text
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

        % Value changed function: StringCompareInputEditField
        function StringCompareInputEditFieldValueChanged(app, event)

        end

        % Button pushed function: ChooseButton
        function ChooseButtonPushed(app, event)

            selected_string = string(app.SpotnamecontainsEditField.Value);

            if contains(selected_string, '&&')
                operator = 'AND';
                substrings = strtrim(string(strsplit(selected_string, '&&')));
            elseif contains(selected_string, '||')
                operator = 'OR';
                substrings = strtrim(string(strsplit(selected_string, '||')));
            else
                preliminary_indices = [];

                if strcmp(app.selected_table, 'MatrixTable')
                    tbl = app.MatrixTable;
                elseif strcmp(app.selected_table, 'InclusionTable')
                    tbl = app.InclusionTable;
                end

                for i = 1:length(tbl.Data.Spotname)
                    if contains(tbl.Data.Spotname(i), selected_string)
                        preliminary_indices(end+1) = i; %#ok
                    end
                end

                selected_spot_indices = tbl.Data{preliminary_indices, '#'};
                app.selected_spot = selected_spot_indices;
                return
            end

            selected_spot_indices = [];

            for i = 1:length(app.base.project.session.spot.name)
                if strcmp(operator, 'AND')
                    condition = all(contains(app.base.project.session.spot.name(i), substrings));
                elseif strcmp(operator, 'OR')
                    condition = any(contains(app.base.project.session.spot.name(i), substrings));
                end

                if condition
                    selected_spot_indices(end+1) = i; %#ok
                end
            end

            app.selected_spot = selected_spot_indices;
        end

        % Value changed function: HostInclusionDropDown
        function HostInclusionDropDownValueChanged(app, event)
            app.selected_host_inclusion = app.HostInclusionDropDown.Value;

            % Get the current table (MatrixTable or InclusionTable) based on the selected table
            if strcmp(app.selected_host_inclusion, 'Host')
                app.selected_table = 'MatrixTable';
                update_quantification_module_GUI(app)
            elseif strcmp(app.selected_host_inclusion, 'Inclusion')
                app.selected_table = 'InclusionTable';
                update_quantification_module_GUI(app)
                 update_inclusion_table_style(app)
            end

            
           
            
        end

        % Button pushed function: ApplytoallCalibratorsButton
        function ApplytoallCalibratorsButtonPushed(app, event)
            changes = check_changes(app, 'quantification');
            if changes == false
                return
            end
            app.editstatus = true;

            if strcmp(app.selected_table, 'MatrixTable')
                currentTable = app.MatrixTable.Data;
                spotNumbers = currentTable{:, 1};

                currentBracketId = app.BracketidDropDown.Value;
                currentCAL = app.selected_CAL;

                internalStandards = app.base.project.session.spot.internal_standard{currentBracketId, currentCAL}(spotNumbers);
                massFractions     = app.base.project.session.spot.internal_standard_mass_fraction{currentBracketId, currentCAL}(spotNumbers);
                totalOxides       = app.base.project.session.spot.internal_standard_oxide_wt{currentBracketId, currentCAL}(spotNumbers);
                feRatios          = app.base.project.session.spot.Fe_ratio_for_total_oxide{currentBracketId, currentCAL}(spotNumbers);

                allCALs = 1:size(app.base.project.session.spot.internal_standard, 2);
                allCALs(allCALs == currentCAL) = [];

                for cal = allCALs
                    sens_data = table2array(app.base.project.session.spot.sensitivities{currentBracketId, cal}(spotNumbers, :));
                    non_zero_rows = sum(sens_data, 2) ~= 0;
                    valid_spotnumbers = spotNumbers(non_zero_rows);

                    possible_elements = [string(app.base.project.session.spot.sensitivities{currentBracketId, cal}(spotNumbers, :).Properties.VariableNames), "Total Oxides"];

                    filtered_internalStandards = internalStandards(non_zero_rows);
                    filtered_internalStandards(filtered_internalStandards == "") = "";

                    is_in_possible_elements = ismember(filtered_internalStandards, possible_elements);

                    internalStandards(~is_in_possible_elements) = "";
                    massFractions(~is_in_possible_elements)     = {[]};
                    totalOxides(~is_in_possible_elements)       = NaN;
                    feRatios(~is_in_possible_elements)          = NaN;

                    app.base.project.session.spot.internal_standard{currentBracketId, cal}(valid_spotnumbers)                    = internalStandards(non_zero_rows);
                    app.base.project.session.spot.internal_standard_mass_fraction{currentBracketId, cal}(valid_spotnumbers)      = massFractions(non_zero_rows);
                    app.base.project.session.spot.internal_standard_oxide_wt{currentBracketId, cal}(valid_spotnumbers)           = totalOxides(non_zero_rows);
                    app.base.project.session.spot.Fe_ratio_for_total_oxide{currentBracketId, cal}(valid_spotnumbers)             = feRatios(non_zero_rows);
                end

            elseif strcmp(app.selected_table, 'InclusionTable')
                currentTable = app.InclusionTable.Data;
                spotNumbers = currentTable{:, 1};

                currentBracketId = app.BracketidDropDown.Value;
                currentCAL = app.selected_CAL;

                internalStandards        = app.base.project.session.spot.internal_standard_inclusion{currentBracketId, currentCAL}(spotNumbers);
                massFractions            = app.base.project.session.spot.internal_standard_mass_fraction_inclusion{currentBracketId, currentCAL}(spotNumbers);
                totalOxides              = app.base.project.session.spot.internal_standard_oxide_wt_inclusion{currentBracketId, currentCAL}(spotNumbers);
                feRatios                 = app.base.project.session.spot.Fe_ratio_for_total_oxide_inclusion{currentBracketId, currentCAL}(spotNumbers);
                second_internalStandards = app.base.project.session.spot.second_internal_standard_inclusion{currentBracketId, currentCAL}(spotNumbers);
                second_massFractions     = app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion{currentBracketId, currentCAL}(spotNumbers);

                allCALs = 1:size(app.base.project.session.spot.internal_standard_inclusion, 2);
                allCALs(allCALs == currentCAL) = [];

                for cal = allCALs
                    sens_data = table2array(app.base.project.session.spot.sensitivities{currentBracketId, cal}(spotNumbers, :));
                    non_zero_rows = sum(sens_data, 2) ~= 0;
                    valid_spotnumbers = spotNumbers(non_zero_rows);

                    possible_elements = [string(app.base.project.session.spot.sensitivities{currentBracketId, cal}(spotNumbers, :).Properties.VariableNames), "Total Oxides"];

                    filtered_internalStandards = internalStandards(non_zero_rows);
                    filtered_internalStandards(filtered_internalStandards == "") = "";

                    is_in_possible_elements = ismember(filtered_internalStandards, possible_elements);

                    internalStandards(~is_in_possible_elements)        = "";
                    massFractions(~is_in_possible_elements)            = {[]};
                    totalOxides(~is_in_possible_elements)              = NaN;
                    feRatios(~is_in_possible_elements)                 = NaN;
                    second_internalStandards(~is_in_possible_elements) = "";
                    second_massFractions(~is_in_possible_elements)     = {[]};

                    app.base.project.session.spot.internal_standard_inclusion{currentBracketId, cal}(valid_spotnumbers)                              = internalStandards(non_zero_rows);
                    app.base.project.session.spot.internal_standard_mass_fraction_inclusion{currentBracketId, cal}(valid_spotnumbers)                = massFractions(non_zero_rows);
                    app.base.project.session.spot.internal_standard_oxide_wt_inclusion{currentBracketId, cal}(valid_spotnumbers)                     = totalOxides(non_zero_rows);
                    app.base.project.session.spot.Fe_ratio_for_total_oxide_inclusion{currentBracketId, cal}(valid_spotnumbers)                       = feRatios(non_zero_rows);
                    app.base.project.session.spot.second_internal_standard_inclusion{currentBracketId, cal}(valid_spotnumbers)                       = second_internalStandards(non_zero_rows);
                    app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion{currentBracketId, cal}(valid_spotnumbers)         = second_massFractions(non_zero_rows);
                end

            else
                return
            end

            update_quantification_module_GUI(app)
        end

        % Value changed function: ComparetoDropDown
        function ComparetoDropDownValueChanged(app, event)
            update_MSF_plot(app)
        end

        % Value changed function: SensitivitybasedonDropDown
        function SensitivitybasedonDropDownValueChanged(app, event)
            update_MSF_plot(app)
        end

        % Value changed function: ShowLegendCheckBox
        function ShowLegendCheckBoxValueChanged(app, event)
            update_MSF_plot(app)
        end

        % Value changed function: DenominatorListBox
        function DenominatorListBoxValueChanged(app, event)
            update_MSF_plot(app)
        end

        % Value changed function: RatioListBox
        function RatioListBoxValueChanged(app, event)
            update_MSF_plot(app)
        end

        % Button pushed function: ExportTableButton
        function ExportTableButtonPushed(app, event)
            
            if isempty(app.MSF_ratios)
                message={'No Data to be exported'};
                uialert(app.UIFigure, message,' Warning','Icon','warning');
                return
            end


            f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
            [filename, pathname] = uiputfile('*.csv', 'Save CSV file');
            delete(f);
            figure(app.UIFigure);

            outputpath = fullfile(pathname, filename);
            if isequal(filename, 0) || isequal(pathname, 0)
                return; % User canceled file selection
            end

            writetable(app.MSF_ratios, outputpath,'WriteRowNames', false);

        end

        % Button pushed function: ExportTableButton_2
        function ExportTableButton_2Pushed(app, event)

            fig = app.UIFigure;
            msg = {['The currently active table will be exported. Make sure that the table already contains the correct internal standard analytes. ' ...
                'If you want to import it back again, make sure to not alter the first three columns of the table. Only fill in the values for your internal standards or total oxides. Under no circumstances delete a row or change the name of the sheet. If you do not want to quantify a spot, just leave the internal standard empty.']};
            title = "ICP-Base";
            selection = uiconfirm(fig,msg,title, ...
                "Options",["I understand and if this does not work it is my own fault","Cancel"], ...
                "DefaultOption",1,"CancelOption",2);

            switch selection
                case "I understand and if this does not work it is my own fault"

                    f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
                    [filename, pathname] = uiputfile('*.xlsx', 'Save Excel file');
                    delete(f);
                    figure(app.UIFigure);

                    outputpath = fullfile(pathname, filename);
                    if isequal(filename, 0) || isequal(pathname, 0)
                        return; % User canceled file selection
                    end

                    if isequal(app.selected_host_inclusion, 'Host')

                        writetable(app.MatrixTable.Data, outputpath, 'Sheet', ['Matrix_', num2str(app.selected_CAL), '_', app.CalibratorDropDown.Items{app.selected_CAL}, '_ID_' ,app.BracketidDropDown.Items{app.selected_bracket_id}]);

                    elseif isequal(app.selected_host_inclusion, 'Inclusion')

                        writetable(app.InclusionTable.Data, outputpath, 'Sheet', ['Inclusion_',num2str(app.selected_CAL), '_', app.CalibratorDropDown.Items{app.selected_CAL}, '_ID_' ,app.BracketidDropDown.Items{app.selected_bracket_id}]);

                    end

                case 'Cancel'
                    return
            end






        end

        % Button pushed function: ImportTableButton
        function ImportTableButtonPushed(app, event)

            fig = app.UIFigure;
            msg = {'Be aware that you can (or rather should) only import tables that were also exported from ICP-Base. You cannot just import a table of any format.'};
            title = "ICP-Base";
            selection = uiconfirm(fig,msg,title, ...
                "Options",["I understand and if this does not work it is my own fault","Cancel"], ...
                "DefaultOption",1,"CancelOption",2);

            switch selection
                case "I understand and if this does not work it is my own fault"

                    f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
                    [filename, pathname] = uigetfile('*.xlsx', 'Save Excel file');
                    delete(f);
                    figure(app.UIFigure);

                    inputpath = fullfile(pathname, filename);
                    if isequal(filename, 0) || isequal(pathname, 0)
                        return; % User canceled file selection
                    end

                    changes = check_changes(app, 'quantification');
                    if changes == false
                        return
                    end
                    app.editstatus = true;

                    % Read the sheet names
                    sheetNames = readtable(inputpath, 'VariableNamingRule', 'preserve', 'Sheet', 1);

                    % Get the actual sheet names using sheetnames function
                    sheets = sheetnames(inputpath);
                    activeSheet = sheets(1); % Get the first sheet name

                    % Parse the sheet name to extract variables
                    % Expected format: 'Matrix_CAL_Name_ID_BracketId' or 'Inclusion_CAL_Name_ID_BracketId'
                    parts = split(activeSheet, '_');

                    % Extract host/inclusion type
                    host_inclusion = parts{1}; % 'Matrix' or 'Inclusion'

                    % Extract CAL index (2nd part after split)
                    CAL = str2double(parts{2});

                    % Extract bracket ID (last part)
                    bracket_id = str2double(parts{end});

                    % Now read the data
                    data = readtable(inputpath, 'Sheet', activeSheet);

                    %Assign to the appropriate table based on host/inclusion
                    if isequal(host_inclusion, 'Matrix')

                        %%%%% check for invalid entries %%%%%

                        % Update GUI to load the correct table
                        app.CalibratorDropDown.Value = CAL;
                        app.BracketidDropDown.Value = bracket_id;
                        app.HostInclusionDropDown.Value = 'Host';
                        update_matrix_table(app)

                        % Compare first two columns (spot numbers and spotnames)
                        current_spot_numbers = app.MatrixTable.Data{:, 1};
                        current_spotnames = app.MatrixTable.Data{:, 2};
                        imported_spot_numbers = data{:, 1};
                        imported_spotnames = data{:, 2};

                        % Check if they match
                        if ~isequal(current_spot_numbers, imported_spot_numbers) || ~isequal(current_spotnames, imported_spotnames)
                            uialert(app.UIFigure, ...
                                'The spot numbers or spot names in the imported file do not match the variables in the data structure. Please ensure the file has not been altered.', ...
                                'Import Error', 'Icon', 'error');
                            return;
                        end


                        % Check for conflicting data: column 4 should not have values if column 5 or 6 have values
                        col4 = data{:, 4};
                        col5 = data{:, 5};
                        col6 = data{:, 6};

                        has_col4 = ~isnan(col4);
                        has_col5 = ~isnan(col5);
                        has_col6 = ~isnan(col6);

                        % Check if any row has both mass fraction (col 4) and total oxides (col 5 or 6)
                        if any(has_col4 & (has_col5 | has_col6))
                            uialert(app.UIFigure, ...
                                'Invalid data: A spot cannot have both a mass fraction value and total oxide values. Please use either mass fraction OR total oxides, not both.', ...
                                'Import Error', 'Icon', 'error');
                            return;
                        end

                        % Validate total oxides range (0 < value <= 100)
                        if any(has_col5 & (col5 <= 0 | col5 > 100))
                            uialert(app.UIFigure, ...
                                'Invalid data: Total Oxides values must be greater than 0 and less than or equal to 100.', ...
                                'Import Error', 'Icon', 'error');
                            return;
                        end

                        % Validate Fe ratio range (0 <= value <= 1)
                        if any(has_col6 & (col6 < 0 | col6 > 1))
                            uialert(app.UIFigure, ...
                                'Invalid data: FeO/(FeO + Fe2O3) values must be between 0 and 1 (inclusive).', ...
                                'Import Error', 'Icon', 'error');
                            return;
                        end

                        %%% lets go %%%

                        % Extract spot numbers (column 1) and values from columns 3, 4, 5, 6
                        spot_numbers = data{:, 1};
                        internal_standard = data{:, 3};  % Column 3: Analyte
                        if isnumeric(internal_standard)
                            internal_standard = repmat("", size(internal_standard));
                        end
                        internal_standard_values = data{:, 4};  % Column 4: x__g_g_
                        total_oxides = data{:, 5};  % Column 5: x_TotalOxides
                        fe_ratio = data{:, 6};  % Column 6: FeO__FeO_Fe2O3_


                        % Process internal_standard (column 3) - cell array of strings
                        app.base.project.session.spot.internal_standard{bracket_id, CAL}(spot_numbers) = internal_standard;

                        % Process internal_standard_mass_fraction (column 4)
                        values_cell = num2cell(internal_standard_values);
                        nan_mask = isnan(internal_standard_values);
                        values_cell(nan_mask) = {[]};
                        app.base.project.session.spot.internal_standard_mass_fraction{bracket_id, CAL}(spot_numbers) = values_cell;

                        % Process internal_standard_oxide_wt (column 5)
                        oxide_cell = num2cell(total_oxides);
                        nan_mask = isnan(total_oxides);
                        app.base.project.session.spot.internal_standard_oxide_wt{bracket_id, CAL}(spot_numbers) = total_oxides;

                        % Process Fe_ratio_for_total_oxide (column 6)
                        fe_cell = num2cell(fe_ratio);
                        nan_mask = isnan(fe_ratio);
                        app.base.project.session.spot.Fe_ratio_for_total_oxide{bracket_id, CAL}(spot_numbers) = fe_ratio;

                    elseif isequal(host_inclusion, 'Inclusion')

                        %%%%% check for invalid entries %%%%%

                        % Update GUI to load the correct table
                        app.CalibratorDropDown.Value = CAL;
                        app.BracketidDropDown.Value = bracket_id;
                        app.HostInclusionDropDown.Value = 'Inclusion';
                        update_inclusion_table(app)

                        % Compare first two columns (spot numbers and spotnames)
                        current_spot_numbers = app.InclusionTable.Data{:, 1};
                        current_spotnames = app.InclusionTable.Data{:, 2};
                        imported_spot_numbers = data{:, 1};
                        imported_spotnames = data{:, 2};

                        % Check if they match
                        if ~isequal(current_spot_numbers, imported_spot_numbers) || ~isequal(current_spotnames, imported_spotnames)
                            uialert(app.UIFigure, ...
                                'The spot numbers or spot names in the imported file do not match the variables in the data structure. Please ensure the file has not been altered.', ...
                                'Import Error', 'Icon', 'error');
                            return;
                        end


                        % Check for conflicting data: column 4 should not have values if column 5 or 6 have values
                        col4 = data{:, 4};
                        col5 = data{:, 5};
                        col6 = data{:, 6};

                        has_col4 = ~isnan(col4);
                        has_col5 = ~isnan(col5);
                        has_col6 = ~isnan(col6);

                        % Check if any row has both mass fraction (col 4) and total oxides (col 5 or 6)
                        if any(has_col4 & (has_col5 | has_col6))
                            uialert(app.UIFigure, ...
                                'Invalid data: A spot cannot have both a mass fraction value and total oxide values. Please use either mass fraction OR total oxides, not both.', ...
                                'Import Error', 'Icon', 'error');
                            return;
                        end

                        % Validate total oxides range (0 < value <= 100)
                        if any(has_col5 & (col5 <= 0 | col5 > 100))
                            uialert(app.UIFigure, ...
                                'Invalid data: Total Oxides values must be greater than 0 and less than or equal to 100.', ...
                                'Import Error', 'Icon', 'error');
                            return;
                        end

                        % Validate Fe ratio range (0 <= value <= 1)
                        if any(has_col6 & (col6 < 0 | col6 > 1))
                            uialert(app.UIFigure, ...
                                'Invalid data: FeO/(FeO + Fe2O3) values must be between 0 and 1 (inclusive).', ...
                                'Import Error', 'Icon', 'error');
                            return;
                        end

                        %%% lets go %%%

                        % Extract spot numbers (column 1) and values from columns 3, 4, 5, 6
                        spot_numbers = data{:, 1};
                        internal_standard = data{:, 3};  % Column 3: Analyte
                        if isnumeric(internal_standard)
                            internal_standard = repmat("", size(internal_standard));
                        end
                        internal_standard_values = data{:, 4};  % Column 4: x__g_g_
                        total_oxides = data{:, 5};  % Column 5: x_TotalOxides
                        fe_ratio = data{:, 6};  % Column 6: FeO__FeO_Fe2O3_

                        % Process internal_standard (column 3) - cell array of strings
                        app.base.project.session.spot.internal_standard_inclusion{bracket_id, CAL}(spot_numbers) = internal_standard;

                        % Process internal_standard_mass_fraction (column 4)
                        values_cell = num2cell(internal_standard_values);
                        nan_mask = isnan(internal_standard_values);
                        values_cell(nan_mask) = {[]};
                        app.base.project.session.spot.internal_standard_mass_fraction_inclusion{bracket_id, CAL}(spot_numbers) = values_cell;

                        % Process internal_standard_oxide_wt (column 5)
                        app.base.project.session.spot.internal_standard_oxide_wt_inclusion{bracket_id, CAL}(spot_numbers) = total_oxides;

                        % Process Fe_ratio_for_total_oxide (column 6)
                        app.base.project.session.spot.Fe_ratio_for_total_oxide_inclusion{bracket_id, CAL}(spot_numbers) = fe_ratio;

                        % process second internal standard.
                        second_internal_standard = data{:, 7};  % Column 7: Analyte
                        second_internal_standard_values = data{:, 8};  % Column 8: x__g_g_

                        % Get the unmixing method for these spots
                        unmixing_methods = app.base.project.session.spot.unmixing_via(spot_numbers);

                        % Find indices where unmixing method is 'Two internal standards'
                        two_std_mask = strcmp(unmixing_methods, 'Two internal standards');

                        % Only process spots that use two internal standards
                        spots_with_two_std = spot_numbers(two_std_mask);

                        if ~isempty(spots_with_two_std)
                            % Convert internal_standard to cell array if it's numeric (handles NaN case)
                            if isnumeric(second_internal_standard)
                                second_internal_standard_cell = cell(size(second_internal_standard));
                                for i = 1:length(second_internal_standard)
                                    if isnan(second_internal_standard(i))
                                        second_internal_standard_cell{i} = '';
                                    else
                                        second_internal_standard_cell{i} = num2str(second_internal_standard(i));
                                    end
                                end
                                second_internal_standard = second_internal_standard_cell;
                            end

                            % Process second_internal_standard (column 7) - only for 'Two internal standards' spots
                            app.base.project.session.spot.second_internal_standard_inclusion{bracket_id, CAL}(spots_with_two_std) = second_internal_standard(two_std_mask);

                            % Process second_internal_standard_mass_fraction (column 8)
                            values_to_assign = second_internal_standard_values(two_std_mask);
                            values_cell = num2cell(values_to_assign);
                            nan_mask = isnan(values_to_assign);
                            values_cell(nan_mask) = {[]};
                            app.base.project.session.spot.second_internal_standard_mass_fraction_inclusion{bracket_id, CAL}(spots_with_two_std) = values_cell;
                        end
                    end

                    update_quantification_module_GUI(app)

                case 'Cancel'
                    return
            end
        end

        % Menu selected function: ChangeTotalOxidesFolderMenu
        function ChangeTotalOxidesFolderMenuSelected(app, event)


            % Open folder selection dialog
            selectedFolder = uigetdir('', 'Select Total Oxides Folder');

            % Check if user selected a folder (not cancelled)
            if selectedFolder == 0
                return
            end

            changes = check_changes(app, 'quantification');
            if changes == false
                return
            end
            app.editstatus = true;


            % Store the selected folder path (adjust property name as needed)
            app.base.project.session.config.total_oxides_path = selectedFolder;

            % Call your existing function
            get_oxides_from_file(app)

            update_quantification_module_GUI(app)
        end

        % Menu selected function: ShowOxidesthatwillbeusedMenu
        function ShowOxidesthatwillbeusedMenuSelected(app, event)

            changes = check_changes(app, 'quantification');
            if changes == false
                return
            end
            app.editstatus = true;

            get_oxides_from_file(app)

            fig = uifigure('Name', "Oxides to be used for quantification from: " + app.base.project.session.config.total_oxides_path, 'Position', [200, 200, 800, 600]);
            uit = uitable(fig);

            oxides_data        = app.base.project.session.oxides;
            element_names      = oxides_data.element_names;
            oxide_names        = oxides_data.oxide_names;
            conv_factors       = oxides_data.conversion_factor_values;
            preferred_isotopes = oxides_data.preferred_isotopes;
            considered_major   = oxides_data.considered_major;

            tabledata = table(element_names, oxide_names, conv_factors, preferred_isotopes, considered_major, ...
                'VariableNames', {'Element', 'Oxide', 'ConversionFactor', 'PreferredIsotope', 'IsMajor'});

            uit.Data            = tabledata;
            uit.Position        = [20 20 760 560];
            uit.ColumnEditable  = false;

            style = uistyle('HorizontalAlignment', 'center');
            addStyle(uit, style);


        end

        % Menu selected function: PropagateuncertaintiesMenu
        function PropagateuncertaintiesMenuSelected(app, event)
            isChecked = app.PropagateuncertaintiesMenu.Checked;
            if isequal(isChecked,'on')
                app.PropagateuncertaintiesMenu.Checked = 'off';
            elseif isequal(isChecked,'off')
                app.PropagateuncertaintiesMenu.Checked = 'on';
            end

        end

        % Menu selected function: EnableinternalstandarduncertaintyMenu
        function EnableinternalstandarduncertaintyMenuSelected(app, event)
          if strcmp(app.EnableinternalstandarduncertaintyMenu.Checked, 'on')
                app.EnableinternalstandarduncertaintyMenu.Checked = 'off';
                app.base.project.session.config.internal_standard_uncertainty = false;
          else
              app.EnableinternalstandarduncertaintyMenu.Checked = 'on';
              app.base.project.session.config.internal_standard_uncertainty = true;
          end
          if app.selected_host_inclusion == "Inclusion"
              update_inclusion_table(app)
              update_inclusion_table_style(app)
          else
              update_matrix_table(app)
          end

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 927 745];
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

            % Create ChangeTotalOxidesFolderMenu
            app.ChangeTotalOxidesFolderMenu = uimenu(app.SettingsMenu);
            app.ChangeTotalOxidesFolderMenu.MenuSelectedFcn = createCallbackFcn(app, @ChangeTotalOxidesFolderMenuSelected, true);
            app.ChangeTotalOxidesFolderMenu.Text = 'Change Total Oxides Folder';

            % Create ShowOxidesthatwillbeusedMenu
            app.ShowOxidesthatwillbeusedMenu = uimenu(app.SettingsMenu);
            app.ShowOxidesthatwillbeusedMenu.MenuSelectedFcn = createCallbackFcn(app, @ShowOxidesthatwillbeusedMenuSelected, true);
            app.ShowOxidesthatwillbeusedMenu.Text = 'Show Oxides that will be used';

            % Create PropagateuncertaintiesMenu
            app.PropagateuncertaintiesMenu = uimenu(app.SettingsMenu);
            app.PropagateuncertaintiesMenu.MenuSelectedFcn = createCallbackFcn(app, @PropagateuncertaintiesMenuSelected, true);
            app.PropagateuncertaintiesMenu.Checked = 'on';
            app.PropagateuncertaintiesMenu.Text = 'Propagate uncertainties';

            % Create EnableinternalstandarduncertaintyMenu
            app.EnableinternalstandarduncertaintyMenu = uimenu(app.SettingsMenu);
            app.EnableinternalstandarduncertaintyMenu.MenuSelectedFcn = createCallbackFcn(app, @EnableinternalstandarduncertaintyMenuSelected, true);
            app.EnableinternalstandarduncertaintyMenu.Text = 'Enable internal standard uncertainty';

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.UIFigure);
            app.GridLayout2.ColumnWidth = {5, '1x', 5};
            app.GridLayout2.RowHeight = {30, '1x'};
            app.GridLayout2.RowSpacing = 7.85624186197917;
            app.GridLayout2.Padding = [8.54998779296875 7.85624186197917 8.54998779296875 7.85624186197917];

            % Create TabGroup
            app.TabGroup = uitabgroup(app.GridLayout2);
            app.TabGroup.Layout.Row = 2;
            app.TabGroup.Layout.Column = 2;

            % Create InternalStandardizationTab
            app.InternalStandardizationTab = uitab(app.TabGroup);
            app.InternalStandardizationTab.Title = 'Internal Standardization';

            % Create ApplytoallCalibratorsButton
            app.ApplytoallCalibratorsButton = uibutton(app.InternalStandardizationTab, 'push');
            app.ApplytoallCalibratorsButton.ButtonPushedFcn = createCallbackFcn(app, @ApplytoallCalibratorsButtonPushed, true);
            app.ApplytoallCalibratorsButton.Tooltip = {'I hate this button'};
            app.ApplytoallCalibratorsButton.Position = [606 21 150 26];
            app.ApplytoallCalibratorsButton.Text = 'Apply to all Calibrators';

            % Create ResetButton
            app.ResetButton = uibutton(app.InternalStandardizationTab, 'push');
            app.ResetButton.ButtonPushedFcn = createCallbackFcn(app, @ResetButtonPushed, true);
            app.ResetButton.Position = [516 21 83 26];
            app.ResetButton.Text = 'Reset';

            % Create Panel
            app.Panel = uipanel(app.InternalStandardizationTab);
            app.Panel.BorderType = 'none';
            app.Panel.Position = [23 19 360 53];

            % Create GridLayout
            app.GridLayout = uigridlayout(app.Panel);
            app.GridLayout.ColumnWidth = {114, '1x', 78};
            app.GridLayout.RowHeight = {23, 22};
            app.GridLayout.RowSpacing = 2;
            app.GridLayout.Padding = [10 2 10 2];

            % Create ApplyButton
            app.ApplyButton = uibutton(app.GridLayout, 'push');
            app.ApplyButton.ButtonPushedFcn = createCallbackFcn(app, @ApplyButtonPushed, true);
            app.ApplyButton.Layout.Row = 2;
            app.ApplyButton.Layout.Column = 3;
            app.ApplyButton.Text = 'Apply';

            % Create StringCompareInputEditField
            app.StringCompareInputEditField = uieditfield(app.GridLayout, 'numeric');
            app.StringCompareInputEditField.Limits = [0 Inf];
            app.StringCompareInputEditField.ValueChangedFcn = createCallbackFcn(app, @StringCompareInputEditFieldValueChanged, true);
            app.StringCompareInputEditField.Layout.Row = 2;
            app.StringCompareInputEditField.Layout.Column = 2;
            app.StringCompareInputEditField.Value = 42;

            % Create StringCompareDropDown
            app.StringCompareDropDown = uidropdown(app.GridLayout);
            app.StringCompareDropDown.Items = {''};
            app.StringCompareDropDown.Layout.Row = 2;
            app.StringCompareDropDown.Layout.Column = 1;
            app.StringCompareDropDown.Value = '';

            % Create ChooseButton
            app.ChooseButton = uibutton(app.GridLayout, 'push');
            app.ChooseButton.ButtonPushedFcn = createCallbackFcn(app, @ChooseButtonPushed, true);
            app.ChooseButton.Layout.Row = 1;
            app.ChooseButton.Layout.Column = 3;
            app.ChooseButton.Text = 'Choose';

            % Create ContainsLabel
            app.ContainsLabel = uilabel(app.GridLayout);
            app.ContainsLabel.HorizontalAlignment = 'right';
            app.ContainsLabel.Layout.Row = 1;
            app.ContainsLabel.Layout.Column = 1;
            app.ContainsLabel.Text = 'Spotname contains:';

            % Create SpotnamecontainsEditField
            app.SpotnamecontainsEditField = uieditfield(app.GridLayout, 'text');
            app.SpotnamecontainsEditField.ValueChangedFcn = createCallbackFcn(app, @SpotnamecontainsEditFieldValueChanged, true);
            app.SpotnamecontainsEditField.Layout.Row = 1;
            app.SpotnamecontainsEditField.Layout.Column = 2;

            % Create AnalyteListBox
            app.AnalyteListBox = uilistbox(app.InternalStandardizationTab);
            app.AnalyteListBox.Items = {};
            app.AnalyteListBox.ValueChangedFcn = createCallbackFcn(app, @AnalyteListBoxValueChanged, true);
            app.AnalyteListBox.Visible = 'off';
            app.AnalyteListBox.Position = [766 57 103 564];
            app.AnalyteListBox.Value = {};

            % Create fromCALListBox
            app.fromCALListBox = uilistbox(app.InternalStandardizationTab);
            app.fromCALListBox.Items = {};
            app.fromCALListBox.ValueChangedFcn = createCallbackFcn(app, @fromCALListBoxValueChanged, true);
            app.fromCALListBox.Visible = 'off';
            app.fromCALListBox.Position = [766 382 103 239];
            app.fromCALListBox.Value = {};

            % Create MatrixTable
            app.MatrixTable = uitable(app.InternalStandardizationTab);
            app.MatrixTable.ColumnName = '';
            app.MatrixTable.ColumnWidth = {'fit'};
            app.MatrixTable.RowName = {};
            app.MatrixTable.ColumnEditable = [false false false true true true];
            app.MatrixTable.RowStriping = 'off';
            app.MatrixTable.CellEditCallback = createCallbackFcn(app, @MatrixTableCellEdit, true);
            app.MatrixTable.SelectionChangedFcn = createCallbackFcn(app, @MatrixTableSelectionChanged, true);
            app.MatrixTable.Position = [10 80 746 545];

            % Create InclusionTable
            app.InclusionTable = uitable(app.InternalStandardizationTab);
            app.InclusionTable.ColumnName = '';
            app.InclusionTable.ColumnWidth = {'fit'};
            app.InclusionTable.RowName = {};
            app.InclusionTable.ColumnEditable = [false false false true true true false true true];
            app.InclusionTable.RowStriping = 'off';
            app.InclusionTable.CellEditCallback = createCallbackFcn(app, @InclusionTableCellEdit, true);
            app.InclusionTable.SelectionChangedFcn = createCallbackFcn(app, @InclusionTableSelectionChanged, true);
            app.InclusionTable.Visible = 'off';
            app.InclusionTable.Position = [12 79 744 545];

            % Create HostInclusionDropDown
            app.HostInclusionDropDown = uidropdown(app.InternalStandardizationTab);
            app.HostInclusionDropDown.Items = {};
            app.HostInclusionDropDown.ValueChangedFcn = createCallbackFcn(app, @HostInclusionDropDownValueChanged, true);
            app.HostInclusionDropDown.Position = [598 631 150 27];
            app.HostInclusionDropDown.Value = {};

            % Create BracketidDropDownLabel
            app.BracketidDropDownLabel = uilabel(app.InternalStandardizationTab);
            app.BracketidDropDownLabel.HorizontalAlignment = 'right';
            app.BracketidDropDownLabel.Position = [381 631 59 27];
            app.BracketidDropDownLabel.Text = 'Bracket id';

            % Create BracketidDropDown
            app.BracketidDropDown = uidropdown(app.InternalStandardizationTab);
            app.BracketidDropDown.Items = {};
            app.BracketidDropDown.ValueChangedFcn = createCallbackFcn(app, @BracketidDropDownValueChanged, true);
            app.BracketidDropDown.Position = [448 631 103 27];
            app.BracketidDropDown.Value = {};

            % Create CalibratorDropDownLabel
            app.CalibratorDropDownLabel = uilabel(app.InternalStandardizationTab);
            app.CalibratorDropDownLabel.HorizontalAlignment = 'right';
            app.CalibratorDropDownLabel.Position = [57 631 151 27];
            app.CalibratorDropDownLabel.Text = 'Calibrator';

            % Create CalibratorDropDown
            app.CalibratorDropDown = uidropdown(app.InternalStandardizationTab);
            app.CalibratorDropDown.Items = {};
            app.CalibratorDropDown.ValueChangedFcn = createCallbackFcn(app, @CalibratorDropDownValueChanged, true);
            app.CalibratorDropDown.Position = [218 631 154 27];
            app.CalibratorDropDown.Value = {};

            % Create ProceedtoResultsModuleButton
            app.ProceedtoResultsModuleButton = uibutton(app.InternalStandardizationTab, 'push');
            app.ProceedtoResultsModuleButton.ButtonPushedFcn = createCallbackFcn(app, @ProceedtoResultsModuleButtonPushed, true);
            app.ProceedtoResultsModuleButton.WordWrap = 'on';
            app.ProceedtoResultsModuleButton.Position = [766 2 103 53];
            app.ProceedtoResultsModuleButton.Text = 'Proceed to Results Module';

            % Create ExportTableButton_2
            app.ExportTableButton_2 = uibutton(app.InternalStandardizationTab, 'push');
            app.ExportTableButton_2.ButtonPushedFcn = createCallbackFcn(app, @ExportTableButton_2Pushed, true);
            app.ExportTableButton_2.Position = [389 50 115 22];
            app.ExportTableButton_2.Text = 'Export Table';

            % Create ImportTableButton
            app.ImportTableButton = uibutton(app.InternalStandardizationTab, 'push');
            app.ImportTableButton.ButtonPushedFcn = createCallbackFcn(app, @ImportTableButtonPushed, true);
            app.ImportTableButton.Position = [516 50 83 22];
            app.ImportTableButton.Text = 'Import Table';

            % Create MatrixSensitivityFactorMSFTab
            app.MatrixSensitivityFactorMSFTab = uitab(app.TabGroup);
            app.MatrixSensitivityFactorMSFTab.Title = 'Matrix Sensitivity Factor (MSF)';

            % Create MSFAxes
            app.MSFAxes = uiaxes(app.MatrixSensitivityFactorMSFTab);
            app.MSFAxes.Box = 'on';
            app.MSFAxes.Position = [13 15 781 610];

            % Create RatioListBox
            app.RatioListBox = uilistbox(app.MatrixSensitivityFactorMSFTab);
            app.RatioListBox.Items = {};
            app.RatioListBox.Multiselect = 'on';
            app.RatioListBox.ValueChangedFcn = createCallbackFcn(app, @RatioListBoxValueChanged, true);
            app.RatioListBox.Position = [793 15 82 419];
            app.RatioListBox.Value = {};

            % Create DenominatorListBox
            app.DenominatorListBox = uilistbox(app.MatrixSensitivityFactorMSFTab);
            app.DenominatorListBox.Items = {};
            app.DenominatorListBox.Multiselect = 'on';
            app.DenominatorListBox.ValueChangedFcn = createCallbackFcn(app, @DenominatorListBoxValueChanged, true);
            app.DenominatorListBox.Position = [793 446 81 175];
            app.DenominatorListBox.Value = {};

            % Create ShowLegendCheckBox
            app.ShowLegendCheckBox = uicheckbox(app.MatrixSensitivityFactorMSFTab);
            app.ShowLegendCheckBox.ValueChangedFcn = createCallbackFcn(app, @ShowLegendCheckBoxValueChanged, true);
            app.ShowLegendCheckBox.Text = 'Show Legend';
            app.ShowLegendCheckBox.Position = [774 631 100 22];
            app.ShowLegendCheckBox.Value = true;

            % Create SensitivitybasedonDropDownLabel
            app.SensitivitybasedonDropDownLabel = uilabel(app.MatrixSensitivityFactorMSFTab);
            app.SensitivitybasedonDropDownLabel.HorizontalAlignment = 'right';
            app.SensitivitybasedonDropDownLabel.Position = [270 626 116 22];
            app.SensitivitybasedonDropDownLabel.Text = 'Sensitivity based on:';

            % Create SensitivitybasedonDropDown
            app.SensitivitybasedonDropDown = uidropdown(app.MatrixSensitivityFactorMSFTab);
            app.SensitivitybasedonDropDown.Items = {'Mean', 'Min', 'Max'};
            app.SensitivitybasedonDropDown.ValueChangedFcn = createCallbackFcn(app, @SensitivitybasedonDropDownValueChanged, true);
            app.SensitivitybasedonDropDown.Position = [392 622 77 30];
            app.SensitivitybasedonDropDown.Value = 'Mean';

            % Create ComparetoDropDownLabel
            app.ComparetoDropDownLabel = uilabel(app.MatrixSensitivityFactorMSFTab);
            app.ComparetoDropDownLabel.HorizontalAlignment = 'right';
            app.ComparetoDropDownLabel.Position = [8 627 72 22];
            app.ComparetoDropDownLabel.Text = 'Compare to:';

            % Create ComparetoDropDown
            app.ComparetoDropDown = uidropdown(app.MatrixSensitivityFactorMSFTab);
            app.ComparetoDropDown.Items = {'', ''};
            app.ComparetoDropDown.ValueChangedFcn = createCallbackFcn(app, @ComparetoDropDownValueChanged, true);
            app.ComparetoDropDown.Position = [86 623 177 30];
            app.ComparetoDropDown.Value = '';

            % Create ExportTableButton
            app.ExportTableButton = uibutton(app.MatrixSensitivityFactorMSFTab, 'push');
            app.ExportTableButton.ButtonPushedFcn = createCallbackFcn(app, @ExportTableButtonPushed, true);
            app.ExportTableButton.Position = [502 624 122 26];
            app.ExportTableButton.Text = 'Export Table';

            % Create ProgressPanel
            app.ProgressPanel = uipanel(app.GridLayout2);
            app.ProgressPanel.BorderType = 'none';
            app.ProgressPanel.Layout.Row = 1;
            app.ProgressPanel.Layout.Column = 2;

            % Create GridLayout3
            app.GridLayout3 = uigridlayout(app.ProgressPanel);
            app.GridLayout3.ColumnWidth = {120, 120, 120, 120, 120, 120};
            app.GridLayout3.RowHeight = {23};
            app.GridLayout3.Padding = [10 3.15000915527344 10 3.15000915527344];

            % Create IntervalButton
            app.IntervalButton = uibutton(app.GridLayout3, 'push');
            app.IntervalButton.ButtonPushedFcn = createCallbackFcn(app, @ImportButtonPushed, true);
            app.IntervalButton.Layout.Row = 1;
            app.IntervalButton.Layout.Column = 2;
            app.IntervalButton.Text = 'Interval';

            % Create ImportButton
            app.ImportButton = uibutton(app.GridLayout3, 'push');
            app.ImportButton.ButtonPushedFcn = createCallbackFcn(app, @ImportButtonPushed, true);
            app.ImportButton.Layout.Row = 1;
            app.ImportButton.Layout.Column = 1;
            app.ImportButton.Text = 'Import';

            % Create ClassificationButton
            app.ClassificationButton = uibutton(app.GridLayout3, 'push');
            app.ClassificationButton.ButtonPushedFcn = createCallbackFcn(app, @ImportButtonPushed, true);
            app.ClassificationButton.Layout.Row = 1;
            app.ClassificationButton.Layout.Column = 3;
            app.ClassificationButton.Text = 'Classification';

            % Create DriftButton
            app.DriftButton = uibutton(app.GridLayout3, 'push');
            app.DriftButton.ButtonPushedFcn = createCallbackFcn(app, @ImportButtonPushed, true);
            app.DriftButton.Layout.Row = 1;
            app.DriftButton.Layout.Column = 4;
            app.DriftButton.Text = 'Drift';

            % Create QuantificationButton
            app.QuantificationButton = uibutton(app.GridLayout3, 'push');
            app.QuantificationButton.Layout.Row = 1;
            app.QuantificationButton.Layout.Column = 5;
            app.QuantificationButton.Text = 'Quantification';

            % Create ResultsButton
            app.ResultsButton = uibutton(app.GridLayout3, 'push');
            app.ResultsButton.ButtonPushedFcn = createCallbackFcn(app, @ImportButtonPushed, true);
            app.ResultsButton.Layout.Row = 1;
            app.ResultsButton.Layout.Column = 6;
            app.ResultsButton.Text = 'Results';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Quantification_Module_readable(varargin)

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