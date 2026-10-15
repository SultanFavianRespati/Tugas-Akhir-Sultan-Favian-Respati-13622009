clc; clear; close all

path = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Meteorological\saved_winter_hdotdot_patched_az_outliers.parquet";

az = table2array(parquetread(path));

% plot(az, "."); ylim([-100 100])

% az = getSpecificVarDataWithNaN(path, "az_mps2");
% az(az == min(az)) = NaN;
% az = fillmissing(az, "linear");
% az = az-mean(az(1:1000));

% ======================SETUP LEVEL CROSSING COUNTING BINS======================
level_int = 0.1; 
tolerance = 0.05; % tolerance is given to prevent noise being counted during on ground
limit_bot = -10;
limit_top = 10;
levels = flip([(limit_bot:level_int:-level_int) tolerance (level_int:level_int:limit_top)]');

% ======================LEVEL CROSSING COUNTING======================
level_counts = lc_fast(az, levels)/2; % pre-made function shared on Matlab file exchange website

% ======================CYCLE PAIRING======================
ii = 1; % declare iteration variable
cycle_counts = zeros(numel(levels), 1);
maxima = zeros(numel(levels), 1);
minima = zeros(numel(levels), 1);

level_counts(level_counts == 0) = NaN;

while any(~isnan(level_counts))
    cyc_counts_min = min(level_counts);
    maxima(ii) = levels(find(~isnan(level_counts), 1, "first"));
    minima(ii) = levels(find(~isnan(level_counts), 1, "last"));

    level_counts = level_counts - cyc_counts_min;

    cycle_counts(ii) = cyc_counts_min;

    ii = ii + 1;
    level_counts(level_counts == 0) = NaN;

end

%"empty" array clearing
minima = minima(minima ~= 0);
maxima = maxima(maxima ~= 0);
cycle_counts = cycle_counts(cycle_counts ~= 0);

% ======================MAXIMA MINIMA DISCRETIZED EXCEEDANCE CURVE======================
cumex = cumsum(cycle_counts);
[occurence, x, ypeak, yvall] = createPeakVallDiscExce(12, cycle_counts, maxima, minima);

%plot
figure
semilogx(x, ypeak)
hold on
semilogx(x, yvall)
hold on
semilogx(cumex, maxima, "g")
hold on
semilogx(cumex, minima, "m")

% ======================LEVEL CROSSING COUNTING SEQUENCE RANDOMIZER======================

maxima = unique(ypeak, "stable");
minima = unique(yvall, "stable");
range = maxima-minima;

levelcross_result = cell(numel(occurence),1);

for ii = 1:numel(occurence)
    levelcross_result{ii} = [ones(occurence(ii),1)*maxima(ii) ones(occurence(ii),1)*minima(ii) ones(occurence(ii),1)*range(ii) ones(occurence(ii),1)*occurence(ii)];
end

levelcross_result = vertcat(levelcross_result{:});
levelcross_result = array2table(levelcross_result, "VariableNames", ["maxima" "minima" "range" "count"]);

%% ==========================================================
rng
rand_idx = randperm(numel(levelcross_result.count));

levelcross_randomized = levelcross_result(rand_idx, :);

sequence_randomized = cell(numel(levelcross_randomized.count)+2,1);
sequence_randomized{1} = 0; sequence_randomized{end} = 0;

for ii = 1:numel(levelcross_randomized.count)
    sequence_randomized{ii+1} = [levelcross_randomized.maxima(ii); levelcross_randomized.minima(ii)];
end

sequence_randomized = vertcat(sequence_randomized{:});

figure
plot(sequence_randomized)
ylim([-1000 1000])

% ======================================================================
rf = rainflow(sequence_randomized);
[occur, xexc, yexc] = createRangeDiscExce(12, rf(:,1), rf(:,2));

figure
semilogx(xexc, yexc)