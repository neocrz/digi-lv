-- menu_state.lua
local State = {}
local MyDigis = require("lib.mydigis")()

local DigiTable = Gui.base.Rect:extend()

function DigiTable:new(t)
  local t = t or {}
  DigiTable.super.new(self, t)
  self.digi = t.digi or {
    key=nil, name=nil, stage=nil
  }
end


function State:enter()
  ObjHandler = ObjectHandler()
  local digi = nil
  
  local popup = Gui.Popup{
    x = (GS.width/2) - (300/2),
    y = 100,
    w = 300,
    h = 40,
    OH_ref = ObjHandler,
    
  }
  local getDigi = function(box,line,row)
    local dg, txt = MyDigis:getDigi(box,line,row)
    if not dg then
      popup.text = txt
      ObjHandler:addObj(popup,11)
      return false
    end
    return dg
end
  
  btn_add_dg = Gui.button.Rect {
    x = (GS.width / 2) - (80*4 +20*3)/2,
    y = GS.height - 100,
    w = 80, h = 40,
    inactive = {
      text = {
        text = "ADD"
      }
    },
    action = {
      released = function(self)
        local box = tonumber(btn_box.input)
        local line = tonumber(btn_line.input)
        local row = tonumber(btn_row.input)
        if not (box and line and row) then
          popup.text = "Indexes are not valid numbers"
          return ObjHandler:addObj(popup, 10)
        end
        if (box > 13) or (box < 1) 
        or (line > 6) or (line < 1)
        or (row >10) or (row < 1)
        then
          popup.text = "Invalid indexes"
          return ObjHandler:addObj(popup, 10)
        end
        
        StateManager:switch("digi_editor", {box=box, line=line, row=row})
      end,
    },
  }

  btn_mod_dg = Gui.button.Rect {
    x = (GS.width / 2) - (80*4 +20*3)/2+(80+20),
    y = GS.height - 100,
    w = 80, h = 40,
    inactive = {
      text = {
        text = "MODIFY"
      }
    },
    action = {
      released = function(self) 
        local result, txt = MyDigis:getDigi(btn_box.input, btn_line.input, btn_row.input) 
        if not result then
          popup.text = txt
          return ObjHandler:addObj(popup,10)
        end
        StateManager:switch("digi_editor", {box=btn_box.input, line=btn_line.input, row=btn_row.input})
      end,
    },
  }
  btn_rm_dg = Gui.button.Rect {
    x = (GS.width / 2) - (80*4 +20*3)/2+(80+20)*2,
    y = GS.height - 100,
    w = 80, h = 40,
    inactive = {
      text = {
        text = "REMOVE"
      }
    },
    action = {
      released = function(self) 
        local result, txt = MyDigis:rmDigi(btn_box.input, btn_line.input, btn_row.input) 
        if not result then
          popup.text = txt
          ObjHandler:addObj(popup,10)
        end
      end,
    },
  }
  btn_menu = Gui.button.Rect {
    x = (GS.width / 2) - (80*4 +20*3)/2+(80+20)*3,
    y = GS.height - 100,
    w = 80, h = 40,
    inactive = {
      text = {
        text = "MENU"
      }
    },
    action = {
      released = function(self) StateManager:switch("menu") end,
    },
  }
  btn_box = Gui.button.text {
    x = (GS.width / 2) - (80*4 +20*3)/2,
    y = GS.height - 100 - 60,
    w = 80, h = 40,
    inactive = {
      text = {
        text = "BOX"
      }
    },
    keep_input=true
  }

  btn_line = Gui.button.text {
    x = (GS.width / 2) - (80*4 +20*3)/2 + (80+20),
    y = GS.height - 100 - 60,
    w = 80, h = 40,
    inactive = {
      text = {
        text = "LINE"
      }
    },
    keep_input=true
  }
  btn_row = Gui.button.text {
    x = (GS.width / 2) - (80*4 +20*3)/2 + (80+20)*2,
    y = GS.height - 100 - 60,
    w = 80, h = 40,
    inactive = {
      text = {
        text = "ROW"
      }
    },
    keep_input=true
  }
  btn_search = Gui.button.Rect {
    x = (GS.width / 2) - (80*4 +20*3)/2 + (80+20)*3,
    y = GS.height - 100 - 60,
    w = 80, h = 40,
    inactive = {
      text = {
        text = "SEARCH"
      }
    },
    keep_input=true
  }
  
  btn_search.action.released = function(self) 
    digi = getDigi(btn_box.input, btn_line.input, btn_row.input)
  end

  
  
  ObjHandler:addObj(btn_box)
  ObjHandler:addObj(btn_line)
  ObjHandler:addObj(btn_row)
  ObjHandler:addObj(btn_search)
  ObjHandler:addObj(btn_add_dg)
  ObjHandler:addObj(btn_rm_dg)
  ObjHandler:addObj(btn_mod_dg)
  ObjHandler:addObj(btn_menu)
  local dg_table = DigiTable()
  ObjHandler:addObj(dg_table)
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
