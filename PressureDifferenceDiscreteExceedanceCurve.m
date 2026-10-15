close all; tic;
path = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Meteorological\saved_summer_hbaro_m_fulldata.parquet";

h = table2array(parquetread(path)); %read pre-acquired concatenated altitude data
r = 6.50; % Assumed fuselage radius in meter
t = 1.5e-3; % Assumed fuselage skin thickness in meter
[sigmahoop, htresh, P8kft, deltaP] = calcAircraftSigmaHoop(h, r, t);

% [~, ~, P] = atmosisa(h.hbaro_m); % Extract pressure variable (P) in pascal
% htresh = 8000*0.3048; % Altitude which pressurization become active, named threshold altitude
% P8kft = atmosisa(htresh); % Atmospheric pressure at 8000 feet (Pascal)
% 
% % Pressure difference calculation between cabin and environment
% deltaP = zeros(size(P)); % Declare empty matrix with the same size as pressure P data
% deltaP(h.hbaro_m <= htresh) = 0; % Pressurization has not yet turned on
% deltaP(h.hbaro_m > htresh) = P8kft - P(h.hbaro_m > htresh); % Pressurization has turned on
% clearvars P h %clearing unused variable to free up system space
% 
% sigmahoop = deltaP*r/t; % Hoop stress in Pascal or N/m^2

% clearvars deltaP %clearing unused variable to free up system space

rfres = rainflow(sigmahoop); %rainflow count obtained stress

% clearvars sigmahoop %clearing unused variable to free up system space

% rfres = [rfres rfres(:,2)/2]; %calculate stress amplitude and store it as the sixth column
% rfres = array2table(rfres, "VariableNames", ["Count" "Range" "Mean" "Start" "End" "Amplitude"]);

UTS = 483e6; %ultimate tensile stress of material in Pa
Yield = 345e6; %yield stress of material in Pa

% MEAN STRESS EFFECT
sigmaeq = sqrt(rfres(:,3)+rfres(:,2)/2); % SWT2                                                                                                                                          

% sigmaeq = calcGoodmanMeanStress(rfres(:,2)/2, rfres(:,3), UTS, -1);
plot(sigmaeq, ".")

% R = 0.05; %stress ratio conforming to obtained fatigue data of material
% SigmaGoodmanNFR = (rfres.Amplitude*Yield)./(Yield-rfres.Mean+rfres.Amplitude.*((1+R)/(1-R))); % Goodman not fully reversible (NFR) (R ~= -1)
%%
[occur, xcellcat, ycellcat, ~, ~, xmid, ymid] = createRangeDiscExce(12, sigmaeq);

figure
plot(h(1:ceil(numel(h)*0.05)), "-")

figure
plot(deltaP(1:ceil(numel(h)*0.05)), ".")

figure
semilogx(xcellcat, ycellcat)
hold on
semilogx(xmid, ymid, "*")
ylim([-0.1*(max(sigmaeq)) max(sigmaeq)*1.1])
yline(0, "LineStyle", "--")
ylabel("Stress Range in Pa")
xlabel("Number of Exceedance")

[flife, N, D, Dtot, lifefactor] = calcFatigueLife(ymid(1:end), occur(1:end), 1176);

%{
spring  1103
summer  1176
fall    1056
winter  875
%}