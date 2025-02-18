%MATSET

%summoned when the matrix correction option is changed

A.KC = get(gco,'Userdata');
type = get(gco,'value');

if type == 1;  %i.e. no matrix correction
    
    UNK(A.KC).MAT_corrtype = type;
    
    set(SMAN.handles(A.KC).h_MATfile,'visible','off');
    set(SMAN.handles(A.KC).h_MATint,'visible','off');
    set(SMAN.handles(A.KC).h_MATconc,'visible','off');
    set(SMAN.handles(A.KC).h_MATunit,'visible','off');
    if A.Oxide_test ~= 0
        set(SMAN.handles(A.KC).h_MATintox,'visible','off');
        set(SMAN.handles(A.KC).h_MATconcwt,'visible','off');
        set(SMAN.handles(A.KC).h_MAToxide,'visible','off');
    end
        
    if UNK(A.KC).sigtotal > 0

        %set up the visible signal parameters
        set(SMAN.handles(A.KC).h_SIGconstraint1_popup,'visible','on');

        %internal standard
        if UNK(A.KC).SIG_constraint1 == 1;
                set(SMAN.handles(A.KC).h_SIGconstraint1_popup,'Value',UNK(A.KC).SIG_constraint1);
                currentunit = UNK(A.KC).SIG1unit;
                
                if currentunit == 1 %i.e. ug/g
                    set(SMAN.handles(A.KC).h_SIG1concis,'Visible','on');
                    set(SMAN.handles(A.KC).h_SIG1unit,'Visible','on','Value',UNK(A.KC).SIG1unit);
                    set(SMAN.handles(A.KC).h_SIG1int,'Visible','on','Value',UNK(A.KC).SIGQIS1);
                    if A.Oxide_test~= 0
                        set(SMAN.handles(A.KC).h_SIG1conciswt,'Visible','off');
                        set(SMAN.handles(A.KC).h_SIG1intox,'Visible','off');   
                    end
                    SIGINTSTD
                    
                elseif currentunit == 2 %i.e. wt.% 
                    set(SMAN.handles(A.KC).h_SIG1concis,'Visible','off');
                    set(SMAN.handles(A.KC).h_SIG1unit,'Visible','on','Value',UNK(A.KC).SIG1unit);
                    set(SMAN.handles(A.KC).h_SIG1int,'Visible','off');
                    if A.Oxide_test~= 0
                        set(SMAN.handles(A.KC).h_SIG1conciswt,'Visible','on','Value',UNK(A.KC).SIGQIS1_concwt);
                        set(SMAN.handles(A.KC).h_SIG1intox,'Visible','on','Value',UNK(A.KC).SIGQIS1ox);   
                    end
                    SIGINTSTD

                end

                set(SMAN.handles(A.KC).h_SIGsalt,'Visible','off');
                set(SMAN.handles(A.KC).h_SALT_set_button,'Visible','off');
                set(SMAN.handles(A.KC).h_SIGAPPLY2ALL,'Visible','on');
                set(SMAN.handles(A.KC).h_SIGquantbutton,'Visible','off');
                set(SMAN.handles(A.KC).h_nosigwarning,'visible','off'); 
                if A.Oxide_test ~= 0
                    set(SMAN.handles(A.KC).h_SIGoxide,'Visible','off');
                end
                if A.Fe_test ~= 0;
                    set(SMAN.handles(A.KC).h_SIG_Feratio,'visible','off');
                end;
                    
        %salinity
        elseif UNK(A.KC).SIG_constraint1 == 2 || UNK(A.KC).SIG_constraint1 == 3;
            set(SMAN.handles(A.KC).h_SIGconstraint1_popup,'Value',UNK(A.KC).SIG_constraint1);
            set(SMAN.handles(A.KC).h_SIG1concis,'Visible','off');
            set(SMAN.handles(A.KC).h_SIGsalt,'Visible','on','string',UNK(A.KC).SIGsalinity);
            set(SMAN.handles(A.KC).h_SALT_set_button,'Visible','on');
            set(SMAN.handles(A.KC).h_SIG1unit,'Visible','on','Value',2);
            set(SMAN.handles(A.KC).h_SIG1int,'Visible','off');
            set(SMAN.handles(A.KC).h_SIGAPPLY2ALL,'Visible','on');
            set(SMAN.handles(A.KC).h_SIGquantbutton,'Visible','off');
            set(SMAN.handles(A.KC).h_nosigwarning,'visible','off'); 
            if A.Oxide_test ~= 0
                set(SMAN.handles(A.KC).h_SIG1intox,'Visible','off');   
                set(SMAN.handles(A.KC).h_SIG1conciswt,'Visible','off');
                set(SMAN.handles(A.KC).h_SIGoxide,'Visible','off');
            end        
            if A.Fe_test ~= 0;
                set(SMAN.handles(A.KC).h_SIG_Feratio,'visible','off');
            end;

            %total oxide
        elseif UNK(A.KC).SIG_constraint1 == 4;
            set(SMAN.handles(A.KC).h_SIGconstraint1_popup,'Value',UNK(A.KC).SIG_constraint1);
            set(SMAN.handles(A.KC).h_SIG1concis,'Visible','off');
            set(SMAN.handles(A.KC).h_SIGsalt,'Visible','off');
            set(SMAN.handles(A.KC).h_SALT_set_button,'Visible','off');
            set(SMAN.handles(A.KC).h_SIG1unit,'Visible','on','value',2);
            set(SMAN.handles(A.KC).h_SIG1int,'Visible','off');
            set(SMAN.handles(A.KC).h_SIGAPPLY2ALL,'Visible','on');
            set(SMAN.handles(A.KC).h_SIGquantbutton,'Visible','off');
            set(SMAN.handles(A.KC).h_nosigwarning,'visible','off'); 
            if A.Oxide_test ~= 0
                set(SMAN.handles(A.KC).h_SIG1intox,'Visible','off');   
                set(SMAN.handles(A.KC).h_SIG1conciswt,'Visible','off');
                set(SMAN.handles(A.KC).h_SIGoxide,'Visible','on','string',UNK(A.KC).SIG_oxide_total);
            end        
            if A.Fe_test ~= 0;
                set(SMAN.handles(A.KC).h_SIG_Feratio,'visible','on','string',UNK(A.KC).SIG_Fe_ratio);
            end;
        end;
    else
        set(SMAN.handles(A.KC).h_nosigwarning,'visible','on'); 
    end
    if A.Fe_test ~= 0;
        set(SMAN.handles(A.KC).h_MAT_Feratio,'visible','off');
    end;

