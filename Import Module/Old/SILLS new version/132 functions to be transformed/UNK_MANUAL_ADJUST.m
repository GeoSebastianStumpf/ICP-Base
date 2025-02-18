%%%%%%% UNK_MANUAL_ADJUST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Callback that reads manually entered input from the 'Standard' section of the SILLS Control
% Panel and returns the value that most closely matches that in the
% standard data file.

%first, determine which field the data was just entered into

last_entered = gco;
currentfig = get(gcf,'UserData');
tags = [UNK.order_opened];
A.KC = find(tags == currentfig);


%now convert the entered string into a numerical value

last_entered_string = get(last_entered,'string');
last_entered_num = str2num(last_entered_string);
set(last_entered,'ForegroundColor','k');

%now determine the time value in the signal data file that most
%closely corresponds to the user input. This is achieved by forming a vector
%containing the absolute value of the difference between the original time
%values and the userinput.  The row number for the minimum value is determined.

unk_timediff = abs(UNK(A.KC).data(:,1)-last_entered_num);
[diff,cellindex] = min(unk_timediff);
last_entered_num = UNK(A.KC).data(cellindex,1);

set(last_entered,'Value',UNK(A.KC).data(cellindex,1),'String',UNK(A.KC).data(cellindex,1));


%now, update the value in the UNK structure array (ie. UNK.bgwindow or UNK.sigwindow)

a = get(last_entered,'UserData');

if strcmp(a,['bgfrom' -1000*UNK(A.KC).order_opened])
    if isempty(UNK(A.KC).bgwindow)
        UNK(A.KC).bgwindow = zeros(1,2);
        UNK(A.KC).bgwindow = [UNK(A.KC).data(cellindex,1) UNK(A.KC).data(cellindex,1)]; %set t1=t2 in [t1 t2]
        set(UNK(A.KC).handles.h_unkbg_total,'string',UNK(A.KC).bgwindow(2)-UNK(A.KC).bgwindow(1));

    elseif ~isempty(UNK(A.KC).bgwindow)

        UNK(A.KC).bgwindow(1,1) = UNK(A.KC).data(cellindex,1);

        if UNK(A.KC).bgwindow(1,1) > UNK(A.KC).bgwindow(1,2)
            set(UNK(A.KC).handles.h_unkbg_userfrom,'ForegroundColor','r');
            set(UNK(A.KC).handles.h_unkbg_userto,'ForegroundColor','r');
            set(UNK(A.KC).handles.h_unkbg_total,'string',UNK(A.KC).bgwindow(2)-UNK(A.KC).bgwindow(1));
            searchdestroy = findobj(gcf,'facecolor',[.9 .9 .9]); 
            delete(searchdestroy); %get rid of the current patch
        else
            set(UNK(A.KC).handles.h_unkbg_userfrom,'ForegroundColor','k');
            set(UNK(A.KC).handles.h_unkbg_userto,'ForegroundColor','k');
            set(UNK(A.KC).handles.h_unkbg_total,'string',UNK(A.KC).bgwindow(2)-UNK(A.KC).bgwindow(1));
            searchdestroy = findobj(gcf,'facecolor',[.9 .9 .9]); 
            delete(searchdestroy); %get rid of the current patch
            UNK(A.KC).handles.h_bgpatch = patch('UserData',['Background Patch' -1000*UNK(A.KC).order_opened],'faces',[1 2 3 4],...
                'vertices',[UNK(A.KC).bgwindow(1) UNK(A.KC).YLim_orig(1);UNK(A.KC).bgwindow(2) UNK(A.KC).YLim_orig(1);UNK(A.KC).bgwindow(2) UNK(A.KC).YLim_orig(2);UNK(A.KC).bgwindow(1) UNK(A.KC).YLim_orig(2)],...
                'EdgeColor','none','facecolor',[.9 .9 .9],'FaceAlpha',0.2);
        end
    end

