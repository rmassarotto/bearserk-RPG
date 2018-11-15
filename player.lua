Player = {}
Player.__index = Player

function Player.new (x, y)
    local self = setmetatable({},Player)
    self.x = x
    self.y = y
    return self
end
