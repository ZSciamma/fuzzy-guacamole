SlideAlert = Confirmation:extend()

local buttonWidth = 200
local buttonHeight = 50
local buttonMarginY = 25			-- Space between bottom of the popup and the button

function SlideAlert:new(text, width, height, sliderLength, nodeValue1, nodeValue2, text1, text2, accept, reject)	-- Potentially also insert an 'accept' function
	SlideAlert.super.new(self, text, width, height, accept, reject)

	local slider1X = self.x + (self.width - sliderLength) / 2
	--local slider1Y = self.y + self.height / 2
	local slider1Y = self.y + 7 * self.height / 10
	self.slider1 = Slider(slider1X, slider1Y, sliderLength, nodeValue1, text1)

	local slider2X = self.x + (self.width - sliderLength) / 2
	--local slider2Y = self.y + self.height / 4
	local slider2Y = self.y + self.height / 3
	self.slider2 = Slider(slider2X, slider2Y, sliderLength, nodeValue2, text2)
end

function SlideAlert:update(dt)
	SlideAlert.super.update(self)
	self.slider1:update()
	self.slider2:update()
end

function SlideAlert:draw()
	SlideAlert.super.draw(self)
	self.slider1:draw()
	self.slider2:draw()
end

function SlideAlert:mousepressed(x, y)
	SlideAlert.super.mousepressed(self, x, y)
	self.slider1:mousepressed(x, y)
	self.slider2:mousepressed(x, y)
end

function SlideAlert:mousereleased(x, y)
	SlideAlert.super.mousereleased(self, x, y)
	self.slider1:mousereleased(x, y)
	self.slider2:mousereleased(x, y)
end
