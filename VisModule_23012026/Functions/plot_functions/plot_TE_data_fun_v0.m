function [ax2plot,options_definition,legend_str] = plot_TE_data_fun_v0(T,ax2plot,options)

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

plot_DL=true;

%% Plot Options definition
if  (isfield(options,'default') && options.default==true) || not(isfield(options,'plot_settings'))|| isempty(options.plot_settings)  || not(isfield(options.plot_settings,'MarkerFaceColor')) || isempty(options.plot_settings.MarkerFaceColor)
    fil=[0 0.4470 0.7410];
    options_definition.plot_settings.MarkerFaceColor=fil;
else
    fil=options.plot_settings.MarkerFaceColor;
end

if  (isfield(options,'default') && options.default==true)|| not(isfield(options,'plot_settings')) || isempty(options.plot_settings)  || not(isfield(options.plot_settings,'MarkerFaceAlpha')) || isempty(options.plot_settings.MarkerFaceAlpha) || not(isfield(options.plot_settings.MarkerFaceAlpha,'Value')) || isempty(options.plot_settings.MarkerFaceAlpha.Value)
    mfa=3/8;
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
    
%[ax2plot]=plot_XY_fun([],options);
%   hfig=figure('Name','Chondrite Normalized diagram');
figure(300)

ax2plot=nexttile;
hold on

ax2plot.FontSize=18;
end


Ox={'H','He','Li','Be','B','C','N','O','F','Ne','Na','Mg','Al','Si','P','S','Cl',...
                'Ar','K','Ca','Sc','Ti','V','Cr','Mn','Fe','Co','Ni','Cu','Zn','Ga','Ge','As',...
                'Se','Br','Kr','Rb','Sr','Y','Zr','Nb','Mo','Tc','Ru','Rh','Pd','Ag','Cd','In',...
                'Sn','Sb','Te','I','Xe','Cs','Ba','La','Ce','Pr','Nd','Pm','Sm','Eu','Gd','Tb',...
                'Dy','Ho','Er','Tm','Yb','Lu','Hf','Ta','W','Re','Os','Ir','Pt','Au','Hg','Tl',...
                'Pb','Bi','Po','At','Rn','Fr','Ra','Ac','Th','Pa','U','Np','Pu','Am','Cm','Bk',...
                'Cf','Es','Fm','Md','No','Lr','Rf','Db','Sg','Bh','Hs','Mt','Uun','Uuu','Uub'};


headers= replace(T.Properties.VariableNames,{'0','1','2','3','4','5','6','7','8','9'},'');
T=T(:,ismember(headers,Ox));
headers=headers(ismember(headers,Ox));

