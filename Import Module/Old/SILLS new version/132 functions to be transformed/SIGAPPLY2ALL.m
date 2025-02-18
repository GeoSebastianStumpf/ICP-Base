%SIGAPPLY2ALL

%This callback updates the Calculation Manager window when the signal's 'Apply to
%All' button is pressed

A.KC = get(gco,'Userdata');

for c = 1:A.UNK_num;

    if UNK(c).sigtotal > 0 %i.e. a signal window exists

        if UNK(A.KC).SIG_constraint1 == 1 %i.e. internal standard

            UNK(c).SIG_constraint1 = UNK(A.KC).SIG_constraint1;

            if UNK(A.KC).SIG1unit == 1; %i.e. ug/g

                UNK(c).SIGQIS1 = UNK(A.KC).SIGQIS1;
                UNK(c).SIGQIS1iso = UNK(A.KC).SIGQIS1iso;
                UNK(c).SIGQIS1_conc = UNK(A.KC).SIGQIS1_conc;
                UNK(c).SIG1unit  = UNK(A.KC).SIG1unit;

                set(SMAN.handles(c).h_SIGconstraint1_popup,'Visible','on','value',1);
                set(SMAN.handles(c).h_SIG1concis,'Visible','on','string',UNK(c).SIGQIS1_conc);
                set(SMAN.handles(c).h_SIG1int,'Visible','on','value',UNK(c).SIGQIS1iso);
                set(SMAN.handles(c).h_SIG1unit,'Visible','on','value',UNK(c).SIG1unit);
                
                if A.Oxide_test ~= 0
                    set(SMAN.handles(c).h_SIG1conciswt,'Visible','off');
                    set(SMAN.handles(c).h_SIG1intox,'Visible','off');
                end

            elseif UNK(A.KC).SIG1unit == 2; %i.e. wt.%

                UNK(c).SIGQIS1 = UNK(A.KC).SIGQIS1;
                UNK(c).SIGQIS1ox = UNK(A.KC).SIGQIS1ox;
                UNK(c).SIGQIS1_concwt = UNK(A.KC).SIGQIS1_concwt;
                UNK(c).SIG1unit  = UNK(A.KC).SIG1unit;
                
                UNK(c).SIGQIS1iso = UNK(A.KC).SIGQIS1iso; %Added in 1.0.6; against mtimes error
                UNK(c).SIGQIS1_conc = UNK(A.KC).SIGQIS1_conc; %Added in 1.0.6; against mtimes error

                set(SMAN.handles(c).h_SIGconstraint1_popup,'Visible','on','value',1);
                set(SMAN.handles(c).h_SIG1concis,'Visible','off');
                set(SMAN.handles(c).h_SIG1int,'Visible','off');
                set(SMAN.handles(c).h_SIG1unit,'Visible','on','value',UNK(c).SIG1unit);
                
                if A.Oxide_test ~= 0
                    set(SMAN.handles(c).h_SIG1conciswt,'Visible','on','string',UNK(c).SIGQIS1_concwt);
                    set(SMAN.handles(c).h_SIG1intox,'Visible','on','value',UNK(c).SIGQIS1ox);
                end
            end
            
            set(SMAN.handles(c).h_SIGsalt,'Visible','off');
            set(SMAN.handles(c).h_SALT_set_button,'Visible','off');
            set(SMAN.handles(c).h_SIGAPPLY2ALL,'Visible','on');
            set(SMAN.handles(c).h_SIGquantbutton,'Visible','off');
            if A.Oxide_test ~= 0
                set(SMAN.handles(c).h_SIGoxide,'Visible','off');
            end        
            if A.Fe_test ~= 0;
                set(SMAN.handles(c).h_SIG_Feratio,'visible','off');
            end

            
        elseif UNK(A.KC).SIG_constraint1 == 2 || UNK(A.KC).SIG_constraint1 == 3 %i.e. salinity

            UNK(c).SIG_constraint1 = UNK(A.KC).SIG_constraint1;
            UNK(c).SIGsalinity = UNK(A.KC).SIGsalinity;
            UNK(c).SALT_mass_balance_factor = UNK(A.KC).SALT_mass_balance_factor;
            UNK(c).SALT = UNK(A.KC).SALT;
            UNK(c).SIG1unit  = UNK(A.KC).SIG1unit;

            set(SMAN.handles(c).h_SIGconstraint1_popup,'Visible','on','value',UNK(c).SIG_constraint1);
            set(SMAN.handles(c).h_SIG1concis,'Visible','off');
            set(SMAN.handles(c).h_SIG1conciswt,'Visible','off');
            set(SMAN.handles(c).h_SIG1int,'Visible','off');
            set(SMAN.handles(c).h_SIG1intox,'Visible','off');
            set(SMAN.handles(c).h_SIG1unit,'Visible','on','value',2)
            set(SMAN.handles(c).h_SIGsalt,'Visible','on','string',UNK(c).SIGsalinity);
            set(SMAN.handles(c).h_SALT_set_button,'Visible','on');
            set(SMAN.handles(c).h_SIGoxide,'Visible','off');
            set(SMAN.handles(c).h_SIGAPPLY2ALL,'Visible','on');
            set(SMAN.handles(c).h_SIGquantbutton,'Visible','off');
            if A.Fe_test ~= 0;
                set(SMAN.handles(c).h_SIG_Feratio,'visible','off');
            end

        elseif UNK(A.KC).SIG_constraint1 == 4 %i.e. total oxide (this can't be accessed unless A.Oxide_test ~= 0)

            UNK(c).SIG_constraint1 = UNK(A.KC).SIG_constraint1;
            UNK(c).SIG_oxide_total = UNK(A.KC).SIG_oxide_total;
            UNK(c).SIG1unit  = UNK(A.KC).SIG1unit;

            set(SMAN.handles(c).h_SIGconstraint1_popup,'Visible','on','value',UNK(c).SIG_constraint1);
            set(SMAN.handles(c).h_SIG1concis,'Visible','off');
            set(SMAN.handles(c).h_SIG1conciswt,'Visible','off');
            set(SMAN.handles(c).h_SIG1int,'Visible','off');
            set(SMAN.handles(c).h_SIG1intox,'Visible','off');
            set(SMAN.handles(c).h_SIG1unit,'Visible','on','value',2);
            set(SMAN.handles(c).h_SIGsalt,'Visible','off');
            set(SMAN.handles(c).h_SALT_set_button,'Visible','off');
            set(SMAN.handles(c).h_SIGoxide,'Visible','on','string',UNK(c).SIG_oxide_total);
            set(SMAN.handles(c).h_SIGAPPLY2ALL,'Visible','on');
            set(SMAN.handles(c).h_SIGquantbutton,'Visible','off');
            if A.Fe_test ~= 0;
                UNK(c).SIG_Fe_ratio = UNK(A.KC).SIG_Fe_ratio;
                set(SMAN.handles(c).h_SIG_Feratio,'visible','on','string',UNK(c).SIG_Fe_ratio);
            end
        end
    end

    %set all the matrix correction settings to 'none'
    if UNK(c).MAT_corrtype ~= 1 
        set(SMAN.handles(c).h_MATtype,'value',1);
        set(SMAN.handles(c).h_MATfile,'visible','off');
        set(SMAN.handles(c).h_MATint,'visible','off');
        set(SMAN.handles(c).h_MATconc,'visible','off');
        set(SMAN.handles(c).h_MATunit,'visible','off');
        if A.Oxide_test ~= 0
            set(SMAN.handles(c).h_MATintox,'visible','off');
            set(SMAN.handles(c).h_MATconcwt,'visible','off');
            set(SMAN.handles(c).h_MAToxide,'visible','off');
        end
    end
        
end
