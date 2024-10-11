anim8 = require 'libraries.anim8'
require 'functions.helpers'
require 'modules.joystick'
require 'src.player'
require 'src.game'
require 'src.debug'

local debug = Debug:new()
local game = Game:new()

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest') -- for scaling -> https://youtu.be/ON7fpPIVtg8?t=554

  game:load()
end

function love.update(dt)
  game:update(dt)

  if __DEBUG then
    debug:update(dt)
  end
end

function love.draw()
  -- normalize per iteration
  love.graphics.setFont(game.font) -- this font should be of sprites, eventually, so we can do neat things (ref: Balatro)
  love.graphics.setLineWidth(1)
  love.graphics.setColor(1, 1, 1)

  game:draw()

  local objects = {}
  debug:draw(objects)
end

function love.keypressed(key)
  game:key_pressed(key)
end

-- True if the window gains focus, false if it loses focus.
function love.focus(f)
end

-- https://love2d.org/wiki/love.mousepressed
function love.mousepressed(x, y, button, istouch)
end

-- https://love2d.org/wiki/love.mousereleased
function love.mousereleased(x, y, button, is_touch)
  game:mouse_pressed(x, y, button, is_touch)
end

-- joysticks
function love.joystickpressed(_joystick, button)
  local btn = game.player.joystick:button_pressed(button)

  if __DEBUG then
    debug:joystick_button_pressed(btn)
  end
end

function love.quit()
  game:quit()
end


