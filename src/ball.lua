-- src/ball.lua
local Ball = {}
Ball.__index = Ball

function Ball:new(world, x, y, radius, options)
	local opts = options or {}

	self = setmetatable({}, Ball)

	self.radius = radius or 5
	self.bounciness = opts.bounciness or 0.4
	self.densit = opts.density or 1
	self.friction = opts.friction or 0.0

	-- Create the physics body
	self.body = love.physics.newBody(world, x, y, "dynamic")
	self.shape = love.physics.newCircleShape(self.radius)
	self.fixture = love.physics.newFixture(self.body, self.shape, self.density)

	-- Physics properties
	self.fixture:setRestitution(self.bounciness)
	self.fixture:setFriction(self.friction)

	-- You can add color or other visual properties here
	self.color = opts.color or { 1, 1, 1 }

	self.lifeTime = 0
	self.maxLifeTime = opts.maxLifeTime or 15 -- Set a default max lifetime
	self.settled = false
	return self
end

function Ball:update(dt)
	if self.settled then
		return
	end

	self.lifeTime = self.lifeTime + dt
	if self.lifeTime >= self.maxLifeTime then
		self.body:setType("static") -- Make the ball static after its lifetime
		self.body:setSleepingAllowed(true)
		self.settled = true
	end

	-- If the position in y is greater than 1000, set the restitution
	if self.body:getY() > 560 then
		self.fixture:setRestitution(0)
	end
end

function Ball:draw()
	love.graphics.setColor(self.color)
	love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.radius)
	love.graphics.setColor(1, 1, 1) -- reset color
end

return Ball