elseif type == 2; %i.e. an internal standard
    
    UNK(A.KC).MAT_corrtype = type;
    
    set(SMAN.handles(A.KC).h_MATfile,'visible','on');
    set(SMAN.handles(A.KC).h_MATint,'visible','on');
        if UNK(A.KC).MATunit == 1 %i.e. ug/g
            set(SMAN.handles(A.KC).h_MATint,'visible','on');
            set(SMAN.handles(A.KC).h_MATconc,'visible','on');
            set(SMAN.handles(A.KC).h_MATunit,'visible','on','value',UNK(A.KC).MATunit);
            if A.Oxide_test~= 0
                set(SMAN.handles(A.KC).h_MATintox,'visible','off');
                set(SMAN.handles(A.KC).h_MATconcwt,'visible','off');
            end
        else %i.e. wt.%
            set(SMAN.handles(A.KC).h_MATint,'visible','off');
            set(SMAN.handles(A.KC).h_MATconc,'visible','off');
            set(SMAN.handles(A.KC).h_MATunit,'visible','on','value',UNK(A.KC).MATunit);
            if A.Oxide_test~= 0
                set(SMAN.handles(A.KC).h_MATintox,'visible','on');
                set(SMAN.handles(A.KC).h_MATconcwt,'visible','on');
            end
        end
    set(SMAN.handles(A.KC).h_SIGconstraint1_popup,'visible','off');
    set(SMAN.handles(A.KC).h_SIG1concis,'visible','off');
    set(SMAN.handles(A.KC).h_SIGsalt,'visible','off');
    set(SMAN.handles(A.KC).h_SALT_set_button,'Visible','off');
    set(SMAN.handles(A.KC).h_SIG1unit,'visible','off');
    set(SMAN.handles(A.KC).h_SIG1int,'visible','off');
    set(SMAN.handles(A.KC).h_SIGAPPLY2ALL,'visible','off');
    if A.Oxide_test~= 0
        set(SMAN.handles(A.KC).h_MAToxide,'visible','off');
        set(SMAN.handles(A.KC).h_SIG1intox,'visible','off');
        set(SMAN.handles(A.KC).h_SIG1conciswt,'visible','off');
        set(SMAN.handles(A.KC).h_SIGoxide,'visible','off');
    end
    if UNK(A.KC).sigtotal > 0
        set(SMAN.handles(A.KC).h_SIGquantbutton,'visible','on');
        set(SMAN.handles(A.KC).h_nosigwarning,'visible','off'); 
    else
        set(SMAN.handles(A.KC).h_SIGquantbutton,'visible','off');
        set(SMAN.handles(A.KC).h_nosigwarning,'visible','on'); 
    end
    if A.Fe_test ~= 0;
        set(SMAN.handles(A.KC).h_MAT_Feratio,'visible','off');
        set(SMAN.handles(A.KC).h_SIG_Feratio,'visible','off');
    end;

