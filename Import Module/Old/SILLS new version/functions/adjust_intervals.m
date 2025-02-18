function adjust_intervals()

%%essentially, all i change is the bgwindow = [start, end] and then
%%everything else needs to change accordingly. where is that done in the
%%original sills?
%this function needs to do the same thing that many functions in SILLS do.
%Some of these are in e.g. SILLSFIG_UPDATE which we will not use

%% which variables need to change when the interval is changed
%% for the STD:
%bgwindow
%bgwindow_index
%bg_time
%data_cps_bg
%bg_cps
%BG_stdev
%Nbg

%sigwindow
%sigwindow_index
%sigtime
%data_cps_sig
%sig_cps
%Nsig

%CPS_ratio??
%do the other variables then change accordingly?

%% for the UNK:
% bgwindow
% mat1window
% mat2window
% mattotal (muss berechnet werden)
% comp1window
% comp2window
% comp3window
% sigtotal
% 
% bgwindow_index
% bg_time
% data_cps_bg
% bg_cps
% Nbg
% 
% mat1window_index
% mat2window_index
% mat_time
% data_cps_mat
% Nmat
% mat_cps
% 
% comp1window_index
% comp2window_index
% comp3window_index
% comp1_time
% comp2_time
% comp3_time
% sig_time
% data_cps_comp1
% data_cps_comp2
% data_cps_comp3
% Ncomp1
% Ncomp2
% Ncomp3
% data_cps_sig
% Nsig
% comp1_cps
% comp2_cps
% comp3_cps
% sig_cps
%% and more
end