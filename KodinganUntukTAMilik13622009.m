%% About
%Name       : Sultan Favian Respati
%Student ID : 13622009
%Aerospace Engineering Major
%Faculty of Mechanical and Aerospace Engineering

%% FDR Data Extraction
clear; clc;close;

%Declare folder paths that will be used
zipfolderpath = ("G:\My Drive\Flight Data KMSP 30R.lnk");
extractionfolderpath = ("C:\Users\Sultan F. Respati\Documents\07. Semester 7\TA 1\folder tes\extraction folder");
list = ls(zipfolderpath);
unzip(fullfile(zipfolderpath, "flight_N138265"), extractionfolderpath)

extractedfilename = ls(extractionfolderpath);
extractedfilename = extractedfilename(3,:);

%% FDR Data Reading
path = (fullfile(extractionfolderpath, extractedfilename));
data = detectImportOptions(path);

%To detect which variable to be read
data.SelectedVariableNames = 'hbaro_m';

%Reading chosen variable data as matrix
M = readmatrix(path, data);

A = M(~isnan(M));

plot(A);

%% Altitude Into Stress Data Processing
% Konversi ketinggian dari kaki ke meter
h = 0.3048.*A;

% Perhitungan tekanan atmosfer untuk tiap nilai ketinggian
[~, ~, P] = atmosisa(h); %hanya variabel P yang akan digunakan
%P dalam satuan Pascal

% Perhitungan perbedaan tekanan kabin dengan lingkungan

htresh = 8000*0.3048; %ketinggian batas 8000 ft dikonversi ke dalam meter
P8kft = atmosisa(htresh); %Tekanan atmosfer pada 8000 kaki (Pascal)

deltaP(h <= htresh) = 0;
deltaP(h > htresh) = P8kft - P(h > htresh);

% Perhitungan tegangan sirkumferensial pada struktur

%{
r = input('radius fuselage (m) : ');
t = input('ketebalan fuselage (m) : ');
%}

r = 5.94; %(m)
t = 1.5e-3; %(m)
sigma = deltaP*r/t; %tegangan sirkumferensial (Pascal)

%% Rainflow Counting
c = rainflow(sigma);

%Ekstraksi hasil rainflow counting

T = array2table(c,VariableNames=["Count" "Range" "Mean" "Start" "End"]);

%Penyajian dalam format .txt
mkdir("C:\Users\Sultan F. Respati\Documents\07. Semester 7\TA 1\folder tes\hasil rainflow")
writematrix(c, "C:\Users\Sultan F. Respati\Documents\07. Semester 7\TA 1\folder tes\hasil rainflow\tes.txt")

%delete extracted file for tidiness
delete(fullfile(extractionfolderpath, extractedfilename))

%{
%UNTUK MENYAMBUNG MULTIPLE DATA
clc; clear; close;
datapath = "C:\Users\Sultan F. Respati\Documents\07. Semester 7\TA 1\folder tes\data"
lsdatapath = string(ls(datapath))
zipfolderpath = "G:\.shortcut-targets-by-id\1RnlP5mtkr7ucoDUDjRAoeqcZf203n-aR\Flight Data KMSP 30R"
lszipfolderpath = string(ls(zipfolderpath))
halopath = "C:\Users\Sultan F. Respati\Documents\07. Semester 7\TA 1\folder tes\halo"
lshalopath = string(ls(halopath))
size(zipfolderpath)
size(lszipfolderpath)
cellfun   (@unzip, fullfile   (zipfolderpath, lszipfolderpath   (3:6,:)   ), repmat(halopath, 4,1) )
opt = detectImportOptions(fullfile(halopath, lshalopath(3,:)));
opt.SelectedVariableNames = 'hbaro_m';
data = [cellfun(@(f) readmatrix(f, opt), fullfile(halopath, lshalopath(3:end,:)), 'UniformOutput', false)]

% Replace each cell by its non-NaN elements:
data = cellfun(@(x) x(~isnan(x)), data, 'UniformOutput', false);

% Optionally remove any cells that became empty after removing NaNs:
isemptyMask = cellfun(@isempty, data);
data(isemptyMask) = [];

data = cell2mat(data);
plot(data)

%}