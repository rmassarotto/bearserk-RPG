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
    self.armor = Item.new("Armadura de madeira","Armadura", {["Defesa"] = 0.15}, "Uma armadura élfica de madeira", "gfx/items/initials/initial_armor.png")
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
    self.health = 40
    self.health_max = 100
    self.block = self.shield.caracteristcs["Taxa de bloqueio"]
    self.flee = 0.1
    self.attack = self.weapon.caracteristcs["Ataque"]
    self.defense = self.armor.caracteristcs["Defesa"] + self.helmet.caracteristcs["Defesa"] + self.boots.caracteristcs["Defesa"]
    self.inventory = Inventory.new()
    self.inventory.addItem(self.inventory, Item.new("Poção de cura", "Consumivel", {["Capacidade de cura"] = 20}, "Uma poção mágica capaz de regenerar vida", "gfx/items/consumables/ruby_old.png"))
    self.inventory.addItem(self.inventory, Item.new("Armadura exemplo", "Armadura", {["Defesa"] = 0.4}, "Uma armadura de exemplo", "gfx/items/chain_mail_2.png"))
    self.inventory.addItem(self.inventory, Item.new("Capacete exemplo", "Capacete", {["Defesa"] = 0.2}, "Um capacete para exemplo", "gfx/items/helmet_2_etched.png"))
    self.inventory.addItem(self.inventory, Item.new("Escudo exemplo", "Escudo", {["Taxa de bloqueio"] = 0.5}, "Um escudo de exemplo", "gfx/items/large_shield_3_new.png"))
    self.inventory.addItem(self.inventory, Item.new("Botas exemplo", "Bota", {["Defesa"] = 0.2}, "Botas de exemplo", "gfx/items/boots_iron_2.png"))
    self.inventory.addItem(self.inventory, Item.new("Arma exemplo", "Arma", {["Ataque"] = {30, 40}, ["Acuracia"] = 0.95}, "Uma arma de exemplo", "gfx/items/spwpn_sceptre_of_asmodeus.png"))
    return self
end

function Player.attack_act(self, enemy)
    local player_attack =  math.random(self.weapon.caracteristcs.Ataque[1], self.weapon.caracteristcs.Ataque[2])
    enemy.health = enemy.health - player_attack
    return player_attack
end

function Player.recalculeAttack(self)
    self.attack = self.weapon.caracteristcs.Ataque
end

function Player.recalculeDefense(self)
    self.defense = self.armor.caracteristcs["Defesa"] + self.helmet.caracteristcs["Defesa"] + self.boots.caracteristcs["Defesa"]
end

function Player.recalculeBlockRate(self)
    self.block = self.shield.caracteristcs["Taxa de bloqueio"]
end

function Player.fury(self)
    self.attack[1] = self.attack[1] + (self.attack[1]*0.4)
    self.attack[2] = self.attack[2] + (self.attack[2]*0.4)
    self.defense = self.defense - (self.defense*0.3)
end

function Player.defensive_mode(self)
    self.attack[1] = self.attack[1] - (self.attack[1]*0.3)
    self.attack[2] = self.attack[2] - (self.attack[2]*0.3)
    self.defense = self.defense + (self.defense*0.4)
end