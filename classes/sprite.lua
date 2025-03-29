local vector2 = require "classes.vector2"
local sprite = {}
sprite.__index = sprite

function sprite:draw()
    local x,y = camera:getSpritePosition(self.pos.x, self.pos.y)
    love.graphics.draw(self.image, x, y, 0, self.scale)
end

function sprite.new(image)
    local self = setmetatable({}, sprite)

    self.pos = vector2.zero

    self.scale = 1

    self.image = love.graphics.newImage(image)
    self.image:setFilter("nearest")

    return self
end

return sprite