function EasyPlotCloseRequestFcn(~,src, ~)
% Call the public function of the app
try
    % cleanupObjPB = onCleanup(@() close(src));
    delete(src);
    MinPlotXEasyPlot_public_update(EasyPlotModule)
catch
    delete(src);
end

% Delete the figure
end