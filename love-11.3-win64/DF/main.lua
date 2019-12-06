require "strict"

require "game"
require "player"

function love.load()
    print("Init")
    
    Game:Initialize()
    Player:Initialize()
end

function love.draw()
    Game:DrawBullet()
    Game:DrawEnemy()
    
    Player:Draw()

    Game:DrawUI()
end

function love.update()
    local deltaTime = Game:GetDelta()
    Game:UpdateMonster(deltaTime)
    Game:UpdateBullet(deltaTime)
    Player:Update(deltaTime)
end

