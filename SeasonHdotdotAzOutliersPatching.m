clc; clear; close all;

load("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\kmsp30r_getzipfileinfo_out.mat")
load("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\clean_zip_file_info_out.mat")
load("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\outliered_zip_file_info_out.mat")

load("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Meteorological\getZipFileInfo Data\spring_zip_file_info_out.mat")
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
% =========================== CHECK SEASON CONFORMITY ===========================

az = cell(numel(zipname),1);

poolsize = 12;
if isempty(gcp("nocreate"))
    parpool("Processes", poolsize); % Choose number of pool
end

tic
parfor ii = 1:numel(zipname)
    if ismember(ii, springindex) %<<<<<====================== CHECK SEASON
        if ismember(ii, cleanindex)
            az{ii} = getSpecificVarDataWithNaN(csvpath(ii), "az_mps2");
            az{ii}(az{ii} == min(az{ii})) = NaN;
            az{ii} = fillmissing(az{ii}, "linear");
            az{ii} = az{ii} - mean(az{ii}(1:1000));

        elseif ismember(ii, outlieredindex)
            h = getSpecificVarDataWithNaN(csvpath(ii), "hdot_2_mps");
            h = fillmissing(h, "linear");
            dt = 1/16; % <<<<<<<<=================================================== CHECK CONFORMITY
            az{ii} = gradient(h, dt);
        end
    end
end
disp(toc)

% CONCATENATE
az = vertcat(az{:});

% SAVE DATA IN PARQUET FORMAT
tbdatafull = array2table(az, "VariableNames", "az_mps2"); %turn full data into table
clearvars az

savepath = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\saved_spring_hdotdot_patched_az_outliers"; %<<<<<====================== CHECK SEASON

parquetwrite(savepath, tbdatafull) %save as parquet

% END NOTIFICATION
[y, Fs]  = audioread("C:\Users\Sultan F. Respati\Documents\00. TA\lg-washing-machine-load-done-tune-made-with-Voicemod.mp3");
sound(y, Fs)

delete(gcp("nocreate"))