elseif strcmp(a,['bgto' -1000*UNK(A.KC).order_opened])
    if isempty(UNK(A.KC).bgwindow)
        UNK(A.KC).bgwindow = zeros(1,2);
        UNK(A.KC).bgwindow = [UNK(A.KC).data(cellindex,1) UNK(A.KC).data(cellindex,1)]; %set t1=t2 in [t1 t2]
        set(UNK(A.KC).handles.h_unkbg_total,'string',UNK(A.KC).bgwindow(2)-UNK(A.KC).bgwindow(1));
            
    elseif ~isempty(UNK(A.KC).bgwindow)

        UNK(A.KC).bgwindow(1,2) = UNK(A.KC).data(cellindex,1);
        if UNK(A.KC).bgwindow(1,2) < UNK(A.KC).bgwindow(1,1)
            set(UNK(A.KC).handles.h_unkbg_userfrom,'ForegroundColor','r');
            set(UNK(A.KC).handles.h_unkbg_userto,'ForegroundColor','r');
            set(UNK(A.KC).handles.h_unkbg_total,'string',UNK(A.KC).bgwindow(2)-UNK(A.KC).bgwindow(1));
            searchdestroy = findobj(gcf,'facecolor',[.9 .9 .9]); 
            delete(searchdestroy); %get rid of the current patch
        else
            set(UNK(A.KC).handles.h_unkbg_userfrom,'ForegroundColor','k');
            set(UNK(A.KC).handles.h_unkbg_userto,'ForegroundColor','k');
            set(UNK(A.KC).handles.h_unkbg_total,'string',UNK(A.KC).bgwindow(2)-UNK(A.KC).bgwindow(1));
            searchdestroy = findobj(gcf,'facecolor',[.9 .9 .9]); 
            delete(searchdestroy); %get rid of the current patch

            UNK(A.KC).handles.h_bgpatch = patch('UserData',['Background Patch' -1000*UNK(A.KC).order_opened],'faces',[1 2 3 4],...
                'vertices',[UNK(A.KC).bgwindow(1) UNK(A.KC).YLim_orig(1);UNK(A.KC).bgwindow(2) UNK(A.KC).YLim_orig(1);UNK(A.KC).bgwindow(2) UNK(A.KC).YLim_orig(2);UNK(A.KC).bgwindow(1) UNK(A.KC).YLim_orig(2)],...
                'EdgeColor','none','facecolor',[.9 .9 .9],'FaceAlpha',0.2);
        end
    end

elseif strcmp(a,['mat1from' -1000*UNK(A.KC).order_opened]);
    if isempty(UNK(A.KC).mat1window)
        UNK(A.KC).mat1window = zeros(1,2);
        UNK(A.KC).mat1window = [UNK(A.KC).data(cellindex,1) UNK(A.KC).data(cellindex,1)]; %set t1=t2 in [t1 t2]
        set(UNK(A.KC).handles.h_unkmat1_total,'string',UNK(A.KC).mat1window(2)-UNK(A.KC).mat1window(1))

    elseif ~isempty(UNK(A.KC).mat1window)

        UNK(A.KC).mat1window(1,1) = UNK(A.KC).data(cellindex,1);
        if UNK(A.KC).mat1window(1,1) > UNK(A.KC).mat1window(1,2)
            set(UNK(A.KC).handles.h_unkmat1_userfrom,'ForegroundColor','r');
            set(UNK(A.KC).handles.h_unkmat1_userto,'ForegroundColor','r');
            set(UNK(A.KC).handles.h_unkmat1_total,'string',UNK(A.KC).mat1window(2)-UNK(A.KC).mat1window(1))
            searchdestroy = findobj(gcf,'facecolor',[.9 1 .9]); 
            delete(searchdestroy); %get rid of the current patch
        else
            set(UNK(A.KC).handles.h_unkmat1_userfrom,'ForegroundColor','k');
            set(UNK(A.KC).handles.h_unkmat1_userto,'ForegroundColor','k');
            set(UNK(A.KC).handles.h_unkmat1_total,'string',UNK(A.KC).mat1window(2)-UNK(A.KC).mat1window(1))
            searchdestroy = findobj(gcf,'facecolor',[.9 1 .9]); 
            delete(searchdestroy); %get rid of the current patch
            UNK(A.KC).handles.h_mat1patch = patch('UserData',['Signal Patch' -1000*UNK(A.KC).order_opened],'faces',[1 2 3 4],...
                'vertices',[UNK(A.KC).mat1window(1) UNK(A.KC).YLim_orig(1);UNK(A.KC).mat1window(2) UNK(A.KC).YLim_orig(1);UNK(A.KC).mat1window(2) UNK(A.KC).YLim_orig(2);UNK(A.KC).mat1window(1) UNK(A.KC).YLim_orig(2)],...
                'EdgeColor','none','facecolor',[.9 1 .9],'FaceAlpha',0.2);
        end
    end

