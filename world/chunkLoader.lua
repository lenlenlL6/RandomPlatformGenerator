local args = {...}

local chunkX = args[1]
local worldPath = args[2]
local seed = args[3]
local worldOption = args[4]

local channel1 = love.thread.getChannel("chunkLoader")

local bitser = require("utils/bitser")

local function load(chunkX)
    local filePath = worldPath .. "/chunk_" .. chunkX
    if not love.filesystem.getInfo(filePath) then
        local data = {}
        for y = 1, 16 do
            local subData = {}
            for x = 1, 16 do
                table.insert(subData, 0)
            end
            table.insert(data, subData)
        end
        love.math.setRandomSeed(seed)
        for num = 1, love.math.random(2, 4) do
            local platformHeight = love.math.random(1, worldOption["maxPlatformHeight"])
            local platformWidth = love.math.random(worldOption["minPlatformWidth"], worldOption["maxPlatformWidth"])
            local randomX = love.math.random(1, 16)
            for i = 1, platformWidth do
                data[platformHeight][randomX] = 1
                randomX = randomX + 1
            end
        end
        local chunkData = {
            x = chunkX,
            data = data
        }
        bitser.dumpLoveFile(filePath, chunkData)
        return chunkData
    end
    return bitser.loadLoveFile(filePath)
end

for _, v in pairs(chunkX) do
    channel1:push(load(v))
end