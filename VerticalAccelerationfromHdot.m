clc; clear all; close all;

path = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Meteorological\saved_winter_hbaro_m_fulldata.parquet";

a = table2array(parquetread(path));
% a = a(1:round(numel(a)*0.1)); %kalau mau 10% data aja
% a = fillmissing(a, "linear");

% a = diff(a)*16;
% plot(a, ".")
% a(a > 150) = NaN;
% a(a < -150) = NaN;
a = a(~isnan(a)); %a = fillmissing(a, "linear");

figure
plot(a, ".")

% a = rainflow(a);
% 
% peak = a(:,3) + 0.5*a(:,2);
% vall = a(:,3) - 0.5*a(:,2);
% exce = cumsum(ceil(a(:,1)));
% 
% peak = sort(peak, "descend");
% vall = sort(vall, "ascend");

% figure
% semilogx(exce, peak)
% hold on
% semilogx(exce, vall)