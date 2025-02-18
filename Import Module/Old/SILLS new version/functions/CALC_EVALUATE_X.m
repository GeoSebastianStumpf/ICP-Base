% CALC_EVALUATE
function [A, UNK,STD, SRM, SMAN, c] = CALC_EVALUATE_X(A, UNK,STD, SRM, SMAN)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This callback is summoned as the first stage in creating an output report.
% This script (and callbacks herein) contain all the calculation steps.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A.warning = 0;

if A.cpsonly == 0 %i.e. we want concentrations

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIAL CHECKS
% First perform some initial checks on the completeness of the user input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%..........................................................................
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

%..........................................................................
% check integration windows in the standards and that times have been
% allocated

for c = 1:A.STD_num

    if isempty(STD(c).bgwindow) || isempty(STD(c).sigwindow)
        msgbox(['Please select background and signal integration windows for standard ' num2str(c)],'SILLS Message');
        A.warning = 1;    
        return
    end

    if STD(c).bgwindow(2) - STD(c).bgwindow(1) == 0
        msgbox(['Please check background integration windows for standard ' num2str(c)],'SILLS Message');
        A.warning = 1;    
        return
    end

    if STD(c).sigwindow(2) - STD(c).sigwindow(1) == 0
        msgbox(['Please check signal integration windows for standard ' num2str(c)],'SILLS Message');
        A.warning = 1;    
        return
    end

    if strcmp(A.timeformat,'hhmm')==1
        if isempty(STD(c).hh) || isempty(STD(c).mm)
            msgbox(['Please specify times for standard ' num2str(c)],'SILLS Message');
            A.warning = 1;    
            return
        end
    end
end

%..........................................................................
% check integration windows in the unknowns and that times have been
% allocated

for c = 1:A.UNK_num

    if isempty(UNK(c).bgwindow) || UNK(c).bgwindow(2) - UNK(c).bgwindow(1) == 0
        msgbox(['Please check background integration windows for unknown ' num2str(c)],'SILLS Message');
        A.warning = 1;    
        return
    end

    if UNK(c).mattotal == 0 && UNK(c).sigtotal == 0
        msgbox(['Define a matrix or signal window for unknown ' num2str(c)],'SILLS Message');
        A.warning = 1;    
        return
    end

    %......................................................................
    % if applicable, check that hh:mm times have been entered 
    
    if strcmp(A.timeformat,'hhmm')==1
        if isempty(UNK(c).hh) || isempty(UNK(c).mm)
            msgbox(['Please specify times for unknown ' num2str(c)],'SILLS Message');
            A.warning = 1;    
            return
        end
    end
end

%..........................................................................
% check that matrix calculation parameters have been entered

for c = 1:A.UNK_num

    if UNK(c).MAT_corrtype == 2 && UNK(c).MATunit == 1 %i.e. matrix normalised to an internal standard (ug/g)
        if isempty(UNK(c).MATQIS_conc)
            msgbox(['Please specify an internal standard concentration for the matrix in unknown ' num2str(c)],'SILLS Message');
            A.warning = 1;    
            return
        end
    end
    
    if UNK(c).MAT_corrtype == 2 && UNK(c).MATunit == 2 %i.e. matrix normalised to an internal standard (wt%)
        if isempty(UNK(c).MATQIS_concwt)
            msgbox(['Please specify an internal standard concentration for the matrix in unknown ' num2str(c)],'SILLS Message');
            A.warning = 1;    
            return
        end
    end

    if UNK(c).MAT_corrtype == 3 %i.e. matrix normalised to total oxides
        if isempty(UNK(c).MAT_oxide_total)
            msgbox(['Please specify a total oxide value for the matrix in unknown ' num2str(c)],'SILLS Message');
            A.warning = 1;    
            return
        elseif A.Fe_test ~= 0 && isempty(UNK(c).MAT_Fe_ratio)
            msgbox(['Please specify a FeO/(FeO+Fe2O3) ratio for the matrix in unknown ' num2str(c)],'SILLS Message');
            A.warning = 1;    
            return
        end
    end
