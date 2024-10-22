local function lshift(x, by)
    return math.floor(x / 2 ^ by)
end

local world = {}

function world:new(worldName, seed, worldOption)
    local obj = {}
    setmetatable(obj, {__index = self})
    obj.name = worldName
    obj.seed = seed
    obj.option = worldOption or {
        renderDistance = 3,
        maxPlatformHeight = 5,
        minPlatformWidth = 2,
        maxPlatformWidth = 5
    }
    obj.loadedChunk = {}
    obj.worldPath = "worlds/world_" .. worldName
    if not love.filesystem.getInfo(obj.worldPath) then
        obj.generated = false
    else
        obj.generated = true
    end
    -- thread channel.
    obj.chunkLoaderChannel = love.thread.getChannel("chunkLoader")
    obj.chunkUpdateChannel = love.thread.getChannel("chunkUpdate")
    obj.chunkCleanerSChannel = love.thread.getChannel("chunkCleanerSend")
    obj.chunkCleanerRChannel = love.thread.getChannel("chunkCleanerReceive")
    return obj
end

function world:update(dt)
    if self.player then
        self.chunkUpdateChannel:push({self.player.x, self.loadedChunk})
    end
    local chunkData = self.chunkLoaderChannel:pop()
    if chunkData then
        if not self.loadedChunk[chunkData.x] then
            self.loadedChunk[chunkData.x] = chunk:new(chunkData)
        end
    end
    self.chunkCleanerSChannel:push({self.player.x, self.loadedChunk})
    local cleaner = self.chunkCleanerRChannel:pop()
    if cleaner then
        for _, v in pairs(cleaner) do
            self.loadedChunk[v] = nil
        end
    end
end

function world:generate()
    self.chunkCleaner = love.thread.newThread("world/chunkCleaner.lua")
    self.chunkCleaner:start()
    if self.generated then
        return
    end
    self.generated = true
    love.filesystem.createDirectory(self.worldPath)
    -- start chunk loader.
    self.chunkLoader = love.thread.newThread("world/chunkLoader.lua")
    -- chunkX, worldPath, seed.
    self.chunkLoader:start({-1, 0, 1}, self.worldPath, self.seed, self.option)
end

function world:addPlayer(player)
    self.player = player
    self.chunkUpdate = love.thread.newThread("world/chunkUpdate.lua")
    self.chunkUpdate:start(self.worldPath, self.seed, self.option)
end

function world:render()
    for _, v in pairs(self.loadedChunk) do
        v:render()
    end
end

function world:fire()
    self.chunkUpdateChannel:push({"stop", 5})
end

return world