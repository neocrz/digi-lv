-- menu_state.lua
local State = {}

local selected_digi = {}
local selected_base = {}
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
    if dg then
      return dg
    end   
    popup.text = txt
    ObjHandler:addObj(popup,11)
    return false
end
  -- oooooo
  local txt_w = 40
  local txt_h = txt_w
  local btn_w = 80
  local btn_h = txt_h
  local btn_pad = 20
  -- ooo
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
        StateManager:switch("digi_editor", {box=btn_box.input, line=btn_line.input, row=btn_row.input, digi=result})
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
        -- add rmObj from the search bubtton
        ObjHandler:rmObj(txt_digi_name)
        ObjHandler:rmObj(txt_digi_hp1)
        ObjHandler:rmObj(txt_digi_hp2)
        ObjHandler:rmObj(txt_digi_lvl1)
        ObjHandler:rmObj(txt_digi_lvl2)
        ObjHandler:rmObj(txt_digi_at1)
        ObjHandler:rmObj(txt_digi_at2)
        ObjHandler:rmObj(txt_digi_sp_at1)
        ObjHandler:rmObj(txt_digi_sp_at2)
        ObjHandler:rmObj(txt_digi_de1)
        ObjHandler:rmObj(txt_digi_de2)
        ObjHandler:rmObj(txt_digi_sp_de1)
        ObjHandler:rmObj(txt_digi_sp_de2)
        ObjHandler:rmObj(txt_digi_np1)
        ObjHandler:rmObj(txt_digi_np2)
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
  btn_box = Gui.button.Text {
    OH_ref=ObjHandler,
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

  btn_line = Gui.button.Text {
    OH_ref = ObjHandler,
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
  btn_row = Gui.button.Text {
    OH_ref = ObjHandler,
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
    local d = getDigi(btn_box.input, btn_line.input, btn_row.input)
    if d then
      selected_digi = d
      selected_base = DigiCatalog:getDigi(selected_digi.key)
      txt_digi_name.text = selected_base.name
      txt_digi_hp2.text = selected_digi.hp
      txt_digi_lvl2.text = selected_digi.level
      txt_digi_at2.text = selected_digi.attack
      txt_digi_sp_at2.text = selected_digi["sp.attack"]
      txt_digi_de2.text = selected_digi.defense
      txt_digi_sp_de2.text = selected_digi["sp.defense"]
      txt_digi_np2.text = string.format("%.2f", (
        (selected_digi.attack/selected_digi.level)-selected_base.attack +
        (selected_digi["sp.attack"]/selected_digi.level)-selected_base["sp.attack"]+
        (selected_digi.defense/selected_digi.level)-selected_base.defense+
        (selected_digi["sp.defense"]/selected_digi.level)-selected_base["sp.defense"]
      )/4)
      ObjHandler:addObj(txt_digi_name)
      ObjHandler:addObj(txt_digi_hp1)
      ObjHandler:addObj(txt_digi_hp2)
      ObjHandler:addObj(txt_digi_lvl1)
      ObjHandler:addObj(txt_digi_lvl2)
      ObjHandler:addObj(txt_digi_at1)
      ObjHandler:addObj(txt_digi_at2)
      ObjHandler:addObj(txt_digi_sp_at1)
      ObjHandler:addObj(txt_digi_sp_at2)
      ObjHandler:addObj(txt_digi_de1)
      ObjHandler:addObj(txt_digi_de2)
      ObjHandler:addObj(txt_digi_sp_de1)
      ObjHandler:addObj(txt_digi_sp_de2)
      ObjHandler:addObj(txt_digi_np1)
      ObjHandler:addObj(txt_digi_np2)
    end
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

  txt_digi_name = Gui.base.Text{
    x=(GS.width)/2 - (btn_w*3)/2,
    y=(GS.height)/2 - (btn_h *3+btn_pad*2) - (btn_h+btn_pad), 
    w=btn_w*3, h=txt_h,
  }
  txt_digi_hp1 = Gui.base.Text{
    x=(GS.width)/2 - ((btn_w+txt_w)*3+btn_pad*2)/2, 
    y=(GS.height)/2 - (btn_h *3+btn_pad*2), 
    w=txt_w, h=txt_h,
    text = "HP"
  }
  txt_digi_hp2 = Gui.base.Text{
    x=(GS.width)/2 - ((btn_w+txt_w)*3+btn_pad*2)/2 + txt_w,
    y=(GS.height)/2 - (btn_h *3+btn_pad*2), 
    w=btn_w, h=btn_h
  }
  txt_digi_lvl1 = Gui.base.Text{
    x = (GS.width)/2 - ((btn_w+txt_w)*3+btn_pad*2)/2 + (btn_w+txt_w+btn_pad), 
    y=(GS.height)/2 - (btn_h *3+btn_pad*2), 
    w=txt_w, h=txt_h,
    text = "LVL"
  }
  txt_digi_lvl2 = Gui.base.Text{
    x=(GS.width)/2 - ((btn_w+txt_w)*3+btn_pad*2)/2 + (btn_w+txt_w+btn_pad) +txt_w,
    y=(GS.height)/2 - (btn_h *3+btn_pad*2), 
    w=btn_w, h=btn_h,
  }
  txt_digi_at1 = Gui.base.Text{
    x = (GS.width)/2 - ((btn_w+txt_w)*3+btn_pad*2)/2 + (btn_w+txt_w+btn_pad)*2, 
    y=(GS.height)/2 - (btn_h *3+btn_pad*2), 
    w=txt_w, h=txt_h,
    text = "AT"
  }
  txt_digi_at2 = Gui.base.Text{
    x=(GS.width)/2 - ((btn_w+txt_w)*3+btn_pad*2)/2 + (btn_w+txt_w+btn_pad)*2 +txt_w,
    y=(GS.height)/2 - (btn_h *3+btn_pad*2), 
    w=btn_w, h=btn_h,
  }
  txt_digi_sp_at1 = Gui.base.Text{
    x = (GS.width)/2 - ((btn_w+txt_w)*3+btn_pad*2)/2, 
    y=(GS.height)/2 - (btn_h*3+btn_pad*2)+(btn_h+btn_pad), 
    w=txt_w, h=txt_h,
    text = "Sp.At"
  }
  txt_digi_sp_at2 = Gui.base.Text{
    x=(GS.width)/2 - ((btn_w+txt_w)*3+btn_pad*2)/2+txt_w,
    y=(GS.height)/2 - (btn_h*3+btn_pad*2)+(btn_h+btn_pad), 
    w=btn_w, h=btn_h,
  }
  txt_digi_de1 = Gui.base.Text{
    x = (GS.width)/2 - ((btn_w+txt_w)*3+btn_pad*2)/2+(btn_w+txt_w+btn_pad), 
    y=(GS.height)/2 - (btn_h*3+btn_pad*2)+(btn_h+btn_pad), 
    w=txt_w, h=txt_h,
    text = "DE"
  }
  txt_digi_de2 = Gui.base.Text{
    x=(GS.width)/2 - ((btn_w+txt_w)*3+btn_pad*2)/2+(btn_w+txt_w+btn_pad)+txt_w,
    y=(GS.height)/2 - (btn_h*3+btn_pad*2)+(btn_h+btn_pad), 
    w=btn_w, h=btn_h,
  }
  txt_digi_sp_de1 = Gui.base.Text{
    x = (GS.width)/2 - ((btn_w+txt_w)*3+btn_pad*2)/2+(btn_w+txt_w+btn_pad)*2, 
    y=(GS.height)/2 - (btn_h*3+btn_pad*2)+(btn_h+btn_pad), 
    w=txt_w, h=txt_h,
    text = "Sp.De"
  }
  txt_digi_sp_de2 = Gui.base.Text{
    x=(GS.width)/2 - ((btn_w+txt_w)*3+btn_pad*2)/2+(btn_w+txt_w+btn_pad)*2+txt_w,
    y=(GS.height)/2 - (btn_h*3+btn_pad*2)+(btn_h+btn_pad), 
    w=btn_w, h=btn_h,
  }
  txt_digi_np1 = Gui.base.Text{
    x = (GS.width)/2 - ((btn_w+txt_w)*3+btn_pad*2)/2+(btn_w+txt_w+btn_pad)*0, 
    y=(GS.height)/2 - (btn_h*3+btn_pad*2)+(btn_h+btn_pad)*2, 
    w=txt_w, h=txt_h,
    text = "NP"
  }
  txt_digi_np2 = Gui.base.Text{
    x=(GS.width)/2 - ((btn_w+txt_w)*3+btn_pad*2)/2+(btn_w+txt_w+btn_pad)*0+txt_w,
    y=(GS.height)/2 - (btn_h*3+btn_pad*2)+(btn_h+btn_pad)*2, 
    w=btn_w, h=btn_h,
  }
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
