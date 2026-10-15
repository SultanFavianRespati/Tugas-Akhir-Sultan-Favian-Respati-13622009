season = ["spring" "summer" "fall" "winter"];

for ii = 1:numel(season)
path = "C:\Users\Sultan F. Respati\Documents\00. TA\Datas\Meteorological\" + season(ii) + "\saved_" + season(ii) + "_hdotdot_patched_az_outliers.parquet";
az = table2array(parquetread(path)); % obtain certain data from season dataset
flight_hours = height(az)/(16*3600); % calculate flight hours by multiplying amount of data with sample rate then convert to hours unit of time

counts = height(rainflow(az));

fprintf("Season : %s\n", season(ii))
fprintf("Total season flight hours within the dataset = %3.f hours\n", flight_hours)
fprintf("Total season vertical acceleration cycles = %0.f cycles\n", counts)
fprintf("Season vertical acceleration cycle per hour = %3.f cycle/hour\n\n", counts/flight_hours)

end