-- look at LocalThunk's Object and see if I can make something polymorphic-ish
Game = {}
Game.__index = Game

-- state enum
local game_states = {
  [1] = 'main_menu',
  [2] = 'pause_menu',
  [3] = 'playing'
}

function Game:new()
  local g = {}
  setmetatable(g, self)

  g.font = love.graphics.setNewFont("assets/fonts/m5x7.ttf", 12)
  g.player = Player:new()
  g.player:load()
  g.state = 3

  return g
end

function Game:load()
  print(__DEBUG)
  if __DEBUG then
    print('')            -- nice console output
    print('Game loaded') -- nice console output
  end
end

function Game:update(dt)
  self.player:update(dt)
end

function Game:draw()
  love.graphics.setColor(1, 1, 1, 1) -- default

  -- draw individual things
  self.player:draw()
end

function Game:key_pressed(key)
  if __DEBUG then
    print('Key: ' .. key .. ' pressed')
  end
end

function Game:mouse_pressed(x, y, button, is_touch)
  local mouse_x, mouse_y = love.mouse.getPosition()

  if __DEBUG then
    print("Mouse was pressed at: " .. mouse_x .. ", " .. mouse_y .. ' with ' .. button)
  end
end

function Game:quit()
  if __DEBUG then
    print('Game quit')
  end
end
