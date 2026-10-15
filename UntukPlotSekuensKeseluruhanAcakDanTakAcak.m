clc; clear; close all

spring = table2array(parquetread("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Period\spring\saved_spring_rainflow_azmps2_randomized_sequence_RNG136.parquet"));
subplot(2,1,1)
plot(1:numel(spring), spring)
n = numel(spring);

hold on
summer = table2array(parquetread("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Period\summer\saved_summer_rainflow_azmps2_randomized_sequence_RNG136.parquet"));
subplot(2,1,1)
plot(n+1:n+numel(summer), summer)
n = n+numel(summer);

hold on
fall = table2array(parquetread("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Period\fall\saved_fall_rainflow_azmps2_randomized_sequence_RNG136.parquet"));
subplot(2,1,1)
plot(n+1:n+numel(fall), fall)
n = n+numel(fall);

hold on
winter = table2array(parquetread("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Period\winter\saved_winter_rainflow_azmps2_randomized_sequence_RNG136.parquet"));
subplot(2,1,1)
plot(n+1:n+numel(winter), winter)

legend(["spring" "summer" "fall" "winter"], "Location", "south", "NumColumns", 4)
ylabel("Perubahan Akselerasi Vertikal (m/s^2)")
xlabel("Sekuens")
ylim([-15 15])

keseluruhan_acak = table2array(parquetread("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\saved_rainflow_azmps2_randomized_sequence_RNG136_fulldata.parquet"));
subplot(2,1,2)
plot(keseluruhan_acak)
ylabel("Perubahan Akselerasi Vertikal (m/s^2)")
xlabel("Sekuens")
ylim([-15 15])