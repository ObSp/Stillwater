local vec2 = {}
vec2.__index = vec2
vec2.__newindex = function (t, k, v)
    error("Property "..k.." is read-only.", 2)
end

vec2.__add = function (self, other)
    if type(other) == "number" then
        other = vec2.new(other, other)
    end
    return vec2.new(self.x + other.x, self.y + other.y)
end
vec2.__sub = function (self, other)
    if type(other) == "number" then
        other = vec2.new(other, other)
    end
    return vec2.new(self.x - other.x, self.y - other.y)
end

vec2.__mul = function (self, other)
    if type(other) == "number" then
        other = vec2.new(other, other)
    end
    return vec2.new(self.x * other.x, self.y * other.y)
end
vec2.__div = function (self, other)
    if type(other) == "number" then
        other = vec2.new(other, other)
    end
    return vec2.new(self.x / other.x, self.y / other.y)
end

vec2.__unm = function (self)
    return vec2.new(-self.x, -self.y)
end

vec2.__tostring = function (self)
    return tostring(self.x)..", "..tostring(self.y)
end


function vec2.new(x, y)
    local self = {}

    self.x = x
    self.y = y

    setmetatable(self, vec2)

    return self
end

return {
    zero = vec2.new(0,0),
    new = vec2.new
}