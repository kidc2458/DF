Player = 
{
    image = nil,
    
    x = 200,
    y = 830,

    speed = 800,

    fireTime = 0,

    playerRadius = 32
}

function Player:Initialize()
    self.image = love.graphics.newImage("assets/player.png")
    self.fireTime = 0
end

function Player:Draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function Player:Update(deltaTime)
    if love.keyboard.isDown("left") then
        self.x = self.x - self.speed * deltaTime
    end

    if love.keyboard.isDown("right") then
        self.x = self.x + self.speed * deltaTime
    end

    self.fireTime = self.fireTime - deltaTime
    if self.fireTime < 0 then
        self.fireTime = 0.1
        Game:Fire(self.x, self.y)
    end
end

function Player:Collision(monsterX,monsterY,monsterRadius)
    if (((monsterX  - self.x-64) * (monsterX - self.x-64)) + ((monsterY - self.y-64)*(monsterY - self.y-64))) < ((monsterRadius+self.playerRadius)*(monsterRadius+self.playerRadius)) then
        return true
    end

    return false
end