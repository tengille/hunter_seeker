Joystick = {}
Joystick.__index = Joystick

local button_mapping = {
  'ps4_x',
  'ps4_o',
  'ps4_square',
  'ps4_triangle',
  'ps4_share',
  'ps4_ps4_button',
  'ps4_options',
  'ps4_l3',
  'ps4_r3',
  'ps4_l1',
  'ps4_r1',
  'ps4_dpad_up',
  'ps4_dpad_down',
  'ps4_dpad_left',
  'ps4_dpad_right',
  'ps4_middle_thing',
  '',
}

-- really just a decorator or interface or whatever for love.mouse
function Joystick:new()
  local j = {}
  setmetatable(j, self)

  j.joystick = love.joystick.getJoysticks()[1]

  return j
end

function Joystick:update(_dt)
  if not self.joystick then
    return
  end

  self.left_x = round(self.joystick:getGamepadAxis("leftx"), 1)
  self.left_y = round(self.joystick:getGamepadAxis("lefty"), 1)
  self.right_x = round(self.joystick:getGamepadAxis("rightx"), 1)
  self.right_y = round(self.joystick:getGamepadAxis("righty"), 1)
  self.trigger_left = round(self.joystick:getGamepadAxis("triggerleft"), 1)
  self.trigger_right = round(self.joystick:getGamepadAxis("triggerright"), 1)
end

function Joystick:button_pressed(button)
  return button_mapping[button]
end

return Joystick

