%%%%%%%%%%%%%%%%%%% AUTOINT.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%This script sets the integration intervals automatically

%First, set up the figure
abort = 0; % Changes to 1 if figure is closed or Cancel is selected

% % %Calculate some position parameters, removed in 1.2.0
% h1 = 150 * sf(2);
% h2 = (A.STD_num + 1) * 20 * sf(2) + 10 * sf(2);
% h3 = (A.UNK_num + 1) * 20 * sf(2) + 10 * sf(2);
% h0 = 60 * sf(2) + h1 + h2 + h3;

%Set up figure and GUI objects; All positions changed in 1.2.0
autofig = figure('name','Auto Intervals','units','pixels','numbertitle','off',...
    'menubar','none','closerequestfcn','abort=1;delete(gcf);',...
    'position',[600*sf(1) 100*sf(2) 300*sf(1) 800*sf(2)]);

frame1 = uipanel(autofig,'units','pixels','position',[10*sf(1) 640*sf(2) 280*sf(1) 150*sf(2)]);
frame2 = uipanel(autofig,'units','pixels','position',[10*sf(1) 510*sf(2) 280*sf(1) 120*sf(2)],'title','Include following Standards');
frame3 = uipanel(autofig,'units','pixels','position',[10*sf(1) 50*sf(2) 280*sf(1) 450*sf(2)],'title','Include following Unknowns');

elementselect = uicontrol(frame1,'style','popupmenu','string',A.ISOTOPE_list,'position',[10*sf(1) 110*sf(2) 60*sf(1) 20*sf(2)]);
elementtext = uicontrol(frame1,'style','text','string','Element used to determine the intervals. It should show high intensity and low background.',...
    'position',[80*sf(1) 90*sf(2) 190*sf(1) 50*sf(2)],'horizontalalignment','left');
sigdelayedit = uicontrol(frame1,'style','edit','string','10','position',[10*sf(1) 65*sf(2) 60*sf(1) 20*sf(2)],'backgroundcolor','w');
sigdelaytext = uicontrol(frame1,'style','text','string',{'Delay after signal start';'(Number of time steps)'},...
    'position',[80*sf(1) 60*sf(2) 190*sf(1) 30*sf(2)],'horizontalalignment','left');
siglengthedit = uicontrol(frame1,'style','edit','string','','position',[10*sf(1) 25*sf(2) 60*sf(1) 20*sf(2)],'backgroundcolor','w');
siglengthtext = uicontrol(frame1,'style','text','string',{'Length of signal after delay';'(Number of time steps)';'Leave empty to detect automatically'},...
    'position',[80*sf(1) 5*sf(2) 190*sf(1) 50*sf(2)],'horizontalalignment','left');

stdtable = uitable(frame2,'Units','pixels','Position',[0 0 278*sf(1) 105*sf(2)],'Enable','on','ColumnFormat',{'logical'},'ColumnEditable',true,...
    'ColumnName',[],'RowName',A.STDPOPUPLIST,'Data',true(A.STD_num,1)); %Added in 1.2.0
unktable = uitable(frame3,'Units','pixels','Position',[0 0 278*sf(1) 435*sf(2)],'Enable','on','ColumnFormat',{'logical'},'ColumnEditable',true,...
    'ColumnName',[],'RowName',A.UNKPOPUPLIST,'Data',true(A.UNK_num,1)); %Added in 1.2.0

% for i = 1:A.STD_num % Removed in 1.2.0
%     stdbox(i) = uicontrol(frame2,'style','checkbox','string',A.STDPOPUPLIST(i),'value',1,'position',[10*sf(1) h2-(i+1)*20*sf(2) 260*sf(1) 20*sf(2)]);
% end
% 
% for i = 1:A.UNK_num
%     unkbox(i) = uicontrol(frame3,'style','checkbox','string',A.UNKPOPUPLIST(i),'value',1,'position',[10*sf(1) h3-(i+1)*20*sf(2) 260*sf(1) 20*sf(2)]);
% end

donebutton = uicontrol(autofig,'style','pushbutton','string','Done','Fontweight','bold','callback','uiresume;','position',[10*sf(1) 10*sf(1) 135*sf(1) 30*sf(2)]);
cancelbutton = uicontrol(autofig,'style','pushbutton','string','Cancel','callback','abort=1;delete(gcf)','position',[155*sf(1) 10*sf(1) 135*sf(1) 30*sf(2)]);

uiwait(autofig);

%Abort if Cancel is clicked or the figure is closed
if abort == 1
    clear abort autofig frame1 frame2 frame3 elementselect i
    clear elementtext sigdelayedit sigdelaytext siglengthedit siglengthtext stdtable unktable donebutton cancelbutton
    return
end

%If Done was clicked

%Read parameters
element = get(elementselect,'value');
stdselect = get(stdtable,'data'); %Changed in 1.2.0
unkselect = get(unktable,'data'); %Changed in 1.2.0
delay = str2num(get(sigdelayedit,'string'));
lengthmanual = str2num(get(siglengthedit,'string'));

