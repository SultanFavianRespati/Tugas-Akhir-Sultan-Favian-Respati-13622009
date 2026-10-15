clc
cycle = [1.661e9 1.898e9 2.740e9 1.482e9];
season = ["spring" "summer" "fall" "winter"];
cycledensity = [5639 5696 5432 5565];
hourtime = cycle./cycledensity;
yeartime = hourtime/8760;

for ii = 1:numel(yeartime)
    fprintf("%s equivalent crack growth life = %.3f\n", season(ii), yeartime(ii))
end