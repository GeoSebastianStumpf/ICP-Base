function [spotname] = read_resonetics_verbose_log(filepath)
    % Open the file
    logfile = fopen(filepath,'r');

    % Check if the file was opened successfully
    if logfile == -1
        error('Cannot open file')
    end

    % Define the patterns to search for
    pattern_pointnumbers = 'Point #(\d+)';
    pattern_spotname = 'Comment: "(.*)"';
    pattern_spotsize = 'Spot Size: (\d+)';
    pattern_date = '\d{4}-\d{2}-\d{2}';
    pattern_rep_rate = 'Rep. Rate:';
    pattern_fired = 'Fired: (\d+)';

    % Initialize empty arrays and cells and variables
    pointnumbers = [];
    spotsize = [];
    measuringdate = {};
    spotname = {};
    found_rep_rate = false;
    found_ablation = false;
    fired = [];

    % Extract the date from the first line
    lineone = fgets(logfile);
    matches_date = regexp(lineone, pattern_date, 'match');
    if ~isempty(matches_date)
        % Rewrite the date
        date_parts = split(matches_date{1}, '-');
        measuringdate = [date_parts{3}, date_parts{2}, date_parts{1}];
    end

    % Read the file line by line
    while ~feof(logfile)
        line = fgets(logfile);

        % check for = Ablation =
        if contains(line, '= Ablation =')
            found_ablation = true;
        end

        % get the fired value
        if contains(line, 'Fired:') && found_ablation
            % Extract the fired value
            matches_fired = regexp(line, pattern_fired, 'tokens');
            if ~isempty(matches_fired)
                % Add the fired value to the array
                fired = [fired; str2double(matches_fired{1}{1})];
            end
            found_ablation = false;
        end

        % get the spot number
        if contains(line, 'Point #')
            % Extract the number after "Point #"
            matches_pointnumbers = regexp(line, pattern_pointnumbers, 'tokens');
            if ~isempty(matches_pointnumbers)
                % Convert the number to a double and append it to the array
                pointnumbers = [pointnumbers; str2double(matches_pointnumbers{1}{1})];
            end
        end

        % get the spotname
        if contains(line, 'Comment:')
            % Extract the comment
            matches_spotname = regexp(line, pattern_spotname, 'tokens');
            if ~isempty(matches_spotname)
                % Add the comment to the cell array
                spotname = [spotname; matches_spotname{1}{1}];
            end
        end

        % check for Rep. Rate
        if contains(line, pattern_rep_rate)
            found_rep_rate = true;
        end

        % get the spot size
        if contains(line, 'Spot Size:') && found_rep_rate
            % Extract the spot size
            matches_spotsize = regexp(line, pattern_spotsize, 'tokens');
            if ~isempty(matches_spotsize)
                % Add the spot size to the cell array
                spotsize = [spotsize; str2double(matches_spotsize{1}{1})];
            end
            found_rep_rate = false;
        end
    end

    fclose(logfile);

    %% be sure that every entry made above is deleted here if the laser did not fire
    % this could be somehow connected to the check of time intervals of the
    % signals below

    for i=length(fired):-1:1
        if fired(i) == 0
            % delete the ith entry in spotname, spotsize, pointnumbers and fired
            spotname(i) = [];
            spotsize(i) = [];
            pointnumbers(i) = [];
            fired(i) = [];
        end
    end
    % 
    % %% Check the spotname and if it contains e.g. GSD classify it as a standard
    % % Initialize an empty cell array for classification
    % std_unk_classification = cell(size(spotname));
    % 
    % % Loop through each entry in spotname
    % for i = 1:length(spotname)
    %     % Check if the entry contains 'GSD'
    %     if contains(spotname{i}, 'GSD') || contains(spotname{i}, 'SRM')
    %         std_unk_classification{i} = 1;
    %     else
    %         std_unk_classification{i} = 0;
    %     end
    % end
    % 
    % for i = 1:length(spotname)
    %     % Check if the entry contains 'GSD'
    %     if contains(spotname{i}, 'GSD')
    %         default_srm{i} = 'GSD-1G.xls';
    %     elseif contains(spotname{i}, 'Sca')
    %         default_srm{i} = 'Sca_17.xls';
    %     end
    % end

end