elseif type == 3 && A.Oxide_test ~= 0; %i.e. total oxides
        
    UNK(A.KC).MAT_corrtype = type;
    
    set(SMAN.handles(A.KC).h_MATfile,'visible','on');
    set(SMAN.handles(A.KC).h_MATint,'visible','off');
    set(SMAN.handles(A.KC).h_MATconc,'visible','off');
    set(SMAN.handles(A.KC).h_MATunit,'visible','on','value',2);
    set(SMAN.handles(A.KC).h_SIGconstraint1_popup,'visible','off');
    set(SMAN.handles(A.KC).h_SIG1concis,'visible','off');
    set(SMAN.handles(A.KC).h_SIGsalt,'visible','off');
    set(SMAN.handles(A.KC).h_SALT_set_button,'Visible','off');
    set(SMAN.handles(A.KC).h_SIG1unit,'visible','off');
    set(SMAN.handles(A.KC).h_SIG1int,'visible','off');
    set(SMAN.handles(A.KC).h_SIGAPPLY2ALL,'visible','off');
    if A.Oxide_test ~= 0
        set(SMAN.handles(A.KC).h_MATintox,'visible','off');
        set(SMAN.handles(A.KC).h_MATconcwt,'visible','off');
        set(SMAN.handles(A.KC).h_MAToxide,'visible','on');
        set(SMAN.handles(A.KC).h_SIG1intox,'visible','off');
        set(SMAN.handles(A.KC).h_SIG1conciswt,'visible','off');
        set(SMAN.handles(A.KC).h_SIGoxide,'visible','off');
    end        
    if UNK(A.KC).sigtotal > 0
        set(SMAN.handles(A.KC).h_SIGquantbutton,'visible','on');
        set(SMAN.handles(A.KC).h_nosigwarning,'visible','off'); 
    else
        set(SMAN.handles(A.KC).h_SIGquantbutton,'visible','off');
        set(SMAN.handles(A.KC).h_nosigwarning,'visible','on'); 
    end
    if A.Fe_test ~= 0;
        set(SMAN.handles(A.KC).h_MAT_Feratio,'visible','on','string',UNK(A.KC).MAT_Fe_ratio);
        set(SMAN.handles(A.KC).h_SIG_Feratio,'visible','off');
    end;

elseif type == 3 && A.Oxide_test == 0; %i.e. total oxides
        set(SMAN.handles(A.KC).h_MATtype,'value',UNK(A.KC).MAT_corrtype);
end;
clear type;
