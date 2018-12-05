require 'player'
require 'item'
require 'inventory'
require 'monster'
local insp = require 'inspect'

flag = 0
hitbox_offset_y = 25
hitbox_offset_x = 5
movespeed = 170
local sti = require "sti"
local bump = require "sti/bump"
cursor = {x = 1, y = 1,image = love.graphics.newImage("gfx/scenario/cursor.png") }
void_tile = {image=love.graphics.newImage("gfx/scenario/void.png")}
battle_mod = false
actual_enemy = {}
actual_music = 0
battle_music = love.audio.newSource("gfx/musics/bensound-epic.mp3")

function love.load(mapParam)
    world = bump.newWorld(32)
    if(type(mapParam) == "table") then
        mapParam = "maps/map0.lua"
    end
    currentMap = mapParam
    if(currentMap == "maps/map0.lua") then
        local music = love.audio.newSource("gfx/musics/Epic-battle-music-grzegorz-majcherczyk-heroica.mp3")
        music:play()
        actual_music = music
    elseif(currentMap == "maps/map1-1.lua") then
        actual_music:pause()
        local music = love.audio.newSource("gfx/musics/101 - music 01.mp3")
        music:play()
        actual_music = music
    end
        
    actual_map=mapParam
    map = sti(mapParam, {"bump"})
    map:bump_init(world)
    down = newAnimation(love.graphics.newImage("gfx/player_sprites/down.png"), 32, 32, 0.3)
    up = newAnimation(love.graphics.newImage("gfx/player_sprites/up.png"), 32, 32, 0.3)
    left = newAnimation(love.graphics.newImage("gfx/player_sprites/left.png"), 32, 32, 0.3)
    right = newAnimation(love.graphics.newImage("gfx/player_sprites/right.png"), 32, 32, 0.3)
    local layer = map:addCustomLayer("Sprites", 4)
    player = Player.new(50,300)
    world:add(player, player.x, player.y, 23, 7)
    loadItems()
    cursor_layer = map:addCustomLayer("Cursor", 5)
    box_layer = map:addCustomLayer("box", 6)
    layer.draw = function(self)
        local spriteNum = nil
        if flag == 0 then
            spriteNum= math.floor(down.currentTime / down.duration * #down.quads) + 1
            love.graphics.draw(down.spriteSheet, down.quads[spriteNum], player.x, player.y-hitbox_offset_y,0, 1)
        elseif flag == 1 then
            love.graphics.draw(down.spriteSheet, down.quads[2], player.x, player.y-hitbox_offset_y,0, 1)
        elseif flag == 2 then
            spriteNum= math.floor(right.currentTime / right.duration * #right.quads) + 1
            love.graphics.draw(right.spriteSheet, right.quads[spriteNum], player.x, player.y-hitbox_offset_y,0, 1)
        elseif flag == 3 then
            love.graphics.draw(right.spriteSheet, right.quads[2], player.x, player.y-hitbox_offset_y,0, 1)
        elseif flag == 4 then
            spriteNum= math.floor(up.currentTime / up.duration * #up.quads) + 1
            love.graphics.draw(up.spriteSheet, up.quads[spriteNum], player.x, player.y-hitbox_offset_y,0, 1)
        elseif flag == 5 then
            love.graphics.draw(up.spriteSheet, up.quads[2], player.x, player.y-hitbox_offset_y,0, 1)
        elseif flag == 6 then
            spriteNum= math.floor(left.currentTime / left.duration * #left.quads) + 1
            love.graphics.draw(left.spriteSheet, left.quads[spriteNum], player.x, player.y-hitbox_offset_y,0, 1)
        elseif flag == 7 then
            love.graphics.draw(left.spriteSheet, left.quads[2], player.x, player.y-hitbox_offset_y,0, 1)
        end
    end
end

function love.update(dt)
    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        flag=0
        down.currentTime = down.currentTime + dt
        player.y = player.y + movespeed*dt
        if down.currentTime >= down.duration then
            down.currentTime = down.currentTime - down.duration
        end
    elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        flag=2
        right.currentTime = right.currentTime + dt
        player.x = player.x + movespeed*dt
        if right.currentTime >= right.duration then
            right.currentTime = right.currentTime - right.duration
        end
    elseif love.keyboard.isDown("w") or love.keyboard.isDown("up") then
        flag=4
        up.currentTime = up.currentTime + dt
        player.y = player.y - movespeed*dt
        if up.currentTime >= up.duration then
            up.currentTime = up.currentTime - up.duration
        end
    elseif love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        flag=6
        left.currentTime = left.currentTime + dt
        player.x = player.x - movespeed*dt
        if left.currentTime >= left.duration then
            left.currentTime = left.currentTime - left.duration
        end
    end

--COLISOES
    local cols
    player.x, player.y, cols, len = world:move(player,player.x, player.y)
    for i=1,len do
        local col = cols[i]
        if(col.other.name == "gate") then
            love.load("maps/map1-1.lua")
            currentMap = "map1-1"
        elseif (col.other.name == "mermaid") and battle_mod == false then
            Battle = map:addCustomLayer("Battle", 8)
            Battle.draw = function(self)
                map = sti("maps/battle_mermaid.lua", {"bump"})
                battle_mod = true
                actual_enemy = Monster.new(0,0,"Mermaid", {10,15}, 0.2, 30, 30)
                actual_music:pause()
                battle_music:play()
                drawPlayerInformations()
            end
        elseif (col.other.name == "troll") and battle_mod == false then
            Battle = map:addCustomLayer("Battle", 8)
            Battle.draw = function(self)
                map = sti("maps/battle_troll.lua", {"bump"})
                battle_mod = true
                actual_enemy = Monster.new(0,0,"Troll", {20,25}, 0.3, 40, 50)
                actual_music:pause()
                battle_music:play()
                drawPlayerInformations()
            end
        end
        -- if(col.other.name == "gate2") then
        --     love.load("maps/map3.lua")
        --     currentMap = "map3"
        -- end
        -- if(col.other.name == "gate3") then
        --     love.load("maps/map4.lua")
        --     currentMap = "map4"
        -- end
        -- if(col.other.name == "Item") then
        --   print(col.other.name)
        -- end
    end
    
    function love.keyreleased (key)
        if key == "f" and battle_mod == true then
        player.fury(player)
        print("Inimigo atacou e deu "..actual_enemy.attack_act(actual_enemy, player) .. " de dano")
        isBattleEnd()

    elseif key == "d" and battle_mod == true then
        player.defensive_mode(player)
        print("Inimigo atacou e deu "..actual_enemy.attack_act(actual_enemy, player) .. " de dano")
        isBattleEnd()

        elseif key == "s" or key=="down" then
            flag=1
        elseif key == "d" or key=="right" then
            flag=3
        elseif key == "w" or key=="up" then
            flag=5
        elseif key == "a" and battle_mod == true then
            print("Player atacou e deu " ..player.attack_act(player, actual_enemy) .." de dano")
            if(isBattleEnd() ~= 1) then
                print("Inimigo atacou e deu "..actual_enemy.attack_act(actual_enemy, player) .. " de dano")
            end
            isBattleEnd()
            
        elseif key == "a" or key=="left" then
            flag=7
        end
    end

    function love.keypressed(key)
        if key == "j" then
            if(cursor.x > 1) then
                cursor.x=cursor.x-1
            end

        elseif key == "i" then
            if(cursor.y > 1) then
                cursor.y = cursor.y-1
            end

        elseif key == "k" then
            if(cursor.y < 3) then
                cursor.y=cursor.y+1
            end

        elseif key == "l" then
            if(cursor.x < 5) then
                cursor.x=cursor.x+1
            end

        elseif key == "e" then
            utilize_item()
        end

    end
    map:update(dt)
end

function startBattle()
    local battle = map:addCustomLayer("Battle",8)
end

function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end


function utilize_item (args)
    local index = (cursor.y-1) *5 + (cursor.x)
    if player.inventory.items[index] ~= 0 then
        if player.inventory.items[index].Nome == "Poção de cura" then
            if player.health < (player.health_max - 20) then
                player.health = player.health + 20
            else
                player.health = player.health_max
            end
            Inventory.removeItem(player.inventory, index)

        elseif player.inventory.items[index].Tipo == "Arma" then
            Item.swapItemLocations(player.weapon, player.inventory.items[index])
            local aux_to_swap = shallowcopy(player.inventory.items[index])
            player.inventory.removeItem(player.inventory, index)
            player.inventory.addItem(player.inventory, player.weapon)
            player.weapon = aux_to_swap
            player.recalculeAttack(player)

        elseif player.inventory.items[index].Tipo == "Armadura" then
            Item.swapItemLocations(player.armor, player.inventory.items[index])
            local aux_to_swap = shallowcopy(player.inventory.items[index])
            player.inventory.removeItem(player.inventory, index)
            player.inventory.addItem(player.inventory, player.armor)
            player.armor = aux_to_swap
            player.recalculeDefense(player)
            

        elseif player.inventory.items[index].Tipo == "Bota" then
            Item.swapItemLocations(player.boots, player.inventory.items[index])
            local aux_to_swap = shallowcopy(player.inventory.items[index])
            player.inventory.removeItem(player.inventory, index)
            player.inventory.addItem(player.inventory, player.boots)
            player.boots = aux_to_swap
            player.recalculeDefense(player)
            
        elseif player.inventory.items[index].Tipo == "Capacete" then
            Item.swapItemLocations(player.helmet, player.inventory.items[index])
            local aux_to_swap = shallowcopy(player.inventory.items[index])
            player.inventory.removeItem(player.inventory, index)
            player.inventory.addItem(player.inventory, player.helmet)
            player.helmet = aux_to_swap
            player.recalculeDefense(player)
            
        elseif player.inventory.items[index].Tipo == "Escudo" then
            Item.swapItemLocations(player.shield, player.inventory.items[index])
            local aux_to_swap = shallowcopy(player.inventory.items[index])
            player.inventory.removeItem(player.inventory, index)
            player.inventory.addItem(player.inventory, player.shield)
            player.shield = aux_to_swap
            player.recalculeBlockRate(player)
        end
    end
end


function newMonster(sprite, position_X, position_Y)
  monster = Monster.new(position_X, position_Y, 10, 10, 100)
  world:add(monster, monster.x, monster.y, 27, 55)
  love.graphics.draw(monsterSprite, position_X, position_Y)
end

function love.draw()
    map:draw()
    map:bump_draw(world)
    drawCursor(cursor.x, cursor.y)
    showItemInformations()
    drawPlayerInformations();
end

function drawPlayerInformations()
    love.graphics.printf("Vida:".. player.health.."/"..player.health_max, 1180, 600,300)
    love.graphics.printf("Ataque:"..player.attack[1] .. "-" ..player.attack[2],1180, 620, 300)
    love.graphics.printf("Defesa:"..player.defense ,1180, 640, 300)
    love.graphics.printf("Acuracia:"..player.weapon.caracteristcs.Acuracia ,1180, 660, 300)
    love.graphics.printf("Taxa de bloqueio:"..player.shield.caracteristcs["Taxa de bloqueio"] ,1180, 680, 300)
    love.graphics.printf("Esquiva:"..player.flee ,1180, 700, 300)
end

function newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0
    return animation
end

function loadItems()
    local layer = map:addCustomLayer("Items", 4)
    layer.draw = function(self)
        player_weapon_img = love.graphics.newImage(player.weapon.path)
        love.graphics.draw(player_weapon_img, player.weapon.x, player.weapon.y)
        player_armor_img = love.graphics.newImage(player.armor.path)
        love.graphics.draw(player_armor_img, player.armor.x, player.armor.y)
        player_shield_img = love.graphics.newImage(player.shield.path)
        love.graphics.draw(player_shield_img, player.shield.x, player.shield.y)
        player_helmet_img = love.graphics.newImage(player.helmet.path)
        love.graphics.draw(player_helmet_img, player.helmet.x, player.helmet.y)
        player_boots_img = love.graphics.newImage(player.boots.path)
        love.graphics.draw(player_boots_img, player.boots.x, player.boots.y)
        iterator = 0
        for i=1,15 do
            if player.inventory.items[i] ~= 0 then
                local item_image = love.graphics.newImage(player.inventory.items[i].path)
                love.graphics.draw(item_image, player.inventory.items[i].x, player.inventory.items[i].y)
            end
        end
    end
end

function drawCursor (posix, posiy)
    cursor_layer.draw = function(self)
        love.graphics.draw(cursor.image, 352+(posix*32), 576+ (posiy*32))
    end
end

function showItemInformations ()
    local index = (cursor.y-1) *5 + (cursor.x)
    if player.inventory.items[index] ~= 0 then
        box_layer.draw = function(self)
            if player.inventory.items[index] ~= 0 then
                local item_image = love.graphics.newImage(player.inventory.items[index].path)
                love.graphics.push()
                love.graphics.scale(4,4)
                love.graphics.draw(item_image, 565/4, 580/4)
                love.graphics.pop()
                local iterator = 0
                for key,value in pairs(player.inventory.items[index]) do
                    if key ~= "path" and key ~= "caracteristcs" and key ~="x" and key ~= "y" and key ~= "name" then
                        local text = key .. ": " .. value
                        love.graphics.printf(text,680, 580+iterator,500)
                        iterator= iterator + 25
                    end
                end
                for key,value in pairs(player.inventory.items[index].caracteristcs) do
                    local text = ""
                    if key == "Ataque" then
                        text = key .. ": " .. value[1] .. "-" .. value[2]
                    else
                        text = key .. ": " .. value
                    end
                    love.graphics.printf(text,680, 580+iterator,500)
                    iterator= iterator + 25
                end
            end
        end
    else
        box_layer.draw = function(self)
            love.graphics.draw(void_tile.image, 565, 580)
        end

    end
end

function isBattleEnd()
    if (battle_mod == true) then
        if(player.health <= 0) then
            print("Player morreu, fim de jogo")
            battle_music:stop()
            actual_music:play()
            return 1
        end
        
        if(actual_enemy.health <= 0) then
            print("Inimigo morreu, fecha tela de batalha")
            battle_music:stop()
            actual_music:play()
            print("XP antes = ".. player.xp)
            player.xp = player.xp + actual_enemy.xp
            print("XP depois = " .. player.xp)
            battle_mod = false
            return 1
        end
    end
    return 0
end
