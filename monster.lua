Monster = {}
Monster.__index = Monster


function Monster.new (x, y, name, attack, defense, health)
    local self = setmetatable({},Monster)
    self.x = x
    self.y = y
    self.name = name
    self.attack = attack
    self.defense = defense
    self.health = health
    return self
end
