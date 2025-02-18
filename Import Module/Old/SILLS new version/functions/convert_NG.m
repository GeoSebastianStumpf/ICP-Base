% general import convert function can be used for 
% std files:
% STDIMP=convert_NG(app.A.stdfullfilename)
% 
% whatever UNKIMP is
% UNKIMP=convert_NG(app.A.stdfullfilename)


function IMP=convert_NG(full_path_file)

    fid = fopen(fullfile(full_path_file));

    IMP = textscan(fid,'%s','delimiter','\t');
    IMP = IMP{1,1};

    temp = strmatch('Resolution', IMP);
    isotopes = IMP(2:temp-1);
    isotopes_num = length(isotopes);

    fclose(fid);

    for i = 1:isotopes_num %Discard any bracketed remarks after isotopes
        iso = cell2mat(isotopes(i));
        a = findstr(iso,'(') - 1;
        if ~isempty(a)
            iso = iso(1:a);
        end
        isotopes(i) = {iso};
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Importing data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    IMP = importdata(fullfile(full_path_file),'\t',5);
    IMP = IMP.data;
    tstep = size(IMP,1);
   
IMP.data = IMP;
 %   UNK.colheaders(1,1)='Time';
    for i=1:isotopes_num
        IMP.colheaders(1,i+1) = isotopes(i);
    end    
 IMP.textdata = IMP.colheaders;
 
end