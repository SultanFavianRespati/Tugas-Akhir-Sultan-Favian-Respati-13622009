tic; clc; close all; clear all;

path = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\saved az_mps2 fulldata.parquet";

a = table2array(parquetread(path));
plot(a, ".")
ylim([-35 30])
n = numel(a);
xlim([0 n])

ii = 1;

while ii ~= numel(a)
    jj = ii + 1;
    d = abs(a(jj)-a(ii));

    while d > 2.064068645401437 && jj ~= numel(a)
        a(jj) = NaN;
        jj = jj + 1;
        d = abs(a(jj)-a(ii));

    end
    ii = jj;

end

a = a(~isnan(a));

figure
plot(a, ".")
ylim([-35 30])
xlim([0 n])
toc

%%
a = array2table(a, "VariableNames", "az_mps2");
parquetwrite("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\saved az_mps2 filtertested fulldata.parquet", a)