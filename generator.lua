local spriteManager = require "spriteManager"
local sprite        = require "classes.sprite"
local vector2       = require "classes.vector2"
local util          = require "classes.util"
local noise         = require "lib.noise"
local waterNoiseMap = require "noisemaps.waterNoiseMap"
local sandNoiseMap  = require "noisemaps.sandNoiseMap"
local treeNoiseMap  = require "noisemaps.treeNoiseMap"


local generator = {}

local blockSizeFactor = 2
local gridSize = 32 * blockSizeFactor

local mapsizeX = 63
local mapsizeY = 34

local startX = -1
local startY = -30

local xIsoSize = 16
local yIsoSize = 9

local globalShadowRot = math.rad(-115)

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
        hasGrid = true,
        decorations = {
            {
                name = "tree",
                noiseMap = treeNoiseMap,
                image = "sprites/treeSprite.png",
                rawOffset = vector2.new(0, 64),
                hasShadow = true,
                shadowImage = "sprites/treeShadowSprite.png"
            }
        }
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
            block:setScale(blockSizeFactor)

            spriteManager.add(block, "blocks")

            if blockData.decorations then
                for _, decoration in pairs(blockData.decorations) do
                    if decoration.noiseMap(x, y) then
                        local spr = sprite.new(decoration.image)
                        spr:setScale(blockSizeFactor)
                        spr.pos = block.pos - (decoration.rawOffset * blockSizeFactor) + vector2.new(0, yIsoSize * blockSizeFactor)
  
                        if decoration.hasShadow then
                            local shadow = sprite.new(decoration.shadowImage)
                            shadow.scaleX = spr.scaleX / 1.5
                            shadow.scaleY = spr.scaleY
                            shadow.pos = spr.pos + vector2.new(spr.imageSize.x/2 - (10 * (blockSizeFactor - 1)), spr.imageSize.y) + (32 * (blockSizeFactor - 1))
                            shadow.rot = globalShadowRot
                            shadow.color = {0,0,0,1}
                            shadow.origin = vector2.new(shadow.imageSize.x, shadow.imageSize.y)
                            
                            spriteManager.add(shadow, "decorations")
                        end

                        spriteManager.add(spr, "decorations")
                    end
                end
            end

            if (blockData.hasGrid) then
                local gridItem = sprite.new("sprites/gridSprite.png")
                gridItem.pos = block.pos
                gridItem:setScale(blockSizeFactor)
    
                spriteManager.add(gridItem, "grids")
            end
        end
    end
end

return generator