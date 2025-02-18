%SIGINTSTD

%Define the internal standard

A.KC = get(gco,'Userdata');
currentunit = get(SMAN.handles(A.KC).h_SIG1unit,'value');

if currentunit == 1 %i.e. ug/g

    %grab the current isotope from the A.ISOTOPES_in_all_SRMs list
    UNK(A.KC).SIGQIS1iso = get(SMAN.handles(A.KC).h_SIG1int,'value');
    currentisotope = A.ISOTOPES_in_all_SRMs(UNK(A.KC).SIGQIS1iso);

    %find the internal standard in the master isotope list (A.ISOTOPE_list)
    b = strcmp(A.ISOTOPE_list,currentisotope);
    sig1intstd = find(b==1);
    UNK(A.KC).SIGQIS1 = sig1intstd;

    %set the internal standard concentration
    concppm = get(SMAN.handles(A.KC).h_SIG1concis,'string');
    if ~isempty(concppm)
        concppm = str2num(concppm);
        if concppm < 0 || concppm > 1e6
            clear currentunit currentisotope currentelement currentoxide
            clear a b matintstd matoxide mwelement mwoxide stoich concwt concppm
            clear sig1intstd sig1oxide            
            msgbox('Invalid Entry');
            return
        else
            UNK(A.KC).SIGQIS1_conc = concppm;
        end
    else
        UNK(A.KC).SIGQIS1_conc = [];
    end

elseif currentunit == 2 %i.e. wt.%

    %grab the current oxide from the A.OXIDES_in_all_SRMs list
    UNK(A.KC).SIGQIS1ox = get(SMAN.handles(A.KC).h_SIG1intox,'value');
    currentisotope = A.ISOTOPES_in_all_SRMs(A.OXIDES_in_all_SRMs_index(UNK(A.KC).SIGQIS1ox));
    currentelement = A.ELEMENTS_in_all_SRMs(A.OXIDES_in_all_SRMs_index(UNK(A.KC).SIGQIS1ox));
    currentoxide = A.OXIDES_in_all_SRMs_oxide(UNK(A.KC).SIGQIS1ox);

    %find the internal standard in the master isotope list (A.ISOTOPE_list)
    b = strcmp(A.ISOTOPE_list,currentisotope);
    sig1intstd = find(b==1);
    UNK(A.KC).SIGQIS1 = sig1intstd;

    %recast the wt.% oxide value into ppm
    b = strcmp(A.Oxides(:,2),currentoxide);
    sig1oxide = find(b==1);
    concwt = get(SMAN.handles(A.KC).h_SIG1conciswt,'string');
    if ~isempty(concwt)
        concwt = str2num(concwt);
        if concwt < 0 || concwt > 100
            clear currentunit currentisotope currentelement currentoxide
            clear a b matintstd matoxide mwelement mwoxide stoich concwt concppm
            clear sig1intstd sig1oxide            
            msgbox('Invalid Entry');
            return
        else
            UNK(A.KC).SIGQIS1_concwt = concwt;
            mwelement = A.Oxides_mol_wts(sig1oxide,1);
            mwoxide = A.Oxides_mol_wts(sig1oxide,2);
            stoich = A.Oxides_mol_wts(sig1oxide,3);
            concppm = concwt*1e4 * stoich * (mwelement/mwoxide);
            UNK(A.KC).SIGQIS1_conc = concppm;
        end
    else
        UNK(A.KC).SIGQIS1_conc = [];
    end
end

clear currentunit currentisotope currentelement currentoxide
clear a b matintstd matoxide mwelement mwoxide stoich concwt concppm
clear sig1intstd sig1oxide