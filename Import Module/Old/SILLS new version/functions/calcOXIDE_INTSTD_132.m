%calcOXIDE_INTSTD
function [A, UNK, STD, SRM, SMAN] = calcOXIDE_INTSTD_132(A, UNK, STD, SRM, SMAN, c)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SUMMONED WHEN THERE IS A) A MATRIX CORRECTION PROCEDURE, B) OXIDE
%NORMALISATION AND C) AN INTERNAL STANDARD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define constants for the following calculations:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
is = UNK(c).SIGQIS2;
Cisinc = UNK(c).SIGQIS2_conc;
Cihost = UNK(c).MAT_CONC;
Oxide_inc = UNK(c).SIG_oxide_total;
Iimix = UNK(c).sig_cps - UNK(c).bg_cps;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Determine which elements are major oxides
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
UNK(c).MIXOXIDE = zeros(11,6); %11 major oxides, 6 categories of data

for b=1:A.ELEMENT_num
    oxide_seek(:,b) = strcmp(A.Oxides(:,1),A.ELEMENT_list(b));
end
oxide_seek2 = sum(oxide_seek);
oxide_seek_index = find(oxide_seek2 > 0);    %indices of the major oxide isotopes
oxide_seek_num = size(oxide_seek_index);
oxide_seek_num = oxide_seek_num(2);

for d=1:11
    %COLUMN 1: index of the isotope corresponding to given oxide
    a = find(oxide_seek(d,:)==1);
    if isempty(a)
        a = 0;
    end
    
    UNK(c).MIXOXIDE(d,1) = a;
end

%..........................................................................
%define an internal standard for the mixture (the most intense signal)
for b = 1:11
    if UNK(c).MIXOXIDE(b,1) ~= 0 
        m(b) = UNK(c).mat_cps(UNK(c).MIXOXIDE(b,1));
        bg(b) = UNK(c).bg_cps(UNK(c).MIXOXIDE(b,1));
    else
        m(b) = 0;
        bg(b) = 0;
    end
    difference(b) = m(b)-bg(b);
end

%define the internal standard
clear temp1
temp1 = find(difference(b)==max(difference(b)));
UNK(c).SIGOXIS = UNK(c).MIXOXIDE(temp1);

%Account for the case Fe is the maximum signal and there are two oxides
%Added in 1.0.2
if length(UNK(c).SIGOXIS) > 1
    UNK(c).SIGOXIS = UNK(c).SIGOXIS(1);
end

CALIB_oxis = UNK(c).REFIS_CALIB ./ UNK(c).REFIS_CALIB(UNK(c).SIGOXIS);
Ioxismix = UNK(c).sig_cps(UNK(c).SIGOXIS) - UNK(c).bg_cps(UNK(c).SIGOXIS);
conc_ratio_mix = (Iimix/Ioxismix)./CALIB_oxis;

for b = 1:11
    if UNK(c).MIXOXIDE(b,1) ~= 0 %Condition added in 1.2.0
    conc_ratio_mix_condensed(b) = conc_ratio_mix(UNK(c).MIXOXIDE(b,1));
    else
        conc_ratio_mix_condensed(b) = 0;
    end
end

%remove any oxide element ratios that are negative
clear temp1
temp1 = find(conc_ratio_mix_condensed < 0);
conc_ratio_mix_condensed(temp1) = 0;
clear temp1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOLVE FOR x
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%..........................................................................
%TEST CONSTRAINT: x* = 0.0001

x_star = 0.0001;
Oxide_mix_0001 = (1-x_star)*Oxide_mat + x_star*Oxide_inc;


if A.Fe_test == 1             %i.e. there is Fe in the list
    if isempty(UNK(c).SIG_Fe_ratio)
        UNK(c).SIG_Fe_ratio = 0;
    end
    a = UNK(c).SIG_Fe_ratio; %the user-defined FeO /(FeO + Fe2O3) ratio
    %cast into the appropriate Fe2+/oxis and Fe3+/oxis conc. ratios
    conc_ratio_mix_condensed(4) = conc_ratio_mix_condensed(4)*(1-(1/(1+(0.699480/0.777314)*((1-a)/a))));
    conc_ratio_mix_condensed(5) = conc_ratio_mix_condensed(5)*(1/(1+(0.699480/0.777314)*((1-a)/a)));
end

%convert conc. ratios into arbitary oxide concentrations:
oxide_conc_arb_mix = conc_ratio_mix_condensed'./A.Oxides_mol_wts(:,1)./A.Oxides_mol_wts(:,3).*A.Oxides_mol_wts(:,2);
Coxidemix_0001 = oxide_conc_arb_mix*(Oxide_mix_0001/sum(oxide_conc_arb_mix));
%calculate correct concentrations for all elements (in ug/g)
Cimix_0001 = conc_ratio_mix*(Oxide_mix_0001/sum(oxide_conc_arb_mix))*10000;