switch options.type.Value
    case 'REE'
        Element_Names={'La', 'Ce', 'Pr', 'Nd', 'Sm', 'Eu', 'Gd', 'Tb', 'Dy', 'Ho', 'Er', 'Tm', 'Yb', 'Lu'};
    case 'TE'
        Element_Names={'Li','Be','Na','Mg','Al','Si','K','Ca','Sc','Ti','V','Cr','Mn','Fe','Co','Ni','Cu','Zn','As','Rb','Sr','Y','Zr','Nb','Mo','Ag','In','Cs','Ba','La','Ce','Pr','Nd','Sm','Eu','Gd','Tb','Dy','Ho','Er','Tm','Yb','Lu','Hf','Ta','W','Pb','Bi','U'};
    case 'ALL'
        Element_Names=Ox;%;
    case 'Custom'
       
        if not(isempty(ax2plot.XAxis.TickLabels)) && not(isequal(ax2plot.XAxis.TickLabels',headers))
            Element_Names=unique([ax2plot.XAxis.TickLabels' headers ] );%;
            [~, idx] = sort(find(ismember(Ox, Element_Names)));
            Element_Names = Ox(idx);
        else
            Element_Names=headers;%;
        end

end

D=nan(size(T,1),numel(Element_Names));
D_DL=nan(size(T,1),numel(Element_Names));

%% find detection limit
if plot_DL==true
T_Cell=table2cell(T);
T_Cell_DL=T_Cell;
mask = cellfun(@(x) ~isnumeric(x) && ischar(x) && contains(x, '<'), T_Cell);
[row, col] = find(mask);

%T_Cell_DL(row, col)=cellfun(@str2double,cellfun(@(x) replace(x,'<',''), T_Cell(row, col));
%T_Cell_DL(not(row),not(col))=nan;

T_Cell_DL(not(mask))={nan};
T_Cell_DL(mask) = cellfun(@(x) str2double(strrep(x, '<', '')), T_Cell(mask), 'UniformOutput', false);



T_DL = array2table(cell2mat(T_Cell_DL), 'VariableNames', T.Properties.VariableNames);

T_Cell(mask)={nan};
mask = cellfun(@ischar, T_Cell);
T_Cell(mask) = cellfun(@str2double, T_Cell(mask), 'UniformOutput', false);
T = array2table(cell2mat(T_Cell), 'VariableNames', T.Properties.VariableNames);

end
%%


for n=1:numel(Element_Names)
    try
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
            D(:,n)=table2array( T(:,colid(end)));
        end
    end
    
catch ME
    ME.stack.line
    end
end

switch options.type.Value
    case 'REE'
%%
        %  REE_Normalizationm﻿ %Sun & McDonough (1989) chondrite values
La_SM=0.237;
Ce_SM=0.612;
Pr_SM=0.095;
Nd_SM=0.467;
Sm_SM=0.153;
Eu_SM=0.058;
Gd_SM=0.2055;
Tb_SM=0.0374;
Dy_SM=0.2540;
Ho_SM=0.0566;
Er_SM=0.1655;
Tm_SM=0.0255;
Yb_SM=0.170;
Lu_SM=0.0254;

%normaliation
[m,n]=size(D); %finds the x and y size of the input data matrix
REE_norm=zeros(m,n);
REE_norm(:,1)=D(:,1)./La_SM;
REE_norm(:,2)=D(:,2)./Ce_SM;
REE_norm(:,3)=D(:,3)./Pr_SM;
REE_norm(:,4)=D(:,4)./Nd_SM;
REE_norm(:,5)=D(:,5)./Sm_SM;
REE_norm(:,6)=D(:,6)./Eu_SM;
REE_norm(:,7)=D(:,7)./Gd_SM;
REE_norm(:,8)=D(:,8)./Tb_SM;
REE_norm(:,9)=D(:,9)./Dy_SM;
REE_norm(:,10)=D(:,10)./Ho_SM;
REE_norm(:,11)=D(:,11)./Er_SM;
REE_norm(:,12)=D(:,12)./Tm_SM;
REE_norm(:,13)=D(:,13)./Yb_SM;
REE_norm(:,14)=D(:,14)./Lu_SM;

%Eu/Eu*
Eu_anomaly(:,1)=(2.*REE_norm(:,6))./(REE_norm(:,5)+REE_norm(:,7));

%plots

%Semi-log REE plot
hold on
%semilogy(x,REE_norm,'-','Color',fil);
x=[1 1.01466 1.02975 1.04529 1.07357 1.08650 1.09975 1.11333 1.12725 1.14042 1.15278 1.16426 1.17480 1.18434];
plot(ax2plot,x,REE_norm,'-','Color',[fil,mfa],'LineWidth',mlw,'HandleVisibility','off');

%patch([x(:);NaN],[REE_norm(:);NaN],'k');

%ylabel(ax2plot,'REE/Cl')

set(ax2plot,'YScale','log','XLim',[1, 1.18434],'XTick',x,'XTickLabel',{'La','Ce','Pr','Nd','Sm','Eu','Gd','Tb','Dy','Ho','Er','Tm','Yb','Lu'})
%%
    case 'Custom'

        plot(ax2plot,1: size(D,2),D,'-','Color',[fil,mfa],'LineWidth',mlw,'HandleVisibility','off');

        set(ax2plot,'YScale','log','XLim',[min(1) max(size(D,2))],'XTick',1: size(D,2),'XTickLabel',Element_Names)


    otherwise
        plot(ax2plot,1: size(D,2),D,'-','Color',[fil,mfa],'LineWidth',mlw,'HandleVisibility','off');


end
plot(ax2plot,nan,nan,'-','Color',[fil,mfa],'LineWidth',mlw,'HandleVisibility','off');

if plot_DL==true

%plot(ax2plot,x,D_DL,'Marker','_','LineStyle','none','Color',[fil,mfa],'LineWidth',mlw);
%plot(ax2plot,1: size(D_DL,2),D_DL,'Marker','_','LineStyle','none','Color',[0.8 0.8 0.8],'LineWidth',mlw);
scatter(ax2plot,1: size(D_DL,2),D_DL,100,'_','filled','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5,'MarkerEdgeColor',[0.8 0.8 0.8],'MarkerFaceColor',[0.8 0.8 0.8],'LineWidth',1,'HandleVisibility','off');
end


if  isfield(options,'legend') && isfield(options.legend,'String')
    legend_str=options.legend.String(any(not(isnan(X1)) & not(isnan(Y1))));
end
