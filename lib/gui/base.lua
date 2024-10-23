local _={}
_.Point = Classic:extend()

function _.Point:new(t)
  self.x = t.x or 0
  self.y = t.y or 0
end

_.Rect = _.Point:extend()

function _.Rect:new(t)
  _.Rect.super.new(self, t)
  self.w = w or 0
  self.h = h or 0
end

_.Circ = _.Point:extend()

function _.Circ:new(t)
  _.Circ.super.new(self, t)
  self.r = r or 0
end

return _