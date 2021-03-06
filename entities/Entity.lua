--Represents a single drawable object
local Class = require 'libs.hump.class'

local Entity = Class{}

--Entities must have a :initialize, :draw, :update
function Entity:init(world, x, y, w, h)
  self.world = world
  self.x = x
  self.y = y
  self.w = w
  self.h = h
end

function Entity:getRect()  --useful for collision detector
  return self.x, self.y, self.w, self.h
end

function Entity:draw()
  -- Do Nothing by default
end

function Entity:update(dt)
  --Do nothing by default
end

return Entity
