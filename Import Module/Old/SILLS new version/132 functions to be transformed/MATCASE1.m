%MATCASE1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SUMMONED WHEN THE MATRIX IS NORMALISED TO AN INTERNAL STANDARD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%..........................................................................
%Define the count ratio, concentration ratio, and absolute concentration
UNK(c).MAT_CPS_ratio = (UNK(c).mat_cps - UNK(c).bg_cps)/(UNK(c).mat_cps(UNK(c).MATQIS) - UNK(c).bg_cps(UNK(c).MATQIS));
UNK(c).MAT_CONC_ratio = UNK(c).MAT_CPS_ratio ./ UNK(c).MATQIS_CALIB;
UNK(c).MAT_CONC = UNK(c).MAT_CONC_ratio .* UNK(c).MATQIS_conc;

%..........................................................................
% ERROR CALCULATIONS

%raw cps errors in the integration intervals due to counting statistics and flicker noise:
UNK(c).sigma_bg = sqrt(((sqrt((UNK(c).bg_cps_mod.*A.DT_VALUES')/UNK(c).Nbg))./A.DT_VALUES').^2 + ((UNK(c).bg_cps_mod*(A.flickernoise/100)/sqrt(UNK(c).Nbg)).*((sqrt(0.01))./sqrt(A.DT_VALUES'))).^2);
UNK(c).sigma_mat = sqrt(((sqrt((UNK(c).mat_cps_mod.*A.DT_VALUES')/UNK(c).Nmat))./A.DT_VALUES').^2 + ((UNK(c).mat_cps_mod*(A.flickernoise/100)/sqrt(UNK(c).Nmat)).*((sqrt(0.01))./sqrt(A.DT_VALUES'))).^2);

%combined cps errors for host region
UNK(c).sigma_MAT = sqrt(UNK(c).sigma_bg.^2 + UNK(c).sigma_mat.^2);

%convert into a concentration error:
CALIBhost = UNK(c).MATQIS_CALIB;
Cishost = UNK(c).MAT_CONC(UNK(c).MATQIS);
Iishost = UNK(c).mat_cps(UNK(c).MATQIS)-UNK(c).bg_cps(UNK(c).MATQIS);

UNK(c).MAT_CONC_error = (1./CALIBhost).*(Cishost/Iishost).*UNK(c).sigma_MAT;

clear CALIBhost Cishost Iishost

%..........................................................................
%CALCULATE LOD (3 sigma definition)
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convert results into oxides if 'Major Elements as Oxides' was selected in
% the Calculation Manager
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(A.report_settings_oxide,'on') == 1;

    if A.Fe_test == 1
        if ~isempty(UNK(c).MAT_Fe_ratio)
            f = UNK(c).MAT_Fe_ratio; %FeO/(FeO+Fe2O3) ratio
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