function [ax2plot,options_definition,legend_str] = plot_TE_data_fun(T,ax2plot,options)

[~,options_definition]=plot_TE_fun([],[]);

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

if  (isfield(options,'default') && options.default==true)|| not(isfield(options,'plot_settings')) || isempty(options.plot_settings)  || not(isfield(options.plot_settings,'LineAlpha')) || isempty(options.plot_settings.LineAlpha) || not(isfield(options.plot_settings.LineAlpha,'Value')) || isempty(options.plot_settings.LineAlpha.Value)
    la=1;
    options_definition.plot_settings.LineAlpha=la;
else
    la=options.plot_settings.LineAlpha.Value;
end

UserData.LineAlpha=la;

if  (isfield(options,'default') && options.default==true) || not(isfield(options,'plot_settings'))|| isempty(options.plot_settings)  || not(isfield(options.plot_settings,'symbol')) || isempty(options.plot_settings.symbol)
    symb='.';
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


if  (isfield(options,'default') && options.default==true) || not(isfield(options,'plot_settings'))|| isempty(options.plot_settings)  || not(isfield(options.plot_settings,'MarkerLineWidth')) || isempty(options.plot_settings.MarkerLineWidth)  || not(isfield(options.plot_settings.MarkerLineWidth,'Value')) || isempty(options.plot_settings.MarkerLineWidth.Value)
    mlw=1.5;
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

legend_str={};

% if not(exist('options','var')) || isempty(options)
%     if not(exist('ax2plot','var'))
%         ax2plot=[];
%     end
%     return
% end

if (isfield(options,'default') && options.default==true)
    type=options.type.Value;
    options=options_definition;
    options.type.Value=type;
else
    options.type.Value='Custom';
end

% if not(exist('options','var')) || isempty(options)
%     if not(exist('ax2plot','var'))
%         ax2plot=[];
%     end
%     return
% end

if (isfield(options,'default') && options.default==true)
    type=options.type.Value;
    options=options_definition;
    options.type.Value=type;
end

if not(exist('ax2plot','var')) || isempty(ax2plot)

    [ax2plot]=plot_TE_fun([],options);
    %   hfig=figure('Name','Chondrite Normalized diagram');

end

%%

if isfield(options,'DetectionLimits') && isfield(options.DetectionLimits,'PlotDetectionLimits') && options.DetectionLimits.PlotDetectionLimits==true && isfield(options.DetectionLimits,'DetectionLimitsTable') && istable(options.DetectionLimits.DetectionLimitsTable)
    T_DL=options.DetectionLimits.DetectionLimitsTable;
    plot_DL=true;
elseif isfield(options,'DetectionLimits') && isfield(options.DetectionLimits,'PlotDetectionLimits') && options.DetectionLimits.PlotDetectionLimits==true
    plot_DL=true;
else
    plot_DL=false;
end

        if isfield(options,'DetectionLimits')&&isfield(options.DetectionLimits,'Color') && ~isempty(options.DetectionLimits.Color)
        dl_color=options.DetectionLimits.Color;
        else
                    dl_color=[0.8 0.8 0.8];

        
        end
%    plot_DL=true;



Elements={'H','He','Li','Be','B','C','N','O','F','Ne','Na','Mg','Al','Si','P','S','Cl',...
    'Ar','K','Ca','Sc','Ti','V','Cr','Mn','Fe','Co','Ni','Cu','Zn','Ga','Ge','As',...
    'Se','Br','Kr','Rb','Sr','Y','Zr','Nb','Mo','Tc','Ru','Rh','Pd','Ag','Cd','In',...
    'Sn','Sb','Te','I','Xe','Cs','Ba','La','Ce','Pr','Nd','Pm','Sm','Eu','Gd','Tb',...
    'Dy','Ho','Er','Tm','Yb','Lu','Hf','Ta','W','Re','Os','Ir','Pt','Au','Hg','Tl',...
    'Pb','Bi','Po','At','Rn','Fr','Ra','Ac','Th','Pa','U','Np','Pu','Am','Cm','Bk',...
    'Cf','Es','Fm','Md','No','Lr','Rf','Db','Sg','Bh','Hs','Mt','Uun','Uuu','Uub'};


