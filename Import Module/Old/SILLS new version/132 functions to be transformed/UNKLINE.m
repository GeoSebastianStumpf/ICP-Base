%%%%%%%%%%%% UNKLINE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Transformed from function to script in 1.0.6

if gco == UNK(A.KC).handles.h_toggle_all

    set(UNK(A.KC).handles.h_unkline_toggle(:),'value',1);
    set(UNK(A.KC).handles.h_unkplot,'YLimMode','manual','XLimMode','manual');
    set(findobj(UNK(A.KC).handles.h_unkplot,'Tag','element'),'Visible','on'); %Modified in 1.0.3
    
elseif gco == UNK(A.KC).handles.h_toggle_none
    
    set(UNK(A.KC).handles.h_unkline_toggle(:),'value',0);
    set(UNK(A.KC).handles.h_unkplot,'YLimMode','manual','XLimMode','manual');
    set(findobj(UNK(A.KC).handles.h_unkplot,'Tag','element'),'Visible','off'); %Modified in 1.0.3
    
else
    toggle = get(gco,'UserData');
    %userdata is corresponds to the i'th element in the list

    toggle_state = get(UNK(A.KC).handles.h_unkline_toggle(toggle),'Value');
    % determine whether the toggle is engaged or not

    plot_list = findobj(UNK(A.KC).handles.h_unkplot,'tag','element'); %Modified in 1.0.3
    userdata_children = get(plot_list,'UserData');
    userdata_size = size(userdata_children);    
    userdata_size = userdata_size(1);
    
    selected_element = userdata_size - toggle + 1;

    if toggle_state == 0 %i.e. radio button unclicked
        set(UNK(A.KC).handles.h_unkplot,'YLimMode','manual','XLimMode','manual');
        set(plot_list(selected_element),'Visible','off');
        
    elseif toggle_state == 1 %i.e. radio button clicked
        set(UNK(A.KC).handles.h_unkplot,'YLimMode','manual','XLimMode','manual');
        set(plot_list(selected_element),'Visible','on');
    end
    %Added in 1.0.6
    clear toggle toggle_state plot_list userdata_children userdata_size selected_element
end

                                           
    