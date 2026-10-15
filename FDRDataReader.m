%% About
%Name       : Sultan Favian Respati
%Student ID : 13622009
%Aerospace Engineering Major
%Faculty of Mechanical and Aerospace Engineering

%% FDR Data Import
clear; clc;close;

%To detect all variables within the csv file utilizing direct file path
path = ("C:\Users\Sultan F. Respati\Desktop\flight_N138265\661200309031434.csv");
data = detectImportOptions(path);

%To detect which variable to be read
data.SelectedVariableNames = 'hbaro_m';

%Reading chosen variable data as matrix
M = readmatrix(path, data);

%Determine NaN (Not a Number) valued variable data as binary logic (NaN as
%true, valued as 1)
nan = isnan(M);

%Zeros matrix to extract non-NaN valued variable data
A = zeros(size(nan,1)-sum(nan),1);

%For loop to extract non-NaN valued variable data
for i = 1:size(nan,1)
    if ~nan(i)
        A(i - sum(nan(1:i))) = M(i);
    end
end

plot(A)