clc; clear; close all;

cs = cumsum(occurence);
cycle = cell(cumex(end), 1);

while any(occurence ~= 0)
    rando = randi(numel(range));
    if occurence(ii) ~= 0
        cycle{ii} = [range_top(ii); range_bot(ii)];
        occurence = occurence - 1;
        ii = ii + 1;
    end
end

cycle = vertcat(cycle{:});

%%

clc; clear; close all
tb = tbfun;
range_top = tb.range_top;
range_bot = tb.range_bot;
range = tb.range;
occurence = tb.occurence;

dataset = cell(numel(occurence),1);

for ii = 1:numel(occurence)
    dataset{ii} = [ones(occurence(ii),1)*range_top(ii) ones(occurence(ii),1)*range_bot(ii) ones(occurence(ii),1)*range(ii) ones(occurence(ii),1)*occurence(ii)];
end

dataset = vertcat(dataset{:});
dataset = array2table(dataset, "VariableNames", ["range_top" "range_bot" "range" "occurence"]);

rando = randperm(numel(dataset.occurence));

datarand = dataset(rando, :);

randomizedloadhistory = cell(numel(datarand.occurence)+2,1);
randomizedloadhistory{1} = 0; randomizedloadhistory{end} = 0;

for ii = 1:numel(datarand.occurence)
    randomizedloadhistory{ii+1} = [datarand.range_top(ii); datarand.range_bot(ii)];
end

randomizedloadhistory = vertcat(randomizedloadhistory{:});

plot(randomizedloadhistory)


































function tb = tbfun
tb = array2table([3,-2.500000000000000,5.500000000000000,1;1.500000000000000,-1.500000000000000,3,4;1.500000000000000,-1,2.500000000000000,6;1,-1,2,8;1,-0.500000000000000,1.500000000000000,13;0.500000000000000,-0.500000000000000,1,56;0.500000000000000,0.050000000000000,0.450000000000000,6;0.050000000000000,0.050000000000000,0,768], "VariableNames", ["range_top" "range_bot" "range" "occurence"]);
end