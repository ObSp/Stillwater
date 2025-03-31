local vector2 = require "classes.vector2"
local sprite = {}
sprite.__index = sprite

function sprite:draw()
    local x,y = camera:getSpritePosition(self.pos.x, self.pos.y)

    local r,g,b,a
    if self.color then
        r,g,b,a= love.graphics.getColor()
        love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.color[4])
    end

    love.graphics.draw(self.image, x, y, self.rot, self.scaleX, self.scaleY, self.origin.x, self.origin.y)
    if r then love.graphics.setColor(r,g,b,a) end
end

function sprite:setScale(scale)
    self.scaleX = scale
    self.scaleY = scale
end

function sprite.new(image)
    local self = setmetatable({}, sprite)

    self.pos = vector2.zero

    self.scaleX = 1
    self.scaleY = 1

    self.image = love.graphics.newImage(image)
    self.image:setFilter("nearest")

    self.rot = 0

    self.origin = vector2.zero

    self.color = nil

    self.imageSize = vector2.new(self.image:getWidth(), self.image:getHeight())

    return self
end

return sprite