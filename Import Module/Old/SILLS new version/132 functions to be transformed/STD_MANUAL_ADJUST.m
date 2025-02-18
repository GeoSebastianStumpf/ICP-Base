%%%%%%% STD_MANUAL_ADJUST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Callback that reads manually entered input from the 'Standard' section of the SILLS Control
% Panel and returns the value that most closely matches that in the
% standard data file.

%first, determine which field the data was just entered into

last_entered = gco;
currentfig = get(gcf,'UserData');
stdtags = [STD.order_opened];
A.DC = find(stdtags == currentfig);


%now convert the entered string into a numerical value

last_entered_string = get(last_entered,'string');
last_entered_num = str2num(last_entered_string);
set(last_entered,'ForegroundColor','k');

%now determine the time value in the signal data file that most
%closely corresponds to the user input. This is achieved by forming a vector
%containing the absolute value of the difference between the original time
%values and the userinput.  The row number for the minimum value is determined.

std_timediff = abs(STD(A.DC).data(:,1)-last_entered_num);
[diff,cellindex] = min(std_timediff);
last_entered_num = STD(A.DC).data(cellindex,1);

set(last_entered,'Value',STD(A.DC).data(cellindex,1),'String',STD(A.DC).data(cellindex,1));


%now, update the value in the STD structure array (ie. STD.bgwindow or STD.sigwindow)

a = get(last_entered,'UserData');

if strcmp(a,['bgfrom' STD(A.DC).order_opened])
    if isempty(STD(A.DC).bgwindow)
        STD(A.DC).bgwindow = zeros(1,2);
        STD(A.DC).bgwindow = [STD(A.DC).data(cellindex,1) STD(A.DC).data(cellindex,1)]; %set t1=t2 in [t1 t2]
        set(STD(A.DC).handles.h_stdbg_total,'string',STD(A.DC).bgwindow(2)-STD(A.DC).bgwindow(1));

    elseif ~isempty(STD(A.DC).bgwindow)

        STD(A.DC).bgwindow(1,1) = STD(A.DC).data(cellindex,1);

        if STD(A.DC).bgwindow(1,1) > STD(A.DC).bgwindow(1,2)
            set(STD(A.DC).handles.h_stdbg_userfrom,'ForegroundColor','r');
            set(STD(A.DC).handles.h_stdbg_userto,'ForegroundColor','r');
            set(STD(A.DC).handles.h_stdbg_total,'string',STD(A.DC).bgwindow(2)-STD(A.DC).bgwindow(1));
            searchdestroy = findobj(gcf,'facecolor',[.9 .9 .9]); 
            delete(searchdestroy); %get rid of the current patch

        else
            set(STD(A.DC).handles.h_stdbg_userfrom,'ForegroundColor','k');
            set(STD(A.DC).handles.h_stdbg_userto,'ForegroundColor','k');
            searchdestroy = findobj(gcf,'facecolor',[.9 .9 .9]); 
            delete(searchdestroy); %get rid of the current patch
            set(STD(A.DC).handles.h_stdbg_total,'string',STD(A.DC).bgwindow(2)-STD(A.DC).bgwindow(1));
      
            STD(A.DC).handles.h_bgpatch = patch('UserData',['Background Patch' STD(A.DC).order_opened],'faces',[1 2 3 4],...
                'vertices',[STD(A.DC).bgwindow(1) STD(A.DC).YLim_orig(1);STD(A.DC).bgwindow(2) STD(A.DC).YLim_orig(1);STD(A.DC).bgwindow(2) STD(A.DC).YLim_orig(2);STD(A.DC).bgwindow(1) STD(A.DC).YLim_orig(2)],...
                'EdgeColor','none','facecolor',[.9 .9 .9],'FaceAlpha',0.2);
        end
    end

elseif strcmp(a,['bgto' STD(A.DC).order_opened])
    if isempty(STD(A.DC).bgwindow)
        STD(A.DC).bgwindow = zeros(1,2);
        STD(A.DC).bgwindow = [STD(A.DC).data(cellindex,1) STD(A.DC).data(cellindex,1)]; %set t1=t2 in [t1 t2]
        set(STD(A.DC).handles.h_stdbg_total,'string',STD(A.DC).bgwindow(2)-STD(A.DC).bgwindow(1));

    elseif ~isempty(STD(A.DC).bgwindow)

        STD(A.DC).bgwindow(1,2) = STD(A.DC).data(cellindex,1);
        if STD(A.DC).bgwindow(1,2) < STD(A.DC).bgwindow(1,1)
            set(STD(A.DC).handles.h_stdbg_userfrom,'ForegroundColor','r');
            set(STD(A.DC).handles.h_stdbg_userto,'ForegroundColor','r');
            set(STD(A.DC).handles.h_stdbg_total,'string',STD(A.DC).bgwindow(2)-STD(A.DC).bgwindow(1));
            searchdestroy = findobj(gcf,'facecolor',[.9 .9 .9]); 
            delete(searchdestroy); %get rid of the current patch

        else
            set(STD(A.DC).handles.h_stdbg_userfrom,'ForegroundColor','k');
            set(STD(A.DC).handles.h_stdbg_userto,'ForegroundColor','k');
            searchdestroy = findobj(gcf,'facecolor',[.9 .9 .9]); 
            delete(searchdestroy); %get rid of the current patch
            set(STD(A.DC).handles.h_stdbg_total,'string',STD(A.DC).bgwindow(2)-STD(A.DC).bgwindow(1));

            STD(A.DC).handles.h_bgpatch = patch('UserData',['Background Patch' STD(A.DC).order_opened],'faces',[1 2 3 4],...
                'vertices',[STD(A.DC).bgwindow(1) STD(A.DC).YLim_orig(1);STD(A.DC).bgwindow(2) STD(A.DC).YLim_orig(1);STD(A.DC).bgwindow(2) STD(A.DC).YLim_orig(2);STD(A.DC).bgwindow(1) STD(A.DC).YLim_orig(2)],...
                'EdgeColor','none','facecolor',[.9 .9 .9],'FaceAlpha',0.2);
        end
    end

