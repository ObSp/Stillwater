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

function util.getGridPosFromWorldPos(xScreen, yScreen, gridSize)
    xScreen = xScreen - (gridSize / 2)
    yScreen = yScreen - (gridSize / 2)

    local factor = 2 / gridSize
    local x = (0.5 * xScreen + yScreen) * factor
    local y = (-0.5 * xScreen + yScreen) * factor

    -- Ensure we round correctly to the tile position
    x = math.floor(x + 0.5)
    y = math.floor(y + 0.5)
    return vector2.new(math.floor(x), math.floor(y))
end

return util