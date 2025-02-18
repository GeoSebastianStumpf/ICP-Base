% DATADRIFT

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Performs calibration and drift correction calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%..........................................................................
% grab the appropriate SRM concentration for each element. If there isn't one, enter 0.
clear temp temp2 temp3
for d = 1:A.STD_num
    for c = 1:A.ISOTOPE_num
        temp = A.ELEMENT_list(c);
        temp2 = strcmp(SRM(STD(d).SRM).rowheaders,char(temp)); %compare the element list with the appropriate SRM list
        temp3 = find(temp2==1);
        if ~isempty(temp3);
            STD(d).SRM_concs(c) = SRM(STD(d).SRM).data(temp3);
        else
            STD(d).SRM_concs(c) = 0;
        end
    end
end
clear temp temp2 temp3

%..........................................................................
% Calculate the calibration slope for each isotope 
%(first to the drift correction internal standard, REFIS, 
% next to the report's internal standard, REPORTIS)
% Create matrix of sensitivities for each standard

for d = 1:A.STD_num
    for c = 1:A.ISOTOPE_num
        STD(d).CONC_ratio(c) = STD(d).SRM_concs(c)/STD(d).SRM_concs(A.REFIS);
        STD(d).CPS_ratio(c) = (STD(d).sig_cps(c) - STD(d).bg_cps(c))/(STD(d).sig_cps(A.REFIS) - STD(d).bg_cps(A.REFIS));
        STD(d).REFIS_CALIB(c) = STD(d).CPS_ratio(c) / STD(d).CONC_ratio(c);
    end
    STD(d).REPORTIS_CALIB = STD(d).REFIS_CALIB./STD(d).REFIS_CALIB(A.REPORTIS);
    STD(d).CPSPPM = (STD(d).sig_cps - STD(d).bg_cps) ./ STD(d).SRM_concs; %Moved from CALIBPLOT.m in 1.2.0
end

%..........................................................................
%create a vector A.STD_TIMES with the time points of the standards

A.STD_TIMES = [];           %empty in case of previous, larger set of unknowns
if strcmp(A.timeformat,'integer_points')==1;
    for c = 1:A.STD_num
        A.STD_TIMES(c) = STD(c).timepoint;
    end
elseif strcmp(A.timeformat,'hhmm')==1;
    for c=1:A.STD_num
        STD(c).clocktime = datenum([STD(c).hh ':' STD(c).mm],15); %convert the hh:mm timeformat to a numeric time code;
        A.STD_TIMES(c) = STD(c).clocktime;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linear Regression Calculations 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%test to see if all standard times are the same (also applies to the case
%of just one standard):

timetest = A.STD_TIMES - A.STD_TIMES(1);

% Compile the calibration slopes (cpsX/cpsIS)/(concX/concIS) of all 
% isotopes and all standards (stored as matrix A.STD_REFIS_CALIB)

A.STD_REFIS_CALIB = zeros(A.ISOTOPE_num,A.STD_num);
for a = 1:A.STD_num
    for b = 1:A.ISOTOPE_num
        A.STD_REFIS_CALIB(b,a) = STD(a).REFIS_CALIB(b);
    end
end

%now, for each isotope measured, define the drift correction with a linear regression through
%the standards' calibration slopes. If there is only one standard, or if
%all standards were defined at the same time, the average slope is used.

A.DRIFT_regression = zeros(A.ISOTOPE_num,2);
if sum(timetest) == 0 %i.e. one standard, or all stds taken at the same time
    for c = 1:A.ISOTOPE_num
        A.DRIFT_regression(c,1) = mean(A.STD_REFIS_CALIB(c,:));
        A.DRIFT_regression(c,2) = 0;
    end
else
    for c = 1:A.ISOTOPE_num
        A.DRIFT_regression(c,:) = polyfit(A.STD_TIMES,A.STD_REFIS_CALIB(c,:),1);
    end
end
clear timetest

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%now define a vector A.UNK_TIMES containing the time information of all
%unknowns & calculate the calibration slopes for each unknown and each
%isotope
if strcmp(A.timeformat,'integer_points')==1;
    A.UNK_TIMES = [];           %empty in case of previous, larger set of unknowns
    for d = 1:A.UNK_num
        A.UNK_TIMES(d) = UNK(d).timepoint;
        for c = 1:A.ISOTOPE_num
            UNK(d).REFIS_CALIB(c) = A.DRIFT_regression(c,1)*UNK(d).timepoint + A.DRIFT_regression(c,2);
        end
        UNK(d).REPORTIS_CALIB = UNK(d).REFIS_CALIB./UNK(d).REFIS_CALIB(A.REPORTIS);
    end
elseif strcmp(A.timeformat,'hhmm')==1;
    for d = 1:A.UNK_num
        UNK(d).clocktime = datenum([UNK(d).hh ':' UNK(d).mm],15); %convert the hh:mm timeformat to a numeric time code;
        A.UNK_TIMES(d) = UNK(d).clocktime;
        for c = 1:A.ISOTOPE_num
            UNK(d).REFIS_CALIB(c) = A.DRIFT_regression(c,1)*UNK(d).clocktime + A.DRIFT_regression(c,2);
        end
        UNK(d).REPORTIS_CALIB = UNK(d).REFIS_CALIB./UNK(d).REFIS_CALIB(A.REFIS);
    end
end

%..........................................................................
% Compile the calibration slopes (cpsX/cpsIS)/(concX/concIS) of all 
% isotopes and all unknowns (stored as matrix A.STD_REFIS_CALIB)

A.UNK_REFIS_CALIB = zeros(A.ISOTOPE_num,A.UNK_num);
for a = 1:A.UNK_num
    for b = 1:A.ISOTOPE_num
        A.UNK_REFIS_CALIB(b,a) = UNK(a).REFIS_CALIB(b);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%