-- This is the template for every button which is used to flip between two states (screens). These are "next" or "home" buttons, for example.
-- The button is drawn on a state 's1' (eg. menu). It closes s1 and opens a new state 's2' (eg. options).

sButton = Object:extend()

local textMargin = 10			-- How far from the edges of the button the text should be (at least)

--[[
-- Set the button's basic properties
function sButton:new(text, x, y, width, height, s1, s2)
	self.text = text
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	if type(s2) == "string" then 	-- allows for buttons with 'special' functions, such as quitting the program.
		self.s1 = s1				-- By default, buttons will be used to change between two states, though.
		self.s2 = s2
	else
		self.func = s2
	end
	self.on = true
end

function sButton:draw()
	if self.active then
		love.graphics.setColor(80, 80, 80)
	else
		love.graphics.setColor(255, 255, 255)
	end
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	love.graphics.print(self.text, self.x + self.width / 10, self.y + self.height / 3)		--	Used to be self.x + self.width / 4 ;  6.5 is also a good setting
	--love.graphics.printf(self.text, self.x, self.y + self.height / 2, self.width, "center")
end

--]]

-- Set the button's basic properties
function sButton:new(text, x, y, width, height, s1, s2, alignment)
	self.text = text
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	if type(s2) == "string" then 	-- allows for buttons with 'special' functions, such as quitting the program.
		self.s1 = s1				-- By default, buttons will be used to change between two states, though.
		self.s2 = s2
	else
		self.func = s2
	end
	self.alignment = alignment or "centre"
	if string.len(text) * LetterWidth < width - textMargin then
		self.textX = self.x + self.width / 2 - math.floor(string.len(self.text) / 2) * LetterWidth
		self.textLimit = string.len(text) * LetterWidth
		self.textY = self.y + self.height / 2 - 10
	else
		self.textX = self.x + textMargin
		self.textLimit = self.width - textMargin * 2
		self.textY = self.y + self.height / 2 - 20
	end

	self.on = true
end

function sButton:draw()
	if self.active then
		love.graphics.setColor(80, 80, 80)
	else
		love.graphics.setColor(255, 255, 255)
	end
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	if self.alignment == "centre" then
		love.graphics.printf(self.text, self.textX, self.textY, self.textLimit)
	elseif self.alignment == "left" then
		love.graphics.print(self.text, self.x + self.width / 10, self.y + self.height / 3)		--	Used to be self.x + self.width / 4 ;  6.5 is also a good setting
	end
	--love.graphics.printf(self.text, self.x, self.y + self.height / 2, self.width, "center")
end

-- When pressed, the button becomes 'active'. It then changes to its active colour unitl the mouse is released.
function sButton:mousepressed(x, y)
	if not self.on then return end
	if x > self.x and x < self.x + self.width and y > self.y and y < self.y + self.height then
		self.active = true
	end
end

-- Check if the mouse is released on the button, in which case its function is carried out (switching states). Otherwise, the button is simply reset.
function sButton:mousereleased(x, y)
	if not self.on then return end
	if x > self.x and x < self.x + self.width and y > self.y and y < self.y + self.height and self.active then
		self:act()
	end
	self.active = false
end

function sButton:act()
	if self.func then
		self:func()
	else
		lovelyMoon.disableState(self.s1)
		lovelyMoon.enableState(self.s2)
	end
end

function sButton:changeText(newText)
	self.text = newText
end

function sButton:disable()
	self.on = false
end

function sButton:enable()
	self.on = true
end
