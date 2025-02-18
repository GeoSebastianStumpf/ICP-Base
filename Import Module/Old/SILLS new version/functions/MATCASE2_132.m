%MATCASE2
function [A, UNK, STD, SRM, SMAN] = MATCASE2_132(A, UNK, STD, SRM, SMAN, c)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SUMMONED WHEN THE MATRIX IS NORMALISED TO TOTAL OXIDES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate arbitrary masses (correct in a relative sense)
% and convert into oxide masses (organised as: SiO2, TiO2, Al2O3,
% Fe2O3, FeO, MnO, MgO, CaO, Na2O, K2O, P2O5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


UNK(c).MATOXIDE = zeros(11,6); %11 major oxides, 6 categories of data

%..................................................................
%COLUMN 1: index of the isotope corresponding to given oxide
UNK(c).MATOXIDE(:,1) = A.Oxides_index;

%..................................................................
%select an internal standard for this calculation (let this be the
%isotope with the greatest I(mat) - I(bg) difference:
for b = 1:11
    if UNK(c).MATOXIDE(b,1) ~= 0;
        m(b) = UNK(c).mat_cps(UNK(c).MATOXIDE(b,1));
        bg(b) = UNK(c).bg_cps(UNK(c).MATOXIDE(b,1));
    else
        m(b) = 0;
        bg(b) = 0;
    end
    difference(b) = m(b)-bg(b);
end

%define the internal standard
clear temp1
temp1 = find(difference(b)==max(difference(b)));
UNK(c).MATQIS = UNK(c).MATOXIDE(temp1);

%create an arbitrary CALIB matrix for the purpose of casting cps in concs.
UNK(c).MATQIS_CALIB = UNK(c).REFIS_CALIB ./ UNK(c).REFIS_CALIB(UNK(c).MATQIS);

%..................................................................
%continue populating the MATOXIDE matrix:

for d=1:11
    if UNK(c).MATOXIDE(d,1) ~= 0 %i.e. that oxide element was analysed
        %COLUMN 2: bg-corrected matrix counts
        UNK(c).MATOXIDE(d,2) = UNK(c).mat_cps(UNK(c).MATOXIDE(d,1)) - UNK(c).bg_cps(UNK(c).MATOXIDE(d,1));
        
        %do not accept negative count rates
        if UNK(c).MATOXIDE(d,2) < 0
            UNK(c).MATOXIDE(d,2) = 0;
        end
        
        %COLUMN 3: arbitrary set of relative concentrations
        UNK(c).MATOXIDE(d,3) = UNK(c).MATOXIDE(d,2)./UNK(c).MATQIS_CALIB(UNK(c).MATOXIDE(d,1));
    else
        continue
    end
end

if A.Fe_test == 1             %i.e. there is Fe in the list
    if isempty(UNK(c).MAT_Fe_ratio)
        UNK(c).MAT_Fe_ratio = 0;
    end
    a = UNK(c).MAT_Fe_ratio; %the user-defined FeO /(FeO + Fe2O3) ratio
    %cast into the appropriate Fe2+ and Fe3+ concentrations
    UNK(c).MATOXIDE(4,3) = UNK(c).MATOXIDE(4,3)*(1-(1/(1+(0.699480/0.777314)*((1-a)/a))));
    UNK(c).MATOXIDE(5,3) = UNK(c).MATOXIDE(5,3)*(1/(1+(0.699480/0.777314)*((1-a)/a)));
end

%COLUMN 4: convert arbitrary element concentrations into arbitary
%oxide concentrations, e.g.

%[SiO2] = ([Si] / MW Si) * (1 mol SiO2 / 1 mol Si) * MW SiO2

UNK(c).MATOXIDE(:,4) = UNK(c).MATOXIDE(:,3)./A.Oxides_mol_wts(:,1)./A.Oxides_mol_wts(:,3).*A.Oxides_mol_wts(:,2);

clear temp1 temp2 temp3 temp4 temp5 temp6
temp1 = sum(UNK(c).MATOXIDE(:,4));  %total oxide mass
temp2 = UNK(c).MAT_oxide_total / temp1; %scale factor

%COLUMN 5: correct oxide concentrations
UNK(c).MATOXIDE(:,5) = UNK(c).MATOXIDE(:,4)*temp2;

%calculate correct concentrations for all elements (in ug/g)
UNK(c).MAT_CONC = (((UNK(c).mat_cps - UNK(c).bg_cps)./UNK(c).MATQIS_CALIB)*temp2)*10000;

%..................................................................
%ERROR CALCULATIONS

%raw cps errors in the integration intervals due to counting statistics and flicker noise:
UNK(c).sigma_bg = sqrt(((sqrt((UNK(c).bg_cps_mod.*A.DT_VALUES')/UNK(c).Nbg))./A.DT_VALUES').^2 + ((UNK(c).bg_cps_mod*(A.flickernoise/100)/sqrt(UNK(c).Nbg)).*((sqrt(0.01))./sqrt(A.DT_VALUES'))).^2);
UNK(c).sigma_mat = sqrt(((sqrt((UNK(c).mat_cps_mod.*A.DT_VALUES')/UNK(c).Nmat))./A.DT_VALUES').^2 + ((UNK(c).mat_cps_mod*(A.flickernoise/100)/sqrt(UNK(c).Nmat)).*((sqrt(0.01))./sqrt(A.DT_VALUES'))).^2);

%combined cps errors for host region:
UNK(c).sigma_MAT = sqrt(UNK(c).sigma_bg.^2 + UNK(c).sigma_mat.^2);

%convert into an absolute concentration:
CALIBhost = UNK(c).MATQIS_CALIB;
Cishost = UNK(c).MAT_CONC(UNK(c).MATQIS);
Iishost = UNK(c).mat_cps(UNK(c).MATQIS)-UNK(c).bg_cps(UNK(c).MATQIS);

UNK(c).MAT_CONC_error = (1./CALIBhost).*(Cishost/Iishost).*UNK(c).sigma_MAT;

clear CALIBhost Cishost Iishost

clear a temp temp1 temp2 temp3 temp4 alpha oxide_seek oxide_seek2 oxide_seek_index oxide_seek_num

%..................................................................
% CALCULATE LOD
%Added two methods in 1.3.2
if strcmp(A.LODmethod,'Longerich')==1
    UNK(c).MAT_LOD_mn = A.LODff .* UNK(c).BG_stdev*sqrt(1/UNK(c).Nbg + 1/UNK(c).Nmat)./UNK(c).MATQIS_CALIB.*(UNK(c).MAT_CONC(UNK(c).MATQIS)/(UNK(c).mat_cps(UNK(c).MATQIS)-UNK(c).bg_cps(UNK(c).MATQIS)));
    UNK(c).MAT_LOD_mm = A.LODff .* UNK(c).BG_stdev*sqrt(2/UNK(c).Nmat)./UNK(c).MATQIS_CALIB.*(UNK(c).MAT_CONC(UNK(c).MATQIS)/(UNK(c).mat_cps(UNK(c).MATQIS)-UNK(c).bg_cps(UNK(c).MATQIS)));
    
    % Added by MG 28.3.2012
elseif strcmp(A.LODmethod,'Pettke')==1
    UNK(c).MAT_LOD_mn = (((sqrt((A.DT_VALUES').*UNK(c).bg_cps* UNK(c).Nmat*(1+UNK(c).Nmat/UNK(c).Nbg))*3.29+2.71)./(A.DT_VALUES'))./(UNK(c).Nmat))./UNK(c).MATQIS_CALIB.*(UNK(c).MAT_CONC(UNK(c).MATQIS)/(UNK(c).mat_cps(UNK(c).MATQIS)-UNK(c).bg_cps(UNK(c).MATQIS))); %calculated after discussion with Pettke and Felix, see paper!
end
% Is Equation 6 in Paper: Ore Geology Reviews 44 (2012) 10–38

% stopp Added by MG 


clear bg difference

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convert results into oxides if 'Major Elements as Oxides' was selected in
% the Calculation Manager
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(A.report_settings_oxide,'on') == 1;

    if A.Fe_test == 1
        f = UNK(c).MAT_Fe_ratio; %FeO/(FeO+Fe2O3) ratio
        %define the Fe2+/(Fe2+ + Fe3+) ratio
        x = 1/(1+(0.699480/0.777314)*((1-f)/f));
        clear f
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
                UNK(c).MAT_CONC_majox(d) = (1-x)*(UNK(c).MAT_CONC(a)/1e4)*(MWoxide/(stoich*MWelement));
                UNK(c).MAT_CONC_error_majox(d) = (1-x)*(UNK(c).MAT_CONC_error(a)/1e4)*(MWoxide/(stoich*MWelement));
                UNK(c).MAT_LOD_mn_majox(d) = (1-x)*(UNK(c).MAT_LOD_mn(a)/1e4)*(MWoxide/(stoich*MWelement));
                UNK(c).MAT_LOD_mm_majox(d) = (1-x)*(UNK(c).MAT_LOD_mm(a)/1e4)*(MWoxide/(stoich*MWelement));

            elseif Fe_hits == 2
                MWelement = A.Oxides_measured_mol_wts(5,1);
                MWoxide =   A.Oxides_measured_mol_wts(5,2);
                stoich =    A.Oxides_measured_mol_wts(5,3);
                UNK(c).MAT_CONC_majox(d) = x*(UNK(c).MAT_CONC(a)/1e4)*(MWoxide/(stoich*MWelement));
                UNK(c).MAT_CONC_error_majox(d) = x*(UNK(c).MAT_CONC_error(a)/1e4)*(MWoxide/(stoich*MWelement));
                UNK(c).MAT_LOD_mn_majox(d) = x*(UNK(c).MAT_LOD_mn(a)/1e4)*(MWoxide/(stoich*MWelement));
                UNK(c).MAT_LOD_mm_majox(d) = x*(UNK(c).MAT_LOD_mm(a)/1e4)*(MWoxide/(stoich*MWelement));
            end
        else
            MWelement = A.Oxides_measured_mol_wts(d,1);
            MWoxide =   A.Oxides_measured_mol_wts(d,2);
            stoich =    A.Oxides_measured_mol_wts(d,3);
            UNK(c).MAT_CONC_majox(d) = (UNK(c).MAT_CONC(a)/1e4)*(MWoxide/(stoich*MWelement));
            UNK(c).MAT_CONC_error_majox(d) = (UNK(c).MAT_CONC_error(a)/1e4)*(MWoxide/(stoich*MWelement));
            UNK(c).MAT_LOD_mn_majox(d) = (UNK(c).MAT_LOD_mn(a)/1e4)*(MWoxide/(stoich*MWelement));
            UNK(c).MAT_LOD_mm_majox(d) = (UNK(c).MAT_LOD_mm(a)/1e4)*(MWoxide/(stoich*MWelement));
        end
    end
    clear Fe_hits

    %distill trace element results
    UNK(c).MAT_CONC_trace = UNK(c).MAT_CONC(A.Trace_index);
    UNK(c).MAT_CONC_error_trace = UNK(c).MAT_CONC_error(A.Trace_index);
    UNK(c).MAT_LOD_mn_trace = UNK(c).MAT_LOD_mn(A.Trace_index);
    UNK(c).MAT_LOD_mm_trace = UNK(c).MAT_LOD_mm(A.Trace_index);

    clear a MWelement MWoxide stoich
    
end
end