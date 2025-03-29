local camera = {}
camera.__index = camera

function camera:getSpritePosition(spriteX, spriteY)
    return self.x + spriteX, self.y + spriteY
end

function camera.new()
    local self = setmetatable({}, camera)

    self.x = 0
    self.y = 0

    return self
end

return camera.new()