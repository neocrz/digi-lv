local _ = {}

function _.Rect(r1, r2)
    local rect1 = {}
    local rect2 = {}

    rect1.x = r1.x or 0
    rect1.y = r1.y or 0
    rect1.w = r1.w or 1
    rect1.h = r1.h or 1

    rect2.x = r2.x or 0
    rect2.y = r2.y or 0
    rect2.w = r2.w or 1
    rect2.h = r2.h or 1

    if rect1.x < rect2.x + rect2.w and
        rect1.x + rect1.w > rect2.x and
        rect1.y < rect2.y + rect2.h and
        rect1.h + rect1.y > rect2.y then
        return true
    else
        return false
    end
end

function _.Circ(c1, c2)
    local circle1 = {}
    circle1.x = c1.x or 0
    circle1.y = c1.y or 0
    circle1.radius = c1.r or 1

    local circle2 = {}
    circle2.x = c2.x or 0
    circle2.y = c2.y or 0
    circle2.radius = c2.r or 1

    local dx = circle1.x - circle2.x
    local dy = circle1.y - circle2.y
    local distance = math.sqrt(dx * dx + dy * dy)

    if (distance < circle1.radius + circle2.radius) then
        return true
    else
        return false
    end
end

return _