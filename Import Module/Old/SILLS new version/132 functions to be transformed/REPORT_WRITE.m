%REPORT_WRITE

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This callback is summoned when the use clicks on 'Create Output Report'
% from the Calculation Manager Window. All operations related to the
% formatting of the report are contained herein
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%..........................................................................
%first perform the calculations:
CALC_EVALUATE;

%..........................................................................
%if there were any warnings produced in CALC_EVALUATE, cancel the action
if A.warning == 1;
    return
end

%..........................................................................
%report if there are any problems with the calculations
clear success

if A.cpsonly == 1 % Added in 1.0.3
    success = ones(A.UNK_num,1);
else
    for c = 1:A.UNK_num
        if UNK(c).matrix_correction_success == 1
            success(c) = 1;
        elseif isempty(UNK(c).matrix_correction_success)
            success(c) = -1;
        elseif UNK(c).matrix_correction_success == 0
            success(c) = 0;
        end
    end
end

%..........................................................................
%find the unknowns for which there was a calculation problem flagged
warning_index = find(success == 0);
if ~isempty(warning_index);
    index = num2str(warning_index);
    msgbox(['Calculation problems have been flagged for the following samples: ' index],'SILLS Warning');
    return
end
clear warning_index index success

%..........................................................................
%determine whether matrix corrections were performed
for c = 1:A.UNK_num
    if UNK(c).MAT_corrtype ~= 1 %i.e. a matrix correction was made
        matrix_correction_test(c) = 1;
    else
        matrix_correction_test(c) = 0;
    end
end

if sum(matrix_correction_test) == 0; %i.e. at least some unknowns have hosts
    colnumber = 16;
else
    colnumber = 24;
end

%..........................................................................
%perform population analysis if requested

% if strcmp(report_settings_population,'on') == 1
%     
%     POPANALYSIS;
%     
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Show config dialog
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Report_config

clear repfig previewpanel repselection relsens sampconc samperr samplod sampinmix
clear hostconc hosterr hostlod bgcps individual createbutton cancelbutton
clear hostcps stdcps ratios x previewtable yield nbackgr bgstdev mixcps nsweeps%Changed in 1.0.2/1.0.3/1.1.1/1.2.0/1.3.0

if abort == 1
    clear abort
    return
else
    clear abort
end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CREATE THE REPORT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%determine the width of the spreadsheet, where colnumber is the number of column
%headers in the individual unknown tables and A.ISOTOPE_num is the number of
%isotopes measured. For this calculation, it is assumed that both x and the
%ablation yield are selected

if strcmp(A.report_settings_oxide,'off')==1;
    w = max([colnumber A.ISOTOPE_num+8 A.ratios.num+3]); %Modified in 1.0.3/1.1.1/1.2.0
else
    w = max([colnumber (A.Oxides_num + A.Trace_num + 5) A.ISOTOPE_num+8 A.ratios.num+3]); %Modified in 1.0.3/1.1.1/1.2.0/1.3.0
end

%..........................................................................
gap = cell(2,w);
separator = cell(3,w);
separator(2,1) = {'**************************************************'};

%..........................................................................
%ITEM 1: Header information
REPORT.header = cell(1,w);
REPORT.header(1,1:2) = {'SILLS Project:' A.sillsfile};

%ITEM 2: STANDARDS: Relative Sensitivity
if reportcfg.relsens == 1
    REPORT.STD_relsens = cell(2+A.STD_num,w);
    REPORT.STD_relsens(1,1) = {'STANDARDS: Relative Sensitivy'};
    REPORT.STD_relsens(2,1:3+A.ISOTOPE_num) = horzcat('File','Time','SRM',A.ISOTOPE_list);
    REPORT.STD_relsens(3:end,1) = A.STDPOPUPLIST;
    for c = 1:A.STD_num
        if strcmp(A.timeformat,'integer_points')==1;
            REPORT.STD_relsens(2+c,2) = {STD(c).timepoint};
        else
            REPORT.STD_relsens(2+c,2) = {[STD(c).hh ':' STD(c).mm]};
        end
        REPORT.STD_relsens(2+c,3) = {SRM(STD(c).SRM).name};

        temp = num2cell(STD(c).REPORTIS_CALIB);
        temp(A.ISOTOPES_with_no_SRM_index) = {'--'};
        REPORT.STD_relsens(2+c,4:3+A.ISOTOPE_num) = temp;
        clear temp

    end
else
    REPORT.STD_relsens = cell(1,w);
end

%..........................................................................
%ITEM 3: SAMPLES: Composition Summary / x / Ablation yield / sweeps
if reportcfg.sampconc == 1
    d = 0; %count the number of unknowns with samples analysed
    for c= 1:A.UNK_num
        if UNK(c).sigtotal > 0
            d = d+1;
            e(c) = c;
        else
            e(c) = 0;
        end
    end

    REPORT.SAMP_compsummary = cell(3+d,w);
    REPORT.SAMP_compsummary(1,1) = {'SAMPLES: Composition Summary'};
    REPORT.SAMP_compsummary(2,1) = {'File'};
    REPORT.SAMP_compsummary(2,2) = {'Time'};
    REPORT.SAMP_compsummary(2,3) = {'Info'}; %Added in 1.0.5

    if strcmp(A.report_settings_oxide,'off') == 1;

        REPORT.SAMP_compsummary(2,4:3+A.ISOTOPE_num) = A.ISOTOPE_list;
        REPORT.SAMP_compsummary(3,4:3+A.ISOTOPE_num) = {[char(181) 'g/g']};

        d = 0;
        for c = 1:A.UNK_num
            if e(c) == 0;
                continue
            else
                d = d+1;
                REPORT.SAMP_compsummary(3+d,1) = A.UNKPOPUPLIST(c);

                if strcmp(A.timeformat,'integer_points')==1;
                    REPORT.SAMP_compsummary(3+d,2) = {UNK(c).timepoint};
                else
                    REPORT.SAMP_compsummary(3+d,2) = {[UNK(c).hh ':' UNK(c).mm]};
                end
                REPORT.SAMP_compsummary(3+d,3) = {UNK(c).Info}; %Added in 1.0.5
                
                REPORT.SAMP_compsummary(3+d,4:3+A.ISOTOPE_num) = num2cell(UNK(c).SAMP_CONC);
                %test for concentrations below detections; replace conc with '<LOD'
                for i = 1:A.ISOTOPE_num;
                    if UNK(c).SAMP_CONC(i) < UNK(c).SAMP_LOD_mn(i)
                        REPORT.SAMP_compsummary(3+d,3+i) = {[char(60) num2str(UNK(c).SAMP_LOD_mn(i))]};
                    elseif strcmp(num2str(UNK(c).SAMP_CONC(i)),'NaN')==1;
                        REPORT.SAMP_compsummary(3+d,3+i) = {'--'};
                    end
                end
                
                %If x is selected, append to this summary; Added in 1.1.1
                if reportcfg.x == 1
                    REPORT.SAMP_compsummary(1,4+A.ISOTOPE_num) = {'Mass ratio Sample/Mix'};
                    REPORT.SAMP_compsummary(2,4+A.ISOTOPE_num) = {'x'};
                    REPORT.SAMP_compsummary(3,4+A.ISOTOPE_num) = {'g/g'};
                    REPORT.SAMP_compsummary(3+d,4+A.ISOTOPE_num) = {UNK(c).x};
                end
                %If yield is selected, append to this summary; Added in 1.2.0
                if reportcfg.yield == 1
                    if reportcfg.x == 1
                        pos = 5;
                    else
                        pos = 4;
                    end
                    REPORT.SAMP_compsummary(1,pos+A.ISOTOPE_num) = {'Ablation yield'};
                    REPORT.SAMP_compsummary(3,pos+A.ISOTOPE_num) = {'(cps/ppm)/(cps/ppm)'};
                    REPORT.SAMP_compsummary(3+d,pos+A.ISOTOPE_num) = {UNK(c).yield};
                end
                %If # of sweeps is selected, append to this summary; Added in 1.3.0
                if reportcfg.nsweeps == 1
                    if reportcfg.x == 0 && reportcfg.yield == 0
                        pos = 4;
                    elseif reportcfg.x == 1 && reportcfg.yield == 1
                        pos = 6;
                    else
                        pos = 5;
                    end
                    REPORT.SAMP_compsummary(1,pos+A.ISOTOPE_num) = {'no of sweeps in: '};
                    REPORT.SAMP_compsummary(3,pos+A.ISOTOPE_num) = {'nbg'};
                    REPORT.SAMP_compsummary(3+d,pos+A.ISOTOPE_num) = {UNK(c).Nbg};
                    REPORT.SAMP_compsummary(3,pos+1+A.ISOTOPE_num) = {'nsig'};
                    REPORT.SAMP_compsummary(3+d,pos+1+A.ISOTOPE_num) = {UNK(c).Nsig};
                    if UNK(c).Nmat >= 3 %no matrix correction equals 2                              
                        REPORT.SAMP_compsummary(3,pos+2+A.ISOTOPE_num) = {'nHost'};
                        REPORT.SAMP_compsummary(3+d,pos+2+A.ISOTOPE_num) = {UNK(c).Nmat};
                    end
                end
                
            end
        end
    else

        REPORT.SAMP_compsummary(2,4:3+A.Oxides_num) = A.Oxides_measured';
        REPORT.SAMP_compsummary(3,4:3+A.Oxides_num) = {'wt.%'};
        REPORT.SAMP_compsummary(2,4+A.Oxides_num:3+A.Oxides_num+A.Trace_num) = A.Trace_measured;
        REPORT.SAMP_compsummary(3,4+A.Oxides_num:3+A.Oxides_num+A.Trace_num) = {[char(181) 'g/g']};

        d = 0;
        for c = 1:A.UNK_num
            if e(c) == 0;
                continue
            else
                d = d+1;
                REPORT.SAMP_compsummary(3+d,1) = A.UNKPOPUPLIST(c);

                if strcmp(A.timeformat,'integer_points')==1;
                    REPORT.SAMP_compsummary(3+d,2) = {UNK(c).timepoint};
                else
                    REPORT.SAMP_compsummary(3+d,2) = {[UNK(c).hh ':' UNK(c).mm]};
                end
                REPORT.SAMP_compsummary(3+d,3) = {UNK(c).Info}; %Added in 1.0.5

                if A.Oxides_num > 0
                    REPORT.SAMP_compsummary(3+d,4:3+A.Oxides_num) = num2cell(UNK(c).SAMP_CONC_majox);
                end
                if A.Trace_num > 0
                    REPORT.SAMP_compsummary(3+d,4+A.Oxides_num:3+A.Oxides_num+A.Trace_num) = num2cell(UNK(c).SAMP_CONC_trace);
                end

                %test for concentrations below detections; replace conc with '<LOD'
                for i = 1:A.Oxides_num;
                    if UNK(c).SAMP_CONC_majox(i) < UNK(c).SAMP_LOD_mn_majox(i)
                        REPORT.SAMP_compsummary(3+d,3+i) = {[char(60) num2str(UNK(c).SAMP_LOD_mn_majox(i))]};
                    elseif strcmp(num2str(UNK(c).SAMP_CONC_majox(i)),'NaN')==1;
                        REPORT.SAMP_compsummary(3+d,3+i) = {'--'};
                    end
                end
                for i = 1:A.Trace_num;
                    if UNK(c).SAMP_CONC_trace(i) < UNK(c).SAMP_LOD_mn_trace(i)
                        REPORT.SAMP_compsummary(3+d,3+A.Oxides_num+i) = {[char(60) num2str(UNK(c).SAMP_LOD_mn_trace(i))]};
                    elseif strcmp(num2str(UNK(c).SAMP_CONC_trace(i)),'NaN')==1;
                        REPORT.SAMP_compsummary(3+d,3+A.Oxides_num+i) = {'--'};
                    end
                end
                                
                %If x is selected, append to this summary; Added in 1.1.1
                if reportcfg.x == 1
                    REPORT.SAMP_compsummary(1,4+A.Oxides_num+A.Trace_num) = {'Mass ratio Sample/Mix'};
                    REPORT.SAMP_compsummary(2,4+A.Oxides_num+A.Trace_num) = {'x'};
                    REPORT.SAMP_compsummary(3,4+A.Oxides_num+A.Trace_num) = {'g/g'};
                    REPORT.SAMP_compsummary(3+d,4+A.Oxides_num+A.Trace_num) = {UNK(c).x};
                end
                %If yield is selected, append to this summary; Added in 1.2.0
                if reportcfg.yield == 1
                    if reportcfg.x == 1
                        pos = 5;
                    else
                        pos = 4;
                    end
                    REPORT.SAMP_compsummary(1,pos+A.Oxides_num+A.Trace_num) = {'Ablation yield'};
                    REPORT.SAMP_compsummary(3,pos+A.Oxides_num+A.Trace_num) = {'(cps/ppm)/(cps/ppm)'};
                    REPORT.SAMP_compsummary(3+d,pos+A.Oxides_num+A.Trace_num) = {UNK(c).yield};
                end
                %If # of sweeps is selected, append to this summary; Added in 1.3.0
                if reportcfg.nsweeps == 1
                    if reportcfg.x == 0 && reportcfg.yield == 0
                        pos = 4;
                    elseif reportcfg.x == 1 && reportcfg.yield == 1
                        pos = 6;
                    else
                        pos = 5;
                    end
                    REPORT.SAMP_compsummary(1,pos+A.Oxides_num+A.Trace_num) = {'no of sweeps in: '};
                    REPORT.SAMP_compsummary(3,pos+A.Oxides_num+A.Trace_num) = {'nbg'};
                    REPORT.SAMP_compsummary(3+d,pos+A.Oxides_num+A.Trace_num) = {UNK(c).Nbg};
                    REPORT.SAMP_compsummary(3,pos+1+A.Oxides_num+A.Trace_num) = {'nsig'};
                    REPORT.SAMP_compsummary(3+d,pos+1+A.Oxides_num+A.Trace_num) = {UNK(c).Nsig};
                    if UNK(c).Nmat >= 3 %no matrix correction equals 2
                        REPORT.SAMP_compsummary(3,pos+2+A.Oxides_num+A.Trace_num) = {'nHost'};
                        REPORT.SAMP_compsummary(3+d,pos+2+A.Oxides_num+A.Trace_num) = {UNK(c).Nmat};
                    end
                end
            end
        end
    end
