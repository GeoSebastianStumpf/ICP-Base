% GENERATED from Table_builder_Submodule.mlapp on 2026-10-28 14:17 by export_mlapp_to_m. This file is for reading purposes, any real changes need to be applied to the .mlapp files and exported again.
classdef Table_builder_Submodule_readable < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        TableBuilderUIFigure           matlab.ui.Figure
        TabGroup                       matlab.ui.container.TabGroup
        DataselectionTab               matlab.ui.container.Tab
        ExcludeCalibratorsCheckBox     matlab.ui.control.CheckBox
        MajorsasoxideswtCheckBox       matlab.ui.control.CheckBox
        RemovemassesfromelementnameCheckBox  matlab.ui.control.CheckBox
        SimplePanel                    matlab.ui.container.Panel
        IfyouexportthetableorproceedtotheVisModulewithLabel  matlab.ui.control.Label
        AdvancedPanel                  matlab.ui.container.Panel
        SpotMetaTree                   matlab.ui.container.CheckBoxTree
        SelectionModeDropDown          matlab.ui.control.DropDown
        SelectionModeDropDownLabel     matlab.ui.control.Label
        ProceedtoVisModuleButton       matlab.ui.control.Button
        ExportcsvTableButton           matlab.ui.control.Button
        ProjectSessionTree             matlab.ui.container.CheckBoxTree
        LinescanstitchingoptionalTab   matlab.ui.container.Tab
        ImportstitchingconfigButton    matlab.ui.control.Button
        ExportstitchingconfigButton    matlab.ui.control.Button
        OffsetSlider                   matlab.ui.control.Slider
        RemovelaststitchButton         matlab.ui.control.Button
        StitchConfigUITable            matlab.ui.control.Table
        ExportstitchedtableButton      matlab.ui.control.Button
        ConfirmcurrentstitchButton     matlab.ui.control.Button
        logscaleCheckBox               matlab.ui.control.CheckBox
        MaxoverlapDatapointsEditField  matlab.ui.control.NumericEditField
        MaxoverlapDatapointsLabel      matlab.ui.control.Label
        UsedatafromButtonGroup         matlab.ui.container.ButtonGroup
        Embed2in1Button                matlab.ui.control.ToggleButton
        Embed1in2Button                matlab.ui.control.ToggleButton
        usels2Button                   matlab.ui.control.ToggleButton
        usels1Button                   matlab.ui.control.ToggleButton
        MoveRightButton                matlab.ui.control.Button
        MoveLeftButton                 matlab.ui.control.Button
        PlotButton                     matlab.ui.control.Button
        PlotLinescanButton             matlab.ui.control.Button
        ElementListBox                 matlab.ui.control.ListBox
        Linescan2EditField             matlab.ui.control.EditField
        Linescan2EditFieldLabel        matlab.ui.control.Label
        Linescan1EditField             matlab.ui.control.EditField
        Linescan1EditFieldLabel        matlab.ui.control.Label
        ContextMenu                    matlab.ui.container.ContextMenu
        ExportasmatMenu                matlab.ui.container.Menu
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
        sourceapp
        base

        Base_Table_for_stitching
        StitchFigure   % figure handle
        StitchAxes     % axes handle
        StitchLine1    % line handle for linescan 1
        StitchLine2    % line handle for linescan 2
        StitchElements 
        StitchN1
        StitchN2
        StitchOffset
        StitchConfig
    end


    methods (Access = private)

        %%%%% GUI functions %%%%%%

        function ResetTree(app,Tree2Update)
            if not(exist('Tree2Update','var'))
                Tree2Update=app.ProjectSessionTree;
            end

            %             if ~isempty(Tree2Update.SelectedNodes)
            %                 app.SelectedNodes_MainTree = Tree2Update.SelectedNodes.NodeData;
            %             end

            a = Tree2Update.Children;
            a.delete;
        end

        function update_project_session_tree(app)

            Tree2Update=app.ProjectSessionTree;

            ResetTree(app,app.ProjectSessionTree)

            base_struct = app.base;

            if ~isempty(base_struct)
                for i = 1:numel(base_struct)
                    % Top level: Project name
                    projectName = base_struct(i).project_name;
                    p0 = uitreenode(Tree2Update, 'Text', string(projectName)); %, 'NodeData', []

                    % Check if there are projects under this base
                    projects = base_struct(i).project;
                    if ~isempty(projects)
                        for j = 1:numel(projects)
                            % Check if 'session' field exists and is not empty
                            if isfield(projects(j), 'session') && ~isempty(projects(j).session)
                                sessions = projects(j).session;
                                for k = 1:numel(sessions)
                                    sessionName = sessions(k).session_name;
                                    p1 = uitreenode(p0, 'Text', string(sessionName), 'NodeData', [i, j]);
                                    % Add more levels here if needed
                                end
                            end
                        end
                    end
                end
            end


        end

        function update_spot_meta_tree(app)

            Tree2Update=app.SpotMetaTree;

            ResetTree(app, app.SpotMetaTree);
            Tree2Update = app.SpotMetaTree;

            % Get checked nodes from your project/session tree
            checkedNodes = app.ProjectSessionTree.CheckedNodes; % adjust name if needed

            if isempty(checkedNodes)
                return
            end

            %%%%%%%%%%%%%%%%%%% Metadata Node %%%%%%%%%%%%%%%%%%%%

            % Top-level nodes
            metaNode = uitreenode(Tree2Update, 'Text', "Metadata", 'NodeData', "Metadata");

            hasICP = false;
            hasLA = false;

            % Loop through checked sessions
            for n = 1:numel(checkedNodes)
                nodeData = checkedNodes(n).NodeData;
                if isempty(nodeData)
                    continue
                end
                if numel(nodeData) == 2 && nodeData(2) > 0
                    j = nodeData(1); k = nodeData(2);
                    session = app.base(j).project(k).session;
                    if isfield(session, 'meta')
                        if isfield(session.meta, 'icp_ms_parameters')
                            hasICP = true;
                        end
                        if isfield(session.meta, 'laser_parameters')
                            hasLA = true;
                        end
                    end
                end
            end

            if hasLA
                uitreenode(metaNode, 'Text', "LA parameters", 'NodeData', "LA parameters");
            end
            if hasICP
                uitreenode(metaNode, 'Text', "ICP-MS parameters", 'NodeData', "ICP-MS parameters");
            end

            %%%%%%%%%%%%%%%%%%% Quantification Node %%%%%%%%%%%%%%%%%%%%
            quantNode = uitreenode(Tree2Update, 'Text', "Quantification", 'NodeData', "Quantification");

            % Standard quantification children
            quantLabels = [...
                "Matrix/Host mass fractions", ...
                "Matrix/Host limits of detection" ...
                "Matrix/Host uncertainties (1σ)", ...
                "Matrix/Host counts-per-sweep", ...
                "Background counts-per-sweep", ...
                "Sensitivities" ...
                ];
            for q = 1:numel(quantLabels)
                uitreenode(quantNode, 'Text', quantLabels(q), 'NodeData', quantLabels(q));
            end

            % --- Only add Inclusion nodes if any checked session is Inclusion ---
            addInclusion = false;

            for n = 1:numel(checkedNodes)

                nodeData = checkedNodes(n).NodeData; % [j, k] indices for project, session
                if isempty(nodeData)
                    continue
                end
                if numel(nodeData) == 2 && nodeData(2) > 0
                    j = nodeData(1); k = nodeData(2);
                    session = app.base(j).project(k).session;
                    if isfield(session, 'config') && isfield(session.config, 'reductiontype') ...
                            && strcmp(session.config.reductiontype, "Inclusion")
                        addInclusion = true;
                        break;
                    end
                end
            end

            if addInclusion
                inclusionLabels = [...
                    "Host-Inclusion-unmixing" ...
                    "Inclusion mass fractions", ...
                    "Inclusion limits of detection", ...
                    "Inclusion uncertainties (1σ)", ...
                    "Inclusion counts-per-sweep", ...
                    "Mix mass fractions", ...
                    "Mix counts-per-sweep", ...
                    ];
                for q = 1:numel(inclusionLabels)
                    uitreenode(quantNode, 'Text', inclusionLabels(q), 'NodeData', inclusionLabels(q));
                end
            end

        end



        %%%%% Table building functions %%%%%%

        function Base_Table = build_assigned_table_from_base(app)
            % --- Get checked nodes from SpotMetaTree ---
            checkedMetaNodes = app.SpotMetaTree.CheckedNodes;
            if isempty(checkedMetaNodes)
                Base_Table = table();
                return
            end
            checkedMetaLabels = string({checkedMetaNodes.NodeData}); % assumes NodeData is string or char

            % Respect current UI behavior, but apply mass removal session-by-session inside this function
            removeMassesPerSession = false;
            if isprop(app, 'RemovemassesfromelementnameCheckBox')
                removeMassesPerSession = logical(app.RemovemassesfromelementnameCheckBox.Value);
            end

            % Helper to check if a label is checked
            isChecked = @(label) any(checkedMetaLabels == label);

            % --- Always needed: Metadata ---
            allProjects = {};
            allSessions = {};
            allComments = {};
            allAnalysts = {};
            allProcessors = {};
            allSpotnames = {};
            alldates = {};
            dynamicMetaData = struct();

            allTypes = {};
            allRefMaterials = {};
            allIntTimePoints = {};
            allusedBracket_id = {};

            % Host-Inclusion-unmixing
            allUnmixingVia = {};
            allMatrixOnlyTracer = {};
            allMatrixFromSpot = {};

            % Sensitivities
            allSensitivitiesRows = {};
            % Matrix/Host mass fractions
            allmatrixcompRows = {};
            % Inclusion mass fractions
            allinclcompRows = {};
            % Matrix/Host limits of detection
            allmatrixlodRows = {};
            % Inclusion limits of detection
            allincllodRows = {};
            % Mix mass fractions
            allmixcompRows = {};
            % Matrix/Host uncertainties (1σ)
            allmatrixuncRows = {};
            % Inclusion uncertainties (1σ)
            allincluncRows = {};

            % cps
            allbkgdCpsRows_mat = {};
            allbkgdCpsRows_incl = {};
            allbkgdCpsRows_mix = {};
            allbkgdCpsRows_bg = {};

            % LA parameters
            allLaserParamTables = {};
            % ICP-MS parameters
            allICPMSParamTables = {};

            % Get checked nodes from the project/session tree
            checkedNodes = app.ProjectSessionTree.CheckedNodes;
            checkedIndices = [];
            for n = 1:numel(checkedNodes)
                nodeData = checkedNodes(n).NodeData;
                if ~isempty(nodeData) && numel(nodeData) == 2 && nodeData(2) > 0
                    checkedIndices = [checkedIndices; nodeData];
                end
            end

            % Pre-scan selected sessions to find all dynamic metadata fields and reductiontype
            for i = 1:numel(app.base)
                for j = 1:numel(app.base(i).project)
                    if isempty(checkedIndices) || ~ismember([i, j], checkedIndices, 'rows')
                        continue
                    end
                    if ~isfield(app.base(i).project(j), 'session')
                        continue
                    end

                    pre_skel = app.sourceapp.base(i).project(j).session;

                    % Skip incomplete sessions without loading
                    if isfield(pre_skel, 'config') && isfield(pre_skel.config, 'module_status')
                        if any(structfun(@(x) x == 0, pre_skel.config.module_status))
                            continue
                        end
                    end

                    pre_needed = ~pre_skel.config.loaded;

                    if pre_needed
                        try
                            h52session(app.sourceapp, i, j);
                        catch
                            continue
                        end
                        session = app.sourceapp.base(i).project(j).session;
                    else
                        session = pre_skel;
                    end

                    % Discover dynamic per-spot metadata fields
                    if isfield(session, 'spot') && ~isempty(session.spot)
                        nSpots = numel(session.spot.name);
                        if isfield(session, 'meta') && isstruct(session.meta)
                            metaFields = fieldnames(session.meta);
                            for f = 1:numel(metaFields)
                                fieldName = metaFields{f};
                                fieldData = session.meta.(fieldName);
                                if (iscell(fieldData) || isstring(fieldData) || isnumeric(fieldData)) && numel(fieldData) == nSpots
                                    if ~isfield(dynamicMetaData, fieldName)
                                        dynamicMetaData.(fieldName) = {};
                                    end
                                end
                            end
                        end
                    end

                    if pre_needed
                        enriched = pre_skel;
                        if isfield(session.config, 'reductiontype')
                            enriched.config.reductiontype = session.config.reductiontype;
                        end

                        app.sourceapp.base(i).project(j).session = enriched;
                        app.base(i).project(j).session = enriched;
                    end
                end
            end

            dynamicMetaFields = fieldnames(dynamicMetaData);
            missingAssignmentSessions = {};

            for i = 1:numel(app.base)
                projectName = app.base(i).project_name;

                for j = 1:numel(app.base(i).project)
                    if isempty(checkedIndices) || ~ismember([i, j], checkedIndices, 'rows')
                        continue
                    end

                    if ~isfield(app.base(i).project(j), 'session')
                        continue
                    end

                    skel = app.sourceapp.base(i).project(j).session;

                    % module_status in skeleton — check before loading
                    if isfield(skel, 'config') && isfield(skel.config, 'module_status')
                        if any(structfun(@(x) x == 0, skel.config.module_status))
                            continue
                        end
                    end

                    needed_load = ~skel.config.loaded;
                    if needed_load
                        try
                            h52session(app.sourceapp, i, j);
                        catch ME
                            DisplayError(ME, 'Failed to load session for table building');
                            continue
                        end
                        session = app.sourceapp.base(i).project(j).session;
                        if ~skel.config.synced
                            session.session_name = skel.session_name;
                            if isfield(skel, 'meta')
                                for fn = ["session_comment", "date", "analyst", "processed_by"]
                                    if isfield(skel.meta, char(fn))
                                        session.meta.(char(fn)) = skel.meta.(char(fn));
                                    end
                                end
                            end
                        end
                    else
                        session = skel;
                    end

                    % Session meta
                    if isfield(session, 'session_name') && ~isempty(session.session_name)
                        sessionName = char(session.session_name);
                    else
                        sessionName = '';
                    end

                    if isfield(session, 'meta') && isfield(session.meta, 'date') && ~isempty(session.meta.date)
                        sessiondate = session.meta.date;
                    else
                        sessiondate = '';
                    end

                    if isfield(session, 'meta') && isfield(session.meta, 'session_comment') && ~isempty(session.meta.session_comment)
                        sessionComment = char(session.meta.session_comment);
                    else
                        sessionComment = '';
                    end

                    if isfield(session, 'meta') && isfield(session.meta, 'analyst') && ~isempty(session.meta.analyst)
                        analyst = char(session.meta.analyst);
                    else
                        analyst = '';
                    end

                    if isfield(session, 'meta') && isfield(session.meta, 'processed_by') && ~isempty(session.meta.processed_by)
                        processed_by = char(session.meta.processed_by);
                    else
                        processed_by = '';
                    end

                    % Spot block
                    if ~isfield(session, 'spot') || isempty(session.spot)
                        if needed_load
                            app.sourceapp.base(i).project(j).session = skel;
                        end
                        continue
                    end

                    spotnames = session.spot.name;
                    nSpots = numel(spotnames);

                    % Require analyte_calibrator_assignment in selected sessions
                    if ~isfield(session.spot, 'analyte_calibrator_assignment') || ...
                            isempty(session.spot.analyte_calibrator_assignment)

                        sessionLabel = sessionName;

                        missingAssignmentSessions{end+1,1} = [char(projectName) ' / ' sessionLabel];
                        if needed_load
                            app.sourceapp.base(i).project(j).session = skel;
                        end
                        continue
                    end

                    assignments = session.spot.analyte_calibrator_assignment;
                    [assignmentMap, assignedCalNames] = buildAnalyteCalMap(app, assignments);

                    % --- Extract dynamic metadata for current session ---
                    sessionDynamicData = struct();
                    for f = 1:numel(dynamicMetaFields)
                        fieldName = dynamicMetaFields{f};
                        if isfield(session, 'meta') && isfield(session.meta, fieldName) && ~isempty(session.meta.(fieldName))
                            sessionDynamicData.(fieldName) = session.meta.(fieldName)(:);
                        else
                            sessionDynamicData.(fieldName) = repmat({''}, nSpots, 1);
                        end
                    end

                    % Type and CALs (backward compatibility, local only)
                    if isfield(session.spot, 'type') && ~isempty(session.spot.type)
                        type = string(session.spot.type(:));
                    else
                        type = strings(nSpots, 1);
                    end
                    type(type == "PRM") = "CAL";
                    type(type == "SRM") = "QCRM";

                    if isfield(session.spot, 'referencematerial') && ~isempty(session.spot.referencematerial)
                        referencematerial = string(session.spot.referencematerial(:));
                    else
                        referencematerial = strings(nSpots, 1);
                    end

                    % Session-local CAL list
                    cal_indices = (type == "CAL");
                    if any(cal_indices)
                        cal_materials = referencematerial(cal_indices);
                        validCALs = unique(cal_materials); % no 'stable' by design
                        validCALs = validCALs(~strcmp(validCALs, "None"));
                        validCALs = validCALs(~strcmp(validCALs, "Select Reference Material"));
                    else
                        validCALs = string.empty(0,1);
                    end

                    % Bracket IDs
                    if isfield(session.spot, 'bracket_id') && ~isempty(session.spot.bracket_id)
                        bracket_id = session.spot.bracket_id(:);
                        if ~isnumeric(bracket_id)
                            bracket_id = zeros(nSpots,1);
                        end
                        uniqueBracketIds = unique(bracket_id);
                        uniqueBracketIds = uniqueBracketIds(uniqueBracketIds ~= 0);
                    else
                        uniqueBracketIds = [];
                    end

                    % Integer time points
                    if isfield(session.spot, 'integer_time_points') && ~isempty(session.spot.integer_time_points)
                        integer_time_points = session.spot.integer_time_points(:);
                        if ~isnumeric(integer_time_points)
                            integer_time_points = NaN(nSpots,1);
                        end
                    else
                        integer_time_points = NaN(nSpots,1);
                    end

                    % Analyte names
                    if isfield(session.spot, 'analytes') && ~isempty(session.spot.analytes)
                        analyteNames = strtrim(string(session.spot.analytes(:)));
                    else
                        analyteNames = strings(0,1);
                    end

                    % Session-specific preferred isotopes (used only when remove masses is enabled)
                    sessionPreferredIsoMap = containers.Map('KeyType', 'char', 'ValueType', 'char');
                    if removeMassesPerSession
                        sessionPreferredIsoMap = getSessionPreferredIsotopeMap(app, session);
                    end

                    % If no CALs or no brackets, skip session
                    if isempty(validCALs) || isempty(uniqueBracketIds)
                        if needed_load
                            app.sourceapp.base(i).project(j).session = skel;
                        end
                        continue
                    end

                    % If all assigned analytes point to one CAL, metadata can be resolved.
                    % Otherwise these CAL-dependent metadata columns are ambiguous and filled with defaults.
                    singleAssignedCalIdx = [];
                    if numel(assignedCalNames) == 1
                        onlyCal = char(assignedCalNames(1));
                        singleAssignedCalIdx = find(strcmp(validCALs, onlyCal), 1);
                    end

                    % --- Only process blocks if checked in SpotMetaTree ---

                    % LA parameters
                    laserParamTable = table();
                    if isChecked("LA parameters")
                        if isfield(session, 'meta') && isfield(session.meta, 'laser_parameters')
                            laserParamStruct = session.meta.laser_parameters;
                            laserParamTable = struct_to_table(app, laserParamStruct);
                        else
                            laserParamTable = table();
                        end
                    end

                    % ICP-MS parameters
                    ICPMSParamTable = table();
                    if isChecked("ICP-MS parameters")
                        if isfield(session, 'meta') && isfield(session.meta, 'icp_ms_parameters')
                            ICPMSParamStruct = session.meta.icp_ms_parameters;
                            ICPMSParamTable = struct_to_table(app, ICPMSParamStruct);
                        else
                            ICPMSParamTable = table();
                        end
                    end

                    % Sensitivities
                    if isChecked("Sensitivities")
                        if isfield(session.spot, 'cal_sensitivities')
                            cal_sensitivities = session.spot.cal_sensitivities;
                        elseif isfield(session.spot, 'prm_sensitivities')
                            cal_sensitivities = session.spot.prm_sensitivities;
                        else
                            cal_sensitivities = table();
                        end
                        sensitivities = getNestedTable(app, session.spot, 'sensitivities', uniqueBracketIds, validCALs, nSpots, analyteNames);

                        % Apply cal_sensitivities patches to all CAL tables (same behavior as before)
                        if ~isempty(cal_sensitivities) && istable(cal_sensitivities)
                            for b = 1:numel(uniqueBracketIds)
                                for p = 1:numel(validCALs)
                                    sens_tbl = ensureAnalyteTable(app, sensitivities{b,p}, analyteNames, nSpots);
                                    common_cols = intersect(sens_tbl.Properties.VariableNames, cal_sensitivities.Properties.VariableNames);
                                    if ~isempty(common_cols)
                                        nRowsCommon = min(height(sens_tbl), height(cal_sensitivities));
                                        if nRowsCommon > 0
                                            nonzero_rows = any(table2array(cal_sensitivities(1:nRowsCommon, :)) ~= 0, 2);
                                            idxRows = find(nonzero_rows);
                                            for cc = 1:numel(common_cols)
                                                colName = common_cols{cc};
                                                sens_tbl{idxRows, colName} = cal_sensitivities{idxRows, colName};
                                            end
                                        end
                                    end
                                    sensitivities{b,p} = sens_tbl;
                                end
                            end
                        end
                    end

                    % Matrix/Host mass fractions
                    if isChecked("Matrix/Host mass fractions")
                        matrix_composition = getNestedTable(app, session.spot, 'matrix_composition', uniqueBracketIds, validCALs, nSpots, analyteNames);
                    end

                    % Matrix/Host limits of detection
                    if isChecked("Matrix/Host limits of detection") || isChecked("Matrix/Host mass fractions")
                        matrix_limits_of_detection = getNestedTable(app, session.spot, 'matrix_limits_of_detection', uniqueBracketIds, validCALs, nSpots, analyteNames);
                    end

                    % Inclusion blocks
                    if isChecked("Inclusion mass fractions")
                        inclusion_composition = getNestedTable(app, session.spot, 'inclusion_composition', uniqueBracketIds, validCALs, nSpots, analyteNames);
                    end
                    if isChecked("Inclusion limits of detection") || isChecked("Inclusion mass fractions") || isChecked("Mix mass fractions")
                        inclusion_limits_of_detection = getNestedTable(app, session.spot, 'inclusion_limits_of_detection', uniqueBracketIds, validCALs, nSpots, analyteNames);
                    end
                    if isChecked("Mix mass fractions")
                        mix_composition = getNestedTable(app, session.spot, 'mix_composition', uniqueBracketIds, validCALs, nSpots, analyteNames);
                    end
                    % Matrix/Host uncertainties (1σ)
                    if isChecked("Matrix/Host uncertainties (1σ)")
                        matrix_composition_uncertainty = getNestedTable(app, session.spot, 'matrix_composition_uncertainty', uniqueBracketIds, validCALs, nSpots, analyteNames);
                    end

                    % Inclusion uncertainties (1σ)
                    if isChecked("Inclusion uncertainties (1σ)")
                        inclusion_composition_uncertainty = getNestedTable(app, session.spot, 'inclusion_composition_uncertainty', uniqueBracketIds, validCALs, nSpots, analyteNames);
                    end

                    % Mixing ratios / unmixing metadata
                    if isChecked("Host-Inclusion-unmixing")

                        if isfield(session.spot, 'unmixing_via') && ~isempty(session.spot.unmixing_via)
                            unmixing_via = string(session.spot.unmixing_via(:));
                        else
                            unmixing_via = repmat("", nSpots, 1);
                        end
                        if isfield(session.spot, 'matrix_only_tracer') && ~isempty(session.spot.matrix_only_tracer)
                            matrix_only_tracer = string(session.spot.matrix_only_tracer(:));
                        else
                            matrix_only_tracer = repmat("", nSpots, 1);
                        end
                        if isfield(session.spot, 'matrix_from_spot') && ~isempty(session.spot.matrix_from_spot)
                            matrix_from_spot = string(session.spot.matrix_from_spot(:));
                        else
                            matrix_from_spot = repmat("", nSpots, 1);
                        end
                    end

                    % cps
                    if isfield(session.spot, 'bkgd_corrected_cps')
                        bkgdCps_mat = session.spot.bkgd_corrected_cps;
                    else
                        bkgdCps_mat = table('Size', [nSpots, numel(analyteNames)], ...
                            'VariableTypes', repmat("double", 1, numel(analyteNames)), ...
                            'VariableNames', cellstr(analyteNames));
                    end

                    if isChecked("Background counts-per-sweep")
                        if isfield(session.spot, 'background_cps')
                            bkgdCps_bg = session.spot.background_cps;
                        else
                            bkgdCps_bg = array2table(zeros(nSpots, numel(analyteNames)), ...
                                'VariableNames', cellstr(analyteNames));
                        end
                    end

                    if isChecked("Inclusion counts-per-sweep")
                        if isfield(session.spot, 'bkgd_corrected_cps_incl')
                            bkgdCps_incl = session.spot.bkgd_corrected_cps_incl;
                        else
                            bkgdCps_incl = array2table(zeros(nSpots, numel(analyteNames)), ...
                                'VariableNames', cellstr(analyteNames));
                        end
                    end

                    if isChecked("Mix counts-per-sweep")
                        if isfield(session.spot, 'bkgd_corrected_cps_mix')
                            bkgdCps_mix = session.spot.bkgd_corrected_cps_mix;
                        else
                            bkgdCps_mix = array2table(zeros(nSpots, numel(analyteNames)), ...
                                'VariableNames', cellstr(analyteNames));
                        end
                    end

                    % --- Core logic ---
                    % Rows are duplicated only by bracket and spot.
                    % CAL selection for analyte values is analyte-wise from analyte_calibrator_assignment.
                    for b = 1:numel(uniqueBracketIds)
                        % Metadata rows (nSpots per bracket)
                        for k = 1:nSpots
                            allProjects{end+1,1} = projectName;
                            allSessions{end+1,1} = sessionName;
                            allComments{end+1,1} = sessionComment;
                            allAnalysts{end+1,1} = analyst;
                            allProcessors{end+1,1} = processed_by;
                            alldates{end+1,1} = sessiondate;
                            allSpotnames{end+1,1} = spotnames(k);

                            for f = 1:numel(dynamicMetaFields)
                                fieldName = dynamicMetaFields{f};
                                currentColumn = sessionDynamicData.(fieldName);
                                if numel(currentColumn) >= k
                                    if iscell(currentColumn)
                                        dynamicMetaData.(fieldName){end+1,1} = currentColumn{k};
                                    else
                                        dynamicMetaData.(fieldName){end+1,1} = currentColumn(k);
                                    end
                                else
                                    dynamicMetaData.(fieldName){end+1,1} = '';
                                end
                            end

                            if numel(type) >= k && ~ismissing(type(k))
                                allTypes{end+1,1} = type(k);
                            else
                                allTypes{end+1,1} = "";
                            end

                            if numel(referencematerial) >= k && ~ismissing(referencematerial(k))
                                allRefMaterials{end+1,1} = referencematerial(k);
                            else
                                allRefMaterials{end+1,1} = "";
                            end

                            allIntTimePoints{end+1,1} = integer_time_points(k);
                            allusedBracket_id{end+1,1} = uniqueBracketIds(b);

                            if isChecked("Host-Inclusion-unmixing")
                                if numel(unmixing_via) >= k
                                    allUnmixingVia{end+1,1} = unmixing_via(k);
                                else
                                    allUnmixingVia{end+1,1} = "";
                                end
                                if numel(matrix_only_tracer) >= k
                                    allMatrixOnlyTracer{end+1,1} = matrix_only_tracer(k);
                                else
                                    allMatrixOnlyTracer{end+1,1} = "";
                                end
                                if numel(matrix_from_spot) >= k
                                    allMatrixFromSpot{end+1,1} = matrix_from_spot(k);
                                else
                                    allMatrixFromSpot{end+1,1} = "";
                                end
                            end
                        end

                        % Numeric blocks per bracket using analyte-level CAL assignment
                        if isChecked("Sensitivities")
                            sensTblAssigned = buildAssignedAnalyteTable(app, sensitivities, b, assignmentMap, validCALs, analyteNames, nSpots);
                            sensTblAssigned = ensureAnalyteTable(app, sensTblAssigned, analyteNames, nSpots);
                            if removeMassesPerSession
                                sensTblAssigned = collapseIsotopeColumnsForSession(app, sensTblAssigned, sessionPreferredIsoMap);
                            end
                            allSensitivitiesRows{end+1,1} = sensTblAssigned;
                        end

                        if isChecked("Matrix/Host mass fractions")
                            matrixCompAssigned = buildAssignedAnalyteTable(app, matrix_composition, b, assignmentMap, validCALs, analyteNames, nSpots);
                            matrixCompAssigned = ensureAnalyteTable(app, matrixCompAssigned, analyteNames, nSpots);
                            if removeMassesPerSession
                                matrixCompAssigned = collapseIsotopeColumnsForSession(app, matrixCompAssigned, sessionPreferredIsoMap);
                            end
                            allmatrixcompRows{end+1,1} = matrixCompAssigned;
                        end

                        if isChecked("Matrix/Host limits of detection") || isChecked("Matrix/Host mass fractions")
                            matrixLodAssigned = buildAssignedAnalyteTable(app, matrix_limits_of_detection, b, assignmentMap, validCALs, analyteNames, nSpots);
                            matrixLodAssigned = ensureAnalyteTable(app, matrixLodAssigned, analyteNames, nSpots);
                            if removeMassesPerSession
                                matrixLodAssigned = collapseIsotopeColumnsForSession(app, matrixLodAssigned, sessionPreferredIsoMap);
                            end
                            allmatrixlodRows{end+1,1} = matrixLodAssigned;
                        end

                        if isChecked("Inclusion mass fractions")
                            inclusionCompAssigned = buildAssignedAnalyteTable(app, inclusion_composition, b, assignmentMap, validCALs, analyteNames, nSpots);
                            inclusionCompAssigned = ensureAnalyteTable(app, inclusionCompAssigned, analyteNames, nSpots);
                            if removeMassesPerSession
                                inclusionCompAssigned = collapseIsotopeColumnsForSession(app, inclusionCompAssigned, sessionPreferredIsoMap);
                            end
                            allinclcompRows{end+1,1} = inclusionCompAssigned;
                        end

                        if isChecked("Inclusion limits of detection") || isChecked("Inclusion mass fractions") || isChecked("Mix mass fractions")
                            inclusionLodAssigned = buildAssignedAnalyteTable(app, inclusion_limits_of_detection, b, assignmentMap, validCALs, analyteNames, nSpots);
                            inclusionLodAssigned = ensureAnalyteTable(app, inclusionLodAssigned, analyteNames, nSpots);
                            if removeMassesPerSession
                                inclusionLodAssigned = collapseIsotopeColumnsForSession(app, inclusionLodAssigned, sessionPreferredIsoMap);
                            end
                            allincllodRows{end+1,1} = inclusionLodAssigned;
                        end

                        if isChecked("Mix mass fractions")
                            mixCompAssigned = buildAssignedAnalyteTable(app, mix_composition, b, assignmentMap, validCALs, analyteNames, nSpots);
                            mixCompAssigned = ensureAnalyteTable(app, mixCompAssigned, analyteNames, nSpots);
                            if removeMassesPerSession
                                mixCompAssigned = collapseIsotopeColumnsForSession(app, mixCompAssigned, sessionPreferredIsoMap);
                            end
                            allmixcompRows{end+1,1} = mixCompAssigned;
                        end
                        if isChecked("Matrix/Host uncertainties (1σ)")
                            matrixUncAssigned = buildAssignedAnalyteTable(app, matrix_composition_uncertainty, b, assignmentMap, validCALs, analyteNames, nSpots);
                            matrixUncAssigned = ensureAnalyteTable(app, matrixUncAssigned, analyteNames, nSpots);
                            matrixUncAssigned{:, :} = abs(matrixUncAssigned{:, :});   % matrix sigma carries the sign of the mass fraction
                            if removeMassesPerSession
                                matrixUncAssigned = collapseIsotopeColumnsForSession(app, matrixUncAssigned, sessionPreferredIsoMap);
                            end
                            allmatrixuncRows{end+1,1} = matrixUncAssigned;
                        end

                        if isChecked("Inclusion uncertainties (1σ)")
                            inclusionUncAssigned = buildAssignedAnalyteTable(app, inclusion_composition_uncertainty, b, assignmentMap, validCALs, analyteNames, nSpots);
                            inclusionUncAssigned = ensureAnalyteTable(app, inclusionUncAssigned, analyteNames, nSpots);
                            inclusionUncAssigned{:, :} = abs(inclusionUncAssigned{:, :});
                            if removeMassesPerSession
                                inclusionUncAssigned = collapseIsotopeColumnsForSession(app, inclusionUncAssigned, sessionPreferredIsoMap);
                            end
                            allincluncRows{end+1,1} = inclusionUncAssigned;
                        end

                        % cps
                        bkgdTblMat = ensureAnalyteTable(app, bkgdCps_mat, analyteNames, nSpots);
                        if removeMassesPerSession
                            bkgdTblMat = collapseIsotopeColumnsForSession(app, bkgdTblMat, sessionPreferredIsoMap);
                        end
                        allbkgdCpsRows_mat{end+1,1} = bkgdTblMat;

                        if isChecked("Inclusion counts-per-sweep")
                            bkgdTblIncl = ensureAnalyteTable(app, bkgdCps_incl, analyteNames, nSpots);
                            if removeMassesPerSession
                                bkgdTblIncl = collapseIsotopeColumnsForSession(app, bkgdTblIncl, sessionPreferredIsoMap);
                            end
                            allbkgdCpsRows_incl{end+1,1} = bkgdTblIncl;
                        end
                        if isChecked("Mix counts-per-sweep")
                            bkgdTblMix = ensureAnalyteTable(app, bkgdCps_mix, analyteNames, nSpots);
                            if removeMassesPerSession
                                bkgdTblMix = collapseIsotopeColumnsForSession(app, bkgdTblMix, sessionPreferredIsoMap);
                            end
                            allbkgdCpsRows_mix{end+1,1} = bkgdTblMix;
                        end
                        if isChecked("Background counts-per-sweep")
                            bkgdTblBg = ensureAnalyteTable(app, bkgdCps_bg, analyteNames, nSpots);
                            if removeMassesPerSession
                                bkgdTblBg = collapseIsotopeColumnsForSession(app, bkgdTblBg, sessionPreferredIsoMap);
                            end
                            allbkgdCpsRows_bg{end+1,1} = bkgdTblBg;
                        end

                        % LA/ICP parameter tables (one per bracket)
                        if isChecked("LA parameters")
                            allLaserParamTables{end+1,1} = laserParamTable;
                        end
                        if isChecked("ICP-MS parameters")
                            allICPMSParamTables{end+1,1} = ICPMSParamTable;
                        end
                    end
                    if needed_load
                        app.sourceapp.base(i).project(j).session = skel;
                    end
                end
            end

            if ~isempty(missingAssignmentSessions)
                missingAssignmentSessions = unique(missingAssignmentSessions);

                if numel(missingAssignmentSessions) == 1
                    msg = sprintf(['The analyte_calibrator_assignment is missing in session:\n\n%s\n\n' ...
                        'This session was skipped.'], missingAssignmentSessions{1});
                else
                    msg = sprintf(['The analyte_calibrator_assignment is missing in these sessions:\n\n%s\n\n' ...
                        'These sessions were skipped.'], strjoin(missingAssignmentSessions, newline));
                end

                uialert(app.TableBuilderUIFigure, msg, ...
                    'Missing analyte-calibrator assignment', ...
                    'Icon', 'warning');
            end

            % --- Build Metadata Table (always included) ---
            Metadata_Table = table(allProjects, allSessions, allComments, allAnalysts, allProcessors, alldates, allSpotnames, ...
                allTypes, allRefMaterials, allIntTimePoints, allusedBracket_id, ...
                'VariableNames', {'Project', 'Session', 'Comment','Analyst', 'Processed by', 'Date', 'Spotname', ...
                'Type', 'Reference_Material', 'Integer_Time_Points', 'used_bracket_id'});

            % Add dynamic metadata columns
            for f = 1:numel(dynamicMetaFields)
                fieldName = dynamicMetaFields{f};
                Metadata_Table.(fieldName) = dynamicMetaData.(fieldName);
            end

            if isChecked("Host-Inclusion-unmixing")
                Metadata_Table.Unmixing_Via = allUnmixingVia;
                Metadata_Table.Matrix_Only_Tracer = allMatrixOnlyTracer;
                Metadata_Table.Matrix_From_Spot = allMatrixFromSpot;
            end

            % --- Build selected numeric/parameter blocks ---
            tableBlocks = {Metadata_Table};

            if isChecked("Matrix/Host mass fractions")
                allmatrixlodTable = buildNumericBlock(app, allmatrixlodRows, 'Matrix_LOD');
                allmatrixlodTable = renameAnalyteColumns(app, allmatrixlodTable, '_mat_lod');
                if ismember('Data_Source', allmatrixlodTable.Properties.VariableNames)
                    allmatrixlodTable.Data_Source = [];
                end

                allmatrixcompTable = buildNumericBlock(app, allmatrixcompRows, 'Matrix_Composition');
                allmatrixcompTable = renameAnalyteColumns(app, allmatrixcompTable, '_mat_ugg');
                if ismember('Data_Source', allmatrixcompTable.Properties.VariableNames)
                    allmatrixcompTable.Data_Source = [];
                end

                allmatrixcompTable = applyLODFiltering(app, allmatrixcompTable, allmatrixlodTable, '_mat_ugg', '_mat_lod');
                tableBlocks{end+1} = allmatrixcompTable;
            end

            if isChecked("Matrix/Host uncertainties (1σ)")
                allmatrixuncTable = buildNumericBlock(app, allmatrixuncRows, 'Matrix_Uncertainty');
                allmatrixuncTable = renameAnalyteColumns(app, allmatrixuncTable, '_mat_unc');
                if ismember('Data_Source', allmatrixuncTable.Properties.VariableNames)
                    allmatrixuncTable.Data_Source = [];
                end
                tableBlocks{end+1} = allmatrixuncTable;
            end

            if isChecked("Inclusion mass fractions")
                allinclusionlodTable = buildNumericBlock(app, allincllodRows, 'Inclusion_LOD');
                allinclusionlodTable = renameAnalyteColumns(app, allinclusionlodTable, '_incl_lod');
                if ismember('Data_Source', allinclusionlodTable.Properties.VariableNames)
                    allinclusionlodTable.Data_Source = [];
                end

                allinclusioncompTable = buildNumericBlock(app, allinclcompRows, 'Inclusion_Composition');
                allinclusioncompTable = renameAnalyteColumns(app, allinclusioncompTable, '_incl_ugg');
                if ismember('Data_Source', allinclusioncompTable.Properties.VariableNames)
                    allinclusioncompTable.Data_Source = [];
                end

                allinclusioncompTable = applyLODFiltering(app, allinclusioncompTable, allinclusionlodTable, '_incl_ugg', '_incl_lod');
                tableBlocks{end+1} = allinclusioncompTable;
            end

            if isChecked("Inclusion uncertainties (1σ)")
                allinclusionuncTable = buildNumericBlock(app, allincluncRows, 'Inclusion_Uncertainty');
                allinclusionuncTable = renameAnalyteColumns(app, allinclusionuncTable, '_incl_unc');
                if ismember('Data_Source', allinclusionuncTable.Properties.VariableNames)
                    allinclusionuncTable.Data_Source = [];
                end
                tableBlocks{end+1} = allinclusionuncTable;
            end

            if isChecked("Mix mass fractions")
                allinclusionlodTable = buildNumericBlock(app, allincllodRows, 'Inclusion_LOD');
                allinclusionlodTable = renameAnalyteColumns(app, allinclusionlodTable, '_incl_lod');
                if ismember('Data_Source', allinclusionlodTable.Properties.VariableNames)
                    allinclusionlodTable.Data_Source = [];
                end

                allmixcompTable = buildNumericBlock(app, allmixcompRows, 'Mix_Composition');
                allmixcompTable = renameAnalyteColumns(app, allmixcompTable, '_mix_ugg');
                if ismember('Data_Source', allmixcompTable.Properties.VariableNames)
                    allmixcompTable.Data_Source = [];
                end

                allmixcompTable = applyLODFiltering(app, allmixcompTable, allinclusionlodTable, '_mix_ugg', '_incl_lod');
                tableBlocks{end+1} = allmixcompTable;
            end

            if isChecked("Matrix/Host limits of detection")
                allmatrixlodTable = buildNumericBlock(app, allmatrixlodRows, 'Matrix_LOD');
                allmatrixlodTable = renameAnalyteColumns(app, allmatrixlodTable, '_mat_lod');
                if ismember('Data_Source', allmatrixlodTable.Properties.VariableNames)
                    allmatrixlodTable.Data_Source = [];
                end
                tableBlocks{end+1} = allmatrixlodTable;
            end

            if isChecked("Inclusion limits of detection")
                allinclusionlodTable = buildNumericBlock(app, allincllodRows, 'Inclusion_LOD');
                allinclusionlodTable = renameAnalyteColumns(app, allinclusionlodTable, '_incl_lod');
                if ismember('Data_Source', allinclusionlodTable.Properties.VariableNames)
                    allinclusionlodTable.Data_Source = [];
                end
                tableBlocks{end+1} = allinclusionlodTable;
            end

            if isChecked("Matrix/Host counts-per-sweep")
                allbkgdCpsTable_mat = buildNumericBlock(app, allbkgdCpsRows_mat, 'Bkgd_Corrected_CPS_mat');
                allbkgdCpsTable_mat = renameAnalyteColumns(app, allbkgdCpsTable_mat, '_mat_cps');
                if ismember('Data_Source', allbkgdCpsTable_mat.Properties.VariableNames)
                    allbkgdCpsTable_mat.Data_Source = [];
                end
                tableBlocks{end+1} = allbkgdCpsTable_mat;
            end

            if isChecked("Inclusion counts-per-sweep")
                allbkgdCpsTable_incl = buildNumericBlock(app, allbkgdCpsRows_incl, 'Bkgd_Corrected_CPS_incl');
                allbkgdCpsTable_incl = renameAnalyteColumns(app, allbkgdCpsTable_incl, '_incl_cps');
                if ismember('Data_Source', allbkgdCpsTable_incl.Properties.VariableNames)
                    allbkgdCpsTable_incl.Data_Source = [];
                end
                tableBlocks{end+1} = allbkgdCpsTable_incl;
            end

            if isChecked("Background counts-per-sweep")
                allbkgdCpsTable_bg = buildNumericBlock(app, allbkgdCpsRows_bg, 'Background_CPS');
                allbkgdCpsTable_bg = renameAnalyteColumns(app, allbkgdCpsTable_bg, '_bg_cps');
                if ismember('Data_Source', allbkgdCpsTable_bg.Properties.VariableNames)
                    allbkgdCpsTable_bg.Data_Source = [];
                end
                tableBlocks{end+1} = allbkgdCpsTable_bg;
            end

            if isChecked("Mix counts-per-sweep")
                allbkgdCpsTable_mix = buildNumericBlock(app, allbkgdCpsRows_mix, 'Bkgd_Corrected_CPS_mix');
                allbkgdCpsTable_mix = renameAnalyteColumns(app, allbkgdCpsTable_mix, '_mix_cps');
                if ismember('Data_Source', allbkgdCpsTable_mix.Properties.VariableNames)
                    allbkgdCpsTable_mix.Data_Source = [];
                end
                tableBlocks{end+1} = allbkgdCpsTable_mix;
            end

            if isChecked("Sensitivities")
                allsensTable = buildNumericBlock(app, allSensitivitiesRows, 'Sensitivities');
                allsensTable = renameAnalyteColumns(app, allsensTable, '_sens');
                if ismember('Data_Source', allsensTable.Properties.VariableNames)
                    allsensTable.Data_Source = [];
                end
                tableBlocks{end+1} = allsensTable;
            end

            if isChecked("LA parameters")
                for i = 1:numel(allLaserParamTables)
                    if isempty(allLaserParamTables{i}) || height(allLaserParamTables{i}) == 0
                        nRows = height(allbkgdCpsRows_mat{i});
                        for j = 1:numel(allLaserParamTables)
                            if ~isempty(allLaserParamTables{j}) && height(allLaserParamTables{j}) > 0
                                refTable = allLaserParamTables{j};
                                varNames = refTable.Properties.VariableNames;
                                varTypes = varfun(@class, refTable, 'OutputFormat', 'cell');
                                emptyData = cell(1, numel(varNames));
                                for k = 1:numel(varNames)
                                    switch varTypes{k}
                                        case {'double', 'single'}
                                            emptyData{k} = zeros(nRows,1);
                                        case {'cell'}
                                            emptyData{k} = cell(nRows,1);
                                        case {'char', 'string'}
                                            emptyData{k} = repmat({''}, nRows,1);
                                        case {'datetime'}
                                            emptyData{k} = NaT(nRows,1);
                                        case {'logical'}
                                            emptyData{k} = false(nRows,1);
                                        otherwise
                                            emptyData{k} = cell(nRows,1);
                                    end
                                end
                                allLaserParamTables{i} = table(emptyData{:}, 'VariableNames', varNames);
                                break;
                            end
                        end
                    end
                end

                allLaserParamTables = harmonizeTableColumns(app, allLaserParamTables);
                allLaserParamTables = harmonizeColumnClasses(app, allLaserParamTables);
                allLaserParamTables = vertcat(allLaserParamTables{:});
                tableBlocks{end+1} = allLaserParamTables;
            end

            if isChecked("ICP-MS parameters")
                for i = 1:numel(allICPMSParamTables)
                    nRows = height(allbkgdCpsRows_mat{i});
                    tbl = allICPMSParamTables{i};

                    if isempty(tbl) || height(tbl) == 0
                        for j = 1:numel(allICPMSParamTables)
                            if ~isempty(allICPMSParamTables{j}) && height(allICPMSParamTables{j}) > 0
                                refTable = allICPMSParamTables{j};
                                varNames = refTable.Properties.VariableNames;
                                emptyData = cell(1, numel(varNames));
                                for k = 1:numel(varNames)
                                    refCol = refTable.(varNames{k});
                                    refType = class(refCol);
                                    if strcmp(refType, 'cell')
                                        firstNonEmpty = find(~cellfun(@isempty, refCol), 1);
                                        if isempty(firstNonEmpty)
                                            emptyData{k} = repmat({''}, nRows, 1);
                                        else
                                            content = refCol{firstNonEmpty};
                                            if ischar(content) || isstring(content)
                                                emptyData{k} = repmat({''}, nRows, 1);
                                            elseif isnumeric(content)
                                                emptyData{k} = num2cell(zeros(nRows, 1));
                                            else
                                                emptyData{k} = cell(nRows, 1);
                                            end
                                        end
                                    elseif strcmp(refType, 'double') || strcmp(refType, 'single')
                                        emptyData{k} = zeros(nRows, 1);
                                    elseif strcmp(refType, 'char') || strcmp(refType, 'string')
                                        emptyData{k} = repmat({''}, nRows, 1);
                                    elseif strcmp(refType, 'datetime')
                                        emptyData{k} = NaT(nRows, 1);
                                    elseif strcmp(refType, 'logical')
                                        emptyData{k} = false(nRows, 1);
                                    else
                                        emptyData{k} = cell(nRows, 1);
                                    end
                                end
                                tbl = table(emptyData{:}, 'VariableNames', varNames);
                                break;
                            end
                        end
                    elseif height(tbl) == 1 && nRows > 1
                        tbl = tbl(ones(nRows,1), :);
                    end

                    allICPMSParamTables{i} = tbl;
                end

                allICPMSParamTables = harmonizeTableColumns(app, allICPMSParamTables);
                allICPMSParamTables = harmonizeColumnClasses(app, allICPMSParamTables);
                allICPMSParamTables = vertcat(allICPMSParamTables{:});
                tableBlocks{end+1} = allICPMSParamTables;
            end

            % --- Concatenate selected blocks ---
            Base_Table = [tableBlocks{:}];

            % --- Normalize textual columns and replace numeric zeros with NaN ---
            if ~isempty(Base_Table)
                if ismember('Type', Base_Table.Properties.VariableNames)
                    Base_Table.Type = normalizeToCellstr(app, Base_Table.Type);
                end
                if ismember('Material', Base_Table.Properties.VariableNames)
                    Base_Table.Material = normalizeToCellstr(app, Base_Table.Material);
                end
                if ismember('Reference_Material', Base_Table.Properties.VariableNames)
                    Base_Table.Reference_Material = normalizeToCellstr(app, Base_Table.Reference_Material);
                end

                numericCols = varfun(@isnumeric, Base_Table, 'OutputFormat', 'uniform');
                if any(numericCols)
                    X = Base_Table{:, numericCols};
                    X(X == 0) = NaN;
                    Base_Table{:, numericCols} = X;
                end
            end

            % Replace 0 with NaN in LOD-filtered composition columns (cell arrays with mixed numeric/string)
            lodFilteredSuffixes = {'_mat_ugg', '_incl_ugg', '_mix_ugg'};
            for colIdx = 1:width(Base_Table)
                colName = Base_Table.Properties.VariableNames{colIdx};
                if any(contains(colName, lodFilteredSuffixes))
                    col = Base_Table.(colName);
                    if iscell(col)
                        for rowIdx = 1:numel(col)
                            if isnumeric(col{rowIdx}) && col{rowIdx} == 0
                                col{rowIdx} = NaN;
                            end
                        end
                        Base_Table.(colName) = col;
                    end
                end
            end

            % Replace empty doubles and 0 values in cell arrays with NaN
            for colIdx = 1:width(Base_Table)
                col = Base_Table.(colIdx);
                if iscell(col)
                    for rowIdx = 1:numel(col)
                        cellVal = col{rowIdx};
                        if isnumeric(cellVal) && isempty(cellVal)
                            col{rowIdx} = NaN;
                        elseif isnumeric(cellVal) && cellVal == 0
                            col{rowIdx} = NaN;
                        end
                    end
                    Base_Table{:, colIdx} = col;
                end
            end

            % --- Row cleanup based on analyte availability (row-only; never drops columns) ---
            if ~isempty(Base_Table)
                varNames = Base_Table.Properties.VariableNames;

                % Analyte columns with allowed output suffixes.
                % Supports both mass-containing names (e.g., Na23_mat_ugg) and mass-free names (e.g., Na_mat_ugg).
                analyteNamePattern = '[A-Z][a-z]?(?:\d+)?';
                analyteSuffixPattern = '(?:_mat_ugg|_incl_ugg|_mix_ugg|_mat_lod|_incl_lod|_mat_cps|_incl_cps|_mix_cps|_sens|_bg_cps|_mat_unc|_incl_unc)';
                isAnalyteCol = ~cellfun('isempty', regexp(varNames, ...
                    ['^' analyteNamePattern analyteSuffixPattern '$'], 'once'));

                analyteCols = varNames(isAnalyteCol);
                sensCols = analyteCols(endsWith(analyteCols, '_sens'));
                nonSensCols = setdiff(analyteCols, sensCols, 'stable');

                hasSens = ~isempty(sensCols);
                hasNonSens = ~isempty(nonSensCols);

                % Cases:
                % 1) no analyte columns -> no cleanup
                % 2) cleanup applies even if only _sens is in the table
                if ~isempty(analyteCols)
                    nRows = height(Base_Table);
                    removeMask = false(nRows,1);

                    % Core rule: remove row if all analyte columns are missing
                    allAnalyteMissing = true(nRows,1);
                    for c = 1:numel(analyteCols)
                        allAnalyteMissing = allAnalyteMissing & isMissingByRow(app, Base_Table.(analyteCols{c}));
                    end
                    removeMask = removeMask | allAnalyteMissing;

                    % New rule: remove row if all _sens columns are missing
                    if hasSens
                        allSensMissing = true(nRows, 1);
                        for c = 1:numel(sensCols)
                            allSensMissing = allSensMissing & isMissingByRow(app, Base_Table.(sensCols{c}));
                        end
                        removeMask = removeMask | allSensMissing;
                    end

                    % Extra non-CAL rule: only when both _sens and non-_sens exist
                    if hasSens && hasNonSens && ismember('Type', varNames)
                        allNonSensMissing = true(nRows,1);
                        for c = 1:numel(nonSensCols)
                            allNonSensMissing = allNonSensMissing & isMissingByRow(app, Base_Table.(nonSensCols{c}));
                        end

                        anySensPresent = false(nRows,1);
                        for c = 1:numel(sensCols)
                            anySensPresent = anySensPresent | ~isMissingByRow(app, Base_Table.(sensCols{c}));
                        end

                        isCal = strcmpi(strtrim(string(Base_Table.Type)), "CAL");
                        removeMask = removeMask | (~isCal & allNonSensMissing & anySensPresent);
                    end

                    Base_Table(removeMask, :) = [];
                end
            end


        end


        function Base_Table = convert_majors_to_oxides_base_table(app, Base_Table)

            try
                oxide_file = dir(fullfile(app.sourceapp.default_oxides_path, 'Oxides.csv'));
                filePath   = fullfile(app.sourceapp.default_oxides_path, oxide_file.name);
                opts       = detectImportOptions(filePath);
                raw        = readtable(filePath, opts);
            catch ME
                DisplayError(ME, 'Error reading oxides from Oxides.csv. Close it if it is open in another program. Make sure the Total Oxide folder was not moved or renamed.');
                message = {'Error reading oxides from Oxides.csv. Did you rename or move the folder? Close the Oxides.csv if it is open in another program.'};
                uialert(app.TableBuilderUIFigure, message, ' Error');
                return;
            end

            element_names_col      = raw(:, 1);
            oxide_names_col        = raw(:, 2);
            conversion_factors_col = raw(:, 3);
            considered_major_col   = raw(:, 5);

            conversion_factor_values = double(conversion_factors_col.Variables);
            oxide_names              = string(oxide_names_col.Variables);
            element_names            = string(element_names_col.Variables);
            considered_major         = string(considered_major_col.Variables);

            uialert(app.TableBuilderUIFigure, ...
                sprintf('Oxide conversion uses the current Oxides.csv configuration from:\n\n%s\n\nThis may differ from the settings used when individual sessions were originally quantified.', app.sourceapp.default_oxides_path), ...
                'Using Current Oxide Configuration', 'Icon', 'info');

            var_names     = Base_Table.Properties.VariableNames;
            new_var_names = var_names;

            for colIdx = 1:numel(var_names)
                colName = var_names{colIdx};

                if contains(colName, '_ugg') || contains(colName, '_lod') || contains(colName, '_unc')
                    base_element = regexp(colName, '^[A-Za-z]+', 'match', 'once');

                    if ~isempty(base_element)
                        element_idx = find(strcmp(element_names, base_element));

                        if ~isempty(element_idx) && strcmp(considered_major(element_idx), 'Yes')
                            factor    = conversion_factor_values(element_idx);
                            oxide_name = char(oxide_names(element_idx));

                            colData = Base_Table.(colName);

                            if iscell(colData)
                                for rowIdx = 1:numel(colData)
                                    val = colData{rowIdx};
                                    if isnumeric(val)
                                        colData{rowIdx} = (val * factor) / 10000;
                                    elseif ischar(val) || isstring(val)
                                        valStr = char(val);
                                        if startsWith(valStr, '<')
                                            numVal = str2double(extractAfter(valStr, 1));
                                            if ~isnan(numVal)
                                                colData{rowIdx} = ['<', num2str((numVal * factor) / 10000)];
                                            end
                                        else
                                            numVal = str2double(valStr);
                                            if ~isnan(numVal)
                                                colData{rowIdx} = num2str((numVal * factor) / 10000);
                                            end
                                        end
                                    end
                                end
                            elseif isnumeric(colData)
                                colData = (colData .* factor) ./ 10000;
                            end

                            Base_Table.(colName) = colData;

                            isotope_part = regexp(colName, '\d+', 'match', 'once');
                            has_isotope  = ~isempty(isotope_part);

                            element_part_length = numel(base_element) + (has_isotope * numel(isotope_part));
                            suffix_part = extractAfter(colName, element_part_length);

                            suffix_part = strrep(suffix_part, '_ugg', '_wtpct');

                            if has_isotope
                                new_var_names{colIdx} = [oxide_name, '_', isotope_part, suffix_part];
                            else
                                new_var_names{colIdx} = [oxide_name, suffix_part];
                            end
                        end
                    end
                end
            end

            Base_Table.Properties.VariableNames = new_var_names;

        end

        function Base_Table = exclude_CALs(app, Base_Table)

            typeVals = strtrim(string(Base_Table.Type));
            isCal = strcmpi(typeVals, "CAL");
            Base_Table = Base_Table(~isCal, :);

        end


        % ---------------- Helpers ----------------

        function preferredIsoMap = getSessionPreferredIsotopeMap(app, session)
            preferredIsoMap = containers.Map('KeyType', 'char', 'ValueType', 'char');

            if ~isfield(session, 'oxides') || ~isstruct(session.oxides)
                return
            end
            if ~isfield(session.oxides, 'preferred_isotopes') || isempty(session.oxides.preferred_isotopes)
                return
            end

            rawPref = session.oxides.preferred_isotopes;

            if iscell(rawPref)
                prefList = string(rawPref(:));
            elseif isstring(rawPref)
                prefList = rawPref(:);
            elseif ischar(rawPref)
                prefList = string({rawPref});
            else
                try
                    prefList = string(rawPref(:));
                catch
                    return
                end
            end

            for ii = 1:numel(prefList)
                isoName = strtrim(prefList(ii));
                if ismissing(isoName) || strlength(isoName) == 0
                    continue
                end

                tok = regexp(char(isoName), '^([A-Z][a-z]?)(\d+)$', 'tokens', 'once');
                if isempty(tok)
                    continue
                end

                elementName = tok{1};
                preferredIsoMap(elementName) = char(isoName);
            end
        end

        function T = collapseIsotopeColumnsForSession(app, T, preferredIsoMap)
            if isempty(T) || ~istable(T) || width(T) == 0
                return
            end

            varNames = T.Properties.VariableNames;
            isoPattern = '^([A-Z][a-z]?)(\d+)$';

            groupedCols = containers.Map('KeyType', 'char', 'ValueType', 'any');
            for ii = 1:numel(varNames)
                colName = varNames{ii};
                tok = regexp(colName, isoPattern, 'tokens', 'once');
                if isempty(tok)
                    continue
                end
                elementName = tok{1};

                if ~isKey(groupedCols, elementName)
                    groupedCols(elementName) = {colName};
                else
                    tmp = groupedCols(elementName);
                    tmp{end+1} = colName;
                    groupedCols(elementName) = tmp;
                end
            end

            if groupedCols.Count == 0
                return
            end

            elements = keys(groupedCols);
            nRows = height(T);

            for e = 1:numel(elements)
                elementName = elements{e};
                cols = groupedCols(elementName);

                % Keep only columns that still exist (table changes during loop)
                cols = cols(ismember(cols, T.Properties.VariableNames));
                if isempty(cols)
                    continue
                end

                targetName = elementName;

                if numel(cols) == 1
                    srcName = cols{1};

                    if strcmp(srcName, targetName)
                        continue
                    end

                    if ismember(targetName, T.Properties.VariableNames)
                        srcVec = coerceNumericVector(app, T.(srcName), nRows);
                        dstVec = coerceNumericVector(app, T.(targetName), nRows);

                        dstMissing = isnan(dstVec) | dstVec == 0;
                        srcPresent = ~(isnan(srcVec) | srcVec == 0);
                        fillMask = dstMissing & srcPresent;
                        dstVec(fillMask) = srcVec(fillMask);

                        T.(targetName) = dstVec;
                        T(:, srcName) = [];
                    else
                        T = renamevars(T, srcName, targetName);
                    end

                    continue
                end

                prefCol = '';
                if isKey(preferredIsoMap, elementName)
                    prefIso = preferredIsoMap(elementName);
                    if any(strcmp(cols, prefIso))
                        prefCol = prefIso;
                    end
                end

                if ~isempty(prefCol)
                    merged = coerceNumericVector(app, T.(prefCol), nRows);
                else
                    merged = NaN(nRows, 1);
                end

                mergedMissing = isnan(merged) | merged == 0;

                for c = 1:numel(cols)
                    colName = cols{c};
                    srcVec = coerceNumericVector(app, T.(colName), nRows);
                    srcPresent = ~(isnan(srcVec) | srcVec == 0);

                    fillMask = mergedMissing & srcPresent;
                    if any(fillMask)
                        merged(fillMask) = srcVec(fillMask);
                        mergedMissing(fillMask) = false;
                    end

                    if ~any(mergedMissing)
                        break
                    end
                end

                if ismember(targetName, T.Properties.VariableNames) && ~any(strcmp(cols, targetName))
                    dstVec = coerceNumericVector(app, T.(targetName), nRows);
                    dstMissing = isnan(dstVec) | dstVec == 0;
                    mergedPresent = ~(isnan(merged) | merged == 0);
                    fillMask = dstMissing & mergedPresent;
                    dstVec(fillMask) = merged(fillMask);
                    merged = dstVec;
                end

                if ismember(targetName, T.Properties.VariableNames)
                    T.(targetName) = merged;
                else
                    firstPos = find(ismember(T.Properties.VariableNames, cols), 1, 'first');
                    if isempty(firstPos)
                        T.(targetName) = merged;
                    else
                        T = addvars(T, merged, 'Before', firstPos, 'NewVariableNames', targetName);
                    end
                end

                colsToDelete = cols;
                colsToDelete(strcmp(colsToDelete, targetName)) = [];
                if ~isempty(colsToDelete)
                    T(:, colsToDelete) = [];
                end
            end
        end

        function missingMask = isMissingByRow(app, col)
            if isnumeric(col)
                missingMask = isnan(col);

            elseif isstring(col)
                missingMask = ismissing(col) | strlength(strtrim(col)) == 0;

            elseif ischar(col)
                missingMask = cellfun(@(x) isempty(strtrim(x)), cellstr(col));

            elseif iscell(col)
                n = numel(col);
                missingMask = false(n,1);
                for r = 1:n
                    v = col{r};

                    if isempty(v)
                        missingMask(r) = true;

                    elseif isnumeric(v)
                        missingMask(r) = isscalar(v) && isnan(v);

                    elseif isstring(v)
                        missingMask(r) = all(ismissing(v)) || all(strlength(strtrim(v)) == 0);

                    elseif ischar(v)
                        missingMask(r) = isempty(strtrim(v));

                    else
                        % Unsupported object types are treated as present
                        missingMask(r) = false;
                    end
                end

            else
                % Fallback for unexpected column types
                missingMask = false(numel(col),1);
            end

            missingMask = missingMask(:);
        end

        function [assignmentMap, assignedCalList] = buildAnalyteCalMap(app, assignTbl)
            assignmentMap = containers.Map('KeyType', 'char', 'ValueType', 'char');
            assignedCalList = strings(0,1);

            if isempty(assignTbl)
                return
            end

            if istable(assignTbl)
                if width(assignTbl) < 2
                    return
                end
                analyteCol = string(assignTbl{:,1});
                calCol = string(assignTbl{:,2});
            elseif iscell(assignTbl)
                if size(assignTbl,2) < 2
                    return
                end
                analyteCol = string(assignTbl(:,1));
                calCol = string(assignTbl(:,2));
            elseif isstring(assignTbl)
                analyteCol = assignTbl(:,1);
                calCol     = assignTbl(:,2);
            else
                return
            end

            analyteCol = strtrim(analyteCol(:));
            calCol = strtrim(calCol(:));

            valid = strlength(analyteCol) > 0 & strlength(calCol) > 0;
            valid = valid & calCol ~= "None" & calCol ~= "Select Reference Material";

            assignedCalList = unique(calCol(valid)); % intentionally no 'stable'

            idx = find(valid);
            for ii = 1:numel(idx)
                assignmentMap(char(analyteCol(idx(ii)))) = char(calCol(idx(ii)));
            end
        end

        function assignedTbl = buildAssignedAnalyteTable(app, nestedCell, b, assignmentMap_, validCALs_, analyteNames_, nRows_)
            assignedTbl = table('Size', [nRows_, numel(analyteNames_)], ...
                'VariableTypes', repmat("double", 1, numel(analyteNames_)), ...
                'VariableNames', cellstr(analyteNames_));

            if isempty(nestedCell) || size(nestedCell,1) < b
                return
            end

            for a = 1:numel(analyteNames_)
                analyteName = char(analyteNames_(a));
                outCol = zeros(nRows_,1);

                if isKey(assignmentMap_, analyteName)
                    calName = assignmentMap_(analyteName);
                    calIdx = find(strcmp(validCALs_, calName), 1); % same pattern as update_assigned_table

                    if ~isempty(calIdx) && calIdx <= size(nestedCell,2)
                        srcTab = nestedCell{b, calIdx};
                        if istable(srcTab) && ismember(analyteName, srcTab.Properties.VariableNames)
                            srcCol = coerceNumericVector(app, srcTab.(analyteName), nRows_);
                            nCopy = min(numel(srcCol), nRows_);
                            outCol(1:nCopy) = srcCol(1:nCopy);
                        end
                    end
                end

                assignedTbl.(analyteName) = outCol;
            end
        end

        function vec = coerceNumericVector(app, vec, nRows_)
            if iscell(vec)
                tmp = zeros(numel(vec), 1);
                for ii = 1:numel(vec)
                    v = vec{ii};
                    if isnumeric(v) && isscalar(v) && ~isempty(v)
                        tmp(ii) = v;
                    else
                        tmp(ii) = 0;
                    end
                end
                vec = tmp;
            end

            if ~isnumeric(vec)
                try
                    vec = double(vec);
                catch
                    try
                        vec = str2double(string(vec));
                        vec(isnan(vec)) = 0;
                    catch
                        vec = zeros(nRows_, 1);
                    end
                end
            end

            vec = vec(:);
            if isempty(vec)
                vec = zeros(nRows_, 1);
            end
        end

        function val = getNestedValue(app, C, b, p, k, defaultVal)
            val = defaultVal;
            try
                if iscell(C) && numel(C) >= (p-1)*size(C,1)+b && ~isempty(C)
                    X = C{b,p};
                    if iscell(X)
                        if numel(X) >= k && ~isempty(X{k})
                            val = X{k};
                        end
                    elseif isstring(X) || ischar(X)
                        if numel(X) >= k
                            val = X(k);
                        end
                    elseif isnumeric(X)
                        if numel(X) >= k
                            val = X(k);
                        end
                    end
                end
            catch
                val = defaultVal;
            end
        end

        function T = ensureAnalyteTable(app, T, analyteNames_, nRows_)
            if ~istable(T) || isempty(T)
                T = table('Size', [nRows_, numel(analyteNames_)], ...
                    'VariableTypes', repmat("double", 1, numel(analyteNames_)), ...
                    'VariableNames', cellstr(analyteNames_));
                return
            end

            for v = 1:width(T)
                if ~isnumeric(T{:,v})
                    try
                        T{:,v} = double(T{:,v});
                    catch
                        T{:,v} = zeros(height(T),1);
                    end
                end
            end

            if height(T) ~= nRows_
                headers = T.Properties.VariableNames;
                TT = table('Size', [nRows_, numel(headers)], ...
                    'VariableTypes', repmat("double", 1, numel(headers)), ...
                    'VariableNames', headers);
                nCopy = min(height(T), nRows_);
                if nCopy > 0
                    TT(1:nCopy, :) = T(1:nCopy, :);
                end
                T = TT;
            end
        end

        function sortedHeaders = getSortedHeaders(app, rowsCell)
            if isempty(rowsCell)
                sortedHeaders = {};
                return
            end
            isT = cellfun(@istable, rowsCell);
            if ~any(isT)
                sortedHeaders = {};
                return
            end
            headersCell = cellfun(@(t) t.Properties.VariableNames, rowsCell(isT), 'UniformOutput', false);
            if isempty(headersCell)
                sortedHeaders = {};
                return
            end

            allHeaders = unique([headersCell{:}], 'stable');
            nums = cellfun(@(h) localExtractNum(app, h), allHeaders);

            idx = (1:numel(allHeaders))';
            sortMat = [isnan(nums(:)), nums(:), idx];
            [~, sortIdx] = sortrows(sortMat, [1 2 3]);

            sortedHeaders = allHeaders(sortIdx);
        end

        function n = localExtractNum(app, h)
            tok = regexp(h, '\d+', 'match', 'once');
            if isempty(tok)
                n = NaN;
            else
                n = str2double(tok);
            end
        end

        function tableWithAllColumns = addMissingColumns(app, inputTable, targetHeaders)
            if isempty(targetHeaders)
                tableWithAllColumns = inputTable;
                return
            end
            missingCols = setdiff(targetHeaders, inputTable.Properties.VariableNames, 'stable');
            if isempty(missingCols)
                tableWithAllColumns = inputTable(:, targetHeaders);
                return
            end
            missingData = zeros(height(inputTable), numel(missingCols));
            missingTable = array2table(missingData, 'VariableNames', missingCols);
            tableWithAllColumns = [inputTable missingTable];
            tableWithAllColumns = tableWithAllColumns(:, targetHeaders);
        end

        function outTable = buildNumericBlock(app, rowsCell, label)
            if isempty(rowsCell)
                outTable = table();
                return
            end
            headers = getSortedHeaders(app, rowsCell);
            if ~isempty(rowsCell)
                rowsCell = cellfun(@(t) addMissingColumns(app, t, headers), rowsCell, 'UniformOutput', false);
            end
            if isempty(rowsCell)
                outTable = table();
                return
            end
            outTable = vertcat(rowsCell{:});
            if isempty(outTable)
                return
            end
            outTable = addvars(outTable, repmat({label}, height(outTable), 1), ...
                'Before', 1, 'NewVariableNames', 'Data_Source');
        end

        function T = renameAnalyteColumns(app, T, suffix)
            if isempty(T)
                return
            end
            metaCols = {'Data_Source'};
            for v = 1:width(T)
                if ~ismember(T.Properties.VariableNames{v}, metaCols)
                    T.Properties.VariableNames{v} = [T.Properties.VariableNames{v} suffix];
                end
            end
        end

        function T = normalizeToCellstr(app, T)
            if istable(T) || isstruct(T)
                return
            end
            if iscell(T)
                try
                    T = cellfun(@char, T, 'UniformOutput', false);
                catch
                    T = cellfun(@(x) char(string(x)), T, 'UniformOutput', false);
                end
            else
                T = cellstr(string(T));
            end
        end

        function C = getNestedField(app, spotStruct, fieldName, uniqueBracketIds_, unique_CALs_, nSpots_, defaultVal)
            if isfield(spotStruct, fieldName)
                C = spotStruct.(fieldName);
            else
                C = cell(numel(uniqueBracketIds_), numel(unique_CALs_));
                for b = 1:numel(uniqueBracketIds_)
                    for p = 1:numel(unique_CALs_)
                        if ischar(defaultVal) || isstring(defaultVal)
                            C{b, p} = repmat({defaultVal}, nSpots_, 1);
                        else
                            C{b, p} = repmat(defaultVal, nSpots_, 1);
                        end
                    end
                end
            end
        end

        function C = getNestedTable(app, spotStruct, fieldName, uniqueBracketIds_, unique_CALs_, nSpots_, analyteNames_)
            if isfield(spotStruct, fieldName)
                C = spotStruct.(fieldName);
            else
                C = cell(numel(uniqueBracketIds_), numel(unique_CALs_));
                for b = 1:numel(uniqueBracketIds_)
                    for p = 1:numel(unique_CALs_)
                        C{b, p} = table('Size', [nSpots_, numel(analyteNames_)], ...
                            'VariableTypes', repmat("double", 1, numel(analyteNames_)), ...
                            'VariableNames', cellstr(analyteNames_));
                    end
                end
            end
        end

        function C = getNestedMixingRatio(app, spotStruct, fieldName, uniqueBracketIds_, unique_CALs_, nSpots_)
            if isfield(spotStruct, fieldName)
                C = spotStruct.(fieldName);
            else
                C = cell(numel(uniqueBracketIds_), numel(unique_CALs_));
                for b = 1:numel(uniqueBracketIds_)
                    for p = 1:numel(unique_CALs_)
                        C{b, p} = repmat({NaN}, nSpots_, 1);
                    end
                end
            end
        end

        function val = getNestedMixingRatioValue(app, C, b, p, k)
            val = [];
            try
                if iscell(C) && numel(C) >= (p-1)*size(C,1)+b && ~isempty(C)
                    X = C{b,p};
                    if iscell(X)
                        if numel(X) >= k && ~isempty(X{k})
                            val = X{k};
                        else
                            val = NaN;
                        end
                    elseif isnumeric(X)
                        if numel(X) >= k
                            val = X(k);
                        else
                            val = NaN;
                        end
                    end
                end
            catch
                val = NaN;
            end
        end

        function T = struct_to_table(app, S)
            if isempty(S)
                T = table();
                return
            end
            fields = fieldnames(S);
            lens = zeros(numel(fields),1);
            for o = 1:numel(fields)
                col = S.(fields{o});
                if ischar(col) || (isstring(col) && isscalar(col))
                    lens(o) = 1;
                else
                    lens(o) = numel(col);
                end
            end
            n = max(lens);
            T = table();
            for o = 1:numel(fields)
                col = S.(fields{o});
                if isempty(col)
                    col = nan(n,1);
                elseif ischar(col) || (isstring(col) && isscalar(col))
                    col = repmat({col}, n, 1);
                elseif iscell(col) && numel(col) == 1 && n > 1
                    col = repmat(col, n, 1);
                elseif isnumeric(col) && numel(col) == 1 && n > 1
                    col = repmat(col, n, 1);
                elseif numel(col) ~= n
                    error('Field %s has %d elements, expected %d.', fields{o}, numel(col), n);
                end
                if isrow(col) && ~ischar(col)
                    col = col';
                end
                T.(fields{o}) = col;
            end
        end

        function harmonizedTables = harmonizeTableColumns(app, tableCell)
            if isempty(tableCell)
                harmonizedTables = tableCell;
                return
            end

            allVarNames = {};
            for i = 1:numel(tableCell)
                if ~isempty(tableCell{i}) && istable(tableCell{i})
                    allVarNames = [allVarNames, tableCell{i}.Properties.VariableNames];
                end
            end
            allVarNames = unique(allVarNames, 'stable');

            for i = 1:numel(tableCell)
                tbl = tableCell{i};
                if isempty(tbl) || ~istable(tbl)
                    continue
                end

                existingVars = tbl.Properties.VariableNames;
                missingVars = setdiff(allVarNames, existingVars, 'stable');

                for j = 1:numel(missingVars)
                    varName = missingVars{j};
                    nRows = height(tbl);

                    varType = 'double';
                    for k = 1:numel(tableCell)
                        if ~isempty(tableCell{k}) && istable(tableCell{k}) && ...
                                ismember(varName, tableCell{k}.Properties.VariableNames)
                            refCol = tableCell{k}.(varName);
                            varType = class(refCol);
                            break;
                        end
                    end

                    switch varType
                        case {'double', 'single'}
                            tbl.(varName) = nan(nRows, 1);
                        case 'cell'
                            tbl.(varName) = cell(nRows, 1);
                        case {'char', 'string'}
                            tbl.(varName) = repmat({''}, nRows, 1);
                        case 'datetime'
                            tbl.(varName) = NaT(nRows, 1);
                        case 'logical'
                            tbl.(varName) = false(nRows, 1);
                        otherwise
                            tbl.(varName) = cell(nRows, 1);
                    end
                end

                tbl = tbl(:, allVarNames);
                tableCell{i} = tbl;
            end

            harmonizedTables = tableCell;
        end

        function filteredCompTable = applyLODFiltering(app, compTable, lodTable, compSuffix, lodSuffix)
            filteredCompTable = compTable;

            if isempty(compTable) || isempty(lodTable) || width(compTable) == 0 || width(lodTable) == 0
                return
            end

            compCols = compTable.Properties.VariableNames;
            compCols = compCols(contains(compCols, compSuffix));

            lodCols = lodTable.Properties.VariableNames;
            lodCols = lodCols(contains(lodCols, lodSuffix));

            for l = 1:numel(compCols)
                elementName = strrep(compCols{l}, compSuffix, '');
                lodColName = [elementName, lodSuffix];

                if ismember(lodColName, lodCols)
                    comp_array = compTable.(compCols{l});
                    lod_array = lodTable.(lodColName);

                    if isnumeric(comp_array) && isnumeric(lod_array)
                        below_lod = comp_array < lod_array;
                        display_values = num2cell(comp_array);
                        display_values(below_lod) = arrayfun(@(x) ['<' num2str(x)], ...
                            lod_array(below_lod), 'UniformOutput', false);
                        filteredCompTable.(compCols{l}) = display_values;
                    end
                end
            end
        end

        function tableCell = harmonizeColumnClasses(app, tableCell)
            % Columns with different classes in different tables (e.g. string in a session with
            % parameters, cell placeholder in a session without) cannot be concatenated.
            % Such columns are converted to cell columns in all tables.
            hasColumns = cellfun(@(t) istable(t) && width(t) > 0, tableCell);
            if ~any(hasColumns)
                return
            end

            tableIndices = find(hasColumns(:))';
            variableNames = tableCell{tableIndices(1)}.Properties.VariableNames;

            for v = 1:numel(variableNames)
                variableName = variableNames{v};

                columnClasses = {};
                for i = tableIndices
                    if ismember(variableName, tableCell{i}.Properties.VariableNames)
                        columnClasses{end+1} = class(tableCell{i}.(variableName)); %#ok<AGROW>
                    end
                end

                if numel(unique(columnClasses)) <= 1
                    continue
                end

                for i = tableIndices
                    if ismember(variableName, tableCell{i}.Properties.VariableNames)
                        tableCell{i}.(variableName) = columnToCell(app, tableCell{i}.(variableName));
                    end
                end
            end
        end

        function out = columnToCell(app, col)
            if iscell(col)
                out = col;
                for r = 1:numel(out)
                    if isempty(out{r})
                        out{r} = '';
                    end
                end
            elseif isstring(col)
                col(ismissing(col)) = "";
                out = cellstr(col);
            elseif isnumeric(col) || islogical(col)
                out = num2cell(col);
            else
                textValues = string(col);
                textValues(ismissing(textValues)) = "";
                out = cellstr(textValues);
            end
            out = out(:);
        end


        %%%%% Linescan stitching %%%%%%

        function build_stitching_table(app)

            allTables        = {};

            checkedNodes = app.ProjectSessionTree.CheckedNodes;
            checkedIndices = [];
            for n = 1:numel(checkedNodes)
                nodeData = checkedNodes(n).NodeData;
                if ~isempty(nodeData) && numel(nodeData) == 2 && nodeData(2) > 0
                    checkedIndices = [checkedIndices; nodeData];
                end
            end

            if isempty(checkedIndices)
                uialert(app.TableBuilderUIFigure, 'No sessions selected.', 'Fetch Data');
                return
            end

            for i = 1:numel(app.base)
                for j = 1:numel(app.base(i).project)
                    if ~ismember([i, j], checkedIndices, 'rows')
                        continue
                    end
                    if ~isfield(app.base(i).project(j), 'session')
                        continue
                    end

                    skel = app.sourceapp.base(i).project(j).session;

                    if isfield(skel, 'config') && isfield(skel.config, 'module_status')
                        if any(structfun(@(x) x == 0, skel.config.module_status))
                            continue
                        end
                    end

                    needed_load = ~skel.config.loaded;
                    if needed_load
                        try
                            h52session(app.sourceapp, i, j);
                        catch
                            continue
                        end
                        session = app.sourceapp.base(i).project(j).session;
                    else
                        session = skel;
                    end

                    sessionName = char(session.session_name);

                    if ~isfield(session, 'spot') || isempty(session.spot)
                        if needed_load, app.sourceapp.base(i).project(j).session = skel; end
                        continue
                    end

                    if ~isfield(session.spot, 'analyte_calibrator_assignment') || ...
                            isempty(session.spot.analyte_calibrator_assignment)
                        if needed_load, app.sourceapp.base(i).project(j).session = skel; end
                        continue
                    end

                    spotnames        = session.spot.name(:);
                    nSpots           = numel(spotnames);
                    analyteNames     = strtrim(string(session.spot.analytes(:)));
                    assignments      = session.spot.analyte_calibrator_assignment;

                    cal_indices   = strcmp(session.spot.type, "CAL");
                    cal_materials = session.spot.referencematerial(cal_indices);
                    unique_names  = unique(cal_materials);
                    unique_names  = unique_names(~strcmp(unique_names, 'None'));
                    validCALs     = unique_names(~strcmp(unique_names, 'Select Reference Material'));

                    bracket_id       = session.spot.bracket_id(:);
                    uniqueBracketIds = unique(bracket_id);
                    uniqueBracketIds = uniqueBracketIds(uniqueBracketIds ~= 0);
                    if isempty(uniqueBracketIds)
                        uniqueBracketIds = 1;
                    end

                    [assignmentMap, ~] = buildAnalyteCalMap(app, assignments);

                    sessionPreferredIsoMap = getSessionPreferredIsotopeMap(app, session);

                    matrix_composition = getNestedTable(app, session.spot, 'matrix_composition', uniqueBracketIds, validCALs, nSpots, analyteNames);

                    allSpotnames = {};
                    allSessions  = {};
                    allDataRows  = {};

                    for b = 1:numel(uniqueBracketIds)
                        compTbl = buildAssignedAnalyteTable(app, matrix_composition, b, assignmentMap, validCALs, analyteNames, nSpots);
                        compTbl = ensureAnalyteTable(app, compTbl, analyteNames, nSpots);
                        compTbl = collapseIsotopeColumnsForSession(app, compTbl, sessionPreferredIsoMap);

                        allDataRows{end+1} = compTbl;
                        allSessions  = [allSessions;  repmat({sessionName}, nSpots, 1)];
                        allSpotnames = [allSpotnames; cellstr(spotnames)];
                    end

                    dataBlock = vertcat(allDataRows{:});
                    sessionCol = allSessions;
                    spotnameCol = allSpotnames;

                    T = [table(sessionCol, spotnameCol, 'VariableNames', {'Session', 'Spotname'}), dataBlock];

                    allTables{end+1} = T;

                    if needed_load
                        app.sourceapp.base(i).project(j).session = skel;
                    end
                end
            end

            if isempty(allTables)
                uialert(app.TableBuilderUIFigure, 'No data could be fetched.', 'Fetch Data');
                return
            end

            allTables = harmonizeTableColumns(app, allTables);
            app.Base_Table_for_stitching = vertcat(allTables{:});

            % Populate element listbox
            varNames = app.Base_Table_for_stitching.Properties.VariableNames;
            metaCols = {'Session', 'Spotname'};
            elementCols = varNames(~ismember(varNames, metaCols));
            app.ElementListBox.Items = elementCols;

        end

        function updateStitchVisibility(app)
            if isempty(app.StitchAxes) || ~isvalid(app.StitchAxes)
                return
            end

            selected = app.ElementListBox.Value;
            showAll  = isempty(selected);

            for e = 1:numel(app.StitchElements)
                vis = showAll || ismember(app.StitchElements{e}, selected);
                app.StitchLine1(e).Visible = vis;
                app.StitchLine2(e).Visible = vis;
                if vis
                    app.StitchLine1(e).HandleVisibility = 'on';
                else
                    app.StitchLine1(e).HandleVisibility = 'off';
                end
            end

            if showAll
                legend(app.StitchAxes, 'off');
            else
                legend(app.StitchAxes);
            end
        end

        function updateStitchOffset(app)
            if isempty(app.StitchAxes) || ~isvalid(app.StitchAxes)
                return
            end
            ov = app.StitchOffset;
            x2 = (app.StitchN1 + 1 - ov : app.StitchN1 + app.StitchN2 - ov)';
            for e = 1:numel(app.StitchElements)
                app.StitchLine2(e).XData = x2;
            end
            app.OffsetSlider.Value = app.OffsetSlider.Limits(2) - ov;
        end

        function running = spliceEmbed(app, running, modified, containerFull, containerName, matchLS, r)
            % Insert an embedded container into running, preserving whatever
            % trimming running already applied to that container.
            idx = find(matchLS(running.Spotname, containerName));
            if isempty(idx)
                running = modified;
                return
            end
            % #3: container must be one contiguous block in running.
            if ~isequal(idx(:).', idx(1):idx(end))
                error('Row %d: container "%s" is non-contiguous in the running table (already embedded into, or re-referenced). Reorder so each container is embedded once, before it is touched again.', ...
                    r, containerName);
            end
            % #2: map the present rows back to their positions in the full container
            % by spotname, so head-trimmed / tail-trimmed / full all work.
            spotFull  = string(containerFull.Spotname);
            a = find(spotFull == string(running.Spotname(idx(1))),   1);
            b = find(spotFull == string(running.Spotname(idx(end))), 1);
            if isempty(a) || isempty(b)
                error('Row %d: could not locate container "%s" rows within its source table.', r, containerName);
            end
            % modified is index-aligned with the full container, so rows a:b are the
            % embedded equivalents of exactly the rows currently in running.
            running = [running(1:idx(1)-1, :); modified(a:b, :); running(idx(end)+1:end, :)];
        end




    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, source)
            app.sourceapp = source;
            app.base = source.base;

            app.TableBuilderUIFigure.Tag = "tablebuilder";

            update_project_session_tree(app)


        end

        % Button pushed function: ExportcsvTableButton
        function ExportcsvTableButtonPushed(app, event)


            progress = uiprogressdlg(app.TableBuilderUIFigure, 'Title', 'ICP-Base', ...
                'Message', 'Building and exporting table...', 'Cancelable', 'off', 'Indeterminate','on');

            try
                Base_Table = build_assigned_table_from_base(app);


                if app.MajorsasoxideswtCheckBox.Value
                    Base_Table = convert_majors_to_oxides_base_table(app, Base_Table);
                end

                if app.ExcludeCalibratorsCheckBox.Value
                    Base_Table = exclude_CALs(app, Base_Table);
                end


            catch

                message = "Table building failed";
                uialert(app.TableBuilderUIFigure,message,"Warning", ...
                    "Icon","warning");
            end

            if isempty(Base_Table)
                message = "Exporting failed. No table was built.";
                uialert(app.TableBuilderUIFigure,message,"Warning", ...
                    "Icon","warning");
                return
            end


            f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
            [filename, pathname] = uiputfile('*.csv', 'Save .csv file');
            delete(f);
            figure(app.TableBuilderUIFigure);

            outputpath = fullfile(pathname, filename);
            if isequal(filename, 0) || isequal(pathname, 0)
                return; % User canceled file selection
            end

            % Write the table to Excel
            writetable(Base_Table, outputpath);

            delete(progress)
        end

        % Button pushed function: ProceedtoVisModuleButton
        function ProceedtoVisModuleButtonPushed(app, event)
            progress = uiprogressdlg(app.TableBuilderUIFigure, 'Title', 'ICP-Base', ...
                'Message', 'Building table...', 'Cancelable', 'off', 'Indeterminate', 'on');
            try
                Base_Table = build_assigned_table_from_base(app);

                if app.MajorsasoxideswtCheckBox.Value
                    Base_Table = convert_majors_to_oxides_base_table(app, Base_Table);
                end

                if app.ExcludeCalibratorsCheckBox.Value
                    Base_Table = exclude_CALs(app, Base_Table);
                end

                if isempty(Base_Table)
                    delete(progress)
                    uialert(app.TableBuilderUIFigure, 'Proceeding to the VisModule failed. No table was built.', 'Warning', 'Icon', 'warning');
                    return
                end

                VisModule(Base_Table, app.sourceapp);
                delete(progress)
            catch ME
                delete(progress)
                DisplayError(ME, 'Building table failed');
            end

        end

        % Callback function: ProjectSessionTree
        function ProjectSessionTreeCheckedNodesChanged(app, event)

            SelectionModeDropDownValueChanged(app)

            %update_spot_meta_tree(app)
        end

        % Value changed function: SelectionModeDropDown
        function SelectionModeDropDownValueChanged(app, event)
            value = app.SelectionModeDropDown.Value;

            if isequal(value, 'Simple')

                app.SimplePanel.Visible = true;
                app.AdvancedPanel.Visible = false;

                update_spot_meta_tree(app)

                % Find and check the Matrix/Host mass fractions node
                nodesToCheck = [];

                if ~isempty(app.SpotMetaTree.Children)
                    for i = 1:numel(app.SpotMetaTree.Children)
                        node = app.SpotMetaTree.Children(i);
                        % Check if this is the Quantification node
                        if strcmp(node.Text, "Quantification")
                            % Loop through its children
                            for j = 1:numel(node.Children)
                                childNode = node.Children(j);
                                if strcmp(childNode.Text, "Matrix/Host mass fractions")
                                    nodesToCheck = [nodesToCheck; childNode];
                                elseif strcmp(childNode.Text, "Inclusion mass fractions")
                                    nodesToCheck = [nodesToCheck; childNode];
                                end
                            end
                            break;
                        end
                    end
                end

                % Set all found nodes as checked
                if ~isempty(nodesToCheck)
                    app.SpotMetaTree.CheckedNodes = nodesToCheck;
                end


            elseif isequal(value, 'Advanced')

                app.SimplePanel.Visible = false;
                app.AdvancedPanel.Visible = true;

                update_spot_meta_tree(app)
            end

        end

        % Menu selected function: ExportasmatMenu
        function ExportasmatMenuSelected(app, event)

            progress = uiprogressdlg(app.TableBuilderUIFigure, 'Title', 'ICP-Base', ...
                'Message', 'Building and exporting table...', 'Cancelable', 'off', 'Indeterminate','on');

            try
                Base_Table = build_assigned_table_from_base(app);


                if app.MajorsasoxideswtCheckBox.Value
                    Base_Table = convert_majors_to_oxides_base_table(app, Base_Table);
                end

                if app.ExcludeCalibratorsCheckBox.Value
                    Base_Table = exclude_CALs(app, Base_Table);
                end

            catch

                message = "Table building failed";
                uialert(app.TableBuilderUIFigure,message,"Warning", ...
                    "Icon","warning");
            end

            if isempty(Base_Table)
                message = "Exporting failed. No table was built.";
                uialert(app.TableBuilderUIFigure,message,"Warning", ...
                    "Icon","warning");
                return
            end


            f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
            [filename, pathname] = uiputfile('*.mat', 'Save .mat file');
            delete(f);
            figure(app.TableBuilderUIFigure);

            outputpath = fullfile(pathname, filename);
            if isequal(filename, 0) || isequal(pathname, 0)
                return; % User canceled file selection
            end

            % Write the table
            save(outputpath, 'Base_Table');

            delete(progress)
        end

        % Value changed function: RemovemassesfromelementnameCheckBox
        function RemovemassesfromelementnameCheckBoxValueChanged(app, event)

            if app.RemovemassesfromelementnameCheckBox.Value == 0
                message = "Be aware that the quantified results are not isotope-resolved! For example, ‘Pb206’ indicates that Pb was measured on mass 206 a.m.u., not that a specific amount of the isotope ²⁰⁶Pb (in e.g., µg/g) is present in the sample.";
                uialert(app.TableBuilderUIFigure,message,"Warning", ...
                    "Icon","warning");
            end

        end

        % Value changed function: MajorsasoxideswtCheckBox
        function MajorsasoxideswtCheckBoxValueChanged(app, event)
            value = app.MajorsasoxideswtCheckBox.Value;

            if value == 1
                message = "Oxide conversion factors are taken from the current Oxides.csv configuration (the default Total Oxide Calculations folder), not from the settings used when each individual session was originally quantified. If a session used a different Oxides.csv (e.g. different conversion factors or major-element settings), its oxide values may be computed with different factors than what was used during quantification.";
                uialert(app.TableBuilderUIFigure, message, "Warning", "Icon", "warning");
            end

        end

        % Callback function
        function devButtonPushed(app, event)


        end

        % Value changed function: ElementListBox
        function ElementListBoxValueChanged(app, event)
            updateStitchVisibility(app);

        end

        % Button pushed function: PlotLinescanButton
        function FetchDataButtonPushed(app, event)
            progress = uiprogressdlg(app.TableBuilderUIFigure, 'Title', 'ICP-Base', ...
                'Message', 'Fetching data...', 'Cancelable', 'off', 'Indeterminate', 'on');
            build_stitching_table(app)
            delete(progress)

        end

        % Button pushed function: PlotButton
        function PlotButtonPushed(app, event)
            if isempty(app.Base_Table_for_stitching) || height(app.Base_Table_for_stitching) == 0
                uialert(app.TableBuilderUIFigure, 'No data loaded. Press Fetch Data first.', 'Plot');
                return
            end

            T        = app.Base_Table_for_stitching;
            varNames = T.Properties.VariableNames;
            metaCols = {'Session', 'Spotname'};
            allElements = varNames(~ismember(varNames, metaCols));

            name1 = strtrim(app.Linescan1EditField.Value);
            name2 = strtrim(app.Linescan2EditField.Value);

            matchLS = @(spot, name) ~cellfun('isempty', regexp(cellstr(string(spot)), ...
                ['(?<![0-9])', regexptranslate('escape', char(name)), '(?![0-9])'], 'once'));

            mask1 = matchLS(T.Spotname, name1);
            mask2 = matchLS(T.Spotname, name2);

            if ~any(mask1)
                uialert(app.TableBuilderUIFigure, sprintf('No data found for "%s".', name1), 'Plot'); return
            end
            if ~any(mask2)
                uialert(app.TableBuilderUIFigure, sprintf('No data found for "%s".', name2), 'Plot'); return
            end

            if isempty(app.StitchFigure) || ~isvalid(app.StitchFigure)
                app.StitchFigure = figure('Name', 'Linescan Stitching', 'NumberTitle', 'off');
            else
                clf(app.StitchFigure);
            end

            app.StitchAxes = axes(app.StitchFigure);
            hold(app.StitchAxes, 'on');

            nElem = numel(allElements);
            app.StitchElements = allElements;
            app.StitchLine1    = gobjects(nElem, 1);
            app.StitchLine2    = gobjects(nElem, 1);
            colors = lines(nElem);

            for e = 1:nElem
                col1 = double(T{mask1, allElements{e}});
                col2 = double(T{mask2, allElements{e}});
                c = colors(e, :);
                app.StitchLine1(e) = plot(app.StitchAxes, (1:numel(col1))', col1, '-',  'Color', c, 'LineWidth', 3, 'DisplayName', allElements{e});
                app.StitchLine2(e) = plot(app.StitchAxes, (1:numel(col2))', col2, '-', 'Color', c, 'LineWidth', 1, 'HandleVisibility', 'off');
            end

            hold(app.StitchAxes, 'off');
            box(app.StitchAxes, 'on');
            grid(app.StitchAxes, 'on');
            app.StitchAxes.YMinorGrid = 'on';
            xlabel(app.StitchAxes, 'Data points');
            if app.logscaleCheckBox.Value
                set(app.StitchAxes, 'YScale', 'log');
            end

            updateStitchVisibility(app);

            app.StitchN1     = sum(mask1);
            app.StitchN2     = sum(mask2);
            app.StitchOffset = 0;

            x1 = (1:app.StitchN1)';
            x2 = (app.StitchN1+1 : app.StitchN1+app.StitchN2)';
            for e = 1:nElem
                app.StitchLine1(e).XData = x1;
                app.StitchLine2(e).XData = x2;
            end

            maxOv = max(1, app.MaxoverlapDatapointsEditField.Value);
            app.OffsetSlider.Limits = [0, maxOv];
            app.OffsetSlider.Value  = maxOv;

        end

        % Value changed function: logscaleCheckBox
        function logscaleCheckBoxValueChanged(app, event)
            if isempty(app.StitchAxes) || ~isvalid(app.StitchAxes)
                return
            end
            if app.logscaleCheckBox.Value
                set(app.StitchAxes, 'YScale', 'log');
            else
                set(app.StitchAxes, 'YScale', 'linear');
            end

        end

        % Value changed function: MaxoverlapDatapointsEditField
        function MaxoverlapDatapointsEditFieldValueChanged(app, event)
            maxOv = max(1, app.MaxoverlapDatapointsEditField.Value);
            app.StitchOffset = 0;
            app.OffsetSlider.Limits          = [0, maxOv];
            app.OffsetSlider.Value           = maxOv;

            updateStitchOffset(app);
        end

        % Button pushed function: MoveLeftButton
        function MoveLeftButtonPushed(app, event)
            app.StitchOffset = min(app.StitchOffset + 1, app.OffsetSlider.Limits(2));
            updateStitchOffset(app);
        end

        % Button pushed function: MoveRightButton
        function MoveRightButtonPushed(app, event)
            app.StitchOffset = max(app.StitchOffset - 1, 0);
            updateStitchOffset(app);
        end

        % Button pushed function: ConfirmcurrentstitchButton
        function ConfirmcurrentstitchButtonPushed(app, event)
            name1 = strtrim(app.Linescan1EditField.Value);
            name2 = strtrim(app.Linescan2EditField.Value);

            if isempty(name1) || isempty(name2)
                uialert(app.TableBuilderUIFigure, 'Enter both linescan names before confirming.', 'Confirm Stitch');
                return
            end

            sourceTag = str2double(app.UsedatafromButtonGroup.SelectedObject.Tag);

            if sourceTag == 1 || sourceTag == 2
                embed2in1 = (app.StitchOffset >= app.StitchN2 && app.StitchOffset <= app.StitchN1);
                embed1in2 = (app.StitchOffset >= app.StitchN1 && app.StitchOffset <= app.StitchN2);
                if embed2in1 || embed1in2
                    uialert(app.TableBuilderUIFigure, ...
                        'One linescan is fully enclosed within the other at the current offset. Use "Embed 1 in 2" or "Embed 2 in 1" instead.', ...
                        'Confirm Stitch');
                    return
                end
            elseif sourceTag == 3
                if ~(app.StitchOffset >= app.StitchN1 && app.StitchOffset <= app.StitchN2)
                    uialert(app.TableBuilderUIFigure, ...
                        'Linescan 1 is not fully contained within linescan 2 at the current offset. Adjust the overlap first.', ...
                        'Confirm Stitch');
                    return
                end
            elseif sourceTag == 4
                if ~(app.StitchOffset >= app.StitchN2 && app.StitchOffset <= app.StitchN1)
                    uialert(app.TableBuilderUIFigure, ...
                        'Linescan 2 is not fully contained within linescan 1 at the current offset. Adjust the overlap first.', ...
                        'Confirm Stitch');
                    return
                end
            end

            sourceLabels = {'Linescan 1', 'Linescan 2', 'Embed 1 in 2', 'Embed 2 in 1'};
            dataSource = sourceLabels{sourceTag};

            newRow = {name1, name2, app.StitchOffset, dataSource};

            if isempty(app.StitchConfig)
                app.StitchConfig = cell2table(newRow, 'VariableNames', {'Linescan1', 'Linescan2', 'Overlap', 'Data from'});
            else
                app.StitchConfig = [app.StitchConfig; cell2table(newRow, 'VariableNames', {'Linescan1', 'Linescan2', 'Overlap', 'Data from'})];
            end

            app.StitchConfigUITable.Data = app.StitchConfig;
            app.StitchConfigUITable.ColumnName = {'Linescan 1', 'Linescan 2', 'Overlap (datapoints)', 'Data from'};
        end

        % Button pushed function: ExportstitchedtableButton
        function ExportstitchedtableButtonPushed(app, event)
            if isempty(app.StitchConfig) || height(app.StitchConfig) == 0
                uialert(app.TableBuilderUIFigure, 'No stitch configuration. Confirm at least one stitch first.', 'Export');
                return
            end

            progress = uiprogressdlg(app.TableBuilderUIFigure, 'Title', 'ICP-Base', ...
                'Message', 'Building stitched table...', 'Cancelable', 'off', 'Indeterminate', 'on');
            try
                Base_Table = build_assigned_table_from_base(app);
                if app.MajorsasoxideswtCheckBox.Value
                    Base_Table = convert_majors_to_oxides_base_table(app, Base_Table);
                end
                if app.ExcludeCalibratorsCheckBox.Value
                    Base_Table = exclude_CALs(app, Base_Table);
                end
                T = Base_Table;

                % #1: collision-proof matcher — name must not be flanked by digits,
                % so "... - 1" no longer matches "... - 10", "... - 11", etc.
                matchLS = @(spot, name) ~cellfun('isempty', regexp(cellstr(string(spot)), ...
                    ['(?<![0-9])', regexptranslate('escape', char(name)), '(?![0-9])'], 'once'));

                cfg     = app.StitchConfig;
                running = T(matchLS(T.Spotname, cfg.Linescan1{1}), :);

                for r = 1:height(cfg)
                    row      = cfg(r, :);
                    name1    = row.Linescan1{1};
                    name2    = row.Linescan2{1};
                    overlap  = row.Overlap;
                    dataFrom = char(row{1, 4});
                    T2       = T(matchLS(T.Spotname, name2), :);
                    N2       = height(T2);
                    nRun     = height(running);

                    switch dataFrom
                        case 'Linescan 1'
                            if overlap < 0 || overlap > N2
                                error('Row %d (%s \x2192 %s): overlap %d must be between 0 and %d (length of Linescan 2).', ...
                                    r, name1, name2, overlap, N2);
                            end
                            running = [running; T2(overlap+1:N2, :)];

                        case 'Linescan 2'
                            if overlap < 0 || overlap > nRun
                                error('Row %d (%s \x2192 %s): overlap %d exceeds current running length %d.', ...
                                    r, name1, name2, overlap, nRun);
                            end
                            running = [running(1:nRun-overlap, :); T2];

                        case 'Embed 2 in 1'
                            T1 = T(matchLS(T.Spotname, name1), :);
                            N1 = height(T1);
                            if overlap < N2 || overlap > N1
                                error('Row %d embed (%s in %s): overlap %d must be between %d (embedded length) and %d (container length).', ...
                                    r, name2, name1, overlap, N2, N1);
                            end
                            startRow = N1 + 1 - overlap;
                            endRow   = N1 + N2 - overlap;
                            modified = [T1(1:startRow-1, :); T2; T1(endRow+1:N1, :)];   % index-aligned with T1, length N1
                            running  = spliceEmbed(app, running, modified, T1, name1, matchLS, r);

                        case 'Embed 1 in 2'
                            T1 = T(matchLS(T.Spotname, name1), :);
                            N1 = height(T1);
                            if overlap < N1 || overlap > N2
                                error('Row %d embed (%s in %s): overlap %d must be between %d (embedded length) and %d (container length).', ...
                                    r, name1, name2, overlap, N1, N2);
                            end
                            startRow_in_T2 = overlap - N1 + 1;
                            modified       = [T2(1:startRow_in_T2-1, :); T1; T2(overlap+1:N2, :)];  % index-aligned with T2, length N2
                            running        = spliceEmbed(app, running, modified, T2, name2, matchLS, r);
                    end
                end
            catch ME
                delete(progress);
                uialert(app.TableBuilderUIFigure, ME.message, 'Export Error');
                return
            end
            delete(progress);

            f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
            [file, path] = uiputfile('*.csv', 'Save stitched table');
            delete(f);
            figure(app.TableBuilderUIFigure);
            if isequal(file, 0), return; end

            try
                writetable(running, fullfile(path, file), 'Delimiter', ',', 'Encoding', 'UTF-8');
            catch ME
                uialert(app.TableBuilderUIFigure, ME.message, 'Export Error');
            end

        end

        % Button pushed function: RemovelaststitchButton
        function RemovelaststitchButtonPushed(app, event)
            if isempty(app.StitchConfig) || height(app.StitchConfig) == 0
                return
            end
            app.StitchConfig(end, :) = [];
            app.StitchConfigUITable.Data = app.StitchConfig;
        end

        % Value changing function: OffsetSlider
        function OffsetSliderValueChanging(app, event)
            app.StitchOffset = round(app.OffsetSlider.Limits(2) - event.Value);
            updateStitchOffset(app);
        end

        % Button pushed function: ExportstitchingconfigButton
        function ExportstitchingconfigButtonPushed(app, event)
            if isempty(app.StitchConfig) || height(app.StitchConfig) == 0
                uialert(app.TableBuilderUIFigure, 'No stitch config to export.', 'Export');
                return
            end
            f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
            [file, path] = uiputfile('*.csv', 'Save stitching config');
            delete(f);
            figure(app.TableBuilderUIFigure);
            if isequal(file, 0), return; end
            writetable(app.StitchConfig, fullfile(path, file), 'Delimiter', ',', 'Encoding', 'UTF-8');

        end

        % Button pushed function: ImportstitchingconfigButton
        function ImportstitchingconfigButtonPushed(app, event)
            f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
            [file, path] = uigetfile('*.csv', 'Load stitching config');
            delete(f);
            figure(app.TableBuilderUIFigure);
            if isequal(file, 0), return; end
            try
                app.StitchConfig = readtable(fullfile(path, file), 'TextType', 'string', 'Delimiter', ',', 'Encoding', 'UTF-8');
                app.StitchConfig.Properties.VariableNames{4} = 'Data from';
                app.StitchConfigUITable.Data = app.StitchConfig;
                app.StitchConfigUITable.ColumnName = {'Linescan 1', 'Linescan 2', 'Overlap (datapoints)', 'Data from'};
            catch ME
                uialert(app.TableBuilderUIFigure, ME.message, 'Import Error');
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create TableBuilderUIFigure and hide until all components are created
            app.TableBuilderUIFigure = uifigure('Visible', 'off');
            app.TableBuilderUIFigure.Position = [100 100 640 480];
            app.TableBuilderUIFigure.Name = 'Table Builder';
            app.TableBuilderUIFigure.Icon = 'icon_48.png';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.TableBuilderUIFigure);
            app.TabGroup.Position = [1 1 640 480];

            % Create DataselectionTab
            app.DataselectionTab = uitab(app.TabGroup);
            app.DataselectionTab.Title = 'Data selection';

            % Create ProjectSessionTree
            app.ProjectSessionTree = uitree(app.DataselectionTab, 'checkbox');
            app.ProjectSessionTree.Position = [33 88 226 354];

            % Assign Checked Nodes
            app.ProjectSessionTree.CheckedNodesChangedFcn = createCallbackFcn(app, @ProjectSessionTreeCheckedNodesChanged, true);

            % Create ExportcsvTableButton
            app.ExportcsvTableButton = uibutton(app.DataselectionTab, 'push');
            app.ExportcsvTableButton.ButtonPushedFcn = createCallbackFcn(app, @ExportcsvTableButtonPushed, true);
            app.ExportcsvTableButton.Position = [353 5 113 34];
            app.ExportcsvTableButton.Text = 'Export .csv Table';

            % Create ProceedtoVisModuleButton
            app.ProceedtoVisModuleButton = uibutton(app.DataselectionTab, 'push');
            app.ProceedtoVisModuleButton.ButtonPushedFcn = createCallbackFcn(app, @ProceedtoVisModuleButtonPushed, true);
            app.ProceedtoVisModuleButton.Position = [500 5 133 34];
            app.ProceedtoVisModuleButton.Text = 'Proceed to VisModule';

            % Create SelectionModeDropDownLabel
            app.SelectionModeDropDownLabel = uilabel(app.DataselectionTab);
            app.SelectionModeDropDownLabel.HorizontalAlignment = 'right';
            app.SelectionModeDropDownLabel.Position = [341 420 92 22];
            app.SelectionModeDropDownLabel.Text = 'Selection Mode:';

            % Create SelectionModeDropDown
            app.SelectionModeDropDown = uidropdown(app.DataselectionTab);
            app.SelectionModeDropDown.Items = {'Simple', 'Advanced'};
            app.SelectionModeDropDown.ValueChangedFcn = createCallbackFcn(app, @SelectionModeDropDownValueChanged, true);
            app.SelectionModeDropDown.Position = [448 415 110 32];
            app.SelectionModeDropDown.Value = 'Simple';

            % Create AdvancedPanel
            app.AdvancedPanel = uipanel(app.DataselectionTab);
            app.AdvancedPanel.BorderType = 'none';
            app.AdvancedPanel.Position = [307 42 278 363];

            % Create SpotMetaTree
            app.SpotMetaTree = uitree(app.AdvancedPanel, 'checkbox');
            app.SpotMetaTree.Position = [34 10 209 354];

            % Create SimplePanel
            app.SimplePanel = uipanel(app.DataselectionTab);
            app.SimplePanel.BorderType = 'none';
            app.SimplePanel.Position = [307 42 278 363];

            % Create IfyouexportthetableorproceedtotheVisModulewithLabel
            app.IfyouexportthetableorproceedtotheVisModulewithLabel = uilabel(app.SimplePanel);
            app.IfyouexportthetableorproceedtotheVisModulewithLabel.WordWrap = 'on';
            app.IfyouexportthetableorproceedtotheVisModulewithLabel.Position = [30 160 218 154];
            app.IfyouexportthetableorproceedtotheVisModulewithLabel.Text = {'Exporting the table or proceeding to the VisModule with Simple selection mode (currently active) will include all LOD filtered mass fraction data, reported in µg/g except for oxides, which are expressed as wt%.'; ''; 'To include CPS data, limits of detection, sensitivities, or LA/ICP-MS metadata in the table, switch the selection mode to Advanced.'};

            % Create RemovemassesfromelementnameCheckBox
            app.RemovemassesfromelementnameCheckBox = uicheckbox(app.DataselectionTab);
            app.RemovemassesfromelementnameCheckBox.ValueChangedFcn = createCallbackFcn(app, @RemovemassesfromelementnameCheckBoxValueChanged, true);
            app.RemovemassesfromelementnameCheckBox.Text = 'Remove masses from element name';
            app.RemovemassesfromelementnameCheckBox.Position = [36 51 220 29];
            app.RemovemassesfromelementnameCheckBox.Value = true;

            % Create MajorsasoxideswtCheckBox
            app.MajorsasoxideswtCheckBox = uicheckbox(app.DataselectionTab);
            app.MajorsasoxideswtCheckBox.ValueChangedFcn = createCallbackFcn(app, @MajorsasoxideswtCheckBoxValueChanged, true);
            app.MajorsasoxideswtCheckBox.Text = 'Majors as oxides (wt%)';
            app.MajorsasoxideswtCheckBox.Position = [36 32 220 20];

            % Create ExcludeCalibratorsCheckBox
            app.ExcludeCalibratorsCheckBox = uicheckbox(app.DataselectionTab);
            app.ExcludeCalibratorsCheckBox.Text = 'Exclude Calibrators';
            app.ExcludeCalibratorsCheckBox.Position = [36 6 220 22];
            app.ExcludeCalibratorsCheckBox.Value = true;

            % Create LinescanstitchingoptionalTab
            app.LinescanstitchingoptionalTab = uitab(app.TabGroup);
            app.LinescanstitchingoptionalTab.Title = 'Linescan stitching (optional)';

            % Create Linescan1EditFieldLabel
            app.Linescan1EditFieldLabel = uilabel(app.LinescanstitchingoptionalTab);
            app.Linescan1EditFieldLabel.HorizontalAlignment = 'right';
            app.Linescan1EditFieldLabel.Position = [15 384 67 22];
            app.Linescan1EditFieldLabel.Text = 'Linescan 1:';

            % Create Linescan1EditField
            app.Linescan1EditField = uieditfield(app.LinescanstitchingoptionalTab, 'text');
            app.Linescan1EditField.Position = [97 381 103 28];

            % Create Linescan2EditFieldLabel
            app.Linescan2EditFieldLabel = uilabel(app.LinescanstitchingoptionalTab);
            app.Linescan2EditFieldLabel.HorizontalAlignment = 'right';
            app.Linescan2EditFieldLabel.Position = [15 351 67 22];
            app.Linescan2EditFieldLabel.Text = 'Linescan 2:';

            % Create Linescan2EditField
            app.Linescan2EditField = uieditfield(app.LinescanstitchingoptionalTab, 'text');
            app.Linescan2EditField.Position = [97 348 103 28];

            % Create ElementListBox
            app.ElementListBox = uilistbox(app.LinescanstitchingoptionalTab);
            app.ElementListBox.Items = {};
            app.ElementListBox.Multiselect = 'on';
            app.ElementListBox.ValueChangedFcn = createCallbackFcn(app, @ElementListBoxValueChanged, true);
            app.ElementListBox.Position = [571 21 62 280];
            app.ElementListBox.Value = {};

            % Create PlotLinescanButton
            app.PlotLinescanButton = uibutton(app.LinescanstitchingoptionalTab, 'push');
            app.PlotLinescanButton.ButtonPushedFcn = createCallbackFcn(app, @FetchDataButtonPushed, true);
            app.PlotLinescanButton.Position = [15 415 182 36];
            app.PlotLinescanButton.Text = 'Fetch Data';

            % Create PlotButton
            app.PlotButton = uibutton(app.LinescanstitchingoptionalTab, 'push');
            app.PlotButton.ButtonPushedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.PlotButton.Position = [15 269 185 35];
            app.PlotButton.Text = 'Plot';

            % Create MoveLeftButton
            app.MoveLeftButton = uibutton(app.LinescanstitchingoptionalTab, 'push');
            app.MoveLeftButton.ButtonPushedFcn = createCallbackFcn(app, @MoveLeftButtonPushed, true);
            app.MoveLeftButton.Position = [14 222 83 39];
            app.MoveLeftButton.Text = '<';

            % Create MoveRightButton
            app.MoveRightButton = uibutton(app.LinescanstitchingoptionalTab, 'push');
            app.MoveRightButton.ButtonPushedFcn = createCallbackFcn(app, @MoveRightButtonPushed, true);
            app.MoveRightButton.Position = [421 222 83 39];
            app.MoveRightButton.Text = '>';

            % Create UsedatafromButtonGroup
            app.UsedatafromButtonGroup = uibuttongroup(app.LinescanstitchingoptionalTab);
            app.UsedatafromButtonGroup.Title = 'Use data from:';
            app.UsedatafromButtonGroup.Position = [208 278 100 149];

            % Create usels1Button
            app.usels1Button = uitogglebutton(app.UsedatafromButtonGroup);
            app.usels1Button.Tag = '1';
            app.usels1Button.Text = '<';
            app.usels1Button.Position = [16 105 67 22];
            app.usels1Button.Value = true;

            % Create usels2Button
            app.usels2Button = uitogglebutton(app.UsedatafromButtonGroup);
            app.usels2Button.Tag = '2';
            app.usels2Button.Text = '<';
            app.usels2Button.Position = [16 73 67 22];

            % Create Embed1in2Button
            app.Embed1in2Button = uitogglebutton(app.UsedatafromButtonGroup);
            app.Embed1in2Button.Tag = '3';
            app.Embed1in2Button.Text = 'Embed 1 in 2';
            app.Embed1in2Button.Position = [7 34 86 22];

            % Create Embed2in1Button
            app.Embed2in1Button = uitogglebutton(app.UsedatafromButtonGroup);
            app.Embed2in1Button.Tag = '4';
            app.Embed2in1Button.Text = 'Embed 2 in 1';
            app.Embed2in1Button.Position = [7 5 86 22];

            % Create MaxoverlapDatapointsLabel
            app.MaxoverlapDatapointsLabel = uilabel(app.LinescanstitchingoptionalTab);
            app.MaxoverlapDatapointsLabel.HorizontalAlignment = 'right';
            app.MaxoverlapDatapointsLabel.WordWrap = 'on';
            app.MaxoverlapDatapointsLabel.FontSize = 10;
            app.MaxoverlapDatapointsLabel.Position = [9 312 115 22];
            app.MaxoverlapDatapointsLabel.Text = 'Max overlap (Datapoints):';

            % Create MaxoverlapDatapointsEditField
            app.MaxoverlapDatapointsEditField = uieditfield(app.LinescanstitchingoptionalTab, 'numeric');
            app.MaxoverlapDatapointsEditField.Limits = [1 Inf];
            app.MaxoverlapDatapointsEditField.RoundFractionalValues = 'on';
            app.MaxoverlapDatapointsEditField.ValueChangedFcn = createCallbackFcn(app, @MaxoverlapDatapointsEditFieldValueChanged, true);
            app.MaxoverlapDatapointsEditField.Position = [129 312 71 23];
            app.MaxoverlapDatapointsEditField.Value = 1;

            % Create logscaleCheckBox
            app.logscaleCheckBox = uicheckbox(app.LinescanstitchingoptionalTab);
            app.logscaleCheckBox.ValueChangedFcn = createCallbackFcn(app, @logscaleCheckBoxValueChanged, true);
            app.logscaleCheckBox.Text = 'log-scale';
            app.logscaleCheckBox.Position = [444 373 72 30];
            app.logscaleCheckBox.Value = true;

            % Create ConfirmcurrentstitchButton
            app.ConfirmcurrentstitchButton = uibutton(app.LinescanstitchingoptionalTab, 'push');
            app.ConfirmcurrentstitchButton.ButtonPushedFcn = createCallbackFcn(app, @ConfirmcurrentstitchButtonPushed, true);
            app.ConfirmcurrentstitchButton.Position = [21 18 188 49];
            app.ConfirmcurrentstitchButton.Text = 'Confirm current stitch';

            % Create ExportstitchedtableButton
            app.ExportstitchedtableButton = uibutton(app.LinescanstitchingoptionalTab, 'push');
            app.ExportstitchedtableButton.ButtonPushedFcn = createCallbackFcn(app, @ExportstitchedtableButtonPushed, true);
            app.ExportstitchedtableButton.Position = [234 18 188 49];
            app.ExportstitchedtableButton.Text = 'Export stitched table';

            % Create StitchConfigUITable
            app.StitchConfigUITable = uitable(app.LinescanstitchingoptionalTab);
            app.StitchConfigUITable.ColumnName = '';
            app.StitchConfigUITable.RowName = {};
            app.StitchConfigUITable.Position = [22 79 320 123];

            % Create RemovelaststitchButton
            app.RemovelaststitchButton = uibutton(app.LinescanstitchingoptionalTab, 'push');
            app.RemovelaststitchButton.ButtonPushedFcn = createCallbackFcn(app, @RemovelaststitchButtonPushed, true);
            app.RemovelaststitchButton.Position = [362 159 125 42];
            app.RemovelaststitchButton.Text = 'Remove last stitch';

            % Create OffsetSlider
            app.OffsetSlider = uislider(app.LinescanstitchingoptionalTab);
            app.OffsetSlider.ValueChangingFcn = createCallbackFcn(app, @OffsetSliderValueChanging, true);
            app.OffsetSlider.Position = [110 248 291 7];

            % Create ExportstitchingconfigButton
            app.ExportstitchingconfigButton = uibutton(app.LinescanstitchingoptionalTab, 'push');
            app.ExportstitchingconfigButton.ButtonPushedFcn = createCallbackFcn(app, @ExportstitchingconfigButtonPushed, true);
            app.ExportstitchingconfigButton.Position = [362 114 125 28];
            app.ExportstitchingconfigButton.Text = 'Export stitching config';

            % Create ImportstitchingconfigButton
            app.ImportstitchingconfigButton = uibutton(app.LinescanstitchingoptionalTab, 'push');
            app.ImportstitchingconfigButton.ButtonPushedFcn = createCallbackFcn(app, @ImportstitchingconfigButtonPushed, true);
            app.ImportstitchingconfigButton.Position = [362 84 125 28];
            app.ImportstitchingconfigButton.Text = 'Import stitching config';

            % Create ContextMenu
            app.ContextMenu = uicontextmenu(app.TableBuilderUIFigure);

            % Create ExportasmatMenu
            app.ExportasmatMenu = uimenu(app.ContextMenu);
            app.ExportasmatMenu.MenuSelectedFcn = createCallbackFcn(app, @ExportasmatMenuSelected, true);
            app.ExportasmatMenu.Text = 'Export as .mat';
            
            % Assign app.ContextMenu
            app.ExportcsvTableButton.ContextMenu = app.ContextMenu;

            % Show the figure after all components are created
            app.TableBuilderUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Table_builder_Submodule_readable(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.TableBuilderUIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.TableBuilderUIFigure)
        end
    end
end