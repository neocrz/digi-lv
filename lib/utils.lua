local _ = {}

function _.searchSubstring(str, substr)
    return string.find(string.lower(str), string.lower(substr)) ~= nil
end

return _