% GENERATED from Interval_Module.mlapp on 2026-10-28 15:37 by export_mlapp_to_m. This file is for reading purposes, any real changes need to be applied to the .mlapp files and exported again.
classdef Interval_Module_readable < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        BaseMenu                        matlab.ui.container.Menu
        ExitMenu                        matlab.ui.container.Menu
        SettingsMenu                    matlab.ui.container.Menu
        AdjustAxisFontsizeMenu          matlab.ui.container.Menu
        ChangeplotstylesfolderMenu      matlab.ui.container.Menu
        HeatmapColormapMenu             matlab.ui.container.Menu
        SpikeEliminationMenu            matlab.ui.container.Menu
        GeneratespikereportMenu         matlab.ui.container.Menu
        SetspikethresholdMenu           matlab.ui.container.Menu
        GridLayout3                     matlab.ui.container.GridLayout
        DatatipsOnOffButton             matlab.ui.control.StateButton
        ProgressPanel                   matlab.ui.container.Panel
        ResultsButton                   matlab.ui.control.Button
        QuantificationButton            matlab.ui.control.Button
        DriftButton                     matlab.ui.control.Button
        ClassificationButton            matlab.ui.control.Button
        ImportButton                    matlab.ui.control.Button
        IntervalButton                  matlab.ui.control.Button
        LocalIntervalSettingCheckBox    matlab.ui.control.CheckBox
        GlobalIntervalPanel             matlab.ui.container.Panel
        GridLayout2                     matlab.ui.container.GridLayout
        LowerLimitLabel_2               matlab.ui.control.Label
        UpperLimitLabel_2               matlab.ui.control.Label
        LowerLimitLabel                 matlab.ui.control.Label
        DeleteMatrixButton              matlab.ui.control.Button
        matrix_upper_indentEditField    matlab.ui.control.NumericEditField
        matrix_lower_indentEditField    matlab.ui.control.NumericEditField
        MatrixUpperLimitPlusTenButton   matlab.ui.control.Button
        MatrixUpperLimitMinusTenButton  matlab.ui.control.Button
        MatrixUpperLimitPlusOneButton   matlab.ui.control.Button
        MatrixUpperLimitMinusOneButton  matlab.ui.control.Button
        MatrixLowerLimitPlusTenButton   matlab.ui.control.Button
        MatrixLowerLimitMinusTenButton  matlab.ui.control.Button
        MatrixLowerLimitPlusOneButton   matlab.ui.control.Button
        MatrixLowerLimitMinusOneButton  matlab.ui.control.Button
        SetMatrixButton                 matlab.ui.control.Button
        DeleteBackgroundsButton         matlab.ui.control.Button
        bg_upper_indentEditField        matlab.ui.control.NumericEditField
        bg_lower_indentEditField        matlab.ui.control.NumericEditField
        UpperLimitLabel                 matlab.ui.control.Label
        BgUpperLimitPlusTenButton       matlab.ui.control.Button
        BgUpperLimitMinusTenButton      matlab.ui.control.Button
        BgUpperLimitPlusOneButton       matlab.ui.control.Button
        BgUpperLimitMinusOneButton      matlab.ui.control.Button
        BgLowerLimitPlusTenButton       matlab.ui.control.Button
        BgLowerLimitMinusTenButton      matlab.ui.control.Button
        BgLowerLimitPlusOneButton       matlab.ui.control.Button
        BgLowerLimitMinusOneButton      matlab.ui.control.Button
        SetBackgroundsButton            matlab.ui.control.Button
        GlobalIntervalSettingCheckBox   matlab.ui.control.CheckBox
        ShowIntervalsCheckBox           matlab.ui.control.CheckBox
        ResetSpikeEliminationButton     matlab.ui.control.Button
        LocalIntervalPanel              matlab.ui.container.Panel
        GridLayout                      matlab.ui.container.GridLayout
        TwoISPanel                      matlab.ui.container.Panel
        HostfromspotDropDown            matlab.ui.control.DropDown
        HostonlytracerLabel             matlab.ui.control.Label
        MOTPanel                        matlab.ui.container.Panel
        MatrixonlytracerDropDown        matlab.ui.control.DropDown
        MatrixonlytracerDropDownLabel   matlab.ui.control.Label
        ShowhostcontributionCheckBox    matlab.ui.control.CheckBox
        FromSpotDropDown                matlab.ui.control.DropDown
        FromSpotDropDownLabel           matlab.ui.control.Label
        UnmixingviaLabel                matlab.ui.control.Label
        UnmixingviaDropDown             matlab.ui.control.DropDown
        Delete3MatrixButton             matlab.ui.control.Button
        Set3MatrixButton                matlab.ui.control.Button
        Delete2MatrixButton             matlab.ui.control.Button
        Set2MatrixButton                matlab.ui.control.Button
        DeleteInclusionButton           matlab.ui.control.Button
        SetInclusionButton              matlab.ui.control.Button
        Delete1MatrixButton             matlab.ui.control.Button
        DeleteBackgroundButton          matlab.ui.control.Button
        Set1MatrixButton                matlab.ui.control.Button
        SetBackgroundButton             matlab.ui.control.Button
        CommentTextArea                 matlab.ui.control.TextArea
        ShowLegendCheckBox              matlab.ui.control.CheckBox
        ProceedtoClassificationModuleButton  matlab.ui.control.Button
        LogscaleCheckBox                matlab.ui.control.CheckBox
        EliminateSpikesButton           matlab.ui.control.Button
        ZoomintoSignalCheckBox          matlab.ui.control.CheckBox
        PlotBackgroundcorrectedCheckBox  matlab.ui.control.CheckBox
        PlotstylesListBox               matlab.ui.control.ListBox
        PreviousSignalButton            matlab.ui.control.Button
        SpotListBox                     matlab.ui.control.ListBox
        NextSignalButton                matlab.ui.control.Button
        ElementLegendListBox            matlab.ui.control.ListBox
        SpotAxes                        matlab.ui.control.UIAxes
        ContextMenu2                    matlab.ui.container.ContextMenu
        ApplygloballyMenu_2             matlab.ui.container.Menu
        ContextMenu3                    matlab.ui.container.ContextMenu
        ApplygloballyMenu               matlab.ui.container.Menu
        IndividualMenu                  matlab.ui.container.Menu
        IndividualInclusiononlyMenu     matlab.ui.container.Menu
        ContextMenu4                    matlab.ui.container.ContextMenu
        RefreshMenu                     matlab.ui.container.Menu
        ContextMenu5                    matlab.ui.container.ContextMenu
        SetforspotgroupsMenu            matlab.ui.container.Menu
        ContextMenu6                    matlab.ui.container.ContextMenu
        ApplytoallMenu                  matlab.ui.container.Menu
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

        active_spot
        active_spot_indices
        selected_spot

        ColorMapValues
        ColorMaps

        editstatus = false % once this is true it asks if the data should be saved

    end

    properties (Access = private)

        selected_analytes
        signal_start_idx
        signal_end_idx

        % variables for the moving interval lines
        hLineToDrag
        hVerticalLines
        hVerticalLinesBounds

        % variables for the plotstyles
        selected_plotstyle
        active_ratios
        ratioplotting
        plotstyles
        plotstyle_path

        % for setting the intervals manually
        selected_interval_type



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

        function get_plotstyles(app)

            csvFiles = dir(fullfile(app.plotstyle_path, '*.csv'));

            analytes    = app.base.project.session.spot.analytes;
            numAnalytes = length(analytes);
            app.plotstyles.Default.Analytes = analytes;
            app.plotstyles.Heatmap.Analytes = analytes;

            colors = lines(numAnalytes);

            if isequal(app.base.project.session.config.reductiontype, 'Matrix')
                app.plotstyles.Default.Color           = arrayfun(@(i) colors(i, :), 1:numAnalytes, 'UniformOutput', false);
                app.plotstyles.Default.LineWidth       = repmat(1.5, numAnalytes, 1);
                app.plotstyles.Default.Linestyle       = repmat("-",      numAnalytes, 1);
                app.plotstyles.Default.Marker          = repmat("none",   numAnalytes, 1);
                app.plotstyles.Default.MarkerSize      = repmat("none",   numAnalytes, 1);
                app.plotstyles.Default.MarkerFaceColor = repmat("none",   numAnalytes, 1);
                app.plotstyles.Default.MarkerEdgeColor = repmat("none",   numAnalytes, 1);

            elseif isequal(app.base.project.session.config.reductiontype, 'Inclusion')
                app.plotstyles.Default.Color           = arrayfun(@(i) colors(i, :), 1:numAnalytes, 'UniformOutput', false);
                app.plotstyles.Default.LineWidth       = repmat(1.5, numAnalytes, 1);
                app.plotstyles.Default.Linestyle       = repmat("-",     numAnalytes, 1);
                app.plotstyles.Default.Marker          = repmat(".",     numAnalytes, 1);
                app.plotstyles.Default.MarkerSize      = repmat(1,       numAnalytes, 1);
                app.plotstyles.Default.MarkerFaceColor = repmat("black", numAnalytes, 1);
                app.plotstyles.Default.MarkerEdgeColor = repmat("black", numAnalytes, 1);
            end

            for k = 1:length(csvFiles)
                baseFileName = csvFiles(k).name;
                fullFileName = fullfile(app.plotstyle_path, baseFileName);
                try
                    data = readtable(fullFileName, 'TextType', 'string');
                    data = data(~any(ismissing(data), 2), :);
                    dataStruct = table2struct(data, 'ToScalar', true);
                    [~, name, ~] = fileparts(baseFileName);
                    app.plotstyles.(name) = dataStruct;
                catch ME
                    DisplayError(ME, 'Failed to import plotstyles')
                    message = ['Failed to read or process file (probably invalid filename containing a hyphen): ', baseFileName];
                    uialert(app.UIFigure, message, "Warning", "Icon", "warning");
                end
            end
        end

        function update_reductiontype(app)
            switch app.base.project.session.config.reductiontype
                case 'Matrix'
                    app.GlobalIntervalSettingCheckBox.Value = true;
                    app.LocalIntervalSettingCheckBox.Value = false;

                    fields_to_check = {'background_starts', 'background_ends', ...
                        'matrix_1_starts', 'matrix_1_ends', ...
                        'matrix_2_starts', 'matrix_2_ends', ...
                        'matrix_3_starts', 'matrix_3_ends'};

                    for field = fields_to_check
                        if ~isfield(app.base.project.session.spot, field{1}) || ...
                                all(isnan(app.base.project.session.spot.(field{1})))
                            app.base.project.session.spot.(field{1}) = NaN(size(app.base.project.session.spot.signal_starts));
                        end
                    end

                case 'Inclusion'
                    app.GlobalIntervalSettingCheckBox.Value = false;
                    app.GlobalIntervalSettingCheckBox.Visible = 'off';
                    app.LocalIntervalSettingCheckBox.Value = true;
                    app.LocalIntervalSettingCheckBox.Visible = 'off';

                    all_fields = {'background_starts', 'background_ends', ...
                        'matrix_1_starts', 'matrix_1_ends', ...
                        'matrix_2_starts', 'matrix_2_ends', ...
                        'matrix_3_starts', 'matrix_3_ends', ...
                        'inclusion_1_starts', 'inclusion_1_ends'};

                    for field = all_fields
                        if ~isfield(app.base.project.session.spot, field{1}) || ...
                                all(isnan(app.base.project.session.spot.(field{1})))
                            app.base.project.session.spot.(field{1}) = NaN(size(app.base.project.session.spot.signal_starts));
                        end
                    end

                    if ~isfield(app.base.project.session.spot, 'unmixing_via')
                        app.base.project.session.spot.unmixing_via = repmat("None", size(app.base.project.session.spot.name));
                    end

                    if ~isfield(app.base.project.session.spot, 'matrix_only_tracer')
                        app.base.project.session.spot.matrix_only_tracer = repmat(app.base.project.session.spot.analytes(1), size(app.base.project.session.spot.name));
                        app.base.project.session.spot.matrix_from_spot   = app.base.project.session.spot.name;
                    end

            end
        end

        function update_interval_panels(app)

            if app.GlobalIntervalSettingCheckBox.Value == true

                app.GlobalIntervalPanel.Visible  = true;

            else
                app.GlobalIntervalPanel.Visible  = false;
            end

            % LocalIntervalPanel
            if app.LocalIntervalSettingCheckBox.Value == true

                app.LocalIntervalPanel.Visible = true;

                if isequal(app.base.project.session.config.reductiontype, 'Matrix')
                    % make the inclusion buttons invisible
                    app.SetInclusionButton.Visible = false;
                    app.DeleteInclusionButton.Visible = false;
                    app.UnmixingviaLabel.Visible = false;
                    app.UnmixingviaDropDown.Visible = false;
                end

            else
                app.LocalIntervalPanel.Visible  = false;

            end

            %update_Interval_Module_GUI(app)
        end

        function update_inclusion_unmixing(app)

            if strcmp(app.base.project.session.config.reductiontype, 'Inclusion')

                % write only if the stored value differs, an identical write would still unsync the session
                if app.base.project.session.spot.unmixing_via(app.selected_spot) ~= string(app.UnmixingviaDropDown.Value)
                    app.base.project.session.spot.unmixing_via(app.selected_spot) = string(app.UnmixingviaDropDown.Value);
                end

                switch app.UnmixingviaDropDown.Value

                    case 'None'

                        app.MOTPanel.Visible = false;
                        app.TwoISPanel.Visible = false;

                    case 'Matrix-only tracer'

                        app.MOTPanel.Visible = true;
                        app.TwoISPanel.Visible = false;

                        % populate MOT dropdown
                        app.MatrixonlytracerDropDown.Items = app.base.project.session.spot.analytes;
                        app.MatrixonlytracerDropDown.ItemsData = 1:numel(app.base.project.session.spot.analytes);
                        app.MatrixonlytracerDropDown.Value = find(strcmp(app.MatrixonlytracerDropDown.Items, app.base.project.session.spot.matrix_only_tracer(app.selected_spot)));

                        app.FromSpotDropDown.Items = app.base.project.session.spot.name;
                        app.FromSpotDropDown.ItemsData = 1:numel(app.base.project.session.spot.name);
                        app.FromSpotDropDown.Value = find(strcmp(app.FromSpotDropDown.Items, app.base.project.session.spot.matrix_from_spot(app.selected_spot)));

                        plot_matrix_only_tracer_unmixing(app)

                    case 'Two internal standards'

                        app.MOTPanel.Visible = false;
                        app.TwoISPanel.Visible = true;

                        app.HostfromspotDropDown.Items = app.base.project.session.spot.name;
                        app.HostfromspotDropDown.ItemsData = 1:numel(app.base.project.session.spot.name);
                        app.HostfromspotDropDown.Value = find(strcmp(app.HostfromspotDropDown.Items, app.base.project.session.spot.matrix_from_spot(app.selected_spot)));

                    case 'Mixing ratio'

                        app.MOTPanel.Visible = false;
                        app.TwoISPanel.Visible = true;

                        app.HostfromspotDropDown.Items = app.base.project.session.spot.name;
                        app.HostfromspotDropDown.ItemsData = 1:numel(app.base.project.session.spot.name);
                        app.HostfromspotDropDown.Value = find(strcmp(app.HostfromspotDropDown.Items, app.base.project.session.spot.matrix_from_spot(app.selected_spot)));

                end
            end

        end



        %%%%%%%%% Plot functions %%%%%%%%%%%%%

        %%% functions to get the data to plot
        function update_active_spot(app)

            signal_start = app.base.project.session.spot.signal_starts(app.selected_spot);
            signal_end = app.base.project.session.spot.signal_ends(app.selected_spot);

            if strcmp(app.base.project.session.config.datatype, 'Continuous')

                fullsignal = app.base.project.session.spot.signal_data;

                if app.selected_spot == 1 % first spot

                    % account for the case where the first spot is rolling
                    % averaged

                    avg_spot_length = mean(nonzeros(diff(app.base.project.session.spot.signal_ends)));
                    % For the first spot, ensure the start index is not negative
                    first_spot_start = max(1, round(signal_end - avg_spot_length));
                    spot_to_plot = fullsignal(first_spot_start:signal_end, :);
                    app.active_spot_indices = first_spot_start:signal_end;

                else % all other following spots

                    % Adjust the indices to correctly capture the spot
                    previous_signal_end = app.base.project.session.spot.signal_ends(app.selected_spot - 1);

                    if ~isequal(previous_signal_end, signal_end)
                        % normal case
                        spot_to_plot = fullsignal(previous_signal_end:signal_end, :);
                        app.active_spot_indices = previous_signal_end:signal_end;

                    else % rolling average case

                        % Find the index of the last spot before the current one
                        % with a different signal_end value.
                        previous_indices = 1:(app.selected_spot - 1);
                        all_ends = app.base.project.session.spot.signal_ends;

                        % Find the last index where the end value is different from the current spot's end value
                        last_different_end_idx = find(all_ends(previous_indices) ~= signal_end, 1, 'last');

                        if isempty(last_different_end_idx) % this is the case if the first spot is rolling averaged

                            avg_spot_length = mean(nonzeros(diff(app.base.project.session.spot.signal_ends)));
                            previous_signal_end = max(1, round(signal_end - avg_spot_length));

                        else

                            previous_signal_end = all_ends(last_different_end_idx);

                        end

                        % Ensure start index is not greater than end index
                        if previous_signal_end >= signal_end
                            % If there's an issue, fall back to the current spot's defined start
                            previous_signal_end = app.base.project.session.spot.signal_starts(app.selected_spot);
                        end

                        spot_to_plot = fullsignal(previous_signal_end:signal_end, :);
                        app.active_spot_indices = previous_signal_end:signal_end;
                    end

                end

                %the previous_signal_end is the problem
                app.active_spot = spot_to_plot; % spot that is plotted

            elseif isfield(app.base.project.session, 'spot') && strcmp(app.base.project.session.config.datatype, 'Single') && ~isempty(app.base.project.session.spot.signal_data{app.selected_spot})

                app.active_spot = app.base.project.session.spot.signal_data{app.selected_spot};
                app.active_spot_indices = 1:height(app.base.project.session.spot.signal_data{app.selected_spot});

            else
                message = "You are generating new problems";
                uialert(app.UIFigure,message,"Warning", ...
                    "Icon","warning");
            end

            % store the signal starts and ends of the active_spot so that
            % the xlims can easily be adjusted for the zoom to signal
            % checkbox
            app.signal_start_idx = signal_start;
            app.signal_end_idx = signal_end;

            % here do the background correction if the checkbox is checked
            if app.PlotBackgroundcorrectedCheckBox.Value
                background_correction(app) % this changes and mutates the app.active_spot
            end

        end

        function background_correction(app)
            % get all the rows from indices background_start to background_end
            background_start = app.base.project.session.spot.background_starts(app.selected_spot);
            background_end   = app.base.project.session.spot.background_ends(app.selected_spot);

            if isnan(background_start) || isnan(background_end)
                app.PlotBackgroundcorrectedCheckBox.Value = false;
                return
            end

            % case of full measurement input
            if strcmp(app.base.project.session.config.datatype, 'Continuous')

                signal = app.base.project.session.spot.signal_data;

                % case of single_spot input
            elseif isfield(app.base.project.session, 'spot') && strcmp(app.base.project.session.config.datatype, 'Single') && ~isempty(app.base.project.session.spot.signal_data{app.selected_spot})

                signal = app.active_spot;

            end

            % get all the columns of the signal table except the first one
            background_values = signal(background_start:background_end, 2:end);

            % now calculate the mean of every column and store it in background_values_mean
            background_values_mean = mean(table2array(background_values, 1));

            % then subtract these mean values from every row in the corresponding columns in the app.active_spot
            corrected_data = table2array(app.active_spot(:, 2:end)) - background_values_mean;

            app.active_spot(:, 2:end) = array2table(corrected_data, "VariableNames", signal.Properties.VariableNames(2:end));

            % Replace negative values with 1
            app.active_spot{:, 2:end} = max(app.active_spot{:, 2:end}, 0);

        end

        function update_elementlistbox_with_plotstyle_analytes(app)

            fields = fieldnames(app.plotstyles);

            if isempty(app.selected_plotstyle) || numel(fields) < app.selected_plotstyle
                app.selected_plotstyle = 1;
            end

            chosenfield = fields{app.selected_plotstyle};
            selectedPlotStyle = app.plotstyles.(chosenfield);

            if isfield(selectedPlotStyle, 'Analytes')
                try
                    % Add 'All' at the beginning
                    validAnalytes = ["All"; selectedPlotStyle.Analytes(:)];
                    [isMember, analyteIndices] = ismember(selectedPlotStyle.Analytes, app.active_spot.Properties.VariableNames);

                    % Filter and adjust indices
                    validAnalytes = ["All"; selectedPlotStyle.Analytes(isMember)];
                    validIndices = analyteIndices(isMember) - 1;

                    % Use 0 for 'All' instead of -1
                    app.ElementLegendListBox.Items = validAnalytes;
                    app.ElementLegendListBox.ItemsData = [0; validIndices(:)];

                catch ME

                    message = "Custom plotstyle failed - Check .csv file for wrong entries";
                    DisplayError(ME,message)
                    uialert(app.UIFigure,message,"Warning","Icon","warning");
                    return

                end

            elseif isfield(selectedPlotStyle, 'Nominator') && isfield(selectedPlotStyle, 'Denominator')
                try
                    nominatorCols = selectedPlotStyle.Nominator;
                    denominatorCols = selectedPlotStyle.Denominator;
                    ratios = table();

                    for i = 1:length(nominatorCols)

                        % Check if both columns exist in the table
                        if ismember(nominatorCols(i), app.active_spot.Properties.VariableNames) && ...
                                ismember(denominatorCols(i), app.active_spot.Properties.VariableNames)

                            nominator = app.active_spot.(nominatorCols(i));
                            denominator = app.active_spot.(denominatorCols(i));
                            ratioName = nominatorCols(i) + "/" + denominatorCols(i);

                            ratios.(ratioName) = nominator ./ denominator;
                        end

                    end

                    app.active_ratios = ratios;

                    % Add 'All' option with 0 index
                    app.ElementLegendListBox.Items = ["All"; ratios.Properties.VariableNames(:)];
                    app.ElementLegendListBox.ItemsData = [0; (1:numel(ratios.Properties.VariableNames))'];

                catch ME
                    message = "Could not calculate ratios - Check .csv file for wrong analyte entries";
                    DisplayError(ME,message)
                    uialert(app.UIFigure,message,"Warning","Icon","warning");

                    return
                end
            end
        end

        function update_spot_plot(app)
            cla(app.SpotAxes)

            x_default = app.active_spot_indices';

            fields = fieldnames(app.plotstyles);
            chosenfield = fields{app.selected_plotstyle};
            selectedPlotStyle = app.plotstyles.(chosenfield);

            if chosenfield == "Default"
                app.ratioplotting = 'false';

                if isempty(app.selected_analytes) || isequal(app.selected_analytes, 0)
                    validIndices    = app.ElementLegendListBox.ItemsData(app.ElementLegendListBox.ItemsData > 0);
                    y               = table2array(app.active_spot(:, validIndices + 1));
                    analytes_to_plot = string(app.ElementLegendListBox.Items(2:end));
                else
                    y               = table2array(app.active_spot(:, app.selected_analytes + 1));
                    analytes_to_plot = string(app.ElementLegendListBox.Items(app.selected_analytes + 1));
                end

                hold(app.SpotAxes, 'on');
                for i = 1:numel(analytes_to_plot)
                    analyte = analytes_to_plot(i);
                    idx = find(strcmp(selectedPlotStyle.Analytes, analyte));

                    if ~isempty(idx)
                        if selectedPlotStyle.Marker(idx) == "none"
                            p(i) = plot(app.SpotAxes, x_default, y(:, i), ...
                                'Color',     selectedPlotStyle.Color{idx}, ...
                                'LineWidth', selectedPlotStyle.LineWidth(idx), ...
                                'LineStyle', selectedPlotStyle.Linestyle(idx), ...
                                'hittest',   'on');
                        else
                            p(i) = plot(app.SpotAxes, x_default, y(:, i), ...
                                'Color',           selectedPlotStyle.Color{idx}, ...
                                'LineWidth',       selectedPlotStyle.LineWidth(idx), ...
                                'LineStyle',       selectedPlotStyle.Linestyle(idx), ...
                                'Marker',          selectedPlotStyle.Marker(idx), ...
                                'MarkerSize',      selectedPlotStyle.MarkerSize(idx), ...
                                'MarkerFaceColor', selectedPlotStyle.MarkerFaceColor(idx), ...
                                'MarkerEdgeColor', selectedPlotStyle.MarkerEdgeColor(idx), ...
                                'hittest',         'on');
                        end
                    end

                    p(i).DataTipTemplate.Interpreter = 'none';
                    p(i).DataTipTemplate.DataTipRows(1) = dataTipTextRow(analyte + ":", string(round(y(:, i))) + " cps");
                    p(i).DataTipTemplate.DataTipRows(2) = [];
                end
                hold(app.SpotAxes, 'off');

            elseif chosenfield == "Heatmap"
                app.ratioplotting = 'false';

                if isempty(app.selected_analytes) || isequal(app.selected_analytes, 0)
                    validIndices    = app.ElementLegendListBox.ItemsData(app.ElementLegendListBox.ItemsData > 0);
                    y               = table2array(app.active_spot(:, validIndices + 1));
                    analytes_to_plot = string(app.ElementLegendListBox.Items(2:end));
                else
                    y               = table2array(app.active_spot(:, app.selected_analytes + 1));
                    analytes_to_plot = string(app.ElementLegendListBox.Items(app.selected_analytes + 1));
                end

                hold(app.SpotAxes, 'on');
                data = y';
                norm_signals = true;
                if norm_signals
                    data = data ./ max(data, [], 2);
                end
                imagesc(app.SpotAxes, x_default, 1:size(data,1), data)
                try
                    colormap(app.SpotAxes, app.ColorMapValues)
                catch
                    colormap(app.SpotAxes, "turbo")
                end
                hold(app.SpotAxes, 'off');

            elseif isfield(selectedPlotStyle, 'Analytes')
                app.ratioplotting = 'false';

                if isempty(app.selected_analytes)
                    y               = table2array(app.active_spot(:, app.ElementLegendListBox.ItemsData(2:end)+1));
                    analytes_to_plot = string(app.ElementLegendListBox.Items(2:end));
                else
                    y               = table2array(app.active_spot(:, app.selected_analytes + 1));
                    analytes_to_plot = string(app.active_spot(:, app.selected_analytes + 1).Properties.VariableNames);
                end

                hold(app.SpotAxes, 'on');
                for i = 1:numel(analytes_to_plot)
                    analyte = analytes_to_plot(i);
                    idx = find(strcmp(selectedPlotStyle.Analytes, analyte));

                    if ~isempty(idx)
                        if selectedPlotStyle.Marker(idx) == "none"
                            p(i) = plot(app.SpotAxes, x_default, y(:, i), ...
                                'Color',     selectedPlotStyle.Color{idx}, ...
                                'LineWidth', selectedPlotStyle.LineWidth(idx), ...
                                'LineStyle', selectedPlotStyle.Linestyle(idx));
                        else
                            p(i) = plot(app.SpotAxes, x_default, y(:, i), ...
                                'Color',           selectedPlotStyle.Color{idx}, ...
                                'LineWidth',       selectedPlotStyle.LineWidth(idx), ...
                                'LineStyle',       selectedPlotStyle.Linestyle(idx), ...
                                'Marker',          selectedPlotStyle.Marker(idx), ...
                                'MarkerSize',      selectedPlotStyle.MarkerSize(idx), ...
                                'MarkerFaceColor', selectedPlotStyle.MarkerFaceColor(idx), ...
                                'MarkerEdgeColor', selectedPlotStyle.MarkerEdgeColor(idx));
                        end
                    end
                    p(i).DataTipTemplate.Interpreter = 'none';
                    p(i).DataTipTemplate.DataTipRows(1) = dataTipTextRow(analyte + ":", string(round(y(:, i))) + " cps");
                    p(i).DataTipTemplate.DataTipRows(2) = [];
                end
                hold(app.SpotAxes, 'off');

            elseif isfield(selectedPlotStyle, 'Nominator') && isfield(selectedPlotStyle, 'Denominator')
                app.ratioplotting = 'true';

                if isempty(app.selected_analytes) || isequal(app.selected_analytes, 0)
                    validIndices    = app.ElementLegendListBox.ItemsData(app.ElementLegendListBox.ItemsData > 0);
                    y               = table2array(app.active_ratios);
                    analytes_to_plot = string(app.ElementLegendListBox.Items(2:end));
                else
                    y               = table2array(app.active_ratios(:, app.selected_analytes));
                    analytes_to_plot = string(app.ElementLegendListBox.Items(app.selected_analytes + 1));
                end

                hold(app.SpotAxes, 'on');
                for i = 1:numel(analytes_to_plot)
                    analyte    = analytes_to_plot(i);
                    ratioNames = selectedPlotStyle.Nominator + "/" + selectedPlotStyle.Denominator;
                    idx        = find(strcmp(ratioNames, analyte));

                    if ~isempty(idx)
                        if selectedPlotStyle.Marker(idx) == "none"
                            p(i) = plot(app.SpotAxes, x_default, y(:, i), ...
                                'Color',     selectedPlotStyle.Color{idx}, ...
                                'LineWidth', selectedPlotStyle.LineWidth(idx), ...
                                'LineStyle', selectedPlotStyle.Linestyle(idx));
                        else
                            p(i) = plot(app.SpotAxes, x_default, y(:, i), ...
                                'Color',           selectedPlotStyle.Color{idx}, ...
                                'LineWidth',       selectedPlotStyle.LineWidth(idx), ...
                                'LineStyle',       selectedPlotStyle.Linestyle(idx), ...
                                'Marker',          selectedPlotStyle.Marker(idx), ...
                                'MarkerSize',      selectedPlotStyle.MarkerSize(idx), ...
                                'MarkerFaceColor', selectedPlotStyle.MarkerFaceColor(idx), ...
                                'MarkerEdgeColor', selectedPlotStyle.MarkerEdgeColor(idx));
                        end
                    end
                    p(i).DataTipTemplate.Interpreter = 'none';
                    p(i).DataTipTemplate.DataTipRows(1) = dataTipTextRow(analyte + ":", string(y(:, i)) + " cps");
                    p(i).DataTipTemplate.DataTipRows(2) = [];
                end
                hold(app.SpotAxes, 'off');
            end

            if isequal(chosenfield, "Heatmap")
                ylim(app.SpotAxes, [0.5 numel(analytes_to_plot)+0.5])

                if app.LogscaleCheckBox.Value
                    linlog = 'log';
                else
                    linlog = 'linear';
                end
                set(app.SpotAxes, 'colorscale',    linlog)
                set(app.SpotAxes, 'YTickLabel',    analytes_to_plot)
                set(app.SpotAxes, 'YTick',         1:numel(analytes_to_plot))

                if app.ZoomintoSignalCheckBox.Value
                    xlim(app.SpotAxes, [app.signal_start_idx, app.signal_end_idx]);
                else
                    xlim(app.SpotAxes, [min(x_default), max(x_default)]);
                end
                app.SpotAxes.YScale = 'linear';

                if ~isempty(app.SpotAxes.Legend)
                    app.SpotAxes.Legend.Visible = false;
                end

            else
                if app.LogscaleCheckBox.Value
                    set(app.SpotAxes, 'YScale', 'log');
                else
                    set(app.SpotAxes, 'YScale', 'linear');
                end

                if app.ZoomintoSignalCheckBox.Value
                    xlim(app.SpotAxes, [app.signal_start_idx, app.signal_end_idx]);
                else
                    xlim(app.SpotAxes, [min(x_default), max(x_default)]);
                end

                ylim(app.SpotAxes, 'auto')
                set(app.SpotAxes, 'yminorgrid',        'on')
                set(app.SpotAxes, 'MinorGridLIneStyle', '-')
                set(app.SpotAxes, 'MinorGridAlpha',     0.15)
                set(app.SpotAxes, 'YTickMode',          'auto')
                set(app.SpotAxes, 'YTickLabelMode',     'auto')

                title(app.SpotAxes, app.base.project.session.spot.name(app.selected_spot), 'Interpreter', 'none');

                if app.ShowLegendCheckBox.Value
                    if any(contains(analytes_to_plot, 'All'))
                        legend(app.SpotAxes, analytes_to_plot(2:end), 'Location', 'northwest', 'NumColumns', 3, 'AutoUpdate', 'off');
                    else
                        legend(app.SpotAxes, analytes_to_plot, 'Location', 'northwest', 'NumColumns', 3, 'AutoUpdate', 'off');
                    end
                else
                    if ~isempty(app.SpotAxes.Legend)
                        app.SpotAxes.Legend.Visible = false;
                    end
                end
            end

            if app.ShowIntervalsCheckBox.Value == true
                update_interval_lines(app, app.SpotAxes, 'bg_mat_incl')
            end
        end



        %%%%%%% update the movable interval lines and interval areas %%%%%

        function KeyPressFcn(app, event)
            % Create keyboard callback
            if strcmp(event.Key, 'b')
                SetBackgroundButtonPushed(app)
            elseif strcmp(event.Key, 'a')
                Set1MatrixButtonPushed(app)
            elseif strcmp(event.Key, 's')
                Set2MatrixButtonPushed(app)
            elseif strcmp(app.base.project.session.config.reductiontype, 'Inclusion') && strcmp(event.Key, 'f')
                SetInclusionButtonPushed(app)
            elseif strcmp(event.Key, 'd')
                Set3MatrixButtonPushed(app)
            end
        end

        function has_overlap = check_interval_overlap(app, new_start, new_end, type)

            intervals = struct();

            type_to_field = struct(...
                'Background',  'bg', ...
                'Host_1',      'host1', ...
                'Host_2',      'host2', ...
                'Inclusion_1', 'incl1', ...
                'Matrix_3',    'host3');

            if isfield(app.base.project.session.spot, 'background_starts') && ...
                    ~isnan(app.base.project.session.spot.background_starts(app.selected_spot))
                intervals.bg = [app.base.project.session.spot.background_starts(app.selected_spot), ...
                    app.base.project.session.spot.background_ends(app.selected_spot)];
            end

            if isfield(app.base.project.session.spot, 'matrix_1_starts') && ...
                    ~isnan(app.base.project.session.spot.matrix_1_starts(app.selected_spot))
                intervals.host1 = [app.base.project.session.spot.matrix_1_starts(app.selected_spot), ...
                    app.base.project.session.spot.matrix_1_ends(app.selected_spot)];
            end

            if isfield(app.base.project.session.spot, 'matrix_2_starts') && ...
                    ~isnan(app.base.project.session.spot.matrix_2_starts(app.selected_spot))
                intervals.host2 = [app.base.project.session.spot.matrix_2_starts(app.selected_spot), ...
                    app.base.project.session.spot.matrix_2_ends(app.selected_spot)];
            end

            if isfield(app.base.project.session.spot, 'inclusion_1_starts') && ...
                    ~isnan(app.base.project.session.spot.inclusion_1_starts(app.selected_spot))
                intervals.incl1 = [app.base.project.session.spot.inclusion_1_starts(app.selected_spot), ...
                    app.base.project.session.spot.inclusion_1_ends(app.selected_spot)];
            end

            if isfield(app.base.project.session.spot, 'matrix_3_starts') && ...
                    ~isnan(app.base.project.session.spot.matrix_3_starts(app.selected_spot))
                intervals.host3 = [app.base.project.session.spot.matrix_3_starts(app.selected_spot), ...
                    app.base.project.session.spot.matrix_3_ends(app.selected_spot)];
            end

            current_field = type_to_field.(type);
            has_overlap   = false;
            interval_names = fieldnames(intervals);
            for i = 1:length(interval_names)
                if ~strcmp(interval_names{i}, current_field)
                    interval = intervals.(interval_names{i});
                    if new_start <= interval(2) && new_end >= interval(1)
                        has_overlap = true;
                        return;
                    end
                end
            end
        end

        function draw_interval_via_rectangles(app, type)

            ROI_sampling = drawrectangle(app.SpotAxes,'Color',[0.8 0.8 0.8],'Rotatable',0,'InteractionsAllowed','all', 'LineWidth', 0.1);

            xrange = [ROI_sampling.Position(1) ROI_sampling.Position(1)+ROI_sampling.Position(3)];

            new_start = ceil(xrange(1));
            new_end = ceil(xrange(2));

            % Check for overlap before setting new interval
            if check_interval_overlap(app, new_start, new_end, type)
                message = "Cannot set interval within already existing interval";
                uialert(app.UIFigure,message,"Warning", ...
                    "Icon","warning");
                delete(ROI_sampling);
                return;
            end

            % Update intervals based on type
            if strcmp(type,"Background")
                app.base.project.session.spot.background_starts(app.selected_spot) = new_start;
                app.base.project.session.spot.background_ends(app.selected_spot)   = new_end;
            elseif strcmp(type,"Host_1")
                app.base.project.session.spot.matrix_1_starts(app.selected_spot) = new_start;
                app.base.project.session.spot.matrix_1_ends(app.selected_spot)   = new_end;
            elseif strcmp(type,"Host_2")
                app.base.project.session.spot.matrix_2_starts(app.selected_spot) = new_start;
                app.base.project.session.spot.matrix_2_ends(app.selected_spot)   = new_end;
            elseif strcmp(type,"Inclusion_1")
                app.base.project.session.spot.inclusion_1_starts(app.selected_spot) = new_start;
                app.base.project.session.spot.inclusion_1_ends(app.selected_spot)   = new_end;
            elseif strcmp(type,"Matrix_3")
                app.base.project.session.spot.matrix_3_starts(app.selected_spot) = new_start;
                app.base.project.session.spot.matrix_3_ends(app.selected_spot)   = new_end;
            end

            app.base.project.session.config.manual_intervals = true;

            delete(ROI_sampling)

        end

        function update_interval_lines(app, ax2plot, update_lines)
            if ~exist('ax2plot', 'var')
                ax2plot = app.SpotAxes;
            end
            if ~exist('update_lines', 'var')
                update_lines = 'bg_mat_incl';
            end

            if isfield(app.base.project.session.spot, 'background_starts') && ...
                    isfield(app.base.project.session.spot, 'background_ends') && ...
                    ~isnan(app.base.project.session.spot.background_starts(app.selected_spot)) && ...
                    ~isnan(app.base.project.session.spot.background_ends(app.selected_spot))

                bg_start = app.base.project.session.spot.background_starts(app.selected_spot);
                bg_end   = app.base.project.session.spot.background_ends(app.selected_spot);

                if strcmp(update_lines, 'bg_mat_incl')
                    app.hVerticalLines(1).xl = xline(ax2plot, bg_start, 'linewidth', 2, 'Color', [0.5 0.5 0.5], 'Tag', 'spot_bg_interval',     'hittest', 'off');
                    app.hVerticalLines(2).xl = xline(ax2plot, bg_end,   'linewidth', 2, 'Color', [0.5 0.5 0.5], 'Tag', 'spot_bg_interval',     'hittest', 'off');
                    update_interval_areas(app)
                end
            end

            if isfield(app.base.project.session.spot, 'matrix_1_starts') && ...
                    isfield(app.base.project.session.spot, 'matrix_1_ends') && ...
                    ~isnan(app.base.project.session.spot.matrix_1_starts(app.selected_spot)) && ...
                    ~isnan(app.base.project.session.spot.matrix_1_ends(app.selected_spot))

                host_1_start = app.base.project.session.spot.matrix_1_starts(app.selected_spot);
                host_1_end   = app.base.project.session.spot.matrix_1_ends(app.selected_spot);

                if strcmp(update_lines, 'bg_mat_incl')
                    app.hVerticalLines(3).xl = xline(ax2plot, host_1_start, 'linewidth', 2, 'Color', "#2D8A0A", 'Tag', 'spot_host_1_interval', 'hittest', 'off');
                    app.hVerticalLines(4).xl = xline(ax2plot, host_1_end,   'linewidth', 2, 'Color', "#2D8A0A", 'Tag', 'spot_host_1_interval', 'hittest', 'off');
                    update_interval_areas(app)
                end
            end

            if isfield(app.base.project.session.spot, 'matrix_2_starts') && ...
                    isfield(app.base.project.session.spot, 'matrix_2_ends') && ...
                    ~isnan(app.base.project.session.spot.matrix_2_starts(app.selected_spot)) && ...
                    ~isnan(app.base.project.session.spot.matrix_2_ends(app.selected_spot))

                host_2_start = app.base.project.session.spot.matrix_2_starts(app.selected_spot);
                host_2_end   = app.base.project.session.spot.matrix_2_ends(app.selected_spot);

                if strcmp(update_lines, 'bg_mat_incl')
                    app.hVerticalLines(5).xl = xline(ax2plot, host_2_start, 'linewidth', 2, 'Color', "#B6E6A3", 'Tag', 'spot_host_2_interval', 'hittest', 'off');
                    app.hVerticalLines(6).xl = xline(ax2plot, host_2_end,   'linewidth', 2, 'Color', "#B6E6A3", 'Tag', 'spot_host_2_interval', 'hittest', 'off');
                    update_interval_areas(app)
                end
            end

            if isfield(app.base.project.session.spot, 'inclusion_1_starts') && ...
                    isfield(app.base.project.session.spot, 'inclusion_1_ends') && ...
                    ~isnan(app.base.project.session.spot.inclusion_1_starts(app.selected_spot)) && ...
                    ~isnan(app.base.project.session.spot.inclusion_1_ends(app.selected_spot))

                incl_1_start = app.base.project.session.spot.inclusion_1_starts(app.selected_spot);
                incl_1_end   = app.base.project.session.spot.inclusion_1_ends(app.selected_spot);

                if strcmp(update_lines, 'bg_mat_incl')
                    app.hVerticalLines(7).xl = xline(ax2plot, incl_1_start, 'linewidth', 2, 'Color', "#3077AC", 'Tag', 'spot_incl_1_interval', 'hittest', 'off');
                    app.hVerticalLines(8).xl = xline(ax2plot, incl_1_end,   'linewidth', 2, 'Color', "#3077AC", 'Tag', 'spot_incl_1_interval', 'hittest', 'off');
                    update_interval_areas(app)
                end
            end

            if isfield(app.base.project.session.spot, 'matrix_3_starts') && ...
                    isfield(app.base.project.session.spot, 'matrix_3_ends') && ...
                    ~isnan(app.base.project.session.spot.matrix_3_starts(app.selected_spot)) && ...
                    ~isnan(app.base.project.session.spot.matrix_3_ends(app.selected_spot))

                host_3_start = app.base.project.session.spot.matrix_3_starts(app.selected_spot);
                host_3_end   = app.base.project.session.spot.matrix_3_ends(app.selected_spot);

                if strcmp(update_lines, 'bg_mat_incl')
                    app.hVerticalLines(9).xl  = xline(ax2plot, host_3_start, 'linewidth', 2, 'Color', "#90EE90", 'Tag', 'spot_host_3_interval', 'hittest', 'off');
                    app.hVerticalLines(10).xl = xline(ax2plot, host_3_end,   'linewidth', 2, 'Color', "#90EE90", 'Tag', 'spot_host_3_interval', 'hittest', 'off');
                    update_interval_areas(app)
                end
            end
        end

        function update_interval_areas(app)

            tmp=findobj(app.SpotAxes,'Type','Patch');
            delete(tmp);

            for k = 1:2:numel(app.hVerticalLines)
                if numel(app.hVerticalLines)>k &&  not(isempty(app.hVerticalLines(k).xl)) && not(isempty(app.hVerticalLines(k+1).xl)) && isvalid(app.hVerticalLines(k).xl) && isvalid(app.hVerticalLines(k+1).xl)
                    ax2plot = app.SpotAxes;
                    ylimits = ylim(ax2plot);
                    x = sort([app.hVerticalLines(k).xl.Value app.hVerticalLines(k+1).xl.Value]);
                    lowerBoundary(1:2) = min([ylimits ylimits]);
                    upperBoundary(1:2) = max([ylimits ylimits]);
                    patch(ax2plot,[x fliplr(x)], [upperBoundary  fliplr(lowerBoundary)], app.hVerticalLines(k+1).xl.Color,'FaceAlpha',0.1,'hittest','off');
                    ylim(ax2plot,ylimits);
                end
            end
        end

        function proceed = confirm_overwrite_manual_intervals(app)
            % true = go on. Asks only if intervals were set or changed manually.
            % A missing field (older sessions) counts as no manual changes.
            proceed = true;
            config = app.base.project.session.config;

            if isfield(config, 'manual_intervals') && config.manual_intervals
                selection = uiconfirm(app.UIFigure, ...
                    "You set or moved intervals manually. The global interval setting overwrite these manual changes for all spots. This is not reversible. Make sure to first set the intervals globally before changing them locally via drag-and-drop.", ...
                    "Manual intervals", ...
                    "Options", ["Overwrite", "Cancel"], ...
                    "DefaultOption", 2, "CancelOption", 2);
                proceed = strcmp(selection, 'Overwrite');
            end
        end

        %%%%%%%%%%%%% spike elimination %%%%%%%%%%%%%

        function [corrected_data, eliminated_spikes] = spike_elimination(app, data, data_start_index)
            % spike_elimination: Identifies and corrects spikes in the data using Grubbs' test.
            % It also records the details of each eliminated spike.

            % Define Constants as single precision
            cpvalueseven = 2.097; % For N=7 measurements, significance level 1%
            cpvaluenine = 2.323;  % For N=9 measurements, significance level 1%
            threshold = app.base.project.session.config.spike_threshold;     % Minimum threshold for spike detection [cps]

            % Initialize output and convert data to single for performance
            corrected_data = data;
            eliminated_spikes = table('Size', [0, 5], ...
                'VariableTypes', {'single', 'single', 'single', 'single', 'single'}, ...
                'VariableNames', {'RowIndex', 'ColumnIndex', 'OriginalValue', 'ReplacementValue', 'SweepIndex'});

            % Apply Grubbs' test correction using a moving window
            for col = 1:size(data, 2)
                % Start from tstep=5 to accommodate a 9-point window (t-4 to t+4)
                for tstep = 5:(size(data, 1) - 4)
                    csp = corrected_data(tstep, col);
                    % Only check points above the minimum threshold
                    if csp > threshold

                        % Define the 9-point window around the current point
                        window9 = corrected_data(tstep-4:tstep+4, col);

                        % The 7-point window is a subset of the 9-point window
                        window7 = window9([1:4, 6:9]); % Excludes point at relative index 5 (csp)

                        % Calculate statistics for both windows
                        meanseven = mean(window7);
                        stdseven = std(window7);
                        meannine = mean(window9);
                        stdnine = std(window9);

                        % Check if the point is an outlier using both criteria
                        % Avoid division by zero if standard deviation is 0
                        if stdseven > 0 && stdnine > 0 && ...
                                ((abs(csp - meanseven) / stdseven) > cpvalueseven) && ...
                                ((abs(csp - meannine) / stdnine) > cpvaluenine)

                            % Calculate replacement value (mean of 6 surrounding points)
                            surrounding = corrected_data(tstep-3:tstep+3, col);
                            surrounding(4) = []; % Exclude the spike itself
                            replacement_value = mean(surrounding);

                            % Calculate absolute sweep index
                            sweep_index = tstep + data_start_index - 1;

                            % Store spike info before correction
                            new_spike = {tstep, col, csp, replacement_value, sweep_index};
                            eliminated_spikes = [eliminated_spikes; new_spike]; %#ok<AGROW>

                            % Replace spike with calculated value
                            corrected_data(tstep, col) = replacement_value;
                        end
                    end
                end
            end
        end

        %%%%%%%%%%%%% host-inclusion-unmixing %%%%%%%

        function plot_matrix_only_tracer_unmixing(app)

            inclusion_1_start = app.base.project.session.spot.inclusion_1_starts(app.selected_spot);
            inclusion_1_end   = app.base.project.session.spot.inclusion_1_ends(app.selected_spot);

            if isnan(inclusion_1_start) || isnan(inclusion_1_end)
                return
            end

            if isequal(app.base.project.session.config.datatype, 'Continuous')
                data_incl = table2array(app.base.project.session.spot.signal_data(:, 2:end));
            elseif isequal(app.base.project.session.config.datatype, 'Single')
                data_incl = table2array(app.base.project.session.spot.signal_data{app.selected_spot}(:, 2:end));
            end

            background_start_incl      = app.base.project.session.spot.background_starts(app.selected_spot);
            background_end_incl        = app.base.project.session.spot.background_ends(app.selected_spot);
            if isnan(background_start_incl) || isnan(background_end_incl)
                return
            end
            background_values_incl     = data_incl(background_start_incl:background_end_incl, :);
            background_values_mean_incl = mean(background_values_incl, 1);
            data_incl_corrected        = data_incl - background_values_mean_incl;

            mix_data = data_incl_corrected(inclusion_1_start:inclusion_1_end, :);

            host_spot_idx = app.FromSpotDropDown.Value;

            host_1_start = app.base.project.session.spot.matrix_1_starts(host_spot_idx);
            host_1_end   = app.base.project.session.spot.matrix_1_ends(host_spot_idx);
            host_2_start = app.base.project.session.spot.matrix_2_starts(host_spot_idx);
            host_2_end   = app.base.project.session.spot.matrix_2_ends(host_spot_idx);
            host_3_start = app.base.project.session.spot.matrix_3_starts(host_spot_idx);
            host_3_end   = app.base.project.session.spot.matrix_3_ends(host_spot_idx);

           
            if isnan(host_1_start) && isnan(host_2_start) && isnan(host_3_start)
                if host_spot_idx ~= app.selected_spot
                    uialert(app.UIFigure, "The host spot has no matrix intervals, so the unmixing cannot be shown. Choose another host spot.", ...
                        "Warning", "Icon", "warning");
                end
                return
            end
        

            if isequal(app.base.project.session.config.datatype, 'Continuous')
                data_host = table2array(app.base.project.session.spot.signal_data(:, 2:end));
            elseif isequal(app.base.project.session.config.datatype, 'Single')
                data_host = table2array(app.base.project.session.spot.signal_data{host_spot_idx}(:, 2:end));
            end

            background_start_host      = app.base.project.session.spot.background_starts(host_spot_idx);
            background_end_host        = app.base.project.session.spot.background_ends(host_spot_idx);
            if isnan(background_start_host) || isnan(background_end_host)
                return
            end
            background_values_host     = data_host(background_start_host:background_end_host, :);
            background_values_mean_host = mean(background_values_host, 1);
            data_host_corrected        = data_host - background_values_mean_host;

            host_data_total = [];
            if ~isnan(host_1_start)
                host_data_total = [host_data_total; data_host_corrected(host_1_start:host_1_end, :)];
            end
            if ~isnan(host_2_start)
                host_data_total = [host_data_total; data_host_corrected(host_2_start:host_2_end, :)];
            end
            if ~isnan(host_3_start)
                host_data_total = [host_data_total; data_host_corrected(host_3_start:host_3_end, :)];
            end

            mean_host_all_elements = mean(host_data_total, 1);
            mean_mix_all_elements  = mean(mix_data, 1);

            mean_MOT_host = mean_host_all_elements(app.MatrixonlytracerDropDown.Value);
            mean_MOT_incl = mean_mix_all_elements(app.MatrixonlytracerDropDown.Value);

            if isequal(mean_MOT_host, 0) || isequal(mean_MOT_incl, 0)
                return
            end

            intensity_ratio      = mean_MOT_incl / mean_MOT_host;
            host_contribution    = mean_host_all_elements * intensity_ratio;

            if isempty(app.selected_analytes)
                y = host_contribution(:, app.ElementLegendListBox.ItemsData(2:end));
            else
                y = host_contribution(:, app.selected_analytes);
            end

            fields     = fieldnames(app.plotstyles);
            chosenfield = fields{app.selected_plotstyle};

            if app.ShowhostcontributionCheckBox.Value && isequal(app.ratioplotting, 'false') && ...
                    app.PlotBackgroundcorrectedCheckBox.Value && ~isequal(chosenfield, "Heatmap")

                delete(findobj(app.SpotAxes, 'Tag', 'HostContributionLine'));
                hold(app.SpotAxes, 'on');
                x_coords = [inclusion_1_start, inclusion_1_end];
                for i = 1:size(y, 2)
                    h = plot(app.SpotAxes, x_coords, [y(i), y(i)], ...
                        'LineWidth', 1.5, 'Color', 'black', 'LineStyle', ':');
                    h.Tag = 'HostContributionLine';
                end
                hold(app.SpotAxes, 'off');
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % helper function for inclusion area plotting
        function segments = findConsecutiveSegments(app, indices)
            % Initialize segments array
            segments = [];

            if isempty(indices)
                return;
            end

            % Start first segment
            segStart = indices(1);
            prev = indices(1);

            for i = 2:length(indices)
                if indices(i) ~= prev + 1
                    % End of a segment found
                    segments = [segments; segStart, prev];
                    segStart = indices(i);
                end
                prev = indices(i);
            end

            % Add final segment
            segments = [segments; segStart, indices(end)];
        end



    end


    methods (Access = public)

        function update_Interval_Module_GUI(app)

            app.SpotListBox.Items    = app.base.project.session.spot.name;
            app.SpotListBox.ItemsData = 1:numel(app.base.project.session.spot.name);

            app.PlotstylesListBox.Items    = cellstr(fieldnames(app.plotstyles));
            app.PlotstylesListBox.ItemsData = 1:numel(app.PlotstylesListBox.Items);

            if isempty(app.selected_spot)
                app.selected_spot = 1;
            end

            % update comment box from session.meta
            if isfield(app.base.project.session, 'meta') && isfield(app.base.project.session.meta, 'comment') && ...
                    ~isempty(app.base.project.session.meta.comment)
                current_comment = app.base.project.session.meta.comment(app.selected_spot);
                if current_comment ~= ""
                    app.CommentTextArea.Value = current_comment;
                else
                    app.CommentTextArea.Value = "";
                end
            else
                app.CommentTextArea.Value = "";
            end

            update_active_spot(app)
            update_elementlistbox_with_plotstyle_analytes(app)
            update_spot_plot(app)

            if strcmp(app.base.project.session.config.reductiontype, 'Inclusion')

                if app.base.project.session.spot.unmixing_via(app.selected_spot) == ""

                    app.UnmixingviaDropDown.Value = app.UnmixingviaDropDown.Items(1);
                    update_inclusion_unmixing(app)

                elseif any(ismember(app.UnmixingviaDropDown.Items, app.base.project.session.spot.unmixing_via(app.selected_spot)))

                    app.UnmixingviaDropDown.Value = app.base.project.session.spot.unmixing_via(app.selected_spot);
                    update_inclusion_unmixing(app)

                else
                    app.UnmixingviaDropDown.Value = app.UnmixingviaDropDown.Items(1);
                    update_inclusion_unmixing(app)
                end

            end

        end


        function set_automatic_background(app, settings)

            try
                test_state = true; % is needed later as a failsafe so that no broken data gets into the data structure

                % if settings is not sent or something wrong is put in
                if not(exist('settings', 'var')) || not(isstruct(settings))
                    settings = struct();
                end

                % if the lower_indent is not input, make it some value
                if not(isfield(settings,'bg_lower_indent')) || isempty(settings.bg_lower_indent)
                    settings.bg_lower_indent = app.bg_lower_indentEditField.Value; % default value
                end

                % if the lower_indent is not input, make it some value
                if not(isfield(settings,'bg_upper_indent')) || isempty(settings.bg_upper_indent)
                    settings.bg_upper_indent = app.bg_upper_indentEditField.Value; % default value
                end

                % Ensure the value is not lower than 0
                if settings.bg_lower_indent < 0
                    settings.bg_lower_indent = 0;
                elseif settings.bg_upper_indent < 0
                    settings.bg_upper_indent = 0;
                end

                lower_indent = settings.bg_lower_indent;
                upper_indent = settings.bg_upper_indent;

                signal_start = app.base.project.session.spot.signal_starts;
                signal_end = app.base.project.session.spot.signal_ends;

                % Initialize arrays to hold background start and end indices
                background_starts = zeros(size(signal_start))';
                background_ends =  zeros(size(signal_start))';

                % case of full measurement input
                if strcmp(app.base.project.session.config.datatype, 'Continuous')

                    % Handle the first spot separately
                    avg_spot_length = mean(nonzeros(diff(signal_end)));
                    first_spot_start = max(1, round(signal_end(1) - avg_spot_length));

                    background_starts(1) = first_spot_start + lower_indent;
                    background_ends(1) = signal_start(1) - upper_indent;

                    % Loop through the remaining spots
                    for i = 2:numel(signal_start)



                        if signal_end(i) == signal_end(i-1) && signal_start(i) == signal_start(i-1)
                            % Special case for rolling average where signal ends/starts are identical

                            % Find the first occurrence of this specific signal_end value
                            first_in_group_idx = find(signal_end(1:i) == signal_end(i), 1, 'first');

                            if first_in_group_idx > 1
                                % Use the signal_end from the spot just before the group of duplicates started
                                prev_signal_end = signal_end(first_in_group_idx - 1);
                            else
                                % This group of duplicates starts from the very first spot
                                prev_signal_end = first_spot_start;
                            end
                            background_starts(i) = prev_signal_end + lower_indent;
                        else
                            % Original logic for normal cases
                            background_starts(i) = signal_end(i-1) + lower_indent;
                        end

                        % this works anyways
                        background_ends(i) = signal_start(i) - upper_indent;

                    end

                    % case of single_spot input
                elseif isfield(app.base.project.session, 'spot') && strcmp(app.base.project.session.config.datatype, 'Single') && ~isempty(app.base.project.session.spot.signal_data{app.selected_spot})

                    % Loop through the remaining spots
                    for i = 1:numel(signal_start)

                        background_starts(i) = 1 + lower_indent;
                        background_ends(i) = signal_start(i) - upper_indent;

                    end

                end

                % an indent larger than the space before the signal would give an empty or reversed background:
                % leave it empty (ignored like every NaN interval) and tell the user which spots
                background_starts = max(background_starts, 1);
                invalid = background_ends < background_starts;
                if any(invalid)
                    background_starts(invalid) = NaN;
                    background_ends(invalid)   = NaN;
                    invalid_idx = find(invalid);
                    spot_list   = strjoin(compose("%d (%s)", invalid_idx(:), app.base.project.session.spot.name(invalid_idx(:))), ', ');
                    uialert(app.UIFigure, sprintf(['The background indents are too large for spot(s) %s, so their background was left empty ' ...
                        '(the background end would be before the background start). Reduce the indents or set these backgrounds manually.'], spot_list), ...
                        'Background Not Set', 'Icon', 'warning');
                end

                % if test_state = false, push the data from the cache to the
                % data structure
                if test_state == false
                    return
                else
                    % Store the results in the app structure
                    app.base.project.session.spot.background_starts = background_starts';
                    app.base.project.session.spot.background_ends = background_ends';

                    app.base.project.session.config.manual_intervals = false;
                end

                if isfield(settings, 'interval_module_GUI_update_state') && settings.interval_module_GUI_update_state == true
                    update_Interval_Module_GUI(app)
                end

            catch ME
                DisplayError(ME,'set_automatic_background')

                message = "set_automatic_background failed";
                uialert(app.UIFigure,message,"Warning", ...
                    "Icon","warning");
                disp("set_automatic_background failed")
            end

        end

        function set_automatic_matrix(app, settings)

            try
                test_state = true; % is needed later as a failsafe so that no broken data gets into the data structure

                % if settings is not sent or something wrong is put in
                if not(exist('settings', 'var')) || not(isstruct(settings))
                    settings = struct();
                end

                % if the lower_indent is not input, make it some value
                if not(isfield(settings,'matrix_lower_indent')) || isempty(settings.matrix_lower_indent)
                    settings.matrix_lower_indent = app.matrix_lower_indentEditField.Value; % default value
                end

                % if the lower_indent is not input, make it some value
                if not(isfield(settings,'matrix_upper_indent')) || isempty(settings.matrix_upper_indent)
                    settings.matrix_upper_indent = app.matrix_upper_indentEditField.Value; % default value
                end

                lower_indent = settings.matrix_lower_indent;
                upper_indent = settings.matrix_upper_indent;

                signal_starts = app.base.project.session.spot.signal_starts;
                signal_ends = app.base.project.session.spot.signal_ends;

                % Initialize arrays to hold background start and end indices
                matrix_starts = zeros(size(signal_starts))';
                matrix_ends =  zeros(size(signal_ends))';

                % Loop through the remaining spots
                for i = 1:numel(matrix_starts)

                    matrix_starts(i) = signal_starts(i) + lower_indent;
                    matrix_ends(i) = signal_ends(i) - upper_indent;

                end

                % indents larger than the signal would give an empty or reversed matrix interval
                invalid = matrix_ends < matrix_starts;
                if any(invalid)
                    matrix_starts(invalid) = NaN;
                    matrix_ends(invalid)   = NaN;
                    invalid_idx = find(invalid);
                    spot_list   = strjoin(compose("%d (%s)", invalid_idx(:), app.base.project.session.spot.name(invalid_idx(:))), ', ');
                    uialert(app.UIFigure, sprintf(['The matrix indents are longer than the signal of spot(s) %s, so their matrix interval was left empty. ' ...
                        'Reduce the indents or set these intervals manually.'], spot_list), ...
                        'Matrix Not Set', 'Icon', 'warning');
                end

                % if test_state = false, push the data from the cache to the
                % data structure
                if test_state == false
                    return
                else
                    % Store the results in the app structure
                    app.base.project.session.spot.matrix_1_starts = matrix_starts';
                    app.base.project.session.spot.matrix_1_ends = matrix_ends';

                    app.base.project.session.config.manual_intervals = false;
                end

                if isfield(settings, 'interval_module_GUI_update_state') && settings.interval_module_GUI_update_state == true
                    update_Interval_Module_GUI(app)
                end

            catch ME
                DisplayError(ME,'set_automatic_matrix')

                message = "set_automatic_matrix failed";
                uialert(app.UIFigure,message,"Warning", ...
                    "Icon","warning");
                disp("set_automatic_matrix failed")
            end

        end


        % Heatmap colormaps
        function ReadColorMaps(app, file)

            XMap_ColorMaps_path = file;

            fid = fopen(XMap_ColorMaps_path,'r');

            Compt = 0;

            app.ColorMaps(1).Name = 'None';
            app.ColorMaps(1).Code = 0;

            while 1
                tline = fgetl(fid);

                if isequal(tline,-1)
                    break
                end

                if length(tline) >= 1
                    if isequal(tline(1),'>')
                        Compt = Compt+1;
                        app.ColorMaps(Compt).Name = tline(3:end);
                        Row = 0;
                        while 1
                            tline = fgetl(fid);
                            if isequal(tline,-1) || isequal(tline,'')
                                break
                            end
                            NUM = strread(tline,'%f'); %# ok
                            Row = Row+1;
                            app.ColorMaps(Compt).Code(Row,1:3) = NUM(1:3);
                        end

                    end
                end
            end
            fclose(fid);

            % Update the menu
            Items=cell(1,numel(app.ColorMaps));
            for i = 1:numel(app.ColorMaps)
                Items{i} = app.ColorMaps(i).Name;
            end

            for i = 1:numel(Items)
                uimenu(app.HeatmapColormapMenu, ...
                    'Text', Items{i}, ...
                    'MenuSelectedFcn', @(src, event) PlotMap_UpdateColormap(app, 256, src));
            end

        end

        function [ColorMap] = PlotMap_UpdateColormap(app,Resolution,src)
            if not(exist('Resolution','var')) || isempty(Resolution)
                Resolution=256;
            end

            names=cell(1,numel(app.ColorMaps));
            for n=1:numel(app.ColorMaps)
                names{n}=app.ColorMaps(n).Name;
            end

            if exist("src","var")
                cmapName = src.Text;
            else
                cmapName =  names{1};
            end

            SelColorMap = find(ismember(names,cmapName));
            ColorData =flip(app.ColorMaps(SelColorMap).Code);

            if Resolution==1
                ColorMap = [0,0,0];
            else
                Step = (Resolution-1)/(size(ColorData,1)-1);
                X = 1:Step:Resolution;


                ColorMap = zeros(length(1:Resolution),size(ColorData,2));
                for i = 1:size(ColorData,2)
                    ColorMap(:,i) = interp1(X',ColorData(:,i),1:Resolution);
                end
                %    ColorMap(1,:) = [0,0,0];
            end

            app.ColorMapValues = ColorMap;
            update_spot_plot(app)
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

            app.IntervalButton.Enable = "on";
            app.IntervalButton.BackgroundColor = orange; % orange because this is the active module
            app.IntervalButton.FontWeight = "bold";

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
                app.base.project.session.config.module_status.interval = true;

            elseif exist("project_id","var") && exist("session_id","var") % coming from the base, GUI stuff

                app.base.project.session =  app.sourceapp.base(project_id).project(session_id).session;

            end

            app.project_id = project_id;
            app.session_id = session_id;
            app.UIFigure.Name = [char(app.base.project_name) ' - ' char(app.base.project.session.session_name)]; %string(app.base.project.session.session_name);

            % keypress function for interval setting shortcuts
            app.UIFigure.KeyPressFcn = @(~,event)KeyPressFcn(app,event);

            update_reductiontype(app)


            % read plot_styles
            try
                if isprop(app.sourceapp, 'default_plotstyle_path') && ~isempty(app.sourceapp.default_plotstyle_path)
                    app.plotstyle_path = app.sourceapp.default_plotstyle_path;
                elseif exist(fullfile(app.sourceapp.installpath, 'Plot_Styles'), 'dir')
                    app.plotstyle_path = fullfile(app.sourceapp.installpath, 'Plot_Styles');
                end
                get_plotstyles(app)
            catch ME
                DisplayError(ME, 'Error reading Plot Styles')
                uialert(app.UIFigure, 'Error reading plot styles', 'Error');
            end








            %update GUI
            update_Interval_Module_GUI(app)

            update_interval_panels(app)

            update_progress_buttons(app)

            datacursormode(app.UIFigure, 'off');


            if ~isfield(app.base.project.session.config, 'spike_threshold')
                app.base.project.session.config.spike_threshold = 600;
            end

            try
                file = fullfile(app.sourceapp.default_VisModule_path,'XMap_ColorMaps.txt');
                ReadColorMaps(app, file)
                PlotMap_UpdateColormap(app, 256);
            catch ME
                DisplayError(ME)
            end

            app.UIFigure.Tag = sprintf('%d_%d', project_id, session_id);

            watch_session_changes(app);
        end

        % Value changed function: ElementLegendListBox
        function ElementLegendListBoxValueChanged(app, event)
            % app.selected_analytes = app.ElementLegendListBox.Value;
            %
            % update_Interval_Module_GUI(app)
            selectedValues = app.ElementLegendListBox.Value;
            if any(selectedValues == 0)
                app.selected_analytes = []; % Empty for 'All'
            else
                app.selected_analytes = selectedValues;
            end
            update_Interval_Module_GUI(app)
        end

        % Value changed function: SpotListBox
        function SpotListBoxValueChanged(app, event)
            app.selected_spot = app.SpotListBox.Value;


            update_Interval_Module_GUI(app)

        end

        % Value changed function: ZoomintoSignalCheckBox
        function ZoomintoSignalCheckBoxValueChanged(app, event)
            update_Interval_Module_GUI(app)

        end

        % Value changed function: LogscaleCheckBox
        function LogscaleCheckBoxValueChanged(app, event)
            update_Interval_Module_GUI(app)

        end

        % Button pushed function: SetBackgroundsButton
        function SetBackgroundsButtonPushed(app, event)
            if ~confirm_overwrite_manual_intervals(app)
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            settings.interval_module_GUI_update_state = true;

            set_automatic_background(app, settings);

        end

        % Button pushed function: ProceedtoClassificationModuleButton
        function ProceedtoClassificationModuleButtonPushed(app, event)

            background_empty = find(isnan(app.base.project.session.spot.background_starts));
            all_matrix_indices = [];
            all_background_only_indices = [];

            if isequal(app.base.project.session.config.reductiontype, 'Inclusion')
                fields_to_check = {'matrix_1_starts', 'matrix_2_starts', 'matrix_3_starts', 'inclusion_1_starts'};
            else
                fields_to_check = {'matrix_1_starts', 'matrix_2_starts', 'matrix_3_starts'};
            end

            % First check: background missing but matrix/inclusion present
            for field = 1:length(fields_to_check)
                matrix_empty   = find(isnan(app.base.project.session.spot.(fields_to_check{field})));
                matrix_indices = setdiff(background_empty, matrix_empty);
                all_matrix_indices = unique([all_matrix_indices; matrix_indices]);
            end

            % Second check: background present but all matrix/inclusion missing
            for i = 1:numel(app.base.project.session.spot.background_starts)
                if ~isnan(app.base.project.session.spot.background_starts(i))
                    all_empty = true;
                    for field = 1:length(fields_to_check)
                        if ~isnan(app.base.project.session.spot.(fields_to_check{field})(i))
                            all_empty = false;
                            break;
                        end
                    end
                    if all_empty
                        all_background_only_indices = [all_background_only_indices; i];
                    end
                end
            end

            % Third check: inclusion interval set but no accompanying matrix interval
            all_inclusion_without_matrix_indices = [];
            if isequal(app.base.project.session.config.reductiontype, 'Inclusion')
                matrix_fields = {'matrix_1_starts', 'matrix_2_starts', 'matrix_3_starts'};
                for i = 1:numel(app.base.project.session.spot.inclusion_1_starts)
                    if ~isnan(app.base.project.session.spot.inclusion_1_starts(i))
                        has_matrix = false;
                        for field = 1:length(matrix_fields)
                            if ~isnan(app.base.project.session.spot.(matrix_fields{field})(i))
                                has_matrix = true;
                                break;
                            end
                        end
                        if ~has_matrix
                            all_inclusion_without_matrix_indices = [all_inclusion_without_matrix_indices; i];
                        end
                    end
                end
            end

            if ~isempty(all_matrix_indices)
                for idx = all_matrix_indices'
                    spotname = app.base.project.session.spot.name(idx);
                    message = sprintf("Missing Background Interval for Spot %d: %s", idx, spotname);
                    uialert(app.UIFigure, message, "Warning", "Icon", "warning");
                    return
                end
            end

            if ~isempty(all_background_only_indices)
                for idx = all_background_only_indices'
                    spotname = app.base.project.session.spot.name(idx);
                    message = sprintf("Missing Matrix or Inclusion Interval for Spot %d: %s", idx, spotname);
                    uialert(app.UIFigure, message, "Warning", "Icon", "warning");
                    return
                end
            end

            if ~isempty(all_inclusion_without_matrix_indices)
                for idx = all_inclusion_without_matrix_indices'
                    spotname = app.base.project.session.spot.name(idx);
                    message = sprintf("Inclusion interval set without a Matrix interval for Spot %d: %s. Note: Reference Materials should always have Matrix intervals assigned, not Inclusion intervals.", idx, spotname);
                    uialert(app.UIFigure, message, "Warning", "Icon", "warning");
                    return
                end
            end

            if isequal(app.base.project.session.config.reductiontype, 'Inclusion') && ...
                    ~all(isnan(app.base.project.session.spot.inclusion_1_starts)) && ...
                    all(strcmp(app.base.project.session.spot.unmixing_via, 'None'))
                message = 'No inclusions were unmixed.';
                uialert(app.UIFigure, message, 'Warning', 'Icon', 'warning');
                return
            end

                        % at least one spot needs intervals, otherwise Drift has nothing to calculate
            if all(isnan(app.base.project.session.spot.background_starts))
                uialert(app.UIFigure, 'No spot has intervals yet. Set the backgrounds and matrix intervals first.', ...
                    'No Intervals', 'Icon', 'warning');
                return
            end

            % every interval that is set must lie inside the signal of its spot and must not be reversed
            if isequal(app.base.project.session.config.datatype, 'Continuous')
                n_sweeps = repmat(height(app.base.project.session.spot.signal_data), numel(app.base.project.session.spot.name), 1);
            else
                n_sweeps = cellfun(@height, app.base.project.session.spot.signal_data(:));
            end

            interval_names = {'background', 'matrix_1', 'matrix_2', 'matrix_3'};
            if isequal(app.base.project.session.config.reductiontype, 'Inclusion')
                interval_names{end+1} = 'inclusion_1';
            end
            for k = 1:numel(interval_names)
                starts = app.base.project.session.spot.([interval_names{k} '_starts'])(:);
                ends   = app.base.project.session.spot.([interval_names{k} '_ends'])(:);
                bad = find(~isnan(starts) & ~isnan(ends) & (ends < starts | starts < 1 | ends > n_sweeps), 1);
                if ~isempty(bad)
                    uialert(app.UIFigure, sprintf(['The %s interval of spot %d (%s) is reversed or lies outside the signal. ' ...
                        'Set it again for this spot.'], strrep(interval_names{k}, '_', ' '), bad, app.base.project.session.spot.name(bad)), ...
                        'Invalid Interval', 'Icon', 'warning');
                    return
                end
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
                            || ~isfield(session_config.module_status, 'interval') ...
                            || ~isequal(session_config.module_status.interval, true)
                        app.base.project.session.config.module_status.interval = true;
                    end

                    settings.ICP_Base_GUI_update_state = true;
                    [app.project_id, app.session_id] = save_to_base(app.sourceapp, app.project_id, app.base.project.session, app.session_id, app.base.project_name, settings);
                    Classification_Module(app.sourceapp, app.base.project_name, app.project_id, app.session_id)
                    delete(app)
                case 'Cancel'
                    return
            end

        end

        % Value changed function: bg_lower_indentEditField
        function bg_lower_indentEditFieldValueChanged(app, event)
          if ~confirm_overwrite_manual_intervals(app)
                app.bg_lower_indentEditField.Value = event.PreviousValue;
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                app.bg_lower_indentEditField.Value = event.PreviousValue;
                return
            end
            app.editstatus = true;

            % Ensure the new value does not go below 0
            if app.bg_lower_indentEditField.Value < 0
                app.bg_lower_indentEditField.Value = 0;
            end

            settings.bg_lower_indent = app.bg_lower_indentEditField.Value;

            settings.interval_module_GUI_update_state = true;
            set_automatic_background(app, settings)
        end

        % Value changed function: bg_upper_indentEditField
        function bg_upper_indentEditFieldValueChanged(app, event)
           if ~confirm_overwrite_manual_intervals(app)
                app.bg_upper_indentEditField.Value = event.PreviousValue;
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                app.bg_upper_indentEditField.Value = event.PreviousValue;
                return
            end
            app.editstatus = true;

            % Ensure the new value does not go below 0
            if app.bg_upper_indentEditField.Value < 0
                app.bg_upper_indentEditField.Value = 0;
            end

            settings.bg_upper_indent = app.bg_upper_indentEditField.Value;

            settings.interval_module_GUI_update_state = true;
            set_automatic_background(app, settings)

        end

        % Value changed function: PlotBackgroundcorrectedCheckBox
        function PlotBackgroundcorrectedCheckBoxValueChanged(app, event)
            if isfield(app.base.project.session.spot, 'background_starts') && isfield(app.base.project.session.spot, 'background_ends') ...
                    && ~isnan(app.base.project.session.spot.background_starts(app.selected_spot)) && ~isnan(app.base.project.session.spot.background_ends(app.selected_spot))
                update_Interval_Module_GUI(app)
            else
                app.PlotBackgroundcorrectedCheckBox.Value = false;
                message = "Set Background first";
                uialert(app.UIFigure, message, "Warning", "Icon", "warning");
            end
        end

        % Button pushed function: NextSignalButton
        function NextSignalButtonPushed(app, event)
            %check if this is the first selected_spot, if yes and you
            %press it jumps to the first signal, otherwise it just goes
            %one signal forward
            if app.selected_spot == numel(app.SpotListBox.Items)

                app.selected_spot = 1;
                app.SpotListBox.Value = 1;

            else
                app.selected_spot=app.selected_spot + 1;
                app.SpotListBox.Value=app.SpotListBox.Value + 1;
            end

            %update the element list and the plot
            update_Interval_Module_GUI(app)
        end

        % Button pushed function: PreviousSignalButton
        function PreviousSignalButtonPushed(app, event)
            %check if this is the first selected_spot, if yes and you
            %press it jumps to the first signal, otherwise it just goes
            %one signal forward
            if app.selected_spot == 1

                app.selected_spot = numel(app.SpotListBox.Items);
                app.SpotListBox.Value = numel(app.SpotListBox.Items);


            else
                app.selected_spot = app.selected_spot - 1;
                app.SpotListBox.Value=app.SpotListBox.Value - 1;
            end

            %update the element list and the plot
            update_Interval_Module_GUI(app)
        end

        % Button pushed function: BgLowerLimitMinusTenButton
        function BgLowerLimitMinusTenButtonPushed(app, event)
            if ~confirm_overwrite_manual_intervals(app)
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            if not(isfield(app.base.project.session.spot, 'background_starts'))
                return
            end

            % Calculate the new value
            app.bg_lower_indentEditField.Value = app.bg_lower_indentEditField.Value - 10;

            % Ensure the new value does not go below 0
            if app.bg_lower_indentEditField.Value < 0
                app.bg_lower_indentEditField.Value = 0;
            end

            settings.bg_lower_indent = app.bg_lower_indentEditField.Value;
            % Ensure the new value does not go below the minimum x limit
            set_automatic_background(app, settings)
            % Update the plot
            update_Interval_Module_GUI(app)
        end

        % Button pushed function: BgLowerLimitMinusOneButton
        function BgLowerLimitMinusOneButtonPushed(app, event)
            if ~confirm_overwrite_manual_intervals(app)
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            if not(isfield(app.base.project.session.spot, 'background_starts'))
                return
            end

            % Calculate the new value
            app.bg_lower_indentEditField.Value = app.bg_lower_indentEditField.Value - 1;

            % Ensure the new value does not go below 0
            if app.bg_lower_indentEditField.Value < 0
                app.bg_lower_indentEditField.Value = 0;
            end

            settings.bg_lower_indent = app.bg_lower_indentEditField.Value;
            % Ensure the new value does not go below the minimum x limit
            set_automatic_background(app, settings)
            % Update the plot
            update_Interval_Module_GUI(app)
        end

        % Button pushed function: BgLowerLimitPlusOneButton
        function BgLowerLimitPlusOneButtonPushed(app, event)
            if ~confirm_overwrite_manual_intervals(app)
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            if not(isfield(app.base.project.session.spot, 'background_starts'))
                return
            end

            % Calculate the new value
            app.bg_lower_indentEditField.Value = app.bg_lower_indentEditField.Value + 1;

            % Ensure the new value does not go below 0
            if app.bg_lower_indentEditField.Value < 0
                app.bg_lower_indentEditField.Value = 0;
            end

            settings.bg_lower_indent = app.bg_lower_indentEditField.Value;
            % Ensure the new value does not go below the minimum x limit
            set_automatic_background(app, settings)
            % Update the plot
            update_Interval_Module_GUI(app)
        end

        % Button pushed function: BgLowerLimitPlusTenButton
        function BgLowerLimitPlusTenButtonPushed(app, event)
            if ~confirm_overwrite_manual_intervals(app)
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            if not(isfield(app.base.project.session.spot, 'background_starts'))
                return
            end

            % Calculate the new value
            app.bg_lower_indentEditField.Value = app.bg_lower_indentEditField.Value + 10;

            % Ensure the new value does not go below 0
            if app.bg_lower_indentEditField.Value < 0
                app.bg_lower_indentEditField.Value = 0;
            end

            settings.bg_lower_indent = app.bg_lower_indentEditField.Value;
            % Ensure the new value does not go below the minimum x limit
            set_automatic_background(app, settings)
            % Update the plot
            update_Interval_Module_GUI(app)
        end

        % Button pushed function: BgUpperLimitMinusTenButton
        function BgUpperLimitMinusTenButtonPushed(app, event)
            if ~confirm_overwrite_manual_intervals(app)
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            if not(isfield(app.base.project.session.spot, 'background_ends'))
                return
            end

            % Calculate the new value
            app.bg_upper_indentEditField.Value = app.bg_upper_indentEditField.Value + 10;

            % Ensure the new value does not go below 0
            if app.bg_upper_indentEditField.Value < 0
                app.bg_upper_indentEditField.Value = 0;
            end

            settings.bg_upper_indent = app.bg_upper_indentEditField.Value;
            % Ensure the new value does not go below the minimum x limit
            set_automatic_background(app, settings)
            % Update the plot
            update_Interval_Module_GUI(app)
        end

        % Button pushed function: BgUpperLimitMinusOneButton
        function BgUpperLimitMinusOneButtonPushed(app, event)
            if ~confirm_overwrite_manual_intervals(app)
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            if not(isfield(app.base.project.session.spot, 'background_ends'))
                return
            end

            % Calculate the new value
            app.bg_upper_indentEditField.Value = app.bg_upper_indentEditField.Value + 1;

            % Ensure the new value does not go below 0
            if app.bg_upper_indentEditField.Value < 0
                app.bg_upper_indentEditField.Value = 0;
            end

            settings.bg_upper_indent = app.bg_upper_indentEditField.Value;
            % Ensure the new value does not go below the minimum x limit
            set_automatic_background(app, settings)
            % Update the plot
            update_Interval_Module_GUI(app)
        end

        % Button pushed function: BgUpperLimitPlusOneButton
        function BgUpperLimitPlusOneButtonPushed(app, event)
            if ~confirm_overwrite_manual_intervals(app)
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            if not(isfield(app.base.project.session.spot, 'background_ends'))
                return
            end

            % Calculate the new value
            app.bg_upper_indentEditField.Value = app.bg_upper_indentEditField.Value - 1;

            % Ensure the new value does not go below 0
            if app.bg_upper_indentEditField.Value < 0
                app.bg_upper_indentEditField.Value = 0;
            end

            settings.bg_upper_indent = app.bg_upper_indentEditField.Value;
            % Ensure the new value does not go below the minimum x limit
            set_automatic_background(app, settings)
            % Update the plot
            update_Interval_Module_GUI(app)
        end

        % Button pushed function: BgUpperLimitPlusTenButton
        function BgUpperLimitPlusTenButtonPushed(app, event)
            if ~confirm_overwrite_manual_intervals(app)
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            if not(isfield(app.base.project.session.spot, 'background_ends'))
                return
            end

            % Calculate the new value
            app.bg_upper_indentEditField.Value = app.bg_upper_indentEditField.Value - 10;

            % Ensure the new value does not go below 0
            if app.bg_upper_indentEditField.Value < 0
                app.bg_upper_indentEditField.Value = 0;
            end

            settings.bg_upper_indent = app.bg_upper_indentEditField.Value;
            % Ensure the new value does not go below the minimum x limit
            set_automatic_background(app, settings)
            % Update the plot
            update_Interval_Module_GUI(app)
        end

        % Button down function: SpotAxes
        function SpotAxesButtonDown(app, event)

            if isempty(app.hLineToDrag) || numel(app.hLineToDrag)==0
                %reset_zoom_pan(app)

                for k = 1:12
                    if numel(app.hVerticalLines)<k || isempty(app.hVerticalLines(k).xl) || not(isvalid(app.hVerticalLines(k).xl))
                        continue
                    end
                    xVertLineCoord = get(app.hVerticalLines(k).xl,'Value');
                    click_buffer = (max(app.SpotAxes.XLim)-min(app.SpotAxes.XLim))*0.01;
                    xVertLineCoord(1) = xVertLineCoord(1);
                    if abs(event.IntersectionPoint(1) - xVertLineCoord(1)) < click_buffer
                        app.hLineToDrag = app.hVerticalLines(k);
                        %disp(app.hLineToDrag(1).xl.Tag)
                        return;
                    end
                end

                if numel(app.hVerticalLines)>1 && not(isempty(app.hVerticalLines(1).xl))&&  isvalid(app.hVerticalLines(1).xl) && not(isempty(app.hVerticalLines(2).xl))&&  isvalid(app.hVerticalLines(2).xl)&& get(app.hVerticalLines(1).xl,'Value')<abs(event.IntersectionPoint(1)) && get(app.hVerticalLines(2).xl,'Value')>abs(event.IntersectionPoint(1))
                    app.hLineToDrag = app.hVerticalLines(1:2);
                    return;
                elseif numel(app.hVerticalLines)>3 && not(isempty(app.hVerticalLines(3).xl))&& isvalid(app.hVerticalLines(3).xl) && not(isempty(app.hVerticalLines(4).xl))&&  isvalid(app.hVerticalLines(4).xl)&& get(app.hVerticalLines(3).xl,'Value')<abs(event.IntersectionPoint(1)) && get(app.hVerticalLines(4).xl,'Value')>abs(event.IntersectionPoint(1))
                    app.hLineToDrag = app.hVerticalLines(3:4);
                    return;
                elseif numel(app.hVerticalLines)>5 && not(isempty(app.hVerticalLines(5).xl))&& isvalid(app.hVerticalLines(5).xl) && not(isempty(app.hVerticalLines(6).xl))&&  isvalid(app.hVerticalLines(6).xl)&& get(app.hVerticalLines(5).xl,'Value')<abs(event.IntersectionPoint(1)) && get(app.hVerticalLines(6).xl,'Value')>abs(event.IntersectionPoint(1))
                    app.hLineToDrag = app.hVerticalLines(5:6);
                    return;
                elseif numel(app.hVerticalLines)>7 && not(isempty(app.hVerticalLines(7).xl))&& isvalid(app.hVerticalLines(7).xl) && not(isempty(app.hVerticalLines(8).xl))&&  isvalid(app.hVerticalLines(8).xl)&& get(app.hVerticalLines(7).xl,'Value')<abs(event.IntersectionPoint(1)) && get(app.hVerticalLines(8).xl,'Value')>abs(event.IntersectionPoint(1))
                    app.hLineToDrag = app.hVerticalLines(7:8);
                    return;
                elseif numel(app.hVerticalLines)>9 && not(isempty(app.hVerticalLines(9).xl))&& isvalid(app.hVerticalLines(9).xl) && not(isempty(app.hVerticalLines(10).xl))&&  isvalid(app.hVerticalLines(10).xl)&& get(app.hVerticalLines(9).xl,'Value')<abs(event.IntersectionPoint(1)) && get(app.hVerticalLines(10).xl,'Value')>abs(event.IntersectionPoint(1))
                    app.hLineToDrag = app.hVerticalLines(9:10);
                    return;
                elseif numel(app.hVerticalLines)>11 && not(isempty(app.hVerticalLines(11).xl))&& isvalid(app.hVerticalLines(11).xl) && not(isempty(app.hVerticalLines(12).xl))&&  isvalid(app.hVerticalLines(12).xl)&& get(app.hVerticalLines(11).xl,'Value')<abs(event.IntersectionPoint(1)) && get(app.hVerticalLines(12).xl,'Value')>abs(event.IntersectionPoint(1))
                    app.hLineToDrag = app.hVerticalLines(11:12);
                    return;
                end
            end

        end

        % Window button motion function: UIFigure
        function UIFigureWindowButtonMotion(app, event)
            if ~isempty(app.hLineToDrag) && numel(app.hLineToDrag) > 0

                currentPoint   = app.SpotAxes.CurrentPoint;
                x            = currentPoint(1,1);
                y            = currentPoint(1,2);
                xlim_ = app.SpotAxes.XLim;
                ylim_ = app.SpotAxes.YLim;
                inside_SpotAxes = x >= xlim_(1) & x <= xlim_(2) & y >= ylim_(1) & y <= ylim_(2); % x >= xlim(1) & x <= xlim(2) & y >= ylim(1) & y <= ylim(2)


                if inside_SpotAxes
                    currentPoint   = app.SpotAxes.CurrentPoint;
                    x            = currentPoint(1,1);
                    %% check the position of the other lines
                    if isempty(app.hVerticalLinesBounds)
                        tmp=nan(1,numel(app.hVerticalLines));
                        for n = 1:numel(app.hVerticalLines) %1:10
                            if isempty(app.hVerticalLines(n).xl)
                                continue
                            end
                            if numel(app.hVerticalLines)>=n && isvalid(app.hVerticalLines(n).xl) && not(isequal(app.hVerticalLines(n).xl, app.hLineToDrag(1).xl))
                                tmp(n)=[app.hVerticalLines(n).xl.Value];
                            end
                        end
                    end

                    if isempty(app.hVerticalLinesBounds)
                        tmp=tmp(not(ismember(tmp,get(app.hLineToDrag(1).xl,'Value'))));
                        if numel(app.hLineToDrag)==2
                            tmp=tmp(not(ismember(tmp,get(app.hLineToDrag(2).xl,'Value'))));
                        end

                        tmp_larger=[tmp(tmp>x) max(xlim_)];
                        tmp_smaller=[tmp(tmp<x) min(xlim_)];
                        if numel(app.hLineToDrag)==2
                            tmp_larger=tmp_larger-abs(app.hLineToDrag(2).xl.Value-app.hLineToDrag(1).xl.Value)./2;
                            tmp_smaller=tmp_smaller+abs(app.hLineToDrag(2).xl.Value-app.hLineToDrag(1).xl.Value)./2;
                        end

                        [~, ix_larger]=min(abs(x-tmp_larger));
                        [~, ix_smaller]=min(abs(x-tmp_smaller));

                        upperbound=tmp_larger(ix_larger);
                        lowerbound=tmp_smaller(ix_smaller);
                        app.hVerticalLinesBounds=[lowerbound,upperbound];
                    else
                        lowerbound=app.hVerticalLinesBounds(1);
                        upperbound=app.hVerticalLinesBounds(2);
                    end
                    inside_bounds = x > lowerbound & x < upperbound;

                    if   inside_bounds
                        if numel(app.hLineToDrag)==2

                            xposlines=[get(app.hLineToDrag(1).xl,'Value') get(app.hLineToDrag(2).xl,'Value')];
                            difference=range(xposlines)/2; % here get the difference between the lines

                            x1=x-difference;
                            x2=x+difference;

                            set(app.hLineToDrag(1).xl, 'Value', x1);
                            set(app.hLineToDrag(2).xl, 'Value', x2);

                        else
                            set(app.hLineToDrag(1).xl, 'Value', x);
                        end
                        if inside_SpotAxes
                            update_interval_areas(app); % Update patches
                        end


                    end
                else
                    UIFigureWindowButtonUp(app)
                end

            end
        end

        % Window button up function: UIFigure
        function UIFigureWindowButtonUp(app, event)


            if ~isempty(app.hLineToDrag)

                changes = check_changes(app, 'interval');
                if changes == false
                    app.hVerticalLinesBounds = [];
                    app.hLineToDrag = [];
                end

                if not(isempty(app.hLineToDrag)) && isvalid(app.hLineToDrag(1).xl)

                    app.editstatus = true;

                    if strcmp(app.hLineToDrag(1).xl.Tag, 'spot_bg_interval')

                        xpos = sort([app.hVerticalLines(1).xl.Value, app.hVerticalLines(2).xl.Value]);
                        [~, idx1] = min(abs(app.active_spot_indices - xpos(1)));
                        [~, idx2] = min(abs(app.active_spot_indices - xpos(2)));

                        if idx1 == app.base.project.session.spot.matrix_1_ends(app.selected_spot)
                            idx1 = idx1 + 1;
                        elseif idx1 == app.base.project.session.spot.matrix_2_ends(app.selected_spot)
                            idx1 = idx1 + 1;
                        elseif isfield(app.base.project.session.spot, 'inclusion_1_ends') && isequal(idx1, app.base.project.session.spot.inclusion_1_ends(app.selected_spot))
                            idx1 = idx1 + 1;
                        elseif idx1 == app.base.project.session.spot.matrix_3_ends(app.selected_spot)
                            idx1 = idx1 + 1;
                        end

                        if idx2 == app.base.project.session.spot.matrix_1_starts(app.selected_spot)
                            idx2 = idx2 - 1;
                        elseif idx2 == app.base.project.session.spot.matrix_2_starts(app.selected_spot)
                            idx2 = idx2 - 1;
                        elseif isfield(app.base.project.session.spot, 'inclusion_1_starts') && isequal(idx2, app.base.project.session.spot.inclusion_1_starts(app.selected_spot))
                            idx2 = idx2 - 1;
                        elseif idx2 == app.base.project.session.spot.matrix_3_starts(app.selected_spot)
                            idx2 = idx2 - 1;
                        end

                        app.base.project.session.spot.background_starts(app.selected_spot) = app.active_spot_indices(idx1);
                        app.base.project.session.spot.background_ends(app.selected_spot)   = app.active_spot_indices(idx2);

                    elseif strcmp(app.hLineToDrag(1).xl.Tag, 'spot_host_1_interval')

                        xpos = sort([app.hVerticalLines(3).xl.Value, app.hVerticalLines(4).xl.Value]);
                        [~, idx1] = min(abs(app.active_spot_indices - xpos(1)));
                        [~, idx2] = min(abs(app.active_spot_indices - xpos(2)));

                        if idx1 == app.base.project.session.spot.background_ends(app.selected_spot)
                            idx1 = idx1 + 1;
                        elseif idx1 == app.base.project.session.spot.matrix_2_ends(app.selected_spot)
                            idx1 = idx1 + 1;
                        elseif isfield(app.base.project.session.spot, 'inclusion_1_ends') && isequal(idx1, app.base.project.session.spot.inclusion_1_ends(app.selected_spot))
                            idx1 = idx1 + 1;
                        elseif idx1 == app.base.project.session.spot.matrix_3_ends(app.selected_spot)
                            idx1 = idx1 + 1;
                        end

                        if idx2 == app.base.project.session.spot.background_starts(app.selected_spot)
                            idx2 = idx2 - 1;
                        elseif idx2 == app.base.project.session.spot.matrix_2_starts(app.selected_spot)
                            idx2 = idx2 - 1;
                        elseif isfield(app.base.project.session.spot, 'inclusion_1_starts') && isequal(idx2, app.base.project.session.spot.inclusion_1_starts(app.selected_spot))
                            idx2 = idx2 - 1;
                        elseif idx2 == app.base.project.session.spot.matrix_3_starts(app.selected_spot)
                            idx2 = idx2 - 1;
                        end

                        app.base.project.session.spot.matrix_1_starts(app.selected_spot) = app.active_spot_indices(idx1);
                        app.base.project.session.spot.matrix_1_ends(app.selected_spot)   = app.active_spot_indices(idx2);

                    elseif strcmp(app.hLineToDrag(1).xl.Tag, 'spot_host_2_interval')

                        xpos = sort([app.hVerticalLines(5).xl.Value, app.hVerticalLines(6).xl.Value]);
                        [~, idx1] = min(abs(app.active_spot_indices - xpos(1)));
                        [~, idx2] = min(abs(app.active_spot_indices - xpos(2)));

                        if idx1 == app.base.project.session.spot.background_ends(app.selected_spot)
                            idx1 = idx1 + 1;
                        elseif idx1 == app.base.project.session.spot.matrix_1_ends(app.selected_spot)
                            idx1 = idx1 + 1;
                        elseif isfield(app.base.project.session.spot, 'inclusion_1_ends') && isequal(idx1, app.base.project.session.spot.inclusion_1_ends(app.selected_spot))
                            idx1 = idx1 + 1;
                        elseif idx1 == app.base.project.session.spot.matrix_3_ends(app.selected_spot)
                            idx1 = idx1 + 1;
                        end

                        if idx2 == app.base.project.session.spot.background_starts(app.selected_spot)
                            idx2 = idx2 - 1;
                        elseif idx2 == app.base.project.session.spot.matrix_1_starts(app.selected_spot)
                            idx2 = idx2 - 1;
                        elseif isfield(app.base.project.session.spot, 'inclusion_1_starts') && isequal(idx2, app.base.project.session.spot.inclusion_1_starts(app.selected_spot))
                            idx2 = idx2 - 1;
                        elseif idx2 == app.base.project.session.spot.matrix_3_starts(app.selected_spot)
                            idx2 = idx2 - 1;
                        end

                        app.base.project.session.spot.matrix_2_starts(app.selected_spot) = app.active_spot_indices(idx1);
                        app.base.project.session.spot.matrix_2_ends(app.selected_spot)   = app.active_spot_indices(idx2);

                    elseif strcmp(app.hLineToDrag(1).xl.Tag, 'spot_incl_1_interval')

                        xpos = sort([app.hVerticalLines(7).xl.Value, app.hVerticalLines(8).xl.Value]);
                        [~, idx1] = min(abs(app.active_spot_indices - xpos(1)));
                        [~, idx2] = min(abs(app.active_spot_indices - xpos(2)));

                        if idx1 == app.base.project.session.spot.background_ends(app.selected_spot)
                            idx1 = idx1 + 1;
                        elseif idx1 == app.base.project.session.spot.matrix_1_ends(app.selected_spot)
                            idx1 = idx1 + 1;
                        elseif idx1 == app.base.project.session.spot.matrix_2_ends(app.selected_spot)
                            idx1 = idx1 + 1;
                        elseif idx1 == app.base.project.session.spot.matrix_3_ends(app.selected_spot)
                            idx1 = idx1 + 1;
                        end

                        if idx2 == app.base.project.session.spot.background_starts(app.selected_spot)
                            idx2 = idx2 - 1;
                        elseif idx2 == app.base.project.session.spot.matrix_1_starts(app.selected_spot)
                            idx2 = idx2 - 1;
                        elseif idx2 == app.base.project.session.spot.matrix_2_starts(app.selected_spot)
                            idx2 = idx2 - 1;
                        elseif idx2 == app.base.project.session.spot.matrix_3_starts(app.selected_spot)
                            idx2 = idx2 - 1;
                        end

                        app.base.project.session.spot.inclusion_1_starts(app.selected_spot) = app.active_spot_indices(idx1);
                        app.base.project.session.spot.inclusion_1_ends(app.selected_spot)   = app.active_spot_indices(idx2);

                    elseif strcmp(app.hLineToDrag(1).xl.Tag, 'spot_host_3_interval')

                        xpos = sort([app.hVerticalLines(9).xl.Value, app.hVerticalLines(10).xl.Value]);
                        [~, idx1] = min(abs(app.active_spot_indices - xpos(1)));
                        [~, idx2] = min(abs(app.active_spot_indices - xpos(2)));

                        if idx1 == app.base.project.session.spot.background_ends(app.selected_spot)
                            idx1 = idx1 + 1;
                        elseif idx1 == app.base.project.session.spot.matrix_1_ends(app.selected_spot)
                            idx1 = idx1 + 1;
                        elseif idx1 == app.base.project.session.spot.matrix_2_ends(app.selected_spot)
                            idx1 = idx1 + 1;
                        elseif isfield(app.base.project.session.spot, 'inclusion_1_ends') && isequal(idx1, app.base.project.session.spot.inclusion_1_ends(app.selected_spot))
                            idx1 = idx1 + 1;
                        end

                        if idx2 == app.base.project.session.spot.background_starts(app.selected_spot)
                            idx2 = idx2 - 1;
                        elseif idx2 == app.base.project.session.spot.matrix_1_starts(app.selected_spot)
                            idx2 = idx2 - 1;
                        elseif idx2 == app.base.project.session.spot.matrix_2_starts(app.selected_spot)
                            idx2 = idx2 - 1;
                        elseif isfield(app.base.project.session.spot, 'inclusion_1_starts') && isequal(idx2, app.base.project.session.spot.inclusion_1_starts(app.selected_spot))
                            idx2 = idx2 - 1;
                        end

                        app.base.project.session.spot.matrix_3_starts(app.selected_spot) = app.active_spot_indices(idx1);
                        app.base.project.session.spot.matrix_3_ends(app.selected_spot)   = app.active_spot_indices(idx2);

                    end

                    app.base.project.session.config.manual_intervals = true;
                end

                app.hVerticalLinesBounds = [];
                app.hLineToDrag = [];

                if strcmp(app.base.project.session.config.reductiontype, 'Inclusion')
                    update_inclusion_unmixing(app)
                end

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
                    || ~isfield(session_config.module_status, 'interval') ...
                    || ~session_config.module_status.interval
                app.base.project.session.config.module_status.interval = true;
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

        % Value changed function: PlotstylesListBox
        function PlotstylesListBoxValueChanged(app, event)
            app.selected_plotstyle = app.PlotstylesListBox.Value;

            app.selected_analytes = []; % empty the selected_analytes list when the plotstyle is changed so that it resets to show all again

            update_Interval_Module_GUI(app)


        end

        % Value changed function: ShowLegendCheckBox
        function ShowLegendCheckBoxValueChanged(app, event)

            update_Interval_Module_GUI(app)
        end

        % Value changed function: ShowIntervalsCheckBox
        function ShowIntervalsCheckBoxValueChanged(app, event)

            update_Interval_Module_GUI(app)

        end

        % Value changed function: CommentTextArea
        function CommentTextAreaValueChanged(app, event)
            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;


            comment = app.CommentTextArea.Value;

            if ~isfield(app.base.project.session.meta, 'comment') || isempty(app.base.project.session.meta.comment)
                app.base.project.session.meta.comment = repmat("", numel(app.base.project.session.spot.signal_starts), 1);
            end

            app.base.project.session.meta.comment(app.selected_spot) = string(strjoin(comment, newline));

        end

        % Button pushed function: DeleteBackgroundsButton
        function DeleteBackgroundsButtonPushed(app, event)
            if ~confirm_overwrite_manual_intervals(app)
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            app.base.project.session.spot.background_starts = NaN(size(app.base.project.session.spot.signal_starts));
            app.base.project.session.spot.background_ends   = NaN(size(app.base.project.session.spot.signal_ends));

            app.base.project.session.config.manual_intervals = false;

            update_Interval_Module_GUI(app)
        end

        % Button pushed function: SetBackgroundButton
        function SetBackgroundButtonPushed(app, event)
            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            app.ShowIntervalsCheckBox.Value = true;

            update_Interval_Module_GUI(app)

            draw_interval_via_rectangles(app, "Background")

            update_Interval_Module_GUI(app)
        end

        % Button pushed function: Set1MatrixButton
        function Set1MatrixButtonPushed(app, event)
            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            app.ShowIntervalsCheckBox.Value = true;

            update_Interval_Module_GUI(app)

            draw_interval_via_rectangles(app, "Host_1")

            update_Interval_Module_GUI(app)
        end

        % Button pushed function: DeleteBackgroundButton
        function DeleteBackgroundButtonPushed(app, event)
            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            app.base.project.session.spot.background_starts(app.selected_spot) = NaN;
            app.base.project.session.spot.background_ends(app.selected_spot)   = NaN;

            app.base.project.session.config.manual_intervals = true;

            update_Interval_Module_GUI(app)
        end

        % Button pushed function: Delete1MatrixButton
        function Delete1MatrixButtonPushed(app, event)
            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            app.base.project.session.spot.matrix_1_starts(app.selected_spot) = NaN;
            app.base.project.session.spot.matrix_1_ends(app.selected_spot)   = NaN;

            app.base.project.session.config.manual_intervals = true;

            update_Interval_Module_GUI(app)
        end

        % Button pushed function: EliminateSpikesButton
        function EliminateSpikesButtonPushed(app, event)


            changes = check_changes(app, 'interval');
            if changes == false
                return
            end

            try
                if ~isfield(app.base.project.session.spot, 'eliminated_spikes')
                    app.base.project.session.spot.eliminated_spikes = cell(size(app.base.project.session.spot.name));
                end

                if isequal(app.base.project.session.config.reductiontype, 'Matrix')
                    if strcmp(app.base.project.session.config.datatype, 'Continuous')
                        data_indices = app.active_spot_indices;
                        data_to_process = table2array(app.base.project.session.spot.signal_data(data_indices, 2:end));

                        [corrected_block, spikes] = spike_elimination(app, data_to_process, data_indices(1));

                        app.base.project.session.spot.signal_data(data_indices, 2:end) = array2table(corrected_block);
                        app.base.project.session.spot.eliminated_spikes{app.selected_spot} = [app.base.project.session.spot.eliminated_spikes{app.selected_spot}; spikes];

                    elseif strcmp(app.base.project.session.config.datatype, 'Single')
                        data_to_process = table2array(app.base.project.session.spot.signal_data{app.selected_spot}(:, 2:end));

                        [corrected_data, spikes] = spike_elimination(app, data_to_process, 1);

                        app.base.project.session.spot.signal_data{app.selected_spot}(:, 2:end) = array2table(corrected_data);
                        app.base.project.session.spot.eliminated_spikes{app.selected_spot} = [app.base.project.session.spot.eliminated_spikes{app.selected_spot}; spikes];
                    end

                elseif isequal(app.base.project.session.config.reductiontype, 'Inclusion')
                    inc_start = app.base.project.session.spot.inclusion_1_starts(app.selected_spot);
                    inc_end   = app.base.project.session.spot.inclusion_1_ends(app.selected_spot);
                    has_inclusion = ~isnan(inc_start) && ~isnan(inc_end);

                    if strcmp(app.base.project.session.config.datatype, 'Continuous')
                        data_indices = app.active_spot_indices;
                        data_to_process = table2array(app.base.project.session.spot.signal_data(data_indices, 2:end));

                        if has_inclusion
                            start_offset = data_indices(1) - 1;
                            relative_inc_start = inc_start - start_offset;
                            relative_inc_end   = inc_end   - start_offset;

                            before_inc = data_to_process(1:relative_inc_start-1, :);
                            in_inc     = data_to_process(relative_inc_start:relative_inc_end, :);
                            after_inc  = data_to_process(relative_inc_end+1:end, :);

                            spikes_before = [];
                            spikes_after  = [];

                            if ~isempty(before_inc)
                                [before_inc, spikes_before] = spike_elimination(app, before_inc, data_indices(1));
                            end
                            if ~isempty(after_inc)
                                [after_inc, spikes_after] = spike_elimination(app, after_inc, data_indices(1) + relative_inc_end);
                                if ~isempty(spikes_after)
                                    spikes_after.RowIndex = spikes_after.RowIndex + relative_inc_end;
                                end
                            end

                            corrected_block = [before_inc; in_inc; after_inc];
                            spikes = [spikes_before; spikes_after];
                        else
                            [corrected_block, spikes] = spike_elimination(app, data_to_process, data_indices(1));
                        end

                        app.base.project.session.spot.signal_data(data_indices, 2:end) = array2table(corrected_block);
                        app.base.project.session.spot.eliminated_spikes{app.selected_spot} = [app.base.project.session.spot.eliminated_spikes{app.selected_spot}; spikes];

                    elseif strcmp(app.base.project.session.config.datatype, 'Single')
                        data_to_process = table2array(app.base.project.session.spot.signal_data{app.selected_spot}(:, 2:end));

                        if has_inclusion
                            before_inc = data_to_process(1:inc_start-1, :);
                            in_inc     = data_to_process(inc_start:inc_end, :);
                            after_inc  = data_to_process(inc_end+1:end, :);

                            spikes_before = [];
                            spikes_after  = [];

                            if ~isempty(before_inc)
                                [before_inc, spikes_before] = spike_elimination(app, before_inc, 1);
                            end
                            if ~isempty(after_inc)
                                [after_inc, spikes_after] = spike_elimination(app, after_inc, inc_end + 1);
                                if ~isempty(spikes_after)
                                    spikes_after.RowIndex = spikes_after.RowIndex + inc_end;
                                end
                            end

                            corrected_data = [before_inc; in_inc; after_inc];
                            spikes = [spikes_before; spikes_after];
                        else
                            [corrected_data, spikes] = spike_elimination(app, data_to_process, 1);
                        end

                        app.base.project.session.spot.signal_data{app.selected_spot}(:, 2:end) = array2table(corrected_data);
                        app.base.project.session.spot.eliminated_spikes{app.selected_spot} = [app.base.project.session.spot.eliminated_spikes{app.selected_spot}; spikes];
                    end
                end

                update_Interval_Module_GUI(app)

            catch ME
                DisplayError(ME, 'Spike elimination');
                uialert(app.UIFigure, "Spike elimination failed", "Warning", "Icon", "warning");
                return;
            end


        end

        % Button pushed function: SetInclusionButton
        function SetInclusionButtonPushed(app, event)
            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            app.ShowIntervalsCheckBox.Value = true;
            update_Interval_Module_GUI(app)

            draw_interval_via_rectangles(app, "Inclusion_1")

            update_Interval_Module_GUI(app)
        end

        % Button pushed function: Set2MatrixButton
        function Set2MatrixButtonPushed(app, event)
            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            app.ShowIntervalsCheckBox.Value = true;
            update_Interval_Module_GUI(app)

            draw_interval_via_rectangles(app, "Host_2")

            update_Interval_Module_GUI(app)
        end

        % Button pushed function: Set3MatrixButton
        function Set3MatrixButtonPushed(app, event)
            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            app.ShowIntervalsCheckBox.Value = true;

            update_Interval_Module_GUI(app)

            draw_interval_via_rectangles(app, "Matrix_3")

            update_Interval_Module_GUI(app)
        end

        % Button pushed function: Delete2MatrixButton
        function Delete2MatrixButtonPushed(app, event)
            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            app.base.project.session.spot.matrix_2_starts(app.selected_spot) = NaN;
            app.base.project.session.spot.matrix_2_ends(app.selected_spot)   = NaN;

            app.base.project.session.config.manual_intervals = true;

            update_Interval_Module_GUI(app)
        end

        % Button pushed function: DeleteInclusionButton
        function DeleteInclusionButtonPushed(app, event)
            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;


            app.base.project.session.spot.inclusion_1_starts(app.selected_spot) = NaN;
            app.base.project.session.spot.inclusion_1_ends(app.selected_spot)   = NaN;

            app.base.project.session.config.manual_intervals = true;

            update_Interval_Module_GUI(app)
        end

        % Button pushed function: Delete3MatrixButton
        function Delete3MatrixButtonPushed(app, event)
            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            app.base.project.session.spot.matrix_3_starts(app.selected_spot) = NaN;
            app.base.project.session.spot.matrix_3_ends(app.selected_spot)   = NaN;

            app.base.project.session.config.manual_intervals = true;

            update_Interval_Module_GUI(app)
        end

        % Button pushed function: SetMatrixButton
        function SetmatrixintervalsautomaticallyButtonPushed(app, event)
            if ~confirm_overwrite_manual_intervals(app)
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            settings.interval_module_GUI_update_state = true;

            set_automatic_matrix(app, settings);

        end

        % Button pushed function: MatrixLowerLimitMinusTenButton
        function MatrixLowerLimitMinusTenButtonPushed(app, event)
            if ~confirm_overwrite_manual_intervals(app)
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            if not(isfield(app.base.project.session.spot, 'matrix_1_starts'))
                return
            end

            % Calculate the new value
            app.matrix_lower_indentEditField.Value = app.matrix_lower_indentEditField.Value - 10;

            % Ensure the new value does not go below 0
            if app.matrix_lower_indentEditField.Value < 0
                app.matrix_lower_indentEditField.Value = 0;
            end

            settings.matrix_lower_indent = app.matrix_lower_indentEditField.Value;
            % Ensure the new value does not go below the minimum x limit
            set_automatic_matrix(app, settings)
            % Update the plot
            update_Interval_Module_GUI(app)
        end

        % Button pushed function: MatrixLowerLimitMinusOneButton
        function MatrixLowerLimitMinusOneButtonPushed(app, event)
            if ~confirm_overwrite_manual_intervals(app)
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            if not(isfield(app.base.project.session.spot, 'matrix_1_starts'))
                return
            end

            % Calculate the new value
            app.matrix_lower_indentEditField.Value = app.matrix_lower_indentEditField.Value - 1;

            % Ensure the new value does not go below 0
            if app.matrix_lower_indentEditField.Value < 0
                app.matrix_lower_indentEditField.Value = 0;
            end

            settings.matrix_lower_indent = app.matrix_lower_indentEditField.Value;
            % Ensure the new value does not go below the minimum x limit
            set_automatic_matrix(app, settings)
            % Update the plot
            update_Interval_Module_GUI(app)
        end

        % Button pushed function: MatrixLowerLimitPlusOneButton
        function MatrixLowerLimitPlusOneButtonPushed(app, event)
            if ~confirm_overwrite_manual_intervals(app)
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            if not(isfield(app.base.project.session.spot, 'matrix_1_starts'))
                return
            end

            % Calculate the new value
            app.matrix_lower_indentEditField.Value = app.matrix_lower_indentEditField.Value + 1;

            % Ensure the new value does not go below 0
            if app.matrix_lower_indentEditField.Value < 0
                app.matrix_lower_indentEditField.Value = 0;
            end

            settings.matrix_lower_indent = app.matrix_lower_indentEditField.Value;
            % Ensure the new value does not go below the minimum x limit
            set_automatic_matrix(app, settings)
            % Update the plot
            update_Interval_Module_GUI(app)
        end

        % Button pushed function: MatrixLowerLimitPlusTenButton
        function MatrixLowerLimitPlusTenButtonPushed(app, event)
            if ~confirm_overwrite_manual_intervals(app)
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            if not(isfield(app.base.project.session.spot, 'matrix_1_starts'))
                return
            end

            % Calculate the new value
            app.matrix_lower_indentEditField.Value = app.matrix_lower_indentEditField.Value + 10;

            % Ensure the new value does not go below 0
            if app.matrix_lower_indentEditField.Value < 0
                app.matrix_lower_indentEditField.Value = 0;
            end

            settings.matrix_lower_indent = app.matrix_lower_indentEditField.Value;
            % Ensure the new value does not go below the minimum x limit
            set_automatic_matrix(app, settings)
            % Update the plot
            update_Interval_Module_GUI(app)
        end

        % Button pushed function: MatrixUpperLimitMinusTenButton
        function MatrixUpperLimitMinusTenButtonPushed(app, event)
            if ~confirm_overwrite_manual_intervals(app)
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            if not(isfield(app.base.project.session.spot, 'matrix_1_ends'))
                return
            end

            % Calculate the new value
            app.matrix_upper_indentEditField.Value = app.matrix_upper_indentEditField.Value + 10;

            % Ensure the new value does not go below 0
            if app.matrix_upper_indentEditField.Value < 0
                app.matrix_upper_indentEditField.Value = 0;
            end

            settings.matrix_upper_indent = app.matrix_upper_indentEditField.Value;
            % Ensure the new value does not go below the minimum x limit
            set_automatic_matrix(app, settings)
            % Update the plot
            update_Interval_Module_GUI(app)
        end

        % Button pushed function: MatrixUpperLimitMinusOneButton
        function MatrixUpperLimitMinusOneButtonPushed(app, event)
            if ~confirm_overwrite_manual_intervals(app)
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            if not(isfield(app.base.project.session.spot, 'matrix_1_ends'))
                return
            end

            % Calculate the new value
            app.matrix_upper_indentEditField.Value = app.matrix_upper_indentEditField.Value + 1;

            % Ensure the new value does not go below 0
            if app.matrix_upper_indentEditField.Value < 0
                app.matrix_upper_indentEditField.Value = 0;
            end

            settings.matrix_upper_indent = app.matrix_upper_indentEditField.Value;
            % Ensure the new value does not go below the minimum x limit
            set_automatic_matrix(app, settings)
            % Update the plot
            update_Interval_Module_GUI(app)
        end

        % Button pushed function: MatrixUpperLimitPlusOneButton
        function MatrixUpperLimitPlusOneButtonPushed(app, event)
            if ~confirm_overwrite_manual_intervals(app)
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            if not(isfield(app.base.project.session.spot, 'matrix_1_ends'))
                return
            end

            % Calculate the new value
            app.matrix_upper_indentEditField.Value = app.matrix_upper_indentEditField.Value - 1;

            % Ensure the new value does not go below 0
            if app.matrix_upper_indentEditField.Value < 0
                app.matrix_upper_indentEditField.Value = 0;
            end

            settings.matrix_upper_indent = app.matrix_upper_indentEditField.Value;
            % Ensure the new value does not go below the minimum x limit
            set_automatic_matrix(app, settings)
            % Update the plot
            update_Interval_Module_GUI(app)
        end

        % Button pushed function: MatrixUpperLimitPlusTenButton
        function MatrixUpperLimitPlusTenButtonPushed(app, event)
            if ~confirm_overwrite_manual_intervals(app)
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            if not(isfield(app.base.project.session.spot, 'matrix_1_ends'))
                return
            end

            % Calculate the new value
            app.matrix_upper_indentEditField.Value = app.matrix_upper_indentEditField.Value - 10;

            % Ensure the new value does not go below 0
            if app.matrix_upper_indentEditField.Value < 0
                app.matrix_upper_indentEditField.Value = 0;
            end

            settings.matrix_upper_indent = app.matrix_upper_indentEditField.Value;
            % Ensure the new value does not go below the minimum x limit
            set_automatic_matrix(app, settings)
            % Update the plot
            update_Interval_Module_GUI(app)
        end

        % Button pushed function: DeleteMatrixButton
        function ErasematrixintervalsgloballyButtonPushed(app, event)
            if ~confirm_overwrite_manual_intervals(app)
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            app.base.project.session.spot.matrix_1_starts = NaN(size(app.base.project.session.spot.signal_starts));
            app.base.project.session.spot.matrix_1_ends   = NaN(size(app.base.project.session.spot.signal_ends));

            app.base.project.session.config.manual_intervals = false;

            update_Interval_Module_GUI(app)
        end

        % Value changed function: matrix_lower_indentEditField
        function matrix_lower_indentEditFieldValueChanged(app, event)
       if ~confirm_overwrite_manual_intervals(app)
                app.matrix_lower_indentEditField.Value = event.PreviousValue;
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                app.matrix_lower_indentEditField.Value = event.PreviousValue;
                return
            end
            app.editstatus = true;

            % Ensure the new value does not go below 0
            if app.matrix_lower_indentEditField.Value < 0
                app.matrix_lower_indentEditField.Value = 0;
            end

            settings.matrix_lower_indent = app.matrix_lower_indentEditField.Value;

            settings.interval_module_GUI_update_state = true;
            set_automatic_matrix(app, settings)
        end

        % Value changed function: matrix_upper_indentEditField
        function matrix_upper_indentEditFieldValueChanged(app, event)
      if ~confirm_overwrite_manual_intervals(app)
                app.matrix_upper_indentEditField.Value = event.PreviousValue;
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                app.matrix_upper_indentEditField.Value = event.PreviousValue;
                return
            end
            app.editstatus = true;

            % Ensure the new value does not go below 0
            if app.matrix_upper_indentEditField.Value < 0
                app.matrix_upper_indentEditField.Value = 0;
            end

            settings.matrix_upper_indent = app.matrix_upper_indentEditField.Value;

            settings.interval_module_GUI_update_state = true;
            set_automatic_matrix(app, settings)
        end

        % Button pushed function: ResetSpikeEliminationButton
        function ResetSpikeEliminationButtonPushed(app, event)

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end

            try
                % Check if spike information is available to perform a reset
                if ~isfield(app.base.project.session.spot, 'eliminated_spikes') || ...
                        isempty(app.base.project.session.spot.eliminated_spikes{app.selected_spot})
                    uialert(app.UIFigure, "No eliminated spikes found.", "Warning", "Icon", "warning");
                    return;
                end

                spikes_to_restore = app.base.project.session.spot.eliminated_spikes{app.selected_spot};

                if any(isnan(spikes_to_restore.SweepIndex))
                    uialert(app.UIFigure, ...
                        'These spikes were removed with an older version of ICP-Base. Version 1.3.0 and newer cannot reset them (Sorry).', ...
                        'Reset Not Possible', 'Icon', 'warning');
                    return;
                end

                if strcmp(app.base.project.session.config.datatype, 'Continuous')

                    for i = 1:height(spikes_to_restore)
                        spike = spikes_to_restore(i, :);

                        % Use SweepIndex to find the absolute row in signal_data
                        absolute_row = spike.SweepIndex;

                        % Restore the original value directly
                        app.base.project.session.spot.signal_data{absolute_row, spike.ColumnIndex + 1} = spike.OriginalValue;

                    end

                elseif strcmp(app.base.project.session.config.datatype, 'Single')
                    for i = 1:height(spikes_to_restore)
                        spike = spikes_to_restore(i, :);

                        % For Single datatype, SweepIndex equals the row index
                        app.base.project.session.spot.signal_data{app.selected_spot}{spike.SweepIndex, spike.ColumnIndex + 1} = spike.OriginalValue;

                    end
                end

                % Clear the stored spike information for the current spot after resetting
                app.base.project.session.spot.eliminated_spikes{app.selected_spot} = [];
                update_Interval_Module_GUI(app);

            catch ME
                DisplayError(ME, 'Reset Spike elimination');
                uialert(app.UIFigure, "Reset spike elimination failed.", "Warning", "Icon", "warning");
                return;
            end

        end

        % Value changed function: UnmixingviaDropDown
        function UnmixingviaDropDownValueChanged(app, event)
            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            app.base.project.session.spot.unmixing_via(app.selected_spot) = string(app.UnmixingviaDropDown.Value);

            update_Interval_Module_GUI(app)
            update_inclusion_unmixing(app)

        end

        % Callback function
        function ShowBaselineCheckBoxValueChanged(app, event)

            update_Interval_Module_GUI(app)
        end

        % Menu selected function: RefreshMenu
        function RefreshMenuSelected(app, event)

            get_plotstyles(app)
            app.selected_plotstyle = [];

            update_Interval_Module_GUI(app)
        end

        % Value changed function: GlobalIntervalSettingCheckBox
        function GlobalIntervalSettingCheckBoxValueChanged(app, event)
            update_interval_panels(app)
        end

        % Value changed function: LocalIntervalSettingCheckBox
        function LocalIntervalSettingCheckBoxValueChanged(app, event)
            update_interval_panels(app)
        end

        % Menu selected function: ApplygloballyMenu
        function ApplygloballyMenuSelected(app, event)


            changes = check_changes(app, 'interval');
            if changes == false
                return
            end

            progress = uiprogressdlg(app.UIFigure, 'Title', 'Applying Spike Elimination...', ...
                'Message', 'Processing all spots.', 'Cancelable', 'off');

            try
                % Ensure the storage for eliminated spikes exists
                if ~isfield(app.base.project.session.spot, 'eliminated_spikes')
                    app.base.project.session.spot.eliminated_spikes = cell(size(app.base.project.session.spot.name));
                end

                num_spots = length(app.base.project.session.spot.name);
                for i = 1:num_spots
                    progress.Value = i / num_spots;
                    progress.Message = sprintf('Processing spot %d of %d', i, num_spots);

                    corrected_data = [];
                    spikes = [];

                    if isequal(app.base.project.session.config.reductiontype, 'Matrix')
                        % Apply to all data without considering inclusions
                        if strcmp(app.base.project.session.config.datatype, 'Continuous')
                            signal_end = app.base.project.session.spot.signal_ends(i);
                            if i == 1
                                avg_spot_length = mean(nonzeros(diff(app.base.project.session.spot.signal_ends)));
                                first_spot_start = max(1, round(signal_end - avg_spot_length));
                                data_indices = first_spot_start:signal_end;
                            else
                                previous_signal_end = app.base.project.session.spot.signal_ends(i - 1);

                                if signal_end == previous_signal_end
                                    % Find the most recent DIFFERENT signal_end before this one
                                    valid_previous_end = [];
                                    for j = (i-1):-1:1
                                        if app.base.project.session.spot.signal_ends(j) < signal_end
                                            valid_previous_end = app.base.project.session.spot.signal_ends(j);
                                            break;
                                        end
                                    end

                                    % If found a valid previous end, use it; otherwise use average method
                                    if ~isempty(valid_previous_end)
                                        data_indices = (valid_previous_end + 1):signal_end;
                                    else
                                        % All previous spots have same signal_end (rare case at start)
                                        avg_spot_length = mean(nonzeros(diff(app.base.project.session.spot.signal_ends)));
                                        spot_start = max(1, round(signal_end - avg_spot_length));
                                        data_indices = spot_start:signal_end;
                                    end

                                else
                                    data_indices = (previous_signal_end + 1):signal_end;
                                end
                            end
                            data_to_process = table2array(app.base.project.session.spot.signal_data(data_indices, 2:end));
                            [corrected_data, spikes] = spike_elimination(app, data_to_process, data_indices(1));
                            app.base.project.session.spot.signal_data(data_indices, 2:end) = array2table(corrected_data);
                        else % 'Single'
                            data_to_process = table2array(app.base.project.session.spot.signal_data{i}(:, 2:end));
                            [corrected_data, spikes] = spike_elimination(app, data_to_process, 1);
                            app.base.project.session.spot.signal_data{i}(:, 2:end) = array2table(corrected_data);
                        end
                        app.base.project.session.spot.eliminated_spikes{i} = [app.base.project.session.spot.eliminated_spikes{i}; spikes];

                    elseif isequal(app.base.project.session.config.reductiontype, 'Inclusion')
                        % Apply spike elimination only outside the inclusion interval for each spot
                        inc_start = app.base.project.session.spot.inclusion_1_starts(i);
                        inc_end   = app.base.project.session.spot.inclusion_1_ends(i);
                        has_inclusion = ~isnan(inc_start) && ~isnan(inc_end);

                        if strcmp(app.base.project.session.config.datatype, 'Continuous')
                            signal_end = app.base.project.session.spot.signal_ends(i);
                            if i == 1

                                avg_spot_length = mean(nonzeros(diff(app.base.project.session.spot.signal_ends)));
                                first_spot_start = max(1, round(signal_end - avg_spot_length));
                                data_indices = first_spot_start:signal_end;

                            else

                                previous_signal_end = app.base.project.session.spot.signal_ends(i - 1);

                                if signal_end == previous_signal_end
                                    % Find the most recent DIFFERENT signal_end before this one
                                    valid_previous_end = [];
                                    for j = (i-1):-1:1
                                        if app.base.project.session.spot.signal_ends(j) < signal_end
                                            valid_previous_end = app.base.project.session.spot.signal_ends(j);
                                            break;
                                        end
                                    end

                                    % If found a valid previous end, use it; otherwise use average method
                                    if ~isempty(valid_previous_end)
                                        data_indices = (valid_previous_end + 1):signal_end;
                                    else
                                        % All previous spots have same signal_end (rare case at start)
                                        avg_spot_length = mean(nonzeros(diff(app.base.project.session.spot.signal_ends)));
                                        spot_start = max(1, round(signal_end - avg_spot_length));
                                        data_indices = spot_start:signal_end;
                                    end

                                else
                                    data_indices = (previous_signal_end + 1):signal_end;
                                end
                            end
                            data_to_process = table2array(app.base.project.session.spot.signal_data(data_indices, 2:end));

                            if has_inclusion
                                start_offset = data_indices(1) - 1;
                                relative_inc_start = inc_start - start_offset;
                                relative_inc_end = inc_end - start_offset;

                                before_inc = data_to_process(1:relative_inc_start-1, :);
                                in_inc = data_to_process(relative_inc_start:relative_inc_end, :);
                                after_inc = data_to_process(relative_inc_end+1:end, :);

                                [before_inc, spikes_before] = spike_elimination(app, before_inc, data_indices(1));
                                [after_inc, spikes_after] = spike_elimination(app, after_inc, data_indices(1) + relative_inc_end);

                                corrected_data = [before_inc; in_inc; after_inc];
                                spikes = [spikes_before; spikes_after];
                            else

                                [corrected_data, spikes] = spike_elimination(app, data_to_process, data_indices(1));

                            end
                            app.base.project.session.spot.signal_data(data_indices, 2:end) = array2table(corrected_data);

                        else % 'Single'
                            data_to_process = table2array(app.base.project.session.spot.signal_data{i}(:, 2:end));
                            if has_inclusion
                                before_inc = data_to_process(1:inc_start-1, :);
                                in_inc = data_to_process(inc_start:inc_end, :);
                                after_inc = data_to_process(inc_end+1:end, :);

                                [before_inc, spikes_before] = spike_elimination(app, before_inc, 1);
                                [after_inc, spikes_after] = spike_elimination(app, after_inc, inc_end + 1);

                                corrected_data = [before_inc; in_inc; after_inc];
                                spikes = [spikes_before; spikes_after];
                            else
                                [corrected_data, spikes] = spike_elimination(app, data_to_process, 1);
                            end
                            app.base.project.session.spot.signal_data{i}(:, 2:end) = array2table(corrected_data);
                        end
                        app.base.project.session.spot.eliminated_spikes{i} = [app.base.project.session.spot.eliminated_spikes{i}; spikes];
                    end
                end

            catch ME
                delete(progress);
                DisplayError(ME, 'Global Spike Elimination');
                uialert(app.UIFigure, "Global spike elimination failed.", "Error", "Icon", "error");
                return;
            end

            delete(progress);
            update_Interval_Module_GUI(app);



        end

        % Menu selected function: ApplygloballyMenu_2
        function ApplygloballyMenu_2Selected(app, event)

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end

            progress = uiprogressdlg(app.UIFigure, 'Title', 'Resetting Spike Elimination...', ...
                'Message', 'Processing all spots.', 'Cancelable', 'off');

            try
                if ~isfield(app.base.project.session.spot, 'eliminated_spikes')
                    delete(progress);
                    uialert(app.UIFigure, "No spike elimination data found to reset. ..." + ...
                        "If you used the rolling average feature, reset the spike elimination for the first rolling average spot (-1) and it will reset for all of them.", "Info", "Icon", "info");
                    return;
                end

                num_spots = length(app.base.project.session.spot.name);
                for i = 1:num_spots
                    progress.Value = i / num_spots;
                    progress.Message = sprintf('Processing spot %d of %d', i, num_spots);

                    spikes_to_restore = app.base.project.session.spot.eliminated_spikes{i};
                    if isempty(spikes_to_restore)
                        continue; % Skip if no spikes were eliminated for this spot
                    end

                    if any(isnan(spikes_to_restore.SweepIndex))
                        delete(progress);
                        uialert(app.UIFigure, ...
                            'One or more spots contain spikes removed with an older version of ICP-Base. Version 1.3.0 and newer cannot reset them.', ...
                            'Reset Not Possible', 'Icon', 'warning');
                        return;
                    end

                    if strcmp(app.base.project.session.config.datatype, 'Continuous')
                        for j = 1:height(spikes_to_restore)
                            spike = spikes_to_restore(j, :);

                            % Use SweepIndex to find the absolute row in signal_data
                            absolute_row = spike.SweepIndex;

                            % Restore the original value directly
                            app.base.project.session.spot.signal_data{absolute_row, spike.ColumnIndex + 1} = spike.OriginalValue;
                        end

                    elseif strcmp(app.base.project.session.config.datatype, 'Single')
                        for j = 1:height(spikes_to_restore)
                            spike = spikes_to_restore(j, :);

                            % For Single datatype, SweepIndex equals the row index
                            app.base.project.session.spot.signal_data{i}{spike.SweepIndex, spike.ColumnIndex + 1} = spike.OriginalValue;
                        end
                    end

                    % Clear the restored spike information
                    app.base.project.session.spot.eliminated_spikes{i} = [];
                end
            catch ME
                delete(progress);
                DisplayError(ME, 'Global Spike Elimination Reset');
                uialert(app.UIFigure, "Global reset of spike elimination failed.", "Error", "Icon", "error");
                return;
            end

            delete(progress);
            update_Interval_Module_GUI(app);

        end

        % Value changed function: HostfromspotDropDown
        function HostfromspotDropDownValueChanged(app, event)
            host_spot_idx = app.HostfromspotDropDown.Value;

            % a host spot without matrix intervals cannot be used for the unmixing
            if host_spot_idx ~= app.selected_spot && ...
                    isnan(app.base.project.session.spot.matrix_1_starts(host_spot_idx)) && ...
                    isnan(app.base.project.session.spot.matrix_2_starts(host_spot_idx)) && ...
                    isnan(app.base.project.session.spot.matrix_3_starts(host_spot_idx))
                uialert(app.UIFigure, "Selected spot has no matrix intervals", "Warning", "Icon", "warning");
                app.HostfromspotDropDown.Value = event.PreviousValue;
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            app.base.project.session.spot.matrix_from_spot(app.selected_spot) = app.base.project.session.spot.name(host_spot_idx);

            update_Interval_Module_GUI(app)
        end

        % Callback function
        function ShowProjectionCheckBoxValueChanged(app, event)
            update_Interval_Module_GUI(app)

        end

        % Callback function
        function ProjectedfromDropDownValueChanged(app, event)


        end

        % Callback function
        function ShowAreasCheckBoxValueChanged(app, event)
            update_Interval_Module_GUI(app)

        end

        % Button pushed function: ClassificationButton, DriftButton, 
        % ImportButton, QuantificationButton, ResultsButton
        function ImportButtonPushed(app, event)
            try
                target = event.Source.Parent.Parent.Parent.Parent.CallbackObject.Text;

                % going back to Import must always be possible, e.g. to fix the detection that caused the bad intervals
                if ~strcmp(target, 'Import')

                    background_empty = find(isnan(app.base.project.session.spot.background_starts));
                    all_matrix_indices = [];
                    all_background_only_indices = [];

                    if isequal(app.base.project.session.config.reductiontype, 'Inclusion')
                        fields_to_check = {'matrix_1_starts', 'matrix_2_starts', 'matrix_3_starts', 'inclusion_1_starts'};
                    else
                        fields_to_check = {'matrix_1_starts', 'matrix_2_starts', 'matrix_3_starts'};
                    end

                    for field = 1:length(fields_to_check)
                        matrix_empty = find(isnan(app.base.project.session.spot.(fields_to_check{field})));
                        matrix_indices = setdiff(background_empty, matrix_empty);
                        all_matrix_indices = unique([all_matrix_indices; matrix_indices]);
                    end

                    for i = 1:length(app.base.project.session.spot.background_starts)
                        if ~isnan(app.base.project.session.spot.background_starts(i))
                            all_empty = true;
                            for field = 1:length(fields_to_check)
                                if ~isnan(app.base.project.session.spot.(fields_to_check{field})(i))
                                    all_empty = false;
                                    break;
                                end
                            end
                            if all_empty
                                all_background_only_indices = [all_background_only_indices; i];
                            end
                        end
                    end

                    if ~isempty(all_matrix_indices)
                        for idx = all_matrix_indices'
                            spotname = app.base.project.session.spot.name(idx);
                            message = sprintf("Missing Background Interval for Spot %d: %s", idx, spotname);
                            uialert(app.UIFigure, message, "Warning", "Icon", "warning");
                            return
                        end
                    end

                    if ~isempty(all_background_only_indices)
                        for idx = all_background_only_indices'
                            spotname = app.base.project.session.spot.name(idx);
                            message = sprintf("Missing Matrix or Inclusion Interval for Spot %d: %s", idx, spotname);
                            uialert(app.UIFigure, message, "Warning", "Icon", "warning");
                            return
                        end
                    end
                end

                if app.editstatus == true
                    fig = app.UIFigure;
                    msg = "Do you want to jump modules?";
                    title = "ICP-Base";
                    selection = uiconfirm(fig, msg, title, ...
                        "Options", ["Yes","Cancel"], ...
                        "DefaultOption", 1, "CancelOption", 2);
                else
                    selection = 'Yes';
                end

                switch selection
                    case 'Yes'
                        settings.ICP_Base_GUI_update_state = true;
                        [app.project_id, app.session_id] = save_to_base(app.sourceapp, app.project_id, app.base.project.session, app.session_id, app.base.project_name, settings);

                        switch target
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
                DisplayError(ME, 'Proceed to other module failed')
                uialert(app.UIFigure, "Proceeding to other module failed", "Warning", "Icon", "warning");
                return
            end
        end

        % Menu selected function: AdjustAxisFontsizeMenu
        function AdjustAxisFontsizeMenuSelected(app, event)
            fontsizevalue = inputdlg('Enter Fontsize:','Set Fontsize', 1,{'12'});
            figure(app.UIFigure);

            if ~isempty(fontsizevalue)
                fontsizevalue=unique(str2num(fontsizevalue{1})); %#ok<ST2NM>
            else
                return
            end

            if isnumeric(fontsizevalue) && not(isnan(fontsizevalue)) && not(isinf(fontsizevalue))

                app.SpotAxes.FontSize = fontsizevalue;

            end

        end

        % Menu selected function: IndividualInclusiononlyMenu, 
        % IndividualMenu
        function IndividualMenuSelected(app, event)

            if isequal(app.base.project.session.config.reductiontype, 'Inclusion')

                if isequal(event.Source.Text, 'Individual (Inclusion only)')

                    Spike_Submodule(app, true)

                elseif isequal(event.Source.Text, 'Individual')

                    Spike_Submodule(app, false)

                end

            elseif isequal(app.base.project.session.config.reductiontype, 'Matrix')

                if isequal(event.Source.Text, 'Individual (Inclusion only)')

                    message = "No inclusion intervals";
                    uialert(app.UIFigure,message,"Warning", ...
                        "Icon","warning");

                    return

                elseif isequal(event.Source.Text, 'Individual')

                    Spike_Submodule(app, false)

                end



            end

        end

        % Value changed function: MatrixonlytracerDropDown
        function MatrixonlytracerDropDownValueChanged(app, event)

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            app.base.project.session.spot.matrix_only_tracer(app.selected_spot) = app.base.project.session.spot.analytes(app.MatrixonlytracerDropDown.Value);

            update_Interval_Module_GUI(app)
        end

        % Value changed function: ShowhostcontributionCheckBox
        function ShowhostcontributionCheckBoxValueChanged(app, event)
            update_Interval_Module_GUI(app)

        end

        % Value changed function: FromSpotDropDown
        function FromSpotDropDownValueChanged(app, event)
           host_spot_idx = app.FromSpotDropDown.Value;

            % a host spot without matrix intervals cannot be used for the unmixing
            if host_spot_idx ~= app.selected_spot && ...
                    isnan(app.base.project.session.spot.matrix_1_starts(host_spot_idx)) && ...
                    isnan(app.base.project.session.spot.matrix_2_starts(host_spot_idx)) && ...
                    isnan(app.base.project.session.spot.matrix_3_starts(host_spot_idx))
                uialert(app.UIFigure, "Selected spot has no matrix intervals", "Warning", "Icon", "warning");
                app.FromSpotDropDown.Value = event.PreviousValue;
                return
            end

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            app.base.project.session.spot.matrix_from_spot(app.selected_spot) = app.base.project.session.spot.name(host_spot_idx);

            update_Interval_Module_GUI(app)
        end

        % Value changed function: DatatipsOnOffButton
        function DatatipsOnOffButtonValueChanged(app, event)

            %%% For Valentine %%%

            button = app.DatatipsOnOffButton;

            % stop a blinking that is already running and restore the colour
            if isstruct(button.UserData) && isfield(button.UserData, 'blink_timer')
                if isvalid(button.UserData.blink_timer)
                    stop(button.UserData.blink_timer)       % its StopFcn deletes the timer
                end
                delete(button.UserData.blink_listener)
                button.BackgroundColor = button.UserData.original_color;
                button.UserData = [];
            end

            if button.Value
                datacursormode(app.UIFigure, 'on');

                original_color = button.BackgroundColor;
                blink_colors   = [[0.38 0.76 0.50]; original_color];    % orange, standard grey

                blink_timer = timer('ExecutionMode', 'fixedSpacing', 'Period', 0.5, 'BusyMode', 'drop');
                blink_timer.TimerFcn = @(t, ~) set(button, 'BackgroundColor', blink_colors(mod(t.TasksExecuted, 2) + 1, :));
                blink_timer.StopFcn  = @(t, ~) delete(t);           % deleted only after it has stopped
                start(blink_timer)

                % when the module (and with it the button) is closed, the timer is stopped and deletes itself
                blink_listener = addlistener(button, 'ObjectBeingDestroyed', @(~, ~) stop(blink_timer));

                button.UserData = struct('blink_timer', blink_timer, ...
                    'blink_listener', blink_listener, 'original_color', original_color);
            else
                datacursormode(app.UIFigure, 'off');
            end

        end

        % Menu selected function: ChangeplotstylesfolderMenu
        function ChangeplotstylesfolderMenuSelected(app, event)

            % Open folder selection dialog
            selectedFolder = uigetdir('', 'Select Plotstyles Folder');

            % Check if user selected a folder (not cancelled)
            if selectedFolder == 0
                return
            end

            % Store the selected folder path (adjust property name as needed)
            app.plotstyle_path = selectedFolder;

            % Call your existing function
            get_plotstyles(app)

            update_Interval_Module_GUI(app)


        end

        % Menu selected function: GeneratespikereportMenu
        function GeneratespikereportMenuSelected(app, event)


            spike_tables = app.base.project.session.spot.eliminated_spikes;

            % Check if there are any eliminated spikes
            if ~iscell(spike_tables) || all(cellfun(@isempty, spike_tables))
                uialert(app.UIFigure, "No eliminated spikes found to report.", "Info", "Icon", "info");
                return;
            end

            % Let user select save location
            f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
            [filename, filepath] = uiputfile('*.xlsx', 'Save Spike Report', 'Spike_Report.xlsx');
            delete(f);
            figure(app.UIFigure);

            if isequal(filename, 0)
                return; % User cancelled
            end
            fullpath = fullfile(filepath, filename);

            try
                % Get analytes list
                analytes = app.base.project.session.spot.analytes;
                spot_names = app.base.project.session.spot.name;

                % Create a combined table for all spots
                all_spikes = table('Size', [0, 5], ...
                    'VariableTypes', {'string', 'single', 'string', 'single', 'single'}, ...
                    'VariableNames', {'SpotName', 'SweepIndex', 'Analyte', 'OriginalValue', 'ReplacementValue'});

                % Loop through each spot
                for i = 1:length(spike_tables)
                    if ~isempty(spike_tables{i})
                        spot_spikes = spike_tables{i};
                        num_spikes = height(spot_spikes);

                        % Convert column indices to analyte names
                        analyte_names = cell(num_spikes, 1);
                        for j = 1:num_spikes
                            col_idx = spot_spikes.ColumnIndex(j);
                            if col_idx <= length(analytes)
                                analyte_names{j} = analytes{col_idx};
                            else
                                analyte_names{j} = sprintf('Column_%d', col_idx);
                            end
                        end

                        % Create table for this spot
                        spot_table = table(...
                            repmat(spot_names(i), num_spikes, 1), ...
                            spot_spikes.SweepIndex, ...
                            analyte_names, ...
                            spot_spikes.OriginalValue, ...
                            spot_spikes.ReplacementValue, ...
                            'VariableNames', {'SpotName', 'SweepIndex', 'Analyte', 'OriginalValue', 'ReplacementValue'});

                        % Append to combined table
                        all_spikes = [all_spikes; spot_table]; %#ok<AGROW>
                    end
                end

                % Check if any spikes were found
                if isempty(all_spikes)
                    uialert(app.UIFigure, "No eliminated spikes found to report.", "Info", "Icon", "info");
                    return;
                end

                % Write to Excel
                writetable(all_spikes, fullpath, 'Sheet', 'Eliminated Spikes');

                % Create a summary sheet
                unique_spots = unique(all_spikes.SpotName);
                summary = table('Size', [length(unique_spots), 2], ...
                    'VariableTypes', {'string', 'double'}, ...
                    'VariableNames', {'SpotName', 'NumberOfSpikes'});

                for i = 1:length(unique_spots)
                    summary.SpotName(i) = unique_spots(i);
                    summary.NumberOfSpikes(i) = sum(strcmp(all_spikes.SpotName, unique_spots(i)));
                end

                writetable(summary, fullpath, 'Sheet', 'Summary');

                uialert(app.UIFigure, sprintf('Spike report saved successfully to:\n%s', fullpath), ...
                    "Success", "Icon", "success");

            catch ME
                DisplayError(ME, 'Generate Spike Report');
                uialert(app.UIFigure, "Failed to generate spike report.", "Error", "Icon", "error");
            end



        end

        % Menu selected function: SetspikethresholdMenu
        function SetspikethresholdMenuSelected(app, event)
            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;


            thresholdvalue = app.base.project.session.config.spike_threshold;

            thresholdvalue = inputdlg('Enter spike elimination threshold in cps:','Threshold:', 1, {num2str(thresholdvalue)});
            figure(app.UIFigure);

            if ~isempty(thresholdvalue)
                thresholdvalue=unique(str2num(thresholdvalue{1})); %#ok<ST2NM>
            else
                return
            end

            if isnumeric(thresholdvalue) && not(isnan(thresholdvalue)) && not(isinf(thresholdvalue))

                app.base.project.session.config.spike_threshold = thresholdvalue;

            end




        end

        % Menu selected function: SetforspotgroupsMenu
        function SetforspotgroupsMenuSelected(app, event)


            Spot_Group_Interval_Submodule(app)

        end

        % Menu selected function: ApplytoallMenu
        function ApplytoallMenuSelected(app, event)

            changes = check_changes(app, 'interval');
            if changes == false
                return
            end
            app.editstatus = true;

            spot    = app.base.project.session.spot;
            current = app.selected_spot;
            mode    = string(app.UnmixingviaDropDown.Value);

            spot.unmixing_via(:) = mode;

            if mode ~= "None"

                % host spot: itself stays itself for every spot, otherwise every spot takes the chosen spot
                if spot.matrix_from_spot(current) == spot.name(current)
                    spot.matrix_from_spot = spot.name;
                else
                    host_name = spot.matrix_from_spot(current);
                    host_idx  = find(spot.name == host_name, 1);
                    spot.matrix_from_spot(:) = host_name;
                    spot.matrix_from_spot(host_idx) = spot.name(host_idx);   % the host spot itself uses itself
                end

                if mode == "Matrix-only tracer"
                    spot.matrix_only_tracer(:) = spot.matrix_only_tracer(current);
                end

            end

            app.base.project.session.spot = spot;

            update_Interval_Module_GUI(app)

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1068 773];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.Icon = 'icon_48.png';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @ExitMenuSelected, true);
            app.UIFigure.WindowButtonUpFcn = createCallbackFcn(app, @UIFigureWindowButtonUp, true);
            app.UIFigure.WindowButtonMotionFcn = createCallbackFcn(app, @UIFigureWindowButtonMotion, true);

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

            % Create AdjustAxisFontsizeMenu
            app.AdjustAxisFontsizeMenu = uimenu(app.SettingsMenu);
            app.AdjustAxisFontsizeMenu.MenuSelectedFcn = createCallbackFcn(app, @AdjustAxisFontsizeMenuSelected, true);
            app.AdjustAxisFontsizeMenu.Text = 'Adjust Axis Fontsize';

            % Create ChangeplotstylesfolderMenu
            app.ChangeplotstylesfolderMenu = uimenu(app.SettingsMenu);
            app.ChangeplotstylesfolderMenu.MenuSelectedFcn = createCallbackFcn(app, @ChangeplotstylesfolderMenuSelected, true);
            app.ChangeplotstylesfolderMenu.Text = 'Change plotstyles folder';

            % Create HeatmapColormapMenu
            app.HeatmapColormapMenu = uimenu(app.SettingsMenu);
            app.HeatmapColormapMenu.Text = 'Heatmap Colormap';

            % Create SpikeEliminationMenu
            app.SpikeEliminationMenu = uimenu(app.UIFigure);
            app.SpikeEliminationMenu.Text = 'Spike Elimination';

            % Create GeneratespikereportMenu
            app.GeneratespikereportMenu = uimenu(app.SpikeEliminationMenu);
            app.GeneratespikereportMenu.MenuSelectedFcn = createCallbackFcn(app, @GeneratespikereportMenuSelected, true);
            app.GeneratespikereportMenu.Text = 'Generate spike report';

            % Create SetspikethresholdMenu
            app.SetspikethresholdMenu = uimenu(app.SpikeEliminationMenu);
            app.SetspikethresholdMenu.MenuSelectedFcn = createCallbackFcn(app, @SetspikethresholdMenuSelected, true);
            app.SetspikethresholdMenu.Text = 'Set spike threshold';

            % Create GridLayout3
            app.GridLayout3 = uigridlayout(app.UIFigure);
            app.GridLayout3.ColumnWidth = {41, 41, 22, 22, 102, 73, 64, 37, 77, 164, 71, 50, '100x', 96};
            app.GridLayout3.RowHeight = {35, 29, '9.8x', '4.35x', '1x', 41, '3.1x', 33, 56, 28, 30, 58, 49};
            app.GridLayout3.ColumnSpacing = 3.85714285714286;
            app.GridLayout3.RowSpacing = 3.5;
            app.GridLayout3.Padding = [3.85714285714286 3.5 3.85714285714286 3.5];

            % Create SpotAxes
            app.SpotAxes = uiaxes(app.GridLayout3);
            title(app.SpotAxes, 'Title')
            xlabel(app.SpotAxes, 'Sweeps')
            ylabel(app.SpotAxes, 'Intensity [cps]')
            zlabel(app.SpotAxes, 'Z')
            app.SpotAxes.Colormap = [];
            app.SpotAxes.FontSize = 12;
            app.SpotAxes.Box = 'on';
            app.SpotAxes.Layout.Row = [3 10];
            app.SpotAxes.Layout.Column = [6 13];
            app.SpotAxes.ButtonDownFcn = createCallbackFcn(app, @SpotAxesButtonDown, true);

            % Create ElementLegendListBox
            app.ElementLegendListBox = uilistbox(app.GridLayout3);
            app.ElementLegendListBox.Items = {''};
            app.ElementLegendListBox.Multiselect = 'on';
            app.ElementLegendListBox.ValueChangedFcn = createCallbackFcn(app, @ElementLegendListBoxValueChanged, true);
            app.ElementLegendListBox.Layout.Row = [4 10];
            app.ElementLegendListBox.Layout.Column = 14;
            app.ElementLegendListBox.Value = {''};

            % Create NextSignalButton
            app.NextSignalButton = uibutton(app.GridLayout3, 'push');
            app.NextSignalButton.ButtonPushedFcn = createCallbackFcn(app, @NextSignalButtonPushed, true);
            app.NextSignalButton.Layout.Row = 2;
            app.NextSignalButton.Layout.Column = [7 8];
            app.NextSignalButton.Text = 'Next';

            % Create SpotListBox
            app.SpotListBox = uilistbox(app.GridLayout3);
            app.SpotListBox.Items = {''};
            app.SpotListBox.ValueChangedFcn = createCallbackFcn(app, @SpotListBoxValueChanged, true);
            app.SpotListBox.Layout.Row = [2 5];
            app.SpotListBox.Layout.Column = [1 5];
            app.SpotListBox.Value = '';

            % Create PreviousSignalButton
            app.PreviousSignalButton = uibutton(app.GridLayout3, 'push');
            app.PreviousSignalButton.ButtonPushedFcn = createCallbackFcn(app, @PreviousSignalButtonPushed, true);
            app.PreviousSignalButton.Layout.Row = 2;
            app.PreviousSignalButton.Layout.Column = 6;
            app.PreviousSignalButton.Text = 'Previous';

            % Create PlotstylesListBox
            app.PlotstylesListBox = uilistbox(app.GridLayout3);
            app.PlotstylesListBox.Items = {''};
            app.PlotstylesListBox.ValueChangedFcn = createCallbackFcn(app, @PlotstylesListBoxValueChanged, true);
            app.PlotstylesListBox.Layout.Row = 3;
            app.PlotstylesListBox.Layout.Column = 14;
            app.PlotstylesListBox.Value = '';

            % Create PlotBackgroundcorrectedCheckBox
            app.PlotBackgroundcorrectedCheckBox = uicheckbox(app.GridLayout3);
            app.PlotBackgroundcorrectedCheckBox.ValueChangedFcn = createCallbackFcn(app, @PlotBackgroundcorrectedCheckBoxValueChanged, true);
            app.PlotBackgroundcorrectedCheckBox.Text = 'Plot Background-corrected';
            app.PlotBackgroundcorrectedCheckBox.Layout.Row = 2;
            app.PlotBackgroundcorrectedCheckBox.Layout.Column = 10;

            % Create ZoomintoSignalCheckBox
            app.ZoomintoSignalCheckBox = uicheckbox(app.GridLayout3);
            app.ZoomintoSignalCheckBox.ValueChangedFcn = createCallbackFcn(app, @ZoomintoSignalCheckBoxValueChanged, true);
            app.ZoomintoSignalCheckBox.Text = 'Zoom in to Signal';
            app.ZoomintoSignalCheckBox.Layout.Row = 2;
            app.ZoomintoSignalCheckBox.Layout.Column = [11 12];

            % Create EliminateSpikesButton
            app.EliminateSpikesButton = uibutton(app.GridLayout3, 'push');
            app.EliminateSpikesButton.ButtonPushedFcn = createCallbackFcn(app, @EliminateSpikesButtonPushed, true);
            app.EliminateSpikesButton.WordWrap = 'on';
            app.EliminateSpikesButton.Layout.Row = 6;
            app.EliminateSpikesButton.Layout.Column = [1 3];
            app.EliminateSpikesButton.Text = 'Eliminate Spikes';

            % Create LogscaleCheckBox
            app.LogscaleCheckBox = uicheckbox(app.GridLayout3);
            app.LogscaleCheckBox.ValueChangedFcn = createCallbackFcn(app, @LogscaleCheckBoxValueChanged, true);
            app.LogscaleCheckBox.Text = 'Log-scale';
            app.LogscaleCheckBox.Layout.Row = 2;
            app.LogscaleCheckBox.Layout.Column = 9;
            app.LogscaleCheckBox.Value = true;

            % Create ProceedtoClassificationModuleButton
            app.ProceedtoClassificationModuleButton = uibutton(app.GridLayout3, 'push');
            app.ProceedtoClassificationModuleButton.ButtonPushedFcn = createCallbackFcn(app, @ProceedtoClassificationModuleButtonPushed, true);
            app.ProceedtoClassificationModuleButton.WordWrap = 'on';
            app.ProceedtoClassificationModuleButton.Layout.Row = 13;
            app.ProceedtoClassificationModuleButton.Layout.Column = 14;
            app.ProceedtoClassificationModuleButton.Text = 'Proceed to Classification Module';

            % Create ShowLegendCheckBox
            app.ShowLegendCheckBox = uicheckbox(app.GridLayout3);
            app.ShowLegendCheckBox.ValueChangedFcn = createCallbackFcn(app, @ShowLegendCheckBoxValueChanged, true);
            app.ShowLegendCheckBox.Text = 'Show Legend';
            app.ShowLegendCheckBox.Layout.Row = 2;
            app.ShowLegendCheckBox.Layout.Column = 14;

            % Create CommentTextArea
            app.CommentTextArea = uitextarea(app.GridLayout3);
            app.CommentTextArea.ValueChangedFcn = createCallbackFcn(app, @CommentTextAreaValueChanged, true);
            app.CommentTextArea.Placeholder = 'Comment';
            app.CommentTextArea.Layout.Row = 7;
            app.CommentTextArea.Layout.Column = [1 5];

            % Create LocalIntervalPanel
            app.LocalIntervalPanel = uipanel(app.GridLayout3);
            app.LocalIntervalPanel.BorderType = 'none';
            app.LocalIntervalPanel.Visible = 'off';
            app.LocalIntervalPanel.Layout.Row = [11 13];
            app.LocalIntervalPanel.Layout.Column = [7 13];

            % Create GridLayout
            app.GridLayout = uigridlayout(app.LocalIntervalPanel);
            app.GridLayout.ColumnWidth = {40, 81, 40, 60, 36, 66, 30, 97, 27, 100, '1x', '1x'};
            app.GridLayout.RowHeight = {23, 23, 22, 25, 31};
            app.GridLayout.ColumnSpacing = 2.25;
            app.GridLayout.RowSpacing = 2.83333333333333;
            app.GridLayout.Padding = [2.25 2.83333333333333 2.25 2.83333333333333];

            % Create SetBackgroundButton
            app.SetBackgroundButton = uibutton(app.GridLayout, 'push');
            app.SetBackgroundButton.ButtonPushedFcn = createCallbackFcn(app, @SetBackgroundButtonPushed, true);
            app.SetBackgroundButton.Tooltip = {'Press d button on the keyboard to activate'};
            app.SetBackgroundButton.Layout.Row = 1;
            app.SetBackgroundButton.Layout.Column = [1 2];
            app.SetBackgroundButton.Text = 'Set Background';

            % Create Set1MatrixButton
            app.Set1MatrixButton = uibutton(app.GridLayout, 'push');
            app.Set1MatrixButton.ButtonPushedFcn = createCallbackFcn(app, @Set1MatrixButtonPushed, true);
            app.Set1MatrixButton.Tooltip = {'Press f button on the keyboard to activate'};
            app.Set1MatrixButton.Layout.Row = 1;
            app.Set1MatrixButton.Layout.Column = [4 5];
            app.Set1MatrixButton.Text = 'Set 1. Matrix';

            % Create DeleteBackgroundButton
            app.DeleteBackgroundButton = uibutton(app.GridLayout, 'push');
            app.DeleteBackgroundButton.ButtonPushedFcn = createCallbackFcn(app, @DeleteBackgroundButtonPushed, true);
            app.DeleteBackgroundButton.Layout.Row = 2;
            app.DeleteBackgroundButton.Layout.Column = [1 2];
            app.DeleteBackgroundButton.Text = 'Delete Background';

            % Create Delete1MatrixButton
            app.Delete1MatrixButton = uibutton(app.GridLayout, 'push');
            app.Delete1MatrixButton.ButtonPushedFcn = createCallbackFcn(app, @Delete1MatrixButtonPushed, true);
            app.Delete1MatrixButton.Layout.Row = 2;
            app.Delete1MatrixButton.Layout.Column = [4 5];
            app.Delete1MatrixButton.Text = 'Delete 1. Matrix';

            % Create SetInclusionButton
            app.SetInclusionButton = uibutton(app.GridLayout, 'push');
            app.SetInclusionButton.ButtonPushedFcn = createCallbackFcn(app, @SetInclusionButtonPushed, true);
            app.SetInclusionButton.Tooltip = {'Press f button on the keyboard to activate'};
            app.SetInclusionButton.Layout.Row = 1;
            app.SetInclusionButton.Layout.Column = 10;
            app.SetInclusionButton.Text = 'Set Inclusion';

            % Create DeleteInclusionButton
            app.DeleteInclusionButton = uibutton(app.GridLayout, 'push');
            app.DeleteInclusionButton.ButtonPushedFcn = createCallbackFcn(app, @DeleteInclusionButtonPushed, true);
            app.DeleteInclusionButton.Layout.Row = 2;
            app.DeleteInclusionButton.Layout.Column = 10;
            app.DeleteInclusionButton.Text = 'Delete Inclusion';

            % Create Set2MatrixButton
            app.Set2MatrixButton = uibutton(app.GridLayout, 'push');
            app.Set2MatrixButton.ButtonPushedFcn = createCallbackFcn(app, @Set2MatrixButtonPushed, true);
            app.Set2MatrixButton.Tooltip = {'Press f button on the keyboard to activate'};
            app.Set2MatrixButton.Layout.Row = 1;
            app.Set2MatrixButton.Layout.Column = [6 7];
            app.Set2MatrixButton.Text = 'Set 2. Matrix';

            % Create Delete2MatrixButton
            app.Delete2MatrixButton = uibutton(app.GridLayout, 'push');
            app.Delete2MatrixButton.ButtonPushedFcn = createCallbackFcn(app, @Delete2MatrixButtonPushed, true);
            app.Delete2MatrixButton.Layout.Row = 2;
            app.Delete2MatrixButton.Layout.Column = [6 7];
            app.Delete2MatrixButton.Text = 'Delete 2. Matrix';

            % Create Set3MatrixButton
            app.Set3MatrixButton = uibutton(app.GridLayout, 'push');
            app.Set3MatrixButton.ButtonPushedFcn = createCallbackFcn(app, @Set3MatrixButtonPushed, true);
            app.Set3MatrixButton.Tooltip = {'Press f button on the keyboard to activate'};
            app.Set3MatrixButton.Layout.Row = 1;
            app.Set3MatrixButton.Layout.Column = 8;
            app.Set3MatrixButton.Text = 'Set 3. Matrix';

            % Create Delete3MatrixButton
            app.Delete3MatrixButton = uibutton(app.GridLayout, 'push');
            app.Delete3MatrixButton.ButtonPushedFcn = createCallbackFcn(app, @Delete3MatrixButtonPushed, true);
            app.Delete3MatrixButton.Layout.Row = 2;
            app.Delete3MatrixButton.Layout.Column = 8;
            app.Delete3MatrixButton.Text = 'Delete 3. Matrix';

            % Create UnmixingviaDropDown
            app.UnmixingviaDropDown = uidropdown(app.GridLayout);
            app.UnmixingviaDropDown.Items = {'None', 'Matrix-only tracer', 'Two internal standards', 'Mixing ratio'};
            app.UnmixingviaDropDown.ValueChangedFcn = createCallbackFcn(app, @UnmixingviaDropDownValueChanged, true);
            app.UnmixingviaDropDown.Tooltip = {'Right-click to apply current settings for all spots'};
            app.UnmixingviaDropDown.Layout.Row = 5;
            app.UnmixingviaDropDown.Layout.Column = [1 3];
            app.UnmixingviaDropDown.Value = 'None';

            % Create UnmixingviaLabel
            app.UnmixingviaLabel = uilabel(app.GridLayout);
            app.UnmixingviaLabel.Layout.Row = 4;
            app.UnmixingviaLabel.Layout.Column = 2;
            app.UnmixingviaLabel.Text = 'Unmixing via';

            % Create MOTPanel
            app.MOTPanel = uipanel(app.GridLayout);
            app.MOTPanel.Visible = 'off';
            app.MOTPanel.Layout.Row = [3 5];
            app.MOTPanel.Layout.Column = [4 9];

            % Create FromSpotDropDownLabel
            app.FromSpotDropDownLabel = uilabel(app.MOTPanel);
            app.FromSpotDropDownLabel.HorizontalAlignment = 'right';
            app.FromSpotDropDownLabel.Position = [12 22 61 22];
            app.FromSpotDropDownLabel.Text = 'From Spot:';

            % Create FromSpotDropDown
            app.FromSpotDropDown = uidropdown(app.MOTPanel);
            app.FromSpotDropDown.Items = {};
            app.FromSpotDropDown.ValueChangedFcn = createCallbackFcn(app, @FromSpotDropDownValueChanged, true);
            app.FromSpotDropDown.Position = [79 20 225 26];
            app.FromSpotDropDown.Value = {};

            % Create ShowhostcontributionCheckBox
            app.ShowhostcontributionCheckBox = uicheckbox(app.MOTPanel);
            app.ShowhostcontributionCheckBox.ValueChangedFcn = createCallbackFcn(app, @ShowhostcontributionCheckBoxValueChanged, true);
            app.ShowhostcontributionCheckBox.Text = 'Show host contribution';
            app.ShowhostcontributionCheckBox.Position = [24 -3 196 22];
            app.ShowhostcontributionCheckBox.Value = true;

            % Create MatrixonlytracerDropDownLabel
            app.MatrixonlytracerDropDownLabel = uilabel(app.MOTPanel);
            app.MatrixonlytracerDropDownLabel.HorizontalAlignment = 'right';
            app.MatrixonlytracerDropDownLabel.Position = [8 53 102 22];
            app.MatrixonlytracerDropDownLabel.Text = 'Matrix-only-tracer:';

            % Create MatrixonlytracerDropDown
            app.MatrixonlytracerDropDown = uidropdown(app.MOTPanel);
            app.MatrixonlytracerDropDown.Items = {};
            app.MatrixonlytracerDropDown.ValueChangedFcn = createCallbackFcn(app, @MatrixonlytracerDropDownValueChanged, true);
            app.MatrixonlytracerDropDown.Position = [117 51 95 26];
            app.MatrixonlytracerDropDown.Value = {};

            % Create TwoISPanel
            app.TwoISPanel = uipanel(app.GridLayout);
            app.TwoISPanel.Visible = 'off';
            app.TwoISPanel.Layout.Row = [3 5];
            app.TwoISPanel.Layout.Column = [4 9];

            % Create HostonlytracerLabel
            app.HostonlytracerLabel = uilabel(app.TwoISPanel);
            app.HostonlytracerLabel.HorizontalAlignment = 'right';
            app.HostonlytracerLabel.Position = [15 51 93 22];
            app.HostonlytracerLabel.Text = 'Host from spot:';

            % Create HostfromspotDropDown
            app.HostfromspotDropDown = uidropdown(app.TwoISPanel);
            app.HostfromspotDropDown.Items = {};
            app.HostfromspotDropDown.ValueChangedFcn = createCallbackFcn(app, @HostfromspotDropDownValueChanged, true);
            app.HostfromspotDropDown.Position = [113 50 197 23];
            app.HostfromspotDropDown.Value = {};

            % Create ResetSpikeEliminationButton
            app.ResetSpikeEliminationButton = uibutton(app.GridLayout3, 'push');
            app.ResetSpikeEliminationButton.ButtonPushedFcn = createCallbackFcn(app, @ResetSpikeEliminationButtonPushed, true);
            app.ResetSpikeEliminationButton.WordWrap = 'on';
            app.ResetSpikeEliminationButton.Layout.Row = 6;
            app.ResetSpikeEliminationButton.Layout.Column = [4 5];
            app.ResetSpikeEliminationButton.Text = 'Reset Spike Elimination';

            % Create ShowIntervalsCheckBox
            app.ShowIntervalsCheckBox = uicheckbox(app.GridLayout3);
            app.ShowIntervalsCheckBox.ValueChangedFcn = createCallbackFcn(app, @ShowIntervalsCheckBoxValueChanged, true);
            app.ShowIntervalsCheckBox.Text = 'Show Intervals';
            app.ShowIntervalsCheckBox.Layout.Row = 2;
            app.ShowIntervalsCheckBox.Layout.Column = 13;
            app.ShowIntervalsCheckBox.Value = true;

            % Create GlobalIntervalSettingCheckBox
            app.GlobalIntervalSettingCheckBox = uicheckbox(app.GridLayout3);
            app.GlobalIntervalSettingCheckBox.ValueChangedFcn = createCallbackFcn(app, @GlobalIntervalSettingCheckBoxValueChanged, true);
            app.GlobalIntervalSettingCheckBox.Text = 'Global Interval Setting';
            app.GlobalIntervalSettingCheckBox.FontWeight = 'bold';
            app.GlobalIntervalSettingCheckBox.Layout.Row = 8;
            app.GlobalIntervalSettingCheckBox.Layout.Column = [2 5];

            % Create GlobalIntervalPanel
            app.GlobalIntervalPanel = uipanel(app.GridLayout3);
            app.GlobalIntervalPanel.BorderType = 'none';
            app.GlobalIntervalPanel.Visible = 'off';
            app.GlobalIntervalPanel.Layout.Row = [9 13];
            app.GlobalIntervalPanel.Layout.Column = [1 5];

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.GlobalIntervalPanel);
            app.GridLayout2.ColumnWidth = {54, 26, 26, 26, 26, 28};
            app.GridLayout2.RowHeight = {26, 22, 22, 23, 25, 22, 22, 23};
            app.GridLayout2.ColumnSpacing = 6.29997907366071;
            app.GridLayout2.RowSpacing = 3.60000949435764;
            app.GridLayout2.Padding = [6.29997907366071 3.60000949435764 6.29997907366071 3.60000949435764];

            % Create SetBackgroundsButton
            app.SetBackgroundsButton = uibutton(app.GridLayout2, 'push');
            app.SetBackgroundsButton.ButtonPushedFcn = createCallbackFcn(app, @SetBackgroundsButtonPushed, true);
            app.SetBackgroundsButton.WordWrap = 'on';
            app.SetBackgroundsButton.FontWeight = 'bold';
            app.SetBackgroundsButton.Layout.Row = 1;
            app.SetBackgroundsButton.Layout.Column = [2 6];
            app.SetBackgroundsButton.Text = 'Set Backgrounds';

            % Create BgLowerLimitMinusOneButton
            app.BgLowerLimitMinusOneButton = uibutton(app.GridLayout2, 'push');
            app.BgLowerLimitMinusOneButton.ButtonPushedFcn = createCallbackFcn(app, @BgLowerLimitMinusOneButtonPushed, true);
            app.BgLowerLimitMinusOneButton.Layout.Row = 2;
            app.BgLowerLimitMinusOneButton.Layout.Column = 3;
            app.BgLowerLimitMinusOneButton.Text = '-1';

            % Create BgLowerLimitPlusOneButton
            app.BgLowerLimitPlusOneButton = uibutton(app.GridLayout2, 'push');
            app.BgLowerLimitPlusOneButton.ButtonPushedFcn = createCallbackFcn(app, @BgLowerLimitPlusOneButtonPushed, true);
            app.BgLowerLimitPlusOneButton.Layout.Row = 2;
            app.BgLowerLimitPlusOneButton.Layout.Column = 5;
            app.BgLowerLimitPlusOneButton.Text = '+1';

            % Create BgLowerLimitMinusTenButton
            app.BgLowerLimitMinusTenButton = uibutton(app.GridLayout2, 'push');
            app.BgLowerLimitMinusTenButton.ButtonPushedFcn = createCallbackFcn(app, @BgLowerLimitMinusTenButtonPushed, true);
            app.BgLowerLimitMinusTenButton.Layout.Row = 2;
            app.BgLowerLimitMinusTenButton.Layout.Column = 2;
            app.BgLowerLimitMinusTenButton.Text = '-10';

            % Create BgLowerLimitPlusTenButton
            app.BgLowerLimitPlusTenButton = uibutton(app.GridLayout2, 'push');
            app.BgLowerLimitPlusTenButton.ButtonPushedFcn = createCallbackFcn(app, @BgLowerLimitPlusTenButtonPushed, true);
            app.BgLowerLimitPlusTenButton.Layout.Row = 2;
            app.BgLowerLimitPlusTenButton.Layout.Column = 6;
            app.BgLowerLimitPlusTenButton.Text = '+10';

            % Create BgUpperLimitMinusOneButton
            app.BgUpperLimitMinusOneButton = uibutton(app.GridLayout2, 'push');
            app.BgUpperLimitMinusOneButton.ButtonPushedFcn = createCallbackFcn(app, @BgUpperLimitMinusOneButtonPushed, true);
            app.BgUpperLimitMinusOneButton.Layout.Row = 3;
            app.BgUpperLimitMinusOneButton.Layout.Column = 3;
            app.BgUpperLimitMinusOneButton.Text = '-1';

            % Create BgUpperLimitPlusOneButton
            app.BgUpperLimitPlusOneButton = uibutton(app.GridLayout2, 'push');
            app.BgUpperLimitPlusOneButton.ButtonPushedFcn = createCallbackFcn(app, @BgUpperLimitPlusOneButtonPushed, true);
            app.BgUpperLimitPlusOneButton.Layout.Row = 3;
            app.BgUpperLimitPlusOneButton.Layout.Column = 5;
            app.BgUpperLimitPlusOneButton.Text = '+1';

            % Create BgUpperLimitMinusTenButton
            app.BgUpperLimitMinusTenButton = uibutton(app.GridLayout2, 'push');
            app.BgUpperLimitMinusTenButton.ButtonPushedFcn = createCallbackFcn(app, @BgUpperLimitMinusTenButtonPushed, true);
            app.BgUpperLimitMinusTenButton.Layout.Row = 3;
            app.BgUpperLimitMinusTenButton.Layout.Column = 2;
            app.BgUpperLimitMinusTenButton.Text = '-10';

            % Create BgUpperLimitPlusTenButton
            app.BgUpperLimitPlusTenButton = uibutton(app.GridLayout2, 'push');
            app.BgUpperLimitPlusTenButton.ButtonPushedFcn = createCallbackFcn(app, @BgUpperLimitPlusTenButtonPushed, true);
            app.BgUpperLimitPlusTenButton.Layout.Row = 3;
            app.BgUpperLimitPlusTenButton.Layout.Column = 6;
            app.BgUpperLimitPlusTenButton.Text = '+10';

            % Create UpperLimitLabel
            app.UpperLimitLabel = uilabel(app.GridLayout2);
            app.UpperLimitLabel.FontSize = 10;
            app.UpperLimitLabel.Layout.Row = 3;
            app.UpperLimitLabel.Layout.Column = 1;
            app.UpperLimitLabel.Text = 'Upper Limit:';

            % Create bg_lower_indentEditField
            app.bg_lower_indentEditField = uieditfield(app.GridLayout2, 'numeric');
            app.bg_lower_indentEditField.ValueChangedFcn = createCallbackFcn(app, @bg_lower_indentEditFieldValueChanged, true);
            app.bg_lower_indentEditField.Layout.Row = 2;
            app.bg_lower_indentEditField.Layout.Column = 4;
            app.bg_lower_indentEditField.Value = 1;

            % Create bg_upper_indentEditField
            app.bg_upper_indentEditField = uieditfield(app.GridLayout2, 'numeric');
            app.bg_upper_indentEditField.ValueChangedFcn = createCallbackFcn(app, @bg_upper_indentEditFieldValueChanged, true);
            app.bg_upper_indentEditField.Layout.Row = 3;
            app.bg_upper_indentEditField.Layout.Column = 4;
            app.bg_upper_indentEditField.Value = 1;

            % Create DeleteBackgroundsButton
            app.DeleteBackgroundsButton = uibutton(app.GridLayout2, 'push');
            app.DeleteBackgroundsButton.ButtonPushedFcn = createCallbackFcn(app, @DeleteBackgroundsButtonPushed, true);
            app.DeleteBackgroundsButton.Layout.Row = 4;
            app.DeleteBackgroundsButton.Layout.Column = [2 6];
            app.DeleteBackgroundsButton.Text = 'Delete Backgrounds';

            % Create SetMatrixButton
            app.SetMatrixButton = uibutton(app.GridLayout2, 'push');
            app.SetMatrixButton.ButtonPushedFcn = createCallbackFcn(app, @SetmatrixintervalsautomaticallyButtonPushed, true);
            app.SetMatrixButton.WordWrap = 'on';
            app.SetMatrixButton.FontWeight = 'bold';
            app.SetMatrixButton.Layout.Row = 5;
            app.SetMatrixButton.Layout.Column = [2 6];
            app.SetMatrixButton.Text = 'Set Matrix';

            % Create MatrixLowerLimitMinusOneButton
            app.MatrixLowerLimitMinusOneButton = uibutton(app.GridLayout2, 'push');
            app.MatrixLowerLimitMinusOneButton.ButtonPushedFcn = createCallbackFcn(app, @MatrixLowerLimitMinusOneButtonPushed, true);
            app.MatrixLowerLimitMinusOneButton.Layout.Row = 6;
            app.MatrixLowerLimitMinusOneButton.Layout.Column = 3;
            app.MatrixLowerLimitMinusOneButton.Text = '-1';

            % Create MatrixLowerLimitPlusOneButton
            app.MatrixLowerLimitPlusOneButton = uibutton(app.GridLayout2, 'push');
            app.MatrixLowerLimitPlusOneButton.ButtonPushedFcn = createCallbackFcn(app, @MatrixLowerLimitPlusOneButtonPushed, true);
            app.MatrixLowerLimitPlusOneButton.Layout.Row = 6;
            app.MatrixLowerLimitPlusOneButton.Layout.Column = 5;
            app.MatrixLowerLimitPlusOneButton.Text = '+1';

            % Create MatrixLowerLimitMinusTenButton
            app.MatrixLowerLimitMinusTenButton = uibutton(app.GridLayout2, 'push');
            app.MatrixLowerLimitMinusTenButton.ButtonPushedFcn = createCallbackFcn(app, @MatrixLowerLimitMinusTenButtonPushed, true);
            app.MatrixLowerLimitMinusTenButton.Layout.Row = 6;
            app.MatrixLowerLimitMinusTenButton.Layout.Column = 2;
            app.MatrixLowerLimitMinusTenButton.Text = '-10';

            % Create MatrixLowerLimitPlusTenButton
            app.MatrixLowerLimitPlusTenButton = uibutton(app.GridLayout2, 'push');
            app.MatrixLowerLimitPlusTenButton.ButtonPushedFcn = createCallbackFcn(app, @MatrixLowerLimitPlusTenButtonPushed, true);
            app.MatrixLowerLimitPlusTenButton.Layout.Row = 6;
            app.MatrixLowerLimitPlusTenButton.Layout.Column = 6;
            app.MatrixLowerLimitPlusTenButton.Text = '+10';

            % Create MatrixUpperLimitMinusOneButton
            app.MatrixUpperLimitMinusOneButton = uibutton(app.GridLayout2, 'push');
            app.MatrixUpperLimitMinusOneButton.ButtonPushedFcn = createCallbackFcn(app, @MatrixUpperLimitMinusOneButtonPushed, true);
            app.MatrixUpperLimitMinusOneButton.Layout.Row = 7;
            app.MatrixUpperLimitMinusOneButton.Layout.Column = 3;
            app.MatrixUpperLimitMinusOneButton.Text = '-1';

            % Create MatrixUpperLimitPlusOneButton
            app.MatrixUpperLimitPlusOneButton = uibutton(app.GridLayout2, 'push');
            app.MatrixUpperLimitPlusOneButton.ButtonPushedFcn = createCallbackFcn(app, @MatrixUpperLimitPlusOneButtonPushed, true);
            app.MatrixUpperLimitPlusOneButton.Layout.Row = 7;
            app.MatrixUpperLimitPlusOneButton.Layout.Column = 5;
            app.MatrixUpperLimitPlusOneButton.Text = '+1';

            % Create MatrixUpperLimitMinusTenButton
            app.MatrixUpperLimitMinusTenButton = uibutton(app.GridLayout2, 'push');
            app.MatrixUpperLimitMinusTenButton.ButtonPushedFcn = createCallbackFcn(app, @MatrixUpperLimitMinusTenButtonPushed, true);
            app.MatrixUpperLimitMinusTenButton.Layout.Row = 7;
            app.MatrixUpperLimitMinusTenButton.Layout.Column = 2;
            app.MatrixUpperLimitMinusTenButton.Text = '-10';

            % Create MatrixUpperLimitPlusTenButton
            app.MatrixUpperLimitPlusTenButton = uibutton(app.GridLayout2, 'push');
            app.MatrixUpperLimitPlusTenButton.ButtonPushedFcn = createCallbackFcn(app, @MatrixUpperLimitPlusTenButtonPushed, true);
            app.MatrixUpperLimitPlusTenButton.Layout.Row = 7;
            app.MatrixUpperLimitPlusTenButton.Layout.Column = 6;
            app.MatrixUpperLimitPlusTenButton.Text = '+10';

            % Create matrix_lower_indentEditField
            app.matrix_lower_indentEditField = uieditfield(app.GridLayout2, 'numeric');
            app.matrix_lower_indentEditField.ValueChangedFcn = createCallbackFcn(app, @matrix_lower_indentEditFieldValueChanged, true);
            app.matrix_lower_indentEditField.Layout.Row = 6;
            app.matrix_lower_indentEditField.Layout.Column = 4;
            app.matrix_lower_indentEditField.Value = 1;

            % Create matrix_upper_indentEditField
            app.matrix_upper_indentEditField = uieditfield(app.GridLayout2, 'numeric');
            app.matrix_upper_indentEditField.ValueChangedFcn = createCallbackFcn(app, @matrix_upper_indentEditFieldValueChanged, true);
            app.matrix_upper_indentEditField.Layout.Row = 7;
            app.matrix_upper_indentEditField.Layout.Column = 4;
            app.matrix_upper_indentEditField.Value = 1;

            % Create DeleteMatrixButton
            app.DeleteMatrixButton = uibutton(app.GridLayout2, 'push');
            app.DeleteMatrixButton.ButtonPushedFcn = createCallbackFcn(app, @ErasematrixintervalsgloballyButtonPushed, true);
            app.DeleteMatrixButton.Layout.Row = 8;
            app.DeleteMatrixButton.Layout.Column = [2 6];
            app.DeleteMatrixButton.Text = 'Delete Matrix';

            % Create LowerLimitLabel
            app.LowerLimitLabel = uilabel(app.GridLayout2);
            app.LowerLimitLabel.FontSize = 10;
            app.LowerLimitLabel.Layout.Row = 2;
            app.LowerLimitLabel.Layout.Column = 1;
            app.LowerLimitLabel.Text = 'Lower Limit:';

            % Create UpperLimitLabel_2
            app.UpperLimitLabel_2 = uilabel(app.GridLayout2);
            app.UpperLimitLabel_2.FontSize = 10;
            app.UpperLimitLabel_2.Layout.Row = 7;
            app.UpperLimitLabel_2.Layout.Column = 1;
            app.UpperLimitLabel_2.Text = 'Upper Limit:';

            % Create LowerLimitLabel_2
            app.LowerLimitLabel_2 = uilabel(app.GridLayout2);
            app.LowerLimitLabel_2.FontSize = 10;
            app.LowerLimitLabel_2.Layout.Row = 6;
            app.LowerLimitLabel_2.Layout.Column = 1;
            app.LowerLimitLabel_2.Text = 'Lower Limit:';

            % Create LocalIntervalSettingCheckBox
            app.LocalIntervalSettingCheckBox = uicheckbox(app.GridLayout3);
            app.LocalIntervalSettingCheckBox.ValueChangedFcn = createCallbackFcn(app, @LocalIntervalSettingCheckBoxValueChanged, true);
            app.LocalIntervalSettingCheckBox.Text = 'Local Interval Setting';
            app.LocalIntervalSettingCheckBox.WordWrap = 'on';
            app.LocalIntervalSettingCheckBox.FontWeight = 'bold';
            app.LocalIntervalSettingCheckBox.Layout.Row = 12;
            app.LocalIntervalSettingCheckBox.Layout.Column = 6;

            % Create ProgressPanel
            app.ProgressPanel = uipanel(app.GridLayout3);
            app.ProgressPanel.Layout.Row = 1;
            app.ProgressPanel.Layout.Column = [1 14];

            % Create IntervalButton
            app.IntervalButton = uibutton(app.ProgressPanel, 'push');
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
            app.DriftButton.ButtonPushedFcn = createCallbackFcn(app, @ImportButtonPushed, true);
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

            % Create DatatipsOnOffButton
            app.DatatipsOnOffButton = uibutton(app.GridLayout3, 'state');
            app.DatatipsOnOffButton.ValueChangedFcn = createCallbackFcn(app, @DatatipsOnOffButtonValueChanged, true);
            app.DatatipsOnOffButton.Tooltip = {'Intervals cannot be moved while this button is toggled'};
            app.DatatipsOnOffButton.Text = 'Datatips On/Off';
            app.DatatipsOnOffButton.Layout.Row = 11;
            app.DatatipsOnOffButton.Layout.Column = 14;

            % Create ContextMenu2
            app.ContextMenu2 = uicontextmenu(app.UIFigure);

            % Create ApplygloballyMenu_2
            app.ApplygloballyMenu_2 = uimenu(app.ContextMenu2);
            app.ApplygloballyMenu_2.MenuSelectedFcn = createCallbackFcn(app, @ApplygloballyMenu_2Selected, true);
            app.ApplygloballyMenu_2.Text = 'Apply globally';
            
            % Assign app.ContextMenu2
            app.ResetSpikeEliminationButton.ContextMenu = app.ContextMenu2;

            % Create ContextMenu3
            app.ContextMenu3 = uicontextmenu(app.UIFigure);

            % Create ApplygloballyMenu
            app.ApplygloballyMenu = uimenu(app.ContextMenu3);
            app.ApplygloballyMenu.MenuSelectedFcn = createCallbackFcn(app, @ApplygloballyMenuSelected, true);
            app.ApplygloballyMenu.Text = 'Apply globally';

            % Create IndividualMenu
            app.IndividualMenu = uimenu(app.ContextMenu3);
            app.IndividualMenu.MenuSelectedFcn = createCallbackFcn(app, @IndividualMenuSelected, true);
            app.IndividualMenu.Text = 'Individual';

            % Create IndividualInclusiononlyMenu
            app.IndividualInclusiononlyMenu = uimenu(app.ContextMenu3);
            app.IndividualInclusiononlyMenu.MenuSelectedFcn = createCallbackFcn(app, @IndividualMenuSelected, true);
            app.IndividualInclusiononlyMenu.Text = 'Individual (Inclusion only)';
            
            % Assign app.ContextMenu3
            app.EliminateSpikesButton.ContextMenu = app.ContextMenu3;

            % Create ContextMenu4
            app.ContextMenu4 = uicontextmenu(app.UIFigure);

            % Create RefreshMenu
            app.RefreshMenu = uimenu(app.ContextMenu4);
            app.RefreshMenu.MenuSelectedFcn = createCallbackFcn(app, @RefreshMenuSelected, true);
            app.RefreshMenu.Text = 'Refresh';
            
            % Assign app.ContextMenu4
            app.PlotstylesListBox.ContextMenu = app.ContextMenu4;

            % Create ContextMenu5
            app.ContextMenu5 = uicontextmenu(app.UIFigure);

            % Create SetforspotgroupsMenu
            app.SetforspotgroupsMenu = uimenu(app.ContextMenu5);
            app.SetforspotgroupsMenu.MenuSelectedFcn = createCallbackFcn(app, @SetforspotgroupsMenuSelected, true);
            app.SetforspotgroupsMenu.Text = 'Set for spot groups';
            
            % Assign app.ContextMenu5
            app.SetBackgroundsButton.ContextMenu = app.ContextMenu5;
            app.SetMatrixButton.ContextMenu = app.ContextMenu5;

            % Create ContextMenu6
            app.ContextMenu6 = uicontextmenu(app.UIFigure);

            % Create ApplytoallMenu
            app.ApplytoallMenu = uimenu(app.ContextMenu6);
            app.ApplytoallMenu.MenuSelectedFcn = createCallbackFcn(app, @ApplytoallMenuSelected, true);
            app.ApplytoallMenu.Text = 'Apply to all';
            
            % Assign app.ContextMenu6
            app.UnmixingviaDropDown.ContextMenu = app.ContextMenu6;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Interval_Module_readable(varargin)

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