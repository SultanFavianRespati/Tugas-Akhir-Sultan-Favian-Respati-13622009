clc; clear all; close all; tic;
h = parquetread("C:\Users\Sultan F. Respati\Documents\00. TA\KMSPFILEANALYSIS\saved hbaro_m fulldata.parquet"); %read pre-acquired concatenated altitude data

[~, ~, P] = atmosisa(h.hbaro_m); % Extract pressure variable (P) in pascal
htresh = 8000*0.3048; % Altitude which pressurization become active, named threshold altitude
P8kft = atmosisa(htresh); % Atmospheric pressure at 8000 feet (Pascal)

% Pressure difference calculation between cabin and environment
deltaP = zeros(size(P)); % Declare empty matrix with the same size as pressure P data
deltaP(h.hbaro_m <= htresh) = 0; % Pressurization has not yet turned on
deltaP(h.hbaro_m > htresh) = P8kft - P(h.hbaro_m > htresh); % Pressurization has turned on
clearvars P h %clearing unused variable to free up system space
r = 6.49; % Assumed fuselage radius in meter
t = 1.5e-3; % Assumed fuselage skin thickness in meter
sigmahoop = deltaP*r/t; % Hoop stress in Pascal or N/m^2

clearvars deltaP %clearing unused variable to free up system space

rfres = rainflow(sigmahoop); %rainflow count obtained stress

clearvars sigmahoop %clearing unused variable to free up system space

rfres(:,4) = rfres(:,4)-1; % "Start" value in Matlab is +1 from actual value due to how Matlab matrix indexing
rfres(:,5) = rfres(:,5)-1; % "End" value in Matlab is +1 from actual value due to how Matlab matrix indexing
rfres = [rfres rfres(:,2)/2]; %calculate stress amplitude and store it as the sixth column
rfres = array2table(rfres, "VariableNames", ["Count" "Range" "Mean" "Start" "End" "Amplitude"]);

UTS = 483*10^6; %ultimate tensile stress of material in Pa
Yield = 345*10^6; %yield stress of material in Pa

R = 0.05; %stress ratio conforming to obtained fatigue data of material
SigmaGoodmanNFR = (rfres.Amplitude*Yield)./(Yield-rfres.Mean+rfres.Amplitude.*((1+R)/(1-R))); % Goodman not fully reversible (NFR) (R ~= -1)

%% THIS CAME FROM AI
% --- PREPARE CONTINUOUS DATA ---
y_continuous = sort(SigmaGoodmanNFR, 'descend');
x_continuous = 1:numel(y_continuous);

% --- PREPARE TRUE COMB PILLARS (Equal X-Axis Spacing) ---
num_bins = 12; 

% We need 13 points to create exactly 12 equal intervals
x_bins = round(logspace(1, log10(numel(y_continuous)), num_bins + 1));
x_bins(1) = 1; % Ensure we start at the Y-axis

% Get the stress for each bin
stress_bins = y_continuous(x_bins);

% Initialize plotting arrays
x_plot = [];
y_plot = [];

% Draw 12 True Comb Pillars
for i = 1:num_bins
    % 1. Start at the floor (bottom left of the tooth)
    x_plot = [x_plot; x_bins(i)];
    y_plot = [y_plot; 0]; 
    
    % 2. Go straight up to the stress level (top left)
    x_plot = [x_plot; x_bins(i)];
    y_plot = [y_plot; stress_bins(i)];
    
    % 3. Move right to the edge of the bin (top right)
    x_plot = [x_plot; x_bins(i+1)];
    y_plot = [y_plot; stress_bins(i)];
    
    % 4. Drop straight down to the floor (bottom right)
    x_plot = [x_plot; x_bins(i+1)];
    y_plot = [y_plot; 0];
    
    % 5. Add NaN to break the line (forces distinct, separated pillars)
    x_plot = [x_plot; NaN];
    y_plot = [y_plot; NaN];
end

% --- PLOTTING THE OVERLAY ---
figure
semilogx(x_plot, y_plot, 'LineWidth', 2, 'Color', '#0072BD') 
hold on 
semilogx(x_continuous, y_continuous, 'LineWidth', 1.5, 'Color', '#D95319', 'LineStyle', '--') 
hold off 

xlabel('Number of Exceedances')
ylabel('Stress Range (Pa)')
title('Continuous Exceedance vs. True Combed Spectrum')
legend('12-Block Spectrum (Combed)', 'Continuous Data')
grid on
%%
data = array2table([x y], "VariableNames", ["Occurence" "Binned Stress"]);
parquetwrite("C:\Users\Sultan F. Respati\Documents\00. TA\KMSPFILEANALYSIS\hbaro_m discretized exceedance curve.parquet", data, "VariableNames", ["Occurence" "Binned Stress"])
%%
%{
figure
semilogx(x, y)
xlabel('Number of Exceedance')
ylabel('Stress range in Pa')

toc
%}