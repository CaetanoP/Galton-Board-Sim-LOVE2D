-- conf.lua
function love.conf(t)
	t.identity = "galton-board" -- Save directory name (string)
	t.version = "11.4" -- LOVE version this was made for

	-- Window settings
	t.window.title = "Galton Board Simulation"
	t.window.icon = nil -- path to an image file to use as window/icon

	t.window.width = 1920 -- Full HD width
	t.window.height = 1080 -- Full HD height
	t.window.resizable = true -- Let user resize
	t.window.fullscreen = false -- Start in windowed mode (set true if you want true fullscreen)
	t.window.vsync = 1 -- Enable vertical sync

	-- Other modules you can disable to slightly improve startup
	t.modules.joystick = false
	t.modules.audio = true
	t.modules.keyboard = true
	t.modules.event = true
	t.modules.graphics = true
	t.modules.timer = true -- Essential for dt in love.update
	t.modules.mouse = true
	t.modules.physics = true -- We need physics for the board
	t.modules.sound = true
	t.modules.thread = false
	t.modules.image = true
	t.modules.system = true
	t.modules.window = true
	t.modules.math = true
end
