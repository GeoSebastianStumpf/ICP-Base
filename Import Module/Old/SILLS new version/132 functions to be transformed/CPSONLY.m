%CPSONLY.m
%Callback of the "CPS data only" checkbox in the Calculation Manager
%Added in 1.0.3

if get(SMAN.figparts.h_CPSonly,'value') == 0 %i.e. option deselected

    %Set flag
    A.cpsonly = 0;

    %Restart Calculation Manager
    CALC_MANAGER;

elseif get(SMAN.figparts.h_CPSonly,'value') == 1 %i.e. option selected

    %Set flag
    A.cpsonly = 1;

    %Hide all Matrix settings: header objects
    set(SMAN.figparts.h_SMANframe2,'visible','off');
    set(SMAN.figparts.h_MAThead,'visible','off');
    set(SMAN.figparts.h_MATtypehead,'visible','off');
    set(SMAN.figparts.h_MATfilehead,'visible','off');
    set(SMAN.figparts.h_MATconchead,'visible','off');
   
    %Hide all Signal settings: header objects
    set(SMAN.figparts.h_SMANframe3,'visible','off');
    set(SMAN.figparts.h_SIGhead,'visible','off');
    set(SMAN.figparts.h_SIGtypehead,'visible','off');
    set(SMAN.figparts.h_SIGconchead,'visible','off');

    %Hide Fe-specific header objects
    if A.Fe_test ~= 0
        set(SMAN.figparts.h_MAT_Feratiohead,'visible','off');
        set(SMAN.figparts.h_SIG_Feratiohead,'visible','off');
    end


    for c = 1:A.UNK_num

        %Hide all Matrix settings: unknown objects
        set(SMAN.handles(c).h_MATtype,'visible','off');
        set(SMAN.handles(c).h_MATfile,'visible','off');
        set(SMAN.handles(c).h_MATconc,'visible','off');
        set(SMAN.handles(c).h_MATunit,'visible','off');
        set(SMAN.handles(c).h_MATint,'visible','off');
        set(SMAN.handles(c).h_MATAPPLY2ALL,'visible','off');

        %Hide all Signal settings: unknown objects
        set(SMAN.handles(c).h_SIGconstraint1_popup,'visible','off');
        set(SMAN.handles(c).h_SIG1concis,'visible','off');
        set(SMAN.handles(c).h_SIG1unit,'visible','off');
        set(SMAN.handles(c).h_SIG1int,'visible','off');
        set(SMAN.handles(c).h_SIGsalt,'visible','off');
        set(SMAN.handles(c).h_SALT_set_button,'visible','off');
        set(SMAN.handles(c).h_SIGAPPLY2ALL,'visible','off');
        set(SMAN.handles(c).h_SIGquantbutton,'visible','off');
        set(SMAN.handles(c).h_nosigwarning,'visible','off');

        %Hide all oxide-specific unknown objects
        if A.Oxide_test ~= 0
            set(SMAN.handles(c).h_MATconcwt,'visible','off');
            set(SMAN.handles(c).h_MATintox,'visible','off');
            set(SMAN.handles(c).h_MAToxide,'visible','off');
            set(SMAN.handles(c).h_SIG1conciswt,'visible','off');
            set(SMAN.handles(c).h_SIG1intox,'visible','off');
            set(SMAN.handles(c).h_SIGoxide,'visible','off');
        end

        %Hide Fe-specific unknown objects
        if A.Fe_test ~= 0
            set(SMAN.handles(c).h_MAT_Feratio,'visible','off');
            set(SMAN.handles(c).h_SIG_Feratio,'visible','off');
        end

        %Move plot, copy and delete options to the left
        set(SMAN.handles(c).h_PLOT,'Position',[360*sf(1) (885-20*c)*sf(2) 35*sf(1) 20*sf(2)]);
        set(SMAN.handles(c).h_COPY,'Position',[400*sf(1) (885-20*c)*sf(2) 35*sf(1) 20*sf(2)]);
        set(SMAN.handles(c).h_DELETE,'Position',[440*sf(1) (885-20*c)*sf(2) 40*sf(1) 20*sf(2)]);
    end
    
    %Button to redefine ratios
    redefine = uicontrol(SMAN.h_SMAN,'style','pushbutton','string','Redefine Ratios',...
        'Callback','mode=''sman'';STDRATIO;','position',[360*sf(1) 900*sf(2) 120*sf(1) 40*sf(2)]);
    if ~isfield(A,'ratios') %i.e. ratios not yet defined
        set(redefine,'string','Define Ratios');
    end

    clear c redefine
end

    
    
    
    
    
    
    