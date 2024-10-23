-- menu_state.lua
local State = {} 

function State:enter()
  ObjHandler = ObjectHandler()
  menu = {}

  -- MENU BUTTONS
  my_digis = Gui.button.Rect{
    inactive = {
      text = {
        text = "MY DIGIS"
      }
    };
    action ={
      released = function(self) StateManager:switch("mydigis") end;
    };
  }

  evo_tree = Gui.button.Rect{
    inactive = {
      text = {
        text = "EVO TREE"
      }
    };
    action ={
      released = function(self) StateManager:switch("evo_tree") end;
    };
  }
  
  
  local menu_dim = {}
  if CONF.mobile then
    menu_dim.w = GS.width/2
    menu_dim.h = GS.height/3
    
  else
    menu_dim.w = GS.width/3 
    menu_dim.h = GS.height/2
  end
  local menu_box = Gui.box.Vbox{
    x=GS.width/2-menu_dim.w/2, 
    y=GS.height/2-menu_dim.h/2,
    w=menu_dim.w, h=menu_dim.h,
    padding = {
      h = 10
    },
    objs={
      my_digis;
      evo_tree;
      Gui.button.Rect{
        inactive = {text = {text = "QUIT"}; };
        action = {
          released = function(self) love.event.quit( exitstatus ) end
        };
      };
    }
  }

  ObjHandler:addObj(menu_box)
end

function State:update(dt)
  ObjHandler:update(dt)
end

function State:draw()
  ObjHandler:draw()
end

function State:exit()
    
end

function State:touchmoved( id, x, y, dx, dy, pressure )
  ObjHandler:touchmoved( id, x, y, dx, dy, pressure )
end

function State:touchpressed( id, x, y, dx, dy, pressure )
  ObjHandler:touchpressed( id, x, y, dx, dy, pressure )
end

function State:touchreleased( id, x, y, dx, dy, pressure )
  ObjHandler:touchreleased( id, x, y, dx, dy, pressure )
end

function State:mousereleased( x, y, button, istouch, presses)
  ObjHandler:mousereleased( x, y, button, istouch, presses)
end

function State:mousemoved( x, y, dx, dy, istouch )
  ObjHandler:mousemoved( x, y, dx, dy, istouch )
end

return State