else
    REPORT.SAMP_compsummary = cell(1,w);
end

%..........................................................................
%ITEM 4: SAMPLES: Error Summary
if reportcfg.samperr == 1
    d = 0; %count the number of unknowns with samples analysed
    for c= 1:A.UNK_num
        if UNK(c).sigtotal > 0
            d = d+1;
            e(c) = c;
        else
            e(c) = 0;
        end
    end

    REPORT.SAMP_errorsummary = cell(3+d,w);
    REPORT.SAMP_errorsummary(1,1) = {'SAMPLES: Error Summary (1 sigma)'};
    REPORT.SAMP_errorsummary(2,1) = {'File'};
    REPORT.SAMP_errorsummary(2,2) = {'Time'};
    REPORT.SAMP_errorsummary(2,3) = {'Info'}; %Added in 1.0.5

    if strcmp(A.report_settings_oxide,'off') == 1;

        REPORT.SAMP_errorsummary(2,4:3+A.ISOTOPE_num) = A.ISOTOPE_list;
        REPORT.SAMP_errorsummary(3,4:3+A.ISOTOPE_num) = {[char(181) 'g/g']};
        d = 0;
        for c = 1:A.UNK_num
            if e(c) == 0;
                continue
            else
                d = d+1;
                REPORT.SAMP_errorsummary(3+d,1) = A.UNKPOPUPLIST(c);

                if strcmp(A.timeformat,'integer_points')==1;
                    REPORT.SAMP_errorsummary(3+d,2) = {UNK(c).timepoint};
                else
                    REPORT.SAMP_errorsummary(3+d,2) = {[UNK(c).hh ':' UNK(c).mm]};
                end
                REPORT.SAMP_errorsummary(3+d,3) = {UNK(c).Info}; %Added in 1.0.5

                REPORT.SAMP_errorsummary(3+d,4:3+A.ISOTOPE_num) = num2cell(UNK(c).SAMP_CONC_error);
                %test for concentrations below detections; replace conc with '<LOD'
                for i = 1:A.ISOTOPE_num;
                    if UNK(c).SAMP_CONC(i) < UNK(c).SAMP_LOD_mn(i)
                        REPORT.SAMP_errorsummary(3+d,3+i) = {[char(60) num2str(UNK(c).SAMP_LOD_mn(i))]};
                    elseif strcmp(num2str(UNK(c).SAMP_CONC(i)),'NaN')==1;
                        REPORT.SAMP_errorsummary(3+d,3+i) = {'--'};
                    end
                end
            end
        end
    else

        REPORT.SAMP_errorsummary(2,4:3+A.Oxides_num) = A.Oxides_measured';
        REPORT.SAMP_errorsummary(3,4:3+A.Oxides_num) = {'wt.%'};
        REPORT.SAMP_errorsummary(2,4+A.Oxides_num:3+A.Oxides_num+A.Trace_num) = A.Trace_measured;
        REPORT.SAMP_errorsummary(3,4+A.Oxides_num:3+A.Oxides_num+A.Trace_num) = {[char(181) 'g/g']};

        d = 0;
        for c = 1:A.UNK_num
            if e(c) == 0;
                continue
            else
                d = d+1;
                REPORT.SAMP_errorsummary(3+d,1) = A.UNKPOPUPLIST(c);

                if strcmp(A.timeformat,'integer_points')==1;
                    REPORT.SAMP_errorsummary(3+d,2) = {UNK(c).timepoint};
                else
                    REPORT.SAMP_errorsummary(3+d,2) = {[UNK(c).hh ':' UNK(c).mm]};
                end
                REPORT.SAMP_errorsummary(3+d,3) = {UNK(c).Info}; %Added in 1.0.5

                if A.Oxides_num > 0
                    REPORT.SAMP_errorsummary(3+d,4:3+A.Oxides_num) = num2cell(UNK(c).SAMP_CONC_error_majox);
                end
                if A.Trace_num > 0
                    REPORT.SAMP_errorsummary(3+d,4+A.Oxides_num:3+A.Oxides_num+A.Trace_num) = num2cell(UNK(c).SAMP_CONC_error_trace);
                end

                %test for concentrations below detections; replace conc with '<LOD'
                for i = 1:A.Oxides_num;
                    if UNK(c).SAMP_CONC_majox(i) < UNK(c).SAMP_LOD_mn_majox(i)
                        REPORT.SAMP_errorsummary(3+d,3+i) = {[char(60) num2str(UNK(c).SAMP_LOD_mn_majox(i))]};
                    elseif strcmp(num2str(UNK(c).SAMP_CONC_error_majox(i)),'NaN')==1;
                        REPORT.SAMP_errorsummary(3+d,3+i) = {'--'};
                    end
                end
                for i = 1:A.Trace_num;
                    if UNK(c).SAMP_CONC_trace(i) < UNK(c).SAMP_LOD_mn_trace(i)
                        REPORT.SAMP_errorsummary(3+d,3+A.Oxides_num+i) = {[char(60) num2str(UNK(c).SAMP_LOD_mn_trace(i))]};
                    elseif strcmp(num2str(UNK(c).SAMP_CONC_error_trace(i)),'NaN')==1;
                        REPORT.SAMP_errorsummary(3+d,3+A.Oxides_num+i) = {'--'};
                    end
                end
            end
        end
    end
else
    REPORT.SAMP_errorsummary = cell(1,w);
end


%..........................................................................
%ITEM 5: SAMPLES: LOD Summary
if reportcfg.samplod == 1
    d = 0; %count the number of unknowns with samples analysed
    for c= 1:A.UNK_num
        if UNK(c).sigtotal > 0
            d = d+1;
            e(c) = c;
        else
            e(c) = 0;
        end
    end

    REPORT.SAMP_LODsummary = cell(3+d,w);
    REPORT.SAMP_LODsummary(1,1) = {'SAMPLES: Limits of Detection Summary'};
    REPORT.SAMP_LODsummary(1,5) = {['Method: ' A.LODmethod]};
    REPORT.SAMP_LODsummary(2,1) = {'File'};
    REPORT.SAMP_LODsummary(2,2) = {'Time'};
    REPORT.SAMP_LODsummary(2,3) = {'Info'}; %Added in 1.0.5

    if strcmp(A.report_settings_oxide,'off') == 1;

        REPORT.SAMP_LODsummary(2,4:3+A.ISOTOPE_num) = A.ISOTOPE_list;
        REPORT.SAMP_LODsummary(3,4:3+A.ISOTOPE_num) = {[char(181) 'g/g']};
        d = 0;
        for c = 1:A.UNK_num
            if e(c) == 0;
                continue
            else
                d = d+1;
                REPORT.SAMP_LODsummary(3+d,1) = A.UNKPOPUPLIST(c);

                if strcmp(A.timeformat,'integer_points')==1;
                    REPORT.SAMP_LODsummary(3+d,2) = {UNK(c).timepoint};
                else
                    REPORT.SAMP_LODsummary(3+d,2) = {[UNK(c).hh ':' UNK(c).mm]};
                end
                REPORT.SAMP_LODsummary(3+d,3) = {UNK(c).Info}; %Added in 1.0.5

                REPORT.SAMP_LODsummary(3+d,4:3+A.ISOTOPE_num) = num2cell(UNK(c).SAMP_LOD_mn);
                for i = 1:A.ISOTOPE_num;
                    if strcmp(num2str(UNK(c).SAMP_LOD_mn(i)),'NaN')==1;
                        REPORT.SAMP_LODsummary(3+d,3+i) = {'--'};
                    end
                end
            end
        end
    else

        REPORT.SAMP_LODsummary(2,4:3+A.Oxides_num) = A.Oxides_measured';
        REPORT.SAMP_LODsummary(3,4:3+A.Oxides_num) = {'wt.%'};
        REPORT.SAMP_LODsummary(2,4+A.Oxides_num:3+A.Oxides_num+A.Trace_num) = A.Trace_measured;
        REPORT.SAMP_LODsummary(3,4+A.Oxides_num:3+A.Oxides_num+A.Trace_num) = {[char(181) 'g/g']};

        d = 0;
        for c = 1:A.UNK_num
            if e(c) == 0;
                continue
            else
                d = d+1;
                REPORT.SAMP_LODsummary(3+d,1) = A.UNKPOPUPLIST(c);

                if strcmp(A.timeformat,'integer_points')==1;
                    REPORT.SAMP_LODsummary(3+d,2) = {UNK(c).timepoint};
                else
                    REPORT.SAMP_LODsummary(3+d,2) = {[UNK(c).hh ':' UNK(c).mm]};
                end
                REPORT.SAMP_LODsummary(3+d,3) = {UNK(c).Info}; %Added in 1.0.5

                if A.Oxides_num > 0
                    REPORT.SAMP_LODsummary(3+d,4:3+A.Oxides_num) = num2cell(UNK(c).SAMP_LOD_mn_majox);
                end
                if A.Trace_num > 0
                    REPORT.SAMP_LODsummary(3+d,4+A.Oxides_num:3+A.Oxides_num+A.Trace_num) = num2cell(UNK(c).SAMP_LOD_mn_trace);
                end

                for i = 1:A.Oxides_num;
                    if strcmp(num2str(UNK(c).SAMP_LOD_mn_majox(i)),'NaN')==1;
                        REPORT.SAMP_LODsummary(3+d,3+i) = {'--'};
                    end
                end
                for i = 1:A.Trace_num;
                    if strcmp(num2str(UNK(c).SAMP_LOD_mn_trace(i)),'NaN')==1;
                        REPORT.SAMP_LODsummary(3+d,3+A.Oxides_num+i) = {'--'};
                    end
                end
            end
        end
    end
