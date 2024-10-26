-- menu_state.lua
local State = {}
local ObjHandler = ObjectHandler()
-- to save the digis

-- to print alerts and info
local popup = Gui.Popup{
  x = (GS.width/2) - (300/2),
  y = 100,
  w = 300,
  h = 40,
  OH_ref = ObjHandler,
}
-- to store the digimon location
local digi_loc = nil
-- to store digimon info
local digi_info = nil

local previous_step = nil


-- 1. step
-- when you want to change the digi that you have selected before
local btn_previous_step = Gui.button.Rect {
  x = (GS.width / 2) - (100*3+20*2)/2 + (100+20),
  y = GS.height - 100,
  w = 80, h = 40,
  inactive = {
    text = {
      text = "MENU"
    }
  },
}

local steps = {}
-- steps.key gets the key of the digimon selected by user
function steps.key ()
  local digi_list = nil
  -- Generates a list of alternatives to choose from
  local gen_list = function (s)
    -- can receive a search string to delimit digi list
    local search = s or nil
    -- table of digis that matches the query
    local digi_btns = {}
    -- rm any previous list
    if digi_list then ObjHandler:rmObj(digi_list) end
    -- template of the digi selection button
    local add_dg_btn = function (digi)
      digi_btns[digi] = Gui.button.Rect {
        inactive = {
          text = { text = digi.name }
        },
        action = {
          -- when some digi button is released
          released = function(self) 
            -- save it's key in the digi_info
            digi_info.key = digi.key 
            -- creates a popup that removes this step and goes to the next one
            popup.text = "'".. digi_info.key .. "' Selected"
            popup.action = function (self)
              self.OH_ref:rmObj(self)
              self.OH_ref:rmObj(digi_list)
              self.OH_ref:rmObj(btn_search)
              steps.status()
            end
            ObjHandler:addObj(popup, 10)
          end
        }
      }
    end
    -- add matched digis to list
    for digiKey, digi in pairs(DigiCatalog.digis) do
      if not search then
        add_dg_btn(digi)
      else
        if Utils.searchSubstring(digi.name, search) then
          add_dg_btn(digi)
        end
      end
    end
    -- list object
    digi_list = Gui.box.List {
      mode = "line",
      objs = digi_btns,
    }
    -- list dimensions
    digi_list.w = GS.width / 2
    digi_list.x = GS.width / 2 - digi_list.w / 2
    digi_list.h = GS.height / 3
    digi_list.y = GS.height / 2 - digi_list.h / 2
    digi_list.mode = "line"
    digi_list:setSizes()
    -- add list
    ObjHandler:addObj(digi_list)
  
  end
  -- initial list with all digis
  gen_list()
  -- a btn to match digis with specific string in its name
  btn_search = Gui.button.text {
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
        gen_list(self.input)
        self.input = ""
      end
    }
  }
  ObjHandler:addObj(btn_search)
end


