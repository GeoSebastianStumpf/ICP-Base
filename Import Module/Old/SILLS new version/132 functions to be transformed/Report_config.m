%Report_Config.m
%
%This script is summoned during the REPORT_WRITE script. It displays the
%composition of the samples and allows the user to choose which items are
%printed in the report.
%It was created because some users preferred other items to appear in the
%report.
%The displayed summary allows a quick decision if the results are useful
%without opening Excel and if not, cancel the action.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Default selection: Feel free to modify
%1 means these values appear in the report by default
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

reportcfg = struct('relsens',0,...  Standard relative sensitivity
    'sampconc',1,...                Sample concentration summary
    'samperr',0,...                 Sample error summary
    'samplod',1,...                 Sample LOD summary
    'sampinmix',0,...               Sample in mixed signal (cps)
    'mixcps',0,...                  Mixed signal (cps)              %added in 1.3.0
    'hostconc',1,...                Host concentration summary
    'hosterr',0,...                 Host error summary
    'hostlod',0,...                 Host LOD summary
    'hostcps',0,...                 Host (cps)                      %Added in 1.0.2
    'bgcps',0,...                   Background (cps)
    'bgstdev',0,...                 Background standard deviation(cps)%Added in 1.3.0
    'stdcps',0,...                  Standard (cps)                  %Added in 1.0.2
    'ratios',0,...                  Ratios (cps/cps)                %Added in 1.0.3
    'individual',0,...              Individual analyses in detail
    'x',0,...                       x (Mass ratio inclusion / total)%Added in 1.1.1
    'yield',1,...                   Ablation yield                  %Added in 1.2.0                     
    'nsweeps',0);%                  # sweeps integrationen        %Added in 1.3.0; Renamed 1.3.2 

