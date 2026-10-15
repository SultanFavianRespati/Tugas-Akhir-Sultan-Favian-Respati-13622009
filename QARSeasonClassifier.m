%To determine which data falls into which season
%sop
clc; clearvars -except zipname csvname zippath csvpath; close all;

if ~exist("zipname", "var")
    load("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\kmsp30r_getzipfileinfo_out.mat"); %load obtained zipname, csvname, csvpath, and zippath data
end

%{
Define season start and end date
construct season bins
Read month from csv
if mm read data is in seasonmonth(i), then zipname is part of season(i), and
its getZipFileInfo() output is categorized into season(i)

save the zipname, zippath, csvname, csvpath into a string matrix. for example : winterzipname
%}

%{
NOAA US Meteorological Season Months

Spring : month 3-5
Summer : month 6-8
Fall : month 9-11
Winter : month 12-2
%}

% springzipfileinfo = strings(size(zipname,1), 4);
% summerzipfileinfo = strings(size(zipname,1), 4);
% fallzipfileinfo = strings(size(zipname,1), 4);
% winterzipfileinfo = strings(size(zipname,1), 4);

fallzipname = strings(size(zipname,1), 1);
fallcsvname = strings(size(zipname,1), 1);
fallzippath = strings(size(zipname,1), 1);
fallcsvpath = strings(size(zipname,1), 1);

springzipname = strings(size(zipname,1), 1);
springcsvname = strings(size(zipname,1), 1);
springzippath = strings(size(zipname,1), 1);
springcsvpath = strings(size(zipname,1), 1);

summerzipname = strings(size(zipname,1), 1);
summercsvname = strings(size(zipname,1), 1);
summerzippath = strings(size(zipname,1), 1);
summercsvpath = strings(size(zipname,1), 1);

winterzipname = strings(size(zipname,1), 1);
wintercsvname = strings(size(zipname,1), 1);
winterzippath = strings(size(zipname,1), 1);
wintercsvpath = strings(size(zipname,1), 1);

failtoread = strings(size(zipname,1), 4);

%%
if isempty(gcp("nocreate"))
    parpool("Processes", 7)
end
tic
parfor ii = 1:size(zipname, 1)
    
    m = readmatrix(csvpath(ii), "Range", "AK2:AK2");

    if (m >= 3) && (m <= 5)
        springzipname(ii) = zipname(ii);
        springcsvname(ii) = csvname(ii);
        springzippath(ii) = zippath(ii);
        springcsvpath(ii) = csvpath(ii);

    elseif (m >= 6) && (m <= 8)
        summerzipname(ii) = zipname(ii);
        summercsvname(ii) = csvname(ii);
        summerzippath(ii) = zippath(ii);
        summercsvpath(ii) = csvpath(ii);

    elseif (m >= 9) && (m <= 11)
        fallzipname(ii) = zipname(ii);
        fallcsvname(ii) = csvname(ii);
        fallzippath(ii) = zippath(ii);
        fallcsvpath(ii) = csvpath(ii);

    elseif (m == 12) || (m <= 2) && (m > 0)
        winterzipname(ii) = zipname(ii);
        wintercsvname(ii) = csvname(ii);
        winterzippath(ii) = zippath(ii);
        wintercsvpath(ii) = csvpath(ii);

    else
        failtoread(ii, :) = [zipname(ii) csvname(ii) zippath(ii) csvpath(ii)];

    end
end

springzipname = emptystringfilter(springzipname);
springcsvname = emptystringfilter(springcsvname);
springzippath = emptystringfilter(springzippath);
springcsvpath = emptystringfilter(springcsvpath);

summerzipname = emptystringfilter(summerzipname);
summercsvname = emptystringfilter(summercsvname);
summerzippath = emptystringfilter(summerzippath);
summercsvpath = emptystringfilter(summercsvpath);

fallzipname = emptystringfilter(fallzipname);
fallcsvname = emptystringfilter(fallcsvname);
fallzippath = emptystringfilter(fallzippath);
fallcsvpath = emptystringfilter(fallcsvpath);

winterzipname = emptystringfilter(winterzipname);
wintercsvname = emptystringfilter(wintercsvname);
winterzippath = emptystringfilter(winterzippath);
wintercsvpath = emptystringfilter(wintercsvpath);

failtoread = emptystringfilter(failtoread);

%%
save("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\spring_zip_file_info_out.mat", "springzipname", "springcsvname", "springzippath", "springcsvpath")
save("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\summer_zip_file_info_out.mat", "summerzipname", "summercsvname", "summerzippath", "summercsvpath")
save("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\fall_zip_file_info_out.mat", "fallzipname", "fallcsvname", "fallzippath", "fallcsvpath")
save("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\winter_zip_file_info_out.mat", "winterzipname", "wintercsvname", "winterzippath", "wintercsvpath")
save("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\fail_to_read_season.mat", "failtoread")

t = toc

function matrix = emptystringfilter(data)
i = sum((data == ""), 2);
idx = (i == 0);
matrix = data(idx,:);
end

delete(gcp("nocreate"))
%{
1  154.9421
2   93.8234
5   56.1130
6   55.1371
7   50.5893
8   55.4926
12
%}