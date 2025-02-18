%UNKDELETE

if A.UNK_num == 0 || isempty(A.UNK_num);
    return;
else
    delcall = get(gcf,'tag');

    if strcmp(delcall,'SILLS Control Panel')==0; %i.e. an Unknown

        currentfig = get(gcf,'UserData');
        unktags = [UNK.order_opened];
        A.KC = find(unktags == currentfig);
        UNK(A.KC).figure_state = 'shut';

        delete(UNK(A.KC).handles.h_unkfig); %close the figure

        A.UNKfigs_open = {UNK.figure_state};
        A.UNKfigs_open = strcmp(A.UNKfigs_open,'open');

        A.K = A.K-1; %reduce the number open by 1

        A.KC = get(SCP.handles.h_currentUNK_popup,'Value');

    else

        if A.KC > 0; %i.e. there are unknowns loaded

            delquery = questdlg('Are you sure you want to delete this unknown?','SILLS Query','Yes','No','Yes');
            if strcmp(delquery,'Yes');

                searchdestroy = find(A.UNK_with_matrix_index == A.KC);
                if ~isempty(searchdestroy);
                    A.UNK_with_matrix_num = size(A.UNK_with_matrix);
                    A.UNK_with_matrix_num = A.UNK_with_matrix_num(1);
                    A.UNK_with_matrix(searchdestroy) = [];
                    A.UNK_with_matrix_index(searchdestroy) = [];
                    for c=1:A.UNK_num;
                        if ~isempty(UNK(c).MATcorrfile_index) && UNK(c).MATcorrfile_index == A.UNK_with_matrix_num; %i.e. the last in the list
                            i = A.UNK_with_matrix_num-1;
                            UNK(c).MATcorrfile_index = i;
                            UNK(c).MATcorrfile = A.UNK_with_matrix_index(i);
                            clear i
                        end;
                    end;
                end;
                clear searchdestroy

                if strcmp(UNK(A.KC).figure_state,'open') == 1
                    delete(UNK(A.KC).handles.h_unkfig);
                    A.K = A.K-1;
                    if A.K == 0;
                        A.k = 0;
                    end;
                end;

                UNK(A.KC) = []; %delete that element of the UNK structure array
                A.UNKPOPUPLIST(A.KC) = [];

                if A.KC == A.UNK_num;   %i.e. if the current unknown was the last in the list
                    A.KC = A.KC - 1;    %reduce the count by one
                end;                    %otherwise it can stay the same

                A.UNK_num = size(UNK,2);  %get the new UNK dimensions

                if A.UNK_num == 0  %i.e. an empty structure array
                    set(SCP.handles.h_currentUNK_popup,'string','< load a unknown >');
                    clear UNK;
                    UNK = struct('data',[],'textdata',[],'colheaders',[],'fileinfo',[],'num_elements',[],'SRM_num',[],'SRM',[],'bgwindow',[],'comp1window',[],'comp2window',[],'comp3window',[],'sigtotal',[],'order_opened',[],'figure_state',[],'XLim_orig',[],'YLim_orig',[],'YLim_orig_element',[],'handles',[],'MAT_corrtype',[],'MATcorrfile',[],'MATintunk',[],'MATintunk_concinmatrix',[],'MATintunk_concinanalyte',[],'SIG_quanttype',[],'SIGintunk',[],'SIGintunk_conc',[],'salinity',[],'SIGquant_elements',[]);
                    UNK.handles = struct('h_unkfig',[],'h_unk_delete_button',[],'h_unk_resetx_button',[],'h_unkline_toggle',[],'h_toggle_all',[],'h_toggle_none',[],'radiogroup',[],'radio_unk1',[],'radio_unk2',[],'radio_unk3',[],'radio_unk4',[],'h_unk_from_text',[],'h_unk_to_text',[],'h_unk_total_text',[],'h_unk_graphic_text',[],'h_unk_manual_text',[],'h_unkbg_userfrom',[],'h_unksig_userfrom',[],'h_unkbg_userto',[],'h_unksig_userto',[],'h_bgpatch',[],'h_sigpatch',[]);
%                    A.UNK_num = 0;
%                    set(SCP.handles.h_unk_delete_button,'Callback',[]);
                    A.KC = 0;
                    A.k = 0;
                else
                    A.UNK_num = size(UNK,1);
                    set(SCP.handles.h_currentUNK_popup,'string',A.UNKPOPUPLIST,'value',A.KC);
                end;

                clear A.UNKfigs_open
                A.UNKfigs_open = {UNK.figure_state};
                A.UNKfigs_open = strcmp(A.UNKfigs_open,'open');
                SILLSFIG_UPDATE;
            end
        end

        if A.CALC_MANAGER_open == 1;
            CALC_MANAGER;
        end
    end
end

clear unktags currentfig delcall delquery