require 'player'
flag = 0
hitbox_offset_y = 25
hitbox_offset_x = 5
movespeed = 100
local sti = require "sti"
local bump = require "sti/bump"
function love.load()
    world = bump.newWorld(32)
    map = sti("maps/map0.lua", {"bump"})
    map:bump_init(world)
    down = newAnimation(love.graphics.newImage("gfx/down.png"), 32, 32, 0.5)
    up = newAnimation(love.graphics.newImage("gfx/up.png"), 32, 32, 0.5)
    left = newAnimation(love.graphics.newImage("gfx/left.png"), 32, 32, 0.5)
    right = newAnimation(love.graphics.newImage("gfx/right.png"), 32, 32, 0.5)
    local layer = map:addCustomLayer("Sprites", 4)
    player = Player.new(0,275)
    world:add(player, player.x, player.y, 23, 7)
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
    local cols
    player.x, player.y, cols, len = world:move(player,player.x, player.y)
    for i=1,len do
        local col = cols[i]
        print(("Collision with %s."):format(col.other.name))
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
