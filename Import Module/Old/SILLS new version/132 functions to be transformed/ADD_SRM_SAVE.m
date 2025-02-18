
%%%%%%%%%% ADD_SRM_SAVE.m %%%%%%%%%%%%%%%%%%%%%%
% Save the user-defined SRM composition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% gather the user-defined concentrations, convert the user input string to 
% a numerical value using the 'str2num' command.  Then, convert the user-defined 
% concentrations into a column of numerical values ('addlist').

ADDSRM.addlist = zeros(ADDSRM.element_library_size,1);

for c = 1:ADDSRM.element_library_size   
    a = get(ADDSRM.handles.h_element_conc(c),'string');
    b = str2num(a);
    if isempty(b);
        b = 0;
    end
    ADDSRM.addlist(c) = b;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now, create a condensed list of elements and concentrations

ADDSRM.srm_row_index = find(ADDSRM.addlist);
ADDSRM.srm_num = size(ADDSRM.srm_row_index); %srm_num = number of user-defined concentrations
ADDSRM.srm_selected_list = cell(ADDSRM.srm_num(1),1);

for c = 1:ADDSRM.srm_num(1);
    a = ADDSRM.srm_row_index(c);
        ADDSRM.srm_selected_list(c,1) = ADDSRM.srm_elements(a);
        ADDSRM.addlist_condensed(c,1) = num2cell(ADDSRM.addlist(ADDSRM.srm_row_index(c,1)));
end

ADDSRM.srm_output_table = [ADDSRM.srm_selected_list ADDSRM.addlist_condensed];

% clear temporary variables
clear a
clear b
clear c
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% prompt user for new SRM file name
[ADDSRM.srmfile,ADDSRM.srmpath] = uiputfile([pwd '/SRM FILES/*.xls'],'Create File Name for New SRM'); %Changed in 1.0.4
ADDSRM.ADDsrmFILE = [ADDSRM.srmpath ADDSRM.srmfile];
xlswrite(ADDSRM.ADDsrmFILE,ADDSRM.srm_output_table); % create an Excel file with SRM data
close(gcf); % close the figure

figure(SCP.handles.h_fig); % reactivate SILLS Control Panel

%now update the popuplist of SRM items
A.SRMPOPUPLIST = vertcat(A.SRMPOPUPLIST,ADDSRM.srmfile);
set(SCP.handles.h_currentSTD_SRM_out,'string',A.SRMPOPUPLIST);
set(SCP.handles.h_currentSRM_popup,'string',A.SRMPOPUPLIST);
