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

local btn_menu = Gui.button.Rect {
  x = (GS.width / 2) - (100 * 3 + 20 * 2) / 2 + (100 + 20),
  y = GS.height - 100,
  w = 100, h = 40,
  inactive = {
    text = {
      text = "MENU"
    }
  },
  action = {
    released = function(self) StateManager:switch("menu") end,
  },
}

local btn_return = Gui.button.Rect {
  x = (GS.width / 2) - (100 * 3 + 20 * 2) / 2 + (100 + 20) * 0,
  y = GS.height - 100,
  w = 100, h = 40,
  inactive = {
    text = {
      text = "RETURN"
    }
  },
  action = {
    released = function(self)
      StateManager:switch("digi_volution")
    end,
  },
}



local Stage = {}
local btn_route = Gui.button.Rect {
  x = (GS.width / 2) - (100 * 3 + 20 * 2) / 2 + (100 + 20) * 2,
  y = GS.height - 100,
  w = 100, h = 40,
  inactive = {
    text = {
      text = "EDIT.ROUTE"
    }
  },
  action = { released = function(self)
    ObjHandler:clearLayer()
    Stage.digi_route()
  end, },
}

-- select starting digimon
function Stage.init()
  -- list of digis
  ObjHandler:addObj(btn_menu)
  ObjHandler:addObj(btn_route)
  local digi_list = {}
  -- gen digi buttons
  local function genDbtn(digi)
    return Gui.button.Rect {
      inactive = { text = { text = digi.name } },
      action = { released = function(self)
        ObjHandler:clearLayer()
        Stage.evos(digi)
      end }
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
    x = (GS.width / 2) - (100 * 3 + 20 * 2) / 2 + (100 + 20),
    y = GS.height - 100 - 60,
    w = 100, h = 40,
    inactive = {
      text = {
        text = "search"
      }
    },
    action = {
      input = function(self)
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

-- Show digivolutions
function Stage.evos(digi)
  dvs = DigiCatalog:getDv(digi)
  print(dvs.from)
  local btn_menu_l = btn_menu
  btn_menu_l.y = GS.height - 20 - 30
  btn_menu_l.h = 30
  local btn_route_l = btn_route
  btn_route_l.y = btn_menu_l.y
  btn_route_l.h = btn_menu_l.h
  ObjHandler:addObj(btn_menu_l)
  ObjHandler:addObj(btn_route_l)
  local _t = { h = 20 }

  if CONF.mobile then
    _t.w = GS.width - 40 * 2
    _t.h_cond = (GS.height / 10) * 1
  else
    _t.w = 250
    _t.h_cond = (GS.height / 10) * 2
  end

  local txt_digi = Gui.base.Text {
    text = digi.name,
    w = _t.w, h = _t.h,
    x = (GS.width / 2) - _t.w / 2,
    y = (GS.height / 2) - (_t.h * 2 + _t.h_cond) / 2
  }
  -- the evolution select to show the conditions
  local txt_digi2 = Gui.base.Text {
    text = "",
    w = _t.w, h = _t.h,
    x = (GS.width / 2) - _t.w / 2,
    y = (GS.height / 2) - (_t.h * 2 + _t.h_cond) / 2 + _t.h
  }
  -- digivolution conditions
  local txt_cond = Gui.base.Text {
    text = "",
    w = _t.w, h = _t.h_cond,
    x = (GS.width / 2) - _t.w / 2,
    y = (GS.height / 2) - (_t.h * 2 + _t.h_cond) / 2 + _t.h * 2
  }


  local txt_from = Gui.base.Text {
    text = "FROM",
    w = _t.w, h = _t.h,
    x = txt_digi.x - _t.w - 20,
    y = (GS.height / 2) - (_t.h * 2 + _t.h_cond) / 2
  }
  _t.from_list = {
    x = txt_from.x + 2, -- 2 borda
    w = txt_from.w - 4, -- 4 borda
    h = (_t.h + _t.h_cond) - 4,
    y = (GS.height / 2) - (_t.h * 2 + _t.h_cond) / 2 + _t.h + 2
  }

  local txt_to = Gui.base.Text {
    text = "TO",
    x = txt_digi.x + _t.w + 20,
    y = (GS.height / 2) - (_t.h * 2 + _t.h_cond) / 2,
    w = _t.w, h = _t.h,
  }
  _t.to_list = {
    x = txt_to.x + 2, -- 2 borda
    w = txt_to.w - 4, -- 4 borda
    h = (_t.h + _t.h_cond) - 4,
    y = (GS.height / 2) - (_t.h * 2 + _t.h_cond) / 2 + _t.h + 2
  }
  if CONF.mobile then
    txt_from.x=txt_cond.x
    txt_from.y=txt_digi.y - 20 -txt_from.h -_t.from_list.h
    _t.from_list.x=txt_from.x+2
    _t.from_list.y=txt_from.y+txt_from.h+2
    
    txt_to.x=txt_cond.x
    txt_to.y=txt_cond.y+txt_cond.h+20
    _t.to_list.x=txt_to.x+2
    _t.to_list.y=txt_to.y+txt_to.h+2
  end

  local function genDigis(tb, pos)
    local digi_list = {}
    digi_list = Gui.box.List {}
    digi_list.h = pos.h
    digi_list.w = pos.w
    digi_list.x = pos.x
    digi_list.y = pos.y
    digi_list.obj_h = 20
    digi_list.mode = "line"
    if tb then
      for d, condition in pairs(tb) do
        table.insert(digi_list.objs, Gui.button.Rect {
          inactive = { text = { text = d.name } },
          action = { released = function(self)
            if not self.__has_activated then
              txt_cond.text = condition
              txt_digi2.text = d.name
              self.__has_activated = true
            else
              ObjHandler:clearLayer()
              Stage.evos(d)
            end
          end }
        })
      end
    end
    return digi_list
  end

  local digis_from = genDigis(dvs.from, _t.from_list)
  digis_from:setSizes()
  local digis_to = genDigis(dvs.to, _t.to_list)
  digis_to:setSizes()

  ObjHandler:addObj(txt_digi)
  ObjHandler:addObj(txt_digi2)
  ObjHandler:addObj(txt_cond)
  ObjHandler:addObj(txt_from)
  ObjHandler:addObj(digis_from)
  ObjHandler:addObj(txt_to)
  ObjHandler:addObj(digis_to)
end

-- add digivolution route
function Stage.digi_route()
  ObjHandler:addObj(btn_menu)
  ObjHandler:addObj(btn_return)
  local dg_evo = { from = nil, to = nil }
  local txt_from = Gui.base.Text {
    x = (GS.width) / 2 - (250) / 2,
    y = (GS.height) / 4,
    w = 250, h = 40,
    text = "From:"
  }
  local digi_list = {}
  -- gen digi buttons
  local function genDbtn(digi)
    return Gui.button.Rect {
      inactive = { text = { text = digi.name } },
      action = { released = function(self)
        if dg_evo.from then
          dg_evo.to = digi
          ObjHandler:clearLayer()
          Stage.add_cond(dg_evo.from, dg_evo.to)
        else
          dg_evo.from = digi
          txt_from.text = "From: " .. digi.name
        end
      end }
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
    x = (GS.width / 2) - (100 * 3 + 20 * 2) / 2 + (100 + 20),
    y = GS.height - 100 - 60,
    w = 100, h = 40,
    inactive = {
      text = {
        text = "search"
      }
    },
    action = {
      input = function(self)
        self.OH_ref:rmObj(digi_list)
        genList(self.input)
        self.input = ""
        self.OH_ref:addObj(digi_list)
      end
    }
  }
  genList()
  ObjHandler:addObj(digi_list)
  ObjHandler:addObj(txt_from)
  ObjHandler:addObj(btn_search)
end

-- add conditions to evolution
function Stage.add_cond(digi_from, digi_to)
  local _t = nil
  _t = { w = 150, h = 30 }
  local txt_title = Gui.base.Text {
    text = "Conditions",
    x = (GS.width) / 2 - _t.w / 2,
    y = _t.h,
    w = _t.w, h = _t.h,
  }

  _t = { w = 250, h = 20, s = 20 }
  local txt_from = Gui.base.Text {
    text = "FROM",
    y = txt_title.y + txt_title.h + _t.s,
    w = _t.w, h = _t.h,
  }

  local txt_from2 = Gui.base.Text {
    w = _t.w, h = _t.h,
    text = digi_from.name,
  }

  local txt_to = Gui.base.Text {
    text = "TO",
    w = _t.w, h = _t.h,
  }
  local txt_to2 = Gui.base.Text {
    w = _t.w, h = _t.h,
    text = digi_to.name,
  }

  if CONF.mobile then
    txt_from.x = (GS.width) / 2 - (txt_from.w) / 2
    txt_from2.x = txt_from.x
    txt_from2.y = txt_from.y + txt_from.h
    txt_to.x = txt_from2.x
    txt_to.y = txt_from2.y + txt_from2.h + _t.s
    txt_to2.x = txt_to.x
    txt_to2.y = txt_to.y + txt_to.h
    _t.w = GS.width - (40 * 2)
    _t.h = GS.height / 2
  else
    txt_from.x = (GS.width) / 2 - (_t.w * 2 + _t.s * 1) / 2
    txt_from2.x = txt_from.x
    txt_from2.y = txt_from.y + txt_from.h
    txt_to.x = (GS.width) / 2 - (_t.w * 2 + _t.s * 1) / 2 + (_t.w + _t.s)
    txt_to.y = txt_from.y
    txt_to2.x = txt_to.x
    txt_to2.y = txt_to.y + txt_to.h
    _t.w = GS.width / 2
    _t.h = (GS.height / 7) * 3
  end

  _t.y = txt_to2.y + txt_to2.h + _t.s
  local txt_cond = Gui.base.Text {
    x = (GS.width) / 2 - _t.w / 2,
    w = _t.w,
    y = _t.y,
    h = _t.h,
    text = ""
  }
  if DigiCatalog.dv_to[digi_from] then
    if DigiCatalog.dv_to[digi_from][digi_to] then
      print(DigiCatalog.dv_to[digi_from][digi_to])
      txt_cond.text = DigiCatalog.dv_to[digi_from][digi_to]
    end
  end

  local btn_add_cond = Gui.button.Text {
    OH_ref = ObjHandler,
    x = (GS.width / 2) - (100 * 3 + 20 * 2) / 2 + (100 + 20) * 2,
    y = GS.height - 100 - (40 + 20),
    w = 100, h = 40,
    inactive = {
      text = {
        text = "add.cond"
      }
    },
    action = {
      input = function(self)
        txt_cond.text = txt_cond.text .. self.input .. "\n"
        self.input = ""
      end
    }
  }
  local btn_clr_cond = Gui.button.Rect {
    OH_ref = ObjHandler,
    x = (GS.width / 2) - (100 * 3 + 20 * 2) / 2 + (100 + 20) * 1,
    y = GS.height - 100 - (40 + 20),
    w = 100, h = 40,
    inactive = {
      text = {
        text = "clr.cond"
      }
    },
    action = {
      released = function(self)
        txt_cond.text = ""
      end
    }
  }
  local btn_save_cond = Gui.button.Rect {
    OH_ref = ObjHandler,
    x = (GS.width / 2) - (100 * 3 + 20 * 2) / 2 + (100 + 20) * 2,
    y = GS.height - 100,
    w = 100, h = 40,
    inactive = {
      text = {
        text = "SAVE"
      }
    },
    action = {
      released = function(self)
        DigiCatalog:addDv(digi_from, digi_to, txt_cond.text)
        popup.text = "Digivolution added"
        popup.action = function(self)
          self.OH_ref:rmObj(self)
          self.OH_ref:clearLayer()
          StateManager:switch("menu")
        end
        ObjHandler:addObj(popup, 10)
      end
    }
  }
  local btn_rm_dv = Gui.button.Rect {
    OH_ref = ObjHandler,
    x = (GS.width / 2) - (100 * 3 + 20 * 2) / 2 + (100 + 20) * 0,
    y = GS.height - 100 - (40 + 20),
    w = 100, h = 40,
    inactive = {
      text = {
        text = "rm.dv"
      }
    },
    action = {
      released = function(self)
        DigiCatalog:rmDv(digi_from, digi_to)
        popup.text = "Digivolution removed"
        popup.action = function(self)
          self.OH_ref:rmObj(self)
          self.OH_ref:clearLayer()
          StateManager:switch("menu")
        end
        ObjHandler:addObj(popup, 10)
      end
    }
  }
  ObjHandler:addObj(txt_title)
  ObjHandler:addObj(txt_from)
  ObjHandler:addObj(txt_to)
  ObjHandler:addObj(txt_from2)
  ObjHandler:addObj(txt_to2)
  ObjHandler:addObj(btn_menu)
  ObjHandler:addObj(btn_return)
  ObjHandler:addObj(txt_cond)
  ObjHandler:addObj(btn_add_cond)
  ObjHandler:addObj(btn_clr_cond)
  ObjHandler:addObj(btn_save_cond)
  ObjHandler:addObj(btn_rm_dv)
  _t = nil
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
  ObjHandler:clearLayer()
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
