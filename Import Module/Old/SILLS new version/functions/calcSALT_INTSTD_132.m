%calcSALT_INTSTD
function [A, UNK, STD, SRM, SMAN] = calcSALT_INTSTD_132(A, UNK, STD, SRM, SMAN, c)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SUMMONED WHEN THERE IS A) A MATRIX CORRECTION, B) A SALINITY
%NORMALISATION, AND B) AN INTENRAL STANDARD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define constants for the following calculations:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

is = UNK(c).SIGQIS2;
Na = A.Na_index;
Cisinc = UNK(c).SIGQIS2_conc;
Cishost = UNK(c).MAT_CONC(is);
Cihost = UNK(c).MAT_CONC;
Iimix = UNK(c).sig_cps - UNK(c).bg_cps;
INamix = UNK(c).sig_cps(Na) - UNK(c).bg_cps(Na);

NaClequiv = UNK(c).SIGsalinity;

%define the CALIB matrix:
CALIB_Na = UNK(c).REFIS_CALIB ./ UNK(c).REFIS_CALIB(Na);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOLVE FOR x
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%..........................................................................
%TEST CONSTRAINT: x* = 0.0001

x_star = 0.0001;
NaClequiv_mix_0001 = (1-x_star)*NaClequiv_mat + x_star*NaClequiv;
conc_ratio_mix_0001 = (Iimix/INamix)./CALIB_Na;

%determine Cimix_0001 from salinity and conc. ratios

if UNK(c).SIG_constraint1 == 2 %i.e. equiv. wt.% NaCl (mass balance);
    for b = 1:UNK(c).salt_num
        MWX = A.Chlorides_mol_wts(UNK(c).chloride_index(b),1);
        MWXCl = A.Chlorides_mol_wts(UNK(c).chloride_index(b),2);
        conc_ratio_condensed_mix_0001(b) = conc_ratio_mix_0001(UNK(c).salt_index(b));

        clear temp1
        temp1 = find(conc_ratio_condensed_mix_0001 < 0);
        conc_ratio_condensed_mix_0001(temp1) = 0;
        clear temp1
        
        chloride_conc_ratio_mix_0001(b) = conc_ratio_condensed_mix_0001(b)*(MWNa/MWX)*(MWXCl/MWNaCl);
    end
    seekdestroy = find(chloride_conc_ratio_mix_0001 == 1);
    chloride_conc_ratio_mix_0001(seekdestroy) = [];
    CNamix_equiv_0001 = NaClequiv_mix_0001*10000*(MWNa/MWNaCl);
    CNamix_0001 = CNamix_equiv_0001/(1+UNK(c).SALT_mass_balance_factor*sum(chloride_conc_ratio_mix_0001));

elseif UNK(c).SIG_constraint1 == 3 %i.e. equiv. wt.% NaCl (charge balance)
    for b = 1:UNK(c).salt_num
        n = A.Chlorides_mol_wts(UNK(c).chloride_index(b),3);
        MWX = A.Chlorides_mol_wts(UNK(c).chloride_index(b),1);
        conc_ratio_condensed_mix_0001(b) = conc_ratio_mix_0001(UNK(c).salt_index(b));

        clear temp1
        temp1 = find(conc_ratio_condensed_mix_0001 < 0);
        conc_ratio_condensed_mix_0001(temp1) = 0;
        clear temp1
        
        sig_MOLAR_ratio_mix_0001(b) = n*conc_ratio_condensed_mix_0001(b)*(MWNa/MWX);
    end
    seekdestroy = find(sig_MOLAR_ratio_mix_0001 == 1);
    sig_MOLAR_ratio_mix_0001(seekdestroy) = [];
    mClmix_0001 = NaClequiv_mix_0001*10/MWNaCl;
    mNamix_0001 = mClmix_0001/(1+sum(sig_MOLAR_ratio_mix_0001));
    
    CNamix_0001 = mNamix_0001*MWNa*1000;
end
    Cimix_0001 = conc_ratio_mix_0001*CNamix_0001;
    Ciinc_0001 = Cihost - (Cihost-Cimix_0001)/x_star;
    Cisinc_0001 = Ciinc_0001(is);

%..........................................................................
%TEST CONSTRAINT: x* = 1

x_star = 1;
NaClequiv_mix_1 = (1-x_star)*NaClequiv_mat + x_star*NaClequiv;
conc_ratio_mix_1 = (Iimix/INamix)./CALIB_Na;

%determine Cimix_1 from salinity and conc. ratios

