clc; clear all; close all;

% Al 2024 T3 property
UTS = 483e6; %Ultimate tensile strength (Pa)
Yield = 345e6; %Yield strength (Pa)

M = 9.699132155499026e+06/1e6; %Bending moment (MNm)
V = -7.314922689923837e+05; %Shear stress (N/m^2)
L = 0.2; %Length between ribs (m)

% hfront = 0.0986; %Front spar height (m)
% hrear = 0.0758; %Rear spar height (m)
% h = mean([hfront; hrear]); % mean spar height (m)
% 
% exrootch = 3.266; %chord (m)
% w = (0.7-0.183)*exrootch; %Howe, Shearbox chord length (m)
% Fb = 1.02; %Howe, Table 13.4
% Abar = 138; %Howe, Table 13.5
% 
% % ts = sqrt(M*L/(h*w))*0.681/(Abar*Fb); %Stringer thickness
% 
% % TO OBTAIN SPAR WEB THICKNESS
% % Qv = V/ht;
% Qw = Qv + 2.*x.*Qt/w;
% sigmas = 0.5*UTS;
% tw = Qw/sigmas;

%% Second Moment of Inertia of Shear Box at Wing Root

%written with the order of : spars forward to aft, upper stringer forward
%to aft then lower stringer forward to aft, upper AND lower skin (joined
%together)

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