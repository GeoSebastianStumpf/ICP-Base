%calcSALT

%SUMMONED WHEN THERE IS A) NO MATRIX CORRECTION AND B) SALINITY
%NORMALISATION

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NORMALISATION OF SAMPLE CONCENTRATIONS TO SALINITY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%..........................................................................
%first, convert selected salt-correction isotopes to a shortened
%matrix of elements
UNK(c).salt_index = find(UNK(c).SALT == 1); %position index of chosen isotopes for salt correction
UNK(c).salt_num = sum(UNK(c).SALT);         %number of elements in the correction (including Na)

for b = 1:UNK(c).salt_num
    UNK(c).salt(b) = A.ISOTOPE_list(UNK(c).salt_index(b));
end

clear temp1 temp2 temp3 temp4
temp1 = char(UNK(c).salt);
temp2 = isletter(temp1);
temp3 = temp2.*temp1;
temp4 = char(temp3);
UNK(c).salt_elements = cell(1,UNK(c).salt_num);
for b = 1:UNK(c).salt_num
    UNK(c).salt_elements(b) = {temp4(b,:)};
end


UNK(c).salt_elements = deblank(UNK(c).salt_elements);

clear temp1 temp2 temp3 temp4

%..........................................................................
%Now compare the element matrix UNK.salt_elements with
%the list of elements from the 'Chlorides' matrix

temp1 = zeros(A.Chlorides_num,UNK(c).salt_num);
for b = 1:UNK(c).salt_num
    temp1(:,b) = strcmp(A.Chlorides(:,1),UNK(c).salt_elements(b));
    UNK(c).chloride_index(b) = find(temp1(:,b)==1);
    %UNK(c).chloride_index contains the row indices of the
    %elements selected for the salt correction
end

%..........................................................................
%select Na as the internal standard for this calculation
UNK(c).SIGSALTIS = A.Na_index;

%create a CALIB matrix for the purpose of casting cps in concs.
UNK(c).SIGSALTIS_CALIB = UNK(c).REFIS_CALIB ./ UNK(c).REFIS_CALIB(UNK(c).SIGSALTIS);

%convert counts ratios to Na into concentration ratios
UNK(c).SAMP_CPS_ratio = UNK(c).samp_cps / UNK(c).samp_cps(UNK(c).SIGSALTIS);
UNK(c).SAMP_CONC_ratio = UNK(c).SAMP_CPS_ratio ./ UNK(c).SIGSALTIS_CALIB;

%..........................................................................
%create a condensed concentration ratio matrix containing just
%those elements chosen for the salt correction

for b = 1:UNK(c).salt_num
    UNK(c).SAMP_CONC_ratio_condensed(b) = UNK(c).SAMP_CONC_ratio(UNK(c).salt_index(b));
end

