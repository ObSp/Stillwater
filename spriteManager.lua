local util = require "classes.util"

local manager = {}
manager.layers = {}

function manager.getOrCreateLayerTable(layerName)
    if not manager.layers[layerName] then
        manager.layers[layerName] = {}
    end

    return manager.layers[layerName]
end

function manager.getLayerSprites(layerName)
    return manager.layers[layerName]
end

function manager.add(sprite, layerName)
    table.insert(manager.getOrCreateLayerTable(layerName), sprite)
end

function manager.drawLayer(layerName)
    for _, v in pairs(manager.getLayerSprites(layerName)) do
        v:draw()
    end
end

function manager.remove(sprite, layerName)
    local layerTbl = manager.getLayerSprites(layerName)

    if not layerTbl then
        error("[SPRITE MANAGER] - No such layer: "..layerName)
    end

    table.remove(layerTbl, util.indexOf(layerTbl, sprite))
end


return manager;