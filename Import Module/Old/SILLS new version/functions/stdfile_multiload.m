%             searchandreplace_NewGUIFigureHandle=uifigure
% STD -> app.STD ... and all the others i already did A-> app.A.
% SCP.handles. > app. this should make all the buttonsand visibility  work 

% canged   %old convert_std; to new      convert_std_NG(app)        
% to do check convert.m
function stdfile_multiload(app)
for i = 1:length(app.A.stdfile)

    app.A.stdfullfilename = strcat(app.A.sillspath,app.A.stdfile(i));
    app.A.stdfullfilename = char(app.A.stdfullfilename);
    [~,~,ext1]=fileparts(app.A.stdfullfilename);

    if strcmp(ext1,'.FIN2')
        STDIMP = importdata(app.A.stdfullfilename,',',8);%Imports Glitter output from Element XR
        dateFIN1 = importdata(app.A.stdfullfilename);
        dateFIN2 = dateFIN1.textdata(2,1);
        dateFIN = dateFIN2{1};
    elseif strcmp(ext1,'.TXT')  %Imports TXT-files form the Element XR
        STDIMP=convert_NG(app.A.stdfullfilename);        %old convert_std;
    else
        STDIMP = importdata(app.A.stdfullfilename);
    end

    %Remove zero entries after last time step
        STDIMP.data(STDIMP.data(:,1)==0,:) = []; %NEW
        %% OLD BLOCK 
%     times = STDIMP.data(:,1);
%     searchdestroy = find(times==0);
%     if ~isempty(searchdestroy)
%         searchdestroy(1) = [];
%         STDIMP.data(times==0,:) = [];
%     end
%%

