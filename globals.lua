Classic = require "lib.classic"
StateManager = require "lib.state_manager"
ObjectHandler = require "lib.obj_handler"
Lovebird = require "lib.lovebird"
Gui = require "lib.gui"

GS={}
local os = love.system.getOS()
if os == "Android" or os == "iOS" then
  local _w, _h = love.window.getDesktopDimensions(  )
  local _s = love.window.getDPIScale() 
    GS.height = _w / _s
    GS.width = _h / _s
else
  GS.width, GS.height = love.graphics.getDimensions( )
end