__DEBUG = true

-- https://love2d.org/wiki/Config_Files
function love.conf(t)
  t.version = '11.5'
  t.title = 'Hunter Seeker'

  t.window.height  = 480
  t.window.width   = 640

  if __DEBUG then
    t.console = true
  end
end
