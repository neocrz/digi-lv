local path = (...):match("(.-)[^%.]+$")
local cwd  = (...):gsub('%.init$', '') .. "."

local _    = {}
_.base     = require(cwd .. "base")
_.box      = require(cwd .. "box")
_.button   = require(cwd .. "button")
_.col      = require(cwd .. "collision")
return _
