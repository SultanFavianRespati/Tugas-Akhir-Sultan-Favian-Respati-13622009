clc; clear; close all

season = "spring";
path = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Meteorological\saved_" +season+ "_hdotdot_patched_az_outliers.parquet";
az = table2array(parquetread(path));

% a = 2e7 + 4e6 + 8e5;
% b = 2e7 + 4e6 + 9e5;
% az = az(a:b);
% t = a*1/16:1/16:b*1/16;

plot(az)
% ylim([-1000 1000])

%%
az(az > 40 | az < -40) = NaN;
az = fillmissing(az, "linear");
figure
plot(az, ".")

%%
az = array2table(az, "VariableNames", "az_mps2");
parquetwrite("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Meteorological\saved_" +season+ "_hdotdot_patched_az_outliers", az)