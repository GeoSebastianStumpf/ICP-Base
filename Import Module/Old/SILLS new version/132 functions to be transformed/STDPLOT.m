%STDPLOT

if A.STD_num == 0
    return
end

A.D = A.D + 1;

A.DC = get(SCP.handles.h_currentSTD_popup,'Value');

if strcmp(STD(A.DC).figure_state,'open') == 1 % if the figure is already open

    figure(STD(A.DC).handles.h_stdfig);  % get the figure

else
    
%%%%%%%%% Replace all 0 values by a very low dummy value %%%%%% 
%%%%%%%%% Added in 1.0.2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for a = 2:size(STD(A.DC).data,2) %cycle through elements
    for b = 1:size(STD(A.DC).data,1) %cycle through timesteps
        if STD(A.DC).data(b,a) == 0
           STD(A.DC).data(b,a) = A.dummy;
        end
    end
end
clear a b
  

STD(A.DC).handles.h_stdfig = figure('name',['Standard (' STD(A.DC).fileinfo.name ')'],...
    'units','pixels','tag',STD(A.DC).fileinfo.name,'NumberTitle','off','menubar','none','WindowButtonDownFcn','STDPICKER',...
    'position',[10*sf(1) 100*sf(2) 770*sf(1) 850*sf(2)],'Color',[0.5137 0.6 0.6941],'UserData',STD(A.DC).order_opened);

set(SCP.handles.h_std_delete_button,'ForegroundColor',[0 0 0]);
set(STD(A.DC).handles.h_stdfig,'CloseRequestFcn','STDDELETE');
    
%%%%%%%%% Show the file menu to save and print %%%%%%%%%%%%%%%% 
%%%%%%%%% Added in 1.0.2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
STD(A.DC).handles.h_figuremenu = uimenu('Label','File');
uimenu(STD(A.DC).handles.h_figuremenu,'Label','Save As...','Callback','SAVEFIGAS');
uimenu(STD(A.DC).handles.h_figuremenu,'Label','Page Setup...','Callback','pagesetupdlg(gcf)','Separator','on');
uimenu(STD(A.DC).handles.h_figuremenu,'Label','Print Preview...','Callback','printpreview(gcf)');
uimenu(STD(A.DC).handles.h_figuremenu,'Label','Print...','Callback','printdlg(gcf)');
set(STD(A.DC).handles.h_stdfig,'DockControls','off','PaperPositionMode','auto');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%% Show the display mode menu %%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%% Added in 1.0.3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
STD(A.DC).handles.h_modemenu = uimenu('Label','Switch Display Mode');
STD(A.DC).handles.h_elementmenu = uimenu(STD(A.DC).handles.h_modemenu,'Label','Plot Isotopes','Enable','off','Callback','mode=''element'';STDRATIO');
STD(A.DC).handles.h_ratiomenu = uimenu(STD(A.DC).handles.h_modemenu,'Label','Plot Ratios','Callback','mode=''ratio'';STDRATIO');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


STD(A.DC).handles.h_std_resetx_button = uicontrol(STD(A.DC).handles.h_stdfig,'style','pushbutton',...
    'string','Reset Axes','Callback',STDRESETX,...
    'backgroundcolor',[0.5137 0.6 0.6941],'ForegroundColor',[0 0 0],...
    'Position',[630*sf(1) 10*sf(2) 130*sf(1) 30*sf(2)]);

STD(A.DC).handles.h_toggle_all = uicontrol(STD(A.DC).handles.h_stdfig,'style','pushbutton',...
    'string','Show All','Callback','STDLINE',...
    'backgroundcolor',[0.5137 0.6 0.6941],'ForegroundColor',[0 0 0],...
    'Position',[630*sf(1) 75*sf(2) 65*sf(1) 30*sf(2)]);

STD(A.DC).handles.h_toggle_none = uicontrol(STD(A.DC).handles.h_stdfig,'style','pushbutton',...
    'string','Show None','Callback','STDLINE',...
    'backgroundcolor',[0.5137 0.6 0.6941],'ForegroundColor',[0 0 0],...
    'Position',[695*sf(1) 75*sf(2) 65*sf(1) 30*sf(2)]);

STD(A.DC).handles.h_spikebutton = uicontrol(STD(A.DC).handles.h_stdfig,'style','pushbutton',...
    'String','Spike Elimination','FontWeight','bold','Callback','spike',...
    'backgroundcolor',[0.5137 0.6 0.6941],'ForegroundColor',[0 0 0],...
    'Position',[630*sf(1) 110*sf(2) 130*sf(1) 30*sf(2)],...
    'tag','standard'); %Added in 1.1.1
