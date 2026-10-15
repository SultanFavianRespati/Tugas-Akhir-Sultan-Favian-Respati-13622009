clc; clear; close all

path = "C:\Users\Sultan F. Respati\Documents\00. TA\Flight Data KMSP 30R\flight_N100054.zip\652200101201529.csv";

opt = detectImportOptions(path);
opt.SelectedVariableNames = "az_mps2";

az = readmatrix(path, opt);
az = az - 9.80665;
az = az(~isnan(az));
az = az(az ~= min(az));

az = rainflow(az);
maxima = az(:,3) + az(:,2)*0.5; maxima = sort(maxima, "descend");
minima = az(:,3) - az(:,2)*0.5; minima = sort(minima, "ascend");
cumex = (1:numel(maxima))';

semilogx(cumex, maxima)
hold on
semilogx(cumex, minima)
yline(0, ":")
xlabel("kelampauan kumulatif (cummulative exceedance)")
ylabel("akselerasi vertikal (m/s^2)")
legend(["maxima" "minima"])

% [occ, x, maxima, minima] = createPeakVallDiscExce(12, count, maxima, minima);