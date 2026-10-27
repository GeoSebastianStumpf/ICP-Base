% GENERATED from Spot_Group_Interval_Submodule.mlapp on 2026-10-27 16:55 by export_mlapp_to_m. This file is for reading purposes, any real changes need to be applied to the .mlapp files and exported again.
classdef Spot_Group_Interval_Submodule_readable < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        SpotnamecontainsEditField       matlab.ui.control.EditField
        SpotnamecontainsEditFieldLabel  matlab.ui.control.Label
        ChooseButton                    matlab.ui.control.Button
        GlobalIntervalPanel             matlab.ui.container.Panel
        GridLayout2                     matlab.ui.container.GridLayout
        MatrixLabel                     matlab.ui.control.Label
        BackgroundsLabel                matlab.ui.control.Label
        LowerLimitLabel                 matlab.ui.control.Label
        BgLowerLimitMinusTenButton      matlab.ui.control.Button
        BgLowerLimitMinusOneButton      matlab.ui.control.Button
        BgLowerLimitPlusOneButton       matlab.ui.control.Button
        BgLowerLimitPlusTenButton       matlab.ui.control.Button
        UpperLimitLabel                 matlab.ui.control.Label
        BgUpperLimitMinusTenButton      matlab.ui.control.Button
        BgUpperLimitMinusOneButton      matlab.ui.control.Button
        BgUpperLimitPlusOneButton       matlab.ui.control.Button
        BgUpperLimitPlusTenButton       matlab.ui.control.Button
        LowerLimitLabel_2               matlab.ui.control.Label
        UpperLimitLabel_2               matlab.ui.control.Label
        MatrixLowerLimitMinusTenButton  matlab.ui.control.Button
        MatrixUpperLimitMinusTenButton  matlab.ui.control.Button
        MatrixLowerLimitMinusOneButton  matlab.ui.control.Button
        MatrixUpperLimitMinusOneButton  matlab.ui.control.Button
        MatrixLowerLimitPlusOneButton   matlab.ui.control.Button
        MatrixLowerLimitPlusTenButton   matlab.ui.control.Button
        MatrixUpperLimitPlusOneButton   matlab.ui.control.Button
        MatrixUpperLimitPlusTenButton   matlab.ui.control.Button
        SpotListBox                     matlab.ui.control.ListBox
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


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, sourceapp)

            app.source = sourceapp;

            app.SpotListBox.Items = app.source.base.project.session.spot.name;
            app.SpotListBox.ItemsData = 1:numel(app.source.base.project.session.spot.name);


        end

        % Value changed function: SpotListBox
        function SpotListBoxValueChanged(app, event)

            app.selected_spot = app.SpotListBox.Value;

        end

        % Button pushed function: ChooseButton
        function ChooseButtonPushed(app, event)

            % Initialize an empty array to store the indices of the selected spots
            selected_spot_indices = [];

            % Iterate through the spot names
            for i = 1:length(app.source.base.project.session.spot.name)
                % Check if the spot name contains the selected string
                if contains(app.source.base.project.session.spot.name(i), app.SpotnamecontainsEditField.Value)
                    % If it does, add the index to the selected_spot_indices array
                    selected_spot_indices(end+1) = i;
                end
            end

            % Store the selected spot indices in the app property
            app.selected_spot = selected_spot_indices;

            app.SpotListBox.Value = selected_spot_indices;


        end

        % Button pushed function: BgLowerLimitPlusTenButton
        function BgLowerLimitPlusTenButtonPushed(app, event)
            changes = check_changes(app.source, 'interval', app.UIFigure);
            if changes == false
                return
            end


            if any(isnan(app.source.base.project.session.spot.background_starts(app.selected_spot)))
                return
            end

            current_bg_starts = app.source.base.project.session.spot.background_starts(app.selected_spot);
            new_bg_starts = max(0, current_bg_starts + 10);
            app.source.base.project.session.spot.background_starts(app.selected_spot) = new_bg_starts;

            app.source.base.project.session.config.manual_intervals = true;

            % Update the plot
            app.source.update_Interval_Module_GUI()

        end

        % Button pushed function: BgLowerLimitPlusOneButton
        function BgLowerLimitPlusOneButtonPushed(app, event)
            changes = check_changes(app.source, 'interval', app.UIFigure);
            if changes == false
                return
            end


            if any(isnan(app.source.base.project.session.spot.background_starts(app.selected_spot)))
                return
            end

            current_bg_starts = app.source.base.project.session.spot.background_starts(app.selected_spot);
            new_bg_starts = max(0, current_bg_starts + 1);
            app.source.base.project.session.spot.background_starts(app.selected_spot) = new_bg_starts;

            app.source.base.project.session.config.manual_intervals = true;

            % Update the plot
            app.source.update_Interval_Module_GUI()

        end

        % Button pushed function: BgLowerLimitMinusOneButton
        function BgLowerLimitMinusOneButtonPushed(app, event)
            changes = check_changes(app.source, 'interval', app.UIFigure);
            if changes == false
                return
            end


            if any(isnan(app.source.base.project.session.spot.background_starts(app.selected_spot)))
                return
            end

            current_bg_starts = app.source.base.project.session.spot.background_starts(app.selected_spot);
            new_bg_starts = max(0, current_bg_starts - 1);
            app.source.base.project.session.spot.background_starts(app.selected_spot) = new_bg_starts;

            app.source.base.project.session.config.manual_intervals = true;

            app.source.update_Interval_Module_GUI()
        end

        % Button pushed function: BgLowerLimitMinusTenButton
        function BgLowerLimitMinusTenButtonPushed(app, event)
            changes = check_changes(app.source, 'interval', app.UIFigure);
            if changes == false
                return
            end


            if any(isnan(app.source.base.project.session.spot.background_starts(app.selected_spot)))
                return
            end

            current_bg_starts = app.source.base.project.session.spot.background_starts(app.selected_spot);
            new_bg_starts = max(0, current_bg_starts - 10);
            app.source.base.project.session.spot.background_starts(app.selected_spot) = new_bg_starts;

            app.source.base.project.session.config.manual_intervals = true;

            app.source.update_Interval_Module_GUI()
        end

        % Button pushed function: BgUpperLimitPlusTenButton
        function BgUpperLimitPlusTenButtonPushed(app, event)
            changes = check_changes(app.source, 'interval', app.UIFigure);
            if changes == false
                return
            end


            if any(isnan(app.source.base.project.session.spot.background_ends(app.selected_spot)))
                return
            end

            current_bg_ends = app.source.base.project.session.spot.background_ends(app.selected_spot);
            new_bg_ends = max(0, current_bg_ends + 10);
            app.source.base.project.session.spot.background_ends(app.selected_spot) = new_bg_ends;

            app.source.base.project.session.config.manual_intervals = true;

            app.source.update_Interval_Module_GUI()

        end

        % Button pushed function: BgUpperLimitPlusOneButton
        function BgUpperLimitPlusOneButtonPushed(app, event)
            changes = check_changes(app.source, 'interval', app.UIFigure);
            if changes == false
                return
            end


            if any(isnan(app.source.base.project.session.spot.background_ends(app.selected_spot)))
                return
            end

            current_bg_ends = app.source.base.project.session.spot.background_ends(app.selected_spot);
            new_bg_ends = max(0, current_bg_ends + 1);
            app.source.base.project.session.spot.background_ends(app.selected_spot) = new_bg_ends;

            app.source.base.project.session.config.manual_intervals = true;

            app.source.update_Interval_Module_GUI()

        end

        % Button pushed function: BgUpperLimitMinusOneButton
        function BgUpperLimitMinusOneButtonPushed(app, event)
            changes = check_changes(app.source, 'interval', app.UIFigure);
            if changes == false
                return
            end


            if any(isnan(app.source.base.project.session.spot.background_ends(app.selected_spot)))
                return
            end

            current_bg_ends = app.source.base.project.session.spot.background_ends(app.selected_spot);
            new_bg_ends = max(0, current_bg_ends - 1);
            app.source.base.project.session.spot.background_ends(app.selected_spot) = new_bg_ends;

            app.source.base.project.session.config.manual_intervals = true;

            app.source.update_Interval_Module_GUI()
        end

        % Button pushed function: BgUpperLimitMinusTenButton
        function BgUpperLimitMinusTenButtonPushed(app, event)
            changes = check_changes(app.source, 'interval', app.UIFigure);
            if changes == false
                return
            end


            if any(isnan(app.source.base.project.session.spot.background_ends(app.selected_spot)))
                return
            end

            current_bg_ends = app.source.base.project.session.spot.background_ends(app.selected_spot);
            new_bg_ends = max(0, current_bg_ends - 10);
            app.source.base.project.session.spot.background_ends(app.selected_spot) = new_bg_ends;

            app.source.base.project.session.config.manual_intervals = true;

            app.source.update_Interval_Module_GUI()
        end

        % Button pushed function: MatrixLowerLimitPlusTenButton
        function MatrixLowerLimitPlusTenButtonPushed(app, event)
            changes = check_changes(app.source, 'interval', app.UIFigure);
            if changes == false
                return
            end


            if any(isnan(app.source.base.project.session.spot.matrix_1_starts(app.selected_spot)))
                return
            end

            current_mat_starts = app.source.base.project.session.spot.matrix_1_starts(app.selected_spot);
            new_mat_starts = max(0, current_mat_starts + 10);
            app.source.base.project.session.spot.matrix_1_starts(app.selected_spot) = new_mat_starts;

            app.source.base.project.session.config.manual_intervals = true;

            app.source.update_Interval_Module_GUI()

        end

        % Button pushed function: MatrixLowerLimitPlusOneButton
        function MatrixLowerLimitPlusOneButtonPushed(app, event)
            changes = check_changes(app.source, 'interval', app.UIFigure);
            if changes == false
                return
            end


            if any(isnan(app.source.base.project.session.spot.matrix_1_starts(app.selected_spot)))
                return
            end

            current_mat_starts = app.source.base.project.session.spot.matrix_1_starts(app.selected_spot);
            new_mat_starts = max(0, current_mat_starts + 1);
            app.source.base.project.session.spot.matrix_1_starts(app.selected_spot) = new_mat_starts;

            app.source.base.project.session.config.manual_intervals = true;

            app.source.update_Interval_Module_GUI()

        end

        % Button pushed function: MatrixLowerLimitMinusOneButton
        function MatrixLowerLimitMinusOneButtonPushed(app, event)
            changes = check_changes(app.source, 'interval', app.UIFigure);
            if changes == false
                return
            end


            if any(isnan(app.source.base.project.session.spot.matrix_1_starts(app.selected_spot)))
                return
            end

            current_mat_starts = app.source.base.project.session.spot.matrix_1_starts(app.selected_spot);
            new_mat_starts = max(0, current_mat_starts - 1);
            app.source.base.project.session.spot.matrix_1_starts(app.selected_spot) = new_mat_starts;

            app.source.base.project.session.config.manual_intervals = true;

            app.source.update_Interval_Module_GUI()
        end

        % Button pushed function: MatrixLowerLimitMinusTenButton
        function MatrixLowerLimitMinusTenButtonPushed(app, event)
            changes = check_changes(app.source, 'interval', app.UIFigure);
            if changes == false
                return
            end


            if any(isnan(app.source.base.project.session.spot.matrix_1_starts(app.selected_spot)))
                return
            end

            current_mat_starts = app.source.base.project.session.spot.matrix_1_starts(app.selected_spot);
            new_mat_starts = max(0, current_mat_starts - 10);
            app.source.base.project.session.spot.matrix_1_starts(app.selected_spot) = new_mat_starts;

            app.source.base.project.session.config.manual_intervals = true;

            app.source.update_Interval_Module_GUI()

        end

        % Button pushed function: MatrixUpperLimitPlusTenButton
        function MatrixUpperLimitPlusTenButtonPushed(app, event)
            changes = check_changes(app.source, 'interval', app.UIFigure);
            if changes == false
                return
            end


            if any(isnan(app.source.base.project.session.spot.matrix_1_ends(app.selected_spot)))
                return
            end

            current_mat_ends = app.source.base.project.session.spot.matrix_1_ends(app.selected_spot);
            new_mat_ends = max(0, current_mat_ends + 10);
            app.source.base.project.session.spot.matrix_1_ends(app.selected_spot) = new_mat_ends;

            app.source.base.project.session.config.manual_intervals = true;

            app.source.update_Interval_Module_GUI()

        end

        % Button pushed function: MatrixUpperLimitPlusOneButton
        function MatrixUpperLimitPlusOneButtonPushed(app, event)
            changes = check_changes(app.source, 'interval', app.UIFigure);
            if changes == false
                return
            end


            if any(isnan(app.source.base.project.session.spot.matrix_1_ends(app.selected_spot)))
                return
            end

            current_mat_ends = app.source.base.project.session.spot.matrix_1_ends(app.selected_spot);
            new_mat_ends = max(0, current_mat_ends + 1);
            app.source.base.project.session.spot.matrix_1_ends(app.selected_spot) = new_mat_ends;

            app.source.base.project.session.config.manual_intervals = true;

            app.source.update_Interval_Module_GUI()
        end

        % Button pushed function: MatrixUpperLimitMinusOneButton
        function MatrixUpperLimitMinusOneButtonPushed(app, event)
            changes = check_changes(app.source, 'interval', app.UIFigure);
            if changes == false
                return
            end


            if any(isnan(app.source.base.project.session.spot.matrix_1_ends(app.selected_spot)))
                return
            end

            current_mat_ends = app.source.base.project.session.spot.matrix_1_ends(app.selected_spot);
            new_mat_ends = max(0, current_mat_ends - 1);
            app.source.base.project.session.spot.matrix_1_ends(app.selected_spot) = new_mat_ends;

            app.source.base.project.session.config.manual_intervals = true;

            app.source.update_Interval_Module_GUI()
        end

        % Button pushed function: MatrixUpperLimitMinusTenButton
        function MatrixUpperLimitMinusTenButtonPushed(app, event)
            changes = check_changes(app.source, 'interval', app.UIFigure);
            if changes == false
                return
            end


            if any(isnan(app.source.base.project.session.spot.matrix_1_ends(app.selected_spot)))
                return
            end

            current_mat_ends = app.source.base.project.session.spot.matrix_1_ends(app.selected_spot);
            new_mat_ends = max(0, current_mat_ends - 10);
            app.source.base.project.session.spot.matrix_1_ends(app.selected_spot) = new_mat_ends;

            app.source.base.project.session.config.manual_intervals = true;

            app.source.update_Interval_Module_GUI()

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'Global interval setting for spot groups';
            app.UIFigure.Icon = 'icon_48.png';

            % Create SpotListBox
            app.SpotListBox = uilistbox(app.UIFigure);
            app.SpotListBox.Items = {};
            app.SpotListBox.Multiselect = 'on';
            app.SpotListBox.ValueChangedFcn = createCallbackFcn(app, @SpotListBoxValueChanged, true);
            app.SpotListBox.Position = [24 21 224 433];
            app.SpotListBox.Value = {};

            % Create GlobalIntervalPanel
            app.GlobalIntervalPanel = uipanel(app.UIFigure);
            app.GlobalIntervalPanel.BorderType = 'none';
            app.GlobalIntervalPanel.Position = [329 99 243 235];

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.GlobalIntervalPanel);
            app.GridLayout2.ColumnWidth = {54, 26, 26, 26, 26, 28};
            app.GridLayout2.RowHeight = {26, 22, 22, 23, 25, 22, 22, 23};
            app.GridLayout2.ColumnSpacing = 6.29997907366071;
            app.GridLayout2.RowSpacing = 3.60000949435764;
            app.GridLayout2.Padding = [6.29997907366071 3.60000949435764 6.29997907366071 3.60000949435764];

            % Create MatrixUpperLimitPlusTenButton
            app.MatrixUpperLimitPlusTenButton = uibutton(app.GridLayout2, 'push');
            app.MatrixUpperLimitPlusTenButton.ButtonPushedFcn = createCallbackFcn(app, @MatrixUpperLimitPlusTenButtonPushed, true);
            app.MatrixUpperLimitPlusTenButton.Layout.Row = 7;
            app.MatrixUpperLimitPlusTenButton.Layout.Column = 6;
            app.MatrixUpperLimitPlusTenButton.Text = '+10';

            % Create MatrixUpperLimitPlusOneButton
            app.MatrixUpperLimitPlusOneButton = uibutton(app.GridLayout2, 'push');
            app.MatrixUpperLimitPlusOneButton.ButtonPushedFcn = createCallbackFcn(app, @MatrixUpperLimitPlusOneButtonPushed, true);
            app.MatrixUpperLimitPlusOneButton.Layout.Row = 7;
            app.MatrixUpperLimitPlusOneButton.Layout.Column = 5;
            app.MatrixUpperLimitPlusOneButton.Text = '+1';

            % Create MatrixLowerLimitPlusTenButton
            app.MatrixLowerLimitPlusTenButton = uibutton(app.GridLayout2, 'push');
            app.MatrixLowerLimitPlusTenButton.ButtonPushedFcn = createCallbackFcn(app, @MatrixLowerLimitPlusTenButtonPushed, true);
            app.MatrixLowerLimitPlusTenButton.Layout.Row = 6;
            app.MatrixLowerLimitPlusTenButton.Layout.Column = 6;
            app.MatrixLowerLimitPlusTenButton.Text = '+10';

            % Create MatrixLowerLimitPlusOneButton
            app.MatrixLowerLimitPlusOneButton = uibutton(app.GridLayout2, 'push');
            app.MatrixLowerLimitPlusOneButton.ButtonPushedFcn = createCallbackFcn(app, @MatrixLowerLimitPlusOneButtonPushed, true);
            app.MatrixLowerLimitPlusOneButton.Layout.Row = 6;
            app.MatrixLowerLimitPlusOneButton.Layout.Column = 5;
            app.MatrixLowerLimitPlusOneButton.Text = '+1';

            % Create MatrixUpperLimitMinusOneButton
            app.MatrixUpperLimitMinusOneButton = uibutton(app.GridLayout2, 'push');
            app.MatrixUpperLimitMinusOneButton.ButtonPushedFcn = createCallbackFcn(app, @MatrixUpperLimitMinusOneButtonPushed, true);
            app.MatrixUpperLimitMinusOneButton.Layout.Row = 7;
            app.MatrixUpperLimitMinusOneButton.Layout.Column = 3;
            app.MatrixUpperLimitMinusOneButton.Text = '-1';

            % Create MatrixLowerLimitMinusOneButton
            app.MatrixLowerLimitMinusOneButton = uibutton(app.GridLayout2, 'push');
            app.MatrixLowerLimitMinusOneButton.ButtonPushedFcn = createCallbackFcn(app, @MatrixLowerLimitMinusOneButtonPushed, true);
            app.MatrixLowerLimitMinusOneButton.Layout.Row = 6;
            app.MatrixLowerLimitMinusOneButton.Layout.Column = 3;
            app.MatrixLowerLimitMinusOneButton.Text = '-1';

            % Create MatrixUpperLimitMinusTenButton
            app.MatrixUpperLimitMinusTenButton = uibutton(app.GridLayout2, 'push');
            app.MatrixUpperLimitMinusTenButton.ButtonPushedFcn = createCallbackFcn(app, @MatrixUpperLimitMinusTenButtonPushed, true);
            app.MatrixUpperLimitMinusTenButton.Layout.Row = 7;
            app.MatrixUpperLimitMinusTenButton.Layout.Column = 2;
            app.MatrixUpperLimitMinusTenButton.Text = '-10';

            % Create MatrixLowerLimitMinusTenButton
            app.MatrixLowerLimitMinusTenButton = uibutton(app.GridLayout2, 'push');
            app.MatrixLowerLimitMinusTenButton.ButtonPushedFcn = createCallbackFcn(app, @MatrixLowerLimitMinusTenButtonPushed, true);
            app.MatrixLowerLimitMinusTenButton.Layout.Row = 6;
            app.MatrixLowerLimitMinusTenButton.Layout.Column = 2;
            app.MatrixLowerLimitMinusTenButton.Text = '-10';

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

            % Create BgUpperLimitPlusTenButton
            app.BgUpperLimitPlusTenButton = uibutton(app.GridLayout2, 'push');
            app.BgUpperLimitPlusTenButton.ButtonPushedFcn = createCallbackFcn(app, @BgUpperLimitPlusTenButtonPushed, true);
            app.BgUpperLimitPlusTenButton.Layout.Row = 3;
            app.BgUpperLimitPlusTenButton.Layout.Column = 6;
            app.BgUpperLimitPlusTenButton.Text = '+10';

            % Create BgUpperLimitPlusOneButton
            app.BgUpperLimitPlusOneButton = uibutton(app.GridLayout2, 'push');
            app.BgUpperLimitPlusOneButton.ButtonPushedFcn = createCallbackFcn(app, @BgUpperLimitPlusOneButtonPushed, true);
            app.BgUpperLimitPlusOneButton.Layout.Row = 3;
            app.BgUpperLimitPlusOneButton.Layout.Column = 5;
            app.BgUpperLimitPlusOneButton.Text = '+1';

            % Create BgUpperLimitMinusOneButton
            app.BgUpperLimitMinusOneButton = uibutton(app.GridLayout2, 'push');
            app.BgUpperLimitMinusOneButton.ButtonPushedFcn = createCallbackFcn(app, @BgUpperLimitMinusOneButtonPushed, true);
            app.BgUpperLimitMinusOneButton.Layout.Row = 3;
            app.BgUpperLimitMinusOneButton.Layout.Column = 3;
            app.BgUpperLimitMinusOneButton.Text = '-1';

            % Create BgUpperLimitMinusTenButton
            app.BgUpperLimitMinusTenButton = uibutton(app.GridLayout2, 'push');
            app.BgUpperLimitMinusTenButton.ButtonPushedFcn = createCallbackFcn(app, @BgUpperLimitMinusTenButtonPushed, true);
            app.BgUpperLimitMinusTenButton.Layout.Row = 3;
            app.BgUpperLimitMinusTenButton.Layout.Column = 2;
            app.BgUpperLimitMinusTenButton.Text = '-10';

            % Create UpperLimitLabel
            app.UpperLimitLabel = uilabel(app.GridLayout2);
            app.UpperLimitLabel.FontSize = 10;
            app.UpperLimitLabel.Layout.Row = 3;
            app.UpperLimitLabel.Layout.Column = 1;
            app.UpperLimitLabel.Text = 'Upper Limit:';

            % Create BgLowerLimitPlusTenButton
            app.BgLowerLimitPlusTenButton = uibutton(app.GridLayout2, 'push');
            app.BgLowerLimitPlusTenButton.ButtonPushedFcn = createCallbackFcn(app, @BgLowerLimitPlusTenButtonPushed, true);
            app.BgLowerLimitPlusTenButton.Layout.Row = 2;
            app.BgLowerLimitPlusTenButton.Layout.Column = 6;
            app.BgLowerLimitPlusTenButton.Text = '+10';

            % Create BgLowerLimitPlusOneButton
            app.BgLowerLimitPlusOneButton = uibutton(app.GridLayout2, 'push');
            app.BgLowerLimitPlusOneButton.ButtonPushedFcn = createCallbackFcn(app, @BgLowerLimitPlusOneButtonPushed, true);
            app.BgLowerLimitPlusOneButton.Layout.Row = 2;
            app.BgLowerLimitPlusOneButton.Layout.Column = 5;
            app.BgLowerLimitPlusOneButton.Text = '+1';

            % Create BgLowerLimitMinusOneButton
            app.BgLowerLimitMinusOneButton = uibutton(app.GridLayout2, 'push');
            app.BgLowerLimitMinusOneButton.ButtonPushedFcn = createCallbackFcn(app, @BgLowerLimitMinusOneButtonPushed, true);
            app.BgLowerLimitMinusOneButton.Layout.Row = 2;
            app.BgLowerLimitMinusOneButton.Layout.Column = 3;
            app.BgLowerLimitMinusOneButton.Text = '-1';

            % Create BgLowerLimitMinusTenButton
            app.BgLowerLimitMinusTenButton = uibutton(app.GridLayout2, 'push');
            app.BgLowerLimitMinusTenButton.ButtonPushedFcn = createCallbackFcn(app, @BgLowerLimitMinusTenButtonPushed, true);
            app.BgLowerLimitMinusTenButton.Layout.Row = 2;
            app.BgLowerLimitMinusTenButton.Layout.Column = 2;
            app.BgLowerLimitMinusTenButton.Text = '-10';

            % Create LowerLimitLabel
            app.LowerLimitLabel = uilabel(app.GridLayout2);
            app.LowerLimitLabel.FontSize = 10;
            app.LowerLimitLabel.Layout.Row = 2;
            app.LowerLimitLabel.Layout.Column = 1;
            app.LowerLimitLabel.Text = 'Lower Limit:';

            % Create BackgroundsLabel
            app.BackgroundsLabel = uilabel(app.GridLayout2);
            app.BackgroundsLabel.HorizontalAlignment = 'center';
            app.BackgroundsLabel.FontWeight = 'bold';
            app.BackgroundsLabel.Layout.Row = 1;
            app.BackgroundsLabel.Layout.Column = [1 6];
            app.BackgroundsLabel.Text = 'Backgrounds';

            % Create MatrixLabel
            app.MatrixLabel = uilabel(app.GridLayout2);
            app.MatrixLabel.HorizontalAlignment = 'center';
            app.MatrixLabel.FontWeight = 'bold';
            app.MatrixLabel.Layout.Row = 5;
            app.MatrixLabel.Layout.Column = [1 6];
            app.MatrixLabel.Text = 'Matrix';

            % Create ChooseButton
            app.ChooseButton = uibutton(app.UIFigure, 'push');
            app.ChooseButton.ButtonPushedFcn = createCallbackFcn(app, @ChooseButtonPushed, true);
            app.ChooseButton.Position = [538 421 52 27];
            app.ChooseButton.Text = 'Choose';

            % Create SpotnamecontainsEditFieldLabel
            app.SpotnamecontainsEditFieldLabel = uilabel(app.UIFigure);
            app.SpotnamecontainsEditFieldLabel.HorizontalAlignment = 'right';
            app.SpotnamecontainsEditFieldLabel.Position = [309 421 112 27];
            app.SpotnamecontainsEditFieldLabel.Text = 'Spotname contains:';

            % Create SpotnamecontainsEditField
            app.SpotnamecontainsEditField = uieditfield(app.UIFigure, 'text');
            app.SpotnamecontainsEditField.Position = [429 421 102 27];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Spot_Group_Interval_Submodule_readable(varargin)

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