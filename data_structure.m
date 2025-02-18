%clear

base.project.sessionname = {"1", "p2",};

session_id=1
%% Data Import
% Logfile for name and metadata
% Full raw signal

base.project.session(session_id).spotnames = {"spot1", "spot2", "spot3"};
base.project.session(session_id).dwelltimes = [0.1 , 0.2];

% full raw signal, everything always comes back to this
base.project.session(session_id).fullsignal_raw = rand(100);
base.project.session(session_id).fullsignal = rand(100);
base.project.session(session_id).elements = {"Li", "La"}; % essentially the colheaders from fullsignal

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% standard
base.project.session(session_id).spot(1).signal_starts = 2;
start = base.project.session(session_id).spot(1).signal_starts;
base.project.session(session_id).spot(1).signal_ends = 10;
ent = base.project.session(session_id).spot(1).signal_ends;
base.project.session(session_id).spot(1).signal = base.project.session(session_id).fullsignal(:,start:end);

base.project.session(session_id).spot(1).type = "Standard";
base.project.session(session_id).spot(1).subtype = "GSD-1G";
base.project.session(session_id).spot(1).acqisition_time = 2;

base.project.session(session_id).spot(1).intervals(1).type = "Background"; %{'Matrix',Fluid,Melt}
base.project.session(session_id).spot(1).intervals(1).idx = [2,3];
base.project.session(session_id).spot(1).intervals(2).type = "Matrix";
base.project.session(session_id).spot(1).intervals(2).idx = [9,10];

%% standard reference material
% folder with .csv sheets like original SILLS
base.project.session(session_id).srm(1).name = "GSD-1G";
base.project.session(session_id).srm(1).conc = [2, 5];
base.project.session(session_id).srm(1).elements = ["Li", "La"];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% unknown - Inclusion
%indexes of the range in the full signal
base.project.session(session_id).spot(2).signal_range_idx = [12,30];
id=base.project.session(session_id).spot(2).signal_range_idx;
base.project.session(session_id).spot(2).signal = base.project.session(session_id).fullsignal(:,id(1):id(2));
%spot type
base.project.session(session_id).spot(2).type = "Unknown";
base.project.session(session_id).spot(2).subtype = "Inclusion";
%time of measurment
base.project.session(session_id).spot(2).acqisition_time = 3;

% intervals
base.project.session(session_id).spot(2).intervals(1).type = "Background";
base.project.session(session_id).spot(2).intervals(1).idx = [13,14];% indexes of the interval start and end in fullsignal

base.project.session(session_id).spot(2).intervals(2).type = "Host_1";
base.project.session(session_id).spot(2).intervals(2).idx = [15,18]; % indexes of the interval start and end in fullsignal
%base.project.session(session_id).spot(2).intervals(2).sensitivity = 3; %sensitivity for this interval

base.project.session(session_id).spot(2).intervals(3).type = "Host-Inclusion-Mix_1";
base.project.session(session_id).spot(2).intervals(3).idx = [19,22]; % indexes of the interval start and end in fullsignal
%base.project.session(session_id).spot(2).intervals(3).sensitivity = 4; %sensitivity for this interval

base.project.session(session_id).spot(2).intervals(4).type = "Host_2";
base.project.session(session_id).spot(2).intervals(4).idx = [23,25]; % indexes of the interval start and end in fullsignal
%base.project.session(session_id).spot(2).intervals(4).sensitivity = 2; %sensitivity for this interval

% quantification settings - Host (equivalent to Matrix)
base.project.session(session_id).spot(2).quantification_settings.internal_standard_matrix__type = "Internal Standard"; %total oxides
base.project.session(session_id).spot(2).quantification_settings.internal_standard_matrix = "Si";
base.project.session(session_id).spot(2).quantification_settings.internal_standard_matrix_conc = 1000000;

% quantification settings - Inclusion
base.project.session(session_id).spot(2).quantification_settings.internal_standard_inclusion__type = "Two Internal Standards";
base.project.session(session_id).spot(2).quantification_settings.internal_standard_inclusion__1 = "Cl";
base.project.session(session_id).spot(2).quantification_settings.internal_standard_inclusion_1_conc = 10000;
base.project.session(session_id).spot(2).quantification_settings.internal_standard_inclusion_2 = "Ni";
base.project.session(session_id).spot(2).quantification_settings.internal_standard_inclusion_2_conc = 10;
base.project.session(session_id).spot(2).quantification_settings.matrix_only_tracer = "Co";
base.project.session(session_id).spot(2).quantification_settings.reference_host = "spot3";