%Close figure & clear some variables not needed
delete(autofig);    
clear abort autofig frame1 frame2 frame3 elementselect i
clear elementtext sigdelayedit sigdelaytext siglengthedit siglengthtext stdtable unktable donebutton cancelbutton

%STANDARDS
stderror = zeros(A.STD_num,1); %Added in 1.2.0
for c = 1:A.STD_num
    if stdselect(c) == 0
        continue
    else
        
        time = STD(c).data(:,1);
        cps = STD(c).data(:,element+1);
        
        for i = 3:length(time)-2
            meanfive(i-2) = (cps(i-2)+cps(i-1)+cps(i)+cps(i+1)+cps(i+2)) / 5;
        end
        for j = 1:length(meanfive)-1
            difference(j) = meanfive(j+1) - meanfive(j);
        end
        
        [maximum,startindex] = max(difference);
        [minimum,endindex] = min(difference);
        
        if ~isempty(lengthmanual)
            endindex = startindex + delay + lengthmanual;
        end
        
        if endindex < startindex+delay %changed in 1.2.0
            stderror(c) = 1;
            clear time cps i j meanfive difference maximum startindex minimum endindex
            STD(c).bgwindow = [];
            STD(c).sigwindow = [];
            continue
        end
        
        startindex = startindex + 2;
        endindex = endindex + 2;
        
        try %Added in 1.2.0
            bgstart = time(3);
            bgend = time(startindex - 7);
            
            sigstart = time(startindex + delay);
            sigend = time(endindex -5);
            
            STD(c).bgwindow = [bgstart bgend];
            STD(c).sigwindow = [sigstart sigend];
        catch
            stderror(c) = 1;
            STD(c).bgwindow = [];
            STD(c).sigwindow = [];
        end
        
        clear time cps meanfive difference maximum minimum i j
        clear startindex endindex bgstart bgend sigstart sigend
    end
end

%UNKNOWNS
unkerror = zeros(A.UNK_num,1);
for c = 1:A.UNK_num
    if unkselect(c) == 0
        continue
    else
        
        time = UNK(c).data(:,1);
        cps = UNK(c).data(:,element+1);
        
        for i = 3:length(time)-2
            meanfive(i-2) = (cps(i-2)+cps(i-1)+cps(i)+cps(i+1)+cps(i+2)) / 5;
        end
        for j = 1:length(meanfive)-1
            difference(j) = meanfive(j+1) - meanfive(j);
        end
        
        [maximum,startindex] = max(difference);
        [minimum,endindex] = min(difference);
        
        if ~isempty(lengthmanual)
            endindex = startindex + delay + lengthmanual;
        end
        
        if endindex < startindex+delay %Changed in 1.2.0
            unkerror(c) = 1;
            clear time cps i j meanfive difference maximum startindex minimum endindex
            UNK(c).bgwindow = [];
            UNK(c).comp1window = [];
            UNK(c).comp2window = [];
            UNK(c).comp3window = [];
            UNK(c).mat1window = [];
            UNK(c).mat2window = [];
            UNK(c).sigtotal = 0;
            UNK(c).mattotal = 0;
            continue
        end
        
        startindex = startindex + 2;
        endindex = endindex + 2;
        
        try %Added in 1.2.0
            bgstart = time(3);
            bgend = time(startindex - 7);
            
            sigstart = time(startindex + delay);
            sigend = time(endindex -5);
            
            UNK(c).bgwindow = [bgstart bgend];
            UNK(c).comp1window = [sigstart sigend];
            UNK(c).comp2window = [];
            UNK(c).comp3window = [];
            UNK(c).mat1window = [];
            UNK(c).mat2window = [];
            UNK(c).sigtotal = sigend - sigstart;
            UNK(c).mattotal = 0;
        catch
            unkerror(c) = 1;
            UNK(c).bgwindow = [];
            UNK(c).comp1window = [];
            UNK(c).comp2window = [];
            UNK(c).comp3window = [];
            UNK(c).mat1window = [];
            UNK(c).mat2window = [];
            UNK(c).sigtotal = 0;
            UNK(c).mattotal = 0;
        end
        
        clear time cps meanfive difference maximum minimum i j
        clear startindex endindex bgstart bgend sigstart sigend
    end
end

%Display warning if errors have been detected, added in 1.2.0
if sum(stderror) > 0 || sum(unkerror) > 0
    warn = vertcat({'SILLS was unable to set integration intervals automatically:'},...
        {'Standards:'},...
        A.STDPOPUPLIST(find(stderror)),...
        {'Unknowns:'},...
        A.UNKPOPUPLIST(find(unkerror)));
    warndlg(warn,'SILLS Warning');
end

clear element stdselect unkselect delay c lengthmanual stderror unkerror warn

SILLSFIG_UPDATE