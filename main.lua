world = require("world/world")
chunk = require("world/chunk")

GAME_WIDTH, GAME_HEIGHT = 1920, 1080

function love.load()
    love.window.setMode(GAME_WIDTH, GAME_HEIGHT, {fullscreen = true})
    player = {
        x = 100,
        y = 100
    }
    world1 = world:new("testworld", 123456)
    world1:generate()
    -- auto load chunk setup.
    world1:addPlayer(player)
end

function love.update(dt)
    world1:update(dt)
end

function love.draw()
    world1:render()
end

function love.quit()
    world1:fire()
end