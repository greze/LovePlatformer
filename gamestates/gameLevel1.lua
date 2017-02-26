-- import libraries
bump = require 'libs.bump.bump'
Gamestate = require 'libs.hump.gamestate'

--import entity system
local Entities = require 'entities.Entities'
local Entity = require 'entities.Entity'

--create gamestate
local gameLevel1 = Gamestate.new()

--import the Entities we build
local Player = require 'entities.player'
local Ground = require 'entities.ground'

--declare some important variables
player = nil
world = nil

function gameLevel1:enter()
  print('gameLevel1 enter')
  --game levels need collisions
  world = bump.newWorld(16) --create a world for bump to function in; tile size is 16
  
  --initialize the Entity system
  Entities:enter(world, nil)
  
  player = Player(world, 16, 16)
  ground_0 = Ground(world, 120, 360, 640, 16)
  ground_1 = Ground(world, 0, 448, 640, 16)
  
  --add instances of the entities to the Entity List
  Entities:addMany({player, ground_0, ground_1})
end

function gameLevel1:update(dt)
  Entities:update(dt) --this executes the update function for each individual Entity
end

function gameLevel1:draw()
  Entities:draw() --executes draw function for each individual Entity
end

return gameLevel1