elseif strcmp(a,['mat1to' -1000*UNK(A.KC).order_opened]);
    if isempty(UNK(A.KC).mat1window)
        UNK(A.KC).mat1window = zeros(1,2);
        UNK(A.KC).mat1window = [UNK(A.KC).data(cellindex,1) UNK(A.KC).data(cellindex,1)]; %set t1=t2 in [t1 t2]
        set(UNK(A.KC).handles.h_unkmat1_total,'string',UNK(A.KC).mat1window(2)-UNK(A.KC).mat1window(1))

    elseif ~isempty(UNK(A.KC).mat1window)

        UNK(A.KC).mat1window(1,2) = UNK(A.KC).data(cellindex,1);
        if UNK(A.KC).mat1window(1,2) < UNK(A.KC).mat1window(1,1);
            set(UNK(A.KC).handles.h_unkmat1_userfrom,'ForegroundColor','r');
            set(UNK(A.KC).handles.h_unkmat1_userto,'ForegroundColor','r');
            set(UNK(A.KC).handles.h_unkmat1_total,'string',UNK(A.KC).mat1window(2)-UNK(A.KC).mat1window(1))
            searchdestroy = findobj(gcf,'facecolor',[.9 1 .9]); 
            delete(searchdestroy); %get rid of the current patch
        else
            set(UNK(A.KC).handles.h_unkmat1_userfrom,'ForegroundColor','k');
            set(UNK(A.KC).handles.h_unkmat1_userto,'ForegroundColor','k');
            set(UNK(A.KC).handles.h_unkmat1_total,'string',UNK(A.KC).mat1window(2)-UNK(A.KC).mat1window(1))
            searchdestroy = findobj(gcf,'facecolor',[.9 1 .9]); 
            delete(searchdestroy); %get rid of the current patch
            UNK(A.KC).handles.h_mat1patch = patch('UserData',['Signal Patch' -1000*UNK(A.KC).order_opened],'faces',[1 2 3 4],...
                'vertices',[UNK(A.KC).mat1window(1) UNK(A.KC).YLim_orig(1);UNK(A.KC).mat1window(2) UNK(A.KC).YLim_orig(1);UNK(A.KC).mat1window(2) UNK(A.KC).YLim_orig(2);UNK(A.KC).mat1window(1) UNK(A.KC).YLim_orig(2)],...
                'EdgeColor','none','facecolor',[.9 1 .9],'FaceAlpha',0.2);
        end
    end
    
    
