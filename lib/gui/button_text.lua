local path = (...):match("(.-)[^%.]+$")

local _ = require(path.."button").Rect:extend()
local utf8 = require("utf8")

function _:new(t)
  local t = t or {}
  _.super.new(self, t)
  self.input = ""
  self.keep_input = t.keep_input or false
  self.OH_ref = t.OH_ref or nil
  self.kb_activated = false
  self.placeholder = {
    inactive = self.inactive.text.text,
    active = self.active.text.text,
  }
  self.def = {}

  self.action.released = function (self)
    self.kb_activated = true
    love.keyboard.setTextInput(true)
    self.inactive.text.text = ""
    self.def.pos = {x=self.x, y=self.y, w=self.w, h=self.h}
    self.def.draw = self.to_draw
    self.draw = self.focus_draw
    if self.OH_ref then 
      self.OH_ref:mvObj(self,10)
    end
    self.x = 20
    self.y = 40
    self.w = GS.width - 40
    --CONF.blank = self
  end
  local _t = t.action or {}
  self.action.input = _t.input or nil
end

function _:focus_draw()
  
  love.graphics.setColor(0,0,0,0.75)
  love.graphics.rectangle("fill",0,0,GS.width,GS.height)
  love.graphics.setColor(1,1,1,1)
  self:to_draw()
  
end

function _:textinput(t)
  if self.kb_activated then
    self.inactive.text.text = self.inactive.text.text .. t
    self.active.text.text = self.inactive.text.text
  end
end
--[[
local upd = _.update

function _:update(dt)
  upd(self, dt)
end
--]]
function _:keypressed(key)
  if key == "backspace" and self.kb_activated then
      -- get the byte offset to the last UTF-8 character in the string.
      local byteoffset = utf8.offset(self.inactive.text.text, -1)

      if byteoffset then
          -- remove the last UTF-8 character.
          -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
          self.inactive.text.text = string.sub(self.inactive.text.text, 1, byteoffset - 1)
      end
  end

  if key == "backspace" and self.kb_activated then
    -- get the byte offset to the last UTF-8 character in the string.
    local byteoffset = utf8.offset(self.inactive.text.text, -1)

    if byteoffset then
      -- remove the last UTF-8 character.
      -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
      self.inactive.text.text = string.sub(self.inactive.text.text, 1, byteoffset - 1)
      self.active.text.text = self.inactive.text.text
    end
  end
  if key == "return" and self.kb_activated then
    if self.OH_ref then 
    self.OH_ref:mvObj(self)
    end
    self.x = self.def.pos.x
    self.y = self.def.pos.y
    self.w = self.def.pos.w
    self.def.pos = nil
    self.def.draw = self.to_draw
    self.draw = self.to_draw
    self.kb_activated = false
    self.input = self.inactive.text.text
    if not self.keep_input then
      self.inactive.text.text = self.placeholder.inactive
    self.active.text.text = self.placeholder.active
    end
    
    if CONF.mobile then love.keyboard.setTextInput(false) end
    if self.action.input then self.action.input(self) end
  end
end



return _