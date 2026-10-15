clc; clear all; close all

%datapath
path = "C:\Users\Sultan F. Respati\Documents\00. TA\Flight Data KMSP 30R\flight_N110314.zip\654200302141553.csv";

%get vertical acceleration accelerometer
var = "az_mps2";
az = getSpecificVarDataWithNaN(path, var); %get variable
az(az == min(az)) = NaN; %Remove outlier*
az = fillmissing(az, "linear"); %Fill NaN (not a number) linearly
az(end) = []; %remove last array index to match array size of hdot2z
avgaz = mean(az);

az = az-avgaz; %9.80665;

plot(az, "-*", "MarkerSize", 2)

% --- PSD Calculation ---
N = numel(az);
fs = 8;
fftaz = fft(az);

% 1. Keep only the first half of the FFT
fftaz = fftaz(1:floor(N/2)+1);

% 2. Calculate Power Spectral Density
paz = (1/(fs*N)) * abs(fftaz).^2;

% 3. Conserve energy for the single-sided spectrum
paz(2:end-1) = 2*paz(2:end-1);

% 4. Generate the correct frequency x-axis
xpl = 0:(fs/N):(fs/2);

% 5. Plot (using a logarithmic y-axis makes it much easier to read)
figure
plot(xpl, 10*log10(paz), "-*")
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/(Hz))')
title('Single-Sided PSD of Vertical Acceleration')

% --- Zero-Phase Low-Pass Filtering ---

% 1. Define filter parameters
fc = 0.3; % Cutoff frequency in Hz (Adjust between 0.1 and 0.5 to see the effect)
Wn = fc / (fs/2); % Normalize the cutoff frequency for MATLAB (0 to 1 scale)

% 2. Design a 2nd-order Butterworth filter
% b = numerator coefficients, a = denominator coefficients
[b, a] = butter(4, Wn, 'low'); 

% 3. Apply zero-phase filtering (forward and backward)
az_filtered = filtfilt(b, a, az);

err = rmse(az_filtered, az);
cor = corrcoef(az_filtered, az);

% 4. Plot the comparison in the time domain
figure
plot(az, 'Color', [0.7 0.7 0.7], 'DisplayName', 'Raw Data (az)')
hold on
plot(az_filtered, 'b', 'LineWidth', 2, 'DisplayName', 'Filtered Trend')
hold off
xlabel('Samples')
ylabel('Vertical Acceleration (m/s^2)')
title(['Zero-Phase Butterworth Filter (Cutoff = ' num2str(fc) ' Hz), RMSE = ' num2str(err) ' corr = ' num2str(cor(1,2))])
legend('Location', 'best')
grid on
ylim([-50 50])

%fc 0.5 rmse 0.063389 corr 0.96943
%fc 0.3 butter 2 rmse 0.083096 corr 0.94757