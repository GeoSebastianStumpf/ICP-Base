%AUTOTIME.m
%
%This script retrieves the standard and unknown times from the file info
%Added in 1.0.5

%Display question dialog
question = {'This option retrieves the times of the measurements from the time the data file hase been created.';...
    'Already entered times will be kept, Time format will be changed to real clock time.';...
    'If you load additional data files from now on, repeat this command before starting calculations.';...
    'It is recommended to check the times for plausibility.';...
    'Do you want to continue?'};
answer = questdlg(question,'Automatic Time Retrieval','Yes','No','Yes');

%abort if No or close button is clicked
if strcmp(answer,'No') == 1 || isempty(answer)
    clear question answer
    return
end

%Get standard times
for i=1:A.STD_num
    if isempty(STD(i).mm)
        datum = STD(i).fileinfo.date;
        if strcmp(STD(i).fileinfo.ext,'.FIN2')
            index = findstr(datum,':');
            index_hh = [index(1)-2 index(1)-1];
            index_mm = [index(1)+1 index(1)+2];  
        else 
            index = findstr(datum,' ');
            index_hh = [index+1 index+2];
            index_mm = [index+4 index+5];
        end
        STD(i).hh = datum(index_hh);
        STD(i).mm = datum(index_mm);
    end
end

%Get unknown times
for i=1:A.UNK_num
    if isempty(UNK(i).mm)
        datum = UNK(i).fileinfo.date;
        if strcmp(UNK(i).fileinfo.ext,'.FIN2')
            index = findstr(datum,':');
            index_hh = [index(1)-2 index(1)-1];
            index_mm = [index(1)+1 index(1)+2];  
        else   
            index = findstr(datum,' ');
            index_hh = [index+1 index+2];
            index_mm = [index+4 index+5];
        end

        UNK(i).hh = datum(index_hh);
        UNK(i).mm = datum(index_mm);
    end
end

%Set time format to hhmm
A.timeformat = 'hhmm';
set(SCP.handles.driftpoints,'checked','off');
set(SCP.handles.drifthhmm,'checked','on');

%Update SILLS main control window
set(SCP.handles.h_currentSTD_drifthh_edit,'Visible','on','string',STD(A.DC).hh);
set(SCP.handles.h_currentSTD_driftcolon,'Visible','on');
set(SCP.handles.h_currentSTD_driftmm_edit,'Visible','on','string',STD(A.DC).mm);
set(SCP.handles.h_currentSTD_driftpoints_popup,'Visible','off');

clear question answer i datum index index_hh index_mm
