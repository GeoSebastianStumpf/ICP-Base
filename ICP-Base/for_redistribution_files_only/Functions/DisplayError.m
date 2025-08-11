function DisplayError(ME,WhichOperation)
%DisplayError - Displays detailed error information
% Description:
%    This function displays detailed information about an error, including the
%    time of occurrence, the operation during which the error occurred, and the
%    stack trace of the error. If the WhichOperation parameter is not provided,
%    it defaults to '?'. In deployed software the error message is written into the log_file.txt
% Author: Nils B. Gies
% Last edit: 2025-01-05
% Inputs:
%    ME - The MException object containing error information
%    WhichOperation - A string describing the operation during which the error occurred
%
try
    if not(exist("WhichOperation","var"))
        disp('Error! Missing ME!')
        return
    end

    if not(exist("WhichOperation","var"))
        WhichOperation='?';
    end

    disp(' ')
    disp('_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_')
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp('%%%%%%%%%%%%%%   Error   %%%%%%%%%%%%%%%%')
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp('%%')
    disp(['%%        ' char(datetime('now'))])
    disp('%%')
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp(['Error occured during: ' WhichOperation])
    % for n=1
    disp('_________________________________________')
    k=1;
    for n=numel(ME.stack):-1:1
        disp(['%%' num2str(k,'%03.f') '%%'])
        k=1+k;
        disp('Error in file:')
        disp(ME.stack(n).file)
        disp(['Error in line: ',num2str(ME.stack(n).line)])
        disp('_________________________________________')
        disp('  ')
    end
    disp(['Error in message: ' ME.message])
    disp('  ')
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp('_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_')
    disp('  ')
    disp('  ')
catch ME
    disp('Error occured during: DisplayError(ME,WhichOperation)')
    for n=numel(ME.stack):-1:1
        disp('Error in file:')
        disp(ME.stack(n).file)
        disp(['Error in line: ',num2str(ME.stack(n).line)])
        disp('_________________________________________')
        disp('  ')
    end
end
end
