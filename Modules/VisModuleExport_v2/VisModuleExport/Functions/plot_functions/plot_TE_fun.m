function [ax2plot,options_definition]=plot_TE_fun(ax2plot,options)
if not(exist('ax2plot','var'))
    ax2plot=[];
end
if not(exist('options','var'))
    options=[];
end
%% options definition
options_definition.TEplot.Value=true;

if  (isfield(options,'default') && options.default==true) || not(isfield(options,'FontSize')) || isempty(options.FontSize)
    FontSize=20;
    options_definition.FontSize.Value=FontSize;
else
    FontSize=options.FontSize.Value;
end

options_definition.type.Value='Custom';
options_definition.type.options={'REE'
    'TE'
    'ALL'
    'Custom'
    };

options_definition.type.description={'REE'
    'TE'
    'ALL'
    'Custom'
    };

if not(exist('options','var')) || isempty(options)
    if not(exist('ax2plot','var'))
        ax2plot=[];
    end
    return
end

if not(exist('ax2plot','var')) || isempty(ax2plot)
    hfig=figure;
    hfig.Position(3)=hfig.Position(3)*1.5;

    ax2plot=nexttile;

    try
        CenterFig_fun(hfig)
    catch ME
        disp(ME.message)
    end
end

hold on

ax2plot.FontSize=FontSize;


if (isfield(options,'default') && options.default==true)
    type=options.type.Value;
    options=options_definition;
    options.type.Value=type;
end

if isfield(options,'TEplot') && options.TEplot.Value==true

    %% Mineral specific options
    x_label_str={};

    if not(isempty(options)) && isfield(options,'type') && strcmp(options.type.Value,'REE')
        Element_Names={'La', 'Ce', 'Pr', 'Nd', 'Sm', 'Eu', 'Gd', 'Tb', 'Dy', 'Ho', 'Er', 'Tm', 'Yb', 'Lu'};
        x=[1 1.01466 1.02975 1.04529 1.07357 1.08650 1.09975 1.11333 1.12725 1.14042 1.15278 1.16426 1.17480 1.18434];

        set(ax2plot,'YScale','log','XLim',[1, 1.18434],'XTick',x,'XTickLabel',{'La','Ce','Pr','Nd','Sm','Eu','Gd','Tb','Dy','Ho','Er','Tm','Yb','Lu'})
        ylabel(ax2plot,'REE/Cl')

    elseif not(isempty(options)) && isfield(options,'type') && strcmp(options.type.Value,'TE')
        Element_Names={'Li','Be','Na','Mg','Al','Si','K','Ca','Sc','Ti','V','Cr','Mn','Fe','Co','Ni','Cu','Zn','As','Rb','Sr','Y','Zr','Nb','Mo','Ag','In','Cs','Ba','La','Ce','Pr','Nd','Sm','Eu','Gd','Tb','Dy','Ho','Er','Tm','Yb','Lu','Hf','Ta','W','Pb','Bi','U'};
        x=1:numel(Element_Names);
        set(ax2plot,'YScale','log','XLim',[min(x) max(x)],'XTick',x,'XTickLabel',Element_Names)
        ylabel(ax2plot,'[μg/g]')

    elseif not(isempty(options)) && isfield(options,'type') && strcmp(options.type.Value,'ALL')
        Element_Names={'H','He','Li','Be','B','C','N','O','F','Ne','Na','Mg','Al','Si','P','S','Cl',...
            'Ar','K','Ca','Sc','Ti','V','Cr','Mn','Fe','Co','Ni','Cu','Zn','Ga','Ge','As',...
            'Se','Br','Kr','Rb','Sr','Y','Zr','Nb','Mo','Tc','Ru','Rh','Pd','Ag','Cd','In',...
            'Sn','Sb','Te','I','Xe','Cs','Ba','La','Ce','Pr','Nd','Pm','Sm','Eu','Gd','Tb',...
            'Dy','Ho','Er','Tm','Yb','Lu','Hf','Ta','W','Re','Os','Ir','Pt','Au','Hg','Tl',...
            'Pb','Bi','Po','At','Rn','Fr','Ra','Ac','Th','Pa','U','Np','Pu','Am','Cm','Bk',...
            'Cf','Es','Fm','Md','No','Lr','Rf','Db','Sg','Bh','Hs','Mt','Uun','Uuu','Uub'};

        x=1:numel(Element_Names);

        set(ax2plot,'YScale','log','XLim',[min(x) max(x)],'XTick',x,'XTickLabel',Element_Names)


        ylabel(ax2plot,'[μg/g]')
    elseif not(isempty(options)) && isfield(options,'type') && (strcmp(options.type.Value,'Custom') || startsWith(options.type.Value,'custom_'))
        set(ax2plot,'XTickLabel',[])
    end



end
    if isfield(options,'ylabel') && isfield(options.ylabel,'String') && ischar(options.ylabel.String)
        ylabel(ax2plot,options.ylabel.String)
    end



