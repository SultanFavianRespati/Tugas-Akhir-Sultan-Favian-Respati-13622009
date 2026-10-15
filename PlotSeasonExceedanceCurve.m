%sop
clc; clear all; close all;

period = ["spring" "summer" "fall" "winter"];
color = ["r" "g" "b" "m"];

for ii = 1:numel(period)

    path = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Period\" + period(ii) + "\saved_" + period(ii) + "_hdotdot_patched_az_outliers.parquet";

    [count, peak, vall] = getRfCountMaxMin(table2array(parquetread(path)));

    [occur, xcellcat, ycellcatpeak, ycellcatvall] = createPeakVallDiscExce(12, count, peak, vall);

    semilogx(xcellcat, ycellcatpeak, "Color", color(ii))
    hold on
    semilogx(xcellcat, ycellcatvall, "Color", color(ii))
    hold on
end

legend(["spring maxima" "spring minima" "summer maxima" "summer minima" "fall maxima" "fall minima" "winter maxima" "winter minima"])
ylabel("Vertical Acceleration m/s^2"); xlabel("Cumulative Exceedance")
ylim([-20 20])