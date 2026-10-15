clc; clearvars -except zipname csvname zippath csvpath fallzipname fallcsvname fallzippath fallcsvpath; close all;

load("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\fall_zip_file_info_out.mat")
load("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\spring_zip_file_info_out.mat")
load("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\summer_zip_file_info_out.mat")
load("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\winter_zip_file_info_out.mat")
load("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\fail_to_read_season.mat")
load("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\kmsp30r_getzipfileinfo_out.mat")

% FALL SEASON
fallindex = zeros(numel(fallzipname), 1);
for ii = 1:numel(fallzipname)
    fallindex(ii) = find(zipname == fallzipname(ii));
end
fallindex(fallindex == 0) = [];
plot(fallindex, ".")
hold on

% SPRING SEASON
springindex = zeros(numel(springzipname), 1);
for ii = 1:numel(springzipname)
    springindex(ii) = find(zipname == springzipname(ii));
end
springindex(springindex == 0) = [];
plot(springindex, ".")
hold on

% SUMMER SEASON
summerindex = zeros(numel(summerzipname), 1);
for ii = 1:numel(summerzipname)
    summerindex(ii) = find(zipname == summerzipname(ii));
end
summerindex(summerindex == 0) = [];
plot(summerindex, ".")
hold on

% WINTER SEASON
winterindex = zeros(numel(winterzipname), 1);
for ii = 1:numel(winterzipname)
    winterindex(ii) = find(zipname == winterzipname(ii));
end
winterindex(winterindex == 0) = [];
plot(winterindex, ".")
hold on

a = {fallindex; springindex; summerindex; winterindex};
a = sort(vertcat(a{:}), "ascend");
plot(a)

% FAIL TO READ
failindex = zeros(numel(failzipname), 1);
for ii = 1:numel(failzipname)
    failindex(ii) = find(zipname == failzipname(ii));
end
failindex(failindex == 0) = [];

failindexcomp = zeros(8,1);
idxcount = 1;
for ii = 1:numel(a)-1
    if a(ii + 1) - 1 ~= a(ii)
        failindexcomp(idxcount) = a(ii + 1) - 1;
        idxcount = idxcount + 1;
    end
end