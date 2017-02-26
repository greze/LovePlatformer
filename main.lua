
--pull bump library
bump = require 'libs.bump.bump'

-- Pullin Gamestate from HUMP library
Gamestate = require 'libs.hump.gamestate'

--Pull in each of the game states
local mainMenu = require 'gamestates.mainMenu'
local gameLevel1 = require 'gamestates.gameLevel1'
local pause = require 'gamestates.pause'

function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(gameLevel1)	
end

function love.keypressed(key)
  if key == "escape" then
    love.event.push("quit")
  end
  
  if Gamestate.current() ~= mainMenu and Gamestate.current() ~= pause and key == 'p' then
    Gamestate.push(pause)
  end
end