elseif strcmp(a,['mat2from' -1000*UNK(A.KC).order_opened]);
    if isempty(UNK(A.KC).mat2window)
        UNK(A.KC).mat2window = zeros(1,2);
        UNK(A.KC).mat2window = [UNK(A.KC).data(cellindex,1) UNK(A.KC).data(cellindex,1)]; %set t1=t2 in [t1 t2]
        set(UNK(A.KC).handles.h_unkmat2_total,'string',UNK(A.KC).mat2window(2)-UNK(A.KC).mat2window(1))

    elseif ~isempty(UNK(A.KC).mat2window)

        UNK(A.KC).mat2window(1,1) = UNK(A.KC).data(cellindex,1);
        if UNK(A.KC).mat2window(1,1) > UNK(A.KC).mat2window(1,2)
            set(UNK(A.KC).handles.h_unkmat2_userfrom,'ForegroundColor','r');
            set(UNK(A.KC).handles.h_unkmat2_userto,'ForegroundColor','r');
            set(UNK(A.KC).handles.h_unkmat2_total,'string',UNK(A.KC).mat2window(2)-UNK(A.KC).mat2window(1))
            searchdestroy = findobj(gcf,'facecolor',[.8 1 .8]); 
            delete(searchdestroy); %get rid of the current patch
        else
            set(UNK(A.KC).handles.h_unkmat2_userfrom,'ForegroundColor','k');
            set(UNK(A.KC).handles.h_unkmat2_userto,'ForegroundColor','k');
            set(UNK(A.KC).handles.h_unkmat2_total,'string',UNK(A.KC).mat2window(2)-UNK(A.KC).mat2window(1))
            searchdestroy = findobj(gcf,'facecolor',[.8 1 .8]); 
            delete(searchdestroy); %get rid of the current patch
            UNK(A.KC).handles.h_mat2patch = patch('UserData',['Signal Patch' -1000*UNK(A.KC).order_opened],'faces',[1 2 3 4],...
                'vertices',[UNK(A.KC).mat2window(1) UNK(A.KC).YLim_orig(1);UNK(A.KC).mat2window(2) UNK(A.KC).YLim_orig(1);UNK(A.KC).mat2window(2) UNK(A.KC).YLim_orig(2);UNK(A.KC).mat2window(1) UNK(A.KC).YLim_orig(2)],...
                'EdgeColor','none','facecolor',[.8 1 .8],'FaceAlpha',0.2);
        end
    end

elseif strcmp(a,['mat2to' -1000*UNK(A.KC).order_opened]);
    if isempty(UNK(A.KC).mat2window)
        UNK(A.KC).mat2window = zeros(1,2);
        UNK(A.KC).mat2window = [UNK(A.KC).data(cellindex,1) UNK(A.KC).data(cellindex,1)]; %set t1=t2 in [t1 t2]
        set(UNK(A.KC).handles.h_unkmat2_total,'string',UNK(A.KC).mat2window(2)-UNK(A.KC).mat2window(1))

    elseif ~isempty(UNK(A.KC).mat2window)

        UNK(A.KC).mat2window(1,2) = UNK(A.KC).data(cellindex,1);
        if UNK(A.KC).mat2window(1,2) < UNK(A.KC).mat2window(1,1);
            set(UNK(A.KC).handles.h_unkmat2_userfrom,'ForegroundColor','r');
            set(UNK(A.KC).handles.h_unkmat2_userto,'ForegroundColor','r');
            set(UNK(A.KC).handles.h_unkmat2_total,'string',UNK(A.KC).mat2window(2)-UNK(A.KC).mat2window(1))
            searchdestroy = findobj(gcf,'facecolor',[.8 1 .8]); 
            delete(searchdestroy); %get rid of the current patch
        else
            set(UNK(A.KC).handles.h_unkmat2_userfrom,'ForegroundColor','k');
            set(UNK(A.KC).handles.h_unkmat2_userto,'ForegroundColor','k');
            set(UNK(A.KC).handles.h_unkmat2_total,'string',UNK(A.KC).mat2window(2)-UNK(A.KC).mat2window(1))
            searchdestroy = findobj(gcf,'facecolor',[.8 1 .8]); 
            delete(searchdestroy); %get rid of the current patch
            UNK(A.KC).handles.h_mat2patch = patch('UserData',['Signal Patch' -1000*UNK(A.KC).order_opened],'faces',[1 2 3 4],...
                'vertices',[UNK(A.KC).mat2window(1) UNK(A.KC).YLim_orig(1);UNK(A.KC).mat2window(2) UNK(A.KC).YLim_orig(1);UNK(A.KC).mat2window(2) UNK(A.KC).YLim_orig(2);UNK(A.KC).mat2window(1) UNK(A.KC).YLim_orig(2)],...
                'EdgeColor','none','facecolor',[.8 1 .8],'FaceAlpha',0.2);
        end
    end
    
