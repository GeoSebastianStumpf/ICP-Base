%SALTSET

%Test to see if there is a Signal Quantification figure already open;
%if so, close it:
if A.SIGSALT_open == 1
    delete(SALT.h_fig);
end

%declare the Signal Quantification figure open
A.SIGSALT_open = 1;

%define which elements you would like to take into account in the balance
%correction

fig_of_origin = get(gcf,'tag');
if strcmp(fig_of_origin,'SMAN.sigquant_fig')==1
    A.KC = get(gcf,'UserData');
elseif strcmp(fig_of_origin,'SILLS Calculation Manager')==1
    A.KC = get(gco,'UserData');
end

SALTCONFIRM = ['A.KC = get(gcf,''UserData'');'...
               'for c = 1:A.ISOTOPE_num;'...
               'UNK(A.KC).SALT(c) = get(SALT.h_isotope_radio(c),''Value'');'...
               'end;'...
               'A.SIGSALT_open=0;'...
               'delete(gcf);'];  

SALT = struct('h_fig',[],'h_dframe1',[],'h_dframe2',[],'h_dt_ok',[],'h_isotope_label',[],'h_isotope_radio',[],'colnumber',[]);

SALT.colnumber = fix(A.ISOTOPE_num/10)+1; % number of columns in the figure (max of 10 isotopes per column)

SALT.h_fig = figure('name','Salt Correction Settings','Userdata',A.KC,'Color',[0 0 0],'NumberTitle','off','menubar','none','Position',[500*sf(1) 100*sf(2) 20+140*SALT.colnumber*sf(1) 485*sf(2)],'CloseRequestFcn',SALTCONFIRM);

SALT.h_dframe1 =  uicontrol(SALT.h_fig,'style','frame','position',[10*sf(1) 330*sf(2) 140*SALT.colnumber*sf(1) 145*sf(2)],...
    'backgroundcolor',[.9 .9 .9]);

SALT.h_dframe2 = uicontrol(SALT.h_fig,'style','frame','position',[10*sf(1) 10*sf(2) 140*SALT.colnumber*sf(1) 315*sf(2)],...
    'backgroundcolor',[.9 .9 .9]);

SALTMASSBALANCE = ['SALT_mass_balance_factor = get(gco,''string'');'...
                'SALT_mass_balance_factor = str2num(SALT_mass_balance_factor);'...
                'UNK(A.KC).SALT_mass_balance_factor = SALT_mass_balance_factor;'];
           
               
SALT.h_header1 =  uicontrol(SALT.h_fig,'style','text','string','1) Click all isotopes you would like to include in the salt correction','BackgroundColor',[.9 .9 .9],'ForegroundColor',[0 0 0],'position',[15*sf(1) 410*sf(2) 120*sf(1) 50*sf(2)]);

if UNK(A.KC).SIG_constraint1 == 2 %i.e. mass balance calculation
    SALT.h_mass_balance_header1 =   uicontrol(SALT.h_fig,'style','text','string','2) Define ''A'' in the eqn: [NaCl]equiv = [NaCl] + A*sum[XCl]','BackgroundColor',[.9 .9 .9],'position',[15*sf(1) 360*sf(2) 120*sf(1) 50*sf(2)]);
    SALT.h_mass_balance_header2 =   uicontrol(SALT.h_fig,'style','text','string','A =','BackgroundColor',[.9 .9 .9],'HorizontalAlignment','left','position',[20*sf(1) 340*sf(2) 30*sf(1) 20*sf(2)]);
    SALT.h_mass_balance_edit =      uicontrol(SALT.h_fig,'style','edit','Callback',SALTMASSBALANCE,'String',UNK(A.KC).SALT_mass_balance_factor,'BackgroundColor',[1 1 1],'HorizontalAlignment','right','position',[50*sf(1) 340*sf(2) 60*sf(1) 20*sf(2)]);
end

for c = 1:A.ISOTOPE_num; %scroll through the measured isotopes

    b = fix((c-1)/10)+1; %establish the column number (up to 10 isotopes per column)

    SALT.h_isotope_label(c) = uicontrol(SALT.h_fig,'style','text','string',A.ISOTOPE_list(c),'HorizontalAlignment','left',...
        'position',[(20+140*(b-1))*sf(1) (315-30*(c-10*(b-1)))*sf(2) 40*sf(1) 25*sf(2)],...
        'backgroundcolor',[.9 .9 .9]);

    SALT.h_isotope_radio(c) = uicontrol(SALT.h_fig,'style','radio','Userdata',c,'BackgroundColor',[.9 .9 .9],'Value',UNK(A.KC).SALT(c),'HorizontalAlignment','right',...
        'position',[(60+140*(b-1))*sf(1) (320-30*(c-10*(b-1)))*sf(2) 70*sf(1) 25*sf(2)]);

end

set(SALT.h_isotope_radio(A.Na_index),'Value',1,'Callback','set(gco,''value'',1)');

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

clear fig_of_origin