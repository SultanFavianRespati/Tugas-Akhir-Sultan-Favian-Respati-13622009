% UNTUK MENYAMBUNG MULTIPLE DATA
clc; clear; close; tic
count = 0;
zipfolderpath = "G:\.shortcut-targets-by-id\1RnlP5mtkr7ucoDUDjRAoeqcZf203n-aR\Flight Data KMSP 30R"; %lokasi data zip disimpan
lszipfolderpath = string(ls(zipfolderpath)); %daftar data dalam bentuk string yang tersimpan pada folder tersebut

unzippath = "C:\Users\Sultan F. Respati\Documents\07. Semester 7\TA\KMSPFILEANALYSIS\extraction folder"; %folder untuk menyimpan hasil unzip

% Unzipping the data
for i = 3:4222
    toc
    count = count + 1;
    unzip(fullfile(zipfolderpath, lszipfolderpath(i)), unzippath)
    lsunzippath = string(ls(unzippath));

    % Option settings to choose certain variable to be read by readmatrix func
    opt = detectImportOptions(fullfile(unzippath, lsunzippath(3)));
    opt.SelectedVariableNames = 'hbaro_m';

    % Data reading
    data = readmatrix(fullfile(unzippath, lsunzippath(3)), opt);
    
    % Remove all NaN valued cells :
    data = data(~isnan(data));

    % Remove cells that became empty after removing NaN valued cells :
    data(isempty(data)) = [];

    % Sambungkan data
    if i == 3
        datafull = data;

    else
        datafull = [datafull; data*(i>3)];
        
    end

    delete(fullfile(unzippath, lsunzippath(3,:)))
end

plot(datafull) %plot hasil data lengkap
savepath = "C:\Users\Sultan F. Respati\Documents\00. TA\KMSPFILEANALYSIS";
writematrix(datafull, fullfile(savepath + filesep + "saved hbaro_m fulldata.csv")) %menyimpan hasil ekstrak
T = readtable(savepath + filesep + "saved hbaro_m fulldata.csv");
parquetwrite(savepath + filesep + "saved hbaro_m fulldata.parquet", T)

rmdir(unzippath)

t = toc