if A.cpsonly == 1
    reportcfg.relsens = 0;
    reportcfg.sampconc = 0;
    reportcfg.samperr = 0;
    reportcfg.samplod = 0;
    reportcfg.sampinmix = 1;
    reportcfg.mixcps = 1;
    reportcfg.hostconc = 0;
    reportcfg.hosterr = 0;
    reportcfg.hostlod = 0;
    reportcfg.hostcps = 1;
    reportcfg.bgcps = 1;
    reportcfg.bgstdev = 0;
    reportcfg.stdcps = 1;
    reportcfg.ratios = 1;
    reportcfg.x = 0;
    reportcfg.yield = 0;
    reportcfg.nsweeps = 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initialize
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
abort = 0; %This value changes to 1 if the figure is closed or cancel is clicked
repfig = figure('name','Report Settings','CloseRequestFcn','abort=1;delete(repfig)','units','pixels','NumberTitle','off','MenuBar','none','position',[30*sf(1) 130*sf(2) 1300*sf(1) 900*sf(2)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Creating preview table (added in 1.2.0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
previewpanel = uipanel('units','pixels','title','Preview of concentrations in ppm','BackgroundColor',get(repfig,'color'),'Position',[20*sf(1) 20*sf(2) 1050*sf(1) 860*sf(2)]);
previewtable = uitable(previewpanel,'Units','pixels','Position',[0 0 1048*sf(1) 840*sf(2)],'Enable','inactive','ColumnName',A.ISOTOPE_list,'RowName',A.UNKPOPUPLIST);

data = cell(A.UNK_num,A.ISOTOPE_num);
for c = 1:A.UNK_num
    for el = 1:A.ISOTOPE_num
        if A.cpsonly == 1
            data(c,el) = {UNK(c).samp_cps(el)};
        elseif UNK(c).SAMP_CONC(el) >= UNK(c).SAMP_LOD_mn(el) 
            data(c,el) = {UNK(c).SAMP_CONC(el)};
        elseif UNK(c).SAMP_CONC(el) < UNK(c).SAMP_LOD_mn(el)
            data(c,el) = {[char(60) num2str(UNK(c).SAMP_LOD_mn(el))]};
        else %i.e. no signal window
            data(c,el) = {'--'};
        end
    end
end
set(previewtable,'Data',data)
clear data c el
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Creating selection buttons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

repselection = uipanel('units','pixels','title','Print in report','backgroundcolor',get(repfig,'color'),'Position',[1100*sf(1) 210*sf(2) 180*sf(1) 670*sf(2)]); %Changed all positions in 1.0.3 / 1.1.1 / 1.2.0  / 1.3.0

relsens =    uicontrol('style','togglebutton','value',reportcfg.relsens,   'Callback','reportcfg.relsens=get(relsens,''Value'');',      'parent',repselection,'String','SRM Relative Sensitivity','Position',[10*sf(1) 600*sf(2) 160*sf(1) 30*sf(2)]);
sampconc =   uicontrol('style','togglebutton','value',reportcfg.sampconc,  'Callback','reportcfg.sampconc=get(sampconc,''Value'');',    'parent',repselection,'String','Sample Concentrations',   'Position',[10*sf(1) 565*sf(2) 160*sf(1) 30*sf(2)]);
samperr =    uicontrol('style','togglebutton','value',reportcfg.samperr,   'Callback','reportcfg.samperr=get(samperr,''Value'');',      'parent',repselection,'String','Sample Errors',           'Position',[10*sf(1) 530*sf(2) 160*sf(1) 30*sf(2)]);
samplod =    uicontrol('style','togglebutton','value',reportcfg.samplod,   'Callback','reportcfg.samplod=get(samplod,''Value'');',      'parent',repselection,'String','Sample LOD',              'Position',[10*sf(1) 495*sf(2) 160*sf(1) 30*sf(2)]);
sampinmix =  uicontrol('style','togglebutton','value',reportcfg.sampinmix, 'Callback','reportcfg.sampinmix=get(sampinmix,''Value'');',  'parent',repselection,'String','Sample in Mix (cps)',     'Position',[10*sf(1) 460*sf(2) 160*sf(1) 30*sf(2)]);
mixcps =     uicontrol('style','togglebutton','value',reportcfg.mixcps,    'Callback','reportcfg.mixcps=get(mixcps,''Value'');',        'parent',repselection,'String','Mix (cps)',               'Position',[10*sf(1) 425*sf(2) 160*sf(1) 30*sf(2)]); %Added in 1.3.0
hostconc =   uicontrol('style','togglebutton','value',reportcfg.hostconc,  'Callback','reportcfg.hostconc=get(hostconc,''Value'');',    'parent',repselection,'String','Host Concentrations',     'Position',[10*sf(1) 390*sf(2) 160*sf(1) 30*sf(2)]);
hosterr =    uicontrol('style','togglebutton','value',reportcfg.hosterr,   'Callback','reportcfg.hosterr=get(hosterr,''Value'');',      'parent',repselection,'String','Host Errors',             'Position',[10*sf(1) 355*sf(2) 160*sf(1) 30*sf(2)]);
hostlod =    uicontrol('style','togglebutton','value',reportcfg.hostlod,   'Callback','reportcfg.hostlod=get(hostlod,''Value'');',      'parent',repselection,'String','Host LOD',                'Position',[10*sf(1) 320*sf(2) 160*sf(1) 30*sf(2)]);
hostcps =    uicontrol('style','togglebutton','value',reportcfg.hostcps,   'Callback','reportcfg.hostcps=get(hostcps,''Value'');',      'parent',repselection,'String','Host (cps)',              'Position',[10*sf(1) 285*sf(2) 160*sf(1) 30*sf(2)]); %Added in 1.0.2
bgcps =      uicontrol('style','togglebutton','value',reportcfg.bgcps,     'Callback','reportcfg.bgcps=get(bgcps,''Value'');',          'parent',repselection,'String','Background (cps)',        'Position',[10*sf(1) 250*sf(2) 160*sf(1) 30*sf(2)]);
bgstdev =    uicontrol('style','togglebutton','value',reportcfg.bgstdev,   'Callback','reportcfg.bgstdev=get(bgstdev,''Value'');',      'parent',repselection,'String','BG stdev (cps)',          'Position',[10*sf(1) 215*sf(2) 160*sf(1) 30*sf(2)]);
stdcps =     uicontrol('style','togglebutton','value',reportcfg.stdcps,    'Callback','reportcfg.stdcps=get(stdcps,''Value'');',        'parent',repselection,'String','Standards (cps)',         'Position',[10*sf(1) 180*sf(2) 160*sf(1) 30*sf(2)]); %Added in 1.0.2
ratios =     uicontrol('style','togglebutton','value',reportcfg.ratios,    'Callback','reportcfg.ratios=get(ratios,''Value'');',        'parent',repselection,'String','Ratios (cps/cps)',        'Position',[10*sf(1) 145*sf(2) 160*sf(1) 30*sf(2)]);  %Added in 1.0.3
x =          uicontrol('style','togglebutton','value',reportcfg.x,         'Callback','reportcfg.x=get(x,''Value'');',                  'parent',repselection,'String','x: Mass ratio Sample/Mix','Position',[10*sf(1) 110*sf(2) 160*sf(1) 30*sf(2)]);
yield =      uicontrol('style','togglebutton','value',reportcfg.yield,     'Callback','reportcfg.yield=get(yield,''Value'');',          'parent',repselection,'String','Ablation yield (-)',      'Position',[10*sf(1) 75*sf(2) 160*sf(1) 30*sf(2)]);  %Added in 1.1.1
nsweeps =    uicontrol('style','togglebutton','value',reportcfg.nsweeps,   'Callback','reportcfg.nsweeps=get(nsweeps,''Value'');',      'parent',repselection,'String','sweeps (BG, Sig, Host)',  'Position',[10*sf(1) 40*sf(2) 160*sf(1) 30*sf(2)]);  %Added in 1.2.0
individual = uicontrol('style','togglebutton','value',reportcfg.individual,'Callback','reportcfg.individual=get(individual,''Value'');','parent',repselection,'String','Individual analyses',     'Position',[10*sf(1) 5*sf(2) 160*sf(1) 30*sf(2)]);  %Added in 1.2.0

d = 0; e = 0;
for c = 1:A.UNK_num
    if UNK(c).MAT_corrtype ~= 1
        d = d+1;
    end
    if UNK(c).MAT_corrtype ~= 1 && UNK(c).SIG_constraint2 ~= 1
        e = e+1;
    end
end
%Disable buttons concerning host if no matrix has been defined
if d == 0
    set(hostconc,'value',0,'enable','off'); reportcfg.hostconc = 0;
    set(hosterr,'value',0,'enable','off');  reportcfg.hosterr = 0;
    set(hostlod,'value',0,'enable','off');  reportcfg.hostlod = 0;
    set(hostcps,'value',0,'enable','off');  reportcfg.hostcps = 0;
    set(x,'value',0,'enable','off');        reportcfg.x = 0;
end
%Disable sample in mix and yield when no samp_cps is calculated (i.e. complex
%quantification scheme; Added in 1.1.1/1.2.0
if e == A.UNK_num
    set(sampinmix,'value',0,'enable','off'); reportcfg.sampinmix = 0;
    set(yield,'value',0,'enable','off');     reportcfg.yield = 0;
end
clear c d e

%Disable buttons except cps when only cps is selected
if A.cpsonly == 1
    set(sampconc,'value',0,'enable','off');   reportcfg.sampconc = 0;
    set(samperr,'value',0,'enable','off');    reportcfg.samperr = 0;
    set(samplod,'value',0,'enable','off');    reportcfg.samplod = 0;
    set(relsens,'value',0,'enable','off');    reportcfg.relsens = 0;
    set(hostconc,'value',0,'enable','off');   reportcfg.hostconc = 0;
    set(hosterr,'value',0,'enable','off');    reportcfg.hosterr = 0;
    set(hostlod,'value',0,'enable','off');    reportcfg.hostlod = 0;
    set(individual,'value',0,'enable','off'); reportcfg.individual = 0;
    set(x,'value',0,'enable','off');          reportcfg.x = 0;
    set(yield,'value',0,'enable','off');      reportcfg.yield = 0;
    %Rename preview title
    set(previewpanel,'title','Preview of sample background-corrected cps');
end

%Disable ratios when no ratios are defined
if A.ratios.num == 0
    set(ratios,'value',0,'enable','off'); reportcfg.ratios = 0;
end

% %Disable x, yield nsweeps when sampconc is deselected
% if reportcfg.sampconc == 0
%     set(x,'value',0,'enable','off');          reportcfg.x = 0;
%     set(yield,'value',0,'enable','off');      reportcfg.yield = 0;
%     set(nsweeps,'value',0,'enable','off');    reportcfg.nsweeps = 0;
% end  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Creating other buttons (scroll buttons removed in 1.2.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

createbutton = uicontrol('style','pushbutton','String','Create Report','Callback','delete(repfig)','FontWeight','bold','Position',[1110*sf(1) 100*sf(2) 160*sf(1) 30*sf(2)]);
cancelbutton = uicontrol('style','pushbutton','String','Cancel','Callback','abort=1;delete(repfig)','Position',[1110*sf(1) 60*sf(2) 160*sf(1) 30*sf(2)]);

uiwait(repfig); %Wait for user