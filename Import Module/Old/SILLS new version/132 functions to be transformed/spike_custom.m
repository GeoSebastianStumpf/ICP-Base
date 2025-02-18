%spike_custom.m
%Part of spike elimination tool
%Executed when button Custom value is clicked
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Check if Custom was already run for this certain element and timestep
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if customdef(tstep,el) == 0
    %if not, put average as default value
    customdef(tstep,el) = round(average);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Dialog
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

default = {num2str(customdef(tstep,el))};
prompt = {sprintf('%s%d\n%s','Average value:',round(average),'Enter custom value:')};
value = inputdlg(prompt,'Define custom value',1,default,'on');

%Extracting value if not canceled
if size(value,1) ~= 0
    val = str2double(value{1,1});
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Check for numeric value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isnan(val)
   val = average;
   errordlg('Enter a numeric value!','Spike Error');
   uiwait;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Saving value for the case Custom is repeated for the same element and timestep
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

customdef(tstep,el) = round(val);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Update spike plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

axes(spikeaxis);
delete(corr);
if modus == 1
    corr = plot(UNK(A.KC).data(tstep-1:tstep+1,1),[UNK(A.KC).data(tstep-1,el) val UNK(A.KC).data(tstep+1,el)],...
        '-ok','MarkerFaceColor','k','LineWidth',3,'DisplayName',['Corrected ' UNK(A.KC).colheaders{1,el}]);
else
    corr = plot(STD(A.DC).data(tstep-1:tstep+1,1),[STD(A.DC).data(tstep-1,el) val STD(A.DC).data(tstep+1,el)],...
    '-ok','MarkerFaceColor','k','LineWidth',3,'DisplayName',['Corrected ' STD(A.DC).colheaders{1,el}]);
end

