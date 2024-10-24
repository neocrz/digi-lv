local OH = Classic:extend()
function OH:new()
  self.layers = {}
  self.default_layer = 2
  self.layers[1] = { count = 0, actual_key = 0, objs = {} }
  self.layers[self.default_layer] = { count = 0, actual_key = 0, objs = {} }
end

function OH:addLayer(n)
  local name = n or nil
  if name then
    self.layers[name] = { count = 0, actual_key = 0, objs = {} }
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
    self.layers[name] = { count = 0, actual_key = 0, objs = {} }
  end
end

function OH:addObj(obj, layerName)
  local layerName = layerName or self.default_layer
  local key = 0
  if layerName and self.layers[layerName] then
    -- incremento de elemento
    key = self.layers[layerName].actual_key + 1
    -- salvando q quantidade
    self.layers[layerName].actual_key = key
    -- adicionando o novo elemento no index
    self.layers[layerName]["objs"][key] = obj

    self.layers[layerName].count = self.layers[layerName].count + 1
  end
  return key
end

function OH:rmObj(key, layerName)
  local layerName = layerName or self.default_layer
  if layerName and self.layers[layerName] then
    if self.layers[layerName]["objs"][key] then
      -- remove
      self.layers[layerName]["objs"][key] = nil
      -- diminui o count
      self.layers[layerName].count = self.layers[layerName].count - 1
    else
      return false
    end
  end
  return true
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
