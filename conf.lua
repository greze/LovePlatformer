-- Configuration for love2d platformer tutorial


function love.conf(t)
	t.title = "Platformer Tutorial" --title window string
	t.version = "0.10.2" --love version this game was made for
	t.window.width = 640
	t.window.height = 480
	
	-- Windows debugging (for Linux or Mac, run program through terminal; set to true for Windows)
	t.console = false
end
