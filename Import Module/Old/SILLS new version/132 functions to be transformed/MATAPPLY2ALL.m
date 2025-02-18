%MATAPPLY2ALL

%This callback updates the Calculation Manager window when the matrix's 'Apply to
%All' button is pressed

A.KC = get(gco,'Userdata');

if UNK(A.KC).MAT_corrtype == 1 %i.e. no matrix correction

    for c = 1:A.UNK_num;
        UNK(c).MAT_corrtype = UNK(A.KC).MAT_corrtype;
        set(SMAN.handles(c).h_MATtype,'Value',1);
        set(SMAN.handles(c).h_MATfile,'visible','off');
        set(SMAN.handles(c).h_MATint,'visible','off');
        set(SMAN.handles(c).h_MATintox,'Visible','off');
        set(SMAN.handles(c).h_MATconc,'visible','off');
        set(SMAN.handles(c).h_MATconcwt,'visible','off');
        set(SMAN.handles(c).h_MAToxide,'visible','off');
        set(SMAN.handles(c).h_MATunit,'visible','off');
        if UNK(c).sigtotal > 0 %i.e. a signal window exists
            if UNK(c).SIG_constraint1 == 1 %i.e. internal standard
                    set(SMAN.handles(c).h_SIGconstraint1_popup,'Visible','on','value',UNK(c).SIG_constraint1);
                if UNK(c).SIG1unit == 1 %i.e. ug/g
                    set(SMAN.handles(c).h_SIG1int,'Visible','on','value',UNK(c).SIGQIS1iso);
                    set(SMAN.handles(c).h_SIG1intox,'Visible','off');
                    set(SMAN.handles(c).h_SIG1concis,'Visible','on','string',UNK(c).SIGQIS1_conc);
                    set(SMAN.handles(c).h_SIG1conciswt,'Visible','off');
                elseif UNK(c).SIG1unit == 2 %i.e. wt.%  
                    set(SMAN.handles(c).h_SIG1int,'Visible','off');
                    set(SMAN.handles(c).h_SIG1intox,'Visible','on','value',UNK(c).SIGQIS1ox);
                    set(SMAN.handles(c).h_SIG1concis,'Visible','off');
                    set(SMAN.handles(c).h_SIG1conciswt,'Visible','on','string',UNK(c).SIGQIS1_concwt);
                end
                    set(SMAN.handles(c).h_SIG1unit,'Visible','on','value',UNK(c).SIG1unit);
                    set(SMAN.handles(c).h_SIGsalt,'Visible','off');
                    set(SMAN.handles(c).h_SALT_set_button,'Visible','off');
                    set(SMAN.handles(c).h_SIGoxide,'Visible','off');
                    set(SMAN.handles(c).h_SIGAPPLY2ALL,'Visible','on');
                    set(SMAN.handles(c).h_SIGquantbutton,'Visible','off');
                    if A.Fe_test ~= 0;
                        set(SMAN.handles(c).h_SIG_Feratio,'visible','off');
                    end
            elseif UNK(c).SIG_constraint1 == 2 || UNK(c).SIG_constraint1 == 3 %i.e. salinity
                set(SMAN.handles(c).h_SIGconstraint1_popup,'Visible','on','value',UNK(c).SIG_constraint1);
                set(SMAN.handles(c).h_SIG1concis,'Visible','off');
                set(SMAN.handles(c).h_SIG1conciswt,'Visible','off');
                set(SMAN.handles(c).h_SIGsalt,'Visible','on','string',UNK(c).SIGsalinity);
                set(SMAN.handles(c).h_SALT_set_button,'Visible','on');
                set(SMAN.handles(c).h_SIGoxide,'Visible','off');
                set(SMAN.handles(c).h_SIG1unit,'Visible','on','value',2);
                set(SMAN.handles(c).h_SIG1int,'Visible','off');
                set(SMAN.handles(c).h_SIG1intox,'Visible','off');
                set(SMAN.handles(c).h_SIGAPPLY2ALL,'Visible','on');
                set(SMAN.handles(c).h_SIGquantbutton,'Visible','off');
                if A.Fe_test ~= 0;
                    set(SMAN.handles(c).h_SIG_Feratio,'visible','off');
                end
            elseif UNK(c).SIG_constraint1 == 4 %i.e. total oxide
                set(SMAN.handles(c).h_SIGconstraint1_popup,'Visible','on','value',UNK(c).SIG_constraint1);
                set(SMAN.handles(c).h_SIG1concis,'Visible','off');
                set(SMAN.handles(c).h_SIG1conciswt,'Visible','off');
                set(SMAN.handles(c).h_SIGsalt,'Visible','off');
                set(SMAN.handles(c).h_SALT_set_button,'Visible','off');
                set(SMAN.handles(c).h_SIGoxide,'Visible','on','string',UNK(c).SIG_oxide_total);
                set(SMAN.handles(c).h_SIG1unit,'Visible','on','value',2);
                set(SMAN.handles(c).h_SIG1int,'Visible','off');
                set(SMAN.handles(c).h_SIG1intox,'Visible','off');
                set(SMAN.handles(c).h_SIGAPPLY2ALL,'Visible','on');
                set(SMAN.handles(c).h_SIGquantbutton,'Visible','off');
                if A.Fe_test ~= 0;
                    set(SMAN.handles(c).h_SIG_Feratio,'visible','on','value',UNK(c).SIG_Fe_ratio);
                end
            end
        else
            set(SMAN.handles(c).h_SIGconstraint1_popup,'Visible','off');
            set(SMAN.handles(c).h_SIG1concis,'Visible','off');
            set(SMAN.handles(c).h_SIG1conciswt,'Visible','off');
            set(SMAN.handles(c).h_SIGsalt,'Visible','off');
            set(SMAN.handles(c).h_SALT_set_button,'Visible','off');
            set(SMAN.handles(c).h_SIGoxide,'Visible','off');
            set(SMAN.handles(c).h_SIG1unit,'Visible','off');
            set(SMAN.handles(c).h_SIG1int,'Visible','off');
            set(SMAN.handles(c).h_SIG1intox,'Visible','off');
            set(SMAN.handles(c).h_SIGAPPLY2ALL,'Visible','off');
            set(SMAN.handles(c).h_SIGquantbutton,'Visible','off');
            if A.Fe_test ~= 0;
                set(SMAN.handles(c).h_SIG_Feratio,'visible','off');
            end
        end
        if A.Fe_test ~= 0;
            set(SMAN.handles(c).h_MAT_Feratio,'visible','off');
        end
    end