else
    REPORT.SAMP_LODsummary = cell(1,w);
end

%..........................................................................
%ITEM 6: SAMPLES: Sample in MIX(cps)
if reportcfg.sampinmix == 1

    d = 0; %count the number of unknowns with samples analysed
    for c= 1:A.UNK_num
        if UNK(c).sigtotal > 0
            d = d+1;
            e(c) = c;
        else
            e(c) = 0;
        end
        if UNK(c).MAT_corrtype ~= 1 && UNK(c).SIG_constraint2 ~= 1 %Added in 1.1.1
            f(c) = 0;
        else
            f(c) = 1;
        end
    end

    REPORT.SAMP_in_MIX = cell(3+d,w);
    REPORT.SAMP_in_MIX(1,1) = {'SAMPLES: Sample in MIX (cps) Background corrected'};
    REPORT.SAMP_in_MIX(2,1) = {'File'};
    REPORT.SAMP_in_MIX(2,2) = {'Time'};
    REPORT.SAMP_in_MIX(2,3) = {'Info'}; %Added in 1.0.5
    REPORT.SAMP_in_MIX(2,4:3+A.ISOTOPE_num) = A.ISOTOPE_list;
    REPORT.SAMP_in_MIX(3,4:3+A.ISOTOPE_num) = {'cps'};

    d = 0;
    for c = 1:A.UNK_num
        if e(c) == 0 || f(c) == 0; %Added f(c) in 1.1.1
            continue
        else
            d = d+1;
            REPORT.SAMP_in_MIX(3+d,1) = A.UNKPOPUPLIST(c);

            if strcmp(A.timeformat,'integer_points')==1;
                REPORT.SAMP_in_MIX(3+d,2) = {UNK(c).timepoint};
            else
                REPORT.SAMP_in_MIX(3+d,2) = {[UNK(c).hh ':' UNK(c).mm]};
            end
            REPORT.SAMP_in_MIX(3+d,3) = {UNK(c).Info}; %Added in 1.0.5
            REPORT.SAMP_in_MIX(3+d,4:3+A.ISOTOPE_num) = num2cell(UNK(c).samp_cps);
        end
    end
    
else
    REPORT.SAMP_in_MIX = cell(1,w);
end

%..........................................................................................
%ITEM 6b: SAMPLES:  MIX(cps)
if reportcfg.mixcps == 1

    d = 0; %count the number of unknowns with samples analysed
    for c= 1:A.UNK_num
        if UNK(c).sigtotal > 0
            d = d+1;
            e(c) = c;
        else
            e(c) = 0;
        end
        if UNK(c).MAT_corrtype ~= 1 && UNK(c).SIG_constraint2 ~= 1 %Added in 1.1.1
            f(c) = 0;
        else
            f(c) = 1;
        end
    end

    REPORT.mixcps = cell(3+d,w);
    REPORT.mixcps(1,1) = {'SAMPLES:  MIX signal (cps) Background corrected'};
    REPORT.mixcps(2,1) = {'File'};
    REPORT.mixcps(2,2) = {'Time'};
    REPORT.mixcps(2,3) = {'Info'}; %Added in 1.0.5
    REPORT.mixcps(2,4:3+A.ISOTOPE_num) = A.ISOTOPE_list;
    REPORT.mixcps(3,4:3+A.ISOTOPE_num) = {'cps'};

    d = 0;
    for c = 1:A.UNK_num
        if e(c) == 0 || f(c) == 0; %Added f(c) in 1.1.1
            continue
        else
            d = d+1;
            REPORT.mixcps(3+d,1) = A.UNKPOPUPLIST(c);

            if strcmp(A.timeformat,'integer_points')==1;
                REPORT.mixcps(3+d,2) = {UNK(c).timepoint};
            else
                REPORT.mixcps(3+d,2) = {[UNK(c).hh ':' UNK(c).mm]};
            end
            REPORT.mixcps(3+d,3) = {UNK(c).Info}; %Added in 1.0.5
            REPORT.mixcps(3+d,4:3+A.ISOTOPE_num) = num2cell(UNK(c).sig_cps - UNK(c).bg_cps);
        end
    end
    
else
    REPORT.mixcps = cell(1,w);
end

%..........................................................................
%ITEM 7: HOSTS: Composition Summary
d = 0; %count the number of unknowns with a host correction
for c= 1:A.UNK_num
    if UNK(c).MAT_corrtype ~= 1
        d = d+1;
        e(c) = c;
    else
        e(c) = 0;
    end
end

