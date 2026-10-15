clc; clear all; close all

%datapath
path = "C:\Users\Sultan F. Respati\Documents\00. TA\Flight Data KMSP 30R\flight_N110314.zip\654200302141553.csv";

%get vertical velocity
var = "hdot_2_mps"; %chosen variable
hdotz = getSpecificVarDataWithNaN(path, var); %get variable

%differentiate to obtain vertical acceleration hdot2z
dy = diff(hdotz);
dx = 1/16;
hdot2z = dy/dx; %IVS derived acceleration

%get vertical acceleration accelerometer
var = "az_mps2";
az = getSpecificVarDataWithNaN(path, var); %get variable
az(az == min(az)) = NaN; %Remove outlier*
az = fillmissing(az, "linear"); %Fill NaN (not a number) linearly
az(end) = []; %remove last array index to match array size of hdot2z
avgaz = mean(az);
    
az = az-avgaz; %9.80665;

err = rmse(az, hdot2z); %root mean square error
cor = corrcoef(az, hdot2z); %correlation coefficient

plot(hdot2z, "g-*", "MarkerSize", 2)
hold on
plot(az, "r-*", "MarkerSize", 2)
xlabel("Sample")
ylabel("Vertical Acceleration (m/s^2)")
title(sprintf("Vertical Acceleration Plot (RMSE = %.3f, Correlation = %.3f)", err, cor(1,2)))
legend("IVS Derived", "Accelerometer", "Location", "northeast")