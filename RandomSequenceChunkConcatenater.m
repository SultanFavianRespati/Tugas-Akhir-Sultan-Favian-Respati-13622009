clc; clear; close all

path1 = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Meteorological\saved_fall_half1_rainflow_azmps2_randomized_sequence_RNG136.parquet";
path2 = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Meteorological\saved_fall_half2_rainflow_azmps2_randomized_sequence_RNG136.parquet";
path = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Meteorological\saved_fall_rainflow_azmps2_randomized_sequence_RNG136";
% b = parquetread(path);

az = [table2array(parquetread(path1)); table2array(parquetread(path2))];
az = array2table(az, "VariableNames", "randomized_sequence_RNG136");
parquetwrite(path, az)