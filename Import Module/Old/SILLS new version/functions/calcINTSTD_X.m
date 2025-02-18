%calcINTSTD
function [A, UNK,STD, SRM, SMAN] = calcINTSTD_X(A, UNK,STD, SRM, SMAN, c)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IF THERE IS NO MATRIX CORRECTION & ONE INTERNAL STANDARD                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%define sample count ratios
UNK(c).SAMP_CPS_ratio = UNK(c).samp_cps / UNK(c).samp_cps(UNK(c).SIGQIS1);
%define the calibration curve matrix (relative to internal standard)
UNK(c).SIGQIS1_CALIB = UNK(c).REFIS_CALIB ./ UNK(c).REFIS_CALIB(UNK(c).SIGQIS1);
%define sample concentration ratios
UNK(c).SAMP_CONC_ratio = UNK(c).SAMP_CPS_ratio ./ UNK(c).SIGQIS1_CALIB;
%define sample concentrations
UNK(c).SAMP_CONC = UNK(c).SAMP_CONC_ratio * UNK(c).SIGQIS1_conc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if UNK(c).MAT_corrtype == 1 %no matrix correction

    %......................................................................
    % CALCULATE x (the mass fraction of inclusion in the mixed signal)

    UNK(c).x = 1;            %i.e. 100% inclusion in the mixed signal
    UNK(c).sigma_x = 0;      %uncertainty in x is 0;

    %......................................................................
    %Define cps errors due to counting statistics and flicker noise:
    UNK(c).sigma_bg = sqrt(((sqrt((UNK(c).bg_cps_mod.*A.DT_VALUES')/UNK(c).Nbg))./A.DT_VALUES').^2 + ((UNK(c).bg_cps_mod*(A.flickernoise/100)/sqrt(UNK(c).Nbg)).*((sqrt(A.flickDT))./sqrt(A.DT_VALUES'))).^2);
    UNK(c).sigma_sig = sqrt((((sqrt((UNK(c).sig_cps_mod.*A.DT_VALUES')/UNK(c).Nsig))./A.DT_VALUES')).^2 + ((UNK(c).sig_cps_mod*(A.flickernoise/100)/sqrt(UNK(c).Nsig)).*((sqrt(A.flickDT))./sqrt(A.DT_VALUES'))).^2);

  % added 1.2 by MG define cps error based on signal and Gas blank
    UNK(c).stderr_bg = (std(UNK(c).data_cps_bg)/sqrt(UNK(c).Nbg));
    UNK(c).stderr_sig = (std(UNK(c).data_cps_sig)/sqrt(UNK(c).Nsig));
    UNK(c).stderrcomb = UNK(c).stderr_bg + UNK(c).stderr_sig; % combined error from BG subtraction
    UNK(c).SAMP_CONC_error = ((UNK(c).stderrcomb ./ UNK(c).samp_cps)) .* UNK(c).SAMP_CONC; %error in concentration
    
  % stop added by MG
    
    %Determine the combined cps errors for the sample
    UNK(c).sigma_samp = sqrt(UNK(c).sigma_bg.^2 + UNK(c).sigma_sig.^2);

    %Convert into absolute concentrations:
    CALIBsamp = UNK(c).SIGQIS1_CALIB;
    Cissamp = UNK(c).SAMP_CONC(UNK(c).SIGQIS1);
    Iissamp = UNK(c).samp_cps(UNK(c).SIGQIS1);

    %added 1.2.0 by MG
    
    %UNK(c).SAMP_CONC_error = (1./CALIBsamp).*(Cissamp/Iissamp).*UNK(c).sigma_samp;
    %UNK(c).SAMP_CONC_error = 5;
    %changed 1.2.0 by MG feb2010 

    clear CALIBsamp Cissamp Iissamp

    %......................................................................
    % CALCULATE LOD
    
    %LOD in the signal
    %Changed factor from 3 to dynamic A.LODff in 1.0.2
    %Added two methods in 1.3.2
    if strcmp(A.LODmethod,'Longerich')==1
        UNK(c).SAMP_LOD_mn = A.LODff * UNK(c).BG_stdev*sqrt(1/UNK(c).Nbg + 1/UNK(c).Nsig)./UNK(c).SIGQIS1_CALIB.*(UNK(c).SAMP_CONC(UNK(c).SIGQIS1)/(UNK(c).sig_cps(UNK(c).SIGQIS1)-UNK(c).bg_cps(UNK(c).SIGQIS1)));
        UNK(c).SAMP_LOD_mm = A.LODff * UNK(c).BG_stdev*sqrt(2/UNK(c).Nsig)./UNK(c).SIGQIS1_CALIB.*(UNK(c).SAMP_CONC(UNK(c).SIGQIS1)/(UNK(c).sig_cps(UNK(c).SIGQIS1)-UNK(c).bg_cps(UNK(c).SIGQIS1)));
        % Added by MG final version 20.04.2011
    elseif strcmp(A.LODmethod,'Pettke')==1
        UNK(c).SAMP_LOD_mn = (((sqrt((A.DT_VALUES').*UNK(c).bg_cps* UNK(c).Nsig*(1+UNK(c).Nsig/UNK(c).Nbg))*3.29+2.71)./(A.DT_VALUES'))./(UNK(c).Nsig))./UNK(c).SIGQIS1_CALIB.*(UNK(c).SAMP_CONC(UNK(c).SIGQIS1)/(UNK(c).sig_cps(UNK(c).SIGQIS1)-UNK(c).bg_cps(UNK(c).SIGQIS1))); %calculated after discussion with Pettke and Felix, see paper!
    end
    % Is Equation 6 in Paper: Ore Geology Reviews 44 (2012) 10–38

    % stopp Added by MG 
    
    %......................................................................
    % DECLARE CALCULATION SUCCESSFUL
    UNK(c).matrix_correction_success = 1;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Convert results into oxides if 'Major Elements as Oxides' was selected in
    % the Calculation Manager
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if strcmp(A.report_settings_oxide,'on') == 1;

        if A.Fe_test == 1
            if ~isempty(UNK(c).SIG_Fe_ratio)
                f = UNK(c).SIG_Fe_ratio; %FeO/(FeO+Fe2O3) ratio
                %define the Fe2+/(Fe2+ + Fe3+) ratio
                x = 1/(1+(0.699480/0.777314)*((1-f)/f));
                clear f
            else
                x = 1; %i.e. set as 100% FeO as a default
            end
        end

        %convert concentrations into oxides
        Fe_hits = 0;
        for d = 1:A.Oxides_num

            p = strcmp(A.Oxides(:,1),A.ELEMENT_list(A.Oxides_index_condensed(d)));
            q = find(p==1);
            a = A.Oxides_index_condensed(d);

            if p(4) == 1 && p(5) == 1 && A.Fe_test ~= 0
                Fe_hits = Fe_hits + 1;

                if Fe_hits == 1
                    MWelement = A.Oxides_measured_mol_wts(4,1);
                    MWoxide =   A.Oxides_measured_mol_wts(4,2);
                    stoich =    A.Oxides_measured_mol_wts(4,3);
                    UNK(c).SAMP_CONC_majox(d) = (1-x)*(UNK(c).SAMP_CONC(a)/1e4)*(MWoxide/(stoich*MWelement));
                    UNK(c).SAMP_CONC_error_majox(d) = (1-x)*(UNK(c).SAMP_CONC_error(a)/1e4)*(MWoxide/(stoich*MWelement));
                    UNK(c).SAMP_LOD_mn_majox(d) = (1-x)*(UNK(c).SAMP_LOD_mn(a)/1e4)*(MWoxide/(stoich*MWelement));
                    UNK(c).SAMP_LOD_mm_majox(d) = (1-x)*(UNK(c).SAMP_LOD_mm(a)/1e4)*(MWoxide/(stoich*MWelement));

                elseif Fe_hits == 2
                    MWelement = A.Oxides_measured_mol_wts(5,1);
                    MWoxide =   A.Oxides_measured_mol_wts(5,2);
                    stoich =    A.Oxides_measured_mol_wts(5,3);
                    UNK(c).SAMP_CONC_majox(d) = x*(UNK(c).SAMP_CONC(a)/1e4)*(MWoxide/(stoich*MWelement));
                    UNK(c).SAMP_CONC_error_majox(d) = x*(UNK(c).SAMP_CONC_error(a)/1e4)*(MWoxide/(stoich*MWelement));
                    UNK(c).SAMP_LOD_mn_majox(d) = x*(UNK(c).SAMP_LOD_mn(a)/1e4)*(MWoxide/(stoich*MWelement));
                    UNK(c).SAMP_LOD_mm_majox(d) = x*(UNK(c).SAMP_LOD_mm(a)/1e4)*(MWoxide/(stoich*MWelement));
                end
            else
                MWelement = A.Oxides_measured_mol_wts(d,1);
                MWoxide =   A.Oxides_measured_mol_wts(d,2);
                stoich =    A.Oxides_measured_mol_wts(d,3);
                UNK(c).SAMP_CONC_majox(d) = (UNK(c).SAMP_CONC(a)/1e4)*(MWoxide/(stoich*MWelement));
                UNK(c).SAMP_CONC_error_majox(d) = (UNK(c).SAMP_CONC_error(a)/1e4)*(MWoxide/(stoich*MWelement));
                UNK(c).SAMP_LOD_mn_majox(d) = (UNK(c).SAMP_LOD_mn(a)/1e4)*(MWoxide/(stoich*MWelement));
                UNK(c).SAMP_LOD_mm_majox(d) = (UNK(c).SAMP_LOD_mm(a)/1e4)*(MWoxide/(stoich*MWelement));
            end
        end
        clear Fe_hits

        %distill trace element results
        UNK(c).SAMP_CONC_trace = UNK(c).SAMP_CONC(A.Trace_index);
        UNK(c).SAMP_CONC_error_trace = UNK(c).SAMP_CONC_error(A.Trace_index);
        UNK(c).SAMP_LOD_mn_trace = UNK(c).SAMP_LOD_mn(A.Trace_index);

        clear a MWelement MWoxide stoich

    end
    

elseif UNK(c).MAT_corrtype ~= 1 && UNK(c).SIG_constraint2 == 1 %i.e. matrix-only tracer

    %......................................................................
    % CALCULATE x (the mass fraction of inclusion in the mixed signal)

    %the mass fraction is defined by Halter et al (2002) Chem. Geol, 183,
    %63-86 as:

    % x = (Cihost - Cimix)/(Cihost - Ciinc)

    % so let 't' be the tracer element and 'is' be the internal standard

    % x = (Cthost - Ctmix)/(Cthost - Ctinc) but Ctinc = 0 so:
    % x = 1 - (Ctmix/Cthost)

    % also: x = (Cishost - Cismix)/(Cishost - Cisinc)

    % we do not know Ctmix or Cismix but we do know that:

    % Ctmix/Cismix = (Itmix/Iismix)/CALIB, where calib is the relative
    % sensitivity of t relative to is

    % It holds that:
    % x = (Cthost - a*Cishost)/(Cthost - a*Cishost + a*Cisinc)
    % where a = Ctmix/Cismix

    %define the variables:
    t = UNK(c).SIG_tracer;
    is = UNK(c).SIGQIS1;
    UNK(c).SIGQIS1_CALIB = UNK(c).REFIS_CALIB ./ UNK(c).REFIS_CALIB(UNK(c).SIGQIS1);
    Cihost = UNK(c).MAT_CONC;
    Cishost = UNK(c).MAT_CONC(is);
    Cthost = UNK(c).MAT_CONC(t);
    Iimix = UNK(c).sig_cps - UNK(c).bg_cps;
    Iismix = UNK(c).sig_cps(is)-UNK(c).bg_cps(is);
    Itmix = UNK(c).sig_cps(t)-UNK(c).bg_cps(t);
    Cisinc = UNK(c).SIGQIS1_conc;

    %solve for the concentration ratio 'cr':
    cr = (Itmix/Iismix)/UNK(c).SIGQIS1_CALIB(t);

    %solve for x
    x = (Cthost - cr*Cishost)/(Cthost - cr*Cishost + cr*Cisinc);

    UNK(c).x = x;

    clear t is Cihost Cishost Cthost Iimix Iismix Itmix Cisinc cr x

    %......................................................................
    %Define cps errors due to counting statistics and flicker noise:

    UNK(c).sigma_bg = sqrt(((sqrt((UNK(c).bg_cps_mod.*A.DT_VALUES')/UNK(c).Nbg))./A.DT_VALUES').^2 + ((UNK(c).bg_cps_mod*(A.flickernoise/100)/sqrt(UNK(c).Nbg)).*((sqrt(A.flickDT))./sqrt(A.DT_VALUES'))).^2);
    UNK(c).sigma_sig = sqrt(((sqrt((UNK(c).sig_cps_mod.*A.DT_VALUES')/UNK(c).Nsig))./A.DT_VALUES').^2 + ((UNK(c).sig_cps_mod*(A.flickernoise/100)/sqrt(UNK(c).Nsig)).*((sqrt(A.flickDT))./sqrt(A.DT_VALUES'))).^2);

    %combined error in the mixed signal (in cps):
    UNK(c).sigma_mix = sqrt(UNK(c).sigma_bg.^2 + UNK(c).sigma_sig.^2);

    %......................................................................
    % MIXTURE CALCULATIONS

    %declare an internal standard for the mixed signal (let this be the 1st
    %internal standard);
    UNK(c).MIXIS = UNK(c).SIGQIS1;
    %calculate concentrations in the mixture
    UNK(c).MIX_CONC = UNK(c).x*(UNK(c).SAMP_CONC) + (1-UNK(c).x)*(UNK(c).MAT_CONC);
    %define calibration curves relative to the mixture's internal standard
    UNK(c).MIXIS_CALIB = UNK(c).REFIS_CALIB ./ UNK(c).REFIS_CALIB(UNK(c).MIXIS);

    %convert cps errors in the mixture into concentrations:
    CALIBmix = UNK(c).MIXIS_CALIB;
    Cismix = UNK(c).MIX_CONC(UNK(c).MIXIS);
    Iismix = UNK(c).sig_cps(UNK(c).MIXIS) - UNK(c).bg_cps(UNK(c).MIXIS);
    UNK(c).MIX_CONC_error = (1./CALIBmix).*(Cismix/Iismix).*UNK(c).sigma_mix;

    clear CALIBmix Cismix Iismix

    %......................................................................
    % CALCULATE LOD
    [A, UNK, STD, SRM, SMAN] = UNCERTAINTY_LOD_CALC_132(A, UNK, STD, SRM, SMAN, c);

    %......................................................................
    % DECLARE CALCULATION SUCCESSFUL
    UNK(c).matrix_correction_success = 1;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convert results into oxides if 'Major Elements as Oxides' was selected in
% the Calculation Manager
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(A.report_settings_oxide,'on') == 1;

    if A.Fe_test == 1
        if ~isempty(UNK(c).SIG_Fe_ratio)
            f = UNK(c).SIG_Fe_ratio; %FeO/(FeO+Fe2O3) ratio
            %define the Fe2+/(Fe2+ + Fe3+) ratio
            x = 1/(1+(0.699480/0.777314)*((1-f)/f));
            clear f
        else
            x = 1; %i.e. set as 100% FeO as a default
        end
    end

    %convert concentrations into oxides
    for d = 1:A.Oxides_num

        a = A.Oxides_index_condensed(d);
        MWelement = A.Oxides_measured_mol_wts(d,1);
        MWoxide =   A.Oxides_measured_mol_wts(d,2);
        stoich =    A.Oxides_measured_mol_wts(d,3);

        if A.Fe_test ==1 && d == 4 %i.e. Fe2O3
            UNK(c).SAMP_CONC_majox(d) = (1-x)*(UNK(c).SAMP_CONC(a)/1e4)*(MWoxide/(stoich*MWelement));
            UNK(c).SAMP_CONC_error_majox(d) = (1-x)*(UNK(c).SAMP_CONC_error(a)/1e4)*(MWoxide/(stoich*MWelement));
            UNK(c).SAMP_LOD_mn_majox(d) = (1-x)*(UNK(c).SAMP_LOD_mn(a)/1e4)*(MWoxide/(stoich*MWelement));
        elseif A.Fe_test == 1 && d == 5 %i.e. FeO
            UNK(c).SAMP_CONC_majox(d) = x*(UNK(c).SAMP_CONC(a)/1e4)*(MWoxide/(stoich*MWelement));
            UNK(c).SAMP_CONC_error_majox(d) = x*(UNK(c).SAMP_CONC_error(a)/1e4)*(MWoxide/(stoich*MWelement));
            UNK(c).SAMP_LOD_mn_majox(d) = x*(UNK(c).SAMP_LOD_mn(a)/1e4)*(MWoxide/(stoich*MWelement));
        else
            UNK(c).SAMP_CONC_majox(d) = (UNK(c).SAMP_CONC(a)/1e4)*(MWoxide/(stoich*MWelement));
            UNK(c).SAMP_CONC_error_majox(d) = (UNK(c).SAMP_CONC_error(a)/1e4)*(MWoxide/(stoich*MWelement));
            UNK(c).SAMP_LOD_mn_majox(d) = (UNK(c).SAMP_LOD_mn(a)/1e4)*(MWoxide/(stoich*MWelement));
        end
    end

    %distill trace element results
    UNK(c).SAMP_CONC_trace = UNK(c).SAMP_CONC(A.Trace_index);
    UNK(c).SAMP_CONC_error_trace = UNK(c).SAMP_CONC_error(A.Trace_index);
    UNK(c).SAMP_LOD_mn_trace = UNK(c).SAMP_LOD_mn(A.Trace_index);

    clear a MWelement MWoxide stoich
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate ablation yield based on the internal standard
% Added in 1.2.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Csamp = UNK(c).SIGQIS1_conc; %Internal standard concentration
Isamp = UNK(c).samp_cps(UNK(c).SIGQIS1); %Internal standard intensity

%Calculate SRM sensitivity for drift correction standard (assumed to undergo no
%drift, average sensitivity is used)
sens_REFIS = zeros(A.STD_num,1);
for i=1:A.STD_num
    sens_REFIS(i) = STD(i).CPSPPM(A.REFIS);
end
sens_REFIS_mean = mean(sens_REFIS);
%Calculate drift corrected SRM sensitivity for sample internal standard
%(Drift corrected calibration slope for internal standard element * average
%sensitivity of drift correction standard, see definition of calibration
%slope
sensSRM = UNK(c).REFIS_CALIB(UNK(c).SIGQIS1) .* sens_REFIS_mean;

%Calculate ablation yield, defined as ratio of sensitivities of sample vs. SRM
UNK(c).yield = (Isamp ./ Csamp) ./ sensSRM;
clear Csamp Isamp sens_REFIS i sens_REFIS_mean sensSRM

end