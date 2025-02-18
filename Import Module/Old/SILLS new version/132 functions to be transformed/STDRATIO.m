%STDRATIO
%Added in 1.0.3
%Allows to plot isotope ratios to select background and signal integration
%windows

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CASE 1: Switch to ratio mode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(mode,'ratio') == 1
    
    %Declare the standard of the selected window active
    if strcmp(STD(A.DC).fileinfo.name,get(gcf,'Tag')) == 0
        active = [];
        for c = 1:A.STD_num
            active(c) = strcmp(STD(c).fileinfo.name,get(gcf,'Tag'));
        end
        A.DC = find(active,1);
        clear c active;
        set(SCP.handles.h_currentSTD_popup,'Value',A.DC);
        SILLSFIG_UPDATE;
    end
    
    if isempty(STD(A.DC).bgwindow) %abort when no background window is selected
        errordlg('Please specify background window first, the ratios displayed are background-corrected','SILLS Error');
        clear mode
        return
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Show the ratio definition figure
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    abort = 0; %Changes to 1 when figure is closed or cancel is clicked

    ratiofigure = figure('name','Ratio Definition','units','pixels','numbertitle','off','menubar','none',...
        'closerequestfcn','abort=1;delete(ratiofigure);',...
        'position',[400*sf(1) 100*sf(2) 300*sf(1) 900*sf(2)]);

    uicontrol(ratiofigure,'style','text','position',[10*sf(1) 845*sf(2) 280*sf(1) 45*sf(2)],...
        'string',{'Selected ratios are shown in output.';'To show ratios in the signal figure,';'check the "SHOW" boxes.'});

    donebutton = uicontrol(ratiofigure,'style','pushbutton','string','DONE','fontweight','bold','callback','uiresume;',...
        'Position',[10*sf(1) 805*sf(2) 120*sf(1) 30*sf(2)]);
    cancelbutton = uicontrol(ratiofigure,'style','pushbutton','string','CANCEL','callback','abort=1;delete(ratiofigure);',...
        'Position',[170*sf(1) 805*sf(2) 120*sf(1) 30*sf(2)]);

    ratiopanel = uipanel('units','pixels','BackgroundColor',get(ratiofigure,'color'),'title','Ratios',...
        'Position',[10*sf(1) 10*sf(2) 280*sf(1) 780*sf(2)]);
    for i = 1:25
        numerator(i) = uicontrol(ratiofigure,'style','popupmenu','string',horzcat({''},A.ISOTOPE_list),'units','pixels',...
            'parent',ratiopanel,'position',[10*sf(1) (770-30*i)*sf(2) 70*sf(1) 20*sf(2)]);
        uicontrol(ratiofigure,'style','text','string','/','fontweight','bold','fontsize',14,'backgroundcolor',get(ratiofigure,'color'),...
            'parent',ratiopanel,'position',[90*sf(1) (770-30*i)*sf(2) 10*sf(1) 20*sf(2)]);
        denominator(i) = uicontrol(ratiofigure,'style','popupmenu','string',horzcat({''},A.ISOTOPE_list),'units','pixels',...
            'parent',ratiopanel,'position',[110*sf(1) (770-30*i)*sf(2) 70*sf(1) 20*sf(2)]);
        showbox(i) = uicontrol(ratiofigure,'style','checkbox','string',' SHOW','units','pixels','backgroundcolor',get(ratiofigure,'color'),...
            'parent',ratiopanel,'position',[200*sf(1) (770-30*i)*sf(2) 70*sf(1) 20*sf(2)],'max',1,'min',0);
        if i <= A.ratios.num
            set(numerator(i),'value',A.ratios.index(i,1)+1);
            set(denominator(i),'value',A.ratios.index(i,2)+1);
            set(showbox(i),'value',A.ratios.show(i));
        end
    end

    uiwait(ratiofigure);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Resumed when DONE is clicked
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if abort == 1
        clear ratiofigure donebutton cancelbutton ratiopanel numerator denominator showbox i abort mode
        return
    end
    
    A.ratios.index = [];
    A.ratios.show = [];
    A.ratios.names = {};

    %Read settings
    numerators = cell2mat(get(numerator,'value')) - 1;
    denominators = cell2mat(get(denominator,'value')) - 1;
    A.ratios.show = cell2mat(get(showbox,'value'));

    %Exclude empty or partially empty ratios
    searchdestroy = find(numerators == 0);
    numerators(searchdestroy) = []; denominators(searchdestroy) = []; A.ratios.show(searchdestroy) = [];
    searchdestroy = find(denominators == 0);
    numerators(searchdestroy) = []; denominators(searchdestroy) = []; A.ratios.show(searchdestroy) = [];

    %Create ratio structure
    A.ratios.index = horzcat(numerators,denominators);
    A.ratios.num = size(A.ratios.index,1);

    A.ratios.names = cell(A.ratios.num,1);
    for i = 1:A.ratios.num
        A.ratios.names(i) = strcat(A.ISOTOPE_list(A.ratios.index(i,1)),'/',A.ISOTOPE_list(A.ratios.index(i,2)));
    end
    
    %Integrate background
    timereadings = STD(A.DC).data(:,1);
    t1 = find(timereadings == STD(A.DC).bgwindow(1));
    t2 = find(timereadings == STD(A.DC).bgwindow(2));
    bgdata = STD(A.DC).data(t1:t2,2:end);
    bgint = mean(bgdata);
    
    %Calculate ratios
    STD(A.DC).ratios = zeros(size(STD(A.DC).data,1),A.ratios.num);
    for i = 1:A.ratios.num
        for tstep = 1:size(STD(A.DC).data,1)
            STD(A.DC).ratios(tstep,i) = (STD(A.DC).data(tstep,A.ratios.index(i,1)+1) - bgint(A.ratios.index(i,1))) ./ (STD(A.DC).data(tstep,A.ratios.index(i,2)+1) - bgint(A.ratios.index(i,2)));
        end
    end

    %Switch back to standard figure
    delete(ratiofigure);
    clear ratiofigure donebutton cancelbutton ratiopanel numerator denominator showbox abort
    clear numerators denominators searchdestroy i tstep mode
    clear timereadings t1 t2 bgdata bgint

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot ratios and legend
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Hide element plots and legend
    set(findobj(STD(A.DC).handles.h_stdplot,'tag','element'),'visible','off');
    set(findobj(STD(A.DC).handles.h_stdlegend,'tag','element'),'visible','off');
    set(STD(A.DC).handles.h_stdline_toggle(:),'visible','off');
    set(STD(A.DC).handles.h_toggle_all,'visible','off');
    set(STD(A.DC).handles.h_toggle_none,'visible','off');
    
    %Delete existing ratio plots
    delete(findobj(STD(A.DC).handles.h_stdplot,'tag','ratio'));
    delete(findobj(STD(A.DC).handles.h_stdlegend,'tag','ratio'));
    
    %Plot ratios
    STD(A.DC).handles.h_ratioplots = plot(STD(A.DC).handles.h_stdplot,STD(A.DC).data(:,1),STD(A.DC).ratios,'tag','ratio');

    %Set Ylim
    if isempty(STD(A.DC).YLim_orig_element)
        STD(A.DC).YLim_orig_element = STD(A.DC).YLim_orig;
    end
    STD(A.DC).YLim_orig = [1E-4 1E4];
    set(STD(A.DC).handles.h_stdplot,'XLim',STD(A.DC).XLim_orig,'YLim',STD(A.DC).YLim_orig);

    %Plot legend
    ratiolegend = zeros(A.ratios.num+1,2);
    ratiolegend(1,:) = [1 3];
    for i=1:A.ratios.num
        ratiolegend(1+i,:) = [26-i 26-i];
    end
    STD(A.DC).handles.h_ratiolegendplots = plot(STD(A.DC).handles.h_stdlegend,ratiolegend(1,:),ratiolegend(2:end,:),'tag','ratio');
    STD(A.DC).handles.h_ratiolegendtext = text(3.5*ones(A.ratios.num,1),ratiolegend(2:end,1),A.ratios.names,'Parent',STD(A.DC).handles.h_stdlegend,'tag','ratio');
    set(STD(A.DC).handles.h_stdlegend,'XLim',[0 10],'YLim',[0 26],'XTick',[],'XTickLabel',[],'YTick',[],'YTickLabel',[]);

    %Hide plots with "SHOW" unchecked
    for i=1:A.ratios.num
        if A.ratios.show(i) == 0
            set(STD(A.DC).handles.h_ratioplots(i),'visible','off');
            set(STD(A.DC).handles.h_ratiolegendplots(i),'visible','off');
            set(STD(A.DC).handles.h_ratiolegendtext(i),'visible','off');
        end
    end

    %Move the patches
    set(STD(A.DC).handles.h_bgpatch,'vertices',[STD(A.DC).bgwindow(1) STD(A.DC).YLim_orig(1);STD(A.DC).bgwindow(2) STD(A.DC).YLim_orig(1);STD(A.DC).bgwindow(2) STD(A.DC).YLim_orig(2);STD(A.DC).bgwindow(1) STD(A.DC).YLim_orig(2)]);
    if ~isempty(STD(A.DC).sigwindow)
        set(STD(A.DC).handles.h_sigpatch,'vertices',[STD(A.DC).sigwindow(1) STD(A.DC).YLim_orig(1);STD(A.DC).sigwindow(2) STD(A.DC).YLim_orig(1);STD(A.DC).sigwindow(2) STD(A.DC).YLim_orig(2);STD(A.DC).sigwindow(1) STD(A.DC).YLim_orig(2)]);
    end
    
    %change menu properties
    set(STD(A.DC).handles.h_elementmenu,'enable','on');
    set(STD(A.DC).handles.h_ratiomenu,'Label','Redefine Ratios');
    
    clear ratiolegend i
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CASE 2: Switch to element mode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif strcmp(mode,'element') == 1
    
    %Declare the standard of the selected window active
    if strcmp(STD(A.DC).fileinfo.name,get(gcf,'Tag')) == 0
        active = [];
        for c = 1:A.STD_num
            active(c) = strcmp(STD(c).fileinfo.name,get(gcf,'Tag'));
        end
        A.DC = find(active,1);
        clear c active;
        set(SCP.handles.h_currentSTD_popup,'Value',A.DC);
        SILLSFIG_UPDATE;
    end
       
    %If present, hide all ratio objects
    set(findobj(STD(A.DC).handles.h_stdplot,'tag','ratio'),'visible','off');
    set(findobj(STD(A.DC).handles.h_stdlegend,'tag','ratio'),'visible','off');
    
    %show all element objects
    set(findobj(STD(A.DC).handles.h_stdplot,'tag','element'),'visible','on');
    set(findobj(STD(A.DC).handles.h_stdlegend,'tag','element'),'visible','on');
    set(STD(A.DC).handles.h_stdline_toggle(:),'visible','on','value',1);
    set(STD(A.DC).handles.h_toggle_all,'visible','on');
    set(STD(A.DC).handles.h_toggle_none,'visible','on');
    
    %reset plot and legend axes limits
    if ~isempty(STD(A.DC).YLim_orig_element)
        STD(A.DC).YLim_orig = STD(A.DC).YLim_orig_element;
    end
    set(STD(A.DC).handles.h_stdplot,'XLim',STD(A.DC).XLim_orig,'YLim',STD(A.DC).YLim_orig);
    set(STD(A.DC).handles.h_stdlegend,'XLim',[0 10],'YLim',[0 STD(A.STD_num).num_elements+1],'XTick',[],'XTickLabel',[],'YTick',[],'YTickLabel',[]);
    
    %Move the patches
    if ~isempty(STD(A.DC).bgwindow)
        set(STD(A.DC).handles.h_bgpatch,'vertices',[STD(A.DC).bgwindow(1) STD(A.DC).YLim_orig(1);STD(A.DC).bgwindow(2) STD(A.DC).YLim_orig(1);STD(A.DC).bgwindow(2) STD(A.DC).YLim_orig(2);STD(A.DC).bgwindow(1) STD(A.DC).YLim_orig(2)]);
    end
    if ~isempty(STD(A.DC).sigwindow)
        set(STD(A.DC).handles.h_sigpatch,'vertices',[STD(A.DC).sigwindow(1) STD(A.DC).YLim_orig(1);STD(A.DC).sigwindow(2) STD(A.DC).YLim_orig(1);STD(A.DC).sigwindow(2) STD(A.DC).YLim_orig(2);STD(A.DC).sigwindow(1) STD(A.DC).YLim_orig(2)]);
    end
    
    %change menu properties
    set(STD(A.DC).handles.h_elementmenu,'enable','off');
    set(STD(A.DC).handles.h_ratiomenu,'Label','Plot Ratios');
    
    clear mode
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CASE 3: Redefine ratios from Calculation Manager
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

