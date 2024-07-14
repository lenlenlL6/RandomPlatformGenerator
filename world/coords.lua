local coords = {}

function coords.screenToWorld(x, y)
    return math.floor(x / 32), math.floor(y / 32)
end