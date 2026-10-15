% Rainflow up to Mean Stress Correction
clc; clear all; close all; tic % Basic clean up procedure
csvpath = "C:\Users\Sultan F. Respati\Documents\00. TA\KMSPFILEANALYSIS\saved hbaro_m csv"; % The path where the csv files are located
lscsvpath = string(ls(csvpath)); % Listed contents of csv path, saved as string class array.
rfsavepath = "C:\Users\Sultan F. Respati\Documents\00. TA\KMSPFILEANALYSIS\saved hbaro_m rainflow"; % Rainflow result save path /  Rainflow save path
GoodmanNFRsavepath = "C:\Users\Sultan F. Respati\Documents\00. TA\KMSPFILEANALYSIS\saved hbaro_m GoodmanNFR";
GoodmanFRsavepath = "C:\Users\Sultan F. Respati\Documents\00. TA\KMSPFILEANALYSIS\saved hbaro_m GoodmanFR";
GerberFRsavepath = "C:\Users\Sultan F. Respati\Documents\00. TA\KMSPFILEANALYSIS\saved hbaro_m GerberFR";

% "if" logic is provided to create rainflow save path, due rainflow save path usually deleted as whole for easy
% analysis restart
if isfolder(rfsavepath) == 0
    mkdir(rfsavepath)
end

if isfolder(GoodmanNFRsavepath) == 0
    mkdir(GoodmanNFRsavepath)
end

if isfolder(GoodmanFRsavepath) == 0
    mkdir(GoodmanFRsavepath)
end

if isfolder(GerberFRsavepath) == 0
    mkdir(GerberFRsavepath)
end

n = 100; % Amount of csv(s) desired to be analysed
parfor i = 1:n
    h = readmatrix(fullfile(csvpath, lscsvpath(i+2,:))) % Read altitude data
    [~, ~, P] = atmosisa(h); % Extract pressure variable (P) in pascal
    htresh = 8000*0.3048; % Altitude which pressurization become active, named threshold altitude
    P8kft = atmosisa(htresh); % Atmospheric pressure at 8000 feet (Pascal)
    
    % Pressure difference calculation between cabin and environment
    deltaP = zeros(size(P)); % Declare empty matrix with the same size as pressure P data
    deltaP(h <= htresh) = 0; % Pressurization has not yet turned on
    deltaP(h > htresh) = P8kft - P(h > htresh); % Pressurization has turned on
    
    r = 6.49; % Assumed fuselage radius in meter
    t = 1.5e-3; % Assumed fuselage skin thickness in meter
    sigmahoop = deltaP*r/t; % Hoop stress in Pascal or N/m^2

    rfres = rainflow(sigmahoop) % Rainflow count
    rfres(:,4) = rfres(:,4)-1; % "Start" value in Matlab is +1 from actual value due to how Matlab matrix indexing
    rfres(:,5) = rfres(:,5)-1; % "End" value in Matlab is +1 from actual value due to how Matlab matrix indexing
    rfrescell{i} = [rfres rfres(:,2)/2]; % Save rainflow result plus stress amplitude in a cell variable due to parallelization
    writematrix(rfrescell{i}, fullfile(rfsavepath, join(["rainflow", lscsvpath(i+2,:)]))) % Save data to rainflow result save path
    rfres = array2table(rfrescell{i}, "VariableNames", ["Count" "Range" "Mean" "Start" "End" "Amplitude"]); % Write rfres in a table for easy variable naming
    Count = rfres.Count;
    % Data of Material Properties
    UTS = 1430*10^6; % Ultimate tensile strength in Pa
    Yield = 1250*10^6; % Yield strength in Pa

    % Mean Stress Correction
    R = 0.05; % Stress ratio provided from obtained SN curve
    SigmaGoodmanNFR = (rfres.Amplitude*Yield)./(Yield-rfres.Mean+rfres.Amplitude.*((1+R)/(1-R))); % Goodman not fully reversible (NFR) (R ~= -1)
    
    SigmaGoodmanFR = rfres.Range./(1-(rfres.Mean/UTS)); % Goodman fully reversible (FR) (R = -1)
    
    SigmaGerberFR = rfres.Range./(1-(rfres.Mean/UTS)).^2; % Gerber fully reversible (FR) (R = -1)
    
    % Exceedance Curves
    rfres.Count = round(rfres.Count); % Round up "Count" values
    %{
    countGoodmanNFR = rfres.Count;
    countGoodmanFR = rfres.Count;
    countGerberFR = rfres.Count;
    %}

    % Note : code below only valid if assuming all "Count" is rounded up
    % (value equal one)
    [SigmaGoodmanNFR, I] = sort(SigmaGoodmanNFR, "descend"); % Sort stress from biggest to smallest
    ExceedanceGoodmanNFR{i} = [SigmaGoodmanNFR rfres.Count (1:length(rfres.Count))']
    writematrix(ExceedanceGoodmanNFR{i}, fullfile(GoodmanNFRsavepath, join(["GoodmanNFR", lscsvpath(i+2,:)])))
    %ExceedanceGoodmanNFR = array2table([SigmaGoodmanNFR rfres.Count (1:length(rfres.Count))'], "VariableNames", ["Goodman Corrected Stress (R ~= -1)" "Count" "Cummulative Exceedance"])
    
    [SigmaGoodmanFR, I] = sort(SigmaGoodmanFR, "descend"); % Sort stress from biggest to smallest
    ExceedanceGoodmanFR{i} = [SigmaGoodmanFR rfres.Count (1:length(rfres.Count))']
    writematrix(ExceedanceGoodmanFR{i}, fullfile(GoodmanFRsavepath, join(["GoodmanFR", lscsvpath(i+2,:)])))
    %ExceedanceGoodmanFR = array2table([SigmaGoodmanFR rfres.Count (1:length(rfres.Count))'], "VariableNames", ["Goodman Corrected Stress (R = -1)" "Count" "Cummulative Exceedance"])
        
    [SigmaGerberFR, I] = sort(SigmaGerberFR, "descend"); % Sort stress from biggest to smallest
    ExceedanceGerberFR{i} = [SigmaGerberFR rfres.Count (1:length(rfres.Count))']
    writematrix(ExceedanceGerberFR{i}, fullfile(GerberFRsavepath, join(["GerberNFR", lscsvpath(i+2,:)])))
    %ExceedanceGerberFR = array2table([SigmaGerberFR rfres.Count (1:length(rfres.Count))'], "VariableNames", ["Gerber Corrected Stress (R = -1)" "Count" "Cummulative Exceedance"])
end
toc