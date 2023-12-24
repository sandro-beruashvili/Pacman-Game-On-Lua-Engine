fitman = {}
fitman.x = 1		
fitman.y = 1		
fitman.sx = 14+32	
fitman.sy = 14+32	
fitman.canEatGhosts = false


fitman.move = 0

animationTime = 0			
animationFrame = 5			

function fitman.movement()
	--magla
	if fitman.move == 1 then
		if map[fitman.x][fitman.y-1] == gfx.tile then fitman.move = 0
		else
			
			fitman.sy = fitman.sy-config.fitmanSpeed
			
	
			if fitman.gfx == gfx.fitman and animationTime > animationFrame then
				fitman.gfx = gfx.fitmanUp
				animationTime = 0
			elseif animationTime > animationFrame then
				fitman.gfx = gfx.fitman
				animationTime = 0
			end	
		end	
	-- dabla
	elseif fitman.move == 2 then
		if map[fitman.x][fitman.y+1] == gfx.tile then fitman.move = 0 
		else
		
			fitman.sy = fitman.sy+config.fitmanSpeed
			
			
			if fitman.gfx == gfx.fitman and animationTime > animationFrame then
				fitman.gfx = gfx.fitmanDown
				animationTime = 0
			elseif animationTime > animationFrame then
				fitman.gfx = gfx.fitman
				animationTime = 0
			end
		end	
	-- marcxena
	elseif fitman.move == 3 then
		if map[fitman.x-1][fitman.y] == gfx.tile then fitman.move = 0 
		else
			
			fitman.sx = fitman.sx-config.fitmanSpeed
			
			
			if fitman.gfx == gfx.fitman and animationTime > animationFrame then
				fitman.gfx = gfx.fitmanLeft
				animationTime = 0
			elseif animationTime > animationFrame then
				fitman.gfx = gfx.fitman
				animationTime = 0
			end	
		end
	-- marjvena
	elseif fitman.move == 4 then
		if map[fitman.x+1][fitman.y] == gfx.tile then fitman.move = 0 
		else
	
			fitman.sx = fitman.sx+config.fitmanSpeed
			
			
			if fitman.gfx == gfx.fitman and animationTime > animationFrame then
				fitman.gfx = gfx.fitmanRight
				animationTime = 0
			elseif animationTime > animationFrame then
				fitman.gfx = gfx.fitman
				animationTime = 0
			end	
		end
	end

	-- gadamowmeba
	newTile = fitman.tileChangeCheck()
	fitman.movementCheck()

	
	if newTile or fitman.move == 0 then
		if 		newDirection == 1 and canMoveUp 	then fitman.move = 1
		elseif 	newDirection == 2 and canMoveDown 	then fitman.move = 2
		elseif 	newDirection == 3 and canMoveLeft 	then fitman.move = 3
		elseif 	newDirection == 4 and canMoveRight 	then fitman.move = 4 
		end
	end


end

function fitman.tileChangeCheck()

	if fitman.sy < fitman.y*32-16 then fitman.y = fitman.y-1 return true end
	if fitman.sy > fitman.y*32+44 then fitman.y = fitman.y+1 return true end
	if fitman.sx < fitman.x*32-16 then fitman.x = fitman.x-1 return true end
	if fitman.sx > fitman.x*32+44 then fitman.x = fitman.x+1 return true end
end

function fitman.movementCheck()
	
	if map[fitman.x][fitman.y-1] ~= gfx.tile then canMoveUp = true 		else canMoveUp = false end		-- Up
	if map[fitman.x][fitman.y+1] ~= gfx.tile then canMoveDown = true 	else canMoveDown = false end	-- Down
	if map[fitman.x-1][fitman.y] ~= gfx.tile then canMoveLeft = true 	else canMoveLeft = false end	-- Left
	if map[fitman.x+1][fitman.y] ~= gfx.tile then canMoveRight = true 	else canMoveRight = false end	-- Right
end