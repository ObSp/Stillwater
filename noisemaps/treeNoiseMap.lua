local noise = require "lib.noise"

local resolution = 15;
local amplitude = 10;

local spreadResolution = 1.5;
    
return function(x, y) 
    local value = (noise:noise(x/resolution, SEED/resolution, y/resolution) * amplitude)/2*amplitude;

    if not (value > .68) then return false end

    local spreadValue = (noise:noise(x/spreadResolution, SEED/spreadResolution, y/spreadResolution) + 1)/2;

    return spreadValue > .7;
end