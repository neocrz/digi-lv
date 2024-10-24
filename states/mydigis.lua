-- menu_state.lua
local State = {}
local MyDigis = require("lib.mydigis")()

local function callDigi (box, line, row)
  local digi, txt = MyDigis:getDigi(box,line,row)
  if not digi then 
    popup = Gui.Popup{
      x = (GS.width/2) - (300/2),
      y = 50,
      w = 300,
      h = 40,
      text = txt,
      action = function (self)
        ObjHandler:rmObj(self.handler_id)
      end
    }

    popup.handler_id = ObjHandler:addObj(popup)
    return false
  end
end

function State:enter()
  ObjHandler = ObjectHandler()
  box_id = nil
  line_id = nil
  row_id = nil
  selected_digi = nil
  
  menu = Gui.button.Rect {
    x = (GS.width / 2) - (100 / 2),
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

  box = Gui.button.text {
    x = (GS.width / 2) - (100*4 +20*3)/2,
    y = GS.height - 100 - 60,
    w = 100, h = 40,
    inactive = {
      text = {
        text = "BOX"
      }
    },
    keep_input=true
  }
  line = Gui.button.text {
    x = (GS.width / 2) - (100*4 +20*3)/2 + (100+20),
    y = GS.height - 100 - 60,
    w = 100, h = 40,
    inactive = {
      text = {
        text = "LINE"
      }
    },
    keep_input=true
  }
  row = Gui.button.text {
    x = (GS.width / 2) - (100*4 +20*3)/2 + (100+20)*2,
    y = GS.height - 100 - 60,
    w = 100, h = 40,
    inactive = {
      text = {
        text = "ROW"
      }
    },
    keep_input=true
  }
  search = Gui.button.Rect {
    x = (GS.width / 2) - (100*4 +20*3)/2 + (100+20)*3,
    y = GS.height - 100 - 60,
    w = 100, h = 40,
    inactive = {
      text = {
        text = "SEARCH"
      }
    },
    keep_input=true
  }
  
  box.action.input = function(self) box_id = self.input end
  line.action.input = function(self) line_id = self.input end
  row.action.input = function(self) row_id = self.input end
  search.action.released = function(self) 
    callDigi(box_id, line_id, row_id) 
  end

  
  menu.handler_id = ObjHandler:addObj(menu) -- return key
  box.handler_id = ObjHandler:addObj(box) -- return key
  line.handler_id = ObjHandler:addObj(line) -- return key
  row.handler_id = ObjHandler:addObj(row) -- return key
  search.handler_id = ObjHandler:addObj(search) -- return key

  

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
