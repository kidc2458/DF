Game =
{
    imageBullet = love.graphics.newImage("assets/bullet.png"),
    imageEnemy = love.graphics.newImage("assets/enemy.png"),
    
    bulletDelay = 0,
    bulletList = {},    
    bulletRadius = 16,

    monsterList = {},    
    monsterSpeed = 200,
    monsterRadius = 32,

    spawnDelay = 0,
    spawnAcc = 0,
    spawnCheck = false,

    collisionCheck = false,
    Score = 0,

    playing = true,
}

function Game:GetDelta()

    if self.playing == true then
        return love.timer.getDelta()
    end

    return 0
end

function Game:Initialize()
    self.Score = 0

    self.bulletList = {}
    for i = 0, 30 do
        self.bulletList[i] =
        {
            x = 0,
            y = 0,
            speed = 500,

            isActive = false,
        }
    end

    self.monsterList = {}
    for i = 0, 4 do
        self.monsterList[i] = 
        {
            x = 0,
            y = 0,
            speed = self.monsterSpeed,

            isActive = false,
        }
    end
end

function Game:DrawUI()
    love.graphics.print("Score : "..Game.Score, 0, 0)

    if self.playing == false then    
        love.graphics.print("Game Over",love.graphics.getWidth()/2,love.graphics.getHeight()/2)
    end
end

function Game:DrawBullet()
    for _k, bullet in pairs(self.bulletList) do
        if bullet.isActive == true then
            love.graphics.draw(self.imageBullet, bullet.x - 16, bullet.y - 16)
        end
    end
end

function Game:DrawEnemy()
    for _K,monster in pairs(self.monsterList) do
        if monster.isActive == true then
            love.graphics.draw(self.imageEnemy, monster.x-64, monster.y-64)
        end
    end
end

function Game:UpdateMonster(deltaTime)
    Game:Spawn(deltaTime)
    Game:Collision()

    local width = love.graphics.getWidth() / 5
    for i,monster in pairs(self.monsterList) do
        if monster.isActive == true then
            monster.x = i * width + width / 2
            monster.y  = monster.y + monster.speed * deltaTime
            if monster.y > love.graphics.getHeight() + 50 then
                monster.isActive = false
            end
        end
    end
end

function Game:UpdateBullet(deltaTime)
    for _k, bullet in pairs(self.bulletList) do
        if bullet.isActive == true then
            bullet.y = bullet.y - bullet.speed * deltaTime
            if bullet.y < -10 then
                bullet.isActive = false
            end
        end
    end
end

function Game:Spawn(deltaTime)
    self.spawnAcc = self.spawnAcc + deltaTime
    if self.spawnAcc > 1 then
        self.spawnAcc = 0
        self.monsterSpeed = self.monsterSpeed + 10
    end

    self.spawnCheck = false
    for _i, monster in pairs(self.monsterList) do
        if self.spawnCheck == false and monster.isActive == true then
            self.spawnCheck = true
            break
        end
    end

    if self.spawnCheck == false then
        for _i, monster in pairs(self.monsterList) do
            monster.y = -50
            monster.isActive = true
            monster.speed = self.monsterSpeed
        end
    end
end

function Game:Fire(x, y)
    for _k, bullet in pairs(self.bulletList) do
        if bullet.isActive == false then
            bullet.isActive = true
            bullet.x = x + 64 -- image center
            bullet.y = y
            return
        end
    end
end

function Game:Collision()
    for _i, monster in pairs(self.monsterList) do
        -- collision bullet and monster 
        if monster.isActive == true then
            self.collisionCheck = false
            for _j, bullet in pairs(self.bulletList) do
                if bullet.isActive == true then
                    if (((monster.x  - bullet.x) * (monster.x - bullet.x)) + ((monster.y - bullet.y)*(monster.y - bullet.y))) < ((self.monsterRadius+self.bulletRadius)*(self.monsterRadius+self.bulletRadius)) then
                        bullet.isActive = false
                        monster.isActive = false
                        self.collisionCheck = true
                        self.Score = self.Score + 10
                        break
                    end
                end
            end    
            if self.collisionCheck == true then
                break
            end
        end

        -- collision player and monster
        if Player:Collision(monster.x,monster.y,self.monsterRadius) == true then
            monster.isActive = false
            self.playing = false
            break
        end
    end
end