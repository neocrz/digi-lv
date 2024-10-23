local _ = {}
local path = (...):match("(.-)[^%.]+$")
local col  = require(path .. "collision")

_.Box = Classic:extend()
_.Vbox = _.Box:extend()

function _.Box:new(t)
  local t = t or {}
  self.x = t.x or 0
  self.y = t.y or 0
  self.w = t.w or 0
  self.h = t.h or 0
  self.mode = t.mode or nil
  t.padding = t.padding or {}

  self.padding = {
    h = t.padding.h or 0,
  }
  self.objs = t.objs or {}
  self.objsD = {}
end

function _.Vbox:new(t)
  local t = t or {}
  _.Vbox.super.new(self, t)
  self:setSizes()
end

function _.Vbox:setSizes()
  local objs_amount = #self.objs
  local pad_amount  = objs_amount - 1
  local base_x      = self.x
  local base_y      = self.y

  self.obj_h        = (self.h - (pad_amount * self.padding.h)) / objs_amount



  for k, obj in pairs(self.objs) do
    obj.w = self.w
    obj.h = self.obj_h
    obj.x = base_x
    obj.y = base_y
    table.insert(self.objsD, obj)
    obj.box_index = k
    base_y = base_y + obj.h
    table.insert(self.objsD, { x = base_x, y = base_y, w = self.w, h = self.padding.h })
    base_y = base_y + self.padding.h
  end
  table.remove(self.objsD)
  self.last_objD = #self.objsD
end

_.List = _.Box:extend()

function _.List:new(t)
  local t = t or {}
  _.List.super.new(self, t)
  self.obj_h = t.obj_h or 40
  self.ref_x = 0
  self.ref_y = 0
  self:setSizes()
end

function _.List:setSizes()
  local objs_amount = #self.objs
  local pad_amount  = objs_amount - 1
  local base_x      = self.x
  local base_y      = self.y

  for k, obj in pairs(self.objs) do
    obj.w = self.w
    obj.h = self.obj_h
    obj.x = base_x
    obj.y = base_y
    table.insert(self.objsD, obj)
    obj.box_index = k
    base_y = base_y + obj.h
    table.insert(self.objsD, { x = base_x, y = base_y, w = self.w, h = self.padding.h })
    base_y = base_y + self.padding.h
  end
  table.remove(self.objsD)
  self.last_objD = #self.objsD
end

function _.List:moveRef(dy)
  self.ref_y = self.ref_y + dy

  for k, v in pairs(self.objsD) do
    v.y = v.y + dy
  end
end

function _.List:touchpressed(id, x, y, dx, dy, pressure)
  if col.Rect({ x = x, y = y }, { x = self.x, y = self.y, w = self.w, h = self.h }) then
    self:moveRef(dy)
  end
  for k, obj in pairs(self.objsD) do
    if obj.touchpressed then obj:touchpressed(id, x, y, dx, dy, pressure) end
  end
end

function _.List:touchmoved(id, x, y, dx, dy, pressure)
  for k, obj in pairs(self.objsD) do
    if obj.touchmoved then obj:touchmoved(id, x, y, dx, dy, pressure) end
  end
end

function _.List:mousemoved(x, y, dx, dy, istouch)
  if self.mouse_pressed then
    self:moveRef(dy)
  end
  for k, obj in pairs(self.objsD) do
    if obj.mousemoved then obj:mousemoved(x, y, dx, dy, istouch) end
  end
end

function _.List:mousepressed( x, y, button, istouch, presses )
  if col.Rect({ x = x, y = y }, { x = self.x, y = self.y, w = self.w, h = self.h }) then
    self.mouse_pressed = true
  end
  for k, obj in pairs(self.objsD) do
    if obj.mousepressed then obj:mousepressed( x, y, button, istouch, presses ) end
  end
end

function _.List:mousereleased(x, y, button, istouch, presses)
  self.mouse_pressed = false
  for k, obj in pairs(self.objsD) do
    if obj.mousereleased then obj:mousereleased(x, y, button, istouch, presses) end
  end
end

function _.Box:rmObj(obj)
  table.remove(self.objs, obj.box_index)
  self:setSizes()
end

function _.Box:draw()
  love.graphics.setScissor(self.x - 1, self.y - 1, self.w + 3, self.h + 3)

  for k, obj in pairs(self.objsD) do
    if obj.draw then obj:draw() end
  end
  love.graphics.setScissor()
  if self.mode then
    love.graphics.rectangle(self.mode, self.x - 1, self.y - 1, self.w + 3, self.h + 3)
  end
end





function _.Box:update(dt)
  for k, obj in pairs(self.objsD) do
    if obj.update then obj:update(dt) end
  end
end

function _.Box:touchpressed(id, x, y, dx, dy, pressure)
  for k, obj in pairs(self.objsD) do
    if obj.touchpressed then obj:touchpressed(id, x, y, dx, dy, pressure) end
  end
end

function _.Box:touchmoved(id, x, y, dx, dy, pressure)
  for k, obj in pairs(self.objsD) do
    if obj.touchmoved then obj:touchmoved(id, x, y, dx, dy, pressure) end
  end
end

function _.Box:touchreleased(id, x, y, dx, dy, pressure)
  for k, obj in pairs(self.objsD) do
    if obj.touchreleased then obj:touchreleased(id, x, y, dx, dy, pressure) end
  end
end

function _.Box:mousereleased(x, y, button, istouch, presses)
  for k, obj in pairs(self.objsD) do
    if obj.mousereleased then obj:mousereleased(x, y, button, istouch, presses) end
  end
end

function _.Box:mousemoved(x, y, dx, dy, istouch)
  for k, obj in pairs(self.objsD) do
    if obj.mousemoved then obj:mousemoved(x, y, dx, dy, istouch) end
  end
end

function _.Box:mousepressed( x, y, button, istouch, presses )
  for k, obj in pairs(self.objsD) do
    if obj.mousepressed then obj:mousepressed( x, y, button, istouch, presses ) end
  end
end

return _
