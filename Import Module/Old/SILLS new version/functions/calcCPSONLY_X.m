%calcCPSONLY.m
%Summoned in CALC_EVALUATE when only cps data is desired
%Added in 1.0.3
%
function [A, UNK,STD, SRM, SMAN] = calcCPSONLY_X(A, UNK,STD, SRM, SMAN)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART 1: INITIAL CHECKS (from CALC_EVALUATE.m)
% First perform some initial checks on the completeness of the user input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% check for standards, unknowns, and dwell times
if A.STD_num == 0
    msgbox('Please load standards before proceeding','SILLS Message');
    A.warning = 1;
    return
elseif A.UNK_num == 0
    msgbox('Please load unknowns before proceeding','SILLS Message');
    A.warning = 1;
    return
elseif sum(A.DT_VALUES) == 0
    msgbox('Please set dwell times before proceeding','SILLS Message');
    A.warning = 1;    
    return
end

% check integration windows in the standards and that times have been
% allocated
for c = 1:A.STD_num
    if isempty(STD(c).bgwindow) || isempty(STD(c).sigwindow)
        msgbox('Please select background and signal integration windows for all standards','SILLS Message');
        A.warning = 1;    
        return
    end
    if STD(c).bgwindow(2) - STD(c).bgwindow(1) == 0
        msgbox('Please check background integration windows for all standards','SILLS Message');
        A.warning = 1;    
        return
    end
    if STD(c).sigwindow(2) - STD(c).sigwindow(1) == 0
        msgbox('Please check signal integration windows for all standards','SILLS Message');
        A.warning = 1;    
        return
    end
    if strcmp(A.timeformat,'hhmm')==1
        if isempty(STD(c).hh) || isempty(STD(c).mm)
            msgbox('Please specify times for all standards','SILLS Message');
            A.warning = 1;    
            return
        end
    end
end

% check integration windows in the unknowns and that times have been
% allocated
for c = 1:A.UNK_num
    if isempty(UNK(c).bgwindow) || UNK(c).bgwindow(2) - UNK(c).bgwindow(1) == 0
        msgbox('Please check background integration windows for all unknowns','SILLS Message');
        A.warning = 1;    
        return
    end
    if UNK(c).mattotal == 0 && UNK(c).sigtotal == 0
        msgbox('Define a matrix or signal window for each unknown','SILLS Message');
        A.warning = 1;    
        return
    end 
    if strcmp(A.timeformat,'hhmm')==1
        if isempty(UNK(c).hh) || isempty(UNK(c).mm)
            msgbox('Please specify times for all unknowns','SILLS Message');
            A.warning = 1;    
            return
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PART 2: Change all dummy values back to 0 (from DATAFILTER.m)
%%%%%%%%% Added in 1.0.2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for c = 1:A.STD_num %Standards
    for a = 2:size(STD(c).data,2) %cycle through elements
        for b = 1:size(STD(c).data,1) %cycle through timesteps
            if STD(c).data(b,a) == A.dummy
                STD(c).data(b,a) = 0;
            end
        end
    end
end
for c = 1:A.UNK_num %Unknowns
    for a = 2:size(UNK(c).data,2) %cycle through elements
        for b = 1:size(UNK(c).data,1) %cycle through timesteps
            if UNK(c).data(b,a) == A.dummy
                UNK(c).data(b,a) = 0;
            end
        end
    end
end
clear a b c

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART 3: depending on the input type specified in the Settings --> Input
% Format menu, create a matrix containing strictly cps data.
%(from DATAFILTER.m)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(A.input_type,'cps')==1 %i.e. if the input format is in counts per second

    for c=1:A.STD_num
        STD(c).total_time_readings = size(STD(c).data);
        STD(c).total_time_readings = STD(c).total_time_readings(1);
        STD(c).time_readings = STD(c).data(:,1);
        STD(c).data_cps = STD(c).data(:,2:end);
    end

    for c=1:A.UNK_num
        UNK(c).total_time_readings = size(UNK(c).data);
        UNK(c).total_time_readings = UNK(c).total_time_readings(1);
        UNK(c).time_readings = UNK(c).data(:,1);
        UNK(c).data_cps = UNK(c).data(:,2:end);
    end