%% @S are these variables needed in the data structure?
    if app.A.k > 0 %if there is one or more unknowns already in the UNK array

        STDIMP_num = size(STDIMP.colheaders(2:end));
        STDIMP_num = STDIMP_num(2);

        app.A.UNK_num = size(UNK);
        app.A.UNK_num = app.A.UNK_num(1);

        if UNK(app.A.UNK_num,1).num_elements ~= STDIMP_num || sum(strcmp(UNK(app.A.UNK_num,1).colheaders(2:end),STDIMP.colheaders(2:end))) < UNK(app.A.UNK_num).num_elements %if there are a different number of elements
             error_message='Element lists do not match. Please load a new standard file.';
            uialert(searchandreplace_NewGUIFigureHandle,error_message,'SILLS Error Message');
            return
        end
    end

    if app.A.d > 0 %if there is one or more standards already in the STD array

        %test for unmatching element lists between this standard and ones loaded
        %previously

        STDIMP_num = size(STDIMP.colheaders(2:end));
        STDIMP_num = STDIMP_num(2);

        app.A.STD_num = size(STD);
        app.A.STD_num = app.A.STD_num(1);

        if STD(app.A.STD_num,1).num_elements ~= STDIMP_num || sum(strcmp(STD(app.A.STD_num,1).colheaders(2:end),STDIMP.colheaders(2:end))) < STD(app.A.STD_num).num_elements
            %if there are a different number of elements
            error_message='Element lists do not match. Please load a new standard file.';
            uialert(searchandreplace_NewGUIFigureHandle,error_message,'SILLS Error Message');
            return
        end

        % populate STD(STD_num), i.e. the most recent standard
        STD(app.A.STD_num + 1,1).data = STDIMP.data;
        STD(app.A.STD_num + 1,1).textdata = STDIMP.textdata;
        STD(app.A.STD_num + 1,1).colheaders = STDIMP.colheaders;
        STD(app.A.STD_num + 1,1).fileinfo = dir(app.A.stdfullfilename);
        STD(app.A.STD_num + 1,1).num_elements = size(STD(app.A.STD_num,1).colheaders(2:end));
        STD(app.A.STD_num + 1,1).num_elements = STD(app.A.STD_num + 1,1).num_elements(2);
        STD(app.A.STD_num + 1,1).bgwindow = [];
        STD(app.A.STD_num + 1,1).sigwindow = [];
        STD(app.A.STD_num + 1,1).timepoint = 1;
        STD(app.A.STD_num + 1,1).fileinfo.ext = ext1;
        if strcmp(ext1,'.FIN2')
            STD(app.A.STD_num +1,1).fileinfo.date = dateFIN; 
        end

        app.A.MC = get(SCP.handles.h_currentSTD_SRM_out,'value');
        STD(app.A.STD_num + 1,1).SRM = app.A.MC;

        app.A.d = app.A.d + 1; %advance the counter for the number of standards opened (irrespective of number deleted)
        STD(app.A.STD_num + 1,1).order_opened = app.A.d;

        STD(app.A.STD_num + 1,1).figure_state = 'shut';
        STD(app.A.STD_num + 1,1).spikestatus = 'undone';
        app.A.STD_num = size(STD);
        app.A.STD_num = app.A.STD_num(1);
        app.A.STDPOPUPLIST(app.A.STD_num,1) = {STD(app.A.STD_num,1).fileinfo.name};

    elseif app.A.d == 0 %i.e. first time a standard has been loaded

        % populate STD(1)
        STD(1).data = STDIMP.data;
        STD(1).textdata = STDIMP.textdata;
        STD(1).colheaders = STDIMP.colheaders;
        STD(1).fileinfo = dir(app.A.stdfullfilename);
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

        if strcmp(app.A.timeformat,'hhmm')==1
            set(SCP.handles.h_currentSTD_driftpoints_popup,'Visible','off');
            set(SCP.handles.h_currentSTD_drifthh_edit,'Visible','on');
            set(SCP.handles.h_currentSTD_driftcolon,'Visible','on');
            set(SCP.handles.h_currentSTD_driftmm_edit,'Visible','on');
        elseif strcmp(app.A.timeformat,'integer_points')==1
            set(SCP.handles.h_currentSTD_driftpoints_popup,'Visible','on');
            set(SCP.handles.h_currentSTD_drifthh_edit,'Visible','off');
            set(SCP.handles.h_currentSTD_driftcolon,'Visible','off');
            set(SCP.handles.h_currentSTD_driftmm_edit,'Visible','off');
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        app.A.d = 1; %counter for the number of standards opened (irrespective of number deleted)
        app.A.D = 0; %number of open STD windows

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %clear these in case former standards or unknowns were loaded that had
        %a different isotope list
        app.A.ISOTOPE_list = {};
        app.A.DT_VALUES = [];
        app.A.ELEMENT_list = {};

        app.A.ISOTOPE_list = STD(1).colheaders(2:end);
        app.A.ISOTOPE_num = size(app.A.ISOTOPE_list);
        app.A.ISOTOPE_num = app.A.ISOTOPE_num(2);
        app.A.DT_VALUES = 0.01 * ones(app.A.ISOTOPE_num,1);

        %create a list of elements analysed

        isotope = char(app.A.ISOTOPE_list); %convert isotopes into a character array
        iselement = isletter(isotope);  %search for letters within the 'isotope' array
        element = iselement.*isotope;
        element2 = char(element);
        for c = 1:app.A.ISOTOPE_num;
            app.A.ELEMENT_list(c) = {element2(c,:)};
        end
        app.A.ELEMENT_list = deblank(app.A.ELEMENT_list);
        app.A.ELEMENT_num = size(app.A.ELEMENT_list);
        app.A.ELEMENT_num = app.A.ELEMENT_num(2);
        clear isotope iselement element element2
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        STD(1).order_opened = app.A.d;
        STD(1).figure_state = 'shut';
        STD(1).spikestatus = 'undone';

        app.A.STD_num = 1; %total number of standards
        app.A.STDPOPUPLIST(1,1) = {STD(1).fileinfo.name};

        app.A.D = 0; %number of open STD windows
    end
end

app.A.DC = app.A.STD_num; %by default the current unknown is the last one loaded

%% old @S i think this is the figure popup which plots unknowns and can go
% app.A.STDfigs_open = {STD.figure_state};
% app.A.STDfigs_open = strcmp(app.A.STDfigs_open,'open');
% 
% STDRESETX = ['if strcmp(get(gca,''tag''),''STD.handles.h_stdplot'');'...
%                  'set(gca,''XLim'',STD(app.A.DC).XLim_orig,''YLim'',STD(app.A.DC).YLim_orig);'...
%              'end'];
% 
% 
% set(SCP.handles.h_currentSTD_popup,'string',app.A.STDPOPUPLIST,'value',app.A.STD_num);
% SILLSFIG_UPDATE

end



