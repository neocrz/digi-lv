
local _ = Classic:extend() -- base status and evolutions.
function _:new()
  self.savefile = "digi_catalog.lua"
  local dg_cat, _msg = love.filesystem.load(self.savefile)
  if dg_cat then
    dg_cat=dg_cat()
    self.digis = dg_cat.digis 
    self.dv_to = dg_cat.dv_to
  else
    dg_cat = require("data."..self.savefile)
    self.digis = dg_cat.digis
    self.dv_to = dg_cat.dv_to
  end
  self:save()
end

function _:save()
  local dg_cat = {
    digis=self.digis,
    dv_to=self.dv_to,
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
end



function _:getDigi(key)
  return self.digis[key]
end

return _
