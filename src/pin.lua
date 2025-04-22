-- src/pin.lua
local Pin = {}
Pin.__index = Pin

function Pin:new(world, x, y, radius, options)
	local opts = options or {}
	self = setmetatable({}, Pin)

	self.radius = radius or 5
	self.color = opts.color or { 0.7, 0.7, 0.7 }

	self.body = love.physics.newBody(world, x, y, "static")
	self.shape = love.physics.newCircleShape(self.radius)
	self.fixture = love.physics.newFixture(self.body, self.shape)

	self.fixture:setFriction(opts.friction or 0.3)
	self.fixture:setRestitution(opts.bounciness or 0.5)

	return self
end

function Pin:update(dt)
	-- Not needed for static objects, but good placeholder
end

function Pin:draw()
	love.graphics.setColor(self.color)
	love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.radius)
	love.graphics.setColor(1, 1, 1)
end

return Pin
