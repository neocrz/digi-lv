-- menu_state.lua
local State = {}
local ObjHandler = ObjectHandler()
local popup = Gui.Popup {
  x = (GS.width / 2) - (300 / 2),
  y = 100,
  w = 300,
  h = 40,
  OH_ref = ObjHandler,
}

btn_menu = Gui.button.Rect {
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

local Stage = {}


-- select starting digimon
function Stage.init()
  -- list of digis
  ObjHandler:addObj(btn_menu)
  local digi_list = {}
  -- gen digi buttons
  local function genDbtn(digi)
    return Gui.button.Rect{
      inactive = { text = { text = digi.name } },
      action = { released = function (self)
        ObjHandler:clearLayer()
        Stage.evos(digi)
      end}
    }
  end

  local function genList(search)
    digi_list = Gui.box.List {}
    digi_list.w = GS.width / 2
    digi_list.x = GS.width / 2 - digi_list.w / 2
    digi_list.h = GS.height / 3
    digi_list.y = GS.height / 2 - digi_list.h / 2
    digi_list.mode = "line"
    digi_list.objs = {}

    -- digi_list_btns
    for k, digi in pairs(DigiCatalog.digis) do
      if search then
        if not Utils.searchSubstring(digi.name, search) then
          goto digi_list_btns_continue
        end
      end
        digi_list.objs[digi] = genDbtn(digi)
    ::digi_list_btns_continue::
    end
    digi_list:setSizes()
  end

  local btn_search = Gui.button.Text {
    OH_ref = ObjHandler,
    x = (GS.width / 2) - (100*3+20*2)/2 + (100+20),
    y = GS.height - 100 - 60,
    w = 100, h = 40,
    inactive = {
      text = {
        text = "search"
      }
    },
    action = {
      input = function (self)
        self.OH_ref:rmObj(digi_list)
        genList(self.input)
        self.input = ""
        self.OH_ref:addObj(digi_list)
      end
    }
  }

  genList()
  ObjHandler:addObj(digi_list)
  ObjHandler:addObj(btn_search)

end

function Stage.evos(digi)
  ObjHandler:addObj(btn_menu)
  local _t = {w=250,h=40}
  local txt_digi = Gui.base.Text{
    text = digi.name,
    w = _t.w, h=_t.h,
    x = (GS.width/2)-_t.w/2,
    y = (GS.height/4)
  }
  ObjHandler:addObj(txt_digi)
end

function State:enter(t)
  Stage.init()
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

function State:mousepressed(x, y, button, istouch, presses)
  ObjHandler:mousepressed(x, y, button, istouch, presses)
end

function State:textinput(t)
  ObjHandler:textinput(t)
end

function State:keypressed(key)
  ObjHandler:keypressed(key)
end

function State:wheelmoved(x, y)
  ObjHandler:wheelmoved(x, y)
end

return State
