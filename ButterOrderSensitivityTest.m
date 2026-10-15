clc; clear; close all
season = "winter";

path = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Meteorological\" + season + "\saved_" + season + "_hdotdot_patched_az_outliers.parquet";

a = 0.001;
b = 7.9;
fc = 3; %Determined through ButterCutOffFrequencyTest
fs = 16;
order = (2:10)'; %Tried through the whole Butterworth order capability in Matlab, error up until 66th order

jeros = zeros(numel(order), 1);

avg = jeros;
variance = jeros;
counts = jeros;
perc = jeros;
maxrange = jeros;
maxmean = jeros;
maxmax = jeros;

az = table2array(parquetread(path)); %obtain certain data from season dataset
az = az(1:1e6);

for ii = 1:numel(jeros)

    [z, p, k] = butter(ii, fc/(fs/2), "low");
    [sos, g] = zp2sos(z,p,k);

    azfilt = filtfilt(sos, g, az);
    if ii == numel(jeros)
        pelot = azfilt;
    end

    avg(ii) = mean(azfilt);

    variance(ii) = var(azfilt);

    azfilt = rainflow(azfilt);

    perc(ii) = prctile(azfilt(:,2), 95);

    maxrange(ii) = max(azfilt(:,2));

    maxmean(ii) = max(azfilt(:,3));

    counts(ii) = height(azfilt);

    maxmax(ii) = max(azfilt(:,3) + azfilt(:,2)/2);
end

x = order;

plot(x, avg, "*")
title("average")
figure
plot(x, variance, "*")
title("variance")
figure
plot(x, counts, "*")
title("cycle counts")
figure
plot(x, perc, "*")
title("95th percentile range")
figure
plot(x, maxrange, "*")
title("maximum range")
figure
plot(x, maxmean, "*")
title("max mean")

figure
plot(pelot)
hold on; plot(az)
ylim([-1000 1000])