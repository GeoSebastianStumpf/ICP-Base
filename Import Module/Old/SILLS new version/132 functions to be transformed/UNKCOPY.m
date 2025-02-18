%UNKCOPY

if strcmp(get(gcf,'tag'),'SILLS Calculation Manager') == 1;
    
   A.KC = get(gco,'Userdata');
   UNK = [UNK(1:A.KC);UNK(A.KC);UNK(A.KC+1:end)];
   clear SMAN;
   A.UNKPOPUPLIST = [A.UNKPOPUPLIST(1:A.KC,1);[char(A.UNKPOPUPLIST(A.KC,1)) ' (copy)'];A.UNKPOPUPLIST(A.KC+1:end)];
   A.KC = A.KC + 1;
   A.k = A.k - 1;
   UNK(A.KC).order_opened = A.k;
   UNK(A.KC).fileinfo.name = char(A.UNKPOPUPLIST(A.KC));
   UNK(A.KC).figure_state = 'shut';
   A.UNK_num = A.UNK_num + 1;
   SILLSFIG_UPDATE_CM;
   CALC_MANAGER;

elseif strcmp(get(gco,'tag'),'SCP.handles.h_unk_copy_button') == 1;

    if A.UNK_num == 0
        return;
    else
        A.KC = get(SCP.handles.h_currentUNK_popup,'Value');
        UNK = [UNK(1:A.KC);UNK(A.KC);UNK(A.KC+1:end)];
        A.UNKPOPUPLIST = [A.UNKPOPUPLIST(1:A.KC,1);[char(A.UNKPOPUPLIST(A.KC,1)) ' (copy)'];A.UNKPOPUPLIST(A.KC+1:end)];
        A.KC = A.KC + 1;
        A.k = A.k - 1;
        UNK(A.KC).order_opened = A.k;
        UNK(A.KC).fileinfo.name = char(A.UNKPOPUPLIST(A.KC));
        UNK(A.KC).figure_state = 'shut';
        A.UNK_num = A.UNK_num + 1;
        set(SCP.handles.h_currentUNK_popup,'string',A.UNKPOPUPLIST);
    end
    if A.CALC_MANAGER_open == 1 %Calculation Manager window is open
        CALC_MANAGER;
    end
end
