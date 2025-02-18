% SIGQUANT_SETTINGS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback that defines the quantification settings for a given unknown
% file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Test to see if there is a Signal Quantification figure already open;
%if so, close it:
if A.SIGQUANT_open == 1
    delete(SMAN.sigquant_fig);
end

%declare the Signal Quantification figure open
A.SIGQUANT_open = 1;

%get the current unknown
A.KC = get(gco,'Userdata');

SIGQUANT_SIGSALT = ['A.KC = get(gcf,''Userdata'');'...
    'salt_conc = get(SMAN.SIGsalt,''string'');'...
    'salt_conc = str2num(salt_conc);'...
    'if salt_conc < 0 || salt_conc > 100;'...
    'msgbox(''Invalid Entry'');'...
    'return;'...
    'else;'...
    'UNK(A.KC).SIGsalinity = salt_conc;'...
    'end;'...
    'clear salt_conc;'];
SIGQUANT_SIGINTSTD_oxide = ['A.KC = get(gcf,''Userdata'');'...
    'intstd_oxide = get(SMAN.SIGoxide,''string'');'...
    'intstd_oxide = str2num(intstd_oxide);'...
    'if intstd_oxide < 0 || intstd_oxide > 100;'...
    'msgbox(''Invalid Entry;'');'...
    'return;'...
    'else;'...
    'UNK(A.KC).SIG_oxide_total = intstd_oxide;'...
    'end;'...
    'clear intstd_oxide;'];
SIGQUANT_SIGFeratio = ['A.KC = get(gcf,''Userdata'');'...
    'Fe_ratio = get(gco,''string'');'...
    'Fe_ratio = str2num(Fe_ratio);'...
    'if Fe_ratio < 0 || Fe_ratio > 1;'...
    'msgbox(''Invalid Entry'');'...
    'return;'...
    'else;'...
    'UNK(A.KC).SIG_Fe_ratio = Fe_ratio;'...
    'end;'...
    'clear Fe_ratio;'];
SIGQUANT_SIGtracer = ['A.KC = get(gcf,''Userdata'');'...
    'tracer = get(gco,''value'');'...
    'UNK(A.KC).SIG_tracer = tracer;'...
    'clear tracer;'];

SMAN.sigquant_fig =         figure('name','Sample Quantification Settings','tag','SMAN.sigquant_fig','UserData',A.KC,...
    'Color',[1 1 1],'NumberTitle','off','position',[500*sf(1) 300*sf(2) 550*sf(1) 405*sf(2)],'menubar','none','CloseRequestFcn','figure(SMAN.h_SMAN);figure(SMAN.sigquant_fig);A.SIGQUANT_open=0;delete(gcf);'); %Changed in 1.0.6

SMAN.sigframe1 =        uipanel(SMAN.sigquant_fig,'units','pixels','BackgroundColor',[.9 .9 .9],'position',[10*sf(1) 220*sf(2) 530*sf(1) 130*sf(2)]);
SMAN.sigframe2 =        uipanel(SMAN.sigquant_fig,'units','pixels','BackgroundColor',[.9 .9 .9],'position',[10*sf(1) 10*sf(2) 530*sf(1) 200*sf(2)]);