%remove any salt correction element ratios that are negative
clear temp1
temp1 = find(UNK(c).SAMP_CONC_ratio_condensed < 0);
UNK(c).SAMP_CONC_ratio_condensed(temp1) = 0;
clear temp1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CASE 1: Total Salinity (Mass Balance)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if UNK(c).SIG_constraint1 == 2  %i.e. mass balance constraint

    %for the matrix correction isotopes, convert X/Na concentration
    %ratios into XCln/NaCl ratios

    % [XCln]/[NaCl] = [X]/[Na] * (MW Na / MW X) * (MW XCln / MW NaCl)
    MWNa = 22.99;
    MWNaCl = 58.44;

    for b = 1:UNK(c).salt_num
        MWX = A.Chlorides_mol_wts(UNK(c).chloride_index(b),1);
        MWXCl = A.Chlorides_mol_wts(UNK(c).chloride_index(b),2);
        UNK(c).SIG_ChlorideCONC_ratio(b) = UNK(c).SAMP_CONC_ratio_condensed(b)*(MWNa/MWX)*(MWXCl/MWNaCl);
    end

    %remove the [NaCl]/[NaCl] ratio (1) from SIG_SALTCONC_ratio
    seekdestroy = find(UNK(c).SIG_ChlorideCONC_ratio == 1);
    UNK(c).SIG_ChlorideCONC_ratio(seekdestroy) = [];

    %calculate equiv. wt.% Na from equiv. wt.% NaCl
    Naequiv = UNK(c).SIGsalinity * (MWNa/MWNaCl);

    %now calculate wt.% Na based on the equation:
    %[Na] = [Na]equiv/(1 + A*sum([XCl]/[NaCl]))
    %where A has been defined by the user as
    %UNK(c).SALT_mass_balance_factor
    %**********************************************************************
    %REFERENCE: Eqn.5 in Heinrich et al (2003), Geochim. Cosmochim. Acta, 67(18),3473–3496
    %REFERENCE: Eqn.3 in Allan et al (2005), Amer. Min., 90, 1767-1775
    %**********************************************************************

    Naconc_in_wt_percent = Naequiv / (1 + UNK(c).SALT_mass_balance_factor*sum(UNK(c).SIG_ChlorideCONC_ratio));

    Naconc_in_ppm = 10000 * Naconc_in_wt_percent;

    %now convert all isotopes in their correct concentations based
    %on Naconc (in ug/g);

    UNK(c).SAMP_CONC = UNK(c).SAMP_CONC_ratio * Naconc_in_ppm;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %CASE 2: Total Salinity (Charge Balance)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif UNK(c).SIG_constraint1 == 3 %i.e. charge balance constraint

    %convert concentration ratios into n*molar ratio for the
    %last term in the equation:

    %mNa = mCl/(1 + sum((n*mX)/mNa))

    %where mX/mNa = [X]/[Na] * (MWNa/MWX)
    for b = 1:UNK(c).salt_num

        n = A.Chlorides_mol_wts(UNK(c).chloride_index(b),3);
        MWX = A.Chlorides_mol_wts(UNK(c).chloride_index(b),1);
        MWNa = 22.99;

        UNK(c).SIG_MOLAR_ratio(b) = n*UNK(c).SAMP_CONC_ratio_condensed(b)*(MWNa/MWX);

    end

    %remove the mNa/mNa entry in the SIG_MOLAR_ratio
    seekdestroy = find(UNK(c).SIG_MOLAR_ratio == 1);
    UNK(c).SIG_MOLAR_ratio(seekdestroy) = [];

    %calculate mCl based on the user-defined equiv. wt.% NaCl
    MWNaCl = 58.44;
    molalityNaCl = (10*UNK(c).SIGsalinity)/MWNaCl;
    mCl = molalityNaCl;

    %calculate mNa:
    mNa = mCl/(1+sum(UNK(c).SIG_MOLAR_ratio));

    %convert mNa into ppm Na:
    Naconc_in_ppm = mNa*MWNa*1000;

    %calculate the absolute concentration of all elements:
    UNK(c).SAMP_CONC = UNK(c).SAMP_CONC_ratio * Naconc_in_ppm;

end

