% UNTUK MENYAMBUNG MULTIPLE DATA
clc; clear; close;

zipfolderpath = "G:\.shortcut-targets-by-id\1RnlP5mtkr7ucoDUDjRAoeqcZf203n-aR\Flight Data KMSP 30R" %lokasi data zip disimpan
lszipfolderpath = string(ls(zipfolderpath)); %daftar data dalam bentuk string yang tersimpan pada folder tersebut

unzippath = "C:\Users\Sultan F. Respati\Documents\07. Semester 7\TA 1\folder tes\halo" %halo adalah file uji untuk menyimpan hasil unzip
lsunzippath = string(ls(unzippath)) %daftar data dalam bentuk string yang tersimpan pada folder tersebut

% Unzipping the data
cellfun(@unzip, fullfile   (zipfolderpath, lszipfolderpath   (3:1055, :)   ), repmat(unzippath, 1055-2, 1) )

% Option settings to choose certain variable to be read by readmatrix func
opt = detectImportOptions(fullfile(unzippath, lsunzippath(3,:)));
opt.SelectedVariableNames = 'hbaro_m';
data = [cellfun(@(f) readmatrix(f, opt), fullfile(unzippath, lsunzippath(3:end,:)), 'UniformOutput', false)];

% Remove all NaN valued cells :
data = cellfun(@(x) x(~isnan(x)), data, 'UniformOutput', false);

% Remove cells that became empty after removing NaN valued cells :
isemptyMask = cellfun(@isempty, data);
data(isemptyMask) = [];

data = cell2mat(data);
plot(data)
input('press any key to finish')
delete(unzippath)
