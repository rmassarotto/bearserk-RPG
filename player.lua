Player = {}
Player.__index = Player
require 'item'
require 'inventory'

function Player.new (x, y)
    local self = setmetatable({},Player)
    self.x = x
    self.y = y
    self.name = "Player"
    self.weapon = Item.new("Espada de aço","Arma", {["Ataque"] = {10,12}, ["Acuracia"] = 0.9}, "Uma espada simples feita de aço", "gfx/items/initials/initial_sword.png")
    self.weapon.x = 224
    self.weapon.y = 608
    self.shield = Item.new("Escudo de madeira","Escudo", {["Taxa de bloqueio"] = 0.15}, "Um escudo de madeira gasto", "gfx/items/initials/initial_shield.png")
    self.shield.x = 284
    self.shield.y = 608
    self.armor = Item.new("Armadura de madeira","Peitoral", {["Defesa"] = 0.15}, "Uma armadura élfica de madeira", "gfx/items/initials/initial_armor.png")
    self.armor.x = 256
    self.armor.y = 608
    self.helmet = Item.new("Capacete de aço","Capacete", {["Defesa"] = 0.05}, "Uma espada simples feita de aço", "gfx/items/initials/initial_helmet.png")
    self.helmet.x = 256
    self.helmet.y = 576
    self.boots = Item.new("Botas de couro","Bota", {["Defesa"] = 0.05}, "Uma bota de couro gasto", "gfx/items/initials/initial_boots.png")
    self.boots.x = 256
    self.boots.y = 640
    self.inventory = Inventory.new()
    self.crit = 2
    self.health = 100
    self.health_max = 100
    self.block = self.shield.caracteristcs["Taxa de bloqueio"]
    self.flee = 0.1
    self.defense = self.armor.caracteristcs["Defesa"] + self.helmet.caracteristcs["Defesa"] + self.boots.caracteristcs["Defesa"]
    self.inventory.addItem(self.inventory, Item.new("Poção de cura", "Consumivel", {["Capacidade de cura"] = 20}, "Uma poção mágica capaz de regenerar vida", "gfx/items/consumables/ruby_old.png"))
    self.inventory.addItem(self.inventory, Item.new("Poção de cura", "Consumivel", {["Capacidade de cura"] = 20}, "Uma poção mágica capaz de regenerar vida", "gfx/items/consumables/ruby_old.png"))
    self.inventory.addItem(self.inventory, Item.new("Poção de cura", "Consumivel", {["Capacidade de cura"] = 20}, "Uma poção mágica capaz de regenerar vida", "gfx/items/consumables/ruby_old.png"))
    self.inventory.addItem(self.inventory, Item.new("Lança", "Arma", {["Ataque"] = {8, 14}, ["Acuracia"] = 0.8}, "Uma lança com ponta de aço", "gfx/items/spear.png"))
    return self
end

function Player.attack(self, enemy)
    local player_attack =  math.random(self.weapon.caracteristcs.Ataque[1], self.weapon.caracteristcs.Ataque[2])
    enemy.health = enemy.health - player_attack
    return player_attack
end

