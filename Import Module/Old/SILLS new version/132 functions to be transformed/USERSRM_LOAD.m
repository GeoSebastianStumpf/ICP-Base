% USERSRM_LOAD.m 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script allows the user to browse for an existing
% SRM datafile and load it into the SILLS session.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% use uigetfile command to browse for the SRM file
[A.userSRMfile,A.userSRMpathname] = uigetfile('*.xls','Browse for SRM composition file',100*sf(1),100*sf(2));
A.SRMcheck = strcmp(A.SRMPOPUPLIST,A.userSRMfile);

if sum(A.SRMcheck)~=0
    warndlg('This SRM is already in the list.','SILLS Warning');
    return
else
    % create a name for the file from its file path
    A.USERSRMFILE = [A.userSRMpathname A.userSRMfile];
    if A.USERSRMFILE == 0 % i.e. if the window was cancelled
        figure(SCP.handles.h_fig); % make SILLS Control Panel the current figure
        return % and quit the USERSRM_LOAD.m routine
    else
        %now update the popuplist of SRM items
        A.SRMPOPUPLIST = vertcat(A.SRMPOPUPLIST,A.userSRMfile);
        set(SCP.handles.h_currentSTD_SRM_out,'string',A.SRMPOPUPLIST); % update the SRM list in the popup window
        set(SCP.handles.h_currentSRM_popup,'string',A.SRMPOPUPLIST);
        
        A.SRM_num = A.SRM_num + 1; % a new SRM added
                        
        B = importdata([pwd '/SRM Files/' A.userSRMfile]); %Changed in 1.0.4
        SRM(A.SRM_num,1).data = B.data;
        SRM(A.SRM_num,1).textdata = B.textdata;
        SRM(A.SRM_num,1).rowheaders = B.rowheaders;
        SRM(A.SRM_num,1).fileinfo = dir(fullfile(pwd,['/SRM Files/' A.userSRMfile])); %Changed in 1.0.4
        SRM(A.SRM_num,1).name = SRM(A.SRM_num,1).fileinfo.name;
        clear B
    end
end

