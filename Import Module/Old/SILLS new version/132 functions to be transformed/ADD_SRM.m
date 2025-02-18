
%%%%%%%%%% ADD_SRM.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creates the window that prompts the user to define a new SRM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ADDSRM = struct('handles',[],'srm_elements',[],'element_library_size',[],'addlist',[],...
    'srm_row_index',[],'srm_num',[],'srm_selected_list',[],...
    'srm_output_table',[],'ADDsrmFILE',[]);

ADDSRM.handles = struct('h_srmfig',[],'h_element_label',[],'h_element_conc',[],...
    'h_enterconc',[],'h_srm_save',[]);

% create the figure
ADDSRM.handles.h_srmfig =               figure('name','Define New SRM',...
    'Color',[0 0 0.3],'position',[200*sf(1) 30*sf(2) 820*sf(1) 620*sf(2)],...
    'menubar','none','NumberTitle','off');

% establish an element list
ADDSRM.srm_elements = {'Li' 'Be' 'B' 'C' 'Na' 'Mg' 'Al' 'Si' 'P' 'S' 'Cl' 'K' 'Ca' 'Sc' 'Ti' 'V' 'Cr' 'Mn' 'Fe',...
     'Co' 'Ni' 'Cu' 'Zn' 'Ga' 'Ge' 'As' 'Se' 'Br' 'Rb' 'Sr' 'Y' 'Zr' 'Nb' 'Mo' 'Tc' 'Ru' 'Rh' 'Pd' 'Ag' 'Cd' 'In' 'Sn',...
     'Sb' 'Te' 'I' 'Cs' 'Ba' 'La' 'Ce' 'Pr' 'Nd' 'Pm' 'Sm' 'Eu' 'Gd' 'Tb' 'Dy' 'Ho' 'Er' 'Tm' 'Yb' 'Lu' 'Hf' 'Ta' 'W',...
     'Re' 'Os' 'Ir' 'Pt' 'Au' 'Hg' 'Tl' 'Pb' 'Bi' 'Th' 'U'}';

ADDSRM.element_library_size = size(ADDSRM.srm_elements,1); %establish how many elements in the list above (may change)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Next, create the GUI elements for each entry in the figure (20 elements per column)

for c = 1:ADDSRM.element_library_size
    
    b = fix((c-1)/20)+1; %establish the column number
   
    ADDSRM.handles.h_element_label(c) =     uicontrol('style','text','string',ADDSRM.srm_elements(c),...
        'ForegroundColor',[1 1 1],'BackgroundColor',[0 0 0.3],...
        'HorizontalAlignment','left','position',[(30+200*(b-1))*sf(1) (525-25*(c-20*(b-1)))*sf(2) 50*sf(1) 25*sf(2)]);
    
    ADDSRM.handles.h_element_conc(c) =     uicontrol('style','edit','position',[(70+200*(b-1))*sf(1) (530-25*(c-20*(b-1)))*sf(2) 100*sf(1) 20*sf(2)],...
        'HorizontalAlignment','right','BackgroundColor',[0 0 0],'Foregroundcolor',[1 1 1]);                             
end
clear b c
%%%%%%%%%%%%%%%


ADDSRM.handles.h_enterconc =   uicontrol('style','text','string','Enter Concentrations (ug/g)',...
                     'ForegroundColor',[1 1 1],'BackgroundColor',[0 0 0.3],'FontWeight','bold',...
                     'position',[270*sf(1) 550*sf(2) 300*sf(1) 20*sf(2)],'HorizontalAlignment','center');

% make the save standard button
ADDSRM.handles.h_srm_save =         uicontrol('style','pushbutton','string','Save SRM to File',...
    'Callback','ADD_SRM_SAVE','position',[630*sf(1) 50*sf(2) 150*sf(1) 50*sf(2)],...
    'backgroundcolor',[0.5137 0.6 0.6941]);


child = get(gcf,'children'); %cluster all the figure handles into 'child'
set(child,'fontname','helvetica','fontsize',8); % set font style
if sf(1) < 0.8
    set(child,'fontsize',7); % reduce font size for lower resolution monitors
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

% C'est tout!
