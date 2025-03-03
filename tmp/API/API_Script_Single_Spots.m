try
    delete(sourceapp_MIQAS)
    delete(imp_mod)
    delete(int_mod)
catch ME
    disp("help")
end

clear
clc


sourceapp_MIQAS=MIQAS;
settings.sourceapp_MIQAS = sourceapp_MIQAS;

imp_mod = Import_Module(sourceapp_MIQAS);

settings.import_module_GUI_update_state = true;
settings.MIQAS_GUI_update_state = true;


settings.session_name = "Flincs_135_141";
settings.session_id = 1;

settings.project_name = "Flincs";
settings.project_id = 1;

% Hardcoded folder path
folder_path = "D:\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Inclusion Analysis\26.03.2024\Cut Signals";

% Get list of all CSV files in the selected folder
% files = dir(fullfile(folder_path, '*.csv'));
% measurementpath = fullfile({files.folder}, {files.name});

% Get list of all CSV files in the selected folder
files = dir(fullfile(folder_path, '*.csv'));

% Sort files by date and time they were last modified
[~, idx] = sort([files.datenum]);
files = files(idx);

measurementpath = fullfile({files.folder}, {files.name});

settings.massspec.Value = repmat({"Agilent 7900"}, 1, numel(measurementpath));

dwelltimepath = "D:\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Inclusion Analysis\AcqMethod.xml";
settings.dwelltime.Value = "Agilent AcqMethod.xml";

settings.import_module_GUI_update_state = true;
settings.MIQAS_GUI_update_state = true;
settings.classification_module_GUI_update_state = true;

for i = 1:numel(measurementpath)

    current_settings = settings;
    if isfield(settings, 'massspec') && isfield(settings.massspec, 'Value')
        current_settings.massspec.Value = settings.massspec.Value{i};
    end
    if isfield(settings, 'session_name')
        current_settings.session_name = settings.session_name;
    end
    if isfield(settings, 'session_id')
        current_settings.session_id = settings.session_id;
    end
    if isfield(settings, 'project_name')
        current_settings.project_name = settings.project_name;
    end
    if isfield(settings, 'project_id')
        current_settings.project_id = settings.project_id;
    end

    current_settings.dwelltime.Value = settings.dwelltime.Value;

    file_path = string(measurementpath{i});

    [~] = single_spot_import_public(imp_mod, file_path, dwelltimepath, current_settings);
    
end

int_mod = Interval_Module(sourceapp_MIQAS, settings.project_name, settings.project_id, settings.session_id, imp_mod.base.project);

delete(imp_mod)
settings.interval_module_GUI_update_state = true;

%settings.bg_lower_indent = 20;
%settings.bg_upper_indent = 20;
set_automatic_background(int_mod, settings)

%settings.matrix_lower_indent = 5;
%settings.matrix_upper_indent = 5;
set_automatic_matrix(int_mod, settings)

settings.spike_elimination = false;
% just comment out the spike_elimination_spotnumber to get a global spike
% elimination for all spots
%settings.spike_elimination_spotnumber = [1,2,3, 4,5,6,    50,51,52,   53,54,55,   109, 110, 111,  112,113,114];
spike_elimination_public(int_mod, settings)


clas_mod = Classification_Module(sourceapp_MIQAS, settings.project_name, settings.project_id, settings.session_id, int_mod.base.project);
delete(int_mod)

settings.spotnumber = [1,2,3, 4,5,6,...
   50,51,52,   53,54,55,...
   109, 110, 111,    112,113,114];
settings.type = ["PRM", "PRM", "PRM", "PRM", "PRM", "PRM",...
    "PRM", "PRM", "PRM", "PRM", "PRM", "PRM",...
    "PRM", "PRM", "PRM", "PRM", "PRM", "PRM", ];
settings.referencematerial = ["GSD_1G", "GSD_1G", "GSD_1G", "Sca_17", "Sca_17", "Sca_17",...
    "Sca_17", "Sca_17", "Sca_17", "GSD_1G", "GSD_1G", "GSD_1G",...
    "Sca_17", "Sca_17", "Sca_17", "GSD_1G", "GSD_1G", "GSD_1G", ];
settings.bracket_id = [1,1,1, 1,1,1,...
    1,1,1, 1,1,1,...
    1,1,1, 1,1,1];

assign_spots_to_reference_materials(clas_mod, settings)


drift_mod = Drift_Module(sourceapp_MIQAS, settings.project_name, settings.project_id, settings.session_id, clas_mod.base.project);
delete(clas_mod)




%% Perkin Elmers

try
    delete(sourceapp_MIQAS)
    delete(imp_mod)
    delete(int_mod)
catch ME
    disp("help")
end

clear
clc


sourceapp_MIQAS=MIQAS;
settings.sourceapp_MIQAS = sourceapp_MIQAS;

