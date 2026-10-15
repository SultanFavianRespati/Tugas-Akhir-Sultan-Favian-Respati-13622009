clc
clear all
close all

sympref('FloatingPointOutput', true);
syms y

cwby = -0.199*y + 7.947; %See excel calculation or personal note, effective half span wing box chord length as a function of y, abbreviation for chord-wing-box-y(y)
cy = -0.422*y + 16.795; %See excel calculation or personal note, chord length as a function of y

% Vinb = 12240; %Inboard half span fuel tank volume (US Gallon)
% Voutb = 4420; %Outboard half span fuel tank volume (US Gallon)

ftotup = 3686.8 + 3813.8 + 1970.4; %KMSP30R, total fuel mass brought biggest zip file size (kg)
ftotlow = 2133.7 + 2017.58; %KMSP30R, total fuel mass brought smallest zip file size (kg)
fave = mean([ftotup; ftotlow]); %average fuel mass brought (kg)
favehs = fave*0.5; %half span average fuel mass brought (kg)
Vresfuel = 500*0.00379; %Reserve fuel tank half span volume (m^3)

% SIMPLIFIED GROSS WEIGHT CALCULATION
rhofuel = 820; %Wikipedia, Jet A-1 fuel density (kg/m^3)
Wmaxzerofuel = 174040*9.80665; %Boeing 747-300 commercial aircraft. Pictures, specifications, reviews. HTML, Aircraft maximum zero fuel weight (N)
Wnrfuel = favehs*9.80665; %FAA provided image, half span assumed filled fuel tank fuel weight excluding reserve (N)
Wresfuel = rhofuel*Vresfuel*9.80665; %FAA provided image, half span assumed 100% filled fuel tank fuel weight (N)
GW = Wmaxzerofuel + 2*Wnrfuel + 2*Wresfuel; %Gross weight = max zero fuel weight + non reserve 50% filled fuel weight + reserve fuel weight

% Y SPAN BOUNDS
ytip = 29.8; %y span tip coordinate

% NON RESERVE FUEL DISTRIBUTION (coordinate : 3.266 - 20.076 m)
Snrfuel50 = (7.297+3.952)*(20.076-3.266)/2; %Half span non reserve fuel reference area, assumed to be not kinked (simple trapezoid)
fuelwin = heaviside(y-3.266) - heaviside(y-20.076); %window which half span fuel load applies
qnrfuel50 = (Wnrfuel/Snrfuel50)*cwby*fuelwin; %fitted curve for half span fuel distribution

% RESERVE FUEL DISTRIBUTION (coordinate : 20.076 - 24.855)
Sresfuel = (3.952+3.001)*(24.855-20.076)/2; %Half span reserve fuel tank reference area, assumed to be not kinked (simple trapezoid)
resfuelwin = heaviside(y-20.076) - heaviside(y-24.855);
qresfuel = (Wresfuel/Sresfuel)*cwby*resfuelwin;

% ENGINES (coordinate : 11.848, 20.767 m)
Weng1 = 4385*9.80665*dirac(y-11.848); %Wikipedia, average CF6-80C engine weight as point load
Weng2 = 4385*9.80665*dirac(y-20.767); %Wikipedia, average CF6-80C engine weight as point load

% LANDING GEAR (coordinate : 5.484 m)
WLG = 0.0372*GW; %Roskam but modified, assumed weight of a single landing gear
WLG = WLG*dirac(y-5.484); %apply landing gear weight as point load

% FUEL SYSTEM (coordinate : 3.266 - 24.855 m)
Wfuelsys = 0.00579*0.5*GW; %Roskam, assumed half span fuel system weight
Stank = (7.297+3.001)*(24.855 - 3.266)/2; %Half span fuel tank reference area
fuelsyswin = heaviside(y-3.266) - heaviside(y-24.855);
qfuelsys = Wfuelsys*cwby*fuelsyswin/Stank; %Half span fuel system weight distribution

