local loadTimeStart = love.timer.getTime()
require "globals"
require "states"

function love.load()
  ObjHandler = ObjectHandler()
  if CONF.mobile then
    local _w, _h = love.window.getDesktopDimensions()
    local _s = love.window.getDPIScale()
    love.window.setFullscreen(true)
    love.window.setMode(1, 2) -- portrait
  end
  love.graphics.setBackgroundColor(78 / 255, 120 / 255, 186 / 255, 1)

  StateManager:switch("menu")
end

function love.update(dt)
  StateManager:update(dt)
  -- Lovebird:update()
  -- FPS = love.timer.getFPS( )
end

function love.draw()
  StateManager:draw()
end

function love.touchmoved(id, x, y, dx, dy, pressure)
  StateManager:touchmoved(id, x, y, dx, dy, pressure)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
  StateManager:touchpressed(id, x, y, dx, dy, pressure)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
  StateManager:touchreleased(id, x, y, dx, dy, pressure)
end

function love.mousereleased(x, y, button, istouch, presses)
  StateManager:mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
  StateManager:mousemoved(x, y, dx, dy, istouch)
end

function love.mousepressed( x, y, button, istouch, presses )
  StateManager:mousepressed( x, y, button, istouch, presses )
end

function love.textinput(t)
  StateManager:textinput(t)
end

function love.keypressed(key)
  StateManager:keypressed(key)
end

function love.wheelmoved(x,y)
  StateManager:wheelmoved(x,y)
end