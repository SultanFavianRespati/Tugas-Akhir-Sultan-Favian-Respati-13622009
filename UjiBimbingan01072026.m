clc; clear all; close all;

path = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\saved az_mps2 fulldata.parquet";

a = table2array(parquetread(path));

%if there's NaN
a(isnan(a)) = [];

%filter load outside maneuver limit (CASR 25)
a(a > 2.5*1.5*9.80665) = [];
a(a < 4) = [];

%Remove data outside deviation standard of 2
% sd = std(a);
% avg = mean(a);
% 
% sig = 3;
% ub = avg + sig*sd;
% lb = avg - sig*sd;
% 
% a(a > ub) = [];
% a(a < lb) = [];

rf = rainflow(a); %rainflow count. Output : Count Range Mean Start End
clearvars a

apeaks = rf(:,3) + rf(:,2)*0.5; %Calculate peak values
avals = rf(:,3) - rf(:,2)*0.5; %calculate valley values
clearvars rf

amix = sort([apeaks; avals], "descend"); % put peak and valley into a single list then sort descending (q)
occurence = [(1:numel(amix)/2)'; flip((1:numel(amix)/2)')];
% occurence assumed to be "symmetric" from 1 until half number of data of
% amix (or also number of data stored in apeaks or avals (q)

%%
close all

apeaks = sort(apeaks, "descend");
avals = sort(avals, "ascend");
occ2 = (1:numel(avals))';
figure
semilogx(occ2, apeaks)
hold on
semilogx(occ2, avals)
grid on
title("Delta G Load Exceedance Curve")
xlabel("Number of Exceedance")
ylabel("Delta G Load")