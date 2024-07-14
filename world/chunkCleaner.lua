local channel1 = love.thread.getChannel("chunkCleanerSend")
local channel2 = love.thread.getChannel("chunkCleanerReceive")

while true do
    local data = channel1:pop()
    if data then
        local result = {}
        local playerX, loadedChunk = unpack(data)
        playerX = math.floor(playerX / 32)
        for i, v in pairs(loadedChunk) do
            if math.abs(math.abs(i) - math.abs(math.floor(playerX / 2 ^ 4))) > 3 then
                table.insert(result, i)
            end
        end
        channel2:push(result)
    end
end