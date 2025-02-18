%%%%%%%%%% UNKPICKER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Transformed from function to script in 1.0.5
%Simplified in 1.0.5

currentfig = get(gcf,'UserData'); %find out which unknown we are dealing with
unktags = [UNK.order_opened]; %list all the unknowns available, using their order_opened tags
KC = find(unktags == currentfig); %make the current unknown the one just selected via clicking its graph.


if get(UNK(KC).handles.radio_unk1,'value') == 1
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

    xpos1_unk = get(gca,'CurrentPoint'); %button down detected
    
    %Abort if user clicked outside the plot axes % Added in 1.0.5
    if strcmp(get(gca,'tag'),'UNK.handles.h_unklegend')
        return
    elseif xpos1_unk(1,1) < xlow || xpos1_unk(1,1) > xhigh || xpos1_unk(1,2) < ylow || xpos1_unk(1,2) > yhigh
        return
    end

    rbbox;
    xpos2_unk = get(gca,'CurrentPoint'); %button up detected

    xpos1_unk = xpos1_unk(1,1:2);
    unk_timediff1 = abs((UNK(KC).data(:,1))-xpos1_unk(1,1));
    [diff1_unk,cell1_unk] = min(unk_timediff1);
    xval1_unk = UNK(KC).data(cell1_unk,1);

    xpos2_unk = xpos2_unk(1,1:2);
    unk_timediff2 = abs((UNK(KC).data(:,1))-xpos2_unk(1,1));
    [diff2_unk,cell2_unk] = min(unk_timediff2);
    xval2_unk = UNK(KC).data(cell2_unk,1);

    if get(UNK(KC).handles.radio_unk2,'value') == 1

        searchdestroy = findobj(gcf,'facecolor',[.9 .9 .9]);
        delete(searchdestroy); %get rid of the current patch

        if xpos1_unk(1) < xlow;
            xpos1_unk(1) = xlow;
        end

        if xpos2_unk(1) > xhigh;
            xpos2_unk(1) = xhigh;
        end

        %%%%%%% test for overlapping windows %%%%%%%%%

        % set up a matrix containing all other windows
        OLAP = [UNK(KC).mat1window; UNK(KC).mat2window; UNK(KC).comp1window; UNK(KC).comp2window; UNK(KC).comp3window];
        minn = min(xval1_unk,xval2_unk);
        maxx = max(xval1_unk,xval2_unk);
        for c = 1:size(OLAP,1)
            if (OLAP(c,1) <= minn && minn <= OLAP(c,2)) || (OLAP(c,1) <= maxx && maxx <= OLAP(c,2))
                msgbox('Overlapping integration windows. Please select again','SILLS Warning');
                return
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        UNK(KC).handles.h_bgpatch = patch('faces',[1 2 3 4],'vertices',[xpos1_unk(1) UNK(KC).YLim_orig(1);xpos2_unk(1) UNK(KC).YLim_orig(1);xpos2_unk(1) UNK(KC).YLim_orig(2);xpos1_unk(1) UNK(KC).YLim_orig(2)],...
            'EdgeColor','none','facecolor',[.9 .9 .9],'FaceAlpha',0.2);

        UNK(KC).bgwindow = [min(xval1_unk,xval2_unk) max(xval1_unk,xval2_unk)];
        %update the display values
        set(findobj('UserData',['bgfrom' -1000*UNK(KC).order_opened]),'string',UNK(KC).bgwindow(1),'Value',UNK(KC).bgwindow(1));
        set(findobj('UserData',['bgto' -1000*UNK(KC).order_opened]),'string',UNK(KC).bgwindow(2),'Value',UNK(KC).bgwindow(2));
        set(UNK(KC).handles.h_unkbg_total,'string',UNK(KC).bgwindow(2)-UNK(KC).bgwindow(1));
        set(UNK(KC).handles.radio_unk5,'value',1);

        SILLSFIG_UPDATE;

    elseif get(UNK(KC).handles.radio_unk3,'value') == 1

        searchdestroy = findobj(gcf,'facecolor',[.9 1 .9]);
        delete(searchdestroy); %get rid of the current patch

        if xpos1_unk(1) < xlow;
            xpos1_unk(1) = xlow;
        end

        if xpos2_unk(1) > xhigh;
            xpos2_unk(1) = xhigh;
        end

        %%%%%%% test for overlapping windows %%%%%%%%%

        % set up a matrix containing all other windows
        OLAP = [UNK(KC).bgwindow; UNK(KC).mat2window; UNK(KC).comp1window; UNK(KC).comp2window; UNK(KC).comp3window];
        minn = min(xval1_unk,xval2_unk);
        maxx = max(xval1_unk,xval2_unk);
        for c = 1:size(OLAP,1)
            if (OLAP(c,1) <= minn && minn <= OLAP(c,2)) || (OLAP(c,1) <= maxx && maxx <= OLAP(c,2))
                msgbox('Overlapping integration windows. Please select again','SILLS Warning');
                return
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        UNK(KC).handles.h_mat1patch = patch('faces',[1 2 3 4],...
            'vertices',[xpos1_unk(1) UNK(KC).YLim_orig(1);xpos2_unk(1) UNK(KC).YLim_orig(1);xpos2_unk(1) UNK(KC).YLim_orig(2);xpos1_unk(1) UNK(KC).YLim_orig(2)],...
            'EdgeColor','none','facecolor',[.9 1 .9],'FaceAlpha',0.2);

        UNK(KC).mat1window(1,:) = [min(xval1_unk,xval2_unk) max(xval1_unk,xval2_unk)];
        %update the display values in the SILLS Control Panel

        set(UNK(KC).handles.h_unkmat1_userfrom,'string',UNK(KC).mat1window(1,1),'Value',UNK(KC).mat1window(1,1));
        set(UNK(KC).handles.h_unkmat1_userto,'string',UNK(KC).mat1window(1,2),'Value',UNK(KC).mat1window(1,2));
        set(UNK(KC).handles.h_unkmat1_total,'string',UNK(KC).mat1window(2)-UNK(KC).mat1window(1));

        SILLSFIG_UPDATE;

    elseif get(UNK(KC).handles.radio_unk4,'value') == 1

        searchdestroy = findobj(gcf,'facecolor',[.8 1 .8]);
        delete(searchdestroy); %get rid of the current patch

        if xpos1_unk(1) < xlow;
            xpos1_unk(1) = xlow;
        end

        if xpos2_unk(1) > xhigh;
            xpos2_unk(1) = xhigh;
        end

        %%%%%%% test for overlapping windows %%%%%%%%%

        % set up a matrix containing all other windows
        OLAP = [UNK(KC).bgwindow; UNK(KC).mat1window; UNK(KC).comp1window; UNK(KC).comp2window; UNK(KC).comp3window];
        minn = min(xval1_unk,xval2_unk);
        maxx = max(xval1_unk,xval2_unk);
        for c = 1:size(OLAP,1)
            if (OLAP(c,1) <= minn && minn <= OLAP(c,2)) || (OLAP(c,1) <= maxx && maxx <= OLAP(c,2))
                msgbox('Overlapping integration windows. Please select again','SILLS Warning');
                return
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        UNK(KC).handles.h_mat2patch = patch('faces',[1 2 3 4],...
            'vertices',[xpos1_unk(1) UNK(KC).YLim_orig(1);xpos2_unk(1) UNK(KC).YLim_orig(1);xpos2_unk(1) UNK(KC).YLim_orig(2);xpos1_unk(1) UNK(KC).YLim_orig(2)],...
            'EdgeColor','none','facecolor',[.8 1 .8],'FaceAlpha',0.2);

        UNK(KC).mat2window(1,:) = [min(xval1_unk,xval2_unk) max(xval1_unk,xval2_unk)];
        %update the display values in the SILLS Control Panel

        set(UNK(KC).handles.h_unkmat2_userfrom,'string',UNK(KC).mat2window(1,1),'Value',UNK(KC).mat2window(1,1));
        set(UNK(KC).handles.h_unkmat2_userto,'string',UNK(KC).mat2window(1,2),'Value',UNK(KC).mat2window(1,2));
        set(UNK(KC).handles.h_unkmat2_total,'string',UNK(KC).mat2window(2)-UNK(KC).mat2window(1));

        SILLSFIG_UPDATE;

    elseif get(UNK(KC).handles.radio_unk5,'value') == 1

        searchdestroy = findobj(gcf,'facecolor',[.9 .9 1]);
        delete(searchdestroy); %get rid of the current patch

        if xpos1_unk(1) < xlow;
            xpos1_unk(1) = xlow;
        end

        if xpos2_unk(1) > xhigh;
            xpos2_unk(1) = xhigh;
        end

        %%%%%%% test for overlapping windows %%%%%%%%%

        % set up a matrix containing all other windows
        OLAP = [UNK(KC).bgwindow; UNK(KC).mat1window; UNK(KC).mat2window; UNK(KC).comp2window; UNK(KC).comp3window];
        minn = min(xval1_unk,xval2_unk);
        maxx = max(xval1_unk,xval2_unk);
        for c = 1:size(OLAP,1)
            if (OLAP(c,1) <= minn && minn <= OLAP(c,2)) || (OLAP(c,1) <= maxx && maxx <= OLAP(c,2))
                msgbox('Overlapping integration windows. Please select again','SILLS Warning');
                return
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        UNK(KC).handles.h_comp1patch = patch('faces',[1 2 3 4],...
            'vertices',[xpos1_unk(1) UNK(KC).YLim_orig(1);xpos2_unk(1) UNK(KC).YLim_orig(1);xpos2_unk(1) UNK(KC).YLim_orig(2);xpos1_unk(1) UNK(KC).YLim_orig(2)],...
            'EdgeColor','none','facecolor',[.9 .9 1],'FaceAlpha',0.2);

        UNK(KC).comp1window(1,:) = [min(xval1_unk,xval2_unk) max(xval1_unk,xval2_unk)];
        %update the display values in the SILLS Control Panel

        set(UNK(KC).handles.h_unkcomp1_userfrom,'string',UNK(KC).comp1window(1,1),'Value',UNK(KC).comp1window(1,1));
        set(UNK(KC).handles.h_unkcomp1_userto,'string',UNK(KC).comp1window(1,2),'Value',UNK(KC).comp1window(1,2));
        set(UNK(KC).handles.h_unkcomp1_total,'string',UNK(KC).comp1window(2)-UNK(KC).comp1window(1));

        SILLSFIG_UPDATE;

    elseif get(UNK(KC).handles.radio_unk6,'value') == 1

        searchdestroy = findobj(gcf,'facecolor',[.8 .8 1]);
        delete(searchdestroy); %get rid of the current patch

        if xpos1_unk(1) <= xlow;
            xpos1_unk(1) = xlow;
        end

        if xpos2_unk(1) > xhigh;
            xpos2_unk(1) = xhigh;
        end

        %%%%%%% test for overlapping windows %%%%%%%%%

        % set up a matrix containing all other windows
        OLAP = [UNK(KC).bgwindow; UNK(KC).mat1window; UNK(KC).mat2window; UNK(KC).comp1window; UNK(KC).comp3window];
        minn = min(xval1_unk,xval2_unk);
        maxx = max(xval1_unk,xval2_unk);
        for c = 1:size(OLAP,1)
            if (OLAP(c,1) <= minn && minn <= OLAP(c,2)) || (OLAP(c,1) <= maxx && maxx <= OLAP(c,2))
                msgbox('Overlapping integration windows. Please select again','SILLS Warning');
                return
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        UNK(KC).handles.h_comp2patch = patch('faces',[1 2 3 4],...
            'vertices',[xpos1_unk(1) UNK(KC).YLim_orig(1);xpos2_unk(1) UNK(KC).YLim_orig(1);xpos2_unk(1) UNK(KC).YLim_orig(2);xpos1_unk(1) UNK(KC).YLim_orig(2)],...
            'EdgeColor','none','facecolor',[.8 .8 1],'FaceAlpha',0.2);

        UNK(KC).comp2window(1,:) = [min(xval1_unk,xval2_unk) max(xval1_unk,xval2_unk)];
        %update the display values in the SILLS Control Panel

        set(UNK(KC).handles.h_unkcomp2_userfrom,'string',UNK(KC).comp2window(1,1),'Value',UNK(KC).comp2window(1,1));
        set(UNK(KC).handles.h_unkcomp2_userto,'string',UNK(KC).comp2window(1,2),'Value',UNK(KC).comp2window(1,2));
        set(UNK(KC).handles.h_unkcomp2_total,'string',UNK(KC).comp2window(2)-UNK(KC).comp2window(1));

        SILLSFIG_UPDATE;

    elseif get(UNK(KC).handles.radio_unk7,'value') == 1

        searchdestroy = findobj(gcf,'facecolor',[.7 .7 1]);
        delete(searchdestroy); %get rid of the current patch

        if xpos1_unk(1) <= xlow;
            xpos1_unk(1) = xlow;
        end

        if xpos2_unk(1) > xhigh;
            xpos2_unk(1) = xhigh;
        end

        %%%%%%% test for overlapping windows %%%%%%%%%

        % set up a matrix containing all other windows
        OLAP = [UNK(KC).bgwindow; UNK(KC).mat1window; UNK(KC).mat2window; UNK(KC).comp1window; UNK(KC).comp2window];
        minn = min(xval1_unk,xval2_unk);
        maxx = max(xval1_unk,xval2_unk);
        for c = 1:size(OLAP,1)
            if (OLAP(c,1) <= minn && minn <= OLAP(c,2)) || (OLAP(c,1) <= maxx && maxx <= OLAP(c,2))
                msgbox('Overlapping integration windows. Please select again','SILLS Warning');
                return
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        UNK(KC).handles.h_comp3patch = patch('faces',[1 2 3 4],...
            'vertices',[xpos1_unk(1) UNK(KC).YLim_orig(1);xpos2_unk(1) UNK(KC).YLim_orig(1);xpos2_unk(1) UNK(KC).YLim_orig(2);xpos1_unk(1) UNK(KC).YLim_orig(2)],...
            'EdgeColor','none','facecolor',[.7 .7 1],'FaceAlpha',0.2);

        UNK(KC).comp3window(1,:) = [min(xval1_unk,xval2_unk) max(xval1_unk,xval2_unk)];
        %update the display values in the SILLS Control Panel

        set(UNK(KC).handles.h_unkcomp3_userfrom,'string',UNK(KC).comp3window(1,1),'Value',UNK(KC).comp3window(1,1));
        set(UNK(KC).handles.h_unkcomp3_userto,'string',UNK(KC).comp3window(1,2),'Value',UNK(KC).comp3window(1,2));
        set(UNK(KC).handles.h_unkcomp3_total,'string',UNK(KC).comp3window(2)-UNK(KC).comp3window(1));

        SILLSFIG_UPDATE;
    end
    clear yrange ylow yhigh xrange xlow xhigh xpos1_unk xpos2_unk unk_timediff1 unk_timediff2 diff1_unk diff2_unk cell1_unk cell2_unk
    clear xval1_unk xval2_unk searchdestroy OLAP minn maxx c
end

A.KC = KC;
clear KC currentfig unktags
