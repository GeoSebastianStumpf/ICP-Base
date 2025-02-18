%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALC_MANAGER
%
% This callback generated the Calculation Manager page, which contains all
% the quantification settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make sure there are standards loaded. These are later needed to define
% which isotopes are available as internal standards

if A.STD_num == 0
    msgbox('Please load standards before proceeding.','SILLS Message','error');
    return
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close current Calculation Manager windows.
searchdestroy = findobj('tag','SILLS Calculation Manager');
delete(searchdestroy);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close current CALIBPLOT windows.
searchdestroy = findobj('tag','SILLS Calibration Graphs');
delete(searchdestroy);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test if Fe was measured; only create the Fe ratio box if this is the
% case (below)
A.Fe_test = strcmp(A.ELEMENT_list,'Fe');
A.Fe_test = sum(A.Fe_test);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test if Na was measured; this will be used to determine whether a
% salt correction option is offered
A.Na_test = strcmp(A.ELEMENT_list,'Na');
A.Na_test = sum(A.Na_test);

%find Na in the isotope list
A.Naseek = strcmp(A.ISOTOPE_list,'Na23');
A.Na_index = find(A.Naseek==1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compare the elements analysed against those in the standards and produce
% a matrix A.ELEMENTS_with_SRM_data showing which elements are available in
% which standards

    clear A.ELEMENTS_with_SRM_data
    clear A.ELEMENTS_in_all_SRMs_index
    clear A.ELEMENTS_in_all_SRMs
    clear A.ISOTOPES_in_all_SRMs_index
    clear A.ISOTOPES_in_all_SRMs
    clear A.ISOTOPENUMBERS_in_all_SRMs

    %first determine how many different SRMs there are

    clear temp
    for c = 1:A.STD_num;
        temp(c) = STD(c).SRM;
    end
    A.SRM_num_used = size(unique(temp));
    A.SRM_num_used = A.SRM_num_used(2);
    clear temp

    %next compared the measured element list to those available in the
    %standard data

    A.ELEMENTS_with_SRM_data = zeros(A.SRM_num_used,A.ELEMENT_num);

    for d = 1:A.SRM_num_used;
        for c = 1:A.ELEMENT_num
            temp = sum(strcmp(SRM(d).rowheaders,A.ELEMENT_list(c)));
            A.ELEMENTS_with_SRM_data(d,c) = temp;
        end
    end
    clear temp

    % create a subset of elements which are defined in ALL SRMs

    temp = sum(A.ELEMENTS_with_SRM_data,1);
    A.ELEMENTS_in_all_SRMs_index = find(temp == A.SRM_num_used);
    if isempty(temp)
        msgbox('At least one isotope needs to occur in all Standard Reference Materials. Check SRM files','SILLS Message','error');
        return
    else

        A.ELEMENTS_in_all_SRMs_num = size(A.ELEMENTS_in_all_SRMs_index);
        A.ELEMENTS_in_all_SRMs_num = A.ELEMENTS_in_all_SRMs_num(2);

        for c = 1:A.ELEMENTS_in_all_SRMs_num
            A.ELEMENTS_in_all_SRMs(c) = A.ELEMENT_list(A.ELEMENTS_in_all_SRMs_index(c));
        end
    end
    clear temp temp2 

    % Now, convert A.ELEMENTS_in_all_SRMs into a list of measured isotopes

    for c = 1:A.ELEMENTS_in_all_SRMs_num
        temp(c,:) = strcmp(A.ELEMENT_list,char(A.ELEMENTS_in_all_SRMs(c)));
    end

    for c = 1:A.ELEMENT_num
        if sum(temp(:,c),1)>0
            temp2(c) = 1;
        else
            temp2(c) = 0;
        end
    end

    %%% now need to search temp2 for 1's and get their column indices.

    A.ISOTOPES_in_all_SRMs_index = find(temp2==1);
    A.ISOTOPES_in_all_SRMs_num = size(A.ISOTOPES_in_all_SRMs_index);
    A.ISOTOPES_in_all_SRMs_num = A.ISOTOPES_in_all_SRMs_num(2);
    
    A.ISOTOPES_in_all_SRMs = A.ISOTOPE_list(A.ISOTOPES_in_all_SRMs_index);
    
    A.ISOTOPES_with_no_SRM_index = find(temp2==0);
    A.ISOTOPES_with_no_SRM = A.ISOTOPE_list(A.ISOTOPES_in_all_SRMs_index);
    
    %clear temp temp2
    
    %%% make a list of just isotope numbers from the A.ISOTOPES_in_all_SRMs
    %%% list
    
    isotope = char(A.ISOTOPES_in_all_SRMs); %convert isotopes into a character array
    iselement = isletter(isotope);  %search for letters within the 'isotope' array
    isnumber = -(iselement-1);
    number = isnumber.*isotope;
    number2 = char(number);
    for c = 1:A.ISOTOPES_in_all_SRMs_num;
        A.ISOTOPENUMBERS_in_all_SRMs(c) = str2num(char(number2(c,:)));
    end

    clear isotope iselement isnumber number number2 temp temp2
    
% Great - A.ISOTOPES_in_all_SRMs is now the list of isotopes that can act
% as internal standards (either for quantification or for drift
% corrections).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Now let's define the so-called 'reference internal standard (REFIS)'. This 
% is an item from the list A.ISOTOPES_in_all_SRMs assumed to have 0 drift 
% and is used as the internal standard to which all calibration slopes are 
% defined. When you define other internal standard in the Calculation 
% Manager, relevant calibration slopes are re-calculated relative to the 
% new internal standard.

temp = char(A.ISOTOPES_in_all_SRMs(A.REFIS_list_index)); %select the first item from the ISOTOPES_in_all_SRMs as the DCIS
temp2 = strcmp(A.ISOTOPE_list,temp);    %find this item in the whole ISOTOPE_list
temp3 = find(temp2==1);
A.REFIS = temp3;
clear temp temp2 temp3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Create a subset of the major oxides that were measured in the
% %analytical protocol (N.B. also need to be elements that were measured in all
% %SRMs...as above....)

%compare the elements in the oxide list with the ELEMENTS_in_all_SRMs list
clear oxide_seek
for b=1:11 
    oxide_seek(:,b) = strcmp(A.ELEMENTS_in_all_SRMs,A.Oxides(b,1));
end

if sum(oxide_seek(:)) == 0 %i.e. no major oxide elements analysed
    A.Oxide_test = 0;
    A.report_settings_oxide = 'off';
else 
    A.Oxide_test = 1;
end

if A.Oxide_test ~= 0;

    %determine the indices of all oxides elements in the ELEMENTS_in_all_SRMs
    %list
    A.OXIDES_in_all_SRMs_index = [];
    b = [];
    for d = 1:11
        temp = find(oxide_seek(:,d)==1);
        x = size(temp);
        x = x(1);
        for e = 1:x
            f = A.Oxides(d,2);
            b = [b;f];
        end
        A.OXIDES_in_all_SRMs_index = [A.OXIDES_in_all_SRMs_index;temp];
    end

    A.OXIDES_in_all_SRMs_oxide = b;
    num = size(A.OXIDES_in_all_SRMs_index);
    num = num(1);

    %create the list of possible oxide internal standards 
    for d = 1:num
        A.OXIDES_in_all_SRMs(d) = {[char(b(d)) ' (' num2str(A.ISOTOPENUMBERS_in_all_SRMs(A.OXIDES_in_all_SRMs_index(d))) ')']};
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    A.UNK_num = size(UNK,2); % first, see how many unknowns have been loaded

    if A.UNK_num == 0
        msgbox('No unknowns have been loaded','SILLS Message','help')
       
    end

    if A.UNK_num == 1
        if isempty(UNK(A.UNK_num).data)
            msgbox('No unknowns have been loaded','SILLS Message','help')
            A.UNK_num = 0;
            
        end
        A.UNK_num = size(UNK,1);
    end

    A.ISOTOPE_list_1 = ['1' A.ISOTOPE_list];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%set up the SMAN figure and its components
SMAN = struct('h_SMAN',[],'figparts',[],'handles',[],'menuitems',[],'figure_state','open');
SMAN.handles = struct('h_UNKfile',[]);
SMAN.handles(A.UNK_num,1) = struct('h_UNKfile',[]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the figure and the two main coloured frames.

if isempty(A.sillsfile)
    name = 'Untitled';
else
    name = A.sillsfile;
end

SMAN.h_SMAN =         figure('name',['Calculation Manager: ' name],'tag','SILLS Calculation Manager','UserData',1000000,...
    'Color',[1 1 1],'NumberTitle','off','position',[10*sf(1) 60*sf(2) 1380*sf(1) 960*sf(2)],'menubar','none','CloseRequestFcn','A.CALC_MANAGER_open = 0;delete(SMAN.h_SMAN)');
set(SMAN.h_SMAN,'DockControls','off'); %Added in 1.0.2

clear name;

A.CALC_MANAGER_open = 1; %variable that says whether the window is open or not.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the menu items
SMAN.menuitems.report =  uimenu('Label','Report');
SMAN.menuitems.calibration =  uimenu('Label','Calibration');
SMAN.menuitems.calibration_show =  uimenu(SMAN.menuitems.calibration,'Label','Show Drift','Callback','CALIBPLOT');

SMAN.menuitems.report_settings = uimenu(SMAN.menuitems.report,'Label','Settings');
SMAN.menuitems.report_write = uimenu(SMAN.menuitems.report,'Label','Create Output Report','Callback','REPORT_WRITE');

REPORT_SETTINGS = ['clear temp;'...
    'temp = get(gcbo,''tag'');'...
    'check = get(gcbo,''check'');'...
    'if strcmp(temp,''majors_as_oxides'') == 1 && A.Oxide_test ~= 0;'...
        'if strcmp(check,''on'')==1;'...
            'set(gcbo,''checked'',''off'');'...
            'A.report_settings_oxide = ''off'';'...
        'else;'...
            'set(gcbo,''checked'',''on'');'...
            'A.report_settings_oxide = ''on'';'...
        'end;'...
    'elseif strcmp(temp,''majors_as_oxide'') == 1 && A.Oxide_test ~= 0;'...
        'set(gcgo,''checked'',''off'');'...
        'A.report_settings_oxide = ''off'';'...
    'end;'...
    'clear check temp;'];

RATIOS = ['clear temp temp2 temp3;'...
    'temp = get(gcbo,''Userdata'');'...
    'set(SMAN.menuitems.ratios_elements(:),''checked'',''off'');'...
    'set(SMAN.menuitems.ratios_elements(temp),''checked'',''on'');'...
    'A.REPORTIS_list_index = temp;'...
    'temp2 = A.ISOTOPES_in_all_SRMs(A.REPORTIS_list_index);'...
    'temp3 = strcmp(A.ISOTOPE_list,temp2);'...
    'A.REPORTIS = find(temp3==1);'];

if A.Oxide_test ~= 0
    SMAN.menuitems.majors_as_oxides = uimenu(SMAN.menuitems.report_settings,'Label','Major Elements as Oxides','Callback',REPORT_SETTINGS,'tag','majors_as_oxides','checked',A.report_settings_oxide);
end
    %SMAN.menuitems.population =     uimenu(SMAN.menuitems.report_settings,'Label','Show Population Analysis','Callback',REPORT_SETTINGS,'tag','population_analysis','checked',A.report_settings_population);
SMAN.menuitems.ratios = uimenu(SMAN.menuitems.report_settings,'Label','Show Ratios to Which Element?','tag','ratios');

for b = 1:A.ISOTOPES_in_all_SRMs_num;
    SMAN.menuitems.ratios_elements(b) = uimenu(SMAN.menuitems.ratios,'Label',char(A.ISOTOPES_in_all_SRMs(b)),'Userdata',b,'Callback',RATIOS);
end

set(SMAN.menuitems.ratios_elements(:),'checked','off');
set(SMAN.menuitems.ratios_elements(A.REPORTIS_list_index),'checked','on');

%Create the menu item to change LOD filter factor
%Added in 1.0.2
SETLODFF = ['answer = inputdlg(''Enter LOD filter factor (Default: 3; Only applicable for Longerich method)'',''Set LOD filter factor'',1,cellstr(num2str(A.LODff)),''off'');'...
    'if ~isnan(str2double(answer));'...
       'A.LODff = str2double(answer);'...
    'else;'...
       'errordlg(''Enter a numeric value!'',''SILLS Error'');'...
       'uiwait;'...
    'end;'...
    'clear answer;'];
SMAN.menuitems.LOD = uimenu(SMAN.menuitems.report_settings,'Label','Set LOD filter factor','Callback',SETLODFF,'Separator','on');

%Create the LOD method menus
%Added 1.3.2
setLODmethod = ['A.LODmethod = get(gcbo,''tag'');'...
                  'if strcmp(A.LODmethod,''Pettke'')==1;'...    
                        'set(SMAN.menuitems.pettke,''checked'',''on'');'...
                        'set(SMAN.menuitems.longerich,''checked'',''off'');'...
                  'elseif strcmp(A.LODmethod,''Longerich'')==1;'...
                        'set(SMAN.menuitems.pettke,''checked'',''off'');'...
                        'set(SMAN.menuitems.longerich,''checked'',''on'');'...
                  'end;'];

SMAN.menuitems.method = uimenu(SMAN.menuitems.report_settings,'Label','Set LOD method');
SMAN.menuitems.pettke = uimenu(SMAN.menuitems.method,'Label','Pettke (2012)','Tag','Pettke','Callback',setLODmethod);
SMAN.menuitems.longerich = uimenu(SMAN.menuitems.method,'Label','Longerich (1996)','Tag','Longerich','Callback',setLODmethod);
if ~isfield(A,'LODmethod') || isempty(A.LODmethod)
    A.LODmethod = 'Pettke';
end
if strcmp(A.LODmethod,'Pettke')==1
    set(SMAN.menuitems.pettke,'checked','on')
    set(SMAN.menuitems.longerich,'checked','off');
elseif strcmp(A.LODmethod,'Longerich')==1
    set(SMAN.menuitems.pettke,'checked','off')
    set(SMAN.menuitems.longerich,'checked','on');
end


%define the internal standard for the report (this is just used for
%expressing ratios)
clear temp temp2
temp = A.ISOTOPES_in_all_SRMs(A.REPORTIS_list_index);
temp2 = strcmp(A.ISOTOPE_list,temp);
A.REPORTIS = find(temp2 == 1);
clear temp temp2



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SMAN.figparts.h_SMANframe2 =     uipanel(SMAN.h_SMAN,'units','pixels','BackgroundColor',[.9 1 .9],'ForegroundColor',[.9 1 .9],'BorderWidth',0,'position',[340*sf(1) 0*sf(2) 490*sf(1) 960*sf(2)]);
SMAN.figparts.h_SMANframe3 =     uipanel(SMAN.h_SMAN,'units','pixels','BackgroundColor',[.9 .9 1],'ForegroundColor',[.9 .9 1],'BorderWidth',0,'position',[830*sf(1) 0*sf(2) 415*sf(1) 960*sf(2)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the headers
SMAN.figparts.h_Infoheader =     uicontrol(SMAN.h_SMAN,'style','text','BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','center','string','Description','position',[135*sf(1) 870*sf(2) 125*sf(1) 60*sf(2)]);
SMAN.figparts.h_Timpointhead =   uicontrol(SMAN.h_SMAN,'style','text','BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','center','string','Assign Time','position',[280*sf(1) 870*sf(2) 35*sf(1) 60*sf(2)]);

SMAN.figparts.h_CPSonly =        uicontrol(SMAN.h_SMAN,'style','checkbox','BackgroundColor',[1 1 1],'string','CPS data only','Callback','CPSONLY','max',1,'min',0,'value',A.cpsonly,'FontWeight','bold','position',[15*sf(1) 910*sf(2) 125*sf(1) 30*sf(2)]); %Added in 1.0.3

SMAN.figparts.h_MAThead =        uicontrol(SMAN.h_SMAN,'style','text','BackgroundColor',[.9 1 .9],'ForegroundColor',[0 0 0],'HorizontalAlignment','center','Fontweight','bold','string','MATRIX SETTINGS','position',[340*sf(1) 930*sf(2) 490*sf(1) 20*sf(2)]);
SMAN.figparts.h_MATtypehead =    uicontrol(SMAN.h_SMAN,'style','text','BackgroundColor',[.9 1 .9],'ForegroundColor',[0 0 0],'HorizontalAlignment','center','string','Correction Type','position',[350*sf(1) 890*sf(2) 85*sf(1) 40*sf(2)]);
SMAN.figparts.h_MATfilehead =    uicontrol(SMAN.h_SMAN,'style','text','BackgroundColor',[.9 1 .9],'ForegroundColor',[0 0 0],'HorizontalAlignment','center','string','Apply Matrix from File','position',[455*sf(1) 890*sf(2) 80*sf(1) 40*sf(2)]);
SMAN.figparts.h_MATconchead =    uicontrol(SMAN.h_SMAN,'style','text','BackgroundColor',[.9 1 .9],'ForegroundColor',[0 0 0],'HorizontalAlignment','center','string','Value','position',[555*sf(1) 890*sf(2) 60*sf(1) 40*sf(2)]);

if A.Fe_test ~= 0 %i.e. a Fe isotope was measured
    SMAN.figparts.h_MAT_Feratiohead =   uicontrol(SMAN.h_SMAN,'style','text','BackgroundColor',[.9 1 .9],'ForegroundColor',[0 0 0],'HorizontalAlignment','center','string','FeO /  (FeO+Fe2O3)','position',[675*sf(1) 870*sf(2) 70*sf(1) 60*sf(2)]);
end

SMAN.figparts.h_SIGhead =        uicontrol(SMAN.h_SMAN,'style','text','BackgroundColor',[.9 .9 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','center','Fontweight','bold','string','SAMPLE SETTINGS','position',[830*sf(1) 930*sf(2) 415*sf(1) 20*sf(2)]);
SMAN.figparts.h_SIGtypehead =    uicontrol(SMAN.h_SMAN,'style','text','BackgroundColor',[.9 .9 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','center','string','Correction Type','position',[860*sf(1) 890*sf(2) 80*sf(1) 40*sf(2)]);
SMAN.figparts.h_SIGconchead =    uicontrol(SMAN.h_SMAN,'style','text','BackgroundColor',[.9 .9 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','center','string','Value','position',[970*sf(1) 890*sf(2) 60*sf(1) 40*sf(2)]);

if A.Fe_test ~= 0
    SMAN.figparts.h_SIG_Feratiohead =   uicontrol(SMAN.h_SMAN,'style','text','BackgroundColor',[.9 .9 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','center','string','FeO /  (FeO+Fe2O3)','position',[1090*sf(1) 870*sf(2) 70*sf(1) 60*sf(2)]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MATFILE = ['A.KC = get(gco,''Userdata'');'...
    'matfile_index = get(gco,''value'');'...
    'UNK(A.KC).MATcorrfile_index = matfile_index;'...
    'matfile = A.UNK_with_matrix_index(matfile_index);'...
    'UNK(A.KC).MATcorrfile = matfile;'...
    'clear matfile matfile_index'];

SIGSALT = ['A.KC = get(gco,''Userdata'');'...
    'salt_conc = get(gco,''string'');'...
    'salt_conc = str2num(salt_conc);'...
    'if salt_conc < 0 || salt_conc > 100;'...
    'clear salt_conc;'...
    'msgbox(''Invalid Entry'');'...    
    'return;'...
    'else;'...
    'UNK(A.KC).SIGsalinity = salt_conc;'...
    'end;'...
    'clear salt_conc;'];

MATINTSTD_oxide = ['A.KC = get(gco,''Userdata'');'...
    'intstd_oxide = get(gco,''string'');'...
    'intstd_oxide = str2num(intstd_oxide);'...
    'if intstd_oxide < 0 || intstd_oxide > 100;'...
    'clear intstd_oxide;'...
    'msgbox(''Invalid Entry'');'...
    'return;'...
    'else;'...
    'UNK(A.KC).MAT_oxide_total = intstd_oxide;'...
    'end;'...
    'clear intstd_oxide;'];
SIGINTSTD_oxide = ['A.KC = get(gco,''Userdata'');'...
    'intstd_oxide = get(gco,''string'');'...
    'intstd_oxide = str2num(intstd_oxide);'...
    'if intstd_oxide < 0 || intstd_oxide > 100;'...
    'clear intstd_oxide;'...
    'msgbox(''Invalid Entry'');'...
    'return;'...
    'else;'...
    'UNK(A.KC).SIG_oxide_total = intstd_oxide;'...
    'end;'...
    'clear intstd_oxide;'];

MAT_Feratio = ['A.KC = get(gco,''Userdata'');'...
    'Fe_ratio = get(gco,''string'');'...
    'Fe_ratio = str2num(Fe_ratio);'...
    'if Fe_ratio < 0 || Fe_ratio > 1;'...
    'clear Fe_ratio;'...
    'msgbox(''Invalid Entry'');'...
    'return;'...
    'else;'...
    'UNK(A.KC).MAT_Fe_ratio = Fe_ratio;'...
    'end;'...
    'clear Fe_ratio;'];
SIG_Feratio = ['A.KC = get(gco,''Userdata'');'...
    'Fe_ratio = get(gco,''string'');'...
    'Fe_ratio = str2num(Fe_ratio);'...
    'if Fe_ratio < 0 || Fe_ratio > 1;'...
    'clear Fe_ratio;'...
    'msgbox(''Invalid Entry'');'...
    'return;'...
    'else;'...
    'UNK(A.KC).SIG_Fe_ratio = Fe_ratio;'...
    'end;'...
    'clear Fe_ratio;'];

TIMEPT_UNKASSIGN = ['A.KC = get(gco,''Userdata'');'...
    'UNK(A.KC).timepoint = get(gco,''value'');'];

INFOSAVE = ['A.KC = get(gco,''UserData'');'...
    'UNK(A.KC).Info = get(gco,''string'');'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Determine which files have matrix windows selected

for c=1:A.UNK_num
    if UNK(c).mattotal > 0
        temp(c)=1;
    else
        temp(c)=0;
    end
end

searchdestroy = find(temp==0);
A.UNK_with_matrix = A.UNKPOPUPLIST;
A.UNK_with_matrix(searchdestroy) = [];
A.UNK_with_matrix_index = 1:A.UNK_num;
A.UNK_with_matrix_index(searchdestroy) = [];
A.UNK_with_matrix_num = size(A.UNK_with_matrix,2);
if A.UNK_with_matrix_num == 1;
   A.UNK_with_matrix_num = size(A.UNK_with_matrix,1);
end
clear searchdestroy temp

%for files without a matrix window, set their UNK.MATcorrfile to the first
%in the list

if A.UNK_with_matrix_num ~= 0
    for c = 1:A.UNK_num
        if UNK(c).mattotal > 0 %i.e. a matrix window is selected
            UNK(c).MATcorrfile_index = find(A.UNK_with_matrix_index==c);
            UNK(c).MATcorrfile = c;
        elseif UNK(c).mattotal == 0
            %Commented in 1.0.3
            %UNK(c).MAT_corrtype = 1; %i.e. no matrix correction is possible
            if isempty(UNK(c).MATcorrfile_index) %Added in 1.0.6
                UNK(c).MATcorrfile_index = 1;
                UNK(c).MATcorrfile = A.UNK_with_matrix_index(1);
            end
        end
    end
elseif A.UNK_with_matrix_num == 0
    for c = 1:A.UNK_num
        UNK(c).MAT_corrtype = 1; %i.e. no matrix correction is possible
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create all GUI items (one set for each unknown)

for c = 1:A.UNK_num;

    SMAN.handles(c).h_count =       uicontrol(SMAN.h_SMAN,'style','text','string',c,'Fontweight','bold','BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','left','position',[15*sf(1) (880-20*c)*sf(2) 15*sf(1) 20*sf(2)]);
    SMAN.handles(c).h_UNKfile =     uicontrol(SMAN.h_SMAN,'style','text','string',A.UNKPOPUPLIST(c),'Fontweight','bold','BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','left','position',[40*sf(1) (880-20*c)*sf(2) 110*sf(1) 20*sf(2)]);
    SMAN.handles(c).h_Info =        uicontrol(SMAN.h_SMAN,'style','edit','Userdata',c,'string',UNK(c).Info,'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','left','position',[160*sf(1) (885-20*c)*sf(2) 100*sf(1) 20*sf(2)],'Callback',INFOSAVE);

    SMAN.handles(c).h_TIMEPOINT =   uicontrol(SMAN.h_SMAN,'style','popup','UserData',c,'string',1:A.timepoints,'Value',UNK(c).timepoint,'Callback',TIMEPT_UNKASSIGN,'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'position',[270*sf(1) (885-20*c)*sf(2) 55*sf(1) 20*sf(2)],'Visible','off');
    SMAN.handles(c).h_TIMEhh =      uicontrol(SMAN.h_SMAN,'style','edit','UserData',c,'tag','SMAN.handles.h_TIMEhh','string',UNK(c).hh,'Callback','TIMESET','BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'position',[270*sf(1) (885-20*c)*sf(2) 25*sf(1) 20*sf(2)],'Visible','off');
   % SMAN.handles(c).h_TIMEcolon =   uicontrol(SMAN.h_SMAN,'style','text','UserData',c,'string',:,'Value',UNK(c).timepoint,'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'position',[297*sf(1) (880-20*c)*sf(2) 5*sf(1) 20*sf(2)],'Visible','off');
    SMAN.handles(c).h_TIMEmm =      uicontrol(SMAN.h_SMAN,'style','edit','UserData',c,'tag','SMAN.handles.h_TIMEmm','string',UNK(c).mm,'Callback','TIMESET','BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'position',[305*sf(1) (885-20*c)*sf(2) 25*sf(1) 20*sf(2)],'Visible','off');

    if strcmp(A.timeformat,'integer_points')==1;
        set(SMAN.handles(c).h_TIMEPOINT,'Visible','on');
    elseif strcmp(A.timeformat,'hhmm')==1
        set(SMAN.handles(c).h_TIMEhh,'Visible','on');
        %set(SMAN.handles(c).h_TIMEcolon,'Visible','on');
        set(SMAN.handles(c).h_TIMEmm,'Visible','on');
    end

    SMAN.handles(c).h_MATtype =     uicontrol(SMAN.h_SMAN,'style','popup','Userdata',c,'Callback','MATSET','Value',UNK(c).MAT_corrtype,'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','right','position',[350*sf(1) (885-20*c)*sf(2) 85*sf(1) 20*sf(2)]);
    SMAN.handles(c).h_MATfile =     uicontrol(SMAN.h_SMAN,'style','popup','Userdata',c,'Callback',MATFILE,'string',A.UNK_with_matrix,'Value',UNK(c).MATcorrfile_index,'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','right','position',[445*sf(1) (885-20*c)*sf(2) 100*sf(1) 20*sf(2)]);
    SMAN.handles(c).h_MATconc =     uicontrol(SMAN.h_SMAN,'style','edit','Userdata',c,'Callback','MATINTSTD','string',UNK(c).MATQIS_conc,'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','right','position',[555*sf(1) (885-20*c)*sf(2) 60*sf(1) 20*sf(2)]);
    SMAN.handles(c).h_MATunit =     uicontrol(SMAN.h_SMAN,'style','popup','Userdata',c,'Callback','MATUNIT','BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','left','string',{'ug/g';'wt.%'},'position',[620*sf(1) (885-20*c)*sf(2) 50*sf(1) 20*sf(2)]);
    SMAN.handles(c).h_MATint =      uicontrol(SMAN.h_SMAN,'style','popup','Userdata',c,'Callback','MATINTSTD','string',A.ISOTOPES_in_all_SRMs,'Value',UNK(c).MATQISiso,'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','right','position',[680*sf(1) (885-20*c)*sf(2) 60*sf(1) 20*sf(2)]);
    if A.Oxide_test ~= 0
        SMAN.handles(c).h_MATconcwt =   uicontrol(SMAN.h_SMAN,'style','edit','Userdata',c,'Callback','MATINTSTD','string',UNK(c).MATQIS_concwt,'BackgroundColor',[.9 .9 .9],'ForegroundColor',[0 0 0],'HorizontalAlignment','right','position',[555*sf(1) (885-20*c)*sf(2) 60*sf(1) 20*sf(2)]);
        SMAN.handles(c).h_MATintox =    uicontrol(SMAN.h_SMAN,'style','popup','Userdata',c,'Callback','MATINTSTD','string',A.OXIDES_in_all_SRMs,'Value',UNK(c).MATQISox,'BackgroundColor',[.9 .9 .9],'ForegroundColor',[0 0 0],'HorizontalAlignment','right','position',[680*sf(1) (885-20*c)*sf(2) 60*sf(1) 20*sf(2)]);
        SMAN.handles(c).h_MAToxide =    uicontrol(SMAN.h_SMAN,'style','edit','Userdata',c,'Callback',MATINTSTD_oxide,'string',UNK(c).MAT_oxide_total,'BackgroundColor',[0 0 0],'ForegroundColor',[1 1 1],'HorizontalAlignment','right','position',[555*sf(1) (885-20*c)*sf(2) 60*sf(1) 20*sf(2)]);
    end
    
    if A.Fe_test ~= 0;
        SMAN.handles(c).h_MAT_Feratio =     uicontrol(SMAN.h_SMAN,'style','edit','Userdata',c,'Callback',MAT_Feratio,'string',UNK(c).MAT_Fe_ratio,'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','right','position',[680*sf(1) (885-20*c)*sf(2) 60*sf(1) 20*sf(2)]);
    end

    %create an 'APPLY' button to copy matrix correction settings to all
    %unknowns
    SMAN.handles(c).h_MATAPPLY2ALL =        uicontrol(SMAN.h_SMAN,'style','pushbutton','Callback','MATAPPLY2ALL','UserData',c,'string','Apply to All','position',[750*sf(1) (885-20*c)*sf(2) 70*sf(1) 20*sf(2)]);

    SMAN.handles(c).h_SIGconstraint1_popup = uicontrol(SMAN.h_SMAN,'style','popup','Userdata',c,'Callback','SIGSET','tag','h_SIGconstraint1_popup','string',{'internal standard';'wt% NaCl (mass)';'wt% NaCl (charge)';'total oxides (majors)'},'HorizontalAlignment','right','BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'position',[840*sf(1) (885-20*c)*sf(2) 120*sf(1) 20*sf(2)]);
    SMAN.handles(c).h_SIG1concis =  uicontrol(SMAN.h_SMAN,'style','edit','Userdata',c,'Callback','SIGINTSTD','string',UNK(c).SIGQIS1_conc,'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','right','position',[970*sf(1) (885-20*c)*sf(2) 60*sf(1) 20*sf(2)]);
    SMAN.handles(c).h_SIG1unit =     uicontrol(SMAN.h_SMAN,'style','popup','Userdata',c,'Callback','SIGUNIT','BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','left','string',{'ug/g';'wt.%'},'position',[1035*sf(1) (885-20*c)*sf(2) 50*sf(1) 20*sf(2)]);
    SMAN.handles(c).h_SIG1int =      uicontrol(SMAN.h_SMAN,'style','popup','Userdata',c,'Callback','SIGINTSTD','string',A.ISOTOPES_in_all_SRMs,'Value',UNK(c).SIGQIS1iso,'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','right','position',[1095*sf(1) (885-20*c)*sf(2) 60*sf(1) 20*sf(2)]);
    SMAN.handles(c).h_SIGsalt =     uicontrol(SMAN.h_SMAN,'style','edit','Userdata',c,'Callback',SIGSALT,'string',UNK(c).SIGsalinity,'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','right','position',[970*sf(1) (885-20*c)*sf(2) 60*sf(1) 20*sf(2)]);
    SMAN.handles(c).h_SALT_set_button =  uicontrol(SMAN.h_SMAN,'style','pushbutton','Userdata',c,'string','ELEMENTS','Callback','SALTSET','position',[1095*sf(1) (885-20*c)*sf(2) 60*sf(1) 20*sf(2)]);
    
    if A.Oxide_test ~= 0
        SMAN.handles(c).h_SIG1conciswt =uicontrol(SMAN.h_SMAN,'style','edit','Userdata',c,'Callback','SIGINTSTD','string',UNK(c).SIGQIS1_concwt,'BackgroundColor',[.9 .9 .9],'ForegroundColor',[0 0 0],'HorizontalAlignment','right','position',[970*sf(1) (885-20*c)*sf(2) 60*sf(1) 20*sf(2)]);
        SMAN.handles(c).h_SIG1intox =    uicontrol(SMAN.h_SMAN,'style','popup','Userdata',c,'Callback','SIGINTSTD','string',A.OXIDES_in_all_SRMs,'Value',UNK(c).SIGQIS1ox,'BackgroundColor',[.9 .9 .9],'ForegroundColor',[0 0 0],'HorizontalAlignment','right','position',[1095*sf(1) (885-20*c)*sf(2) 60*sf(1) 20*sf(2)]);
        SMAN.handles(c).h_SIGoxide =    uicontrol(SMAN.h_SMAN,'style','edit','Userdata',c,'Callback',SIGINTSTD_oxide,'string',UNK(c).SIG_oxide_total,'BackgroundColor',[0 0 0],'ForegroundColor',[1 1 1],'HorizontalAlignment','right','position',[970*sf(1) (885-20*c)*sf(2) 60*sf(1) 20*sf(2)]);
    end
    
    if A.Fe_test ~= 0;
        SMAN.handles(c).h_SIG_Feratio =     uicontrol(SMAN.h_SMAN,'style','edit','Userdata',c,'Callback',SIG_Feratio,'string',UNK(c).SIG_Fe_ratio,'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','right','position',[1095*sf(1) (885-20*c)*sf(2) 60*sf(1) 20*sf(2)]);
    end

    %create an 'APPLY' button to copy signal quantification settings to all
    %unknowns (only if there are no matrix corrections)
    SMAN.handles(c).h_SIGAPPLY2ALL =        uicontrol(SMAN.h_SMAN,'style','pushbutton','Callback','SIGAPPLY2ALL','UserData',c,'string','Apply to All','position',[1165*sf(1) (885-20*c)*sf(2) 70*sf(1) 20*sf(2)]);

    %create a signal quantification button to be shown when there are two
    SMAN.handles(c).h_SIGquantbutton =      uicontrol(SMAN.h_SMAN,'style','pushbutton','Userdata',c,'Callback','SIGQUANT_SETTINGS','string','DEFINE SAMPLE SETTINGS','HorizontalAlignment','center','position',[940*sf(1) (885-20*c)*sf(2) 200*sf(1) 20*sf(2)]);
    SMAN.handles(c).h_nosigwarning =        uicontrol(SMAN.h_SMAN,'style','text','string','No Signal','BackgroundColor',[.9 .9 1],'ForegroundColor',[0 0 0],'HorizontalAlignment','center','position',[940*sf(1) (880-20*c)*sf(2) 200*sf(1) 20*sf(2)]);

    % draw the matrix correction options if any matrix windows have been
    % selected
    if A.UNK_with_matrix_num > 0;
        set(SMAN.handles(c).h_MATtype,'string',{'none';'internal std';'total oxides'});
    else
        set(SMAN.handles(c).h_MATtype,'string','none');
        set(SMAN.handles(c).h_MATfile,'visible','off');
        set(SMAN.handles(c).h_MATint,'Visible','off');
        set(SMAN.handles(c).h_MATconc,'Visible','off');
        set(SMAN.handles(c).h_MATunit,'Visible','off');
        if A.Oxide_test ~= 0;
            set(SMAN.handles(c).h_MATintox,'Visible','off');
            set(SMAN.handles(c).h_MATconcwt,'Visible','off');
            set(SMAN.handles(c).h_MAToxide,'Visible','off');
        end        
        if A.Fe_test ~= 0;
            set(SMAN.handles(c).h_MAT_Feratio,'Visible','off');
        end
    end

    corrtype = UNK(c).MAT_corrtype;
    if corrtype == 1 %i.e. no matrix correction
        set(SMAN.handles(c).h_MATfile,'visible','off');
        set(SMAN.handles(c).h_MATint,'visible','off');
        set(SMAN.handles(c).h_MATconc,'visible','off');
        set(SMAN.handles(c).h_MATunit,'visible','off');
        if A.Oxide_test ~= 0;
            set(SMAN.handles(c).h_MATintox,'Visible','off');
            set(SMAN.handles(c).h_MATconcwt,'Visible','off');
            set(SMAN.handles(c).h_MAToxide,'Visible','off');
        end        
        if UNK(c).sigtotal > 0 %i.e. a signal window exists
            if UNK(c).SIG_constraint1 == 1 %i.e. internal standard
                set(SMAN.handles(c).h_SIGconstraint1_popup,'Visible','on','value',UNK(c).SIG_constraint1);
                if UNK(c).SIG1unit == 1 %i.e. ug/g
                    set(SMAN.handles(c).h_SIG1int,'Visible','on','value',UNK(c).SIGQIS1iso);
                    set(SMAN.handles(c).h_SIG1concis,'Visible','on','string',UNK(c).SIGQIS1_conc);
                    if A.Oxide_test ~= 0
                        set(SMAN.handles(c).h_SIG1intox,'Visible','off');
                        set(SMAN.handles(c).h_SIG1conciswt,'Visible','off');
                    end
                    set(SMAN.handles(c).h_SIG1unit,'visible','on','value',UNK(c).SIG1unit);
                elseif UNK(c).SIG1unit == 2 %i.e. wt.%
                    set(SMAN.handles(c).h_SIG1int,'Visible','off');
                    set(SMAN.handles(c).h_SIG1concis,'Visible','off');
                    if A.Oxide_test ~= 0
                        set(SMAN.handles(c).h_SIG1intox,'Visible','on','value',UNK(c).SIGQIS1ox);
                        set(SMAN.handles(c).h_SIG1conciswt,'Visible','on','string',UNK(c).SIGQIS1_concwt);
                    end
                    set(SMAN.handles(c).h_SIG1unit,'visible','on','value',UNK(c).SIG1unit);
                end
                set(SMAN.handles(c).h_SIGsalt,'Visible','off');
                set(SMAN.handles(c).h_SALT_set_button,'Visible','off');
                if A.Oxide_test ~= 0
                    set(SMAN.handles(c).h_SIGoxide,'Visible','off');
                end
                set(SMAN.handles(c).h_SIG1unit,'Visible','on');
                set(SMAN.handles(c).h_SIGAPPLY2ALL,'Visible','on');
                set(SMAN.handles(c).h_SIGquantbutton,'Visible','off');
                set(SMAN.handles(c).h_nosigwarning,'visible','off'); 
                if A.Fe_test ~= 0;
                    set(SMAN.handles(c).h_SIG_Feratio,'visible','off');
                end
            elseif UNK(c).SIG_constraint1 == 2 || UNK(c).SIG_constraint1 == 3 %i.e. salinity
                set(SMAN.handles(c).h_SIGconstraint1_popup,'Visible','on','value',UNK(c).SIG_constraint1);
                set(SMAN.handles(c).h_SIG1int,'Visible','off');
                set(SMAN.handles(c).h_SIG1concis,'Visible','off');
                set(SMAN.handles(c).h_SIGsalt,'Visible','on','string',UNK(c).SIGsalinity);
                set(SMAN.handles(c).h_SALT_set_button,'Visible','on');
                set(SMAN.handles(c).h_SIG1unit,'Visible','on','value',2);
                set(SMAN.handles(c).h_SIGAPPLY2ALL,'Visible','on');
                set(SMAN.handles(c).h_SIGquantbutton,'Visible','off');
                set(SMAN.handles(c).h_nosigwarning,'visible','off'); 
                if A.Oxide_test ~= 0
                    set(SMAN.handles(c).h_SIG1intox,'Visible','off');
                    set(SMAN.handles(c).h_SIG1conciswt,'Visible','off');
                    set(SMAN.handles(c).h_SIGoxide,'Visible','off');
                end
                if A.Fe_test ~= 0;
                    set(SMAN.handles(c).h_SIG_Feratio,'visible','off');
                end
            elseif UNK(c).SIG_constraint1 == 4 %i.e. total oxide
                set(SMAN.handles(c).h_SIGconstraint1_popup,'Visible','on','value',UNK(c).SIG_constraint1);
                set(SMAN.handles(c).h_SIG1int,'Visible','off');
                set(SMAN.handles(c).h_SIG1concis,'Visible','off');
                set(SMAN.handles(c).h_SIGsalt,'Visible','off');
                set(SMAN.handles(c).h_SALT_set_button,'Visible','off');
                set(SMAN.handles(c).h_SIG1unit,'Visible','on','value',2);
                set(SMAN.handles(c).h_SIGAPPLY2ALL,'Visible','on');
                set(SMAN.handles(c).h_SIGquantbutton,'Visible','off');
                set(SMAN.handles(c).h_nosigwarning,'visible','off'); 
                if A.Oxide_test ~= 0
                    set(SMAN.handles(c).h_SIG1intox,'Visible','off');
                    set(SMAN.handles(c).h_SIG1conciswt,'Visible','off');
                    set(SMAN.handles(c).h_SIGoxide,'Visible','on','string',UNK(c).SIG_oxide_total);
                end
                if A.Fe_test ~= 0;
                    set(SMAN.handles(c).h_SIG_Feratio,'visible','on','value',UNK(c).SIG_Fe_ratio);
                end
            end
        else
                set(SMAN.handles(c).h_SIGconstraint1_popup,'Visible','off');
                set(SMAN.handles(c).h_SIG1int,'Visible','off');
                set(SMAN.handles(c).h_SIG1concis,'Visible','off');
                set(SMAN.handles(c).h_SIGsalt,'Visible','off');
                set(SMAN.handles(c).h_SALT_set_button,'Visible','off');
                set(SMAN.handles(c).h_SIG1unit,'Visible','off');
                set(SMAN.handles(c).h_SIGAPPLY2ALL,'Visible','off');
                set(SMAN.handles(c).h_SIGquantbutton,'Visible','off');
                set(SMAN.handles(c).h_nosigwarning,'visible','on'); 
                if A.Oxide_test ~= 0
                    set(SMAN.handles(c).h_SIG1intox,'Visible','off');
                    set(SMAN.handles(c).h_SIG1conciswt,'Visible','off');
                    set(SMAN.handles(c).h_SIGoxide,'Visible','off');
                end
                if A.Fe_test ~= 0;
                    set(SMAN.handles(c).h_SIG_Feratio,'visible','off');
                end
        end
        if A.Fe_test ~= 0;
            set(SMAN.handles(c).h_MAT_Feratio,'visible','off');
        end

    elseif corrtype == 2 %internal standard
        set(SMAN.handles(c).h_MATfile,'visible','on');
        if UNK(c).MATunit == 1 %i.e. ug/g
            set(SMAN.handles(c).h_MATint,'visible','on');
            set(SMAN.handles(c).h_MATconc,'visible','on');
            if A.Oxide_test ~= 0
                set(SMAN.handles(c).h_MATintox,'visible','off');
                set(SMAN.handles(c).h_MATconcwt,'visible','off');
            end
        elseif UNK(c).MATunit == 2 %i.e. wt.%
            set(SMAN.handles(c).h_MATint,'visible','off');
            set(SMAN.handles(c).h_MATconc,'visible','off');
            if A.Oxide_test ~= 0
                set(SMAN.handles(c).h_MATintox,'visible','on');
                set(SMAN.handles(c).h_MATconcwt,'visible','on');
            end
        end
        if A.Oxide_test ~= 0
            set(SMAN.handles(c).h_MAToxide,'visible','off');
        end
        set(SMAN.handles(c).h_MATunit,'visible','on','value',UNK(c).MATunit);

        set(SMAN.handles(c).h_SIGconstraint1_popup,'Visible','off');
        set(SMAN.handles(c).h_SIG1int,'Visible','off');
        set(SMAN.handles(c).h_SIG1concis,'Visible','off');
        set(SMAN.handles(c).h_SIGsalt,'Visible','off');
        set(SMAN.handles(c).h_SALT_set_button,'Visible','off');
        set(SMAN.handles(c).h_SIG1unit,'Visible','off');
        set(SMAN.handles(c).h_SIGAPPLY2ALL,'Visible','off');
        if A.Oxide_test ~= 0
            set(SMAN.handles(c).h_SIG1intox,'Visible','off');
            set(SMAN.handles(c).h_SIG1conciswt,'Visible','off');
            set(SMAN.handles(c).h_SIGoxide,'Visible','off');
        end
        if UNK(c).sigtotal > 0
            set(SMAN.handles(c).h_SIGquantbutton,'Visible','on');
            set(SMAN.handles(c).h_nosigwarning,'visible','off'); 
        else
            set(SMAN.handles(c).h_SIGquantbutton,'Visible','off');
            set(SMAN.handles(c).h_nosigwarning,'visible','on');
        end
        if A.Fe_test ~= 0;
            set(SMAN.handles(c).h_MAT_Feratio,'visible','off');
            set(SMAN.handles(c).h_SIG_Feratio,'visible','off');
        end
    elseif corrtype ==3 %total oxides
        set(SMAN.handles(c).h_MATfile,'visible','on');
        set(SMAN.handles(c).h_MATint,'visible','off');
        set(SMAN.handles(c).h_MATconc,'visible','off');
        set(SMAN.handles(c).h_MATunit,'visible','on','value',2);

        set(SMAN.handles(c).h_SIGconstraint1_popup,'Visible','off');
        set(SMAN.handles(c).h_SIG1int,'Visible','off');
        set(SMAN.handles(c).h_SIG1concis,'Visible','off');
        set(SMAN.handles(c).h_SIGsalt,'Visible','off');
        set(SMAN.handles(c).h_SALT_set_button,'Visible','off');
        set(SMAN.handles(c).h_SIG1unit,'Visible','off');
        set(SMAN.handles(c).h_SIGAPPLY2ALL,'Visible','off');
        if A.Oxide_test ~= 0
            set(SMAN.handles(c).h_MATintox,'visible','off');
            set(SMAN.handles(c).h_MATconcwt,'visible','off');
            set(SMAN.handles(c).h_MAToxide,'visible','on');
            set(SMAN.handles(c).h_SIG1intox,'Visible','off');
            set(SMAN.handles(c).h_SIG1conciswt,'Visible','off');
            set(SMAN.handles(c).h_SIGoxide,'Visible','off');
        end
        if UNK(c).sigtotal > 0
            set(SMAN.handles(c).h_SIGquantbutton,'Visible','on');
            set(SMAN.handles(c).h_nosigwarning,'visible','off'); 
        else
            set(SMAN.handles(c).h_SIGquantbutton,'Visible','off');
            set(SMAN.handles(c).h_nosigwarning,'visible','on');
        end
        if A.Fe_test ~= 0;
            set(SMAN.handles(c).h_MAT_Feratio,'visible','on');
            set(SMAN.handles(c).h_SIG_Feratio,'visible','off');
        end
    end
    clear corrtype


    %create copy and delete options for each unknown
    SMAN.handles(c).h_PLOT =               uicontrol(SMAN.h_SMAN,'style','pushbutton','Callback','UNKPLOT','UserData',c,'string','Plot','position',[1255*sf(1) (885-20*c)*sf(2) 35*sf(1) 20*sf(2)]);
    SMAN.handles(c).h_COPY =               uicontrol(SMAN.h_SMAN,'style','pushbutton','Callback','UNKCOPY','UserData',c,'string','Copy','position',[1295*sf(1) (885-20*c)*sf(2) 35*sf(1) 20*sf(2)]);
    SMAN.handles(c).h_DELETE =             uicontrol(SMAN.h_SMAN,'style','pushbutton','Callback','UNKDELETE2','UserData',c,'string','Delete','position',[1335*sf(1) (885-20*c)*sf(2) 40*sf(1) 20*sf(2)]);
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DONE!

clear oxide_seek num b c d e f x ans

if A.cpsonly == 1 %Added in 1.0.3
    CPSONLY;
end