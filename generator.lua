local spriteManager = require "spriteManager"
local sprite        = require "classes.sprite"
local vector2       = require "classes.vector2"
local util          = require "classes.util"
local noise         = require "lib.noise"
local waterNoiseMap = require "noisemaps.waterNoiseMap"
local sandNoiseMap  = require "noisemaps.sandNoiseMap"


local generator = {}

local blockSizeFactor = 2.5
local gridSize = 32 * blockSizeFactor

local mapsizeX = 45
local mapsizeY = 22

local startX = -1
local startY = -20


math.randomseed(os.time())
_G.SEED = math.random(0, 10000)

generator.blockData = {
    water = {
        name = "water",
        image = "sprites/waterSprite.png",
        hasGrid = false,
    },
    sand = {
        name = "sand",
        image = "sprites/sandSprite.png",
        hasGrid = true,
    },
    grass = {
        name = "grass",
        image = "sprites/grassSprite.png",
        hasGrid = true
    }
}

function generator.blockDataFromPos(x, y)
    if waterNoiseMap(x,y) then return generator.blockData.water end

    if sandNoiseMap(x,y) then return generator.blockData.sand end
    
    return generator.blockData.grass
end

function generator.generate()
    for x = startX, mapsizeX, 1 do
        for y = startY, mapsizeY, 1 do
            local blockData = generator.blockDataFromPos(x, y)

            local block = sprite.new(blockData.image)
            block.pos = util.getIsoPosFromGridPos(x, y, gridSize) + (blockData == generator.blockData.water and vector2.new(0, 15) or 0)
            block.scale = blockSizeFactor

            spriteManager.add(block, "blocks")

            if (blockData.hasGrid) then
                local gridItem = sprite.new("sprites/gridSprite.png")
                gridItem.pos = block.pos
                gridItem.scale = blockSizeFactor
    
                spriteManager.add(gridItem, "grids")
            end
        end
    end
end

return generator