%UNCERTAINTY_LOD_CALC;
%define uncertainty in the mixed signal

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBSTITUTIONAL VARIABLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%first define the internal standard for the calculations
if UNK(c).SIG_constraint1 == 1 %an internal standard;
    is = UNK(c).SIGQIS1;
elseif UNK(c).SIG_constraint1 == 2 || UNK(c).SIG_constraint1 == 3 %salinity standardisation
    is = A.Na_index;
elseif UNK(c).SIG_constraint1 == 4; %total oxides
    is = UNK(c).SIGOXIS;
end

CALIBis = UNK(c).REFIS_CALIB ./ UNK(c).REFIS_CALIB(is);

Iib = UNK(c).bg_cps_mod;
Iihost = UNK(c).mat_cps_mod - UNK(c).bg_cps_mod;
Iimix = UNK(c).sig_cps_mod - UNK(c).bg_cps;
%Iisamp = UNK(c).samp_cps; %Added in 1.0.6

x = UNK(c).x;
Nmix = UNK(c).Nsig;
DTi = A.DT_VALUES;
RSDf = A.flickernoise;

Iishost = Iihost(is);
Iismix = Iimix(is);
%Iisample = Iisamp(is); %Added in 1.0.6
Cishost = UNK(c).MAT_CONC(is);
Cismix = UNK(c).MIX_CONC(is);
Cissamp = UNK(c).SAMP_CONC(is);
sigmais_HOST = UNK(c).MAT_CONC_error(is);
sigmais_MIX = UNK(c).MIX_CONC_error(is);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculate the error in the deconvoluted signal concentration
%(derived from equation 15 in Halter et al.(2002) Chem. Geol., 183,
%63-86.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

term1 = UNK(c).sigma_mat.^2.*((Cishost/Iishost).*((1-(1/x))./CALIBis)).^2;
term2 = UNK(c).sigma_bg.^2.*(((Cishost/Iishost).*((1-(1/x))./CALIBis)) + (Cismix/Iismix).*((1/x)./CALIBis)).^2;
term3 = UNK(c).sigma_sig.^2.*((Cismix/Iismix).*((1/x)./CALIBis)).^2;

%as an initial guess sigmais_SAMP* = sqrt(term1 + term2 + term3);
sigmais_SAMP_star = sqrt(term1(is)+term2(is)+term3(is));
sigma_x_star = sqrt((((1/(Cishost-Cissamp)) - (Cishost-Cismix)/(Cishost-Cissamp)^2)^2*(sigmais_HOST^2)) + ((-1/(Cishost-Cissamp))^2*(sigmais_MIX^2)) + ((((Cishost-Cismix)/((Cishost-Cissamp)^2))^2)*(sigmais_SAMP_star^2)));

%now calculate sigmais_SAMP*(2) and a new value of x*(2)
term4is_star = (sigma_x_star^2/4)*((Cishost/Iishost)*(Iishost)/CALIBis(is) - ((Iismix)/CALIBis(is))*(Cismix/Iismix))^2;
sigmais_SAMP_star2 = sqrt(term1(is) + term2(is) + term3(is) + term4is_star);
sigma_x_star2 = sqrt((((1/(Cishost-Cissamp)) - (Cishost-Cismix)/(Cishost-Cissamp)^2)^2*(sigmais_HOST^2)) + ((-1/(Cishost-Cissamp))^2*(sigmais_MIX^2)) + (((((Cishost-Cismix)/((Cishost-Cissamp)^2))^2))*(sigmais_SAMP_star2^2)));

sigma_x_0 = 0;
sigma_x_1 = sigma_x_star*2;

eps0 = 0.000001;
eps = abs((sigma_x_star2 - sigma_x_star)/sigma_x_star);

k = 0;

while eps>eps0

    term4is_star = (sigma_x_star^2/4)*((Cishost/Iishost)*(Iishost)/CALIBis(is) - ((Iismix)/CALIBis(is))*(Cismix/Iismix))^2;
    sigmais_SAMP_star2 = sqrt(term1(is) + term2(is) + term3(is) + term4is_star);
    sigma_x_star2 = sqrt((((1/(Cishost-Cissamp)) - (Cishost-Cismix)/(Cishost-Cissamp)^2)^2*(sigmais_HOST^2)) + ((-1/(Cishost-Cissamp))^2*(sigmais_MIX^2)) + (((((Cishost-Cismix)/((Cishost-Cissamp)^2))^2))*(sigmais_SAMP_star2^2)));

    if sigmais_SAMP_star2 > sigmais_SAMP_star
        sigma_x_1 = sigma_x_star;
    else
        sigma_x_0 = sigma_x_star;
    end

    term4is_star = (sigma_x_star2^2/4)*((Cishost/Iishost)*(Iishost)/CALIBis(is) - ((Iismix)/CALIBis(is))*(Cismix/Iismix))^2;
    sigmais_SAMP_star = sqrt(term1(is) + term2(is) + term3(is) + term4is_star);
    sigma_x_star = sqrt((((1/(Cishost-Cissamp)) - (Cishost-Cismix)/(Cishost-Cissamp)^2)^2*(sigmais_HOST^2)) + ((-1/(Cishost-Cissamp))^2*(sigmais_MIX^2)) + (((((Cishost-Cismix)/((Cishost-Cissamp)^2))^2))*(sigmais_SAMP_star^2)));

    eps = abs((sigma_x_star2 - sigma_x_star)/sigma_x_star);

    k = k+1;

    if k==100
        return
    end
end

UNK(c).sigma_x = sigma_x_star;

term4 = (UNK(c).sigma_x^2/4)*((Cishost/Iishost)*(Iihost)./CALIBis - (Iimix./CALIBis)*(Cismix/Iismix)).^2;
UNK(c).SAMP_CONC_error = sqrt(term1 + term2 + term3 + term4);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%LOD in the mixed signal
%Changed factor from 3 to dynamic A.LODff in 1.0.2
%Added two methods in 1.3.2
if strcmp(A.LODmethod,'Longerich')==1
    UNK(c).MIX_LOD_mn = A.LODff*UNK(c).BG_stdev*sqrt(1/UNK(c).Nbg + 1/UNK(c).Nsig)./CALIBis.*(UNK(c).MIX_CONC(is)/(UNK(c).sig_cps(is)-UNK(c).bg_cps(is)));
    UNK(c).MIX_LOD_mm = A.LODff*UNK(c).BG_stdev*sqrt(2/UNK(c).Nsig)./CALIBis.*(UNK(c).MIX_CONC(is)/(UNK(c).sig_cps(is)-UNK(c).bg_cps(is)));
    % Added by MG, changed 16.02.2011
    % UNK(c).MIX_LOD_new = (((3.29*(A.DT_VALUES').*UNK(c).BG_stdev*sqrt(UNK(c).Nsig)+ 2.71)./(A.DT_VALUES'))./(UNK(c).Nsig))./CALIBis.*(UNK(c).MIX_CONC(is)/(UNK(c).sig_cps(is)-UNK(c).bg_cps(is))); %calculation after JAAS, Tanner 2010  IUPAC approximation
elseif strcmp(A.LODmethod,'Pettke')==1
    UNK(c).MIX_LOD_mn = (((sqrt((A.DT_VALUES').*UNK(c).bg_cps* UNK(c).Nsig*(1+UNK(c).Nsig/UNK(c).Nbg))*3.29+2.71)./(A.DT_VALUES'))./(UNK(c).Nsig))./CALIBis.*(UNK(c).MIX_CONC(is)/(UNK(c).sig_cps(is)-UNK(c).bg_cps(is))); %calculated after discussion with Pettke and Felix, see paper!
end
% Is Equation 6 in Paper: Ore Geology Reviews 44 (2012) 10–38
%for zz = 1:A.ISOTOPE_num
%    if UNK(c).SAMP_LOD_new(zz) > UNK(c).SAMP_LOD_mn(zz)
%       UNK(c).SAMP_LOD_mn(zz) = UNK(c).SAMP_LOD_new(zz);
%    end
%end


%stopp Added by MG 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%LOD in the deconvoluted signal

%need the cps error of the matrix component of the mixed signal:
%first define the intensity of the host in the mixed signal:

Iihost_in_mix = (Iihost/Iishost)*(1-x)*Iismix*(Cishost/Cismix);

UNK(c).sigma_host_in_mix = sqrt((((sqrt(((Iihost_in_mix + Iib)).*DTi')/UNK(c).Nbg))./DTi').^2 + (((Iihost_in_mix + Iib)*(RSDf/100)/sqrt(UNK(c).Nbg)).*((sqrt(A.flickDT))./sqrt(DTi'))).^2);

%Changed factor from 3 to dynamic A.LODff in 1.0.2 ; Changed to sample C/I
%factor instead of mix factor in 1.0.6
UNK(c).SAMP_LOD_mn = (A.LODff/x)./CALIBis.*(Cismix./Iismix).*sqrt(UNK(c).sigma_bg.^2 + UNK(c).sigma_host_in_mix.^2);

% Added by MG 19.1.2011 changed 16.2.2011 and 20.4.2011
% UNK(c).SAMP_LOD_new = (((3.29.*(A.DT_VALUES').*UNK(c).BG_stdev*sqrt(UNK(c).Nsig)+ 2.71)./(A.DT_VALUES'))./(UNK(c).Nsig))./CALIBis.*(UNK(c).MIX_CONC(is)/(UNK(c).sig_cps(is)-UNK(c).bg_cps(is))); %calculation after JAAS, Tanner 2010  IUPAC approximation
UNK(c).SAMP_LOD_new = (((sqrt((A.DT_VALUES').*UNK(c).bg_cps.* UNK(c).Nsig*(1+UNK(c).Nsig/UNK(c).Nbg))*3.29+2.71)./(A.DT_VALUES'))./(UNK(c).Nsig))./CALIBis.*(UNK(c).MIX_CONC(is)/(UNK(c).sig_cps(is)-UNK(c).bg_cps(is))); %calculated after discussion with Pettke and Felix, see paper!             

% for zz = 1:A.ISOTOPE_num
%        if UNK(c).SAMP_LOD_new(zz) > UNK(c).SAMP_LOD_mn(zz)
%           UNK(c).SAMP_LOD_mn(zz) = UNK(c).SAMP_LOD_new(zz);
%        end
%    end
UNK(c).SAMP_LOD_mn = UNK(c).SAMP_LOD_new;
%LOD new is always used over the one from Longerich. If you want the old
%Longerich LOD undo this line with %.

% stopp Added by MG 


clear term1 term2 term3 term4 Iihost Iib CALIBis CALIBis Cishost Iishost Cismix Iimix x Nmix DTi RSDf
clear is CALIBis Iishost Iismix Cishost Cismix Cissamp sigmais_HOST sigmais_MIX
clear sigmais_SAMP_star sigma_x_star term4is_star sigmais_SAMP_star2 sigma_x_star2 sigma_x_0 sigma_x_1 eps0 eps k
clear Iihost_in_mix Iisamp Iisample


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

