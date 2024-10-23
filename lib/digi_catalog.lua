local _ = Classic:extend() -- base status and evolutions.

function _:new(t)
    local t = t or nil
    self.digimons = t or {}
end




return _