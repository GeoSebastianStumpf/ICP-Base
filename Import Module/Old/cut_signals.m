
function [signal_data, icp_signals_processed, icp_signals_raw] = cut_signals(filepath)

    %% importing the raw data
    icp_signals_raw = readtable(filepath);
    
    %% extracting informations out of the raw data
    
    icp_signals_processed = icp_signals_raw;
    icp_signals_processed.totalcounts = sum(table2array(icp_signals_raw(:,2:end)),2,'omitnan');
    
    %% define the background and the signal --> signal = 1, background = 0 with totalcounts
    
    % Calculate the median of the total counts
    M = median(icp_signals_processed.totalcounts);
    % Calculate the Median Absolute Deviation of the total counts
    MAD = median(abs(icp_signals_processed.totalcounts - M));
    % Calculate the Robust Z-Score
    icp_signals_processed.robust_z_score = (icp_signals_processed.totalcounts - M) / MAD;
    
    % Classify the data points where the Robust Z-Score is less than a threshold as background
    threshold = 10; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    icp_signals_processed.classification(icp_signals_processed.robust_z_score < threshold) = 0;
    icp_signals_processed.classification(icp_signals_processed.robust_z_score >= threshold) = 1;

    %% clear out single spikes
    
    %Define a logical array
    logicalArray = icp_signals_processed.classification;
    % Reshape the logical array into a row vector
    logicalArray = reshape(logicalArray, 1, []);
    % Convert the logical array to a string
    charArray = num2str(logicalArray);
    % Remove any whitespace in the string
    charArray = strrep(charArray, ' ', '');
    % Define the pattern you want to find
    pattern_spike = '0{1}1{1}0{1}'; %for patterns like 010
    
    spikes = (regexp(charArray, pattern_spike))+1;
    
    for o = spikes
        icp_signals_processed.classification(o) = 0;
        icp_signals_processed.robust_z_score(o) = icp_signals_processed.robust_z_score(o+1);
    end
    
    %% find where the signals start and end
    
    starts = find(diff(icp_signals_processed.classification == 1) == 1);
    ends = find(diff(icp_signals_processed.classification == 1) == -1);
    
    %filter the ends of the signals
    %if the length between the start of a signal and its end is more than a
    %threshold it is a proper signal, otherwise it is a cleaning shot
    
    signal_starts = [];
    signal_ends = [];
    cleaningshot_starts = [];
    cleaningshot_ends = [];
    
    % Calculate the lengths of all signals
    lengths = ends - starts;
    
    % Classify the signals
    % the lengths are always e.g. 9, 58, 8, 58, 9, 57 and so on, always a
    % cleaning shot and a signal, everything above the mean of these lengths is
    % classified as a signal and below as a cleaning shot
    for i = 1:length(ends) 
        if ends(i) - starts(i) > mean(lengths)
            signal_starts = [signal_starts; starts(i)];
            signal_ends = [signal_ends; ends(i)];
        else
            cleaningshot_starts = [cleaningshot_starts; starts(i)];
            cleaningshot_ends = [cleaningshot_ends; ends(i)];
        end
    end
    
    %% slice all signals into blocks using always the ends of the signals
    
    %get the first signal
    median_distancebetweensignalends = median(diff(signal_ends));
    start_index = max(1, signal_ends(1)-median_distancebetweensignalends);
    signal_data(1).signal = icp_signals_processed(start_index:signal_ends(1), 1:size(icp_signals_raw, 2));
    
    %get all signals between the first and the last one
    for i = 2:length(signal_ends)
        % Check if next index is within bounds
        if i <= length(signal_ends)
            signal_data(i).signal = icp_signals_processed(signal_ends(i-1)+5:signal_ends(i)+5, 1:size(icp_signals_raw, 2));
        else
            % Handle the last signal separately
            signal_data(i).signal = icp_signals_processed(signal_ends(i-1)+5:end, 1:size(icp_signals_raw, 2));
        end
    end

   
   

end