end

% check that signal calculation parameters have been entered
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for c = 1:A.UNK_num

    if UNK(c).MAT_corrtype == 1 && UNK(c).sigtotal == 0 %i.e. no matrix correction / no signal selected 
        msgbox(['Unknown ' num2str(c) ' must have a matrix and/or signal calculation'],'SILLS Message');
        A.warning = 1;    
        return
    end

    if UNK(c).sigtotal ~= 0 %i.e. there is a signal; Added in 1.0.6
        if UNK(c).SIG_constraint1 == 1 && UNK(c).SIG1unit == 1 %i.e. sample normalised to an internal standard (ug/g)
            if isempty(UNK(c).SIGQIS1_conc)
                msgbox(['Please specify an internal standard concentration for the sample in unknown ' num2str(c)],'SILLS Message');
                A.warning = 1;
                return
            end
        end

        if UNK(c).SIG_constraint1 == 1 && UNK(c).SIG1unit == 2 %i.e. sample normalised to an internal standard (wt%)
            if isempty(UNK(c).SIGQIS1_concwt)
                msgbox(['Please specify an internal standard concentration for the sample in unknown ' num2str(c)],'SILLS Message');
                A.warning = 1;
                return
            end
        end

        if UNK(c).SIG_constraint1 == 2 || UNK(c).SIG_constraint1 == 3 %i.e. sample normalised to salinity
            if isempty(UNK(c).SIGsalinity)
                msgbox(['Please specify a salinity for the sample in unknown ' num2str(c)],'SILLS Message');
                A.warning = 1;
                return
            end
        end
        
        if UNK(c).SIG_constraint1 == 2 %Added in 1.0.6
            if isempty(UNK(c).SALT_mass_balance_factor)
                 msgbox(['Please specify a salt mass balance factor for the sample in unknown ' num2str(c)],'SILLS Message');
                 A.warning = 1;
            end
        end

        if UNK(c).SIG_constraint1 == 4 %i.e. sample normalised to total oxides
            if isempty(UNK(c).SIG_oxide_total)
                msgbox(['Please specify a total oxide value for the sample in unknown ' num2str(c)],'SILLS Message');
                A.warning = 1;
                return
            elseif A.Fe_test ~= 0 && isempty(UNK(c).SIG_Fe_ratio)
                msgbox(['Please specify a FeO/(FeO+Fe2O3) ratio for the sample in unknown ' num2str(c)],'SILLS Message');
                A.warning = 1;
                return
            end
        end
    end
end

for c = 1:A.UNK_num

    if UNK(c).MAT_corrtype ~= 1 && UNK(c).sigtotal ~= 0 %i.e. there is a matrix correction; modified in 1.0.6
        if UNK(c).SIG_constraint2 == 2 && UNK(c).SIG2unit == 1 % i.e. normalised to a 2nd internal standard (ug/g)
            if isempty(UNK(c).SIGQIS2_conc)
                msgbox(['Please specify a 2nd internal standard concentration for the sample in unknown ' num2str(c)],'SILLS Message');
                A.warning = 1;    
               return
            end
        elseif UNK(c).SIG_constraint2 == 2 && UNK(c).SIG2unit == 2 % i.e. normalised to a 2nd internal standard (wt.%)
            if isempty(UNK(c).SIGQIS2_concwt)
                msgbox(['Please specify a 2nd internal standard concentration for the sample in unknown ' num2str(c)],'SILLS Message');
                A.warning = 1;    
               return
            end
        end
    end
end


