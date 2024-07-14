local chunk = {}

function chunk:new(chunkData)
    local obj = {}
    setmetatable(obj, {__index = self})
    obj.x = chunkData.x
    obj.data = chunkData.y
    return obj
end

function chunk:render()
    for y, v in pairs(self.data) do
        for x, value in pairs(v) do
            if value > 0 then
                love.graphics.rectangle("fill", self.x * 512 + (x - 1) * 32, (y - 1) * 32 + GAME_HEIGHT / 2)
            end
        end
    end
end