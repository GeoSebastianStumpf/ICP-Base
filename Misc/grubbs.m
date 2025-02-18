% % Generate data with spikes
% rng(42);
% n_rows = 100;
% n_cols = 10;
% data = abs(randn(n_rows, n_cols));
% 
% % Add random spikes
% n_spikes = 3;
% for col = 1:n_cols
%     spike_idx = randperm(n_rows, n_spikes);
%     data(spike_idx, col) = abs(data(spike_idx, col)) * 5;
% end

clc
clear

import = readtable("D:\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\Alm06_Min\Alm-Min-1.csv");
data = table2array(import(:, 2));


% Constants from second implementation
cpvalueseven = 2.097; % For N=7 measurements
cpvaluenine = 2.323;  % For N=9 measurements

% Apply correction using moving window
corrected_data = data;
for col = 1:size(data,2)
    tstep = 5;
    while tstep < size(data,1)-4
        % Get window values
        csp = data(tstep,col);
        onebefore = data(tstep-1,col);
        oneafter = data(tstep+1,col);
        twobefore = data(tstep-2,col);
        twoafter = data(tstep+2,col);
        threebefore = data(tstep-3,col);
        threeafter = data(tstep+3,col);
        fourafter = data(tstep+4,col);
        fourbefore = data(tstep-4,col);
        
        % Calculate statistics for both windows
        window7 = [onebefore, oneafter, twoafter, twobefore, threebefore, threeafter, csp];
        window9 = [window7, fourafter, fourbefore];
        
        stdseven = std(window7);
        meanseven = mean(window7);
        stdnine = std(window9);
        meannine = mean(window9);
        
        % Check if point is outlier using both criteria
        if ((abs(csp - meanseven))/stdseven) > cpvalueseven && ...
           ((abs(csp - meannine))/stdnine) > cpvaluenine
            
            % Replace with average of surrounding points (excluding current point)
            surrounding = [onebefore, oneafter, twoafter, twobefore, threebefore, threeafter];
            corrected_data(tstep,col) = mean(surrounding);
        end
        tstep = tstep + 1;
    end
end

% Visualize results
figure('Position', [100 100 1200 600]);

% Original data with detected outliers
subplot(2,1,1)
plot(data)
hold on

for col = 1:size(data,2)
    for tstep = 5:size(data,1)-4
        % Recheck for outliers to mark them
        window7 = [data(tstep-1,col), data(tstep+1,col), data(tstep+2,col), ...
                  data(tstep-2,col), data(tstep-3,col), data(tstep+3,col), data(tstep,col)];
        window9 = [window7, data(tstep+4,col), data(tstep-4,col)];
        
        if ((abs(data(tstep,col) - mean(window7)))/std(window7)) > cpvalueseven && ...
           ((abs(data(tstep,col) - mean(window9)))/std(window9)) > cpvaluenine
            plot(tstep, data(tstep,col), 'rx', 'MarkerSize', 10)
        end
    end
end

hold off
title('Original Data with Spikes (outliers marked in red)')
xlabel('Sample')
ylabel('Value')
yscale('log')
grid on

% Corrected data
subplot(2,1,2)
plot(corrected_data)
title('Data after Moving Window Grubbs Test Correction')
xlabel('Sample')
ylabel('Value')
yscale('log')
grid on

%%

clc
clear

import = readtable("D:\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\Alm06_Min\Alm-Min-1.csv");
data = table2array(import(:, 2:end));

% Constants
cpvalueseven = 2.097; % For N=7 measurements, significance level 1%
cpvaluenine = 2.323;  % For N=9 measurements, significance level 1%
%Lower threshold for spike identification, prevents identification of a
%spike each time for sporadically occurring elements
threshold = 500;     % Minimum threshold for spike detection [cps]

% Apply correction using moving window
corrected_data = data;
for col = 1:size(data,2)
    tstep = 5;
    while tstep < size(data,1)-4
        % Only check points above threshold
        if data(tstep,col) > threshold
            % Get window values
            csp = data(tstep,col);
            onebefore = data(tstep-1,col);
            oneafter = data(tstep+1,col);
            twobefore = data(tstep-2,col);
            twoafter = data(tstep+2,col);
            threebefore = data(tstep-3,col);
            threeafter = data(tstep+3,col);
            fourafter = data(tstep+4,col);
            fourbefore = data(tstep-4,col);
            
            % Calculate statistics for both windows
            window7 = [onebefore, oneafter, twoafter, twobefore, threebefore, threeafter, csp];
            window9 = [window7, fourafter, fourbefore];
            
            stdseven = std(window7);
            meanseven = mean(window7);
            stdnine = std(window9);
            meannine = mean(window9);
            
            % Check if point is outlier using both criteria
            if ((abs(csp - meanseven))/stdseven) > cpvalueseven && ...
               ((abs(csp - meannine))/stdnine) > cpvaluenine
                
                % Replace with average of surrounding points (excluding current point)
                surrounding = [onebefore, oneafter, twoafter, twobefore, threebefore, threeafter];
                corrected_data(tstep,col) = mean(surrounding);
            end
        end
        tstep = tstep + 1;
    end
end

% % Visualize results
% figure('Position', [100 100 1200 600]);
% 
% % Original data with detected outliers
% subplot(2,1,1)
% plot(data)
% hold on
% yline(threshold, 'r--', 'Threshold')

% for col = 1:size(data,2)
%     for tstep = 5:size(data,1)-4
%         % Only check points above threshold
%         if data(tstep,col) > threshold
%             % Recheck for outliers to mark them
%             window7 = [data(tstep-1,col), data(tstep+1,col), data(tstep+2,col), ...
%                       data(tstep-2,col), data(tstep-3,col), data(tstep+3,col), data(tstep,col)];
%             window9 = [window7, data(tstep+4,col), data(tstep-4,col)];
% 
%             if ((abs(data(tstep,col) - mean(window7)))/std(window7)) > cpvalueseven && ...
%                ((abs(data(tstep,col) - mean(window9)))/std(window9)) > cpvaluenine
%                 plot(tstep, data(tstep,col), 'rx', 'MarkerSize', 10)
%             end
%         end
%     end
% end

% hold off
% title('Original Data with Spikes (outliers marked in red)')
% xlabel('Sample')
% ylabel('Value')
% yscale('log')
% grid on
% 
% % Corrected data
% subplot(2,1,2)
% plot(corrected_data)
% hold on
% yline(threshold, 'r--', 'Threshold')
% hold off
% title('Data after Moving Window Grubbs Test Correction')
% xlabel('Sample')
% ylabel('Value')
% yscale('log')
% grid on