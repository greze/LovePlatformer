
local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local player = Class{
  __includes = Entity -- Player class inherits the Entity class
}

function player:init(world, x, y)
  self.img = love.graphics.newImage('assets/character_block.png')
  
  Entity.init(self, world, x, y, self.img:getWidth(), self.img:getHeight())
  
  --Add unique player values
  self.xVelocity = 0 --current velocity on x/y axes
  self.yVelocity = 0
  self.acc = 100, --player acceleration
  self.maxSpeed = 600, --top speed
  self.friction = 20, --slow the player down, toggle for icy or slick platforms
  self.gravity = 80,
  
    --jumping things
  self.isJumping = false, --in the process of jumping?
  self.isGrounded = false, --on the ground?
  self.hasReachedMax = false, --is this how high we can jump?
  self.jumpAcc = 500, --how fast we accelerate up
  self.jumpMaxSpeed = 11, --speed limit while jumping
  
  self.world:add(self, self:getRect())
end

function player:collisionFilter(other)
  local x, y, w, h = self.world:getRect(other)
  local playerBottom = self.y + self.h
  local otherBottom = y + h
  
  if playerBottom <= y then --bottom of player collides with platform
    return 'slide'
  end
end

function player:update(dt)  --basically the update function from part 1, but with self. instead of player.
  local prevX, prevY = self.x, self.y
  
  --apply friction
  self.xVelocity = self.xVelocity * (1 - math.min(dt * self.friction, 1))
  self.yVelocity = self.yVelocity * (1 - math.min(dt * self.friction, 1))
  
  --apply gravity
  self.yVelocity = self.yVelocity + self.gravity * dt
  
    if love.keyboard.isDown("left", "a") and self.xVelocity > -self.maxSpeed then
		self.xVelocity = self.xVelocity - self.acc * dt
	elseif love.keyboard.isDown("right", "d") and self.xVelocity < self.maxSpeed then
		self.xVelocity = self.xVelocity + self.acc * dt
	end
	
  --jump code
  if love.keyboard.isDown("up", "w") then
    if -self.yVelocity < self.jumpMaxSpeed and not self.hasReachedMax then
      self.yVelocity =  self.yVelocity - self.jumpAcc * dt
    elseif math.abs(self.yVelocity) > self.jumpMaxSpeed then
      self.hasReachedMax = true
    end
    
    self.isGrounded = false -- not on the ground anymore
  end
  
    --where the player arrives at
  local goalX = self.x + self.xVelocity
  local goalY = self.y + self.yVelocity
  
    --move the player while testing for collisions
  self.x, self.y, collisions, len = self.world:move(self, goalX, goalY, self.collisionFilter)
  
    --loop through collisions and see if anything important is happening
  for i, coll in ipairs(collisions) do
    if coll.touch.y > goalY then --we touched below (higher location has higher y value)
      self.hasReachedMax = true --this doesn't happen in the demo
      self.isGrounded = false
    elseif coll.normal.y < 0 then
      self.hasReachedMax = false
      self.isGrounded = true
    end
  end
end

function player:draw()
  love.graphics.draw(self.img, self.x, self.y)
end

return player