elseif strcmp(mode,'sman') == 1
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Show the ratio definition figure
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    abort = 0; %Changes to 1 when figure is closed or cancel is clicked

    ratiofigure = figure('name','Ratio Definition','units','pixels','numbertitle','off','menubar','none',...
        'closerequestfcn','abort=1;delete(ratiofigure);',...
        'position',[400*sf(1) 100*sf(2) 300*sf(1) 900*sf(2)]);

    uicontrol(ratiofigure,'style','text','position',[10*sf(1) 845*sf(2) 280*sf(1) 45*sf(2)],...
        'string',{'Selected ratios are shown in output.';'To show ratios in the signal figure,';'check the "SHOW" boxes.'});

    donebutton = uicontrol(ratiofigure,'style','pushbutton','string','DONE','fontweight','bold','callback','uiresume;',...
        'Position',[10*sf(1) 805*sf(2) 120*sf(1) 30*sf(2)]);
    cancelbutton = uicontrol(ratiofigure,'style','pushbutton','string','CANCEL','callback','close(ratiofigure);',...
        'Position',[170*sf(1) 805*sf(2) 120*sf(1) 30*sf(2)]);

    ratiopanel = uipanel('units','pixels','BackgroundColor',get(ratiofigure,'color'),'title','Ratios',...
        'Position',[10*sf(1) 10*sf(2) 280*sf(1) 780*sf(2)]);
    for i = 1:25
        numerator(i) = uicontrol(ratiofigure,'style','popupmenu','string',horzcat({''},A.ISOTOPE_list),'units','pixels',...
            'parent',ratiopanel,'position',[10*sf(1) (770-30*i)*sf(2) 70*sf(1) 20*sf(2)]);
        uicontrol(ratiofigure,'style','text','string','/','fontweight','bold','fontsize',14,'backgroundcolor',get(ratiofigure,'color'),...
            'parent',ratiopanel,'position',[90*sf(1) (770-30*i)*sf(2) 10*sf(1) 20*sf(2)]);
        denominator(i) = uicontrol(ratiofigure,'style','popupmenu','string',horzcat({''},A.ISOTOPE_list),'units','pixels',...
            'parent',ratiopanel,'position',[110*sf(1) (770-30*i)*sf(2) 70*sf(1) 20*sf(2)]);
        showbox(i) = uicontrol(ratiofigure,'style','checkbox','string',' SHOW','units','pixels','backgroundcolor',get(ratiofigure,'color'),...
            'parent',ratiopanel,'position',[200*sf(1) (770-30*i)*sf(2) 70*sf(1) 20*sf(2)],'max',1,'min',0,'visible','off');
        if isfield(A,'ratios') %i.e. it is not the first time ratios are defined
            if i <= A.ratios.num
                set(numerator(i),'value',A.ratios.index(i,1)+1);
                set(denominator(i),'value',A.ratios.index(i,2)+1);
                set(showbox(i),'value',A.ratios.show(i));
            end
        end
    end

    uiwait(ratiofigure);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Resumed when DONE is clicked
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if abort == 1
        clear ratiofigure donebutton cancelbutton ratiopanel numerator denominator i abort mode
        return
    else
        set(ratiofigure,'closerequestfcn','delete(ratiofigure);');
    end
  
    A.ratios.index = [];
    A.ratios.show = [];
    A.ratios.names = {};
    
    %Read settings
    numerators = cell2mat(get(numerator,'value')) - 1;
    denominators = cell2mat(get(denominator,'value')) - 1;
    A.ratios.show = cell2mat(get(showbox,'value'));

    %Exclude empty or partially empty ratios
    searchdestroy = find(numerators == 0);
    numerators(searchdestroy) = []; denominators(searchdestroy) = []; A.ratios.show(searchdestroy) = [];
    searchdestroy = find(denominators == 0);
    numerators(searchdestroy) = []; denominators(searchdestroy) = []; A.ratios.show(searchdestroy) = [];

    %Create ratio structure
    A.ratios.index = horzcat(numerators,denominators);
    A.ratios.num = size(A.ratios.index,1);

    A.ratios.names = cell(A.ratios.num,1);
    for i = 1:A.ratios.num
        A.ratios.names(i) = strcat(A.ISOTOPE_list(A.ratios.index(i,1)),'/',A.ISOTOPE_list(A.ratios.index(i,2)));
    end
    
    %Switch back to Calculation Manager
    close(ratiofigure);
    clear ratiofigure donebutton cancelbutton ratiopanel numerator denominator abort
    clear numerators denominators searchdestroy i tstep mode
end