clc; clear all; close all

load("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\clean_zip_file_info_out.mat")
load("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\outliered_zip_file_info_out.mat")
load("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\kmsp30r_getzipfileinfo_out.mat")

cleanindex = zeros(numel(cleanzipname), 1);
for ii = 1:numel(cleanzipname)
    idx = find(zipname == cleanzipname(ii), 1);
    if ~isempty(idx)
        cleanindex(ii) = idx;
    end
end
cleanindex(cleanindex == 0) = [];
plot(cleanindex, cleanindex, ".")

hold on
outlieredindex = zeros(numel(outlieredzipname), 1);
for ii = 1:numel(outlieredzipname)
    idx = find(zipname == outlieredzipname(ii), 1);
    if ~isempty(idx)
        outlieredindex(ii) = idx;
    end
end
outlieredindex(outlieredindex == 0) = [];
plot(outlieredindex, outlieredindex, ".")
%%
save("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\outliered_zip_file_info_out.mat", "outlieredzipname", "outlieredcsvname", "outlieredzippath", "outlieredcsvpath", "outlieredindex")
save("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\clean_zip_file_info_out.mat", "cleanzipname", "cleancsvname", "cleanzippath", "cleancsvpath", "cleanindex")