if strcmp(STD(A.DC).spikestatus,'finished') == 1
    set(STD(A.DC).handles.h_spikebutton,'FontWeight','normal','String','Spike Elimination (done)');
end

    %set up the mutually exclusive 'background' and 'signal' radio buttons

STD(A.DC).handles.radiogroup = uibuttongroup('units','pixels','position',[20*sf(1) 10*sf(2) 600*sf(1) 130*sf(2)],'BackgroundColor',[0 0 0]);

STD(A.DC).handles.radio_std1 = uicontrol(STD(A.DC).handles.h_stdfig,'style','radio',...
    'string','ZOOM','Fontweight','bold','units','pixels',...
    'Position',[620*sf(1) 35*sf(2) 60*sf(1) 15*sf(2)],'ForegroundColor',[1 1 1],'BackgroundColor',[0.5137 0.6 0.6941],...
    'Parent',STD(A.DC).handles.radiogroup);

STD(A.DC).handles.radio_std2 = uicontrol(STD(A.DC).handles.h_stdfig,'style','radio',...
    'string','BKGND','Fontweight','bold','units','pixels','Value',1,...
    'Position',[90*sf(1) 90*sf(2) 60*sf(1) 15*sf(2)],'ForegroundColor',[1 1 1],'BackgroundColor',[0 0 0],...
    'Parent',STD(A.DC).handles.radiogroup);

STD(A.DC).handles.radio_std3 = uicontrol(STD(A.DC).handles.h_stdfig,'style','radio',...
    'string','SIGNAL','Fontweight','bold','units','pixels',...
    'Position',[160*sf(1) 90*sf(2) 60*sf(1) 15*sf(2)],'ForegroundColor',[1 1 1],'BackgroundColor',[0 0 0],...
    'Parent',STD(A.DC).handles.radiogroup);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % when this box is clicked the user can input a lower time bracket for
    % the background portion of the standard file. The callback STDBG_USERFROM.m
    % includes a routine to determine the time value that most closely matches this input.

STD(A.DC).handles.h_std_from_text =          uicontrol(STD(A.DC).handles.h_stdfig,'style','text','tag','STD.handles.h_std_from_text',...
    'string','from:','HorizontalAlignment','right',...
    'ForegroundColor',[.9 .9 .9],...
    'position',[50*sf(1) 75*sf(2) 50*sf(1) 20*sf(2)],...
    'backgroundcolor',[0 0 0]);
STD(A.DC).handles.h_std_to_text =            uicontrol(STD(A.DC).handles.h_stdfig,'style','text','tag','STD.handles.h_std_to_text',...
    'string','to:','HorizontalAlignment','right',...
    'ForegroundColor',[.9 .9 .9],...
    'position',[50*sf(1) 55*sf(2) 50*sf(1) 20*sf(2)],...
    'backgroundcolor',[0 0 0]);
STD(A.DC).handles.h_std_total_text =            uicontrol(STD(A.DC).handles.h_stdfig,'style','text','tag','STD.handles.h_std_total_text',...
    'string','total:','HorizontalAlignment','right',...
    'ForegroundColor','y',...
    'position',[50*sf(1) 35*sf(2) 50*sf(1) 20*sf(2)],...
    'backgroundcolor',[0 0 0]);

STD(A.DC).handles.h_stdbg_userfrom =         uicontrol(STD(A.DC).handles.h_stdfig,'style','edit','tag','STD.handles.h_stdbg_userfrom',...
    'Callback','STD_MANUAL_ADJUST','UserData',['bgfrom' STD(A.DC).order_opened],...
    'HorizontalAlignment','right','BackgroundColor',[1 1 1],...
    'position',[110*sf(1) 80*sf(2) 60*sf(1) 15*sf(2)]);
STD(A.DC).handles.h_stdbg_userto =           uicontrol(STD(A.DC).handles.h_stdfig,'style','edit','tag','STD.handles.h_stdbg_userto',...
    'Callback','STD_MANUAL_ADJUST','UserData',['bgto' STD(A.DC).order_opened],...
    'HorizontalAlignment','right','BackgroundColor',[1 1 1],...
    'position',[110*sf(1) 60*sf(2) 60*sf(1) 15*sf(2)]);