clear MWNa MWNaCl MWX MWXCl seekdestroy Naequiv Naconc_in_wt_percent Naconc_in_ppm
clear n molality NaCl mCl mNa Naconc_in_ppm
clear temp1 temp2 temp3 temp4


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if UNK(c).MAT_corrtype == 1 %no matrix correction

    %......................................................................
    % CALCULATE x (the mass fraction of inclusion in the mixed signal)

    UNK(c).x = 1;        %i.e. 100% inclusion in the mixed signal
    UNK(c).sigma_x = 0;  %i.e. uncertainty in x is 0

    %......................................................................
    %Define cps errors due to counting statistics and flicker noise:

    UNK(c).sigma_bg = sqrt(((sqrt((UNK(c).bg_cps_mod.*A.DT_VALUES')/UNK(c).Nbg))./A.DT_VALUES').^2 + ((UNK(c).bg_cps_mod*(A.flickernoise/100)/sqrt(UNK(c).Nbg)).*((sqrt(A.flickDT))./sqrt(A.DT_VALUES'))).^2);
    UNK(c).sigma_sig = sqrt(((sqrt((UNK(c).sig_cps_mod.*A.DT_VALUES')/UNK(c).Nsig))./A.DT_VALUES').^2 + ((UNK(c).sig_cps_mod*(A.flickernoise/100)/sqrt(UNK(c).Nsig)).*((sqrt(A.flickDT))./sqrt(A.DT_VALUES'))).^2);

    %Determine the combined cps errors for the sample
    UNK(c).sigma_samp = sqrt(UNK(c).sigma_bg.^2 + UNK(c).sigma_sig.^2);

    %Convert into absolute concentrations:
    CALIBsamp = UNK(c).SIGSALTIS_CALIB;
    Cissamp = UNK(c).SAMP_CONC(UNK(c).SIGSALTIS);
    Iissamp = UNK(c).samp_cps(UNK(c).SIGSALTIS);

    UNK(c).SAMP_CONC_error = (1./CALIBsamp).*(Cissamp/Iissamp).*UNK(c).sigma_samp;

    clear CALIBsamp Cissamp Iissamp

    %......................................................................
    % CALCULATE LOD
    
    %LOD in the signal
    %Changed factor from 3 to dynamic A.LODff in 1.0.2
    %Added two methods in 1.3.2
    if strcmp(A.LODmethod,'Longerich')==1
        UNK(c).SAMP_LOD_mn = A.LODff*UNK(c).BG_stdev*sqrt(1/UNK(c).Nbg + 1/UNK(c).Nsig)./UNK(c).SIGSALTIS_CALIB.*(UNK(c).SAMP_CONC(UNK(c).SIGSALTIS)/(UNK(c).sig_cps(UNK(c).SIGSALTIS)-UNK(c).bg_cps(UNK(c).SIGSALTIS)));
        UNK(c).SAMP_LOD_mm = A.LODff*UNK(c).BG_stdev*sqrt(2/UNK(c).Nsig)./UNK(c).SIGSALTIS_CALIB.*(UNK(c).SAMP_CONC(UNK(c).SIGSALTIS)/(UNK(c).sig_cps(UNK(c).SIGSALTIS)-UNK(c).bg_cps(UNK(c).SIGSALTIS)));
        
        % Added by MG changed 16.2.2011 and 20.4.2011 and 28.3.2012
        %UNK(c).SAMP_LOD_new = (((3.29*(A.DT_VALUES').*UNK(c).BG_stdev*sqrt(UNK(c).Nsig)+ 2.71)./(A.DT_VALUES'))./(UNK(c).Nsig))./UNK(c).SIGSALTIS_CALIB.*(UNK(c).SAMP_CONC(UNK(c).SIGSALTIS)/(UNK(c).sig_cps(UNK(c).SIGSALTIS)-UNK(c).bg_cps(UNK(c).SIGSALTIS))); %calculationafter JAAS, Tanner 2010  IUPAC approximation
    elseif strcmp(A.LODmethod,'Pettke')==1
        UNK(c).SAMP_LOD_mn = (((sqrt((A.DT_VALUES').*UNK(c).bg_cps* UNK(c).Nsig*(1+UNK(c).Nsig/UNK(c).Nbg))*3.29+2.71)./(A.DT_VALUES'))./(UNK(c).Nsig))./UNK(c).SIGSALTIS_CALIB.*(UNK(c).SAMP_CONC(UNK(c).SIGSALTIS)/(UNK(c).sig_cps(UNK(c).SIGSALTIS)-UNK(c).bg_cps(UNK(c).SIGSALTIS))); %calculated after discussion with Pettke and Felix, see paper!
    end
    % Is Equation 6 in Paper: Ore Geology Reviews 44 (2012) 10–38
    %for zz = 1:A.ISOTOPE_num
    %    if UNK(c).SAMP_LOD_new(zz) > UNK(c).SAMP_LOD_mn(zz)
    %       UNK(c).SAMP_LOD_mn(zz) = UNK(c).SAMP_LOD_new(zz);
    %    end
    %end

    % stopp Added by MG 
    %......................................................................
    % DECLARE CALCULATION SUCCESSFUL
    UNK(c).matrix_correction_success = 1;


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
    is = UNK(c).SIGSALTIS;
    UNK(c).SIGSALTIS_CALIB = UNK(c).REFIS_CALIB ./ UNK(c).REFIS_CALIB(UNK(c).SIGSALTIS);
    Cihost = UNK(c).MAT_CONC;
    Cishost = UNK(c).MAT_CONC(is);
    Cthost = UNK(c).MAT_CONC(t);
    Iimix = UNK(c).sig_cps - UNK(c).bg_cps;
    Iismix = UNK(c).sig_cps(is)-UNK(c).bg_cps(is);
    Itmix = UNK(c).sig_cps(t)-UNK(c).bg_cps(t);
    Cisinc = UNK(c).SAMP_CONC(is);

    %solve for the concentration ratio 'a':
    a = (Itmix/Iismix)/UNK(c).SIGSALTIS_CALIB(t);

    %solve for x
    x = (Cthost - a*Cishost)/(Cthost - a*Cishost + a*Cisinc);

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
    UNK(c).MIXIS = UNK(c).SIGSALTIS;
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
% Calculate ablation yield based on the internal standard (Na)
% Added in 1.2.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Csamp = UNK(c).SAMP_CONC(UNK(c).SIGSALTIS); %Internal standard concentration
Isamp = UNK(c).samp_cps(UNK(c).SIGSALTIS); %Internal standard intensity

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
sensSRM = UNK(c).REFIS_CALIB(UNK(c).SIGSALTIS) .* sens_REFIS_mean;

%Calculate ablation yield, defined as ratio of sensitivities of sample vs. SRM
UNK(c).yield = (Isamp ./ Csamp) ./ sensSRM;
clear Csamp Isamp sens_REFIS i sens_REFIS_mean sensSRM