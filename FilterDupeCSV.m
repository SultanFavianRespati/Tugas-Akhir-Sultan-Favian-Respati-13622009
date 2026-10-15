%Filter Duped CSVs
clc; clear all; close all;

load("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\kmsp30r_getzipfileinfo_out.mat")
load("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\dupe_csv_names.mat")

if isempty(gcp("nocreate"))
    parpool("Processes", 6)
end

dupeindex = zeros(numel(dupecsvname), 1);

parfor ii = 1:numel(dupecsvname)
    dupeindex(ii) = find(csvname == dupecsvname(ii))
end

%%
rmzip = strings(numel(csvname), 4);
size([zipname(1710) csvname(1710) zippath(1710) csvpath(1710)])
size(rmzip(1710, :))
rmzip(dupeindex, :) = [zipname(dupeindex) csvname(dupeindex) zippath(dupeindex) csvpath(dupeindex)];
rmzip = rmzip(rmzip(:, 1) ~= "", :);

%%
save("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\dupe_csv_indexes.mat", "dupeindex")