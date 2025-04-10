local sprite = require "classes.sprite"
local spriteManager = require "spriteManager"
local camera = require "classes.camera"
local generator = require "generator"
local reader    = require "shaders.reader"
local util      = require "classes.util"
local vector2   = require "classes.vector2"

local shader
local ambiance
local music

function love.load()
    love.window.setTitle("Stillwater")
    love.window.setMode(3,3, {resizable = true})
    love.window.maximize()

    ambiance = love.audio.newSource("sounds/birds.mp3", "stream")
    ambiance:play()

    music = love.audio.newSource("sounds/music.mp3", "stream")
    music:play()

    love.graphics.setBackgroundColor(102/255, 204/255, 255/255)

    --add sprites
    generator.generate()

    _G.camera = camera

    shader = love.graphics.newShader(reader.read_file("shaders/main.glsl"))
end

local selectedBlock
function love.update()
    local x, y = love.mouse.getPosition()
    local isoMousePos = util.getGridPosFromWorldPos(x, y + 20 * (generator.blockSizeFactor - 1), generator.gridSize)

    local block = generator.getSpotInfo(isoMousePos.x, isoMousePos.y)
    if selectedBlock then
        selectedBlock = nil
    end
    if not block then return end
    selectedBlock = block
end


local function sendLightingData()
    shader:send("numLights", 0)
    shader:send("pos", {0,0})
    --shader:send("color", {{1,1,1,1}})
    shader:send("power", .1)
    shader:send("radius", 50)
end

function love.draw()
    love.graphics.setShader(shader)

    sendLightingData()

    love.graphics.setColor(1, 1, 1, 1)
    spriteManager.drawLayer("blocks")

    --transparency
    love.graphics.setColor(1, 1, 1, .08)
    spriteManager.drawLayer("grids")

    love.graphics.setColor(1, 1, 1, 1)
    spriteManager.drawLayer("decorations")
    love.graphics.setShader()

    love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 10, 10)
    love.graphics.print("Seed: "..tostring(SEED), 10, 30)
end

function love.keypressed(k)
    if k == "q" then
        love.event.quit()
    elseif k == "r" then
        love.event.quit("restart")
    elseif k == "f11" then
        love.window.setFullscreen(not love.window.getFullscreen())
    end
end