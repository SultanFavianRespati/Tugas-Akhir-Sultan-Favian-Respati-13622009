% Concatenate specific variable data of all flights
clc; clear all; close all; %sop

path = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\kmsp30r_getzipfileinfo_out.mat"; %choose data path <----------- change to respective season

load(path); %load pre-acquired zipname csvname zippath csvpath 

chosvar = "hdot_2_mps"; %Chosen variable to be read from csvs

datafull = cell(size(zipname,1),1); %pre-allocate cell <----------- change to respective season

%Execute parallelization
if isempty(gcp("nocreate"))
    parpool("Processes", 12); % Choose number of pool
end

tic
parfor ii = 1:size(zipname,1) % <----------- change to respective season
    datafull{ii} = getSpecificVarDataWithNaN(csvpath(ii), chosvar); %feed cell array with a chosen variable datas <----------- change to respective season
end
t = toc;

delete(gcp("nocreate"))
% %%
datafull = vertcat(datafull{:}); %concatenate obtained full data of a chosen variable

tbdatafull = array2table(datafull, "VariableNames", chosvar); %turn full data into table
clearvars datafull
% %%
savepath = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas"; %declare save path

parquetwrite(savepath + filesep + "saved_" + chosvar + "_wnan_fulldata", tbdatafull) %save as parquet <----------- change to respective season

[y, Fs]  = audioread("C:\Users\Sultan F. Respati\Documents\00. TA\lg-washing-machine-load-done-tune-made-with-Voicemod.mp3");
sound(y, Fs)
%{
1

2

4

6

8

10

11

%% az_mps2 with NaN
1

2

4

6

8

10

11

12

%}