Ciinc_0001 = Cihost - (Cihost-Cimix_0001)/x_star;
Cisinc_0001 = Ciinc_0001(is);

%..........................................................................
%TEST CONSTRAINT: x* = 1

x_star = 1;
Oxide_mix_1 = (1-x_star)*Oxide_mat + x_star*Oxide_inc;

if A.Fe_test == 1             %i.e. there is Fe in the list
    if isempty(UNK(c).SIG_Fe_ratio)
        UNK(c).SIG_Fe_ratio = 0;
    end
    a = UNK(c).SIG_Fe_ratio; %the user-defined FeO /(FeO + Fe2O3) ratio
    %cast into the appropriate Fe2+/oxis and Fe3+/oxis conc. ratios
    conc_ratio_mix_condensed(4) = conc_ratio_mix_condensed(4)*(1-(1/(1+(0.699480/0.777314)*((1-a)/a))));
    conc_ratio_mix_condensed(5) = conc_ratio_mix_condensed(5)*(1/(1+(0.699480/0.777314)*((1-a)/a)));
end

%convert conc. ratios into arbitary oxide concentrations:
oxide_conc_arb_mix = conc_ratio_mix_condensed'./A.Oxides_mol_wts(:,1)./A.Oxides_mol_wts(:,3).*A.Oxides_mol_wts(:,2);
Coxidemix_1 = oxide_conc_arb_mix*(Oxide_mix_1/sum(oxide_conc_arb_mix));
%calculate correct concentrations for all elements (in ug/g)
Cimix_1 = conc_ratio_mix*(Oxide_mix_1/sum(oxide_conc_arb_mix))*10000;
Ciinc_1 = Cihost - (Cihost-Cimix_1)/x_star;
Cisinc_1 = Ciinc_1(is);

%..........................................................................
%test slope of Cismix* = f(x*);

if Cisinc_0001 < Cisinc_1
    slope = 1; %positive
else
    slope = -1; %negative
end

%..........................................................................
%test the constraint on the second internal standard
if Cisinc < min(Cisinc_0001,Cisinc_1) || Cisinc > max(Cisinc_0001,Cisinc_1)
    UNK(c).matrix_correction_success = 0;
    return
end

%..........................................................................
%Now that the internal standard has been approved as an
%allowable value, define an arbitrary mixing ratio 'xstar' (x*),
%where x* is defined as: x = (Cihost - Cimix)/(Cihost - Ciinc)

%where is = internal standard; i = ith element
x_0=0; %lower limit
x_1=1; %upper limit
x_star = 0.5; %initial choice of x

Oxide_mix_star = (1-x_star)*Oxide_mat + x_star*Oxide_inc;

if A.Fe_test == 1             %i.e. there is Fe in the list
    if isempty(UNK(c).SIG_Fe_ratio)
        UNK(c).SIG_Fe_ratio = 0;
    end
    a = UNK(c).SIG_Fe_ratio; %the user-defined FeO /(FeO + Fe2O3) ratio
    %cast into the appropriate Fe2+/oxis and Fe3+/oxis conc. ratios
    conc_ratio_mix_condensed(4) = conc_ratio_mix_condensed(4)*(1-(1/(1+(0.699480/0.777314)*((1-a)/a))));
    conc_ratio_mix_condensed(5) = conc_ratio_mix_condensed(5)*(1/(1+(0.699480/0.777314)*((1-a)/a)));
end

%convert conc. ratios into arbitary oxide concentrations:
oxide_conc_arb_mix = conc_ratio_mix_condensed'./A.Oxides_mol_wts(:,1)./A.Oxides_mol_wts(:,3).*A.Oxides_mol_wts(:,2);
Coxidemix_star = oxide_conc_arb_mix*(Oxide_mix_star/sum(oxide_conc_arb_mix));
%calculate correct concentrations for all elements (in ug/g)
Cimix_star = conc_ratio_mix*(Oxide_mix_star/sum(oxide_conc_arb_mix))*10000;
Ciinc_star = Cihost - (Cihost-Cimix_star)/x_star;
Cisinc_star = Ciinc_star(is);

eps0 = 0.0001; %resolution of x
eps = abs((Cisinc_star - Cisinc)/Cisinc);
k = 0;