STD(A.DC).handles.h_stdbg_total =           uicontrol(STD(A.DC).handles.h_stdfig,'style','text','tag','STD.handles.h_stdbg_total',...
    'HorizontalAlignment','right','BackgroundColor',[0 0 0],'ForegroundColor','y',...
    'position',[105*sf(1) 40*sf(2) 60*sf(1) 15*sf(2)]);
STD(A.DC).handles.h_stdbg_erase =           uicontrol(STD(A.DC).handles.h_stdfig,'style','pushbutton','tag','STD.handles.h_stdbg_erase',...
    'HorizontalAlignment','center','string','ERASE','Callback','ERASE_STDWINDOW','position',[110*sf(1) 20*sf(2) 60*sf(1) 15*sf(2)]);

STD(A.DC).handles.h_stdsig_userfrom =        uicontrol(STD(A.DC).handles.h_stdfig,'style','edit','tag','STD.handles.h_stdsig_userfrom',...
    'Callback','STD_MANUAL_ADJUST','UserData',['sigfrom' STD(A.DC).order_opened],...
    'HorizontalAlignment','right','BackgroundColor',[.9 .9 1],...
    'position',[180*sf(1) 80*sf(2) 60*sf(1) 15*sf(2)]);
STD(A.DC).handles.h_stdsig_userto =          uicontrol(STD(A.DC).handles.h_stdfig,'style','edit','tag','STD.handles.h_stdsig_userto',...
    'Callback','STD_MANUAL_ADJUST','UserData',['sigto' STD(A.DC).order_opened],...
    'HorizontalAlignment','right','BackgroundColor',[.9 .9 1],...
    'position',[180*sf(1) 60*sf(2) 60*sf(1) 15*sf(2)]);
STD(A.DC).handles.h_stdsig_total =           uicontrol(STD(A.DC).handles.h_stdfig,'style','text','tag','STD.handles.h_stdsig_total',...
    'HorizontalAlignment','right','BackgroundColor',[0 0 0],'ForegroundColor','y',...
    'position',[175*sf(1) 40*sf(2) 60*sf(1) 15*sf(2)]);
STD(A.DC).handles.h_stdsig_erase =           uicontrol(STD(A.DC).handles.h_stdfig,'style','pushbutton','tag','STD.handles.h_stdsig_erase',...
    'HorizontalAlignment','center','string','ERASE','Callback','ERASE_STDWINDOW','position',[180*sf(1) 20*sf(2) 60*sf(1) 15*sf(2)]);

%write an array of values for plotting a legend
STD(A.DC).legendarray(1,1) = 3;
STD(A.DC).legendarray(2,1) = 6;

C = STD(A.STD_num).num_elements;

for c = 1:C; %for each element
    STD(A.DC).legendarray(:,c+1) = C + 1 - c; 
    STD(A.DC).legendentry_positions(1,c) = 7;
    STD(A.DC).legendentry_positions(2,c) = C + 1 - c;
end

STD(A.DC).legendentries = STD(A.STD_num).colheaders(2:end);
STD(A.DC).legendentry_positions = STD(A.DC).legendentry_positions;

%plot the legend
STD(A.DC).handles.h_stdlegend = subplot(1,2,2);plot(STD(A.DC).legendarray(:,1),STD(A.DC).legendarray(:,2:end),'tag','element'); %Modified in 1.0.3
set(STD(A.DC).handles.h_stdlegend,'units','pixels','XLim',[0 10],'YLim',[0 STD(A.STD_num).num_elements+1],...
    'position',[630*sf(1) 160*sf(2) 130*sf(1) 660*sf(2)],'NextPlot','add',... Modified in 1.0.3
    'XTick',[],'XTickLabel',[],'YTick',[],'YTickLabel',[],'tag','STD.handles.h_stdlegend'); %Added tag in 1.0.5

STD(A.DC).legendtext = text(STD(A.DC).legendentry_positions(1,:),STD(A.DC).legendentry_positions(2,:),STD(A.DC).legendentries);
set(STD(A.DC).legendtext,'FontSize',8,'tag','element'); %Modified in 1.0.3

%determine the pixel position of each text item.
STD(A.DC).incrmt = 660/(C+1);

for c = 1:C
    STD(A.DC).handles.h_stdline_toggle(c) =   uicontrol(STD(A.DC).handles.h_stdfig,'style','radio','position',[640*sf(1) (812-c*STD(A.DC).incrmt)*sf(2) 15*sf(1) 15*sf(2)],...
    'BackgroundColor',[1 1 1],'Value',1,'Userdata',c,'Callback','STDLINE');
