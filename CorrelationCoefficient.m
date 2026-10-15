clc; clear; close all; tic;
% State file directories
filepath = "D:/KMSP 30R Copy";
dirfilepath = dir(fullfile(filepath, '*.zip'));
extractpath = "C:\Users\Sultan F. Respati\Documents\00. TA\KMSPFILEANALYSIS\extract fol";

if isfolder(extractpath) == 1
    rmdir(extractpath, "s")
    mkdir(extractpath)
end

err = zeros(4220, 1);

for i = 1:4220
    selectedfilepath = fullfile(filepath, dirfilepath(i).name); %state which file path to be unzipped in current iteration
    unzip(selectedfilepath, extractpath) %unzip the selected path in current iteration
    dirextractpath = dir(fullfile(extractpath, '*.csv')); %list the extracted file
    extractedcontent = fullfile(extractpath, dirextractpath(1).name); %state extracted file path
    opt = detectImportOptions(extractedcontent); %detect extracted file import options
    opt.SelectedVariableNames = "hbaro_m"; %selecting a variable name from import options
    h = readmatrix(extractedcontent, opt); %read the selected variable name as a matrix
    h = h(~isnan(h)); %remove NaN values

    [~, ~, Pisa] = atmosisa(h); %obtain isa pressure
    mask = 2:2:size(Pisa, 1); Pisa = Pisa(mask); %take half of isa static pressure values to equalize pitot static pressure array size

    opt.SelectedVariableNames = "press_static_npm2"; %selecting a variable name from import options
    Pstat = readmatrix(extractedcontent, opt); %read the selected variable name as a matrix
    Pstat = Pstat(~isnan(Pstat)); %remove NaN values

    err(i,1) = rmse(Pisa, Pstat);

    delete(extractedcontent)
    toc
end
%%
    plot(Pstat, "ro")
    hold on
    plot(Pisa, "bx")
%%
aveerr = mean(err)