
local _ = Classic:extend() -- base status and evolutions.
function _:new()
  -- dv_to[i][j] -> [i] evolves to [j] digimon
  -- dv_from[i][j] -> [i] evolves from [j] digimon
  -- digis -> digis information

  self.savefile = "digi_catalog.lua"
  local dg_cat, _msg = love.filesystem.load(self.savefile)
  if dg_cat then
    dg_cat=dg_cat()
    self.digis = dg_cat.digis 
    self.dv_to = dg_cat.dv_to
    self.dv_from = dg_cat.dv_to
  else
    dg_cat = require("data.digi_catalog")
    self.digis = dg_cat.digis
    self.dv_to = dg_cat.dv_to
    self.dv_from = dg_cat.dv_from
  end
  self:save()
end

function _:save()
  local dg_cat = {
    digis=self.digis,
    
    dv_to=self.dv_to,
    dv_from=self.dv_from,
  }
  str = Ser(dg_cat)
  love.filesystem.write(self.savefile, str)
end

function _:addDigi(t)
  local t = t or {}
  local d = {}
  d.key = t.key
  d.name = t.Name or t.name or nil
  d.stage = t.Stage or t.stage or nil
  d.species = t.species or t.Species or nil
  d.attribute = t.Attribute or t.attribute or nil
  d.element = t.Element or t.element or nil
  d.hp = t.HP or t.hp or nil
  d.attack = t.Attack or t.attack or nil
  d["sp.attack"] = t["Sp.Attack"] or t["sp.attack"] or nil
  d.defense = t.Defense or t.defense or nil
  d["sp.defense"] = t["Sp.Defense"] or t["sp.defense"] or nil
  d.spirit = t.Spirit or t.spirit or nil

  self.digis[d.key] = d
  self:save()
end

function _:addDv(from, to, conditions)
  if not self.dv_to[from] then
    self.dv_to[from] = {}
  end
  self.dv_to[from][to]=conditions

  if not self.dv_from[to] then
    self.dv_from[to] = {}
  end
  self.dv_from[to][from]=conditions
  self:save()
  return true
end

function _:rmDv(from, to)
  if not self.dv_to[from] then
    self.dv_to[from] = {}
  end
  self.dv_to[from][to]=nil

  if not self.dv_from[to] then
    self.dv_from[to] = {}
  end
  self.dv_from[to][from]=nil
  self:save()
  return true
end

function _:getDv(digi)
  return {
    from=self.dv_from[digi], -- list of digis that evolves to this digi
    to=self.dv_to[digi], -- list of digis that this digi evolves to
  }
end


function _:getDigi(key)
  return self.digis[key]
end

return _
