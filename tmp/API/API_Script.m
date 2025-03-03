try
    delete(sourceapp_MIQAS)
    delete(imp_mod)
    delete(int_mod)
    delete(clas_mod)
    delete(drift_mod)
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


settings.session_name = "Alm-Min-1";
settings.session_id = 0;

settings.project_name = "Almirez";
settings.project_id = 0;

measurementpath = "C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\Alm06_Min\Alm-Min-1.csv";
settings.massspec.Value = "Agilent 7900";

logfilepath = "C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\Alm06_Min\Alm06_Min_log_20231130_172714.log";
settings.laser.Value = "Resonetics Verbose Log (.log)";

dwelltimepath = "C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\Alm06_Min\AcqMethod.xml";
settings.dwelltime.Value = "Agilent AcqMethod.xml";

settings.import_module_GUI_update_state = true;
settings.MIQAS_GUI_update_state = true;
settings.classification_module_GUI_update_state = true;
settings.reductiontype = 'Matrix';


[~] = measurement_logfile_import_public(imp_mod, measurementpath, logfilepath, dwelltimepath, settings);


% Att the signal detection is a part of the above function but has to be moved
% at some point and done properly
%[imp_mod.base.project.session.spot.signal_starts, imp_mod.base.project.session.spot.signal_ends] = detect_signals(imp_mod.base.project.session.fullsignal_raw, numel(imp_mod.base.project.session.spotname));

int_mod = Interval_Module(sourceapp_MIQAS, settings.project_name, settings.project_id, settings.session_id, imp_mod.base.project);

delete(imp_mod)

settings.interval_module_GUI_update_state = true;

%settings.bg_lower_indent = 20;
%settings.bg_upper_indent = 20;
set_automatic_background(int_mod, settings)

%settings.matrix_lower_indent = 5;
%settings.matrix_upper_indent = 5;
set_automatic_matrix(int_mod, settings)

clas_mod = Classification_Module(sourceapp_MIQAS, settings.project_name, settings.project_id, settings.session_id, int_mod.base.project);

delete(int_mod)

% everything needs to match lengths and PRM and SRM need a type whereas for
% IHRM the type has to be "None".
% Make sure to use the exact same spelling as the .csv reference material
% files are named
% All of this is case sensitive

settings.spotnumber = [1,2,3,   43,44,45,   87,88,89,    133,134,135];
settings.type = ["PRM", "PRM", "PRM",  "PRM", "PRM", "PRM",   "PRM", "PRM", "PRM", "PRM", "PRM", "PRM"];
settings.referencematerial = ["GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G",    "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G"];
settings.bracket_id = [1,1,1, 1,1,1, 1,1,1, 1,1,1];

assign_spots_to_reference_materials(clas_mod, settings)

drift_mod = Drift_Module(sourceapp_MIQAS, settings.project_name, settings.project_id, settings.session_id, clas_mod.base.project);
delete(clas_mod)

%save_to_base(sourceapp_MIQAS, int_mod.project_id, int_mod.base.project.session, int_mod.session_id, int_mod.base.project_name, settings)



% for the referencmaterial and type assignement the user has to input
% indices and the type/refmat as stings, chars


%[settings_default] = measurement_logfile_import_public(imp_mod)


%% asdf

try
    delete(sourceapp_MIQAS)
    delete(imp_mod)
catch ME
    disp("help")
end

clear
clc

sourceapp_MIQAS=MIQAS;
settings.sourceapp_MIQAS = sourceapp_MIQAS;


measurementpath = ["C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\Alm06_Min\Alm-Min-1.csv",...
    "C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\Alm06_Min2\Alm-Min-2.csv",...
    "C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\VaCa-Min-1\VCa-Min-1.csv",...
    "C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\standards_test\standards_test.csv",...
    "C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\Luca Day 1\Silicates-TE.csv",...
    "C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\Natalia Spotsizes\618NW.csv"];

settings.massspec.Value = ["Agilent 7900", "Agilent 7900", "Agilent 7900", "Agilent 7900", "Agilent 7900", "Agilent 7900"];

logfilepath = ["C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\Alm06_Min\Alm06_Min_log_20231130_172714.log",...
    "C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\Alm06_Min2\Alm06_Min2_log_20240117_145530.log",...
    "C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\VaCa-Min-1\VCa-Min-1_log_20240430_153528.log",...
    "C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\standards_test\standards_test_log_20231211_140206.log",...
    "C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\Luca Day 1\201124_TE_log_20241120_162728.log",...
    "C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\Natalia Spotsizes\Natalia Granitoid_log_20241030_133022.log"];

