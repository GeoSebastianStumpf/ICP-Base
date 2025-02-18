%calcOXIDE

% SUMMONED WHEN THERE IS OXIDE NORMALISATION AND EITHER i) NO MATRIX
% CORRECTION OR ii) A MATRIX-ONLY TRACER

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%find the elements that are contained in the A.Oxides list
%(SiO2,TiO2,Al2O3,Fe2O3,FeO,MnO,MgO,CaO,Na2O,K2O,P2O5)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear oxide_seek oxide_seek2 oxide_seek_index oxide_seek_num
for b=1:A.ELEMENT_num
    oxide_seek(:,b) = strcmp(A.Oxides(:,1),A.ELEMENT_list(b));
end
oxide_seek2 = sum(oxide_seek);
oxide_seek_index = find(oxide_seek2 > 0);    %indices of the major oxide isotopes
oxide_seek_num = size(oxide_seek_index);
oxide_seek_num = oxide_seek_num(2);         %number of isotopes in the oxide list

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CALCULATION OF SAMPLE CONCENTRATIONS BASED ON TOTAL OXIDE NORMALISATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%..........................................................................
%define a matrix SIGOXIDE

UNK(c).SIGOXIDE = zeros(11,6); %11 major oxides, 6 categories of data

%..................................................................
%COLUMN 1: index of the isotope corresponding to given oxide

UNK(c).SIGOXIDE(:,1) = A.Oxides_index;

% 
% for d=1:11
%     %COLUMN 1: index of the isotope corresponding to given oxide
%     a = find(oxide_seek(d,:)==1);
%     if isempty(a)
%         a = 0;
%     end
%     UNK(c).SIGOXIDE(d,1) = a;
% end
% clear a 

