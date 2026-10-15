clc; clear; close all

season = "summer"; %======================================================== CHECK SEASON

path = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Meteorological\" + season + "\saved_" + season + "_hbaro_m_fulldata.parquet";
pathsave = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Meteorological\" + season + "\saved_" + season + "_rainflow_sigmahoop_randomized_cycle_pair_RNG136"; 

h = table2array(parquetread(path));
h = h(1:1e6);

r = 6.774/2; %See SolidWorks three view measurement, cabin radius (meter)
t = 1.81e-3; %See ASC Flight Accident Report page 159 through reverse calculation, fuselage skin thickness (meter), 100/13.5 of 0.0096 inch eq. to 0.711 inch

sigmahoop = calcAircraftSigmaHoop(h, r, t); %obtain sigma hoop due to pressurization

%filter QAR data
fs = 4;          % Sampling frequency [Hz]
fc = 0.03;       % Cutoff frequency [Hz]
order = 4;       % Butterworth filter order
Wn = fc/(fs/2);  % Normalized cutoff frequency
[b,a] = butter(order, Wn, "low");
sigmahoopfiltered = filtfilt(b, a, sigmahoop);

plot(sigmahoop)
hold on
plot(sigmahoopfiltered, "LineStyle", "-", "LineWidth", 1.5, "Color", "g")
ylim([-1e9 1e9]) 

sigmahoop = rainflow(sigmahoop); %rainflow counting


%extract cycle counts, maximas, and minimas
cycle_counts = sigmahoop(:,1);
maxima = sigmahoop(:,3) + sigmahoop(:,2)/2; maxima = sort(maxima, "descend");
minima = sigmahoop(:,3) - sigmahoop(:,2)/2; minima = sort(minima, "ascend");
semilogx(sort(sigmahoop(:,2), "descend"))
figure

clearvars sigmahoop

%remove crossing maximas and minimas
maxima_true = maxima(1 : find(maxima > minima, 1, "last"));
minima_true = minima(1 : find(maxima > minima, 1, "last"));
cycle_counts = cycle_counts(1 : find(maxima > minima, 1, "last"));

clearvars az maxima minima

%create discretized maxima minima exceedance curve
[occurrence, x, maxima_true, minima_true] = createPeakVallDiscExce(12, cycle_counts, maxima_true, minima_true);

semilogx(x, maxima_true)
hold on
semilogx(x, minima_true)

clearvars cycle_counts

% ============================================ RAINFLOW COUNTING CYCLE PAIRING ============================================

maxima_true = maxima_true(1:2:numel(maxima_true)-1); %get only unique values
minima_true = minima_true(1:2:numel(minima_true)-1); %get only unique values

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
rand_idx = randperm(height(rainflow_result)); %this is the random permutation index

rainflow_randomized = rainflow_result(rand_idx, :); %randomize rainflow cycle pair result using random permutation index

clearvars rainflow_result

parquetwrite(pathsave, rainflow_randomized)

%%
%{
clearvars -except pathsave season
path1 = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Meteorological\saved_" + season + "_half1_rainflow_azmps2_randomized_cycle_pair_RNG136.parquet";
path2 = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Meteorological\saved_" + season + "_half2_rainflow_azmps2_randomized_cycle_pair_RNG136.parquet";
path = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Meteorological\saved_" + season + "_rainflow_azmps2_randomized_cycle_pair_RNG136";
% b = parquetread(path);

az = [table2array(parquetread(path1)); table2array(parquetread(path2))];
az = array2table(az, "VariableNames", ["maxima" "minima"]);
parquetwrite(path, az)
%}