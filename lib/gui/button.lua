local path  = (...):match("(.-)[^%.]+$")
local _ = {}
local col = require(path .. "collision")


local default_font = love.graphics.getFont() -- default font
local default_color = { 0.7, 0.7, 0.7, 1 } 

local Button = Classic:extend()

function Button:new(t)
    local t = t or {}
    local _t = {}
    self.x = t.x or 0
    self.y = t.y or 0
    self.font = default_font

    -- temp tables
    _t.inactive = t.inactive or {}
    _t.inactive.text = _t.inactive.text or {}
    -- inactive style
    self.inactive = {}
    self.inactive.color = _t.inactive.color or default_color
    self.inactive.mode = _t.inactive.mode or "line"
    self.inactive.text = {
        font = _t.inactive.text.font or default_font,
        color = _t.inactive.text.color or default_color,
        text = _t.inactive.text.text or ""
    }
    -- temp tables
    _t.active = t.active or {}
    _t.active.text = _t.active.text or {}
    -- active style
    self.active = {}
    self.active.color = _t.active.color or self.inactive.color
    self.active.mode = _t.active.mode or "fill"
    self.active.text = {
        -- follow the inactive style if nil
        font = _t.active.text.font or self.inactive.text.font,  
        color = _t.active.text.color or self.inactive.text.color,
        text = _t.active.text.text or self.inactive.text.text
    }
    -- external default color
    _t.r, _t.g, _t.b, _t.a = love.graphics.getColor()
    self.external_color = { _t.r, _t.g, _t.b, _t.a }

    _t.action = t.action or {} --temp
    self.action = {}
    self.action.pressed = _t.action.pressed or nil
    self.action.released = _t.action.released or nil
    self.action.hover = _t.action.hover or nil
    self.action.out = _t.action.out or nil

end

function Button:destroy()
end


_.Rect = Button:extend()
function _.Rect:new(t)
    local t = t or {}
    local _t = {} -- temp table
    _.Rect.super.new(self, t)
    self.w = t.w or 0
    self.h = t.h or 0

    -- temp tables
    _t.draw_state = t.draw_state or {}
    -- drawing states
    self.draw_state = {}
    self.draw_state.inactive = _t.draw_state.inactive or function(self)
        love.graphics.setColor(unpack(self.inactive.color)) -- color
        love.graphics.rectangle( -- rectangle
            self.inactive.mode,
            self.x, self.y,
            self.w, self.h
        )
        -- text
        love.graphics.setColor(unpack(self.inactive.text.color))
        love.graphics.print(
            self.inactive.text.text,
            self.x + (self.w / 2) - (self.inactive.text.font:getWidth(self.inactive.text.text) / 2),
            self.y + (self.h / 2) - (self.inactive.text.font:getHeight(self.inactive.text.text) / 2)
        )
        -- return to default
        love.graphics.setColor(unpack(self.external_color))
    end

    self.draw_state.active = _t.draw_state.active or function(self) -- Active draw
        -- Button Color
        love.graphics.setColor(unpack(self.active.color))
        love.graphics.rectangle(
            self.active.mode,
            self.x, self.y,
            self.w, self.h
        )
        -- Text Color
        love.graphics.setColor(unpack(self.active.text.color))
        love.graphics.print(
            self.active.text.text,
            self.x + (self.w / 2) - (self.active.text.font:getWidth(self.active.text.text) / 2),
            self.y + (self.h / 2) - (self.active.text.font:getHeight(self.active.text.text) / 2)
        )

        -- Return ambient color
        love.graphics.setColor(unpack(self.external_color))
    end

    self.draw = self.draw_state.inactive
end

function _.Rect:update(dt)
    local touches = love.touch.getTouches()
    local mouseX, mouseY = love.mouse.getPosition()
    if touches[1] then
        local tch = function()
            for i, id in ipairs(touches) do
                
                local tx, ty = love.touch.getPosition(id)
                if (tx == mouseX and ty == mouseY) then print("test") end
                if col.Rect({ x = tx, y = ty }, { x = self.x, y = self.y, w = self.w, h = self.h }) then
                    self.draw = self.draw_state.active
                    if self.action.hover then self.action.hover(self) end
                    return
                end
                ::continue_touches::
            end
            self.draw = self.draw_state.inactive
            if self.action.out then self.action.out(self) end
        end
        tch()
    else if col.Rect({ x = mouseX, y = mouseY }, { x = self.x, y = self.y, w = self.w, h = self.h }) then
    else
        self.draw = self.draw_state.inactive
        if self.action.out then self.action.out(self) end
        end
    end
end

function _.Rect:touchpressed(id, x, y, dx, dy, pressure)
    if col.Rect({ x = x, y = y }, { x = self.x, y = self.y, w = self.w, h = self.h }) then
        if self.action.pressed then self.action.pressed(self) end
    end
end

function _.Rect:touchmoved(id, x, y, dx, dy, pressure) end

function _.Rect:touchreleased(id, x, y, dx, dy, pressure)
    if col.Rect({ x = x, y = y }, { x = self.x, y = self.y, w = self.w, h = self.h }) then
        if self.action.released then self.action.released(self) end
    end
end

function _.Rect:mousereleased( x, y, button, istouch, presses)
    if istouch then return end
    if col.Rect({ x = x, y = y }, { x = self.x, y = self.y, w = self.w, h = self.h }) then
        if self.action.released then self.action.released(self) end
    end
end

function _.Rect:mousemoved( x, y, dx, dy, istouch )
    
    if istouch then return end
    
    if col.Rect({ x = x, y = y }, { x = self.x, y = self.y, w = self.w, h = self.h }) then
        self.draw = self.draw_state.active
        if self.action.hover then self.action.hover(self) end
        return
    else
        self.draw = self.draw_state.inactive
        if self.action.out then self.action.out(self) end
    end
end

return _