if d ~=0
    
    if reportcfg.hostconc == 1

        REPORT.HOST_compsummary = cell(3+d,w);
        REPORT.HOST_compsummary(1,1) = {'HOSTS: Composition Summary'};
        REPORT.HOST_compsummary(2,1) = {'File'};
        REPORT.HOST_compsummary(2,2) = {'Time'};
        REPORT.HOST_compsummary(2,3) = {'Info'}; %Added in 1.0.5

        if strcmp(A.report_settings_oxide,'off') == 1;

            REPORT.HOST_compsummary(2,4:3+A.ISOTOPE_num) = A.ISOTOPE_list;
            REPORT.HOST_compsummary(3,4:3+A.ISOTOPE_num) = {[char(181) 'g/g']};
            d = 0;
            for c = 1:A.UNK_num
                if e(c) == 0;
                    continue
                else
                    d = d+1;
                    REPORT.HOST_compsummary(3+d,1) = A.UNKPOPUPLIST(c);

                    if strcmp(A.timeformat,'integer_points')==1;
                        REPORT.HOST_compsummary(3+d,2) = {UNK(c).timepoint};
                    else
                        REPORT.HOST_compsummary(3+d,2) = {[UNK(c).hh ':' UNK(c).mm]};
                    end
                    REPORT.HOST_compsummary(3+d,3) = {UNK(c).Info}; %Added in 1.0.5

                    REPORT.HOST_compsummary(3+d,4:3+A.ISOTOPE_num) = num2cell(UNK(c).MAT_CONC);
                    %test for concentrations below detections; replace conc with '<LOD'
                    for i = 1:A.ISOTOPE_num;
                        if UNK(c).MAT_CONC(i) < UNK(c).MAT_LOD_mn(i)
                            REPORT.HOST_compsummary(3+d,3+i) = {[char(60) num2str(UNK(c).MAT_LOD_mn(i))]};
                        elseif strcmp(num2str(UNK(c).MAT_CONC(i)),'NaN')==1;
                            REPORT.HOST_compsummary(3+d,3+i) = {'--'};
                        end
                    end
                end
            end
        else

            REPORT.HOST_compsummary(2,4:3+A.Oxides_num) = A.Oxides_measured';
            REPORT.HOST_compsummary(3,4:3+A.Oxides_num) = {'wt.%'};
            REPORT.HOST_compsummary(2,4+A.Oxides_num:3+A.Oxides_num+A.Trace_num) = A.Trace_measured;
            REPORT.HOST_compsummary(3,4+A.Oxides_num:3+A.Oxides_num+A.Trace_num) = {[char(181) 'g/g']};

            d = 0;
            for c = 1:A.UNK_num
                if e(c) == 0;
                    continue
                else
                    d = d+1;

                    REPORT.HOST_compsummary(3+d,1) = A.UNKPOPUPLIST(c);

                    if strcmp(A.timeformat,'integer_points')==1;
                        REPORT.HOST_compsummary(3+d,2) = {UNK(c).timepoint};
                    else
                        REPORT.HOST_compsummary(3+d,2) = {[UNK(c).hh ':' UNK(c).mm]};
                    end
                    REPORT.HOST_compsummary(3+d,3) = {UNK(c).Info}; %Added in 1.0.5

                    if A.Oxide_test ~= 0
                        REPORT.HOST_compsummary(3+d,4:3+A.Oxides_num) = num2cell(UNK(c).MAT_CONC_majox);
                        REPORT.HOST_compsummary(3+d,4+A.Oxides_num:3+A.Oxides_num+A.Trace_num) = num2cell(UNK(c).MAT_CONC_trace);
                    end

                    %test for concentrations below detections; replace conc with '<LOD'
                    for i = 1:A.Oxides_num;
                        if UNK(c).MAT_CONC_majox(i) < UNK(c).MAT_LOD_mn_majox(i)
                            REPORT.HOST_compsummary(3+d,3+i) = {[char(60) num2str(UNK(c).MAT_LOD_mn_majox(i))]};
                        elseif strcmp(num2str(UNK(c).MAT_CONC_majox(i)),'NaN')==1;
                            REPORT.HOST_compsummary(3+d,3+i) = {'--'};
                        end
                    end
                    for i = 1:A.Trace_num;
                        if UNK(c).MAT_CONC_trace(i) < UNK(c).MAT_LOD_mn_trace(i)
                            REPORT.HOST_compsummary(3+d,3+A.Oxides_num+i) = {[char(60) num2str(UNK(c).MAT_LOD_mn_trace(i))]};
                        elseif strcmp(num2str(UNK(c).MAT_CONC_trace(i)),'NaN')==1;
                            REPORT.HOST_compsummary(3+d,3+A.Oxides_num+i) = {'--'};
                        end
                    end
                end
            end
        end
    else
        REPORT.HOST_compsummary = cell(1,w);
    end

    %..........................................................................
    %ITEM 8: HOSTS: Error Summary
    if reportcfg.hosterr == 1
        d = 0; %count the number of unknowns with a host correction
        for c= 1:A.UNK_num
            if UNK(c).MAT_corrtype ~= 1
                d = d+1;
                e(c) = c;
            else
                e(c) = 0;
            end
        end

        REPORT.HOST_errorsummary = cell(3+d,w);
        REPORT.HOST_errorsummary(1,1) = {'HOSTS: Error Summary (1 sigma)'};
        REPORT.HOST_errorsummary(2,1) = {'File'};
        REPORT.HOST_errorsummary(2,2) = {'Time'};
        REPORT.HOST_errorsummary(2,3) = {'Info'}; %Added in 1.0.5

        if strcmp(A.report_settings_oxide,'off') == 1;

            REPORT.HOST_errorsummary(2,4:3+A.ISOTOPE_num) = A.ISOTOPE_list;
            REPORT.HOST_errorsummary(3,4:3+A.ISOTOPE_num) = {[char(181) 'g/g']};
            d = 0;
            for c = 1:A.UNK_num
                if e(c) == 0;
                    continue
                else
                    d = d+1;
                    REPORT.HOST_errorsummary(3+d,1) = A.UNKPOPUPLIST(c);

                    if strcmp(A.timeformat,'integer_points')==1;
                        REPORT.HOST_errorsummary(3+d,2) = {UNK(c).timepoint};
                    else
                        REPORT.HOST_errorsummary(3+d,2) = {[UNK(c).hh ':' UNK(c).mm]};
                    end
                    REPORT.HOST_errorsummary(3+d,3) = {UNK(c).Info}; %Added in 1.0.5

                    REPORT.HOST_errorsummary(3+d,4:3+A.ISOTOPE_num) = num2cell(UNK(c).MAT_CONC_error);
                    %test for concentrations below detections; replace conc with '<LOD'
                    for i = 1:A.ISOTOPE_num;
                        if UNK(c).MAT_CONC(i) < UNK(c).MAT_LOD_mn(i)
                            REPORT.HOST_errorsummary(3+d,3+i) = {[char(60) num2str(UNK(c).MAT_LOD_mn(i))]};
                        elseif strcmp(num2str(UNK(c).MAT_CONC(i)),'NaN')==1;
                            REPORT.HOST_errorsummary(3+d,3+i) = {'--'};
                        end
                    end
                end
            end
        else

            REPORT.HOST_errorsummary(2,4:3+A.Oxides_num) = A.Oxides_measured';
            REPORT.HOST_errorsummary(3,4:3+A.Oxides_num) = {'wt.%'};
            REPORT.HOST_errorsummary(2,4+A.Oxides_num:3+A.Oxides_num+A.Trace_num) = A.Trace_measured;
            REPORT.HOST_errorsummary(3,4+A.Oxides_num:3+A.Oxides_num+A.Trace_num) = {[char(181) 'g/g']};

            d = 0;
            for c = 1:A.UNK_num
                if e(c) == 0;
                    continue
                else
                    d = d+1;
                    REPORT.HOST_errorsummary(3+d,1) = A.UNKPOPUPLIST(c);

                    if strcmp(A.timeformat,'integer_points')==1;
                        REPORT.HOST_errorsummary(3+d,2) = {UNK(c).timepoint};
                    else
                        REPORT.HOST_errorsummary(3+d,2) = {[UNK(c).hh ':' UNK(c).mm]};
                    end
                    REPORT.HOST_errorsummary(3+d,3) = {UNK(c).Info}; %Added in 1.0.5

                    if A.Oxide_test ~= 0
                        REPORT.HOST_errorsummary(3+d,4:3+A.Oxides_num) = num2cell(UNK(c).MAT_CONC_error_majox);
                        REPORT.HOST_errorsummary(3+d,4+A.Oxides_num:3+A.Oxides_num+A.Trace_num) = num2cell(UNK(c).MAT_CONC_error_trace);
                    end

                    %test for concentrations below detections; replace conc with '<LOD'
                    for i = 1:A.Oxides_num;
                        if UNK(c).MAT_CONC_majox(i) < UNK(c).MAT_LOD_mn_majox(i)
                            REPORT.HOST_errorsummary(3+d,3+i) = {[char(60) num2str(UNK(c).MAT_LOD_mn_majox(i))]};
                        elseif strcmp(num2str(UNK(c).MAT_CONC_error_majox(i)),'NaN')==1;
                            REPORT.HOST_errorsummary(3+d,3+i) = {'--'};
                        end
                    end
                    for i = 1:A.Trace_num;
                        if UNK(c).MAT_CONC_trace(i) < UNK(c).MAT_LOD_mn_trace(i)
                            REPORT.HOST_errorsummary(3+d,3+A.Oxides_num+i) = {[char(60) num2str(UNK(c).MAT_LOD_mn_trace(i))]};
                        elseif strcmp(num2str(UNK(c).MAT_CONC_error_trace(i)),'NaN')==1;
                            REPORT.HOST_errorsummary(3+d,3+A.Oxides_num+i) = {'--'};
                        end
                    end
                end
            end
        end
    else
        REPORT.HOST_errorsummary = cell(1,w);
    end

    %....................................................................
    %ITEM 9: HOSTS: LOD Summary
    if reportcfg.hostlod == 1
        d = 0; %count the number of unknowns with samples analysed
        for c= 1:A.UNK_num
            if UNK(c).MAT_corrtype ~= 1
                d = d+1;
                e(c) = c;
            else
                e(c) = 0;
            end
        end

        REPORT.HOST_LODsummary = cell(3+d,w);
        REPORT.HOST_LODsummary(1,1) = {'HOSTS: Limits of Detection Summary'};
        REPORT.HOST_LODsummary(1,5) = {['Method: ' A.LODmethod]};
        REPORT.HOST_LODsummary(2,1) = {'File'};
        REPORT.HOST_LODsummary(2,2) = {'Time'};
        REPORT.HOST_LODsummary(2,3) = {'Info'}; %Added in 1.0.5

        if strcmp(A.report_settings_oxide,'off') == 1;

            REPORT.HOST_LODsummary(2,4:3+A.ISOTOPE_num) = A.ISOTOPE_list;
            REPORT.HOST_LODsummary(3,4:3+A.ISOTOPE_num) = {[char(181) 'g/g']};
            d = 0;
            for c = 1:A.UNK_num
                if e(c) == 0;
                    continue
                else
                    d = d+1;
                    REPORT.HOST_LODsummary(3+d,1) = A.UNKPOPUPLIST(c);

                    if strcmp(A.timeformat,'integer_points')==1;
                        REPORT.HOST_LODsummary(3+d,2) = {UNK(c).timepoint};
                    else
                        REPORT.HOST_LODsummary(3+d,2) = {[UNK(c).hh ':' UNK(c).mm]};
                    end
                    REPORT.HOST_LODsummary(3+d,3) = {UNK(c).Info}; %Added in 1.0.5

                    REPORT.HOST_LODsummary(3+d,4:3+A.ISOTOPE_num) = num2cell(UNK(c).MAT_LOD_mn);
                    for i = 1:A.ISOTOPE_num;
                        if strcmp(num2str(UNK(c).MAT_LOD_mn(i)),'NaN')==1;
                            REPORT.HOST_LODsummary(3+d,3+i) = {'--'};
                        end
                    end
                end
            end
        else

            REPORT.HOST_LODsummary(2,4:3+A.Oxides_num) = A.Oxides_measured';
            REPORT.HOST_LODsummary(3,4:3+A.Oxides_num) = {'wt.%'};
            REPORT.HOST_LODsummary(2,4+A.Oxides_num:3+A.Oxides_num+A.Trace_num) = A.Trace_measured;
            REPORT.HOST_LODsummary(3,4+A.Oxides_num:3+A.Oxides_num+A.Trace_num) = {[char(181) 'g/g']};

            d = 0;
            for c = 1:A.UNK_num
                if e(c) == 0;
                    continue
                else
                    d = d+1;
                    REPORT.HOST_LODsummary(3+d,1) = A.UNKPOPUPLIST(c);

                    if strcmp(A.timeformat,'integer_points')==1;
                        REPORT.HOST_LODsummary(3+d,2) = {UNK(c).timepoint};
                    else
                        REPORT.HOST_LODsummary(3+d,2) = {[UNK(c).hh ':' UNK(c).mm]};
                    end
                    REPORT.HOST_LODsummary(3+d,3) = {UNK(c).Info}; %Added in 1.0.5

                    if A.Oxide_test ~= 0
                        REPORT.HOST_LODsummary(3+d,4:3+A.Oxides_num) = num2cell(UNK(c).MAT_LOD_mn_majox);
                        REPORT.HOST_LODsummary(3+d,4+A.Oxides_num:3+A.Oxides_num+A.Trace_num) = num2cell(UNK(c).MAT_LOD_mn_trace);
                    end

                    for i = 1:A.Oxides_num;
                        if strcmp(num2str(UNK(c).MAT_LOD_mn_majox(i)),'NaN')==1;
                            REPORT.HOST_LODsummary(3+d,3+i) = {'--'};
                        end
                    end
                    for i = 1:A.Trace_num;
                        if strcmp(num2str(UNK(c).MAT_LOD_mn_trace(i)),'NaN')==1;
                            REPORT.HOST_LODsummary(3+d,3+A.Oxides_num+i) = {'--'};
                        end
                    end
                end
            end
        end
    else
        REPORT.HOST_LODsummary = cell(1,w);
    end
    
    %..........................................................................
    %ITEM 10: HOSTS: cps signal
    %Added in 1.0.2
    if reportcfg.hostcps == 1
        d = 0; %count the number of unknowns with a host correction
        for c= 1:A.UNK_num
            if UNK(c).MAT_corrtype ~= 1
                d = d+1;
                e(c) = c;
            else
                e(c) = 0;
            end
        end
        
        REPORT.HOST_cps = cell(3+d,w);
        REPORT.HOST_cps(1,1) = {'HOSTS: cps Summary (Background corrected)'};
        REPORT.HOST_cps(2,1) = {'File'};
        REPORT.HOST_cps(2,2) = {'Time'};
        REPORT.HOST_cps(2,3) = {'Info'}; %Added in 1.0.5
        
        REPORT.HOST_cps(2,4:3+A.ISOTOPE_num) = A.ISOTOPE_list;
        REPORT.HOST_cps(3,4:3+A.ISOTOPE_num) = {'cps'};
        
        d = 0;
        for c= 1:A.UNK_num
            if e(c) == 0
                continue
            else
                d = d + 1;
                REPORT.HOST_cps(3+d,1) = A.UNKPOPUPLIST(c);

                if strcmp(A.timeformat,'integer_points')==1;
                    REPORT.HOST_cps(3+d,2) = {UNK(c).timepoint};
                else
                    REPORT.HOST_cps(3+d,2) = {[UNK(c).hh ':' UNK(c).mm]};
                end
                REPORT.HOST_cps(3+d,3) = {UNK(c).Info}; %Added in 1.0.5
                
                REPORT.HOST_cps(3+d,4:3+A.ISOTOPE_num) = num2cell(UNK(c).mat_cps - UNK(c).bg_cps);
            end
        end
    else
        REPORT.HOST_cps = cell(1,w);
    end


