%SILLSOPEN.m
%Created in 1.0.3, before it was an internal Callback

delquery = questdlg('Would you like to save the current project?','SILLS Query','Yes','No','Yes');
if strcmp(delquery,'Yes');
    A.sillsdir = pwd; %Changed in 1.0.4
    [A.sillsfile,A.sillsdir] = uiputfile([A.sillsdir '/*.mat'],'Save Project to File',100,100);
    if A.sillsfile == 0;
        figure(SCP.handles.h_fig);
        return;
    else
        sillsworkspace = [A.sillsdir A.sillsfile];
        save(sillsworkspace);
    end;
end

for c = 1:50;
    delete(gcf);
end;

clear all;
A.sillsdir = pwd; %Changed in 1.0.4
[A.sillsfile,A.sillsdir] = uigetfile([A.sillsdir '/*.mat'],'Browse for Project',100,100);

if A.sillsfile == 0;
    delete(gcf);
    SILLS;
else                                                  %i.e. open project
    sillsworkspace = [A.sillsdir A.sillsfile];
    load(sillsworkspace);
    HANDLEPURGE;

    if isempty(A.STDPOPUPLIST);
        set(SCP.handles.h_currentSTD_popup,'string','< load a standard >');
        A.DC = [];
    else
        set(SCP.handles.h_currentSTD_popup,'string',A.STDPOPUPLIST,'Value',A.DC);
        set(SCP.handles.h_currentSTD_SRM_out,'string',A.SRMPOPUPLIST,'Value',A.MC);
    end;

    if isempty(A.UNKPOPUPLIST);
        set(SCP.handles.h_currentUNK_popup,'string','< load an unknown >');
        A.KC = [];
    else
        set(SCP.handles.h_currentUNK_popup,'string',A.UNKPOPUPLIST,'Value',A.KC);
    end

    set(SCP.handles.h_fig,'name',['SILLS Project: ' A.sillsfile]);
    SILLSFIG_UPDATE;

    if strcmp(A.input_type,'cts') == 1; %Added in 1.0.2
        set(SCP.handles.cps,'checked','off');
        set(SCP.handles.counts,'checked','on');
    else
        set(SCP.handles.cps,'checked','on');
        set(SCP.handles.counts,'checked','off');
    end

    if strcmp(A.timeformat,'hhmm') == 1; %Added in 1.0.2
        set(SCP.handles.drifthhmm,'checked','on');
        set(SCP.handles.driftpoints,'checked','off');
    else
        set(SCP.handles.drifthhmm,'checked','off');
        set(SCP.handles.driftpoints,'checked','on');
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Check for variables added after 1.0.0

    if ~isfield(A,'dummy'); %Added in 1.0.2
        A.dummy = 0.1;
    end

    if ~isfield(A,'LODff'); %Added in 1.0.2
        A.LODff = 3;
    end

    if ~isfield(A,'cpsonly'); %Added in 1.0.3
        A.cpsonly = 0;
    end

    if ~isfield(A,'ratios'); %Added in 1.0.3
        A.ratios.index = [];
        A.ratios.show = [];
        A.ratios.num = 0;
        A.ratios.names = {};
    end

    for c = 1:A.STD_num
        if ~isfield(STD(c),'spikestatus') %Added in 1.0.1
            STD(c).spikestatus = 'undone';
        end
        if ~isfield(STD(c),'YLim_orig_element') %Added in 1.0.3
            STD(c).YLim_orig_element = [];
        end
    end

    for c = 1:A.UNK_num
        if ~isfield(UNK(c),'spikestatus') %Added in 1.0.1
            UNK(c).spikestatus = 'undone';
        end
        if ~isfield(UNK(c),'YLim_orig_element') %Added in 1.0.3
            UNK(c).YLim_orig_element = [];
        end
    end

    clear c SILLSOPEN sillsworkspace %Added in 1.0.4
end







