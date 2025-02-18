%spike_finish.m
%Part of spike elimination tool
%Executed when button Finish is clicked or the scan ran through all spikes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Create white empty figure
clf(spikefig);
set(spikefig,'Color','w');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Display title
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if modus == 1
    sumtit = uicontrol(spikefig,'Units','Normalized','Style','text','Position',[0.02 0.97 0.98 0.02],...
        'HorizontalAlignment','left','FontWeight','bold','FontSize',10,'BackgroundColor','w',...
        'String',['Spike elimination summary for unknown ' UNK(A.KC).fileinfo.name]);
else
    sumtit = uicontrol(spikefig,'Units','Normalized','Style','text','Position',[0.02 0.97 0.98 0.02],...
        'HorizontalAlignment','left','FontWeight','bold','FontSize',10,'BackgroundColor','w',...
        'String',['Spike elimination summary for standard ' STD(A.DC).fileinfo.name]);
end

uicontrol(spikefig,'Units','Normalized','Style','text','Position',[0.02 0.95 0.98 0.015],... %Changed in 1.0.5
             'HorizontalAlignment','left','FontWeight','normal','FontSize',8,'BackgroundColor','w',...
             'String',sprintf('%s%d\n%s','Parameters: Lower threshold: ',threshold ,...
             ' Outlier detection based on Grubbs for 7 and 9 timeslices assuming normal distribution and detecting only highly significant outliers!!'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initialize variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

counter(1,:) = []; % 1st row is empty (element counter starts at 2)
summary = []; % array of entries for each element

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Creating summary
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%for the case no spikes were found
if sum(counter(:,1)) == 0
    summary = sprintf('%s\n\n%s','No spikes were found in this dataset',...
        'if you think there are, try to set a lower threshold or a smaller minimal factor');
    
%Creating summary for normal case
else
    for i = 1:el-1
        if modus == 1
            summary = [summary sprintf('%s%s%d%s%d%s%d%s\n',UNK(A.KC).colheaders{1,i+1},': ',counter(i,1),...
                ' Spikes identified, ',counter(i,2),' corrected, ',counter(i,3),' ignored')];
        else
            summary = [summary sprintf('%s%s%d%s%d%s%d%s\n',STD(A.DC).colheaders{1,i+1},': ',counter(i,1),...
                ' Spikes identified, ',counter(i,2),' corrected, ',counter(i,3),' ignored')];
        end
    end

    %if Finish was clicked before all spikes were seen add remark and set
    %status to aborted
    if modus == 1
        if el < size(UNK(A.KC).data,2)
            summary = [summary sprintf('\n%s\n','Spike elimination aborted by user')];
            UNK(A.KC).spikestatus = 'aborted';
        else
            UNK(A.KC).spikestatus = 'finished';
        end
    else
        if el < size(STD(A.DC).data,2)
            summary = [summary sprintf('\n%s\n','Spike elimination aborted by user')];
            STD(A.DC).spikestatus = 'aborted';
        else
            STD(A.DC).spikestatus = 'finished';
        end
    end
end

%Add remark
summary = [summary sprintf('\n%s','This window can be closed without losing changes')];
    
%Display summary
uicontrol(spikefig,'Units','Normalized','Style','text','Position',[0.02 0.05 0.98 0.88],...
             'HorizontalAlignment','left','FontWeight','normal','FontSize',8,'BackgroundColor','w',...
             'String',summary);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Update SILLS Unknown / Standard plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Changed in 1.0.5

if modus == 1
    UNK(A.KC).figure_state = 'shut';
    delete(UNK(A.KC).handles.h_unkfig);
    A.K = A.K - 1;
    UNKPLOT
else
    STD(A.DC).figure_state = 'shut';
    delete(STD(A.DC).handles.h_stdfig);
    A.D = A.D - 1;
    STDPLOT
end

figure(spikefig)

uiresume; %Moved to end in 1.0.3