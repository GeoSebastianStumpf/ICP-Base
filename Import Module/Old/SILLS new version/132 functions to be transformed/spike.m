%spike.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SPIKE ELIMINATION TOOL
%By Dimitri Meier [meierdim@student.ethz.ch] and Marcel Guillong 
%
%
%To be used as addition to SILLS
%
%Other scripts needed:
%spike_correct.m
%spike_custom.m
%spike_finish.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MAIN SCRIPT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Default Configuration Settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Feel free to change these settings

%for N=7 measurements, the comparison value for the Grubbs outlier test is based on a level of signifikance of 1%:
cpvalueseven = 2.097;

%for N=7 measurements, the comparison value for the Grubbs outlier test is based on a level of signifikance of 1%:
cpvaluenine = 2.323;
%
%values from: Rechentafeln Fur Die Chemische Analytik Von Friedrich W.Küster, Alfred Thiel, Alfred Ruland s.299,
%Frank E. Grubbs: Sample Criteria for Testing Outlying Observations. Annals of Mathematical Statistics, Vol. 21, No. 1 (Mar., 1950), pp. 27-58
%http://en.wikipedia.org/wiki/Grubbs%27_test_for_outliers
%
%
%Lower threshold for spike identification, prevents identification of a
%spike each time for sporadically occurring elements
thresholdstd = 1000; % [cps]

%Time range displayed around an identified spike
timerangestd = 20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Determine whether spike is called from a standard or unknown plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(get(gco,'tag'),'unknown') == 1 %i.e. spike was called for an unknown
    modus = 1;
else %i.e. spike was called for a standard
    modus = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Configuration settings dialog
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%repeat configuration dialog until input is numeric
wronginput = true;
while wronginput 
    %Set up dialog
    prompt = {'Enter lower threshold for spike identification:',...
              'Enter displayed time range around spikes'};
          
    default = {num2str(thresholdstd),num2str(timerangestd)};
    Options = struct('Resize','on','WindowStyle','normal');
    config = inputdlg(prompt,'Spike elimination configuration settings',1,default,Options);

    %Extract values
    threshold = str2double(config{1,1});
    timerange = str2double(config{2,1}) / 2; %timerange is added on each side, therefore /2

    %Check for numeric values
    if isnan(threshold*timerange)
        errordlg('Enter a numeric value!','Spike Error');
        uiwait
    else
        wronginput = false;
    end
end
clear wronginput prompt default Options config thresholdstd timerangestd;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PART 1: UNKNOWN
if modus == 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Check if button was clicked from an unknown plot which is not the current
%unknown, if yes, set this unknown as the new current unknown
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(UNK(A.KC).fileinfo.name,get(gcf,'Tag')) == 0
    active = [];
    for c = 1:A.UNK_num
        active(c) = strcmp(UNK(c).fileinfo.name,get(gcf,'Tag'));
    end
    A.KC = find(active,1);
    clear active c;
    set(SCP.handles.h_currentUNK_popup,'Value',A.KC);
    SILLSFIG_UPDATE
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Set up window and buttons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spikefig = figure('name',['Unknown (' UNK(A.KC).fileinfo.name ') Spike Elimination'],'tag',UNK(A.KC).fileinfo.name,... %Added tag in 1.0.3
    'units','pixels','NumberTitle','off','MenuBar','none','position',[30*sf(1) 130*sf(2) 770*sf(1) 850*sf(2)],...
    'CloseRequestFcn','clear spikeaxis correctbutton ignorebutton finishbutton time average orig corr timerange val value default prompt tstep customdef custombutton spikefig counter i threshold summary el modus c C csp onebefore twobefore oneafter twoafter sumtit threebefore threeafter meansix stdsix fourafter fourbefore cpvaluenine cpvalueseven meannine meanseven stdnine stdseven;delete(gcf);');

