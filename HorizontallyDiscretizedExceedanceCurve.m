clc; clear all; close all;

intcount = 12;

yrand = sort(rand(14022,1), "descend"); %random stochastic values of stress range
xrand = (1:numel(yrand)); %number of exceedance assumed 1 occurence per y value

xexc = logspace(0, log10(numel(xrand)), intcount + 1);
yexc = interp1(xrand, yrand, xexc); yexc(end) = yrand(end);

dif = diff(log10(xexc(1:2)));

xmid = 10.^((dif:dif:log10(xexc(end)))-dif/2);
ymid = interp1(xexc, yexc, xmid);

xcell = cell(intcount,1);
ycell = cell(intcount,1);
for i = 1:intcount
    xcell{i} = [xexc(i); xexc(i); xexc(i+1); xexc(i+1)];
    ycell{i} = [0; ymid(i); ymid(i); 0];
end

xcellcat = vertcat(xcell{:});
ycellcat = vertcat(ycell{:});