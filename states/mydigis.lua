-- menu_state.lua
local State = {}
local MyDigis = require("lib.mydigis")()



function State:enter()
  ObjHandler = ObjectHandler()
  
  local popup = Gui.Popup{
    x = (GS.width/2) - (300/2),
    y = 100,
    w = 300,
    h = 40,
    OH_ref = ObjHandler,
    
  }
  local getDigi = function(box,line,row)
    local digi, txt = MyDigis:getDigi(box,line,row)
    if not digi then
      popup.text = txt
      ObjHandler:addObj(popup,11)
    end
end
  
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
  line = Gui.button.text {
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
  row = Gui.button.text {
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
  search = Gui.button.Rect {
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
  
  search.action.released = function(self) 
    getDigi(box.input, line.input, row.input)
  end

  
  ObjHandler:addObj(menu) -- return key
  ObjHandler:addObj(box) -- return key
  ObjHandler:addObj(line) -- return key
  ObjHandler:addObj(row) -- return key
  ObjHandler:addObj(search) -- return key

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
