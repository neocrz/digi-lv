local _    = Classic:extend()

function _:new(t)
    local t = t or {}
    self.text = t.text or ""
    self.font = t.font or love.graphics.getFont()
    self.x = t.x or 0
    self.y = t.y or 0
    self.w = t.w or 0
    self.h = t.h or 0
    self.action = t.action or nil
end

function _:draw()
    love.graphics.setColor(0,0,0,0.75)
    love.graphics.rectangle("fill",0,0,GS.width, GS.height)
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle(                                
      "line",
      self.x, self.y,
      self.w, self.h
    )
    love.graphics.print(
      self.text,
      self.x + (self.w / 2) - (self.font:getWidth(self.text) / 2),
      self.y + (self.h / 2) - (self.font:getHeight(self.text) / 2)
    )
end
function _:touchpressed(...)
    if self.action then self.action(self) end
end
function _:mousepressed(...)
    if self.action then self.action(self) end
end


function _:keypressed(...)
    if self.action then self.action(self) end
end

return _