imp_mod = Import_Module(sourceapp_MIQAS);

settings.import_module_GUI_update_state = true;
settings.MIQAS_GUI_update_state = true;


settings.session_name = "Flincs_135_141";
settings.session_id = 1;

settings.project_name = "Flincs";
settings.project_id = 1;

% Hardcoded folder path
folder_path = "D:\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Bulks\2024_raw-data\11_Jn";

% Get list of all CSV files in the selected folder
files = dir(fullfile(folder_path, '*.xl'));
measurementpath = fullfile({files.folder}, {files.name});

settings.massspec.Value = repmat({"Perkin Elmers"}, 1, numel(measurementpath));

dwelltimepath = "D:\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Inclusion Analysis\AcqMethod.xml";
settings.dwelltime.Value = "Agilent AcqMethod.xml";

settings.import_module_GUI_update_state = true;
settings.MIQAS_GUI_update_state = true;

for i = 1:numel(measurementpath)

    current_settings = settings;
    if isfield(settings, 'massspec') && isfield(settings.massspec, 'Value')
        current_settings.massspec.Value = settings.massspec.Value{i};
    end
    if isfield(settings, 'session_name')
        current_settings.session_name = settings.session_name;
    end
    if isfield(settings, 'session_id')
        current_settings.session_id = settings.session_id;
    end
    if isfield(settings, 'project_name')
        current_settings.project_name = settings.project_name;
    end
    if isfield(settings, 'project_id')
        current_settings.project_id = settings.project_id;
    end

    current_settings.dwelltime.Value = settings.dwelltime.Value;

    file_path = string(measurementpath{i});

    [~] = single_spot_import_public(imp_mod, file_path, dwelltimepath, current_settings);
    
end

int_mod = Interval_Module(sourceapp_MIQAS, settings.project_name, settings.project_id, settings.session_id, imp_mod.base.project);

delete(imp_mod)

settings.interval_module_GUI_update_state = true;




%% demo files agilent 7900


try
    delete(sourceapp_MIQAS)
    delete(imp_mod)
    delete(int_mod)
catch ME
    disp("help")
end

clear
clc


sourceapp_MIQAS=MIQAS;
settings.sourceapp_MIQAS = sourceapp_MIQAS;

imp_mod = Import_Module(sourceapp_MIQAS);

settings.import_module_GUI_update_state = true;
settings.MIQAS_GUI_update_state = true;


settings.session_name = "demo_Files";
settings.session_id = 1;

settings.project_name = "Demo";
settings.project_id = 1;

measurementpath = ["D:\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\demo_files_shot_by_shot\demo_fi01.csv",...
                    "D:\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\demo_files_shot_by_shot\demo_fi02.csv",...
                    "D:\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\demo_files_shot_by_shot\demo_fi03.csv",...
                    "D:\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\demo_files_shot_by_shot\demo_fi04.csv",...
                    "D:\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\demo_files_shot_by_shot\demo_fi05.csv",...
                    "D:\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\demo_files_shot_by_shot\demo_fi06.csv",...
                    "D:\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\demo_files_shot_by_shot\demo_fi07.csv",...
                    "D:\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\demo_files_shot_by_shot\demo_fi08.csv",...
                    "D:\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\demo_files_shot_by_shot\demo_fi09.csv",...
                    "D:\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\demo_files_shot_by_shot\demo_fi10.csv",...
                    "D:\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\demo_files_shot_by_shot\demo_fi11.csv",...
                    "D:\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\demo_files_shot_by_shot\demo_fi12.csv",...
                    "D:\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\demo_files_shot_by_shot\demo_fi13.csv"];

settings.massspec.Value = ["Agilent 7900","Agilent 7900","Agilent 7900","Agilent 7900","Agilent 7900","Agilent 7900","Agilent 7900","Agilent 7900",...
                            "Agilent 7900","Agilent 7900","Agilent 7900","Agilent 7900","Agilent 7900"];

dwelltimepath = "D:\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\Alm06_Min\AcqMethod.xml";
settings.dwelltime.Value = "Agilent AcqMethod.xml";

settings.import_module_GUI_update_state = true;
settings.MIQAS_GUI_update_state = true;

for i = 1:numel(measurementpath)

    current_settings = settings;
    if isfield(settings, 'massspec') && isfield(settings.massspec, 'Value')
        current_settings.massspec.Value = settings.massspec.Value{i};
    end
    if isfield(settings, 'session_name')
        current_settings.session_name = settings.session_name;
    end
    if isfield(settings, 'session_id')
        current_settings.session_id = settings.session_id;
    end
    if isfield(settings, 'project_name')
        current_settings.project_name = settings.project_name;
    end
    if isfield(settings, 'project_id')
        current_settings.project_id = settings.project_id;
    end

    [~] = single_spot_import_public(imp_mod, measurementpath(i), dwelltimepath, current_settings);

end




