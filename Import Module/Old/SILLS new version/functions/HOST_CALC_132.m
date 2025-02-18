%HOST_CALC
function [A, UNK, STD, SRM, SMAN] = HOST_CALC_132(A, UNK, STD, SRM, SMAN, c)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%if the user has selected a normalisation to oxides or salinity,
%calculate the sum of the concentrations in the host on this basis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if UNK(c).SIG_constraint1 == 2 || UNK(c).SIG_constraint1 == 3 %i.e. equiv. wt% NaCl

    %CONSTANTS %%%%%%%%%%%%%%%%%%%%%%%%
    NaClequiv_inc = UNK(c).SIGsalinity;
    MWNa = 22.99;
    MWNaCl = 58.44;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %first, convert selected salt-correction isotopes to a shortened
    %matrix of elements
    UNK(c).salt_index = find(UNK(c).SALT == 1); %position index of chosen isotopes for salt correction
    UNK(c).salt_num = sum(UNK(c).SALT);         %number of elements in the correction (including Na)

    %......................................................................
    if UNK(c).salt_num == 0 %i.e. no auxiliary elements were selected for the salt correction
    
        %select Na as the internal standard for this calculation
        UNK(c).SIGSALTIS = A.Na_index;

        %create a CALIB matrix for the purpose of casting cps in concs.
        UNK(c).SIGSALTIS_CALIB = UNK(c).REFIS_CALIB ./ UNK(c).REFIS_CALIB(UNK(c).SIGSALTIS);

        %convert matrix counts ratios to Na into concentration ratios
        UNK(c).MAT_CPS_ratio = (UNK(c).mat_cps - UNK(c).bg_cps)/(UNK(c).mat_cps(UNK(c).SIGSALTIS) - UNK(c).bg_cps(UNK(c).SIGSALTIS));
        UNK(c).MAT_CONC_ratio = UNK(c).MAT_CPS_ratio ./ UNK(c).SIGSALTIS_CALIB;

        if UNK(c).SIG_constraint1 == 2 %i.e. equiv. wt.% NaCl by mass

            %determine wt.% NaCl
            Na_ppm_mat = UNK(c).MAT_CONC(A.Na_index);
            NaCl_mat = (Na_ppm_mat/10000)*MWNaCl/MWNa;
            NaClequiv_mat = NaCl_mat;
        
        elseif UNK(c).SIG_constraint1 == 3 %i.e. equiv. wt.%NaCl by charge

            %determine molality of Na:
            mNa_mat = (UNK(c).MAT_CONC(A.Na_index)/MWNa)/1000;
            mCl_mat = mNa_mat;
            %convert mCl into NaClequiv:
            NaClequiv_mat = mCl_mat*MWNaCl/10;
        
        end

    %......................................................................
    else        
        for b = 1:UNK(c).salt_num
            UNK(c).salt(b) = A.ISOTOPE_list(UNK(c).salt_index(b));
        end

        clear temp1 temp2 temp3 temp4
        temp1 = char(UNK(c).salt);
        temp2 = isletter(temp1);
        temp3 = temp2.*temp1;
        temp4 = char(temp3);
        for b = 1:UNK(c).salt_num
            UNK(c).salt_elements(b) = {temp4(b,:)};
        end

        UNK(c).salt_elements = deblank(UNK(c).salt_elements);

        clear temp1 temp2 temp3 temp4

        %Now compare the element matrix UNK.salt_elements with
        %the list of elements from the 'Chlorides' matrix
        temp1 = zeros(A.Chlorides_num,UNK(c).salt_num);
        for b = 1:UNK(c).salt_num
            temp(:,b) = strcmp(A.Chlorides(:,1),UNK(c).salt_elements(b));
            UNK(c).chloride_index(b) = find(temp(:,b)==1);
            %UNK(c).chloride_index contains the row indices of the
            %elements selected for the salt correction
        end

        %select Na as the internal standard for this calculation
        UNK(c).SIGSALTIS = A.Na_index;

        %create a CALIB matrix for the purpose of casting cps in concs.
        UNK(c).SIGSALTIS_CALIB = UNK(c).REFIS_CALIB ./ UNK(c).REFIS_CALIB(UNK(c).SIGSALTIS);

        %convert matrix counts ratios to Na into concentration ratios
        UNK(c).MAT_CPS_ratio = (UNK(c).mat_cps - UNK(c).bg_cps)/(UNK(c).mat_cps(UNK(c).SIGSALTIS) - UNK(c).bg_cps(UNK(c).SIGSALTIS));
        UNK(c).MAT_CONC_ratio = UNK(c).MAT_CPS_ratio ./ UNK(c).SIGSALTIS_CALIB;

        %create a condensed concentration ratio matrix containing just
        %those elements chosen for the salt correction
        for b = 1:UNK(c).salt_num
            UNK(c).MAT_CONC_ratio_condensed(b) = UNK(c).MAT_CONC_ratio(UNK(c).salt_index(b));
        end

        if UNK(c).SIG_constraint1 == 2 %i.e. equiv. wt.% NaCl by mass

            %determine wt.% NaCl
            Na_ppm_mat = UNK(c).MAT_CONC(A.Na_index);
            NaCl_mat = (Na_ppm_mat/10000)*MWNaCl/MWNa;

            %convert X/Na ratios into XCl/NaCl
            for b = 1:UNK(c).salt_num
                MWX = A.Chlorides_mol_wts(UNK(c).chloride_index(b),1);
                MWXCl = A.Chlorides_mol_wts(UNK(c).chloride_index(b),2);
                chloride_conc_ratio_mat(b) = UNK(c).MAT_CONC_ratio_condensed(b)*(MWNa/MWX)*(MWXCl/MWNaCl);
            end

            %remove the [NaCl]/[NaCl] ratio (1) from SIG_SALTCONC_ratio
            seekdestroy = find(chloride_conc_ratio_mat == 1);
            chloride_conc_ratio_mat(seekdestroy) = [];
            chloride_conc_mat = chloride_conc_ratio_mat*NaCl_mat;

            %calculate the equiv. wt.% NaCl
            NaClequiv_mat = NaCl_mat + UNK(c).SALT_mass_balance_factor*sum(chloride_conc_mat);

        %..................................................................
        elseif UNK(c).SIG_constraint1 == 3 %i.e. equiv. wt.%NaCl by charge
            %convert concentration ratios into n*molar ratio for the last term in the equation:

            %determine molality of Na:
            mNa_mat = (UNK(c).MAT_CONC(A.Na_index)/MWNa)/1000;

            %mNa = mCl/(1 + sum((n*mX)/mNa))

            %where mX/mNa = [X]/[Na] * (MWNa/MWX)
            for b = 1:UNK(c).salt_num
                n = A.Chlorides_mol_wts(UNK(c).chloride_index(b),3);
                MWX = A.Chlorides_mol_wts(UNK(c).chloride_index(b),1);
                molar_ratio_mat(b) = n*UNK(c).MAT_CONC_ratio_condensed(b)*(MWNa/MWX);
            end

            %remove the mNa/mNa entry in the SIG_MOLAR_ratio
            seekdestroy = find(molar_ratio_mat == 1);
            molar_ratio_mat(seekdestroy) = [];
            mX_mat = molar_ratio_mat*mNa_mat;
            mCl_mat = mNa_mat + sum(mX_mat);

            %convert mCl into NaClequiv:
            NaClequiv_mat = mCl_mat*MWNaCl/10;
        end
    end
    
