Keyboard = {}
Keyboard.__index = Keyboard

-- really just a decorator or interface or whatever for love.mouse
function Keyboard:new()
  local m = {}
  setmetatable(m, self)

  return m
end

function Keyboard:update(_dt)
end

return Keyboard
