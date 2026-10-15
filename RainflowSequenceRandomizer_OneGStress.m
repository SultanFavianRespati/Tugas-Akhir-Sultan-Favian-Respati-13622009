clc; clear; close all

% season = "winter"; %======================================================== CHECK SEASON
% 
% path = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Meteorological\" + season + "\saved_" + season + "_hdotdot_patched_az_outliers.parquet"; %======================================================== CHECK SEASON
% pathsave = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Meteorological\" + season + "\saved_" + season + "_rainflow_azmps2_randomized_cycle_pair_RNG136"; 

path = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\saved_hdotdot_patched_az_outliers2_fulldata.parquet";
pathsave = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\saved_rainflow_azmps2_randomized_cycle_pair_RNG136_fulldata";
az = table2array(parquetread(path));


%filter QAR data, See paper by Khelif (just use this one istg bru u tired)
fs = 16;         % Sampling frequency [Hz]
fc = 3;       % Cutoff frequency [Hz]
order = 4;       % Butterworth filter order
Wn = fc/(fs/2);  % Normalized cutoff frequency
[b,a] = butter(order, Wn, "low");
az = filtfilt(b, a, az);

% plot(az(1:1e6))
% hold on
% plot(azfiltered(1:1e6), "LineStyle", "-", "LineWidth", 1.5, "Color", "g")
% ylim([-1e3 1e3]) 


az = rainflow(az);

cycle_counts = az(:,1);
maxima = az(:,3) + az(:,2)/2; maxima = sort(maxima, "descend");
minima = az(:,3) - az(:,2)/2; minima = sort(minima, "ascend");

clearvars az

maxima_true = maxima(1 : find(maxima > minima, 1, "last"));
minima_true = minima(1 : find(maxima > minima, 1, "last"));
cycle_counts = cycle_counts(1 : find(maxima > minima, 1, "last"));

clearvars maxima minima

[occurrence, x, maxima_true, minima_true] = createPeakVallDiscExce(12, cycle_counts, maxima_true, minima_true);

% semilogx(x, maxima_true)
% hold on
% semilogx(x, minima_true)

clearvars x cycle_counts

% ============================================ RAINFLOW COUNTING CYCLE PAIRING ============================================

maxima_true = maxima_true(1:2:numel(maxima_true)-1); %get only unique values
minima_true = minima_true(1:2:numel(minima_true)-1);

rainflow_result = cell(numel(occurrence),1); %prepare the cells of the rainflow cycle pair

%create duplicates of maximas and minimas as many as there is number of
%occurence of each discrete block
for ii = 1:numel(occurrence)
    rainflow_result{ii} = [ones(occurrence(ii),1)*maxima_true(ii) ones(occurrence(ii),1)*minima_true(ii)];
end

clearvars maxima_true minima_true occurrence

%save the result (maxima & minima) as table for ease of var calling.
rainflow_result = vertcat(rainflow_result{:});
rainflow_result = array2table(rainflow_result, "VariableNames", ["maxima" "minima"]);


% ============================================ RAINFLOW COUNTING CYCLE PAIR RANDOMIZER ============================================

rng(136); % set the seed
rand_idx = randperm(height(rainflow_result)); %random permutation index

rainflow_randomized = rainflow_result(rand_idx, :); %randomize rainflow cycle pair result using random permutation index

clearvars rainflow_result

parquetwrite(pathsave, rainflow_randomized)