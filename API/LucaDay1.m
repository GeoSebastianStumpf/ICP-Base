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


settings.session_name = "Luca_Day_1";
settings.session_id = 0;

settings.project_name = "Others";
settings.project_id = 0;

measurementpath = "C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\Luca Day 1\Silicates-TE.csv";
settings.massspec.Value = "Agilent 7900";

logfilepath = "C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\Luca Day 1\201124_TE_log_20241120_162728.log";
settings.laser.Value = "Resonetics Verbose Log (.log)";

dwelltimepath = "C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\Luca Day 1\AcqMethod.xml";
settings.dwelltime.Value = "Agilent AcqMethod.xml";

settings.import_module_GUI_update_state = true;
settings.MIQAS_GUI_update_state = true;
settings.classification_module_GUI_update_state = true;
settings.interval_module_GUI_update_state = true;
settings.reductiontype = 'Matrix';

[~] = measurement_logfile_import_public(imp_mod, measurementpath, logfilepath, dwelltimepath, settings);


% Att the signal detection is a part of the above function but has to be moved
% at some point and done properly
%[imp_mod.base.project.session.spot.signal_starts, imp_mod.base.project.session.spot.signal_ends] = detect_signals(imp_mod.base.project.session.fullsignal_raw, numel(imp_mod.base.project.session.spotname));

int_mod = Interval_Module(sourceapp_MIQAS, settings.project_name, settings.project_id, settings.session_id, imp_mod.base.project);

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

clas_mod = Classification_Module(sourceapp_MIQAS, settings.project_name, settings.project_id, settings.session_id, int_mod.base.project);

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


drift_mod = Drift_Module(sourceapp_MIQAS, settings.project_name, settings.project_id, settings.session_id, clas_mod.base.project);
delete(clas_mod)


% Reference materials for each sequence
settings.internal_standard_for_primary_reference_material = [
    repmat("GSD_1G", 1, length(4:24)), ...       % First sequence
    repmat("NIST612", 1, length(206:228)), ...   % Second sequence
    repmat("Sca_17", 1, length(302:319))         % Third sequence
];

% Spot numbers in sequences
settings.spotnumber_for_internal_standard = [
    4:24, ...           % First sequence
    206:228, ...        % Second sequence
    302:319             % Third sequence
];

% Internal standards for each sequence
settings.internal_standard = [
    repmat("Fe57", 1, length(4:24)), ...         % First sequence
    repmat("Ti49", 1, length(206:228)), ...      % Second sequence
    repmat("Na23", 1, length(302:319))           % Third sequence
];

% Mass fractions for each sequence
settings.internal_standard_mass_fraction = [
    repmat(500, 1, length(4:24)), ...           % First sequence
    repmat(600, 1, length(206:228)), ...        % Second sequence
    repmat(700, 1, length(302:319))             % Third sequence
];

settings.quantification_module_GUI_update_state = true;

quant_mod = Quantification_Module(sourceapp_MIQAS, settings.project_name, settings.project_id, settings.session_id, drift_mod.base.project);
delete(drift_mod)

assign_internal_standard(quant_mod, settings)


%save_to_base(sourceapp_MIQAS, int_mod.project_id, int_mod.base.project.session, int_mod.session_id, int_mod.base.project_name, settings)



% for the referencmaterial and type assignement the user has to input
% indices and the type/refmat as stings, chars


%[settings_default] = measurement_logfile_import_public(imp_mod)
