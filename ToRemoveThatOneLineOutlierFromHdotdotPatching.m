clc; clear; close all

path = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\saved_hdotdot_patched_az_outliers.parquet";

az = table2array(parquetread(path));
az(0.5e8+1e7+420354:0.5e8+1e7+561985) = NaN;
az(0.5e8+1e7+420354-1:0.5e8+1e7+561985+1) = fillmissing(az(0.5e8+1e7+420354-1:0.5e8+1e7+561985+1), "linear");

plot(az, ".")
ylabel("vertical acceleration m/s^2")
xlabel("sample")