if UNK(c).SIG_constraint1 == 2 %i.e. equiv. wt.% NaCl (mass balance);
    for b = 1:UNK(c).salt_num
        MWX = A.Chlorides_mol_wts(UNK(c).chloride_index(b),1);
        MWXCl = A.Chlorides_mol_wts(UNK(c).chloride_index(b),2);
        conc_ratio_condensed_mix_1(b) = conc_ratio_mix_1(UNK(c).salt_index(b));
        
        clear temp1
        temp1 = find(conc_ratio_condensed_mix_1 < 0);
        conc_ratio_condensed_mix_1(temp1) = 0;
        clear temp1
        
        chloride_conc_ratio_mix_1(b) = conc_ratio_condensed_mix_1(b)*(MWNa/MWX)*(MWXCl/MWNaCl);
    end
    seekdestroy = find(chloride_conc_ratio_mix_1 == 1);
    chloride_conc_ratio_mix_1(seekdestroy) = [];
    CNamix_equiv_1 = NaClequiv_mix_1*10000*(MWNa/MWNaCl);
    CNamix_1 = CNamix_equiv_1/(1+UNK(c).SALT_mass_balance_factor*sum(chloride_conc_ratio_mix_1));

elseif UNK(c).SIG_constraint1 == 3 %i.e. equiv. wt.% NaCl (charge balance)
    for b = 1:UNK(c).salt_num
        n = A.Chlorides_mol_wts(UNK(c).chloride_index(b),3);
        MWX = A.Chlorides_mol_wts(UNK(c).chloride_index(b),1);
        conc_ratio_condensed_mix_1(b) = conc_ratio_mix_1(UNK(c).salt_index(b));
        
        clear temp1
        temp1 = find(conc_ratio_condensed_mix_1 < 0);
        conc_ratio_condensed_mix_1(temp1) = 0;
        clear temp1
        
        sig_MOLAR_ratio_mix_1(b) = n*conc_ratio_condensed_mix_1(b)*(MWNa/MWX);
    end
    seekdestroy = find(sig_MOLAR_ratio_mix_1 == 1);
    sig_MOLAR_ratio_mix_1(seekdestroy) = [];
    mClmix_1 = NaClequiv_mix_1*10/MWNaCl;
    mNamix_1 = mClmix_1/(1+sum(sig_MOLAR_ratio_mix_1));
    
    CNamix_1 = mNamix_1*MWNa*1000;
end
    Cimix_1 = conc_ratio_mix_1*CNamix_1;
    Ciinc_1 = Cihost - (Cihost-Cimix_1)/x_star;
    Cisinc_1 = Ciinc_1(is);
    
%..........................................................................
%determine the slopes of Cisinc* = f(x*) 

if Cisinc_0001 < Cisinc_1
    slope = 1; %positive
else
    slope = -1; %negative
end

%..........................................................................
%test the constraint on the salinity

if Cisinc > max(Cisinc_0001,Cisinc_1) || Cisinc < min(Cisinc_0001,Cisinc_1)
        UNK(c).matrix_correction_success = 0;
        return
end

%..........................................................................
%Now that the internal standard has been approved as an
%allowable value, define an arbitrary mixing ratio 'xstar' (x*),
%where x* is defined as: x = (Cihost - Cimix)/(Cihost - Ciinc)

x_0=0; %lower limit
x_1=1; %upper limit

%INITIAL CONDITIONS: x = 0.5...........................................
x_star = 0.5;
NaClequiv_mix_star = (1-x_star)*NaClequiv_mat + x_star*NaClequiv;
conc_ratio_mix_star = (Iimix/INamix)./CALIB_Na;

%determine Cimix_star from salinity and conc. ratios

if UNK(c).SIG_constraint1 == 2 %i.e. equiv. wt.% NaCl (mass balance);
    for b = 1:UNK(c).salt_num
        MWX = A.Chlorides_mol_wts(UNK(c).chloride_index(b),1);
        MWXCl = A.Chlorides_mol_wts(UNK(c).chloride_index(b),2);
        conc_ratio_condensed_mix_star(b) = conc_ratio_mix_star(UNK(c).salt_index(b));
        
        clear temp1
        temp1 = find(conc_ratio_condensed_mix_star < 0);
        conc_ratio_condensed_mix_star(temp1) = 0;
        clear temp1
        
        chloride_conc_ratio_mix_star(b) = conc_ratio_condensed_mix_star(b)*(MWNa/MWX)*(MWXCl/MWNaCl);
    end
    seekdestroy = find(chloride_conc_ratio_mix_star == 1);
    chloride_conc_ratio_mix_star(seekdestroy) = [];
    CNamix_equiv_star = NaClequiv_mix_star*10000*(MWNa/MWNaCl);
    CNamix_star = CNamix_equiv_star/(1+UNK(c).SALT_mass_balance_factor*sum(chloride_conc_ratio_mix_star));

