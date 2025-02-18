%SIGCONSTRAINT_SET

clear current quanttype

A.KC = get(gcf,'UserData');
current = get(gco,'tag');
quanttype = get(gco,'value');

if strcmp(current,'constraint1_popup')==1

    if quanttype == 1 %i.e. internal standard

        UNK(A.KC).SIG_constraint1 = quanttype;
        
        set(SMAN.SIGconc_header1,'visible','on');
        if UNK(A.KC).SIG1unit == 1 %i.e. ug/g
            set(SMAN.SIG1int,'visible','on','value',UNK(A.KC).SIGQIS1iso);
            set(SMAN.SIG1concis,'visible','on','string',UNK(A.KC).SIGQIS1_conc);
            set(SMAN.SIG1unit,'visible','on','value',UNK(A.KC).SIG1unit);
            if A.Oxide_test ~= 0
                set(SMAN.SIG1intox,'visible','off');
                set(SMAN.SIG1conciswt,'visible','off');
            end
        elseif UNK(A.KC).SIG1unit == 2 %i.e. wt.%
            set(SMAN.SIG1int,'visible','off');
            set(SMAN.SIG1concis,'visible','off');
            set(SMAN.SIG1unit,'visible','on','value',UNK(A.KC).SIG1unit);
            if A.Oxide_test ~= 0
                set(SMAN.SIG1intox,'visible','on','value',UNK(A.KC).SIGQIS1ox);
                set(SMAN.SIG1conciswt,'visible','on','string',UNK(A.KC).SIGQIS1_concwt);
            end
        end

        set(SMAN.SIGsalt,'visible','off');
        set(SMAN.SALT_set_button,'visible','off');
        if A.Oxide_test ~= 0
            set(SMAN.SIGoxide,'visible','off');
        end
        if A.Fe_test ~= 0;
            set(SMAN.SIG_Feheader,'visible','off');
            set(SMAN.SIG_Feratio,'visible','off');
        end

    elseif quanttype == 2 || quanttype == 3 %i.e. equiv wt% NaCl

        if A.Na_test ~= 0
        
            UNK(A.KC).SIG_constraint1 = quanttype;

            set(SMAN.SIG1int,'visible','off');
            set(SMAN.SIG1concis,'visible','off');
            if A.Oxide_test ~= 0
                set(SMAN.SIG1intox,'visible','off');
                set(SMAN.SIG1conciswt,'visible','off');
                set(SMAN.SIGoxide,'visible','off');
            end
            if A.Na_test ~= 0;
                set(SMAN.SIGconc_header1,'visible','on');
                set(SMAN.SIGsalt,'visible','on');
                set(SMAN.SALT_set_button,'visible','on');
                set(SMAN.SIG1unit,'visible','on','value',2);
            else
                set(SMAN.SIGconc_header1,'visible','off');
                set(SMAN.SIGsalt,'visible','off');
                set(SMAN.SALT_set_button,'visible','off');
                set(SMAN.SIG1unit,'visible','off','value',2);
            end
            if A.Fe_test ~= 0;
                set(SMAN.SIG_Feheader,'visible','off');
                set(SMAN.SIG_Feratio,'visible','off');
            end

        elseif A.Na_test == 0
    
            set(SMAN.constraint1_popup,'value',UNK(A.KC).SIG_constraint1);

        end
            
    elseif quanttype == 4 && A.Oxide_test ~= 0 % i.e. total oxides (major elements)

        UNK(A.KC).SIG_constraint1 = quanttype;
        
        set(SMAN.SIGconc_header1,'visible','on');
        set(SMAN.SIG1int,'visible','off');
        set(SMAN.SIG1intox,'visible','off');
        set(SMAN.SIG1concis,'visible','off');
        set(SMAN.SIG1conciswt,'visible','off');
        set(SMAN.SIGsalt,'visible','off');
        set(SMAN.SALT_set_button,'visible','off');
        set(SMAN.SIGoxide,'visible','on');
        set(SMAN.SIG1unit,'visible','on','value',2);
        if A.Fe_test ~= 0;
            set(SMAN.SIG_Feheader,'visible','on');
            set(SMAN.SIG_Feratio,'visible','on');
        end

    elseif quanttype == 4 && A.Oxide_test == 0
    
        set(SMAN.constraint1_popup,'value',UNK(A.KC).SIG_constraint1);
    
    end

%..........................................................................
elseif strcmp(current,'constraint2_popup')==1     % i.e. second constraint selected

    if quanttype == 1  % i.e. matrix-only tracer

        UNK(A.KC).SIG_constraint2 = quanttype;

        set(SMAN.SIGtracer,'visible','on');
        set(SMAN.SIGconc_header2,'visible','off');
        set(SMAN.SIG2int,'visible','off');
        set(SMAN.SIG2concis,'visible','off');
        set(SMAN.SIG2unit,'visible','off');
        if A.Oxide_test ~= 0
            set(SMAN.SIG2intox,'visible','off');
            set(SMAN.SIG2conciswt,'visible','off');
        end
        
    elseif quanttype == 2 %i.e. internal standard

        UNK(A.KC).SIG_constraint2 = quanttype;

        set(SMAN.SIGtracer,'visible','off');
        set(SMAN.SIGconc_header2,'visible','on');
        if UNK(A.KC).SIG2unit == 1 %i.e. ug/g
            set(SMAN.SIG2int,'visible','on','value',UNK(A.KC).SIGQIS2iso);
            set(SMAN.SIG2concis,'visible','on','string',UNK(A.KC).SIGQIS2_conc);
            set(SMAN.SIG2unit,'visible','on','value',UNK(A.KC).SIG2unit);
            if A.Oxide_test ~= 0
                set(SMAN.SIG2intox,'visible','off');
                set(SMAN.SIG2conciswt,'visible','off');
            end
        elseif UNK(A.KC).SIG2unit == 2 %i.e. wt.%
            if A.Oxide_test ~= 0
                set(SMAN.SIG2int,'visible','off');
                set(SMAN.SIG2concis,'visible','off');
                set(SMAN.SIG2unit,'visible','on','value',UNK(A.KC).SIG2unit);
                set(SMAN.SIG2intox,'visible','on','value',UNK(A.KC).SIGQIS2ox);
                set(SMAN.SIG2conciswt,'visible','on','string',UNK(A.KC).SIGQIS2_concwt);
            elseif A.Oxide_test == 0
                UNK(A.KC).SIG2unit = 1;
                set(SMAN.SIG2unit,'visible','on','value',1);
            end
        end
    end
end

clear current quanttype ans