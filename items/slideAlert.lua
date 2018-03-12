SlideAlert = Notification:extend()

local buttonWidth = 200
local buttonHeight = 50
local buttonMarginY = 25			-- Space between bottom of the popup and the button

function SlideAlert:new(width, height, sliderLength, func)	-- Potentially also insert an 'accept' function
	SlideAlert.super.new(self, width, height, func)

	local sliderX = self.x + (self.width - sliderLength) / 2
	local sliderY = self.y + self.height / 2
	self.slider = Slider(sliderX, sliderY, sliderLength)
end


function SlideAlert:update(dt)
	SlideAlert.super.update(self)
	self.slider:update()
end


function SlideAlert:draw()
	SlideAlert.super.draw(self)
	self.slider:draw()
end


function SlideAlert:mousepressed(x, y)
	SlideAlert.super.mousepressed(self, x, y)
	self.slider:mousepressed(x, y)
end



function SlideAlert:mousereleased(x, y)
	SlideAlert.super.mousereleased(self, x, y)
	self.slider:mousereleased(x, y)
end