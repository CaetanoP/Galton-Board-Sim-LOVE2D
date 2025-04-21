-- src/ball.lua

local Ball = {}
Ball.__index = Ball

--===============================
-- Constructor: Creates a new Ball object
--===============================
function Ball:new(world, x, y, radius, options)
	local opts = options or {}
	self = setmetatable({}, Ball)

	-- === Visual and physical properties ===
	self.radius = radius or 5
	self.bounciness = opts.bounciness or 0.0
	self.density = opts.density or 1
	self.friction = opts.friction or 0.0
	self.color = opts.color or { 1, 1, 1 }

	-- === Create physics body ===
	self.body = love.physics.newBody(world, x, y, "dynamic")
	self.shape = love.physics.newCircleShape(self.radius)
	self.fixture = love.physics.newFixture(self.body, self.shape, self.density)

	-- === Set physical behavior ===
	self.fixture:setRestitution(self.bounciness)
	self.fixture:setFriction(self.friction)

	-- === Simulation control ===
	self.lifeTime = 0 -- Tracks how long the ball has existed
	self.maxLifeTime = opts.maxLifeTime or 30 -- Lifetime before turning static
	self.settled = false -- Whether the ball has been "frozen"
	self.insideBin = false -- Whether the ball is inside a bin
	self.alive = true
	return self
end

--===============================
-- Updates ball's physics and state each frame
--===============================
function Ball:update(dt)
	if self.settled then
		-- get the vy of the ball
		local vx, vy = self.body:getLinearVelocity()

		-- if vy is negative, set it to
		if vy < 0 then
			self.body:setLinearVelocity(0, 0)
			--sleep the body
			self.body:setSleepingAllowed(true)
			self.body:setType("static")
			self.body:setAwake(false)
			self.alive = false
		end

		return
	end

	-- Once ball is low enough (hits bin), stop it from bouncing
	if self.body:getY() > 560 then
		self:onBinEnter()
		self.settled = true
	end
end

--===============================
-- Renders the ball
--===============================
function Ball:draw()
	love.graphics.setColor(self.color)
	love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.radius)
	love.graphics.setColor(1, 1, 1) -- Reset drawing color
end

--===============================
-- Sets the ball to a static state
--===============================

function Ball:onBinEnter()
	self.body:setGravityScale(0) -- disable gravity
	self.body:setLinearVelocity(0, 0)
	self.body:applyLinearImpulse(0, 0.5)
	self.fixture:setRestitution(0)

	self.insideBin = true
end

return Ball
