clc; clear all; close all;
seasonpath = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\summer_zip_file_info_out.mat";
load(seasonpath)
load("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\kmsp30r_getzipfileinfo_out.mat")
load("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\fail_to_read_season.mat")

%%
chosidx = 6;
seasonindex = summerindex;
seasonzipname = summerzipname;
seasoncsvname = summercsvname;
seasonzippath = summerzippath;
seasoncsvpath = summercsvpath;

for ii = 1:numel(seasonindex)
    if seasonindex(ii) == failindex(chosidx) - 1
        seasonindex(ii + 2:end+1) = seasonindex(ii + 1:end);
        seasonindex(ii) = failindex(chosidx);

        seasonzipname(ii + 2:end+1) = seasonzipname(ii + 1:end);
        seasonzipname(ii) = failzipname(chosidx);

        seasoncsvname(ii + 2:end+1) = seasoncsvname(ii + 1:end);
        seasoncsvname(ii) = failcsvname(chosidx);

        seasonzippath(ii + 2:end+1) = seasonzippath(ii + 1:end);
        seasonzippath(ii) = failzippath(chosidx);
        
        seasoncsvpath(ii + 2:end+1) = seasoncsvpath(ii + 1:end);
        seasoncsvpath(ii) = failcsvpath(chosidx);
    end
end

summerindex = seasonindex;
summerzipname = seasonzipname;
summercsvname = seasoncsvname;
summerzippath = seasonzippath;
summercsvpath = seasoncsvpath;
plot(seasonindex, ".")

save(seasonpath, "summerzipname", "summercsvname", "summerzippath", "summercsvpath", "summerindex")