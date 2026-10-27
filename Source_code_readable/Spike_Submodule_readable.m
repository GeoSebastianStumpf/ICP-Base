% GENERATED from Spike_Submodule.mlapp on 2026-10-27 10:27 by export_mlapp_to_m. This file is for reading purposes, any real changes need to be applied to the .mlapp files and exported again.
classdef Spike_Submodule_readable < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure          matlab.ui.Figure
        PressEnterafterenteringthenumbertoviewcustomvalueLabel  matlab.ui.control.Label
        EditField         matlab.ui.control.NumericEditField
        LogscaleCheckBox  matlab.ui.control.CheckBox
        FinishButton      matlab.ui.control.Button
        AcceptButton      matlab.ui.control.Button
        IgnoreButton      matlab.ui.control.Button
        SpikeAxes         matlab.ui.control.UIAxes
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
        source

        eliminated_spikes   % Table to store detected spike information
        corrected_data      % Data with corrected spike values
        current_spike_index % Index of the currently viewed spike
        spot
        spot_indices
        current_spot_to_plot

        data_to_correct

        inclusion
    end



    methods (Access = private)

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

        function find_and_correct_spikes(app)

            if app.inclusion == false
                % consider all data
                app.data_to_correct = app.current_spot_to_plot(:, 2:end);
                data_start_index = app.spot_indices(1);

            elseif app.inclusion == true
                % consider only inclusion data

                inc_start = app.source.base.project.session.spot.inclusion_1_starts(app.spot);
                inc_end   = app.source.base.project.session.spot.inclusion_1_ends(app.spot);

                if strcmp(app.source.base.project.session.config.datatype, 'Continuous')

                    app.data_to_correct =  app.source.base.project.session.spot.signal_data(inc_start:inc_end, 2:end);
                    data_start_index = inc_start;

                elseif strcmp(app.source.base.project.session.config.datatype, 'Single')

                    app.data_to_correct = app.current_spot_to_plot(inc_start:inc_end , 2:end);
                    data_start_index = inc_start;

                end

            end

            % Define Constants as single precision
            cpvalueseven = 2.097; % For N=7 measurements, significance level 1%
            cpvaluenine = 2.323;  % For N=9 measurements, significance level 1%
            threshold = app.source.base.project.session.config.spike_threshold; % Minimum threshold for spike detection [cps]

            % Initialize output and convert data to single for performance
            corrected_data_matrix = table2array(app.data_to_correct);
            spikes = table('Size', [0, 5], ...
                'VariableTypes', {'single', 'single', 'single', 'single', 'single'}, ...
                'VariableNames', {'RowIndex', 'ColumnIndex', 'OriginalValue', 'ReplacementValue', 'SweepIndex'});

            % Apply Grubbs' test correction using a moving window
            for col = 1:size(corrected_data_matrix, 2)
                % Start from tstep=5 to accommodate a 9-point window (t-4 to t+4)
                for tstep = 5:(size(corrected_data_matrix, 1) - 4)
                    csp = corrected_data_matrix(tstep, col);
                    % Only check points above the minimum threshold
                    if csp > threshold
                        % Define the 9-point window around the current point
                        window9 = corrected_data_matrix(tstep-4:tstep+4, col);

                        % The 7-point window is a subset of the 9-point window
                        window7 = window9([1:4, 6:9]); % Excludes point at relative index 5 (csp)

                        % Calculate statistics for both windows
                        meanseven = mean(window7);
                        stdseven = std(window7);
                        meannine = mean(window9);
                        stdnine = std(window9);

                        % Check if the point is an outlier using both criteria
                        if stdseven > 0 && stdnine > 0 && ...
                                ((abs(csp - meanseven) / stdseven) > cpvalueseven) && ...
                                ((abs(csp - meannine) / stdnine) > cpvaluenine)

                            % Calculate replacement value (mean of 6 surrounding points)
                            surrounding = corrected_data_matrix(tstep-3:tstep+3, col);
                            surrounding(4) = []; % Exclude the spike itself
                            replacement_value = mean(surrounding);

                            % Calculate absolute sweep index
                            sweep_index = tstep + data_start_index - 1;

                            % Store spike info before correction
                            new_spike = {tstep, col, csp, replacement_value, sweep_index};
                            spikes = [spikes; new_spike]; %#ok<AGROW>

                            % Apply correction to the matrix
                            corrected_data_matrix(tstep, col) = replacement_value;

                        end
                    end
                end
            end

            app.eliminated_spikes = spikes;
            app.corrected_data = array2table(corrected_data_matrix, 'VariableNames', app.data_to_correct.Properties.VariableNames());

            if ~isempty(spikes)
                app.current_spike_index = 1;
            else
                app.current_spike_index = 0;
            end
        end

        function update_spike_plot(app)

            cla(app.SpikeAxes, 'reset');

            if app.current_spike_index == 0
                app.SpikeAxes.Title.String = 'No spikes detected.';

                message = "No spikes detected";
                uialert(app.UIFigure,message,"Warning", ...
                    "Icon","warning");

                return
            end

            uncorrected_data = app.data_to_correct;

            current_spike = app.eliminated_spikes(app.current_spike_index, :);
            row = current_spike.RowIndex;
            col = current_spike.ColumnIndex;
            original_value = current_spike.OriginalValue;
            corrected_value = app.corrected_data{row, col};
            sweep_index = current_spike.SweepIndex;
            element_name = uncorrected_data.Properties.VariableNames{col};

            % Update the EditField with the current corrected value (only if it exists)
            if ~isempty(app.EditField) && isvalid(app.EditField)
                app.EditField.Value = double(corrected_value);
            end

            % Plot original and corrected data for the affected trace
            hold(app.SpikeAxes, 'on');
            plot(app.SpikeAxes, table2array(uncorrected_data(:, col)), 'r.-', 'DisplayName', 'Spike','HandleVisibility','off');
            plot(app.SpikeAxes, table2array(app.corrected_data(:, col)), 'k.-', 'DisplayName', element_name);

            % Highlight the spike and the corrected value
            plot(app.SpikeAxes, row, original_value, 'rx', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'Spike');
            plot(app.SpikeAxes, row, corrected_value, 'gx', 'MarkerSize', 12, 'LineWidth', 2, 'DisplayName', 'Corrected');
            hold(app.SpikeAxes, 'off');

            % Configure plot
            title_str = sprintf('Element: %s - Spike %d of %d (Sweep: %d)', ...
                element_name, app.current_spike_index, height(app.eliminated_spikes), sweep_index);
            app.SpikeAxes.Title.String = title_str;
            app.SpikeAxes.Title.Interpreter = 'none';
            legend(app.SpikeAxes, 'Location', 'southeast', 'Interpreter', 'none');
            app.SpikeAxes.YGrid = 'on';
            app.SpikeAxes.XGrid = 'off';
            app.SpikeAxes.GridLineStyle = '-';
            app.SpikeAxes.YMinorGrid = 'on';
            app.SpikeAxes.MinorGridLineStyle = '-';
            app.SpikeAxes.MinorGridAlpha = 0.1;
            box(app.SpikeAxes, 'on')

            % Zoom in on the spike
            zoom_window = 30;
            total_points = height(uncorrected_data);
            x_min = max(1, row - zoom_window);
            x_max = min(total_points, row + zoom_window);
            xlim(app.SpikeAxes, [x_min, x_max]);

            % Set Y-limits with padding - use CORRECTED data for proper range
            visible_data_corrected = app.corrected_data{x_min:x_max, col};
            visible_data_corrected_positive = visible_data_corrected(visible_data_corrected > 0);

            if app.LogscaleCheckBox.Value
                % Log scale
                set(app.SpikeAxes, 'YScale', 'log');

                if ~isempty(visible_data_corrected_positive)
                    y_min_val = min(visible_data_corrected_positive);
                    y_max_val = max(visible_data_corrected_positive);

                    % Include the original spike value in range calculation
                    if original_value > 0
                        y_max_val = max(y_max_val, original_value);
                    end

                    % Check if min and max are too close
                    if y_max_val / y_min_val < 1.1
                        % Expand range symmetrically in log space
                        log_center = (log10(y_max_val) + log10(y_min_val)) / 2;
                        y_min_val = 10^(log_center - 0.5);
                        y_max_val = 10^(log_center + 0.5);
                    end

                    % Use logarithmic padding
                    log_range = log10(y_max_val) - log10(y_min_val);
                    padding_factor = 0.15;

                    y_min_limit = 10^(log10(y_min_val) - log_range * padding_factor);
                    y_max_limit = 10^(log10(y_max_val) + log_range * padding_factor);

                    % Ensure limits are different
                    if y_max_limit <= y_min_limit
                        y_max_limit = y_min_limit * 10;
                    end

                    ylim(app.SpikeAxes, [max(0.1, y_min_limit), y_max_limit]);
                else
                    ylim(app.SpikeAxes, [0.1, 1000]);
                end
            else
                % Linear scale
                set(app.SpikeAxes, 'YScale', 'linear');

                y_min_val = min(visible_data_corrected);
                y_max_val = max(visible_data_corrected);

                % Include the original spike value in range calculation
                y_max_val = max(y_max_val, original_value);

                y_padding = (y_max_val - y_min_val) * 0.15;

                if y_padding == 0 || y_padding < 1e-10
                    y_padding = max(y_max_val * 0.1, 1);
                end

                % Ensure limits are different
                if (y_max_val + y_padding) <= (y_min_val - y_padding)
                    y_padding = abs(y_max_val - y_min_val) * 0.5 + 1;
                end

                ylim(app.SpikeAxes, [max(0, y_min_val - y_padding), y_max_val + y_padding]);
            end

        end


    end




    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, int_mod, inclusion)

            center_figure(app, app.UIFigure)

            app.source = int_mod;
            app.spot = app.source.selected_spot;
            app.spot_indices = app.source.active_spot_indices;
            
            % always take the raw rows from the session, never app.source.active_spot:
            % that one is background-subtracted while "Plot background corrected" is ticked
            if strcmp(app.source.base.project.session.config.datatype, 'Continuous')
                app.current_spot_to_plot = app.source.base.project.session.spot.signal_data(app.spot_indices, :);
            else
                app.current_spot_to_plot = app.source.base.project.session.spot.signal_data{app.spot};
            end

            app.inclusion = inclusion;


            if app.inclusion == true
                % consider only inclusion data

                if isnan(app.source.base.project.session.spot.inclusion_1_starts(app.spot)) || isnan(app.source.base.project.session.spot.inclusion_1_ends(app.spot))

                    message = "Set inclusion interval first";
                    uialert(app.UIFigure,message,"Warning", ...
                        "Icon","warning");
                    return

                end
            end

            find_and_correct_spikes(app);
            update_spike_plot(app);
        end

        % Button pushed function: AcceptButton
        function AcceptButtonPushed(app, event)
            if app.current_spike_index > 0 && app.current_spike_index <= height(app.eliminated_spikes)
                app.current_spike_index = app.current_spike_index + 1;

                % Check if we've processed all spikes
                if app.current_spike_index > height(app.eliminated_spikes)
                    app.current_spike_index = 0;
                    uialert(app.UIFigure, "All spikes have been processed.", "Info", "Icon", "info");
                else
                    update_spike_plot(app);
                end
            end
        end

        % Button pushed function: IgnoreButton
        function IgnoreButtonPushed(app, event)
            if app.current_spike_index > 0 && app.current_spike_index <= height(app.eliminated_spikes)

                current_spike = app.eliminated_spikes(app.current_spike_index, :);

                % Restore original value in corrected_data
                app.corrected_data{current_spike.RowIndex, current_spike.ColumnIndex} = current_spike.OriginalValue;

                % Remove the spike from the tracking table
                app.eliminated_spikes(app.current_spike_index, :) = [];

                % Don't increment the index - the next spike is now at the current position
                % Check if we're at the end
                if app.current_spike_index > height(app.eliminated_spikes)
                    if height(app.eliminated_spikes) > 0
                        % Go to the last spike
                        app.current_spike_index = height(app.eliminated_spikes);
                    else
                        % No more spikes
                        app.current_spike_index = 0;
                        uialert(app.UIFigure, "All spikes have been processed.", "Info", "Icon", "info");
                        return;
                    end
                end

                update_spike_plot(app);
            end
        end

        % Button pushed function: FinishButton
        function FinishButtonPushed(app, event)

            changes = check_changes(app.source, 'interval', app.UIFigure);
            if changes == false
                return
            end

            % Check if there are remaining spikes that haven't been reviewed
            if app.current_spike_index > 0 && app.current_spike_index <= height(app.eliminated_spikes)
                remaining_spikes = height(app.eliminated_spikes) - app.current_spike_index + 1;

                % Ask user what to do with remaining spikes
                selection = uiconfirm(app.UIFigure, ...
                    sprintf('There are %d remaining spike(s). What would you like to do?', remaining_spikes), ...
                    'Remaining Spikes', ...
                    'Options', {'Accept All', 'Ignore All', 'Cancel'}, ...
                    'DefaultOption', 1, ...
                    'CancelOption', 3, ...
                    'Icon', 'question');

                switch selection
                    case 'Accept All'
                        % Do nothing - spikes are already in eliminated_spikes and corrected_data

                    case 'Ignore All'
                        % Restore original values for all remaining spikes
                        for i = app.current_spike_index:height(app.eliminated_spikes)
                            spike = app.eliminated_spikes(i, :);
                            app.corrected_data{spike.RowIndex, spike.ColumnIndex} = spike.OriginalValue;
                        end
                        % Remove remaining spikes from the table
                        app.eliminated_spikes(app.current_spike_index:end, :) = [];

                    case 'Cancel'
                        % User cancelled - don't finish
                        return;
                end
            end

            % Ensure the storage for eliminated spikes exists
            % Ensure the storage for eliminated spikes exists
            if ~isfield(app.source.base.project.session.spot, 'eliminated_spikes')
                app.source.base.project.session.spot.eliminated_spikes = cell(size(app.source.base.project.session.spot.name));
            end

            if app.inclusion == false
                if strcmp(app.source.base.project.session.config.datatype, 'Continuous')
                    % Store results
                    app.source.base.project.session.spot.signal_data(app.spot_indices, 2:end) = app.corrected_data;
                    app.source.base.project.session.spot.eliminated_spikes{app.spot} = [app.source.base.project.session.spot.eliminated_spikes{app.spot}; app.eliminated_spikes];

                elseif strcmp(app.source.base.project.session.config.datatype, 'Single')
                    % Store results
                    app.source.base.project.session.spot.signal_data{app.spot}(:,2:end) = app.corrected_data;
                    app.source.base.project.session.spot.eliminated_spikes{app.spot} = [app.source.base.project.session.spot.eliminated_spikes{app.spot}; app.eliminated_spikes];
                end

            elseif app.inclusion == true
                inc_start = app.source.base.project.session.spot.inclusion_1_starts(app.spot);
                inc_end   = app.source.base.project.session.spot.inclusion_1_ends(app.spot);

                if strcmp(app.source.base.project.session.config.datatype, 'Continuous')
                    % Store results
                    app.source.base.project.session.spot.signal_data(inc_start:inc_end, 2:end) = app.corrected_data;
                    % SweepIndex is already correct, no offset needed
                    app.source.base.project.session.spot.eliminated_spikes{app.spot} = [app.source.base.project.session.spot.eliminated_spikes{app.spot}; app.eliminated_spikes];

                elseif strcmp(app.source.base.project.session.config.datatype, 'Single')
                    % Store results
                    app.source.base.project.session.spot.signal_data{app.spot}(inc_start:inc_end, 2:end) = app.corrected_data;
                    % SweepIndex is already correct, no offset needed
                    app.source.base.project.session.spot.eliminated_spikes{app.spot} = [app.source.base.project.session.spot.eliminated_spikes{app.spot}; app.eliminated_spikes];
                end

            end

            update_Interval_Module_GUI(app.source)
            delete(app)

        end

        % Value changed function: LogscaleCheckBox
        function LogscaleCheckBoxValueChanged(app, event)
           update_spike_plot(app)
        end

        % Value changed function: EditField
        function EditFieldValueChanged(app, event)
            if app.current_spike_index > 0
                % Get the new value from the edit field
                new_value = app.EditField.Value;

                % Validate that it's a positive number
                if isnan(new_value) || new_value < 0
                    uialert(app.UIFigure, "Please enter a valid positive number.", "Invalid Input", "Icon", "warning");
                    % Reset to current corrected value
                    current_spike = app.eliminated_spikes(app.current_spike_index, :);
                    app.EditField.Value = app.corrected_data{current_spike.RowIndex, current_spike.ColumnIndex};
                    return;
                end

                % Update the corrected data with the new value
                current_spike = app.eliminated_spikes(app.current_spike_index, :);
                app.corrected_data{current_spike.RowIndex, current_spike.ColumnIndex} = new_value;

                % Update the eliminated_spikes table with the new replacement value
                app.eliminated_spikes.ReplacementValue(app.current_spike_index) = new_value;

                % Refresh the plot to show the new corrected value
                update_spike_plot(app);
            end

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Icon = 'icon_48.png';
            app.UIFigure.Tag = 'spike_submodule';

            % Create SpikeAxes
            app.SpikeAxes = uiaxes(app.UIFigure);
            title(app.SpikeAxes, 'Title')
            xlabel(app.SpikeAxes, 'Sweeps')
            ylabel(app.SpikeAxes, 'Intensity [cps]')
            zlabel(app.SpikeAxes, 'Z')
            app.SpikeAxes.Colormap = zeros(0,3);
            app.SpikeAxes.MinorGridLineStyle = '-';
            app.SpikeAxes.YGrid = 'on';
            app.SpikeAxes.YMinorGrid = 'on';
            app.SpikeAxes.FontSize = 12;
            app.SpikeAxes.GridAlpha = 0.15;
            app.SpikeAxes.Box = 'on';
            app.SpikeAxes.Position = [27 59 580 404];

            % Create IgnoreButton
            app.IgnoreButton = uibutton(app.UIFigure, 'push');
            app.IgnoreButton.ButtonPushedFcn = createCallbackFcn(app, @IgnoreButtonPushed, true);
            app.IgnoreButton.Position = [445 12 101 29];
            app.IgnoreButton.Text = 'Ignore';

            % Create AcceptButton
            app.AcceptButton = uibutton(app.UIFigure, 'push');
            app.AcceptButton.ButtonPushedFcn = createCallbackFcn(app, @AcceptButtonPushed, true);
            app.AcceptButton.Position = [321 12 117 29];
            app.AcceptButton.Text = 'Accept';

            % Create FinishButton
            app.FinishButton = uibutton(app.UIFigure, 'push');
            app.FinishButton.ButtonPushedFcn = createCallbackFcn(app, @FinishButtonPushed, true);
            app.FinishButton.Position = [577 12 45 29];
            app.FinishButton.Text = 'Finish';

            % Create LogscaleCheckBox
            app.LogscaleCheckBox = uicheckbox(app.UIFigure);
            app.LogscaleCheckBox.ValueChangedFcn = createCallbackFcn(app, @LogscaleCheckBoxValueChanged, true);
            app.LogscaleCheckBox.Text = 'Log-scale';
            app.LogscaleCheckBox.Position = [12 12 74 29];
            app.LogscaleCheckBox.Value = true;

            % Create EditField
            app.EditField = uieditfield(app.UIFigure, 'numeric');
            app.EditField.Limits = [0 Inf];
            app.EditField.ValueDisplayFormat = '%.1f';
            app.EditField.ValueChangedFcn = createCallbackFcn(app, @EditFieldValueChanged, true);
            app.EditField.Position = [198 12 95 29];

            % Create PressEnterafterenteringthenumbertoviewcustomvalueLabel
            app.PressEnterafterenteringthenumbertoviewcustomvalueLabel = uilabel(app.UIFigure);
            app.PressEnterafterenteringthenumbertoviewcustomvalueLabel.HorizontalAlignment = 'center';
            app.PressEnterafterenteringthenumbertoviewcustomvalueLabel.WordWrap = 'on';
            app.PressEnterafterenteringthenumbertoviewcustomvalueLabel.FontSize = 10;
            app.PressEnterafterenteringthenumbertoviewcustomvalueLabel.Position = [103 12 86 44];
            app.PressEnterafterenteringthenumbertoviewcustomvalueLabel.Text = 'Press "Enter" after entering the number to view custom value';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Spike_Submodule_readable(varargin)

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