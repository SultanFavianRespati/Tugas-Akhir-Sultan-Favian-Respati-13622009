%sop
clc; clear all; close all;

period = ["spring" "summer" "fall" "winter"];

for ii = 1:numel(period)
    subplot(2, 2, ii)
    path = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Period\" + period(ii) + "\saved_" + period(ii) + "_hdotdot_patched_az_outliers.parquet";
    
    [count, peak, vall] = getRfCountMaxMin(table2array(parquetread(path)));
    
    [occur, xcellcat, ycellcatpeak, ycellcatvall] = createPeakVallDiscExce(12, count, peak, vall);
    
    semilogx(xcellcat, ycellcatpeak, "LineWidth", 2)
    hold on
    semilogx(xcellcat, ycellcatvall, "LineWidth", 2)
    hold on
    semilogx(1:numel(peak), sort(peak, "descend"), 1:numel(vall), sort(vall, "ascend"))
    
    ylabel("Vertical Acceleration m/s^2"); xlabel("Cumulative Exceedance")
    title(period(ii))
    xlim([1 10^8])
    ylim([-20 20])
end