elseif strcmp(a,['comp1from' -1000*UNK(A.KC).order_opened]);
    if isempty(UNK(A.KC).comp1window)
        UNK(A.KC).comp1window = zeros(1,2);
        UNK(A.KC).comp1window = [UNK(A.KC).data(cellindex,1) UNK(A.KC).data(cellindex,1)]; %set t1=t2 in [t1 t2]
        comp1total = UNK(A.KC).comp1window(2)-UNK(A.KC).comp1window(1);
        set(UNK(A.KC).handles.h_unkcomp1_total,'string',comp1total);
    elseif ~isempty(UNK(A.KC).comp1window)

        UNK(A.KC).comp1window(1,1) = UNK(A.KC).data(cellindex,1);
        if UNK(A.KC).comp1window(1,1) > UNK(A.KC).comp1window(1,2)
            set(UNK(A.KC).handles.h_unkcomp1_userfrom,'ForegroundColor','r');
            set(UNK(A.KC).handles.h_unkcomp1_userto,'ForegroundColor','r');
            comp1total = UNK(A.KC).comp1window(2)-UNK(A.KC).comp1window(1);
            set(UNK(A.KC).handles.h_unkcomp1_total,'string',comp1total);
            searchdestroy = findobj(gcf,'facecolor',[.9 .9 1]); 
            delete(searchdestroy); %get rid of the current patch
        else
            set(UNK(A.KC).handles.h_unkcomp1_userfrom,'ForegroundColor','k');
            set(UNK(A.KC).handles.h_unkcomp1_userto,'ForegroundColor','k');
            comp1total = UNK(A.KC).comp1window(2)-UNK(A.KC).comp1window(1);
            set(UNK(A.KC).handles.h_unkcomp1_total,'string',comp1total);
            searchdestroy = findobj(gcf,'facecolor',[.9 .9 1]); 
            delete(searchdestroy); %get rid of the current patch
            UNK(A.KC).handles.h_comp1patch = patch('UserData',['Signal Patch' -1000*UNK(A.KC).order_opened],'faces',[1 2 3 4],...
                'vertices',[UNK(A.KC).comp1window(1) UNK(A.KC).YLim_orig(1);UNK(A.KC).comp1window(2) UNK(A.KC).YLim_orig(1);UNK(A.KC).comp1window(2) UNK(A.KC).YLim_orig(2);UNK(A.KC).comp1window(1) UNK(A.KC).YLim_orig(2)],...
                'EdgeColor','none','facecolor',[.9 .9 1],'FaceAlpha',0.2);
        end
    end

