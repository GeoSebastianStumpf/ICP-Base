function EasyPlotCloseRequestFcn(src,event)

if isgraphics(src)
    mainapp = getappdata(src,'mainapp');
end

try
    delete(src);
catch
    keyboard
end

% Standalone mode
if isempty(mainapp)
    %return
end
try

% If mainapp already destroyed → exit safely
if isnumeric(mainapp) || ~isvalid(mainapp)
    EPM=EasyPlotModule;
    EPM.MinPlotXEasyPlot_public_update;
else
        EPM=EasyPlotModule(mainapp);
    EPM.MinPlotXEasyPlot_public_update;
end

catch ME
    DisplayError(ME)
end
end