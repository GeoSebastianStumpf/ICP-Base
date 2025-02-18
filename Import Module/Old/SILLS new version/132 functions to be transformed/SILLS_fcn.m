function SILLS_fcn
%This is a function that calls the SILLS main script
%It is used for the standalone version only
%It can be ignored in the script version
%Added in 1.0.4

fprintf('\n\n%s\n\n%s\n%s\n',...
    'Loading SILLS...',...
    'Do NOT close this window while working with SILLS.',...
    'All unsaved data will be lost')

SILLS

%Assign global variables to base workspace
%Added in 1.0.6
assignin('base','sf',sf);
assignin('base','SMAN',SMAN);
assignin('base','STD',STD);
assignin('base','UNK',UNK);
assignin('base','A',A);
assignin('base','SRM',SRM);
assignin('base','SCP',SCP);

assignin('base','SILLSNEW',SILLSNEW);
assignin('base','SILLSSAVE',SILLSSAVE);
assignin('base','SILLSEXIT',SILLSEXIT);
assignin('base','SILLSINPUT',SILLSINPUT);
assignin('base','TIMEPT_STDASSIGN',TIMEPT_STDASSIGN);

