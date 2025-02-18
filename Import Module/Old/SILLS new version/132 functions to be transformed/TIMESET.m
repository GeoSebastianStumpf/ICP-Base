%TIMESET

t = get(gco,'string');
t = str2num(t);

if isempty(t)
    msgbox('Invalid Entry','SILLS Warning');
    clear t
    return
end

if strcmp(get(gco,'tag'),'SCP.handles.h_currentSTD_drifthh_edit')==1;
    if t < 0 || t > 23 || ~isequal(t,round(t))
        msgbox('Invalid Entry','SILLS Warning');
        clear t
        return
    end;
    if t < 10
        STD(A.DC).hh = sprintf('%c%d','0',t);
    else
        STD(A.DC).hh = num2str(t);
    end
    
elseif strcmp(get(gco,'tag'),'SCP.handles.h_currentSTD_driftmm_edit')==1;
    if t < 0 || t > 59 || ~isequal(t,round(t))
        msgbox('Invalid Entry','SILLS Warning');
        clear t
        return
    end;
    if t < 10
        STD(A.DC).mm = sprintf('%c%d','0',t);
    else
        STD(A.DC).mm = num2str(t);
    end

elseif strcmp(get(gco,'tag'),'SMAN.handles.h_TIMEhh')==1;
    A.KC = get(gco,'Userdata');
    if t < 0 || t > 24 || ~isequal(t,round(t))
        msgbox('Invalid Entry','SILLS Warning');
        clear t
        return
    end;
    if t < 10
        UNK(A.KC).hh = sprintf('%c%d','0',t);
    else
        UNK(A.KC).hh = num2str(t);
    end
    
elseif strcmp(get(gco,'tag'),'SMAN.handles.h_TIMEmm')==1;
    A.KC = get(gco,'Userdata');
    if t < 0 || t > 59 || ~isequal(t,round(t))
        msgbox('Invalid Entry','SILLS Warning');
        clear t
        return
    end;
    if t < 10
        UNK(A.KC).mm = sprintf('%c%d','0',t);
    else
        UNK(A.KC).mm = num2str(t);
    end
end

clear t

