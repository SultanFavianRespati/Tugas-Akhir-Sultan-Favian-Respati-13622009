clc; clear all; close all

%Zip file with the smallest size
path = "C:\Users\Sultan F. Respati\Documents\00. TA\Flight Data KMSP 30R\flight_N114746.zip\655200307210357.csv";

tiledlayout(2,2)

nexttile
fuel = getSpecificVarDataWithNaN(path, "fqty_1_kg");
fuel = fillmissing(fuel, "linear");
plot(fuel, "-*")
ylim([0 5000])
title("Fuel Tank No. 1")
xlabel("Sample")
ylabel("Fuel Mass (kg)")

nexttile
fuel = getSpecificVarDataWithNaN(path, "fqty_2_kg");
fuel = fillmissing(fuel, "linear");
plot(fuel, "-*")
ylim([0 5000])
title("Fuel Tank No. 2")
xlabel("Sample")
ylabel("Fuel Mass (kg)")

nexttile
fuel = getSpecificVarDataWithNaN(path, "fqty_3_kg");
fuel = fillmissing(fuel, "linear");
plot(fuel, "-*")
ylim([0 5000])
title("Fuel Tank No. 3")
xlabel("Sample")
ylabel("Fuel Mass (kg)")

nexttile
fuel = getSpecificVarDataWithNaN(path, "fqty_4_kg");
fuel = fillmissing(fuel, "linear");
plot(fuel, "-*")
ylim([0 5000])
title("Fuel Tank No. 4")
xlabel("Sample")
ylabel("Fuel Mass (kg)")

%Zip file with the biggest size
path = "C:\Users\Sultan F. Respati\Documents\00. TA\Flight Data KMSP 30R\flight_N157529.zip\666200210071615.csv";

figure
tiledlayout(2,2)

nexttile
fuel = getSpecificVarDataWithNaN(path, "fqty_1_kg");
fuel = fillmissing(fuel, "linear");
plot(fuel, "-*")
ylim([0 5000])
title("Fuel Tank No. 1")
xlabel("Sample")
ylabel("Fuel Mass (kg)")

nexttile
fuel = getSpecificVarDataWithNaN(path, "fqty_2_kg");
fuel = fillmissing(fuel, "linear");
plot(fuel, "-*")
ylim([0 5000])
title("Fuel Tank No. 2")
xlabel("Sample")
ylabel("Fuel Mass (kg)")

nexttile
fuel = getSpecificVarDataWithNaN(path, "fqty_3_kg");
fuel = fillmissing(fuel, "linear");
plot(fuel, "-*")
ylim([0 5000])
title("Fuel Tank No. 3")
xlabel("Sample")
ylabel("Fuel Mass (kg)")

nexttile
fuel = getSpecificVarDataWithNaN(path, "fqty_4_kg");
fuel = fillmissing(fuel, "linear");
plot(fuel, "-*")
ylim([0 5000])
title("Fuel Tank No. 4")
xlabel("Sample")
ylabel("Fuel Mass (kg)")