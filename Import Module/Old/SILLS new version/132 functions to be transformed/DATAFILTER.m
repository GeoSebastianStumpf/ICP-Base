% DATAFILTER

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PART 0: Change all dummy values back to 0
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
% PART 1: depending on the input type specified in the Settings --> Input
% Format menu, create a matrix containing strictly cps data.
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PART 2: Integrate all windows and determine number of cycles
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
    STD(c).BG_stdev = std(STD(c).data_cps_bg);  % added in 1.3.0 to read out BG stdev of standards
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

    if ~isempty(UNK(c).mat1window)
        mat1_t1_index = find(UNK(c).time_readings == UNK(c).mat1window(1));
        mat1_t2_index = find(UNK(c).time_readings == UNK(c).mat1window(2));
        UNK(c).mat1window_index = [mat1_t1_index mat1_t2_index];
    else
        mat1_t1_index = 1;
        mat1_t2_index = 1;
        UNK(c).mat1windox_index = [mat1_t1_index mat1_t2_index];
    end

    if ~isempty(UNK(c).mat2window)
        mat2_t1_index = find(UNK(c).time_readings == UNK(c).mat2window(1));
        mat2_t2_index = find(UNK(c).time_readings == UNK(c).mat2window(2));
        UNK(c).mat2window_index = [mat2_t1_index mat2_t2_index];
    else
        mat2_t1_index = 1;
        mat2_t2_index = 1;
        UNK(c).mat2window_index = [mat2_t1_index mat2_t2_index];
    end

    mat1_t1 = UNK(c).time_readings(mat1_t1_index);
    mat1_t2 = UNK(c).time_readings(mat1_t2_index);
    mat2_t1 = UNK(c).time_readings(mat2_t1_index);
    mat2_t2 = UNK(c).time_readings(mat2_t2_index);

    UNK(c).mat_time = (mat1_t2 - mat1_t1) + (mat2_t2 - mat2_t1);
    UNK(c).data_cps_mat = [UNK(c).data_cps(mat1_t1_index:mat1_t2_index,:);UNK(c).data_cps(mat2_t1_index:mat2_t2_index,:)];
    UNK(c).Nmat = size(UNK(c).data_cps_mat);
    UNK(c).Nmat = UNK(c).Nmat(1);
    if UNK(c).Nmat > 1                              %i.e. more than one time slice
        UNK(c).mat_cps = mean(UNK(c).data_cps_mat); %calculate the average count rate in the matrix window
    else                                            %i.e. no window
        UNK(c).mat_cps = zeros(1,A.ISOTOPE_num);    %zero average count rate
    end

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
        UNK(c).data_cps_comp1 = [];
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART 3 DRIFT CORRECTIONS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DATADRIFT


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART 4: PREPARATORY STEPS FOR LOD CALCULATIONS

%changed by MG 17.05.10 due to the implemention of the new LOD Calculation by Tanner M. JAAS 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for c = 1:A.UNK_num

    %create duplicate cps arrays
    UNK(c).data_cps_bg_LODmod = UNK(c).data_cps_bg;
    UNK(c).data_cps_mat_LODmod = UNK(c).data_cps_mat;
    UNK(c).data_cps_sig_LODmod = UNK(c).data_cps_sig;

    for b = 1:A.ISOTOPE_num

        %test for 0 counts in the background
        if sum(UNK(c).data_cps_bg(:,b))==0
            %replace with 1 count (e.g. 100cps for 10ms dwell time)
            UNK(c).data_cps_bg_LODmod(1,b) = 1/A.DT_VALUES(b);
        end

        %likewise...comment by MG 17.5.2010 why change a 0 value in the
        %host or the signal sample? ------> deleted
        %if ~isempty(UNK(c).data_cps_mat) && sum(UNK(c).data_cps_mat(:,b))==0
        %    UNK(c).data_cps_mat_LODmod(1,b) = 1/A.DT_VALUES(b);
       % end

       % if ~isempty(UNK(c).data_cps_sig) && sum(UNK(c).data_cps_sig(:,b))==0
        %   UNK(c).data_cps_sig_LODmod(1,b) = 1/A.DT_VALUES(b);
        %end

    end

    %define the standard deviations of the modified bg cps array
    %UNK(c).BG_stdev = std(UNK(c).data_cps_bg_LODmod); %old version
    UNK(c).BG_stdev = std(UNK(c).data_cps_bg);    % new version does not change the BG fom 0 to 1 count

    %define a modified version of each mean cps array
    %UNK(c).bg_cps_mod = mean(UNK(c).data_cps_bg_LODmod); old version
    UNK(c).bg_cps_mod = mean(UNK(c).data_cps_bg); %changed that there is no change
    UNK(c).mat_cps_mod = mean(UNK(c).data_cps_mat_LODmod); % not changed
    UNK(c).sig_cps_mod = mean(UNK(c).data_cps_sig_LODmod); % not changed

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART 5: Create an index of major oxide elements and trace elements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %..........................................................................
% %%% make a list of just isotope numbers from A.ISOTOPES_list
%     
% isotope = char(A.ISOTOPE_list); %convert isotopes into a character array
% iselement = isletter(isotope);  %search for letters within the 'isotope' array
% isnumber = -(iselement-1);
% number = isnumber.*isotope;
% number2 = char(number);
% for c = 1:A.ISOTOPE_num;
%     A.ISOTOPENUMBERS(c) = str2num(char(number2(c,:)));
% end
% 
% %..........................................................................
% %compare the elements in the oxide list with A.ELEMENT_list
% clear oxide_seek
% for b=1:11 
%     oxide_seek(:,b) = strcmp(A.ELEMENT_list,A.Oxides(b,1));
% end
% 
% %determine the indices of all oxides elements in the ELEMENTS_in_all_SRMs
% %list
% A.OXIDES_index = [];
% b = [];
% for d = 1:11
%     temp = find(oxide_seek(:,d)==1);
%     x = size(temp);
%     x = x(1);
%     for e = 1:x
%         f = A.Oxides(d,2);
%         b = [b;f];
%     end
%     A.OXIDES_index = [A.OXIDES_index;temp];
% end
% 
% A.OXIDES_oxide = b;
% num = size(A.OXIDES_index);
% num = num(1);
% 
% %create the complete list of oxides (separate entries for individual
% %isotopes)
% for d = 1:num
%     A.OXIDES_complete_list(d) = {[char(b(d)) ' (' num2str(A.ISOTOPENUMBERS(A.OXIDES_index(d))) ')']};
% end


