local args = {...}

local worldPath = args[1]
local seed = args[2]

require("love.timer")
local coords = require("world/coords")

local channel1 = love.thread.getChannel("chunkUpdate")
local channel2 = love.thread.getChannel("chunkLoader")
local channel3 = love.thread.getChannel("addThread")

function lshift(x, by)
    return x * 2 ^ by
end

while true do
    local playerX, loadedChunk = table.unpack(channel:pop())
    if playerX then
        if tostring(playerX) == "stop" then
            break
        end
        playerX, playerY = coords.screenToWorld(playerX, 0)
        if not loadedChunk[lshift(playerX, 4)] then
            local thread = love.thread.newThread("world/chunkLoader.lua")
            thread:start({lshift(playerX, 4)}, worldPath, seed)
        end
    end
end