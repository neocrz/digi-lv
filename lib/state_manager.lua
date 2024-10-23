-- state_manager.lua
local _ = {}
_.states = {}
_.current = nil

function _:addState(name, state)
    self.states[name] = state
end

function _:switch(name, ...)
    if self.states[name] then
        if self.current and self.current.exit then
            self.current:exit()
        end
        self.current = self.states[name]
        if self.current and self.current.enter then
            self.current:enter(...)
        end
    else
        error("State " .. name .. " does not exist.")
    end
end

function _:update(dt)
    if self.current.update then
        self.current:update(dt)
    end
end

function _:draw()
    if self.current.draw then
        self.current:draw()
    end
end

function _:touchmoved(id, x, y, dx, dy, pressure)
    if self.current.touchmoved then
        self.current:touchmoved(id, x, y, dx, dy, pressure)
    end
end

function _:touchpressed(id, x, y, dx, dy, pressure)
    if self.current.touchpressed then
        self.current:touchpressed(id, x, y, dx, dy, pressure)
    end
end

function _:touchreleased(id, x, y, dx, dy, pressure)
    if self.current.touchreleased then
        self.current:touchreleased(id, x, y, dx, dy, pressure)
    end
end

function _:mousereleased(x, y, button, istouch, presses)
    if self.current.mousereleased then
        self.current:mousereleased(x, y, button, istouch, presses)
    end
end

function _:mousemoved(x, y, dx, dy, istouch)
    if self.current.mousemoved then
        self.current:mousemoved(x, y, dx, dy, istouch)
    end
end

return _
