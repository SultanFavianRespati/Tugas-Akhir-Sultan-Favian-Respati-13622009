clc; clear; close all

seq = parquetread("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\saved_rainflow_azmps2_randomized_cycle_pair_RNG136_fulldata.parquet");

minimas = seq.minima;
maximas = seq.maxima;

seq = zeros(numel(minimas)*2,1);

seq(1:2:numel(seq)-1) = minimas;
seq(2:2:numel(seq)) = maximas;

plot(seq)
xlabel("Sekuens")
ylabel("Perubahan Akselerasi Vertikal (m/s^2)")
parquetwrite("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\saved_rainflow_azmps2_randomized_sequence_RNG136_fulldata", array2table(seq))