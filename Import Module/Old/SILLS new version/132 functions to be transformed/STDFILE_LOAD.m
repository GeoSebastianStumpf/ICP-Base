%%%%%%%%% STDFILE_LOAD %%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script does the following: (1)imports the user-specified .csv file, 
% (2) creates a structure array 'STD' which shall contain all data and 
% calculation settings relevant to that sample, and (3) plots the data 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Browse for the standard file
%Replaces STDFILE_BROWSE.m
%Added in 1.0.3
if isempty(A.sillspath)
    A.sillspath = pwd; %Changed in 1.0.4
end

[A.stdfile,A.sillspath] = uigetfile([A.sillspath '/*.*'],'Browse for standard file','MultiSelect','on'); %Changed in 1.0.6

if iscellstr(A.stdfile) %i.e. Multiple files, Added in 1.0.6
    STDFILE_MULTILOAD
    return
elseif A.stdfile == 0 % i.e. if the window was cancelled
    figure(SCP.handles.h_fig); % make SILLS Control Panel the current figure
    return 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A.stdfullfilename = [A.sillspath A.stdfile];
[te1,te2,ext1]=fileparts(A.stdfile);
clear te1 te2
if strcmp(ext1,'.FIN2')
    STDIMP = importdata(A.stdfullfilename,',',8); %Imports Glitter output from Element XR
    dateFIN1 = importdata(A.stdfullfilename);
    dateFIN2 = dateFIN1.textdata(2,1);
    dateFIN = dateFIN2{1};
    clear dateFIN1 dateFIN2
elseif strcmp(ext1,'.TXT')  %Imports TXT-files form the Element XR
    convert_std;
else    
    STDIMP = importdata(A.stdfullfilename);
end

%Remove zero entries after last time step
%Added in 1.0.5 changed in 1.1.1
times = STDIMP.data(:,1);
searchdestroy = find(times==0);
if ~isempty(searchdestroy)
    searchdestroy(1) = [];
    STDIMP.data(searchdestroy,:) = [];
end
clear times searchdestroy


if A.k > 0 %if there is one or more unknowns already in the UNK array

    %test for unmatching element lists between this standard and previously
    %loaded unknowns

    STDIMP_num = size(STDIMP.colheaders(2:end));
    STDIMP_num = STDIMP_num(2);

    A.UNK_num = size(UNK);
    A.UNK_num = A.UNK_num(1);

    if UNK(A.UNK_num,1).num_elements ~= STDIMP_num; %if there are a different number of elements
        msgbox('Element lists do not match. Please load a new standard file.','SILLS Error Message','error');
        return
    else
        temp = strcmp(UNK(A.UNK_num,1).colheaders(2:end),STDIMP.colheaders(2:end)); %compare the new element list with the one originally read
        if sum(temp) < UNK(A.UNK_num).num_elements
            msgbox('Element lists do not match. Please load a new standard file.','SILLS Error Message','error');
            clear temp
            return
        end
        clear temp
    end
end