%if the calculation can proceed without any warning statements, declare
%A.warning = 0; Otherwise A.warning = 1
A.warning = 0; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART 1-3: Initial Data Filtering 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[A, UNK,STD, SRM] = DATAFILTER_X(A, UNK,STD, SRM);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART 4 MATRIX (HOST) CALCULATIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%..........................................................................
%Determine which unknowns have been allocated a matrix correction
%% fix because if there are e.g. 40 unknowns loaded in and then 5 unknowns deleted, the MATcorrfile list is offset because it doesnt refresh the list
% so e.g. if we have 5 samples and the 4th sample is deleted, the list will
% be 1, 2, 3, 5 but there are only 4 samples in there so it cant possibly
% index to 5
for  c=1:A.UNK_num
UNK(c).MATcorrfile=c;
end
%% original code
for c=1:A.UNK_num
    %old
    %  if get(SMAN.handles(c).h_MATtype,'Value') ~= 1 %i.e. the user has chosen to define a matrix correction
    if SMAN.handles(c).h_MATtype ~= 1 %i.e. the user has chosen to define a matrix correction
        %
        %assign the chosen matrix file's matrix data to the current unknown
        UNK(c).mat_time = UNK(UNK(c).MATcorrfile).mat_time;
        UNK(c).data_cps_mat = UNK(UNK(c).MATcorrfile).data_cps_mat;
        UNK(c).data_cps_mat_LODmod = UNK(UNK(c).MATcorrfile).data_cps_mat_LODmod;
        UNK(c).mat_cps = UNK(UNK(c).MATcorrfile).mat_cps;
        UNK(c).mat_cps_mod = UNK(UNK(c).MATcorrfile).mat_cps_mod;

    else %i.e. no matrix correction
        UNK(c).mat_time = 0;
        UNK(c).data_cps_mat = zeros(1,A.ISOTOPE_num);
        UNK(c).data_cps_mat_LODmod = zeros(1,A.ISOTOPE_num);
        UNK(c).mat_cps = zeros(1,A.ISOTOPE_num);
        UNK(c).mat_cps_mod = zeros(1,A.ISOTOPE_num);
    end
end

%..........................................................................
%Now scroll through the unknowns and calculate the host composition
%..........................................................................

