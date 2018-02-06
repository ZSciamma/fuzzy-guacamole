-- This is the file defining the scrollbar item (used for scrolling through a list, for example)

ScrollBar = Object:extend()

local barColour = { 150, 150, 150 }
local barWidth = 20
local barHeight = love.graphics.getHeight()
local barX = love.graphics.getWidth() - barWidth
local barY = 0


function ScrollBar:new()	
	self.width = 15				-- Dimensions for the scrollable rectangle
	self.height = 50
	self.x = love.graphics.getWidth() - 17		-- Place scroller in middle of rectangle    alternately: - ((barWidth + self.width) / 2)	
	self.y = 0
	
	-- Velocities
	self.vY = 0
	self.accel = 10				-- How much speed the scrollbar gains depending on the user's motion
	self.deccel = 20			-- How mcuh speed the scrollbar loses

	self.on = true

end

function ScrollBar:resetPosition()
	self.y = 0 
	self.vY = 0
end

function ScrollBar:update(dt)
	if not self.on then return end
	-- Move the bar if onscreen:
	if self.y >= -1 and self.vY < 0 or self.y + self.height <= love.graphics.getHeight() + 50 and self.vY > 0 then
		self.y = self.y + self.vY * dt
	end

	-- Keep the bar onscreen, halting its movement
	if self.y < 0 then 
		self.y = 0 
		self.vY = 0
	end
	if self.y + self.height > love.graphics.getHeight() then 
		self.y = love.graphics.getHeight() - self.height 
		self.vY = 0
	end
	
	-- Slow down the bar without movement:
	if self.vY > 0 then
		self.vY = self.vY - self.deccel * math.min(1, 10 * dt)
		if self.vY < 0 then self.vY = 0 end
	elseif self.vY < 0 then
		self.vY = self.vY + self.deccel * math.min(1, 10 * dt)
		if self.vY > 0 then self.vY = 0 end
	end
end


function ScrollBar:draw()
	if not self.on then return end

	love.graphics.setColor(barColour)
	love.graphics.rectangle("fill", love.graphics.getWidth() - barWidth, barY, barWidth, barHeight)
	love.graphics.setColor(80, 80, 80)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

end

function ScrollBar:wheelmoved(x, y)
	if not self.on then return end

	self.vY = self.vY + y * self.accel
end

function ScrollBar:isMoving()
	if self.vY == 0 then return false end
	return true
end

function ScrollBar:On()
	self.on = true
end

function ScrollBar:Off()
	self.on = false
end