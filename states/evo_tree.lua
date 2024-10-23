-- menu_state.lua
local State = {}

function State:enter()
  ObjHandler = ObjectHandler()
  menu = Gui.button.Rect {
    x = (GS.width / 2) - (100 / 2),
    y = GS.height - 100,
    w = 100, h = 40,
    inactive = {
      text = {
        text = "menu"
      }
    },
    action = {
      released = function(self) StateManager:switch("menu") end,
    },
  }

  local digis = require "data.d_catalog"
  local DigiCatalog = require("lib.digi_catalog")({ digis = digis })
  digis = nil
  menu_key = ObjHandler:addObj(menu)
  menu = nil
  digi_btns = {}
  selected_digi = nil
  for digiKey, digi in pairs(DigiCatalog.digis) do
    table.insert(digi_btns,
      Gui.button.Rect {
        inactive = {
          text = { text = digi.name }
        },
        action = {
          released = function(self) selected_digi = digiKey end
        }
      })
  end

  local digi_list = Gui.box.List {
    mode = "line",
    objs = digi_btns,
  }

  digi_list.w = GS.width / 2
  digi_list.x = GS.width / 2 - digi_list.w / 2
  digi_list.h = GS.height / 3
  digi_list.y = GS.height / 2 - digi_list.h / 2
  digi_list.mode = "line"
  digi_list:setSizes()
  ObjHandler:addObj(digi_list)
end

function State:update(dt)
  ObjHandler:update(dt)
end

function State:draw()
  ObjHandler:draw()
end

function State:exit()

end

function State:touchmoved(id, x, y, dx, dy, pressure)
  ObjHandler:touchmoved(id, x, y, dx, dy, pressure)
end

function State:touchpressed(id, x, y, dx, dy, pressure)
  ObjHandler:touchpressed(id, x, y, dx, dy, pressure)
end

function State:touchreleased(id, x, y, dx, dy, pressure)
  ObjHandler:touchreleased(id, x, y, dx, dy, pressure)
end

function State:mousereleased(x, y, button, istouch, presses)
  ObjHandler:mousereleased(x, y, button, istouch, presses)
end

function State:mousemoved(x, y, dx, dy, istouch)
  ObjHandler:mousemoved(x, y, dx, dy, istouch)
end

function State:mousepressed( x, y, button, istouch, presses )
  ObjHandler:mousepressed( x, y, button, istouch, presses )
end

return State