elseif UNK(A.KC).MAT_corrtype == 2 %i.e. internal standard

    for c = 1:A.UNK_num;
        UNK(c).MAT_corrtype = UNK(A.KC).MAT_corrtype;
        set(SMAN.handles(c).h_MATtype,'Value',2);
        set(SMAN.handles(c).h_MATfile,'visible','on');
        if UNK(A.KC).MATunit == 1 %i.e. ug/g
            UNK(c).MATQISiso = UNK(A.KC).MATQISiso;
            UNK(c).MATQIS = UNK(A.KC).MATQIS;
            UNK(c).MATQIS_conc = UNK(A.KC).MATQIS_conc;
            UNK(c).MATunit = UNK(A.KC).MATunit;
            set(SMAN.handles(c).h_MATint,'visible','on','value',UNK(c).MATQISiso);
            set(SMAN.handles(c).h_MATconc,'visible','on','string',UNK(c).MATQIS_conc);
            set(SMAN.handles(c).h_MATintox,'visible','off');
            set(SMAN.handles(c).h_MATconcwt,'visible','off');
            set(SMAN.handles(c).h_MATunit,'visible','on','value',UNK(c).MATunit);
        else %i.e. wt.%
            UNK(c).MATQISox = UNK(A.KC).MATQISox;
            UNK(c).MATQIS = UNK(A.KC).MATQIS;
            UNK(c).MATQIS_concwt = UNK(A.KC).MATQIS_concwt;
            UNK(c).MATQIS_conc = UNK(A.KC).MATQIS_conc;
            UNK(c).MATunit = UNK(A.KC).MATunit;
            set(SMAN.handles(c).h_MATint,'visible','off');
            set(SMAN.handles(c).h_MATconc,'visible','off');
            set(SMAN.handles(c).h_MATintox,'visible','on','value',UNK(c).MATQISox);
            set(SMAN.handles(c).h_MATconcwt,'visible','on','string',UNK(c).MATQIS_concwt);
            set(SMAN.handles(c).h_MATunit,'visible','on','value',UNK(c).MATunit);
        end
        set(SMAN.handles(c).h_MAToxide,'visible','off');
        if UNK(c).sigtotal > 0 %i.e. a signal window exists
            set(SMAN.handles(c).h_SIGconstraint1_popup,'Visible','off');
            set(SMAN.handles(c).h_SIG1concis,'Visible','off');
            set(SMAN.handles(c).h_SIG1conciswt,'Visible','off');
            set(SMAN.handles(c).h_SIGsalt,'Visible','off');
            set(SMAN.handles(c).h_SALT_set_button,'Visible','off');
            set(SMAN.handles(c).h_SIGoxide,'Visible','off');
            set(SMAN.handles(c).h_SIG1unit,'Visible','off');
            set(SMAN.handles(c).h_SIG1int,'Visible','off');
            set(SMAN.handles(c).h_SIG1intox,'Visible','off');
            set(SMAN.handles(c).h_SIGAPPLY2ALL,'Visible','off');
            set(SMAN.handles(c).h_SIGquantbutton,'Visible','on');
            if A.Fe_test ~= 0;
                set(SMAN.handles(c).h_SIG_Feratio,'visible','off');
            end
        end
        if A.Fe_test ~= 0;
            set(SMAN.handles(c).h_MAT_Feratio,'visible','off');
        end
    end


