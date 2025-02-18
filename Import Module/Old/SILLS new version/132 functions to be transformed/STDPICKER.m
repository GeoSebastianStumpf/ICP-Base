%%%%%%%%%% STDPICKER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Transformed from function to script in 1.0.5
%Simplified in 1.0.5

currentfig = get(gcf,'UserData'); %find out which standard we are dealing with
stdtags = [STD.order_opened]; %list all the standards available, using their order_opened tags
DC = find(stdtags == currentfig); %make the current_STD the one just selected via clicking its graph.


if get(STD(DC).handles.radio_std1,'value') == 1 %i.e. zoom is selected
    ZOOMER
     
else
    zoom off
    set(gca,'units','pixels');
    yrange = get(gca,'YLim');
    ylow = yrange(1);
    yhigh = yrange(2);
    xrange = get(gca,'XLim');
    xlow = xrange(1);
    xhigh = xrange(2);

    xpos1_std = get(gca,'CurrentPoint'); %button down detected
    
    %Abort if user clicked outside the plot axes % Added in 1.0.5
    if strcmp(get(gca,'tag'),'STD.handles.h_stdlegend')
        return
    elseif xpos1_std(1,1) < xlow || xpos1_std(1,1) > xhigh || xpos1_std(1,2) < ylow || xpos1_std(1,2) > yhigh
        return
    end

    rbbox;
    xpos2_std = get(gca,'CurrentPoint'); %button up detected

    xpos1_std = xpos1_std(1,1:2);
    std_timediff1 = abs((STD(DC).data(:,1))-xpos1_std(1,1));
    [diff1_std,cell1_std] = min(std_timediff1);
    xval1_std = STD(DC).data(cell1_std,1);

    xpos2_std = xpos2_std(1,1:2);
    std_timediff2 = abs((STD(DC).data(:,1))-xpos2_std(1,1));
    [diff2_std,cell2_std] = min(std_timediff2);
    xval2_std = STD(DC).data(cell2_std,1);

    if get(STD(DC).handles.radio_std2,'value') == 1

        searchdestroy = findobj(gcf,'facecolor',[.9 .9 .9]); 
        delete(searchdestroy); %get rid of the current patch

        if xpos1_std(1) < xlow;
            xpos1_std(1) = xlow;
        end

        if xpos2_std(1) > xhigh;
            xpos2_std(1) = xhigh;
        end
        
         %%%%%%% test for overlapping windows %%%%%%%%%
        
        % set up a matrix containing all other windows
        OLAP = STD(DC).sigwindow;
        minn = min(xval1_std,xval2_std);
        maxx = max(xval1_std,xval2_std);
        for c = 1:size(OLAP,1)
            if (OLAP(c,1) <= minn && minn <= OLAP(c,2)) || (OLAP(c,1) <= maxx && maxx <= OLAP(c,2))
                msgbox('Overlapping integration windows. Please select again','SILLS Warning');
                return
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
        STD(DC).handles.h_bgpatch = patch('faces',[1 2 3 4],'vertices',[xpos1_std(1) STD(DC).YLim_orig(1);xpos2_std(1) STD(DC).YLim_orig(1);xpos2_std(1) STD(DC).YLim_orig(2);xpos1_std(1) STD(DC).YLim_orig(2)],...
            'EdgeColor','none','facecolor',[.9 .9 .9],'FaceAlpha',0.2);
      
        STD(DC).bgwindow = [min(xval1_std,xval2_std) max(xval1_std,xval2_std)];

        %update the display values
        set(findobj('UserData',['bgfrom' STD(DC).order_opened]),'string',STD(DC).bgwindow(1),'Value',STD(DC).bgwindow(1));
        set(findobj('UserData',['bgto' STD(DC).order_opened]),'string',STD(DC).bgwindow(2),'Value',STD(DC).bgwindow(2));
        set(STD(DC).handles.h_stdbg_total,'string',STD(DC).bgwindow(2)-STD(DC).bgwindow(1));
        set(STD(DC).handles.radio_std3,'value',1);
        
        SILLSFIG_UPDATE;
                
    elseif get(STD(DC).handles.radio_std3,'value') == 1

        searchdestroy = findobj(gcf,'facecolor',[.9 .9 1]); 
        delete(searchdestroy); %get rid of the current patch

        if xpos1_std(1) < xlow;
            xpos1_std(1) = xlow;
        end

        if xpos2_std(1) > xhigh;
            xpos2_std(1) = xhigh;
        end

         %%%%%%% test for overlapping windows %%%%%%%%%
        
        % set up a matrix containing all other windows
        OLAP = STD(DC).bgwindow;
        minn = min(xval1_std,xval2_std);
        maxx = max(xval1_std,xval2_std);
        for c = 1:size(OLAP,1)
            if (OLAP(c,1) <= minn && minn <= OLAP(c,2)) || (OLAP(c,1) <= maxx && maxx <= OLAP(c,2))
                msgbox('Overlapping integration windows. Please select again','SILLS Warning');
                return
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        STD(DC).handles.h_sigpatch = patch('faces',[1 2 3 4],...
            'vertices',[xpos1_std(1) STD(DC).YLim_orig(1);xpos2_std(1) STD(DC).YLim_orig(1);xpos2_std(1) STD(DC).YLim_orig(2);xpos1_std(1) STD(DC).YLim_orig(2)],...
            'EdgeColor','none','facecolor',[.9 .9 1],'FaceAlpha',0.2);

        STD(DC).sigwindow(1,:) = [min(xval1_std,xval2_std) max(xval1_std,xval2_std)];
        
        %update the display values in the SILLS Control Panel
        
        set(STD(DC).handles.h_stdsig_userfrom,'string',STD(DC).sigwindow(1,1),'Value',STD(DC).sigwindow(1,1));
        set(STD(DC).handles.h_stdsig_userto,'string',STD(DC).sigwindow(1,2),'Value',STD(DC).sigwindow(1,2));
        set(STD(DC).handles.h_stdsig_total,'string',STD(DC).sigwindow(2)-STD(DC).sigwindow(1));

        SILLSFIG_UPDATE;
    end
    clear xpos1_std xpos2_std std_timediff1 std_timediff2 diff1_std diff2_std cell1_std cell2_std xval1_std xval2_std
    clear searchdestroy xrange xlow xhigh yrange ylow yhigh OLAP minn maxx c
end

A.DC = DC;
clear DC currentfig stdtags