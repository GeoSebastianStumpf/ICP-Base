%calcINTSTD_INTSTD

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SUMMONED WHEN THERE IS A) A MATRIX CORRECTION PROCEDURE AND B)
%NORMALISATION TO TWO INTERNAL STANDARDS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define constants for the following calculations:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

is1 = UNK(c).SIGQIS1;               %1st internal standard
is2 = UNK(c).SIGQIS2;               %2nd internal standard
UNK(c).SIGQIS2_CALIB = UNK(c).REFIS_CALIB ./ UNK(c).REFIS_CALIB(UNK(c).SIGQIS2);
CALIBis2 = UNK(c).SIGQIS2_CALIB;    %calibration curves relative to 2nd i.s.
Iimix = UNK(c).sig_cps - UNK(c).bg_cps;
Iis1mix = UNK(c).sig_cps(is1)-UNK(c).bg_cps(is1);   %of the 1st i.s.
Iis2mix = UNK(c).sig_cps(is2)-UNK(c).bg_cps(is2);   %of the 2nd i.s.
Cihost = UNK(c).MAT_CONC;           %conc. of all elements in the host
Cis1host = UNK(c).MAT_CONC(is1);    %conc. of is1 in the host
Cis2host = UNK(c).MAT_CONC(is2);    %conc. of is2 in the host
Cis1inc = UNK(c).SIGQIS1_conc;      %conc. of is1 in the inclusion
Cis2inc = UNK(c).SIGQIS2_conc;      %conc. of is2 in the inclusion
Cis1mix_Cis2mix = (Iis1mix/Iis2mix)/CALIBis2(is1);
%conc. ratio of is1 to is2 in the mix

%..........................................................................
% Calculate the mass fraction x

%let
cr = Cis1mix_Cis2mix;

%it follows that x = (Cis1host - cr*Cis2host)/(Cis1host - Cis1inc -
%cr*Cis2host + cr*Cis2inc);

x = (Cis1host - cr*Cis2host)/(Cis1host - Cis1inc - cr*Cis2host + cr*Cis2inc);
UNK(c).x = x;

%......................................................................
% MIXTURE AND SAMPLE CALCULATIONS

%now that x is defined, we can put a value on Cis2mix:
Cis2mix = (1-x)*Cis2host + x*Cis2inc;

%using intensity ratios, we can define the concentration of all elements in
%the mixed signal:
%i.e. Cimix = ((Iimix/Iis2mix)/CALIB)*Cis2mix
Cimix = ((Iimix/Iis2mix)./CALIBis2)*Cis2mix;

%now define the concentration of all elements in the inclusion based on the
%equation: Ciinc = (Cimix - (1-x)*Cihost)/x
Ciinc = (Cimix - (1-x)*Cihost)/x;
UNK(c).SAMP_CONC = Ciinc;

%declare an internal standard for the mixed signal (let this be the 1st
%internal standard);
UNK(c).MIXIS = UNK(c).SIGQIS1;
%calculate concentrations in the mixture
UNK(c).MIX_CONC = UNK(c).x*(UNK(c).SAMP_CONC) + (1-UNK(c).x)*(UNK(c).MAT_CONC);
%define calibration curves relative to the mixture's internal standard
UNK(c).MIXIS_CALIB = UNK(c).REFIS_CALIB ./ UNK(c).REFIS_CALIB(UNK(c).MIXIS);

%......................................................................
% ERROR CALCULATIONS

%Define cps errors due to counting statistics and flicker noise:
UNK(c).sigma_bg = sqrt(((sqrt((UNK(c).bg_cps_mod.*A.DT_VALUES')/UNK(c).Nbg))./A.DT_VALUES').^2 + ((UNK(c).bg_cps_mod*(A.flickernoise/100)/sqrt(UNK(c).Nbg)).*((sqrt(A.flickDT))./sqrt(A.DT_VALUES'))).^2);
UNK(c).sigma_sig = sqrt((((sqrt((UNK(c).sig_cps_mod.*A.DT_VALUES')/UNK(c).Nsig))./A.DT_VALUES')).^2 + ((UNK(c).sig_cps_mod*(A.flickernoise/100)/sqrt(UNK(c).Nsig)).*((sqrt(A.flickDT))./sqrt(A.DT_VALUES'))).^2);

%Determine the combined cps errors for the mixture
UNK(c).sigma_mix = sqrt(UNK(c).sigma_bg.^2 + UNK(c).sigma_sig.^2);

%Convert into absolute concentrations:
CALIBmix = UNK(c).MIXIS_CALIB;
Cis1mix = UNK(c).MIX_CONC(is1);
Iis1mix = UNK(c).sig_cps(is1) - UNK(c).bg_cps(is1);

UNK(c).MIX_CONC_error = (1./CALIBmix).*(Cis1mix/Iis1mix).*UNK(c).sigma_mix;

%......................................................................
% CALCULATE LOD
UNCERTAINTY_LOD_CALC

%......................................................................
% DECLARE CALCULATION SUCCESSFUL
UNK(c).matrix_correction_success = 1;


clear is1 is2 x cr
clear CALIBis2
clear Cihost Cis1host Cis2host
clear Ciinc Cis1inc Cis2inc
clear Cis1mix_Cis2mix Cimix Cis2mix
clear Iimix Iis1mix Iis2mix
clear CALIBmix Cis1mix Iis1mix








