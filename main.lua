require 'player'
local inspect = require ("inspect")
flag = 0
hitbox_offset_y = 25
hitbox_offset_x = 5
movespeed = 170
inventory_state = 0
local sti = require "sti"
local bump = require "sti/bump"


function love.load(mapParam)
    world = bump.newWorld(32)
    if(type(mapParam) == "table") then
        mapParam = "maps/map0.lua"
    end
    actual_map=mapParam
    map = sti(mapParam, {"bump"})
    map:bump_init(world)
    down = newAnimation(love.graphics.newImage("gfx/player_sprites/down.png"), 32, 32, 0.3)
    up = newAnimation(love.graphics.newImage("gfx/player_sprites/up.png"), 32, 32, 0.3)
    left = newAnimation(love.graphics.newImage("gfx/player_sprites/left.png"), 32, 32, 0.3)
    right = newAnimation(love.graphics.newImage("gfx/player_sprites/right.png"), 32, 32, 0.3)
    local layer = map:addCustomLayer("Sprites", 4)
    player = Player.new(0,300)
    world:add(player, player.x, player.y, 23, 7)
    loadItems()
    cursor_layer = map:addCustomLayer("Cursor", 5)
    loadCursorInventory(1,1)
    box_layer = map:addCustomLayer("box", 6)
    showItemInformations(1,1)
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
    elseif love.keyboard.isDown("lalt") and love.keyboard.isDown("1") then
        loadCursorInventory(2,1)
        -- pcall(showItemInformations,2,1)
    elseif love.keyboard.isDown("lalt") and love.keyboard.isDown("2") then
        loadCursorInventory(2,2)
        -- pcall(showItemInformations,2,2)
    elseif love.keyboard.isDown("lalt")  and love.keyboard.isDown("3") then
        loadCursorInventory(2,3)
        -- pcall(showItemInformations,3,2)
    elseif love.keyboard.isDown("lalt") and love.keyboard.isDown("4") then
        loadCursorInventory(2,4)
        -- pcall(showItemInformations,4,2)
    elseif love.keyboard.isDown("lalt") and love.keyboard.isDown("5") then
        loadCursorInventory(2,5)
        -- pcall(showItemInformations,5,2)
    elseif love.keyboard.isDown("lctrl") and love.keyboard.isDown("1") then
        loadCursorInventory(3,1)
        -- pcall(showItemInformations,1,3)
    elseif love.keyboard.isDown("lctrl") and love.keyboard.isDown("2") then
        loadCursorInventory(3,2)
        -- pcall(showItemInformations,2,3)
    elseif love.keyboard.isDown("lctrl") and love.keyboard.isDown("3") then
        loadCursorInventory(3,3)
        -- pcall(showItemInformations,3,3)
    elseif love.keyboard.isDown("lctrl") and love.keyboard.isDown("4") then
        loadCursorInventory(3,4)
        -- pcall(showItemInformations,4,3)
    elseif love.keyboard.isDown("lctrl") and love.keyboard.isDown("5") then
        loadCursorInventory(3,5)
        -- pcall(showItemInformations,5,3)
    elseif love.keyboard.isDown("1") then
        loadCursorInventory(1,1)
        pcall(showItemInformations,1,1)
    elseif love.keyboard.isDown("2") then
        loadCursorInventory(1,2)
        pcall(showItemInformations,1,2)
    elseif love.keyboard.isDown("3") then
        loadCursorInventory(1,3)
        -- pcall(showItemInformations,3,1)
    elseif love.keyboard.isDown("4") then
        loadCursorInventory(1,4)
        -- pcall(showItemInformations,4,1)
    elseif love.keyboard.isDown("5") then
        loadCursorInventory(1,5)
        -- pcall(showItemInformations,5,1)
    end
    local cols
    player.x, player.y, cols, len = world:move(player,player.x, player.y)
    for i=1,len do
        local col = cols[i]
        if(col.other.name == "gate") then
            love.load("maps/map1.lua")
        end
    end
    function love.keyreleased (key)
        if key == "s" or key=="down" then
            flag=1
        elseif key == "d" or key=="right" then
            flag=3
        elseif key == "w" or key=="up" then
            flag=5
        elseif key == "a" or key=="left" then
            flag=7
        end
    end
    map:update(dt)
end

function love.draw()
    map:draw()
    map:bump_draw(world)
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
        love.graphics.draw(player_weapon_img, 224, 608)
        player_armor_img = love.graphics.newImage(player.armor.path)
        love.graphics.draw(player_armor_img, 256, 608)
        player_shield_img = love.graphics.newImage(player.shield.path)
        love.graphics.draw(player_shield_img, 288, 608)
        player_helmet_img = love.graphics.newImage(player.helmet.path)
        love.graphics.draw(player_helmet_img, 256, 576)
        player_boots_img = love.graphics.newImage(player.boots.path)
        love.graphics.draw(player_boots_img, 256, 640)
        iterator = 0
        for i=1,#player.items do
            for j=1,#player.items[i] do
                iterator = iterator+32
                local item_image = love.graphics.newImage(player.items[i][j].path)
                love.graphics.draw(item_image, 352+iterator, 608)
            end
        end
    end
end

function loadCursorInventory(posiy,posix)
    cursor_layer.draw = function(self)
        cursor = love.graphics.newImage("gfx/scenario/cursor.png")
        love.graphics.draw(cursor, 352+(posix*32), 576+ (posiy*32))
    end
end

function showItemInformations (x,y)
    box_layer.draw = function(self)
        local item_image = love.graphics.newImage(player.items[x][y].path)
        love.graphics.push()
            love.graphics.scale(4,4)
            love.graphics.draw(item_image, 565/4, 580/4)
        love.graphics.pop()
        love.graphics.printf("Nome",680, 580,200)
        love.graphics.printf(player.items[x][y].name,680, 595,200)
    end
end