%..........................................................................
% select an internal standard for this calculation (let this be the 
% isotope with the greatest sample intensity

for b = 1:11
    if UNK(c).SIGOXIDE(b,1) ~=0 && UNK(c).samp_cps(UNK(c).SIGOXIDE(b,1)) > 0
        samp(b) = UNK(c).samp_cps(UNK(c).SIGOXIDE(b,1));
    else
        samp(b) = 0;
    end
end

%define the internal standard
clear temp1
temp1 = find(samp == max(samp));
UNK(c).SIGOXIS = UNK(c).SIGOXIDE(temp1,1);

%Account for the case Fe is the maximum signal and there are two oxides
%Added in 1.0.2
if length(UNK(c).SIGOXIS) > 1
    UNK(c).SIGOXIS = UNK(c).SIGOXIS(1);
end

%create an arbitrary CALIB matrix for the purpose of casting cps in concs.
UNK(c).SIGOXIS_CALIB = UNK(c).REFIS_CALIB ./ UNK(c).REFIS_CALIB(UNK(c).SIGOXIS);

%..........................................................................
%continue populating the SIGOXIDE matrix:

for d=1:11
    if UNK(c).SIGOXIDE(d,1) ~= 0 %i.e. that oxide element was analysed
        %COLUMN 2: sample count rate
        UNK(c).SIGOXIDE(d,2) = UNK(c).samp_cps(UNK(c).SIGOXIDE(d,1));
        
        %do not accept negative count rates
        if UNK(c).SIGOXIDE(d,2) < 0
            UNK(c).SIGOXIDE(d,2) = 0;
        end
        
        %COLUMN 3: arbitrary set of relative concentrations
        UNK(c).SIGOXIDE(d,3) = UNK(c).SIGOXIDE(d,2)./UNK(c).SIGOXIS_CALIB(UNK(c).SIGOXIDE(d,1));
    else
        continue
    end
end

if A.Fe_test == 1             %i.e. there is Fe in the list
    if isempty(UNK(c).SIG_Fe_ratio)
        UNK(c).SIG_Fe_ratio = 0;
    end
    a = UNK(c).SIG_Fe_ratio; %the user-defined FeO /(FeO + Fe2O3) ratio
    %cast into the appropriate Fe2+ and Fe3+ concentrations
    UNK(c).SIGOXIDE(4,3) = UNK(c).SIGOXIDE(4,3)*(1-(1/(1+(0.699480/0.777314)*((1-a)/a))));
    UNK(c).SIGOXIDE(5,3) = UNK(c).SIGOXIDE(5,3)*(1/(1+(0.699480/0.777314)*((1-a)/a)));
end

%COLUMN 4: convert arbitrary element concentrations into arbitary
%oxide concentrations, e.g.

%[SiO2] = ([Si] / MW Si) * (1 mol SiO2 / 1 mol Si) * MW SiO2

UNK(c).SIGOXIDE(:,4) = UNK(c).SIGOXIDE(:,3)./A.Oxides_mol_wts(:,1)./A.Oxides_mol_wts(:,3).*A.Oxides_mol_wts(:,2);

clear temp temp2 
temp = sum(UNK(c).SIGOXIDE(:,4));  %total oxide mass
temp2 = UNK(c).SIG_oxide_total / temp; %scale factor

%COLUMN 5: correct oxide concentrations
UNK(c).SIGOXIDE(:,5) = UNK(c).SIGOXIDE(:,4)*temp2;

%calculate correct concentrations for all elements (in ug/g)
UNK(c).SAMP_CONC = ((UNK(c).samp_cps./UNK(c).SIGOXIS_CALIB)*temp2)*10000;

clear oxide_seek oxide_seek2 oxide_seek_index oxide_seek_num
clear a d
clear temp temp1 temp2 samp

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if UNK(c).MAT_corrtype == 1 %no matrix correction

    %......................................................................
    % CALCULATE x (the mass fraction of inclusion in the mixed signal)

    UNK(c).x = 1;        %i.e. 100% inclusion in the mixed signal
    UNK(c).sigma_x = 0;  %uncertainty in x is 0

    %......................................................................
    %Define cps errors due to counting statistics and flicker noise:
    UNK(c).sigma_bg = sqrt(((sqrt((UNK(c).bg_cps_mod.*A.DT_VALUES')/UNK(c).Nbg))./A.DT_VALUES').^2 + ((UNK(c).bg_cps_mod*(A.flickernoise/100)/sqrt(UNK(c).Nbg)).*((sqrt(A.flickDT))./sqrt(A.DT_VALUES'))).^2);
    UNK(c).sigma_sig = sqrt(((sqrt((UNK(c).sig_cps_mod.*A.DT_VALUES')/UNK(c).Nsig))./A.DT_VALUES').^2 + ((UNK(c).sig_cps_mod*(A.flickernoise/100)/sqrt(UNK(c).Nsig)).*((sqrt(A.flickDT))./sqrt(A.DT_VALUES'))).^2);

    %Determine the combined cps errors for the sample
    UNK(c).sigma_samp = sqrt(UNK(c).sigma_bg.^2 + UNK(c).sigma_sig.^2);

    %Convert into absolute concentrations:
    CALIBsamp  = UNK(c).SIGOXIS_CALIB;
    Cissamp = UNK(c).SAMP_CONC(UNK(c).SIGOXIS);
    Iissamp = UNK(c).samp_cps(UNK(c).SIGOXIS);

    UNK(c).SAMP_CONC_error = (1./CALIBsamp).*(Cissamp/Iissamp).*UNK(c).sigma_samp;

    clear CALIBsamp Cissamp Iissamp

    %......................................................................
    % CALCULATE LOD

    %use SIGOXIS as an internal standard for calculating LOD:
    
    %LOD in the signal
    %Changed factor from 3 to dynamic A.LODff in 1.0.2
    %Added two methods in 1.3.2
    if strcmp(A.LODmethod,'Longerich')==1
        UNK(c).SAMP_LOD_mn = A.LODff*UNK(c).BG_stdev*sqrt(1/UNK(c).Nbg + 1/UNK(c).Nsig)./UNK(c).SIGOXIS_CALIB.*(UNK(c).SAMP_CONC(UNK(c).SIGOXIS)/UNK(c).samp_cps(UNK(c).SIGOXIS));
        UNK(c).SAMP_LOD_mm = A.LODff*UNK(c).BG_stdev*sqrt(2/UNK(c).Nsig)./UNK(c).SIGOXIS_CALIB.*(UNK(c).SAMP_CONC(UNK(c).SIGOXIS)/UNK(c).samp_cps(UNK(c).SIGOXIS));
        % Added by MG changed 16.2.2011 and 20.4.2011
        %UNK(c).SAMP_LOD_new = (((3.29*(A.DT_VALUES').*UNK(c).BG_stdev*sqrt(UNK(c).Nsig)+ 2.71)./(A.DT_VALUES'))./(UNK(c).Nsig))./UNK(c).SIGOXIS_CALIB.*(UNK(c).SAMP_CONC(UNK(c).SIGOXIS)/UNK(c).samp_cps(UNK(c).SIGOXIS)); %calculationafter JAAS, Tanner 2010  IUPAC approximation
    elseif strcmp(A.LODmethod,'Pettke')==1
        UNK(c).SAMP_LOD_mn = (((sqrt((A.DT_VALUES').*UNK(c).bg_cps* UNK(c).Nsig*(1+UNK(c).Nsig/UNK(c).Nbg))*3.29+2.71)./(A.DT_VALUES'))./(UNK(c).Nsig))./UNK(c).SIGOXIS_CALIB.*(UNK(c).SAMP_CONC(UNK(c).SIGOXIS)/UNK(c).samp_cps(UNK(c).SIGOXIS));
    end
    %calculated after discussion with Pettke and Felix, see paper! Is Equation 6 in Paper: Ore Geology Reviews 44 (2012) 10–38
    %for zz = 1:A.ISOTOPE_num
    %    if UNK(c).SAMP_LOD_new(zz) > UNK(c).SAMP_LOD_mn(zz)
    %       UNK(c).SAMP_LOD_mn(zz) = UNK(c).SAMP_LOD_new(zz);
    %    end
    %end
    
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

                elseif Fe_hits == 2
                    MWelement = A.Oxides_measured_mol_wts(5,1);
                    MWoxide =   A.Oxides_measured_mol_wts(5,2);
                    stoich =    A.Oxides_measured_mol_wts(5,3);
                    UNK(c).SAMP_CONC_majox(d) = x*(UNK(c).SAMP_CONC(a)/1e4)*(MWoxide/(stoich*MWelement));
                    UNK(c).SAMP_CONC_error_majox(d) = x*(UNK(c).SAMP_CONC_error(a)/1e4)*(MWoxide/(stoich*MWelement));
                    UNK(c).SAMP_LOD_mn_majox(d) = x*(UNK(c).SAMP_LOD_mn(a)/1e4)*(MWoxide/(stoich*MWelement));
                end
            else
                MWelement = A.Oxides_measured_mol_wts(d,1);
                MWoxide =   A.Oxides_measured_mol_wts(d,2);
                stoich =    A.Oxides_measured_mol_wts(d,3);
                UNK(c).SAMP_CONC_majox(d) = (UNK(c).SAMP_CONC(a)/1e4)*(MWoxide/(stoich*MWelement));
                UNK(c).SAMP_CONC_error_majox(d) = (UNK(c).SAMP_CONC_error(a)/1e4)*(MWoxide/(stoich*MWelement));
                UNK(c).SAMP_LOD_mn_majox(d) = (UNK(c).SAMP_LOD_mn(a)/1e4)*(MWoxide/(stoich*MWelement));
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
    is = UNK(c).SIGOXIS;
    UNK(c).SIGOXIS_CALIB = UNK(c).REFIS_CALIB ./ UNK(c).REFIS_CALIB(UNK(c).SIGOXIS);
    Cihost = UNK(c).MAT_CONC;
    Cishost = UNK(c).MAT_CONC(is);
    Cthost = UNK(c).MAT_CONC(t);
    Iimix = UNK(c).sig_cps - UNK(c).bg_cps;   
    Iismix = UNK(c).sig_cps(is)-UNK(c).bg_cps(is);
    Itmix = UNK(c).sig_cps(t)-UNK(c).bg_cps(t);
    Cisinc = UNK(c).SAMP_CONC(is);
    
    %solve for the concentration ratio 'a': 
    a = (Itmix/Iismix)/UNK(c).SIGOXIS_CALIB(t);

    %solve for x
    x = (Cthost - a*Cishost)/(Cthost - a*Cishost + a*Cisinc);
    
    UNK(c).x = x;

    clear t is Cihost Cishost Cthost Iimix Iismix Itmix Cisinc a x

    %......................................................................
    %Define cps errors due to counting statistics and flicker noise:

    UNK(c).sigma_bg = sqrt(((sqrt((UNK(c).bg_cps_mod.*A.DT_VALUES')/UNK(c).Nbg))./A.DT_VALUES').^2 + ((UNK(c).bg_cps_mod*(A.flickernoise/100)/sqrt(UNK(c).Nbg)).*((sqrt(A.flickDT))./sqrt(A.DT_VALUES'))).^2);
    UNK(c).sigma_sig = sqrt(((sqrt((UNK(c).sig_cps_mod.*A.DT_VALUES')/UNK(c).Nsig))./A.DT_VALUES').^2 + ((UNK(c).sig_cps_mod*(A.flickernoise/100)/sqrt(UNK(c).Nsig)).*((sqrt(A.flickDT))./sqrt(A.DT_VALUES'))).^2);
    %UNK(c).sigma_mat has already been defined
    
    %combined error in the mixed signal (in cps):
    UNK(c).sigma_mix = sqrt(UNK(c).sigma_bg.^2 + UNK(c).sigma_sig.^2);

    %......................................................................
    % MIXTURE CALCULATIONS

    %declare an internal standard for the mixed signal (let this be the 1st
    %internal standard);
    UNK(c).MIXIS = UNK(c).SIGOXIS;
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

    UNCERTAINTY_LOD_CALC
    
    %......................................................................
    % DECLARE CALCULATION SUCCESSFUL
    UNK(c).matrix_correction_success = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate ablation yield based on the internal standard (highest
% intensity signal)
% Added in 1.2.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Csamp = UNK(c).SAMP_CONC(UNK(c).SIGOXIS); %Internal standard concentration
Isamp = UNK(c).samp_cps(UNK(c).SIGOXIS); %Internal standard intensity

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
sensSRM = UNK(c).REFIS_CALIB(UNK(c).SIGOXIS) .* sens_REFIS_mean;

%Calculate ablation yield, defined as ratio of sensitivities of sample vs. SRM
UNK(c).yield = (Isamp ./ Csamp) ./ sensSRM;
clear Csamp Isamp sens_REFIS i sens_REFIS_mean sensSRM

