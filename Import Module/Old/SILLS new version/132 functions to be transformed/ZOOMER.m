%%%%%%%%%%%% ZOOMER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Transformed from function to script in 1.0.5

set(gcf,'Units','Pixels');

xrange = get(gca,'XLim'); %original x range
xlow = xrange(1);
xhigh = xrange(2);

yrange = get(gca,'YLim'); %original y range
ylow = yrange(1);
yhigh = yrange(2);

pos1 = get(gca,'CurrentPoint');
    
%Abort if user clicked outside the plot axes % Added in 1.0.5
if strcmp(get(gca,'tag'),'STD.handles.h_stdlegend') || strcmp(get(gca,'tag'),'UNK.handles.h_unklegend')
    return
elseif pos1(1,1) < xlow || pos1(1,1) > xhigh || pos1(1,2) < ylow || pos1(1,2) > yhigh
    return
end

rbbox;
pos2 = get(gca,'CurrentPoint');

coordinates = [pos1(1,1:2);pos2(1,1:2)];

xmin = min(coordinates(:,1));
xmax = max(coordinates(:,1));
ymin = min(coordinates(:,2));
ymax = max(coordinates(:,2));

    if xmin < xlow;
        xmin = xlow;
    end
    
    if xmax > xhigh;
        xmax = xhigh;
    end

    if ymin < ylow;
        ymin = ylow;
    end
    
    if ymax > yhigh;
        ymax = yhigh;
    end

set(gca,'XLim',[xmin xmax],'YLim',[ymin ymax]);

clear xrange xlow xhigh yrange ylow yhigh
clear pos1 pos2 coordinates xmin xmax ymin ymax