SMAN.sigfile_header =   uicontrol(SMAN.sigquant_fig,'style','text','string','File:','HorizontalAlignment','left','Fontweight','bold','BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'position',[20*sf(1) 360*sf(2) 30*sf(1) 20*sf(2)]);
SMAN.sigfile_item =     uicontrol(SMAN.sigquant_fig,'style','text','string',UNK(A.KC).fileinfo.name,'HorizontalAlignment','left','BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'position',[60*sf(1) 360*sf(2) 180*sf(1) 20*sf(2)]);
SMAN.SIG1APPLY2ALL =    uicontrol(SMAN.sigquant_fig,'style','pushbutton','tag','SIG1','string','Apply to All','Callback','SIGQUANT_APPLY2ALL','position',[460*sf(1) 230*sf(2) 70*sf(1) 20*sf(2)]);
SMAN.SIG2APPLY2ALL =    uicontrol(SMAN.sigquant_fig,'style','pushbutton','tag','SIG2','string','Apply to All','Callback','SIGQUANT_APPLY2ALL','position',[460*sf(1) 20*sf(2) 70*sf(1) 20*sf(2)]);

SMAN.constraint1_header = uicontrol(SMAN.sigquant_fig,'style','text','string','Constraint 1','HorizontalAlignment','left','Fontweight','bold','BackgroundColor',[.9 .9 .9],'ForegroundColor',[0 0 0],'position',[20*sf(1) 320*sf(2) 100*sf(1) 20*sf(2)]);
SMAN.constraint1_popup = uicontrol(SMAN.sigquant_fig,'style','popup','tag','constraint1_popup','Value',UNK(A.KC).SIG_constraint1,'Callback','SIGCONSTRAINT_SET','string',{'internal standard';'eq. wt% NaCl (mass balance)';'eq. wt% NaCl (charge balance)';'total oxides (major elements)'},'HorizontalAlignment','right','BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'position',[20*sf(1) 290*sf(2) 180*sf(1) 20*sf(2)]);

SMAN.constraint2_header = uicontrol(SMAN.sigquant_fig,'style','text','string','Constraint 2','HorizontalAlignment','left','Fontweight','bold','BackgroundColor',[.9 .9 .9],'ForegroundColor',[0 0 0],'position',[20*sf(1) 180*sf(2) 100*sf(1) 20*sf(2)]);
SMAN.constraint2_popup = uicontrol(SMAN.sigquant_fig,'style','popup','tag','constraint2_popup','Value',UNK(A.KC).SIG_constraint2,'Callback','SIGCONSTRAINT_SET','string',{'matrix-only tracer';'2nd internal standard'},'Value',UNK(A.KC).SIG_constraint2,'HorizontalAlignment','right','BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'position',[20*sf(1) 150*sf(2) 180*sf(1) 20*sf(2)]);

SMAN.SIGconc_header1 =   uicontrol(SMAN.sigquant_fig,'style','text','string','Value','HorizontalAlignment','center','BackgroundColor',[.9 .9 .9],'ForegroundColor',[0 0 0],'position',[270*sf(1) 310*sf(2) 70*sf(1) 20*sf(2)]);
SMAN.SIGconc_header2 =   uicontrol(SMAN.sigquant_fig,'style','text','string','Value','HorizontalAlignment','center','BackgroundColor',[.9 .9 .9],'ForegroundColor',[0 0 0],'position',[270*sf(1) 170*sf(2) 70*sf(1) 20*sf(2)]);

SMAN.SIG1concis =       uicontrol(SMAN.sigquant_fig,'style','edit','tag','SIG1','Callback','SIGQUANT_SIGINTSTD','BackgroundColor',[1 1 1],'string',UNK(A.KC).SIGQIS1_conc,'ForegroundColor',[0 0 0],'HorizontalAlignment','right','position',[270*sf(1) 290*sf(2) 70*sf(1) 20*sf(2)]);
SMAN.SIGsalt =          uicontrol(SMAN.sigquant_fig,'style','edit','Callback',SIGQUANT_SIGSALT,'BackgroundColor',[.8 .8 .8],'string',UNK(A.KC).SIGsalinity,'ForegroundColor',[0 0 0],'HorizontalAlignment','right','position',[270*sf(1) 290*sf(2) 70*sf(1) 20*sf(2)]);
SMAN.SIG1unit =         uicontrol(SMAN.sigquant_fig,'style','popup','tag','SIG1','Callback','SIGQUANT_SIGUNIT','BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','left','string',{'ug/g';'wt.%'},'value',UNK(A.KC).SIG1unit,'position',[345*sf(1) 290*sf(2) 50*sf(1) 20*sf(2)]);
SMAN.SIG1int =          uicontrol(SMAN.sigquant_fig,'style','popup','tag','SIG1','Callback','SIGQUANT_SIGINTSTD','string',A.ISOTOPES_in_all_SRMs,'Value',UNK(A.KC).SIGQIS1iso,'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','right','position',[405*sf(1) 290*sf(2) 70*sf(1) 20*sf(2)]);
SMAN.SALT_set_button =  uicontrol(SMAN.sigquant_fig,'style','pushbutton','string','ELEMENTS','Callback','SALTSET','position',[405*sf(1) 290*sf(2) 70*sf(1) 20*sf(2)]);

if A.Oxide_test ~= 0
    SMAN.SIG1conciswt =     uicontrol(SMAN.sigquant_fig,'style','edit','tag','SIG1','Callback','SIGQUANT_SIGINTSTD','BackgroundColor',[.9 .9 .9],'string',UNK(A.KC).SIGQIS1_concwt,'ForegroundColor',[0 0 0],'HorizontalAlignment','right','position',[270*sf(1) 290*sf(2) 70*sf(1) 20*sf(2)]);
    SMAN.SIG1intox =        uicontrol(SMAN.sigquant_fig,'style','popup','tag','SIG1','Callback','SIGQUANT_SIGINTSTD','string',A.OXIDES_in_all_SRMs,'Value',UNK(A.KC).SIGQIS1ox,'BackgroundColor',[.9 .9 .9],'ForegroundColor',[0 0 0],'HorizontalAlignment','right','position',[405*sf(1) 290*sf(2) 70*sf(1) 20*sf(2)]);
    SMAN.SIGoxide =         uicontrol(SMAN.sigquant_fig,'style','edit','Callback',SIGQUANT_SIGINTSTD_oxide,'string',UNK(A.KC).SIG_oxide_total,'BackgroundColor',[0 0 0],'ForegroundColor',[1 1 1],'HorizontalAlignment','right','position',[270*sf(1) 290*sf(2) 70*sf(1) 20*sf(2)]);
end
    
if A.Fe_test ~= 0;
    SMAN.SIG_Feheader = uicontrol(SMAN.sigquant_fig,'style','text','string','FeO /  (FeO+Fe2O3)','BackgroundColor',[.9 .9 .9],'ForegroundColor',[0 0 0],'position',[405*sf(1) 300*sf(2) 70*sf(1) 40*sf(2)]);
    SMAN.SIG_Feratio =     uicontrol(SMAN.sigquant_fig,'style','edit','Callback',SIGQUANT_SIGFeratio,'string',UNK(A.KC).SIG_Fe_ratio,'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','right','position',[405*sf(1) 290*sf(2) 70*sf(1) 20*sf(2)]);
end

SMAN.SIGtracer =        uicontrol(SMAN.sigquant_fig,'style','popup','Callback',SIGQUANT_SIGtracer,'string',A.ISOTOPE_list,'Value',UNK(A.KC).SIG_tracer,'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'position',[270*sf(1) 150*sf(2) 70*sf(1) 20*sf(2)]);
SMAN.SIG2concis =       uicontrol(SMAN.sigquant_fig,'style','edit','tag','SIG2','Callback','SIGQUANT_SIGINTSTD','BackgroundColor',[1 1 1],'string',UNK(A.KC).SIGQIS2_conc,'ForegroundColor',[0 0 0],'HorizontalAlignment','right','position',[270*sf(1) 150*sf(2) 70*sf(1) 20*sf(2)]);
SMAN.SIG2unit =         uicontrol(SMAN.sigquant_fig,'style','popup','tag','SIG2','Callback','SIGQUANT_SIGUNIT','BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','left','string',{'ug/g';'wt.%'},'value',UNK(A.KC).SIG2unit,'position',[345*sf(1) 150*sf(2) 50*sf(1) 20*sf(2)]);
SMAN.SIG2int =          uicontrol(SMAN.sigquant_fig,'style','popup','tag','SIG2','Callback','SIGQUANT_SIGINTSTD','string',A.ISOTOPES_in_all_SRMs,'Value',UNK(A.KC).SIGQIS2iso,'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','right','position',[405*sf(1) 150*sf(2) 70*sf(1) 20*sf(2)]);

if A.Oxide_test ~= 0
    SMAN.SIG2conciswt =     uicontrol(SMAN.sigquant_fig,'style','edit','tag','SIG2','Callback','SIGQUANT_SIGINTSTD','BackgroundColor',[.9 .9 .9],'string',UNK(A.KC).SIGQIS2_concwt,'ForegroundColor',[0 0 0],'HorizontalAlignment','right','position',[270*sf(1) 150*sf(2) 70*sf(1) 20*sf(2)]);
    SMAN.SIG2intox =        uicontrol(SMAN.sigquant_fig,'style','popup','tag','SIG2','Callback','SIGQUANT_SIGINTSTD','string',A.OXIDES_in_all_SRMs,'Value',UNK(A.KC).SIGQIS2ox,'BackgroundColor',[.9 .9 .9],'ForegroundColor',[0 0 0],'HorizontalAlignment','right','position',[405*sf(1) 150*sf(2) 70*sf(1) 20*sf(2)]);
end

% Now define which uicontrol elements need to be visible/invisible

quanttype1 = get(SMAN.constraint1_popup,'value');

if quanttype1 == 1 %i.e. internal standard
    set(SMAN.SIGconc_header1,'visible','on');

    if UNK(A.KC).SIG1unit == 1 %i.e. ug/g
        set(SMAN.SIG1int,'visible','on');
        set(SMAN.SIG1concis,'visible','on');
        set(SMAN.SIG1unit,'visible','on');
        if A.Oxide_test ~= 0
            set(SMAN.SIG1intox,'visible','off');
            set(SMAN.SIG1conciswt,'visible','off');
        end
    elseif UNK(A.KC).SIG1unit == 2 %i.e. wt.%
        if A.Oxide_test ~= 0
            set(SMAN.SIG1int,'visible','off');
            set(SMAN.SIG1intox,'visible','on');
            set(SMAN.SIG1concis,'visible','off');
            set(SMAN.SIG1conciswt,'visible','on');
            set(SMAN.SIG1unit,'visible','on');
        elseif A.Oxide_test == 0
            set(SMAN.SIG1int,'visible','on');
            set(SMAN.SIG1intox,'visible','off');
            set(SMAN.SIG1concis,'visible','on');
            set(SMAN.SIG1conciswt,'visible','off');
            set(SMAN.SIG1unit,'visible','on','value',1);
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

elseif quanttype1 == 2 || quanttype1 == 3 %i.e. equiv wt% NaCl
    set(SMAN.SIG1int,'visible','off');
    set(SMAN.SIG1concis,'visible','off');
    if A.Oxide_test ~= 0
        set(SMAN.SIG1intox,'visible','off');
        set(SMAN.SIG1conciswt,'visible','off');
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
    set(SMAN.SIGoxide,'visible','off');
    if A.Fe_test ~= 0;
        set(SMAN.SIG_Feheader,'visible','off');
        set(SMAN.SIG_Feratio,'visible','off');
    end

elseif quanttype1 == 4 % i.e. total oxides (major elements)
    set(SMAN.SIGconc_header1,'visible','on');
    set(SMAN.SIG1int,'visible','off');
    set(SMAN.SIG1concis,'visible','off');
    set(SMAN.SIGsalt,'visible','off');
    set(SMAN.SALT_set_button,'visible','off');
    set(SMAN.SIG1unit,'visible','on','value',2);
    if A.Oxide_test ~= 0
        set(SMAN.SIG1intox,'visible','off');
        set(SMAN.SIG1conciswt,'visible','off');
        set(SMAN.SIGoxide,'visible','on');
    end
    if A.Fe_test ~= 0;
        set(SMAN.SIG_Feheader,'visible','on');
        set(SMAN.SIG_Feratio,'visible','on');
    end
end
clear quanttype1

if UNK(A.KC).MAT_corrtype ~= 1 %i.e. a matrix correction

    quanttype1 = get(SMAN.constraint1_popup,'value');
    quanttype2 = get(SMAN.constraint2_popup,'value');

    if quanttype2 == 1  % i.e. matrix-only tracer
        set(SMAN.SIGtracer,'visible','on');
        set(SMAN.SIGconc_header2,'visible','off');
        set(SMAN.SIG2int,'visible','off');
        set(SMAN.SIG2concis,'visible','off');
        if A.Oxide_test ~= 0
            set(SMAN.SIG2intox,'visible','off');
            set(SMAN.SIG2conciswt,'visible','off');
        end
        set(SMAN.SIG2unit,'visible','off');
    
    elseif quanttype2 == 2  % i.e. internal standard
        set(SMAN.SIGtracer,'visible','off');
        set(SMAN.SIGconc_header2,'visible','on');
        if UNK(A.KC).SIG2unit == 1 %i.e. ug/g
            set(SMAN.SIG2int,'visible','on');
            set(SMAN.SIG2concis,'visible','on');
            set(SMAN.SIG2unit,'visible','on');
            if A.Oxide_test ~= 0
                set(SMAN.SIG2intox,'visible','off');
                set(SMAN.SIG2conciswt,'visible','off');
            end        
        elseif UNK(A.KC).SIG2unit == 2 %i.e. wt.%
            if A.Oxide_test ~= 0
                set(SMAN.SIG2int,'visible','off');
                set(SMAN.SIG2intox,'visible','on');
                set(SMAN.SIG2concis,'visible','off');
                set(SMAN.SIG2conciswt,'visible','on')
                set(SMAN.SIG2unit,'visible','on');
            elseif A.Oxide_test == 0
                set(SMAN.SIG2int,'visible','on');
                set(SMAN.SIG2intox,'visible','off');
                set(SMAN.SIG2concis,'visible','on');
                set(SMAN.SIG2conciswt,'visible','off')
                set(SMAN.SIG2unit,'visible','on',value,1);
            end
        end
        set(SMAN.SIG2int,'visible','on');
        set(SMAN.SIG2concis,'visible','on');

     end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reduce the fontsize if a lower resolution monitor is being used
if sf(1) < 0.8
    child = get(gcf,'children');
    notmenu = find(strcmp(get(child,'type'),'uimenu') == 0);
    child = child(notmenu);
    set(child,'fontsize',7);
    clear child notmenu
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear quanttype1 quanttype2