elseif strcmp(A.input_type,'cts')==1 %i.e. if the input format is in raw counts

    for c = 1:A.STD_num

        STD(c).total_time_readings = size(STD(c).data);
        STD(c).total_time_readings = STD(c).total_time_readings(1);
        STD(c).time_readings = STD(c).data(:,1);
        STD(c).data_cps = zeros(STD(c).total_time_readings,A.ISOTOPE_num);

        for d = 1:A.ISOTOPE_num
            STD(c).data_cps(:,d)=STD(c).data(:,d+1)/A.DT_VALUES(d);
        end
    end

    for c = 1:A.UNK_num

        UNK(c).total_time_readings = size(UNK(c).data);
        UNK(c).total_time_readings = UNK(c).total_time_readings(1);
        UNK(c).time_readings = UNK(c).data(:,1);
        UNK(c).data_cps = zeros(UNK(c).total_time_readings,A.ISOTOPE_num);

        for d = 1:A.ISOTOPE_num
            UNK(c).data_cps(:,d)=UNK(c).data(:,d+1)/A.DT_VALUES(d);
        end
    end
end

clear c d

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PART 4: Integrate all windows and determine number of cycles
%(Modified from DATAFILTER.m)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for c=1:A.STD_num % scrolling through the Standards


    bg_t1_index = find(STD(c).time_readings == STD(c).bgwindow(1));
    bg_t2_index = find(STD(c).time_readings == STD(c).bgwindow(2));
    STD(c).bgwindow_index = [bg_t1_index bg_t2_index];
    bg_t1 = STD(c).time_readings(bg_t1_index);
    bg_t2 = STD(c).time_readings(bg_t2_index);

    STD(c).bg_time = bg_t2-bg_t1;               %STD(c).bg_time = elapsed time in the bg window
    STD(c).data_cps_bg = STD(c).data_cps(bg_t1_index:bg_t2_index,:);
    STD(c).bg_cps = mean(STD(c).data_cps_bg);   %STD(c).bg_cps = average count rate in the bg window
    STD(c).Nbg = size(STD(c).data_cps_bg);
    STD(c).Nbg = STD(c).Nbg(1);                 %STD(c).Nbg = # sweeps in the bg window

    sig_t1_index = find(STD(c).time_readings == STD(c).sigwindow(1));
    sig_t2_index = find(STD(c).time_readings == STD(c).sigwindow(2));
    STD(c).sigwindow_index = [sig_t1_index sig_t2_index];
    sig_t1 = STD(c).time_readings(sig_t1_index);
    sig_t2 = STD(c).time_readings(sig_t2_index);

    STD(c).sig_time = sig_t2-sig_t1;
    STD(c).data_cps_sig = STD(c).data_cps(sig_t1_index:sig_t2_index,:);
    STD(c).sig_cps = mean(STD(c).data_cps_sig);
    STD(c).Nsig = size(STD(c).data_cps_sig);
    STD(c).Nsig = STD(c).Nsig(1);

end