%% unknown - Mineral
%indexes of the range in the full signal
base.project.session(session_id).spot(3).signal_range_idx = [40,60];
id=base.project.session(session_id).spot(3).signal_range_idx;
base.project.session(session_id).spot(3).signal = base.project.session(session_id).fullsignal(:,id(1):id(2));
%spot type
base.project.session(session_id).spot(3).type = "Unknown";
base.project.session(session_id).spot(3).subtype = "Mineral";
%time of measurment
base.project.session(session_id).spot(3).acqisition_time = 4;

% intervals
base.project.session(session_id).spot(3).intervals(1).type = "Background";
base.project.session(session_id).spot(3).intervals(1).idx = [41,47];

base.project.session(session_id).spot(3).intervals(2).type = "Matrix_1";
base.project.session(session_id).spot(3).intervals(2).idx = [49,55];
%base.project.session(session_id).spot(3).intervals(2).sensitivity = 3; %sensitivity for this interval

base.project.session(session_id).spot(3).intervals(3).type = "Matrix_2";
base.project.session(session_id).spot(3).intervals(3).idx = [57,58];

% quantification settings - Mineral
base.project.session(session_id).spot(3).quantification_settings.internal_standard_matrix__type = "Internal Standard"; %total oxides
base.project.session(session_id).spot(3).quantification_settings.internal_standard_matrix = "Si";
base.project.session(session_id).spot(3).quantification_settings.internal_standard_matrix_conc = 1000000;

%% results - for the whole project
base.project.session(session_id).results.mass_fractions = table();
base.project.session(session_id).results.detection_limits = table();

% % Workflow
% Should be linear so that it is easy to understand for the user
%     Deactive Quantification settings as long as not all intervals are set
%     and drift correction is done and everything else is assigned
% 

% Data Import
%     Logfiles and signal files from multiple laser systems and mass-specs
%         Automatic Signal detection (bg + cleaningshot + signal)
%     Option to load in single Signals (Filename = Spotname then)
%         Separate for Standards and Unknowns like original SILLS
% In the data import the starts and ends of the signals must be detected
% and assigned to the correct name of a Logfile - once that is done it is
% easy to plot the signals and assign the intervals automatically

%     Must be able to convert old SILLS files to LARP
%     gets the Acquisition time from the full signal or the logfile or
%         file-information itself
%     Import the dwell times from the AcqMethod.xml file from the Mass-Spec
%       If this is not available, make a table where it can be input by
%       hand or read in a .csv file

% Assign Standard and Unknown
%     has to be done before setting intervals to not even give the option
%     of inclusion here, keeps it simpler and more linear too
%     Can be done according to name or chosen manually
%     Assign SRM to Standard

% Set intervals
%     Manually and automatically
%     Assign spot.type according to which intervals were set
%     All kinds of cool plotting stuff - Ratios, Colours etc
%     Use random forest do mark background, matrix and inclusion to set
%     intervals automatically

% Drift Correction
%     Choose drift monitoring analyte (dma)
%     Easy to read plots and maybe suggest a dma
%     should be able to handle multiple brackets !!!
%     different fits (linear, polynomial etc)
% 
% Quantification Settings
%     Use 2 standards simultaneously for specific elements
%         Assign elements to standards if there is more than 1 standard
%         subtype
%     Matrix quantification
%         IS/total oxides
%     Inclusion quantification
%         2IS or MOT
%             2IS - input concs
%             MOT
%                 Visualize
%                 Make the RI for every element changeable
%                 Based on Ratios for every element
%                 Individual MOTS for different elements/element groups
%     LOD calculation based on Host or BG
% 
% Output
%     Two Tables, one with Concs and one with DLs
%     MinPlot
% 
% % Machine Learning Idea
%     use a pre-trained model to detect the signals in the full signal file
%         Hopefully more robust than what i have right now
%         should be independent of the colheaders (elements)
%     use a random forest based on already set intervals in selected spots
%     predict all other intervals




