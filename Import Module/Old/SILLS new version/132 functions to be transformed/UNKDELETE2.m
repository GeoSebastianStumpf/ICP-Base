%UNKDELETE2

%summoned when an unknown file is deleted from the Calculation Manager

A.KC = get(gco,'Userdata');

delquery = questdlg('Are you sure you want to delete this sample?','SILLS Query','Yes','No','Yes');

if strcmp(delquery,'Yes');

    searchdestroy = find(A.UNK_with_matrix_index == A.KC);
    
    if ~isempty(searchdestroy);
        A.UNK_with_matrix(searchdestroy) = [];
        A.UNK_with_matrix_index(searchdestroy) = [];
        for c=1:A.UNK_num;
            if ~isempty(UNK(c).MATcorrfile_index) && UNK(c).MATcorrfile_index == A.UNK_with_matrix_num; %i.e. the last in the list
                i = A.UNK_with_matrix_num-1;
                UNK(c).MATcorrfile_index = i;
                UNK(c).MATcorrfile = A.UNK_with_matrix_index(i);
                clear i
            end;
            set(SMAN.handles(c).h_MATfile,'string',A.UNK_with_matrix,'value',UNK(c).MATcorrfile_index);
        end;

        A.UNK_with_matrix_num = size(A.UNK_with_matrix,2);
        
        if A.UNK_with_matrix_num == 0;
            %A.UNK_with_matrix_num = 0;
            for c=1:A.UNK_num;
                UNK(c).MAT_corrtype = 1;
                UNK(c).MATcorrfile = 1;
                set(SMAN.handles(c).h_MATtype,'string','none');
            end
        else
            A.UNK_with_matrix_num = size(A.UNK_with_matrix,1);
        end;
    end;

    if strcmp(UNK(A.KC).figure_state,'open') == 1
        delete(UNK(A.KC).handles.h_unkfig);
        A.K = A.K-1;
        if A.K == 0;
            A.k = 0;
        end;
    end;
    
    UNK(A.KC) = [];
    A.UNKPOPUPLIST(A.KC) = [];
    
    if A.KC == A.UNK_num;
        A.KC = A.KC - 1;
    end;
    
    A.UNK_num = size(UNK,2);
    
    if A.UNK_num == 0;
        set(SCP.handles.h_currentUNK_popup,'string','< load an unknown >');
        clear UNK;
        UNK = struct('data',[],'textdata',[],'colheaders',[],'fileinfo',[],'num_elements',[],'internal_standard',[],'bgwindow',[],'mat1window',[],'mat2window',[],'mattotal',[],'comp1window',[],'comp2window',[],'comp3window',[],'sigtotal',[],'order_opened',[],'figure_state',[],'XLim_orig',[],'YLim_orig',[],'YLim_orig_element',[],'timepoint',[],'hh',[],'mm',[],'Info',[],'MAT_corrtype',[],'MATcorrfile',[],'MATQIS',[],'MATQIS_conc',[],'MATQIS_conc_error',[],'MAT_oxide_total',[],'MAT_oxide_total_error',[],'MAT_Fe_ratio',[],'SIG_quanttype',[],'SIGQIS1',[],'SIGQIS1_conc',[],'SIGQIS1_conc_error',[],'SIGQIS2',[],'SIGQIS2_conc',[],'SIGQIS2_conc_error',[],'SIGsalinity',[],'SIGsalinity_error',[],'SALT',[],'SIGQIS_oxide',[],'SIGQIS_oxide_error',[],'SIG_Fe_ratio',[],'SIG_constraint1',[],'SIG_constraint2',[],'SIG_tracer',[]);
        UNK.handles = struct('h_unkfig',[],'h_unk_delete_button',[],'h_unk_resetx_button',[],'h_unkline_toggle',[],'h_toggle_all',[],'h_toggle_none',[],'radiogroup',[],'radio_unk1',[],'radio_unk2',[],'radio_unk3',[],'radio_unk4',[],'h_unk_from_text',[],'h_unk_to_text',[],'h_unk_total_text',[],'h_unk_graphic_text',[],'h_unk_manual_text',[],'h_unkbg_userfrom',[],'h_unksig_userfrom',[],'h_unkbg_userto',[],'h_unksig_userto',[],'h_bgpatch',[],'h_sigpatch',[]);
%        A.UNK_num = 0;
%         set(SCP.handles.h_unk_delete_button,'Callback',[]);
        A.KC = 0;
        A.k = 0;
    else
        A.UNK_num = size(UNK,1);
        set(SCP.handles.h_currentUNK_popup,'string',A.UNKPOPUPLIST,'value',A.KC);
        A.UNKfigs_open = {UNK.figure_state};
        A.UNKfigs_open = strcmp(A.UNKfigs_open,'open');
    end;
    
    SILLSFIG_UPDATE_CM;
    CALC_MANAGER;

end;

clear delquery
clear searchdestroy;
