% CALIBPLOT

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following script produces three visualisation figures:
%
% (1) relative sensitivity plot (cps/ppm X vs. cps/ppm Y)
% (2) relative sensitivity time series (for visualising the time standards
% and unknowns were taken
% (3) drift bar plot (% change in relative sensitivity relative to an
% internal standard
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initial Checks 
% Modified in 1.0.6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if A.STD_num == 0
    msgbox('Please load standards before proceeding','SILLS Message');
    A.warning = 1;
    return
elseif A.UNK_num == 0
    msgbox('Please load unknowns before proceeding','SILLS Message');
    A.warning = 1;
    return
elseif sum(A.DT_VALUES) == 0
    msgbox('Please set dwell times before proceeding','SILLS Message');
    A.warning = 1;    
    return
end

for c = 1:A.STD_num

    if isempty(STD(c).bgwindow) || isempty(STD(c).sigwindow)
        msgbox(['Please select background and signal integration windows for standard ' num2str(c)],'SILLS Message');
        A.warning = 1;    
        return
    end

    if STD(c).bgwindow(2) - STD(c).bgwindow(1) == 0
        msgbox(['Please check background integration windows for standard ' num2str(c)],'SILLS Message');
        A.warning = 1;    
        return
    end

    if STD(c).sigwindow(2) - STD(c).sigwindow(1) == 0
        msgbox(['Please check signal integration windows for standard ' num2str(c)],'SILLS Message');
        A.warning = 1;    
        return
    end

    if strcmp(A.timeformat,'hhmm')==1
        if isempty(STD(c).hh) || isempty(STD(c).mm)
            msgbox(['Please specify times for standard ' num2str(c)],'SILLS Message');
            A.warning = 1;    
            return
        end
    end
end

for c = 1:A.UNK_num

    if isempty(UNK(c).bgwindow) || UNK(c).bgwindow(2) - UNK(c).bgwindow(1) == 0
        msgbox(['Please check background integration windows for unknown ' num2str(c)],'SILLS Message');
        A.warning = 1;    
        return
    end

    if UNK(c).mattotal == 0 && UNK(c).sigtotal == 0
        msgbox(['Define a matrix or signal window for unknown ' num2str(c)],'SILLS Message');
        A.warning = 1;    
        return
    end
 
    if strcmp(A.timeformat,'hhmm')==1
        if isempty(UNK(c).hh) || isempty(UNK(c).mm)
            msgbox(['Please specify times for unknown ' num2str(c)],'SILLS Message');
            A.warning = 1;    
            return
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close current CALIBPLOT windows.
searchdestroy = findobj('tag','SILLS Calibration Graphs');
delete(searchdestroy);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pass the raw data through intitial treatment steps
DATAFILTER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%set up the SMAN figure and its components

CAL = struct('h_CAL',[],'figparts',[],'handles',[],'menuitems',[],'figure_state','open');
CAL.handles = struct('h_CALIBPLOT',[]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CREATE THE FIGURE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isempty(A.sillsfile)
    name = 'Untitled';
else
    name = A.sillsfile;
end

CAL.h_CAL =         figure('name',['Calibration Graphs: ' name],'tag','SILLS Calibration Graphs','UserData',10000000,...
    'Color',[0 0 0],'NumberTitle','off','position',[110*sf(1) 130*sf(2) 1250*sf(1) 800*sf(2)],'menubar','none');

clear name;

A.CALIBPLOT_open = 1; %variable that says whether the window is open or not.


%..........................................................................
% Set up frames
%CAL.handles.h_CALframe2 =     uipanel(CAL.h_CAL,'units','pixels','BackgroundColor',[1 1 1],'ForegroundColor',[1 1 1],'BorderWidth',0,'position',[510*sf(1) 20*sf(2) 670*sf(1) 760*sf(2)]);

%..........................................................................
% Create a matrix of sensitivities for each standard
% Moved into DATADRIFT.m in 1.2.0
% for c = 1:A.STD_num
%     STD(c).CPSPPM = (STD(c).sig_cps - STD(c).bg_cps)./STD(c).SRM_concs;
% end

% Concatenate the STD.CPSPPM matrices
CAL.CPSPPM = [];
for c = 1:A.STD_num
    CAL.CPSPPM = [CAL.CPSPPM;STD(c).CPSPPM];
end

%..........................................................................
%create a matrix of timepoints for the standards and unknowns

if strcmp(A.timeformat,'integer_points')==1
    CAL.STD_TIMES = A.STD_TIMES;
    CAL.UNK_TIMES = A.UNK_TIMES;
elseif strcmp(A.timeformat,'hhmm')==1
    CAL.STD_TIMES = [];
    for c = 1:A.STD_num
        CAL.STD_hh(c) = str2num(STD(c).hh);
        CAL.STD_mm(c) = str2num(STD(c).mm);
        CAL.STD_hourfraction(c) = str2num(STD(c).mm)/60;
        CAL.STD_TIMES = [CAL.STD_TIMES (CAL.STD_hh(c) + CAL.STD_hourfraction(c))];
    end
    CAL.UNK_TIMES = [];
    for c = 1:A.UNK_num
        CAL.UNK_hh(c) = str2num(UNK(c).hh);
        CAL.UNK_hourfraction(c) = str2num(UNK(c).mm)/60;
        CAL.UNK_TIMES = [CAL.UNK_TIMES (CAL.UNK_hh(c) + CAL.UNK_hourfraction(c))];
    end
end


%..........................................................................
% FIGURE 1

CAL.handles.h_FIG1_xaxis_text1 = uicontrol(CAL.h_CAL,'style','text','string','Define a drift correction standard:','BackgroundColor',[0 0 0],'ForegroundColor',[1 1 1],'Fontweight','bold','position',[100*sf(1) 385*sf(2) 200*sf(1) 20*sf(2)]);
CAL.handles.h_FIG1_xaxis_text2 = uicontrol(CAL.h_CAL,'style','text','string','(assumed to undergo no drift)','BackgroundColor',[0 0 0],'ForegroundColor',[1 1 1],'position',[100*sf(1) 370*sf(2) 200*sf(1) 20*sf(2)]);
CAL.handles.h_FIG1_xaxis_text3 = uicontrol(CAL.h_CAL,'style','text','string','cps/ppm','BackgroundColor',[0 0 0],'ForegroundColor',[1 1 1],'position',[320*sf(1) 405*sf(2) 55*sf(1) 20*sf(2)]);
CAL.handles.h_FIG1_xaxis_popup = uicontrol(CAL.h_CAL,'style','popup','tag','fig1x','string',A.ISOTOPES_in_all_SRMs,'Value',A.REFIS_list_index,'Callback','CALSET','BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'position',[320*sf(1) 385*sf(2) 55*sf(1) 20*sf(2)]);

CAL.handles.h_FIG1_yaxis_text = uicontrol(CAL.h_CAL,'style','text','string','cps/ppm','BackgroundColor',[0 0 0],'ForegroundColor',[1 1 1],'position',[15*sf(1) 600*sf(2) 55*sf(1) 20*sf(2)]);
CAL.handles.h_FIG1_yaxis_popup = uicontrol(CAL.h_CAL,'style','popup','tag','fig1y','string',A.ISOTOPE_list,'Value',A.CAL_yisotope,'Callback','CALSET','BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],'position',[15*sf(1) 580*sf(2) 55*sf(1) 20*sf(2)]);

CAL.fig1x = CAL.CPSPPM(:,A.REFIS);
CAL.fig1y = CAL.CPSPPM(:,A.CAL_yisotope);

%determine the range for the plot (the origin (0,0) will always be shown);
CAL.fig1xrange = zeros(2,A.STD_num);
CAL.fig1xrange(2,:) = 1.2*CAL.fig1x;
CAL.fig1yrange = zeros(2,A.STD_num);
CAL.fig1yrange(2,:) = 1.2*CAL.fig1y;

subplot(2,2,1);plot(CAL.fig1xrange,CAL.fig1yrange,CAL.fig1x,CAL.fig1y,'o','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 1 1],'MarkerSize',8);
set(gca,'units','pixels','XGrid','on','YGrid','on','position',[100*sf(1) 450*sf(2) 500*sf(1) 300*sf(2)],'XColor',[1 1 1],'YColor',[1 1 1],'FontSize',8,'Color',[0.8 0.8 0.8]);
title('RELATIVE SENSITIVITY','Color',[1 1 1],'Fontweight','Bold');
legend(A.STDPOPUPLIST,'location','SouthEast');

%show the relative sensitivies for each standard
CAL.handles.h_frame1 = uipanel(CAL.h_CAL,'units','pixels','BackgroundColor',[.9 .9 .9],'ForeGroundColor',[.9 .9 .9],'position',[100*sf(1) 50*sf(2) 500*sf(1) 300*sf(2)]);

CAL.handles.h_FIG1_STD_header = uicontrol(CAL.h_CAL,'style','text','string','Standards','position',[120*sf(1) 325*sf(2) 120*sf(1) 20*sf(2)],'BackgroundColor',[.9 .9 .9],'ForegroundColor',[0 0 0],'HorizontalAlignment','center');
CAL.handles.h_FIG1_SRM_header = uicontrol(CAL.h_CAL,'style','text','string','SRM','position',[245*sf(1) 315*sf(2) 100*sf(1) 30*sf(2)],'BackgroundColor',[.9 .9 .9],'ForegroundColor',[0 0 0],'HorizontalAlignment','center');
CAL.handles.h_FIG1_TIME_header = uicontrol(CAL.h_CAL,'style','text','string','Time','position',[350*sf(1) 315*sf(2) 80*sf(1) 30*sf(2)],'BackgroundColor',[.9 .9 .9],'ForegroundColor',[0 0 0],'HorizontalAlignment','center');
CAL.handles.h_FIG1_relsens_header1 = uicontrol(CAL.h_CAL,'style','text','string','Relative Sensitivities',...
    'position',[435*sf(1) 330*sf(2) 160*sf(1) 15*sf(2)],'BackgroundColor',[.9 .9 .9],'ForegroundColor',[0 0 0],'HorizontalAlignment','center');
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
    if strcmp(A.timeformat,'integer_points')==1
        CAL.handles.h_FIG1_TIMES(c) = uicontrol(CAL.h_CAL,'style','text','string',CAL.STD_TIMES(c),'position',[350*sf(1) (310-15*c)*sf(2) 80*sf(1) 15*sf(2)],'BackgroundColor',[.9 .9 .9],'ForegroundColor',fontcolor,'HorizontalAlignment','center');
    else
        hh = num2str(CAL.STD_hh(c));
        mm = num2str(CAL.STD_mm(c));
        if strcmp(mm,'0') ==1
            mm = '00';
        end
        timestring = [hh ':' mm];
        CAL.handles.h_FIG1_TIMES(c) = uicontrol(CAL.h_CAL,'style','text','string',timestring,'position',[350*sf(1) (310-15*c)*sf(2) 80*sf(1) 15*sf(2)],'BackgroundColor',[.9 .9 .9],'ForegroundColor',fontcolor,'HorizontalAlignment','center');
    end
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

%ok, now we are in a position to plot the data

CAL.fig2x1 = CAL.STD_TIMES;
CAL.fig2y1 = CAL.STD_REFIS_CALIB(A.CAL_yisotope,:);
CAL.fig2x2 = CAL.UNK_TIMES;
CAL.fig2y2 = CAL.UNK_REFIS_CALIB(A.CAL_yisotope,:);

%determine the time range for the plot
if min(CAL.fig2x1) < min(CAL.fig2x2);
    CAL.xmin = min(CAL.fig2x1);
else
    CAL.xmin = min(CAL.fig2x2);
end
if max(CAL.fig2x1)> min(CAL.fig2x2);
    CAL.xmax = max(CAL.fig2x1);
else
    CAL.xmax = max(CAL.fig2x2);
end
CAL.xrange = CAL.xmax - CAL.xmin;

if min(CAL.fig2x1) == max(CAL.fig2x1) && CAL.xrange == 0 %i.e. all standards and unknowns taken at the same time
    m = CAL.DRIFT_regression(A.CAL_yisotope,1);
    CAL.fig2xrange = [0 2*CAL.xmax];
    CAL.fig2yrange = [m m];
elseif min(CAL.fig2x1) == max(CAL.fig2x1) && CAL.xrange ~= 0 %i.e. stds taken at the same time / unknowns taken at different times
    m = CAL.DRIFT_regression(A.CAL_yisotope,1);
    CAL.fig2xrange = [(CAL.xmin - 0.1*CAL.xrange) (CAL.xmax + 0.1*CAL.xrange)];
    CAL.fig2yrange = [m m];
else
    CAL.fig2xrange = [(CAL.xmin - 0.1*CAL.xrange) (CAL.xmax + 0.1*CAL.xrange)];
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

clear ymin ymax yrange ystart yend
clear absmax labelpos
clear a b c d m 