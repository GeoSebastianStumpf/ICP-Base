%% this is for Uncut Signals + Logfile

logfilePath = "D:\OneDrive - Universitaet Bern\PhD\Programs\SILLS new version\Import Module\Mineral Analysis\Alm06_Min2_log_20240117_145530.log";
csvinputpath = "D:\OneDrive - Universitaet Bern\PhD\Programs\SILLS new version\Import Module\Mineral Analysis\Uncut Signals.csv";

%logfilePath = "D:\OneDrive - Universitaet Bern\PhD\Data\Almirez\LA-ICP-MS Data\Minerals\30.11.2023\Alm06_Min_log_20231130_172714.log";
%csvinputpath = "D:\OneDrive - Universitaet Bern\PhD\Data\Almirez\LA-ICP-MS Data\Minerals\30.11.2023\Alm-Min-1.csv";

% reads in the data from the logfile
LOGDAT = extract_logfile_data(logfilePath);

% just cuts the signals
[SIGDAT, icp_signals_processed, icp_signals_raw] = cut_signals(csvinputpath); %[SIGDAT, pr]


% this sets the background and signal intervals
%output of cut_signals as input 
% eventually this has to work on UNK and STD and not SIGDAT (its the same
% anyways)
SIGDAT  = set_automatic_intervals(SIGDAT);

% this gives the HH:MM information for the drift correction, takes the output of
%output of cut_signals as input
% eventually this has to work on UNK and STD and not SIGDAT (its the same
% anyways)
SIGDAT = set_automatic_drifttime(SIGDAT);

%% ==============================================================================================%%
        %Independent of the input, when the data arrives here it should all be the same 
%%==============================================================================================%%

% Distribute the data from SIGDAT to STD and UNK
[STD, UNK] = SIGDAT_to_STD_UNK(SIGDAT, LOGDAT);

% Fill the A struct with infos from STD and UNK
[A] = STD_UNK_to_A(STD, UNK);

%% ==============================================================================================%%
        %Independent of whatever happens before, when the data arrives here
        %(at the end of the import)
        %it should be the same as in the old SILLS
%%==============================================================================================%%

if false
%% First, Run the Script to ge the data, then activate this section and then press Run Section and it opens SILLS and imports the data
sillsapp = SILLS
public_import_fullSTD(sillsapp,STD,true)
public_import_fullUNK(sillsapp,UNK,true)
public_import_fullA(sillsapp,A)

end

%% for Inclusion analyses this looks a little different because the intervals fill other variables e.g. mat1window and so on
% do everything by hand basically, like the old sills
%% there should also be something for the bulk analyses









%% unused shit 

        %%
        % UNK(i).total_time_readings = length(UNK(i).data);
        % UNK(i).time_readings = UNK(i).data(:, 1); % this might fail if the time is not the first column
        % UNK(i).data_cps = UNK(i).data(:, 2:end);
        % UNK(i).bgwindow_index = SIGDAT(i).bg_indices;
        % UNK(i).bg_time = UNK(i).bgwindow(2) - UNK(i).bgwindow(1);
        % UNK(i).data_cps_bg = SIGDAT(i).data_cps_bg;
        % UNK(i).bg_cps = mean(UNK(i).data_cps_bg);
        % UNK(i).Nbg = height(UNK(i).data_cps_bg);
        % 
        % UNK(i).mat1windox_index = [1,1];
        % UNK(i).mat2windox_index = [1,1];    
        % UNK(i).mat_time = 0;
        % UNK(i).data_cps_mat = zeros(1, UNK(i).num_elements);
        % UNK(i).Nmat = 2; % idk why
        % UNK(i).mat_cps = zeros(1, UNK(i).num_elements);        
        % 
        % UNK(i).comp1window_index = SIGDAT(i).signal_indices;
        % UNK(i).comp2window_index = [1,1];
        % UNK(i).comp3window_index = [1,1];
        % UNK(i).comp1_time = UNK(i).comp1window(2) - UNK(i).comp1window(1);
        % UNK(i).comp2_time = 0;
        % UNK(i).comp3_time = 0;
        % UNK(i).data_cps_comp1 = SIGDAT(i).data_cps_sig;        
        % UNK(i).Ncomp1 = height(UNK(i).data_cps_comp1);
        % UNK(i).Ncomp2 = 0;
        % UNK(i).data_cps_comp2 = [];
        % UNK(i).Ncomp3 = 0;
        % UNK(i).data_cps_comp3 = [];
        % UNK(i).data_cps_sig = UNK(i).data_cps_comp1;  % this is probably different if comp2 and comp3 are also used, maybe just an addition of the tables
        % UNK(i).Nsig = height(UNK(i).data_cps_sig);
        % UNK(i).comp1_cps = mean(UNK(i).data_cps_sig);
        % UNK(i).comp2_cps = zeros(1, UNK(i).num_elements);          
        % UNK(i).comp3_cps = zeros(1, UNK(i).num_elements);  
        % UNK(i).sig_cps = mean(UNK(i).data_cps_sig); % this is probably different if comp2 and comp3 are also used, maybe just an addition of the means
        % 
        % UNK(i).clocktime = 7.3925e+05; % wtf is this
        % UNK(i).REFIS_CALIB = ??
        % UNK(i).REPORTIS_CALIB = REFIS_CALIB;
        % UNK(i).MATQIS_CALIB = REFIS_CALIB;
        % 
        % UNK(i).data_cps_bg_LODmod = UNK(i).data_cps_bg;
        % UNK(i).data_cps_mat_LODmod = zeros(1, UNK(i).num_elements);  
        % UNK(i).data_cps_sig_LODmod = UNK(i).data_cps_sig;
        % UNK(i).BG_stdev = std(UNK(i).data_cps_bg);
        % UNK(i).BG_stdev = std(UNK(i).data_cps_bg);
        % UNK(i).bg_cps_mod = UNK(i).bg_cps;
        % UNK(i).mat_cps_mod = zeros(1, UNK(i).num_elements);  
        % UNK(i).sig_cps_mod = UNK(i).sig_cps;   
        % 
        % UNK(i).MAT_CONC = zeros(1, UNK(i).num_elements);
        % UNK(i).MAT_CONC_error = zeros(1, UNK(i).num_elements);
        % UNK(i).MAT_LOD_mn = zeros(1, UNK(i).num_elements);
        % UNK(i).MAT_LOD_mm = zeros(1, UNK(i).num_elements);
