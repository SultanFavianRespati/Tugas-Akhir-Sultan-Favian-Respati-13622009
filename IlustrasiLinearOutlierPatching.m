clc; clear; close all

rng(136)

a = rand(10,1)*2+10;
a(4) = a(4)-8;
fs = 0.125;
t = fs:fs:fs*numel(a);
plot(t, a, "o", "LineWidth", 2)
ylim([0 15])
patch = a;
patch(patch == min(patch)) = NaN;
patch = fillmissing(patch, "linear");
hold on
plot(t(4), patch(4), "*", "LineWidth", 1.5, "MarkerSize", 8)
hold on
plot(t, patch)

ylabel("Akselerasi Vertikal (m/s^2)")
xlabel("Waktu (s)")