elseif strcmp(a,['comp1to' -1000*UNK(A.KC).order_opened]);
    if isempty(UNK(A.KC).comp1window)
        UNK(A.KC).comp1window = zeros(1,2);
        UNK(A.KC).comp1window = [UNK(A.KC).data(cellindex,1) UNK(A.KC).data(cellindex,1)]; %set t1=t2 in [t1 t2]
        comp1total = UNK(A.KC).comp1window(2)-UNK(A.KC).comp1window(1);
        set(UNK(A.KC).handles.h_unkcomp1_total,'string',comp1total);
    elseif ~isempty(UNK(A.KC).comp1window)

        UNK(A.KC).comp1window(1,2) = UNK(A.KC).data(cellindex,1);
        if UNK(A.KC).comp1window(1,2) < UNK(A.KC).comp1window(1,1);
            set(UNK(A.KC).handles.h_unkcomp1_userfrom,'ForegroundColor','r');
            set(UNK(A.KC).handles.h_unkcomp1_userto,'ForegroundColor','r');
            comp1total = UNK(A.KC).comp1window(2)-UNK(A.KC).comp1window(1);
            set(UNK(A.KC).handles.h_unkcomp1_total,'string',comp1total);
            searchdestroy = findobj(gcf,'facecolor',[.9 .9 1]); 
            delete(searchdestroy); %get rid of the current patch
        else
            set(UNK(A.KC).handles.h_unkcomp1_userfrom,'ForegroundColor','k');
            set(UNK(A.KC).handles.h_unkcomp1_userto,'ForegroundColor','k');
            comp1total = UNK(A.KC).comp1window(2)-UNK(A.KC).comp1window(1);
            set(UNK(A.KC).handles.h_unkcomp1_total,'string',comp1total);
            searchdestroy = findobj(gcf,'facecolor',[.9 .9 1]); 
            delete(searchdestroy); %get rid of the current patch
            UNK(A.KC).handles.h_comp1patch = patch('UserData',['Signal Patch' -1000*UNK(A.KC).order_opened],'faces',[1 2 3 4],...
                'vertices',[UNK(A.KC).comp1window(1) UNK(A.KC).YLim_orig(1);UNK(A.KC).comp1window(2) UNK(A.KC).YLim_orig(1);UNK(A.KC).comp1window(2) UNK(A.KC).YLim_orig(2);UNK(A.KC).comp1window(1) UNK(A.KC).YLim_orig(2)],...
                'EdgeColor','none','facecolor',[.9 .9 1],'FaceAlpha',0.2);
        end
    end


elseif strcmp(a,['comp2from' -1000*UNK(A.KC).order_opened]);
    if isempty(UNK(A.KC).comp2window)
        UNK(A.KC).comp2window = zeros(1,2);
        UNK(A.KC).comp2window = [UNK(A.KC).data(cellindex,1) UNK(A.KC).data(cellindex,1)]; %set t1=t2 in [t1 t2]
        comp2total = UNK(A.KC).comp2window(2)-UNK(A.KC).comp2window(1);
        set(UNK(A.KC).handles.h_unkcomp2_total,'string',comp2total);
    elseif ~isempty(UNK(A.KC).comp2window)

        UNK(A.KC).comp2window(1,1) = UNK(A.KC).data(cellindex,1);
        if UNK(A.KC).comp2window(1,1) > UNK(A.KC).comp2window(1,2)
            set(UNK(A.KC).handles.h_unkcomp2_userfrom,'ForegroundColor','r');
            set(UNK(A.KC).handles.h_unkcomp2_userto,'ForegroundColor','r');
            comp2total = UNK(A.KC).comp2window(2)-UNK(A.KC).comp2window(1);
            set(UNK(A.KC).handles.h_unkcomp2_total,'string',comp2total);
            searchdestroy = findobj(gcf,'facecolor',[.8 .8 1]); 
            delete(searchdestroy); %get rid of the current patch
        else
            set(UNK(A.KC).handles.h_unkcomp2_userfrom,'ForegroundColor','k');
            set(UNK(A.KC).handles.h_unkcomp2_userto,'ForegroundColor','k');
            comp2total = UNK(A.KC).comp2window(2)-UNK(A.KC).comp2window(1);
            set(UNK(A.KC).handles.h_unkcomp2_total,'string',comp2total);
            searchdestroy = findobj(gcf,'facecolor',[.8 .8 1]); 
            delete(searchdestroy); %get rid of the current patch
            UNK(A.KC).handles.h_comp2patch = patch('UserData',['Signal Patch' -1000*UNK(A.KC).order_opened],'faces',[1 2 3 4],...
                'vertices',[UNK(A.KC).comp2window(1) UNK(A.KC).YLim_orig(1);UNK(A.KC).comp2window(2) UNK(A.KC).YLim_orig(1);UNK(A.KC).comp2window(2) UNK(A.KC).YLim_orig(2);UNK(A.KC).comp2window(1) UNK(A.KC).YLim_orig(2)],...
                'EdgeColor','none','facecolor',[.8 .8 1],'FaceAlpha',0.2);
        end
    end

