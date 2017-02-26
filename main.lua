--pull bump library
bump = require 'libs.bump.bump'
world = nil  --storage for bump

ground_0 = {}
ground_1 = {}

-- Setup a player object to hold an image and attach a collision object
player = {
  x = 16,
  y = 16,

  -- rules for basic physics
  xVelocity = 0, --current velocity on x, y axes
  yVelocity = 0,
  acc = 100, --player acceleration
  maxSpeed = 600, --top speed
  friction = 20, --slow the player down, toggle for icy or slick platforms
  gravity = 80,
	
  --jumping things
  isJumping = false, --in the process of jumping?
  isGrounded = false, --on the ground?
  hasReachedMax = false, --is this how high we can jump?
  jumpAcc = 500, --how fast we accelerate up
  jumpMaxSpeed = 11, --speed limit while jumping
	
  --storage area
  img = nil --sprite storage
}

function love.load()

  --setup bump
  world = bump.newWorld(16)  	--16 tile size

  --create player
  player.img = love.graphics.newImage('assets/character_block.png')
	
  world:add(player, player.x, player.y, player.img:getWidth(), player.img:getHeight())
	
  --draw a level
  world:add(ground_0, 120, 360, 640, 16)
  world:add(ground_1, 0, 448, 640, 32)
	
end

function love.update(dt)

  local prevX, prevY = player.x, player.y
	
  --apply friction
  player.xVelocity = player.xVelocity * (1 - math.min(dt * player.friction, 1))
  player.yVelocity = player.yVelocity * (1 - math.min(dt * player.friction, 1))	

  --apply gravity
  player.yVelocity = player.yVelocity + player.gravity * dt
	
	if love.keyboard.isDown("left", "a") and player.xVelocity > -player.maxSpeed then
		player.xVelocity = player.xVelocity - player.acc * dt
	elseif love.keyboard.isDown("right", "d") and player.xVelocity < player.maxSpeed then
		player.xVelocity = player.xVelocity + player.acc * dt
	end
		
  --jump code
  if love.keyboard.isDown("up", "w") then
    if -player.yVelocity < player.jumpMaxSpeed and not player.hasReachedMax then
      player.yVelocity =  player.yVelocity - player.jumpAcc * dt
    elseif math.abs(player.yVelocity) > player.jumpMaxSpeed then
      player.hasReachedMax = true
    end
		
    player.isGrounded = false  --no longer on the ground
  end
	
  --where the player arrives at
  local goalX = player.x + player.xVelocity
  local goalY = player.y + player.yVelocity

  --collision 'filters'
  player.filter = function(item, other)
    local x, y, w, h = world:getRect(other)
    local px, py, pw, ph = world:getRect(item)
    local playerBottom = py + ph
    local otherBottom = y + h

    if playerBottom <= y then --bottom of player collides with platform
      return 'slide'
    end
  end

  --move the player while testing for collisions
  player.x, player.y, collisions, len = world:move(player, goalX, goalY, player.filter)
	
  --loop through collisions and see if anything important is happening
  for i, coll in ipairs(collisions) do
    if coll.touch.y > goalY then --we touched below (higher location has higher y value)
      player.hasReachedMax = true --this doesn't happen in the demo
      player.isGrounded = false
    elseif coll.normal.y < 0 then
      player.hasReachedMax = false
      player.isGrounded = true
    end
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.push("quit")
  end
end

function love.draw(dt)

  love.graphics.draw(player.img, player.x, player.y)	
  love.graphics.rectangle('fill', world:getRect(ground_0))
  love.graphics.rectangle('fill', world:getRect(ground_1))
  
end
