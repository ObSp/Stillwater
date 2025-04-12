local spriteManager = require "spriteManager"
local sprite        = require "classes.sprite"
local vector2       = require "classes.vector2"
local util          = require "classes.util"
local noise         = require "lib.noise"
local waterNoiseMap = require "noisemaps.waterNoiseMap"
local sandNoiseMap  = require "noisemaps.sandNoiseMap"
local treeNoiseMap  = require "noisemaps.treeNoiseMap"
local bushNoiseMap  = require "noisemaps.bushNoiseMap"


local generator = {}

local blockSizeFactor = 2

local mapsizeX = 63
local mapsizeY = 34

local startX = -1
local startY = -30

local xIsoSize = 32
local yIsoSize = 16

local gridSize = xIsoSize * blockSizeFactor

local globalShadowRot = math.rad(-115)

math.randomseed(os.time())
_G.SEED = math.random(0, 10000)

generator.blockGrid = {}

generator.isoSize = vector2.new(xIsoSize, yIsoSize)
generator.blockSizeFactor = blockSizeFactor
generator.gridSize = gridSize

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
                rawOffset = (vector2.new(0, 62) * blockSizeFactor) -vector2.new(0, (yIsoSize * blockSizeFactor)/2),
                hasShadow = true,
                shadowImage = "sprites/treeShadowSprite.png"
            },
            {
                name = "bush",
                noiseMap = bushNoiseMap,
                image = "sprites/bushSprite.png",
                rawOffset = vector2.new(0, yIsoSize * blockSizeFactor),
                hasShadow = false,
                shadowImage = "sprites/treeShadowSprite.png"
            },
        }
    }
}

function generator.putSpotInfo(x, y, block)
    if not generator.blockGrid[x] then
        generator.blockGrid[x] = {}
    end

    generator.blockGrid[x][y] = block
end

function generator.getSpotInfo(x, y)
    if not generator.blockGrid[x] then
        return nil
    end

    return generator.blockGrid[x][y]
end

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

            local finalDecorationData = {}

            if blockData.decorations then
                for _, decoration in pairs(blockData.decorations) do
                    if decoration.noiseMap(x, y) then
                        local spr = sprite.new(decoration.image)
                        spr:setScale(blockSizeFactor)
                        spr.pos = block.pos - decoration.rawOffset
  
                        local shadow
                        if decoration.hasShadow then
                            shadow = sprite.new(decoration.shadowImage)
                            shadow.scaleX = spr.scaleX / 1.5
                            shadow.scaleY = spr.scaleY
                            shadow.pos = spr.pos + vector2.new(spr.imageSize.x/2 - (10 * (blockSizeFactor - 1)), spr.imageSize.y) + (32 * (blockSizeFactor - 1))
                            shadow.rot = globalShadowRot
                            shadow.color = {0,0,0,1}
                            shadow.origin = vector2.new(shadow.imageSize.x, shadow.imageSize.y)
                            
                            spriteManager.add(shadow, "decorations")
                        end

                        spriteManager.add(spr, "decorations")
                        finalDecorationData = {
                            dec = spr,
                            shadow = shadow
                        }
                        goto continue
                    end
                end
                ::continue::
            end

            local gridItem
            if (blockData.hasGrid) then
                gridItem = sprite.new("sprites/gridSprite.png")
                gridItem.pos = block.pos
                gridItem:setScale(blockSizeFactor)
    
                spriteManager.add(gridItem, "grids")
            end

            generator.putSpotInfo(x, y, {
                block = block,
                decoration = finalDecorationData.dec,
                decorationShadow = finalDecorationData.shadow,
                gridItem = gridItem
            })
        end
    end
end

return generator