elseif strcmp(a,['comp2to' -1000*UNK(A.KC).order_opened]);
    if isempty(UNK(A.KC).comp2window)
        UNK(A.KC).comp2window = zeros(1,2);
        UNK(A.KC).comp2window = [UNK(A.KC).data(cellindex,1) UNK(A.KC).data(cellindex,1)]; %set t1=t2 in [t1 t2]
        comp2total = UNK(A.KC).comp2window(2)-UNK(A.KC).comp2window(1);
        set(UNK(A.KC).handles.h_unkcomp2_total,'string',comp2total);
    elseif ~isempty(UNK(A.KC).comp2window)

        UNK(A.KC).comp2window(1,2) = UNK(A.KC).data(cellindex,1);
        if UNK(A.KC).comp2window(1,2) < UNK(A.KC).comp2window(1,1);
            set(UNK(A.KC).handles.h_unkcomp2_userfrom,'ForegroundColor','r');
            set(UNK(A.KC).handles.h_unkcomp2_userto,'ForegroundColor','r');
            comp2total = UNK(A.KC).comp2window(2)-UNK(A.KC).comp2window(1);
            set(UNK(A.KC).handles.h_unkcomp2_total,'string',comp2total);
            searchdestroy = findobj(gcf,'facecolor',[.8 .8 1]); 
            delete(searchdestroy); %get rid of the current patch
        else
            set(UNK(A.KC).handles.h_unkcomp2_userfrom,'ForegroundColor','k');
            set(UNK(A.KC).handles.h_unkcomp2_userto,'ForegroundColor','k');
            comp2total = UNK(A.KC).comp2window(2)-UNK(A.KC).comp2window(1);
            set(UNK(A.KC).handles.h_unkcomp2_total,'string',comp2total);
            searchdestroy = findobj(gcf,'facecolor',[.8 .8 1]); 
            delete(searchdestroy); %get rid of the current patch
            UNK(A.KC).handles.h_comp2patch = patch('UserData',['Signal Patch' -1000*UNK(A.KC).order_opened],'faces',[1 2 3 4],...
                'vertices',[UNK(A.KC).comp2window(1) UNK(A.KC).YLim_orig(1);UNK(A.KC).comp2window(2) UNK(A.KC).YLim_orig(1);UNK(A.KC).comp2window(2) UNK(A.KC).YLim_orig(2);UNK(A.KC).comp2window(1) UNK(A.KC).YLim_orig(2)],...
                'EdgeColor','none','facecolor',[.8 .8 1],'FaceAlpha',0.2);
        end
    end

elseif strcmp(a,['comp3from' -1000*UNK(A.KC).order_opened]);
    if isempty(UNK(A.KC).comp3window)
        UNK(A.KC).comp3window = zeros(1,2);
        UNK(A.KC).comp3window = [UNK(A.KC).data(cellindex,1) UNK(A.KC).data(cellindex,1)]; %set t1=t2 in [t1 t2]
        comp3total = UNK(A.KC).comp3window(2)-UNK(A.KC).comp3window(1);
        set(UNK(A.KC).handles.h_unkcomp3_total,'string',comp3total);
    elseif ~isempty(UNK(A.KC).comp3window)

        UNK(A.KC).comp3window(1,1) = UNK(A.KC).data(cellindex,1);
        if UNK(A.KC).comp3window(1,1) > UNK(A.KC).comp3window(1,2)
            set(UNK(A.KC).handles.h_unkcomp3_userfrom,'ForegroundColor','r');
            set(UNK(A.KC).handles.h_unkcomp3_userto,'ForegroundColor','r');
            comp3total = UNK(A.KC).comp3window(2)-UNK(A.KC).comp3window(1);
            set(UNK(A.KC).handles.h_unkcomp3_total,'string',comp3total);
            searchdestroy = findobj(gcf,'facecolor',[.7 .7 1]); 
            delete(searchdestroy); %get rid of the current patch
        else
            set(UNK(A.KC).handles.h_unkcomp3_userfrom,'ForegroundColor','k');
            set(UNK(A.KC).handles.h_unkcomp3_userto,'ForegroundColor','k');
            comp3total = UNK(A.KC).comp3window(2)-UNK(A.KC).comp3window(1);
            set(UNK(A.KC).handles.h_unkcomp3_total,'string',comp3total);
            searchdestroy = findobj(gcf,'facecolor',[.7 .7 1]); 
            delete(searchdestroy); %get rid of the current patch
            UNK(A.KC).handles.h_comp3patch = patch('UserData',['Signal Patch' -1000*UNK(A.KC).order_opened],'faces',[1 2 3 4],...
                'vertices',[UNK(A.KC).comp3window(1) UNK(A.KC).YLim_orig(1);UNK(A.KC).comp3window(2) UNK(A.KC).YLim_orig(1);UNK(A.KC).comp3window(2) UNK(A.KC).YLim_orig(2);UNK(A.KC).comp3window(1) UNK(A.KC).YLim_orig(2)],...
                'EdgeColor','none','facecolor',[.7 .7 1],'FaceAlpha',0.2);
        end
    end

