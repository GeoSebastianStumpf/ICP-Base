%SIGQUANT_SIGINTSTD

%Define the internal standard

A.KC = get(gcf,'Userdata');
temp = get(gco,'tag');

if strcmp(temp,'SIG1')==1 %i.e. something in the Constraint 1 panel was selected

    currentunit = get(SMAN.SIG1unit,'value');
    
    if currentunit == 1 %i.e. ug/g

        %grab the current isotope from the A.ISOTOPES_in_all_SRMs list
        UNK(A.KC).SIGQIS1iso  = get(SMAN.SIG1int,'value');
        currentisotope = A.ISOTOPES_in_all_SRMs(UNK(A.KC).SIGQIS1iso);

        %find the internal standard in the master isotope list (A.ISOTOPE_list)
        b = strcmp(A.ISOTOPE_list,currentisotope);
        sig1intstd = find(b==1);
        UNK(A.KC).SIGQIS1 = sig1intstd;

        %set the internal standard concentration
        concppm = get(SMAN.SIG1concis,'string');
        if ~isempty(concppm)
            concppm = str2num(concppm);
            if concppm < 0 || concppm > 1e6
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
        UNK(A.KC).SIGQIS1ox = get(SMAN.SIG1intox,'value');
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
        concwt = get(SMAN.SIG1conciswt,'string');
        if ~isempty(concwt)
            concwt = str2num(concwt);
            if concwt < 0 || concwt > 100
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

elseif strcmp(temp,'SIG2')==1 %i.e. something in the Constraint 2 panel was selected

    currentunit = get(SMAN.SIG2unit,'value');
        
    if currentunit == 1 %i.e. ug/g

        %grab the current isotope from the A.ISOTOPES_in_all_SRMs list
        UNK(A.KC).SIGQIS2iso = get(SMAN.SIG2int,'value');
        currentisotope = A.ISOTOPES_in_all_SRMs(UNK(A.KC).SIGQIS2iso);

        %find the internal standard in the master isotope list (A.ISOTOPE_list)
        b = strcmp(A.ISOTOPE_list,currentisotope);
        sig2intstd = find(b==1);
        UNK(A.KC).SIGQIS2 = sig2intstd;

        %set the internal standard concentration
        concppm = get(SMAN.SIG2concis,'string');
        if ~isempty(concppm)
            concppm = str2num(concppm);
            if concppm < 0 || concppm > 1e6
                msgbox('Invalid Entry');
                return;
            else            
                UNK(A.KC).SIGQIS2_conc = concppm;
            end
        else
            UNK(A.KC).SIGQIS2_conc = [];
        end
        
    elseif currentunit == 2 %i.e. wt.% 

        %grab the current oxide from the A.OXIDES_in_all_SRMs list
        UNK(A.KC).SIGQIS2ox = get(SMAN.SIG2intox,'value');
        currentisotope = A.ISOTOPES_in_all_SRMs(A.OXIDES_in_all_SRMs_index(UNK(A.KC).SIGQIS2ox));
        currentelement = A.ELEMENTS_in_all_SRMs(A.OXIDES_in_all_SRMs_index(UNK(A.KC).SIGQIS2ox));
        currentoxide = A.OXIDES_in_all_SRMs_oxide(UNK(A.KC).SIGQIS2ox);

        %find the internal standard in the master isotope list (A.ISOTOPE_list)
        b = strcmp(A.ISOTOPE_list,currentisotope);
        sig2intstd = find(b==1);
        UNK(A.KC).SIGQIS2 = sig2intstd;

        %recast the wt.% oxide value into ppm
        b = strcmp(A.Oxides(:,2),currentoxide);
        sig2oxide = find(b==1);
        concwt = get(SMAN.SIG2conciswt,'string'); %Changed in 1.1.1
        if ~isempty(concwt)
            concwt = str2num(concwt);
            if concwt < 0 || concwt > 100
                msgbox('Invalid Entry');
                return
            else
                UNK(A.KC).SIGQIS2_concwt = concwt;
                mwelement = A.Oxides_mol_wts(sig2oxide,1);
                mwoxide = A.Oxides_mol_wts(sig2oxide,2);
                stoich = A.Oxides_mol_wts(sig2oxide,3);
                concppm = concwt*1e4 * stoich * (mwelement/mwoxide);
                UNK(A.KC).SIGQIS2_conc = concppm;
            end
        else
            UNK(A.KC).SIGQIS2_conc = [];
        end
    end
end

clear temp currentunit currentisotope currentelement currentoxide
clear b sig1intstd sig2intstd sig1oxide sig2oxide concwt concwt mwelement mwoxide stoich concppm