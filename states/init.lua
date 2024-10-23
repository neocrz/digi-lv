local path = (...):match("(.-)[^%.]+$")
local cwd  = (...):gsub('%.init$', '') .. "."

StateManager:addState("menu", require(cwd .. "menu"))
StateManager:addState("mydigis", require(cwd .. "mydigis"))
StateManager:addState("evo_tree", require(cwd .. "evo_tree"))