else

    REPORT.HOST_compsummary = cell(1,w);
    REPORT.HOST_errorsummary = cell(1,w);
    REPORT.HOST_LODsummary = cell(1,w);
    REPORT.HOST_cps = cell(1,w);

end

%..........................................................................
%ITEM 11: BACKGROUND (cps)
if reportcfg.bgcps == 1

    REPORT.BG = cell(3+A.STD_num+A.UNK_num,w);
    REPORT.BG(1,1) = {'BACKGROUND (cps)'};
    REPORT.BG(2,1) = {'File'};
    REPORT.BG(2,2) = {'Time'};
    REPORT.BG(2,3) = {'Type'};
    REPORT.BG(2,4:3+A.ISOTOPE_num) = A.ISOTOPE_list;
    REPORT.BG(3,4:3+A.ISOTOPE_num) = {'cps'};

    for c = 1:A.STD_num %Standards
        REPORT.BG(c+3,1) = A.STDPOPUPLIST(c);
        if strcmp(A.timeformat,'integer_points')==1;
            REPORT.BG(c+3,2) = {STD(c).timepoint};
        else
            REPORT.BG(c+3,2) = {[STD(c).hh ':' STD(c).mm]};
        end
        REPORT.BG(c+3,3) = {'STANDARD'};
        REPORT.BG(c+3,4:3+A.ISOTOPE_num) = num2cell(STD(c).bg_cps);
    end

    for c = 1:A.UNK_num %Unknowns
        REPORT.BG(c+3+A.STD_num,1) = A.UNKPOPUPLIST(c);
        if strcmp(A.timeformat,'integer_points')==1;
            REPORT.BG(c+3+A.STD_num,2) = {UNK(c).timepoint};
        else
            REPORT.BG(c+3+A.STD_num,2) = {[UNK(c).hh ':' UNK(c).mm]};
        end
        REPORT.BG(c+3+A.STD_num,3) = {'UNKNOWN'};
        REPORT.BG(c+3+A.STD_num,4:3+A.ISOTOPE_num) = num2cell(UNK(c).bg_cps);
    end
else
    REPORT.BG = cell(1,w);
end

%..........................................................................
%ITEM 11b: BACKGROUND stdev(cps)
if reportcfg.bgstdev == 1

    REPORT.BGstdev = cell(3+A.STD_num+A.UNK_num,w);
    REPORT.BGstdev(1,1) = {'BG stdev (cps)'};
    REPORT.BGstdev(2,1) = {'File'};
    REPORT.BGstdev(2,2) = {'Time'};
    REPORT.BGstdev(2,3) = {'Type'};
    REPORT.BGstdev(2,4:3+A.ISOTOPE_num) = A.ISOTOPE_list;
    REPORT.BGstdev(3,4:3+A.ISOTOPE_num) = {'cps?'};

    for c = 1:A.STD_num %Standards
        REPORT.BGstdev(c+3,1) = A.STDPOPUPLIST(c);
        if strcmp(A.timeformat,'integer_points')==1;
            REPORT.BGstdev(c+3,2) = {STD(c).timepoint};
        else
            REPORT.BGstdev(c+3,2) = {[STD(c).hh ':' STD(c).mm]};
        end
        REPORT.BGstdev(c+3,3) = {'STANDARD'};
        REPORT.BGstdev(c+3,4:3+A.ISOTOPE_num) = num2cell(STD(c).BG_stdev);
    end

    for c = 1:A.UNK_num %Unknowns
        REPORT.BGstdev(c+3+A.STD_num,1) = A.UNKPOPUPLIST(c);
        if strcmp(A.timeformat,'integer_points')==1;
            REPORT.BGstdev(c+3+A.STD_num,2) = {UNK(c).timepoint};
        else
            REPORT.BGstdev(c+3+A.STD_num,2) = {[UNK(c).hh ':' UNK(c).mm]};
        end
        REPORT.BGstdev(c+3+A.STD_num,3) = {'UNKNOWN'};
        REPORT.BGstdev(c+3+A.STD_num,4:3+A.ISOTOPE_num) = num2cell(UNK(c).BG_stdev);
    end
else
    REPORT.BGstdev = cell(1,w);
end
%..........................................................................
%ITEM 12: STANDARDS (cps)
%Added in 1.0.2
if reportcfg.stdcps == 1
    REPORT.STD_cps = cell(3+A.STD_num,w);
    REPORT.STD_cps (1,1) = {'STANDARDS (cps; Background corrected)'};
    REPORT.STD_cps (2,1) = {'File'};
    REPORT.STD_cps (2,2) = {'Time'};

    REPORT.STD_cps(2,4:3+A.ISOTOPE_num) = A.ISOTOPE_list;
    REPORT.STD_cps(3,4:3+A.ISOTOPE_num) = {'cps'};
    
    for c = 1:A.STD_num
        REPORT.STD_cps(c+3,1) = A.STDPOPUPLIST(c);
        
        if strcmp(A.timeformat,'integer_points')==1;
            REPORT.STD_cps(c+3,2) = {STD(c).timepoint};
        else
            REPORT.STD_cps(c+3,2) = {[STD(c).hh ':' STD(c).mm]};
        end
        
        REPORT.STD_cps(c+3,4:3+A.ISOTOPE_num) = num2cell(STD(c).sig_cps - STD(c).bg_cps);
    end
else
    REPORT.STD_cps = cell(1,w);
end

%..........................................................................
%ITEM 13: RATIOS (cps/cps) and Standard Errors
%Added in 1.0.3
if reportcfg.ratios == 1
    %Integrated ratios
    INTEGRATED = cell(3+A.STD_num+A.UNK_num,w);
    INTEGRATED(1,1) = {'RATIOS (cps/cps)'};
    INTEGRATED(2,1) = {'File'};
    INTEGRATED(2,2) = {'Time'};
    INTEGRATED(2,3) = {'Type'};
    INTEGRATED(2,4:3+A.ratios.num) = A.ratios.names;
    INTEGRATED(3,4:3+A.ratios.num) = {'cps/cps'};
    
    for c = 1:A.STD_num
        INTEGRATED(c+3,1) = A.STDPOPUPLIST(c);
        INTEGRATED(c+3,3) = {'STANDARD'};
        
        if strcmp(A.timeformat,'integer_points')==1;
            INTEGRATED(c+3,2) = {STD(c).timepoint};
        else
            INTEGRATED(c+3,2) = {[STD(c).hh ':' STD(c).mm]};
        end
        
        INTEGRATED(c+3,4:3+A.ratios.num) = num2cell(STD(c).ratioint);
    end
    
    for c = 1:A.UNK_num
        INTEGRATED(c+3+A.STD_num,1) = A.UNKPOPUPLIST(c);
        INTEGRATED(c+3+A.STD_num,3) = {'UNKNOWN'};
        
        if strcmp(A.timeformat,'integer_points')==1;
            INTEGRATED(c+3+A.STD_num,2) = {UNK(c).timepoint};
        else
            INTEGRATED(c+3+A.STD_num,2) = {[UNK(c).hh ':' UNK(c).mm]};
        end
        
        if UNK(c).sigtotal ~= 0
            INTEGRATED(c+3+A.STD_num,4:3+A.ratios.num) = num2cell(UNK(c).ratioint);
        else
            INTEGRATED(c+3+A.STD_num,4) = {'NO SIGNAL WINDOW'};
        end
    end
    
    %Ratio standard errors
    ERRORS = cell(3+A.STD_num+A.UNK_num,w);
    ERRORS(1,1) = {'RATIO STANDARD ERRORS (cps/cps)'};
    ERRORS(2,1) = {'File'};
    ERRORS(2,2) = {'Time'};
    ERRORS(2,3) = {'Type'};
    ERRORS(2,4:3+A.ratios.num) = A.ratios.names;
    ERRORS(3,4:3+A.ratios.num) = {'cps/cps'};
    
    for c = 1:A.STD_num
        ERRORS(c+3,1) = A.STDPOPUPLIST(c);
        ERRORS(c+3,3) = {'STANDARD'};
        
        if strcmp(A.timeformat,'integer_points')==1;
            ERRORS(c+3,2) = {STD(c).timepoint};
        else
            ERRORS(c+3,2) = {[STD(c).hh ':' STD(c).mm]};
        end
        
        ERRORS(c+3,4:3+A.ratios.num) = num2cell(STD(c).ratioerr);
    end
    
    for c = 1:A.UNK_num
        ERRORS(c+3+A.STD_num,1) = A.UNKPOPUPLIST(c);
        ERRORS(c+3+A.STD_num,3) = {'UNKNOWN'};
        
        if strcmp(A.timeformat,'integer_points')==1;
            ERRORS(c+3+A.STD_num,2) = {UNK(c).timepoint};
        else
            ERRORS(c+3+A.STD_num,2) = {[UNK(c).hh ':' UNK(c).mm]};
        end
        
        if UNK(c).sigtotal ~= 0
            ERRORS(c+3+A.STD_num,4:3+A.ratios.num) = num2cell(UNK(c).ratioerr);
        else
            ERRORS(c+3+A.STD_num,4) = {'NO SIGNAL WINDOW'};
        end
    end
    
    REPORT.RATIOS = vertcat(INTEGRATED,gap,ERRORS);
    clear INTEGRATED ERRORS    
else
    REPORT.RATIOS = cell(1,w);
end      

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ITEM 14 onward: Individual Analysis Tables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if reportcfg.individual == 1

REPORT.UNKNOWN = struct('table',[]);

