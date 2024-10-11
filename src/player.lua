require 'modules.joystick'

Player = {}
Player.__index = Player

function Player:new()
  local p = {}
  setmetatable(p, self)

  p.joystick = Joystick:new()
  p.x = 100
  p.y = 100
  p.x_velocity = 0
  p.y_velocity = 0
  p.friction = 10
  p.speed = 500
  p.direction = 'idle'
  p.movement_type = 'walking' -- walking / running / roll
  p.scale = 2

  return p
end

function Player:load()
  -- refactor me -> https://www.youtube.com/watch?v=ON7fpPIVtg8
  self.animations = {}
  self.animations.sprite_sheet = love.graphics.newImage('assets/link_movement.png')
  self.animations.grid = anim8.newGrid(16, 16, self.animations.sprite_sheet:getWidth(), self.animations.sprite_sheet:getHeight())

  self.animations.up = anim8.newAnimation(self.animations.grid('5-6', 1), 0.2)
  self.animations.down = anim8.newAnimation(self.animations.grid('1-2', 1), 0.2)
  self.animations.left = anim8.newAnimation(self.animations.grid('7-8', 1), 0.2)
  self.animations.right = anim8.newAnimation(self.animations.grid('3-4', 1), 0.2)

  self.current_animation = self.animations.down

  self.player_movement_animations = {
    right = self.animations.right,
    up_right = self.animations.right,
    up = self.animations.up,
    up_left = self.animations.left,
    left = self.animations.left,
    down_left =  self.animations.down,
    down = self.animations.down,
    down_right = self.animations.down,
    idle = self.animations.down
  }
end

function Player:update(dt)
  self.joystick:update(dt)

  -- private?
  self:move(dt)
  self:calculate_direction()

  -- draw animations
  -- need to account "rolling" / "attacking"
  -- how to finish an animation?
  self.current_animation = self.player_movement_animations[self.direction]

  if self.movement_type == 'running' then
    self.current_animation:update(dt * 2)
  else
    self.current_animation:update(dt)
  end
end

function Player:draw()
  -- normalize color
  love.graphics.setColor(1, 1, 1)

  -- gets dimensions of current frame and draws on top of origin point correctly
  local dims = self.current_animation:getDimensions()
  self.current_animation:draw(self.animations.sprite_sheet, self.x, self.y, nil, self.scale, self.scale, dims / 2, dims)

  if __DEBUG then
    love.graphics.setColor(1, 1, 1)
    love.graphics.print('x_v: ' .. round(self.x_velocity, 0), self.x,  self.y + 2)
    love.graphics.print('y_v: ' .. round(self.y_velocity, 0), self.x,  self.y + 10)
    love.graphics.print('dir: ' .. self.direction .. ' - ' .. self.movement_type, self.x, self.y + 18)

    love.graphics.setColor(1, 0, 0)                 -- debug color
    love.graphics.circle('fill', self.x, self.y, 2) -- origin
  end
end

function Player:move(dt)
  if math.abs(self.x_velocity) > 40 or math.abs(self.y_velocity) > 40 then
    self.movement_type = 'running'
  else
    self.movement_type = 'walking'
  end

  -- refactor?
  self.x = self.x + self.x_velocity * dt
  self.y = self.y + self.y_velocity * dt
  self.x_velocity = self.x_velocity * (1 - math.min(dt * self.friction, 1))
  self.y_velocity = self.y_velocity * (1 - math.min(dt * self.friction, 1))

  self:keyboard_movement(dt)
  self:joystick_movement(dt)
end

function Player:keyboard_movement(dt)
  if love.keyboard.isDown('d') and self.x_velocity < self.speed then
    self.x_velocity = self.x_velocity + self.speed * dt
  end

  if love.keyboard.isDown('a') and self.x_velocity > -self.speed then
    self.x_velocity = self.x_velocity - self.speed * dt
  end

  if love.keyboard.isDown('s') and self.y_velocity < self.speed then
    self.y_velocity = self.y_velocity + self.speed * dt
  end

  if love.keyboard.isDown('w') and self.y_velocity > -self.speed then
    self.y_velocity = self.y_velocity - self.speed * dt
  end
end

function Player:joystick_movement(dt)
  -- self.x_velocity = self.x_velocity + self.speed * dt * self.joystick.left_x
  -- self.y_velocity = self.y_velocity + self.speed * dt * self.joystick.left_y
end

-- sloppy but works
function Player:calculate_direction()
  if round(self.x_velocity, 0) > 0 then
    if round(self.y_velocity, 0) > 0 then
      self.direction = 'down_right'
    elseif round(self.y_velocity, 0) < 0 then
      self.direction = 'up_right'
    else
      self.direction = 'right'
    end
  elseif round(self.x_velocity, 0) < 0 then
    if round(self.y_velocity, 0) > 0 then
      self.direction = 'down_left'
    elseif round(self.y_velocity, 0) < 0 then
      self.direction = 'up_left'
    else
      self.direction = 'left'
    end
  elseif round(self.y_velocity, 0) > 0 and round(self.x_velocity) == 0 then
    self.direction = 'down'
  elseif round(self.y_velocity, 0) < 0 and round(self.x_velocity) == 0 then
    self.direction = 'up'
  else
    self.direction = 'idle'
  end
end