-- 2. step -> gets the status of the select digimon
function steps.status()
  -- this step is to get the specific digi status
  -- level, attack, sp.attack, defense, sp.defense, spirit
  -- it will first automatically fill the values (if to modify)
  local txt_w = 40
  local txt_h = txt_w
  local btn_w = 80
  local btn_h = txt_h
  local btn_pad = 20
  -- digi key
  local txt_key = Gui.base.Text{
    x=(GS.width)/2 - (btn_w*3)/2,
    y=(GS.height)/2 - (btn_h *3+btn_pad*2) - (btn_h+btn_pad), 
    w=btn_w*3, h=txt_h,
    text = digi_info.key
  }
  -- hp, lvl
  local txt_hp = Gui.base.Text{
    x = (GS.width)/2 - ((btn_w+txt_w)*2+btn_pad)/2, 
    y=(GS.height)/2 - (btn_h *3+btn_pad*2), 
    w=txt_w, h=txt_h,
    text = "HP"
  }
  local btn_hp = Gui.button.text {
    x = (GS.width)/2 - ((btn_w+txt_w)*2+btn_pad)/2 + txt_h,
    y=(GS.height)/2 - (btn_h *3+btn_pad*2), 
    w = btn_w, h = btn_h,
    input = digi_info.hp or 0,
    inactive = {
      text = {
        text = digi_info.hp or 0,
      }
    },
    keep_input=true
  }
  
  local txt_lvl = Gui.base.Text{
    x = (GS.width)/2 - ((btn_w+txt_w)*2+btn_pad)/2 + (btn_w+txt_w+btn_pad), 
    y=(GS.height)/2 - (btn_h *3+btn_pad*2), 
    w=txt_w, h=txt_h,
    text = "LVL"
  }
  local btn_lvl = Gui.button.text {
    x = (GS.width)/2 - ((btn_w+txt_w)*2+btn_pad)/2  + (btn_w+txt_w+btn_pad) + txt_h,
    y=(GS.height)/2 - (btn_h *3+btn_pad*2), 
    w = btn_w, h = btn_h,
    input = digi_info.lvl or 0,
    inactive = {
      text = {
        text = digi_info.lvl or 0,
      }
    },
    keep_input=true
  }

  -- attack sp.attack
  local txt_at = Gui.base.Text{
    x = (GS.width)/2 - ((btn_w+txt_w)*2+btn_pad)/2, 
    y= (GS.height)/2 - (btn_h*3+btn_pad*2)+(btn_h+btn_pad), 
    w=txt_w, h=txt_h,
    text = "AT"
  }
  local btn_at = Gui.button.text {
    x = (GS.width)/2 - ((btn_w+txt_w)*2+btn_pad)/2 + txt_h,
    y=(GS.height)/2 - (btn_h *3+btn_pad*2)+(btn_h+btn_pad), 
    w = btn_w, h = btn_h,
    input = digi_info.attack or 0,
    inactive = {
      text = {
        text = digi_info.attack or 0,
      }
    },
    keep_input=true
  }
  
  local txt_sp_at = Gui.base.Text{
    x = (GS.width)/2 - ((btn_w+txt_w)*2+btn_pad)/2 + (btn_w+txt_w+btn_pad), 
    y=(GS.height)/2 - (btn_h *3+btn_pad*2)+(btn_h+btn_pad), 
    w=txt_w, h=txt_h,
    text = "Sp.At"
  }
  local btn_sp_at = Gui.button.text {
    x = (GS.width)/2 - ((btn_w+txt_w)*2+btn_pad)/2  + (btn_w+txt_w+btn_pad) + txt_h,
    y=(GS.height)/2 - (btn_h *3+btn_pad*2)+(btn_h+btn_pad), 
    w = btn_w, h = btn_h,
    input = digi_info["sp.attack"] or 0,
    inactive = {
      text = {
        text = digi_info["sp.attack"] or 0,
      }
    },
    keep_input=true
  }
  -- def, sp.def
  -- attack sp.attack
  local txt_de = Gui.base.Text{
    x = (GS.width)/2 - ((btn_w+txt_w)*2+btn_pad)/2, 
    y= (GS.height)/2 - (btn_h*3+btn_pad*2)+(btn_h+btn_pad)*2, 
    w=txt_w, h=txt_h,
    text = "DE"
  }
  local btn_de = Gui.button.text {
    x = (GS.width)/2 - ((btn_w+txt_w)*2+btn_pad)/2 + txt_h,
    y=(GS.height)/2 - (btn_h *3+btn_pad*2)+(btn_h+btn_pad)*2, 
    w = btn_w, h = btn_h,
    input = digi_info.defense or 0,
    inactive = {
      text = {
        text = digi_info.defense or 0,
      }
    },
    keep_input=true
  }
  
  local txt_sp_de = Gui.base.Text{
    x = (GS.width)/2 - ((btn_w+txt_w)*2+btn_pad)/2 + (btn_w+txt_w+btn_pad), 
    y=(GS.height)/2 - (btn_h *3+btn_pad*2)+(btn_h+btn_pad)*2, 
    w=txt_w, h=txt_h,
    text = "Sp.De"
  }
  local btn_sp_de = Gui.button.text {
    x = (GS.width)/2 - ((btn_w+txt_w)*2+btn_pad)/2  + (btn_w+txt_w+btn_pad) + txt_h,
    y=(GS.height)/2 - (btn_h *3+btn_pad*2)+(btn_h+btn_pad)*2, 
    w = btn_w, h = btn_h,
    input = digi_info["sp.defense"] or 0,
    inactive = {
      text = {
        text = digi_info["sp.defense"] or 0,
      }
    },
    keep_input=true
  }
  btn_add = Gui.button.Rect {
    x = (GS.width / 2) - (100*3+20*2)/2 + (100+20)*2,
    y = GS.height - 100,
    w = 100, h = 40,
    inactive = {
      text = {
        text = "ADD"
      }
    },
    action = {
      released = function(self)
        digi_info.hp = btn_hp.input
        digi_info.level = btn_lvl.input
        digi_info.attack = btn_at.input
        digi_info["sp.attack"] = btn_sp_at.input
        digi_info.defense = btn_de.input
        digi_info["sp.defense"] = btn_sp_de.input
        MyDigis:addDigi(
          digi_loc.box, 
          digi_loc.line, 
          digi_loc.row,
          digi_info
        )
        popup.text = "Digimon Added"
        popup.action = function (self)
          self.OH_ref:clearLayer()
          self.OH_ref:rmObj(self)
          StateManager:switch("menu")
        end
        ObjHandler:addObj(popup, 10)
      end,
    },
  }

  ObjHandler:addObj(txt_key)
  ObjHandler:addObj(txt_hp)
  ObjHandler:addObj(btn_hp)
  ObjHandler:addObj(txt_lvl)
  ObjHandler:addObj(btn_lvl)
  ObjHandler:addObj(txt_at)
  ObjHandler:addObj(btn_at)
  ObjHandler:addObj(txt_sp_at)
  ObjHandler:addObj(btn_sp_at)
  ObjHandler:addObj(txt_de)
  ObjHandler:addObj(btn_de)
  ObjHandler:addObj(txt_sp_de)
  ObjHandler:addObj(btn_sp_de)
  ObjHandler:addObj(btn_add)

  
end

-- receives a t that must contain box,line,row and maybe digi (if to modify)
function State:enter(t)
  digi_loc = {}
  digi_loc.box = tonumber(t.box)
  digi_loc.line = tonumber(t.line)
  digi_loc.row = tonumber(t.row)
  
  digi_info = t.digi or {}

  btn_menu = Gui.button.Rect {
    x = (GS.width / 2) - (100*3+20*2)/2 + (100+20),
    y = GS.height - 100,
    w = 100, h = 40,
    inactive = {
      text = {
        text = "MENU"
      }
    },
    action = {
      released = function(self) 
        ObjHandler:clearLayer()
        StateManager:switch("menu") 
      end,
    },
  }
  ObjHandler:addObj(btn_menu)

  steps.key()
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
