% GENERATED from Import_Module.mlapp on 2026-10-28 14:17 by export_mlapp_to_m. This file is for reading purposes, any real changes need to be applied to the .mlapp files and exported again.
classdef Import_Module_readable < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        BaseMenu                        matlab.ui.container.Menu
        ExitMenu                        matlab.ui.container.Menu
        SettingsMenu                    matlab.ui.container.Menu
        DDMMformatcheckMenu             matlab.ui.container.Menu
        GridLayout2                     matlab.ui.container.GridLayout
        ProgressPanel                   matlab.ui.container.Panel
        ResultsButton                   matlab.ui.control.Button
        QuantificationButton            matlab.ui.control.Button
        DriftButton                     matlab.ui.control.Button
        ClassificationButton            matlab.ui.control.Button
        ImportButton                    matlab.ui.control.Button
        IntervalButton                  matlab.ui.control.Button
        TabGroup                        matlab.ui.container.TabGroup
        GeneralImportTab                matlab.ui.container.Tab
        ContinuousPanel                 matlab.ui.container.Panel
        ContinuousPlotElementsListBox   matlab.ui.control.ListBox
        LogScaleCheckBox                matlab.ui.control.CheckBox
        PlotSignalRangesCheckBox        matlab.ui.control.CheckBox
        ShowSpotnamesCheckBox           matlab.ui.control.CheckBox
        globalsignalindentEditField     matlab.ui.control.NumericEditField
        DetectSignalsButton             matlab.ui.control.Button
        ProceedinMatrixModeButton       matlab.ui.control.Button
        ProceedinInclusionModeButton    matlab.ui.control.Button
        andpressenterkeyLabel           matlab.ui.control.Label
        orenterglobalindentLabel        matlab.ui.control.Label
        ContinuousPlot                  matlab.ui.control.UIAxes
        SinglePanel                     matlab.ui.container.Panel
        ShowAcquisitionTimesButton      matlab.ui.control.Button
        DetectionthresholdEditField     matlab.ui.control.NumericEditField
        DetectionthresholdEditFieldLabel  matlab.ui.control.Label
        ProceedinInclusionModeButton_Single  matlab.ui.control.Button
        ProceedinMatrixModeButton_Single  matlab.ui.control.Button
        DetectSingleSignalsButton       matlab.ui.control.Button
        SingleSpotsListBox              matlab.ui.control.ListBox
        NextButton                      matlab.ui.control.Button
        PreviousButton                  matlab.ui.control.Button
        SingleSpotAxes                  matlab.ui.control.UIAxes
        ChooseMassSpecDropDown          matlab.ui.control.DropDown
        GetSignalFilesButton            matlab.ui.control.Button
        SignalFileEditField             matlab.ui.control.EditField
        ShowLaserMetadataButton         matlab.ui.control.Button
        ChooseLaserDropDown             matlab.ui.control.DropDown
        GetLaserMetadataButton          matlab.ui.control.Button
        LaserMetadataFileEditField      matlab.ui.control.EditField
        ShowMassSpecMetadataButton      matlab.ui.control.Button
        ChooseMassSpecMetadataDropDown  matlab.ui.control.DropDown
        GetMassSpecMetadataButton       matlab.ui.control.Button
        MassSpecMetadataEditField       matlab.ui.control.EditField
        ManualSelectionTab              matlab.ui.container.Tab
        ManualSelectionPanel            matlab.ui.container.Panel
        SpotnameEditField               matlab.ui.control.EditField
        SpotnameEditFieldLabel          matlab.ui.control.Label
        ManSelElementListBox            matlab.ui.control.ListBox
        AssignButton                    matlab.ui.control.Button
        DrawRectangleButton             matlab.ui.control.Button
        ProceedinInclusionModeButton_2  matlab.ui.control.Button
        ProceedinMatrixModeButton_2     matlab.ui.control.Button
        ResetallButton                  matlab.ui.control.Button
        RemovelastButton                matlab.ui.control.Button
        ManualSelectionAxes             matlab.ui.control.UIAxes
        ContextMenu                     matlab.ui.container.ContextMenu
        MovingaveragesettingsMenu       matlab.ui.container.Menu
        ContextMenu2                    matlab.ui.container.ContextMenu
        DeleteRectangleMenu             matlab.ui.container.Menu
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
        % General variables
        project_id
        session_id
    
    end

    properties (Access = private)
        
        
        selected_analytes

        selected_spot

        % for manual selection
        selected_analytes_man_sel
        signal_start_end
        rectangle

        %
        global_signal_indent

        %
        editstatus
    end


    methods (Access = private)
        % general functions

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

        function updateLogfileInformations(app, src, event)

            changes = check_changes(app, 'import', ancestor(src, 'figure'));
            if changes == false
                return
            end
            app.editstatus = true;

            % Get the edited data
            newData = src.Data;

            % Update the spotnames in the data structure
            app.base.project.session.spot.name = newData.Spotname;

        end

        function updateAcqTimesInformations(app, src, event)
            changes = check_changes(app, 'import', ancestor(src, 'figure'));
            if changes == false
                return
            end
            app.editstatus = true;

            % Get the edited data
            newData = src.Data;

            acquisitiontimes = newData.Acquisition_Time;
            timePattern = '^([01]?[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$';

            invalidIndices = [];
            for i = 1:length(acquisitiontimes)
                timeStr = string(acquisitiontimes(i));
                if ~isempty(timeStr) && isempty(regexp(timeStr, timePattern, 'once'))
                    invalidIndices = [invalidIndices, i];
                end
            end

            if ~isempty(invalidIndices)
                % revert to the currently stored times
                if isfield(app.base.project.session.spot, 'acquisition_datetime')
                    dt = datetime(app.base.project.session.spot.acquisition_datetime, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
                    src.Data.Acquisition_Time = string(dt, 'HH:mm:ss');
                else
                    src.Data.Acquisition_Time = app.base.project.session.spot.acquisition_time;
                end
                return
            end

            % write back, preserving each spot's existing date
            if isfield(app.base.project.session.spot, 'acquisition_datetime')
                dt = datetime(app.base.project.session.spot.acquisition_datetime, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
                datePart = string(dt, 'yyyy-MM-dd');
                app.base.project.session.spot.acquisition_datetime = datePart + " " + string(newData.Acquisition_Time);
            else
                app.base.project.session.spot.acquisition_time = string(newData.Acquisition_Time);
            end

        end


        % Helper function to merge two structs
        function combinedStruct = mergeStructs(app, struct1, struct2)
            combinedStruct = struct1;
            fieldsStruct2 = fieldnames(struct2);
            for i = 1:numel(fieldsStruct2)
                combinedStruct.(fieldsStruct2{i}) = struct2.(fieldsStruct2{i});
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



        %%%%%%%%%%% Continuous Signals %%%%%%%%%%


        function update_continuous_plot(app)
            cla(app.ContinuousPlot)

            x_signal = 1:length(table2array(app.base.project.session.spot.signal_data(:, 1))); %table2array(app.base.project.session.spot.signal_data(:, 1));
            y_signal = table2array(app.base.project.session.spot.signal_data(:, 2:end));

            %% plot the main plot
            x = x_signal;

            % if selected_analytes is empty, e.g. at initializing the plot
            % it will plot all analytes
            if isempty(app.selected_analytes)
                y = sum(y_signal, 2); %y_signal;
            else
                y = table2array(app.base.project.session.spot.signal_data(:, app.selected_analytes));
            end

            plot(app.ContinuousPlot,x ,y ,'LineWidth',1)

            % Set the y-axis to logarithmic scale
            %set(app.ContinuousPlot, 'YScale', 'log');

            if app.LogScaleCheckBox.Value
                set(app.ContinuousPlot, 'YScale', 'log');
            else
                set(app.ContinuousPlot, 'YScale', 'linear');
            end

            % This plots always the ends with the grey areas in between
            % When the signals are detected, plot them
            if app.PlotSignalRangesCheckBox.Value && isfield(app.base.project.session, 'spot') && isfield(app.base.project.session.spot, 'signal_starts') && isfield(app.base.project.session.spot, 'signal_ends')

                hold(app.ContinuousPlot, 'on')

                y_signal_nonzero = y(y ~= 0);
                y_min = min(y_signal_nonzero);
                y_max = max(y(:));

                % Calculate average length of signal_end to signal_end intervals
                signal_starts = app.base.project.session.spot.signal_starts;
                signal_ends = app.base.project.session.spot.signal_ends;
                if numel(signal_ends) > 1
                    avg_interval = mean(diff(signal_ends));
                else
                    avg_interval = 0;
                end

                % Plot grey areas and lines
                for i = 1:numel(signal_ends)
                    if i == 1
                        % For the first interval, use the average length
                        start_idx = max(1, signal_ends(i) - round(avg_interval));
                    else
                        start_idx = signal_ends(i-1);
                    end
                    end_idx = signal_ends(i);

                    if start_idx >= 1 && start_idx <= numel(x) && end_idx >= 1 && end_idx <= numel(x)
                        % Alternate between lighter and slightly darker grey
                        if mod(i, 2) == 0
                            grey_color = [0.6, 0.6, 0.6];
                        else
                            grey_color = [0.8, 0.8, 0.8];
                        end

                        % Fill the area between the lines with transparency
                        fill(app.ContinuousPlot, [x(start_idx), x(start_idx), x(end_idx), x(end_idx)], [y_min, y_max, y_max, y_min], ...
                            grey_color, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
                    end

                    % Draw the lines
                    line(app.ContinuousPlot, [x(signal_starts(i)), x(signal_starts(i))], [y_min, y_max], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1);
                    line(app.ContinuousPlot, [x(end_idx), x(end_idx)], [y_min, y_max], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1);

                    %% plot the names if the checkbox is checked
                    if app.ShowSpotnamesCheckBox.Value
                        % Add spot name text in the top left corner of the area
                        if isfield(app.base.project.session.spot, 'name') && i <= numel(app.base.project.session.spot.name)
                            spotname = app.base.project.session.spot.name(i);
                            text(app.ContinuousPlot, x(start_idx)+5, y_max, spotname, 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left', 'FontSize', 10, 'Color', 'k', 'Interpreter', 'none');
                        end
                    end

                end

                hold(app.ContinuousPlot, 'off')

            end


        end



        function [signal_starts, signal_ends, cleaningshot_starts, cleaningshot_ends] = detect_signals(app, fullsignal_raw, num_spots)

            progress = uiprogressdlg(app.UIFigure, 'Title', 'Detecting signals...', ...
                'Message', 'Using bisection method', 'Cancelable', 'off', 'Indeterminate','on');

            % Extracting information out of the raw data
            fullsignal_processed = fullsignal_raw;
            fullsignal_processed.totalcounts = sum(table2array(fullsignal_raw(:,2:end)), 2, 'omitnan');

            % Normalizing the totalcounts
            min_totalcounts = min(fullsignal_processed.totalcounts);
            max_totalcounts = max(fullsignal_processed.totalcounts);

            % Bisection method to find the optimal threshold
            threshold_low = 0;
            threshold_high = 1;
            tolerance = 1e-9;

            while (threshold_high - threshold_low) > tolerance
                threshold_mid = (threshold_low + threshold_high) / 2;
                [signal_starts, signal_ends, cleaningshot_starts, cleaningshot_ends] = classify_signals(threshold_mid, fullsignal_processed, min_totalcounts, max_totalcounts);

                if length(signal_starts) == num_spots && length(signal_ends) == num_spots
                    break;
                elseif length(signal_starts) < num_spots
                    threshold_high = threshold_mid;
                else
                    threshold_low = threshold_mid;
                end
            end

            % Final classification with the optimal threshold
            optimal_threshold = threshold_mid;
            [signal_starts, signal_ends, cleaningshot_starts, cleaningshot_ends] = classify_signals(optimal_threshold, fullsignal_processed, min_totalcounts, max_totalcounts);

            % Function to classify data points and count signal starts and ends
            function [signal_starts, signal_ends, cleaningshot_starts, cleaningshot_ends] = classify_signals(threshold, fullsignal_processed, min_totalcounts, max_totalcounts)
                fullsignal_processed.normalized_totalcounts = (fullsignal_processed.totalcounts - min_totalcounts) / (max_totalcounts - min_totalcounts);
                fullsignal_processed.classification = zeros(height(fullsignal_processed), 1); % Initialize the classification column
                fullsignal_processed.classification(fullsignal_processed.normalized_totalcounts >= threshold) = 1;

                % Clear out single spikes
                logicalArray = fullsignal_processed.classification;
                logicalArray = reshape(logicalArray, 1, []);
                charArray = num2str(logicalArray);
                charArray = strrep(charArray, ' ', '');
                pattern_spike = '0{1}1{1}0{1}';
                spikes = (regexp(charArray, pattern_spike))+1;

                for o = spikes
                    fullsignal_processed.classification(o) = 0;
                    fullsignal_processed.normalized_totalcounts(o) = fullsignal_processed.normalized_totalcounts(o+1);
                end

                % Find where the signals start and end
                starts = find(diff(fullsignal_processed.classification == 1) == 1);
                ends = find(diff(fullsignal_processed.classification == 1) == -1);

                % Filter the ends of the signals
                signal_starts = [];
                signal_ends = [];
                cleaningshot_starts = [];
                cleaningshot_ends = [];

                lengths = ends - starts;

                for i = 1:length(ends)
                    if ends(i) - starts(i) > mean(lengths)
                        signal_starts = [signal_starts; starts(i)];
                        signal_ends = [signal_ends; ends(i)];
                    else
                        cleaningshot_starts = [cleaningshot_starts; starts(i)];
                        cleaningshot_ends = [cleaningshot_ends; ends(i)];
                    end
                end
            end

            delete(progress)

        end

        function [signal_starts, signal_ends] = detect_signals_via_time(app)

            progress = uiprogressdlg(app.UIFigure, 'Title', 'Detecting signals...', ...
                'Message', 'Using time from laser logfile', 'Cancelable', 'off', 'Indeterminate','on');

            fullsignal_raw = app.base.project.session.spot.signal_data;
            laser_start_times =   app.base.project.session.meta.laser_parameters.laser_start_times;
            laser_stop_times = app.base.project.session.meta.laser_parameters.laser_stop_times;


            % Initialize output arrays
            signal_starts = zeros(size(laser_start_times));
            signal_ends = zeros(size(laser_stop_times));

            % Get time column from data (in seconds)
            time_array = table2array(fullsignal_raw(:,1));

            % Convert cell array of datetime strings to datetime array
            start_times = datetime(laser_start_times);
            stop_times = datetime(laser_stop_times);

            % Convert to seconds since start of measurement
            t0 = start_times(1);
            start_secs = seconds(start_times - t0);
            stop_secs = seconds(stop_times - t0);

            % Handle global signal indent
            if ~isempty(app.global_signal_indent) && app.global_signal_indent > 0
                indent = app.global_signal_indent;
            else
                indent = 1;
            end

            % Find corresponding indices for each laser start/stop time
            % Find corresponding indices for each laser start/stop time
            for i = 1:length(start_secs)
                % Find closest time index and apply indent
                [~, start_idx] = min(abs(time_array - start_secs(i)));
                [~, end_idx] = min(abs(time_array - stop_secs(i)));

                % Apply the indent to both start and end indices
                signal_starts(i) = start_idx + indent;
                signal_ends(i) = end_idx + indent;
            end
            delete(progress)
        end


        %%%%%%%%%%% Single Signals %%%%%%%%%%


        function update_single_spot_plot(app)
            cla(app.SingleSpotAxes)

            % here check which spot is selected
            if isempty(app.selected_spot)
                app.selected_spot = 1;
            end

            spot_to_plot = app.base.project.session.spot.signal_data{app.selected_spot};

            %% plot the main plot
            % Att this x_default has to change if single signals are input
            x_default = 1:height(spot_to_plot);
            y_default = table2array(spot_to_plot(:, 2:end)); %

            plot(app.SingleSpotAxes, x_default, y_default)

            set(app.SingleSpotAxes, 'YScale', 'log')
            xlim(app.SingleSpotAxes, [1, height(spot_to_plot)])
            title(app.SingleSpotAxes, app.base.project.session.spot.name(app.selected_spot), 'Interpreter', 'none');

            % Add vertical lines for signal_starts and signal_ends
            signal_starts = app.base.project.session.spot.signal_starts(app.selected_spot);
            signal_ends = app.base.project.session.spot.signal_ends(app.selected_spot);

            hold(app.SingleSpotAxes, 'on')
            for i = 1:length(signal_starts)
                xline(app.SingleSpotAxes, signal_starts(i), 'g-.', 'LineWidth', 2);
            end
            for i = 1:length(signal_ends)
                xline(app.SingleSpotAxes, signal_ends(i), 'r-.', 'LineWidth', 2);
            end
            hold(app.SingleSpotAxes, 'off')

        end


        function [signal_starts, signal_ends]  = detect_single_spot_signal_starts_ends(app, single_spot)

            %%extracting informations out of the raw data

            single_spot.totalcounts = sum(table2array(single_spot(:,2:end)),2,'omitnan');
            single_spot.index = (1:height(single_spot))';

            % define the background and the signal --> signal = 1, background = 0

            % Min-Max Normalization
            min_val = min(single_spot.totalcounts);
            max_val = max(single_spot.totalcounts);
            single_spot.normalized_counts = (single_spot.totalcounts - min_val) / (max_val - min_val);

            % Classify the data points where the normalized counts are less than a threshold as background
            threshold = app.DetectionthresholdEditField.Value; %0.010; % Adjust the threshold as needed
            single_spot.classification(single_spot.normalized_counts < threshold) = 0;
            single_spot.classification(single_spot.normalized_counts >= threshold) = 1;

            % Detect signal starts and ends
            starts = find(diff([0; single_spot.classification]) == 1);
            ends = find(diff([single_spot.classification; 0]) == -1);

            % Select the appropriate start and end indices
            if isempty(starts) || isempty(ends)
                signal_starts = [];
                signal_ends = [];
            elseif starts == ends

                signal_starts = max(1, round(height(single_spot)/3));
                signal_ends = height(single_spot);

            elseif isequal(starts, 1) && isequal(ends, height(single_spot)-1)

                signal_starts = max(1, round(height(single_spot)/3));
                signal_ends = height(single_spot);


            else
                signal_starts = min(starts);
                signal_ends = max(ends(ends > signal_starts));
            end

        end



        %%%%%%%%%%% Tab Manual Selection %%%%%%%%%%

        function update_manual_selection_axes(app)

            cla(app.ManualSelectionAxes)

            x_signal = 1:height(app.base.project.session.spot.signal_data);
            y_signal = table2array(app.base.project.session.spot.signal_data(:, 2:end));

            x = x_signal;

            % Check if 'Total Counts' is selected (ItemsData == 0)
            if isempty(app.selected_analytes_man_sel) || isequal(app.selected_analytes_man_sel,0)
                y = sum(y_signal, 2);
            else
                y = y_signal(:, app.selected_analytes_man_sel);
            end

            plot(app.ManualSelectionAxes, x, y, 'LineWidth', 1);
            set(app.ManualSelectionAxes, 'YScale', 'log');


            % Plot vertical lines for signal starts and ends, and spot names
            if isfield(app.base.project.session.spot, 'signal_starts') && ...
                    isfield(app.base.project.session.spot, 'signal_ends') && ...
                    isfield(app.base.project.session.spot, 'name')

                starts = app.base.project.session.spot.signal_starts;
                ends = app.base.project.session.spot.signal_ends;
                names = app.base.project.session.spot.name;

                for i = 1:numel(starts)
                    xline(app.ManualSelectionAxes, starts(i), '--g', 'LineWidth', 1); % green dashed for start
                    xline(app.ManualSelectionAxes, ends(i), '--r', 'LineWidth', 1);   % red dashed for end

                    % Place the spot name between the lines, at the top of the axes
                    mid_x = (starts(i) + ends(i)) / 2;
                    y_max = max(y)*0.95;
                    text(app.ManualSelectionAxes, mid_x, y_max, names(i), ...
                        'HorizontalAlignment', 'center', ...
                        'VerticalAlignment', 'bottom', ...
                        'FontSize', 10, 'Color', [0 0 0], 'Interpreter', 'none');
                end
            end


        end

        function draw_rectangle(app)

            % Draw a rectangle on the plot
            app.rectangle = drawrectangle(app.ManualSelectionAxes, 'Color', [0.5 0.5 0.5], 'LineWidth', 0.5);

            % Get the position and limints of the rectangle
            pos = app.rectangle.Position;
            app.signal_start_end = round([pos(1), pos(1) + pos(3)]);

        end

        function store_signal_start_end(app)

            % Get current spot name and signal start/end
            spot_name = app.SpotnameEditField.Value;
            if isempty(spot_name)
                return
            end
            signal_start = app.signal_start_end(1);
            signal_end = app.signal_start_end(2);

            % Append to spot.name
            if isfield(app.base.project.session.spot, 'name') && ~isempty(app.base.project.session.spot.name)
                app.base.project.session.spot.name(end+1,1) = string(spot_name);
            else
                app.base.project.session.spot.name = string(spot_name);
            end

            % Append to spot.signal_starts
            if isfield(app.base.project.session.spot, 'signal_starts') && ~isempty(app.base.project.session.spot.signal_starts)
                app.base.project.session.spot.signal_starts(end+1,1) = signal_start;
            else
                app.base.project.session.spot.signal_starts = signal_start;
            end

            % Append to spot.signal_ends
            if isfield(app.base.project.session.spot, 'signal_ends') && ~isempty(app.base.project.session.spot.signal_ends)
                app.base.project.session.spot.signal_ends(end+1,1) = signal_end;
            else
                app.base.project.session.spot.signal_ends = signal_end;
            end

            delete(app.rectangle)
           % app.signal_start_end = [];

        end



    end


    methods (Access = public)

        function update_progress_buttons(app)

            status = app.base.project.session.config.module_status;

            green = [204/255, 1, 204/255];
            orange = [1, 229/255, 204/255];
            red = [1, 204/255, 204/255];

            app.ImportButton.Enable = "off";
            app.ImportButton.BackgroundColor = orange; % orange because this is the active module

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

        function refresh_panels_after_reset(app)

            if isempty(app.base)
                return
            end

            session_config = app.base.project.session.config;

            if isfield(session_config, 'datatype') && isequal(session_config.datatype, 'Continuous')

                app.SinglePanel.Visible          = false;
                app.ContinuousPanel.Visible      = true;
                app.ManualSelectionPanel.Visible = true;
                update_continuous_panel(app)
                update_manual_selection_panel(app)

            elseif isfield(session_config, 'datatype') && isequal(session_config.datatype, 'Single')

                app.SinglePanel.Visible     = true;
                app.ContinuousPanel.Visible = false;
                update_single_panel(app)
            end
        end

        function update_continuous_panel(app)

            % Interactive plots
            if isfield(app.base.project.session.spot, 'signal_data')

                el_names = app.base.project.session.spot.signal_data(:, 2:end).Properties.VariableNames; %read out the names of the analytes from each signal
                app.ContinuousPlotElementsListBox.Items = el_names; %fills up the analytes_listbox with the names
                app.ContinuousPlotElementsListBox.ItemsData=2:numel(el_names);

                update_continuous_plot(app)

            end

            if isfield(app.base.project.session.spot, 'signal_data')
                app.SignalFileEditField.Value = app.base.project.session.config.signal_path;
            end

            if isfield(app.base.project.session.config, 'laser_metadata_path')
                app.LaserMetadataFileEditField.Value = app.base.project.session.config.laser_metadata_path;
                app.ShowLaserMetadataButton.Enable = 'on';
            end

            if isfield(app.base.project.session.config, 'mass_spec_metadata_path')
                app.MassSpecMetadataEditField.Value = app.base.project.session.config.mass_spec_metadata_path;
                app.ShowMassSpecMetadataButton.Enable = 'on';
            end

        end

        function update_single_panel(app)

            % here populate the spotname listbox
            app.SingleSpotsListBox.Items = app.base.project.session.spot.name;
            app.SingleSpotsListBox.ItemsData = 1:numel(app.base.project.session.spot.name);

            update_single_spot_plot(app)

            if isfield(app.base.project.session.spot, 'signal_data')
                app.SignalFileEditField.Value = app.base.project.session.config.signal_path;
            end

            if isfield(app.base.project.session.config, 'laser_metadata_path')
                app.LaserMetadataFileEditField.Value = app.base.project.session.config.laser_metadata_path;
                app.ShowLaserMetadataButton.Enable = 'on';
            end

            if isfield(app.base.project.session.config, 'mass_spec_metadata_path')
                app.MassSpecMetadataEditField.Value = app.base.project.session.config.mass_spec_metadata_path;
                app.ShowMassSpecMetadataButton.Enable = 'on';
            end

        end

        function update_manual_selection_panel(app)
            el_names = app.base.project.session.spot.signal_data(:, 2:end).Properties.VariableNames;
            % Add 'Total Counts' as the first entry
            app.ManSelElementListBox.Items = ['Total Counts', el_names];
            % ItemsData: 0 for 'Total Counts', 1:numel(el_names) for analytes
            app.ManSelElementListBox.ItemsData = [0, 1:numel(el_names)];

            update_manual_selection_axes(app)

        end

        function proceed_to_interval(app, selected_reductiontype, ask_to_proceed)

            if nargin < 3
                ask_to_proceed = true;
            end

            if ~isfield(app.base.project.session, 'spot')
                message = "No data was imported";
                uialert(app.UIFigure,message,"Warning", ...
                    "Icon","warning");
                return
            elseif ~isfield(app.base.project.session.spot, 'signal_starts')
                message = "No signals were detected";
                uialert(app.UIFigure,message,"Warning", ...
                    "Icon","warning");
                return
            end


            % names, signal starts and ends must belong to the same spots
            n_names  = 0;
            if isfield(app.base.project.session.spot, 'name')
                n_names = numel(app.base.project.session.spot.name);
            end
            n_starts = numel(app.base.project.session.spot.signal_starts);
            n_ends   = numel(app.base.project.session.spot.signal_ends);

            if n_names ~= n_starts || n_starts ~= n_ends
                uialert(app.UIFigure, sprintf(['There are %d spot names but %d detected signals. ' ...
                    'Check the laser log, adjust the signal indent, or select the signals manually.'], n_names, n_starts), ...
                    'Signals Do Not Match', 'Icon', 'warning');
                return
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            if isfield(app.base.project.session.spot, 'acquisition_datetime') && ~isempty(app.base.project.session.spot.acquisition_datetime)
                dt = datetime(app.base.project.session.spot.acquisition_datetime, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
                if ~any(day(dt) > 12) && numel(unique(month(dt))) > 1
                    uialert(app.UIFigure, ...
                        ['The acquisition dates span more than one month, and the day/month order is ambiguous. ' ...
                        'This usually means the date format was read with the wrong day/month convention. ' ...
                        'Open the "DD/MM format check" in the "Settings" menu, swap day and month, then proceed.'], ...
                        'Check Acquisition Dates', 'Icon', 'warning');
                    return
                end
            end

            % Validate and clean analyte names (expected format: e.g. Na23, Li7, La139)
            analytes = app.base.project.session.spot.analytes;
            validPattern = '^[A-Za-z]{1,2}\d{1,3}$';
            nonConforming = ~arrayfun(@(a) ~isempty(regexp(a, validPattern, 'once')), analytes);

            if any(nonConforming)
                cleaned_analytes = analytes;
                failed = {};
                for k = 1:length(analytes)
                    if nonConforming(k)
                        match = regexp(analytes(k), '[A-Za-z]{1,2}\d{1,3}', 'match', 'once');
                        if strlength(match) > 0
                            cleaned_analytes(k) = string(match);
                        else
                            failed{end+1} = analytes(k);
                        end
                    end
                end

                if ~isempty(failed)
                    message = sprintf('The following analytes could not be parsed to a valid name (expected e.g. Na23, Li7, La139):\n%s', strjoin(failed, ', '));
                    uialert(app.UIFigure, message, "Warning", "Icon", "warning");
                    return
                end

                selection = uiconfirm(app.UIFigure, ...
                    "Some analyte names contain extra characters and will be cleaned to the format e.g. Na23, Li7, La139. Proceed?", ...
                    "ICP-Base", "Options", ["Proceed", "Cancel"], "DefaultOption", 1, "CancelOption", 2);
                if strcmp(selection, 'Cancel')
                    return
                end

                app.base.project.session.spot.analytes = string(cleaned_analytes);

                if strcmp(app.base.project.session.config.datatype, 'Single')
                    for k = 1:length(app.base.project.session.spot.signal_data)
                        tbl = app.base.project.session.spot.signal_data{k};
                        new_names = tbl.Properties.VariableNames;
                        new_names(2:end) = cellstr(cleaned_analytes');
                        tbl.Properties.VariableNames = new_names;
                        app.base.project.session.spot.signal_data{k} = tbl;
                    end
                else
                    tbl = app.base.project.session.spot.signal_data;
                    new_names = tbl.Properties.VariableNames;
                    new_names(2:end) = cellstr(cleaned_analytes');
                    tbl.Properties.VariableNames = new_names;
                    app.base.project.session.spot.signal_data = tbl;
                end

                if isfield(app.base.project.session.spot, 'dwelltimes') && ~isempty(fieldnames(app.base.project.session.spot.dwelltimes))
                    app.base.project.session.spot.dwelltimes.Properties.VariableNames = cellstr(cleaned_analytes');
                end
            end

            % the default dwelltimes are only written after the final Yes
            assume_default_dwelltimes = ~isfield(app.base.project.session.spot, 'dwelltimes');

            if assume_default_dwelltimes
                selection = uiconfirm(app.UIFigure, ...
                    "You did not import dwelltimes (Mass-Spec Metadata). ICP-Base assumes dwelltimes of 10 ms for all elements. You can adjust them manually in the Quantification Module.", ...
                    "ICP-Base", "Options", ["Proceed", "Cancel"], "DefaultOption", 1, "CancelOption", 2);
                if strcmp(selection, 'Cancel')
                    return
                end
            end

            try

                if ask_to_proceed
                    selection = uiconfirm(app.UIFigure, "Do you want to proceed", "ICP-Base", ...
                        "Options",["Yes","Cancel"], ...
                        "DefaultOption",1,"CancelOption",2);
                else
                    selection = 'Yes';
                end

                switch selection
                    case 'Yes'

                        % switching Matrix <-> Inclusion changes everything that Drift and Quantification calculate
                        if ~isempty(selected_reductiontype) && isfield(app.base.project.session.config, 'reductiontype') ...
                                && ~isequal(app.base.project.session.config.reductiontype, selected_reductiontype)
                            changes = check_changes(app, 'reductiontype');
                            if changes == false
                                return
                            end
                        end

                        if assume_default_dwelltimes
                            columns = numel(app.base.project.session.spot.analytes);
                            app.base.project.session.spot.dwelltimes = array2table(repmat(0.01, 1, columns), 'VariableNames', app.base.project.session.spot.analytes);
                        end

                        % write only what actually changes
                        session_config = app.base.project.session.config;
                        if ~isempty(selected_reductiontype) ...
                                && (~isfield(session_config, 'reductiontype') || ~isequal(session_config.reductiontype, selected_reductiontype))
                            app.base.project.session.config.reductiontype = selected_reductiontype;
                        end
                        if ~isfield(session_config, 'module_status') ...
                                || ~isfield(session_config.module_status, 'import') ...
                                || ~isequal(session_config.module_status.import, true)
                            app.base.project.session.config.module_status.import = true;
                        end

                        settings.ICP_Base_GUI_update_state = true;
                        [app.project_id, app.session_id] = save_to_base(app.sourceapp, app.project_id, app.base.project.session, app.session_id, app.base.project_name, settings);
                        Interval_Module(app.sourceapp, app.base.project_name, app.project_id, app.session_id)
                        delete(app)

                    case 'Cancel'
                        return
                end

            catch ME

                DisplayError(ME,'Proceeding failed')
                message = "Proceeding failed";
                uialert(app.UIFigure,message,"Warning", ...
                    "Icon","warning");

                return
            end

        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Signal Import %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%% Signal import functions %%%%%%%%%%%%%%%

        %%%% Agilent
        function [spotname, signal_data, time] = read_single_agilent_csv(app, signal_path)

            % Read the file content
            fileContent = fileread(signal_path);

            % Capture date, time, and optional AM/PM from the "Acquired :" line
            tok = regexp(fileContent, 'Acquired\s*:\s*(\S+)\s+(\d{1,2}:\d{2}:\d{2})\s*([AP]M)?', 'tokens', 'once');
            dateStr = tok{1};
            timeStr = tok{2};
            ampm    = tok{3};

            % --- date --- (handles 2026-04-30, 30-04-2026, 30/04/2026, 04/30/2026)
            nums = sscanf(regexprep(dateStr, '[-/]', ' '), '%d');   % the three numbers
            if nums(1) > 31
                % year first -> ISO yyyy-mm-dd
                yr = nums(1); mo = nums(2); dy = nums(3);
            else
                % year last -> first two are day/month, disambiguate
                A = nums(1); B = nums(2); yr = nums(3);
                if A > 12
                    dy = A; mo = B;        % D/M/Y
                elseif B > 12
                    mo = A; dy = B;        % M/D/Y
                else
                    dy = A; mo = B;        % ambiguous -> default D/M/Y
                end
            end

            % --- time (handle 12h AM/PM) ---
            tp = sscanf(timeStr, '%d:%d:%d');
            hh = tp(1); mn = tp(2); ss = tp(3);
            if strcmpi(ampm, 'PM') && hh < 12, hh = hh + 12; end
            if strcmpi(ampm, 'AM') && hh == 12, hh = 0;      end

            time = string(datetime(yr, mo, dy, hh, mn, ss), 'yyyy-MM-dd HH:mm:ss');

            opts = detectImportOptions(signal_path);
            opts.VariableNamesLine = 4;
            opts.DataLines = [5 Inf];
            signal_data = readtable(signal_path, opts);

            % Remove the last row if it contains NaN
            if any(isnan(signal_data{end, :}))
                signal_data(end, :) = [];
            end

            % Rename reaction cell columns: 'Na23__23' -> 'Na23', 'S32__48' -> 'S48'
            varNames = signal_data.Properties.VariableNames;
            for k = 1:length(varNames)
                varNames{k} = regexprep(varNames{k}, '^([A-Za-z]{1,2})\d+\D+(\d+)$', '$1$2');
            end
            signal_data.Properties.VariableNames = varNames;

            % Remove the .csv extension from the filename
            [~, spotname, ~] = fileparts(signal_path);

        end

        function [signal_data] = read_continuous_agilent_csv(app, signal_path)


            fid = fopen(signal_path, 'r'); % Open the file for reading

            for i = 1:3
                line = fgetl(fid);
            end

            headerLine = fgetl(fid);
            fclose(fid); % Close the file

            % Read the data starting from row 28
            opts = detectImportOptions(signal_path);
            opts.DataLines = [5 Inf]; % Start reading from row 31 to the end of the file
            signal_data = readtable(signal_path, opts);

                        % Split the header line into individual column headers
            columnHeaders = strsplit(headerLine, opts.Delimiter);
            columnHeaders = columnHeaders(~cellfun('isempty', columnHeaders));

            % Assign the extracted column headers to the data table
            signal_data.Properties.VariableNames = columnHeaders;

            % Rename reaction cell columns: 'Na23 -> 23' -> 'Na23', 'S32 -> 48' -> 'S48'
            varNames = signal_data.Properties.VariableNames;
            for k = 1:length(varNames)
                varNames{k} = regexprep(varNames{k}, '^([A-Za-z]{1,2})\d+\D+(\d+)$', '$1$2');
            end
            signal_data.Properties.VariableNames = varNames;

        end

        function [spotname, signal_data, time, icp_ms_parameters, dwelltimes] = read_agilent_batch_folder(app, mass_spec_metadata_path)

            progress = uiprogressdlg(app.UIFigure, 'Title', 'Import...', ...
                'Message', '1', 'Cancelable', 'off'); %, 'Indeterminate','on'

            % Initialize variables to store all data
            all_signal_data = {}; % Use a cell array to store signal_data from each iteration
            all_spotname = {};    % Store all spotnames
            all_time = {};        % Store all time values

            % Get a list of all subfolders in the .b folder
            subfolders = dir(fullfile(mass_spec_metadata_path, '*.d'));

            % Iterate through each .d folder
            for i = 1:length(subfolders)

                progress.Value = i / length(subfolders);

                if subfolders(i).isdir
                    % Construct the full path to the .d folder
                    dFolderPath = fullfile(mass_spec_metadata_path, subfolders(i).name);

                    progress.Message = sprintf('Importing - %s', subfolders(i).name);

                    % Find the .csv file in the .d folder
                    csvFiles = dir(fullfile(dFolderPath, '*.csv'));
                    csvFiles = csvFiles(~startsWith({csvFiles.name}, '._'));

                    AcqMethodFile = dir(fullfile(dFolderPath, '*AcqMethod.xml'));
                    HardwareConfigMethodFile = dir(fullfile(dFolderPath, 'HardwareConfig*.xml'));

                    if isempty(csvFiles) || isempty(AcqMethodFile) || isempty(HardwareConfigMethodFile)
                        continue
                    end

                    % Assume there is only one .csv file per .d folder
                    csvFilePath = fullfile(dFolderPath, csvFiles(1).name);
                    % Call the read_agilent_csv function
                    [spotname, signal_data, time] = read_single_agilent_csv(app, csvFilePath);

                    % Append the data to the collection
                    all_signal_data{end + 1} = signal_data;
                    all_spotname{end + 1} = spotname;
                    all_time{end + 1} = time;

                    acqmethodFilePath = fullfile(dFolderPath, AcqMethodFile(1).name);
                    hardwareconfigFilePath = fullfile(dFolderPath, HardwareConfigMethodFile(1).name);

                    if i == 1

                        % das gibt nur ein leeres struct zurück
                        [icp_ms_parameters, dwelltimes] = read_agilent_acqmethod(app, acqmethodFilePath);

                        if contains(HardwareConfigMethodFile(1).name, '7900')
                            [hardware_parameters] = read_agilent_hardware_config_7900(app, hardwareconfigFilePath);
                        elseif contains(HardwareConfigMethodFile(1).name, 'QQQ')
                            [hardware_parameters] = read_agilent_hardware_config_QQQ(app, hardwareconfigFilePath);
                        elseif contains(HardwareConfigMethodFile(1).name, '8900')
                            [hardware_parameters] = read_agilent_hardware_config_8900(app, hardwareconfigFilePath);
                        end
                        % Combine hardware_parameters into icp_ms_parameters
                        icp_ms_parameters = mergeStructs(app, icp_ms_parameters, hardware_parameters);

                    end

                end
            end

            % Combine all data into output variables
            signal_data = all_signal_data;
            spotname = all_spotname;
            time = all_time;
            %dwelltimes = all_dwelltimes;

            delete(progress);

        end

        %%%% Perkin Elmer
        function [spotname, signal_data, time] = read_perkinelmer_xl(app, signal_path)

            % Get file info to extract last modified time
            fileInfo = dir(signal_path);
            time = datestr(fileInfo.datenum, 'yyyy-mm-dd HH:MM:SS');

            signal_data = readtable(signal_path, 'Delimiter', ',', 'FileType', 'text');

            % Remove the .csv extension from the filename
            [~, spotname, ~] = fileparts(signal_path);


        end

        function [spotname, signal_data, time] = read_single_perkinelmer_nexion_csv(app, signal_path)

            fileInfo = dir(signal_path);
            time = datestr(fileInfo.datenum, 'yyyy-mm-dd HH:MM:SS');

            signal_data = readtable(signal_path);

            % Remove the last row if it contains NaN
            if any(isnan(signal_data{end, :}))
                signal_data(end, :) = [];
            end

            varNames = signal_data.Properties.VariableNames;

            % Clean up names: remove _ and first digit after it
            cleanedNames = regexprep(varNames, '_\d', '');

            % Apply cleaned names back to the table
            signal_data.Properties.VariableNames = cleanedNames;

            % Remove the .csv extension from the filename
            [~, spotname, ~] = fileparts(signal_path);

        end

        %%%% ThermoFisher
        function [signal_data, icp_ms_parameters, dwelltimes]  = read_continuous_iCAP_RQ_csv(app, signal_path)

            % Open the file and read row 27 manually
            fid = fopen(signal_path, 'r'); % Open the file for reading

            if fid == -1
                message = "Failed to open file. Check permission to open file.";
                uialert(app.UIFigure, message, "Warning", "Icon", "warning");
                disp('Failed to open file. Check permission to open file.')
                return
            end


         
            % Initialize the main struct for storing parameters
            icp_ms_parameters = struct();

            % Read the first 26 rows
            for i = 1:26
                line = fgetl(fid);

                if contains(line, 'STDR:')
                    stdr_line = strrep(line, 'STDR:', ''); % Remove prefix
                    keyValuePairs = strsplit(stdr_line, ';');
                    for j = 1:length(keyValuePairs)
                        if contains(keyValuePairs{j}, '=')
                            [key, value] = strtok(keyValuePairs{j}, '=');
                            key = strtrim(key);
                            key = strrep(key, ' ', '_'); % Replace spaces with underscores
                            key = matlab.lang.makeValidName(key); % Sanitize the key
                            value = strtrim(value(2:end)); % Remove '='
                            icp_ms_parameters.(key) = convertToNumericIfPossible(value);
                        end
                    end

                elseif contains(line, 'RF Generator:')
                    rf_generator_line = strrep(line, 'RF Generator:', ''); % Remove prefix
                    keyValuePairs = strsplit(rf_generator_line, ';');
                    for j = 1:length(keyValuePairs)
                        if contains(keyValuePairs{j}, '=')
                            [key, value] = strtok(keyValuePairs{j}, '=');
                            key = strtrim(key);
                            key = strrep(key, ' ', '_');
                            key = matlab.lang.makeValidName(key);
                            value = strtrim(value(2:end));
                            icp_ms_parameters.(key) = convertToNumericIfPossible(value);
                        end
                    end

                elseif contains(line, 'Ion Optics:')
                    ion_optics_line = strrep(line, 'Ion Optics:', ''); % Remove prefix
                    keyValuePairs = strsplit(ion_optics_line, ';');
                    for j = 1:length(keyValuePairs)
                        if contains(keyValuePairs{j}, '=')
                            [key, value] = strtok(keyValuePairs{j}, '=');
                            key = strtrim(key);
                            key = strrep(key, ' ', '_');
                            key = matlab.lang.makeValidName(key);
                            value = strtrim(value(2:end));
                            icp_ms_parameters.(key) = convertToNumericIfPossible(value);
                        end
                    end

                elseif contains(line, 'Vacuum:')
                    vacuum_line = strrep(line, 'Vacuum:', ''); % Remove prefix
                    keyValuePairs = strsplit(vacuum_line, ';');
                    for j = 1:length(keyValuePairs)
                        if contains(keyValuePairs{j}, '=')
                            [key, value] = strtok(keyValuePairs{j}, '=');
                            key = strtrim(key);
                            key = strrep(key, ' ', '_');
                            key = matlab.lang.makeValidName(key);
                            value = strtrim(value(2:end));
                            icp_ms_parameters.(key) = convertToNumericIfPossible(value);
                        end
                    end

                elseif contains(line, 'Detector:')
                    detector_line = strrep(line, 'Detector:', ''); % Remove prefix
                    keyValuePairs = strsplit(detector_line, ';');
                    for j = 1:length(keyValuePairs)
                        if contains(keyValuePairs{j}, '=')
                            [key, value] = strtok(keyValuePairs{j}, '=');
                            key = strtrim(key);
                            key = strrep(key, ' ', '_');
                            key = matlab.lang.makeValidName(key);
                            value = strtrim(value(2:end));
                            icp_ms_parameters.(key) = convertToNumericIfPossible(value);
                        end
                    end

                elseif contains(line, 'Cooling System:')
                    cooling_system_line = strrep(line, 'Cooling System:', ''); % Remove prefix
                    keyValuePairs = strsplit(cooling_system_line, ';');
                    for j = 1:length(keyValuePairs)
                        if contains(keyValuePairs{j}, '=')
                            [key, value] = strtok(keyValuePairs{j}, '=');
                            key = strtrim(key);
                            key = strrep(key, ' ', '_');
                            key = matlab.lang.makeValidName(key);
                            value = strtrim(value(2:end));
                            icp_ms_parameters.(key) = convertToNumericIfPossible(value);
                        end
                    end

                elseif contains(line, 'Power Supply:')
                    power_supply_line = strrep(line, 'Power Supply:', ''); % Remove prefix
                    keyValuePairs = strsplit(power_supply_line, ';');
                    for j = 1:length(keyValuePairs)
                        if contains(keyValuePairs{j}, '=')
                            [key, value] = strtok(keyValuePairs{j}, '=');
                            key = strtrim(key);
                            key = strrep(key, ' ', '_');
                            key = matlab.lang.makeValidName(key);
                            value = strtrim(value(2:end));
                            icp_ms_parameters.(key) = convertToNumericIfPossible(value);
                        end
                    end

                elseif contains(line, 'Gas Supply:')
                    gas_supply_line = strrep(line, 'Gas Supply:', ''); % Remove prefix
                    keyValuePairs = strsplit(gas_supply_line, ';');
                    for j = 1:length(keyValuePairs)
                        if contains(keyValuePairs{j}, '=')
                            [key, value] = strtok(keyValuePairs{j}, '=');
                            key = strtrim(key);
                            key = strrep(key, ' ', '_');
                            key = matlab.lang.makeValidName(key);
                            value = strtrim(value(2:end));
                            icp_ms_parameters.(key) = convertToNumericIfPossible(value);
                        end
                    end

                elseif contains(line, 'Pulse Counting:')
                    pulse_counting_line = strrep(line, 'Pulse Counting:', ''); % Remove prefix
                    keyValuePairs = strsplit(pulse_counting_line, ';');
                    for j = 1:length(keyValuePairs)
                        if contains(keyValuePairs{j}, '=')
                            [key, value] = strtok(keyValuePairs{j}, '=');
                            key = strtrim(key);
                            key = strrep(key, ' ', '_');
                            key = matlab.lang.makeValidName(key);
                            value = strtrim(value(2:end));
                            icp_ms_parameters.(key) = convertToNumericIfPossible(value);
                        end
                    end
                end
            end

                        % Helper function to convert numeric strings to single
            function output = convertToNumericIfPossible(inputStr)
                % Attempts to convert a string to single numeric type
                % Returns single if numeric, otherwise returns original char
                numValue = str2double(inputStr);
                if ~isnan(numValue)
                    output = single(numValue);
                else
                    output = inputStr; % Keep as char if not numeric
                end
            end



            %%%% get data %%%%%
            headerLine = fgetl(fid); % Read row 27
            % Skip row 28
            fgetl(fid);
            row29Data = fgetl(fid);

            fclose(fid); % Close the file

            opts = detectImportOptions(signal_path);
            delimiter = opts.Delimiter;

            % Split the header line into individual column headers
            columnHeaders = strsplit(headerLine, delimiter);
            columnHeaders = columnHeaders(~cellfun('isempty', columnHeaders));

            for i = 2:length(columnHeaders) % Start from 2 to skip 'Time'
                header = columnHeaders{i};
                numberPart = regexp(header, '^\d+', 'match'); % Extract the number at the start
                elementPart = regexp(header, '[A-Za-z]+$', 'match'); % Extract the element
                if ~isempty(numberPart) && ~isempty(elementPart)
                    columnHeaders{i} = [elementPart{1} numberPart{1}]; % Combine element and number
                end
            end

            % Extract all dwell time values using a regular expression
            dwellTimes = regexp(row29Data, 'dwell time=([\d.]+)', 'tokens');
            % Convert the extracted tokens to a numeric array
            dwellTimes = cellfun(@(x) str2double(x{1}), dwellTimes);
            % Create a table
            dwelltimes = array2table(dwellTimes, 'VariableNames', columnHeaders(2:end));

            % Extract all xcal values using a regular expression
            xcalfactor = regexp(row29Data, 'xcal factor=([\d.]+)', 'tokens');
            % Convert the extracted tokens to a numeric array
            xcalfactor = cellfun(@(x) str2double(x{1}), xcalfactor);   
            % this was turned off as I have no idea what this is and it
            % fucks up the Table_builder_Submodule
            %icp_ms_parameters.xcal_factors = array2table(xcalfactor, 'VariableNames', columnHeaders(2:end));


            % Read the data starting from row 28
            opts.DataLines = [31 Inf]; % Start reading from row 31 to the end of the file
            signal_data = readtable(signal_path, opts);

            % Assign the extracted column headers to the data table
            signal_data.Properties.VariableNames = columnHeaders;

        end

        function [spotname, signal_data, time, icp_ms_parameters, dwelltimes] = read_single_iCAP_RQ_csv(app, signal_path)

            % data, parameters and dwell times are read exactly like for the continuous format
            [signal_data, icp_ms_parameters, dwelltimes] = read_continuous_iCAP_RQ_csv(app, signal_path);

            % the first line holds the sample name and the acquisition date and time,
            % e.g. "20230327-S1:07/17/2025 03:48:48 PM;"
            fid = fopen(signal_path, 'r');
            first_line = fgetl(fid);
            fclose(fid);

            % date with any separator (/ . -), time as 12 h (AM/PM) or 24 h; whatever stands around it is ignored
            time_match = regexp(first_line, ...
                '(\d{1,4})[/.\-](\d{1,2})[/.\-](\d{1,4})\s+(\d{1,2}):(\d{2}):(\d{2})(?:\s*([AaPp][Mm]))?', ...
                'tokens', 'once');

            if ~isempty(time_match)

                n1 = str2double(time_match{1});
                n2 = str2double(time_match{2});
                n3 = str2double(time_match{3});
                hh = str2double(time_match{4});
                mn = str2double(time_match{5});
                ss = str2double(time_match{6});

                if numel(time_match) >= 7
                    ampm = time_match{7};
                else
                    ampm = '';
                end

                if n1 > 31                      % year first: yyyy-mm-dd
                    yr = n1; mo = n2; dy = n3;
                else                            % year last
                    yr = n3;
                    if n1 > 12                  % the first number cannot be a month: day/month/year
                        dy = n1; mo = n2;
                    elseif n2 > 12              % the second number cannot be a month: month/day/year
                        mo = n1; dy = n2;
                    elseif ~isempty(ampm)       % ambiguous with a 12 h clock: US style month/day/year
                        mo = n1; dy = n2;
                    else                        % ambiguous with a 24 h clock: day/month/year
                        dy = n1; mo = n2;
                    end
                end
                if yr < 100, yr = yr + 2000; end

                if strcmpi(ampm, 'PM') && hh < 12, hh = hh + 12; end
                if strcmpi(ampm, 'AM') && hh == 12, hh = 0;      end

                time = char(datetime(yr, mo, dy, hh, mn, ss, 'Format', 'yyyy-MM-dd HH:mm:ss'));

            else
                % no date and time in the first line: use the time the file was saved
                file_info = dir(signal_path);
                time = datestr(file_info.datenum, 'yyyy-mm-dd HH:MM:SS');
            end

            % the spot name is the file name, like in the other Single readers
            [~, spotname, ~] = fileparts(signal_path);

        end

        function [spotname, signal_data, time, icp_ms_parameters, dwelltimes] = read_single_iCAP_Q_csv(app, signal_path)

            opts = detectImportOptions(signal_path);
            delimiter = opts.Delimiter;

            % Open the file and read rows manually
            fid = fopen(signal_path, 'r');

            if fid == -1
                message = "Failed to open file. Check permission to open file.";
                uialert(app.UIFigure, message, "Warning", "Icon", "warning");
                disp('Failed to open file. Check permission to open file.')
                return
            end

            firstLine = fgetl(fid);
            % Extract date and time from first line
            % (e.g. "N610-01:02/09/2026 10:00:43 AM;" or "...02/09/2026 10:00:43;")
            timeMatch = regexp(firstLine, '(\d{1,2})/(\d{1,2})/(\d{4})\s+(\d{1,2}):(\d{2}):(\d{2})(?:\s+([AP]M))?', 'tokens', 'once');
            if ~isempty(timeMatch)
                A  = str2double(timeMatch{1});
                B  = str2double(timeMatch{2});
                yr = str2double(timeMatch{3});
                hh = str2double(timeMatch{4});
                mn = str2double(timeMatch{5});
                ss = str2double(timeMatch{6});
                if numel(timeMatch) >= 7
                    ampm = timeMatch{7};
                else
                    ampm = '';
                end

                % Disambiguate day/month via the >12 rule (default day-first)
                if A > 12
                    dy = A; mo = B;        % D/M/Y
                elseif B > 12
                    mo = A; dy = B;        % M/D/Y
                else
                    dy = A; mo = B;        % ambiguous -> default D/M/Y
                end

                % Handle 12h AM/PM
                if strcmpi(ampm, 'PM') && hh < 12, hh = hh + 12; end
                if strcmpi(ampm, 'AM') && hh == 12, hh = 0;      end

                time = char(datetime(yr, mo, dy, hh, mn, ss, 'Format', 'yyyy-MM-dd HH:mm:ss'));
            else
                % no date in the header: use the file's last modified time
                fileInfo = dir(signal_path);
                time = datestr(fileInfo.datenum, 'yyyy-mm-dd HH:MM:SS');
            end

            % Initialize the main struct for storing parameters
            icp_ms_parameters = struct();

            % Helper function to convert numeric strings to single
            function output = convertToNumericIfPossible(inputStr)
                numValue = str2double(inputStr);
                if ~isnan(numValue)
                    output = single(numValue);
                else
                    output = inputStr;
                end
            end

            % Read the first 13 rows for parameters
            for i = 2:13
                line = fgetl(fid);

                if contains(line, 'Laser_STD:')
                    stdr_line = strrep(line, 'Laser_STD:', '');
                    keyValuePairs = strsplit(stdr_line, ';');
                    for j = 1:length(keyValuePairs)
                        if contains(keyValuePairs{j}, '=')
                            [key, value] = strtok(keyValuePairs{j}, '=');
                            key = strtrim(key);
                            key = strrep(key, ' ', '_');
                            key = matlab.lang.makeValidName(key);
                            value = strtrim(value(2:end));
                            icp_ms_parameters.(key) = convertToNumericIfPossible(value);
                        end
                    end

                elseif contains(line, 'RF Generator:')
                    rf_generator_line = strrep(line, 'RF Generator:', '');
                    keyValuePairs = strsplit(rf_generator_line, ';');
                    for j = 1:length(keyValuePairs)
                        if contains(keyValuePairs{j}, '=')
                            [key, value] = strtok(keyValuePairs{j}, '=');
                            key = strtrim(key);
                            key = strrep(key, ' ', '_');
                            key = matlab.lang.makeValidName(key);
                            value = strtrim(value(2:end));
                            icp_ms_parameters.(key) = convertToNumericIfPossible(value);
                        end
                    end

                elseif contains(line, 'Ion Optics:')
                    ion_optics_line = strrep(line, 'Ion Optics:', '');
                    keyValuePairs = strsplit(ion_optics_line, ';');
                    for j = 1:length(keyValuePairs)
                        if contains(keyValuePairs{j}, '=')
                            [key, value] = strtok(keyValuePairs{j}, '=');
                            key = strtrim(key);
                            key = strrep(key, ' ', '_');
                            key = matlab.lang.makeValidName(key);
                            value = strtrim(value(2:end));
                            icp_ms_parameters.(key) = convertToNumericIfPossible(value);
                        end
                    end

                elseif contains(line, 'Vacuum:')
                    vacuum_line = strrep(line, 'Vacuum:', '');
                    keyValuePairs = strsplit(vacuum_line, ';');
                    for j = 1:length(keyValuePairs)
                        if contains(keyValuePairs{j}, '=')
                            [key, value] = strtok(keyValuePairs{j}, '=');
                            key = strtrim(key);
                            key = strrep(key, ' ', '_');
                            key = matlab.lang.makeValidName(key);
                            value = strtrim(value(2:end));
                            icp_ms_parameters.(key) = convertToNumericIfPossible(value);
                        end
                    end

                elseif contains(line, 'Detector:')
                    detector_line = strrep(line, 'Detector:', '');
                    keyValuePairs = strsplit(detector_line, ';');
                    for j = 1:length(keyValuePairs)
                        if contains(keyValuePairs{j}, '=')
                            [key, value] = strtok(keyValuePairs{j}, '=');
                            key = strtrim(key);
                            key = strrep(key, ' ', '_');
                            key = matlab.lang.makeValidName(key);
                            value = strtrim(value(2:end));
                            icp_ms_parameters.(key) = convertToNumericIfPossible(value);
                        end
                    end

                elseif contains(line, 'Cooling System:')
                    cooling_system_line = strrep(line, 'Cooling System:', '');
                    keyValuePairs = strsplit(cooling_system_line, ';');
                    for j = 1:length(keyValuePairs)
                        if contains(keyValuePairs{j}, '=')
                            [key, value] = strtok(keyValuePairs{j}, '=');
                            key = strtrim(key);
                            key = strrep(key, ' ', '_');
                            key = matlab.lang.makeValidName(key);
                            value = strtrim(value(2:end));
                            icp_ms_parameters.(key) = convertToNumericIfPossible(value);
                        end
                    end

                elseif contains(line, 'Power Supply:')
                    power_supply_line = strrep(line, 'Power Supply:', '');
                    keyValuePairs = strsplit(power_supply_line, ';');
                    for j = 1:length(keyValuePairs)
                        if contains(keyValuePairs{j}, '=')
                            [key, value] = strtok(keyValuePairs{j}, '=');
                            key = strtrim(key);
                            key = strrep(key, ' ', '_');
                            key = matlab.lang.makeValidName(key);
                            value = strtrim(value(2:end));
                            icp_ms_parameters.(key) = convertToNumericIfPossible(value);
                        end
                    end

                elseif contains(line, 'Gas Supply:')
                    gas_supply_line = strrep(line, 'Gas Supply:', '');
                    keyValuePairs = strsplit(gas_supply_line, ';');
                    for j = 1:length(keyValuePairs)
                        if contains(keyValuePairs{j}, '=')
                            [key, value] = strtok(keyValuePairs{j}, '=');
                            key = strtrim(key);
                            key = strrep(key, ' ', '_');
                            key = matlab.lang.makeValidName(key);
                            value = strtrim(value(2:end));
                            icp_ms_parameters.(key) = convertToNumericIfPossible(value);
                        end
                    end

                elseif contains(line, 'Pulse Counting:')
                    pulse_counting_line = strrep(line, 'Pulse Counting:', '');
                    keyValuePairs = strsplit(pulse_counting_line, ';');
                    for j = 1:length(keyValuePairs)
                        if contains(keyValuePairs{j}, '=')
                            [key, value] = strtok(keyValuePairs{j}, '=');
                            key = strtrim(key);
                            key = strrep(key, ' ', '_');
                            key = matlab.lang.makeValidName(key);
                            value = strtrim(value(2:end));
                            icp_ms_parameters.(key) = convertToNumericIfPossible(value);
                        end
                    end
                end
            end

            %%%% Get data from rows 14-16 %%%%%
            headerLine = fgetl(fid);  % Read row 14 (element names)
            dwellLine = fgetl(fid);   % Read row 15 (dwell times)

            fclose(fid);

            % Split the header line into individual column headers
            % (tab-delimited) - seems to be comma delimited not tab
            % delimined
            columnHeaders = strsplit(headerLine, delimiter);
            columnHeaders = columnHeaders(~cellfun('isempty', columnHeaders));

            % Reformat element names from "7Li" to "Li7"
            for i = 2:length(columnHeaders)
                header = columnHeaders{i};
                numberPart = regexp(header, '^\d+', 'match');
                elementPart = regexp(header, '[A-Za-z]+$', 'match');
                if ~isempty(numberPart) && ~isempty(elementPart)
                    columnHeaders{i} = [elementPart{1} numberPart{1}];
                end
            end

            % Extract all dwell time values using a regular expression
            dwellTimes = regexp(dwellLine, 'dwell time=([\d.]+)', 'tokens');
            dwellTimes = cellfun(@(x) str2double(x{1}), dwellTimes);
            dwelltimes = array2table(dwellTimes, 'VariableNames', columnHeaders(2:end));

            % Read the data starting from row 16
            opts.DataLines = [16 Inf];
            signal_data = readtable(signal_path, opts);

            % Assign the extracted column headers to the data table
            signal_data.Properties.VariableNames = columnHeaders;

            % Remove the .csv extension from the filename
            [~, spotname, ~] = fileparts(signal_path);

        end

        function [spotname, signal_data, time] = read_element_xr(app, signal_path)

            fileContent = fileread(signal_path);
            % Extract date and time from the header
            % e.g. "Wednesday, February 26, 2025 10:05:52"  or  "... 10:05:52 PM"
            timePattern = '\w+, (\w+ \d+, \d+) (\d+:\d+:\d+)\s*([AP]M)?';
            timeMatch = regexp(fileContent, timePattern, 'tokens', 'once');
            if ~isempty(timeMatch)
                datePart = timeMatch{1};
                timePart = timeMatch{2};
                ampm     = timeMatch{3};
                if isempty(ampm)
                    dt = datetime([datePart ' ' timePart], ...
                        'InputFormat', 'MMMM d, yyyy HH:mm:ss', 'Locale', 'en_US');
                else
                    dt = datetime([datePart ' ' timePart ' ' ampm], ...
                        'InputFormat', 'MMMM d, yyyy h:mm:ss a', 'Locale', 'en_US');
                end
                time = string(dt, 'yyyy-MM-dd HH:mm:ss');
            else
                % no date in the header: use the file's last modified time
                fileInfo = dir(signal_path);
                time = datestr(fileInfo.datenum, 'yyyy-mm-dd HH:MM:SS');
            end

            signal_data = readtable(signal_path, 'Delimiter', ',', 'FileType', 'text', ...
                'HeaderLines', 7);

            % Remove the .csv extension from the filename
            [~, spotname, ~] = fileparts(signal_path);

        end

        function [spotname, signal_data, time] = read_element_xr_csv(app, signal_path)

            % Get file info to extract last modified time
            fileInfo = dir(signal_path);
            time = datestr(fileInfo.datenum, 'yyyy-mm-dd HH:MM:SS');

            opts = detectImportOptions(signal_path);
            opts.DataLines = [7 Inf];
            signal_data = readtable(signal_path, opts);

            signal_data.Properties.VariableNames{1} = 'Time';
            signal_data.Properties.VariableNames = regexprep(signal_data.Properties.VariableNames, '^([a-zA-Z]+\d+).*', '$1');

            % Remove the .csv extension from the filename
            [~, spotname, ~] = fileparts(signal_path);

        end


        function [spotname, signal_data, time] = read_single_neptune_csv(app, signal_path)

            % 1. Parse Metadata (Date + Time)
            fileContent = fileread(signal_path);

            % Date, e.g. "Date: 16/01/2026"
            dateMatch = regexpi(fileContent, 'Date:\s*(\d{1,2})/(\d{1,2})/(\d{4})', 'tokens', 'once');
            % Analysis time, e.g. "19:29:24" or "07:29:24 PM"
            timeMatch = regexpi(fileContent, 'Analysis time:\s*(\d{1,2}):(\d{2}):(\d{2})(?:\s*([AP]M))?', 'tokens', 'once');

            try
                A  = str2double(dateMatch{1});
                B  = str2double(dateMatch{2});
                yr = str2double(dateMatch{3});
                hh = str2double(timeMatch{1});
                mn = str2double(timeMatch{2});
                ss = str2double(timeMatch{3});
                if numel(timeMatch) >= 4
                    ampm = timeMatch{4};
                else
                    ampm = '';
                end

                % Disambiguate day/month via the >12 rule (default day-first)
                if A > 12
                    dy = A; mo = B;        % D/M/Y
                elseif B > 12
                    mo = A; dy = B;        % M/D/Y
                else
                    dy = A; mo = B;        % ambiguous -> default D/M/Y
                end

                % Handle 12h AM/PM
                if strcmpi(ampm, 'PM') && hh < 12, hh = hh + 12; end
                if strcmpi(ampm, 'AM') && hh == 12, hh = 0;      end

                time = char(datetime(yr, mo, dy, hh, mn, ss, 'Format', 'yyyy-MM-dd HH:mm:ss'));
            catch ME
                DisplayError(ME, 'Neptune Import Failed because no date/time was detected')
            end


            % 2. Read Data Table
            opts = detectImportOptions(signal_path);
            opts.DataLines = [24 Inf];      % Data starts on line 24
            opts.VariableNamesLine = 23;    % Headers are on line 23

            signal_data = readtable(signal_path, opts);

            % 3. Remove 'Cycle' column
            if ismember('Cycle', signal_data.Properties.VariableNames)
                signal_data.Cycle = [];
            end

            % --- CLEAN VARIABLE NAMES ---
            % regexprep: Replace 'x' (optional) + Digits + Letters -> with Letters + Digits
            signal_data.Properties.VariableNames = regexprep(signal_data.Properties.VariableNames, '^x?(\d+)([a-zA-Z]+)$', '$2$1');

            % 4. Get Spotname
            [~, spotname, ~] = fileparts(signal_path);

        end



        %%%% SILLS

        function data = read_sills_project(app, signal_path)

            sills_data = load(signal_path);

            n_unk = size(sills_data.UNK, 1);
            n_std = size(sills_data.STD, 1);

            unk_signal_data        = cell(n_unk, 1);
            unk_type               = repmat("Unknown", n_unk, 1);
            unk_reference_material = repmat("None", n_unk, 1);
            unk_bracket_id         = zeros(n_unk, 1);
            unk_background_starts  = NaN(n_unk, 1);
            unk_background_ends    = NaN(n_unk, 1);
            unk_inclusion_starts   = NaN(n_unk, 1);
            unk_inclusion_ends     = NaN(n_unk, 1);
            unk_matrix_1_starts    = NaN(n_unk, 1);
            unk_matrix_1_ends      = NaN(n_unk, 1);
            unk_matrix_2_starts    = NaN(n_unk, 1);
            unk_matrix_2_ends      = NaN(n_unk, 1);
            unk_acquisition_time   = cell(n_unk, 1);
            unk_spotname           = cell(n_unk, 1);

            for i = 1:n_unk
                unk_signal_data{i} = array2table(sills_data.UNK(i).data, 'VariableNames', sills_data.UNK(i).colheaders);
                unk_spotname{i}    = sills_data.UNK(i).fileinfo.name;

                % Background indices
                if isfield(sills_data.UNK(i), 'bgwindow_index') && ~isempty(sills_data.UNK(i).bgwindow_index)
                    if ~(sills_data.UNK(i).bgwindow_index(1) == 1 && sills_data.UNK(i).bgwindow_index(2) == 1)
                        unk_background_starts(i) = sills_data.UNK(i).bgwindow_index(1);
                        unk_background_ends(i)   = sills_data.UNK(i).bgwindow_index(2);
                    end
                end

                % Inclusion indices
                if isfield(sills_data.UNK(i), 'comp1window_index') && ~isempty(sills_data.UNK(i).comp1window_index)
                    if ~(sills_data.UNK(i).comp1window_index(1) == 1 && sills_data.UNK(i).comp1window_index(2) == 1)
                        unk_inclusion_starts(i) = sills_data.UNK(i).comp1window_index(1);
                        unk_inclusion_ends(i)   = sills_data.UNK(i).comp1window_index(2);
                    end
                end

                % Matrix 1 indices (handles both typo and correct field name)
                if isfield(sills_data.UNK(i), 'mat1windox_index') && ~isempty(sills_data.UNK(i).mat1windox_index)
                    if ~(sills_data.UNK(i).mat1windox_index(1) == 1 && sills_data.UNK(i).mat1windox_index(2) == 1)
                        unk_matrix_1_starts(i) = sills_data.UNK(i).mat1windox_index(1);
                        unk_matrix_1_ends(i)   = sills_data.UNK(i).mat1windox_index(2);
                    end
                elseif isfield(sills_data.UNK(i), 'mat1window_index') && ~isempty(sills_data.UNK(i).mat1window_index)
                    if ~(sills_data.UNK(i).mat1window_index(1) == 1 && sills_data.UNK(i).mat1window_index(2) == 1)
                        unk_matrix_1_starts(i) = sills_data.UNK(i).mat1window_index(1);
                        unk_matrix_1_ends(i)   = sills_data.UNK(i).mat1window_index(2);
                    end
                end

                % Matrix 2 indices
                if isfield(sills_data.UNK(i), 'mat2window_index') && ~isempty(sills_data.UNK(i).mat2window_index)
                    if ~(sills_data.UNK(i).mat2window_index(1) == 1 && sills_data.UNK(i).mat2window_index(2) == 1)
                        unk_matrix_2_starts(i) = sills_data.UNK(i).mat2window_index(1);
                        unk_matrix_2_ends(i)   = sills_data.UNK(i).mat2window_index(2);
                    end
                end

                % Promote inclusion to matrix 1 if both matrix windows are unset
                if isnan(unk_matrix_1_starts(i)) && isnan(unk_matrix_2_starts(i)) && ~isnan(unk_inclusion_starts(i))
                    unk_matrix_1_starts(i)  = unk_inclusion_starts(i);
                    unk_matrix_1_ends(i)    = unk_inclusion_ends(i);
                    unk_inclusion_starts(i) = NaN;
                    unk_inclusion_ends(i)   = NaN;
                end

                % Acquisition time
                if isfield(sills_data.UNK(i), 'hh') && isfield(sills_data.UNK(i), 'mm')
                    unk_acquisition_time{i} = [sills_data.UNK(i).hh, ':', sills_data.UNK(i).mm, ':00'];
                end
            end

            %%% Standard files

            std_signal_data        = cell(n_std, 1);
            std_type               = repmat("PRM", n_std, 1);
            std_reference_material = repmat("None", n_std, 1);
            std_bracket_id         = ones(n_std, 1);
            std_background_starts  = NaN(n_std, 1);
            std_background_ends    = NaN(n_std, 1);
            std_matrix_1_starts    = NaN(n_std, 1);
            std_matrix_1_ends      = NaN(n_std, 1);
            std_acquisition_time   = cell(n_std, 1);
            std_spotname           = cell(n_std, 1);

            for i = 1:n_std
                std_signal_data{i} = array2table(sills_data.STD(i).data, 'VariableNames', sills_data.STD(i).colheaders);
                std_spotname{i}    = sills_data.STD(i).fileinfo.name;

                % Background indices
                if isfield(sills_data.STD(i), 'bgwindow_index') && ~isempty(sills_data.STD(i).bgwindow_index)
                    if ~(sills_data.STD(i).bgwindow_index(1) == 1 && sills_data.STD(i).bgwindow_index(2) == 1)
                        std_background_starts(i) = sills_data.STD(i).bgwindow_index(1);
                        std_background_ends(i)   = sills_data.STD(i).bgwindow_index(2);
                    end
                end

                % Signal indices
                if isfield(sills_data.STD(i), 'sigwindow_index') && ~isempty(sills_data.STD(i).sigwindow_index)
                    if ~(sills_data.STD(i).sigwindow_index(1) == 1 && sills_data.STD(i).sigwindow_index(2) == 1)
                        std_matrix_1_starts(i) = sills_data.STD(i).sigwindow_index(1);
                        std_matrix_1_ends(i)   = sills_data.STD(i).sigwindow_index(2);
                    end
                end

                % Acquisition time
                if isfield(sills_data.STD(i), 'hh') && isfield(sills_data.STD(i), 'mm')
                    std_acquisition_time{i} = [sills_data.STD(i).hh, ':', sills_data.STD(i).mm, ':00'];
                end
            end

            %%%

            data.dwelltimes = array2table(sills_data.A.DT_VALUES', 'VariableNames', std_signal_data{1}.Properties.VariableNames(2:end));

            if ~isempty(unk_acquisition_time) && ~isempty(std_acquisition_time)
                unk_time_dt = datetime(unk_acquisition_time, 'InputFormat', 'HH:mm:ss');
                std_time_dt = datetime(std_acquisition_time, 'InputFormat', 'HH:mm:ss');

                combined_table = table( ...
                    [unk_time_dt;             std_time_dt], ...
                    [unk_spotname;            std_spotname], ...
                    [unk_type;                std_type], ...
                    [unk_reference_material;  std_reference_material], ...
                    [unk_bracket_id;          std_bracket_id], ...
                    [unk_signal_data;         std_signal_data], ...
                    [unk_background_starts;   std_background_starts], ...
                    [unk_background_ends;     std_background_ends], ...
                    [unk_inclusion_starts;    NaN(n_std, 1)], ...
                    [unk_inclusion_ends;      NaN(n_std, 1)], ...
                    [unk_matrix_1_starts;     std_matrix_1_starts], ...
                    [unk_matrix_1_ends;       std_matrix_1_ends], ...
                    [unk_matrix_2_starts;     NaN(n_std, 1)], ...
                    [unk_matrix_2_ends;       NaN(n_std, 1)], ...
                    'VariableNames', {'AcquisitionTime', 'Spotname', 'Type', 'ReferenceMaterial', ...
                    'bracket_id', 'SignalData', 'BackgroundStarts', 'BackgroundEnds', ...
                    'InclusionStarts', 'InclusionEnds', 'Matrix1Starts', 'Matrix1Ends', ...
                    'Matrix2Starts', 'Matrix2Ends'});

                combined_table = sortrows(combined_table, 'AcquisitionTime');

                %                 formatted_time = string(datestr(combined_table.AcquisitionTime, 'HH:MM:SS'));
                %                 data.AcquisitionDateTime = "2000-01-01 " + formatted_time;
                data.AcquisitionTime   = cellstr(datestr(combined_table.AcquisitionTime, 'HH:MM:SS'));
                data.Spotname          = combined_table.Spotname;
                data.Type              = combined_table.Type;
                data.ReferenceMaterial = combined_table.ReferenceMaterial;
                data.bracket_id        = combined_table.bracket_id;
                data.SignalData        = combined_table.SignalData;
                data.BackgroundStarts  = combined_table.BackgroundStarts;
                data.BackgroundEnds    = combined_table.BackgroundEnds;
                data.InclusionStarts   = combined_table.InclusionStarts;
                data.InclusionEnds     = combined_table.InclusionEnds;
                data.Matrix1Starts     = combined_table.Matrix1Starts;
                data.Matrix1Ends       = combined_table.Matrix1Ends;
                data.Matrix2Starts     = combined_table.Matrix2Starts;
                data.Matrix2Ends       = combined_table.Matrix2Ends;

            elseif ~isempty(unk_acquisition_time) || ~isempty(std_acquisition_time)
                message = "There were no acquisition times set in the sills project. ICP-Base needs those to order the spots correctly.";
                uialert(app.UIFigure, message, "Warning", "Icon", "warning");
                data = struct();
                return;
            end

        end


        %%%%%%%%%%%%%%%%%% Signal Import Wrappers %%%%%%%%%%%%%%%

        function [settings, signal_data, spotname, time, icp_ms_parameters, dwelltimes, sills_data, signal_path] = read_signal_files_wrapper(app, signal_path, settings)

            signal_data = [];
            time = '';
            spotname = [];
            icp_ms_parameters = struct();
            dwelltimes = [];
            sills_data = struct();

            if not(exist('signal_path','var')) || isempty(signal_path)
                settings.massspec.Value = app.ChooseMassSpecDropDown.Value; % default value
                settings.massspec.Options = {'Agilent', 'Perkin Elmer', 'Thermo Fisher Element XR'}; %For API
                return
            end

            if exist('settings','var')&& isfield(settings,'massspec')
                switch settings.massspec.Value
                    case 'Agilent .csv (Single)'

                        [spotname, signal_data, time] = read_single_agilent_csv(app, signal_path);

                        app.SinglePanel.Visible = true;
                        app.ContinuousPanel.Visible = false;

                    case 'Agilent .csv (Continuous)'

                        [signal_data] = read_continuous_agilent_csv(app, signal_path);

                        app.SinglePanel.Visible = false;
                        app.ContinuousPanel.Visible = true;
                        app.ManualSelectionPanel.Visible = true;

                    case 'Agilent Batch Folder (.b)'

                        [spotname, signal_data, time, icp_ms_parameters, dwelltimes] = read_agilent_batch_folder(app, signal_path);

                    case 'PerkinElmer .xl (Single)'

                        [spotname, signal_data, time] = read_perkinelmer_xl(app, signal_path);

                        app.SinglePanel.Visible = true;
                        app.ContinuousPanel.Visible = false;

                    case 'PerkinElmer Nexion .csv (Single)'

                        [spotname, signal_data, time] = read_single_perkinelmer_nexion_csv(app, signal_path);

                        app.SinglePanel.Visible = true;
                        app.ContinuousPanel.Visible = false;
                        
                    case 'Thermo Fisher Element XR .FIN2 (Single)'

                        [spotname, signal_data, time] = read_element_xr(app, signal_path);

                        app.SinglePanel.Visible = true;
                        app.ContinuousPanel.Visible = false;

                    case 'Thermo Fisher Element XR .csv (Single)'

                        [spotname, signal_data, time] = read_element_xr_csv(app, signal_path);

                        app.SinglePanel.Visible = true;
                        app.ContinuousPanel.Visible = false;

                    case 'sills Project'

                        sills_data = read_sills_project(app,signal_path);

                        app.SinglePanel.Visible = true;
                        app.ContinuousPanel.Visible = false;

                    case 'Thermo Fisher iCAP RQ .csv (Continuous)'

                        [signal_data, icp_ms_parameters, dwelltimes]  = read_continuous_iCAP_RQ_csv(app, signal_path);

                        app.SinglePanel.Visible = false;
                        app.ContinuousPanel.Visible = true;
                        app.ManualSelectionPanel.Visible = true;

                    case 'Thermo Fisher iCAP Q .csv (Single)'

                        [spotname, signal_data, time, icp_ms_parameters, dwelltimes]  = read_single_iCAP_Q_csv(app, signal_path);

                        app.SinglePanel.Visible = true;
                        app.ContinuousPanel.Visible = false;

                    case 'Tofwerk .h5 (Single)'

                        [signal_data, icp_ms_parameters, dwelltimes]  = read_tofwerk_single_h_five(app, signal_path);

                        app.SinglePanel.Visible = true;
                        app.ContinuousPanel.Visible = false;

                    case 'Thermo Fisher Neptune .csv (Single)'

                        [spotname, signal_data, time] = read_single_neptune_csv(app, signal_path);

                        app.SinglePanel.Visible = true;
                        app.ContinuousPanel.Visible = false;

                        %%% New imports
                    case 'PerkinElmer .xl (Continuous)'

                        [~, signal_data, ~] = read_perkinelmer_xl(app, signal_path);

                        app.SinglePanel.Visible = false;
                        app.ContinuousPanel.Visible = true;
                        app.ManualSelectionPanel.Visible = true;

                    case 'PerkinElmer Nexion .csv (Continuous)'

                        [~, signal_data, ~] = read_single_perkinelmer_nexion_csv(app, signal_path);

                        app.SinglePanel.Visible = false;
                        app.ContinuousPanel.Visible = true;
                        app.ManualSelectionPanel.Visible = true;

                    case 'Thermo Fisher Element XR .FIN2 (Continuous)'

                        signal_data = readtable(signal_path, 'Delimiter', ',', 'FileType', 'text', 'HeaderLines', 7);

                        app.SinglePanel.Visible = false;
                        app.ContinuousPanel.Visible = true;
                        app.ManualSelectionPanel.Visible = true;

                    case 'Thermo Fisher Element XR .csv (Continuous)'

                        [~, signal_data, ~] = read_element_xr_csv(app, signal_path);

                        app.SinglePanel.Visible = false;
                        app.ContinuousPanel.Visible = true;
                        app.ManualSelectionPanel.Visible = true;

                    case 'Thermo Fisher iCAP Q .csv (Continuous)'

                        [~, signal_data, ~, icp_ms_parameters, dwelltimes] = read_single_iCAP_Q_csv(app, signal_path);

                        app.SinglePanel.Visible = false;
                        app.ContinuousPanel.Visible = true;
                        app.ManualSelectionPanel.Visible = true;

                    case 'Thermo Fisher iCAP RQ .csv (Single)'

                        [spotname, signal_data, time, icp_ms_parameters, dwelltimes] = read_single_iCAP_RQ_csv(app, signal_path);

                        app.SinglePanel.Visible = true;
                        app.ContinuousPanel.Visible = false;

                end

            end

        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Laser Metadata %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % everything is stored in singles as of 1.00.60127

        % Resonetics verbose (.log)
        function laser_parameters = read_resonetics_verbose_log(app, filepath)

            progress = uiprogressdlg(app.UIFigure, 'Title', 'Import...', ...
                'Message', 'Importing laser log file', 'Cancelable', 'off', 'Indeterminate','on');

            % Open the file
            logfile = fopen(filepath, 'r');

            % Check if the file was opened successfully
            if logfile == -1
                error('Cannot open file')
            end

            % Define the patterns to search for
            pattern_pointnumbers = 'Point #(\d+)';
            pattern_spotname = 'Comment: "(.*)"';
            pattern_spotsize = 'Spot Size: (\d+) µm';
            pattern_date = '\d{4}-\d{2}-\d{2}';
            pattern_rep_rate = 'Rep\. Rate: (\d+\.?\d*) Hz';
            pattern_fired = 'Fired: (\d+)';
            pattern_laser_start = '(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}.\d{3})\tLaser Started';
            pattern_laser_stop = '(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}.\d{3})\tLaser Stopped';
            pattern_fluence = 'Requested On-Sample Fluence: (\d+\.?\d*) J\.cm';
            pattern_triggered = 'Triggered: (\d+)';
            pattern_ablation_duration = 'Laser fired for: (\d+\.?\d*) ms';
            pattern_background_duration = 'Delay 1: (\d+\.?\d*) s';
            pattern_laser_energy = 'Current Laser Energy: (\d+\.?\d*) mJ';
            pattern_laser_hv = 'Current Laser HV: (\d+\.?\d*) kV';
            pattern_gas_health = 'Current Gas Health: (\d+)%';
            pattern_he_flow = 'He MFC: Current Flow \((\d+\.?\d*) ml/min\)';
            pattern_n_flow = 'N2 MFC: Current Flow \((\d+\.?\d*) ml/min\)';
            pattern_attenuator = 'Current Attenuator: (\d+\.?\d*)%T';
            pattern_position = 'Position: \[(\d+\.?\d*) (\d+\.?\d*) (\d+\.?\d*)\]';

            % Initialize empty arrays and cells
            pointnumbers = [];
            spotsize = [];
            measuringdate = {};
            spotname = {};
            is_cleaning = false;
            found_ablation = false;
            fired = [];
            laser_start_times = {};
            laser_stop_times = {};
            rep_rates = [];
            fluences = [];
            pulses_triggered = [];
            ablation_duration = [];
            background_duration = [];
            laser_energy = [];
            laser_hv = [];
            gas_health = [];
            he_flow = [];
            n_flow = [];
            attenuator = [];
            x_position = [];
            y_position = [];
            z_position = [];

            % Temporary variables to track laser energy, HV, gas health, flows, attenuator, and position
            temp_laser_energy = single(NaN);
            temp_laser_hv = single(NaN);
            temp_gas_health = single(NaN);
            temp_he_flow = single(NaN);
            temp_n_flow = single(NaN);
            temp_attenuator = single(NaN);

            % Extract the date from the first line
            lineone = fgets(logfile);
            matches_date = regexp(lineone, pattern_date, 'match');
            if ~isempty(matches_date)
                % Rewrite the date
                date_parts = split(matches_date{1}, '-');
                measuringdate = [date_parts{3}, date_parts{2}, date_parts{1}];
            end

            % Read the file line by line
            while ~feof(logfile)
                line = fgets(logfile);

                % Check if we're in cleaning section
                if contains(line, 'Performing Cleaning')
                    is_cleaning = true;
                end

                % Reset cleaning flag when we see Rep. Rate (indicates start of new measurement)
                if contains(line, 'Rep. Rate:')
                    is_cleaning = false;
                end

                % Check for spot size (only when not in cleaning section)
                if contains(line, 'Spot Size:') && ~is_cleaning
                    matches_spotsize = regexp(line, pattern_spotsize, 'tokens');
                    if ~isempty(matches_spotsize)
                        spotsize = [spotsize; single(str2double(matches_spotsize{1}{1}))];
                    end
                end

                % Check for laser start time
                matches_start = regexp(line, pattern_laser_start, 'tokens');
                if ~isempty(matches_start)
                    laser_start_times = [laser_start_times; matches_start{1}{1}];
                end

                % Check for laser stop time
                matches_stop = regexp(line, pattern_laser_stop, 'tokens');
                if ~isempty(matches_stop)
                    laser_stop_times = [laser_stop_times; matches_stop{1}{1}];
                end

                % Check for rep rate
                matches_rep_rate = regexp(line, pattern_rep_rate, 'tokens');
                if ~isempty(matches_rep_rate)
                    rep_rates = [rep_rates; single(str2double(matches_rep_rate{1}{1}))];
                end

                % Check for fluence
                matches_fluence = regexp(line, pattern_fluence, 'tokens');
                if ~isempty(matches_fluence)
                    fluences = [fluences; single(str2double(matches_fluence{1}{1}))];
                end

                % Check for = Ablation =
                if contains(line, '= Ablation =')
                    found_ablation = true;
                end

                if contains(line, 'Triggered:') && found_ablation
                    % Get the triggered pulses
                    matches_triggered = regexp(line, pattern_triggered, 'tokens');
                    if ~isempty(matches_triggered)
                        pulses_triggered = [pulses_triggered; single(str2double(matches_triggered{1}{1}))];
                    end
                end

                % Get the fired value
                if contains(line, 'Fired:') && found_ablation
                    matches_fired = regexp(line, pattern_fired, 'tokens');
                    if ~isempty(matches_fired)
                        fired = [fired; single(str2double(matches_fired{1}{1}))];
                    end
                    found_ablation = false;
                end

                % Get the spot number
                if contains(line, 'Point #')
                    matches_pointnumbers = regexp(line, pattern_pointnumbers, 'tokens');
                    if ~isempty(matches_pointnumbers)
                        pointnumbers = [pointnumbers; single(str2double(matches_pointnumbers{1}{1}))];
                    end
                end

                % Get the spotname
                if contains(line, 'Comment:')
                    matches_spotname = regexp(line, pattern_spotname, 'tokens');
                    if ~isempty(matches_spotname)
                        spotname = [spotname; matches_spotname{1}{1}];
                    end
                end

                % Get the ablation duration
                matches_ablation_duration = regexp(line, pattern_ablation_duration, 'tokens');
                if ~isempty(matches_ablation_duration)
                    ablation_duration = [ablation_duration; single(str2double(matches_ablation_duration{1}{1}))];
                end

                % Get the background duration
                matches_background_duration = regexp(line, pattern_background_duration, 'tokens');
                if ~isempty(matches_background_duration)
                    background_duration = [background_duration; single(str2double(matches_background_duration{1}{1}))];
                end

                % Temporarily store laser energy
                matches_laser_energy = regexp(line, pattern_laser_energy, 'tokens');
                if ~isempty(matches_laser_energy)
                    temp_laser_energy = single(str2double(matches_laser_energy{1}{1}));
                end

                % Temporarily store laser HV
                matches_laser_hv = regexp(line, pattern_laser_hv, 'tokens');
                if ~isempty(matches_laser_hv)
                    temp_laser_hv = single(str2double(matches_laser_hv{1}{1}));
                end

                % Temporarily store gas health
                matches_gas_health = regexp(line, pattern_gas_health, 'tokens');
                if ~isempty(matches_gas_health)
                    temp_gas_health = single(str2double(matches_gas_health{1}{1}));
                end

                % Temporarily store He flow
                matches_he_flow = regexp(line, pattern_he_flow, 'tokens');
                if ~isempty(matches_he_flow)
                    temp_he_flow = single(str2double(matches_he_flow{1}{1}));
                end

                % Temporarily store N2 flow
                matches_n_flow = regexp(line, pattern_n_flow, 'tokens');
                if ~isempty(matches_n_flow)
                    temp_n_flow = single(str2double(matches_n_flow{1}{1}));
                end

                % Temporarily store attenuator
                matches_attenuator = regexp(line, pattern_attenuator, 'tokens');
                if ~isempty(matches_attenuator)
                    temp_attenuator = single(str2double(matches_attenuator{1}{1}));
                end

                % Store position values directly
                matches_position = regexp(line, pattern_position, 'tokens');
                if ~isempty(matches_position)
                    x_position = [x_position; single(str2double(matches_position{1}{1}))];
                    y_position = [y_position; single(str2double(matches_position{1}{2}))];
                    z_position = [z_position; single(str2double(matches_position{1}{3}))];
                end

                % Check for Point Ablation line
                if contains(line, 'Point Ablation')
                    % Save the last recorded laser energy, HV, flows, attenuator, and position
                    laser_energy = [laser_energy; temp_laser_energy];
                    laser_hv = [laser_hv; temp_laser_hv];
                    he_flow = [he_flow; temp_he_flow];
                    n_flow = [n_flow; temp_n_flow];
                    attenuator = [attenuator; temp_attenuator];
                end
            end

            fclose(logfile);

            % Replicate gas health for all entries in spotname
            gas_health = repmat(temp_gas_health, length(spotname), 1);

            % Remove entries where the laser did not fire
            for i = length(fired):-1:1
                if fired(i) == 0
                    spotname(i) = [];
                    spotsize(i) = [];
                    pointnumbers(i) = [];
                    fired(i) = [];
                    laser_start_times(i) = [];
                    laser_stop_times(i) = [];
                    rep_rates(i) = [];
                    fluences(i) = [];
                    pulses_triggered(i) = [];
                    ablation_duration(i) = [];
                    background_duration(i) = [];
                    laser_energy(i) = [];
                    laser_hv(i) = [];
                    gas_health(i) = [];
                    he_flow(i) = [];
                    n_flow(i) = [];
                    attenuator(i) = [];
                    x_position(i) = [];
                    y_position(i) = [];
                    z_position(i) = [];
                end
            end

            % Package all outputs into one struct
            laser_parameters = struct( ...
                'measuringdate', measuringdate, ...
                'pointnumbers', pointnumbers, ...
                'spotname', {spotname}, ...
                'spotsize', spotsize, ...
                'rep_rates', rep_rates, ...
                'fluences', fluences, ...
                'laser_start_times', {laser_start_times}, ...
                'laser_stop_times', {laser_stop_times}, ...
                'fired', fired, ...
                'pulses_triggered', pulses_triggered, ...
                'ablation_duration', ablation_duration, ...
                'background_duration', background_duration, ...
                'laser_energy', laser_energy, ...
                'laser_hv', laser_hv, ...
                'gas_health', gas_health, ...
                'he_flow', he_flow, ...
                'n_flow', n_flow, ...
                'attenuator', attenuator, ...
                'x_position', x_position, ...
                'y_position', y_position, ...
                'z_position', z_position ...
                );

            delete(progress)
        end

        % Resonetics (.csv)
        function laser_parameters = read_resonetics_csv_log(app, filepath)
            % Initialize variables
            laserRepRate = [];
            spotSize = [];
            he_flow = [];
            n_flow = [];
            laser_hv = [];
            laser_energy = [];
            fluence = [];
            x_position = [];
            y_position = [];
            z_position = [];
            cell_pressure = [];
            ablationDuration = [];
            laserStopTimes = [];
            backgroundDuration = [];

            opts = detectImportOptions(filepath);
            delimiter = opts.Delimiter;

            % Read log
            logData = readtable(filepath, 'Delimiter', delimiter, 'ReadVariableNames', true);

            % Extract spot names from the Comment column
            commentCol = logData.Comment;
            validComments = ~cellfun(@isempty, commentCol);

            if any(validComments)
                % Get unique spot names
                spotname = commentCol(validComments);
            else
                spotname = {};
            end

            % Find rows where LaserState is 'On'
            laserOnRows = strcmp(logData.LaserState, 'On');

            % Extract parameters on On-state rows and convert to single
            laserRepRate = single(logData.LaserRep_Rate_Hz_(laserOnRows));
            spotSize     = single(logData.SpotSize_um_(laserOnRows));
            he_flow      = single(logData.MFC1_ml_min_(laserOnRows));
            n_flow       = single(logData.MFC2_ml_min_(laserOnRows));
            laser_hv     = single(logData.LaserHV_kV_(laserOnRows));
            laser_energy = single(logData.LaserEnergy_mJ_(laserOnRows));
            fluence      = single(logData.On_SampleFluence_J_cm___(laserOnRows));
            x_position   = single(logData.X_um_(laserOnRows));
            y_position   = single(logData.Y_um_(laserOnRows));
            z_position   = single(logData.Z_um_(laserOnRows));
            cell_pressure = single(logData.CellPressure_kPa_(laserOnRows));

            % Extract laser start times and enforce a consistent display format
            fmt = 'yyyy-MM-dd HH:mm:ss.SSS';

            laserStartTimes = logData.Timestamp(laserOnRows);
            if ~isdatetime(laserStartTimes)
                % Try to parse as datetime if not already
                try
                    laserStartTimes = datetime(laserStartTimes, 'InputFormat', fmt);
                catch
                    laserStartTimes = datetime(laserStartTimes);
                end
            end
            laserStartTimes.Format = fmt;

            % Initialize arrays for durations and stop times (match format)
            n = numel(laserStartTimes);
            ablationDuration   = single(NaN(n, 1));
            backgroundDuration = single(NaN(n, 1));
            laserStopTimes     = NaT(n, 1);
            laserStopTimes.Format = fmt;

            % Compute durations using indices of On rows
            laserOnIndices = find(laserOnRows);

            for i = 1:n
                currentIndex = laserOnIndices(i);

                % Stop time is the next row's timestamp (typically LaserState 'Off')
                if currentIndex < height(logData)
                    tsStop = logData.Timestamp(currentIndex + 1);
                    if ~isdatetime(tsStop)
                        try
                            tsStop = datetime(tsStop, 'InputFormat', fmt);
                        catch
                            tsStop = datetime(tsStop);
                        end
                    end
                    laserStopTimes(i) = tsStop;

                    % Ablation duration: stop - start (convert to single)
                    ablationDuration(i) = single(seconds(laserStopTimes(i) - laserStartTimes(i)));
                end

                % Background duration: start - previous row's timestamp (convert to single)
                if currentIndex > 1
                    tsPrev = logData.Timestamp(currentIndex - 1);
                    if ~isdatetime(tsPrev)
                        try
                            tsPrev = datetime(tsPrev, 'InputFormat', fmt);
                        catch
                            tsPrev = datetime(tsPrev);
                        end
                    end
                    backgroundDuration(i) = single(seconds(laserStartTimes(i) - tsPrev));
                end
            end

            % Convert datetimes to cellstr using the same format for both
            laserStartTimes = cellstr(laserStartTimes);
            laserStopTimes  = cellstr(laserStopTimes);

            % Package into one struct
            laser_parameters = struct( ...
                'spotname', {spotname}, ...
                'rep_rates', laserRepRate, ...
                'spotsize', spotSize, ...
                'he_flow', he_flow, ...
                'n_flow', n_flow, ...
                'laser_hv', laser_hv, ...
                'laser_energy', laser_energy, ...
                'fluences', fluence, ...
                'x_position', x_position, ...
                'y_position', y_position, ...
                'z_position', z_position, ...
                'cell_pressure', cell_pressure, ...
                'laser_start_times', {laserStartTimes}, ...
                'ablation_duration', ablationDuration, ...
                'laser_stop_times', {laserStopTimes}, ...
                'background_duration', backgroundDuration ...
                );
        end

        % Agilent/Teledyne .iolite (.csv) (Marco Zamora, Queensland) / Pol Castellano
        % Granada / Thorsten Singapore
        function laser_parameters = read_agilent_iolite_csv_log(app, filepath)

            % Initialize variables
            laserRepRate = [];
            spotSize = [];
            x_position = [];
            y_position = [];
            ablationDuration = [];
            laserStopTimes = [];
            backgroundDuration = [];

            opts = detectImportOptions(filepath);
            delimiter = opts.Delimiter;

            % Read the CSV log file
            logData = readtable(filepath, 'Delimiter', delimiter, 'ReadVariableNames', true);

            % Extract spot names from the Comment column
            commentCol = logData.Comment;
            validComments = ~cellfun(@isempty, commentCol);

            if any(validComments)
                % Get unique spot names
                spotname = commentCol(validComments);
            else
                spotname = {};
            end

            % Find rows where LaserState is 'On'
            laserOnRows = strcmp(logData.LaserState, 'On');

            % Extract relevant data for 'On' rows and convert to single
            laserRepRate = single(logData.LaserRep_Rate(laserOnRows));
            x_position = single(logData.X(laserOnRows));
            y_position = single(logData.Y(laserOnRows));

            spotSizeData = logData.SpotSize(laserOnRows);
            if iscell(spotSizeData)
                % Extract first number from cell strings like '50 x 50'
                firstValue = regexp(spotSizeData{1}, '\d+', 'match', 'once');
                spotSizeValue = single(str2double(firstValue));
                % Replicate for all entries
                spotSize = repmat(spotSizeValue, length(spotSizeData), 1);
            else
                % Already numeric
                spotSize = single(spotSizeData);
            end

            % Convert timestamps to datetime
            logData.Timestamp = datetime(logData.Timestamp, 'InputFormat', 'mm:ss.S');

            % Assuming laserStartTimes is your datetime array
            logData.Timestamp = logData.Timestamp; % Copy the original array

            % Loop through the array and fix the hours
            for i = 2:length(logData.Timestamp)
                if logData.Timestamp(i) < logData.Timestamp(i-1)
                    % If the current time is earlier than the previous time, add 1 hour
                    logData.Timestamp(i:end) = logData.Timestamp(i:end) + hours(1);
                end
            end

            % Extract laser start times
            laserStartTimes = logData.Timestamp(laserOnRows);

            % Initialize arrays for ablationDuration, laserStopTimes, and backgroundDuration (as single)
            ablationDuration = single(NaN(size(laserStartTimes)));
            laserStopTimes = NaT(size(laserStartTimes));
            backgroundDuration = single(NaN(size(laserStartTimes)));

            % Find indices of rows where LaserState is 'On'
            laserOnIndices = find(laserOnRows);

            % Loop through laserOnIndices to calculate durations
            for i = 1:length(laserOnIndices) % Start from the second index
                currentIndex = laserOnIndices(i);

                % Calculate ablation duration (convert to single)
                if currentIndex < height(logData)
                    laserStopTimes(i) = logData.Timestamp(currentIndex + 1);
                    ablationDuration(i) = single(seconds(laserStopTimes(i) - laserStartTimes(i)));
                end

                % Calculate background duration (convert to single)
                if currentIndex == 4
                    backgroundDuration(i) = single(15);
                elseif currentIndex > 4
                    previousTimestamp = logData.Timestamp(currentIndex - 4);
                    backgroundDuration(i) = single(seconds(laserStartTimes(i) - previousTimestamp));
                end

            end

            % Convert datetime arrays to cell arrays of strings (if needed)
            laserStartTimes = cellstr(laserStartTimes);
            laserStopTimes = cellstr(laserStopTimes);

            % Package into one struct
            laser_parameters = struct( ...
                'spotname', {spotname}, ...
                'rep_rates', laserRepRate, ...
                'spotsize', spotSize, ...
                'x_position', x_position, ...
                'y_position', y_position, ...
                'laser_start_times', {laserStartTimes}, ...
                'ablation_duration', ablationDuration, ...
                'laser_stop_times', {laserStopTimes}, ...
                'background_duration', backgroundDuration ...
                );
        end

        % Teledyne ScanData (.csv)
        function laser_parameters = read_teledyne_scan_data_csv(app, filepath)

            % Initialize variables
            spotname = {};
            x_position = [];
            y_position = [];
            z_position = [];
            laserStartTimes = {};
            laserStopTimes = {};
            ablationDuration = [];
            backgroundDuration = [];

            % Read the CSV file as text
            fileID = fopen(filepath, 'r');
            fileContent = textscan(fileID, '%s', 'Delimiter', '\n');
            fclose(fileID);
            lines = fileContent{1};

            opts = detectImportOptions(filepath);
            delimiter = opts.Delimiter;

            currentSpot = '';
            spotIndex = 0;

            % Parse each line
            for i = 1:length(lines)
                line = strtrim(lines{i});

                % Skip empty lines
                if isempty(line)
                    continue;
                end

                % Split by tab delimiter
                parts = strsplit(line, delimiter);

                % Check if this is a spot name line (lines that don't contain dots)
                if ~contains(parts{1}, '.') && ~strcmp(parts{1}, 'SpotCount')
                    currentSpot = parts{1};
                    spotIndex = spotIndex + 1;
                    spotname{spotIndex} = currentSpot;
                    continue;
                end

                % Extract position data
                if contains(parts{1}, 'Position.Start')
                    x_position(spotIndex) = single(str2double(parts{2}));
                    y_position(spotIndex) = single(str2double(parts{3}));
                    z_position(spotIndex) = single(str2double(parts{4}));
                end

                % Extract laser on time
                if contains(parts{1}, 'Time.LaserOn')
                    laserStartTimes{spotIndex} = strtrim(parts{2});
                end

                % Extract laser off time
                if contains(parts{1}, 'Time.LaserOff')
                    laserStopTimes{spotIndex} = strtrim(parts{2});
                end
            end

            % Convert times to datetime and calculate ablation duration
            laserStartDT = datetime(laserStartTimes, 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSS');
            laserStopDT = datetime(laserStopTimes, 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSS');

            % Calculate ablation duration in seconds
            ablationDuration = single(seconds(laserStopDT - laserStartDT));

            % Calculate background duration (time since previous laser off)
            backgroundDuration = single(NaN(size(ablationDuration)));
            for i = 2:length(laserStartDT)
                backgroundDuration(i) = single(seconds(laserStartDT(i) - laserStopDT(i-1)));
            end

            % For first spot, set a default background duration
            if ~isempty(backgroundDuration)
                backgroundDuration(1) = single(15);
            end

            % Package into struct (keeping same field names as original)
            laser_parameters = struct( ...
                'spotname', {spotname'}, ...
                'x_position', single(x_position'), ...
                'y_position', single(y_position'), ...
                'z_position', single(z_position'), ...
                'laser_start_times', {laserStartTimes'}, ...
                'ablation_duration', ablationDuration', ...
                'laser_stop_times', {laserStopTimes'}, ...
                'background_duration', backgroundDuration' ...
                );
        end

        % ESL csv (Active View 2.)
        function laser_parameters = read_esl_csv_log(app, filepath)

            % Initialize variables
            laserRepRate = [];
            spotSize = [];
            x_position = [];
            y_position = [];
            ablationDuration = [];
            laserStopTimes = [];
            backgroundDuration = [];

            % Read the CSV log file
            logData = readtable(filepath, 'VariableNamesLine', 1);

            % Extract spot names from the Comment column
            commentCol = logData.Comment;
            validComments = ~cellfun(@isempty, commentCol);

            if any(validComments)
                % Get unique spot names
                spotname = commentCol(validComments);
            else
                spotname = {};
            end

            % Find rows where LaserState is 'On'
            laserOnRows = strcmp(logData.LaserState, 'On');

            % Extract relevant data for 'On' rows and convert to single
            laserRepRate = single(logData.LaserRep_Rate_Hz_(laserOnRows));
            spotSize = single(logData.SpotSize_um_(laserOnRows));
            x_position = single(logData.X_um_(laserOnRows));
            y_position = single(logData.Y_um_(laserOnRows));

            % Convert timestamps to datetime
            logData.Timestamp = datetime(logData.Timestamp, 'InputFormat', 'mm:ss.S');

            % Assuming laserStartTimes is your datetime array
            logData.Timestamp = logData.Timestamp; % Copy the original array

            % Loop through the array and fix the hours
            for i = 2:length(logData.Timestamp)
                if logData.Timestamp(i) < logData.Timestamp(i-1)
                    % If the current time is earlier than the previous time, add 1 hour
                    logData.Timestamp(i:end) = logData.Timestamp(i:end) + hours(1);
                end
            end

            % Extract laser start times
            laserStartTimes = logData.Timestamp(laserOnRows);

            % Initialize arrays for ablationDuration, laserStopTimes, and backgroundDuration (as single)
            ablationDuration = single(NaN(size(laserStartTimes)));
            laserStopTimes = NaT(size(laserStartTimes));
            backgroundDuration = single(NaN(size(laserStartTimes)));

            % Find indices of rows where LaserState is 'On'
            laserOnIndices = find(laserOnRows);

            % Loop through laserOnIndices to calculate durations
            for i = 1:length(laserOnIndices) % Start from the second index
                currentIndex = laserOnIndices(i);

                % Calculate ablation duration (convert to single)
                if currentIndex < height(logData)
                    laserStopTimes(i) = logData.Timestamp(currentIndex + 1);
                    ablationDuration(i) = single(seconds(laserStopTimes(i) - laserStartTimes(i)));
                end

                % Calculate background duration (convert to single)
                if currentIndex == 3
                    backgroundDuration(i) = single(15);
                elseif currentIndex > 3
                    previousTimestamp = logData.Timestamp(currentIndex - 1);
                    backgroundDuration(i) = single(seconds(laserStartTimes(i) - previousTimestamp));
                end

            end
            % Convert datetime arrays to cell arrays of strings (if needed)
            laserStartTimes = cellstr(laserStartTimes);
            laserStopTimes = cellstr(laserStopTimes);

            % Package into one struct
            laser_parameters = struct( ...
                'spotname', {spotname}, ...
                'rep_rates', laserRepRate, ...
                'spotsize', spotSize, ...
                'x_position', x_position, ...
                'y_position', y_position, ...
                'laser_start_times', {laserStartTimes}, ...
                'ablation_duration', ablationDuration, ...
                'laser_stop_times', {laserStopTimes}, ...
                'background_duration', backgroundDuration ...
                );
        end

        % Resonetics logbook (.xlsx) / Belousov Tasmania
        function laser_parameters = read_resonetics_logbook(app, filepath)

            % Initialize variables
            laserRepRate = [];
            spotSize = [];
            laser_energy = [];
            fluence = [];
            x_position = [];
            y_position = [];
            z_position = [];
            sample = [];
            type = [];
            spotname = [];

            logData = readtable(filepath);

            % Extract spot names from the Comment column
            commentCol = logData.DataIdent;

            % Find rows that contain spot names (non-empty comments)
            validComments = ~cellfun(@isempty, commentCol);

            if any(validComments)
                % Get spot names
                spotname = commentCol(validComments);
            else
                spotname = {};
            end

            laserRepRate = single(str2double(logData.LaserFrequency));
            spotSize = single(str2double(logData.BeamSize));
            laser_energy = single(str2double(logData.LaserEnergy));
            fluence = single(logData.LaserFluence);

            sample = logData.Sample;

            type = string(logData.SampleType);
            for i = 1:length(type)
                if strcmp(type(i), 'Primary')
                    type(i) = "PRM";
                elseif strcmp(type(i), 'Sample')
                    type(i) = "Unknown";
                elseif strcmp(type(i), 'Secondary')
                    type(i) = "SRM";
                elseif strcmp(type(i), 'Primary_Secondary')
                    type(i) = "PRM";
                end
            end

            refmat = repmat("None", size(type));

            % Assuming logData.Geometry1 is the given cell array
            geometryData = logData.Geometry1;

            % Initialize cell arrays for x, y, and z
            x = cell(size(geometryData));
            y = cell(size(geometryData));
            z = cell(size(geometryData));

            % Loop through each cell and extract x, y, z values
            for i = 1:length(geometryData)
                % Extract the string and convert it to a numeric array (as single)
                values = single(sscanf(geometryData{i}, '[%f %f %f]'));
                x{i} = values(1);
                y{i} = values(2);
                z{i} = values(3);
            end

            x_position = single(cell2mat(x));
            y_position = single(cell2mat(y));
            z_position = single(cell2mat(z));

            % Package into one struct
            laser_parameters = struct( ...
                'spotname', {spotname}, ...
                'rep_rates', laserRepRate, ...
                'spotsize', spotSize, ...
                'laser_energy', laser_energy, ...
                'fluences', fluence, ...
                'x_position', x_position, ...
                'y_position', y_position, ...
                'z_position', z_position ...
                );

        end

        % Teledyne Iridia (.lase)
        function laser_parameters = read_teledyne_iridia_lase(app, filepath)
            % Read Teledyne Iridia .lase file and return a struct of column arrays.

            lines = readlines(filepath, "EmptyLineRule","skip");
            lines = strip(lines);

            % Find [Scans] section
            scansStart = find(lines == "[Scans]", 1, "first");
            if isempty(scansStart)
                error("read_teledyne_iridia_lase:NoScansSection", "No [Scans] section found.");
            end
            nextSectionRel = find(startsWith(lines(scansStart+1:end), "["), 1, "first");
            if isempty(nextSectionRel)
                section = lines(scansStart+1:end);
            else
                section = lines(scansStart+1 : scansStart+nextSectionRel-1);
            end

            % Parse Header=
            hIdx = find(startsWith(section, "Header="), 1, "first");
            if isempty(hIdx)
                error("read_teledyne_iridia_lase:NoHeader", "No Header= line found in [Scans].");
            end
            headerStr = extractAfter(section(hIdx), "Header=");
            headers = parseCSV(headerStr);
            nHeaders = numel(headers);

            % Collect Scan lines
            scanLines = section(startsWith(section, "Scan"));
            n = numel(scanLines);
            if n == 0
                warning("read_teledyne_iridia_lase:NoScans", "No Scan lines found.");
                out = struct();
                return
            end

            % Preallocate (using single for numeric)
            scankey     = strings(n,1);
            scantype    = strings(n,1);
            description = strings(n,1);
            selected    = single(NaN(n,1));
            lockedit    = single(NaN(n,1));
            vertexcount = single(NaN(n,1));
            vertexlist  = single(NaN(n,3));

            preSettings = cell(n,1);
            ablSettings = cell(n,1);
            dataSettings= cell(n,1);

            % Header index map
            H = lower(strrep(headers, " ", ""));
            idxScanType    = find(H == "scantype", 1);
            idxDescription = find(H == "description", 1);
            idxSelected    = find(H == "selected", 1);
            idxLockEdit    = find(H == "lockedit", 1);
            idxVertexCount = find(H == "vertexcount", 1);
            idxVertexList  = find(H == "vertexlist", 1);
            idxPreablation = find(H == "preablationsettings", 1);
            idxAblation    = find(H == "ablationsettings", 1);
            idxData        = find(H == "data", 1);

            % Iterate scans
            for i = 1:n
                ln = scanLines(i);

                % Split at first '='
                eqPos = strfind(ln, "=");
                if isempty(eqPos)
                    error("read_teledyne_iridia_lase:MalformedLine", "Malformed scan line at index %d", i);
                end
                scankey(i) = strtrim(extractBefore(ln, eqPos(1)));
                valuePart  = extractAfter(ln,  eqPos(1));

                % CSV split for this line (respect quotes)
                tokens = parseCSV(valuePart);
                if numel(tokens) ~= nHeaders
                    error("read_teledyne_iridia_lase:FieldCountMismatch", ...
                        "Line %d: expected %d fields, got %d", i, nHeaders, numel(tokens));
                end

                % Assign simple fields (convert to single)
                if ~isempty(idxScanType),    scantype(i)    = tokens(idxScanType);    end
                if ~isempty(idxDescription), description(i) = tokens(idxDescription); end
                if ~isempty(idxSelected),    selected(i)    = single(str2double(tokens(idxSelected))); end
                if ~isempty(idxLockEdit),    lockedit(i)    = single(str2double(tokens(idxLockEdit))); end
                if ~isempty(idxVertexCount), vertexcount(i) = single(str2double(tokens(idxVertexCount))); end

                % Vertex list "x,y,z" (convert to single)
                if ~isempty(idxVertexList)
                    vraw = stripQuotes(tokens(idxVertexList));
                    if strlength(vraw) > 0
                        vp = split(vraw, ",");
                        if numel(vp) >= 3
                            vertexlist(i,1) = single(str2double(vp(1)));
                            vertexlist(i,2) = single(str2double(vp(2)));
                            vertexlist(i,3) = single(str2double(vp(3)));
                        end
                    end
                end

                % Parse Preablation settings
                if ~isempty(idxPreablation)
                    preSettings{i} = parseKeyValueStruct(tokens(idxPreablation));
                end

                % Parse Ablation settings
                if ~isempty(idxAblation)
                    ablSettings{i} = parseKeyValueStruct(tokens(idxAblation));
                end

                % Parse Data
                if ~isempty(idxData)
                    dataSettings{i} = parseKeyValueStruct(tokens(idxData));
                end
            end

            % Build table
            tbl = table();
            tbl.scankey     = scankey;
            tbl.scantype    = scantype;
            tbl.description = description;
            tbl.selected    = selected;
            tbl.lockedit    = lockedit;
            tbl.vertexcount = vertexcount;
            tbl.vertexx     = vertexlist(:,1);
            tbl.vertexy     = vertexlist(:,2);
            tbl.vertexz     = vertexlist(:,3);

            % Flatten nested settings into columns
            tbl = addSettings(tbl, preSettings,  'pre');
            tbl = addSettings(tbl, ablSettings,  'abl');
            tbl = addSettings(tbl, dataSettings, 'data');

            % Convert to scalar struct of column arrays
            out = table2struct(tbl, 'ToScalar', true);

            % ===== Local helpers =====

            function tokens = parseCSV(strv)
                % Split comma-separated values respecting quotes
                s = char(strv);
                tokens = strings(0,1);
                buf = '';
                inQuotes = false;
                for k = 1:numel(s)
                    c = s(k);
                    if c == '"'
                        inQuotes = ~inQuotes;
                    elseif c == ',' && ~inQuotes
                        tokens(end+1,1) = strtrim(string(stripQuotes(string(buf)))); %#ok<AGROW>
                        buf = '';
                        continue
                    end
                    buf = [buf c]; %#ok<AGROW>
                end
                tokens(end+1,1) = strtrim(string(stripQuotes(string(buf))));
            end

            function s2 = stripQuotes(s1)
                % Remove surrounding double quotes if present
                if strlength(s1) >= 2 && startsWith(s1, '"') && endsWith(s1, '"')
                    s2 = extractBetween(s1, 2, strlength(s1)-1);
                else
                    s2 = s1;
                end
            end

            function S = parseKeyValueStruct(token)
                kv = stripQuotes(token);
                S = struct();
                if strlength(kv) == 0
                    return
                end
                items = split(kv, ";");
                for t = 1:numel(items)
                    item = strtrim(items(t));
                    if strlength(item) == 0, continue; end
                    eq = strfind(item, "=");
                    if isempty(eq), continue; end
                    key = strtrim(extractBefore(item, eq(1)));
                    val = strtrim(extractAfter(item,  eq(1)));
                    if strlength(key) == 0, continue; end
                    fld = matlab.lang.makeValidName(key);

                    num = str2double(val);
                    if ~isnan(num)
                        S.(fld) = single(num);  % Convert to single
                    elseif ~isempty(regexp(val, '^\d{4}/\d{2}/\d{2}\s+\d{2}:\d{2}:\d{2}(\.\d{3})?$', 'once'))
                        try
                            S.(fld) = datetime(val, 'InputFormat','yyyy/MM/dd HH:mm:ss.SSS');
                        catch
                            S.(fld) = datetime(val, 'InputFormat','yyyy/MM/dd HH:mm:ss');
                        end
                    else
                        S.(fld) = val;
                    end
                end
            end

            function T = addSettings(T, C, prefix)
                % Add columns for a cell array of structs C with prefix
                flds = strings(0,1);
                for k = 1:numel(C)
                    S = C{k};
                    if isempty(S), continue; end
                    flds = union(flds, string(fieldnames(S)));
                end
                if isempty(flds), return; end

                nrows = height(T);
                for f = flds.'
                    fname = char(f);
                    % Determine column class from first non-empty value
                    cls = '';
                    for k = 1:numel(C)
                        S = C{k};
                        if isempty(S) || ~isfield(S, fname), continue; end
                        v = S.(fname);
                        if ~isempty(v)
                            cls = class(v);
                            break
                        end
                    end
                    % Allocate column (use single for numeric)
                    switch cls
                        case {'double', 'single'}
                            col = single(NaN(nrows,1));
                        case 'datetime'
                            col = NaT(nrows,1);
                        otherwise
                            col = strings(nrows,1); col(:) = missing;
                    end
                    % Fill column
                    for k = 1:numel(C)
                        S = C{k};
                        if isempty(S) || ~isfield(S, fname), continue; end
                        v = S.(fname);
                        if isempty(v), continue; end
                        switch cls
                            case {'double', 'single'}
                                col(k) = single(v);
                            case 'datetime'
                                col(k) = v;
                            otherwise
                                col(k) = string(v);
                        end
                    end
                    vname = matlab.lang.makeValidName(lower(prefix) + "_" + lower(fname));
                    T.(vname) = col;
                end
            end

            % renaming to fit other data (convert to single)
            spotsize_um = single(str2double(extractBefore(out.abl_laser_spotsize, 'µm')));

            % Build renamed struct from 'out'
            laser_parameters = struct( ...
                'spotname',           out.description, ...
                'spotsize',           spotsize_um, ...
                'x_position',         out.vertexx, ...
                'y_position',         out.vertexy, ...
                'z_position',         out.vertexz, ...
                'rep_rates',          out.abl_laser_reprate, ...
                'fluences',           out.abl_laser_fluence, ...
                'laser_start_times',  out.data_spot0_pass1_time_laseron, ...
                'laser_stop_times',   out.data_spot0_pass1_time_laseroff, ...
                'laser_hv',           out.data_ablation_laser_kv, ...
                'fired',              out.abl_shotcount, ...
                'laser_energy',       out.abl_laser_output ...
                );

            % calculate the ablation and background durations from the
            % laser on and off times.

            % Use the timestamps from the struct
            laserStartTimes = laser_parameters.laser_start_times;
            laserStopTimes  = laser_parameters.laser_stop_times;

            % Ensure column vectors and align lengths
            laserStartTimes = laserStartTimes(:);
            laserStopTimes  = laserStopTimes(:);
            n = min(numel(laserStartTimes), numel(laserStopTimes));
            laserStartTimes = laserStartTimes(1:n);
            laserStopTimes  = laserStopTimes(1:n);

            % Ablation duration: stop - start (seconds). NaT will yield NaN. Convert to single.
            ablationDuration = single(seconds(laserStopTimes - laserStartTimes));

            % Background duration: time between previous stop and current start (as single)
            backgroundDuration = single(NaN(n,1));
            if n > 1
                backgroundDuration(2:end) = single(seconds(laserStartTimes(2:end) - laserStopTimes(1:end-1)));
                % Optional: treat overlaps as missing
                backgroundDuration(backgroundDuration < 0) = single(median(backgroundDuration, 'omitnan'));
            end

            % Store results
            laser_parameters.ablation_duration   = ablationDuration;
            laser_parameters.background_duration = backgroundDuration;

            % Convert datetime arrays to cell array of strings with milliseconds
            laser_parameters.laser_start_times = cellstr(string(laser_parameters.laser_start_times, 'yyyy-MM-dd HH:mm:ss.SSS'));
            laser_parameters.laser_stop_times  = cellstr(string(laser_parameters.laser_stop_times,  'yyyy-MM-dd HH:mm:ss.SSS'));

        end

        %%%% LA_Metadata_Template.xlsx
        function laser_parameters = read_la_template_xlsx(app, filepath)

            % Read the Excel file (read text as string for easier missing handling)
            data = readtable(filepath, 'ReadVariableNames', true, 'TextType', 'string');

            laser_parameters = struct();
            varNames = data.Properties.VariableNames;

            % Ensure spotname exists and fill missing/empty entries with "No spotname"
            idxSpot = find(strcmpi(varNames, 'spotname'), 1);
            if ~isempty(idxSpot)
                vn = varNames{idxSpot};
                col = data.(vn);
                % Normalize to string
                if iscell(col)
                    col = string(col);
                end
                % Replace missing/empty/blank with "No spotname"
                missingMask = ismissing(col) | strlength(strtrim(col)) == 0;
                col(missingMask) = "No spotname";
                laser_parameters.spotname = col;
            else
                % No spotname column -> create default
                laser_parameters.spotname = repmat("No spotname", height(data), 1);
            end

            % Add other columns only if not fully empty/NaN
            for k = 1:numel(varNames)
                vn = varNames{k};
                if strcmpi(vn, 'spotname')
                    continue
                end
                col = data.(vn);
                if ~isAllMissingColumn(col)
                    % Convert numeric columns to single
                    if isnumeric(col)
                        col = single(col);
                    end
                    laser_parameters.(vn) = col;
                end
            end

            function tf = isAllMissingColumn(col)
                % Returns true if the entire column is empty/NaN/missing/blank
                if isnumeric(col)
                    tf = isempty(col) || all(isnan(col), 'all');
                elseif islogical(col)
                    % Logical doesn't have NaN; treat as not fully missing
                    tf = false;
                elseif isstring(col)
                    tf = isempty(col) || all(ismissing(col) | strlength(strtrim(col)) == 0);
                elseif iscell(col)
                    if isempty(col)
                        tf = true;
                        return
                    end
                    % Mixed cell content handling
                    tf = all(cellfun(@(x) ...
                        (isempty(x)) || ...
                        (isnumeric(x) && isnan(x)) || ...
                        (isstring(x) && (ismissing(x) || strlength(strtrim(x)) == 0)) || ...
                        (ischar(x)   && (isempty(x) || all(isspace(x)))) ...
                        , col));
                elseif isdatetime(col) || isduration(col) || iscategorical(col)
                    tf = isempty(col) || all(ismissing(col));
                else
                    % Fallback: keep the column
                    tf = false;
                end
            end

        end

        % Resonetics (.csv) for linescans
        function laser_parameters = read_resonetics_csv_log_linescan(app, filepath)

            % Initialize variables
            laserRepRate = [];
            spotSize = [];
            he_flow = [];
            n_flow = [];
            laser_hv = [];
            laser_energy = [];
            fluence = [];
            x_position_start = [];
            y_position_start  = [];
            z_position_start  = [];
            x_position_stop = [];
            y_position_stop = [];
            z_position_stop = [];
            cell_pressure = [];
            ablationDuration = [];
            laserStopTimes = [];
            backgroundDuration = [];
            scan_speed_mm_s = [];

            opts = detectImportOptions(filepath);
            delimiter = opts.Delimiter;

            % Read log
            logData = readtable(filepath, 'Delimiter', delimiter, 'ReadVariableNames', true);

            % Extract spot names from the Comment column
            commentCol = logData.Comment;
            validComments = ~cellfun(@isempty, commentCol);

            if any(validComments)
                % Get unique spot names
                spotname = commentCol(validComments);
            else
                spotname = {};
            end

            two_Indices = find(logData.VertixNumber == 2);
            base_index = two_Indices(2:2:end);

            % Extract parameters on On-state rows and convert to single
            laserRepRate = single(logData.LaserRep_Rate_Hz_(base_index-1));
            spotSize     = single(logData.SpotSize_um_(base_index-1));
            he_flow      = single(logData.MFC1_ml_min_(base_index-1));
            n_flow       = single(logData.MFC2_ml_min_(base_index-1));
            laser_hv     = single(logData.LaserHV_kV_(base_index-1));
            laser_energy = single(logData.LaserEnergy_mJ_(base_index-1));
            fluence      = single(logData.On_SampleFluence_J_cm___(base_index-1));
            cell_pressure = single(logData.CellPressure_kPa_(base_index-1));
            scan_speed_mm_s = single(logData.ScanVelocity_um_s_(base_index).*0.001);

            x_position_start = single(logData.X_um_(base_index-1));
            y_position_start  = single(logData.Y_um_(base_index-1));
            z_position_start = single(logData.Z_um_(base_index-1));

            x_position_stop = single(logData.X_um_(base_index+1));
            y_position_stop   = single(logData.Y_um_(base_index+1));
            z_position_stop  = single(logData.Z_um_(base_index+1));


            % Extract laser start times and enforce a consistent display format
            fmt = 'yyyy-MM-dd HH:mm:ss.SSS';

            laserStartTimes = logData.Timestamp(base_index-1);
            laserStopTimes = logData.Timestamp(base_index+1);

            if ~isdatetime(laserStartTimes)
                % Try to parse as datetime if not already
                try
                    laserStartTimes = datetime(laserStartTimes, 'InputFormat', fmt);
                catch
                    laserStartTimes = datetime(laserStartTimes);
                end
            end
            laserStartTimes.Format = fmt;

            if ~isdatetime(laserStopTimes)
                % Try to parse as datetime if not already
                try
                    laserStopTimes = datetime(laserStopTimes, 'InputFormat', fmt);
                catch
                    laserStopTimes = datetime(laserStopTimes);
                end
            end
            laserStopTimes.Format = fmt;

            % Ablation duration: stop - start (convert to single)
            ablationDuration = single(seconds(laserStopTimes - laserStartTimes));


            background_start = logData.Timestamp(base_index-7);
            background_stop = logData.Timestamp(base_index-6);

            backgroundDuration = single(seconds(background_stop - background_start));


            % Convert datetimes to cellstr using the same format for both
            laserStartTimes = cellstr(laserStartTimes);
            laserStopTimes  = cellstr(laserStopTimes);


            % Package into one struct
            laser_parameters = struct( ...
                'spotname', {spotname}, ...
                'rep_rates', laserRepRate, ...
                'spotsize', spotSize, ...
                'he_flow', he_flow, ...
                'n_flow', n_flow, ...
                'laser_hv', laser_hv, ...
                'laser_energy', laser_energy, ...
                'fluences', fluence, ...
                'x_position_start', x_position_start, ...
                'y_position_start', y_position_start, ...
                'z_position_start', z_position_start, ...
                'x_position_stop', x_position_stop, ...
                'y_position_stop', y_position_stop, ...
                'z_position_stop', z_position_stop, ...
                'cell_pressure', cell_pressure, ...
                'laser_start_times', {laserStartTimes}, ...
                'ablation_duration', ablationDuration, ...
                'laser_stop_times', {laserStopTimes}, ...
                'background_duration', backgroundDuration, ...
                'scan_speed_mm_s', scan_speed_mm_s ...
                );
        end

        % Resonetics verbose (.log) for linescans
        function laser_parameters = read_resonetics_verbose_log_linescan(app, filepath)
            progress = uiprogressdlg(app.UIFigure,'Title','Import...','Message','Importing path ablation log file','Cancelable','off','Indeterminate','on');

            fid = fopen(filepath,'r');
            if fid == -1, error('Cannot open file'); end

            % Patterns
            pat_date          = '\d{4}-\d{2}-\d{2}';
            pat_pointnumber   = 'Point #(\d+)';
            pat_spotname      = 'Comment: "(.*)"';
            pat_fluence       = 'Requested On-Sample Fluence: (\d+\.?\d*) J\.cm';
            pat_rep_rate      = 'Rep\. Rate: (\d+\.?\d*) Hz';
            pat_triggered     = 'Triggered: (\d+)';
            pat_fired         = 'Fired: (\d+)';
            pat_delay1        = 'Delay 1: (\d+\.?\d*) s';
            pat_laser_energy  = 'Current Laser Energy: (\d+\.?\d*) mJ';
            pat_laser_hv      = 'Current Laser HV: (\d+\.?\d*) kV';
            pat_he_flow       = 'He MFC: Current Flow \((\d+\.?\d*) m[Ll]/min\)';
            pat_n2_flow       = 'N2 MFC: Current Flow \((\d+\.?\d*) m[Ll]/min\)';
            pat_attenuator    = 'Current Attenuator: (\d+\.?\d*)%T';
            pat_vertexes      = 'Vertexes: \[(\d+\.?\d*) (\d+\.?\d*) (\d+\.?\d*)\]\[(\d+\.?\d*) (\d+\.?\d*) (\d+\.?\d*)\]';
            pat_path_length   = 'Path Length: (\d+\.?\d*) µm';
            pat_scan_speed    = 'Scan Speed: (\d+\.?\d*) mm/s';
            pat_spotsize      = 'Set Spot Size: (\d+\.?\d*) µm';
            pat_laser_start = '(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3})\tLaser (?:stage triggering enabled|Started)\.?';
            pat_laser_stop  = '(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3})\tLaser (?:stage triggering disabled|Stopped)\.?';

            % Containers
            measuringdate       = {};
            pointnumbers        = [];
            spotname            = {};
            fluences            = [];
            rep_rates           = [];
            pulses_triggered    = [];
            fired               = [];
            background_duration = [];
            laser_energy        = [];
            laser_hv            = [];
            he_flow             = [];
            n_flow              = [];
            attenuator          = [];
            x_position_start    = [];
            y_position_start    = [];
            z_position_start    = [];
            x_position_end      = [];
            y_position_end      = [];
            z_position_end      = [];
            path_length         = [];
            scan_speed_mm_s     = [];
            spotsize            = [];
            laser_start_times   = {};
            laser_stop_times    = {};

            % State
            in_main_ablation    = false;
            found_ablation_block = false;

            % Temp instrumentation (use single)
            temp_energy = single(NaN);
            temp_hv = single(NaN);
            temp_he = single(NaN);
            temp_n2 = single(NaN);
            temp_att = single(NaN);

            % Date
            firstLine = fgets(fid);
            mdate = regexp(firstLine, pat_date, 'match');
            if ~isempty(mdate), measuringdate = {mdate{1}}; end
            fseek(fid,0,'bof');

            while ~feof(fid)
                line = fgets(fid);
                if ~ischar(line), break; end

                m = regexp(line, pat_spotname, 'tokens');
                if ~isempty(m), spotname = [spotname; m{1}{1}]; end

                m = regexp(line, pat_pointnumber, 'tokens');
                if ~isempty(m), pointnumbers = [pointnumbers; single(str2double(m{1}{1}))]; end

                m = regexp(line, pat_fluence, 'tokens');
                if ~isempty(m), fluences = [fluences; single(str2double(m{1}{1}))]; end

                m = regexp(line, pat_vertexes, 'tokens');
                if ~isempty(m)
                    t = m{1};
                    x_position_start = [x_position_start; single(str2double(t{1}))];
                    y_position_start = [y_position_start; single(str2double(t{2}))];
                    z_position_start = [z_position_start; single(str2double(t{3}))];
                    x_position_end   = [x_position_end;   single(str2double(t{4}))];
                    y_position_end   = [y_position_end;   single(str2double(t{5}))];
                    z_position_end   = [z_position_end;   single(str2double(t{6}))];

                    laser_energy = [laser_energy; temp_energy];
                    laser_hv     = [laser_hv;     temp_hv];
                    he_flow      = [he_flow;      temp_he];
                    n_flow       = [n_flow;       temp_n2];
                    attenuator   = [attenuator;   temp_att];

                    rep_rates           = [rep_rates; single(NaN)];
                    spotsize            = [spotsize; single(NaN)];
                    path_length         = [path_length; single(NaN)];
                    scan_speed_mm_s     = [scan_speed_mm_s; single(NaN)];
                    background_duration = [background_duration; single(NaN)];
                    pulses_triggered    = [pulses_triggered; single(NaN)];
                    fired               = [fired; single(NaN)];
                end

                m = regexp(line, pat_path_length, 'tokens');
                if ~isempty(m), path_length(end) = single(str2double(m{1}{1})); end

                if contains(line,'Main Ablation'), in_main_ablation = true; end


                m = regexp(line, pat_laser_start, 'tokens');
                if ~isempty(m) && in_main_ablation, laser_start_times = [laser_start_times; m{1}{1}]; end
                m = regexp(line, pat_laser_stop, 'tokens');
                if ~isempty(m) && in_main_ablation, laser_stop_times = [laser_stop_times; m{1}{1}]; end

                m = regexp(line, pat_scan_speed, 'tokens');
                if ~isempty(m) && in_main_ablation, scan_speed_mm_s(end) = single(str2double(m{1}{1})); end

                m = regexp(line, pat_rep_rate, 'tokens');
                if ~isempty(m) && in_main_ablation, rep_rates(end) = single(str2double(m{1}{1})); end

                m = regexp(line, pat_spotsize, 'tokens');
                if ~isempty(m) && in_main_ablation, spotsize(end) = single(str2double(m{1}{1})); end

                m = regexp(line, pat_delay1, 'tokens');
                if ~isempty(m), background_duration(end) = single(str2double(m{1}{1})); end

                m = regexp(line, pat_laser_energy, 'tokens'); if ~isempty(m), temp_energy = single(str2double(m{1}{1})); end
                m = regexp(line, pat_laser_hv, 'tokens');     if ~isempty(m), temp_hv     = single(str2double(m{1}{1})); end
                m = regexp(line, pat_he_flow, 'tokens');      if ~isempty(m), temp_he     = single(str2double(m{1}{1})); end
                m = regexp(line, pat_n2_flow, 'tokens');      if ~isempty(m), temp_n2     = single(str2double(m{1}{1})); end
                m = regexp(line, pat_attenuator, 'tokens');   if ~isempty(m), temp_att    = single(str2double(m{1}{1})); end

                if contains(line,'= Ablation ='), found_ablation_block = true; end
                if found_ablation_block && contains(line,'Triggered:')
                    m = regexp(line, pat_triggered, 'tokens');
                    if ~isempty(m), pulses_triggered(end) = single(str2double(m{1}{1})); end
                end
                if found_ablation_block && contains(line,'Fired:')
                    m = regexp(line, pat_fired, 'tokens');
                    if ~isempty(m), fired(end) = single(str2double(m{1}{1})); end
                    found_ablation_block = false;
                    in_main_ablation = false;
                end
            end
            fclose(fid);

            % Pad laser start/stop times to match points
            nPoints = numel(pointnumbers);
            if numel(laser_start_times) < nPoints
                laser_start_times = [laser_start_times; repmat({''}, nPoints - numel(laser_start_times),1)];
            end
            if numel(laser_stop_times) < nPoints
                laser_stop_times  = [laser_stop_times;  repmat({''}, nPoints - numel(laser_stop_times),1)];
            end

            % Remove fired == 0
            remove = fired == 0;
            pointnumbers(remove)        = [];
            spotname(remove)            = [];
            fluences(remove)            = [];
            rep_rates(remove)           = [];
            pulses_triggered(remove)    = [];
            fired(remove)               = [];
            background_duration(remove) = [];
            laser_energy(remove)        = [];
            laser_hv(remove)            = [];
            he_flow(remove)             = [];
            n_flow(remove)              = [];
            attenuator(remove)          = [];
            x_position_start(remove)    = [];
            y_position_start(remove)    = [];
            z_position_start(remove)    = [];
            x_position_end(remove)      = [];
            y_position_end(remove)      = [];
            z_position_end(remove)      = [];
            path_length(remove)         = [];
            scan_speed_mm_s(remove)     = [];
            spotsize(remove)            = [];
            laser_start_times(remove)   = [];
            laser_stop_times(remove)    = [];

            laser_parameters = struct( ...
                'measuringdate',        measuringdate, ...
                'pointnumbers',         pointnumbers, ...
                'spotname',             {spotname}, ...
                'spotsize',             spotsize, ...
                'rep_rates',            rep_rates, ...
                'fluences',             fluences, ...
                'laser_start_times',    {laser_start_times}, ...
                'laser_stop_times',     {laser_stop_times}, ...
                'pulses_triggered',     pulses_triggered, ...
                'fired',                fired, ...
                'background_duration',  background_duration, ...
                'laser_energy',         laser_energy, ...
                'laser_hv',             laser_hv, ...
                'he_flow',              he_flow, ...
                'n_flow',               n_flow, ...
                'attenuator',           attenuator, ...
                'x_position_start',     x_position_start, ...
                'y_position_start',     y_position_start, ...
                'z_position_start',     z_position_start, ...
                'x_position_end',       x_position_end, ...
                'y_position_end',       y_position_end, ...
                'z_position_end',       z_position_end, ...
                'path_length',          path_length, ...
                'scan_speed_mm_s',      scan_speed_mm_s ...
                );

            delete(progress)


        end

        %%%%%%%%% Laser Wrapper %%%%%%%%%%%%%%

        function [settings, laser_parameters, laser_metadata_path] = read_laser_metadata_wrapper(app, laser_metadata_path, settings)

            % Check if laser_metadata_path is provided
            if ~exist('laser_metadata_path', 'var') || isempty(laser_metadata_path)
                settings.laser.Value = app.ChooseLaserDropDown.Value; % default value
                settings.laser.Options = {'Resonetics Verbose Log (.log)', 'Resonetics Log (.csv)'};
                return;
            end

            % Process based on settings.laser.Value
            if exist('settings', 'var') && isfield(settings, 'laser')
                switch settings.laser.Value
                    case 'Resonetics Verbose Log (.log)'

                        [laser_parameters] = read_resonetics_verbose_log(app, laser_metadata_path);

                    case 'Resonetics Log (.csv)'

                        [laser_parameters] = read_resonetics_csv_log(app, laser_metadata_path);

                    case 'Teledyne Iridia (.lase)'
              
                        [laser_parameters] = read_teledyne_iridia_lase(app, laser_metadata_path);

                    case 'Agilent/Teledyne (Iolite.csv)'

                        [laser_parameters] = read_agilent_iolite_csv_log(app, laser_metadata_path);

                    case 'Resonetics Logbook (.xlsx)'

                        [laser_parameters] = read_resonetics_logbook(app, laser_metadata_path);

                    case 'LA_Metadata_Template (.xlsx)'

                        [laser_parameters] = read_la_template_xlsx(app, laser_metadata_path);  

                    case 'Resonetics Log Linescan (.csv)'

                        [laser_parameters] = read_resonetics_csv_log_linescan(app, laser_metadata_path);

                    case 'Resonetics Verbose Log Linescan (.log)'

                        laser_parameters = read_resonetics_verbose_log_linescan(app, laser_metadata_path);

                    case 'ESL (.csv)'

                        laser_parameters = read_esl_csv_log(app, laser_metadata_path);
                        
                    case 'Teledyne ScanData (.csv)'

                        laser_parameters = read_teledyne_scan_data_csv(app, laser_metadata_path);
                        
                        

                end
            end
            % convert here once for all readers
            laser_parameters.spotname = string(laser_parameters.spotname);
            if isfield(laser_parameters, 'laser_start_times')
                laser_parameters.laser_start_times = string(laser_parameters.laser_start_times);
            end
            if isfield(laser_parameters, 'laser_stop_times')
                laser_parameters.laser_stop_times = string(laser_parameters.laser_stop_times);
            end

        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Mass-Spec Metadata %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%% Agilent
        function [parameters, dwelltimes] = read_agilent_acqmethod(app, mass_spec_metadata_path)

            % Read the XML file
            xmlData = xmlread(mass_spec_metadata_path);

            % Get all IcpmsElement nodes
            elements = xmlData.getElementsByTagName('IcpmsElement');

            % Initialize arrays to store element names and integration times
            elementNames = cell(1, elements.getLength);
            integrationTimes = zeros(1, elements.getLength);

            % Loop through each IcpmsElement node
            for i = 0:elements.getLength-1
                % Get the current IcpmsElement node
                element = elements.item(i);

                % Get the ElementName, IntegrationTime, and MZ nodes
                elementNameNode = element.getElementsByTagName('ElementName').item(0);
                integrationTimeNode = element.getElementsByTagName('IntegrationTime').item(0);
                mzNode = element.getElementsByTagName('MZ').item(0);

                % Extract the text content of the nodes
                elementName = char(elementNameNode.getTextContent());
                integrationTime = str2double(char(integrationTimeNode.getTextContent()));
                mzValue = str2double(char(mzNode.getTextContent()));

                % Combine element names with MZ values
                elementNames{i+1} = [elementName, num2str(mzValue)];
                integrationTimes(i+1) = integrationTime;
            end

            % Create a table with integration times as values and element names as column headers
            dwelltimes = array2table(integrationTimes, 'VariableNames', elementNames);

            parameters = struct();
            tuneIDNodes = xmlData.getElementsByTagName('TuneID');
            for i = 0:tuneIDNodes.getLength-1
                tuneIDNode = tuneIDNodes.item(i);
                if str2double(char(tuneIDNode.getTextContent())) == 1 || str2double(char(tuneIDNode.getTextContent())) == 2
                    % Get the parent node of TuneID
                    parentNode = tuneIDNode.getParentNode();

                    % Loop through all child nodes of the parent node
                    childNodes = parentNode.getChildNodes();
                    for j = 0:childNodes.getLength-1
                        childNode = childNodes.item(j);
                        if childNode.getNodeType() == childNode.ELEMENT_NODE
                            % Extract the parameter name and value
                            paramName = char(childNode.getNodeName());
                            if startsWith(paramName, 'Opt_') % Only include parameters starting with "Opt"
                                paramValue = char(childNode.getTextContent());
                                % Remove the "Opt_" prefix
                                paramName = paramName(5:end);
                                % Store numeric values as numbers and text values as cell arrays
                                numericValue = str2double(paramValue);
                                if isnan(numericValue)
                                    parameters.(paramName) = paramValue;
                                else
                                    parameters.(paramName) = numericValue; % Store numbers as numeric
                                end
                            end
                        end
                    end
                end
            end
        end

        function [parameters] = read_agilent_hardware_config_7900(app, mass_spec_metadata_path)

            % Read the XML file
            xmlData = xmlread(mass_spec_metadata_path);

            % Get the root element
            rootElement = xmlData.getDocumentElement();

            % Extract the attributes
            modelName = char(rootElement.getAttribute('ModelName'));
            serialNumber = char(rootElement.getAttribute('SerialNumber'));
            moduleID = char(rootElement.getAttribute('ModuleID'));

            % Store the extracted values in the struct
            parameters.ModelName = modelName;
            parameters.SerialNumber = serialNumber;
            parameters.ModuleID = moduleID;

            % Find the <Detector> element
            detectorElement = rootElement.getElementsByTagName('Detector').item(0);

            % Extract values from the <Detector> element
            parameters.Out_EMDiscriminator = str2double(detectorElement.getElementsByTagName('Out_EMDiscriminator').item(0).getTextContent());

            if ~isempty(detectorElement.getElementsByTagName('Sys_EMDeadTime').item(0))

                parameters.Sys_EMDeadTime = str2double(detectorElement.getElementsByTagName('Sys_EMDeadTime').item(0).getTextContent());

            elseif ~isempty(detectorElement.getElementsByTagName('Sys_EMReferenceMass').item(0))

                parameters.Sys_EMReferenceMass = str2double(detectorElement.getElementsByTagName('Sys_EMReferenceMass').item(0).getTextContent());

            elseif ~isempty(detectorElement.getElementsByTagName('Sys_EMCorrectionFactor').item(0))

                parameters.Sys_EMCorrectionFactor = str2double(detectorElement.getElementsByTagName('Sys_EMCorrectionFactor').item(0).getTextContent());

            end

            parameters.Opt_AnalogHV = str2double(detectorElement.getElementsByTagName('Opt_AnalogHV').item(0).getTextContent());
            parameters.Opt_PulseHV = str2double(detectorElement.getElementsByTagName('Opt_PulseHV').item(0).getTextContent());
            parameters.EMPulseLimit_Cache = str2double(detectorElement.getElementsByTagName('EMPulseLimit_Cache').item(0).getTextContent());
            parameters.EMAnalogLimit_Cache = str2double(detectorElement.getElementsByTagName('EMAnalogLimit_Cache').item(0).getTextContent());

        end

        function [parameters] = read_agilent_hardware_config_QQQ(app, mass_spec_metadata_path)

            % Read the XML file
            xmlData = xmlread(mass_spec_metadata_path);

            % Get the root element
            rootElement = xmlData.getDocumentElement();

            % Extract the attributes
            modelName = char(rootElement.getAttribute('ModelName'));
            serialNumber = char(rootElement.getAttribute('SerialNumber'));
            moduleID = char(rootElement.getAttribute('ModuleID'));

            % Store the extracted values in the struct
            parameters.ModelName = modelName;
            parameters.SerialNumber = serialNumber;
            parameters.ModuleID = moduleID;

            % Find the <Detector> element
            detectorElement = rootElement.getElementsByTagName('Detector').item(0);

            % Extract values from the <Detector> element
            parameters.Opt_AnalogHV = str2double(detectorElement.getElementsByTagName('Opt_AnalogHV').item(0).getTextContent());
            parameters.Opt_PulseHV = str2double(detectorElement.getElementsByTagName('Opt_PulseHV').item(0).getTextContent());
            parameters.EMPulseLimit_Cache = str2double(detectorElement.getElementsByTagName('EMPulseLimit_Cache').item(0).getTextContent());
            parameters.EMAnalogLimit_Cache = str2double(detectorElement.getElementsByTagName('EMAnalogLimit_Cache').item(0).getTextContent());

        end

        function [parameters] = read_agilent_hardware_config_8900(app, mass_spec_metadata_path)

            % Read the XML file
            xmlData = xmlread(mass_spec_metadata_path);

            % Get the root element
            rootElement = xmlData.getDocumentElement();

            % Extract the attributes
            modelName = char(rootElement.getAttribute('ModelName'));
            serialNumber = char(rootElement.getAttribute('SerialNumber'));
            moduleID = char(rootElement.getAttribute('ModuleID'));

            % Store the extracted values in the struct
            parameters.ModelName = modelName;
            parameters.SerialNumber = serialNumber;
            parameters.ModuleID = moduleID;
            % too tired right now, doing this later
%             % Find the <Detector> element
%               detectorElement = rootElement.getElementsByTagName('HardwareOptimize').item(0);
%             % Extract values from the <Detector> element
%             parameters.Out_EMDiscriminator = str2double(detectorElement.getElementsByTagName('Out_EMDiscriminator').item(0).getTextContent());
% 
%             if ~isempty(detectorElement.getElementsByTagName('Sys_EMDeadTime').item(0))
% 
%                 parameters.Sys_EMDeadTime = str2double(detectorElement.getElementsByTagName('Sys_EMDeadTime').item(0).getTextContent());
% 
%             elseif ~isempty(detectorElement.getElementsByTagName('Sys_EMReferenceMass').item(0))
% 
%                 parameters.Sys_EMReferenceMass = str2double(detectorElement.getElementsByTagName('Sys_EMReferenceMass').item(0).getTextContent());
% 
%             elseif ~isempty(detectorElement.getElementsByTagName('Sys_EMCorrectionFactor').item(0))
% 
%                 parameters.Sys_EMCorrectionFactor = str2double(detectorElement.getElementsByTagName('Sys_EMCorrectionFactor').item(0).getTextContent());
% 
%             end
% 
%             parameters.Opt_AnalogHV = str2double(detectorElement.getElementsByTagName('Opt_AnalogHV').item(0).getTextContent());
%             parameters.Opt_PulseHV = str2double(detectorElement.getElementsByTagName('Opt_PulseHV').item(0).getTextContent());
%             parameters.EMPulseLimit_Cache = str2double(detectorElement.getElementsByTagName('EMPulseLimit_Cache').item(0).getTextContent());
%             parameters.EMAnalogLimit_Cache = str2double(detectorElement.getElementsByTagName('EMAnalogLimit_Cache').item(0).getTextContent());

        end

        %%%% Thermo Fisher
        function [dwelltimes] = read_element_xr_fin(app, mass_spec_metadata_path)

            % Open file
            fid = fopen(mass_spec_metadata_path, 'r');

            % Skip 9 lines
            for i = 1:9
                fgetl(fid);
            end

            % Read headers (line 10)
            headerLine = fgetl(fid);
            headers = textscan(headerLine, '%s', 'Delimiter', ',');
            columnNames = headers{1};

            % Read data (line 11)
            dataLine = fgetl(fid);
            data = textscan(dataLine, '%f', 'Delimiter', ',');
            dwellTimeValues = data{1}';

            % Close file
            fclose(fid);

            dwellTimeValues = dwellTimeValues ./ 1000;

            % Create a table with the data
            dwelltimes = array2table(dwellTimeValues, 'VariableNames', columnNames);

        end

        %%%% ICP_MS_Metadata_Template.xlsx
        function [parameters] = read_icp_ms_template_xlsx(app, mass_spec_metadata_path)

            parameters = struct();
            try
                data = readtable(mass_spec_metadata_path, 'ReadVariableNames', true, 'TextType', 'string');

                varNames = data.Properties.VariableNames;
                for k = 1:numel(varNames)
                    vn = varNames{k};
                    col = data.(vn);

                    if iscell(col)
                        col = string(col);
                    end

                    if ~isAllMissingColumn(col)
                        if isnumeric(col)
                            parameters.(vn) = single(col);
                        else
                            parameters.(vn) = col;
                        end
                    end
                end
            catch
                parameters = struct();
            end

            function tf = isAllMissingColumn(col)
                if isnumeric(col)
                    tf = isempty(col) || all(isnan(col), 'all');
                elseif islogical(col)
                    tf = false;
                elseif isstring(col)
                    tf = isempty(col) || all(ismissing(col) | strlength(strtrim(col)) == 0);
                elseif isdatetime(col) || isduration(col) || iscategorical(col)
                    tf = isempty(col) || all(ismissing(col));
                else
                    tf = false;
                end
            end
        end

        %%% Dwell_Times_Template.xlsx
        function [dwelltimes] = read_dwell_times_template_xlsx(app, mass_spec_metadata_path)

            % Read the Excel file
            dwelltimes = readtable(mass_spec_metadata_path);

            % Get the variable names (column headers)
            varNames = dwelltimes.Properties.VariableNames;

            % Get the first row of data (dwelltimes in seconds)
            dwellTimeValues = table2array(dwelltimes(1,:));

            % Create a new table with just the dwelltimes
            dwelltimes = array2table(dwellTimeValues, 'VariableNames', varNames);


        end

        %%% Acquisition_Time_Template.xlsx
        function [acquisition_times] = read_acquisition_times_template_xlsx(app, mass_spec_metadata_path)

            % Read the Excel file
            acquisition_times_data = readtable(mass_spec_metadata_path);

            acquisition_times = string(acquisition_times_data.Acquisition_Times);

        end


        %%%%%%%%% Mass-Spec Wrapper %%%%%%%%%%%%%%

        function [settings, Hardware_parameters, ICP_MS_parameters, dwelltimes, acquisition_time, mass_spec_metadata_path] = read_mass_spec_metadata_wrapper(app, mass_spec_metadata_path, settings)

            Hardware_parameters = struct();
            ICP_MS_parameters = struct();
            dwelltimes = [];
            acquisition_time = [];

                switch app.ChooseMassSpecMetadataDropDown.Value %settings.dwelltime.Value

                    case 'Agilent AcqMethod (.xml)'

                        [ICP_MS_parameters, dwelltimes] = read_agilent_acqmethod(app, mass_spec_metadata_path);

                    case 'Agilent HardwareConfig_ICPQQQ (.xml)'

                        [Hardware_parameters] = read_agilent_hardware_config_QQQ(app, mass_spec_metadata_path);

                    case 'Agilent HardwareConfig_7900 (.xml)'

                        [Hardware_parameters] = read_agilent_hardware_config_7900(app, mass_spec_metadata_path);

                    case 'Thermo Fisher Element XR (.FIN)'

                        [dwelltimes] = read_element_xr_fin(app, mass_spec_metadata_path);

                    case 'ICP_MS_Metadata_Template (.xlsx)'

                        [ICP_MS_parameters] = read_icp_ms_template_xlsx(app, mass_spec_metadata_path);

                    case 'Dwell_Times_Template (.xlsx)'

                        [dwelltimes] = read_dwell_times_template_xlsx(app, mass_spec_metadata_path);

                    case 'Acquisition_Time_Template (.xlsx)'

                        [acquisition_time] = read_acquisition_times_template_xlsx(app, mass_spec_metadata_path);
                end

            %end
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% API %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%         function [settings] = single_signal_import_API(app, signal_path, mass_spec_metadata_path, settings)
% 
%             try
%                 test_state = true; % is needed later as a failsafe so that no broken data gets into the data structure
% 
%                 % if settings is not sent or something wrong is put in
%                 if not(exist('settings', 'var')) || not(isstruct(settings))
%                     settings = struct();
%                 end
% 
%                 % if the signal_path is empty, send the settings back
%                 if not(exist('signal_path','var')) || isempty(signal_path)
%                     signal_path = [];
%                     [settings, ~, ~, ~, ~, ~,~, ~] = read_signal_files_wrapper(app, signal_path, settings);
%                     test_state = false;
%                 end
% 
%                 % if the mass_spec_metadata_path is empty, send the settings back
%                 if not(exist('mass_spec_metadata_path','var')) || isempty(mass_spec_metadata_path)
%                     mass_spec_metadata_path = [];
%                     [settings, ~, ~, ~] = read_mass_spec_metadata_wrapper(app, mass_spec_metadata_path, settings);
%                     test_state = false;
%                 end
% 
%                 % if the session_name is not input
%                 if not(isfield(settings,'session_name')) || isempty(settings.session_name)
%                     settings.session_name = 'New Sesh';
%                 end
% 
%                 % if the project_name is not sent, just call it new project
%                 if not(isfield(settings,'project_name')) || isempty(settings.project_name)
%                     settings.project_name = 'New Proj';
%                 end
% 
%                 % if the session_name is not input, make it empty
%                 if not(isfield(settings,'session_id')) || isempty(settings.session_id)
%                     settings.session_id = 0; % default value
%                 end
% 
%                 % if the project_id is not sent, set default to 0
%                 if not(isfield(settings,'project_id')) || isempty(settings.project_id)
%                     settings.project_id = 0;    % default value
%                 end
% 
%                 if not(isfield(settings,'massspec')) || isempty(settings.massspec)
%                     disp("Please select a Mass-Spec")
%                     return
%                 end
% 
%                 if not(isfield(settings,'reductiontype')) || isempty(settings.reductiontype)
%                     settings.reductiontype = 'Matrix'; % default value
%                 end
% 
%                 % run the functions and save the output in a cache
%                 [settings, signal_data, spotname, time, icp_ms_parameters, dwelltimes,~, signal_path]= read_signal_files_wrapper(app, signal_path, settings);
%                 [settings, ICP_MS_parameters, dwelltimes, mass_spec_metadata_path] = read_mass_spec_metadata_wrapper(app, mass_spec_metadata_path, settings);
% 
%                 % if test_state = false, push the data from the cache to the
%                 % data structure
%                 if test_state == false
%                     return
%                 else
%                     % Initialize the data structure if it does not exist
%                     if ~isfield(app.base, 'project')
%                         app.base.project = struct();
%                     end
%                     if ~isfield(app.base.project, 'session')
%                         app.base.project.session = struct();
%                     end
%                     if ~isfield(app.base.project.session, 'dwelltimes')
%                         app.base.project.session.dwelltimes = [];
%                         app.base.project.session.config.mass_spec_metadata_path = [];
%                     end
%                     if ~isfield(app.base.project.session, 'spot')
%                         app.base.project.session.spot = struct();
%                         app.base.project.session.spot.signal_data = [];
%                         app.base.project.session.config.signal_path = {};
%                         app.base.project.session.spot.acquisition_time = {};
%                         app.base.project.session.spot.name = {};
%                     end
% 
%                     all_analytes = {};
%                     % Collect analytes from the current file
%                     current_analytes = signal_data.Properties.VariableNames(2:end)';
%                     if isempty(all_analytes)
%                         all_analytes = current_analytes;
%                     else
%                         if ~isequal(sort(all_analytes), sort(current_analytes))
%                             %message = "Only load files that contain the same analytes!";
%                             %uialert(app.UIFigure, message, "Warning", "Icon", "warning");
%                             disp('Only load files that contain the same analytes!')
%                             return;
%                         end
%                     end
%                     % Check if there are already analytes in the data structure
%                     if isfield(app.base.project, 'session') && isfield(app.base.project.session, 'spot') && isfield(app.base.project.session.spot, 'analytes') && ~isempty(app.base.project.session.spot.analytes)
%                         if ~isequal(sort(app.base.project.session.spot.analytes), sort(all_analytes))
%                             %message = "Only load files that contain the same analytes!";
%                             %uialert(app.UIFigure, message, "Warning", "Icon", "warning");
%                             disp('Only load files that contain the same analytes!')
%                             return;
%                         end
%                     end
%                     app.base.project.session.spot.analytes = all_analytes;
% 
%                     % Determine the index for the new data
%                     index = numel(app.base.project.session.spot.signal_data) + 1;
% 
%                     % Push the data to the data structure
%                     app.base.project.session.spot.signal_data{index,1} = signal_data;
%                     % do the rest
%                     app.base.project.session.config.signal_path{index,1} = char(signal_path);
%                     app.base.project.session.spot.acquisition_time{index,1} = time;
%                     app.base.project.session.spot.name{index,1} = char(spotname);
% 
%                     % Detect the signals and store the results
%                     [signal_starts, signal_ends] = detect_single_spot_signal_starts_ends(app, signal_data);
%                     app.base.project.session.spot.signal_starts(index,1) = signal_starts;
%                     app.base.project.session.spot.signal_ends(index,1) = signal_ends;
% 
%                     % store the dwelltimes
%                     app.base.project.session.dwelltimes = dwelltimes;
%                     app.base.project.session.config.mass_spec_metadata_path =  mass_spec_metadata_path;
% 
%                     % store project and session related variables
%                     app.base.project.session.session_name = settings.session_name;
%                     app.base.project_name = settings.project_name;
%                     app.project_id = settings.project_id;
%                     app.session_id = settings.session_id;
% 
%                     % store the type of import
%                     app.base.project.session.config.datatype = 'Single';
%                     app.base.project.session.config.reductiontype = settings.reductiontype;
% 
%                 end
% 
%                 if isfield(settings, 'import_module_GUI_update_state') && settings.import_module_GUI_update_state == true
%                     update_Imp_Mod_GUI_single_spot_Tab(app)
%                 end
% 
%             catch ME
%                 DisplayError(ME,'single_spot_import_public failed')
% 
%                 message = "single_spot_import_public failed";
%                 uialert(app.UIFigure,message,"Warning", ...
%                     "Icon","warning");
%                 disp('single_spot_import_public failed')
%             end
% 
%             % if ~isequal(sort(app.base.project.session.spot.analytes), sort(app.base.project.session.dwelltimeanalytes))
%             %     disp("Analytes from measurement file and dwelltime file are different")
%             % end
% 
% 
%         end

%         function [settings] = continuous_signal_import_API(app, signal_path, laser_metadata_path, mass_spec_metadata_path, settings)
% 
%             try
%                 test_state = true; % is needed later as a failsafe so that no broken data gets into the data structure
% 
%                 % if settings is not sent or something wrong is put in
%                 if not(exist('settings', 'var')) || not(isstruct(settings))
%                     settings = struct();
%                 end
% 
%                 % if the laser_metadata_path is empty, send the settings back
%                 if not(exist('laser_metadata_path','var')) || isempty(laser_metadata_path)
%                     laser_metadata_path = [];
%                     [settings, ~, laser_metadata_path]  = read_laser_metadata_wrapper(app, laser_metadata_path, settings);
% 
%                     test_state = false;
%                 end
% 
%                 % if the signal_path is empty, send the settings back
%                 if not(exist('signal_path','var')) || isempty(signal_path)
%                     signal_path = [];
%                     [settings, ~, ~] = read_continuous_signal_wrapper(app, signal_path, settings);
%                     test_state = false;
%                 end
% 
%                 % if the mass_spec_metadata_path is empty, send the settings back
%                 if not(exist('mass_spec_metadata_path','var')) || isempty(mass_spec_metadata_path)
%                     mass_spec_metadata_path = [];
%                     [settings,~, ~, ~, ~]  = read_mass_spec_metadata_wrapper(app, mass_spec_metadata_path, settings);
%                     test_state = false;
%                 end
% 
%                 % if the session_name is not input
%                 if not(isfield(settings,'session_name')) || isempty(settings.session_name)
%                     settings.session_name = 'New Sesh';
%                 end
% 
%                 % if the project_name is not sent, just call it new project
%                 if not(isfield(settings,'project_name')) || isempty(settings.project_name)
%                     settings.project_name = 'New Proj';
%                 end
% 
%                 % if the session_name is not input, make it empty
%                 if not(isfield(settings,'session_id')) || isempty(settings.session_id)
%                     settings.session_id = 0; % default value
%                 end
% 
%                 % if the project_id is not sent, set default to 0
%                 if not(isfield(settings,'project_id')) || isempty(settings.project_id)
%                     settings.project_id = 0;    % default value
%                 end
% 
%                 if not(isfield(settings,'massspec')) || isempty(settings.massspec)
%                     disp("Please select a Mass-Spec")
%                     return
%                 end
% 
%                 if not(isfield(settings,'laser')) || isempty(settings.laser)
%                     disp("Please select a Laser")
%                     return
%                 end
% 
%                 if not(isfield(settings,'dwelltime')) || isempty(settings.dwelltime)
%                     disp("Please select a dwelltime file")
%                     return
%                 end
% 
%                 if not(isfield(settings,'reductiontype')) || isempty(settings.reductiontype)
%                     settings.reductiontype = 'Matrix'; % default value
%                 end
% 
%                 % run the functions and save the output in a cache
%                 [settings, signal_data, signal_path] = read_continuous_signal_wrapper(app, signal_path, settings);
%                 [settings, laser_parameters, laser_metadata_path] = read_laser_metadata_wrapper(app, laser_metadata_path, settings);
%                 [settings, ICP_MS_parameters, dwelltimes, mass_spec_metadata_path]  = read_mass_spec_metadata_wrapper(app, mass_spec_metadata_path, settings);
%                 % if test_state = false, push the data from the cache to the
%                 % data structure
%                 if test_state == false
%                     return
%                 else
%                     % push the data to datastructure
%                     app.base.project.session.spot.signal_data = signal_data;
% 
%                     app.base.project.session.spot.analytes = app.base.project.session.spot.signal_data.Properties.VariableNames(2:end)';
%                     app.base.project.session.config.signal_path = signal_path;
% 
%                     app.base.project.session.spot.name = laser_parameters.spotname;
%                     app.base.project.session.meta.spotsize = laser_parameters.spotsize;
%                     app.base.project.session.meta.repetition_rate = laser_parameters.rep_rates;
%                     app.base.project.session.meta.fluence = laser_parameters.fluences;
%                     app.base.project.session.meta.laser_start_times = laser_parameters.laser_start_times;
%                     app.base.project.session.meta.laser_stop_times = laser_parameters.laser_stop_times;
%                     app.base.project.session.meta.pulses_fired = laser_parameters.fired;
%                     app.base.project.session.meta.pulses_triggered = laser_parameters.pulses_triggered;
%                     app.base.project.session.meta.ablation_duration = laser_parameters.ablation_duration;
%                     app.base.project.session.meta.background_duration = laser_parameters.background_duration;
%                     app.base.project.session.meta.laser_energy = laser_parameters.laser_energy;
%                     app.base.project.session.meta.laser_hv = laser_parameters.laser_hv;
%                     app.base.project.session.meta.gas_health = laser_parameters.gas_health;
%                     app.base.project.session.meta.He_flow = laser_parameters.He_flow;
%                     app.base.project.session.meta.N_flow = laser_parameters.N_flow;
%                     app.base.project.session.meta.attenuator = laser_parameters.attenuator;
%                     app.base.project.session.meta.x_position = laser_parameters.x_position;
%                     app.base.project.session.meta.y_position = laser_parameters.y_position;
%                     app.base.project.session.meta.z_position = laser_parameters.z_position;
%                     app.base.project.session.meta.cell_pressure = laser_parameters.cell_pressure;
% 
%                     app.base.project.session.config.laser_metadata_path=laser_metadata_path;
% 
%                     % Att how do I know they are in the right order?
%                     app.base.project.session.dwelltimes = dwelltimes;
%                     app.base.project.session.config.mass_spec_metadata_path =  mass_spec_metadata_path;
% 
%                     app.base.project.session.session_name = settings.session_name;
%                     app.base.project_name = settings.project_name;
% 
%                     app.project_id = settings.project_id;
%                     app.session_id = settings.session_id;
% 
%                     app.base.project.session.config.datatype = 'Continuous';
%                     app.base.project.session.config.reductiontype = settings.reductiontype;
% 
%                 end
% 
%                 % Att detect the signals, has to be moved later
%                 [app.base.project.session.spot.signal_starts, app.base.project.session.spot.signal_ends] = detect_signals(app, app.base.project.session.spot.signal_data, numel(app.base.project.session.spot.name));
% 
%                 if isfield(settings, 'import_module_GUI_update_state') && settings.import_module_GUI_update_state == true
%                     update_Imp_Mod_GUI_Meas_Log_Tab(app)
%                 end
% 
%             catch ME
%                 DisplayError(ME,'measurement_logfile_import_public failed')
% 
%                 message = "measurement_logfile_import_public failed";
%                 uialert(app.UIFigure,message,"Warning", ...
%                     "Icon","warning");
%             end
%         end


        %unfinished
%         function [settings] = import_mass_spec_metadata_API(app, mass_spec_metadata_path, settings)
% 
%             try
%                 test_state = true; % is needed later as a failsafe so that no broken data gets into the data structure
% 
%                 % if settings is not sent or something wrong is put in
%                 if not(exist('settings', 'var')) || not(isstruct(settings))
%                     settings = struct();
%                 end
% 
%                 % if the mass_spec_metadata_path is empty, send the settings back
%                 if not(exist('mass_spec_metadata_path','var')) || isempty(mass_spec_metadata_path)
%                     %%% here give what is possible
%                     test_state = false;
%                 end
% 
%                 % if the session_name is not input
%                 if not(isfield(settings,'session_name')) || isempty(settings.session_name)
%                     settings.session_name = 'New Sesh';
%                 end
% 
%                 % if the project_name is not sent, just call it new project
%                 if not(isfield(settings,'project_name')) || isempty(settings.project_name)
%                     settings.project_name = 'New Proj';
%                 end
% 
%                 % if the session_name is not input, make it empty
%                 if not(isfield(settings,'session_id')) || isempty(settings.session_id)
%                     settings.session_id = 0; % default value
%                 end
% 
%                 % if the project_id is not sent, set default to 0
%                 if not(isfield(settings,'project_id')) || isempty(settings.project_id)
%                     settings.project_id = 0;    % default value
%                 end
% 
%                 if not(isfield(settings,'mass_spec_metadata')) || isempty(settings.mass_spec_metadata)
%                     disp("Please select a mass_spec_metadata file")
%                     return
%                 end
% 
%                 % run the functions and save the output in a cache
%                 %[settings, Hardware_parameters, ICP_MS_parameters, dwelltimes, acquisition_time, mass_spec_metadata_path] = read_mass_spec_metadata_wrapper(app, mass_spec_metadata_path, settings);
%                 % if test_state = false, push the data from the cache to the
%                 % data structure
%                 if test_state == false
%                     return
%                 else
% 
%  
% 
%                     GetMassSpecMetadataButtonPushed(app)
% 
%                 end
% 
%                 % Att detect the signals, has to be moved later
%                 %[app.base.project.session.spot.signal_starts, app.base.project.session.spot.signal_ends] = detect_signals(app, app.base.project.session.spot.signal_data, numel(app.base.project.session.spot.name));
% 
%                 if isfield(settings, 'import_module_GUI_update_state') && settings.import_module_GUI_update_state == true
%                     update_continuous_panel(app)
%                 end
% 
%             catch ME
%                 DisplayError(ME,'import_mass_spec_metadata_API failed')
% 
%                 message = "import_mass_spec_metadata_API failed";
%                 uialert(app.UIFigure,message,"Warning", ...
%                     "Icon","warning");
%             end
%         end
% 



    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, sourceapp, project_name, project_id, session_id)
            center_figure(app, app.UIFigure)

            % sourceapp = app von der aus das ImportModule gecallt wird, 1st
            if exist("sourceapp","var")
                app.sourceapp = sourceapp;
            end% input argument of startupfcn

            if exist("project_name", "var")
                app.base.project_name = project_name;
            end

            %% when the addnewsession button is pressed
            if exist("project_id","var") && exist("session_id","var")
                app.project_id = project_id;
                app.session_id = session_id;

                if isequal(0, app.session_id) % If this is the first time adding a session

                    app.base.project.session.session_name = "New Session";
                    app.UIFigure.Name = [char(app.base.project_name) ' - ' char(app.base.project.session.session_name)];

                    app.base.project.session.config.module_status.import = false;
                    app.base.project.session.config.module_status.interval = false;
                    app.base.project.session.config.module_status.classification = false;
                    app.base.project.session.config.module_status.drift = false;
                    app.base.project.session.config.module_status.quantification = false;
                    app.base.project.session.config.module_status.results = false;

                    app.base.project.session.config.synced = false;
                    app.base.project.session.config.loaded = true;

                elseif app.session_id > 0 % If an already existing session is opened

                    app.base.project.session =  app.sourceapp.base(project_id).project(session_id).session;
                    %app.base.project.session.session_name = "New Session #" + string(app.session_id);
                    app.UIFigure.Name = [char(app.base.project_name) ' - ' char(app.base.project.session.session_name)];

                end
            end

%             %% for API calls if someone wants to send data in
%             if  exist("project_id","var") && exist("session_id","var") && exist("data", "var")
%                 % load the sessin_id and the data
%                 app.project_id = project_id;
%                 app.session_id = session_id;
%                 app.base.project.session.session_name = data.session_name;
%                 app.base.project_name = data.project_name;
% 
%                 % adjust the name of the new session
%                 app.UIFigure.Name = [char(app.base.project_name) ' - ' char(app.base.project.session.session_name)];
% 
%                 app.base.project.session.config.module_status.import = true;
%                 app.base.project.session.config.module_status.interval = false;
%                 app.base.project.session.config.module_status.classification = false;
%                 app.base.project.session.config.module_status.drift = false;
%                 app.base.project.session.config.module_status.quantification = false;
%                 app.base.project.session.config.module_status.results = false;
% 
%             end

            update_progress_buttons(app)

            %update GUI
            if ~isempty(app.base)
                if isfield(app.base.project.session, 'config') && isfield(app.base.project.session.config, 'datatype') && isequal(app.base.project.session.config.datatype, 'Continuous')

                    app.SinglePanel.Visible = false;
                    app.ContinuousPanel.Visible = true;
                    app.ManualSelectionPanel.Visible = true;
                    update_continuous_panel(app)
                    update_manual_selection_panel(app)


                elseif isfield(app.base.project.session, 'config') && isfield(app.base.project.session.config, 'datatype') && isequal(app.base.project.session.config.datatype, 'Single')
                    app.SinglePanel.Visible = true;
                    app.ContinuousPanel.Visible = false;
                    update_single_panel(app)
                end
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if ~isfield(app.base.project.session, 'meta')
                app.base.project.session.meta = struct();
            end
            
            app.UIFigure.Tag = sprintf('%d_%d', app.project_id, app.session_id);

             watch_session_changes(app);
        end

        % Value changed function: ContinuousPlotElementsListBox
        function ContinuousPlotElementsListBoxValueChanged(app, event)
            % if the Legend Value changes the Zoomed Plot gets updated

            app.selected_analytes = app.ContinuousPlotElementsListBox.Value;

            update_continuous_plot(app)
        end

        % Button pushed function: DetectSignalsButton
        function DetectSignalsButtonPushed(app, event)
            changes = check_changes(app, 'import');
            if changes == false
                return
            end
            app.editstatus = true;

            if ~isstruct(app.base.project) || ~isstruct(app.base.project.session) || isempty(app.base.project.session)
                message = "Load a signal file and a logfile";
                uialert(app.UIFigure, message, "Warning", "Icon", "warning");
                return
            end

            if ~isfield(app.base.project.session, 'spot') || ...
                    (~isfield(app.base.project.session.spot, 'signal_data') && ~isfield(app.base.project.session.spot, 'name'))
                message = "Load a signal file and a logfile";
                uialert(app.UIFigure,message,"Warning", ...
                    "Icon","warning");
                return
            elseif isfield(app.base.project.session.spot, 'signal_data') && ~isfield(app.base.project.session.spot, 'name')

                message = "Load a logfile";
                uialert(app.UIFigure,message,"Warning", ...
                    "Icon","warning");
                return
            elseif ~isfield(app.base.project.session.spot, 'signal_data') && isfield(app.base.project.session.spot, 'name')

                message = "Load a signal file";
                uialert(app.UIFigure,message,"Warning", ...
                    "Icon","warning");
                return

            else

                % Try first detection method
                try
                    [app.base.project.session.spot.signal_starts, ...
                        app.base.project.session.spot.signal_ends] = ...
                        detect_signals(app, app.base.project.session.spot.signal_data, ...
                        numel(app.base.project.session.spot.name));

                 
                    update_continuous_plot(app);
                    return; % Exit if first method succeeds

                catch ME1
                    % If first method fails, try second method
                    try
                        [app.base.project.session.spot.signal_starts, ...
                            app.base.project.session.spot.signal_ends] = ...
                            detect_signals_via_time(app)
              
                        update_continuous_plot(app);
                        return;

                    catch ME2
                        % If both methods fail, display error
                        DisplayError(ME1, 'detect_signals');
                        DisplayError(ME2, 'detect_signals_via_time');

                        message = "Signals could not be detected using either method";
                        uialert(app.UIFigure, message, "Warning", "Icon", "warning");
  
                    end
                end

            end


        end

        % Value changed function: PlotSignalRangesCheckBox
        function PlotSignalRangesCheckBoxValueChanged(app, event)
            update_continuous_plot(app);
        end

        % Value changed function: ShowSpotnamesCheckBox
        function ShowSpotnamesCheckBoxValueChanged(app, event)
            update_continuous_plot(app);
        end

        % Button pushed function: GetMassSpecMetadataButton
        function GetMassSpecMetadataButtonPushed(app, event)
            settings = struct(); % passed to read_mass_spec_metadata_wrapper, which reads the dropdown itself
            
            changes = check_changes(app, 'import');
            if changes == false
                return
            end
            app.editstatus = true;

            try

                if isequal(app.ChooseMassSpecMetadataDropDown.Value, 'Agilent AcqMethod (.xml)')

                    % if the button is pushed it asks for a file with .xml ending
                    f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
                    [filename, pathname] = uigetfile('*.xml', 'Select files', defaultStartDir(app), 'MultiSelect', 'off');
                    delete(f);
                    figure(app.UIFigure);

                    if filename ~= 0
                        app.base.project.session.config.mass_spec_metadata_path = fullfile(pathname, filename);

                        [~, ~, ICP_MS_parameters, dwelltimes, ~, ~]  = read_mass_spec_metadata_wrapper(app, app.base.project.session.config.mass_spec_metadata_path, settings);

                        app.base.project.session.spot.dwelltimes = dwelltimes;

                        if isfield(app.base.project.session.meta, 'icp_ms_parameters')
                            app.base.project.session.meta.icp_ms_parameters = ...
                                mergeStructs(app, app.base.project.session.meta.icp_ms_parameters, ICP_MS_parameters);
                        else
                            app.base.project.session.meta.icp_ms_parameters = ICP_MS_parameters;
                        end

                        app.ShowMassSpecMetadataButton.Enable = 'on';
                    end

                elseif isequal(app.ChooseMassSpecMetadataDropDown.Value, 'Agilent HardwareConfig_ICPQQQ (.xml)') || isequal(app.ChooseMassSpecMetadataDropDown.Value, 'Agilent HardwareConfig_7900 (.xml)')

                    % if the button is pushed it asks for a file with .xml ending
                    f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
                    [filename, pathname] = uigetfile('*.xml', 'Select files', defaultStartDir(app), 'MultiSelect', 'off');
                    delete(f);
                    figure(app.UIFigure);

                    if filename ~= 0

                        app.base.project.session.config.mass_spec_metadata_path = fullfile(pathname, filename);

                        [~, Hardware_parameters, ~, ~, ~, ~]  = read_mass_spec_metadata_wrapper(app, app.base.project.session.config.mass_spec_metadata_path, settings);

                        if isfield(app.base.project.session.meta, 'icp_ms_parameters')
                            app.base.project.session.meta.icp_ms_parameters = ...
                                mergeStructs(app, app.base.project.session.meta.icp_ms_parameters, Hardware_parameters);
                        else
                            app.base.project.session.meta.icp_ms_parameters = Hardware_parameters;
                        end

                    end

                elseif isequal(app.ChooseMassSpecMetadataDropDown.Value, 'Thermo Fisher Element XR (.FIN)')

                    f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
                    [filename, pathname] = uigetfile('*.FIN', 'Select files', defaultStartDir(app), 'MultiSelect', 'off');
                    delete(f);
                    figure(app.UIFigure);

                    if filename ~= 0
                        app.base.project.session.config.mass_spec_metadata_path = fullfile(pathname, filename);

                        [~, ~, ~, dwelltimes, ~, ~]  = read_mass_spec_metadata_wrapper(app, app.base.project.session.config.mass_spec_metadata_path, settings);

                        app.base.project.session.spot.dwelltimes = dwelltimes;

                        app.ShowMassSpecMetadataButton.Enable = 'on';
                    end


                elseif isequal(app.ChooseMassSpecMetadataDropDown.Value, 'ICP_MS_Metadata_Template (.xlsx)')

                    f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
                    [filename, pathname] = uigetfile('*.xlsx', 'Select files', defaultStartDir(app), 'MultiSelect', 'off');
                    delete(f);
                    figure(app.UIFigure);

                    if filename ~= 0
                        app.base.project.session.config.mass_spec_metadata_path = fullfile(pathname, filename);

                        [~, ~, ICP_MS_parameters, ~, ~, ~]  = read_mass_spec_metadata_wrapper(app, app.base.project.session.config.mass_spec_metadata_path, settings);

                        % Merge tuning parameters without overwriting existing fields
                        if isfield(app.base.project.session.meta, 'icp_ms_parameters')
                            app.base.project.session.meta.icp_ms_parameters = ...
                                mergeStructs(app, app.base.project.session.meta.icp_ms_parameters, ICP_MS_parameters);
                        else
                            app.base.project.session.meta.icp_ms_parameters = ICP_MS_parameters;
                        end

                        app.ShowMassSpecMetadataButton.Enable = 'on';
                    end

                elseif isequal(app.ChooseMassSpecMetadataDropDown.Value, 'Dwell_Times_Template (.xlsx)')

                    f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
                    [filename, pathname] = uigetfile('*.xlsx', 'Select files', defaultStartDir(app), 'MultiSelect', 'off');
                    delete(f);
                    figure(app.UIFigure);

                    if filename ~= 0
                        app.base.project.session.config.mass_spec_metadata_path = fullfile(pathname, filename);

                        [~, ~, ~, dwelltimes, ~, ~]  = read_mass_spec_metadata_wrapper(app, app.base.project.session.config.mass_spec_metadata_path, settings);


                            if isfield(app.base.project.session, 'spot') && isfield(app.base.project.session.spot, 'analytes') && ~isempty(app.base.project.session.spot.analytes)
                            % Get analytes list
                            analytes = app.base.project.session.spot.analytes;

                            % Get dwell times variable names
                            dwelltimeVars = dwelltimes.Properties.VariableNames;

                            % Check if all analytes are present in dwell times
                            if ~all(ismember(analytes, dwelltimeVars))
                                message = "The analyte names in the dwell time template do not match the measured analytes. Please check that all analyte names (including isotope numbers) are identical in both files and update the template accordingly or just leave this empty and update the dwell times in the Quantification Module manually.";
                                uialert(app.UIFigure,message,"Warning", ...
                                    "Icon","warning");
                                return;
                            end
                        end

                        app.base.project.session.spot.dwelltimes = dwelltimes;

                        app.ShowMassSpecMetadataButton.Enable = 'on';
                    end

                elseif isequal(app.ChooseMassSpecMetadataDropDown.Value, 'Acquisition_Time_Template (.xlsx)')

                    f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
                    [filename, pathname] = uigetfile('*.xlsx', 'Select files', defaultStartDir(app), 'MultiSelect', 'off');
                    delete(f);
                    figure(app.UIFigure);

                    if filename ~= 0
                        app.base.project.session.config.mass_spec_metadata_path = fullfile(pathname, filename);

                        [~, ~, ~, ~, acquisition_time, ~]  = read_mass_spec_metadata_wrapper(app, app.base.project.session.config.mass_spec_metadata_path, settings);

                        app.base.project.session.spot.acquisition_datetime = acquisition_time;

                        app.ShowMassSpecMetadataButton.Enable = 'on';
                    end

                end

                if isfield(app.base.project.session.config, 'datatype') && isequal(app.base.project.session.config.datatype, 'Single')
                    update_single_panel(app)
                elseif isfield(app.base.project.session.config, 'datatype') && isequal(app.base.project.session.config.datatype, 'Continuous')
                    update_continuous_panel(app)
                    update_manual_selection_panel(app)
                end


            catch ME
                
                DisplayError(ME,'Get Mass-Spec Metadata button')

                message = "Loading Metadata failed";
                uialert(app.UIFigure,message,"Warning", ...
                    "Icon","warning");

            end


        end

        % Button pushed function: ShowMassSpecMetadataButton
        function ShowMassSpecMetadataButtonPushed(app, event)
            if ~isfield(app.base.project.session.meta, 'icp_ms_parameters')
                return
            end

            % Create a new figure window
            fig = uifigure('Name', 'ICP-MS Parameters', 'Position', [100 100 450 600]);

            % Create a uitable
            uit = uitable(fig);
            uit.Position = [20 20 660 560];

            % Get the ICP-MS parameters struct
            icpmsparams = app.base.project.session.meta.icp_ms_parameters;

            % Get field names dynamically
            fieldNames = fieldnames(icpmsparams);

            % Extract values and convert to display format
            fieldValues = cell(length(fieldNames), 1);
            for i = 1:length(fieldNames)
                value = icpmsparams.(fieldNames{i});
                if ischar(value) || isstring(value)
                    fieldValues{i} = value;
                elseif isnumeric(value)
                    fieldValues{i} = num2str(value);
                else
                    fieldValues{i} = class(value);
                end
            end

            % Create table with parameter names and values
            tabledata = table(fieldNames, fieldValues, 'VariableNames', {'Parameter', 'Value'});

            % Set the data
            uit.Data = tabledata;

            % Make parameter names not editable, values editable
            uit.ColumnEditable = [false, false];

            % Adjust column widths
            uit.ColumnWidth = {300, 100};


        end

        % Button pushed function: ShowLaserMetadataButton
        function ShowLaserMetadataButtonPushed(app, event)
            if ~isfield(app.base.project.session.meta, 'laser_parameters')
                return
            end

            % Create a new figure with specified size
            fig = uifigure('Name', 'Logfile Informations', 'Position', [200, 200, 1000, 600]);

            % Create a table in the new figure
            uit = uitable(fig);

            % Get the data
            spotnames = app.base.project.session.spot.name;
            laserparams = app.base.project.session.meta.laser_parameters;

            % Get the expected number of rows
            numSpots = length(spotnames);

            % Get field names dynamically and filter by dimensions
            fieldNames = fieldnames(laserparams);

            % Build table arguments dynamically
            tableArgs = {spotnames};
            varNames = {'Spotname'};

            for i = 1:length(fieldNames)
                fieldData = laserparams.(fieldNames{i});

                % Only include fields with same length as spotname and numeric/logical data
                if ~isempty(fieldData) && (isnumeric(fieldData) || islogical(fieldData)) && length(fieldData) == numSpots
                    tableArgs{end + 1} = fieldData;
                    varNames{end + 1} = fieldNames{i};
                end
            end

            % Create table with dynamic arguments
            tableArgs{end + 1} = 'VariableNames';
            tableArgs{end + 1} = varNames;
            tabledata = table(tableArgs{:});

            % Assign the data to the table
            uit.Data = tabledata;

            % Set the position and size of the table within the figure
            uit.Position = [20 20 960 560];

            % Make ONLY the spotname column (first column) editable
            numColumns = width(tabledata);
            editableColumns = false(1, numColumns);
            editableColumns(1) = true;
            uit.ColumnEditable = editableColumns;

            % Center the column entries
            style = uistyle('HorizontalAlignment', 'center');
            addStyle(uit, style);

            % Add CellEditCallback to update the data structure
            uit.CellEditCallback = @(src, event) updateLogfileInformations(app, src, event);

        end

        % Callback function: ExitMenu, UIFigure
        function ExitMenuSelected(app, event)
            % nothing imported: no signal data in this session
            no_data = isempty(app.base) || isempty(app.base.project) || ...
                ~isfield(app.base.project, 'session') || ~isfield(app.base.project.session, 'spot') || ...
                ~isfield(app.base.project.session.spot, 'signal_data') || isempty(app.base.project.session.spot.signal_data);

            % a new session (not in the base yet) where nothing was imported: close without adding it
            if no_data && (isempty(app.session_id) || isequal(app.session_id, 0))
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

            % import is only done when there is data
            if ~no_data
                session_config = app.base.project.session.config;
                if ~isfield(session_config, 'module_status') ...
                        || ~isfield(session_config.module_status, 'import') ...
                        || ~session_config.module_status.import
                    app.base.project.session.config.module_status.import = true;
                end
            end

            [~,~] =   save_to_base(app.sourceapp, app.project_id, app.base.project.session, app.session_id, app.base.project_name, settings);

            source_app = app.sourceapp;      % must be taken before delete(app)
            delete(app)

            % the window is gone now, so the base can enable the session buttons again
            try
                refresh_session_buttons(source_app)
            catch ME
                DisplayError(ME, 'Refreshing session buttons after closing a module');
            end
        end

        % Value changed function: LogScaleCheckBox
        function LogScaleCheckBoxValueChanged(app, event)

            update_continuous_plot(app)
        end

        % Button pushed function: GetSignalFilesButton
        function GetSignalFilesButtonPushed(app, event)
            changes = check_changes(app, 'import');
            if changes == false
                return
            end
            app.editstatus = true;

            try

                if  isequal(app.ChooseMassSpecDropDown.Value,'Agilent .csv (Continuous)')

                    f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
                    [filename, pathname] = uigetfile('*.csv', 'Select a file', defaultStartDir(app));
                    delete(f);
                    figure(app.UIFigure);

                    if not(filename==0)

                        app.base.project.session.config.signal_path = fullfile(pathname, filename);

                        % this function is also in the API wrapper measurement_logfile_import_public
                        settings.massspec.Value = app.ChooseMassSpecDropDown.Value;

                        [~, signal_data, ~, ~, ~, ~,~, ~] = read_signal_files_wrapper(app, app.base.project.session.config.signal_path, settings);

                        app.base.project.session.spot.signal_data = signal_data;

                        app.base.project.session.spot.analytes = string(app.base.project.session.spot.signal_data.Properties.VariableNames(2:end)');

                        app.base.project.session.config.datatype = 'Continuous';
                        % Plot the continuous Plot for the first time
                        update_continuous_panel(app)
                        update_manual_selection_panel(app)

                        update_manual_selection_panel(app)
                        update_manual_selection_axes(app)

                    end


                elseif  isequal(app.ChooseMassSpecDropDown.Value,'Agilent Batch Folder (.b)')

                    pathname = uigetdir(defaultStartDir(app), 'Select a folder');

                    % make the import here
                    if not(pathname==0)

                        app.base.project.session.config.signal_path = pathname;
                        app.base.project.session.config.mass_spec_metadata_path = pathname;

                        % this function is also in the API wrapper measurement_logfile_import_public
                        settings.massspec.Value = app.ChooseMassSpecDropDown.Value;

                        [~, signal_data, spotname, time, icp_ms_parameters, dwelltimes,~, ~] = read_signal_files_wrapper(app, app.base.project.session.config.signal_path, settings);

                        if length(signal_data) == 1 % Assumption that it is continuous

                            app.base.project.session.spot.signal_data = signal_data{1};
                            app.base.project.session.spot.analytes = string(app.base.project.session.spot.signal_data.Properties.VariableNames(2:end)');
                            app.base.project.session.spot.dwelltimes = dwelltimes;
                            app.base.project.session.meta.icp_ms_parameters = icp_ms_parameters;

                            app.base.project.session.config.datatype = 'Continuous';

                            update_continuous_panel(app)
                            update_manual_selection_panel(app)

                            update_manual_selection_panel(app)
                            update_manual_selection_axes(app)

                            app.SinglePanel.Visible = false;
                            app.ContinuousPanel.Visible = true;
                            app.ManualSelectionPanel.Visible = true;

                        else % Assumption that it it is Single

                            app.base.project.session.spot.signal_data = signal_data';
                            app.base.project.session.spot.name = string(spotname');
                            app.base.project.session.spot.acquisition_datetime = string(time');
                            app.base.project.session.spot.analytes = string(app.base.project.session.spot.signal_data{1}.Properties.VariableNames(2:end)');
                            app.base.project.session.spot.dwelltimes = dwelltimes;
                            app.base.project.session.meta.icp_ms_parameters = icp_ms_parameters;

                            app.base.project.session.config.datatype = 'Single';

                            for i = 1:length(signal_data)
                                [signal_starts, signal_ends] = detect_single_spot_signal_starts_ends(app, signal_data{i});
                                app.base.project.session.spot.signal_starts(i, 1) = signal_starts;
                                app.base.project.session.spot.signal_ends(i, 1) = signal_ends;
                            end

                            % Sort spots by acquisition time
                            acqDt = datetime(app.base.project.session.spot.acquisition_datetime, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
                            if ~issorted(acqDt)
                                [~, idx] = sort(acqDt);
                                app.base.project.session.spot.signal_data      = app.base.project.session.spot.signal_data(idx);
                                app.base.project.session.spot.name             = app.base.project.session.spot.name(idx);
                                app.base.project.session.spot.acquisition_datetime = app.base.project.session.spot.acquisition_datetime(idx);
                                app.base.project.session.spot.signal_starts    = app.base.project.session.spot.signal_starts(idx);
                                app.base.project.session.spot.signal_ends      = app.base.project.session.spot.signal_ends(idx);
                            end

                            app.SinglePanel.Visible = true;
                            app.ContinuousPanel.Visible = false;
                            update_single_panel(app)


                        end

                     
                        app.ShowMassSpecMetadataButton.Enable = 'on';

                    end

                elseif isequal(app.ChooseMassSpecDropDown.Value,'Agilent .csv (Single)') || isequal(app.ChooseMassSpecDropDown.Value,'PerkinElmer .xl (Single)') ||...
                         isequal(app.ChooseMassSpecDropDown.Value,'Thermo Fisher Element XR .FIN2 (Single)') ||  isequal(app.ChooseMassSpecDropDown.Value,'PerkinElmer Nexion .csv (Single)') ||...
                         isequal(app.ChooseMassSpecDropDown.Value,'Thermo Fisher iCAP Q .csv (Single)') || isequal(app.ChooseMassSpecDropDown.Value,'Thermo Fisher Element XR .csv (Single)') ||...
                         isequal(app.ChooseMassSpecDropDown.Value,'Thermo Fisher Neptune .csv (Single)') || isequal(app.ChooseMassSpecDropDown.Value,'Thermo Fisher iCAP RQ .csv (Single)')

                    f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
                    [filenames, pathname] = uigetfile('*.*', 'Select files', defaultStartDir(app), 'MultiSelect', 'on');
                    delete(f);
                    figure(app.UIFigure);

                    if isequal(filenames, 0)
                        return; % User canceled the file selection
                    end

                    app.base.project.session.config.signal_path = pathname;

                    if ischar(filenames)
                        filenames = {filenames}; % Ensure filenames is a cell array
                    end

                    new_signal_paths = fullfile(pathname, filenames)';

                    % this function is also in the API wrapper measurement_logfile_import_public
                    settings.massspec.Value = app.ChooseMassSpecDropDown.Value;

                    if ~isfield(app.base, 'project') || ~isfield(app.base.project, 'session') || ~isfield(app.base.project.session, 'spot')
                        current_length = 0;
                    elseif isfield(app.base.project.session, 'spot') && ~isfield(app.base.project.session.spot, 'signal_data') 
                        current_length = 0;                      
                    elseif isfield(app.base.project.session, 'spot') && isfield(app.base.project.session.spot, 'signal_data') && ~isempty(app.base.project.session.spot.signal_data)
                        current_length = length(app.base.project.session.spot.signal_data);
                    end

                                        % work on local copies and write back once at the end,
                    % so an abort halfway leaves the session untouched
                    if isfield(app.base.project.session, 'spot')
                        spot = app.base.project.session.spot;
                    else
                        spot = struct();
                    end
                    if isfield(app.base.project.session, 'meta')
                        meta = app.base.project.session.meta;
                    else
                        meta = struct();
                    end

                    all_analytes = {};

                    for i = 1:length(filenames)
                        signal_path = new_signal_paths{i};

                        [~, signal_data, spotname, time, icp_ms_parameters, dwelltimes,~, ~] = read_signal_files_wrapper(app, signal_path, settings);

                        % Collect analytes from the current file
                        current_analytes = string(signal_data.Properties.VariableNames(2:end)');
                        if isempty(all_analytes)
                            all_analytes = current_analytes;
                        elseif ~isequal(sort(all_analytes), sort(current_analytes))
                            uialert(app.UIFigure, "Only load files that contain the same analytes!", "Warning", "Icon", "warning");
                            return;
                        end

                        % Check if there are already analytes in the data structure
                        if isfield(spot, 'analytes') && ~isempty(spot.analytes) && ~isequal(sort(spot.analytes), sort(all_analytes))
                            uialert(app.UIFigure, "Only load files that contain the same analytes!", "Warning", "Icon", "warning");
                            return;
                        end

                        spot.analytes = string(current_analytes);

                        spot.signal_data{current_length + i, 1} = signal_data;
                        spot.acquisition_datetime{current_length + i, 1} = time;
                        spot.name{current_length + i, 1} = char(spotname);

                        % signal detection
                        [signal_starts, signal_ends] = detect_single_spot_signal_starts_ends(app, signal_data);
                        spot.signal_starts(current_length + i, 1) = signal_starts;
                        spot.signal_ends(current_length + i, 1) = signal_ends;

                        % icp_ms_parameters of the first spot are used for all of them
                        if ~isempty(fields(icp_ms_parameters))
                            if ~isfield(meta, 'icp_ms_parameters') || isempty(fieldnames(meta.icp_ms_parameters))
                                meta.icp_ms_parameters = icp_ms_parameters;
                            end
                        end
                        if ~isempty(dwelltimes)
                            if ~isfield(spot, 'dwelltimes') || isempty(fieldnames(spot.dwelltimes))
                                spot.dwelltimes = dwelltimes;
                            end
                        end
                    end

                    spot.name = string(spot.name);
                    spot.acquisition_datetime = string(spot.acquisition_datetime);

                    % Sort spots by acquisition time
                    acqDt = datetime(spot.acquisition_datetime, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
                    if ~issorted(acqDt)
                        [~, idx] = sort(acqDt);
                        spot.signal_data          = spot.signal_data(idx);
                        spot.name                 = spot.name(idx);
                        spot.acquisition_datetime = spot.acquisition_datetime(idx);
                        spot.signal_starts        = spot.signal_starts(idx);
                        spot.signal_ends          = spot.signal_ends(idx);
                    end

                    app.base.project.session.spot = spot;
                    app.base.project.session.meta = meta;
                    app.base.project.session.config.datatype = 'Single';
                    update_single_panel(app)


                elseif isequal(app.ChooseMassSpecDropDown.Value,'sills Project')

                    f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
                    [filename, pathname] = uigetfile('*.mat', 'Select a file', defaultStartDir(app));
                    delete(f);
                    figure(app.UIFigure);

                    if not(filename==0)

                        app.base.project.session.config.signal_path = fullfile(pathname, filename);

                        % this function is also in the API wrapper measurement_logfile_import_public
                        settings.massspec.Value = app.ChooseMassSpecDropDown.Value;

                        [~, ~, ~, ~, ~, ~, sills_data, ~] = read_signal_files_wrapper(app, app.base.project.session.config.signal_path, settings);

                        app.base.project.session.spot.name = string(sills_data.Spotname);
                        app.base.project.session.spot.dwelltimes = sills_data.dwelltimes;

                        app.base.project.session.spot.acquisition_datetime = "2026-06-06 " + string(sills_data.AcquisitionTime);

                        app.base.project.session.spot.type = sills_data.Type;
                        app.base.project.session.spot.referencematerial = sills_data.ReferenceMaterial;
                        app.base.project.session.spot.bracket_id = sills_data.bracket_id;

                        app.base.project.session.spot.signal_data = sills_data.SignalData;

                        app.base.project.session.spot.background_starts = sills_data.BackgroundStarts;  
                        app.base.project.session.spot.background_ends = sills_data.BackgroundEnds; 
                        app.base.project.session.spot.inclusion_1_starts = sills_data.InclusionStarts;     
                        app.base.project.session.spot.inclusion_1_ends = sills_data.InclusionEnds;   
                        app.base.project.session.spot.matrix_1_starts = sills_data.Matrix1Starts;  
                        app.base.project.session.spot.matrix_1_ends = sills_data.Matrix1Ends; 
                        app.base.project.session.spot.matrix_2_starts = sills_data.Matrix2Starts;     
                        app.base.project.session.spot.matrix_2_ends = sills_data.Matrix2Ends;   

                        for i = 1:length(sills_data.Spotname)
                            [signal_starts, signal_ends] = detect_single_spot_signal_starts_ends(app, app.base.project.session.spot.signal_data{i});
                            all_signal_starts(i) = signal_starts;
                            all_signal_ends(i) = signal_ends;
                        end

                        app.base.project.session.spot.signal_starts = all_signal_starts';
                        app.base.project.session.spot.signal_ends = all_signal_ends';
                        
                        app.base.project.session.spot.analytes = string(app.base.project.session.spot.signal_data{1}.Properties.VariableNames(2:end)');

                        app.base.project.session.config.datatype = 'Single';
                        update_single_panel(app)
                    end

                elseif isequal(app.ChooseMassSpecDropDown.Value,'Thermo Fisher iCAP RQ .csv (Continuous)')

                    f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
                    [filename, pathname] = uigetfile('*.csv', 'Select a file', defaultStartDir(app));
                    delete(f);
                    figure(app.UIFigure);

                    if not(filename==0)

                        app.base.project.session.config.signal_path = fullfile(pathname, filename);
                        app.base.project.session.config.mass_spec_metadata_path = pathname;

                        % this function is also in the API wrapper measurement_logfile_import_public
                        settings.massspec.Value = app.ChooseMassSpecDropDown.Value;

                        [~, signal_data, ~, ~, icp_ms_parameters, dwelltimes,~, ~] = read_signal_files_wrapper(app, app.base.project.session.config.signal_path, settings);

                        app.base.project.session.spot.signal_data = signal_data;
                        app.base.project.session.meta.icp_ms_parameters = icp_ms_parameters;
                        app.base.project.session.spot.dwelltimes = dwelltimes;
                        app.base.project.session.spot.analytes = string(app.base.project.session.spot.signal_data.Properties.VariableNames(2:end)');

                        app.base.project.session.config.datatype = 'Continuous';

                        update_continuous_panel(app)
                        update_manual_selection_panel(app)
                      
                        app.ShowMassSpecMetadataButton.Enable = 'on';

                        update_manual_selection_panel(app)
                        update_manual_selection_axes(app)

                    end

                elseif isequal(app.ChooseMassSpecDropDown.Value,'PerkinElmer .xl (Continuous)')

                    f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
                    [filename, pathname] = uigetfile('*.*', 'Select a file', defaultStartDir(app));
                    delete(f);
                    figure(app.UIFigure);

                    if not(filename==0)

                        app.base.project.session.config.signal_path = fullfile(pathname, filename);

                        settings.massspec.Value = app.ChooseMassSpecDropDown.Value;

                        [~, signal_data, ~, ~, ~, ~, ~, ~] = read_signal_files_wrapper(app, app.base.project.session.config.signal_path, settings);

                        app.base.project.session.spot.signal_data = signal_data;
                        app.base.project.session.spot.analytes = string(app.base.project.session.spot.signal_data.Properties.VariableNames(2:end)');

                        app.base.project.session.config.datatype = 'Continuous';

                        update_continuous_panel(app)
                        update_manual_selection_panel(app)
                        update_manual_selection_axes(app)

                    end

                elseif isequal(app.ChooseMassSpecDropDown.Value,'PerkinElmer Nexion .csv (Continuous)')

                    f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
                    [filename, pathname] = uigetfile('*.csv', 'Select a file', defaultStartDir(app));
                    delete(f);
                    figure(app.UIFigure);

                    if not(filename==0)

                        app.base.project.session.config.signal_path = fullfile(pathname, filename);

                        settings.massspec.Value = app.ChooseMassSpecDropDown.Value;

                        [~, signal_data, ~, ~, ~, ~, ~, ~] = read_signal_files_wrapper(app, app.base.project.session.config.signal_path, settings);

                        app.base.project.session.spot.signal_data = signal_data;
                        app.base.project.session.spot.analytes = string(app.base.project.session.spot.signal_data.Properties.VariableNames(2:end)');

                        app.base.project.session.config.datatype = 'Continuous';

                        update_continuous_panel(app)
                        update_manual_selection_panel(app)
                        update_manual_selection_axes(app)

                    end

                elseif isequal(app.ChooseMassSpecDropDown.Value,'Thermo Fisher Element XR .FIN2 (Continuous)')

                    f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
                    [filename, pathname] = uigetfile('*.*', 'Select a file', defaultStartDir(app));
                    delete(f);
                    figure(app.UIFigure);

                    if not(filename==0)

                        app.base.project.session.config.signal_path = fullfile(pathname, filename);

                        settings.massspec.Value = app.ChooseMassSpecDropDown.Value;

                        [~, signal_data, ~, ~, ~, ~, ~, ~] = read_signal_files_wrapper(app, app.base.project.session.config.signal_path, settings);

                        app.base.project.session.spot.signal_data = signal_data;
                        app.base.project.session.spot.analytes = string(app.base.project.session.spot.signal_data.Properties.VariableNames(2:end)');

                        app.base.project.session.config.datatype = 'Continuous';

                        update_continuous_panel(app)
                        update_manual_selection_panel(app)
                        update_manual_selection_axes(app)

                    end

                elseif isequal(app.ChooseMassSpecDropDown.Value,'Thermo Fisher Element XR .csv (Continuous)')

                    f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
                    [filename, pathname] = uigetfile('*.csv', 'Select a file', defaultStartDir(app));
                    delete(f);
                    figure(app.UIFigure);

                    if not(filename==0)

                        app.base.project.session.config.signal_path = fullfile(pathname, filename);

                        settings.massspec.Value = app.ChooseMassSpecDropDown.Value;

                        [~, signal_data, ~, ~, ~, ~, ~, ~] = read_signal_files_wrapper(app, app.base.project.session.config.signal_path, settings);

                        app.base.project.session.spot.signal_data = signal_data;
                        app.base.project.session.spot.analytes = string(app.base.project.session.spot.signal_data.Properties.VariableNames(2:end)');

                        app.base.project.session.config.datatype = 'Continuous';

                        update_continuous_panel(app)
                        update_manual_selection_panel(app)
                        update_manual_selection_axes(app)

                    end

                elseif isequal(app.ChooseMassSpecDropDown.Value,'Thermo Fisher iCAP Q .csv (Continuous)')

                    f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
                    [filename, pathname] = uigetfile('*.csv', 'Select a file', defaultStartDir(app));
                    delete(f);
                    figure(app.UIFigure);

                    if not(filename==0)

                        app.base.project.session.config.signal_path = fullfile(pathname, filename);
                        app.base.project.session.config.mass_spec_metadata_path = pathname;

                        settings.massspec.Value = app.ChooseMassSpecDropDown.Value;

                        [~, signal_data, ~, ~, icp_ms_parameters, dwelltimes, ~, ~] = read_signal_files_wrapper(app, app.base.project.session.config.signal_path, settings);

                        app.base.project.session.spot.signal_data = signal_data;
                        app.base.project.session.meta.icp_ms_parameters = icp_ms_parameters;
                        app.base.project.session.spot.dwelltimes = dwelltimes;
                        app.base.project.session.spot.analytes = string(app.base.project.session.spot.signal_data.Properties.VariableNames(2:end)');

                        app.base.project.session.config.datatype = 'Continuous';

                        update_continuous_panel(app)
                        update_manual_selection_panel(app)
                        update_manual_selection_axes(app)

                        app.ShowMassSpecMetadataButton.Enable = 'on';

                    end

                end

            
            catch ME
                DisplayError(ME,'Import failed')

                message = "Import failed";
                uialert(app.UIFigure,message,"Warning", ...
                    "Icon","warning");

            end
        end

        % Value changed function: SingleSpotsListBox
        function SingleSpotsListBoxValueChanged(app, event)
            app.selected_spot = app.SingleSpotsListBox.Value;


            update_single_panel(app)

        end

        % Button pushed function: NextButton
        function NextButtonPushed(app, event)
            %check if this is the first selected_spot, if yes and you
            %press it jumps to the first signal, otherwise it just goes
            %one signal forward
            if app.selected_spot == numel(app.SingleSpotsListBox.Items)

                app.selected_spot = 1;
                app.SingleSpotsListBox.Value = 1;
            else
                app.selected_spot=app.selected_spot + 1;
                app.SingleSpotsListBox.Value=app.SingleSpotsListBox.Value + 1;
            end

            %update the element list and the plot
            update_single_panel(app)
        end

        % Button pushed function: PreviousButton
        function PreviousButtonPushed(app, event)
            %check if this is the first selected_spot, if yes and you
            %press it jumps to the first signal, otherwise it just goes
            %one signal forward
            if app.selected_spot == 1

                app.selected_spot = numel(app.SingleSpotsListBox.Items);
                app.SingleSpotsListBox.Value = numel(app.SingleSpotsListBox.Items);
            else
                app.selected_spot = app.selected_spot - 1;
                app.SingleSpotsListBox.Value=app.SingleSpotsListBox.Value - 1;
            end

            %update the element list and the plot
            update_single_panel(app)
        end

        % Button pushed function: ProceedinInclusionModeButton, 
        % ProceedinInclusionModeButton_2, 
        % ProceedinInclusionModeButton_Single, ProceedinMatrixModeButton, 
        % ProceedinMatrixModeButton_2, ProceedinMatrixModeButton_Single
        function ProceedinMatrixModeButtonPushed(app, event)

            selected_reductiontype = '';
            if contains(event.Source.Text, 'Matrix')
                selected_reductiontype = 'Matrix';
            elseif contains(event.Source.Text, 'Inclusion')
                selected_reductiontype = 'Inclusion';
            end

            proceed_to_interval(app, selected_reductiontype);

        end

        % Callback function: ChooseLaserDropDown, ChooseLaserDropDown
        function ChooseLaserDropDownValueChanged(app, event)

            app.ChooseLaserDropDown.Value = event.Source.Value;

        end

        % Button pushed function: ClassificationButton, DriftButton, 
        % IntervalButton, QuantificationButton, ResultsButton
        function IntervalButtonPushed(app, event)
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

        % Value changed function: globalsignalindentEditField
        function globalsignalindentEditFieldValueChanged(app, event)
            % the indent is applied to the laser on/off times, so a laser log and signal data are needed
            if ~isfield(app.base.project.session, 'spot') || ~isfield(app.base.project.session.spot, 'signal_data') || ...
                    ~isfield(app.base.project.session, 'meta') || ~isfield(app.base.project.session.meta, 'laser_parameters') || ...
                    ~isfield(app.base.project.session.meta.laser_parameters, 'laser_start_times')
                uialert(app.UIFigure, "Load the signal file and the laser log file first, the indent is applied to the laser on/off times.", ...
                    "Warning", "Icon", "warning");
                app.globalsignalindentEditField.Value = event.PreviousValue;
                return
            end

            changes = check_changes(app, 'import');
            if changes == false
                return
            end
            app.editstatus = true;


            app.global_signal_indent = app.globalsignalindentEditField.Value;

            [app.base.project.session.spot.signal_starts, ...
                app.base.project.session.spot.signal_ends] = ...
                detect_signals_via_time(app);

            update_continuous_plot(app);
        end

        % Button pushed function: GetLaserMetadataButton
        function GetLogFileButton_SinglePushed(app, event)
            changes = check_changes(app, 'import');
            if changes == false
                return
            end
            app.editstatus = true;

            try

                if isequal(app.ChooseLaserDropDown.Value, 'Resonetics Verbose Log (.log)') || isequal(app.ChooseLaserDropDown.Value, 'Resonetics Verbose Log Linescan (.log)') 

                    % if the button is pushed it asks for a file with .log ending
                    f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
                    [filename, pathname] = uigetfile('*.log', 'Select a log file', defaultStartDir(app));
                    delete(f);
                    figure(app.UIFigure);

                elseif isequal(app.ChooseLaserDropDown.Value, 'Resonetics Log (.csv)') || isequal(app.ChooseLaserDropDown.Value, 'Agilent/Teledyne (Iolite.csv)')...
                         || isequal(app.ChooseLaserDropDown.Value, 'Resonetics Log Linescan (.csv)') || isequal(app.ChooseLaserDropDown.Value, 'ESL (.csv)') ||...
                         isequal(app.ChooseLaserDropDown.Value, 'Teledyne ScanData (.csv)')

                    % if the button is pushed it asks for a file with .log ending
                    f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
                    [filename, pathname] = uigetfile('*.csv', 'Select a log file', defaultStartDir(app));
                    delete(f);
                    figure(app.UIFigure);

                elseif isequal(app.ChooseLaserDropDown.Value, 'Resonetics Logbook (.xlsx)') || isequal(app.ChooseLaserDropDown.Value, 'LA_Metadata_Template (.xlsx)')

                    % if the button is pushed it asks for a file with .log ending
                    f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
                    [filename, pathname] = uigetfile('*.xlsx', 'Select a log file', defaultStartDir(app));
                    delete(f);
                    figure(app.UIFigure);

                elseif isequal(app.ChooseLaserDropDown.Value, 'Teledyne Iridia (.lase)')
              
                    f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
                    [filename, pathname] = uigetfile('*.lase', 'Select a log file', defaultStartDir(app));
                    delete(f);
                    figure(app.UIFigure);

                end

                if not(filename==0)

                    app.base.project.session.config.laser_metadata_path = fullfile(pathname, filename);

                    settings.laser.Value = app.ChooseLaserDropDown.Value;

                    [~, laser_parameters, ~] = read_laser_metadata_wrapper(app, app.base.project.session.config.laser_metadata_path, settings);

                    app.base.project.session.spot.name = laser_parameters.spotname;

                    app.base.project.session.meta.laser_parameters = laser_parameters;
                    app.base.project.session.meta.laser_parameters = rmfield(app.base.project.session.meta.laser_parameters, 'spotname');

                
                    app.ShowLaserMetadataButton.Enable = 'on';

                end

                if isfield(app.base.project.session.config, 'datatype') && isequal(app.base.project.session.config.datatype, 'Single')
                    update_single_panel(app)
                elseif isfield(app.base.project.session.config, 'datatype') && isequal(app.base.project.session.config.datatype, 'Continuous')
                    update_continuous_panel(app)
                    update_manual_selection_panel(app)
                end

            catch ME
                DisplayError(ME,'Load Laser Metadata')

                message = "Load Laser Metadata failed";
                uialert(app.UIFigure,message,"Warning", ...
                    "Icon","warning");

            end

        end

        % Value changed function: ChooseMassSpecDropDown
        function ChooseMassSpecDropDownValueChanged(app, event)

            app.ChooseMassSpecDropDown.Value = event.Source.Value;

            if isequal(app.ChooseMassSpecDropDown.Value, 'Agilent Batch Folder (.b)')
                app.ChooseMassSpecMetadataDropDown.Enable = 'off';
                app.GetMassSpecMetadataButton.Enable = 'off';

            else
                app.ChooseMassSpecMetadataDropDown.Enable = 'on';
                app.GetMassSpecMetadataButton.Enable = 'on';

            end

        end

        % Value changed function: ChooseMassSpecMetadataDropDown
        function ChooseMassSpecMetadataDropDownValueChanged(app, event)

            app.ChooseMassSpecMetadataDropDown.Value = event.Source.Value;

        end

        % Callback function
        function SpotListBoxValueChanged(app, event)

            app.selected_linescan = app.SpotListBox.Value;

            update_linescan_rolling_average(app)

        end

        % Callback function
        function LinescanAnalyteListBoxValueChanged(app, event)

            app.selected_analytes_linescan = app.LinescanAnalyteListBox.Value;

                update_linescan_rolling_average(app)
        end

        % Menu selected function: MovingaveragesettingsMenu
        function MovingaveragesettingsMenuSelected(app, event)

            if isfield(app.base.project.session.spot, 'signal_starts') && ~isempty(app.base.project.session.spot.signal_starts)

                Moving_average_Submodule(app)

            end


        end

        % Button pushed function: AssignButton
        function AssignButtonPushed(app, event)

            if isempty(app.signal_start_end)
                return
            end


            changes = check_changes(app, 'import');
            if changes == false
                return
            end
            app.editstatus = true;

            store_signal_start_end(app)
            update_manual_selection_axes(app)

        end

        % Value changed function: ManSelElementListBox
        function ManSelElementListBoxValueChanged(app, event)
            app.selected_analytes_man_sel = app.ManSelElementListBox.Value;
            
             update_manual_selection_axes(app)
        end

        % Button down function: ManualSelectionAxes
        function ManualSelectionAxesButtonDown(app, event)
            
        end

        % Button pushed function: DrawRectangleButton
        function DrawRectangleButtonPushed(app, event)

            draw_rectangle(app)
        end

        % Button pushed function: ResetallButton
        function ResetallButtonPushed(app, event)
                        changes = check_changes(app, 'import');
            if changes == false
                return
            end
            app.editstatus = true;

            % Completely delete the fields from spot
            if isfield(app.base.project.session.spot, 'name')
                app.base.project.session.spot = rmfield(app.base.project.session.spot, 'name');
            end
            if isfield(app.base.project.session.spot, 'signal_starts')
                app.base.project.session.spot = rmfield(app.base.project.session.spot, 'signal_starts');
            end
            if isfield(app.base.project.session.spot, 'signal_ends')
                app.base.project.session.spot = rmfield(app.base.project.session.spot, 'signal_ends');
            end

            update_manual_selection_axes(app)
        end

        % Button pushed function: RemovelastButton
        function RemovelastButtonPushed(app, event)
            
                        changes = check_changes(app, 'import');
            if changes == false
                return
            end
            app.editstatus = true;
            
            % Remove last entry from spot.name
            if isfield(app.base.project.session.spot, 'name') && ~isempty(app.base.project.session.spot.name)
                app.base.project.session.spot.name(end) = [];
            end
            % Remove last entry from spot.signal_starts
            if isfield(app.base.project.session.spot, 'signal_starts') && ~isempty(app.base.project.session.spot.signal_starts)
                app.base.project.session.spot.signal_starts(end) = [];
            end
            % Remove last entry from spot.signal_ends
            if isfield(app.base.project.session.spot, 'signal_ends') && ~isempty(app.base.project.session.spot.signal_ends)
                app.base.project.session.spot.signal_ends(end) = [];
            end

            update_manual_selection_axes(app)
        end

        % Menu selected function: DeleteRectangleMenu
        function DeleteRectangleMenuSelected(app, event)
            delete(app.rectangle)

            app.signal_start_end = [];
        end

        % Button pushed function: DetectSingleSignalsButton
        function DetectSingleSignalsButtonPushed(app, event)
            changes = check_changes(app, 'import');
            if changes == false
                return
            end
            app.editstatus = true;


            signal_data = app.base.project.session.spot.signal_data;

            for i = 1:length(signal_data)
                [signal_starts, signal_ends] = detect_single_spot_signal_starts_ends(app, signal_data{i});
                app.base.project.session.spot.signal_starts(i, 1) = signal_starts;
                app.base.project.session.spot.signal_ends(i, 1) = signal_ends;
            end

            update_single_panel(app)

        end

        % Value changed function: DetectionthresholdEditField
        function DetectionthresholdEditFieldValueChanged(app, event)

            DetectSingleSignalsButtonPushed(app)
        end

        % Button pushed function: ShowAcquisitionTimesButton
        function ShowAcquisitionTimesButtonPushed(app, event)
            
            % Create a new figure with specified size
            fig = uifigure('Name', 'Acquisition Times', 'Position', [200, 200, 600, 600]);

            % Create a table in the new figure
            uit = uitable(fig);

            % Get the data
            spotnames = app.base.project.session.spot.name;
            if isfield(app.base.project.session.spot, 'acquisition_datetime')
                dt = datetime(app.base.project.session.spot.acquisition_datetime, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
                acquisitiontimes_str = string(dt, 'HH:mm:ss');     % show time-of-day only
            else
                acquisitiontimes_str = string(app.base.project.session.spot.acquisition_time);
            end


            % Create table with spotname and acquisition times
            tabledata = table(spotnames, acquisitiontimes_str, ...
                'VariableNames', {'Spotname', 'Acquisition_Time'});

            % Assign the data to the table
            uit.Data = tabledata;

            % Set the position and size of the table within the figure
            uit.Position = [20 20 560 560];

            % Make only the spotname column editable (first column)
            uit.ColumnEditable = [false, true];

            % Center the column entries
            style = uistyle('HorizontalAlignment', 'center');
            addStyle(uit, style);

            % Add CellEditCallback to update the data structure
            uit.CellEditCallback = @(src, event) updateAcqTimesInformations(app, src, event);




        end

        % Menu selected function: DDMMformatcheckMenu
        function DDMMformatcheckMenuSelected(app, event)
             
            if ~isfield(app.base.project.session, 'spot')
                uialert(app.UIFigure, "No data has been imported yet, so there are no acquisition dates to swap.", "ICP-Base", "Icon", "warning");
                return
            end

            if isequal(app.base.project.session.config.datatype, 'Continuous')
                uialert(app.UIFigure, "This is a continuous-data session, which has no per-spot acquisition dates to swap.", "ICP-Base", "Icon", "warning");
                return
            end

            if ~isfield(app.base.project.session.spot, 'acquisition_datetime')
                uialert(app.UIFigure, "This session stores only a time of day (no date), so there is nothing to swap.", "ICP-Base", "Icon", "warning");
                return
            end

            % Show the current acquisition dates
            fig = uifigure('Name', 'Swap Day / Month', 'Position', [200 200 600 600]);
            uit = uitable(fig, 'Position', [20 20 560 560], 'ColumnEditable', [false false]);
            addStyle(uit, uistyle('HorizontalAlignment', 'center'));
            uit.Data = table(app.base.project.session.spot.name(:), ...
                string(app.base.project.session.spot.acquisition_datetime(:)), ...
                'VariableNames', {'Spotname', 'yyyy-mm-dd hh:mm:ss'});
                

            % Ask whether to swap
            selection = uiconfirm(fig, "Swap day and month for ALL acquisition dates?", "ICP-Base", ...
                "Options", ["Swap day/month", "Close"], "DefaultOption", 2, "CancelOption", 2);
            if selection ~= "Swap day/month"
                return
            end

            dt = datetime(app.base.project.session.spot.acquisition_datetime, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');

            % A day > 12 cannot become a month -> those dates are already unambiguous
            if any(day(dt) > 12)
                uialert(fig, "Some dates have a day greater than 12, which can't become a month. Those dates are already unambiguous, so a swap isn't possible.", "ICP-Base", "Icon", "warning");
                return
            end

            % Only now does data actually change -> check for downstream resets
            changes = check_changes(app, 'import');
            if changes == false
                return
            end
            app.editstatus = true;

            % Swap month <-> day and write back
            new_dt = datetime(year(dt), day(dt), month(dt), hour(dt), minute(dt), second(dt));
            app.base.project.session.spot.acquisition_datetime = string(new_dt, 'yyyy-MM-dd HH:mm:ss');
            app.base.project.session.config.synced = false;

            % Refresh the display with the swapped dates
            uit.Data = table(app.base.project.session.spot.name(:), ...
                string(app.base.project.session.spot.acquisition_datetime(:)), ...
                'VariableNames', {'Spotname', 'yyyy-mm-dd hh:mm:ss'});



        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1064 750];
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

            % Create DDMMformatcheckMenu
            app.DDMMformatcheckMenu = uimenu(app.SettingsMenu);
            app.DDMMformatcheckMenu.MenuSelectedFcn = createCallbackFcn(app, @DDMMformatcheckMenuSelected, true);
            app.DDMMformatcheckMenu.Text = 'DD/MM format check';

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.UIFigure);
            app.GridLayout2.ColumnWidth = {76, 90, '1x'};
            app.GridLayout2.RowHeight = {35, '1x'};

            % Create TabGroup
            app.TabGroup = uitabgroup(app.GridLayout2);
            app.TabGroup.Layout.Row = 2;
            app.TabGroup.Layout.Column = [1 3];

            % Create GeneralImportTab
            app.GeneralImportTab = uitab(app.TabGroup);
            app.GeneralImportTab.Title = 'General Import';

            % Create MassSpecMetadataEditField
            app.MassSpecMetadataEditField = uieditfield(app.GeneralImportTab, 'text');
            app.MassSpecMetadataEditField.Editable = 'off';
            app.MassSpecMetadataEditField.Position = [86 554 192 25];

            % Create GetMassSpecMetadataButton
            app.GetMassSpecMetadataButton = uibutton(app.GeneralImportTab, 'push');
            app.GetMassSpecMetadataButton.ButtonPushedFcn = createCallbackFcn(app, @GetMassSpecMetadataButtonPushed, true);
            app.GetMassSpecMetadataButton.Position = [288 554 167 25];
            app.GetMassSpecMetadataButton.Text = '3. Get Mass-Spec Metadata';

            % Create ChooseMassSpecMetadataDropDown
            app.ChooseMassSpecMetadataDropDown = uidropdown(app.GeneralImportTab);
            app.ChooseMassSpecMetadataDropDown.Items = {'Agilent AcqMethod (.xml)', 'Agilent HardwareConfig_ICPQQQ (.xml)', 'Agilent HardwareConfig_7900 (.xml)', 'Thermo Fisher Element XR (.FIN)', 'ICP_MS_Metadata_Template (.xlsx)', 'Acquisition_Time_Template (.xlsx)', 'Dwell_Times_Template (.xlsx)'};
            app.ChooseMassSpecMetadataDropDown.ValueChangedFcn = createCallbackFcn(app, @ChooseMassSpecMetadataDropDownValueChanged, true);
            app.ChooseMassSpecMetadataDropDown.Position = [465 554 287 25];
            app.ChooseMassSpecMetadataDropDown.Value = 'Agilent AcqMethod (.xml)';

            % Create ShowMassSpecMetadataButton
            app.ShowMassSpecMetadataButton = uibutton(app.GeneralImportTab, 'push');
            app.ShowMassSpecMetadataButton.ButtonPushedFcn = createCallbackFcn(app, @ShowMassSpecMetadataButtonPushed, true);
            app.ShowMassSpecMetadataButton.Enable = 'off';
            app.ShowMassSpecMetadataButton.Position = [762 554 233 25];
            app.ShowMassSpecMetadataButton.Text = 'Show Mass-Spec Metadata';

            % Create LaserMetadataFileEditField
            app.LaserMetadataFileEditField = uieditfield(app.GeneralImportTab, 'text');
            app.LaserMetadataFileEditField.Editable = 'off';
            app.LaserMetadataFileEditField.Position = [86 589 192 22];

            % Create GetLaserMetadataButton
            app.GetLaserMetadataButton = uibutton(app.GeneralImportTab, 'push');
            app.GetLaserMetadataButton.ButtonPushedFcn = createCallbackFcn(app, @GetLogFileButton_SinglePushed, true);
            app.GetLaserMetadataButton.Position = [288 589 167 22];
            app.GetLaserMetadataButton.Text = '2. Get Laser Metadata';

            % Create ChooseLaserDropDown
            app.ChooseLaserDropDown = uidropdown(app.GeneralImportTab);
            app.ChooseLaserDropDown.Items = {'Resonetics Verbose Log (.log)', 'Resonetics Log (.csv)', 'Resonetics Logbook (.xlsx)', 'Teledyne Iridia (.lase)', 'Teledyne ScanData (.csv)', 'Agilent/Teledyne (Iolite.csv)', 'ESL (.csv)', 'LA_Metadata_Template (.xlsx)', 'Resonetics Log Linescan (.csv)', 'Resonetics Verbose Log Linescan (.log)'};
            app.ChooseLaserDropDown.DropDownOpeningFcn = createCallbackFcn(app, @ChooseLaserDropDownValueChanged, true);
            app.ChooseLaserDropDown.ValueChangedFcn = createCallbackFcn(app, @ChooseLaserDropDownValueChanged, true);
            app.ChooseLaserDropDown.Position = [465 589 287 22];
            app.ChooseLaserDropDown.Value = 'Resonetics Verbose Log (.log)';

            % Create ShowLaserMetadataButton
            app.ShowLaserMetadataButton = uibutton(app.GeneralImportTab, 'push');
            app.ShowLaserMetadataButton.ButtonPushedFcn = createCallbackFcn(app, @ShowLaserMetadataButtonPushed, true);
            app.ShowLaserMetadataButton.Enable = 'off';
            app.ShowLaserMetadataButton.Position = [762 589 233 22];
            app.ShowLaserMetadataButton.Text = 'Show Laser Metadata';

            % Create SignalFileEditField
            app.SignalFileEditField = uieditfield(app.GeneralImportTab, 'text');
            app.SignalFileEditField.Editable = 'off';
            app.SignalFileEditField.Position = [86 621 192 22];

            % Create GetSignalFilesButton
            app.GetSignalFilesButton = uibutton(app.GeneralImportTab, 'push');
            app.GetSignalFilesButton.ButtonPushedFcn = createCallbackFcn(app, @GetSignalFilesButtonPushed, true);
            app.GetSignalFilesButton.Position = [288 621 167 22];
            app.GetSignalFilesButton.Text = '1. Get Signal File';

            % Create ChooseMassSpecDropDown
            app.ChooseMassSpecDropDown = uidropdown(app.GeneralImportTab);
            app.ChooseMassSpecDropDown.Items = {'Agilent Batch Folder (.b)', 'Agilent .csv (Single)', 'Agilent .csv (Continuous)', 'PerkinElmer .xl (Single)', 'PerkinElmer .xl (Continuous)', 'PerkinElmer Nexion .csv (Single)', 'PerkinElmer Nexion .csv (Continuous)', 'Thermo Fisher Element XR .FIN2 (Single)', 'Thermo Fisher Element XR .FIN2 (Continuous)', 'Thermo Fisher Element XR .csv (Single)', 'Thermo Fisher Element XR .csv (Continuous)', 'Thermo Fisher iCAP RQ .csv (Single)', 'Thermo Fisher iCAP RQ .csv (Continuous)', 'Thermo Fisher iCAP Q .csv (Single)', 'Thermo Fisher iCAP Q .csv (Continuous)', 'Thermo Fisher Neptune .csv (Single)', 'sills Project'};
            app.ChooseMassSpecDropDown.ValueChangedFcn = createCallbackFcn(app, @ChooseMassSpecDropDownValueChanged, true);
            app.ChooseMassSpecDropDown.Position = [465 621 287 22];
            app.ChooseMassSpecDropDown.Value = 'Agilent Batch Folder (.b)';

            % Create SinglePanel
            app.SinglePanel = uipanel(app.GeneralImportTab);
            app.SinglePanel.Visible = 'off';
            app.SinglePanel.Position = [11 34 1029 510];

            % Create SingleSpotAxes
            app.SingleSpotAxes = uiaxes(app.SinglePanel);
            title(app.SingleSpotAxes, 'Title')
            xlabel(app.SingleSpotAxes, 'Sweeps')
            ylabel(app.SingleSpotAxes, 'Intensity [cps]')
            zlabel(app.SingleSpotAxes, 'Z')
            app.SingleSpotAxes.Colormap = [];
            app.SingleSpotAxes.Box = 'on';
            app.SingleSpotAxes.Position = [16 46 717 448];

            % Create PreviousButton
            app.PreviousButton = uibutton(app.SinglePanel, 'push');
            app.PreviousButton.ButtonPushedFcn = createCallbackFcn(app, @PreviousButtonPushed, true);
            app.PreviousButton.Position = [782 456 103 35];
            app.PreviousButton.Text = 'Previous';

            % Create NextButton
            app.NextButton = uibutton(app.SinglePanel, 'push');
            app.NextButton.ButtonPushedFcn = createCallbackFcn(app, @NextButtonPushed, true);
            app.NextButton.Position = [891 456 103 35];
            app.NextButton.Text = 'Next';

            % Create SingleSpotsListBox
            app.SingleSpotsListBox = uilistbox(app.SinglePanel);
            app.SingleSpotsListBox.Items = {''};
            app.SingleSpotsListBox.ValueChangedFcn = createCallbackFcn(app, @SingleSpotsListBoxValueChanged, true);
            app.SingleSpotsListBox.Position = [782 63 212 392];
            app.SingleSpotsListBox.Value = '';

            % Create DetectSingleSignalsButton
            app.DetectSingleSignalsButton = uibutton(app.SinglePanel, 'push');
            app.DetectSingleSignalsButton.ButtonPushedFcn = createCallbackFcn(app, @DetectSingleSignalsButtonPushed, true);
            app.DetectSingleSignalsButton.Position = [238 8 139 27];
            app.DetectSingleSignalsButton.Text = 'Detect Signals';

            % Create ProceedinMatrixModeButton_Single
            app.ProceedinMatrixModeButton_Single = uibutton(app.SinglePanel, 'push');
            app.ProceedinMatrixModeButton_Single.ButtonPushedFcn = createCallbackFcn(app, @ProceedinMatrixModeButtonPushed, true);
            app.ProceedinMatrixModeButton_Single.Position = [699 10 142 24];
            app.ProceedinMatrixModeButton_Single.Text = 'Proceed in Matrix Mode';

            % Create ProceedinInclusionModeButton_Single
            app.ProceedinInclusionModeButton_Single = uibutton(app.SinglePanel, 'push');
            app.ProceedinInclusionModeButton_Single.ButtonPushedFcn = createCallbackFcn(app, @ProceedinMatrixModeButtonPushed, true);
            app.ProceedinInclusionModeButton_Single.Position = [848 10 162 24];
            app.ProceedinInclusionModeButton_Single.Text = 'Proceed in Inclusion Mode';

            % Create DetectionthresholdEditFieldLabel
            app.DetectionthresholdEditFieldLabel = uilabel(app.SinglePanel);
            app.DetectionthresholdEditFieldLabel.HorizontalAlignment = 'right';
            app.DetectionthresholdEditFieldLabel.Position = [49 10 114 24];
            app.DetectionthresholdEditFieldLabel.Text = 'Detection threshold:';

            % Create DetectionthresholdEditField
            app.DetectionthresholdEditField = uieditfield(app.SinglePanel, 'numeric');
            app.DetectionthresholdEditField.Limits = [0 1];
            app.DetectionthresholdEditField.ValueChangedFcn = createCallbackFcn(app, @DetectionthresholdEditFieldValueChanged, true);
            app.DetectionthresholdEditField.Position = [170 10 43 24];
            app.DetectionthresholdEditField.Value = 0.01;

            % Create ShowAcquisitionTimesButton
            app.ShowAcquisitionTimesButton = uibutton(app.SinglePanel, 'push');
            app.ShowAcquisitionTimesButton.ButtonPushedFcn = createCallbackFcn(app, @ShowAcquisitionTimesButtonPushed, true);
            app.ShowAcquisitionTimesButton.Position = [456 10 188 24];
            app.ShowAcquisitionTimesButton.Text = 'Show Acquisition Times';

            % Create ContinuousPanel
            app.ContinuousPanel = uipanel(app.GeneralImportTab);
            app.ContinuousPanel.Visible = 'off';
            app.ContinuousPanel.Position = [13 13 1022 532];

            % Create ContinuousPlot
            app.ContinuousPlot = uiaxes(app.ContinuousPanel);
            xlabel(app.ContinuousPlot, 'Sweeps')
            ylabel(app.ContinuousPlot, 'Intensity [cps]')
            zlabel(app.ContinuousPlot, 'Z')
            app.ContinuousPlot.Colormap = [];
            app.ContinuousPlot.Box = 'on';
            app.ContinuousPlot.Position = [8 39 936 456];

            % Create orenterglobalindentLabel
            app.orenterglobalindentLabel = uilabel(app.ContinuousPanel);
            app.orenterglobalindentLabel.Position = [341 6 122 28];
            app.orenterglobalindentLabel.Text = 'or enter global indent:';

            % Create andpressenterkeyLabel
            app.andpressenterkeyLabel = uilabel(app.ContinuousPanel);
            app.andpressenterkeyLabel.Position = [542 6 122 28];
            app.andpressenterkeyLabel.Text = 'and press enter key';

            % Create ProceedinInclusionModeButton
            app.ProceedinInclusionModeButton = uibutton(app.ContinuousPanel, 'push');
            app.ProceedinInclusionModeButton.ButtonPushedFcn = createCallbackFcn(app, @ProceedinMatrixModeButtonPushed, true);
            app.ProceedinInclusionModeButton.Position = [861 5 149 30];
            app.ProceedinInclusionModeButton.Text = 'Proceed in Inclusion Mode';

            % Create ProceedinMatrixModeButton
            app.ProceedinMatrixModeButton = uibutton(app.ContinuousPanel, 'push');
            app.ProceedinMatrixModeButton.ButtonPushedFcn = createCallbackFcn(app, @ProceedinMatrixModeButtonPushed, true);
            app.ProceedinMatrixModeButton.Position = [710 5 146 30];
            app.ProceedinMatrixModeButton.Text = 'Proceed in Matrix Mode';

            % Create DetectSignalsButton
            app.DetectSignalsButton = uibutton(app.ContinuousPanel, 'push');
            app.DetectSignalsButton.ButtonPushedFcn = createCallbackFcn(app, @DetectSignalsButtonPushed, true);
            app.DetectSignalsButton.Position = [191 5 136 30];
            app.DetectSignalsButton.Text = 'Detect Signals';

            % Create globalsignalindentEditField
            app.globalsignalindentEditField = uieditfield(app.ContinuousPanel, 'numeric');
            app.globalsignalindentEditField.ValueChangedFcn = createCallbackFcn(app, @globalsignalindentEditFieldValueChanged, true);
            app.globalsignalindentEditField.Tooltip = {'Global Indent'};
            app.globalsignalindentEditField.Position = [471 7 60 26];

            % Create ShowSpotnamesCheckBox
            app.ShowSpotnamesCheckBox = uicheckbox(app.ContinuousPanel);
            app.ShowSpotnamesCheckBox.ValueChangedFcn = createCallbackFcn(app, @ShowSpotnamesCheckBoxValueChanged, true);
            app.ShowSpotnamesCheckBox.Text = 'Show Spotnames';
            app.ShowSpotnamesCheckBox.Position = [236 495 122 30];

            % Create PlotSignalRangesCheckBox
            app.PlotSignalRangesCheckBox = uicheckbox(app.ContinuousPanel);
            app.PlotSignalRangesCheckBox.ValueChangedFcn = createCallbackFcn(app, @PlotSignalRangesCheckBoxValueChanged, true);
            app.PlotSignalRangesCheckBox.Text = 'Plot Signal Ranges';
            app.PlotSignalRangesCheckBox.Position = [111 495 120 30];
            app.PlotSignalRangesCheckBox.Value = true;

            % Create LogScaleCheckBox
            app.LogScaleCheckBox = uicheckbox(app.ContinuousPanel);
            app.LogScaleCheckBox.ValueChangedFcn = createCallbackFcn(app, @LogScaleCheckBoxValueChanged, true);
            app.LogScaleCheckBox.Text = 'Log-Scale';
            app.LogScaleCheckBox.Position = [20 495 87 30];
            app.LogScaleCheckBox.Value = true;

            % Create ContinuousPlotElementsListBox
            app.ContinuousPlotElementsListBox = uilistbox(app.ContinuousPanel);
            app.ContinuousPlotElementsListBox.Items = {};
            app.ContinuousPlotElementsListBox.Multiselect = 'on';
            app.ContinuousPlotElementsListBox.ValueChangedFcn = createCallbackFcn(app, @ContinuousPlotElementsListBoxValueChanged, true);
            app.ContinuousPlotElementsListBox.Position = [944 39 71 482];
            app.ContinuousPlotElementsListBox.Value = {};

            % Create ManualSelectionTab
            app.ManualSelectionTab = uitab(app.TabGroup);
            app.ManualSelectionTab.Title = 'Manual Selection';

            % Create ManualSelectionPanel
            app.ManualSelectionPanel = uipanel(app.ManualSelectionTab);
            app.ManualSelectionPanel.Visible = 'off';
            app.ManualSelectionPanel.Position = [3 10 1037 643];

            % Create ManualSelectionAxes
            app.ManualSelectionAxes = uiaxes(app.ManualSelectionPanel);
            xlabel(app.ManualSelectionAxes, 'Sweeps')
            ylabel(app.ManualSelectionAxes, 'Intensity')
            app.ManualSelectionAxes.Box = 'on';
            app.ManualSelectionAxes.ButtonDownFcn = createCallbackFcn(app, @ManualSelectionAxesButtonDown, true);
            app.ManualSelectionAxes.Position = [6 55 949 552];

            % Create RemovelastButton
            app.RemovelastButton = uibutton(app.ManualSelectionPanel, 'push');
            app.RemovelastButton.ButtonPushedFcn = createCallbackFcn(app, @RemovelastButtonPushed, true);
            app.RemovelastButton.Position = [607 606 84 26];
            app.RemovelastButton.Text = 'Remove last';

            % Create ResetallButton
            app.ResetallButton = uibutton(app.ManualSelectionPanel, 'push');
            app.ResetallButton.ButtonPushedFcn = createCallbackFcn(app, @ResetallButtonPushed, true);
            app.ResetallButton.Position = [699 606 65 26];
            app.ResetallButton.Text = 'Reset all';

            % Create ProceedinMatrixModeButton_2
            app.ProceedinMatrixModeButton_2 = uibutton(app.ManualSelectionPanel, 'push');
            app.ProceedinMatrixModeButton_2.ButtonPushedFcn = createCallbackFcn(app, @ProceedinMatrixModeButtonPushed, true);
            app.ProceedinMatrixModeButton_2.Position = [714 15 145 30];
            app.ProceedinMatrixModeButton_2.Text = 'Proceed in Matrix Mode';

            % Create ProceedinInclusionModeButton_2
            app.ProceedinInclusionModeButton_2 = uibutton(app.ManualSelectionPanel, 'push');
            app.ProceedinInclusionModeButton_2.ButtonPushedFcn = createCallbackFcn(app, @ProceedinMatrixModeButtonPushed, true);
            app.ProceedinInclusionModeButton_2.Position = [869 15 163 30];
            app.ProceedinInclusionModeButton_2.Text = 'Proceed in Inclusion Mode';

            % Create DrawRectangleButton
            app.DrawRectangleButton = uibutton(app.ManualSelectionPanel, 'push');
            app.DrawRectangleButton.ButtonPushedFcn = createCallbackFcn(app, @DrawRectangleButtonPushed, true);
            app.DrawRectangleButton.Position = [24 15 239 30];
            app.DrawRectangleButton.Text = 'Draw Rectangle';

            % Create AssignButton
            app.AssignButton = uibutton(app.ManualSelectionPanel, 'push');
            app.AssignButton.ButtonPushedFcn = createCallbackFcn(app, @AssignButtonPushed, true);
            app.AssignButton.Position = [520 15 171 31];
            app.AssignButton.Text = 'Assign';

            % Create ManSelElementListBox
            app.ManSelElementListBox = uilistbox(app.ManualSelectionPanel);
            app.ManSelElementListBox.Items = {};
            app.ManSelElementListBox.Multiselect = 'on';
            app.ManSelElementListBox.ValueChangedFcn = createCallbackFcn(app, @ManSelElementListBoxValueChanged, true);
            app.ManSelElementListBox.Position = [964 92 65 496];
            app.ManSelElementListBox.Value = {};

            % Create SpotnameEditFieldLabel
            app.SpotnameEditFieldLabel = uilabel(app.ManualSelectionPanel);
            app.SpotnameEditFieldLabel.HorizontalAlignment = 'right';
            app.SpotnameEditFieldLabel.Position = [272 20 64 22];
            app.SpotnameEditFieldLabel.Text = 'Spotname:';

            % Create SpotnameEditField
            app.SpotnameEditField = uieditfield(app.ManualSelectionPanel, 'text');
            app.SpotnameEditField.Position = [351 16 161 30];

            % Create ProgressPanel
            app.ProgressPanel = uipanel(app.GridLayout2);
            app.ProgressPanel.Layout.Row = 1;
            app.ProgressPanel.Layout.Column = [1 3];

            % Create IntervalButton
            app.IntervalButton = uibutton(app.ProgressPanel, 'push');
            app.IntervalButton.ButtonPushedFcn = createCallbackFcn(app, @IntervalButtonPushed, true);
            app.IntervalButton.Position = [131 6 100 23];
            app.IntervalButton.Text = 'Interval';

            % Create ImportButton
            app.ImportButton = uibutton(app.ProgressPanel, 'push');
            app.ImportButton.Position = [11 6 100 23];
            app.ImportButton.Text = 'Import';

            % Create ClassificationButton
            app.ClassificationButton = uibutton(app.ProgressPanel, 'push');
            app.ClassificationButton.ButtonPushedFcn = createCallbackFcn(app, @IntervalButtonPushed, true);
            app.ClassificationButton.Position = [263 6 100 23];
            app.ClassificationButton.Text = 'Classification';

            % Create DriftButton
            app.DriftButton = uibutton(app.ProgressPanel, 'push');
            app.DriftButton.ButtonPushedFcn = createCallbackFcn(app, @IntervalButtonPushed, true);
            app.DriftButton.Position = [389 6 100 23];
            app.DriftButton.Text = 'Drift';

            % Create QuantificationButton
            app.QuantificationButton = uibutton(app.ProgressPanel, 'push');
            app.QuantificationButton.ButtonPushedFcn = createCallbackFcn(app, @IntervalButtonPushed, true);
            app.QuantificationButton.Position = [509 6 100 23];
            app.QuantificationButton.Text = 'Quantification';

            % Create ResultsButton
            app.ResultsButton = uibutton(app.ProgressPanel, 'push');
            app.ResultsButton.ButtonPushedFcn = createCallbackFcn(app, @IntervalButtonPushed, true);
            app.ResultsButton.Position = [633 6 100 23];
            app.ResultsButton.Text = 'Results';

            % Create ContextMenu
            app.ContextMenu = uicontextmenu(app.UIFigure);

            % Create MovingaveragesettingsMenu
            app.MovingaveragesettingsMenu = uimenu(app.ContextMenu);
            app.MovingaveragesettingsMenu.MenuSelectedFcn = createCallbackFcn(app, @MovingaveragesettingsMenuSelected, true);
            app.MovingaveragesettingsMenu.Text = 'Moving average settings';
            
            % Assign app.ContextMenu
            app.ProceedinMatrixModeButton_Single.ContextMenu = app.ContextMenu;
            app.ProceedinMatrixModeButton.ContextMenu = app.ContextMenu;
            app.ProceedinMatrixModeButton_2.ContextMenu = app.ContextMenu;

            % Create ContextMenu2
            app.ContextMenu2 = uicontextmenu(app.UIFigure);

            % Create DeleteRectangleMenu
            app.DeleteRectangleMenu = uimenu(app.ContextMenu2);
            app.DeleteRectangleMenu.MenuSelectedFcn = createCallbackFcn(app, @DeleteRectangleMenuSelected, true);
            app.DeleteRectangleMenu.Text = 'Delete Rectangle';
            
            % Assign app.ContextMenu2
            app.DrawRectangleButton.ContextMenu = app.ContextMenu2;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Import_Module_readable(varargin)

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