elseif UNK(c).SIG_constraint1 == 3 %i.e. equiv. wt.% NaCl (charge balance)
    for b = 1:UNK(c).salt_num
        n = A.Chlorides_mol_wts(UNK(c).chloride_index(b),3);
        MWX = A.Chlorides_mol_wts(UNK(c).chloride_index(b),1);
        conc_ratio_condensed_mix_star(b) = conc_ratio_mix_star(UNK(c).salt_index(b));
        
        clear temp1
        temp1 = find(conc_ratio_condensed_mix_star < 0);
        conc_ratio_condensed_mix_star(temp1) = 0;
        clear temp1
        
        sig_MOLAR_ratio_mix_star(b) = n*conc_ratio_condensed_mix_star(b)*(MWNa/MWX);
    end
    seekdestroy = find(sig_MOLAR_ratio_mix_star == 1);
    sig_MOLAR_ratio_mix_star(seekdestroy) = [];
    mClmix_star = NaClequiv_mix_star*10/MWNaCl;
    mNamix_star = mClmix_star/(1+sum(sig_MOLAR_ratio_mix_star));
    
    CNamix_star = mNamix_star*MWNa*1000;
end
    Cimix_star = conc_ratio_mix_star*CNamix_star;
    Ciinc_star = Cihost - (Cihost-Cimix_star)/x_star;
    Cisinc_star = Ciinc_star(is);
   

eps0 = 0.0001;
eps = abs((Cisinc_star - Cisinc)/Cisinc);
k = 0;

%..........................................................................
%TEST THE CONSTRAINT FOR THE CORRECT VALUE OF x_star
while eps > eps0
    
NaClequiv_mix_star = (1-x_star)*NaClequiv_mat + x_star*NaClequiv;
conc_ratio_mix_star = (Iimix/INamix)./CALIB_Na;

%determine Cimix_star from salinity and conc. ratios

if UNK(c).SIG_constraint1 == 2 %i.e. equiv. wt.% NaCl (mass balance);
    for b = 1:UNK(c).salt_num
        MWX = A.Chlorides_mol_wts(UNK(c).chloride_index(b),1);
        MWXCl = A.Chlorides_mol_wts(UNK(c).chloride_index(b),2);
        conc_ratio_condensed_mix_star(b) = conc_ratio_mix_star(UNK(c).salt_index(b));
        
        clear temp1
        temp1 = find(conc_ratio_condensed_mix_star < 0);
        conc_ratio_condensed_mix_star(temp1) = 0;
        clear temp1
        
        chloride_conc_ratio_mix_star(b) = conc_ratio_condensed_mix_star(b)*(MWNa/MWX)*(MWXCl/MWNaCl);
    end
    seekdestroy = find(chloride_conc_ratio_mix_star == 1);
    chloride_conc_ratio_mix_star(seekdestroy) = [];
    CNamix_equiv_star = NaClequiv_mix_star*10000*(MWNa/MWNaCl);
    CNamix_star = CNamix_equiv_star/(1+UNK(c).SALT_mass_balance_factor*sum(chloride_conc_ratio_mix_star));

elseif UNK(c).SIG_constraint1 == 3 %i.e. equiv. wt.% NaCl (charge balance)
    for b = 1:UNK(c).salt_num
        n = A.Chlorides_mol_wts(UNK(c).chloride_index(b),3);
        MWX = A.Chlorides_mol_wts(UNK(c).chloride_index(b),1);
        conc_ratio_condensed_mix_star(b) = conc_ratio_mix_star(UNK(c).salt_index(b));
        
        clear temp1
        temp1 = find(conc_ratio_condensed_mix_star < 0);
        conc_ratio_condensed_mix_star(temp1) = 0;
        clear temp1
        
        sig_MOLAR_ratio_mix_star(b) = n*conc_ratio_condensed_mix_star(b)*(MWNa/MWX);
    end
    seekdestroy = find(sig_MOLAR_ratio_mix_star == 1);
    sig_MOLAR_ratio_mix_star(seekdestroy) = [];
    mClmix_star = NaClequiv_mix_star*10/MWNaCl;
    mNamix_star = mClmix_star/(1+sum(sig_MOLAR_ratio_mix_star));
    
    CNamix_star = mNamix_star*MWNa*1000;
end
    Cimix_star = conc_ratio_mix_star*CNamix_star;
    Ciinc_star = Cihost - (Cihost-Cimix_star)/x_star;
    Cisinc_star = Ciinc_star(is);

    if slope == 1 %positive slope
        if  Cisinc_star < Cisinc
            x_0 = x_star;
        else
            x_1 = x_star;
        end
    else
        if Cisinc_star < Cisinc
            x_1 = x_star;
        else
            x_0 = x_star;
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







    