Mouse = {}
Mouse.__index = Mouse

function Mouse:test()
  puts "Mouse"
end

-- really just a decorator or interface or whatever for love.mouse
function Mouse:new()
  local m = {}
  setmetatable(m, self)

  m.x = nil
  m.y = nil

  return m
end

function Mouse:update(_dt)
  self.x, self.y = love.mouse.getPosition()
end

-- x/y_tolerance is usually something like the height and width of the related object
-- this may change
function Mouse:is_hovered_on(object, x_tolerance, y_tolderance)
  if self.x >= object.x and
      self.x <= object.x + x_tolerance and
      self.y >= object.y and
      self.y <= object.y + y_tolderance then
    return true
  else
    return false
  end
end

function Mouse:is_left_clicked()
  return love.mouse.isDown(1)
end

function Mouse:is_right_clicked()
  return love.mouse.isDown(2)
end

function Mouse:is_left_clicked_on(object)
  if self:is_hovered_on(object) and self:is_left_click() then
    return true
  end
end

return Mouse
