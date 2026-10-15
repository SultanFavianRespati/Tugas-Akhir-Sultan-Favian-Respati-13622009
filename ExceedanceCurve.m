clc; clear all; close all;
% EXCEEDANCE CURVE

% Required history data : Syy, Szz, Mises, Max Principals (P1 P2)

%{
syy = readmatrix()
szz = readmatrix()
mises = readmatrix()
P1 = readmatrix()
P2 = readmatrix()

or

[Syy Szz Mises P1 P2] = readvars("filepath")
%}

% Mises
Mises = [50.55
10.942
12.278
49.21
4.9264
3.1224
52.554
5.2274
3.6965
107.72
25.506
72.778
45.073
115.88
39
92.733
77.825
2.0679
18.793
3.5569
3.5836
85.061
8.563
90.204
115.62
86.203
98.754
22.038
148.37
32.281
37.42
78.858
54.978
35.499
];

% Max Principal 1
P1 = [48.854
-10.662
-11.619
47.648
4.4198
2.917
50.926
-4.6362
-3.618
104.55
-24.803
-69.873
43.835
112.48
-37.746
-88.921
75.692
1.7781
-18.203
3.672
-2.5649
-81.7
8.2816
87.932
-110.7
-82.172
95.941
-21.003
-142.09
32.178
36.576
-75.953
-52.625
-33.133
];

%Max Principal 2
P2 = [-2.2392
0.36382
0.68064
-1.8429
-0.78596
-0.12259
-1.6037
-0.19311
-0.10727
-3.8423
0.78239
3.061
-1.3681
-3.9559
1.34
4.205
-1.9838
-0.48724
0.64391
0.25311
0.80701
3.567
-0.30434
-2.5171
5.301
4.1524
-3.267
1.0788
6.7342
-0.11403
-0.74946
3.2328
2.5121
2.1616
];

Syy = [48.854
-10.662
-11.619
47.648
4.4198
2.917
50.926
-4.6362
-3.618
104.55
-24.803
-69.873
43.835
112.48
-37.746
-88.921
75.692
1.7781
-18.203
3.672
-2.5649
-81.7
8.2816
87.932
-110.7
-82.172
95.941
-21.003
-142.09
32.178
36.576
-75.953
-52.625
-33.133
];

Szz = [-2.2392
0.36382
0.68064
-1.8429
-0.78596
-0.12259
-1.6037
-0.19311
-0.10727
-3.8423
0.78239
3.061
-1.3681
-3.9559
1.34
4.205
-1.9838
-0.48724
0.64391
0.25311
0.80701
3.567
-0.30434
-2.5171
5.301
4.1524
-3.267
1.0788
6.7342
-0.11403
-0.74946
3.2328
2.5121
2.1616
];
%% Signed Mises and Signed Absolute Maximum Principal Stress
signedmises = sign((Syy+Szz)/2).*Mises;

%{
if P1 >= P2
    signedabsmaxprincipal = P1;
else
    signedabsmaxprincipal = P2;
end
%}

%% RAINFLOW COUNT
%Rainflow count signedmises data

a = rainflow(signedmises) %store rainflow results inside a variable

a(:,4) = a(:,4)-1;
a(:,5) = a(:,5)-1;
a = [a a(:,2)/2]; %Calculate stress amplitude (sigma_a)

rfres = array2table(a, "VariableNames", ["Count" "Range" "Mean" "Start" "End" "Amplitude"]); %rfres : rainflow result

%% Material Ultimate and Yield Properties
UTS_MPa = 1430; %MPa
Yield_MPa = 1250; %MPa

%% Mean Stress Correction
%Goodman (R ~= -1)
R = 0.05;
SigmaGoodmanNFR = (rfres.Amplitude*Yield_MPa)./(Yield_MPa-rfres.Mean+rfres.Amplitude.*((1+R)/(1-R)));

SigmaGoodmanFR = rfres.Range./(1-(rfres.Mean/UTS_MPa));

SigmaGerberFR = rfres.Range./(1-(rfres.Mean/UTS_MPa)).^2;

%% Exceedance Curve Stress (Goodman R ~= -1)

%Sort SigmaGoodmanNFR (Not Fully Reversible)

[SigmaGoodmanNFR, I] = sort(SigmaGoodmanNFR, "descend");

rfres.Count = round(rfres.Count(I));

%Exceedance Curve
ExceedanceGoodmanNFR = array2table([SigmaGoodmanNFR rfres.Count (1:length(rfres.Count))'], "VariableNames", ["Goodman Corrected Stress (R ~= -1)" "Count" "Cummulative Exceedance"])

% Discretize
n = 12; %amount of discretization segments

%% Exceedance Curve Stress (Goodman R = -1)

%Sort SigmaGoodmanFR (Fully Reversible)

[SigmaGoodmanFR, I] = sort(SigmaGoodmanFR, "descend");

rfres.Count = round(rfres.Count(I));

%Exceedance Curve
ExceedanceGoodmanFR = array2table([SigmaGoodmanFR rfres.Count (1:length(rfres.Count))'], "VariableNames", ["Goodman Corrected Stress (R = -1)" "Count" "Cummulative Exceedance"])

%% Exceedance Curve Stress (Gerber R = -1)

%Sort SigmaGoodmanFR (Fully Reversible)

[SigmaGerberFR, I] = sort(SigmaGerberFR, "descend");

rfres.Count = round(rfres.Count(I));

%Exceedance Curve
ExceedanceGerberFR = array2table([SigmaGerberFR rfres.Count (1:length(rfres.Count))'], "VariableNames", ["Gerber Corrected Stress (R = -1)" "Count" "Cummulative Exceedance"])
