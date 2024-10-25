Classic = require "lib.classic"
StateManager = require "lib.state_manager"
ObjectHandler = require "lib.obj_handler"
Lovebird = require "lib.lovebird"
Gui = require "lib.gui"
Ser = require "lib.ser"
Utils = require "lib.utils"
CONF = {}
DigiCatalog = require("lib.digi_catalog")({ digis = require("data.d_catalog") })

GS={}
CONF.OS = love.system.getOS()

if CONF.OS == "Android" or CONF.OS == "iOS" then CONF.mobile=true end

if CONF.mobile then
  local _w, _h = love.window.getDesktopDimensions(  )
  local _s = love.window.getDPIScale() 
    GS.height = _w / _s
    GS.width = _h / _s
else
  GS.width, GS.height = love.graphics.getDimensions( )
end