% AERO LIFT (coordinate : 0 - 29.8 m)
aeroliftwin = heaviside(y) - heaviside(y-29.8); %window which aerodynamic lift applies
qaerolift = wingaerodynamicliftdistribution("poly6")*aeroliftwin; %Half span aerodynamic lift distribution. Note : change this equation if analyzed flight condition is changed

% STRUCTURAL (coordinate : 0 - 29.8 m)
Wwing = 0.113*0.5*GW; %Roskam, half span wing assumed structural weight
Swing = (4.232+16.795)*29.8*0.5; %half span wing reference area
qstruct = Wwing*cy*aeroliftwin/Swing; %half span wing weight distribution

% NET LOAD DISTRIBUTION
qnet = - qnrfuel50 ;
qnet = qnet - qresfuel;
qnet = qnet - Weng1;
qnet = qnet - Weng2;
qnet = qnet - WLG;
qnet = qnet - qfuelsys;
qnet = qnet + qaerolift;
qnet = qnet - qstruct;

% INTEGRATION TO OBTAIN SHEAR AND MOMENT DISTRIBUTION FUNCTION
Vindef = int(qnet, y); %indefinitely integrated half span shear distribution function
Mindef = int(Vindef, y); %indefinitely integrated moment distribution function

% INDEFINITE INTEGRAL CONSTANTS DETERMINATION
C1 = subs(-Vindef, y, ytip); %first integration constant
C2 = subs(-Mindef, y, ytip) - C1*ytip; %second integration constant

% FULLY CONSTRUCTED SHEAR AND MOMENT DISTRIBUTION FUNCTION
Vnet = Vindef + C1; %complete half span shear distribution function
Mnet = Mindef + C1*y + C2; %complete half span moment distribution function

% LOAD, SHEAR, MOMENT DISTRIBUTION FUNCTION AS SUBSTITUTABLE FUNCTION
qnetfun = matlabFunction(qnet);
Vnetfun = matlabFunction(Vnet);
Mnetfun = matlabFunction(Mnet);

% Y SPAN PLOT WINDOW
pp = 0:0.0001:ytip; %chosen plot range

% PLOT WINDOW COORDINATES SUBSTITUTION
qnetpp = qnetfun(pp); %force distribution plot points
Vnetpp = Vnetfun(pp); %shear distribution plot points
Mnetpp = Mnetfun(pp); %moment distribution plot points

% MOMENT AT ROOT
V = Vnetfun(0); %shear stress at root
M = Mnetfun(0); %bending moment at root

% PLOT
plot(pp, qnetpp, "r.")
title("Gaya Angkat vs Setengah Span Sayap")
ylabel('Gaya Angkat (N)')
xlabel("Setengah Span Sayap (m)")

figure
plot(pp, Vnetpp, "g.")
title("Gaya Geser vs Setengah Span Sayap")
ylabel('Gaya Geser (N)')
xlabel("Setengah Span Sayap (m)")

figure
plot(pp, Mnetpp, "m.")
title("Momen Lentur vs Setengah Span Sayap")
ylabel('Momen Lentur (Nm)')
xlabel("Setengah Span Sayap (m)")

% TOTAL AERODYNAMIC LIFT
Lhalf = double(int(qaerolift,y,0,ytip));
Ltotal = 2*Lhalf;

fprintf("Half-span lift = %.3f N\n", Lhalf);
fprintf("Total lift     = %.3f N\n", Ltotal);
fprintf("Gross weight   = %.3f N\n", GW);

%=================================Z Coordinate of Each Component=================================
Zloc_spars = [0.195 0.152 0.179]; %forward to aft

Zloc_upperstr = [1.050 1.065 1.077 1.086 1.094 1.099 1.103 1.106 ...
    1.106 1.106 1.104 1.102 1.100 1.096 1.091 1.085 ...
    1.067 1.056 1.043 1.029 1.013 0.996 0.978 0.958 ...
    0.936 0.910 0.883 0.853]; %forward to aft

