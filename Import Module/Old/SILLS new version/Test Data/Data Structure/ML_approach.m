

%% importing the raw data
%training_data = readtable("D:\OneDrive - Universitaet Bern\PhD\Programs\SILLS new version\Signal Cutter\Mineral Analysis\Uncut Signals.csv");
test_data_1 = readtable("D:\OneDrive - Universitaet Bern\PhD\Data\Almirez\LA-ICP-MS Data\Minerals\30.11.2023\Alm-Min-1.csv");
training_data = readtable("D:\OneDrive - Universitaet Bern\PhD\Programs\SILLS new version\Test Data\Mineral Analysis\Diego Data\Sulfides_DT\040424_sulfides.csv");

%% extracting informations out of the raw data

icp_signals_processed = training_data;
icp_signals_processed.totalcounts = sum(table2array(training_data(:,2:end)),2,'omitnan');

%% calculate more parameters and add them to the table to have mor things to learn on

% Calculate the median of the total counts
M = median(icp_signals_processed.totalcounts);
% Calculate the Median Absolute Deviation of the total counts
MAD = median(abs(icp_signals_processed.totalcounts - M));
% Calculate the Robust Z-Score
icp_signals_processed.robust_z_score = (icp_signals_processed.totalcounts - M) / MAD;

% Classify the data points where the Robust Z-Score is less than a threshold as background
threshold = 5; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
icp_signals_processed.classification(icp_signals_processed.robust_z_score < threshold) = 0;
icp_signals_processed.classification(icp_signals_processed.robust_z_score >= threshold) = 1;

% Normalize the totalcounts data
icp_signals_processed.totalcounts_normalized = (icp_signals_processed.totalcounts - min(icp_signals_processed.totalcounts)) / (max(icp_signals_processed.totalcounts) - min(icp_signals_processed.totalcounts));

% Classify the data points where the Robust Z-Score is less than a threshold as background
threshold = 0.05; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
icp_signals_processed.classification_normalized(icp_signals_processed.totalcounts_normalized < threshold) = 0;
icp_signals_processed.classification_normalized(icp_signals_processed.totalcounts_normalized >= threshold) = 1;

% calculate the first and second derivative
for i = 2:size(icp_signals_processed, 2)
    % Skip 'classification' and 'classification_normalized' columns
    if strcmp(icp_signals_processed.Properties.VariableNames{i}, 'classification') || strcmp(icp_signals_processed.Properties.VariableNames{i}, 'classification_normalized')
        continue
    end
    
    % Calculate the first derivative and store it in a new column
    icp_signals_processed.([icp_signals_processed.Properties.VariableNames{i} '_derivative']) = [diff(icp_signals_processed{:, i}); NaN];
    
    % Calculate the second derivative and store it in a new column
    icp_signals_processed.([icp_signals_processed.Properties.VariableNames{i} '_second_derivative']) = [diff(icp_signals_processed{:, i}, 2); NaN; NaN];
end

% Classify with the first derivative
threshold = 1e+05;
icp_signals_processed.classification_derivative(icp_signals_processed.totalcounts_derivative < threshold) = 0;
icp_signals_processed.classification_derivative(icp_signals_processed.totalcounts_derivative >= threshold) = 1;
icp_signals_processed.classification_derivative(icp_signals_processed.totalcounts_derivative < -1e+05) = 1;

% Classify with the second derivative
threshold = 1e+05;
icp_signals_processed.classification_second_derivative(icp_signals_processed.totalcounts_second_derivative < threshold) = 0;
icp_signals_processed.classification_second_derivative(icp_signals_processed.totalcounts_second_derivative >= threshold) = 1;
icp_signals_processed.classification_second_derivative(icp_signals_processed.totalcounts_second_derivative < -1e+05) = 1;

% Classify with Ti
threshold = 1e+04;
icp_signals_processed.classification_Ti(icp_signals_processed.Ti47 < threshold) = 0;
icp_signals_processed.classification_Ti(icp_signals_processed.Ti47 >= threshold) = 1;

% Classify with Co59
threshold = 1e+04;
icp_signals_processed.classification_Co(icp_signals_processed.Co59 < threshold) = 0;
icp_signals_processed.classification_Co(icp_signals_processed.Co59 >= threshold) = 1;


%% plot this shit
% Create a new figure
figure

% Create the first subplot
subplot(5, 1, 1)
hold on
plot(icp_signals_processed.Time_Sec_,icp_signals_processed.totalcounts)
scatter(icp_signals_processed.Time_Sec_, icp_signals_processed.totalcounts, [], icp_signals_processed.classification, 'filled')
xlabel('Time (Sec)')
ylabel('Total Counts')
colorbar
set(gca, 'YScale', 'log')
colormap jet
hold off

% Create the second subplot
subplot(5, 1, 2)
hold on
plot(icp_signals_processed.Time_Sec_,icp_signals_processed.totalcounts)
scatter(icp_signals_processed.Time_Sec_, icp_signals_processed.totalcounts, [], icp_signals_processed.classification_normalized, 'filled')
xlabel('Time (Sec)')
ylabel('Total Counts')
colorbar
set(gca, 'YScale', 'log')
colormap jet
hold off

% Create the third subplot
subplot(5, 1, 3)
hold on
plot(icp_signals_processed.Time_Sec_,icp_signals_processed.totalcounts_derivative)
scatter(icp_signals_processed.Time_Sec_, icp_signals_processed.totalcounts_derivative, [], icp_signals_processed.classification_derivative, 'filled')
xlabel('Time (Sec)')
ylabel('Total Counts Derivative')
hold off

% Create the fourth subplot
subplot(5, 1, 4)
hold on
plot(icp_signals_processed.Time_Sec_,icp_signals_processed.totalcounts_second_derivative)
scatter(icp_signals_processed.Time_Sec_, icp_signals_processed.totalcounts_second_derivative, [], icp_signals_processed.classification_second_derivative, 'filled')
xlabel('Time (Sec)')
ylabel('Total Counts Second Derivative')
hold off

subplot(5, 1, 5)
hold on
plot(icp_signals_processed.Time_Sec_,icp_signals_processed.Ti47)
scatter(icp_signals_processed.Time_Sec_, icp_signals_processed.Ti47, [], icp_signals_processed.classification_Ti, 'filled')
xlabel('Time (Sec)')
ylabel('Ti')
hold off

