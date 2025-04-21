-- src/bin.lua
local Bin = {}
Bin.__index = Bin

function Bin:new(world, x, y, width, height, wallThickness, options)
	local opts = options or {}
	local self = setmetatable({}, Bin)

	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.thickness = wallThickness or 5
	self.color = opts.color or { 0.5, 0.5, 1 }
	self.count = 0

	-- Left wall
	self.left = love.physics.newBody(world, x, y - height / 2, "static")
	self.leftShape = love.physics.newRectangleShape(self.thickness, height)
	self.leftFixture = love.physics.newFixture(self.left, self.leftShape)
	self.leftFixture:setRestitution(0)
	-- Right wall
	self.right = love.physics.newBody(world, x + width - self.thickness, y - height / 2, "static")
	self.rightShape = love.physics.newRectangleShape(self.thickness, height)
	self.rightFixture = love.physics.newFixture(self.right, self.rightShape)
	self.rightFixture:setRestitution(0)
	-- Bottom
	self.bottom = love.physics.newBody(world, x + width / 2 - self.thickness / 2, y, "static")
	self.bottomShape = love.physics.newRectangleShape(width - self.thickness * 2, self.thickness)
	self.bottomFixture = love.physics.newFixture(self.bottom, self.bottomShape)
	self.bottomFixture:setRestitution(0)
	return self
end

function Bin:draw()
	love.graphics.setColor(self.color)

	-- Draw left wall
	local lx, ly = self.left:getPosition()
	love.graphics.rectangle("fill", lx - self.thickness / 2, ly - self.height / 2, self.thickness, self.height)

	-- Draw right wall
	local rx, ry = self.right:getPosition()
	love.graphics.rectangle("fill", rx - self.thickness / 2, ry - self.height / 2, self.thickness, self.height)

	-- Draw bottom
	local bx, by = self.bottom:getPosition()
	love.graphics.rectangle(
		"fill",
		bx - (self.width - self.thickness * 2) / 2,
		by - self.thickness / 2,
		self.width - self.thickness * 2,
		self.thickness
	)

	love.graphics.setColor(1, 1, 1)
end
function Bin:CountBallsInside(balls)
	self.count = 0
	if balls == nil then
		return
	end
	local x1 = self.left:getX()
	local x2 = self.right:getX()
	local yTop = 0
	local yBottom = self.bottom:getY()

	for _, ball in ipairs(balls) do
		if ball.settled then
			local bx, by = ball.body:getX(), ball.body:getY()
			if bx > x1 and bx < x2 and by > yTop and by < yBottom then
				self.count = self.count + 1
			end
		end
	end
end
return Bin