spikeaxis = axes('Units','Normalized','OuterPosition',[0 0.15 1 0.85],'YScale','log','Nextplot','add','Box','on'); %Changed in 1.0.3
if ~isempty(UNK(A.KC).YLim_orig_element)
    set(spikeaxis,'YLim',UNK(A.KC).YLim_orig_element)
else
    set(spikeaxis,'YLim',UNK(A.KC).YLim_orig)
end

uicontrol(spikefig,'Units','Normalized','Style','text','Position',[0.05 0.1 0.55 0.05],...
    'HorizontalAlignment','center','FontWeight','bold','FontSize',12,'BackgroundColor',get(spikefig,'Color'),...
    'String','What do you want to do with this identified spike?');

correctbutton = uicontrol(spikefig,'Units','Normalized','Style','pushbutton','String','Correct',...
    'Position',[0.05 0.05 0.2 0.05],'Callback','spike_correct','FontSize',12);

custombutton = uicontrol(spikefig,'Units','Normalized','Style','pushbutton','String','Custom value',...
    'Position',[0.28 0.05 0.2 0.05],'Callback','spike_custom','FontSize',12);

ignorebutton = uicontrol(spikefig,'Units','Normalized','Style','pushbutton','String','Ignore',...
    'Position',[0.52 0.05 0.2 0.05],'Callback','counter(el,3)=counter(el,3)+1;uiresume;','FontSize',12);

finishbutton = uicontrol(spikefig,'Units','Normalized','Style','pushbutton','String','Finish',...
    'Position',[0.75 0.05 0.2 0.05],'Callback','spike_finish','FontSize',12);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initialize some variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

customdef = zeros(size(UNK(A.KC).data)); 
counter = zeros(size(UNK(A.KC).data,2),3); %1st column identified, 2nd corrected, 3rd ignored

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Identify spikes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%loop through elements
for el= 2:size(UNK(A.KC).data,2)

    %loop through timesteps
    tstep = 5;
    while tstep < size(UNK(A.KC).data,1)-4
        
        %Exclude data below threshold
        if UNK(A.KC).data(tstep,el) > threshold
            
            %CONDITION FOR SPIKE IDENTIFICATION
            csp = UNK(A.KC).data(tstep,el); %current spike
            onebefore = UNK(A.KC).data(tstep-1,el);
            oneafter = UNK(A.KC).data(tstep+1,el);
            twobefore = UNK(A.KC).data(tstep-2,el);
            twoafter = UNK(A.KC).data(tstep+2,el);
            threebefore = UNK(A.KC).data(tstep-3,el);
            threeafter = UNK(A.KC).data(tstep+3,el);
            fourafter = UNK(A.KC).data(tstep+4,el);
            fourbefore = UNK(A.KC).data(tstep-4,el);
          
            %Changed in 1.0.5
            stdseven = std([onebefore, oneafter, twoafter, twobefore, threebefore, threeafter, csp]);
            meanseven = (onebefore + oneafter + twoafter + twobefore + threebefore + threeafter + csp) / 7;
            stdnine = std([onebefore, oneafter, twoafter, twobefore, threebefore, threeafter, fourafter, fourbefore, csp]);
            meannine = (onebefore + oneafter + twoafter + twobefore + threebefore + threeafter + fourafter + fourbefore + csp) / 9;
            
            if ((abs(csp - meanseven))/stdseven) > cpvalueseven && ((abs(csp - meannine))/stdnine) > cpvaluenine % Grubbs outlier test based on r(alpha) 1% "value is highly significant to be an outlier"

                time = UNK(A.KC).data(tstep,1);
                counter(el,1) = counter(el,1) + 1;
                average = (onebefore + oneafter + twoafter + twobefore + threebefore + threeafter) / 6; %Standard correction value (average)
                val = average;

                %Plotting data
                cla(spikeaxis);

                plot(UNK(A.KC).data(:,1),UNK(A.KC).data(:,2:end)); %all data

                orig = plot(UNK(A.KC).data(:,1),UNK(A.KC).data(:,el),'-ob','MarkerFaceColor','b','LineWidth',3,...
                    'DisplayName',['Measured ' UNK(A.KC).colheaders{1,el}]); %original data

                corr = plot(UNK(A.KC).data(tstep-1:tstep+1,1),[UNK(A.KC).data(tstep-1,el) val UNK(A.KC).data(tstep+1,el)],...
                    '-ok','MarkerFaceColor','k','LineWidth',3,'DisplayName',['Corrected ' UNK(A.KC).colheaders{1,el}]); %corrected data

                %set display limit
                if time-timerange < 0
                    xlim([0 2*timerange]);
                elseif time+timerange > UNK(A.KC).data(end,1)
                    xlim([UNK(A.KC).data(end,1)-2*timerange UNK(A.KC).data(end,1)]);
                else
                    xlim([time-timerange time+timerange]);
                end

                legend([orig corr],'Location','North','Orientation','Horizontal');
                title(['Spike Elimination for unknown ' UNK(A.KC).fileinfo.name ': ' UNK(A.KC).colheaders{1,el}],'FontSize',12);

                uiwait(spikefig); %wait for user's choice
                if exist('summary','var') == 1 %i.e. spike_finish was called; Added in 1.0.3
                    return
                end 
            end
        end
        tstep = tstep + 1;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PART 2: STANDARD
