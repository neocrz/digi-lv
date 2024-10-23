local path = (...):match("(.-)[^%.]+$")

local _ = require(path.."button").Rect:extend()
local utf8 = require("utf8")

function _:new(t)
  local t = t or {}
  _.super.new(self, t)
  self.input = ""
  self.kb_activated = false
  self.placeholder = {
    inactive = self.inactive.text.text,
    active = self.active.text.text,
  }

  self.action.released = function (self)
    self.kb_activated = true
    love.keyboard.setTextInput(true)
    self.inactive.text.text = ""
  end
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
    self.kb_activated = false
    self.input = self.inactive.text.text
    self.inactive.text.text = self.placeholder.inactive
    self.active.text.text = self.placeholder.active
    if CONF.mobile then love.keyboard.setTextInput(false) end
  end
end

return _