settings.laser.Value = ["Resonetics Verbose Log (.log)", "Resonetics Verbose Log (.log)", "Resonetics Verbose Log (.log)", "Resonetics Verbose Log (.log)", "Resonetics Verbose Log (.log)", "Resonetics Verbose Log (.log)"];

dwelltimepath = ["C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\Alm06_Min\AcqMethod.xml",...
    "C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\Alm06_Min2\AcqMethod.xml",...
    "C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\VaCa-Min-1\AcqMethod.xml",...
    "C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\standards_test\AcqMethod.xml",...
    "C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\Luca Day 1\AcqMethod.xml",...
    "C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\Natalia Spotsizes\AcqMethod.xml"];

settings.dwelltime.Value = ["Agilent AcqMethod.xml", "Agilent AcqMethod.xml", "Agilent AcqMethod.xml", "Agilent AcqMethod.xml", "Agilent AcqMethod.xml", "Agilent AcqMethod.xml"];

settings.project_name = ["Almirez","Almirez", "Alps", "Others", "Others" "Others"];
settings.project_id = [1, 1, 2, 3, 3, 3]; %[0, 0, 0, 0];

settings.session_name = ["Alm-Min-1", "Alm-Min-2", "VCa-Min-1", "standards_test", "Luca Day 1", "Natalia"];
settings.session_id = [0, 0, 0, 0, 0, 0];

settings.MIQAS_GUI_update_state = true;
settings.import_module_GUI_update_state = true;
settings.interval_module_GUI_update_state = true;

%settings.bg_lower_indent = [20, 20, 20, 15, 19];
%settings.bg_upper_indent = [20, 20, 17, 23, 10];

%settings.matrix_lower_indent = [6, 5, 7, 5, 5];
%settings.matrix_upper_indent = [6, 5, 7, 5, 5];

for i = 1:numel(measurementpath)

    current_settings = settings;
    if isfield(settings, 'massspec') && isfield(settings.massspec, 'Value')
        current_settings.massspec.Value = settings.massspec.Value{i};
    end
    if isfield(settings, 'laser') && isfield(settings.laser, 'Value')
        current_settings.laser.Value = settings.laser.Value{i};
    end
    if isfield(settings, 'dwelltime') && isfield(settings.dwelltime, 'Value')
        current_settings.dwelltime.Value = settings.dwelltime.Value{i};
    end
    if isfield(settings, 'session_name')
        current_settings.session_name = settings.session_name{i};
    end
    if isfield(settings, 'session_id')
        current_settings.session_id = settings.session_id(i);
    end
    if isfield(settings, 'project_name')
        current_settings.project_name = settings.project_name{i};
    end
    if isfield(settings, 'project_id')
        current_settings.project_id = settings.project_id(i);
    end
    if isfield(settings, 'bg_lower_indent')
        current_settings.bg_lower_indent = settings.bg_lower_indent(i);
    end
    if isfield(settings, 'bg_upper_indent')
        current_settings.bg_upper_indent = settings.bg_upper_indent(i);
    end
    if isfield(settings, 'matrix_lower_indent')
        current_settings.matrix_lower_indent = settings.matrix_lower_indent(i);
    end
    if isfield(settings, 'matrix_upper_indent')
        current_settings.matrix_upper_indent = settings.matrix_upper_indent(i);
    end

    % open Import Module
    imp_mod = Import_Module(sourceapp_MIQAS);
    % Import data
    measurement_logfile_import_public(imp_mod, measurementpath(i), logfilepath(i), dwelltimepath(i), current_settings);

    % open Interval Module and transfer data
    int_mod = Interval_Module(sourceapp_MIQAS, current_settings.project_name, current_settings.project_id, current_settings.session_id, imp_mod.base.project);
    %delete Import Module
    delete(imp_mod)
    % set the backgrounds
    set_automatic_background(int_mod, current_settings)
    % set the matrix interval
    set_automatic_matrix(int_mod, current_settings)
    
    %save to base
    save_to_base(sourceapp_MIQAS, int_mod.project_id, int_mod.base.project.session, int_mod.session_id, int_mod.base.project_name, current_settings)
    %delte Interval Module
    delete(int_mod)
end