if A.d > 0 %if there is one or more standards already in the STD array

    %test for unmatching element lists between this standard and ones loaded
    %previously

    STDIMP_num = size(STDIMP.colheaders(2:end));
    STDIMP_num = STDIMP_num(2);

    A.STD_num = size(STD);
    A.STD_num = A.STD_num(1);

    if STD(A.STD_num,1).num_elements ~= STDIMP_num; %if there are a different number of elements
        msgbox('Element lists do not match. Please load a new standard file.','SILLS Error Message','error');
        return
    else
        temp = strcmp(STD(A.STD_num,1).colheaders(2:end),STDIMP.colheaders(2:end)); %compare the new element list with the one originally read
        if sum(temp) < STD(A.STD_num).num_elements
            msgbox('Element lists do not match. Please load a new standard file.','SILLS Error Message','error');
            clear temp
            return
        end
        clear temp
    end

    % populate STD(STD_num), i.e. the most recent standard
    STD(A.STD_num + 1,1).data = STDIMP.data;
    STD(A.STD_num + 1,1).textdata = STDIMP.textdata;
    STD(A.STD_num + 1,1).colheaders = STDIMP.colheaders;
    STD(A.STD_num + 1,1).fileinfo = dir(A.stdfullfilename);
    STD(A.STD_num + 1,1).num_elements = size(STD(A.STD_num,1).colheaders(2:end));
    STD(A.STD_num + 1,1).num_elements = STD(A.STD_num + 1,1).num_elements(2);
    STD(A.STD_num + 1,1).bgwindow = [];
    STD(A.STD_num + 1,1).sigwindow = [];
    STD(A.STD_num + 1,1).timepoint = 1;

    A.MC = get(SCP.handles.h_currentSTD_SRM_out,'value');
    STD(A.STD_num + 1,1).SRM = A.MC;

    A.d = A.d + 1; %advance the counter for the number of standards opened (irrespective of number deleted)
    STD(A.STD_num + 1,1).order_opened = A.d;

    STD(A.STD_num + 1,1).figure_state = 'open';
    STD(A.STD_num + 1,1).spikestatus = 'undone';
    A.STD_num = size(STD);
    A.STD_num = A.STD_num(1);
    A.STDPOPUPLIST(A.STD_num,1) = {STD(A.STD_num,1).fileinfo.name};
    STD(A.STD_num + 1,1).fileinfo.ext = ext1;
    if strcmp(ext1,'.FIN2')
       STD(A.STD_num +1,1).fileinfo.date = dateFIN; 
    end

    A.D = A.D + 1; %number of open STD windows
    %   SILLSFIG_UPDATE

elseif A.d == 0 %i.e. first time a standard has been loaded

    % populate STD(1)
    STD(1).data = STDIMP.data;
    STD(1).textdata = STDIMP.textdata;
    STD(1).colheaders = STDIMP.colheaders;
    STD(1).fileinfo = dir(A.stdfullfilename);
    STD(1).num_elements = size(STD(1).colheaders(2:end));
    STD(1).num_elements = STD(1).num_elements(2);
    STD(1).bgwindow = [];
    STD(1).sigwindow = [];
    STD(1).timepoint = 1;
    STD(1).fileinfo.ext = ext1;
    if strcmp(ext1,'.FIN2')
       STD(1).fileinfo.date = dateFIN; 
    end

    STD(1).SRM = 1;
    set(SCP.handles.h_currentSTD_SRM_out,'Visible','on'); %make the popuplist visible in the 'Data for selected Standard' window

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Make the appropriate drift setting uicontrols visible in the
    % SILLS Control Panel

    if strcmp(A.timeformat,'hhmm')==1
        set(SCP.handles.h_currentSTD_driftpoints_popup,'Visible','off');
        set(SCP.handles.h_currentSTD_drifthh_edit,'Visible','on');
        set(SCP.handles.h_currentSTD_driftcolon,'Visible','on');
        set(SCP.handles.h_currentSTD_driftmm_edit,'Visible','on');
    elseif strcmp(A.timeformat,'integer_points')==1
        set(SCP.handles.h_currentSTD_driftpoints_popup,'Visible','on');
        set(SCP.handles.h_currentSTD_drifthh_edit,'Visible','off');
        set(SCP.handles.h_currentSTD_driftcolon,'Visible','off');
        set(SCP.handles.h_currentSTD_driftmm_edit,'Visible','off');
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    A.d = 1; %counter for the number of standards opened (irrespective of number deleted)
    A.D = 1; %number of open STD windows

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %clear these in case former standards or unknowns were loaded that had
    %a different isotope list
    A.ISOTOPE_list = {};
    A.DT_VALUES = [];
    A.ELEMENT_list = {};

    A.ISOTOPE_list = STD(1).colheaders(2:end);
    A.ISOTOPE_num = size(A.ISOTOPE_list);
    A.ISOTOPE_num = A.ISOTOPE_num(2);
    A.DT_VALUES = 0.01 * ones(A.ISOTOPE_num,1); %Changes in 1.0.6

    %create a list of elements analysed

    isotope = char(A.ISOTOPE_list); %convert isotopes into a character array
    iselement = isletter(isotope);  %search for letters within the 'isotope' array
    element = iselement.*isotope;
    element2 = char(element);
    for c = 1:A.ISOTOPE_num;
        A.ELEMENT_list(c) = {element2(c,:)};
    end
    A.ELEMENT_list = deblank(A.ELEMENT_list);
    A.ELEMENT_num = size(A.ELEMENT_list);
    A.ELEMENT_num = A.ELEMENT_num(2);
    clear isotope iselement element element2
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    STD(1).order_opened = A.d;
    STD(1).figure_state = 'open';
    STD(1).spikestatus = 'undone';

    A.STD_num = 1; %total number of standards
    A.STDPOPUPLIST(1,1) = {STD(1).fileinfo.name};

    A.D=1; %number of open STD windows

