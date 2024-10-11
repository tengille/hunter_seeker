require 'modules.joystick'

-- to be used for drawing icons fading out
local button_icons = {
  ps4_x = 'assets/debug/narehop/x.png',
  ps4_o = 'assets/debug/narehop/o.png',
  ps4_square = 'assets/debug/narehop/square.png',
  ps4_triangle = 'assets/debug/narehop/triangle.png',
  ps4_share = 'assets/debug/narehop/share.png',
  ps4_ps4_button = 'assets/debug/narehop/ps.png',
  ps4_options = 'assets/debug/narehop/options.png',
  ps4_l3 = 'assets/debug/narehop/l3.png',
  ps4_r3 = 'assets/debug/narehop/r3.png',
  ps4_l1 = 'assets/debug/narehop/lb.png',
  ps4_r1 = 'assets/debug/narehop/rb.png',
  ps4_dpad_up = 'assets/debug/narehop/dpad_up.png',
  ps4_dpad_down = 'assets/debug/narehop/dpad_down.png',
  ps4_dpad_left = 'assets/debug/narehop/dpad_left.png',
  ps4_dpad_right = 'assets/debug/narehop/dpad_right.png',
  ps4_middle_thing = 'assets/debug/narehop/middle-button.png',
  ps4_lt = 'assets/debug/narehop/lt.png',
  ps4_rt = 'assets/debug/narehop/rt.png'
}

Debug = {}
Debug.__index = Debug

function Debug:new()
  local d = {}
  setmetatable(d, self)

  d.elements = {}
  d.joystick = Joystick:new()

  -- custom because triggers
  d.left_trigger_icon = love.graphics.newImage(button_icons['ps4_lt'])
  d.right_trigger_icon = love.graphics.newImage(button_icons['ps4_rt'])

  return d
end

function Debug:update(dt)
  self.joystick:update(dt)

  local w, h = love.graphics.getDimensions()
  self.width = w
  self.height = h

  for i = 1, #self.elements do
    local element = self.elements[i]
    if element ~= nil then
      element:update(dt)
      element:fade_out()
      if element:should_delete() then
        table.remove(self.elements, i)
      end
    end
  end
end

function Debug:draw(_objects)
  -- normalize
  love.graphics.setColor(1, 1, 1, 1)

  -- refactor me into update, we don't need all these variables in :draw()
  -- sticks
  local left_base_joystick_x = 30
  local left_base_joystick_y = self.height - 30
  local right_base_joystick_x = 120
  local right_base_joystick_y = self.height - 30
  local radius = 20

  love.graphics.circle('line', left_base_joystick_x, left_base_joystick_y, radius)
  love.graphics.circle('line', right_base_joystick_x, right_base_joystick_y, radius)
  love.graphics.setColor(1, 0, 0)

  local joystick_left_x = left_base_joystick_x + (self.joystick.left_x * radius)
  local joystick_left_y = left_base_joystick_y + (self.joystick.left_y * radius)
  local joystick_right_x = right_base_joystick_x + (self.joystick.right_x * radius)
  local joystick_right_y = right_base_joystick_y + (self.joystick.right_y * radius)
  love.graphics.circle('fill', joystick_left_x, joystick_left_y, 4)
  love.graphics.circle('fill', joystick_right_x, joystick_right_y, 4)
  love.graphics.setColor(1, 1, 1)

  -- triggers
  love.graphics.setColor(1, 1, 1, self.joystick.trigger_left)
  love.graphics.draw(self.left_trigger_icon, left_base_joystick_x - 10, self.height - 70)
  love.graphics.setColor(1, 1, 1, self.joystick.trigger_right)
  love.graphics.draw(self.right_trigger_icon, right_base_joystick_x - 10, self.height - 70)

  -- mouse
  local mouse_x, mouse_y = love.mouse.getPosition()
  love.graphics.print(mouse_x .. ', ' .. mouse_y, mouse_x - 20, mouse_y - 20)
  love.graphics.setColor(1, 0, 0)
  love.graphics.line(mouse_x - 5, mouse_y, mouse_x + 5, mouse_y)
  love.graphics.line(mouse_x, mouse_y - 5, mouse_x, mouse_y + 5)

  -- elements
  for i = 1, #self.elements do
    self.elements[i]:draw()
  end
end

function Debug:joystick_button_pressed(button)
  self.elements[#self.elements + 1] = DebugElement:new(button)
end

DebugElement = {}
DebugElement.__index = DebugElement

function DebugElement:new(button)
  local de = {}
  setmetatable(de, self)

  de.button = button
  de.img = love.graphics.newImage(button_icons[button])
  de.fading = false
  de.r = 1
  de.g = 1
  de.b = 1
  de.a = 1
  de.fade_time = 1
  de.x = 60

  local _w, h = love.graphics.getDimensions()
  de.y = h - 30

  return de
end

function DebugElement:fade_out()
  if not self.fading then
    self.fading = true
  end
end

function DebugElement:update(dt)
  if self.fading and self.fade_time >= 0 then
    self.fade_time = self.fade_time - dt
    self.y = self.y - 1
  end

  if self.fade_time < 0 then
    self.fading = false
  end
end

function DebugElement:draw()
  love.graphics.setColor(1, 1, 1, self.fade_time)
  love.graphics.draw(self.img, self.x, self.y)
end

function DebugElement:should_delete()
  return self.fade_time <= 0
end