end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %plot the data

    STD(A.DC).handles.h_stdplot= subplot(1,2,1);plot(STD(A.DC).data(:,1),STD(A.DC).data(:,2:end));

    %.....................................................
    %attach userdata to each plotted line.
    STD(A.DC).lines = get(STD(A.DC).handles.h_stdplot,'Children');

    for c = 1:C
        set(STD(A.DC).lines(c),'userdata',C+1-c);
        set(STD(A.DC).lines(c),'tag','element'); %Added in 1.0.3
    end
    clear c C
    %.....................................................

    %set the title
    A.DC = get(SCP.handles.h_currentSTD_popup,'value');
    figtit = A.STDPOPUPLIST(A.DC);
    title(figtit);
    clear figtit;

    set(STD(A.DC).handles.h_stdplot,'Fontsize',8,'units','pixels','position',[40*sf(1) 160*sf(2) 580*sf(1) 660*sf(2)],'Yscale','log');
    ylimold = get(STD(A.DC).handles.h_stdplot,'YLim'); %this and next 3 lines added in 1.0.2
    ylimold(1) = 10;
    set(STD(A.DC).handles.h_stdplot,'YLim',ylimold);
    clear ylimold
    set(STD(A.DC).handles.h_stdplot,'tag','STD.handles.h_stdplot'); %Added in 1.0.5
    STD(A.DC).XLim_orig = get(STD(A.DC).handles.h_stdplot,'XLim');
    STD(A.DC).YLim_orig = get(STD(A.DC).handles.h_stdplot,'YLim');

    % declare STD(A.DC).handles.h_stdfig open
    STD(A.DC).figure_state = 'open';
    A.STDfigs_open = {STD.figure_state};
    A.STDfigs_open = strcmp(A.STDfigs_open,'open');

    %add the patches

    if ~isempty(STD(A.DC).bgwindow)
        STD(A.DC).handles.h_bgpatch = patch('faces',[1 2 3 4],...
            'vertices',[STD(A.DC).bgwindow(1) STD(A.DC).YLim_orig(1);STD(A.DC).bgwindow(2) STD(A.DC).YLim_orig(1);STD(A.DC).bgwindow(2) STD(A.DC).YLim_orig(2);STD(A.DC).bgwindow(1) STD(A.DC).YLim_orig(2)],...
            'EdgeColor','none','facecolor',[.9 .9 .9],'FaceAlpha',0.2);
        set(STD(A.DC).handles.h_stdbg_userfrom,'string',STD(A.DC).bgwindow(1,1),'Value',STD(A.DC).bgwindow(1,1));
        set(STD(A.DC).handles.h_stdbg_userto,'string',STD(A.DC).bgwindow(1,2),'Value',STD(A.DC).bgwindow(1,2));
    end

    if ~isempty(STD(A.DC).sigwindow)
        STD(A.DC).handles.h_sigpatch = patch('faces',[1 2 3 4],...
            'vertices',[STD(A.DC).sigwindow(1) STD(A.DC).YLim_orig(1);STD(A.DC).sigwindow(2) STD(A.DC).YLim_orig(1);STD(A.DC).sigwindow(2) STD(A.DC).YLim_orig(2);STD(A.DC).sigwindow(1) STD(A.DC).YLim_orig(2)],...
            'EdgeColor','none','facecolor',[.9 .9 1],'FaceAlpha',0.2);
        set(STD(A.DC).handles.h_stdsig_userfrom,'string',STD(A.DC).sigwindow(1,1),'Value',STD(A.DC).sigwindow(1,1));
        set(STD(A.DC).handles.h_stdsig_userto,'string',STD(A.DC).sigwindow(1,2),'Value',STD(A.DC).sigwindow(1,2));
    end

    hold on

    % reduce the fontsize if a lower resolution monitor is being used
    if sf(1) < 0.8
        child = get(gcf,'children');
        notmenu = find(strcmp(get(child,'type'),'uimenu') == 0);
        child = child(notmenu);
        set(child,'fontsize',7);
        set(STD(A.DC).legendtext,'fontsize',7);
        set(STD(A.DC).handles.radio_std1,'fontsize',7);
        set(STD(A.DC).handles.radio_std2,'fontsize',7);
        set(STD(A.DC).handles.radio_std3,'fontsize',7);
        clear child notmenu
    end

    SILLSFIG_UPDATE
    figure(STD(A.DC).handles.h_stdfig)
end