elseif UNK(A.KC).MAT_corrtype == 3 %i.e. total oxide

    for c = 1:A.UNK_num;
        UNK(c).MAT_corrtype = UNK(A.KC).MAT_corrtype;
        set(SMAN.handles(c).h_MATtype,'Value',3);
        set(SMAN.handles(c).h_MATfile,'visible','on');
        set(SMAN.handles(c).h_MATint,'visible','off');
        set(SMAN.handles(c).h_MATconc,'visible','off');
        set(SMAN.handles(c).h_MATintox,'visible','off');
        set(SMAN.handles(c).h_MATconcwt,'visible','off');
        UNK(c).MAT_oxide_total = UNK(A.KC).MAT_oxide_total;
        set(SMAN.handles(c).h_MAToxide,'visible','on','string',UNK(c).MAT_oxide_total);
        set(SMAN.handles(c).h_MATunit,'visible','on','value',2);
        if UNK(c).sigtotal > 0 %i.e. a signal window exists
            set(SMAN.handles(c).h_SIGconstraint1_popup,'Visible','off');
            set(SMAN.handles(c).h_SIG1concis,'Visible','off');
            set(SMAN.handles(c).h_SIG1conciswt,'Visible','off');
            set(SMAN.handles(c).h_SIGsalt,'Visible','off');
            set(SMAN.handles(c).h_SALT_set_button,'Visible','off');
            set(SMAN.handles(c).h_SIGoxide,'Visible','off');
            set(SMAN.handles(c).h_SIG1unit,'Visible','off');
            set(SMAN.handles(c).h_SIG1int,'Visible','off');
            set(SMAN.handles(c).h_SIG1intox,'Visible','off');
            set(SMAN.handles(c).h_SIGAPPLY2ALL,'Visible','off');
            set(SMAN.handles(c).h_SIGquantbutton,'Visible','on');
            if A.Fe_test ~= 0;
                set(SMAN.handles(c).h_SIG_Feratio,'visible','off');
            end
            if A.Fe_test ~= 0;
                set(SMAN.handles(c).h_MAT_Feratio,'visible','off');
            end
        end
        if A.Fe_test ~= 0;
            UNK(c).MAT_Fe_ratio = UNK(A.KC).MAT_Fe_ratio;
            set(SMAN.handles(c).h_MAT_Feratio,'visible','on','string',UNK(c).MAT_Fe_ratio);
        end
    end
end
