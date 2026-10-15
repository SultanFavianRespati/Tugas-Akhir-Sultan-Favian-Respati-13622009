clc; clear; close all

period = ["full_true" "spring" "summer" "fall" "winter"];

for ss = 1:numel(period)
    fprintf("current season : %s\n", period(ss))
    path = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\crackgrowth_cyclepair_input\saved_" + period(ss) + "_rainflow_azmps2_randomized_cycle_pair_RNG136.parquet";
    
    rand_cyclepair = parquetread(path);
    
    maxima = (rand_cyclepair.maxima/9.80665)*62.298*1.5; %62.298 MPa okay MEGA
    minima = (rand_cyclepair.minima/9.80665)*62.298*1.5;
    
    clearvars rand_cyclepair
    
    KIc = 46; % Dirgantara et al., in MPa okay MEGA, 
    C = 2.838573e-12; %Dirgantara et al. yang dari manda kolab Aliabadi dan Pak Ichsan
    m = 4.6; %yang ini juga
    
    N = 0;
    datalength = length(maxima);
    ii = 1;
    aa = 1;
    N4plot = zeros(1, 1e6);
    a2c    = zeros(1, 1e6);
    
    a = 1.73e-3; % IGNORE -> See AFGROW, assumed initial through crack length, meter
    r = (4.7625e-3)*0.5; % rivet hole 3/16 in dia., or yeah that much in [] NO REFERENCE
    a_max = 1e-2 - r;
    
    maxima = max(maxima, 0); %to ensure only consider stress above 0
    minima = max(minima, 0); %to ensure only consider stress above 0
    maxmax = max(maxima);
    
    while true
    
        sigmamax = maxima(ii);
        sigmamin = minima(ii);
            
        % B = betaWOW(a, r, r, r, 2.5e-2);
        B = betaEdgeCrackNearHoleRc02(a) + 1.1215 - 1; %Cartwright compunding method
        if B <= 0
            break
        end

        Kfactor = B * sqrt(pi*a);
        Kmax = Kfactor * sigmamax;
        Kmin = Kfactor * sigmamin;
        
        if Kmax >= KIc
            break
        end
    
        deltaK = Kmax-Kmin;
    
        da = C*(deltaK)^m; %Paris
    
        a = a + da;
        N = N + 1;
    
        if mod(N, 100e3) == 0
            % Expand arrays if necessary
            if aa > length(N4plot)
                N4plot(end+1:end+1e6) = 0;
                a2c(end+1:end+1e6) = 0;
            end
            a2c(aa) = a;
            N4plot(aa) = N;
            aa = aa + 1;
        end
    
        if a >= a_max
            break
        end

        if ii == datalength
            ii = 1;
        else
            ii = ii + 1;
        end
    end
    
    N4plot(aa) = N;
    a2c(aa) = a;
    N4plot = N4plot(1:aa);
    a2c    = a2c(1:aa);
    
    savepath = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\crackgrowthloop_results\crackgrowthloop_" + period(ss);
    save(savepath)
end

% plot(N4plot, a2c, ".")
% xlabel("Siklus Beban")
% ylabel("Panjang Retak (m)")
% yline(a_max, '--', sprintf('Maximum crack length = %.2f mm', a_max*1000))

function B = betaMaas1(a,r) %refer to Maas, pdf page 98
B = (1 + 0.2*(1 - a/(r + a)) + 0.3*(1 - a/(a + r))^6) * (2.243 - 2.64*(a/(r + a)) + 1.352*(a/(a + r))^2 - 2.48*(a/(a + r))^3);
end

function B = betaMaas2(a,r)
B = 0.5*(3-(a/(r + a))) * (1 + 1.243*(1-a/(a+r))^3);
end

function B = betaWOW(a, Rl, Rm, Rr, d)
xl = d + Rm + a;     % Distance from center of left hole to crack tip
xr = d - (Rm + a);   % Distance from center of right hole to crack tip
dk_l = 0.5 * (Rl ./ xl).^2 + 1.5 * (Rl ./ xl).^4;
dk_r = 0.5 * (Rr ./ xr).^2 + 1.5 * (Rr ./ xr).^4;
x = a ./ (Rm + a);
k1 = (1.0 + 0.2*(1.0-x) + 0.3*(1.0-x).^6) .* (2.243 - 2.64*x + 1.352*x.^2 - 0.248*x.^3);
B = k1 + dk_l + dk_r;
end

function B = betaEdgeCrackNearHoleRc04(a)
B = 61.715*a^6 - 145*a^5 + 126.54*a^4 - 51.923*a^3 + 9.5315*a^2 - 0.4923*a + 1.1207;
end

function B = betaEdgeCrackNearHoleRc02(a)
B = 3e13*a.^6 - 5e11*a.^5 + 4e9*a.^4 - 1e7*a.^3 + 13934*a.^2 + 0.6616*a + 1.02;
end