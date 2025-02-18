%csvinputpath = "D:\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\standards_test\standards_test.csv";
%filepath = "D:\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\standards_test\standards_test_log_20231211_140206.log";

%csvinputpath = "D:\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\Natalia Spotsizes\618NW.csv";

% Importing the raw data
%fullsignal_raw = readtable(csvinputpath);
%num_spots = 59;
%[spotname, spotsize, fired] = extract_logfile_data(filepath);
%num_spots = numel(spotname);

function [signal_starts, signal_ends, cleaningshot_starts, cleaningshot_ends] = detect_signals(fullsignal_raw, num_spots)
% Extracting information out of the raw data
fullsignal_processed = fullsignal_raw;
fullsignal_processed.totalcounts = sum(table2array(fullsignal_raw(:,2:end)), 2, 'omitnan');

% Normalizing the totalcounts
min_totalcounts = min(fullsignal_processed.totalcounts);
max_totalcounts = max(fullsignal_processed.totalcounts);

% Bisection method to find the optimal threshold
threshold_low = 0;
threshold_high = 1;
tolerance = 1e-9;

while (threshold_high - threshold_low) > tolerance
    threshold_mid = (threshold_low + threshold_high) / 2;
    [signal_starts, signal_ends, cleaningshot_starts, cleaningshot_ends] = classify_signals(threshold_mid, fullsignal_processed, min_totalcounts, max_totalcounts);

    if length(signal_starts) == num_spots && length(signal_ends) == num_spots
        break;
    elseif length(signal_starts) < num_spots
        threshold_high = threshold_mid;
    else
        threshold_low = threshold_mid;
    end
end

% Final classification with the optimal threshold
optimal_threshold = threshold_mid;
[signal_starts, signal_ends, cleaningshot_starts, cleaningshot_ends] = classify_signals(optimal_threshold, fullsignal_processed, min_totalcounts, max_totalcounts);

% Function to classify data points and count signal starts and ends
    function [signal_starts, signal_ends, cleaningshot_starts, cleaningshot_ends] = classify_signals(threshold, fullsignal_processed, min_totalcounts, max_totalcounts)
        fullsignal_processed.normalized_totalcounts = (fullsignal_processed.totalcounts - min_totalcounts) / (max_totalcounts - min_totalcounts);
        fullsignal_processed.classification = zeros(height(fullsignal_processed), 1); % Initialize the classification column
        fullsignal_processed.classification(fullsignal_processed.normalized_totalcounts >= threshold) = 1;

        % Clear out single spikes
        logicalArray = fullsignal_processed.classification;
        logicalArray = reshape(logicalArray, 1, []);
        charArray = num2str(logicalArray);
        charArray = strrep(charArray, ' ', '');
        pattern_spike = '0{1}1{1}0{1}';
        spikes = (regexp(charArray, pattern_spike))+1;

        for o = spikes
            fullsignal_processed.classification(o) = 0;
            fullsignal_processed.normalized_totalcounts(o) = fullsignal_processed.normalized_totalcounts(o+1);
        end

        % Find where the signals start and end
        starts = find(diff(fullsignal_processed.classification == 1) == 1);
        ends = find(diff(fullsignal_processed.classification == 1) == -1);

        % Filter the ends of the signals
        signal_starts = [];
        signal_ends = [];
        cleaningshot_starts = [];
        cleaningshot_ends = [];

        lengths = ends - starts;

        for i = 1:length(ends)
            if ends(i) - starts(i) > mean(lengths)
                signal_starts = [signal_starts; starts(i)];
                signal_ends = [signal_ends; ends(i)];
            else
                cleaningshot_starts = [cleaningshot_starts; starts(i)];
                cleaningshot_ends = [cleaningshot_ends; ends(i)];
            end
        end
    end



end




