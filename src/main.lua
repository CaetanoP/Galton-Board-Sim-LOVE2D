local Ball = require("ball")
local Pin = require("pin")
local Bin = require("bin")

-- Global tables and world
local balls = {}
local pins = {}
local bins = {}
local world
local gameRunning = true
-- === Constants ===
local BALL_LIMIT = 900
local BALL_SPAWN_INTERVAL = 0.05
local lastSpawnTime = 0

-- === LOVE LOAD ===
function love.load()
	font = love.graphics.newFont(60)
	love.graphics.setFont(font)
	love.graphics.setColor(1, 1, 1)
	love.physics.setMeter(64)
	world = love.physics.newWorld(0, 9.81 * 64, true)
	world:setSleepingAllowed(true)

	balls = {}
	balls_drawn = {}
	pins = {}
	bins = {}

	GeneratePins()
	GenerateBins()
end

-- === UPDATE ===
function love.update(dt)
	if gameRunning then
		world:update(dt) -- Update physics world
	end

	for _, ball in ipairs(balls) do
		if ball.alive then
			ball:update(dt)
		else
			--remove the ball from the table
			table.remove(balls, _)
		end
	end

	-- Spawn a ball every interval
	if love.timer.getTime() - lastSpawnTime > BALL_SPAWN_INTERVAL and #balls_drawn < BALL_LIMIT then
		if gameRunning then
			BallSpawn()
		end
		lastSpawnTime = love.timer.getTime()
	end
end

-- r== DRAW ===
function love.draw()
	for _, ball in ipairs(balls_drawn) do
		ball:draw()
	end

	for _, pin in ipairs(pins) do
		pin:draw()
	end

	-- Display FPS and Ball Count
	love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
	love.graphics.print("Balls: " .. #balls_drawn, 10, 75)
end

-- === INPUT ===
function love.keypressed(key)
	if key == "s" then
		SaveBinDataToFile()
	end
	if key == "q" then
		love.event.quit()
	end
	if key == "p" then
		gameRunning = not gameRunning
	end
	if key == "r" then
		world:destroy()
		love.load()
	end
end

-- === BALL SPAWNER ===
function BallSpawn()
	local randomNoise = math.random(-1, 1)
	local ball = Ball:new(world, 960 + randomNoise, 40, 4)
	table.insert(balls, ball)
	table.insert(balls_drawn, ball)
end

-- === PIN GENERATION ===
function GeneratePins()
	local screenWidth = love.graphics.getWidth()
	local rows = 20
	local pinSpacingX = 35
	local pinSpacingY = 35
	local pinRadius = 10
	local startY = -150
	local skippedRows = 5

	for row = 0, rows - 1 do
		if row < skippedRows then
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
end

-- === BIN GENERATION ===
function GenerateBins()
	local screenWidth = love.graphics.getWidth()
	local screenHeight = love.graphics.getHeight()
	local binCount = 140
	local binWidth = screenWidth / binCount
	local binHeight = 460
	local binY = screenHeight

	for i = 0, binCount - 1 do
		local x = i * binWidth
		table.insert(bins, Bin:new(world, x, binY, binWidth, binHeight, 1.5))
	end
end

-- === SAVE DATA TO FILE ===
function SaveBinDataToFile()
	local output = "Bin Index\tBall Count\n"
	-- Count balls in each bin

	for i, bin in ipairs(bins) do
		output = output .. string.format("%d\t%d\n", i, bin:CountBallsInside(balls_drawn) or 0)
	end

	local success, err = love.filesystem.write("galton_data.txt", output)

	if success then
		print("✅ Data saved to galton_data.txt")
	else
		print("❌ Error saving file: ", err)
	end
end
