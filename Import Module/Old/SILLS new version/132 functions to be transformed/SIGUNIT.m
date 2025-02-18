%SIGUNIT

%summoned when the unit popup is changed in the Calculation Settings

A.KC = get(gco,'Userdata');
currentunit = get(gco,'value');
currenttype = get(SMAN.handles(A.KC).h_SIGconstraint1_popup,'value');

if currenttype == 1 %internal standard
    
    if currentunit == 1 %i.e. ug/g
        
        set(SMAN.handles(A.KC).h_SIG1int,'visible','on');
        set(SMAN.handles(A.KC).h_SIG1concis,'visible','on');
        if A.Oxide_test ~= 0
            set(SMAN.handles(A.KC).h_SIG1intox,'visible','off');
            set(SMAN.handles(A.KC).h_SIG1conciswt,'visible','off');
        end
        UNK(A.KC).SIG1unit = 1;
        SIGINTSTD;        
        
    elseif currentunit == 2 %i.e. wt.%

        if A.Oxide_test ~= 0
            set(SMAN.handles(A.KC).h_SIG1int,'visible','off');
            set(SMAN.handles(A.KC).h_SIG1concis,'visible','off');
            set(SMAN.handles(A.KC).h_SIG1intox,'visible','on');
            set(SMAN.handles(A.KC).h_SIG1conciswt,'visible','on');
            UNK(A.KC).SIG1unit = 2;
            SIGINTSTD;        
        elseif A.Oxide_test == 0
            UNK(A.KC).SIG1unit = 1;
            set(SMAN.handles(A.KC).h_SIG1unit,'value',1);
        end
    end

elseif currenttype == 2 || currenttype == 3 %salinity
    
    if currentunit == 1
        set(SMAN.handles(A.KC).h_SIG1unit,'value',2);
    end

elseif currenttype == 4 %total oxides
    
    if currentunit == 1
        set(SMAN.handles(A.KC).h_SIG1unit,'value',2);
    end

end

clear currentunit currenttype