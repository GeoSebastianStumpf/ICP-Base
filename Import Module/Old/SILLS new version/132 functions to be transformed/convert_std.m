%function convert(directory,filename)
% This script is an addition to the SILLS data reduction software.
% It converts the output files created by the ELEMENT-2 Machine
% to a format readable for SILLS.
% The resolution information contained in the ELEMENT-2 files is discarded.
% The original files will not be changed, this script creates a new set of
% files with the extension *.converted which can be imported into SILLS.
%
% Syntax: convert('directory','filename')
%
% 'directory' is a string specifying the directory the files are located.
%    Enter convert('.','filename') if you wish to work in the current
%    directory.
%
% 'filename' is a string specifying the filename of the data files.
%    Use asterisks to select multiple files. If you wish to select all
%    files in the directory type convert('directory','*').
%    Make sure you select only ELEMENT-2 files, a format slightly different
%    or any other file type will result in an error.
%
% Examples:
%
%   convert('C:\laser-data\28Feb08\','fe26a01.TXT')
%
%   convert('fe2627','fe26*.TXT')
%
%   convert('.','*')
%
% By Dimitri Meier, February 2008



%currentdir = pwd;
%cd(directory);
%filelist = ls(filename);

%for file = 1:size(filelist,1)
    
 %   if isdir(filelist(file,:)) || ~isempty(findstr(filelist(file,:),'convert.m'))
  %      continue
 %   end

  %  disp(['Converting ' filelist(file,:) ' ...'])
    
    %----------------------------------------------------------------------
    %Modify this section
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Importing header
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fid = fopen(A.stdfullfilename);

    IMP = textscan(fid,'%s','delimiter','\t');
    IMP = IMP{1,1};

    temp = strmatch('Resolution', IMP);
    isotopes = IMP(2:temp-1);
    isotopes_num = length(isotopes);

    fclose(fid);
    clear IMP temp fid

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
    IMP = importdata(A.stdfullfilename,'\t',5);
    IMP = IMP.data;
    tstep = size(IMP,1);
    
    %----------------------------------------------------------------------
    %Here, the following variables must exist:
    %
    % isotopes : Cell array of strings
    % isotopes_num : Integer Number
    % IMP : Matrix of numbers
    % tstep : Integer number
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Create new file
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %   fid = fopen([filelist(file,:) '.conv'],'wt');

  %  fprintf(fid,'%s','Intensity Vs Time');
   % for i = 1:isotopes_num
  %      fprintf(fid,'%c',',');
  %  end
  %  fprintf(fid,'\n%s','Time in Seconds');
  %  for i = 1:isotopes_num
  %      fprintf(fid,'%c%s',',',cell2mat(isotopes(i)));
  %  end
%
 %   for t = 1:tstep
  %      fprintf(fid,'\n%f',IMP(t,1));
  %      for i = 2:isotopes_num+1
  %          fprintf(fid,'%c%f',',',IMP(t,i));
  %      end
  %  end
STDIMP.data = IMP;
 %   UNK.colheaders(1,1)='Time';
    for i=1:isotopes_num
        STDIMP.colheaders(1,i+1) = isotopes(i);
    end    
 STDIMP.textdata = STDIMP.colheaders;
 
  %  fclose(fid);
    clear IMP isotopes isotopes_num iso i a tstep fid t
%end

%cd(currentdir);
clear IMP isotopes isotopes_num iso i a tstep fid t
clear directory filename currentdir filelist file