Player = {}
Player.__index = Player
require 'item'

function Player.new (x, y)
    local self = setmetatable({},Player)
    self.x = x
    self.y = y
    self.name = "Player"
    self.weapon = Item.new("Espada de aço", {["attack"] = {10,12}, ["accuracy"] = 0.9}, "Uma espada simples feita de aço", "gfx/items/initials/initial_sword.png")
    self.shield = Item.new("Escudo de madeira", {["block_rate"] = 0.2}, "Um escudo de madeira gasto", "gfx/items/initials/initial_shield.png")
    self.armor = Item.new("Armadura de madeira", {["defense"] = 0.2}, "Uma armadura élfica de madeira", "gfx/items/initials/initial_armor.png")
    self.helmet = Item.new("Capacete de aço", {["defense"] = 0.1}, "Uma espada simples feita de aço", "gfx/items/initials/initial_helmet.png")
    self.boots = Item.new("Botas de couro", {["defense"] = 0.05}, "Uma bota de couro gasto", "gfx/items/initials/initial_boots.png")
    self.items = {{Item.new("Poção de cura", {["healt_cure"] = 20}, "Uma poção mágica capaz de regenerar vida", "gfx/items/consumables/ruby_old.png"),
    Item.new("Lança", {["attack"] = {8, 14}, ["accuracy"] = 0.8}, "Uma lança com ponta de aço", "gfx/items/spear.png")}}
    self.attack = {self.weapon.caracteristcs["attack"]}
    self.crit = 2
    self.health = 40
    self.block = self.shield.caracteristcs["block_rate"]
    self.flee = 0.3
    self.defense = self.armor.caracteristcs["defense"] + self.helmet.caracteristcs["defense"] + self.boots.caracteristcs["defense"]
    return self
end
