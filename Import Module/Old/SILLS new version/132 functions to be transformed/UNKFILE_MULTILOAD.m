%%%%%%%%% UNKFILE_MULTILOAD %%%%%%%%%%%%
%
%This script loads multiple unknowns at once, but does not open any figure
%Copied from UNKFILE_LOAD, with minor adaptions
%
%Added in 1.0.6

unkfilenum = length(A.unkfile);

for i = 1:unkfilenum

    A.unkfullfilename = strcat(A.sillspath,A.unkfile(i));
    A.unkfullfilename = char(A.unkfullfilename);
    [te1,te2,ext1]=fileparts(A.unkfullfilename);
    clear te1 te2
    if strcmp(ext1,'.FIN2')
        UNKIMP = importdata(A.unkfullfilename,',',8); %Import Glitter output from Element XR
        dateFIN1 = importdata(A.unkfullfilename);
        dateFIN2 = dateFIN1.textdata(2,1);
        dateFIN = dateFIN2{1};
        clear dateFIN1 dateFIN2
    elseif strcmp(ext1,'.TXT')  %Imports TXT-files form the Element XR
        convert;
    else    
        UNKIMP = importdata(A.unkfullfilename);
    end
    
    %Remove zero entries after last time step
    %Added in 1.0.5 changed in 1.1.1
    times = UNKIMP.data(:,1);
    searchdestroy = find(times==0);
    if ~isempty(searchdestroy)
        searchdestroy(1) = [];
        UNKIMP.data(searchdestroy,:) = [];
    end
    clear times searchdestroy

    if A.d > 0 %if there is one or more standards already in the STD array

        %test for unmatching element lists between this unknown and previously
        %loaded standards

        UNKIMP_num = size(UNKIMP.colheaders(2:end));
        UNKIMP_num = UNKIMP_num(2);

        A.STD_num = size(STD);
        A.STD_num = A.STD_num(1);

        if STD(A.STD_num,1).num_elements ~= UNKIMP_num; %if there are a different number of elements
            msgbox('Element lists do not match. Please load a new file.','SILLS Error Message','error');
            return
        else
            temp = strcmp(STD(A.STD_num,1).colheaders(2:end),UNKIMP.colheaders(2:end)); %compare the new element list with the one originally read
            if sum(temp) < STD(A.STD_num).num_elements
                msgbox('Element lists do not match. Please load a new file.','SILLS Error Message','error');
                clear temp
                return
            end
            clear temp
        end
    end


    if A.k < 0 %i.e. if there are already one or more unknowns in the UNK array (remember k counts in the negative direction)

        %test for unmatching element lists between this standard and ones loaded
        %previously

        UNKIMP_num = size(UNKIMP.colheaders(2:end));
        UNKIMP_num = UNKIMP_num(2);

        A.UNK_num = size(UNK);
        A.UNK_num = A.UNK_num(1);

        if UNK(A.UNK_num,1).num_elements ~= UNKIMP_num;
            msgbox('Element lists do not match. Please load a new standard file.','SILLS Error Message','error');
            return
        else
            temp = strcmp(UNK(A.UNK_num,1).colheaders(2:end),UNKIMP.colheaders(2:end)); %compare the new element list with the one originally read
            if sum(temp) < UNK(A.UNK_num).num_elements
                msgbox('Element lists do not match! Please load a new standard file.','SILLS Error Message','error');
                clear temp
                return
            end
            clear temp
        end

        % populate UNK(UNK_num), i.e. the most recent unknown
        UNK(A.UNK_num + 1,1).data = UNKIMP.data;
        UNK(A.UNK_num + 1,1).textdata = UNKIMP.textdata;
        UNK(A.UNK_num + 1,1).colheaders = UNKIMP.colheaders;
        UNK(A.UNK_num + 1,1).fileinfo = dir(A.unkfullfilename);
        UNK(A.UNK_num + 1,1).num_elements = size(UNK(A.UNK_num,1).colheaders(2:end));
        UNK(A.UNK_num + 1,1).num_elements = UNK(A.UNK_num + 1,1).num_elements(2);
        UNK(A.UNK_num + 1,1).bgwindow = [];
        UNK(A.UNK_num + 1,1).mat1window = [];
        UNK(A.UNK_num + 1,1).mat2window = [];
        UNK(A.UNK_num + 1,1).mattotal = [];
        UNK(A.UNK_num + 1,1).comp1window = [];
        UNK(A.UNK_num + 1,1).comp2window = [];
        UNK(A.UNK_num + 1,1).comp3window = [];
        UNK(A.UNK_num + 1,1).sigtotal = [];
        UNK(A.UNK_num + 1,1).MAT_corrtype = 1;
        UNK(A.UNK_num + 1,1).MATcorrfile = A.UNK_num+1;
        UNK(A.UNK_num + 1,1).MATQIS = 1;
        UNK(A.UNK_num + 1,1).MATQISiso = 1;
        UNK(A.UNK_num + 1,1).MATQISox = 1;
        UNK(A.UNK_num + 1,1).MATunit = 1;
        UNK(A.UNK_num + 1,1).SIG_quanttype = 1;
        UNK(A.UNK_num + 1,1).SIGQIS = 1;
        UNK(A.UNK_num + 1,1).timepoint = 1;
        UNK(A.UNK_num + 1,1).SALT = zeros(A.ELEMENT_num,1); %whether isotopes are included in a salt correction or not
        UNK(A.UNK_num + 1,1).SALT_mass_balance_factor = 0.5; %Added in 1.0.6
        UNK(A.UNK_num +1,1).Info = [];
        UNK(A.UNK_num +1,1).SIG_constraint1 = 1;
        UNK(A.UNK_num +1,1).SIG_constraint2 = 1;
        UNK(A.UNK_num +1,1).SIGQIS1 = UNK(A.UNK_num,1).SIGQIS1;
        UNK(A.UNK_num +1,1).SIGQIS1iso = UNK(A.UNK_num,1).SIGQIS1iso;
        UNK(A.UNK_num +1,1).SIGQIS1ox = UNK(A.UNK_num,1).SIGQIS1ox;
        UNK(A.UNK_num +1,1).SIG1unit = UNK(A.UNK_num,1).SIG1unit;
        UNK(A.UNK_num +1,1).SIGQIS2 = UNK(A.UNK_num,1).SIGQIS2;
        UNK(A.UNK_num +1,1).SIGQIS2iso = UNK(A.UNK_num,1).SIGQIS2iso;
        UNK(A.UNK_num +1,1).SIGQIS2ox = UNK(A.UNK_num,1).SIGQIS2ox;
        UNK(A.UNK_num +1,1).SIG2unit = UNK(A.UNK_num,1).SIG2unit;
        UNK(A.UNK_num +1,1).SIG_tracer = 1;
        UNK(A.UNK_num +1,1).fileinfo.ext = ext1;
        if strcmp(ext1,'.FIN2')
             UNK(A.UNK_num +1,1).fileinfo.date = dateFIN; 
        end

        A.k = A.k - 1; %advance the counter for the number of unknowns opened (irrespective of number deleted); remember this counts in the neg. direction
        UNK(A.UNK_num + 1,1).order_opened = A.k; %remember that k is a negative number

        UNK(A.UNK_num + 1,1).figure_state = 'shut';
        UNK(A.UNK_num + 1,1).spikestatus = 'undone';
        A.UNK_num = size(UNK);
        A.UNK_num = A.UNK_num(1);
        A.UNKPOPUPLIST(A.UNK_num,1) = {UNK(A.UNK_num,1).fileinfo.name};

    elseif A.k == 0 %i.e. first time an unknown has been loaded

        % populate UNK(1)
        UNK(1).data = UNKIMP.data;
        UNK(1).textdata = UNKIMP.textdata;
        UNK(1).colheaders = UNKIMP.colheaders;
        UNK(1).fileinfo = dir(A.unkfullfilename);
        UNK(1).num_elements = size(UNK(1).colheaders(2:end));
        UNK(1).num_elements = UNK(1).num_elements(2);
        UNK(1).bgwindow = [];
        UNK(1).mat1window = [];
        UNK(1).mat2window = [];
        UNK(1).mattotal = [];
        UNK(1).comp1window = [];
        UNK(1).comp2window = [];
        UNK(1).comp3window = [];
        UNK(1).sigtotal = [];
        UNK(1).MAT_corrtype = 1;
        UNK(1).MATcorrfile = 1;
        UNK(1).MATQIS = 1;
        UNK(1).MATQISiso = 1;
        UNK(1).MATQISox = 1;

        UNK(1).Info = [];

        UNK(1).SIG_constraint1 = 1;
        UNK(1).SIG_constraint2 = 1;

        UNK(1).SIGQIS1 = 1;
        UNK(1).SIGQIS1iso = 1;
        UNK(1).SIGQIS1ox = 1;
        UNK(1).SIG1unit = 1;
        UNK(1).SIGQIS2 = 1;
        UNK(1).SIGQIS2iso = 1;
        UNK(1).SIGQIS2ox = 1;
        UNK(1).SIG2unit = 1;
        UNK(1).timepoint = 1;

        UNK(1).SIG_tracer = 1;
        UNK(1).fileinfo.ext = ext1;
        if strcmp(ext1,'.FIN2')
            UNK(1).fileinfo.date = dateFIN; 
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %clear these in case former standards or unknowns were loaded that had
        %a different isotope list
        A.ISOTOPE_list = {};
        A.DT_VALUES = [];
        A.ELEMENT_list = {};

        A.ISOTOPE_list = UNK(1).colheaders(2:end);
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

        UNK(1).SALT = zeros(A.ELEMENT_num,1); %whether isotopes are included in a salt correction or not
        UNK(1).SALT_mass_balance_factor = 0.5; %Added in 1.0.6


        A.k = -1;   %counter for the number of unknowns opened (irrespective of number deleted)
        %This counter goes in the negative direction, in order to distinguish it from the standards
        A.K = 0;    %number of open UNK windows

        UNK(1).order_opened = A.k;
        UNK(1).figure_state = 'shut';
        UNK(1).spikestatus = 'undone';

        A.UNK_num = 1; %total number of unknowns
        A.UNKPOPUPLIST(1,1) = {UNK(1).fileinfo.name};

        %SILLSFIG_UPDATE
    end
end

A.KC = A.UNK_num; %by default the current unknown is the last one loaded

A.UNKfigs_open = {UNK.figure_state};
A.UNKfigs_open = strcmp(A.UNKfigs_open,'open');

UNKRESETX = ['if strcmp(get(gca,''tag''),''UNK.handles.h_unkplot'');'...
                 'set(gca,''XLim'',UNK(A.KC).XLim_orig,''YLim'',UNK(A.KC).YLim_orig);end;'];

clear unkfilenum i UNKIMP UNKIMP_num ext1

set(SCP.handles.h_currentUNK_popup,'string',A.UNKPOPUPLIST,'value',A.UNK_num);
SILLSFIG_UPDATE

figure(SCP.handles.h_fig);