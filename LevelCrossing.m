clc; clear all; close all;

% Define the test data
data = [-0.8, 1.3, 0.7, 3.4, 0.7, 2.5, -1.4, -0.5, -2.3, ...
    -2.2, -2.6, -2.4, -3.3, 1.5, 0.6, 3.4, -0.5];

% Run the function
rst = astmLevelCrossingCounting(data);

% Display results
disp('Level | Counts');
disp(rst);

function rst = astmLevelCrossingCounting(data, refLevel, levels, aggregate)
% astmLevelCrossingCounting - ASTM level crossing counting in E1049-85: sec 5.1.1.
%
% Parameters:
%   data      : 1d numeric array, Load sequence data for counting.
%   refLevel  : scalar, optional (default: 0.0). Reference level.
%   levels    : 1d numeric array, optional. Self-defined levels for counting.
%   aggregate : boolean, optional (default: true). 
%               If false, the original sequence for internal counting is returned.
%
% Returns:
%   rst : Nx2 numeric matrix containing [Level, Count] (if aggregate=true)
%         or a 1D array of crossing levels (if aggregate=false).

    %% 1. Handle Optional Arguments
    if nargin < 2 || isempty(refLevel)
        refLevel = 0.0;
    end
    if nargin < 3
        levels = [];
    end
    if nargin < 4 || isempty(aggregate)
        aggregate = true;
    end

    %% 2. Edge Case Check
    data = data(:)'; % Ensure row vector
    if length(data) <= 1
        error('Input data length should be at least 2');
    end

    % Generate levels if not provided
    if isempty(levels)
        minElement = floor(min(data));
        maxElement = ceil(max(data));
        levels = minElement:1:maxElement; % Equivalent to np.linspace(min, max, num)
    else
        levels = sort(unique(levels)); % Ensure sorted and unique
    end

    %% 3. Filter Sequence (Remove intermediate points between peaks and valleys)
    data = sequencePeakValleyFilter(data);

    %% 4. Counting Logic
    counts = zeros(size(levels));
    rstSeq = [];

    % Check each interval from small to large value
    for i = 1:(length(data) - 1)
        intervalStart = data(i);
        intervalEnd = data(i+1);
        
        lowerVal = min(intervalStart, intervalEnd);
        upperVal = max(intervalStart, intervalEnd);
        
        % Find which levels fall into this interval
        % Python's searchsorted logic: 
        % 1st interval includes lower bound. Subsequent intervals strictly > lower bound.
        if i == 1
            valid_idx = find(levels >= lowerVal & levels <= upperVal);
        else
            valid_idx = find(levels > lowerVal & levels <= upperVal);
        end
        
        % Evaluate crossing conditions against refLevel
        for k = 1:length(valid_idx)
            j = valid_idx(k);
            L = levels(j);
            
            % E1049 Rules:
            % If interval is rising and level >= refLevel
            % If interval is falling and level < refLevel
            if (intervalStart <= intervalEnd && L >= refLevel) || ...
               (intervalStart > intervalEnd && L < refLevel)
                
                counts(j) = counts(j) + 1;
                rstSeq(end+1) = L; %#ok<AGROW>
            end
        end
    end

    %% 5. Format Output
    if aggregate
        % Only keep levels that actually have counts
        has_count = counts > 0;
        if ~any(has_count)
            rst = [];
        else
            % Return Nx2 matrix: [Levels, Counts]
            rst = [levels(has_count)', counts(has_count)'];
        end
    else
        % Return sequence column vector
        rst = rstSeq'; 
    end
end

%% Helper Function: Sequence Peak/Valley Filter
% Replicates `ffpack.utils.sequenceFilter.sequencePeakValleyFilter`
function out = sequencePeakValleyFilter(data)
    % Remove consecutive identical values (flat lines)
    d1 = diff(data);
    data([d1 == 0, false]) = [];
    
    if length(data) <= 2
        out = data;
        return;
    end
    
    % Find turning points: where the slope changes sign
    d2 = diff(data);
    isTurning = d2(1:end-1) .* d2(2:end) < 0;
    
    % Keep the first point, the turning points, and the last point (keepEnds=True)
    out = data([true, isTurning, true]);
end