local sprite = require "classes.sprite"
local spriteManager = require "spriteManager"
local camera = require "classes.camera"
local generator = require "generator"

local shader

function love.load()
    love.window.setTitle("Stillwater")
    love.window.setMode(3,3, {resizable = true})
    love.window.maximize()


    love.graphics.setBackgroundColor(102/255, 204/255, 255/255)

    --add sprites
    generator.generate()

    _G.camera = camera

    shader = love.graphics.newShader[[
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
        vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
        return pixel * color;
    }

    ]]
end

function love.update()
    
end

function love.draw()
    love.graphics.setShader(shader)
    love.graphics.setColor(1, 1, 1, 1)
    spriteManager.drawLayer("blocks")

    --transparency
    love.graphics.setColor(1, 1, 1, .08)
    spriteManager.drawLayer("grids")
    love.graphics.setShader()
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