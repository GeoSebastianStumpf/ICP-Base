function [ax2plot,options_definition,legend_str]=plot_ratio_XYZ_data_fun(T,ax2plot,options)

[~,options_definition]=plot_XYZ_fun([],[]);

if not(exist('T','var'))
    T=[];
end
if not(exist('ax2plot','var'))
    ax2plot=[];
end
if not(exist('options','var'))
    options=[];
end

%% Plot Options definition
if  (isfield(options,'default') && options.default==true) || not(isfield(options,'plot_settings'))|| isempty(options.plot_settings)  || not(isfield(options.plot_settings,'MarkerFaceColor')) || isempty(options.plot_settings.MarkerFaceColor)
    fil=[0 0.4470 0.7410];
    options_definition.plot_settings.MarkerFaceColor=fil;
else
    fil=options.plot_settings.MarkerFaceColor;
end

if  (isfield(options,'default') && options.default==true)|| not(isfield(options,'plot_settings')) || isempty(options.plot_settings)  || not(isfield(options.plot_settings,'MarkerFaceAlpha')) || isempty(options.plot_settings.MarkerFaceAlpha) || not(isfield(options.plot_settings.MarkerFaceAlpha,'Value')) || isempty(options.plot_settings.MarkerFaceAlpha.Value)
    mfa=6/8;
    options_definition.plot_settings.MarkerFaceAlpha=mfa;
else
    mfa=options.plot_settings.MarkerFaceAlpha.Value;
end

if  (isfield(options,'default') && options.default==true) || not(isfield(options,'plot_settings'))|| isempty(options.plot_settings)  || not(isfield(options.plot_settings,'symbol')) || isempty(options.plot_settings.symbol)
    symb='o';
    options_definition.plot_settings.symbol=symb;
else
    symb=options.plot_settings.symbol;
end

if  (isfield(options,'default') && options.default==true) || not(isfield(options,'plot_settings'))|| isempty(options.plot_settings)  || not(isfield(options.plot_settings,'MarkerEdgeColor')) || isempty(options.plot_settings.MarkerEdgeColor)
    if strcmp(symb,'.')
        mec=fil;
    else
        mec=[0 0 0];
    end
    options_definition.plot_settings.MarkerEdgeColor=mec;
else
    mec=options.plot_settings.MarkerEdgeColor;

end

if  (isfield(options,'default') && options.default==true) || not(isfield(options,'plot_settings'))|| isempty(options.plot_settings)  || not(isfield(options.plot_settings,'MarkerEdgeAlpha')) || isempty(options.plot_settings.MarkerEdgeAlpha)  || not(isfield(options.plot_settings.MarkerEdgeAlpha,'Value')) || isempty(options.plot_settings.MarkerEdgeAlpha.Value)
    mea=4/8;
    options_definition.plot_settings.MarkerEdgeAlpha=mea;
else
    mea=options.plot_settings.MarkerEdgeAlpha.Value;
end

if  (isfield(options,'default') && options.default==true) || not(isfield(options,'plot_settings'))|| isempty(options.plot_settings)  || not(isfield(options.plot_settings,'MarkerLineWidth')) || isempty(options.plot_settings.MarkerLineWidth)  || not(isfield(options.plot_settings.MarkerLineWidth,'Value')) || isempty(options.plot_settings.MarkerLineWidth.Value)
    mlw=0.5;
    options_definition.plot_settings.MarkerLineWidth.Value=mlw;
else
    mlw=options.plot_settings.MarkerLineWidth.Value;
end

if  (isfield(options,'default') && options.default==true) || not(isfield(options,'plot_settings'))|| isempty(options.plot_settings)  || not(isfield(options.plot_settings,'symbol_size')) || isempty(options.plot_settings.symbol_size)
    symbsize=100;
    options_definition.plot_settings.symbol_size=symbsize;
else
    symbsize= options.plot_settings.symbol_size;
end

if isfield(options,'X1') && not(isempty(options.X1))
    A0 = T.(char(options.X1));
    if ~isnumeric(A0) && iscell(A0)
        cens      = cellfun(@(x) ischar(x) && startsWith(x, '<'), A0);
        str       = cellfun(@ischar, A0) & ~cens;
        A0(cens)  = {NaN};
        A0(str)   = num2cell(cellfun(@str2double, A0(str)));
        A0        = cell2mat(A0);
    end
else
    A0 = ones(size(T,1),1);
end

if isfield(options,'Y1') && not(isempty(options.Y1))
    B0 = T.(char(options.Y1));
    if ~isnumeric(B0) && iscell(B0)
        cens      = cellfun(@(x) ischar(x) && startsWith(x, '<'), B0);
        str       = cellfun(@ischar, B0) & ~cens;
        B0(cens)  = {NaN};
        B0(str)   = num2cell(cellfun(@str2double, B0(str)));
        B0        = cell2mat(B0);
    end
else
    B0 = ones(size(T,1),1);
end

if isfield(options,'Z1') && not(isempty(options.Z1))
    C0 = T.(char(options.Z1));
    if ~isnumeric(C0) && iscell(C0)
        cens      = cellfun(@(x) ischar(x) && startsWith(x, '<'), C0);
        str       = cellfun(@ischar, C0) & ~cens;
        C0(cens)  = {NaN};
        C0(str)   = num2cell(cellfun(@str2double, C0(str)));
        C0        = cell2mat(C0);
    end
