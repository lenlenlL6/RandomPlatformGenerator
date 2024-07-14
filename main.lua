world = require("world/world")
chunk = require("world/chunk")
coords = require("world/coords")

GAME_WIDTH, GAME_HEIGHT = 1890, 1000

function love.load()
    love._openConsole()
    love.window.setMode(GAME_WIDTH, GAME_HEIGHT, {fullscreen = false})
    player = {
        x = 1,
        y = 1
    }
    world1 = world:new("testworld", 123456)
    world1:generate()
    -- auto load chunk setup.
    world1:addPlayer(player)
end

function love.update(dt)
    player.x = player.x + 300 * dt
    world1:update(dt)
end

function love.draw()
    love.graphics.push()
    love.graphics.translate(-player.x, -player.y)
    world1:render()
    love.graphics.pop()
    love.graphics.print("FPS: " .. love.timer.getFPS())
    local count = 0
    for _, __ in pairs(world1.loadedChunk) do
        count = count + 1
    end
    love.graphics.print("Number of loaded chunks: " .. count, 100)
end

function love.quit()
    world1:fire()
end