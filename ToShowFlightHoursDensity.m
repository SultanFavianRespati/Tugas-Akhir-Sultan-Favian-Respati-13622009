clc; clear; close all
season = ["spring" "summer" "fall" "winter" "full_true" "fulldata"];
% N = [2.017e9 2.305e9 3.249e9 1.845e9 2.278e9 2.139e9];

for kk = 1:numel(season)
    path = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\crackgrowth_cyclepair_input\saved_" + season(kk) + "_rainflow_azmps2_randomized_cycle_pair_RNG136.parquet";

    az = table2array(parquetread(path)); %obtain certain data from season dataset

    flight_hours = height(az)/(16*3600); %calculate flight hours by multiplying amount of data with sample rate then convert to hours unit of time

    clear az

    cycle = table2array(parquetread(path)); %obtain certain data from season dataset

    load("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\crackgrowthloop_results\crackgrowthloop_" + season(kk) + ".mat")
    N = N4plot(end);

    cycle_amount = height(cycle);

    clear cycle

    cycle_density = cycle_amount/flight_hours;

    if season(kk) == "full_true"
        fprintf("Season : %s\n", "Keseluruhan")
    elseif season(kk) == "fulldata"
        fprintf("Season : %s\n", "Keseluruhan (Acak)")
    else
        fprintf("Season : %s\n", season(kk))
    end

    fprintf("Total season flight hours within the dataset = %3.f hours\n", flight_hours)
    fprintf("Vertical acceleration cycle counted through Rainflow Counting = %.0f cycle\n", cycle_amount)
    fprintf("Cycle density = %.0f cycles per hour\n", cycle_density)
    fprintf("Equivalent flight hours = %.0f hour\n\n", N/cycle_density)
end