local args = {...}

local worldPath = args[1]
local seed = args[2]
local worldOption = args[3]

require("love.timer")
require("love.event")
local coords = require("world/coords")

local channel1 = love.thread.getChannel("chunkUpdate")

local function lshift(x, by)
    return math.floor(x / 2 ^ by)
end

while true do
    if channel1:getCount() ~= 0 then
        local playerX, loadedChunk = unpack(channel1:pop())
        playerX = math.floor(playerX / 32)
        local chunkI = lshift(playerX, 4)
        for i = -1, 1 do
            if not loadedChunk[chunkI + i] then
                local thread = love.thread.newThread("world/chunkLoader.lua")
                thread:start({chunkI + i}, worldPath, seed, worldOption)
            end
        end
    end
end