for c = 1:A.UNK_num

    %count the number of integration intervals to display
    d = 1;

    if UNK(c).MAT_corrtype ~=1 && ~isempty(UNK(c).mat1window)
        d = d+1;
    end
    if UNK(c).MAT_corrtype ~=1 && ~isempty(UNK(c).mat2window)
        d = d+1;
    end
    if UNK(c).sigtotal > 0 && ~isempty(UNK(c).comp1window)
        d = d+1;
    end
    if UNK(c).sigtotal > 0 && ~isempty(UNK(c).comp2window)
        d = d+1;
    end
    if UNK(c).sigtotal > 0 && ~isempty(UNK(c).comp3window)
        d = d+1;
    end

    if UNK(c).MAT_corrtype ~=1 && UNK(c).sigtotal > 0
        t = 1;  %number of lines required to define the time
        m = 1;  %number of lines required to define the matrix quantification procedure
        s = 2;  %number of lines required to define the sample quantification procedure
        x = 1;  %number of lines required to define the mass fraction
    elseif UNK(c).MAT_corrtype ~=1 && UNK(c).sigtotal == 0
        t = 1;
        m = 1;
        s = 0;
        x = 0;
    elseif UNK(c).MAT_corrtype == 1 && UNK(c).sigtotal > 0
        t = 1;
        m = 0;
        s = 1;
        x = 0;
    elseif UNK(c).MAT_corrtype == 1 && UNK(c).sigtotal == 0
        t = 1;
        m = 0;
        s = 0;
        x = 0;
    end

    REPORT.UNKNOWN(c).table = cell(5+t+m+s+x+d+A.ISOTOPE_num,w);
    REPORT.UNKNOWN(c).table(1,1) = {[num2str(c) ': ' UNK(c).fileinfo.name]};
    REPORT.UNKNOWN(c).table(2,1) = {UNK(c).Info};

    if strcmp(A.timeformat,'integer_points')==1;
        REPORT.UNKNOWN(c).table(2+t,1) = {'Time:'};
        REPORT.UNKNOWN(c).table(2+t,2) = {[UNK(c).timepoint]};
    else
        REPORT.UNKNOWN(c).table(2+t,1) = {'Time:'};
        REPORT.UNKNOWN(c).table(2+t,2) = {[UNK(c).hh ':' UNK(c).mm]};
    end

    if m == 1;
        REPORT.UNKNOWN(c).table(2+t+m,1) = {'Host Quantification:'};
        if UNK(c).MAT_corrtype == 1
            REPORT.UNKNOWN(c).table(2+t+m,2) = {'none'};
        elseif UNK(c).MAT_corrtype == 2
            REPORT.UNKNOWN(c).table(2+t+m,2) = {[char(A.ISOTOPE_list(UNK(c).MATQIS)) ' internal standard = ' num2str(UNK(c).MATQIS_conc) char(181) 'g/g']}; %Changed in 1.0.5
        elseif UNK(c).MAT_corrtype == 3
            REPORT.UNKNOWN(c).table(2+t+m,2) = {['total oxides (major elements) = ' num2str(UNK(c).MAT_oxide_total) '%']};
        end
    end

    if s > 0
        REPORT.UNKNOWN(c).table(2+t+m+1,1) = {'Signal Quantification:'};
        if UNK(c).SIG_constraint1 == 1
            REPORT.UNKNOWN(c).table(2+t+m+1,2) = {[char(A.ISOTOPE_list(UNK(c).SIGQIS1)) ' internal standard = ' num2str(UNK(c).SIGQIS1_conc) char(181) 'g/g']};
        elseif UNK(c).SIG_constraint1 == 2
            REPORT.UNKNOWN(c).table(2+t+m+1,2) = {['eq. wt% NaCl = ' num2str(UNK(c).SIGsalinity) ' = [NaCl] + ' num2str(UNK(c).SALT_mass_balance_factor) '*sum[XCl] (mass balance)']};
        elseif UNK(c).SIG_constraint1 == 3
            REPORT.UNKNOWN(c).table(2+t+m+1,2) = {['eq. wt% NaCl = ' num2str(UNK(c).SIGsalinity) ' (by charge balance)']};
        elseif UNK(c).SIG_constraint1 == 4
            REPORT.UNKNOWN(c).table(2+t+m+1,2) = {['total oxides (major elements) = ' num2str(UNK(c).SIG_oxide_total) '%']};
        end
    end

    if s == 2
        REPORT.UNKNOWN(c).table(2+t+m+2,1) = {'Signal Quantification:'};
        if UNK(c).SIG_constraint2 == 1;
            REPORT.UNKNOWN(c).table(2+t+m+2,2) = {[char(A.ISOTOPE_list(UNK(c).SIG_tracer)) ' matrix-only tracer']};
        elseif UNK(c).SIG_constraint2 == 2;
            REPORT.UNKNOWN(c).table(2+t+m+2,2) = {[char(A.ISOTOPE_list(UNK(c).SIGQIS2)) ' internal standard = ' num2str(UNK(c).SIGQIS2_conc) char(181) 'g/g']};
        end
    end

    if x == 1; %i.e. a matrix correction
        REPORT.UNKNOWN(c).table(3+t+m+s,1) = {['mass fraction of sample in mixed signal = ' num2str(UNK(c).x) ' ' char(177) ' ' num2str(UNK(c).sigma_x)]};
    end

    d = 1;
    REPORT.UNKNOWN(c).table(3+t+m+s+x+d,1) = {'Background:'};
    REPORT.UNKNOWN(c).table(3+t+m+s+x+d,2) = {num2str(UNK(c).bgwindow(1))};
    REPORT.UNKNOWN(c).table(3+t+m+s+x+d,3) = {num2str(UNK(c).bgwindow(2))};
    if m > 0
        REPORT.UNKNOWN(c).table(4+t+m+s+x+d,1) = {'Host:'};
        if ~isempty(UNK(c).mat1window) && isempty(UNK(c).mat2window)
            REPORT.UNKNOWN(c).table(4+t+m+s+x+d,2) = {num2str(UNK(c).mat1window(1))};
            REPORT.UNKNOWN(c).table(4+t+m+s+x+d,3) = {num2str(UNK(c).mat1window(2))};
            d = d+1;
        elseif isempty(UNK(c).mat2window)&& ~isempty(UNK(c).mat2window)
            REPORT.UNKNOWN(c).table(4+t+m+s+x+d,2) = {num2str(UNK(c).mat2window(1))};
            REPORT.UNKNOWN(c).table(4+t+m+s+x+d,3) = {num2str(UNK(c).mat2window(2))};
            d = d+1;
        elseif ~isempty(UNK(c).mat1window) && ~isempty(UNK(c).mat2window)
            REPORT.UNKNOWN(c).table(4+t+m+s+x+d,2) = {num2str(UNK(c).mat1window(1))};
            REPORT.UNKNOWN(c).table(4+t+m+s+x+d,3) = {num2str(UNK(c).mat1window(2))};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,2) = {num2str(UNK(c).mat2window(1))};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,3) = {num2str(UNK(c).mat2window(2))};
            d = d+2;
        end
    end
    if s > 0
        REPORT.UNKNOWN(c).table(4+t+m+s+x+d,1) = {'Sample:'};
        if ~isempty(UNK(c).comp1window) && isempty(UNK(c).comp2window) && isempty(UNK(c).comp3window)
            REPORT.UNKNOWN(c).table(4+t+m+s+x+d,2) = {num2str(UNK(c).comp1window(1))};
            REPORT.UNKNOWN(c).table(4+t+m+s+x+d,3) = {num2str(UNK(c).comp1window(2))};
            d = d+1;
        elseif isempty(UNK(c).comp1window) && ~isempty(UNK(c).comp2window) && isempty(UNK(c).comp3window)
            REPORT.UNKNOWN(c).table(4+t+m+s+x+d,2) = {num2str(UNK(c).comp2window(1))};
            REPORT.UNKNOWN(c).table(4+t+m+s+x+d,3) = {num2str(UNK(c).comp2window(2))};
            d = d+1;
        elseif isempty(UNK(c).comp1window) && isempty(UNK(c).comp2window) && ~isempty(UNK(c).comp3window)
            REPORT.UNKNOWN(c).table(4+t+m+s+x+d,2) = {num2str(UNK(c).comp3window(1))};
            REPORT.UNKNOWN(c).table(4+t+m+s+x+d,3) = {num2str(UNK(c).comp3window(2))};
            d = d+1;
        elseif ~isempty(UNK(c).comp1window) && ~isempty(UNK(c).comp2window) && isempty(UNK(c).comp3window)
            REPORT.UNKNOWN(c).table(4+t+m+s+x+d,2) = {num2str(UNK(c).comp1window(1))};
            REPORT.UNKNOWN(c).table(4+t+m+s+x+d,3) = {num2str(UNK(c).comp1window(2))};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,2) = {num2str(UNK(c).comp2window(1))};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,3) = {num2str(UNK(c).comp2window(2))};
            d = d+2;
        elseif isempty(UNK(c).comp1window) && ~isempty(UNK(c).comp2window) && ~isempty(UNK(c).comp3window)
            REPORT.UNKNOWN(c).table(4+t+m+s+x+d,2) = {num2str(UNK(c).comp2window(1))};
            REPORT.UNKNOWN(c).table(4+t+m+s+x+d,3) = {num2str(UNK(c).comp2window(2))};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,2) = {num2str(UNK(c).comp3window(1))};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,3) = {num2str(UNK(c).comp3window(2))};
            d = d+2;
        elseif ~isempty(UNK(c).comp1window) && ~isempty(UNK(c).comp2window) && ~isempty(UNK(c).comp3window)
            REPORT.UNKNOWN(c).table(4+t+m+s+x+d,2) = {num2str(UNK(c).comp1window(1))};
            REPORT.UNKNOWN(c).table(4+t+m+s+x+d,3) = {num2str(UNK(c).comp1window(2))};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,2) = {num2str(UNK(c).comp2window(1))};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,3) = {num2str(UNK(c).comp2window(2))};
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d,2) = {num2str(UNK(c).comp3window(1))};
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d,3) = {num2str(UNK(c).comp3window(2))};
            d = d+3;
        end
    end

    if strcmp(A.report_settings_oxide,'off')==1

        if sum(matrix_correction_test) ~= 0; %i.e. at least some unknowns have hosts
            REPORT.UNKNOWN(c).table(5+t+m+x+s+d,1) = {'Analyte'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,2) = {'Dwell Time(s)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,3) = {'Cycle Time(s)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,4) = {'Rel. Sensitivity'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,5) = {'BG(s)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,6) = {'BG(cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,7) = {'sigma BG(cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,8) = {'Host(s)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,9) = {'Host(cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,10) = {'Host-BG(cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,11) = {'Host-BG(cps/cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,12) = {'Host(conc/conc)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,13) = {['Host(' char(181) 'g/g)']};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,14) = {'error'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,15) = {['LOD(' char(181) 'g/g)']};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,16) = {'Sample(s)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,17) = {'MIX(cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,18) = {'Host in MIX(cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,19) = {'Sample in MIX(cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,20) = {'Sample in MIX(cps/cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,21) = {'Sample(conc/conc)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,22) = {['Sample(' char(181) 'g/g)']};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,23) = {'error'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,24) = {['LOD(' char(181) 'g/g)']};

            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,1) = A.ISOTOPE_list';
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,2) = num2cell(A.DT_VALUES);
            %define the cycle time:
            AT = UNK(c).data(end,1)-UNK(c).data(end-1,1);
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,3) = num2cell(AT);
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,4) = num2cell(UNK(c).REPORTIS_CALIB');
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,5) = num2cell(UNK(c).bgwindow(2)-UNK(c).bgwindow(1));
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,6) = num2cell(UNK(c).bg_cps');
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,7) = num2cell(UNK(c).BG_stdev');

            if UNK(c).MAT_corrtype ~= 1 %i.e. there is a matrix correction
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,8) = num2cell(UNK(c).mattotal);
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,9) = num2cell(UNK(c).mat_cps');
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,10) = num2cell(UNK(c).mat_cps'-UNK(c).bg_cps');
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,11) = num2cell((UNK(c).mat_cps'-UNK(c).bg_cps')./(UNK(c).mat_cps(A.REPORTIS)-UNK(c).bg_cps(A.REPORTIS)));
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,12) = num2cell(UNK(c).MAT_CONC'./UNK(c).MAT_CONC(A.REPORTIS));
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,13) = num2cell(UNK(c).MAT_CONC');
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,14) = num2cell(UNK(c).MAT_CONC_error');
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,15) = num2cell(UNK(c).MAT_LOD_mn');
            end

            if ~isempty(UNK(c).data_cps_sig) %i.e. there is a sample signal
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,16) = num2cell(UNK(c).sigtotal);
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,17) = num2cell(UNK(c).sig_cps');
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,18) = num2cell(UNK(c).sig_cps'-UNK(c).bg_cps'-UNK(c).samp_cps');
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,19) = num2cell(UNK(c).samp_cps');
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,20) = num2cell(UNK(c).samp_cps'./UNK(c).samp_cps(A.REPORTIS));
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,21) = num2cell(UNK(c).SAMP_CONC'./UNK(c).SAMP_CONC(A.REPORTIS));
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,22) = num2cell(UNK(c).SAMP_CONC');
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,23) = num2cell(UNK(c).SAMP_CONC_error');
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,24) = num2cell(UNK(c).SAMP_LOD_mn');
            end

        elseif sum(matrix_correction_test) == 0 && s > 0; %i.e. no hosts but there is a sample

            REPORT.UNKNOWN(c).table(5+t+m+x+s+d,1) = {'Analyte'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,2) = {'Dwell Time(s)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,3) = {'Cycle Time(s)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,4) = {'Rel. Sensitivity'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,5) = {'BG(s)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,6) = {'BG(cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,7) = {'sigma BG(cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,8) = {'Sample(s)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,9) = {'MIX(cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,10) = {'Host in MIX(cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,11) = {'Sample in MIX(cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,12) = {'Sample in MIX(cps/cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,13) = {'Sample(conc/conc)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,14) = {['Sample(' char(181) 'g/g)']};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,15) = {'error'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,16) = {['LOD(' char(181) 'g/g)']};

            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,1) = A.ISOTOPE_list';
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,2) = num2cell(A.DT_VALUES);
            %define the cycle time:
            AT = UNK(c).data(end,1)-UNK(c).data(end-1,1);
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,3) = num2cell(AT);
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,4) = num2cell(UNK(c).REPORTIS_CALIB');
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,5) = num2cell(UNK(c).bgwindow(2)-UNK(c).bgwindow(1));
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,6) = num2cell(UNK(c).bg_cps');
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,7) = num2cell(UNK(c).BG_stdev');
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,8) = num2cell(UNK(c).sigtotal);
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,9) = num2cell(UNK(c).sig_cps');
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,10) = num2cell(UNK(c).sig_cps'-UNK(c).bg_cps'-UNK(c).samp_cps');
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,11) = num2cell(UNK(c).samp_cps');
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,12) = num2cell(UNK(c).samp_cps'./UNK(c).samp_cps(A.REPORTIS));
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,13) = num2cell(UNK(c).SAMP_CONC'./UNK(c).SAMP_CONC(A.REPORTIS));
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,14) = num2cell(UNK(c).SAMP_CONC');
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,15) = num2cell(UNK(c).SAMP_CONC_error');
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,16) = num2cell(UNK(c).SAMP_LOD_mn');
        end

    elseif strcmp(A.report_settings_oxide,'on')==1

        if sum(matrix_correction_test) ~= 0; %i.e. at least some unknowns have hosts

            %..............................................................
            % oxide table
            REPORT.UNKNOWN(c).table(5+t+m+x+s+d,1) = {'Analyte'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,2) = {'Dwell Time(s)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,3) = {'Cycle Time(s)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,4) = {'Rel. Sensitivity'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,5) = {'BG(s)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,6) = {'BG(cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,7) = {'sigma BG(cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,8) = {'Host(s)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,9) = {'Host(cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,10) = {'Host-BG(cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,11) = {'Host-BG(cps/cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,12) = {'Host(wt.%/wt.%)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,13) = {'Host(wt.%)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,14) = {'error'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,15) = {'LOD(wt.%)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,16) = {'Sample(s)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,17) = {'MIX(cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,18) = {'Host in MIX(cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,19) = {'Sample in MIX(cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,20) = {'Sample in MIX(cps/cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,21) = {'Sample(wt.%/wt.%)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,22) = {'Sample(wt.%)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,23) = {'error'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,24) = {'LOD(wt.%)'};

            if A.Oxide_test ~= 0
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,1) = A.Oxides_measured;
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,2) = num2cell(A.DT_VALUES(A.Oxides_index_condensed));
            end
            
            %define the cycle time:
            AT = UNK(c).data(end,1)-UNK(c).data(end-1,1);
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,3) = num2cell(AT);
            
            if A.Oxide_test ~= 0
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,4) = num2cell(UNK(c).REPORTIS_CALIB(A.Oxides_index_condensed)');
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,5) = num2cell(UNK(c).bgwindow(2)-UNK(c).bgwindow(1));
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,6) = num2cell(UNK(c).bg_cps(A.Oxides_index_condensed)');
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,7) = num2cell(UNK(c).BG_stdev(A.Oxides_index_condensed)');
            end
            
            %..............................................................
            if UNK(c).MAT_corrtype ~= 1 %i.e. there is a matrix correction

                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,8) = num2cell(UNK(c).mattotal);
                
                if A.Oxide_test ~= 0
                    REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,9) = num2cell(UNK(c).mat_cps(A.Oxides_index_condensed)');
                    REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,10) = num2cell(UNK(c).mat_cps(A.Oxides_index_condensed)'-UNK(c).bg_cps(A.Oxides_index_condensed)');
                    REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,11) = num2cell((UNK(c).mat_cps(A.Oxides_index_condensed)'-UNK(c).bg_cps(A.Oxides_index_condensed)')./(UNK(c).mat_cps(A.REPORTIS)-UNK(c).bg_cps(A.REPORTIS)));
                    seek_reportis = find(A.Oxides_index_condensed==A.REPORTIS);
                    if ~isempty(seek_reportis)
                        REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,12) = num2cell(UNK(c).MAT_CONC_majox'./UNK(c).MAT_CONC_majox(seek_reportis));
                        REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,13) = num2cell(UNK(c).MAT_CONC_majox');
                        REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,14) = num2cell(UNK(c).MAT_CONC_error_majox');
                        REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,15) = num2cell(UNK(c).MAT_LOD_mn_majox');
                    else
                        REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,13) = num2cell(UNK(c).MAT_CONC_majox');
                        REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,14) = num2cell(UNK(c).MAT_CONC_error_majox');
                        REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,15) = num2cell(UNK(c).MAT_LOD_mn_majox');
                    end
                end
            end
                    
            
            %..............................................................
            if ~isempty(UNK(c).data_cps_sig) %i.e. there is a sample signal
                
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,16) = num2cell(UNK(c).sigtotal);
                
                if A.Oxide_test ~= 0
                    REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,17) = num2cell(UNK(c).sig_cps(A.Oxides_index_condensed)');
                    REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,18) = num2cell(UNK(c).sig_cps(A.Oxides_index_condensed)'-UNK(c).bg_cps(A.Oxides_index_condensed)'-UNK(c).samp_cps(A.Oxides_index_condensed)');
                    REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,19) = num2cell(UNK(c).samp_cps(A.Oxides_index_condensed)');
                    REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,20) = num2cell(UNK(c).samp_cps(A.Oxides_index_condensed)'./UNK(c).samp_cps(A.REPORTIS));

                    seek_reportis = find(A.Oxides_index_condensed==A.REPORTIS);
                    if ~isempty(seek_reportis)
                        REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,21) = num2cell(UNK(c).SAMP_CONC_majox'./UNK(c).SAMP_CONC_majox(seek_reportis));
                        REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,22) = num2cell(UNK(c).SAMP_CONC_majox');
                        REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,23) = num2cell(UNK(c).SAMP_CONC_error_majox');
                        REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,24) = num2cell(UNK(c).SAMP_LOD_mn_majox');
                    else
                        REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,22) = num2cell(UNK(c).SAMP_CONC_majox');
                        REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,23) = num2cell(UNK(c).SAMP_CONC_error_majox');
                        REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,24) = num2cell(UNK(c).SAMP_LOD_mn_majox');
                    end
                end
            end                
                              
            %..............................................................
            % trace table
           
                REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,1) = {'Analyte'};
                REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,2) = {'Dwell Time(s)'};
                REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,3) = {'Cycle Time(s)'};
                REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,4) = {'Rel. Sensitivity'};
                REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,5) = {'BG(s)'};
                REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,6) = {'BG(cps)'};
                REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,7) = {'sigma BG(cps)'};
                REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,8) = {'Host(s)'};
                REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,9) = {'Host(cps)'};
                REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,10) = {'Host-BG(cps)'};
                REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,11) = {'Host-BG(cps/cps)'};
                REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,12) = {'Host(conc/conc)'};
                REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,13) = {['Host(' char(181) 'g/g)']};
                REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,14) = {'error'};
                REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,15) = {['LOD(' char(181) 'g/g)']};
                REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,16) = {'Sample(s)'};
                REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,17) = {'MIX(cps)'};
                REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,18) = {'Host in MIX(cps)'};
                REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,19) = {'Sample in MIX(cps)'};
                REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,20) = {'Sample in MIX(cps/cps)'};
                REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,21) = {'Sample(conc/conc)'};
                REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,22) = {['Sample(' char(181) 'g/g)']};
                REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,23) = {'error'};
                REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,24) = {['LOD(' char(181) 'g/g)']};

                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,1) = A.Trace_measured;
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,2) = num2cell(A.DT_VALUES(A.Trace_index));
                %define the cycle time:
                AT = UNK(c).data(end,1)-UNK(c).data(end-1,1);
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,3) = num2cell(AT);
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,4) = num2cell(UNK(c).REPORTIS_CALIB(A.Trace_index)');
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,5) = num2cell(UNK(c).bgwindow(2)-UNK(c).bgwindow(1));
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,6) = num2cell(UNK(c).bg_cps(A.Trace_index)');
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,7) = num2cell(UNK(c).BG_stdev(A.Trace_index)');

            %..............................................................
            if UNK(c).MAT_corrtype ~= 1 %i.e. there is a matrix correction

                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,8) = num2cell(UNK(c).mattotal);
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,9) = num2cell(UNK(c).mat_cps(A.Trace_index)');
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,10) = num2cell(UNK(c).mat_cps(A.Trace_index)'-UNK(c).bg_cps(A.Trace_index)');
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,11) = num2cell((UNK(c).mat_cps(A.Trace_index)'-UNK(c).bg_cps(A.Trace_index)')./(UNK(c).mat_cps(A.REPORTIS)-UNK(c).bg_cps(A.REPORTIS)));
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,12) = num2cell(UNK(c).MAT_CONC_trace'./UNK(c).MAT_CONC(A.REPORTIS));
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,13) = num2cell(UNK(c).MAT_CONC_trace');
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,14) = num2cell(UNK(c).MAT_CONC_error_trace');
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,15) = num2cell(UNK(c).MAT_LOD_mn_trace');
            end

            %..............................................................
            if ~isempty(UNK(c).data_cps_sig) %i.e. there is a sample signal
            
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,16) = num2cell(UNK(c).sigtotal);
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,17) = num2cell(UNK(c).sig_cps(A.Trace_index)');
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,18) = num2cell(UNK(c).sig_cps(A.Trace_index)'-UNK(c).bg_cps(A.Trace_index)'-UNK(c).samp_cps(A.Trace_index)');
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,19) = num2cell(UNK(c).samp_cps(A.Trace_index)');
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,20) = num2cell(UNK(c).samp_cps(A.Trace_index)'./UNK(c).samp_cps(A.REPORTIS));
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,21) = num2cell(UNK(c).SAMP_CONC_trace'./UNK(c).SAMP_CONC(A.REPORTIS));
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,22) = num2cell(UNK(c).SAMP_CONC_trace');
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,23) = num2cell(UNK(c).SAMP_CONC_error_trace');
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,24) = num2cell(UNK(c).SAMP_LOD_mn_trace');
            end

        elseif sum(matrix_correction_test) == 0 && s > 0; %i.e. no hosts but there is a sample

            %..............................................................
            % oxide table
            REPORT.UNKNOWN(c).table(5+t+m+x+s+d,1) = {'Analyte'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,2) = {'Dwell Time(s)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,3) = {'Cycle Time(s)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,4) = {'Rel. Sensitivity'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,5) = {'BG(s)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,6) = {'BG(cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,7) = {'sigma BG(cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,8) = {'Sample(s)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,9) = {'MIX(cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,10) = {'Host in MIX(cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,11) = {'Sample in MIX(cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,12) = {'Sample in MIX(cps/cps)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,13) = {'Sample(wt.%/wt.%)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,14) = {'Sample(wt.%)'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,15) = {'error'};
            REPORT.UNKNOWN(c).table(5+t+m+s+x+d,16) = {'LOD(wt.%)'};

            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,1) = A.Oxides_measured;
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,2) = num2cell(A.DT_VALUES(A.Oxides_index_condensed));
            %define the cycle time:
            AT = UNK(c).data(end,1)-UNK(c).data(end-1,1);
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:end,3) = num2cell(AT);
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,4) = num2cell(UNK(c).REPORTIS_CALIB(A.Oxides_index_condensed)');
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,5) = num2cell(UNK(c).bgwindow(2)-UNK(c).bgwindow(1));
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,6) = num2cell(UNK(c).bg_cps(A.Oxides_index_condensed)');
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,7) = num2cell(UNK(c).BG_stdev(A.Oxides_index_condensed)');

            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,8) = num2cell(UNK(c).sigtotal);
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,9) = num2cell(UNK(c).sig_cps(A.Oxides_index_condensed)');
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,10) = num2cell(UNK(c).sig_cps(A.Oxides_index_condensed)'-UNK(c).bg_cps(A.Oxides_index_condensed)'-UNK(c).samp_cps(A.Oxides_index_condensed)');
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,11) = num2cell(UNK(c).samp_cps(A.Oxides_index_condensed)');
            REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,12) = num2cell(UNK(c).samp_cps(A.Oxides_index_condensed)'./UNK(c).samp_cps(A.REPORTIS));

            seek_reportis = find(A.Oxides_index_condensed==A.REPORTIS);
            if ~isempty(seek_reportis)
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,13) = num2cell(UNK(c).SAMP_CONC_majox'./UNK(c).SAMP_CONC_majox(seek_reportis));
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,14) = num2cell(UNK(c).SAMP_CONC_majox');
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,15) = num2cell(UNK(c).SAMP_CONC_error_majox');
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,16) = num2cell(UNK(c).SAMP_LOD_mn_majox');
            else
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,13) = [];
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,14) = [];
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,15) = [];
                REPORT.UNKNOWN(c).table(6+t+m+s+x+d:5+t+m+s+x+d+A.Oxides_num,16) = [];
            end

            %..............................................................
            % trace table
            
            REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,1) = {'Analyte'};
            REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,2) = {'Dwell Time(s)'};
            REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,3) = {'Cycle Time(s)'};
            REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,4) = {'Rel. Sensitivity'};
            REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,5) = {'BG(s)'};
            REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,6) = {'BG(cps)'};
            REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,7) = {'sigma BG(cps)'};
            REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,8) = {'Sample(s)'};
            REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,9) = {'MIX(cps)'};
            REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,10) = {'Host in MIX(cps)'};
            REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,11) = {'Sample in MIX(cps)'};
            REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,12) = {'Sample in MIX(cps/cps)'};
            REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,13) = {'Sample(conc/conc)'};
            REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,14) = {['Sample(' char(181) 'g/g)']};
            REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,15) = {'error'};
            REPORT.UNKNOWN(c).table(7+t+m+s+x+d+A.Oxides_num,16) = {['LOD(' char(181) 'g/g)']};

            if A.Trace_num > 0             
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,1) = A.Trace_measured;
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,2) = num2cell(A.DT_VALUES(A.Trace_index));
                %define the cycle time:
                AT = UNK(c).data(end,1)-UNK(c).data(end-1,1);
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,3) = num2cell(AT);
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,4) = num2cell(UNK(c).REPORTIS_CALIB(A.Trace_index)');
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,5) = num2cell(UNK(c).bgwindow(2)-UNK(c).bgwindow(1));
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,6) = num2cell(UNK(c).bg_cps(A.Trace_index)');
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,7) = num2cell(UNK(c).BG_stdev(A.Trace_index)');

                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,8) = num2cell(UNK(c).sigtotal);
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,9) = num2cell(UNK(c).sig_cps(A.Trace_index)');
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,10) = num2cell(UNK(c).sig_cps(A.Trace_index)'-UNK(c).bg_cps(A.Trace_index)'-UNK(c).samp_cps(A.Trace_index)');
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,11) = num2cell(UNK(c).samp_cps(A.Trace_index)');
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,12) = num2cell(UNK(c).samp_cps(A.Trace_index)'./UNK(c).samp_cps(A.REPORTIS));
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,13) = num2cell(UNK(c).SAMP_CONC_trace'./UNK(c).SAMP_CONC(A.REPORTIS));
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,14) = num2cell(UNK(c).SAMP_CONC_trace');
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,15) = num2cell(UNK(c).SAMP_CONC_error_trace');
                REPORT.UNKNOWN(c).table(8+t+m+s+x+d+A.Oxides_num:7+t+m+s+x+d+A.Oxides_num+A.Trace_num,16) = num2cell(UNK(c).SAMP_LOD_mn_trace');
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

unknown = gap;
for c = 1:A.UNK_num;
    q = vertcat(REPORT.UNKNOWN(c).table,gap);
    unknown = vertcat(unknown,q);
end

else
    unknown = cell(1,w);
end

%CONCATENATE THE REPORT
REPORT.COMPILED = vertcat(REPORT.header,gap,...
    REPORT.STD_relsens,separator,...
    REPORT.SAMP_compsummary,gap,...
    REPORT.SAMP_errorsummary,gap,...
    REPORT.SAMP_LODsummary,gap,...
    REPORT.SAMP_in_MIX,separator,...
    REPORT.mixcps,separator,...
    REPORT.HOST_compsummary,gap,...
    REPORT.HOST_errorsummary,gap,...
    REPORT.HOST_LODsummary,gap,...
    REPORT.HOST_cps,separator,...
    REPORT.BG,separator,...
    REPORT.BGstdev,separator,...
    REPORT.STD_cps,separator,...
    REPORT.RATIOS,separator,...
    unknown); %Changed in 1.0.2 / 1.0.3

%CREATE THE FILE
if ispc %xlswrite works in windows only
    default = '.xls';
    if ~isempty(A.sillsfile) %Added in 1.0.3
        index = strfind(A.sillsfile,'.mat');
        if ~isempty(index)
            default = A.sillsfile;
            default(index:index+3) = '.xls';
        end
    end
    %prompt the user for a file name
    [A.reportfile,A.reportpath] = uiputfile({'*.xls','Microsoft Excel File (*.xls)';'*.*','All files (*.*)'},'Create Output File',default);
    
    %if the user cancels the prompt window return to the signal results window
    if A.reportfile == 0
        figure(SMAN.h_SMAN);
        clear a b c d e f gap i m q s separator unknown w x colnumber matrix_correction_test t seekreportis reportcfg index default pos
        return
    end
    A.reportfile = [A.reportpath A.reportfile];
    
    try %Added in 1.2.0
        xlswrite(A.reportfile,REPORT.COMPILED);
    catch %If writing Excel file failed --> low-level export
        warndlg('Writing the Excel file failed. SILLS is attempting to write a comma-separated text file instead.','SILLS warning');
        A.reportfile(end-2:end) = 'csv';
        %Exporting low-level
        fid = fopen(A.reportfile,'w');
        for g=1:size(REPORT.COMPILED,1)
            %define format string
            str = '';
            for h=1:size(REPORT.COMPILED,2)
                if isnumeric(REPORT.COMPILED{g,h})
                    str = [str '%g,'];
                else
                    str = [str '%s,'];
                end
            end
            fprintf(fid,[str '\n'],REPORT.COMPILED{g,:});
        end
        fclose(fid);
        clear fid g h str
    end
    
    
else % i.e. operating system is Mac or something else --> low-level export, Added in 1.2.0
    
    default = '.csv';
    if ~isempty(A.sillsfile) %Added in 1.0.3
        index = strfind(A.sillsfile,'.mat');
        if ~isempty(index)
            default = A.sillsfile;
            default(index:index+3) = '.csv';
        end
    end
    %prompt the user for a file name
    [A.reportfile,A.reportpath] = uiputfile({'*.csv','Comma-separated text file (*.csv)';'*.*','All files (*.*)'},'Create Output File',default);
    
    %if the user cancels the prompt window return to the signal results window
    if A.reportfile == 0
        figure(SMAN.h_SMAN);
        clear a b c d e f gap i m q s separator unknown w x colnumber matrix_correction_test t seekreportis reportcfg index default pos
        return
    end
    A.reportfile = [A.reportpath A.reportfile];
    
    %Exporting low-level
    fid = fopen(A.reportfile,'w');
    for g=1:size(REPORT.COMPILED,1)
        %define format string
        str = '';
        for h=1:size(REPORT.COMPILED,2)
            if isnumeric(REPORT.COMPILED{g,h})
                str = [str '%g,'];
            else
                str = [str '%s,'];
            end
        end
        fprintf(fid,[str '\n'],REPORT.COMPILED{g,:});
    end
    fclose(fid);
    clear fid g h str
end

clear a b c d e f gap i m q s separator unknown w x pos
clear colnumber matrix_correction_test t
clear seekreportis reportcfg index default