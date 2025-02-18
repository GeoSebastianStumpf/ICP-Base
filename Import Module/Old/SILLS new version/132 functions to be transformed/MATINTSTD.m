%MATINTSTD

%Define the internal standard

A.KC = get(gco,'Userdata');
currentunit = get(SMAN.handles(A.KC).h_MATunit,'value');


if currentunit == 1 %i.e. ug/g

    %grab the current isotope from the A.ISOTOPES_in_all_SRMs list
    UNK(A.KC).MATQISiso = get(SMAN.handles(A.KC).h_MATint,'value');
    currentisotope = A.ISOTOPES_in_all_SRMs(UNK(A.KC).MATQISiso);

    %find the internal standard in the master isotope list (A.ISOTOPE_list)
    b = strcmp(A.ISOTOPE_list,currentisotope);
    matintstd = find(b==1);
    UNK(A.KC).MATQIS = matintstd;

    %set the internal standard concentration
    concppm = get(SMAN.handles(A.KC).h_MATconc,'string');
    if ~isempty(concppm)
        concppm = str2num(concppm);
        if (concppm < 0) || (concppm > 1e6)
            msgbox('Invalid Entry');
            return
        else
            UNK(A.KC).MATQIS_conc = concppm;
        end
    else
        UNK(A.KC).MATQIS_conc = [];
    end

elseif currentunit == 2 && A.Oxide_test ~= 0 %i.e. wt.%

    %grab the current oxide from the A.OXIDES_in_all_SRMs list
    UNK(A.KC).MATQISox = get(SMAN.handles(A.KC).h_MATintox,'value');
    currentisotope = A.ISOTOPES_in_all_SRMs(A.OXIDES_in_all_SRMs_index(UNK(A.KC).MATQISox));
    currentelement = A.ELEMENTS_in_all_SRMs(A.OXIDES_in_all_SRMs_index(UNK(A.KC).MATQISox));
    currentoxide = A.OXIDES_in_all_SRMs_oxide(UNK(A.KC).MATQISox);

    %find the internal standard in the master isotope list (A.ISOTOPE_list)
    b = strcmp(A.ISOTOPE_list,currentisotope);
    matintstd = find(b==1);
    UNK(A.KC).MATQIS = matintstd;

    %recast the wt.% oxide value into ppm
    b = strcmp(A.Oxides(:,2),currentoxide);
    matoxide = find(b==1);
    concwt = get(SMAN.handles(A.KC).h_MATconcwt,'string');
    if ~isempty(concwt)
        concwt = str2num(concwt);
        if concwt < 0 || concwt > 100
            msgbox('Invalid Entry');
            return
        else
            UNK(A.KC).MATQIS_concwt = concwt;
            mwelement = A.Oxides_mol_wts(matoxide,1);
            mwoxide = A.Oxides_mol_wts(matoxide,2);
            stoich = A.Oxides_mol_wts(matoxide,3);
            concppm = concwt*1e4 * stoich * (mwelement/mwoxide);
            UNK(A.KC).MATQIS_conc = concppm;
        end
    else
        UNK(A.KC).MATQIS_conc = [];
    end
end

clear currentunit currentisotope currentelement currentoxide
clear a b matintstd matoxide mwelement mwoxide stoich concwt concppm
