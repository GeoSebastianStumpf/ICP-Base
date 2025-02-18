%calcRATIOS.m
%summoned at the end of the calculations
%Added in 1.0.3

if A.ratios.num == 0
    return
end

for c = 1:A.STD_num %STANDARDS

    %Recalculate ratios
    STD(c).ratios = zeros(size(STD(c).data,1),A.ratios.num);
    for i = 1:A.ratios.num
        for tstep = 1:size(STD(c).data,1)
            STD(c).ratios(tstep,i) = (STD(c).data_cps(tstep,A.ratios.index(i,1)) - STD(c).bg_cps(A.ratios.index(i,1))) ./ (STD(c).data_cps(tstep,A.ratios.index(i,2)) - STD(c).bg_cps(A.ratios.index(i,2)));
        end
    end
    
    STD(c).ratioint = [];
    STD(c).ratioerr = [];

    %Define bg corrected integrated ratios
    sampcps = STD(c).sig_cps - STD(c).bg_cps;
    for i = 1:A.ratios.num
        STD(c).ratioint(i) = sampcps(A.ratios.index(i,1)) ./ sampcps(A.ratios.index(i,2));

        %Integrate ratios, define error (standard error)
        ratioseries = STD(c).ratios(STD(c).sigwindow_index(1):STD(c).sigwindow_index(2),i);
        ratioseries(find(isnan(ratioseries))) = [];
        ratioseries(find(isinf(ratioseries))) = [];
        STD(c).ratioerr(i) = std(ratioseries) ./ sqrt(length(ratioseries));

    end
end

for c = 1:A.UNK_num %UNKNOWNS

    %Exclude unknowns with no signal window
    if UNK(c).sigtotal == 0
        continue
    end

    %Recalculate ratios
    UNK(c).ratios = zeros(size(UNK(c).data,1),A.ratios.num);
    for i = 1:A.ratios.num
        for tstep = 1:size(UNK(c).data,1)
            UNK(c).ratios(tstep,i) = (UNK(c).data_cps(tstep,A.ratios.index(i,1)) - UNK(c).bg_cps(A.ratios.index(i,1))) ./ (UNK(c).data_cps(tstep,A.ratios.index(i,2)) - UNK(c).bg_cps(A.ratios.index(i,2)));
        end
    end

    UNK(c).ratioint = [];
    UNK(c).ratioerr = [];    
    
    %Define bg corrected integrated ratios
    for i = 1:A.ratios.num
        UNK(c).ratioint(i) = UNK(c).samp_cps(A.ratios.index(i,1)) ./ UNK(c).samp_cps(A.ratios.index(i,2));

        %Integrate ratios, define error (standard error)
        if ~isempty(UNK(c).comp1window)
            ratioseries1 = UNK(c).ratios(UNK(c).comp1window_index(1):UNK(c).comp1window_index(2),i);
        else
            ratioseries1 = [];
        end
        if ~isempty(UNK(c).comp2window)
            ratioseries2 = UNK(c).ratios(UNK(c).comp2window_index(1):UNK(c).comp2window_index(2),i);
        else
            ratioseries2 = [];
        end
        if ~isempty(UNK(c).comp3window)
            ratioseries3 = UNK(c).ratios(UNK(c).comp3window_index(1):UNK(c).comp3window_index(2),i);
        else
            ratioseries3 = [];
        end

        ratioseries = vertcat(ratioseries1,ratioseries2,ratioseries3);
        ratioseries(find(isnan(ratioseries))) = [];
        ratioseries(find(isinf(ratioseries))) = [];
        UNK(c).ratioerr(i) = std(ratioseries) ./ sqrt(length(ratioseries));

    end

end

clear c i tstep ratioseries sampcps ratioseries1 ratioseries2 ratioseries3
