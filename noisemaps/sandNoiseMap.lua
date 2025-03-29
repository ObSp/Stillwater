local noise = require "lib.noise"

local resolution = 25;

return function(x, y)
    local value = (noise:noise(x/resolution, y/resolution, SEED/resolution) + 1)/2;

    return value > .68;
end