elseif strcmp(a,['sigfrom' STD(A.DC).order_opened]);
    if isempty(STD(A.DC).sigwindow)
        STD(A.DC).sigwindow = zeros(1,2);
        STD(A.DC).sigwindow = [STD(A.DC).data(cellindex,1) STD(A.DC).data(cellindex,1)]; %set t1=t2 in [t1 t2]
        set(STD(A.DC).handles.h_stdsig_total,'string',STD(A.DC).sigwindow(2)-STD(A.DC).sigwindow(1));
   
    elseif ~isempty(STD(A.DC).sigwindow)

        STD(A.DC).sigwindow(1,1) = STD(A.DC).data(cellindex,1);
        if STD(A.DC).sigwindow(1,1) > STD(A.DC).sigwindow(1,2)
            set(STD(A.DC).handles.h_stdsig_userfrom,'ForegroundColor','r');
            set(STD(A.DC).handles.h_stdsig_userto,'ForegroundColor','r');
            set(STD(A.DC).handles.h_stdsig_total,'string',STD(A.DC).sigwindow(2)-STD(A.DC).sigwindow(1));
            searchdestroy = findobj(gcf,'facecolor',[.9 .9 1]); 
            delete(searchdestroy); %get rid of the current patch
        else
            set(STD(A.DC).handles.h_stdsig_userfrom,'ForegroundColor','k');
            set(STD(A.DC).handles.h_stdsig_userto,'ForegroundColor','k');
            set(STD(A.DC).handles.h_stdsig_total,'string',STD(A.DC).sigwindow(2)-STD(A.DC).sigwindow(1));
            searchdestroy = findobj(gcf,'facecolor',[.9 .9 1]); 
            delete(searchdestroy); %get rid of the current patch
            STD(A.DC).handles.h_sigpatch = patch('UserData',['Signal Patch' STD(A.DC).order_opened],'faces',[1 2 3 4],...
                'vertices',[STD(A.DC).sigwindow(1) STD(A.DC).YLim_orig(1);STD(A.DC).sigwindow(2) STD(A.DC).YLim_orig(1);STD(A.DC).sigwindow(2) STD(A.DC).YLim_orig(2);STD(A.DC).sigwindow(1) STD(A.DC).YLim_orig(2)],...
                'EdgeColor','none','facecolor',[.9 .9 1],'FaceAlpha',0.2);
        end
    end

elseif strcmp(a,['sigto' STD(A.DC).order_opened]);
    if isempty(STD(A.DC).sigwindow)
        STD(A.DC).sigwindow = zeros(1,2);
        STD(A.DC).sigwindow = [STD(A.DC).data(cellindex,1) STD(A.DC).data(cellindex,1)]; %set t1=t2 in [t1 t2]
        set(STD(A.DC).handles.h_stdsig_total,'string',STD(A.DC).sigwindow(2)-STD(A.DC).sigwindow(1));
    elseif ~isempty(STD(A.DC).sigwindow)

        STD(A.DC).sigwindow(1,2) = STD(A.DC).data(cellindex,1);
        if STD(A.DC).sigwindow(1,2) < STD(A.DC).sigwindow(1,1);
            set(STD(A.DC).handles.h_stdsig_userfrom,'ForegroundColor','r');
            set(STD(A.DC).handles.h_stdsig_userto,'ForegroundColor','r');
            set(STD(A.DC).handles.h_stdsig_total,'string',STD(A.DC).sigwindow(2)-STD(A.DC).sigwindow(1));
            searchdestroy = findobj(gcf,'facecolor',[.9 .9 1]); 
            delete(searchdestroy); %get rid of the current patch

        else
            set(STD(A.DC).handles.h_stdsig_userfrom,'ForegroundColor','k');
            set(STD(A.DC).handles.h_stdsig_userto,'ForegroundColor','k');
            set(STD(A.DC).handles.h_stdsig_total,'string',STD(A.DC).sigwindow(2)-STD(A.DC).sigwindow(1));
            searchdestroy = findobj(gcf,'facecolor',[.9 .9 1]); 
            delete(searchdestroy); %get rid of the current patch
            STD(A.DC).handles.h_sigpatch = patch('UserData',['Signal Patch' STD(A.DC).order_opened],'faces',[1 2 3 4],...
                'vertices',[STD(A.DC).sigwindow(1) STD(A.DC).YLim_orig(1);STD(A.DC).sigwindow(2) STD(A.DC).YLim_orig(1);STD(A.DC).sigwindow(2) STD(A.DC).YLim_orig(2);STD(A.DC).sigwindow(1) STD(A.DC).YLim_orig(2)],...
                'EdgeColor','none','facecolor',[.9 .9 1],'FaceAlpha',0.2);
        end
    end
end

SILLSFIG_UPDATE

clear last_entered currentfig stdtags 
clear last_entered_string last_entered_num 
clear std_timediff diff cellindex 
clear searchdestroy
clear a
