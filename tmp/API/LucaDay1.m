try
    delete(sourceapp_ICP_Base)
    delete(imp_mod)
    delete(int_mod)
    delete(clas_mod)
    delete(drift_mod)
catch ME
    disp("help")
end

clear
clc

sourceapp_ICP_Base = ICP_Base;
settings.sourceapp_ICP_Base = sourceapp_ICP_Base;

settings.import_module_GUI_update_state = true;
settings.ICP_Base_GUI_update_state = true;

settings.session_name = "Luca_Day_1";
settings.session_id = 0;

settings.project_name = "Others";
settings.project_id = 0;

measurementpath = "C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\ICP-Base\Test Data\Mineral Analysis\Luca Day 1\Silicates-TE.csv";
settings.massspec.Value = "Agilent 7900";

logfilepath = "C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\ICP-Base\Test Data\Mineral Analysis\Luca Day 1\201124_TE_log_20241120_162728.log";
settings.laser.Value = "Resonetics Verbose Log (.log)";

dwelltimepath = "C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\ICP-Base\Test Data\Mineral Analysis\Luca Day 1\AcqMethod.xml";
settings.dwelltime.Value = "Agilent AcqMethod.xml";

settings.import_module_GUI_update_state = true;
settings.ICP_Base_GUI_update_state = true;
settings.classification_module_GUI_update_state = true;
settings.interval_module_GUI_update_state = true;
settings.reductiontype = 'Matrix';

imp_mod = Import_Module(sourceapp_ICP_Base, settings.project_name, settings.project_id, settings.session_id, settings);

[~] = measurement_logfile_import_public(imp_mod, measurementpath, logfilepath, dwelltimepath, settings);

% Att the signal detection is a part of the above function but has to be moved
% at some point and done properly
%[imp_mod.base.project.session.spot.signal_starts, imp_mod.base.project.session.spot.signal_ends] = detect_signals(imp_mod.base.project.session.fullsignal_raw, numel(imp_mod.base.project.session.spotname));

[project_id, session_id] = save_to_base(sourceapp_ICP_Base, imp_mod.project_id, imp_mod.base.project.session, imp_mod.session_id, imp_mod.base.project_name, settings);
int_mod = Interval_Module(sourceapp_ICP_Base, sourceapp_ICP_Base.base.project_name, project_id, session_id, settings);
delete(imp_mod)

%settings.bg_lower_indent = 20;
settings.bg_upper_indent = 25;
set_automatic_background(int_mod, settings)

%settings.matrix_lower_indent = 5;
%settings.matrix_upper_indent = 5;
set_automatic_matrix(int_mod, settings)

settings.spike_elimination = false;
% just comment out the spike_elimination_spotnumber to get a global spike
% elimination for all spots
% Attention though, the public spike elimination does not care about the
% inclusion intervals, it will correct all spikes
%settings.spike_elimination_spotnumber = [1,2,3, 4,5,6,    50,51,52,   53,54,55,   109, 110, 111,  112,113,114];
spike_elimination_public(int_mod, settings)

[project_id, session_id] = save_to_base(sourceapp_ICP_Base, int_mod.project_id, int_mod.base.project.session, int_mod.session_id, int_mod.base.project_name, settings);
clas_mod = Classification_Module(sourceapp_ICP_Base, sourceapp_ICP_Base.base.project_name, project_id, session_id, settings);
delete(int_mod)

% everything needs to match lengths and PRM and SRM need a type whereas for
% IHRM the type has to be "None".
% Make sure to use the exact same spelling as the .csv reference material
% files are named
% All of this is case sensitive

% settings.spotnumber = [1,2,3,   25,26,27,   49,50,51,    73,74,75, 97,98,99,   121,122,123,    146,147,148,...
%     149,150,151,   174,175,176,   201,202,203,...
%     204,205,206,   228,229,230,...
%     231,232,233,   254,255,256,  276,277,278,  296,297,298,...
%     299,300,301, 320,321,322];
% settings.type = ["PRM", "PRM", "PRM",  "PRM", "PRM", "PRM", "PRM", "PRM", "PRM", "PRM", "PRM", "PRM", "PRM", "PRM",  "PRM", "PRM", "PRM", "PRM", "PRM", "PRM", "PRM",...
%     "PRM", "PRM", "PRM","PRM", "PRM", "PRM","PRM", "PRM", "PRM",...
%     "PRM", "PRM", "PRM","PRM", "PRM", "PRM",...
%     "PRM", "PRM", "PRM","PRM", "PRM", "PRM","PRM", "PRM", "PRM","PRM", "PRM", "PRM",...
%     "PRM", "PRM", "PRM","PRM", "PRM", "PRM"];
% settings.referencematerial = ["GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G",...
%     "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G",...
%     "NIST612", "NIST612", "NIST612", "NIST612", "NIST612", "NIST612",...
%     "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G",...
%     "Sca_17", "Sca_17", "Sca_17", "Sca_17", "Sca_17", "Sca_17"];
% settings.bracket_id = [1,1,1, 1,1,1, 1,1,1, 1,1,1, 1,1,1, 1,1,1, 1,1,1,...
%     2,2,2,  2,2,2,  2,2,2,...
%     3,3,3,  3,3,3,...
%     4,4,4,  4,4,4,  4,4,4, 4,4,4,...
%     5,5,5,  5,5,5 ];

