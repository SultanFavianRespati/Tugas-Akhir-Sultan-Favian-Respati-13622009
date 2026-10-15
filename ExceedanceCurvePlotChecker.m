clc; clear all; close all
a = rand(1e6,1)-0.5;
[occur, xcellcat, ycellcatpeak, ycellcatvall] = createPeakVallDiscExce(12, a, a);

% semilogx(1:numel(a), sort(a, "descend"), "o")
% hold on
semilogx(xcellcat, ycellcatpeak)
hold on
semilogx(xcellcat, ycellcatvall)
hold on
semilogx(sort(a, "descend"), "m")
hold on
semilogx(sort(a, "ascend"), "m")
% hold on
% semilogx(xexc, yexc, "square", "LineWidth", 2)
% hold on
% semilogx(xmid, ymid, "rx", "LineWidth", 2)