end

clear STDIMP STDIMP_num ext1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%update the standard popup list in the SILLS Control Panel
set(SCP.handles.h_currentSTD_popup,'string',A.STDPOPUPLIST,'value',A.STD_num);

%%%%%%%% create the standard plot figure %%%%%%%%%%%%%

%define the current standard, A.DC
A.DC = A.STD_num;

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
     
STD(A.DC).handles = struct('h_stdfig',[],'h_std_delete_button',[],'h_std_resetx_button',[],'h_stdline_toggle',[],'h_toggle_all',[],'h_toggle_none',[],...
    'radiogroup',[],'radio_std1',[],'radio_std2',[],'radio_std3',[],'radio_std4',[],'h_std_from_text',[],'h_std_to_text',[],...
    'h_std_total_text',[],'h_std_graphic_text',[],'h_std_manual_text',[],'h_stdbg_userfrom',[],'h_stdsig_userfrom',[],...
    'h_stdbg_userto',[],'h_stdsig_userto',[],'h_bgpatch',[],'h_sigpatch',[]);

STD(A.DC).handles.h_stdfig = figure('name',['Standard (' STD(A.DC).fileinfo.name ')'],...
    'units','pixels','tag',STD(A.DC).fileinfo.name,'NumberTitle','off','menubar','none','WindowButtonDownFcn','STDPICKER',...
    'position',[10*sf(1) 100*sf(2) 770*sf(1) 850*sf(2)],'Color',[0.5137 0.6 0.6941],'UserData',STD(A.DC).order_opened);

% create an array containing all the 'A.d' variables. This keeps track of
% which standard plots are currently open
A.STDfigs_open = {STD.figure_state};
A.STDfigs_open = strcmp(A.STDfigs_open,'open');

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

%%%%%%%%% Show the display mode menu %%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%% Added in 1.0.3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
STD(A.DC).handles.h_modemenu = uimenu('Label','Switch Display Mode');
STD(A.DC).handles.h_elementmenu = uimenu(STD(A.DC).handles.h_modemenu,'Label','Plot Isotopes','Enable','off','Callback','mode=''element'';STDRATIO');
STD(A.DC).handles.h_ratiomenu = uimenu(STD(A.DC).handles.h_modemenu,'Label','Plot Ratios','Callback','mode=''ratio'';STDRATIO');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

STDRESETX = ['if strcmp(get(gca,''tag''),''STD.handles.h_stdplot'');'...
                 'set(gca,''XLim'',STD(A.DC).XLim_orig,''YLim'',STD(A.DC).YLim_orig);'...
             'end'];

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

hold on

% reduce the fontsize if a lower resolution monitor is being used
% Changed in 1.0.4
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

% That's it.

SILLSFIG_UPDATE
%figure(STD(A.DC).handles.h_stdfig)

clear c C