else
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Check if button was clicked from a standard plot which is not the current
%standard, if yes, set this standard as the new current standard
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(STD(A.DC).fileinfo.name,get(gcf,'Tag')) == 0
    active = [];
    for c = 1:A.STD_num
        active(c) = strcmp(STD(c).fileinfo.name,get(gcf,'Tag'));
    end
    A.DC = find(active,1);
    clear c active;
    set(SCP.handles.h_currentSTD_popup,'Value',A.DC);
    SILLSFIG_UPDATE
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Set up window and buttons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spikefig = figure('name',['Standard (' STD(A.DC).fileinfo.name ') Spike Elimination'],'tag',STD(A.DC).fileinfo.name,... %Added tag in 1.0.3
    'units','pixels','NumberTitle','off','MenuBar','none','position',[30*sf(1) 130*sf(2) 770*sf(1) 850*sf(2)],...
     'CloseRequestFcn','clear spikeaxis correctbutton ignorebutton finishbutton time average orig corr timerange val value default prompt tstep customdef custombutton spikefig counter i threshold summary el modus c C csp onebefore twobefore oneafter twoafter sumtit threebefore threeafter meansix stdsix fourafter fourbefore cpvaluenine cpvalueseven meannine meanseven stdnine stdseven;delete(gcf);');

spikeaxis = axes('Units','Normalized','OuterPosition',[0 0.15 1 0.85],'YScale','log','Nextplot','add','Box','on'); %Changed in 1.0.3
if ~isempty(STD(A.DC).YLim_orig_element)
    set(spikeaxis,'YLim',STD(A.DC).YLim_orig_element)
else
    set(spikeaxis,'YLim',STD(A.DC).YLim_orig)
end

uicontrol(spikefig,'Units','Normalized','Style','text','Position',[0.05 0.1 0.55 0.05],...
    'HorizontalAlignment','center','FontWeight','bold','FontSize',12,'BackgroundColor',get(spikefig,'Color'),...
    'String','What do you want to do with this identified spike?');

correctbutton = uicontrol(spikefig,'Units','Normalized','Style','pushbutton','String','Correct',...
    'Position',[0.05 0.05 0.2 0.05],'Callback','spike_correct','FontSize',12);

custombutton = uicontrol(spikefig,'Units','Normalized','Style','pushbutton','String','Custom value',...
    'Position',[0.28 0.05 0.2 0.05],'Callback','spike_custom','FontSize',12);

ignorebutton = uicontrol(spikefig,'Units','Normalized','Style','pushbutton','String','Ignore',...
    'Position',[0.52 0.05 0.2 0.05],'Callback','counter(el,3)=counter(el,3)+1;uiresume;','FontSize',12);

