-- menu_state.lua
local State = {} 

function State:enter()
  ObjHandler = ObjectHandler()
end

function State:update(dt)
  ObjHandler:update(dt)
end

function State:draw()
  ObjHandler:draw()
end

function State:exit()
    
end

function State:touchmoved( id, x, y, dx, dy, pressure )
  ObjHandler:touchmoved( id, x, y, dx, dy, pressure )
end

function State:touchpressed( id, x, y, dx, dy, pressure )
  ObjHandler:touchpressed( id, x, y, dx, dy, pressure )
end

function State:touchreleased( id, x, y, dx, dy, pressure )
  ObjHandler:touchreleased( id, x, y, dx, dy, pressure )
end

function State:mousereleased( x, y, button, istouch, presses)
  ObjHandler:mousereleased( x, y, button, istouch, presses)
end

function State:mousemoved( x, y, dx, dy, istouch )
  ObjHandler:mousemoved( x, y, dx, dy, istouch )
end

return State
