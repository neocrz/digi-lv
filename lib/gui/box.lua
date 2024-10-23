local _ = {}

_.Box = Classic:extend()
_.Vbox = _.Box:extend()

function _.Box:new(t)
    local t = t or {}
    self.x = t.x or 0
    self.y = t.y or 0
    self.w = t.w or 0
    self.h = t.h or 0
    t.padding = t.padding or {}

    self.padding = {
        h = t.padding.h or 0,
    }
    self.objs = t.objs or {}
end

function _.Vbox:new(t)
    local t = t or {}
    _.Vbox.super.new(self, t)
    self:setSizes()
end

function _.Vbox:setSizes()
    local objs_amount = #self.objs
    local pad_amount  = objs_amount - 1
    local base_x = self.x
    local base_y = self.y

    self.obj_h = (self.h -(pad_amount * self.padding.h))/objs_amount

    self.objsD = {}

    for k,obj in pairs(self.objs) do
        obj.w = self.w
        obj.h = self.obj_h
        obj.x = base_x
        obj.y = base_y
        table.insert(self.objsD, obj)
        obj._vbox_index = k
        base_y = base_y + obj.h
        table.insert(self.objsD, {x=base_x, y=base_y, w=self.w, h = self.padding.h})
        base_y = base_y + self.padding.h
    end
    table.remove(self.objsD)
end

_.Grid = _.Box:extend()

function _.Grid:new(t)
    local t = t or {}
    _.Vbox.super.new(self, t)
end


function _.Box:rmObj(obj)
    table.remove(self.objs, obj._vbox_index)
    self:setSizes()
end

function _.Box:draw()
    for k,obj in pairs(self.objsD) do
        if obj.draw then obj:draw() end
    end
end

function _.Box:update(dt)
    for k,obj in pairs(self.objsD) do
        if obj.update then obj:update(dt) end
    end
end

function _.Box:touchpressed(id, x, y, dx, dy, pressure)
    for k,obj in pairs(self.objsD) do
        if obj.touchpressed then obj:touchpressed(id, x, y, dx, dy, pressure) end
    end
end

function _.Box:touchmoved(id, x, y, dx, dy, pressure)
    for k,obj in pairs(self.objsD) do
        if obj.touchmoved then obj:touchmoved(id, x, y, dx, dy, pressure) end
    end
end

function _.Box:touchreleased(id, x, y, dx, dy, pressure)
    for k,obj in pairs(self.objsD) do
        if obj.touchreleased then obj:touchreleased(id, x, y, dx, dy, pressure) end
    end
end

function _.Box:mousereleased( x, y, button, istouch, presses)
    for k,obj in pairs(self.objsD) do
        if obj.mousereleased then obj:mousereleased( x, y, button, istouch, presses) end
    end
end

function _.Box:mousemoved( x, y, dx, dy, istouch )
    for k,obj in pairs(self.objsD) do
        if obj.mousemoved then obj:mousemoved( x, y, dx, dy, istouch ) end
    end
end

return _