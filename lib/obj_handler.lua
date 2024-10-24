local OH = Classic:extend()
function OH:new()
  self.layers = {}
  self.default_layer = 2
  self.layers[1] = { count = 0, objs = {} }
  self.layers[self.default_layer] = { count = 0, objs = {} }
end

function OH:addLayer(n)
  local name = n or nil
  if name then
    self.layers[name] = { count = 0, objs = {} }
  end
end

function OH:rmLayer(n)
  local name = n or nil
  if name and self.layers[name] then
    self.layers[name] = nil
  end
end

function OH:clearLayer(n)
  local name = n or nil
  if name and self.layers[name] then
    self.layers[name] = nil
    self.layers[name] = { count = 0, objs = {} }
  end
end

function OH:addObj(obj, layer)
  local layer = layer or self.default_layer
  
  if not self.layers[layer] then
    self:addLayer(layer)
  end
  self.layers[layer]["objs"][obj] = obj
  self.layers[layer].count = self.layers[layer].count + 1
  obj._OH_layer = layer
end

function OH:rmObj(obj)
  local layer = obj._OH_layer or self.default_layer
  
  if self.layers[layer] then
    self.layers[layer]["objs"][obj] = nil
    self.layers[layer].count = self.layers[layer].count - 1
  end
  
  obj._OH_layer = nil
  return true
end

function OH:mvObj(obj, newLayer)
  if not self:objExist(obj) then
    return false
  end
  local newLayer = newLayer or self.default_layer
  self:rmObj(obj)
  self:addObj(obj,newLayer)
end

function OH:objExist(obj)
  local layer = obj._OH_layer or self.default_layer
  if self.layers[layer]["objs"][obj] then
    return true
  end
  return false
end

function OH:update(dt)
  for k_l, layer in pairs(self.layers) do
    for k_o, obj in pairs(layer.objs) do
      if obj.update then obj:update(dt) end
    end
  end
end

function OH:draw()
  for k_l, layer in pairs(self.layers) do
    for k_o, obj in pairs(layer.objs) do
      if obj.draw then obj:draw() end
    end
  end
end

function OH:touchmoved(id, x, y, dx, dy, pressure)
  for k_l, layer in pairs(self.layers) do
    for k_o, obj in pairs(layer.objs) do
      if obj.touchmoved then obj:touchmoved(id, x, y, dx, dy, pressure) end
    end
  end
end

function OH:touchpressed(id, x, y, dx, dy, pressure)
  for k_l, layer in pairs(self.layers) do
    for k_o, obj in pairs(layer.objs) do
      if obj.touchpressed then obj:touchpressed(id, x, y, dx, dy, pressure) end
    end
  end
end

function OH:touchreleased(id, x, y, dx, dy, pressure)
  for k_l, layer in pairs(self.layers) do
    for k_o, obj in pairs(layer.objs) do
      if obj.touchreleased then obj:touchreleased(id, x, y, dx, dy, pressure) end
    end
  end
end

function OH:mousereleased(x, y, button, istouch, presses)
  for k_l, layer in pairs(self.layers) do
    for k_o, obj in pairs(layer.objs) do
      if obj.mousereleased then obj:mousereleased(x, y, button, istouch, presses) end
    end
  end
end

function OH:mousemoved(x, y, dx, dy, istouch)
  for k_l, layer in pairs(self.layers) do
    for k_o, obj in pairs(layer.objs) do
      if obj.mousemoved then obj:mousemoved(x, y, dx, dy, istouch) end
    end
  end
end

function OH:mousepressed( x, y, button, istouch, presses )
  for k_l, layer in pairs(self.layers) do
    for k_o, obj in pairs(layer.objs) do
      if obj.mousepressed then obj:mousepressed( x, y, button, istouch, presses ) end
    end
  end
end
function OH:textinput(t)
  for k_l, layer in pairs(self.layers) do
    for k_o, obj in pairs(layer.objs) do
      if obj.textinput then obj:textinput(t) end
    end
  end
end

function OH:keypressed(key)
  for k_l, layer in pairs(self.layers) do
    for k_o, obj in pairs(layer.objs) do
      if obj.keypressed then obj:keypressed(key) end
    end
  end
end
function OH:wheelmoved(x,y)
  for k_l, layer in pairs(self.layers) do
    for k_o, obj in pairs(layer.objs) do
      if obj.wheelmoved then obj:wheelmoved(x,y) end
    end
  end
end



return OH
