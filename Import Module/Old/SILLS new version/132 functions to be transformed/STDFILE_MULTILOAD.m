%%%%%%%%% STDFILE_MULTILOAD %%%%%%%%%%%%
%
%This script loads multiple unknowns at once, but does not open any figure
%Copied from STDFILE_LOAD, with minor adaptions
%
%Added in 1.0.6

stdfilenum = length(A.stdfile);

for i = 1:stdfilenum

    A.stdfullfilename = strcat(A.sillspath,A.stdfile(i));
    A.stdfullfilename = char(A.stdfullfilename);
    [te1,te2,ext1]=fileparts(A.stdfullfilename);
    clear te1 te2
    if strcmp(ext1,'.FIN2')
        STDIMP = importdata(A.stdfullfilename,',',8);%Imports Glitter output from Element XR
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
        STD(A.STD_num + 1,1).fileinfo.ext = ext1;
        if strcmp(ext1,'.FIN2')
            STD(A.STD_num +1,1).fileinfo.date = dateFIN; 
        end

        A.MC = get(SCP.handles.h_currentSTD_SRM_out,'value');
        STD(A.STD_num + 1,1).SRM = A.MC;

        A.d = A.d + 1; %advance the counter for the number of standards opened (irrespective of number deleted)
        STD(A.STD_num + 1,1).order_opened = A.d;

        STD(A.STD_num + 1,1).figure_state = 'shut';
        STD(A.STD_num + 1,1).spikestatus = 'undone';
        A.STD_num = size(STD);
        A.STD_num = A.STD_num(1);
        A.STDPOPUPLIST(A.STD_num,1) = {STD(A.STD_num,1).fileinfo.name};

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
        A.D = 0; %number of open STD windows

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %clear these in case former standards or unknowns were loaded that had
        %a different isotope list
        A.ISOTOPE_list = {};
        A.DT_VALUES = [];
        A.ELEMENT_list = {};

        A.ISOTOPE_list = STD(1).colheaders(2:end);
        A.ISOTOPE_num = size(A.ISOTOPE_list);
        A.ISOTOPE_num = A.ISOTOPE_num(2);
        A.DT_VALUES = 0.01 * ones(A.ISOTOPE_num,1);

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
        STD(1).figure_state = 'shut';
        STD(1).spikestatus = 'undone';

        A.STD_num = 1; %total number of standards
        A.STDPOPUPLIST(1,1) = {STD(1).fileinfo.name};

        A.D = 0; %number of open STD windows
    end
end

A.DC = A.STD_num; %by default the current unknown is the last one loaded

A.STDfigs_open = {STD.figure_state};
A.STDfigs_open = strcmp(A.STDfigs_open,'open');

STDRESETX = ['if strcmp(get(gca,''tag''),''STD.handles.h_stdplot'');'...
                 'set(gca,''XLim'',STD(A.DC).XLim_orig,''YLim'',STD(A.DC).YLim_orig);'...
             'end'];

clear stdfilenum i STDIMP STDIMP_num ext1

set(SCP.handles.h_currentSTD_popup,'string',A.STDPOPUPLIST,'value',A.STD_num);
SILLSFIG_UPDATE

figure(SCP.handles.h_fig);






