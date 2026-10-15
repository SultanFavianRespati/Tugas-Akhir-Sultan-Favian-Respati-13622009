%sop
clc; clear all; close all;

az = readmatrix("D:\KMSP main datasave\saved az_mps2 csv\az_mps2 652200101201529.csv"); %DATA LOST
dnz = (az/9.80665)-1; %convert obtained vertical load data into change of vertical load data
rfres = rainflow(dnz); %rainflow change of vertical load
rfres = array2table(rfres, "VariableNames", ["Count" "Range" "Mean" "Start" "End"]); %save rainflow result as a table

dnzpeak = rfres.Mean + rfres.Range/2; %calculate maxima change of vertical load data
dnzval = rfres.Mean - rfres.Range/2; %calculate minima change of vertical load data
%occurrence = [(1:size(rfres, 1))'; flip((1:size(rfres, 1))')];

intcount = 12; %interval count

%% Approach 1
%Positive Excursion
dnzmax = max(dnzpeak); %determine maximum vertical load change value
interval = dnzmax/intcount; %discretization interval
bin = 0:interval:dnzmax; %stating discretization bins
count = histcounts(dnzpeak, bin); %counting how many stresses fall into stated bins
N = cumsum(flip(count)); %counting cumulation of stress counts in each bins
x = 1; y = dnzmax;

for i = 1:intcount %creating x and y values for the discretized exceedance curve
    x = [x; N(i); N(i); 1];
    y = [y; dnzmax-(i-1)*interval; dnzmax-i*interval; dnzmax-i*interval];
end

tiledlayout(2,1)
nexttile
semilogx(x, y); hold

%Negative Excursion
dnzmin = min(dnzval); %determine maximum vertical load change value
interval = dnzmin/intcount; %discretization interval
bin = flip(0:interval:dnzmin); %stating discretization bins
count = histcounts(dnzval, bin); %counting how many stresses fall into stated bins
N = cumsum(count); %counting cumulation of stress counts in each bins
x = 1; y = dnzmin;

for i = 1:intcount %creating x and y values for the discretized exceedance curve
    x = [x; N(i); N(i); 1];
    y = [y; dnzmin-(i-1)*interval; dnzmin-i*interval; dnzmin-i*interval];
end

semilogx(x, y)
title('Bin on Each Excursion')
xlim([1 10^5]); ylim([-0.4 0.4])
xlabel('Number of Exceedance'); ylabel('Change in Vertical G Load')

%% Approach 2
dnzpv = [dnzpeak; dnzval];
interval = (max(dnzpv)-min(dnzpv))/intcount;
bin = min(dnzpv):interval:max(dnzpv);
count = histcounts(dnzpv, bin);
Nn = cumsum(count(1:6));
Np = cumsum(flip(count(7:12)));
N = [Nn flip(Np)];

x = 1; y = max(dnzpv);

for i = 1:intcount %creating x and y values for the discretized exceedance curve
    x = [x; N(i); N(i); 1];
    y = [y; max(dnzpv)-(i-1)*interval; max(dnzpv)-i*interval; max(dnzpv)-i*interval];
end

nexttile
semilogx(x, y)
title('Combined Bin')
xlim([1 10^5]); ylim([-0.4 0.4])
xlabel('Number of Exceedance'); ylabel('Change in Vertical G Load')