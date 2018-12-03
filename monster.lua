Monster = {}
Monster.__index = Monster


function Monster.new (x, y, attack, defense, health)
    local self = setmetatable({},Monster)
    self.x = x
    self.y = y
    self.name = "Monster"
    self.attack = attack
    self.defense = defense
    self.health = health
    return self
end