%..........................................................................
%TEST THE CONSTRAINT FOR THE CORRECT VALUE OF x_star
while eps > eps0

    Oxide_mix_star = (1-x_star)*Oxide_mat + x_star*Oxide_inc;

    if A.Fe_test == 1             %i.e. there is Fe in the list
        if isempty(UNK(c).SIG_Fe_ratio)
            UNK(c).SIG_Fe_ratio = 0;
        end
        a = UNK(c).SIG_Fe_ratio; %the user-defined FeO /(FeO + Fe2O3) ratio
        %cast into the appropriate Fe2+/oxis and Fe3+/oxis conc. ratios
        conc_ratio_mix_condensed(4) = conc_ratio_mix_condensed(4)*(1-(1/(1+(0.699480/0.777314)*((1-a)/a))));
        conc_ratio_mix_condensed(5) = conc_ratio_mix_condensed(5)*(1/(1+(0.699480/0.777314)*((1-a)/a)));
    end

    %convert conc. ratios into arbitary oxide concentrations:
    oxide_conc_arb_mix = conc_ratio_mix_condensed'./A.Oxides_mol_wts(:,1)./A.Oxides_mol_wts(:,3).*A.Oxides_mol_wts(:,2);
    Coxidemix_star = oxide_conc_arb_mix*(Oxide_mix_star/sum(oxide_conc_arb_mix));
    %calculate correct concentrations for all elements (in ug/g)
    Cimix_star = conc_ratio_mix*(Oxide_mix_star/sum(oxide_conc_arb_mix))*10000;
    Ciinc_star = Cihost - (Cihost-Cimix_star)/x_star;
    Cisinc_star = Ciinc_star(is);

    if slope == 1
        if  Cisinc_star > Cisinc
            x_1 = x_star;
        else
            x_0 = x_star;
        end
    else
        if Cisinc_star > Cisinc
            x_0 = x_star;
        else
            x_1 = x_star;
        end
    end

    % change x_star to the mean of the new boundary conditions
    x_star = (x_0 + x_1)/2;

    eps = abs((Cisinc_star - Cisinc)/Cisinc);

    k = k+1;

    if k == 100
        UNK(c).matrix_correction_success = 0;
        return
    end
end

UNK(c).x = x_star;
UNK(c).SAMP_CONC = Ciinc_star;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%..........................................................................
% MIXED SIGNAL CALCULATIONS

%define concentrations of the mixed signal:
clear temp1
temp1 = UNK(c).sig_cps - UNK(c).bg_cps;
UNK(c).MIXIS = find(temp1==max(temp1));
clear temp1

UNK(c).MIX_CONC = UNK(c).x*(UNK(c).SAMP_CONC) + (1-UNK(c).x)*(UNK(c).MAT_CONC);
UNK(c).MIXIS_CALIB = UNK(c).REFIS_CALIB ./ UNK(c).REFIS_CALIB(UNK(c).MIXIS);

%......................................................................
% ERROR CALCULATIONS

%Define cps errors due to counting statistics and flicker noise:
UNK(c).sigma_bg = sqrt(((sqrt((UNK(c).bg_cps_mod.*A.DT_VALUES')/UNK(c).Nbg))./A.DT_VALUES').^2 + ((UNK(c).bg_cps_mod*(A.flickernoise/100)/sqrt(UNK(c).Nbg)).*((sqrt(A.flickDT))./sqrt(A.DT_VALUES'))).^2);
UNK(c).sigma_sig = sqrt((((sqrt((UNK(c).sig_cps_mod.*A.DT_VALUES')/UNK(c).Nsig))./A.DT_VALUES')).^2 + ((UNK(c).sig_cps_mod*(A.flickernoise/100)/sqrt(UNK(c).Nsig)).*((sqrt(A.flickDT))./sqrt(A.DT_VALUES'))).^2);

%Determine the combined cps errors for the mixture
UNK(c).sigma_mix = sqrt(UNK(c).sigma_bg.^2 + UNK(c).sigma_sig.^2);

%Convert into absolute concentrations:
is = UNK(c).MIXIS;
CALIBmix = UNK(c).MIXIS_CALIB;
Cismix = UNK(c).MIX_CONC(is);
Iismix = UNK(c).sig_cps(is) - UNK(c).bg_cps(is);

UNK(c).MIX_CONC_error = (1./CALIBmix).*(Cismix/Iismix).*UNK(c).sigma_mix;

%......................................................................
% CALCULATE LOD
[A, UNK, STD, SRM, SMAN] = UNCERTAINTY_LOD_CALC_132(A, UNK, STD, SRM, SMAN, c);

%......................................................................
% DECLARE CALCULATION SUCCESSFUL
UNK(c).matrix_correction_success = 1;

end
