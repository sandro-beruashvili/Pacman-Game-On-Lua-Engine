require("config")
require("map")
require("ghost")
require("fitman")

gfx = {}
sfx = {}

points = 0
fruitStartTimer = 0
gameOver = false

function love.load()

	love.filesystem.setIdentity(config.gameName)					
	love.keyboard.setKeyRepeat(true)

    love.graphics.setBackgroundColor(104, 136, 248)                 -- lurji foni

    love.window.setTitle(config.windowTitle)                        -- Window title
    love.window.setMode(config.screenWidth, config.screenHeight)    --tamashis grafikis resolution

    																
    sfx.cheese = love.audio.newSource("data/cheese.ogg", "static")	

  -- teqsturebi
    gfx.tile = love.graphics.newImage("data/tile.png")				
    gfx.black = love.graphics.newImage("data/black.png")
    
    gfx.fitman= love.graphics.newImage("data/fitman.png")
    gfx.fitmanUp = love.graphics.newImage("data/fitmanUp.png")
    gfx.fitmanDown = love.graphics.newImage("data/fitmanDown.png")
    gfx.fitmanLeft = love.graphics.newImage("data/fitmanLeft.png")
    gfx.fitmanRight = love.graphics.newImage("data/fitmanRight.png")

    gfx.ghost0 = love.graphics.newImage("data/ghost0.png")
    gfx.ghost1 = love.graphics.newImage("data/ghost1.png")
    gfx.ghost2 = love.graphics.newImage("data/ghost2.png")
    gfx.ghostEat = love.graphics.newImage("data/ghostEat.png")
    
    gfx.cheese = love.graphics.newImage("data/cheese1.png")
    gfx.fruit = love.graphics.newImage("data/fruit1.png")


    fitman.gfx = gfx.fitman
   --ghostebi
    for i = 0, 4 do 												
    	ghosts[i] = {}
    	setmetatable(ghosts[i], ghost)
    	ghosts[i]:init()
    end

    map.loadData()
end

function love.keypressed(key)
	if key == "up" 		then newDirection = 1 end
	if key == "down" 	then newDirection = 2 end
	if key == "left" 	then newDirection = 3 end
	if key == "right" 	then newDirection = 4 end

	if key == "escape" then love.event.quit() end
end

function love.update()
	
	if not gameOver then
		fitman.movement()
	end
	
	for i = 0, #ghosts do
		ghosts[i]:movement()
	end

	-- gvirabshi gadzroma(internetshi movidzie)
	if 		fitman.sx < -10 		then fitman.sx = 36+(32*20)	fitman.x = 20
	elseif 	fitman.sx > 46+(32*20) 	then fitman.sx = 1 fitman.x = 0
	end

	for i = 0, #ghosts do 
		if 		ghosts[i].sx < -10 then ghosts[i].sx = 36+(32*20) ghosts[i].x = 20
		elseif 	ghosts[i].sx > 36+(32*20) then ghosts[i].sx = 1 ghosts[i].x = 0
		end
	end

	animationTime = animationTime + 1

--fitmanis qulebis ageba
	if map[fitman.x][fitman.y] == gfx.cheese then
		points = points +1
		map[fitman.x][fitman.y] = gfx.black
		sfx.cheese:play()
	elseif map[fitman.x][fitman.y] == gfx.fruit then
		fitman.canEatGhosts = true
		for i = 0, #ghosts do
			ghosts[i].gfx = gfx.ghostEat
		end
		map[fitman.x][fitman.y] = gfx.black
		fruitStartTimer = love.timer.getTime()
	end

	if love.timer.getTime() - fruitStartTimer > 10 then
		fitman.canEatGhosts = false
		for i = 0, #ghosts do
			if ghosts[i].eaten == nil or ghosts[i].eaten ~= 1 then
				ghosts[i].gfx = ghosts[i].initGfx
			end
		end
		fruitStartTimer = 0
	end

	-- and ghosts
	for i = 0, #ghosts do
		if fitman.x == ghosts[i].x and fitman.y == ghosts[i].y then			
			
			if fitman.canEatGhosts then
				ghosts[i]:eat()
			else
				gameOver = true
			end
		end

		-- ghosts 30 wamshi tavidan chndebian
		if ghosts[i].eaten == 1 then
			if love.timer.getTime() - ghosts[i].respawnTimer > 30 then
				ghosts[i]:respawn()
			end
		end
	end
end

function drawMap()
	love.graphics.setColor(255,255,255,255)
	for i = 0, 20 do 														-- Background
		for j = 0, 20 do
			love.graphics.draw(gfx.black, 14+i*32, 14+j*32, 0, 1, 1)
		end
	end
	for i = 0, 20 do 														-- Tiles
		for j = 0, 20 do
			if map[i][j] ~= nil then
				love.graphics.draw(map[i][j], 14+i*32, 14+j*32, 0, 1, 1)
			end
		end
	end

end

function love.draw(dt)
	drawMap()

	love.graphics.draw(fitman.gfx, fitman.sx, fitman.sy, 0, 1, 1)


	for i = 0, #ghosts do
		if ghosts[i].gfx ~= nil then
			love.graphics.draw(ghosts[i].gfx, ghosts[i].sx, ghosts[i].sy, 0, 1, 1)
		end
	end
  love.graphics.print( 'points: ', 280, 20, 0, 1.5, 1.5)
	love.graphics.print( points, 345, 20, 0, 1.5, 1.5)



	if gameOver then
		love.graphics.setColor(0,0,100,255)
		love.graphics.rectangle("fill", config.screenWidth * 0.5 - config.screenWidth * 0.3 , config.screenHeight * 0.5 - config.screenHeight * 0.25, config.screenWidth*0.6, config.screenHeight*0.15)
		love.graphics.setColor(255,255,0,255)
		love.graphics.print("Game over!", config.screenWidth * 0.5 - config.screenWidth * 0.25, 200, 0, 5)
	end
	
	if canMoveUp 	then love.graphics.setColor(0, 255, 0, 255) else love.graphics.setColor(255, 0, 0, 255) end
	love.graphics.rectangle("fill", 200, 10, 5, 5)

	if canMoveDown 	then love.graphics.setColor(0, 255, 0, 255) else love.graphics.setColor(255, 0, 0, 255) end
	love.graphics.rectangle("fill", 200, 20, 5, 5)

	if canMoveLeft 	then love.graphics.setColor(0, 255, 0, 255) else love.graphics.setColor(255, 0, 0, 255) end
	love.graphics.rectangle("fill", 195, 15, 5, 5)

	if canMoveRight then love.graphics.setColor(0, 255, 0, 255) else love.graphics.setColor(255, 0, 0, 255) end
	love.graphics.rectangle("fill", 205, 15, 5, 5)


	if ghost.canMoveForward then love.graphics.setColor(0, 255, 0, 255) else love.graphics.setColor(255, 0, 0, 255) end
	love.graphics.rectangle("fill", 220, 10, 5, 5)

	if ghost.canMoveLeft then love.graphics.setColor(0, 255, 0, 255) else love.graphics.setColor(255, 0, 0, 255) end
	love.graphics.rectangle("fill", 215, 15, 5, 5)

	if ghost.canMoveRight then love.graphics.setColor(0, 255, 0, 255) else love.graphics.setColor(255, 0, 0, 255) end
	love.graphics.rectangle("fill", 225, 15, 5, 5)
end