%..........................................................................
elseif UNK(c).SIG_constraint1 == 4 %i.e. total oxides

    if UNK(c).MAT_corrtype == 3 %i.e. total oxides
        Oxide_mat = UNK(c).MAT_oxide_total;
    
    else
        %find the elements that are contained in the A.Oxides list
        %(typical majors only)
        for b=1:A.ELEMENT_num
            oxide_seek(:,b) = strcmp(A.Oxides(:,1),A.ELEMENT_list(b));
        end
        oxide_seek2 = sum(oxide_seek);
        oxide_seek_index = find(oxide_seek2 > 0);    %indices of the major oxide isotopes
        oxide_seek_num = size(oxide_seek_index);
        oxide_seek_num = oxide_seek_num(2);         %number of isotopes in the oxide list

        UNK(c).MATOXIDE = zeros(11,6); %11 major oxides, 6 categories of data

        for d=1:11
            %COLUMN 1: index of the isotope corresponding to given oxide
            a = find(oxide_seek(d,:)==1);
            if isempty(a)
                a = 0;
            end
            UNK(c).MATOXIDE(d,1) = a;
        end

        %..................................................................
        %continue populating the MATOXIDE matrix:

        for d=1:11
            conc(d) = UNK(c).MAT_CONC(UNK(c).MATOXIDE(d,1));
        end
        oxide = (conc/10000)./A.Oxides_mol_wts(:,1)'./A.Oxides_mol_wts(:,3)'.*A.Oxides_mol_wts(:,2)';

        if A.Fe_test == 1             %i.e. there is Fe in the list
            if isempty(UNK(c).SIG_Fe_ratio)
                UNK(c).SIG_Fe_ratio = 0;
            end
            a = UNK(c).SIG_Fe_ratio; %the user-defined FeO /(FeO + Fe2O3) ratio
            %determine FeO and Fe2O3
            oxide(5) = (conc(5)/10000)/((55.85/71.85)+((1-a)/a)*2*(55.85/159.7));
            oxide(4) = ((1-a)/a)*oxide(5);
        end

        Oxide_mat = sum(oxide);
    end
end

