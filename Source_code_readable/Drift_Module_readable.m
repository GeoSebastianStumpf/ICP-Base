% GENERATED from Drift_Module.mlapp on 2026-10-28 16:53 by export_mlapp_to_m. This file is for reading purposes, any real changes need to be applied to the .mlapp files and exported again.
classdef Drift_Module_readable < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                   matlab.ui.Figure
        BaseMenu                   matlab.ui.container.Menu
        ExitMenu                   matlab.ui.container.Menu
        GridLayout                 matlab.ui.container.GridLayout
        ShowUncertaintiesCheckBox  matlab.ui.control.CheckBox
        BracketidDropDown          matlab.ui.control.DropDown
        BracketidDropDownLabel     matlab.ui.control.Label
        CalibratorDropDown         matlab.ui.control.DropDown
        CalibratorDropDownLabel    matlab.ui.control.Label
        ProgressPanel              matlab.ui.container.Panel
        ResultsButton              matlab.ui.control.Button
        QuantificationButton       matlab.ui.control.Button
        DriftButton                matlab.ui.control.Button
        ClassificationButton       matlab.ui.control.Button
        ImportButton               matlab.ui.control.Button
        IntervalButton             matlab.ui.control.Button
        ProceedtoQuantificationModuleButton  matlab.ui.control.Button
        PreviousAnalyteButton      matlab.ui.control.Button
        PlotLabelsCheckBox         matlab.ui.control.CheckBox
        NextAnalyteButton          matlab.ui.control.Button
        ElementLegendListBox       matlab.ui.control.ListBox
        DriftAxes                  matlab.ui.control.UIAxes
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

        all_CAL
        selected_CAL
        selected_bracket_id
        mean_analyte_cps_matrix


        selected_analytes

        %%%%%%%%
        initial_sensitivities
        initial_sensitivities_unc
        sensitivities_to_fit
        drift_segments
        corrected_values_for_plotting

        icm_ratios_to_fit
        blank_signals_to_fit 

    end

    methods (Access = private)

        function update_drift_module(app)

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

            % populate the elementlistbox
            app.ElementLegendListBox.Items = ['All'; app.base.project.session.spot.sensitivities{app.BracketidDropDown.Value, app.selected_CAL}.Properties.VariableNames'];
            app.ElementLegendListBox.ItemsData = 0:numel(app.ElementLegendListBox.Items)-1;

            update_line_plot(app)
            update_scatter_plot(app)

        end

        function same = values_match(app, a, b)
            % equal up to floating-point noise: recomputing on another computer (e.g. Windows vs macOS)
            % can change the last digits, which must not count as a change of the results
            relative_tolerance = 1e-8;

            if istable(a) && istable(b)
                same = isequal(a.Properties.VariableNames, b.Properties.VariableNames);
                if same
                    try
                        same = values_match(app, table2array(a), table2array(b));
                    catch
                        same = isequaln(a, b);   % table with non-numeric columns
                    end
                end

            elseif iscell(a) && iscell(b)
                same = isequal(size(a), size(b)) && ...
                    all(cellfun(@(x, y) values_match(app, x, y), a(:), b(:)));

            elseif isnumeric(a) && isnumeric(b)
                a = double(a(:));
                b = double(b(:));
                same = numel(a) == numel(b) && ...
                    all(a == b | (isnan(a) & isnan(b)) | abs(a - b) <= relative_tolerance * max(abs(a), abs(b)) | abs(a - b) < 1e-12);

            else
                same = isequaln(a, b);
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

            app.DriftButton.Enable = "on";
            app.DriftButton.BackgroundColor = green;
            app.DriftButton.FontWeight = 'bold';

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

        function [differs, changed_fields, added_fields] = spot_results_differ(app, spot_before, spot_after, verbose)
            % Compares two copies of spot field by field (the field names are taken from the structs).
            %   changed_fields: existed before and has different values, or was removed
            %   added_fields:   did not exist before
            % Only changed_fields make downstream results (quantification, results) outdated.

            if nargin < 4
                verbose = false;
            end

            fields_to_skip = {'signal_data'};      % large raw data, not changed by the drift calculation

            all_field_names = union(fieldnames(spot_before), fieldnames(spot_after));
            all_field_names = setdiff(all_field_names, fields_to_skip);

            changed_fields = {};
            added_fields   = {};

            for field_number = 1:numel(all_field_names)
                field_name = all_field_names{field_number};

                exists_before = isfield(spot_before, field_name);
                exists_after  = isfield(spot_after,  field_name);

                if ~exists_before && exists_after
                    added_fields{end+1} = field_name; %#ok<AGROW>
                elseif exists_before && ~exists_after
                    changed_fields{end+1} = field_name; %#ok<AGROW>
                elseif exists_before && exists_after && ~values_match(app, spot_before.(field_name), spot_after.(field_name))
                    changed_fields{end+1} = field_name; %#ok<AGROW>
                end
            end

            differs = ~isempty(changed_fields) || ~isempty(added_fields);

            if verbose && differs
                fprintf('[spot_results_differ] changed: %s | added: %s\n', strjoin(changed_fields, ', '), strjoin(added_fields, ', '));
            end
        end
        
        %%%%%%% functions for GUI plotting %%%%%%%%%%

        function update_scatter_plot(app)

            cal_indices   = app.base.project.session.spot.type == "CAL";
            cal_materials = app.base.project.session.spot.referencematerial(cal_indices);
            unique_names  = unique(cal_materials);
            unique_names  = unique_names(unique_names ~= "None");
            validCALs     = unique_names(unique_names ~= "Select Reference Material");

            rm_idx      = find(app.base.project.session.spot.referencematerial == validCALs(app.selected_CAL));
            bracket_idx = find(app.base.project.session.spot.bracket_id == app.BracketidDropDown.Value);
            valid_idx   = intersect(rm_idx, bracket_idx);

            x_data = app.base.project.session.spot.integer_time_points(valid_idx);
            y_data = app.initial_sensitivities(valid_idx, :);

            % individual-CAL uncertainty (backwards compatible)
            if ~isempty(app.initial_sensitivities_unc) && ...
                    isequal(size(app.initial_sensitivities_unc), size(app.initial_sensitivities))
                y_err = app.initial_sensitivities_unc(valid_idx, :);
            else
                y_err = zeros(size(y_data));
            end

            zero_cols = all(y_data == 0, 1);
            y_data    = y_data(:, ~zero_cols);
            y_err     = y_err(:, ~zero_cols);

            if isempty(y_data)
                return
            end

            analyte_names = app.base.project.session.spot.analytes(~zero_cols);

            if ~isempty(app.selected_analytes)
                y_data        = y_data(:, app.selected_analytes);
                y_err         = y_err(:, app.selected_analytes);
                analyte_names = analyte_names(app.selected_analytes);
            end

            hold(app.DriftAxes, 'on');
            colors = lines(size(y_data, 2));
            for k = 1:size(y_data, 2)
                % error bars behind the markers (kept out of the legend)
                if app.ShowUncertaintiesCheckBox.Value
                    errorbar(app.DriftAxes, x_data, y_data(:, k), y_err(:, k), ...
                        'LineStyle', 'none', 'Color', colors(k, :), 'CapSize', 4, ...
                        'HandleVisibility', 'off');
                end

                s = scatter(app.DriftAxes, x_data, y_data(:, k), 15, colors(k, :), 'o', 'filled');
                s.DataTipTemplate.DataTipRows = [
                    dataTipTextRow('Sensitivity', y_data(:, k))
                    dataTipTextRow('Analyte',     repmat(analyte_names(k), numel(x_data), 1))
                    ];
            end
            hold(app.DriftAxes, 'off');

            xlim(app.DriftAxes, [0 max(app.base.project.session.spot.integer_time_points) + 100]);
            ylim(app.DriftAxes, [min(y_data(:)) * 0.7, max(y_data(:)) * 1.3]);
            set(app.DriftAxes, 'YScale', 'log');
            set(app.DriftAxes, 'yminorgrid', 'on')
            set(app.DriftAxes, 'MinorGridLineStyle', '-')
            set(app.DriftAxes, 'MinorGridAlpha', 0.15)

        end

        function update_line_plot(app)
            cla(app.DriftAxes)
            delete(allchild(app.DriftAxes))
            hold(app.DriftAxes, 'on');

            blue = [0.7, 0.7, 1];      % 0-5% change
            % turquoise = [0.7, 1, 0.9]; % 5-10% change
            % green = [0.9, 1, 0.3];     % 10-15% change
            orange = [1, 0.5, 0];      % 15-20% change
            red = [1, 0, 0];           % >20% change

            for row = 1:size(app.sensitivities_to_fit, 1)
                for col = 1:size(app.sensitivities_to_fit, 2)
                    current_cell = app.sensitivities_to_fit{row, col};

                    if isempty(current_cell) || col ~= app.selected_CAL
                        continue
                    end
                    if isempty(current_cell) || row ~= app.BracketidDropDown.Value
                        continue
                    end

                    indices = current_cell.indices;
                    x_values = zeros(size(indices));

                    for idx = 1:length(indices)
                        if mod(indices(idx), 1) == 0
                            x_values(idx) = app.base.project.session.spot.integer_time_points(indices(idx));
                        else
                            lower_idx = floor(indices(idx));
                            upper_idx = ceil(indices(idx));
                            lower_val = app.base.project.session.spot.integer_time_points(lower_idx);
                            upper_val = app.base.project.session.spot.integer_time_points(upper_idx);
                            x_values(idx) = (lower_val + upper_val) / 2;
                        end
                    end

                    y_values = current_cell.sensitivities;
                    if isfield(current_cell, 'sensitivities_unc')
                        y_unc = current_cell.sensitivities_unc;
                    else
                        y_unc = zeros(size(y_values));
                    end
                    % Find columns that are not all zeros
                    non_zero_cols = any(y_values ~= 0);
                    % Keep only non-zero columns
                    y_values = y_values(:, non_zero_cols);
                    y_unc    = y_unc(:, non_zero_cols);

                    if ~isempty(app.selected_analytes)
                        y_values = y_values(:, app.selected_analytes);
                        y_unc    = y_unc(:, app.selected_analytes);
                    end

                    for i = 1:size(y_values, 2)

                        analytes = string(app.ElementLegendListBox.Items(2:end));

                        if isempty(app.selected_analytes)
                            analyte_name = analytes(i);
                        else
                            analyte_name = analytes(app.selected_analytes(i));
                        end

                        for j = 1:length(x_values)-1
                            change = abs((y_values(j+1,i) - y_values(j,i)) / y_values(j,i) * 100);

                            % if change <= 5
                            %     color = blue;
                            % elseif change <= 10
                            %     color = turquoise;
                            % elseif change <= 15
                            %     color = green;
                            % elseif change <= 20
                            %     color = orange;
                            % else
                            %     color = red;
                            % end

                            if change <= 5
                                color = blue;
                            elseif change <= 15
                                color = orange;
                            else
                                color = red;
                            end

                            % uncertainty envelope for this segment (confidence band)
                            n_band  = 20;
                            w       = linspace(0, 1, n_band);
                            x_seg   = x_values(j)   + (x_values(j+1)   - x_values(j))   * w;
                            y_seg   = y_values(j,i) + (y_values(j+1,i) - y_values(j,i)) * w;
                            sig_seg = sqrt((1-w).^2 * y_unc(j,i)^2 + w.^2 * y_unc(j+1,i)^2);
                            x_seg   = x_seg(:).';
                            y_seg   = y_seg(:).';
                            sig_seg = sig_seg(:).';
                            upper   = y_seg + sig_seg;
                            lower   = max(y_seg - sig_seg, realmin);

                            if app.ShowUncertaintiesCheckBox.Value
                                fill(app.DriftAxes, [x_seg, fliplr(x_seg)], [upper, fliplr(lower)], ...
                                    color, 'FaceAlpha', 0.12, 'EdgeColor', 'none', ...
                                    'HandleVisibility', 'off', 'Tag', analyte_name);
                            end

                            plot(app.DriftAxes, [x_values(j), x_values(j+1)], ...
                                [y_values(j,i), y_values(j+1,i)], ...
                                '-', 'Color', color, 'LineWidth', 1.5, ...
                                'Tag', analyte_name);

                            % Label each segment
                            mid_x = (x_values(j) + x_values(j+1)) / 2;
                            mid_y = (y_values(j,i) + y_values(j+1,i)) / 2;
                            if app.PlotLabelsCheckBox.Value
                                text(app.DriftAxes, mid_x, mid_y, analyte_name, ...
                                    'HorizontalAlignment', 'center', ...
                                    'VerticalAlignment', 'middle', ...
                                    'FontSize', 8, ...
                                    'BackgroundColor', 'white', ...
                                    'EdgeColor', 'black', ...
                                    'Margin', 1,...
                                    'Clipping','on');
                            end
                        end
                        % group-averaged anchor uncertainty
                        if app.ShowUncertaintiesCheckBox.Value
                            errorbar(app.DriftAxes, x_values(:), y_values(:,i), y_unc(:,i), ...
                                'LineStyle', 'none', 'Color', [0.3 0.3 0.3], 'CapSize', 8, ...
                                'LineWidth', 1.5, 'HandleVisibility', 'off', 'Tag', analyte_name);
                        end
                    end
                end
            end
            hold(app.DriftAxes, 'off');
        end


    end




    methods (Access = public)

        %%%%%% these functions actually do the drift correction %%%%%%%%

        function calculate_integer_time_points(app)

            if strcmp(app.base.project.session.config.datatype, 'Continuous') && ~isfield(app.base.project.session.spot, 'integer_time_points')

                app.base.project.session.spot.integer_time_points = app.base.project.session.spot.signal_starts;

            elseif strcmp(app.base.project.session.config.datatype, 'Single') && isfield(app.base.project.session.spot, 'acquisition_datetime') && ~isempty(app.base.project.session.spot.acquisition_datetime)

                dt = datetime(app.base.project.session.spot.acquisition_datetime, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');

                start_time = dt(1);
                relative_times = minutes(dt - start_time);
                integer_time_points = relative_times + 1;

                app.base.project.session.spot.integer_time_points = integer_time_points;

            elseif strcmp(app.base.project.session.config.datatype, 'Single') && isfield(app.base.project.session.spot, 'acquisition_time')

                total_minutes = zeros(length(app.base.project.session.spot.acquisition_time), 1);
                for i = 1:length(app.base.project.session.spot.acquisition_time)
                    time_str = app.base.project.session.spot.acquisition_time(i);
                    parts = split(time_str, ':');
                    hours = str2double(parts(1));
                    mins = str2double(parts(2));
                    total_minutes(i) = hours * 60 + mins;
                end

                for i = 2:length(total_minutes)
                    if total_minutes(i) < total_minutes(i-1)
                        total_minutes(i:end) = total_minutes(i:end) + 1440;
                    end
                end

                start_time = total_minutes(1);
                relative_times = total_minutes - start_time;
                integer_time_points = relative_times + 1;

                app.base.project.session.spot.integer_time_points = integer_time_points;

            end

        end

        function calculate_background_corrected_matrix_intensities(app)

            background_start = app.base.project.session.spot.background_starts;
            background_end   = app.base.project.session.spot.background_ends;

            matrix_1_start = app.base.project.session.spot.matrix_1_starts;
            matrix_1_end   = app.base.project.session.spot.matrix_1_ends;
            matrix_2_start = app.base.project.session.spot.matrix_2_starts;
            matrix_2_end   = app.base.project.session.spot.matrix_2_ends;
            matrix_3_start = app.base.project.session.spot.matrix_3_starts;
            matrix_3_end   = app.base.project.session.spot.matrix_3_ends;

            if isequal(app.base.project.session.config.datatype, 'Continuous')
                signal = app.base.project.session.spot.signal_data;
            end

            nSpots    = numel(app.base.project.session.spot.signal_starts);
            nAnalytes = numel(app.base.project.session.spot.analytes);

            % per-analyte dwell times (seconds), aligned to the analyte columns (signal cols 2:end)
            analyte_names = app.base.project.session.spot.analytes;
            if isstring(analyte_names) || ischar(analyte_names)
                analyte_names = cellstr(analyte_names);
            end
            dt = cellfun(@(c) app.base.project.session.spot.dwelltimes.(c), analyte_names);
            dt = dt(:).';

            bg_corr_matrix = zeros(nSpots, nAnalytes);
            bg_background  = zeros(nSpots, nAnalytes);

            % uncertainty propagation
            sem_bg_mat     = zeros(nSpots, nAnalytes);
            sem_mat_mat    = zeros(nSpots, nAnalytes);
            sem_bkgd_corrected_mat = zeros(nSpots, nAnalytes);

            for spot = 1:nSpots

                if isequal(app.base.project.session.config.datatype, 'Single')
                    signal = app.base.project.session.spot.signal_data{spot};
                end

                if ~isnan(background_start(spot)) && ~isnan(background_end(spot))
                    bg_data = table2array(signal(background_start(spot):background_end(spot), 2:end));
                    mean_analytes_cps_background = mean(bg_data, 1);
                    N_bg = size(bg_data, 1);
                else
                    continue
                end

                all_matrix_data = [];
                if ~isnan(matrix_1_start(spot)) && ~isnan(matrix_1_end(spot))
                    all_matrix_data = [all_matrix_data; table2array(signal(matrix_1_start(spot):matrix_1_end(spot), 2:end))];
                end
                if ~isnan(matrix_2_start(spot)) && ~isnan(matrix_2_end(spot))
                    all_matrix_data = [all_matrix_data; table2array(signal(matrix_2_start(spot):matrix_2_end(spot), 2:end))];
                end
                if ~isnan(matrix_3_start(spot)) && ~isnan(matrix_3_end(spot))
                    all_matrix_data = [all_matrix_data; table2array(signal(matrix_3_start(spot):matrix_3_end(spot), 2:end))];
                end

                if ~isempty(all_matrix_data)
                    % uncertainty propagation
                    N_mat = size(all_matrix_data, 1);
                    mean_analytes_cps_matrix_raw = mean(all_matrix_data, 1);

                    matrix_data_corrected    = all_matrix_data - mean_analytes_cps_background;
                    mean_analytes_cps_matrix = mean(matrix_data_corrected, 1);
                else
                    continue
                end

                bg_corr_matrix(spot, :) = mean_analytes_cps_matrix;
                bg_background(spot, :)  = mean_analytes_cps_background;

                %%%%%%%%%%% uncertainty propagation %%%%%%%%%%%
                % The SEM for each window is the larger of the Poisson prediction
                % (sqrt(mean_CPS / (dt*N))) and the observed sweep-to-sweep SEM
                % (std / sqrt(N)). If the signal fluctuates beyond counting statistics —
                % from sample heterogeneity or ablation instability — the observed SEM
                % wins; otherwise Poisson sets the floor.
                
                % background
                sigma_poisson_bg = sqrt(mean_analytes_cps_background ./ (dt .* N_bg));
                sigma_observed_bg = std(bg_data, 0, 1) ./ sqrt(N_bg);
                sem_bg_mat(spot, :) = max(sigma_poisson_bg, sigma_observed_bg);

                % matrix
                sigma_poisson_mat = sqrt(mean_analytes_cps_matrix_raw ./ (dt .* N_mat));
                sigma_observed_mat = std(all_matrix_data, 0, 1) ./ sqrt(N_mat);
                sem_mat_mat(spot, :) = max(sigma_poisson_mat, sigma_observed_mat);

                % background-corrected
                sem_bkgd_corrected_mat(spot, :) = sqrt(sem_bg_mat(spot,:).^2 + sem_mat_mat(spot,:).^2);

            end

            varNames = signal.Properties.VariableNames(2:end);

            app.base.project.session.spot.bkgd_corrected_cps = array2table(bg_corr_matrix, 'VariableNames', varNames);
            app.base.project.session.spot.background_cps      = array2table(bg_background,  'VariableNames', varNames);

            %%%%%%%%%%% uncertainty propagation %%%%%%%%%%%
            app.base.project.session.spot.sem_bkgd_cps          = array2table(sem_bg_mat,     'VariableNames', varNames);
            app.base.project.session.spot.sem_matrix_cps         = array2table(sem_mat_mat,    'VariableNames', varNames);
            app.base.project.session.spot.sem_bkgd_corrected_cps = array2table(sem_bkgd_corrected_mat, 'VariableNames', varNames);

        end

        function calculate_sensitivities_of_CALs(app)

            app.all_CAL = [];
            app.initial_sensitivities     = zeros(numel(app.base.project.session.spot.type), numel(app.base.project.session.spot.analytes));
            app.initial_sensitivities_unc = zeros(numel(app.base.project.session.spot.type), numel(app.base.project.session.spot.analytes));

            for i = 1:numel(app.base.project.session.spot.type)
                if app.base.project.session.spot.type(i) == "CAL"
                    app.all_CAL = [app.all_CAL, i];
                end
            end

            for i = 1:numel(app.all_CAL)

                spot_index = app.all_CAL(i);

                bg_corrected_cps_matrix     = app.base.project.session.spot.bkgd_corrected_cps(spot_index, :);
                sem_bkgd_corrected_cps_matrix = app.base.project.session.spot.sem_bkgd_corrected_cps(spot_index, :);

                referencematerial = app.base.project.session.spot.referencematerial(spot_index);

                idx = find(app.base.project.session.referencematerials.names == referencematerial, 1);

                if ~isempty(idx)
                    cal_concentration_table  = app.base.project.session.referencematerials.data{idx};
                    cal_uncertainty_table    = app.base.project.session.referencematerials.uncertainty{idx};
                    cal_elements             = cal_concentration_table.Properties.VariableNames;

                    cleaned_analytes = regexprep(app.base.project.session.spot.analytes, '\d', '');

                    for j = 1:numel(cleaned_analytes)
                        element = char(cleaned_analytes(j));

                        if ~ismember(element, cal_elements)
                            continue
                        end

                        cps           = bg_corrected_cps_matrix.(j);
                        sem_cps       = sem_bkgd_corrected_cps_matrix.(j);
                        mass_fraction = cal_concentration_table.(element);

                        sensitivity = cps / mass_fraction;
                        app.initial_sensitivities(spot_index, j) = sensitivity;

                        relative_variance_cps = (sem_cps / cps)^2;

                        if ~isempty(cal_uncertainty_table) && ...
                            ismember(element, cal_uncertainty_table.Properties.VariableNames)

                            unc_rm_mass_fraction = cal_uncertainty_table.(element);
                            if ~isnan(unc_rm_mass_fraction) && unc_rm_mass_fraction > 0
                                relative_variance_rm = (unc_rm_mass_fraction / mass_fraction)^2;
                            else
                                relative_variance_rm = 0;
                            end
                        else
                            relative_variance_rm = 0;
                        end

                        app.initial_sensitivities_unc(spot_index, j) = sensitivity * sqrt(relative_variance_cps + relative_variance_rm);
                    end
                end
            end

            app.base.project.session.spot.cal_sensitivities     = array2table(app.initial_sensitivities,     'VariableNames', cellstr(app.base.project.session.spot.analytes));
            app.base.project.session.spot.cal_sensitivities_uncertainty = array2table(app.initial_sensitivities_unc, 'VariableNames', cellstr(app.base.project.session.spot.analytes));

        end

        function group_CALs_and_bracket_ids(app)

            cal_indices = app.base.project.session.spot.type == "CAL";

            cal_materials = app.base.project.session.spot.referencematerial(cal_indices);

            unique_names = unique(cal_materials);
            unique_names = unique_names(unique_names ~= "None");
            unique_names = unique_names(unique_names ~= "Select Reference Material");

            all_bracket_ids = unique(app.base.project.session.spot.bracket_id);
            all_bracket_ids = all_bracket_ids(all_bracket_ids ~= 0);

            app.sensitivities_to_fit = cell(max(all_bracket_ids), length(unique_names));

            % per-CAL counting SEM in CPS space (nSpots x nAnalytes)
            sem_cps_all      = table2array(app.base.project.session.spot.sem_bkgd_corrected_cps);
            cleaned_analytes = regexprep(app.base.project.session.spot.analytes, '\d', '');
            nAnalytes        = size(app.initial_sensitivities, 2);

            for cal_idx = 1:length(unique_names)
                name    = unique_names(cal_idx);
                indices = [];

                for j = 1:length(app.base.project.session.spot.referencematerial)
                    if app.base.project.session.spot.referencematerial(j) == name && app.base.project.session.spot.type(j) == "CAL"
                        indices(end+1) = j;
                    end
                end

                % RM mass fractions and uncertainties for this material (same for the whole group)
                idx_rm                  = find(app.base.project.session.referencematerials.names == name, 1);
                cal_concentration_table = app.base.project.session.referencematerials.data{idx_rm};
                if isfield(app.base.project.session.referencematerials, 'uncertainty') && ...
                        numel(app.base.project.session.referencematerials.uncertainty) >= idx_rm
                    cal_uncertainty_table = app.base.project.session.referencematerials.uncertainty{idx_rm};
                else
                    cal_uncertainty_table = [];
                end
                cal_elements            = cal_concentration_table.Properties.VariableNames;

                mass_fraction_vector    = nan(1, nAnalytes);
                unc_mass_fraction_vector = zeros(1, nAnalytes);
                for j = 1:nAnalytes
                    element = char(cleaned_analytes(j));
                    if ismember(element, cal_elements)
                        mass_fraction_vector(j) = cal_concentration_table.(element);
                        if ~isempty(cal_uncertainty_table) && ismember(element, cal_uncertainty_table.Properties.VariableNames)
                            v = cal_uncertainty_table.(element);
                            if ~isnan(v) && v > 0
                                unc_mass_fraction_vector(j) = v;
                            end
                        end
                    end
                end

                bracket_ids        = app.base.project.session.spot.bracket_id(indices);
                unique_bracket_ids = unique(bracket_ids);

                for bracket_idx = 1:length(unique_bracket_ids)
                    bracket_id      = unique_bracket_ids(bracket_idx);
                    bracket_indices = indices(bracket_ids == bracket_id);

                    bracket_indices = bracket_indices(any(app.initial_sensitivities(bracket_indices, :), 2));

                    if isempty(bracket_indices)
                        message = "Too many CAL intervals are missing to regress sensitivities. ICP-Base needs a bracket start and end to do the regression between them.";
                        uialert(app.UIFigure, message, "Warning", "Icon", "warning");
                        error('ICP_Base:driftFailed', message);
                    end

                    sensitivities_to_average = zeros(numel(bracket_indices), size(app.initial_sensitivities, 2));
                    sem_cps_to_average       = zeros(numel(bracket_indices), nAnalytes);
                    for x = 1:numel(bracket_indices)
                        sensitivities_to_average(x, :) = app.initial_sensitivities(bracket_indices(x), :);
                        sem_cps_to_average(x, :)       = sem_cps_all(bracket_indices(x), :);
                    end

                    group_breaks = [0];
                    for k = 1:length(bracket_indices)-1
                        spots_between     = bracket_indices(k)+1 : bracket_indices(k+1)-1;
                        types_between     = app.base.project.session.spot.type(spots_between);
                        materials_between = app.base.project.session.spot.referencematerial(spots_between);
                        if any(types_between ~= "CAL") || any(materials_between ~= name)
                            group_breaks(end+1) = k;
                        end
                    end
                    group_breaks = [group_breaks(:); length(bracket_indices)];

                    average_sensitivities_to_fit              = zeros(size(sensitivities_to_average));
                    average_sensitivities_unc_to_fit          = zeros(size(sensitivities_to_average));  % combined
                    average_sensitivities_unc_counting_to_fit = zeros(size(sensitivities_to_average));  % counting component
                    average_sensitivities_unc_rm_to_fit       = zeros(size(sensitivities_to_average));  % RM component
                    average_sensitivities_to_fit_idx          = zeros(length(bracket_indices), 1);

                    for group_idx = 1:length(group_breaks)-1
                        start_idx     = group_breaks(group_idx) + 1;
                        end_idx       = group_breaks(group_idx+1);
                        current_group = start_idx:end_idx;
                        n_in_group    = length(current_group);

                        group_sensitivities = sensitivities_to_average(current_group, :);
                        avg_sensitivity     = mean(group_sensitivities, 1, 'omitnan');


                        % ---- uncertainty propagation on the group-averaged sensitivity ----
                        % Sensitivity S = CPS / C. Two error sources behave differently:
                        %   - counting statistics (from CPS): independent per CAL -> shrinks with N
                        %   - RM uncertainty (from C):        shared -> correlated, does NOT reduce

                        % counting SEM (CPS space) for every CAL spot in this group (N x nAnalytes)
                        group_sem_cps = sem_cps_to_average(current_group, :);

                        % propagated counting SEM of the group mean (reduces by sqrt(N))
                        sem_mean_cps     = sqrt(sum(group_sem_cps.^2, 1)) / n_in_group;
                        avg_unc_counting = sem_mean_cps ./ mass_fraction_vector;

                        % between-spot SEM: take max with counting floor to capture real scatter
                        % without double-counting (std=0 for N=1, so counting floor wins automatically)
                        sem_between      = std(group_sensitivities, 0, 1) / sqrt(n_in_group);
                        avg_unc_counting = max(sem_between, avg_unc_counting);

                        % RM contribution: relative uncertainty scaled by the averaged sensitivity.
                        % shared across the whole group -> fully correlated, does NOT reduce or inflate
                        avg_unc_rm = avg_sensitivity .* (unc_mass_fraction_vector ./ mass_fraction_vector);

                        % combine the two independent contributions in quadrature
                        avg_sensitivity_unc = sqrt(avg_unc_counting.^2 + avg_unc_rm.^2);
                        % ---------------------------------------------------------------

                        current_bracket_indices = bracket_indices(current_group);

                        if mod(n_in_group, 2) == 0
                            mid_idx       = n_in_group/2 - 0.5;
                            storage_idx   = current_group(ceil(mid_idx));
                            plot_position = (current_bracket_indices(ceil(mid_idx)) + current_bracket_indices(ceil(mid_idx) + 1)) / 2;
                        else
                            mid_idx       = ceil(n_in_group/2);
                            storage_idx   = current_group(mid_idx);
                            plot_position = current_bracket_indices(mid_idx);
                        end

                        average_sensitivities_to_fit(storage_idx, :)              = avg_sensitivity;
                        average_sensitivities_unc_to_fit(storage_idx, :)          = avg_sensitivity_unc;
                        average_sensitivities_unc_counting_to_fit(storage_idx, :) = avg_unc_counting;
                        average_sensitivities_unc_rm_to_fit(storage_idx, :)       = avg_unc_rm;
                        average_sensitivities_to_fit_idx(storage_idx)             = plot_position;
                    end

                    non_zero_rows                             = ~all(average_sensitivities_to_fit == 0, 2);
                    average_sensitivities_to_fit              = average_sensitivities_to_fit(non_zero_rows, :);
                    average_sensitivities_unc_to_fit          = average_sensitivities_unc_to_fit(non_zero_rows, :);
                    average_sensitivities_unc_counting_to_fit = average_sensitivities_unc_counting_to_fit(non_zero_rows, :);
                    average_sensitivities_unc_rm_to_fit       = average_sensitivities_unc_rm_to_fit(non_zero_rows, :);
                    average_sensitivities_to_fit_idx          = average_sensitivities_to_fit_idx(non_zero_rows);

                    app.sensitivities_to_fit{bracket_id, cal_idx} = struct(...
                        'sensitivities',              average_sensitivities_to_fit,              ...
                        'sensitivities_unc',          average_sensitivities_unc_to_fit,          ...
                        'sensitivities_unc_counting', average_sensitivities_unc_counting_to_fit, ...
                        'sensitivities_unc_rm',       average_sensitivities_unc_rm_to_fit,       ...
                        'indices',                    average_sensitivities_to_fit_idx);
                end
            end
        end

        function linear_regression(app)
            % Find the linear index of the first non-empty cell
            first_non_empty_idx = find(~cellfun(@isempty, app.sensitivities_to_fit), 1);

            % Check if we actually found at least one non-empty cell
            if ~isempty(first_non_empty_idx)
                first_valid_struct = app.sensitivities_to_fit{first_non_empty_idx};
                num_columns = size(first_valid_struct.sensitivities, 2);
            end

            for row = 1:size(app.sensitivities_to_fit, 1)
                for col = 1:size(app.sensitivities_to_fit, 2)
                    current_cell = app.sensitivities_to_fit{row, col};

                    % Skip empty cells
                    if isempty(current_cell)
                        continue
                    end
                    if isequal(numel(current_cell.indices), 0) || isequal(numel(current_cell.indices), 1)
                        message = "Drift calculation failed. Maybe too many Calibrator intervals are missing to regress sensitivities or not enough calibrators were selected to build brackets.";
                        uialert(app.UIFigure,message,"Warning", "Icon","warning");
                        error('ICP_Base:driftFailed', message)
                    end

                    % Get x values (signal starts)
                    indices = current_cell.indices;
                    x_values = zeros(size(indices));

                    for idx = 1:length(indices)
                        if mod(indices(idx), 1) == 0
                            x_values(idx) = app.base.project.session.spot.integer_time_points(indices(idx));
                        else
                            lower_idx = floor(indices(idx));
                            upper_idx = ceil(indices(idx));
                            lower_val = app.base.project.session.spot.integer_time_points(lower_idx);
                            upper_val = app.base.project.session.spot.integer_time_points(upper_idx);
                            x_values(idx) = (lower_val + upper_val) / 2;
                        end
                    end
                    sensitivities              = current_cell.sensitivities;
                    sensitivities_unc          = current_cell.sensitivities_unc;
                    sensitivities_unc_counting = current_cell.sensitivities_unc_counting;
                    sensitivities_unc_rm       = current_cell.sensitivities_unc_rm;

                    % Initialize segment storage
                    num_segments = length(x_values) - 1;
                    slopes = zeros(num_segments, num_columns);
                    intercepts = zeros(num_segments, num_columns);

                    % Fit lines between consecutive points
                    for i = 1:num_segments
                        x_segment = x_values(i:i+1);
                        for sens_col = 1:size(sensitivities, 2)
                            y_segment = sensitivities(i:i+1, sens_col);
                            coeffs = polyfit(x_segment, y_segment, 1);
                            slopes(i, sens_col) = coeffs(1);
                            intercepts(i, sens_col) = coeffs(2);
                        end
                    end

                    % uncertainty propagation:
                    % carry the two anchor-point uncertainties of each segment forward.
                    % the confidence envelope is built in unknown_fitting by weighting
                    % these two endpoints depending on where a spot falls in the segment.
                    % counting and RM are carried separately so unknown_fitting can
                    % interpolate counting (quadrature, independent) and RM (linear, correlated).
                    unc_start          = sensitivities_unc(1:end-1, :);            % combined, left anchor
                    unc_end            = sensitivities_unc(2:end,   :);            % combined, right anchor
                    unc_start_counting = sensitivities_unc_counting(1:end-1, :);
                    unc_end_counting   = sensitivities_unc_counting(2:end,   :);
                    unc_start_rm       = sensitivities_unc_rm(1:end-1, :);
                    unc_end_rm         = sensitivities_unc_rm(2:end,   :);

                    % Store results in app
                    app.drift_segments{row, col} = struct(...
                        'slopes',             slopes, ...
                        'intercepts',         intercepts, ...
                        'unc_start',          unc_start, ...
                        'unc_end',            unc_end, ...
                        'unc_start_counting', unc_start_counting, ...
                        'unc_end_counting',   unc_end_counting, ...
                        'unc_start_rm',       unc_start_rm, ...
                        'unc_end_rm',         unc_end_rm, ...
                        'time_ranges',        [x_values(1:end-1), x_values(2:end)]);
                end
            end
        end

        function unknown_fitting(app)
            % Get all signal starts
            all_integer_time_points = app.base.project.session.spot.integer_time_points;

            % Process each bracket and CAL combination
            for row = 1:size(app.drift_segments, 1)
                for col = 1:size(app.drift_segments, 2)
                    current_segments = app.drift_segments{row, col};

                    % Skip empty cells
                    if isempty(current_segments)
                        continue
                    end

                    % Initialize storage for this bracket-CAL combination
                    num_spots   = length(all_integer_time_points);
                    num_columns = size(current_segments.slopes, 2);
                    corrected_values         = zeros(num_spots, num_columns);
                    corrected_unc            = zeros(num_spots, num_columns);   % combined
                    corrected_unc_rm         = zeros(num_spots, num_columns);   % RM component only

                    % Process each segment
                    for seg = 1:size(current_segments.time_ranges, 1)
                        % Get segment time range
                        start_time = current_segments.time_ranges(seg, 1);
                        end_time = current_segments.time_ranges(seg, 2);

                        % Find indices within this time range
                        in_range_idx = find(all_integer_time_points >= start_time & ...
                            all_integer_time_points <= end_time);

                        % Get corresponding x-values
                        x_values = all_integer_time_points(in_range_idx);

                        % fractional position within the segment (0 at left anchor, 1 at right)
                        span = end_time - start_time;
                        if span == 0
                            w = zeros(size(x_values));
                        else
                            w = (x_values - start_time) / span;
                        end

                        % Calculate corrected sensitivities for each column
                        for col_idx = 1:num_columns
                            slope = current_segments.slopes(seg, col_idx);
                            intercept = current_segments.intercepts(seg, col_idx);

                            % Apply line equation y = kx + d
                            corrected_values(in_range_idx, col_idx) = slope * x_values + intercept;

                            % uncertainty propagation, per root source:
                            %   counting: independent between anchors -> quadrature (narrows toward the middle)
                            %   RM:       correlated (same reference material) -> linear (carries through fully)
                            sigma_A_counting = current_segments.unc_start_counting(seg, col_idx);
                            sigma_B_counting = current_segments.unc_end_counting(seg, col_idx);
                            sigma_counting = sqrt((1 - w).^2 * sigma_A_counting^2 + w.^2 * sigma_B_counting^2);

                            sigma_A_rm = current_segments.unc_start_rm(seg, col_idx);
                            sigma_B_rm = current_segments.unc_end_rm(seg, col_idx);
                            sigma_rm = (1 - w) * sigma_A_rm + w * sigma_B_rm;

                            corrected_unc(in_range_idx, col_idx)    = sqrt(sigma_counting.^2 + sigma_rm.^2);
                            corrected_unc_rm(in_range_idx, col_idx) = sigma_rm;
                        end
                    end

                    app.corrected_values_for_plotting{row, col} = corrected_values;
                    % Store results
                    % Find CAL indices
                    cal_indices = find(app.base.project.session.spot.type == "CAL");
                    % Set CAL rows to zero
                    corrected_values(cal_indices, :) = 0;
                    corrected_unc(cal_indices, :)    = 0;
                    corrected_unc_rm(cal_indices, :) = 0;

                    analyte_names = cellstr(app.base.project.session.spot.analytes);
                    app.base.project.session.spot.sensitivities{row, col}                = array2table(corrected_values, 'VariableNames', analyte_names);
                    app.base.project.session.spot.sensitivities_uncertainty{row, col}    = array2table(corrected_unc,    'VariableNames', analyte_names);
                    app.base.project.session.spot.sensitivities_uncertainty_rm{row, col} = array2table(corrected_unc_rm, 'VariableNames', analyte_names);

                    % Delete columns that contain only zeros from each table
                    data = table2array(app.base.project.session.spot.sensitivities{row, col});
                    zero_cols = all(data == 0, 1);  % Find columns that are all zero
                    app.base.project.session.spot.sensitivities{row, col}(:, zero_cols)                = [];
                    app.base.project.session.spot.sensitivities_uncertainty{row, col}(:, zero_cols)    = [];
                    app.base.project.session.spot.sensitivities_uncertainty_rm{row, col}(:, zero_cols) = [];
                end
            end
        end


        %%%%%%%  Inclusion Stuff %%%%%%%%%%%%%%
        % Needed here for interference correction

        function initialize_inclusion_cps_tables(app)
            n_spots  = numel(app.base.project.session.spot.name);
            analytes = cellstr(app.base.project.session.spot.analytes);
            empty_table = array2table(zeros(n_spots, numel(analytes)), 'VariableNames', analytes);

            app.base.project.session.spot.bkgd_corrected_cps_incl = empty_table;
            app.base.project.session.spot.bkgd_corrected_cps_host = empty_table;

            app.base.project.session.spot.sem_bkgd_corrected_cps_incl = empty_table;
            app.base.project.session.spot.sem_bkgd_corrected_cps_host = empty_table;
        end

        function calculate_background_corrected_mix_intensities(app)

            if isequal(app.base.project.session.config.reductiontype, 'Inclusion')

                all_UNK = find(~strcmp(app.base.project.session.spot.type, "CAL"));

                if ~isfield(app.base.project.session.spot, 'bkgd_corrected_cps_mix')
                    app.base.project.session.spot.bkgd_corrected_cps_mix = array2table(zeros(numel(app.base.project.session.spot.name), numel(app.base.project.session.spot.analytes)), ...
                        'VariableNames', cellstr(app.base.project.session.spot.analytes));
                end

                % uncertainty propagation: per-analyte dwell times (s) and SEM storage
                nSpots        = numel(app.base.project.session.spot.name);
                analyte_names = app.base.project.session.spot.analytes;
                if isstring(analyte_names) || ischar(analyte_names)
                    analyte_names = cellstr(analyte_names);
                end
                dt          = cellfun(@(c) app.base.project.session.spot.dwelltimes.(c), analyte_names);
                dt          = dt(:).';
                sem_mix_mat = zeros(nSpots, numel(analyte_names));

                for i = 1:numel(all_UNK)
                    unk = all_UNK(i);

                    inclusion_1_start = app.base.project.session.spot.inclusion_1_starts(unk);
                    inclusion_1_end   = app.base.project.session.spot.inclusion_1_ends(unk);

                    if isnan(inclusion_1_start) || isnan(inclusion_1_end)
                        continue
                    end

                    if isequal(app.base.project.session.config.datatype, 'Continuous')
                        data_incl = table2array(app.base.project.session.spot.signal_data(:, 2:end));
                    elseif isequal(app.base.project.session.config.datatype, 'Single')
                        data_incl = table2array(app.base.project.session.spot.signal_data{unk}(:, 2:end));
                    end

                    background_start_incl       = app.base.project.session.spot.background_starts(unk);
                    background_end_incl         = app.base.project.session.spot.background_ends(unk);
                    background_values_incl      = data_incl(background_start_incl:background_end_incl, :);
                    background_values_mean_incl = mean(background_values_incl, 1);
                    data_incl_corrected         = data_incl - background_values_mean_incl;

                    mix_data              = data_incl_corrected(inclusion_1_start:inclusion_1_end, :);
                    mean_mix_all_elements = mean(mix_data, 1);

                    column_headers = app.base.project.session.spot.analytes;
                    mix_table      = array2table(mean_mix_all_elements, 'VariableNames', cellstr(column_headers));

                    app.base.project.session.spot.bkgd_corrected_cps_mix(unk, :) = mix_table;

                    %%%%%%%%%%% uncertainty propagation %%%%%%%%%%%
                    % same max(Poisson, observed) recipe as the matrix, on the raw windows.
                    % The background SEM is computed from this spot's own background window
                    % (not taken from the matrix SEM, which is skipped for spots without matrix intervals).
                    raw_mix_data = data_incl(inclusion_1_start:inclusion_1_end, :);
                    N_mix = size(raw_mix_data, 1);
                    N_bg  = size(background_values_incl, 1);

                    sem_mix_raw = max(sqrt(mean(raw_mix_data, 1) ./ (dt .* N_mix)), ...
                        std(raw_mix_data, 0, 1) ./ sqrt(N_mix));
                    sem_bg      = max(sqrt(background_values_mean_incl ./ (dt .* N_bg)), ...
                        std(background_values_incl, 0, 1) ./ sqrt(N_bg));

                    sem_mix_mat(unk, :) = sqrt(sem_mix_raw.^2 + sem_bg.^2);
                end

                app.base.project.session.spot.sem_bkgd_corrected_cps_mix = ...
                    array2table(sem_mix_mat, 'VariableNames', cellstr(app.base.project.session.spot.analytes));
            end
        end

        function matrix_only_tracer_unmixing(app)

            sess      = app.base.project.session;
            all_spots = 1:numel(sess.spot.name);
            analytes  = cellstr(sess.spot.analytes);

            % SEM tables from the drift module (single source of truth)
            sem_mix_all  = table2array(sess.spot.sem_bkgd_corrected_cps_mix);
            sem_host_all = table2array(sess.spot.sem_bkgd_corrected_cps);

            for spot = all_spots

                if sess.spot.unmixing_via(spot) ~= "Matrix-only tracer", continue; end

                inclusion_1_start = sess.spot.inclusion_1_starts(spot);
                inclusion_1_end   = sess.spot.inclusion_1_ends(spot);
                if isnan(inclusion_1_start) || isnan(inclusion_1_end), continue; end

                % Get host spot index
                host_name = sess.spot.matrix_from_spot(spot);
                host_idx  = find(sess.spot.name == host_name, 1);
                if isempty(host_idx), continue; end

                % Get signals from corrected tables
                mix_signal  = table2array(sess.spot.bkgd_corrected_cps_mix(spot, :));
                host_signal = table2array(sess.spot.bkgd_corrected_cps(host_idx, :));

                % Get matrix-only tracer index
                tracer     = sess.spot.matrix_only_tracer(spot);
                tracer_idx = find(string(analytes) == tracer, 1);
                if isempty(tracer_idx), continue; end

                mot_mix  = mix_signal(tracer_idx);
                mot_host = host_signal(tracer_idx);

                if mot_host <= 0 || mot_mix <= 0
                    uialert(app.UIFigure, ...
                        sprintf('The matrix-only tracer (%s) for spot "%s" has a non-positive signal after interference or blank correction. Check your correction configuration.', ...
                        char(tracer), char(sess.spot.name(spot))), ...
                        'Unmixing Failed', 'Icon', 'error');
                end

                intensity_ratio        = mot_mix / mot_host;
                host_contribution      = host_signal * intensity_ratio;
                inclusion_contribution = mix_signal - host_contribution;

                sess.spot.bkgd_corrected_cps_incl(spot, :) = array2table(inclusion_contribution, 'VariableNames', analytes);
                sess.spot.bkgd_corrected_cps_host(spot, :) = array2table(host_contribution,      'VariableNames', analytes);

                %%%%%%%%%%% uncertainty propagation %%%%%%%%%%%
                % host_i = h_i * r with r = mot_mix / mot_host, incl_i = mix_i - host_i.
                % r carries the counting error of both tracer signals and is shared by all
                % analytes. Analytes are otherwise treated as independent (conservative).
                sigma_mix  = sem_mix_all(spot, :);
                sigma_host = sem_host_all(host_idx, :);

                rel_var_ratio = (sigma_mix(tracer_idx) / mot_mix)^2 + (sigma_host(tracer_idx) / mot_host)^2;

                var_host_contribution = (intensity_ratio * sigma_host).^2 + host_contribution.^2 * rel_var_ratio;

                sem_host_contribution = sqrt(var_host_contribution);
                sem_inclusion         = sqrt(sigma_mix.^2 + var_host_contribution);

                % the tracer itself: host_contribution = mix exactly, so incl = 0 with no error
                sem_host_contribution(tracer_idx) = sigma_mix(tracer_idx);
                sem_inclusion(tracer_idx)         = 0;

                sess.spot.sem_bkgd_corrected_cps_incl(spot, :) = array2table(sem_inclusion,         'VariableNames', analytes);
                sess.spot.sem_bkgd_corrected_cps_host(spot, :) = array2table(sem_host_contribution, 'VariableNames', analytes);
            end

            app.base.project.session = sess;
        end

        %%%%%%%  Polyatomic Interference Correction %%%%%%%%%%%%%%

        function group_ICMs_and_compute_ratios(app)
            sess      = app.base.project.session;
            pairs     = sess.spot.icm_correction_pairs;
            cps       = sess.spot.bkgd_corrected_cps;
            time_pts  = sess.spot.integer_time_points;
            icm_mask  = sess.spot.type == "ICM";
            icm_ids   = sess.spot.icm_bracket_id;
            col_names = cps.Properties.VariableNames;

            unique_pairs = unique(pairs(:, {'Interferer', 'Target'}), 'rows');
            app.icm_ratios_to_fit = cell(height(unique_pairs), 1);

            for p = 1:height(unique_pairs)
                interferer = char(unique_pairs.Interferer(p));
                target     = char(unique_pairs.Target(p));

                if ~ismember(interferer, col_names) || ~ismember(target, col_names)
                    continue
                end

                id      = pairs.ID(pairs.Interferer == interferer & pairs.Target == target);
                id_mask = icm_mask & (icm_ids == id);
                if ~any(id_mask), continue; end

                icm_indices        = find(id_mask);
                icm_interferer_sig = cps{id_mask, interferer};
                icm_target_sig     = cps{id_mask, target};
                icm_times          = time_pts(id_mask);

                valid = icm_interferer_sig > 0;
                if ~any(valid), continue; end

                icm_indices = icm_indices(valid);
                icm_times   = icm_times(valid);
                ratios      = icm_target_sig(valid) ./ icm_interferer_sig(valid);

                % Detect group breaks
                group_breaks = 0;
                for k = 1:length(icm_indices)-1
                    spots_between = icm_indices(k)+1 : icm_indices(k+1)-1;
                    if ~isempty(spots_between) && ...
                            (any(sess.spot.type(spots_between) ~= "ICM") || any(icm_ids(spots_between) ~= id))
                        group_breaks(end+1) = k;
                    end
                end
                group_breaks = [group_breaks(:); length(icm_indices)];

                avg_ratios = zeros(length(group_breaks)-1, 1);
                avg_times  = zeros(length(group_breaks)-1, 1);

                for g = 1:length(group_breaks)-1
                    start_idx     = group_breaks(g) + 1;
                    end_idx       = group_breaks(g+1);
                    current_group = start_idx:end_idx;

                    avg_ratios(g) = mean(ratios(current_group));

                    group_times = icm_times(current_group);
                    if mod(length(current_group), 2) == 0
                        mid = length(current_group) / 2;
                        avg_times(g) = (group_times(mid) + group_times(mid+1)) / 2;
                    else
                        avg_times(g) = group_times(ceil(length(current_group)/2));
                    end
                end

                app.icm_ratios_to_fit{p} = struct(...
                    'ratios',         avg_ratios, ...
                    'time_positions', avg_times,  ...
                    'interferer',     interferer, ...
                    'target',         target);
            end
        end

        function apply_interference_correction(app)
            sess          = app.base.project.session;
            cps           = sess.spot.bkgd_corrected_cps;
            time_pts      = sess.spot.integer_time_points;
            non_icm_mask  = sess.spot.type ~= "ICM";
            non_icm_times = time_pts(non_icm_mask);

            has_mix = isfield(sess.spot, 'bkgd_corrected_cps_mix');
            if has_mix
                cps_mix       = sess.spot.bkgd_corrected_cps_mix;
                mix_col_names = cps_mix.Properties.VariableNames;
            end

            for p = 1:numel(app.icm_ratios_to_fit)
                entry = app.icm_ratios_to_fit{p};
                if isempty(entry), continue; end

                ratios     = entry.ratios;
                time_pos   = entry.time_positions;
                interferer = entry.interferer;
                target     = entry.target;

                if numel(time_pos) == 1
                    interp_ratios = repmat(ratios, sum(non_icm_mask), 1);
                else
                    interp_ratios = interp1(time_pos, ratios, non_icm_times, 'linear', 'extrap');
                end

                cps{non_icm_mask, target} = cps{non_icm_mask, target} - ...
                    cps{non_icm_mask, interferer} .* interp_ratios;

                if has_mix && ismember(target, mix_col_names) && ismember(interferer, mix_col_names)
                    cps_mix{non_icm_mask, target} = cps_mix{non_icm_mask, target} - ...
                        cps_mix{non_icm_mask, interferer} .* interp_ratios;
                end
            end

            app.base.project.session.spot.bkgd_corrected_cps = cps;
            if has_mix
                app.base.project.session.spot.bkgd_corrected_cps_mix = cps_mix;
            end
        end

        %%%%%%%  Blank Correction %%%%%%%%%%%%%%

        function group_blanks_and_compute_signals(app)
            sess      = app.base.project.session;
            pairs     = sess.spot.blank_correction_elements;
            cps       = sess.spot.bkgd_corrected_cps;
            time_pts  = sess.spot.integer_time_points;
            icm_mask  = sess.spot.type == "ICM";
            icm_ids   = sess.spot.blank_bracket_id;
            col_names = cps.Properties.VariableNames;

            unique_ids = unique(pairs.ID);
            app.blank_signals_to_fit = cell(max(unique_ids), 1);

            for i = 1:numel(unique_ids)
                id      = unique_ids(i);
                id_mask = icm_mask & (icm_ids == id);
                if ~any(id_mask), continue; end

                elements    = pairs.Element(pairs.ID == id);
                icm_indices = find(id_mask);
                icm_times   = time_pts(id_mask);

                % Detect group breaks
                group_breaks = 0;
                for k = 1:length(icm_indices)-1
                    spots_between = icm_indices(k)+1 : icm_indices(k+1)-1;
                    if ~isempty(spots_between) && ...
                            (any(sess.spot.type(spots_between) ~= "ICM") || any(icm_ids(spots_between) ~= id))
                        group_breaks(end+1) = k;
                    end
                end
                group_breaks = [group_breaks(:); length(icm_indices)];

                n_groups    = length(group_breaks) - 1;
                avg_times   = zeros(n_groups, 1);
                avg_signals = zeros(n_groups, numel(elements));

                for g = 1:n_groups
                    start_idx     = group_breaks(g) + 1;
                    end_idx       = group_breaks(g+1);
                    current_group = start_idx:end_idx;

                    group_times = icm_times(current_group);
                    if mod(length(current_group), 2) == 0
                        mid = length(current_group) / 2;
                        avg_times(g) = (group_times(mid) + group_times(mid+1)) / 2;
                    else
                        avg_times(g) = group_times(ceil(length(current_group)/2));
                    end

                    group_indices = icm_indices(current_group);

                    for e = 1:numel(elements)
                        el = char(elements(e));
                        if ~ismember(el, col_names), continue; end
                        el_signals = cps{group_indices, el};
                        valid      = el_signals > 0;
                        if ~any(valid), continue; end
                        avg_signals(g, e) = mean(el_signals(valid));
                    end
                end

                app.blank_signals_to_fit{id} = struct(...
                    'elements',       elements, ...
                    'time_positions', avg_times, ...
                    'signals',        avg_signals);
            end
        end

        function apply_blank_correction(app)
            sess      = app.base.project.session;
            cps       = sess.spot.bkgd_corrected_cps;
            time_pts  = sess.spot.integer_time_points;
            icm_mask  = sess.spot.type == "ICM";
            col_names = cps.Properties.VariableNames;

            has_mix = isfield(sess.spot, 'bkgd_corrected_cps_mix');
            if has_mix
                cps_mix = sess.spot.bkgd_corrected_cps_mix;
            end

            for id = 1:numel(app.blank_signals_to_fit)
                entry = app.blank_signals_to_fit{id};
                if isempty(entry), continue; end

                time_pos = entry.time_positions;
                elements = entry.elements;
                signals  = entry.signals;

                if id > size(sess.spot.blank_spot_assignment, 2), continue; end
                assigned_mask = logical(sess.spot.blank_spot_assignment(:, id)) & ~icm_mask;
                if ~any(assigned_mask), continue; end

                assigned_times = time_pts(assigned_mask);

                for e = 1:numel(elements)
                    el = char(elements(e));
                    if ~ismember(el, col_names), continue; end

                    if numel(time_pos) == 1
                        interp_signals = repmat(signals(1, e), sum(assigned_mask), 1);
                    else
                        interp_signals = interp1(time_pos, signals(:, e), assigned_times, 'linear', 'extrap');
                    end

                    cps{assigned_mask, el} = cps{assigned_mask, el} - interp_signals;

                    if has_mix && ismember(el, cps_mix.Properties.VariableNames)
                        cps_mix{assigned_mask, el} = cps_mix{assigned_mask, el} - interp_signals;
                    end
                end
            end

            app.base.project.session.spot.bkgd_corrected_cps = cps;
            if has_mix
                app.base.project.session.spot.bkgd_corrected_cps_mix = cps_mix;
            end
        end


        %%%%%%% public drift correction %%%%%%%%%
        % basically just a wrapper

        function drift_correction(app)

            % without a calibrator nothing can be calculated, and the module cannot display anything
            if ~any(app.base.project.session.spot.type == "CAL")
                error('ICP_Base:driftNoCAL', ['No calibrator (CAL) is assigned. ' ...
                    'Assign at least one CAL with a reference material in the Classification module.']);
            end

            calculate_integer_time_points(app)
           
            calculate_background_corrected_matrix_intensities(app)

            if isequal(app.base.project.session.config.reductiontype, 'Inclusion')
                initialize_inclusion_cps_tables(app)
                calculate_background_corrected_mix_intensities(app)
            end

            if isfield(app.base.project.session.spot, 'icm_correction_pairs') && ...
                    any(app.base.project.session.spot.type == "ICM")
                group_ICMs_and_compute_ratios(app)
                apply_interference_correction(app)
            end

            if isfield(app.base.project.session.spot, 'blank_correction_elements') && ...
                    ~isempty(app.base.project.session.spot.blank_correction_elements) && ...
                    any(app.base.project.session.spot.type == "ICM")
                group_blanks_and_compute_signals(app)
                apply_blank_correction(app)
            end

            if isequal(app.base.project.session.config.reductiontype, 'Inclusion') && ...
                    any(app.base.project.session.spot.unmixing_via == "Matrix-only tracer")
                matrix_only_tracer_unmixing(app)
            end

            calculate_sensitivities_of_CALs(app)
         
            group_CALs_and_bracket_ids(app)
         
            linear_regression(app)
         
            unknown_fitting(app)

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
                app.base.project.session.config.module_status.drift = true;


            elseif exist("project_id","var") && exist("session_id","var") % coming from the base, GUI stuff

                app.base.project.session =  app.sourceapp.base(project_id).project(session_id).session;

            end

            app.project_id = project_id;
            app.session_id = session_id;
            app.UIFigure.Name = [char(app.base.project_name) ' - ' char(app.base.project.session.session_name)]; %string(app.base.project.session.session_name);

            % Change "PRM" to "CAL" & "SRM" to "QCRM"-Backwards compatibility
            app.base.project.session.spot.type(app.base.project.session.spot.type == "PRM") = "CAL";
            app.base.project.session.spot.type(app.base.project.session.spot.type == "SRM") = "QCRM";
            
            if isfield(app.base.project.session.spot, 'prm_sensitivities')
                % Copy data to the new field
                [app.base.project.session.spot.cal_sensitivities] = app.base.project.session.spot.prm_sensitivities;
                % Remove the old field
                app.base.project.session.spot = rmfield(app.base.project.session.spot, 'prm_sensitivities');
            end
            
            app.UIFigure.Tag = sprintf('%d_%d', app.project_id, app.session_id);




           % start watching the session (kept as a handle so that it can be paused around the calculation)
            watcher = watch_session_changes(app);        
            % here the drift_correction is done at startup
            spot_before = app.base.project.session.spot;         % reference copy (data is shared, not duplicated)

            watcher.Enabled = false;                              % the recompute must not flag on its own
            try
                drift_correction(app)
            catch ME
                % the calculation failed: close without saving, the session in the base stays as it was
                DisplayError(ME, 'Drift calculation failed');
                source_app = app.sourceapp;
                delete(app)
                try
                    refresh_session_buttons(source_app)
                catch
                end
                uialert(source_app.UIFigure, ...
                    ['The drift calculation failed, so the Drift module was closed without saving. ' ...
                    'Your session data was not changed. Check the intervals for the reference materials and their RM files and the settings in the ' ...
                    'Classification module, then open Drift again.' newline newline 'Details: ' ME.message], ...
                    'Drift Calculation Failed', 'Icon', 'error');
                return
            end
            watcher.Enabled = true;

            [results_differ, changed_fields] = spot_results_differ(app, spot_before, app.base.project.session.spot);

            if results_differ
                app.base.project.session.config.synced = false;
            end

            % If existing drift results changed, quantification and results are outdated.
            % Fields that were only added (old sessions without uncertainty tables) do not count.
            downstream_was_reset = false;

            if ~isempty(changed_fields)

                module_status = app.base.project.session.config.module_status;
                quantification_was_done = isfield(module_status, 'quantification') && isequal(module_status.quantification, true);
                results_were_done       = isfield(module_status, 'results')        && isequal(module_status.results, true);

                quantification_fields_to_remove = {'matrix_composition', 'matrix_limits_of_detection', 'Fe_2_3', ...
                    'analyte_calibrator_assignment', 'matrix_composition_uncertainty'};

                if isequal(app.base.project.session.config.reductiontype, 'Inclusion')
                    quantification_fields_to_remove = [quantification_fields_to_remove, ...
                        {'inclusion_composition', 'inclusion_limits_of_detection', 'mix_composition', ...
                        'Fe_2_3_incl', 'inclusion_composition_uncertainty'}];
                end

                for field_number = 1:numel(quantification_fields_to_remove)
                    field_name = quantification_fields_to_remove{field_number};
                    if isfield(app.base.project.session.spot, field_name)
                        app.base.project.session.spot = rmfield(app.base.project.session.spot, field_name);
                    end
                end

                if quantification_was_done
                    app.base.project.session.config.module_status.quantification = false;
                end
                if results_were_done
                    app.base.project.session.config.module_status.results = false;
                end

                downstream_was_reset = quantification_was_done || results_were_done;
            end

            datacursormode(app.UIFigure, 'off');

            % write the stage status only if it changes
            session_config = app.base.project.session.config;
            if ~isfield(session_config, 'module_status') ...
                    || ~isfield(session_config.module_status, 'drift') ...
                    || ~isequal(session_config.module_status.drift, true)
                app.base.project.session.config.module_status.drift = true;
            end

            update_drift_module(app)
            update_progress_buttons(app)

            if downstream_was_reset % this only happens if in the first three modules one forgot to set module_status.drift = false
                uialert(app.UIFigure, ...
                    ['The drift results changed. Quantification and results were reset and must be recalculated. ' ...
                    'Close this window without saving to keep the previous results.'], ...
                    'Drift results changed', 'Icon', 'info');
            end
        end

        % Button pushed function: NextAnalyteButton
        function NextAnalyteButtonPushed(app, event)

            if app.selected_analytes == numel(app.ElementLegendListBox.Items)-1
                return
            elseif isempty(app.selected_analytes)
                app.selected_analytes = 1;
                app.ElementLegendListBox.Value = 1;
            else
                app.selected_analytes=app.selected_analytes + 1;
                app.ElementLegendListBox.Value=app.ElementLegendListBox.Value + 1;
            end

            %update the element list and the plot
            update_drift_module(app)

        end

        % Value changed function: CalibratorDropDown
        function CalibratorDropDownValueChanged(app, event)
            app.selected_CAL = app.CalibratorDropDown.Value;

            update_drift_module(app)
        end

        % Value changed function: ElementLegendListBox
        function ElementLegendListBoxValueChanged(app, event)
            chosen_analyte = app.ElementLegendListBox.Value;

            if chosen_analyte == 0  % When 'All' is selected (Value = 0)
                app.selected_analytes = [];
            else
                app.selected_analytes = chosen_analyte;
            end

            update_line_plot(app)
            update_scatter_plot(app)
        end

        % Value changed function: PlotLabelsCheckBox
        function PlotLabelsCheckBoxValueChanged(app, event)

            update_drift_module(app)

        end

        % Button pushed function: PreviousAnalyteButton
        function PreviousAnalyteButtonPushed(app, event)
             if isempty(app.selected_analytes)
                return
             elseif app.selected_analytes == 1
                app.selected_analytes = [];
                app.ElementLegendListBox.Value = 0;
            else
                app.selected_analytes = app.selected_analytes - 1;
                app.ElementLegendListBox.Value = app.ElementLegendListBox.Value - 1;
             end 

            update_drift_module(app)
        end

        % Button pushed function: ProceedtoQuantificationModuleButton
        function ProceedtoQuantificationModuleButtonPushed2(app, event)


            session_config = app.base.project.session.config;
            if ~isfield(session_config, 'module_status') ...
                    || ~isfield(session_config.module_status, 'drift') ...
                    || ~session_config.module_status.drift
                app.base.project.session.config.module_status.drift = true;
            end

            settings.ICP_Base_GUI_update_state = true;

            [app.project_id, app.session_id] = save_to_base(app.sourceapp, app.project_id, app.base.project.session, app.session_id, app.base.project_name, settings);
            Quantification_Module(app.sourceapp, app.base.project_name, app.project_id, app.session_id)
            delete(app)

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
                    || ~isfield(session_config.module_status, 'drift') ...
                    || ~session_config.module_status.drift
                app.base.project.session.config.module_status.drift = true;
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

        % Value changed function: BracketidDropDown
        function BracketidDropDownValueChanged(app, event)
            app.selected_bracket_id = app.BracketidDropDown.Value;

            update_drift_module(app)
        end

        % Button pushed function: ClassificationButton, ImportButton, 
        % IntervalButton, QuantificationButton, ResultsButton
        function ImportButtonPushed(app, event)
            try

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

            catch ME
                DisplayError(ME,'Proceed to other module failed')
                message = "Proceeding to other module failed";
                uialert(app.UIFigure,message,"Warning", ...
                    "Icon","warning");

                return
            end
        end

        % Value changed function: ShowUncertaintiesCheckBox
        function ShowUncertaintiesCheckBoxValueChanged(app, event)
            update_line_plot(app)
            update_scatter_plot(app)

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1068 723];
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

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {5, 39, 151, 107, 41, 59, 133, '100x', 70, 53, 80, 28, 86, 5};
            app.GridLayout.RowHeight = {35, 28, 22, '14.36x', '1x', 53, 5};
            app.GridLayout.ColumnSpacing = 5.92307692307692;
            app.GridLayout.RowSpacing = 11.1428571428571;
            app.GridLayout.Padding = [5.92307692307692 11.1428571428571 5.92307692307692 11.1428571428571];

            % Create DriftAxes
            app.DriftAxes = uiaxes(app.GridLayout);
            xlabel(app.DriftAxes, 'Integer Time Points')
            ylabel(app.DriftAxes, 'Sensitivity [cps/µg/g]')
            zlabel(app.DriftAxes, 'Z')
            app.DriftAxes.Colormap = [];
            app.DriftAxes.YScale = 'log';
            app.DriftAxes.YMinorTick = 'on';
            app.DriftAxes.Box = 'on';
            app.DriftAxes.Layout.Row = [3 6];
            app.DriftAxes.Layout.Column = [2 12];

            % Create ElementLegendListBox
            app.ElementLegendListBox = uilistbox(app.GridLayout);
            app.ElementLegendListBox.Items = {''};
            app.ElementLegendListBox.Multiselect = 'on';
            app.ElementLegendListBox.ValueChangedFcn = createCallbackFcn(app, @ElementLegendListBoxValueChanged, true);
            app.ElementLegendListBox.Layout.Row = 4;
            app.ElementLegendListBox.Layout.Column = 13;
            app.ElementLegendListBox.Value = {''};

            % Create NextAnalyteButton
            app.NextAnalyteButton = uibutton(app.GridLayout, 'push');
            app.NextAnalyteButton.ButtonPushedFcn = createCallbackFcn(app, @NextAnalyteButtonPushed, true);
            app.NextAnalyteButton.Layout.Row = 2;
            app.NextAnalyteButton.Layout.Column = [13 14];
            app.NextAnalyteButton.Text = 'Next Analyte';

            % Create PlotLabelsCheckBox
            app.PlotLabelsCheckBox = uicheckbox(app.GridLayout);
            app.PlotLabelsCheckBox.ValueChangedFcn = createCallbackFcn(app, @PlotLabelsCheckBoxValueChanged, true);
            app.PlotLabelsCheckBox.Text = 'Plot Labels';
            app.PlotLabelsCheckBox.Layout.Row = 3;
            app.PlotLabelsCheckBox.Layout.Column = 13;

            % Create PreviousAnalyteButton
            app.PreviousAnalyteButton = uibutton(app.GridLayout, 'push');
            app.PreviousAnalyteButton.ButtonPushedFcn = createCallbackFcn(app, @PreviousAnalyteButtonPushed, true);
            app.PreviousAnalyteButton.Layout.Row = 2;
            app.PreviousAnalyteButton.Layout.Column = [11 12];
            app.PreviousAnalyteButton.Text = 'Previous Analyte';

            % Create ProceedtoQuantificationModuleButton
            app.ProceedtoQuantificationModuleButton = uibutton(app.GridLayout, 'push');
            app.ProceedtoQuantificationModuleButton.ButtonPushedFcn = createCallbackFcn(app, @ProceedtoQuantificationModuleButtonPushed2, true);
            app.ProceedtoQuantificationModuleButton.WordWrap = 'on';
            app.ProceedtoQuantificationModuleButton.Layout.Row = 6;
            app.ProceedtoQuantificationModuleButton.Layout.Column = 13;
            app.ProceedtoQuantificationModuleButton.Text = 'Proceed to Quantification Module';

            % Create ProgressPanel
            app.ProgressPanel = uipanel(app.GridLayout);
            app.ProgressPanel.Layout.Row = 1;
            app.ProgressPanel.Layout.Column = [2 13];

            % Create IntervalButton
            app.IntervalButton = uibutton(app.ProgressPanel, 'push');
            app.IntervalButton.ButtonPushedFcn = createCallbackFcn(app, @ImportButtonPushed, true);
            app.IntervalButton.Position = [131 6 100 23];
            app.IntervalButton.Text = 'Interval';

            % Create ImportButton
            app.ImportButton = uibutton(app.ProgressPanel, 'push');
            app.ImportButton.ButtonPushedFcn = createCallbackFcn(app, @ImportButtonPushed, true);
            app.ImportButton.Position = [11 6 100 23];
            app.ImportButton.Text = 'Import';

            % Create ClassificationButton
            app.ClassificationButton = uibutton(app.ProgressPanel, 'push');
            app.ClassificationButton.ButtonPushedFcn = createCallbackFcn(app, @ImportButtonPushed, true);
            app.ClassificationButton.Position = [263 6 100 23];
            app.ClassificationButton.Text = 'Classification';

            % Create DriftButton
            app.DriftButton = uibutton(app.ProgressPanel, 'push');
            app.DriftButton.Position = [389 6 100 23];
            app.DriftButton.Text = 'Drift';

            % Create QuantificationButton
            app.QuantificationButton = uibutton(app.ProgressPanel, 'push');
            app.QuantificationButton.ButtonPushedFcn = createCallbackFcn(app, @ImportButtonPushed, true);
            app.QuantificationButton.Position = [509 6 100 23];
            app.QuantificationButton.Text = 'Quantification';

            % Create ResultsButton
            app.ResultsButton = uibutton(app.ProgressPanel, 'push');
            app.ResultsButton.ButtonPushedFcn = createCallbackFcn(app, @ImportButtonPushed, true);
            app.ResultsButton.Position = [633 6 100 23];
            app.ResultsButton.Text = 'Results';

            % Create CalibratorDropDownLabel
            app.CalibratorDropDownLabel = uilabel(app.GridLayout);
            app.CalibratorDropDownLabel.HorizontalAlignment = 'right';
            app.CalibratorDropDownLabel.Layout.Row = 2;
            app.CalibratorDropDownLabel.Layout.Column = 3;
            app.CalibratorDropDownLabel.Text = 'Calibrator';

            % Create CalibratorDropDown
            app.CalibratorDropDown = uidropdown(app.GridLayout);
            app.CalibratorDropDown.Items = {};
            app.CalibratorDropDown.ValueChangedFcn = createCallbackFcn(app, @CalibratorDropDownValueChanged, true);
            app.CalibratorDropDown.Layout.Row = 2;
            app.CalibratorDropDown.Layout.Column = 4;
            app.CalibratorDropDown.Value = {};

            % Create BracketidDropDownLabel
            app.BracketidDropDownLabel = uilabel(app.GridLayout);
            app.BracketidDropDownLabel.HorizontalAlignment = 'right';
            app.BracketidDropDownLabel.Layout.Row = 2;
            app.BracketidDropDownLabel.Layout.Column = 6;
            app.BracketidDropDownLabel.Text = 'Bracket id';

            % Create BracketidDropDown
            app.BracketidDropDown = uidropdown(app.GridLayout);
            app.BracketidDropDown.Items = {};
            app.BracketidDropDown.ValueChangedFcn = createCallbackFcn(app, @BracketidDropDownValueChanged, true);
            app.BracketidDropDown.Layout.Row = 2;
            app.BracketidDropDown.Layout.Column = 7;
            app.BracketidDropDown.Value = {};

            % Create ShowUncertaintiesCheckBox
            app.ShowUncertaintiesCheckBox = uicheckbox(app.GridLayout);
            app.ShowUncertaintiesCheckBox.ValueChangedFcn = createCallbackFcn(app, @ShowUncertaintiesCheckBoxValueChanged, true);
            app.ShowUncertaintiesCheckBox.Text = 'Show Uncertainties';
            app.ShowUncertaintiesCheckBox.Layout.Row = 2;
            app.ShowUncertaintiesCheckBox.Layout.Column = [9 10];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Drift_Module_readable(varargin)

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