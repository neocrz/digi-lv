--[[
Usage
-- Unstructured Digis
local DigiCatalog = require "lib.digi_catalog"()
local digis = require "data.digimons"
DigiCatalog:addDigis(digis)
DigiCatalog:exportDigis()

-- Structured Digis

local digis = require "data.digimons"
local DigiCatalog = require "lib.digi_catalog"({digis=digis})

--]]


local _ = Classic:extend() -- base status and evolutions.
function _:new(t)
  local t = t or {}
  self.digis = t.digis or {}
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
  -- digivolve_to ={["agumon"]={"level >= 4","friendship > 2"}
  d.digivolve_to = t.digivolve_to or {}

  self.digis[d.key] = d
end

function _:addDigis(digis)
  local digis = digis or {}
  for digikey, digi in pairs(digis) do
    local digi = digi
    digi.key = digi.key or digikey
    self:addDigi(digi)
  end
end

function _:exportDigis(filename, internal)
  local filename = filename or "d_catalog.lua"
  local str = Ser(self.digis)
  if internal then
    local file = io.open(filename, "w")

    if file then
      file:write(str) -- Write the string to the file
      file:close()    -- Close the file
    else
      print("Error: Unable to open file for writing.")
    end
  else
    love.filesystem.write(filename, str)
  end
end

function _:getDigi(key)
  return self.digis[key]
end

return _
