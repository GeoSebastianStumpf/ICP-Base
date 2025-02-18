%UNKRATIO
%Added in 1.0.3
%Allows to plot isotope ratios to select background and signal integration
%windows

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CASE 1: Switch to ratio mode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(mode,'ratio') == 1
        
    %Declare the unknown of the selected window active
    if strcmp(UNK(A.KC).fileinfo.name,get(gcf,'Tag')) == 0
        active = [];
        for c = 1:A.UNK_num
            active(c) = strcmp(UNK(c).fileinfo.name,get(gcf,'Tag'));
        end
        A.KC = find(active,1);
        clear active c;
        set(SCP.handles.h_currentUNK_popup,'Value',A.KC);
        SILLSFIG_UPDATE;
    end

    if isempty(UNK(A.KC).bgwindow) %abort when no background window is selected
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
    timereadings = UNK(A.KC).data(:,1);
    t1 = find(timereadings == UNK(A.KC).bgwindow(1));
    t2 = find(timereadings == UNK(A.KC).bgwindow(2));
    bgdata = UNK(A.KC).data(t1:t2,2:end);
    bgint = mean(bgdata);
    
    %Calculate ratios
    UNK(A.KC).ratios = zeros(size(UNK(A.KC).data,1),A.ratios.num);
    for i = 1:A.ratios.num
        for tstep = 1:size(UNK(A.KC).data,1)
            UNK(A.KC).ratios(tstep,i) = (UNK(A.KC).data(tstep,A.ratios.index(i,1)+1) - bgint(A.ratios.index(i,1))) ./ (UNK(A.KC).data(tstep,A.ratios.index(i,2)+1) - bgint(A.ratios.index(i,2)));
        end
    end

    %Switch back to unknown figure
    delete(ratiofigure);
    clear ratiofigure donebutton cancelbutton ratiopanel numerator denominator showbox abort
    clear numerators denominators searchdestroy i tstep mode
    clear timereadings t1 t2 bgdata bgint

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot ratios and legend
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    %Hide element plots and legend
    set(findobj(UNK(A.KC).handles.h_unkplot,'tag','element'),'visible','off');
    set(findobj(UNK(A.KC).handles.h_unklegend,'tag','element'),'visible','off');
    set(UNK(A.KC).handles.h_unkline_toggle(:),'visible','off');
    set(UNK(A.KC).handles.h_toggle_all,'visible','off');
    set(UNK(A.KC).handles.h_toggle_none,'visible','off');
       
    %Delete existing ratio plots
    delete(findobj(UNK(A.KC).handles.h_unkplot,'tag','ratio'));
    delete(findobj(UNK(A.KC).handles.h_unklegend,'tag','ratio'));
    
    %Plot ratios
    UNK(A.KC).handles.h_ratioplots = plot(UNK(A.KC).handles.h_unkplot,UNK(A.KC).data(:,1),UNK(A.KC).ratios,'tag','ratio');

    %Set Ylim
    if isempty(UNK(A.KC).YLim_orig_element)
        UNK(A.KC).YLim_orig_element = UNK(A.KC).YLim_orig;
    end
    UNK(A.KC).YLim_orig = [1E-4 1E4];
    set(UNK(A.KC).handles.h_unkplot,'XLim',UNK(A.KC).XLim_orig,'YLim',UNK(A.KC).YLim_orig);

    %Plot legend
    ratiolegend = zeros(A.ratios.num+1,2);
    ratiolegend(1,:) = [1 3];
    for i=1:A.ratios.num
        ratiolegend(1+i,:) = [26-i 26-i];
    end
    UNK(A.KC).handles.h_ratiolegendplots = plot(UNK(A.KC).handles.h_unklegend,ratiolegend(1,:),ratiolegend(2:end,:),'tag','ratio');
    UNK(A.KC).handles.h_ratiolegendtext = text(3.5*ones(A.ratios.num,1),ratiolegend(2:end,1),A.ratios.names,'Parent',UNK(A.KC).handles.h_unklegend,'tag','ratio');
    set(UNK(A.KC).handles.h_unklegend,'XLim',[0 10],'YLim',[0 26],'XTick',[],'XTickLabel',[],'YTick',[],'YTickLabel',[]);

    %Hide plots with "SHOW" unchecked
    for i=1:A.ratios.num
        if A.ratios.show(i) == 0
            set(UNK(A.KC).handles.h_ratioplots(i),'visible','off');
            set(UNK(A.KC).handles.h_ratiolegendplots(i),'visible','off');
            set(UNK(A.KC).handles.h_ratiolegendtext(i),'visible','off');
        end
    end

    %Move the patches
    set(UNK(A.KC).handles.h_bgpatch,'vertices',[UNK(A.KC).bgwindow(1) UNK(A.KC).YLim_orig(1);UNK(A.KC).bgwindow(2) UNK(A.KC).YLim_orig(1);UNK(A.KC).bgwindow(2) UNK(A.KC).YLim_orig(2);UNK(A.KC).bgwindow(1) UNK(A.KC).YLim_orig(2)]);
    if ~isempty(UNK(A.KC).mat1window)
        set(UNK(A.KC).handles.h_mat1patch,'vertices',[UNK(A.KC).mat1window(1) UNK(A.KC).YLim_orig(1);UNK(A.KC).mat1window(2) UNK(A.KC).YLim_orig(1);UNK(A.KC).mat1window(2) UNK(A.KC).YLim_orig(2);UNK(A.KC).mat1window(1) UNK(A.KC).YLim_orig(2)]);
    end
    if ~isempty(UNK(A.KC).mat2window)
        set(UNK(A.KC).handles.h_mat2patch,'vertices',[UNK(A.KC).mat2window(1) UNK(A.KC).YLim_orig(1);UNK(A.KC).mat2window(2) UNK(A.KC).YLim_orig(1);UNK(A.KC).mat2window(2) UNK(A.KC).YLim_orig(2);UNK(A.KC).mat2window(1) UNK(A.KC).YLim_orig(2)]);
    end
    if ~isempty(UNK(A.KC).comp1window)
        set(UNK(A.KC).handles.h_comp1patch,'vertices',[UNK(A.KC).comp1window(1) UNK(A.KC).YLim_orig(1);UNK(A.KC).comp1window(2) UNK(A.KC).YLim_orig(1);UNK(A.KC).comp1window(2) UNK(A.KC).YLim_orig(2);UNK(A.KC).comp1window(1) UNK(A.KC).YLim_orig(2)]);
    end
    if ~isempty(UNK(A.KC).comp2window)
        set(UNK(A.KC).handles.h_comp2patch,'vertices',[UNK(A.KC).comp2window(1) UNK(A.KC).YLim_orig(1);UNK(A.KC).comp2window(2) UNK(A.KC).YLim_orig(1);UNK(A.KC).comp2window(2) UNK(A.KC).YLim_orig(2);UNK(A.KC).comp2window(1) UNK(A.KC).YLim_orig(2)]);
    end
    if ~isempty(UNK(A.KC).comp3window)
        set(UNK(A.KC).handles.h_comp3patch,'vertices',[UNK(A.KC).comp3window(1) UNK(A.KC).YLim_orig(1);UNK(A.KC).comp3window(2) UNK(A.KC).YLim_orig(1);UNK(A.KC).comp3window(2) UNK(A.KC).YLim_orig(2);UNK(A.KC).comp3window(1) UNK(A.KC).YLim_orig(2)]);
    end       
            
    %change menu properties
    set(UNK(A.KC).handles.h_elementmenu,'enable','on');
    set(UNK(A.KC).handles.h_ratiomenu,'Label','Redefine Ratios');

    clear ratiolegend i
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CASE 2: Switch to element mode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif strcmp(mode,'element') == 1
    
    %Declare the unknown of the selected window active
    if strcmp(UNK(A.KC).fileinfo.name,get(gcf,'Tag')) == 0
        active = [];
        for c = 1:A.UNK_num
            active(c) = strcmp(UNK(c).fileinfo.name,get(gcf,'Tag'));
        end
        A.KC = find(active,1);
        clear active c;
        set(SCP.handles.h_currentUNK_popup,'Value',A.KC);
        SILLSFIG_UPDATE;
    end
       
    %If present, hide all ratio objects
    set(findobj(UNK(A.KC).handles.h_unkplot,'tag','ratio'),'visible','off');
    set(findobj(UNK(A.KC).handles.h_unklegend,'tag','ratio'),'visible','off');
    
    %show all element objects
    set(findobj(UNK(A.KC).handles.h_unkplot,'tag','element'),'visible','on');
    set(findobj(UNK(A.KC).handles.h_unklegend,'tag','element'),'visible','on');
    set(UNK(A.KC).handles.h_unkline_toggle(:),'visible','on','value',1);
    set(UNK(A.KC).handles.h_toggle_all,'visible','on');
    set(UNK(A.KC).handles.h_toggle_none,'visible','on');
    
    %reset plot and legend axes limits
    if ~isempty(UNK(A.KC).YLim_orig_element)
        UNK(A.KC).YLim_orig = UNK(A.KC).YLim_orig_element;
    end
    set(UNK(A.KC).handles.h_unkplot,'XLim',UNK(A.KC).XLim_orig,'YLim',UNK(A.KC).YLim_orig);
    set(UNK(A.KC).handles.h_unklegend,'XLim',[0 10],'YLim',[0 UNK(A.UNK_num).num_elements+1],'XTick',[],'XTickLabel',[],'YTick',[],'YTickLabel',[]);
    
    %Move the patches
    if ~isempty(UNK(A.KC).bgwindow)
        set(UNK(A.KC).handles.h_bgpatch,'vertices',[UNK(A.KC).bgwindow(1) UNK(A.KC).YLim_orig(1);UNK(A.KC).bgwindow(2) UNK(A.KC).YLim_orig(1);UNK(A.KC).bgwindow(2) UNK(A.KC).YLim_orig(2);UNK(A.KC).bgwindow(1) UNK(A.KC).YLim_orig(2)]);
    end
    if ~isempty(UNK(A.KC).mat1window)
        set(UNK(A.KC).handles.h_mat1patch,'vertices',[UNK(A.KC).mat1window(1) UNK(A.KC).YLim_orig(1);UNK(A.KC).mat1window(2) UNK(A.KC).YLim_orig(1);UNK(A.KC).mat1window(2) UNK(A.KC).YLim_orig(2);UNK(A.KC).mat1window(1) UNK(A.KC).YLim_orig(2)]);
    end
    if ~isempty(UNK(A.KC).mat2window)
        set(UNK(A.KC).handles.h_mat2patch,'vertices',[UNK(A.KC).mat2window(1) UNK(A.KC).YLim_orig(1);UNK(A.KC).mat2window(2) UNK(A.KC).YLim_orig(1);UNK(A.KC).mat2window(2) UNK(A.KC).YLim_orig(2);UNK(A.KC).mat2window(1) UNK(A.KC).YLim_orig(2)]);
    end
    if ~isempty(UNK(A.KC).comp1window)
        set(UNK(A.KC).handles.h_comp1patch,'vertices',[UNK(A.KC).comp1window(1) UNK(A.KC).YLim_orig(1);UNK(A.KC).comp1window(2) UNK(A.KC).YLim_orig(1);UNK(A.KC).comp1window(2) UNK(A.KC).YLim_orig(2);UNK(A.KC).comp1window(1) UNK(A.KC).YLim_orig(2)]);
    end
    if ~isempty(UNK(A.KC).comp2window)
        set(UNK(A.KC).handles.h_comp2patch,'vertices',[UNK(A.KC).comp2window(1) UNK(A.KC).YLim_orig(1);UNK(A.KC).comp2window(2) UNK(A.KC).YLim_orig(1);UNK(A.KC).comp2window(2) UNK(A.KC).YLim_orig(2);UNK(A.KC).comp2window(1) UNK(A.KC).YLim_orig(2)]);
    end
    if ~isempty(UNK(A.KC).comp3window)
        set(UNK(A.KC).handles.h_comp3patch,'vertices',[UNK(A.KC).comp3window(1) UNK(A.KC).YLim_orig(1);UNK(A.KC).comp3window(2) UNK(A.KC).YLim_orig(1);UNK(A.KC).comp3window(2) UNK(A.KC).YLim_orig(2);UNK(A.KC).comp3window(1) UNK(A.KC).YLim_orig(2)]);
    end   
    
    %change menu properties
    set(UNK(A.KC).handles.h_elementmenu,'enable','off');
    set(UNK(A.KC).handles.h_ratiomenu,'Label','Plot Ratios');
    
    clear mode    
end