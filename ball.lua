Ball = {}

collideSound = love.audio.newSource("assets/collideSound.mp3", "static")
scoreSound = love.audio.newSource("assets/scoreSound.mp3", "static")
bgm = love.audio.newSource("assets/bgm.mp3", "stream")

collideSound:setVolume(0.5)
scoreSound:setVolume(0.5)
bgm:setVolume(1.5)
bgm:setLooping(true)

function Ball:load()
	self.img = love.graphics.newImage("assets/ball.png")
	self.width = self.img:getWidth()
	self.height = self.img:getHeight()
	self.x = love.graphics.getWidth() / 2
	self.y = love.graphics.getHeight() / 2 - self.height / 2
	self.speed = 340
	self.xVel = -self.speed
	self.yVel = 0
	
	bgm:play()
end

function Ball:update(dt)
	Ball:move(dt)
	Ball:collide()
end

function Ball:collide()
	self:collideWall()	
	self:collidePlayer()
	self:collideAI()
	self:score()	
end

function Ball:collideWall()
	if self.y < 0 then
		self.y = 0
		self.yVel = -self.yVel
	elseif self.y + self.height > love.graphics.getHeight() then
		self.y = love.graphics.getHeight() - self.height
		self.yVel = -self.yVel
	end
end

function Ball:collidePlayer()
	if checkCollision(self, Player) then
		self.xVel = self.speed
		local middleBall = self.y + self.height / 2
		local middlePlayer = Player.y + Player.height / 2
		local collisionPosition = middleBall - middlePlayer
		self.yVel = collisionPosition * 5
		collideSound:play()
	end
end

function Ball:collideAI()
	if checkCollision(self, AI) then
		self.xVel = -self.speed
		local middleBall = self.y + self.height / 2
		local middleAI = AI.y + AI.height / 2
		local collisionPosition = middleBall - middleAI
		self.yVel = collisionPosition * 5
		collideSound:play()
	end
end

function Ball:score()
	if self.x < 0 then
		self:resetPosition(1)
		Score.ai = Score.ai + 1
		scoreSound:play()
	end

	if self.x + self.height > love.graphics.getWidth() then
		self:resetPosition(-1)
		Score.player = Score.player + 1
		scoreSound:play()
	end
end

function Ball:resetPosition(modifier)
	self.x = love.graphics.getWidth() / 2 - self.width / 2
	self.y = love.graphics.getHeight() / 2 - self.height / 2
	self.yVel = 0
	self.xVel = self.speed * modifier
end

function Ball:move(dt)
	self.x = self.x + self.xVel * dt
	self.y = self.y + self.yVel * dt
end

function Ball:draw()
	love.graphics.draw(self.img, self.x, self.y)
end