for c=1:A.UNK_num % scrolling through the Unknowns

    bg_t1_index = find(UNK(c).time_readings == UNK(c).bgwindow(1));
    bg_t2_index = find(UNK(c).time_readings == UNK(c).bgwindow(2));
    UNK(c).bgwindow_index = [bg_t1_index bg_t2_index];
    bg_t1 = UNK(c).time_readings(bg_t1_index);
    bg_t2 = UNK(c).time_readings(bg_t2_index);

    UNK(c).bg_time = bg_t2-bg_t1;
    UNK(c).data_cps_bg = UNK(c).data_cps(bg_t1_index:bg_t2_index,:);
    UNK(c).bg_cps = mean(UNK(c).data_cps_bg);
    UNK(c).Nbg = size(UNK(c).data_cps_bg);
    UNK(c).Nbg = UNK(c).Nbg(1);

    if ~isempty(UNK(c).comp1window)
        comp1_t1_index = find(UNK(c).time_readings == UNK(c).comp1window(1));
        comp1_t2_index = find(UNK(c).time_readings == UNK(c).comp1window(2));
        UNK(c).comp1window_index = [comp1_t1_index comp1_t2_index];
    else
        comp1_t1_index = 1;
        comp1_t2_index = 1;
    end

    if ~isempty(UNK(c).comp2window)
        comp2_t1_index = find(UNK(c).time_readings == UNK(c).comp2window(1));
        comp2_t2_index = find(UNK(c).time_readings == UNK(c).comp2window(2));
        UNK(c).comp2window_index = [comp2_t1_index comp2_t2_index];
    else
        comp2_t1_index = 1;
        comp2_t2_index = 1;
        UNK(c).comp2window_index = [comp2_t1_index comp2_t2_index];
    end

    if ~isempty(UNK(c).comp3window)
        comp3_t1_index = find(UNK(c).time_readings == UNK(c).comp3window(1));
        comp3_t2_index = find(UNK(c).time_readings == UNK(c).comp3window(2));
        UNK(c).comp3window_index = [comp3_t1_index comp3_t2_index];
    else
        comp3_t1_index = 1;
        comp3_t2_index = 1;
        UNK(c).comp3window_index = [comp3_t1_index comp3_t2_index];
    end

    comp1_t1 = UNK(c).time_readings(comp1_t1_index);
    comp1_t2 = UNK(c).time_readings(comp1_t2_index);
    comp2_t1 = UNK(c).time_readings(comp2_t1_index);
    comp2_t2 = UNK(c).time_readings(comp2_t2_index);
    comp3_t1 = UNK(c).time_readings(comp3_t1_index);
    comp3_t2 = UNK(c).time_readings(comp3_t2_index);

    UNK(c).comp1_time = comp1_t2 - comp1_t1;
    UNK(c).comp2_time = comp2_t2 - comp2_t1;
    UNK(c).comp3_time = comp3_t2 - comp3_t1;
    UNK(c).sig_time =   UNK(c).comp1_time + UNK(c).comp2_time + UNK(c).comp3_time;

    if UNK(c).comp1_time > 0;
        UNK(c).data_cps_comp1 = UNK(c).data_cps(comp1_t1_index:comp1_t2_index,:);
        UNK(c).Ncomp1 = size(UNK(c).data_cps_comp1);
        UNK(c).Ncomp1 = UNK(c).Ncomp1(1);
    else
        UNK(c).Ncomp1 = 0;
    end
    if UNK(c).comp2_time > 0;
        UNK(c).data_cps_comp2 = UNK(c).data_cps(comp2_t1_index:comp2_t2_index,:);
        UNK(c).Ncomp2 = size(UNK(c).data_cps_comp2);
        UNK(c).Ncomp2 = UNK(c).Ncomp2(1);
    else
        UNK(c).Ncomp2 = 0;
        UNK(c).data_cps_comp2 = [];
    end
    if UNK(c).comp3_time > 0;
        UNK(c).data_cps_comp3 = UNK(c).data_cps(comp3_t1_index:comp3_t2_index,:);
        UNK(c).Ncomp3 = size(UNK(c).data_cps_comp3);
        UNK(c).Ncomp3 = UNK(c).Ncomp3(1);
    else
        UNK(c).Ncomp3 = 0;
        UNK(c).data_cps_comp3 = [];
    end
    UNK(c).data_cps_sig = [UNK(c).data_cps_comp1;UNK(c).data_cps_comp2;UNK(c).data_cps_comp3];
    UNK(c).Nsig = UNK(c).Ncomp1 + UNK(c).Ncomp2 + UNK(c).Ncomp3;

    if UNK(c).Ncomp1 > 1
        UNK(c).comp1_cps = mean(UNK(c).data_cps_comp1);
    else
        UNK(c).comp1_cps = zeros(1,A.ISOTOPE_num);
    end

    if UNK(c).Ncomp2 > 1
        UNK(c).comp2_cps = mean(UNK(c).data_cps_comp2);
    else
        UNK(c).comp2_cps = zeros(1,A.ISOTOPE_num);
    end

    if UNK(c).Ncomp3 > 1
        UNK(c).comp3_cps = mean(UNK(c).data_cps_comp3);
    else
        UNK(c).comp3_cps = zeros(1,A.ISOTOPE_num);
    end

    if UNK(c).Nsig > 1
        UNK(c).sig_cps = mean(UNK(c).data_cps_sig);
    else
        UNK(c).sig_cps = zeros(1,A.ISOTOPE_num);
    end
end

clear bg_t1 bg_t1_index bg_t2 bg_t2_index
clear comp1_t1 comp1_t1_index comp1_t2 comp1_t2_index
clear comp2_t1 comp2_t1_index comp2_t2 comp2_t2_index
clear comp3_t1 comp3_t1_index comp3_t2 comp3_t2_index
clear sig_t1 sig_t1_index sig_t2 sig_t2_index

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART 5: Sample cps data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for c = 1:A.UNK_num    
   
    UNK(c).samp_cps = UNK(c).sig_cps - UNK(c).bg_cps;

end
clear c

end