settings.spotnumber = [1,2,3,   25,26,27,   49,50,51,    73,74,75, 97,98,99,   121,122,123,    146,147,148,...
    149,150,151,   174,175,176,   201,202,203,...
    204,205,      229,230,...
    231,232,233,   254,255,256,  276,277,278,  296,297,298,...
    299,300,301, 320,321,322];
settings.type = ["PRM", "PRM", "PRM",  "PRM", "PRM", "PRM", "PRM", "PRM", "PRM", "PRM", "PRM", "PRM", "PRM", "PRM",  "PRM", "PRM", "PRM", "PRM", "PRM", "PRM", "PRM",...
    "PRM", "PRM", "PRM","PRM", "PRM", "PRM","PRM", "PRM", "PRM",...
    "PRM", "PRM", "PRM","PRM",...
    "PRM", "PRM", "PRM","PRM", "PRM", "PRM","PRM", "PRM", "PRM","PRM", "PRM", "PRM",...
    "PRM", "PRM", "PRM","PRM", "PRM", "PRM"];
settings.referencematerial = ["GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G",...
    "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G",...
    "NIST612", "NIST612", "NIST612", "NIST612",...
    "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G", "GSD_1G",...
    "GSD_1G", "Sca_17", "Sca_17", "Sca_17", "Sca_17", "GSD_1G"];
settings.bracket_id = [1,1,6, 6,1,1, 1,1,1, 1,1,1, 1,1,1, 1,1,1, 1,1,1,...
    2,2,2,  2,2,2,  2,2,2,...
    1,1,    1,1,...
    4,4,4,  4,4,4,  4,4,4, 4,4,4,...
    5,5,5,  5,5,5 ];

assign_spots_to_reference_materials(clas_mod, settings)

[project_id, session_id] = save_to_base(sourceapp_ICP_Base, clas_mod.project_id, clas_mod.base.project.session, clas_mod.session_id, clas_mod.base.project_name, settings);
drift_mod = Drift_Module(sourceapp_ICP_Base, sourceapp_ICP_Base.base.project_name, project_id, session_id, settings);
delete(clas_mod)


% Reference materials for each sequence

settings.internal_standard_for_primary_reference_material= [
    repmat("GSD_1G", 1, length(4:145)), ...       % PRMs for bracket_ids for GSD
    repmat("GSD_1G", 1, length(152:200)), ... 
    repmat("GSD_1G", 1, length(234:295)), ... 
    repmat("GSD_1G", 1, length(302:319)), ...
    repmat("GSD_1G", 1, length(4:24)), ...
    repmat("NIST612", 1, length(206:228)), ...   % PRMs for bracket_ids for NIST
    repmat("Sca_17", 1, length(302:319))         % PRMs for bracket_ids for Sca-17
];

settings.internal_standard_for_bracket_id = [
    repmat(1, 1, length(4:145)), ...       % Bracket_ids for GSD
    repmat(2, 1, length(152:200)), ... 
    repmat(4, 1, length(234:295)), ... 
    repmat(5, 1, length(302:319)), ...
    repmat(6, 1, length(4:24)), ...
    repmat(1, 1, length(206:228)), ...   % Bracket_ids for NIST
    repmat(5, 1, length(302:319))         % bracket_ids for Sca-17
];

settings.spotnumber_for_internal_standard= [
    4:145, ...       % Spotnumbers for GSD
    152:200, ... 
    234:295, ... 
    302:319, ...
    4:24, ...
    206:228, ...   % Spotnumbers for NIST
    302:319         % Spotnumbers for Sca-17
];

settings.internal_standard = [
    repmat("Fe57", 1, length(4:145)), ...       % IS for GSD
    repmat("Fe57", 1, length(152:200)), ... 
    repmat("Fe57", 1, length(234:295)), ... 
    repmat("Fe57", 1, length(302:319)), ...
    repmat("Fe57", 1, length(4:24)), ...
    repmat("Ti49", 1, length(206:228)), ...   % IS for NIST
    repmat("Na23", 1, length(302:319))         % IS for Sca-17
];

settings.internal_standard_mass_fraction = [
    repmat(500, 1, length(4:145)), ...       % Mass fractions for GSD
    repmat(500, 1, length(152:200)), ... 
    repmat(500, 1, length(234:295)), ... 
    repmat(500, 1, length(302:319)), ...
    repmat(500, 1, length(4:24)), ...
    repmat(600, 1, length(206:228)), ...   % Mass_fractions for NIST
    repmat(700, 1, length(302:319))         % Mass_fractions for Sca-17
];


settings.quantification_module_GUI_update_state = true;

[project_id, session_id] = save_to_base(sourceapp_ICP_Base, drift_mod.project_id, drift_mod.base.project.session, drift_mod.session_id, drift_mod.base.project_name, settings);
quant_mod = Quantification_Module(sourceapp_ICP_Base, sourceapp_ICP_Base.base.project_name, project_id, session_id, settings);
delete(drift_mod)

assign_internal_standard(quant_mod, settings)
quantification_wrapper(quant_mod)

[project_id, session_id] = save_to_base(sourceapp_ICP_Base, quant_mod.project_id, quant_mod.base.project.session, quant_mod.session_id, quant_mod.base.project_name, settings);
results_mod = Results_Module(sourceapp_ICP_Base, sourceapp_ICP_Base.base.project_name, project_id, session_id, settings);
delete(quant_mod)






%[settings_default] = measurement_logfile_import_public(imp_mod)