for c = 1:A.UNK_num

    % First define MATQIS_CALIB = [I(x),std/I(MATQIS),std] /
    % [C(x),std/C(MATQIS),std]

    % MATQIS_CALIB = REFIS_CALIB*[(I(REFIS),std/I(MATQIS),std) /
    % C(MATQIS),std/C(REFIS),std)]

    UNK(c).MATQIS_CALIB = UNK(c).REFIS_CALIB ./ UNK(c).REFIS_CALIB(UNK(c).MATQIS);

    if UNK(c).MAT_corrtype == 1 %i.e. no correction

        UNK(c).MAT_CONC = zeros(1,A.ISOTOPE_num);
        UNK(c).MAT_CONC_error = zeros(1,A.ISOTOPE_num);
        UNK(c).MAT_LOD_mn = zeros(1,A.ISOTOPE_num);
        UNK(c).MAT_LOD_mm = zeros(1,A.ISOTOPE_num);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %CASE 1: Internal Standard
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    elseif UNK(c).MAT_corrtype == 2

        [A, UNK, STD, SRM, SMAN] = MATCASE1_132(A, UNK, STD, SRM, SMAN, c);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %CASE 2: Total Oxides
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    elseif UNK(c).MAT_corrtype == 3

        [A, UNK, STD, SRM, SMAN] = MATCASE2_132(A, UNK, STD, SRM, SMAN, c);

    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART 5: SIGNAL CALCULATIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for c = 1:A.UNK_num

    %......................................................................
    % If there is no signal window, set concentration, error, and LOD to 0

    if UNK(c).sigtotal == 0
        UNK(c).SAMP_CONC = zeros(1,A.ISOTOPE_num);
        UNK(c).SAMP_CONC_error = zeros(1,A.ISOTOPE_num);
        UNK(c).SAMP_LOD_mn = zeros(1,A.ISOTOPE_num);
        UNK(c).SAMP_LOD_mm = zeros(1,A.ISOTOPE_num);
        continue;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % CALCULATE THE COUNT RATE OF THE SAMPLE IN THE MIXED SIGNAL
    % (APPLICABLE IF THERE IS EITHER i)NO MATRIX CORRECTION, OR
    % ii) A MATRIX-ONLY TRACER)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if UNK(c).MAT_corrtype == 1 || (UNK(c).MAT_corrtype ~=1 && UNK(c).SIG_constraint2 == 1)

        %define the sample count rate
        [A, UNK,STD, SRM, SMAN] = SAMP_CPS_X(A, UNK,STD, SRM, SMAN, c);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Internal Standard
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if UNK(c).SIG_constraint1 == 1 %i.e. internal standard
            
            [A, UNK,STD, SRM, SMAN] = calcINTSTD_X(A, UNK,STD, SRM, SMAN, c);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Total Salinity
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif UNK(c).SIG_constraint1 == 2 || UNK(c).SIG_constraint1 == 3 %i.e. eq. wt% NaCl
            
            [A, UNK,STD, SRM, SMAN] = calcSALT_X(A, UNK,STD, SRM, SMAN, c);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Total Oxides (major elements)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif UNK(c).SIG_constraint1 == 4 %i.e. total oxides
            
            [A, UNK,STD, SRM, SMAN] = calcOXIDE_X(A, UNK,STD, SRM, SMAN, c);
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % IF THERE IS A MATRIX CORRECTION AND A MORE COMPLEX QUANTIFICATION
        % SCHEME....
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    elseif UNK(c).MAT_corrtype ~=1 && (UNK(c).SIG_constraint2 == 2 || UNK(c).SIG_constraint2 == 3)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %2 Internal Standards
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        if UNK(c).SIG_constraint1 == 1 && UNK(c).SIG_constraint2 == 2

             [A, UNK, STD, SRM, SMAN] = calcINTSTD_INTSTD_132(A, UNK, STD, SRM, SMAN, c);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Total Salinity & Internal Std.
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        elseif (UNK(c).SIG_constraint1 == 2 || UNK(c).SIG_constraint1 == 3) && UNK(c).SIG_constraint2 == 2
            
            if isempty(UNK(c).SALT_mass_balance_factor)
                msgbox('Please enter a mass balance factor for the salinity normalisation (click on ''ELEMENTS'')','SILLS Message');
                return
            end
            
            [A, UNK, STD, SRM, SMAN] = HOST_CALC_132(A, UNK, STD, SRM, SMAN, c);
            [A, UNK, STD, SRM, SMAN] = calcSALT_INTSTD_132(A, UNK, STD, SRM, SMAN, c);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Total Oxides & Internal Std.
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        elseif UNK(c).SIG_constraint1 == 4 && UNK(c).SIG_constraint2 == 2
            [A, UNK, STD, SRM, SMAN] = HOST_CALC_132(A, UNK, STD, SRM, SMAN, c);
            [A, UNK, STD, SRM, SMAN] = calcOXIDE_INTSTD_132(A, UNK, STD, SRM, SMAN, c);

        end
        UNK(c).yield = []; %Set ablation yield to empty (can't be calculated), added in 1.2.0
    end
end


clear bg_t1_index bg_t2_index bg_t1 bg_t2 sig_t1_index sig_t2_index sig_t1 sig_t2
clear mat1_t1_index mat1_t2_index mat2_t1_index mat2_t2_index mat1_t1 mat1_t2 mat2_t1 mat2_t2
clear comp1_t1_index comp1_t2_index comp2_t1_index comp2_t2_index comp3_t1_index comp3_t2_index
clear comp1_t1 comp1_t2 comp2_t1 comp2_t2 comp3_t1 comp3_t2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART 6: RATIO CALCULATIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[A, UNK,STD, SRM, SMAN] = calcRATIOS_X(A, UNK,STD, SRM, SMAN);

else %i.e. only CPS data
    
    [A, UNK,STD, SRM, SMAN] = calcCPSONLY_X(A, UNK,STD, SRM, SMAN);
    [A, UNK,STD, SRM, SMAN] = calcRATIOS_X(A, UNK,STD, SRM, SMAN);
    
end

end