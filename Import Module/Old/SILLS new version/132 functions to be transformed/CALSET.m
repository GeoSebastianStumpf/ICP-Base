%CALSET

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This callback is summoned by activating the drop-down lists in Figure 1 
% of the 'Calibration Graphs' window. This script adjusts the appearance of 
% the graphs according to the user input.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%determine which popup was activated
currentaxis = get(gco,'tag');

if strcmp(currentaxis,'fig1x')==1;

    A.REFIS_list_index = get(gco,'value');
    temp = A.ISOTOPES_in_all_SRMs(A.REFIS_list_index);
    temp2 = strcmp(A.ISOTOPE_list,temp);
    A.REFIS = find(temp2==1);

    CAL.fig1x = CAL.CPSPPM(:,A.REFIS);
    DATADRIFT;
    
elseif strcmp(currentaxis,'fig1y')==1;
    
    A.CAL_yisotope = get(gco,'value');
    CAL.fig1y = CAL.CPSPPM(:,A.CAL_yisotope);
    
end

CAL.fig1xrange = zeros(2,A.STD_num);
CAL.fig1xrange(2,:) = 1.2*CAL.fig1x;
CAL.fig1yrange = zeros(2,A.STD_num);
CAL.fig1yrange(2,:) = 1.2*CAL.fig1y;


