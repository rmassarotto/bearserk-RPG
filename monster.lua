Monster = {}
Monster.__index = Monster


function Monster.new (x, y, name, attack, defense, health, xp)
    local self = setmetatable({},Monster)
    self.x = x
    self.y = y
    self.name = name
    self.attack = attack
    self.defense = defense
    self.health = health
    self.xp = xp
    return self
end

function Monster.attack_act(self, player)
    os.execute("sleep 1")
    local attack = math.random(self.attack[1],self.attack[2])
    attack = attack*(1-player.defense)
    player.health = player.health - attack;
    return attack
end