finishbutton = uicontrol(spikefig,'Units','Normalized','Style','pushbutton','String','Finish',...
    'Position',[0.75 0.05 0.2 0.05],'Callback','spike_finish','FontSize',12);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initialize some variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

customdef = zeros(size(STD(A.DC).data)); 
counter = zeros(size(STD(A.DC).data,2),3); %1st column identified, 2nd corrected, 3rd ignored

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Identify spikes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%loop through elements
for el= 2:size(STD(A.DC).data,2)

    %loop through timesteps
    tstep = 5;
    while tstep < size(STD(A.DC).data,1)-4
        
        %Exclude data below threshold
        if STD(A.DC).data(tstep,el) > threshold
            
           
            %CONDITION FOR SPIKE IDENTIFICATION
            csp = STD(A.DC).data(tstep,el); %current spike
            onebefore = STD(A.DC).data(tstep-1,el);
            oneafter = STD(A.DC).data(tstep+1,el);
            twobefore = STD(A.DC).data(tstep-2,el);
            twoafter = STD(A.DC).data(tstep+2,el);
            threebefore = STD(A.DC).data(tstep-3,el);
            threeafter = STD(A.DC).data(tstep+3,el);
            fourafter = STD(A.DC).data(tstep+4,el);
            fourbefore = STD(A.DC).data(tstep-4,el);
            
            %Changed in 1.0.5
            stdseven = std([onebefore, oneafter, twoafter, twobefore, threebefore, threeafter, csp]);
            meanseven = (onebefore + oneafter + twoafter + twobefore + threebefore + threeafter + csp) / 7;
            stdnine = std([onebefore, oneafter, twoafter, twobefore, threebefore, threeafter, fourafter, fourbefore, csp]);
            meannine = (onebefore + oneafter + twoafter + twobefore + threebefore + threeafter + fourafter + fourbefore + csp) / 9;
            
            if ((abs(csp - meanseven))/stdseven) > cpvalueseven && ((abs(csp - meannine))/stdnine) > cpvaluenine % Grubbs outlier test based on r(alpha) 1% "value is highly significant to be an outlier"
            
                time = STD(A.DC).data(tstep,1);
                counter(el,1) = counter(el,1) + 1;
                average = (onebefore + oneafter + twoafter + twobefore + threebefore + threeafter) / 6 ; %Standard correction value (average)
                val = average;

                %Plotting data
                cla(spikeaxis);

                plot(STD(A.DC).data(:,1),STD(A.DC).data(:,2:end)); %all data

                orig = plot(STD(A.DC).data(:,1),STD(A.DC).data(:,el),'-ob','MarkerFaceColor','b','LineWidth',3,...
                    'DisplayName',['Measured ' STD(A.DC).colheaders{1,el}]); %original data

                corr = plot(STD(A.DC).data(tstep-1:tstep+1,1),[STD(A.DC).data(tstep-1,el) val STD(A.DC).data(tstep+1,el)],...
                    '-ok','MarkerFaceColor','k','LineWidth',3,'DisplayName',['Corrected ' STD(A.DC).colheaders{1,el}]); %corrected data

                %set display limit
                if time-timerange < 0
                    xlim([0 2*timerange]);
                elseif time+timerange > STD(A.DC).data(end,1)
                    xlim([STD(A.DC).data(end,1)-2*timerange STD(A.DC).data(end,1)]);
                else
                    xlim([time-timerange time+timerange]);
                end

                legend([orig corr],'Location','North','Orientation','Horizontal');
                title(['Spike Elimination for standard ' STD(A.DC).fileinfo.name ': ' STD(A.DC).colheaders{1,el}],'FontSize',12);

                uiwait(spikefig); %wait for user's choice
                if exist('summary','var') == 1 %i.e. spike_finish was called; Added in 1.0.3
                    return
                end                                    
            end
        end
        tstep = tstep + 1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Finish
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
spike_finish