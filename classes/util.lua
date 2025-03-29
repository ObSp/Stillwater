local vector2 = require "classes.vector2"

local util = {}

function util.indexOf(tbl, value)
    for i, v in pairs(tbl) do
        if v == value then return i end
    end
end

local iHat = vector2.new(1, .5)
local jHat = vector2.new(-1, .5)
function util.getIsoPosFromGridPos(x, y, gridSize)
    return (iHat * x + (jHat * y)) * (gridSize/2)
end

return util