T_in=T;

if strcmp(options.type.Value,'REE')
    Element_Names={'La', 'Ce', 'Pr', 'Nd', 'Sm', 'Eu', 'Gd', 'Tb', 'Dy', 'Ho', 'Er', 'Tm', 'Yb', 'Lu'};
    options.xValues=[1 1.01466 1.02975 1.04529 1.07357 1.08650 1.09975 1.11333 1.12725 1.14042 1.15278 1.16426 1.17480 1.18434];

elseif strcmp(options.type.Value,'TE')
    Element_Names={'Li','Be','Na','Mg','Al','Si','K','Ca','Sc','Ti','V','Cr','Mn','Fe','Co','Ni','Cu','Zn','As','Rb','Sr','Y','Zr','Nb','Mo','Ag','In','Cs','Ba','La','Ce','Pr','Nd','Sm','Eu','Gd','Tb','Dy','Ho','Er','Tm','Yb','Lu','Hf','Ta','W','Pb','Bi','U'};
elseif strcmp(options.type.Value,'All')


    headers= replace(T.Properties.VariableNames,{'0','1','2','3','4','5','6','7','8','9'},'');
    T=T(:,ismember(headers,Elements));
    headers=headers(ismember(headers,Elements));
elseif strcmp(options.type.Value,'Custom') || startsWith(options.type.Value,'custom_')
    if isfield(options,'Element_List') && iscell(options.Element_List)
        Element_Names= options.Element_List;
        Elements = Element_Names;
    end
    %   T_=T;
    headers= T.Properties.VariableNames;
    if sum(ismember(headers,Elements))==0
        %  T=T_;
        headers= replace(T.Properties.VariableNames,{'0','1','2','3','4','5','6','7','8','9'},'');
        T=T(:,ismember(headers,Elements));
        headers=headers(ismember(headers,Elements));
        % ath problem if not unique
    else
    end
    T=T(:,ismember(headers,Elements));
    headers=headers(ismember(headers,Elements));


    if not(isfield(options,'Element_List') && iscell(options.Element_List) && not(isempty(options.Element_List(ismember(options.Element_List, Elements)))))

        if not(isempty(ax2plot.XAxis.TickLabels)) && not(isequal(ax2plot.XAxis.TickLabels',headers))
            Element_Names=unique([ax2plot.XAxis.TickLabels' headers ] );%;
            [~, idx] = sort(find(ismember(Elements, Element_Names)));
            Element_Names = Elements(idx);
        else
            Element_Names=headers;%;
        end
    end

    if isfield(options,'TENorm') && isfield(options.TENorm,'NormState') && options.TENorm.NormState==true
        norm_vector=nan(1,numel(Element_Names));

        for n=1:numel(Element_Names)
            if any(ismember(options.TENorm.Elements,Element_Names{n}))
                norm_vector(n)=options.TENorm.Values(ismember(options.TENorm.Elements,Element_Names{n}));
            end
        end

        %             disp(options.TENorm.Name)
    else
        norm_vector=ones(1,numel(Element_Names));
    end
end

D=nan(size(T,1),numel(Element_Names));

%% find detection limit
if plot_DL==true && not(exist('T_DL','var'))
   D_DL=nan(size(T,1),numel(Element_Names));
 T_Cell=table2cell(T);
    T_Cell_DL=T_Cell;
    mask = cellfun(@(x) ~isnumeric(x) && ischar(x) && contains(x, '<'), T_Cell);
    % [row, col] = find(mask);

    %T_Cell_DL(row, col)=cellfun(@str2double,cellfun(@(x) replace(x,'<',''), T_Cell(row, col));
    %T_Cell_DL(not(row),not(col))=nan;

    T_Cell_DL(not(mask))={nan};
    T_Cell_DL(mask) = cellfun(@(x) str2double(strrep(x, '<', '')), T_Cell(mask), 'UniformOutput', false);

    T_DL = array2table(cell2mat(T_Cell_DL), 'VariableNames', T.Properties.VariableNames);

    T_Cell(mask)={nan};
    mask = cellfun(@ischar, T_Cell);
    T_Cell(mask) = cellfun(@str2double, T_Cell(mask), 'UniformOutput', false);
    T = array2table(cell2mat(T_Cell), 'VariableNames', T.Properties.VariableNames);
else
       D_DL=nan(size(T,1),numel(Element_Names));

end
%%


for n=1:numel(Element_Names)
    try
        % replace(T.Properties.VariableNames,{'0','1','2','3','4','5','6','7','8','9'},'')
        if any(ismember(headers,Element_Names{n}))
            if sum(ismember(headers,Element_Names{n}))==1
                if istable(T(:,ismember(headers,Element_Names{n})))
                    D(:,n)=table2array( T(:,ismember(headers,Element_Names{n})));
                    if plot_DL==true
                        D_DL(:,n)=table2array( T_DL(:,ismember(headers,Element_Names{n})));
                    end
                elseif iscell(T(:,ismember(headers,Element_Names{n})))
                    D(:,n)=T(:,ismember(headers,Element_Names{n}));
                    if plot_DL==true
                        D_DL(:,n)=T_DL(:,ismember(headers,Element_Names{n}));
                    end
                end
            elseif sum(ismember(headers,Element_Names{n}))>1
                colid=find(ismember(headers,Element_Names{n}));
                [val,poslessnan]=min(sum(isnan(table2array(T(:,colid)))));
                D(:,n)=table2array( T(:,colid(poslessnan)));
            end
        end

    catch ME
ME.stack.line
    end
end

if isempty(D)
    return
end

if isfield(options,'xValues')
    x=options.xValues;
else
    x=1:size(D,2);
end


if isfield(options,'custom') && isfield(options.custom,'Annotation')&& options.custom.Annotation==true && isfield(options.custom,'AnnotationColumn')
    label_list=cell(1,numel(options.custom.AnnotationColumn));
    for anl=1:numel(options.custom.AnnotationColumn)
        if isnumeric(T_in.(options.custom.AnnotationColumn{anl}))
            label_list{anl}=num2cell(T_in.(options.custom.AnnotationColumn{anl}));
        else
            label_list{anl}=T_in.(options.custom.AnnotationColumn{anl});
        end
    end
end

if isfield(options,'DetectionLimits') && isfield(options.DetectionLimits,'Annotation')&& options.DetectionLimits.Annotation==true && isfield(options.DetectionLimits,'AnnotationColumn')
    label_list_dl=cell(1,numel(options.DetectionLimits.AnnotationColumn));
    for anl=1:numel(options.DetectionLimits.AnnotationColumn)
        if isnumeric(T_in.(options.DetectionLimits.AnnotationColumn{anl}))
            label_list_dl{anl}=num2cell(T_in.(options.DetectionLimits.AnnotationColumn{anl}));
        else
            label_list_dl{anl}=T_in.(options.DetectionLimits.AnnotationColumn{anl});
        end
    end
end

if strcmpi(options.type.Value,'Custom') || startsWith(options.type.Value,'custom')
    if isfield(options,'TENorm') && isfield(options.TENorm,'NormState') && options.TENorm.NormState==true
        D=D./norm_vector;
        if  isfield(options.TENorm,'Name')
            ylabel(ax2plot,options.TENorm.Name,Interpreter="none");
        end
    end

    if size(D,1)==size(D,2)
        D=D';
    end

    if isfield(options,'legend') && isfield(options.legend,'String')
        p = plot(ax2plot,x,D,'-','Color',[fil,la],'Marker',symb,'LineWidth',mlw,'HandleVisibility','on','Tag',options.legend.String,'UserData',UserData);
    else
        p = plot(ax2plot,x,D,'-','Color',[fil,la],'Marker',symb,'LineWidth',mlw,'HandleVisibility','on','Tag',num2str(numel([ax2plot.Children])),'UserData',UserData);
    end


    if plot_DL==true
        if isfield(options,'legend') && isfield(options.legend,'String')
            %p = plot(ax2plot,x,D,'-','Color',[fil,la],'Marker',symb,'LineWidth',mlw,'HandleVisibility','on','Tag',options.legend.String,'UserData',UserData);
            p_dl = plot(x,D_DL,'linestyle','none','Color',dl_color,'Marker','_','LineWidth',2,'HandleVisibility','on','Tag',[options.legend.String '_LOD'],'UserData',UserData);
        else
            %  p = plot(ax2plot,x,D,'-','Color',[fil,la],'Marker',symb,'LineWidth',mlw,'HandleVisibility','on','Tag',num2str(numel([ax2plot.Children])),'UserData',UserData);
            p_dl = plot(x,D_DL,'linestyle','none','Color',dl_color,'Marker','_','LineWidth',2,'HandleVisibility','on','Tag',[num2str(numel([ax2plot.Children])) '_LOD'],'UserData',UserData);
        end

 end

    set(ax2plot,'YScale','log','XLim',[min(x) max(x)],'XTick',x,'XTickLabel',Element_Names)


else
    p = plot(ax2plot,x,D,'-','Color',[fil,la],'Marker',symb,'LineWidth',mlw,'HandleVisibility','on','UserData',UserData);

    if plot_DL==true
        % scatter(ax2plot,x,D_DL,100,'_','filled','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5,'MarkerEdgeColor',[0.4 0.4 0.4],'MarkerFaceColor',[0.4 0.4 0.4],'LineWidth',2,'HandleVisibility','off');
        p_dl = plot(x,D_DL,'linestyle','none','Color',dl_color,'Marker','_','LineWidth',2,'HandleVisibility','on','UserData',UserData);
    end

end


try
    if exist("label_list","var")
        for nnn=1:(numel(p))

            p(nnn).DataTipTemplate.Interpreter='none';

            p(nnn).DataTipTemplate.DataTipRows(1)= dataTipTextRow(string(p(nnn).DataTipTemplate.DataTipRows(1).Label), ax2plot.XTickLabel);
            for anl=1:numel(options.custom.AnnotationColumn)
                p(nnn).DataTipTemplate.DataTipRows(end+1) = dataTipTextRow(string(options.custom.AnnotationColumn{anl}), repmat(string(label_list{anl}{nnn}),numel(p(nnn).XData),1));
            end
        end
    end

    if exist("label_list_dl","var")
        for nnn=1:(numel(p_dl))

            p_dl(nnn).DataTipTemplate.Interpreter='none';

            p_dl(nnn).DataTipTemplate.DataTipRows(1)= dataTipTextRow(string(p_dl(nnn).DataTipTemplate.DataTipRows(1).Label), ax2plot.XTickLabel);
            for anl=1:numel(options.custom.AnnotationColumn)
                p_dl(nnn).DataTipTemplate.DataTipRows(end+1) = dataTipTextRow(string(options.custom.AnnotationColumn{anl}), repmat(string(label_list{anl}{nnn}),numel(p_dl(nnn).XData),1));
            end
        end
    end


catch
    keyboard
end


ax2plot.XGrid=true;
ax2plot.YGrid=true;

if  isfield(options,'legend') && isfield(options.legend,'String')
    legend_str=options.legend.String(any(not(isnan(X1)) & not(isnan(Y1))));
end
