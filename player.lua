Player = {}
Player.__index = Player

function Player.new (x, y)
    local self = setmetatable({},Player)
    self.x = x
    self.y = y
    self.name = "Player"
    self.attack = {10, 12}
    self.crit = 2
    self.health = 40
    self.block = 0.1
    self.flee = 0.3
    self.defense = 0.3
    self.weapon = "gfx/items/initials/initial_sword.png"
    self.shield = "gfx/items/initials/initial_shield.png"
    self.armor = "gfx/items/initials/initial_armor.png"
    self.helmet = "gfx/items/initials/initial_helmet.png"
    self.boots = "gfx/items/initials/initial_boots.png"
    return self
end