subplot(2,2,1);plot(CAL.fig1xrange,CAL.fig1yrange,CAL.fig1x,CAL.fig1y,'o','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 1 1],'MarkerSize',8);
set(gca,'units','pixels','XGrid','on','YGrid','on','position',[100*sf(1) 450*sf(2) 500*sf(1) 300*sf(2)],'XColor',[1 1 1],'YColor',[1 1 1],'FontSize',8,'Color',[0.8 0.8 0.8]);
title('RELATIVE SENSITIVITY','Color',[1 1 1],'Fontweight','Bold');
legend(A.STDPOPUPLIST,'location','SouthEast');

CAL.handles.h_FIG1_relsens_header2 = uicontrol(CAL.h_CAL,'style','text','string',['cps/ppm ' char(A.ISOTOPE_list(A.CAL_yisotope)) ' / cps/ppm ' char(A.ISOTOPE_list(A.REFIS))],...
    'position',[435*sf(1) 315*sf(2) 160*sf(1) 15*sf(2)],'BackgroundColor',[.9 .9 .9],'ForegroundColor',[0 0 0],'HorizontalAlignment','center');

colorindex = get(legend,'colororder');
if A.STD_num > 7 %Added in 1.0.6
   colorindex = vertcat(colorindex,colorindex); 
end

for c = 1:A.STD_num
    fontcolor = colorindex(c,:);
    CAL.handles.h_FIG1_STD(c) = uicontrol(CAL.h_CAL,'style','text','string',A.STDPOPUPLIST(c),'position',[120*sf(1) (310-15*c)*sf(2) 120*sf(1) 15*sf(2)],'BackgroundColor',[.9 .9 .9],'ForegroundColor',fontcolor,'HorizontalAlignment','center');
    srm = STD(c).SRM;
    CAL.handles.h_FIG1_SRM(c) = uicontrol(CAL.h_CAL,'style','text','string',SRM(srm).name,'position',[245*sf(1) (310-15*c)*sf(2) 100*sf(1) 15*sf(2)],'BackgroundColor',[.9 .9 .9],'ForegroundColor',fontcolor,'HorizontalAlignment','center');
    CAL.handles.h_FIG1_TIMES(c) = uicontrol(CAL.h_CAL,'style','text','string',CAL.STD_TIMES(c),'position',[350*sf(1) (310-15*c)*sf(2) 80*sf(1) 15*sf(2)],'BackgroundColor',[.9 .9 .9],'ForegroundColor',fontcolor,'HorizontalAlignment','center');
    slope = STD(c).CPSPPM(A.CAL_yisotope)/STD(c).CPSPPM(A.REFIS);
    CAL.handles.h_FIG1_slope(c) = uicontrol(CAL.h_CAL,'style','text','string',slope,'position',[435*sf(1) (310-15*c)*sf(2) 160*sf(1) 15*sf(2)],'BackgroundColor',[.9 .9 .9],'ForegroundColor',fontcolor,'HorizontalAlignment','center');   
end

clear colorindex fontcolor srm slope cal_axes

%..........................................................................
% FIGURE 2

%normalise the A.STD_REFIS_CALIB and A.UNK_REFIS_CALIB matrices to the the current xaxis isotope
CAL.STD_REFIS_CALIB = zeros(A.ISOTOPE_num,A.STD_num);
CAL.UNK_REFIS_CALIB = zeros(A.ISOTOPE_num,A.UNK_num);
for c = 1:A.ISOTOPE_num
    CAL.STD_REFIS_CALIB(c,:) = A.STD_REFIS_CALIB(c,:)./A.STD_REFIS_CALIB(A.REFIS,:);
    CAL.UNK_REFIS_CALIB(c,:) = A.UNK_REFIS_CALIB(c,:)./A.UNK_REFIS_CALIB(A.REFIS,:);
end

%For the purpose of plotting, define the linear regression through
%the standards' calibration slopes. If there is only one standard, or if
%all standards were defined at the same time, the average calibration slope is used.

timetest = A.STD_TIMES - A.STD_TIMES(1); %see if all standards were collected at the same time

CAL.DRIFT_regression = zeros(A.ISOTOPE_num,2);
if sum(timetest) == 0 %i.e. one standard, or all stds taken at the same time
    for c = 1:A.ISOTOPE_num
        CAL.DRIFT_regression(c,1) = mean(CAL.STD_REFIS_CALIB(c,:));
        CAL.DRIFT_regression(c,2) = 0;
    end
else
    for c = 1:A.ISOTOPE_num
        CAL.DRIFT_regression(c,:) = polyfit(CAL.STD_TIMES,CAL.STD_REFIS_CALIB(c,:),1);
    end
end
clear timetest


CAL.fig2x1 = CAL.STD_TIMES;
CAL.fig2y1 = CAL.STD_REFIS_CALIB(A.CAL_yisotope,:);
CAL.fig2x2 = CAL.UNK_TIMES;
CAL.fig2y2 = CAL.UNK_REFIS_CALIB(A.CAL_yisotope,:);

if min(CAL.fig2x1) == max(CAL.fig2x1) && CAL.xrange == 0 %i.e. all standards and unknowns taken at the same time
    m = CAL.DRIFT_regression(A.CAL_yisotope,1);
    CAL.fig2xrange = [0 2*CAL.xmax];
    CAL.fig2yrange = [m m];
elseif min(CAL.fig2x1) == max(CAL.fig2x1) && CAL.xrange ~= 0 %i.e. stds taken at the same time / unknowns taken at different times
    m = CAL.DRIFT_regression(A.CAL_yisotope,1);
    CAL.fig2xrange = [(CAL.xmin - 0.1*CAL.xrange) (CAL.xmax + 0.1*CAL.xrange)];
    CAL.fig2yrange = [m m];
else
    CAL.fig2CAL.xrange = [(CAL.xmin - 0.1*CAL.xrange) (CAL.xmax + 0.1*CAL.xrange)];
    m = CAL.DRIFT_regression(A.CAL_yisotope,1);
    b = CAL.DRIFT_regression(A.CAL_yisotope,2);
    CAL.fig2yrange = [(m*(CAL.fig2xrange(1)) + b) (m*(CAL.fig2xrange(2)) + b)];
end

%determine the range in y data
if min(CAL.fig2y1) < min(CAL.fig2y2);
    ymin = min(CAL.fig2y1);
else
    ymin = min(CAL.fig2y2);
end
if max(CAL.fig2y1) > max(CAL.fig2y2);
    ymax = max(CAL.fig2y1);
else
    ymax = max(CAL.fig2y2);
end
yrange = ymax - ymin;

if CAL.STD_REFIS_CALIB(A.CAL_yisotope,1)/CAL.STD_REFIS_CALIB(A.CAL_yisotope,1) == 1 && CAL.STD_REFIS_CALIB(A.REFIS,1)/CAL.STD_REFIS_CALIB(A.REFIS,1) == 1

    subplot(2,2,2);plot(CAL.fig2xrange,CAL.fig2yrange,CAL.fig2x1,CAL.fig2y1,'o',CAL.fig2x2,CAL.fig2y2,'o');
    CAL.fig2children = get(gca,'children');
    set(CAL.fig2children(1),'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 1 0.3],'MarkerSize',8);
    set(CAL.fig2children(2),'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 1 1],'MarkerSize',8);
    if yrange ~= 0;
        set(gca,'YLim',[(ymin - 0.5*yrange) (ymax + 0.5*yrange)]);
    else 
        set(gca,'YLim',[0 2*ymin]);
    end
    set(gca,'XLim',[CAL.fig2xrange(1) CAL.fig2xrange(2)]);
    set(gca,'units','pixels','XGrid','on','YGrid','on','position',[700*sf(1) 450*sf(2) 500*sf(1) 300*sf(2)],'XColor',[1 1 1],'YColor',[1 1 1],'FontSize',8,'Color',[0.8 0.8 0.8]);
    if strcmp(A.timeformat,'integer_points') == 1
        xlabel('Time (integer time divisions)');
    else
        xlabel('Time (hours)');
    end
    ylabel(['cps/ppm ' char(A.ISOTOPE_list(A.CAL_yisotope)) ' / cps/ppm ' char(A.ISOTOPE_list(A.REFIS))]);
    title('DRIFT IN RELATIVE SENSITIVITY','Color',[1 1 1],'Fontweight','Bold');
    legend('DRIFT TREND','STANDARDS','UNKNOWNS','location','SouthEast');

else
    subplot(2,2,2)
    set(gca,'units','pixels','XGrid','on','YGrid','on','position',[700*sf(1) 450*sf(2) 500*sf(1) 300*sf(2)],'XColor',[1 1 1],'YColor',[1 1 1],'FontSize',8,'Color',[0.8 0.8 0.8]);
    if strcmp(A.timeformat,'integer_points') == 1
        xlabel('Time (integer time divisions)');
    else
        xlabel('Time (hours)');
    end
    ylabel(['cps/ppm ' char(A.ISOTOPE_list(A.CAL_yisotope)) ' / cps/ppm ' char(A.ISOTOPE_list(A.REFIS))]);
    title('DRIFT IN RELATIVE SENSITIVITY','Color',[1 1 1],'Fontweight','Bold');

end

%..........................................................................
% FIGURE 3

%determine the % change in relative sensitivity for each isotope

%determine the % change in relative sensitivity for each isotope

for c = 1:A.ISOTOPE_num
    if min(CAL.fig2x1) ~= max(CAL.fig2x1) %i.e. standards taken at different times
        yend = CAL.DRIFT_regression(c,1)*CAL.xmax + CAL.DRIFT_regression(c,2);
        ystart = CAL.DRIFT_regression(c,1)*CAL.xmin + CAL.DRIFT_regression(c,2);
        CAL.DRIFT_percent(c) = 100*((yend - ystart)/ystart);
    else
        CAL.DRIFT_percent(c) = 0;
    end
end

if CAL.STD_REFIS_CALIB(A.CAL_yisotope,1)/CAL.STD_REFIS_CALIB(A.CAL_yisotope,1) == 1 && CAL.STD_REFIS_CALIB(A.REFIS,1)/CAL.STD_REFIS_CALIB(A.REFIS,1) == 1

subplot(2,2,4);bar(1:A.ISOTOPE_num,CAL.DRIFT_percent);
set(gca,'units','pixels','YGrid','on','position',[700*sf(1) 50*sf(2) 500*sf(1) 300*sf(2)],'XColor',[1 1 1],'YColor',[1 1 1],'FontSize',8,'Color',[0.8 0.8 0.8]);

ymax = max(CAL.DRIFT_percent);
ymin = min(CAL.DRIFT_percent);
if abs(ymin) < ymax
    absmax = ymax;
else
    absmax = abs(ymin);
end

if absmax == 0
    absmax = 1;
end

set(gca,'YLim',[-1.5*absmax 1.5*absmax]);
labelpos = zeros(1,A.ISOTOPE_num);
labelpos(:) = absmax;

text(1:A.ISOTOPE_num,1.1*labelpos,A.ISOTOPE_list,'fontsize',8,'rotation',90,'HorizontalAlignment','left');
text(1:A.ISOTOPE_num,-1.4*labelpos,A.ISOTOPE_list,'fontsize',8,'rotation',90,'HorizontalAlignment','left');
xlabel('Isotopes');
ylabel(['% change in sensitivity relative to ' char(A.ISOTOPE_list(A.REFIS))]);
title('% DRIFT IN RELATIVE SENSITIVITY','Color',[1 1 1],'Fontweight','Bold');

else
    subplot(2,2,4)
    set(gca,'units','pixels','YGrid','on','position',[700*sf(1) 50*sf(2) 500*sf(1) 300*sf(2)],'XColor',[1 1 1],'YColor',[1 1 1],'FontSize',8,'Color',[0.8 0.8 0.8],'XLim',[0,A.ISOTOPE_num],'YLim',[-100 100]);
    xlabel('Isotopes');
    ylabel(['% change in sensitivity relative to ' char(A.ISOTOPE_list(A.REFIS))]);
    title('% DRIFT IN RELATIVE SENSITIVITY','Color',[1 1 1],'Fontweight','Bold');
end

clear currentaxis 
clear ymin ymax yrange ystart yend
clear absmax labelpos
clear a b c d m 