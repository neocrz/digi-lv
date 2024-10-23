-- menu_state.lua
local State = {}
local DigiCatalog = require("lib.digi_catalog")({ digis = require("data.d_catalog") })

local gen_digi_list = function(search)
  local search = search or nil
  local digi_btns = {}
  local add_dg_btn = function (digi)
    digi_btns[digi] = Gui.button.Rect {
      inactive = {
        text = { text = digi.name }
      },
      action = {
        released = function(self) selected_digi = digi end
      }
    }
  end
  
  for digiKey, digi in pairs(DigiCatalog.digis) do
    if not search then
      add_dg_btn(digi)
    else
      if Utils.searchSubstring(digi.name, search) then
        add_dg_btn(digi)
      end
    end
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
  digi_list_key = ObjHandler:addObj(digi_list)
  return digi_list_key
end

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

  search = Gui.button.text {
    x = (GS.width / 2) - (100 / 2),
    y = GS.height - 100 - 60,
    w = 100, h = 40,
    inactive = {
      text = {
        text = "search"
      }
    },
    action = {
      input = function (self)
        ObjHandler:rmObj(digi_list_key)
        digi_list_key = gen_digi_list(self.input)
      end
    }
  }

  
  menu = ObjHandler:addObj(menu) -- return key
  search = ObjHandler:addObj(search) -- return key
  selected_digi = nil
  
  digi_list_key = gen_digi_list()
end

function State:update(dt)
  ObjHandler:update(dt)
  -- if selected_digi then print(selected_digi.name) end
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

function State:textinput(t)
  ObjHandler:textinput(t)
end
function State:keypressed(key)
  ObjHandler:keypressed(key)
end
function State:wheelmoved(x,y)
  ObjHandler:wheelmoved(x,y)
end

return State