elseif strcmp(a,['comp3to' -1000*UNK(A.KC).order_opened]);
    if isempty(UNK(A.KC).comp3window)
        UNK(A.KC).comp3window = zeros(1,2);
        UNK(A.KC).comp3window = [UNK(A.KC).data(cellindex,1) UNK(A.KC).data(cellindex,1)]; %set t1=t2 in [t1 t2]
        comp3total = UNK(A.KC).comp3window(2)-UNK(A.KC).comp3window(1);
        set(UNK(A.KC).handles.h_unkcomp3_total,'string',comp3total);
    elseif ~isempty(UNK(A.KC).comp3window)

        UNK(A.KC).comp3window(1,2) = UNK(A.KC).data(cellindex,1);
        if UNK(A.KC).comp3window(1,2) < UNK(A.KC).comp3window(1,1);
            set(UNK(A.KC).handles.h_unkcomp3_userfrom,'ForegroundColor','r');
            set(UNK(A.KC).handles.h_unkcomp3_userto,'ForegroundColor','r');
            comp3total = UNK(A.KC).comp3window(2)-UNK(A.KC).comp3window(1);
            set(UNK(A.KC).handles.h_unkcomp3_total,'string',comp3total);
            searchdestroy = findobj(gcf,'facecolor',[.7 .7 1]); 
            delete(searchdestroy); %get rid of the current patch
        else
            set(UNK(A.KC).handles.h_unkcomp3_userfrom,'ForegroundColor','k');
            set(UNK(A.KC).handles.h_unkcomp3_userto,'ForegroundColor','k');
            comp3total = UNK(A.KC).comp3window(2)-UNK(A.KC).comp3window(1);
            set(UNK(A.KC).handles.h_unkcomp3_total,'string',comp3total);
            searchdestroy = findobj(gcf,'facecolor',[.7 .7 1]); 
            delete(searchdestroy); %get rid of the current patch
            UNK(A.KC).handles.h_comp3patch = patch('UserData',['Signal Patch' -1000*UNK(A.KC).order_opened],'faces',[1 2 3 4],...
                'vertices',[UNK(A.KC).comp3window(1) UNK(A.KC).YLim_orig(1);UNK(A.KC).comp3window(2) UNK(A.KC).YLim_orig(1);UNK(A.KC).comp3window(2) UNK(A.KC).YLim_orig(2);UNK(A.KC).comp3window(1) UNK(A.KC).YLim_orig(2)],...
                'EdgeColor','none','facecolor',[.7 .7 1],'FaceAlpha',0.2);
        end
    end

end

SILLSFIG_UPDATE

clear last_entered currentfig tags 
clear last_entered_string last_entered_num 
clear unk_timediff diff cellindex
clear searchdestroy
clear a