Zloc_lowerstr = [-0.619 -0.642 -0.664 -0.684 -0.701 -0.717 -0.730 -0.740 ...
    -0.749 -0.754 -0.758 -0.760 -0.759 -0.756 -0.752 -0.745 ...
    -0.722 -0.705 -0.685 -0.663 -0.639 -0.614 -0.587 -0.560 ...
    -0.533 -0.505 -0.477 -0.447]; %forward to aft

Zloc_skintopbottom = 0.192; %upper and lower skin

Zloc = [Zloc_spars Zloc_upperstr Zloc_lowerstr Zloc_skintopbottom];

%=================================Local Second Moment of Area of Each Component=================================
Iloc_spars = [5679259804.00270653e-12 ...
    7869884037.59466743e-12 ...
    2576932165.42907858e-12]; %forward to aft

Iloc_upperstr = ones(1, numel(Zloc_upperstr)) * 33503.54129012e-12; %forward to aft

Iloc_lowerstr = ones(1, numel(Zloc_lowerstr)) * 33503.54129012e-12; %forward to aft

Iloc_skintopbottom = 91442585530.49626160e-12; %upper and lower skin

Iloc = [Iloc_spars Iloc_upperstr Iloc_lowerstr Iloc_skintopbottom];

%=================================Local Area of Each Component=================================
Acomp_spars = [24843.82721841e-6 ...
    27697.72075305e-6 ...
    19090.71746039e-6]; %forward to aft

Acomp_upperstr = ones(1, numel(Zloc_upperstr)) * 150.4e-6; %forward to aft

Acomp_lowerstr = ones(1, numel(Zloc_lowerstr)) * 150.4e-6; %forward to aft

Acomp_skintopbottom = 122183.97522798e-6; %upper and lower skin

Acomp = [Acomp_spars Acomp_upperstr Acomp_lowerstr Acomp_skintopbottom];

Zneutral = sum(Acomp.*Zloc)./sum(Acomp); %1x1 matrix
d = Zloc - Zneutral; %Nx1 matrix, Zloc Nx1 matrix, Zneutral 1x1 matrix
Icomp = Iloc + Acomp.*d.^2; %Nx1 matrix, Iloc Nx1 matrix, Acomp Nx1 matrix, d Nx1 matrix
Itot = sum(Icomp);

dneut2lowest = 0.776;

sigma_bending_max = M*dneut2lowest/Itot;
fprintf("Bending moment at root   = %.3f Nm\n", M);
fprintf("Total second moment of area   = %.3f m^4\n", Itot);
fprintf("Root lower wing skin stress   = %.3f MPa\n", sigma_bending_max/10^6);



function fun = wingaerodynamicliftdistribution(fittype)
Lift = [8152.621544
13505.76812
18179.8116
21896.18718
24989.79236
27810.70319
30499.53509
33046.17336
35368.40929
36358.6949
37061.0035
37984.22038
39059.46601
40223.71311
41385.57805
42430.41423
43229.99542
43656.24252
43614.19171
43614.19171
43656.24252
43229.99542
42430.41423
41385.57805
40223.71311
39059.46601
37984.22038
37061.0035
36358.6949
35368.40929
33046.17336
30499.53509
27810.70319
24989.79236
21896.18718
18179.8116
13505.76812
8152.621544
    ];
yspan = [-29.672
    -29.1639
    -28.1632
    -26.7002
    -24.8194
    -22.578
    -20.044
    -17.2945
    -14.413
    -12.8703
    -12.5534
    -11.9274
    -11.0077
    -9.8169
    -8.3844
    -6.7455
    -4.9405
    -3.0138
    -1.0129
    1.0129
    3.0138
    4.9405
    6.7455
    8.3844
    9.8169
    11.0077
    11.9274
    12.5534
    12.8703
    14.413
    17.2945
    20.044
    22.578
    24.8194
    26.7002
    28.1632
    29.1639
    29.672
    ];

fitresult = fit(yspan, Lift, fittype);
coeff = coeffvalues(fitresult);

syms y
fun = 0;

for i = 1:length(coeff)
    fun = fun + coeff(i)*y^(length(coeff)-i);
end
end