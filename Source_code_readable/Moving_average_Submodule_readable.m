% GENERATED from Moving_average_Submodule.mlapp on 2026-10-28 15:37 by export_mlapp_to_m. This file is for reading purposes, any real changes need to be applied to the .mlapp files and exported again.
classdef Moving_average_Submodule_readable < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        MovingAverageSettingsUIFigure  matlab.ui.Figure
        NumberofsweepstostepforwardEditField  matlab.ui.control.NumericEditField
        NumberofsweepstostepforwardEditFieldLabel  matlab.ui.control.Label
        ApplyButton                    matlab.ui.control.Button
        HowmanysweepstoindenttheintervalintheunselectedEditField  matlab.ui.control.NumericEditField
        HowmanysweepstoindenttheintervalintheunselectedstartandendLabel  matlab.ui.control.Label
        NumberofsweepstoskipatthestartEditField  matlab.ui.control.NumericEditField
        NumberofsweepstoskipatthestartEditFieldLabel  matlab.ui.control.Label
        NumberofsweepstoskipattheendEditField  matlab.ui.control.NumericEditField
        NumberofsweepstoskipattheendEditFieldLabel  matlab.ui.control.Label
        NumberofsweepstobeaveragedEditField  matlab.ui.control.NumericEditField
        NumberofsweepstobeaveragedEditFieldLabel  matlab.ui.control.Label
        SpotListBox                    matlab.ui.control.ListBox
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
        selected_spot

    end

    methods (Access = private)

        function applied = apply_rolling_average(app)

            applied = false;

            if isempty(app.selected_spot)
                uialert(app.MovingAverageSettingsUIFigure, "No spots selected.", "Warning", "Icon", "warning");
                return
            end


            signal_starts = app.source.base.project.session.spot.signal_starts(app.selected_spot);
            signal_ends   = app.source.base.project.session.spot.signal_ends(app.selected_spot);

            sweeps_to_average      = app.NumberofsweepstobeaveragedEditField.Value;
            sweeps_to_skip_start   = app.NumberofsweepstoskipatthestartEditField.Value;
            sweeps_to_skip_end     = app.NumberofsweepstoskipattheendEditField.Value;
            sweeps_to_step_forward = app.NumberofsweepstostepforwardEditField.Value;

            num_signals = numel(signal_starts);
            all_starts  = cell(num_signals, 1);
            all_ends    = cell(num_signals, 1);

            for i = 1:num_signals
                effective_start     = signal_starts(i) + sweeps_to_skip_start;
                effective_end       = signal_ends(i)   - sweeps_to_skip_end;
                last_possible_start = effective_end - sweeps_to_average + 1;

                if effective_start <= last_possible_start
                    start_indices = (effective_start : sweeps_to_step_forward : last_possible_start)';
                    all_starts{i} = start_indices;
                    all_ends{i}   = start_indices + sweeps_to_average - 1;
                else
                    uialert(app.MovingAverageSettingsUIFigure, ...
                        "Signal is too short for the given window size after applying skips.", "Warning", "Icon", "warning");
                    return
                end
            end

            changes = check_changes(app.source, 'import', app.MovingAverageSettingsUIFigure);
            if changes == false
                applied = false;
                return
            end

            final_names           = string([]);
            final_signal_starts   = [];
            final_signal_ends     = [];
            final_matrix_1_starts = [];
            final_matrix_1_ends   = [];

            selected_spot_map = containers.Map('KeyType', 'double', 'ValueType', 'any');
            for i = 1:num_signals
                selected_idx         = app.selected_spot(i);
                num_new_spots        = numel(all_starts{i});
                base_name            = app.source.base.project.session.spot.name(selected_idx);
                spot_suffixes        = " -" + (1:num_new_spots)';
                data.generated_names   = base_name + spot_suffixes;
                data.replicated_starts = repmat(app.source.base.project.session.spot.signal_starts(selected_idx), num_new_spots, 1);
                data.replicated_ends   = repmat(app.source.base.project.session.spot.signal_ends(selected_idx),   num_new_spots, 1);
                data.matrix_starts     = all_starts{i};
                data.matrix_ends       = all_ends{i};
                selected_spot_map(selected_idx) = data;
            end

            original_spot_count = numel(app.source.base.project.session.spot.name);
            unselected_indent   = app.HowmanysweepstoindenttheintervalintheunselectedEditField.Value;

            for i = 1:original_spot_count
                if isKey(selected_spot_map, i)
                    data = selected_spot_map(i);
                    final_names           = [final_names;           data.generated_names];
                    final_signal_starts   = [final_signal_starts;   data.replicated_starts];
                    final_signal_ends     = [final_signal_ends;     data.replicated_ends];
                    final_matrix_1_starts = [final_matrix_1_starts; data.matrix_starts];
                    final_matrix_1_ends   = [final_matrix_1_ends;   data.matrix_ends];
                else
                    final_names           = [final_names;           app.source.base.project.session.spot.name(i)];
                    current_signal_start  = app.source.base.project.session.spot.signal_starts(i);
                    current_signal_end    = app.source.base.project.session.spot.signal_ends(i);
                    final_signal_starts   = [final_signal_starts;   current_signal_start];
                    final_signal_ends     = [final_signal_ends;     current_signal_end];

                    matrix_start = current_signal_start + unselected_indent;
                    matrix_end   = current_signal_end   - unselected_indent;
                    if matrix_start > matrix_end
                        matrix_start = current_signal_start;
                        matrix_end   = current_signal_end;
                    end
                    final_matrix_1_starts = [final_matrix_1_starts; matrix_start];
                    final_matrix_1_ends   = [final_matrix_1_ends;   matrix_end];
                end
            end

            app.source.base.project.session.spot.name            = final_names;
            app.source.base.project.session.spot.signal_starts   = final_signal_starts;
            app.source.base.project.session.spot.signal_ends     = final_signal_ends;
            app.source.base.project.session.spot.matrix_1_starts = final_matrix_1_starts;
            app.source.base.project.session.spot.matrix_1_ends   = final_matrix_1_ends;

            app.source.base.project.session.meta.rolling_average_settings.sweeps_to_average      = sweeps_to_average;
            app.source.base.project.session.meta.rolling_average_settings.sweeps_to_skip_start   = sweeps_to_skip_start;
            app.source.base.project.session.meta.rolling_average_settings.sweeps_to_skip_end     = sweeps_to_skip_end;
            app.source.base.project.session.meta.rolling_average_settings.sweeps_to_step_forward = sweeps_to_step_forward;
            app.source.base.project.session.meta.rolling_average_settings.unselected_indent      = unselected_indent;
            app.source.base.project.session.meta.rolling_average_settings.applied                = true;

            if isequal(app.source.base.project.session.config.datatype, 'Continuous')

                app.source.base.project.session.spot.integer_time_points = final_matrix_1_starts;

            elseif isequal(app.source.base.project.session.config.datatype, 'Single')

                final_signal_data = {};

                if isfield(app.source.base.project.session.spot, 'acquisition_datetime')

                    dt_all = datetime(app.source.base.project.session.spot.acquisition_datetime, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
                    final_acquisition_datetime = strings(0, 1);

                    for i = 1:original_spot_count
                        if isKey(selected_spot_map, i)
                            data           = selected_spot_map(i);
                            num_duplicates = numel(data.matrix_starts);

                            final_signal_data = [final_signal_data; ...
                                repmat(app.source.base.project.session.spot.signal_data(i), num_duplicates, 1)];

                            current_dt = dt_all(i);

                            if i < original_spot_count
                                next_dt = dt_all(i + 1);
                            else
                                if i > 1
                                    next_dt = current_dt + (current_dt - dt_all(i - 1));
                                else
                                    next_dt = current_dt + minutes(10);
                                end
                            end

                            signal_start  = app.source.base.project.session.spot.signal_starts(i);
                            signal_length = app.source.base.project.session.spot.signal_ends(i) - signal_start;

                            for j = 1:num_duplicates
                                window_center = (data.matrix_starts(j) + data.matrix_ends(j)) / 2;
                                relative_pos  = (window_center - signal_start) / signal_length;
                                interp_dt     = current_dt + relative_pos * (next_dt - current_dt);
                                final_acquisition_datetime = [final_acquisition_datetime; string(interp_dt, 'yyyy-MM-dd HH:mm:ss')];
                            end
                        else
                            final_acquisition_datetime = [final_acquisition_datetime; ...
                                app.source.base.project.session.spot.acquisition_datetime(i)];
                            final_signal_data = [final_signal_data; ...
                                app.source.base.project.session.spot.signal_data(i)];
                        end
                    end

                    app.source.base.project.session.spot.acquisition_datetime = final_acquisition_datetime;
                    app.source.base.project.session.spot.signal_data          = final_signal_data;

                else

                    final_acquisition_times = string([]);

                    for i = 1:original_spot_count
                        if isKey(selected_spot_map, i)
                            data           = selected_spot_map(i);
                            num_duplicates = numel(data.matrix_starts);

                            final_signal_data = [final_signal_data; ...
                                repmat(app.source.base.project.session.spot.signal_data(i), num_duplicates, 1)];

                            current_time = app.source.base.project.session.spot.acquisition_time(i);

                            if i < original_spot_count
                                next_time = app.source.base.project.session.spot.acquisition_time(i + 1);
                            else
                                current_parts   = sscanf(current_time, '%d:%d:%d');
                                current_seconds = current_parts(1)*3600 + current_parts(2)*60 + current_parts(3);
                                if i > 1
                                    prev_time    = app.source.base.project.session.spot.acquisition_time(i - 1);
                                    prev_parts   = sscanf(prev_time, '%d:%d:%d');
                                    prev_seconds = prev_parts(1)*3600 + prev_parts(2)*60 + prev_parts(3);
                                    next_seconds = current_seconds + (current_seconds - prev_seconds);
                                else
                                    next_seconds = current_seconds + 600;
                                end
                                h = floor(next_seconds / 3600);
                                m = floor(mod(next_seconds, 3600) / 60);
                                s = floor(mod(next_seconds, 60));
                                next_time = string(sprintf('%02d:%02d:%02d', h, m, s));
                            end

                            current_parts = sscanf(current_time, '%d:%d:%d');
                            t_start = current_parts(1)*3600 + current_parts(2)*60 + current_parts(3);
                            next_parts = sscanf(next_time, '%d:%d:%d');
                            t_end   = next_parts(1)*3600 + next_parts(2)*60 + next_parts(3);

                            signal_start  = app.source.base.project.session.spot.signal_starts(i);
                            signal_length = app.source.base.project.session.spot.signal_ends(i) - signal_start;

                            for j = 1:num_duplicates
                                window_center  = (data.matrix_starts(j) + data.matrix_ends(j)) / 2;
                                relative_pos   = (window_center - signal_start) / signal_length;
                                interp_seconds = t_start + relative_pos * (t_end - t_start);
                                h = floor(interp_seconds / 3600);
                                m = floor(mod(interp_seconds, 3600) / 60);
                                s = floor(mod(interp_seconds, 60));
                                final_acquisition_times = [final_acquisition_times; string(sprintf('%02d:%02d:%02d', h, m, s))];
                            end
                        else
                            final_acquisition_times = [final_acquisition_times; ...
                                app.source.base.project.session.spot.acquisition_time(i)];
                            final_signal_data = [final_signal_data; ...
                                app.source.base.project.session.spot.signal_data(i)];
                        end
                    end

                    app.source.base.project.session.spot.acquisition_time = final_acquisition_times;
                    app.source.base.project.session.spot.signal_data      = final_signal_data;

                end

            end

            if isfield(app.source.base.project.session, 'meta') && ...
                    isfield(app.source.base.project.session.meta, 'laser_parameters')

                laser_params     = app.source.base.project.session.meta.laser_parameters;
                param_fields     = fieldnames(laser_params);
                new_laser_params = struct();

                for f = 1:numel(param_fields)
                    field     = param_fields{f};
                    orig_data = laser_params.(field);

                    if iscell(orig_data) || isstring(orig_data)
                        field_length = length(orig_data);
                    elseif isnumeric(orig_data) || islogical(orig_data)
                        field_length = size(orig_data, 1);
                    else
                        continue;
                    end

                    if field_length ~= original_spot_count
                        new_laser_params.(field) = orig_data;
                        continue;
                    end

                    expanded_data = {};
                    idx = 1;
                    for i = 1:original_spot_count
                        if isKey(selected_spot_map, i)
                            num_duplicates = numel(selected_spot_map(i).matrix_starts);
                            if iscell(orig_data)
                                expanded_data(idx:idx+num_duplicates-1, 1) = repmat(orig_data(i), num_duplicates, 1);
                            elseif isstring(orig_data)
                                expanded_data(idx:idx+num_duplicates-1, 1) = repmat({orig_data(i)}, num_duplicates, 1);
                            else
                                expanded_data(idx:idx+num_duplicates-1, 1) = num2cell(repmat(orig_data(i), num_duplicates, 1));
                            end
                            idx = idx + num_duplicates;
                        else
                            if iscell(orig_data)
                                expanded_data(idx, 1) = orig_data(i);
                            else
                                expanded_data(idx, 1) = {orig_data(i)};
                            end
                            idx = idx + 1;
                        end
                    end

                    if isnumeric(orig_data)
                        new_laser_params.(field) = cell2mat(expanded_data);
                    elseif isstring(orig_data)
                        new_laser_params.(field) = string(expanded_data);
                    else
                        new_laser_params.(field) = expanded_data;
                    end
                end

                app.source.base.project.session.meta.laser_parameters = new_laser_params;
            end
            applied = true;
        end




    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, sourceapp)

            app.source = sourceapp;

            app.SpotListBox.Items = app.source.base.project.session.spot.name;
            app.SpotListBox.ItemsData = 1:numel(app.source.base.project.session.spot.name);

            if isfield(app.source.base.project.session.meta, 'rolling_average_settings') && app.source.base.project.session.meta.rolling_average_settings.applied == true

                app.NumberofsweepstobeaveragedEditField.Value = app.source.base.project.session.meta.rolling_average_settings.sweeps_to_average;
                app.NumberofsweepstoskipatthestartEditField.Value = app.source.base.project.session.meta.rolling_average_settings.sweeps_to_skip_start;
                app.NumberofsweepstoskipattheendEditField.Value = app.source.base.project.session.meta.rolling_average_settings.sweeps_to_skip_end;
                app.NumberofsweepstostepforwardEditField.Value = app.source.base.project.session.meta.rolling_average_settings.sweeps_to_step_forward;
                app.HowmanysweepstoindenttheintervalintheunselectedEditField.Value = app.source.base.project.session.meta.rolling_average_settings.unselected_indent;

                app.SpotListBox.Enable = false;
                app.NumberofsweepstobeaveragedEditField.Enable = false;
                app.NumberofsweepstoskipatthestartEditField.Enable = false;
                app.NumberofsweepstoskipattheendEditField.Enable = false;
                app.NumberofsweepstostepforwardEditField.Enable = false;
                app.HowmanysweepstoindenttheintervalintheunselectedEditField.Enable = false;
                app.ApplyButton.Enable = false;

            end






        end

        % Callback function
        function devButtonPushed(app, event)

            apply_rolling_average(app)

        end

        % Value changed function: SpotListBox
        function SpotListBoxValueChanged(app, event)

            app.selected_spot = app.SpotListBox.Value;

        end

        % Button pushed function: ApplyButton
        function ApplyButtonPushed(app, event)


            fig = app.MovingAverageSettingsUIFigure;
            title = "ICP-Base";

            msg = "After applying, you process your data like you would normally but there are a few quirks:" + newline + ...
                "1. If you change anything in the global interval setting for the matrix, everything will be reset and you can trash this session. Just don't touch this feature for the matrix." + newline + ...
                "2. For the spots that are not moving averaged, adjust the matrix intervals manually (and not globally!) or via global interval setting for spot groups (right-click on the global buttons)." + newline + ...
                "3. You can set the backgrounds using the global interval setting like normal though! Just don't touch the matrix intervals." + newline + ...
                "4. If the spikes should be reset globally for datatype continuous it has to be done once for the first rolling average window. All subsequent windows will also be reset since they all access the same underlying data." + newline + ...
                "5. Once this has been applied, there is no going back. Either you roll with it or start from scratch." + newline + ...
                "6. If the datatype is single, the acquisition time for each window is interpolated between the acquisition time of the original spot and the next spot. Be aware that this can result in slight inaccuracies of the drift correction in certain cases.";

            main_selection = uiconfirm(fig,msg,title, ...
                "Options",["I understood and if things go sideways it's my own fault","Cancel"], ...
                "DefaultOption",1,"CancelOption",2, ...
                "Icon","warning");

            if isequal(main_selection, "I understood and if things go sideways it's my own fault")

                msg_2 = "Really?";
                selection_2 = uiconfirm(fig, msg_2, title, ...
                    "Options",["Yes, really!", "No"], ...
                    "DefaultOption",1,"CancelOption",2);

                if isequal(selection_2, 'Yes, really!')

                    applied = apply_rolling_average(app);

                    if applied
                        source_app = app.source;
                        delete(app)
                        refresh_panels_after_reset(source_app)
                        proceed_to_interval(source_app, 'Matrix', false);
                    end

                elseif isequal(selection_2, 'No')

                    return

                end


            elseif isequal(main_selection, 'Cancel')

                return

            end





        end

        % Value changed function: NumberofsweepstostepforwardEditField
        function NumberofsweepstostepforwardEditFieldValueChanged(app, event)


        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create MovingAverageSettingsUIFigure and hide until all components are created
            app.MovingAverageSettingsUIFigure = uifigure('Visible', 'off');
            app.MovingAverageSettingsUIFigure.Position = [100 100 640 480];
            app.MovingAverageSettingsUIFigure.Name = 'Moving Average Settings';
            app.MovingAverageSettingsUIFigure.Icon = 'icon_48.png';

            % Create SpotListBox
            app.SpotListBox = uilistbox(app.MovingAverageSettingsUIFigure);
            app.SpotListBox.Items = {};
            app.SpotListBox.Multiselect = 'on';
            app.SpotListBox.ValueChangedFcn = createCallbackFcn(app, @SpotListBoxValueChanged, true);
            app.SpotListBox.Position = [24 27 224 427];
            app.SpotListBox.Value = {};

            % Create NumberofsweepstobeaveragedEditFieldLabel
            app.NumberofsweepstobeaveragedEditFieldLabel = uilabel(app.MovingAverageSettingsUIFigure);
            app.NumberofsweepstobeaveragedEditFieldLabel.HorizontalAlignment = 'right';
            app.NumberofsweepstobeaveragedEditFieldLabel.Position = [308 160 193 22];
            app.NumberofsweepstobeaveragedEditFieldLabel.Text = 'Number of sweeps to be averaged:';

            % Create NumberofsweepstobeaveragedEditField
            app.NumberofsweepstobeaveragedEditField = uieditfield(app.MovingAverageSettingsUIFigure, 'numeric');
            app.NumberofsweepstobeaveragedEditField.Limits = [1 Inf];
            app.NumberofsweepstobeaveragedEditField.HorizontalAlignment = 'center';
            app.NumberofsweepstobeaveragedEditField.Position = [516 153 45 35];
            app.NumberofsweepstobeaveragedEditField.Value = 5;

            % Create NumberofsweepstoskipattheendEditFieldLabel
            app.NumberofsweepstoskipattheendEditFieldLabel = uilabel(app.MovingAverageSettingsUIFigure);
            app.NumberofsweepstoskipattheendEditFieldLabel.HorizontalAlignment = 'right';
            app.NumberofsweepstoskipattheendEditFieldLabel.Position = [296 259 205 22];
            app.NumberofsweepstoskipattheendEditFieldLabel.Text = 'Number of sweeps to skip at the end:';

            % Create NumberofsweepstoskipattheendEditField
            app.NumberofsweepstoskipattheendEditField = uieditfield(app.MovingAverageSettingsUIFigure, 'numeric');
            app.NumberofsweepstoskipattheendEditField.Limits = [0 Inf];
            app.NumberofsweepstoskipattheendEditField.HorizontalAlignment = 'center';
            app.NumberofsweepstoskipattheendEditField.Position = [516 252 45 35];

            % Create NumberofsweepstoskipatthestartEditFieldLabel
            app.NumberofsweepstoskipatthestartEditFieldLabel = uilabel(app.MovingAverageSettingsUIFigure);
            app.NumberofsweepstoskipatthestartEditFieldLabel.HorizontalAlignment = 'right';
            app.NumberofsweepstoskipatthestartEditFieldLabel.Position = [293 310 208 22];
            app.NumberofsweepstoskipatthestartEditFieldLabel.Text = 'Number of sweeps to skip at the start:';

            % Create NumberofsweepstoskipatthestartEditField
            app.NumberofsweepstoskipatthestartEditField = uieditfield(app.MovingAverageSettingsUIFigure, 'numeric');
            app.NumberofsweepstoskipatthestartEditField.Limits = [0 Inf];
            app.NumberofsweepstoskipatthestartEditField.HorizontalAlignment = 'center';
            app.NumberofsweepstoskipatthestartEditField.Position = [516 303 45 35];

            % Create HowmanysweepstoindenttheintervalintheunselectedstartandendLabel
            app.HowmanysweepstoindenttheintervalintheunselectedstartandendLabel = uilabel(app.MovingAverageSettingsUIFigure);
            app.HowmanysweepstoindenttheintervalintheunselectedstartandendLabel.HorizontalAlignment = 'right';
            app.HowmanysweepstoindenttheintervalintheunselectedstartandendLabel.WordWrap = 'on';
            app.HowmanysweepstoindenttheintervalintheunselectedstartandendLabel.Position = [284 354 217 42];
            app.HowmanysweepstoindenttheintervalintheunselectedstartandendLabel.Text = 'Number of sweeps to indent the interval in the unselected spots (start and end):';

            % Create HowmanysweepstoindenttheintervalintheunselectedEditField
            app.HowmanysweepstoindenttheintervalintheunselectedEditField = uieditfield(app.MovingAverageSettingsUIFigure, 'numeric');
            app.HowmanysweepstoindenttheintervalintheunselectedEditField.Limits = [0 15];
            app.HowmanysweepstoindenttheintervalintheunselectedEditField.HorizontalAlignment = 'center';
            app.HowmanysweepstoindenttheintervalintheunselectedEditField.Position = [516 359 45 35];
            app.HowmanysweepstoindenttheintervalintheunselectedEditField.Value = 5;

            % Create ApplyButton
            app.ApplyButton = uibutton(app.MovingAverageSettingsUIFigure, 'push');
            app.ApplyButton.ButtonPushedFcn = createCallbackFcn(app, @ApplyButtonPushed, true);
            app.ApplyButton.Position = [294 27 272 90];
            app.ApplyButton.Text = 'Apply';

            % Create NumberofsweepstostepforwardEditFieldLabel
            app.NumberofsweepstostepforwardEditFieldLabel = uilabel(app.MovingAverageSettingsUIFigure);
            app.NumberofsweepstostepforwardEditFieldLabel.HorizontalAlignment = 'right';
            app.NumberofsweepstostepforwardEditFieldLabel.Position = [308 209 193 22];
            app.NumberofsweepstostepforwardEditFieldLabel.Text = 'Number of sweeps to step forward:';

            % Create NumberofsweepstostepforwardEditField
            app.NumberofsweepstostepforwardEditField = uieditfield(app.MovingAverageSettingsUIFigure, 'numeric');
            app.NumberofsweepstostepforwardEditField.Limits = [1 Inf];
            app.NumberofsweepstostepforwardEditField.ValueChangedFcn = createCallbackFcn(app, @NumberofsweepstostepforwardEditFieldValueChanged, true);
            app.NumberofsweepstostepforwardEditField.HorizontalAlignment = 'center';
            app.NumberofsweepstostepforwardEditField.Position = [516 202 45 35];
            app.NumberofsweepstostepforwardEditField.Value = 1;

            % Show the figure after all components are created
            app.MovingAverageSettingsUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Moving_average_Submodule_readable(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.MovingAverageSettingsUIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.MovingAverageSettingsUIFigure)
        end
    end
end