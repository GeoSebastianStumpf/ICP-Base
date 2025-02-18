%MATUNIT

%summoned when the unit popup is changed in the Calculation Settings

A.KC = get(gco,'Userdata');
currentunit = get(gco,'value');
currenttype = get(SMAN.handles(A.KC).h_MATtype,'value');

if currenttype == 2 %internal standard
    
    if currentunit == 1 %i.e. ug/g
        
        set(SMAN.handles(A.KC).h_MATint,'visible','on');
        set(SMAN.handles(A.KC).h_MATconc,'visible','on');
        if A.Oxide_test ~= 0
            set(SMAN.handles(A.KC).h_MATintox,'visible','off');
            set(SMAN.handles(A.KC).h_MATconcwt,'visible','off');
        end
        UNK(A.KC).MATunit = 1;
        MATINTSTD;        

    elseif currentunit == 2 %i.e. wt.%

        if A.Oxide_test ~= 0
            set(SMAN.handles(A.KC).h_MATint,'visible','off');
            set(SMAN.handles(A.KC).h_MATconc,'visible','off');
            set(SMAN.handles(A.KC).h_MATintox,'visible','on');
            set(SMAN.handles(A.KC).h_MATconcwt,'visible','on');
            UNK(A.KC).MATunit = 2;
            MATINTSTD;
        elseif A.Oxide_test == 0 %i.e. no oxide elements measured
            UNK(A.KC).MATunit = 1;
            set(SMAN.handles(A.KC).h_MATunit,'value',1);
        end
    end
elseif currenttype == 3 %total oxide
    
    if currentunit == 1
        set(SMAN.handles(A.KC).h_MATunit,'value',2);
    end
end
clear currentunit currenttype
