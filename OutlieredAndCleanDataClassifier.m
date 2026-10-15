clc; clear all; close all

load("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\kmsp30r_getzipfileinfo_out.mat")

az = cell(numel(csvpath), 1);

outlieredcsvname = cell(numel(csvpath), 1);
outlieredcsvpath = cell(numel(csvpath), 1);
outlieredzipname = cell(numel(csvpath), 1);
outlieredzippath = cell(numel(csvpath), 1);
outlierindex = cell(numel(csvpath), 1);

cleancsvname = cell(numel(csvpath), 1);
cleancsvpath = cell(numel(csvpath), 1);
cleanzipname = cell(numel(csvpath), 1);
cleanzippath = cell(numel(csvpath), 1);
cleanindex = cell(numel(csvpath), 1);

poolsize = 12;
if isempty(gcp("nocreate"))
    parpool("Processes", poolsize); % Choose number of pool
end

% a = 1;
% r = 50;

tic
parfor ii = 1:numel(csvpath)
    az = getSpecificVarDataWithNaN(csvpath(ii), "az_mps2");
    az(az == min(az)) = NaN;
    az = fillmissing(az, "linear");

    if any(az >= -35 & az <= -15)
        outlieredcsvname{ii} = csvname(ii);
        outlieredcsvpath{ii} = csvpath(ii);
        outlieredzipname{ii} = zipname(ii);
        outlieredzippath{ii} = zippath(ii);
        outlierindex{ii} = ii;
    else
        cleancsvname{ii} = csvname(ii);
        cleancsvpath{ii} = csvpath(ii);
        cleanzipname{ii} = zipname(ii);
        cleanzippath{ii} = zippath(ii);
        cleanindex{ii} = ii;
    end
end
toc

outlieredcsvname = vertcat(outlieredcsvname{:,1});
outlieredcsvpath = vertcat(outlieredcsvpath{:,1});
outlieredzipname = vertcat(outlieredzipname{:,1});
outlieredzippath = vertcat(outlieredzippath{:,1});
outlierindex = vertcat(outlierindex{:,1});

cleancsvname = vertcat(cleancsvname{:,1});
cleancsvpath = vertcat(cleancsvpath{:,1});
cleanzipname = vertcat(cleanzipname{:,1});
cleanzippath = vertcat(cleanzippath{:,1});
cleanindex = vertcat(cleanindex{:,1});

[y, Fs]  = audioread("C:\Users\Sultan F. Respati\Documents\00. TA\lg-washing-machine-load-done-tune-made-with-Voicemod.mp3");
sound(y, Fs)

%%
save("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\outliered_zip_file_info_out.mat", "outlieredzipname", "outlieredcsvname", "outlieredzippath", "outlieredcsvpath", "outlieredindex")
save("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\clean_zip_file_info_out.mat", "cleanzipname", "cleancsvname", "cleanzippath", "cleancsvpath", "cleanindex")

%%
delete(gcp("nocreate"))