local _ = {}
local default_color = { 1, 1, 1, 1 }
local default_font = love.graphics.getFont()
local _t = {}
_t.r, _t.g, _t.b, _t.a = love.graphics.getColor()
local external_color = { _t.r, _t.g, _t.b, _t.a }

_.Point = Classic:extend()

function _.Point:new(t)
  local t = t or {}
  self.x = t.x or 0
  self.y = t.y or 0
end

_.Rect = _.Point:extend()

function _.Rect:new(t)
  local t = t or {}
  _.Rect.super.new(self, t)
  self.w = t.w or 0
  self.h = t.h or 0
end

_.Circ = _.Point:extend()

function _.Circ:new(t)
  local t = t or {}
  _.Circ.super.new(self, t)
  self.r = t.r or 0
end

_.Text = _.Rect:extend()
function _.Text:new(t)
  local t = t or {}
  _.Text.super.new(self, t)
  self.text = t.text or ""
  self.mode = "line"
  self.color = t.color or default_color
  self.font = t.color or default_font
end

function _.Text:draw()
  love.graphics.setColor(unpack(self.color))
  love.graphics.rectangle(                                -- rectangle
    self.mode,
    self.x, self.y,
    self.w, self.h
  )
  love.graphics.print(
    self.text,
    self.x + (self.w / 2) - (self.font:getWidth(self.text) / 2),
    self.y + (self.h / 2) - (self.font:getHeight(self.text) / 2)
  )
  love.graphics.setColor(unpack(external_color))
end


return _
