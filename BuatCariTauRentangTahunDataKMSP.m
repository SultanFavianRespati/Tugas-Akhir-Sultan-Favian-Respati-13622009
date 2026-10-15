clc; clear; close all

clc; clearvars -except zipname csvname zippath csvpath; close all;

if ~exist("zipname", "var")
    load("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\kmsp30r_getzipfileinfo_out.mat"); %load obtained zipname, csvname, csvpath, and zippath data
end

if isempty(gcp("nocreate"))
    parpool("Processes", 12)
end

year = zeros(numel(csvpath), 1);

tic
parfor ii = 1:numel(csvpath)
    year(ii) = max(unique(readmatrix(csvpath(ii), "Range", "AL2:AL66")));
end
toc

plot(year, ".")

[y, Fs]  = audioread("C:\Users\Sultan F. Respati\Documents\00. TA\lg-washing-machine-load-done-tune-made-with-Voicemod.mp3");
sound(y, Fs)