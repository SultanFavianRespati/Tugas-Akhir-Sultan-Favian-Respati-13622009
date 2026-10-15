clc; clear; close all

spring = table2array(parquetread("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Period\spring\saved_spring_rainflow_azmps2_randomized_sequence_RNG136.parquet"));

summer = table2array(parquetread("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Period\summer\saved_summer_rainflow_azmps2_randomized_sequence_RNG136.parquet"));

fall = table2array(parquetread("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Period\fall\saved_fall_rainflow_azmps2_randomized_sequence_RNG136.parquet"));

winter = table2array(parquetread("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Period\winter\saved_winter_rainflow_azmps2_randomized_sequence_RNG136.parquet"));

seq = [spring; summer; fall; winter];

clear spring summer fall winter

[count, maxima, minima] = getRfCountMaxMin(seq);

[~, x, ypeak, yvall] = createPeakVallDiscExce(12, count, maxima, minima);

semilogx(x, ypeak, "k")
hold on
semilogx(x, yvall, "k")

seq = table2array(parquetread("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\saved_rainflow_azmps2_randomized_sequence_RNG136_fulldata.parquet"));

[count, maxima, minima] = getRfCountMaxMin(seq);

[~, x, ypeak, yvall] = createPeakVallDiscExce(12, count, maxima, minima);

hold on
semilogx(x, ypeak, "k-.")
hold on
semilogx(x, yvall, "k-.")

legend(["Keseluruhan" "Keseluruhan" "Keseluruhan (Acak)" "Keseluruhan (Acak)"])
ylabel("Perubahan Akselerasi Vertikal (m/s^2)")
xlabel("Cummulative Exceedance")