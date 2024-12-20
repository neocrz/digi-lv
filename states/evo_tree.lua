-- menu_state.lua
local State = {}
local ObjHandler = ObjectHandler()


local gen_digi_list = function(search)
  if digi_list then
    ObjHandler:rmObj(digi_list)
  end
  -- search term
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

 digi_list = Gui.box.List {
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

function State:enter()
  local digi_list = nil
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

gen_digi_list()
  search = Gui.button.Text {
    OH_ref = ObjHandler,
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
        
        
        gen_digi_list(self.input)
        self.input = ""
      end
    }
  }

  
  ObjHandler:addObj(menu) -- return key
  ObjHandler:addObj(search) -- return key
  selected_digi = nil
  
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
