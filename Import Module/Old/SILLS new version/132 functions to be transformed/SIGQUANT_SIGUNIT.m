%SIGQUANT_SIGUNIT

%summoned when a unit popup is changed in the Signal Quantification window

A.KC = get(gcf,'UserData');

temp = get(gco,'tag');


if strcmp(temp,'SIG1')==1
    currentconstraint = 1;
    currenttype = get(SMAN.constraint1_popup,'value');
else
    currentconstraint = 2;
    currenttype = get(SMAN.constraint2_popup,'value');
end

if currentconstraint == 1
    
    currentunit = get(SMAN.SIG1unit,'value');
    
    if currenttype == 1 %internal standard
    
        if currentunit == 1 %i.e. ug/g
            set(SMAN.SIG1int,'visible','on');
            set(SMAN.SIG1concis,'visible','on');
            if A.Oxide_test ~= 0
                set(SMAN.SIG1intox,'visible','off');
                set(SMAN.SIG1conciswt,'visible','off');
            end
            UNK(A.KC).SIG1unit = 1;
            SIGQUANT_SIGINTSTD
            
        elseif currentunit == 2 %i.e. wt.%
            if A.Oxide_test ~= 0
                set(SMAN.SIG1int,'visible','off');
                set(SMAN.SIG1concis,'visible','off');
                set(SMAN.SIG1intox,'visible','on');
                set(SMAN.SIG1conciswt,'visible','on');
                UNK(A.KC).SIG1unit = 2;
                SIGQUANT_SIGINTSTD
            elseif A.Oxide_test == 0
                UNK(A.KC).SIG1unit = 1;
                set(SMAN.SIG1unit,'value',1);
            end
        end

    elseif currenttype == 2 || currenttype == 3 %salinity

        if currentunit == 1
            set(SMAN.SIG1unit(A.KC),'value',2);
        end

    elseif currenttype == 4 %total oxides

        if currentunit == 1
            set(SMAN.SIG1unit(A.KC),'value',2);
        end
    end
       
elseif currentconstraint == 2

    currentunit = get(SMAN.SIG2unit,'value');

    if currentunit == 1 %i.e. ug/g

        set(SMAN.SIG2int,'visible','on');
        set(SMAN.SIG2concis,'visible','on');
        if A.Oxide_test ~= 0 
            set(SMAN.SIG2intox,'visible','off');
            set(SMAN.SIG2conciswt,'visible','off');
        end
        UNK(A.KC).SIG2unit = 1;
        SIGQUANT_SIGINTSTD
        
    elseif currentunit == 2 %i.e. wt.%

        if A.Oxide_test ~= 0
            set(SMAN.SIG2int,'visible','off');
            set(SMAN.SIG2concis,'visible','off');
            set(SMAN.SIG2intox,'visible','on');
            set(SMAN.SIG2conciswt,'visible','on');
            UNK(A.KC).SIG2unit = 2;
            SIGQUANT_SIGINTSTD

        elseif A.Oxide_test == 0
            UNK(A.KC).SIG2unit = 1;
            set(SMAN.SIG2unit,'value',1)
        end
    end
end

clear temp currentconstraint currenttype currentunit 