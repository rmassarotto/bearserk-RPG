local sti = require "sti"

function love.load()
  map = sti('maps/map0.lua')
end

function love.update(dt)
  map:update(dt)
end

function love.draw()
  map:draw()
end