%..........................................................................
%find the elements that are contained in the Oxides list 
%(i.e. SiO2, TiO2, Al2O3, Fe2O3, FeO, MnO, MgO, CaO, Na2O, K2O, P2O5)

clear oxide_seek oxide_seek2 oxide_seek_index oxide_seek_num

for b=1:A.ELEMENT_num
    oxide_seek(:,b) = strcmp(A.Oxides(:,1),A.ELEMENT_list(b));
end

oxide_seek2 = sum(oxide_seek);
oxide_seek_index = find(oxide_seek2 > 0);   %indices of the major oxide isotopes
trace_seek_index = find(oxide_seek2 == 0);

A.Oxides_index = zeros(11,1); %11 major oxides
for d=1:11
    a = find(oxide_seek(d,:)==1);
    sizea = size(a);
    if isempty(a)
        a = 0;
    elseif sizea(2) > 1 %i.e. more than one isotope of the same element was measured
        
        %select the isotope with the highest average sensitivty in the
        %standards
        for p = 1:sizea(2)
            avgRELSENS(p) = mean(A.STD_REFIS_CALIB(a(p),:));
        end
        
        maxsens = find(max(avgRELSENS));
        a = a(maxsens);
        A.Oxides_index(d) = a;
        
        clear avgRELSENS maxsens p 
        
    else       
        A.Oxides_index(d) = a;
    end
end

oxides_measured = find(A.Oxides_index > 0);
A.Oxides_index_condensed = A.Oxides_index(oxides_measured);
oxides_measured_num = size(A.Oxides_index_condensed);
A.Oxides_num = oxides_measured_num(1);

A.Oxides_measured = cell(A.Oxides_num,1);
A.Oxides_measured_mol_wts = zeros(A.Oxides_num,3);

Fe_hits = 0;
for d = 1:A.Oxides_num
    a = strcmp(A.Oxides(:,1),A.ELEMENT_list(A.Oxides_index_condensed(d)));
    b = find(a==1);
    if a(4) == 1 && a(5) == 1 && A.Fe_test ~= 0 %i.e. Fe was measured
        Fe_hits = Fe_hits + 1;
        if Fe_hits == 1
            %the oxide identity
            A.Oxides_measured(d) = A.Oxides(4,2);
            %the metal mol. wt.
            A.Oxides_measured_mol_wts(d,1) = A.Oxides_mol_wts(4,1);
            %the oxide mol. wt.
            A.Oxides_measured_mol_wts(d,2) = A.Oxides_mol_wts(4,2);
            %the metal to oxide ratio
            A.Oxides_measured_mol_wts(d,3) = A.Oxides_mol_wts(4,3);
        elseif Fe_hits == 2
            A.Oxides_measured(d) = A.Oxides(5,2);
            A.Oxides_measured_mol_wts(d,1) = A.Oxides_mol_wts(5,1);
            A.Oxides_measured_mol_wts(d,2) = A.Oxides_mol_wts(5,2);
            A.Oxides_measured_mol_wts(d,3) = A.Oxides_mol_wts(5,3);
        end        
    else
        A.Oxides_measured(d) = A.Oxides(b,2);
        A.Oxides_measured_mol_wts(d,1) = A.Oxides_mol_wts(b,1);
        A.Oxides_measured_mol_wts(d,2) = A.Oxides_mol_wts(b,2);
        A.Oxides_measured_mol_wts(d,3) = A.Oxides_mol_wts(b,3);
    end
end
clear Fe_hits

clear sizea oxides_measured oxides_measured_num 

%.........................................................................
A.Trace_index = (find(oxide_seek2 == 0))';     %indices of the trace elements isotopes
trace_seek_num = size(trace_seek_index);
A.Trace_num = trace_seek_num(2);         %number of isotopes in the trace element list
A.Trace_measured = A.ISOTOPE_list(A.Trace_index);

clear oxide_seek oxide_seek2 oxide_seek_index trace_seek_index trace_seek_num

% We now know where to look in the master A.ISOTOPE_list for the oxides and
% the trace elements

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear bg_t1 bg_t1_index bg_t2 bg_t2_index
clear mat1_t1 mat1_t1_index mat1_t2 mat1_t2_index
clear mat2_t1 mat2_t1_index mat2_t2 mat2_t2_index
clear comp1_t1 comp1_t1_index comp1_t2 comp1_t2_index
clear comp2_t1 comp2_t1_index comp2_t2 comp2_t2_index
clear comp3_t1 comp3_t1_index comp3_t2 comp3_t2_index
clear sig_t1 sig_t1_index sig_t2 sig_t2_index
