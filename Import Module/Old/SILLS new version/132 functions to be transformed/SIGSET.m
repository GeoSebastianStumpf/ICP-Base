%SIGSET

figuretag = get(gcf,'tag');

if strcmp(figuretag,'SILLS Calculation Manager') == 1
    A.KC = get(gco,'Userdata');
    a = A.KC;
    type = get(gco,'value');

elseif strcmp(figuretag,'SMAN.sigquant_fig') == 1
    type = get(SMAN.constraint1_popup,'value');

end

if UNK(a).MAT_corrtype == 1 %i.e. there is no matrix correction

    if type == 1; %i.e. internal standard
        
        UNK(A.KC).SIG_constraint1 = type;

        set(SMAN.handles(a).h_SIGconstraint1_popup,'value',UNK(a).SIG_constraint1);
        
        if UNK(a).SIG1unit == 1 %i.e. ug/g
            set(SMAN.handles(a).h_SIG1int,'visible','on','value',UNK(a).SIGQIS1iso);
            set(SMAN.handles(a).h_SIG1concis,'visible','on','string',UNK(a).SIGQIS1_conc);
            set(SMAN.handles(a).h_SIG1unit,'visible','on','value',UNK(a).SIG1unit);
            if A.Oxide_test ~= 0
                set(SMAN.handles(a).h_SIG1intox,'visible','off');
                set(SMAN.handles(a).h_SIG1conciswt,'visible','off');
            end
            
        elseif UNK(a).SIG1unit ==2 %i.e. wt.%
            set(SMAN.handles(a).h_SIG1int,'visible','off');
            set(SMAN.handles(a).h_SIG1concis,'visible','off');
            set(SMAN.handles(a).h_SIG1unit,'visible','on','value',UNK(a).SIG1unit);
            if A.Oxide_test ~= 0
                set(SMAN.handles(a).h_SIG1intox,'visible','on','value',UNK(a).SIGQIS1ox);
                set(SMAN.handles(a).h_SIG1conciswt,'visible','on','string',UNK(a).SIGQIS1_concwt);
            end        
        end
        set(SMAN.handles(a).h_SIGsalt,'visible','off');
        set(SMAN.handles(a).h_SALT_set_button,'Visible','off');
        set(SMAN.handles(a).h_SIGAPPLY2ALL,'visible','on');
        set(SMAN.handles(a).h_SIGquantbutton,'visible','off');
        set(SMAN.handles(a).h_nosigwarning,'visible','off');
        if A.Oxide_test ~= 0
            set(SMAN.handles(a).h_SIGoxide,'visible','off');
        end
        if A.Fe_test ~= 0;
            set(SMAN.handles(a).h_SIG_Feratio,'visible','off');
        end;

    elseif type == 2 || type == 3 %i.e. salinity
    
        if A.Na_test ~= 0
            
            UNK(A.KC).SIG_constraint1 = type;

            set(SMAN.handles(a).h_SIGconstraint1_popup,'value',UNK(a).SIG_constraint1);
            set(SMAN.handles(a).h_SIG1int,'visible','off');
            set(SMAN.handles(a).h_SIG1concis,'visible','off');
            set(SMAN.handles(a).h_SIG1unit,'visible','on','value',2);
            set(SMAN.handles(a).h_SIGsalt,'visible','on','string',UNK(a).SIGsalinity);
            set(SMAN.handles(a).h_SALT_set_button,'Visible','on');
            set(SMAN.handles(a).h_SIGAPPLY2ALL,'visible','on');
            set(SMAN.handles(a).h_SIGquantbutton,'visible','off');
            set(SMAN.handles(a).h_nosigwarning,'visible','off');
            if A.Oxide_test ~= 0;
                set(SMAN.handles(a).h_SIG1intox,'visible','off');
                set(SMAN.handles(a).h_SIG1conciswt,'visible','off');
                set(SMAN.handles(a).h_SIGoxide,'visible','off');
            end            
            if A.Fe_test ~= 0;
                set(SMAN.handles(a).h_SIG_Feratio,'visible','off');
            end;

        elseif A.Na_test == 0
            
            set(SMAN.handles(a).h_SIGconstraint1_popup,'value',UNK(a).SIG_constraint1);
        
        end
           
    elseif type == 4  && A.Oxide_test ~= 0 %i.e. total oxides

        UNK(A.KC).SIG_constraint1 = type;

        set(SMAN.handles(a).h_SIGconstraint1_popup,'value',UNK(a).SIG_constraint1);
        set(SMAN.handles(a).h_SIG1int,'visible','off');
        set(SMAN.handles(a).h_SIG1concis,'visible','off');
        set(SMAN.handles(a).h_SIG1unit,'visible','on','value',2);
        set(SMAN.handles(a).h_SIGsalt,'visible','off');
        set(SMAN.handles(a).h_SALT_set_button,'Visible','off');
        set(SMAN.handles(a).h_SIG1int,'visible','off');
        set(SMAN.handles(a).h_SIGAPPLY2ALL,'visible','on');
        set(SMAN.handles(a).h_SIGquantbutton,'visible','off');
        set(SMAN.handles(a).h_nosigwarning,'visible','off');
        if A.Oxide_test ~= 0
            set(SMAN.handles(a).h_SIG1intox,'visible','off');
            set(SMAN.handles(a).h_SIG1conciswt,'visible','off');
            set(SMAN.handles(a).h_SIGoxide,'visible','on','string',UNK(a).SIG_oxide_total);
        end
        if A.Fe_test ~= 0;
            set(SMAN.handles(a).h_SIG_Feratio,'visible','on','string',UNK(a).SIG_Fe_ratio);
        end;
    
    elseif type == 4 && A.Oxide_test == 0
    
        set(SMAN.handles(a).h_SIGconstraint1_popup,'value',UNK(a).SIG_constraint1);

    end
end

clear a figuretag type