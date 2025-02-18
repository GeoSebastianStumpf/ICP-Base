% repair file if their is an error message like: Reference to non-existent
% field 'hh' or similar.

if isfield(UNK(1),'hh') == 0
    for d = 1:A.UNK_num
        UNK(d).hh = [];
    end
end

if isfield(UNK(1),'mm') == 0
    for d = 1:A.UNK_num
        UNK(d).mm = [];
    end
end

if isfield(UNK(1),'MATQIS_conc') == 0
    for d = 1:A.UNK_num
        UNK(d).MATQIS_conc = [];
    end
end

if isfield(UNK(1),'MATQIS_concwt') == 0
    for d = 1:A.UNK_num
        UNK(d).MATQIS_concwt = [];
    end
end

if isfield(UNK(1),'MAT_oxide_total') == 0
    for d = 1:A.UNK_num
        UNK(d).MAT_oxide_total = [];
    end
end

if isfield(UNK(1),'MAT_Fe_ratio') == 0
    for d = 1:A.UNK_num
        UNK(d).MAT_Fe_ratio = [];
    end
end

if isfield(UNK(1),'SIGQIS1_conc') == 0
    for d = 1:A.UNK_num
        UNK(d).SIGQIS1_conc = [];
    end
end

if isfield(UNK(1),'SIGsalinity') == 0
    for d = 1:A.UNK_num
        UNK(d).SIGsalinity = [];
    end
end

if isfield(UNK(1),'SIGQIS1_concwt') == 0
    for d = 1:A.UNK_num
        UNK(d).SIGQIS1_concwt = [];
    end
end

if isfield(UNK(1),'SIG_oxide_total') == 0
    for d = 1:A.UNK_num
        UNK(d).SIG_oxide_total =[];
    end
end

if isfield(UNK(1),'SIG_Fe_ratio') == 0
    for d = 1:A.UNK_num
        UNK(d).SIG_Fe_ratio = [];
    end
end

if isfield(UNK(1),'MATunit') == 0
    for d = 1:A.UNK_num
        UNK(d).MATunit = [];
    end
end

for d = 1:A.UNK_num
    if UNK(d).MATunit == 1
    elseif UNK(d).MATunit == 2
    else
        UNK(d).MATunit = 1;
    end
end

for d = 1:A.UNK_num
    if isfield(UNK(d),'SIGQIS2_conc') == 0
        UNK(d).SIGQIS2_conc = [];
    end
end

for d = 1:A.UNK_num
    if isfield(UNK(d),'SIGQIS2_concwt') == 0
        UNK(d).SIGQIS2_concwt = [];
    end
end

for d = 1:A.UNK_num
    if isfield(UNK(d),'salt') == 0
        UNK(d).salt = {};
    end
end

for d = 1:A.UNK_num
    if isfield(UNK(d),'SAMP_CONC_ratio_condensed') == 0
        UNK(d).SAMP_CONC_ratio_condensed = [];
    end
end

for d = 1:A.UNK_num
    if isfield(UNK(d),'SIG_ChlorideCONC_ratio') == 0
        UNK(d).SIG_ChlorideCONC_ratio = [];
    end
end

for d = 1:A.UNK_num
    if isfield(UNK(d),'MATcorrfile_index') == 0
        UNK(d).MATcorrfile_index = [];
    end
end

for d = 1:A.UNK_num
    if isfield(UNK(d),'SIG_MOLAR_ratio') == 0
        UNK(d).SIG_MOLAR_ratio = [];
    end
end


for d=1:A.STD_num
    if isfield(STD(d),'hh') == 0
        STD(d).hh = [];
    end
end

for d=1:A.STD_num
    if isfield(STD(d),'mm') == 0
        STD(d).mm = [];
    end
end
