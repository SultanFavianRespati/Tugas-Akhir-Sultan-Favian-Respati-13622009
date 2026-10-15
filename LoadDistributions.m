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
Wnrfuel = favehs*9.80665; %FAA provided image, half span assumed 50% filled fuel tank fuel weight excluding reserve (N)
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
V = Vnetfun(0); %shear stress at exposed root
M = Mnetfun(0); %bending moment at exposed root

% PLOT
plot(pp, qnetpp, "r.")
title("Lift vs Y Span")

figure
plot(pp, Vnetpp, "g.")
title("Shear vs Y Span")

figure
plot(pp, Mnetpp, "m.")
title("Bending Moment vs Y Span")

% TOTAL AERODYNAMIC LIFT
Lhalf = double(int(qaerolift,y,0,ytip));
Ltotal = 2*Lhalf;

fprintf("Half-span lift = %.3f N\n", Lhalf);
fprintf("Total lift     = %.3f N\n", Ltotal);
fprintf("Gross weight   = %.3f N\n", GW);

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