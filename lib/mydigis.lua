local _ = Classic:extend() -- new: generate rows and lines

function _:new(boxes)
  self.boxes = boxes or nil
  self.selected = nil
  if not self.boxes then
    self.boxes = {}
    for i = 1, 12 do
      table.insert(self.boxes, i, {})
      for j = 1, 6 do
        table.insert(self.boxes[i], j, {})
      end
    end
  end
end

function _:addDigi(box, line, row, digi)
  local box = tonumber(box)
  local line = tonumber(line)
  local row = tonumber(row)
  local t = digi or {}
  local d = {}
  d.key = t.key
  d.name = t.name or nil
  d.level = t.level or nil
  d.stage = t.stage or nil
  d.species = t.Species or nil
  d.attribute = t.attribute or nil
  d.element = t.element or nil
  d.hp =  t.hp or nil
  d.attack = t.attack or nil
  d["sp.attack"] = t["sp.attack"] or nil
  d.defense = t.defense or nil
  d["sp.defense"] = t["sp.defense"] or nil
  d.spirit = t.spirit or nil
  d.box = box
  d.line = line
  d.row = row

  self.boxes[line][row] = d
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
  if digi then
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
  return true, "success"
end

return _
