local Ball = require("ball")
local Pin = require("pin")
local Bin = require("bin")

function love.load()
	love.physics.setMeter(64)
	world = love.physics.newWorld(0, 9.81 * 64, true)
	world:setSleepingAllowed(true)
	balls = {}
	pins = {}
	bins = {}

	-- === Generate PINS ===
	local screenWidth = love.graphics.getWidth()
	local screenHeight = love.graphics.getHeight()

	local rows = 20
	local pinSpacingX = 35
	local pinSpacingY = 35
	local pinRadius = 10
	local startY = -150
	local skipedRows = 5
	for row = 0, rows - 1 do
		-- Skip the first n rows
		if row < skipedRows then
			goto continue
		end
		local cols = row + 1
		local offsetX = (screenWidth - (cols - 1) * pinSpacingX) / 2
		for col = 0, cols - 1 do
			local x = offsetX + col * pinSpacingX
			local y = startY + row * pinSpacingY
			table.insert(pins, Pin:new(world, x, y, pinRadius))
		end
		::continue::
	end
	-- 75
	-- === Generate BINS ===
	local binCount = 140
	local binWidth = screenWidth / binCount
	local binHeight = 460
	local binY = screenHeight -- align bottom of bins with screen

	for i = 0, binCount - 1 do
		local x = i * binWidth
		table.insert(bins, Bin:new(world, x, binY, binWidth, binHeight, 2))
	end
end

function love.update(dt)
	world:update(dt)

	for _, ball in ipairs(balls) do
		ball:update(dt)
	end
	--Press r to reset the world
	if love.keyboard.isDown("r") then
		world:destroy()
		love.load()
	end
end

function love.draw()
	for _, ball in ipairs(balls) do
		ball:draw()
	end

	for _, pin in ipairs(pins) do
		pin:draw()
	end

	for _, bin in ipairs(bins) do
		bin:CountBallsInside(balls)
	end

	--Ball Spawn 1 per 0.5 seconds
	if love.timer.getTime() % 0.05 < 0.01 and #balls < 900 then
		BallSpawn()
	end

	-- Create a font object with a larger size
	local font = love.graphics.newFont(60)

	-- Set the font
	love.graphics.setFont(font)

	-- Draw FPS
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
	-- Draw the number of balls
	love.graphics.print("Balls: " .. #balls, 10, 75)
end

function love.keypressed(key)
	if key == "s" then
		SaveBinDataToFile()
	end
end

function BallSpawn()
	local randomNoise = math.random(-1, 1)
	local ball = Ball:new(world, 960 + randomNoise, 40, 4)
	table.insert(balls, ball)
end

function SaveBinDataToFile()
	local output = "Bin Index\tBall Count\n"

	for i, bin in ipairs(bins) do
		output = output .. string.format("%d\t%d\n", i, bin.count or 0)
	end

	local success, err = love.filesystem.write("galton_data.txt", output)

	if success then
		print("✅ Data saved to galton_data.txt")
	else
		print("❌ Error saving file: ", err)
	end
end
