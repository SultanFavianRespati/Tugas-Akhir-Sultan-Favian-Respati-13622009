%Check Dupe
load("C:\Users\Sultan F. Respati\Documents\00. TA\KMSP30R_getZipFileInfoOut.mat")
clc; clearvars -except zipname csvname zippath csvpath
%{
in order to check dupe we must obtain two data from two file, one of which
is the suspected dupe file

standard filename format for csv is 19 character long, but obtained csv
names is 21 character long. These anomalies must be found and is suspected
as dupe due to additional 2 character of "_1" which is assumed as "first
copy of ..."

csvnames must be turned into char to be able be dissected

if csvname on 20th column is not empty or ' ' then that csvname on that index
is stored to be suspected as dupe

after all suspected csvname is collected it must be further analyzed
%}

charcsvname = char(csvname); %turn csv names into char array
neidx = find(charcsvname(:,20) ~= ' '); %obtain the indexes of these suspected csvs
suscsvname = charcsvname(neidx, :);
% disp(suscsvname) %display all suspected csvs
% output:

% 658200108131251_1.csv
% 658200108211620_1.csv
% 658200112121653_1.csv
% 659200105160410_1.csv
% 659200105161152_1.csv
% 659200105161655_1.csv
% 659200105171226_1.csv
% 659200107230711_1.csv
% 659200107231136_1.csv
% 664200307081753_1.csv
% 665200301251924_1.csv

% it is obtained that all the suspected csvs are ended with '_1'  before .csv
%{
i personally think that it is save to assume that the '_1' means that it
is the copy of a file for example : 'thisisacsv_1.csv' is a copy of
'thisisacsv.csv'. Thus the original file name shall be constructed
(filename without '_1') and then access its content if the file itself
exists

first the originalcsvname must be constructed

then find the index of csvname that equals to originalcsvname

use that index to get csvpath of the original csv path
%}

oricsvname = char(string(suscsvname(:, 1:15)) + string(repmat('.csv', size(suscsvname, 1), 1))); %construct original csv name

eqidx = zeros(size(oricsvname, 1), 1); %prepare index array to get the original csvpath

for i = 1:size(oricsvname, 1)
    try
        eqidx(i) = find(csvname == string(oricsvname(i,:))); %done by utilizing trycatch block, it was found that 664200307081753_1.csv is unique and does not have an "original" does might results in error
    catch
    end
end

%filter due to previous finding
eqidx(eqidx == 0) = []; %filter index of zero
suscsvname(string(suscsvname) == '664200307081753_1.csv', :) = []; %remove suscsv that has no "original"

oricsvpath = csvpath(eqidx); %obtain original csvpath

%{
the original csv path has been obtained thus original csvs can be read

the next step is to obtain the suspected dupe csv path (or i would like to
call suscsvpath)

suscsvpath can be obtained by finding the index of the suscsvname inside
csvname

then we use that index to get the suspected csv path (suscsvpath)

this process is similar to previous process
%}

susidx = zeros(size(suscsvname, 1), 1); %prepare index array to get the suspected csvpath

for i = 1:size(suscsvname, 1)
    try
        susidx(i) = find(csvname == string(suscsvname(i,:))); %done by utilizing trycatch block to bypass error
    catch
    end
end

suscsvpath = csvpath(susidx); %obtain suspected dupe csvpath

%{
now that oricsvpath and suscsvpath has been obtained, we can read matrixes
of these paths.

first we must choose a variable to be checked, I personally choose vertical
acceleration due to gust load being random by environment factor
It is safe to say that it is impossible for two flights having the same
gust event down to the decimals.

then the ori and sus matrices is compared to check if it equals to one
another

if yes, then it is confirmed that suscsvname(i) is dupecsvname(i)
if no, then it is confirmed that suscsvname(i) is part of csvname
%}

dupecsvname = strings(size(suscsvname, 1)); %prepare empty string array to store dupecsvname
unicsvname = strings(size(suscsvname, 1)); %prepare empty string array to store suscsvname that turns out to be unique
for i = 1:size(suscsvpath,1)
    susmat = getSpecificVarData(suscsvpath(i), "az_mps2"); %obtain NaN-filtered data from a specific column title
    orimat = getSpecificVarData(oricsvpath(i), "az_mps2"); %obtain NaN-filtered data from a specific column title
    try
        if susmat == orimat %duplicate check
            dupecsvname(i) = string(suscsvname(i,:)); %store dupe csv
        else
            unicsvname(i) = string(suscsvname(i,:)); %store unique csv
        end
    catch
    end
end

fprintf("Total duplicate csv : %g csv(s)\n", numel(dupecsvname))
fprintf("Total unique suspected csv : %g csv(s)\n", numel(unicsvname))