else
    C0 = ones(size(T,1),1);
end

if isfield(options,'D1') && not(isempty(options.D1))
    D0 = T.(char(options.D1));
    if ~isnumeric(D0) && iscell(D0)
        cens      = cellfun(@(x) ischar(x) && startsWith(x, '<'), D0);
        str       = cellfun(@ischar, D0) & ~cens;
        D0(cens)  = {NaN};
        D0(str)   = num2cell(cellfun(@str2double, D0(str)));
        D0        = cell2mat(D0);
    end
else
    D0 = ones(size(T,1),1);
end

if isfield(options,'E1') && not(isempty(options.E1))
    E0 = T.(char(options.E1));
    if ~isnumeric(E0) && iscell(E0)
        cens      = cellfun(@(x) ischar(x) && startsWith(x, '<'), E0);
        str       = cellfun(@ischar, E0) & ~cens;
        E0(cens)  = {NaN};
        E0(str)   = num2cell(cellfun(@str2double, E0(str)));
        E0        = cell2mat(E0);
    end
else
    E0 = ones(size(T,1),1);
end

if isfield(options,'F1') && not(isempty(options.F1))
    F0 = T.(char(options.F1));
    if ~isnumeric(F0) && iscell(F0)
        cens      = cellfun(@(x) ischar(x) && startsWith(x, '<'), F0);
        str       = cellfun(@ischar, F0) & ~cens;
        F0(cens)  = {NaN};
        F0(str)   = num2cell(cellfun(@str2double, F0(str)));
        F0        = cell2mat(F0);
    end
else
    F0 = ones(size(T,1),1);
end



X1=A0./B0;
Y1=C0./D0;
Z1=E0./F0;



if isfield(options,'C1')&& not(isempty(options.C1)) && ismember(options.C1,T.Properties.VariableNames)
    C1=T.(char(options.C1));
    if ~isnumeric(C1) && iscell(C1)
        cens      = cellfun(@(x) ischar(x) && startsWith(x, '<'), C1);
        str       = cellfun(@ischar, C1) & ~cens;
        C1(cens)  = {NaN};
        C1(str)   = num2cell(cellfun(@str2double, C1(str)));
        C1        = cell2mat(C1);
    end
elseif isfield(options,'C1')&& not(isempty(options.C1)) && strcmp(options.C1,'1:n')
    C1=(1:size(T,1))';
else
    C1=(1:size(T,1))';
    options.ColorData.cbar_label='Colormap Error - Check Selected Variable';
end

if exist('condition','var')
    C1=C1(condition);
end

if  exist('X1','var') &&  exist('Y1','var') &&  exist('Z1','var') %&&any(not(any((isnan([X1 Y1 Z1])),2)))
    if isfield(options,'custom') && isfield(options.custom,'Annotation')&& options.custom.Annotation==true && isfield(options.custom,'AnnotationColumn')
        label_list=cell(1,numel(options.custom.AnnotationColumn));
        for anl=1:numel(options.custom.AnnotationColumn)
            label_list{anl}=T.(options.custom.AnnotationColumn{anl});
        end
    end

    if isfield(options,'ColorData') && isfield(options.ColorData,'Value') && options.ColorData.Value && isfield(options.ColorData,'colormap') && not(isempty(options.ColorData.colormap))
        colormap(ax2plot,options.ColorData.colormap)

        if  isfield(options.ColorData,'cbar_label')
            cbar_str=options.ColorData.cbar_label;
        else
            cbar_str='';
        end

        s=  scatter3(ax2plot,X1(not(any(isnan([X1 Y1 Z1]),2))),Y1(not(any(isnan([X1 Y1 Z1]),2))),Z1(not(any(isnan([X1 Y1 Z1]),2))),symbsize,C1(not(any(isnan([X1 Y1 Z1]),2))),symb,'filled','MarkerFaceAlpha',mfa,'MarkerEdgeAlpha',mea,'MarkerEdgeColor',mec,'LineWidth',mlw);
        cbar= colorbar;
        cbar.Label.String=cbar_str;
        cbar.Label.Interpreter=ax2plot.XAxis.Label.Interpreter;


    else
        s=  scatter3(ax2plot,X1(not(any(isnan([X1 Y1 Z1]),2))),Y1(not(any(isnan([X1 Y1 Z1]),2))),Z1(not(any(isnan([X1 Y1 Z1]),2))),symbsize,symb,'filled','MarkerFaceAlpha',mfa,'MarkerEdgeAlpha',mea,'MarkerEdgeColor',mec,'MarkerFaceColor',fil,'LineWidth',mlw);
    end
    if exist("label_list","var")
        s.DataTipTemplate.Interpreter='none';

        for anl=1:numel(options.custom.AnnotationColumn)
            s.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow(string(options.custom.AnnotationColumn{anl}), @(x) string(label_list{anl}));
        end
    end

    if  isfield(options,'legend') && isfield(options.legend,'String')
        legend_str=options.legend.String(any(not(isnan(X1)) & not(isnan(Y1))));
    end

end

end





