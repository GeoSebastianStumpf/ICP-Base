% DWELLTIMES

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% callback that sets the dwelltimes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DT = struct('h_fig',[],'h_dframe1',[],'h_dframe2',[],'h_dt_text',[],'h_dt_box',[],'h_dt_eltext',[],'h_dt_elbox',[]);

if isempty(A.ISOTOPE_list);
    msgbox('Please load a standard or unknown before you set dwell times','SILLS Message','help');
    return
end

DWELL =    ['A.common_dt = get(DT.h_dt_box,''String'');'...
        'A.common_dt = str2num(A.common_dt);'...
        'set(DT.h_dt_box,''Value'',A.common_dt);'...
        'if isempty(A.common_dt);'...
            'return;'...
        'else;'...
            'for c = 1:A.ISOTOPE_num;'...
                'set(DT.h_dt_elbox(c),''String'',A.common_dt,''Value'',A.common_dt);'...
                'A.DT_VALUES(c) = get(DT.h_dt_elbox(c),''Value'');'...
            'end;'...
        'end;'];

DWELLSET =  ['for c=1:A.ISOTOPE_num;'...
                'current_value = get(DT.h_dt_elbox(c),''String'');'...
                'current_value = str2num(current_value);'...
                'A.DT_VALUES(c) = current_value;'...
            'end;'...
            'clear current_value;'...
            'close(gcf);'];
        
DT.colnumber = fix(A.ISOTOPE_num/10)+1; % number of columns in the figure (max of 10 isotopes per column)

DT.h_fig = figure('name','Dwell Times','Color',[0 0 0],'NumberTitle','off','menubar','none','Position',[500*sf(1) 100*sf(2) 20+140*DT.colnumber*sf(1) 455*sf(2)]);

DT.h_dframe1 =  uicontrol(DT.h_fig,'style','frame','position',[10*sf(1) 330*sf(2) 140*DT.colnumber*sf(1) 115*sf(2)],...
    'backgroundcolor',[.5 .5 .5]);

DT.h_dframe2 = uicontrol(DT.h_fig,'style','frame','position',[10*sf(1) 10*sf(2) 140*DT.colnumber*sf(1) 315*sf(2)],...
    'backgroundcolor',[.5 .5 .5]);

DT.h_dt_text = uicontrol(DT.h_fig,'style','text','string','Enter Dwell Time (s) (sets values below)',...
    'position',[20*sf(1) 410*sf(2) 120*sf(1) 25*sf(2)],'ForegroundColor',[1 1 1],'HorizontalAlignment','left',...
    'backgroundcolor',[.5 .5 .5]);

DT.h_dt_box =  uicontrol(DT.h_fig,'style','edit','position',[20*sf(1) 380*sf(2) 110*sf(1) 25*sf(2)],...
    'Callback',DWELL,'BackgroundColor',[0 0 0],'ForegroundColor',[1 1 1],'HorizontalAlignment','right');

DT.h_dt_ok =   uicontrol(DT.h_fig,'style','pushbutton','string','DONE','Callback',DWELLSET,'position',[20*sf(1) 340*sf(2) 110*sf(1) 30*sf(2)]);

%set up the isotope labels and adjacent dwell time value boxes


for c = 1:A.ISOTOPE_num; %scroll through the measured isotopes

    b = fix((c-1)/10)+1; %establish the column number (up to 10 isotopes per column)

    DT.h_dt_eltext(c) = uicontrol(DT.h_fig,'style','text','string',A.ISOTOPE_list(c),'HorizontalAlignment','left',...
        'position',[(20+140*(b-1))*sf(1) (315-30*(c-10*(b-1)))*sf(2) 40*sf(1) 25*sf(2)],...
        'backgroundcolor',[.5 .5 .5]);

    DT.h_dt_elbox(c) = uicontrol(DT.h_fig,'style','edit','Userdata',c,'BackgroundColor',[1 1 1],'HorizontalAlignment','right',...
        'position',[(60+140*(b-1))*sf(1) (320-30*(c-10*(b-1)))*sf(2) 70*sf(1) 25*sf(2)]);

    if A.DT_VALUES(c) ~= 0
        set(DT.h_dt_elbox(c),'value',A.DT_VALUES(c),'string',A.DT_VALUES(c));
    end
end

clear c b
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

