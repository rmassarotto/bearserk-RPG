require 'player'
flag = 0
function love.load()
    down = newAnimation(love.graphics.newImage("gfx/down.png"), 32, 32, 0.5)
    up = newAnimation(love.graphics.newImage("gfx/up.png"), 32, 32, 0.5)
    left = newAnimation(love.graphics.newImage("gfx/left.png"), 32, 32, 0.5)
    right = newAnimation(love.graphics.newImage("gfx/right.png"), 32, 32, 0.5)
    world = love.physics.newWorld(0,200,true)
        world:setCallbacks(beginContact, endContact, preSolve, postSolve)
    player = Player.new(0,0)
        player.body = love.physics.newBody(world, 0, 0, "dynamic")
        player.s = love.physics.newPolygonShape(0,0,0,32,32,32,32,0)
        player.f = love.physics.newFixture(player.body, player.s)
        player.f:setUserData("Player")
    ball = {}
       ball.b = love.physics.newBody(world, 400,200, "dynamic")  -- set x,y position (400,200) and let it move and hit other objects ("dynamic")
       ball.b:setMass(10)                                        -- make it pretty light
       ball.s = love.physics.newCircleShape(50)                  -- give it a radius of 50
       ball.f = love.physics.newFixture(ball.b, ball.s)          -- connect body to shape
       ball.f:setRestitution(0.4)                                -- make it bouncy
       ball.f:setUserData("Ball")                                -- give it a name, which we'll access later
   static = {}
       static.b = love.physics.newBody(world, 400,400, "static") -- "static" makes it not move
       static.s = love.physics.newRectangleShape(200,50)         -- set size to 200,50 (x,y)
       static.f = love.physics.newFixture(static.b, static.s)
       static.f:setUserData("Block")
end

function love.update(dt)
    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        flag=0
        down.currentTime = down.currentTime + dt
        player.y = player.y + 0.2
        if down.currentTime >= down.duration then
            down.currentTime = down.currentTime - down.duration
        end
    elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        flag=2
        right.currentTime = right.currentTime + dt
        player.x = player.x + 0.2
        if right.currentTime >= right.duration then
            right.currentTime = right.currentTime - right.duration
        end
    elseif love.keyboard.isDown("w") or love.keyboard.isDown("up") then
        flag=4
        up.currentTime = up.currentTime + dt
        player.y = player.y - 0.2
        if up.currentTime >= up.duration then
            up.currentTime = up.currentTime - up.duration
        end
    elseif love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        flag=6
        left.currentTime = left.currentTime + dt
        player.x = player.x - 0.2
        if left.currentTime >= left.duration then
            left.currentTime = left.currentTime - left.duration
        end
    end
    player.body:setPosition(player.x, player.y)
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
    -- elseif love.keyreleased("s") or love.keyreleased("down") then
    --     print("Ola")
    world:update(dt)
end

function love.draw()
    local spriteNum = nil
    if flag == 0 then
        spriteNum= math.floor(down.currentTime / down.duration * #down.quads) + 1
        love.graphics.draw(down.spriteSheet, down.quads[spriteNum], player.x, player.y,0, 1)
    elseif flag == 1 then
        love.graphics.draw(down.spriteSheet, down.quads[2], player.x, player.y,0, 1)
    elseif flag == 2 then
        spriteNum= math.floor(right.currentTime / right.duration * #right.quads) + 1
        love.graphics.draw(right.spriteSheet, right.quads[spriteNum], player.x, player.y,0, 1)
    elseif flag == 3 then
        love.graphics.draw(right.spriteSheet, right.quads[2], player.x, player.y,0, 1)
    elseif flag == 4 then
        spriteNum= math.floor(up.currentTime / up.duration * #up.quads) + 1
        love.graphics.draw(up.spriteSheet, up.quads[spriteNum], player.x, player.y,0, 1)
    elseif flag == 5 then
        love.graphics.draw(up.spriteSheet, up.quads[2], player.x, player.y,0, 1)
    elseif flag == 6 then
        spriteNum= math.floor(left.currentTime / left.duration * #left.quads) + 1
        love.graphics.draw(left.spriteSheet, left.quads[spriteNum], player.x, player.y,0, 1)
    elseif flag == 7 then
        love.graphics.draw(left.spriteSheet, left.quads[2], player.x, player.y,0, 1)
    end
    love.graphics.circle("line", ball.b:getX(),ball.b:getY(), ball.s:getRadius(), 20)
    love.graphics.polygon("line", static.b:getWorldPoints(static.s:getPoints()))
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
