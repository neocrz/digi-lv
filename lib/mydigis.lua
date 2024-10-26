local _ = Classic:extend() -- new: generate rows and lines

function _:new(boxes)
  self.boxes = boxes or nil
  if not self.boxes then
    local saved_boxes, _l = love.filesystem.load("digi_boxes.lua")()
    self.boxes = saved_boxes
  end
  self.selected = nil
  if not self.boxes then
    self.boxes = {}
    for i = 1, 12 do
      table.insert(self.boxes, i, {})
      for j = 1, 6 do
        table.insert(self.boxes[i], j, {})
        for k = 1, 10 do
          table.insert(self.boxes[i][j], k, {})
        end
      end
    end
  end
end

function _:saveBoxes()
  str = Ser(self.boxes)
  love.filesystem.write("digi_boxes.lua", str)
end

function _:addDigi(box, line, row, digi)
  local box = tonumber(box)
  local line = tonumber(line)
  local row = tonumber(row)
  local t = digi or {}
  local d = {}
  d.key = t.key
  d.level = t.level or nil
  
  d.hp =  t.hp or nil
  d.attack = t.attack or nil
  d["sp.attack"] = t["sp.attack"] or nil
  d.defense = t.defense or nil
  d["sp.defense"] = t["sp.defense"] or nil
  -- d.box = box
  -- d.line = line
  -- d.row = row
  self.boxes[box][line][row] = d
  self:saveBoxes()
end

function _:getDigi(box, line, row)
  local box = tonumber(box)
  local line = tonumber(line)
  local row = tonumber(row)
  if not (box and line and row) then
    return false, "Indexes are not valid numbers"
  end
  if (box > 13) or (box < 1) 
  or (line > 6) or (line < 1)
  or (row >10) or (row < 1)
  then
    return false, "Invalid indexes"
  end
  
  digi = self.boxes[box][line][row]
  
  if digi and digi.key then
    return digi, "success"
  else
    return false, "No digi in this position"
  end
end

function _:rmDigi(box, line, row)
  local box = tonumber(box)
  local line = tonumber(line)
  local row = tonumber(row)
  if not (box and line and row) then
    return false, "Indexes are not valid numbers"
  end
  if (box > 13) or (box < 1) 
  or (line > 6) or (line < 1)
  or (row >10) or (row < 1)
  then
    return false, "Invalid indexes"
  end

  self.boxes[box][line][row] = nil
  self:saveBoxes()
  return true, "success"
end

return _
