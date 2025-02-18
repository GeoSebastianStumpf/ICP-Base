%%%%%%%% STDDELETE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This is called everytime either a standard plot is closed, or a
% standard is deleted from the popup list.

if A.STD_num == 0 || isempty(A.STD_num);
    return;
else
    delcall = get(gcf,'tag');
    if strcmp(delcall,'SILLS Control Panel')==0;
        currentfig = get(gcf,'UserData');
        stdtags = [STD.order_opened];
        A.DC = find(stdtags == currentfig);
        STD(A.DC).figure_state = 'shut';
        delete(STD(A.DC).handles.h_stdfig);
        A.STDfigs_open = {STD.figure_state};
        A.STDfigs_open = strcmp(A.STDfigs_open,'open');
        A.D = A.D-1;
        A.DC = get(SCP.handles.h_currentSTD_popup,'Value');
    else
        if A.DC > 0;
            delquery = questdlg('Are you sure you want to delete this standard?','SILLS Query','Yes','No','Yes');
            if strcmp(delquery,'Yes');
                if strcmp(STD(A.DC).figure_state,'open') == 1;
                    delete(STD(A.DC).handles.h_stdfig);
                    A.D = A.D-1;
                    if A.D == 0;
                        A.d = 0;
                    end;
                end;

%                 A.STD_num = size(STD,1); %Added in 1.0.6
                
                STD(A.DC) = []; %delete that element of the STD structure array
                A.STDPOPUPLIST(A.DC) = [];

                if A.DC == A.STD_num;   %i.e. if the current standard was the last in the list
                    A.DC = A.DC - 1;    %reduce the count by one
                end;                    %otherwise it can stay the same

                A.STD_num = size(STD,2);  %get the new STD dimensions

                if A.STD_num == 0  %i.e. an empty structure array
                    set(SCP.handles.h_currentSTD_popup,'string','< load a standard >');
                    clear STD;
                    STD = struct('data',[],'textdata',[],'colheaders',[],'fileinfo',[],'num_elements',[],'SRM_num',[],'SRM',[],'bgwindow',[],'sigwindow',[],'order_opened',[],'figure_state',[],'XLim_orig',[],'YLim_orig',[],'YLim_orig_element',[],'handles',[]);
                    STD.handles = struct('h_stdfig',[],'h_std_delete_button',[],'h_std_resetx_button',[],'h_stdline_toggle',[],'h_toggle_all',[],'h_toggle_none',[],'radiogroup',[],'radio_std1',[],'radio_std2',[],'radio_std3',[],'radio_std4',[],'h_std_from_text',[],'h_std_to_text',[],'h_std_total_text',[],'h_std_graphic_text',[],'h_std_manual_text',[],'h_stdbg_userfrom',[],'h_stdsig_userfrom',[],'h_stdbg_userto',[],'h_stdsig_userto',[],'h_bgpatch',[],'h_sigpatch',[]);
%                   A.STD_num = 0;
%                   set(SCP.handles.h_std_delete_button,'Callback',[]);
                    set(SCP.handles.h_currentSTD_SRM_out,'value',1,'Visible','off');
                    A.MC = 1; %reset to NIST_610.xls
                    A.DC = 0;
                    A.d = 0;
                else
                    A.STD_num = size(STD,1); %Changed in 1.0.6
                    set(SCP.handles.h_currentSTD_popup,'string',A.STDPOPUPLIST,'value',A.DC);
                    A.MC = STD(A.DC).SRM;
                    set(SCP.handles.h_currentSTD_SRM_out,'value',A.MC);
                end

                clear A.STDfigs_open
                A.STDfigs_open = {STD.figure_state};
                A.STDfigs_open = strcmp(A.STDfigs_open,'open');
                SILLSFIG_UPDATE;
            end
        end
    end
end

clear stdtags delcall currentfig