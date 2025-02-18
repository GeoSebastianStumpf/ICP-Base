% this function has to be able to take the output of the cut_signals
% function and it should also be able to just input the single signal csv
% input files if the files were aquired with the stop and go method. Up to
% now it only works with the input from cut_signals

% this could also be done by machine learning by giving it a training set
% where the intervals are set and then letting it predict the intervals for
% a test set. So the intervals need to be predicted, everything else is
% given

%% this works with SIGDAT but it has to work with UNK and STD
function [cut_sig] = set_automatic_intervals(cut_sig) %,thxs

    threshold = 100; % this is higher here
    for i = 1:length(cut_sig)
        cut_sig(i).signal.totalcounts = sum(table2array(cut_sig(i).signal(:,2:end)),2,'omitnan');

        M = median(cut_sig(i).signal.totalcounts);
        MAD = median(abs(cut_sig(i).signal.totalcounts - M));
        cut_sig(i).signal.robust_z_score = (cut_sig(i).signal.totalcounts - M) / MAD;
        cut_sig(i).signal.classification(cut_sig(i).signal.robust_z_score < threshold) = 0;
        cut_sig(i).signal.classification(cut_sig(i).signal.robust_z_score >= threshold) = 1;

        %make the first 15 classifications 0 so that there are no problems with
        % the signal from before
        cut_sig(i).signal.classification(1:15) = 0;

        % Clear out single spikes
        logicalArray = cut_sig(i).signal.classification;
        logicalArray = reshape(logicalArray, 1, []);
        charArray = num2str(logicalArray);
        charArray = strrep(charArray, ' ', '');
        pattern_spike = '0{1}1{1}0{1}'; %for patterns like 010
        spikes = (regexp(charArray, pattern_spike))+1;
        for o = spikes
            cut_sig(i).signal.classification(o) = 0;
            cut_sig(i).signal.robust_z_score(o) = cut_sig(i).signal.robust_z_score(o+1);
        end

        %find the starts and ends of the signals and cleaning shots
        start = find(diff(cut_sig(i).signal.classification == 1) == 1);
        ende = find(diff(cut_sig(i).signal.classification == 1) == -1);
        % Ensure the first 10 entries are always 0
        cut_sig(i).signal.classification(1:15) = 0;

        signal_start = [];
        signal_end = [];
        cleaningshot_start = [];
        cleaningshot_end = [];
        laenge = ende - start;

            %if the signal is longer than the mean of all signal lengths it
            %is a signal, otherwise it is a cleaning shot
        for j = 1:length(ende) 
            if ende(j) - start(j) > mean(laenge)
                signal_start = [signal_start; start(j)];
                signal_end = [signal_end; ende(j)];
            else
                cleaningshot_start = [cleaningshot_start; start(j)];
                cleaningshot_end = [cleaningshot_end; ende(j)];
            end
        end


        %% up to here, it just gets the starts and ends of the signals
        %% maybe it would just be easiest to say that 20 sweeps before the threshold has to lower than the threshold
        %then the signal starts and we have the start. So get the average
        %of 20 sweeps and check if the next 4 sweeps are all higher than
        %that, this means that a signal started.


        %sig_start_th=8

        %if not (exist("thxs","var"))
            %if isfield(thxs, "sig_start_th") && isnumeric(thxs.sig_start_th)
            %    sig_start_th=thxs.sig_start_th;
            %end
           % if isfield(thxs, "sig_start_th") && isnumeric(thxs.sig_start_th)
           %     sig_start_th=thxs.sig_start_th;
           % end
        %end

        %set the signal intervals
        signal_start_dist = 8; %these values can be changed in the app designer to change the intend globally
        signal_end_dist = 11;
        cut_sig(i).signal_interval_starts_time = cut_sig(i).signal.Time_Sec_(signal_start + signal_start_dist); %thxs
        cut_sig(i).signal_interval_ends_time = cut_sig(i).signal.Time_Sec_(signal_end - signal_end_dist);

        %set the background intervals
        bg_start_dist = 10;
        bg_end_dist = 5;
        cut_sig(i).background_interval_starts_time = cut_sig(i).signal.Time_Sec_(bg_start_dist);
        cut_sig(i).background_interval_ends_time = cut_sig(i).signal.Time_Sec_(cleaningshot_start - bg_end_dist);

        %store the windows into arrays
        cut_sig(i).bgwindow = [cut_sig(i).background_interval_starts_time, cut_sig(i).background_interval_ends_time];
        cut_sig(i).sigwindow = [cut_sig(i).signal_interval_starts_time, cut_sig(i).signal_interval_ends_time];

        %store the start and end indices of the intervals in arrays
        cut_sig(i).bg_indices = [bg_start_dist, cleaningshot_start - bg_end_dist];        
        cut_sig(i).signal_indices = [signal_start + signal_start_dist, signal_end - signal_end_dist];

        %store the data within the signal and background intervals
        cut_sig(i).data_cps_bg = cut_sig(i).signal(cut_sig(i).bg_indices(1):cut_sig(i).bg_indices(2), 2:end); %this fails if Time is not the first column
        cut_sig(i).data_cps_sig = cut_sig(i).signal(cut_sig(i).signal_indices(1):cut_sig(i).signal_indices(2), 2:end);%this fails if Time is not the first column

    end

    %remove the initialzed columns again
    for i = 1:length(cut_sig)
        cut_sig(i).signal = removevars(cut_sig(i).signal, {'totalcounts', 'robust_z_score', 'classification'});
        cut_sig(i).data_cps_bg = removevars(cut_sig(i).data_cps_bg, {'totalcounts', 'robust_z_score', 'classification'});
        cut_sig(i).data_cps_sig = removevars(cut_sig(i).data_cps_sig, {'totalcounts', 'robust_z_score', 'classification'});
    end

end

