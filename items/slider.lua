Slider = Object:extend()
local nodeDist = 50					-- Distance between nodes
local width = 10
local radius = 15					-- Radius of the pointer

function Slider:new(x, y, length, nodeValue, text)
	self.x = x
	self.y = y
	self.cX = self.x + nodeDist
	self.cY = y
	self.nodeValue = nodeValue
	self.text = text

	self.active = false
	self.length = length

	self.offsetX = 0		-- Corrects for the position of the mouse when the slider is first moved
end

function Slider:update(dt)
	local mouseX = love.mouse.getX()
	if self.active == false then return end
	if mouseX - self.offsetX > self.x + self.length then
		self.cX = self.x + self.length
		return
	elseif mouseX - self.offsetX < self.x then
		self.cX = self.x
		return
	end
	self.cX = mouseX - self.offsetX
end

function Slider:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle("fill", self.x, self.y, self.length, width)

	love.graphics.setColor(0, 0, 0)											-- Bar outline
	love.graphics.rectangle("line", self.x, self.y, self.length, width)
															-- Circle pointer (sliding part)
	love.graphics.setColor(0, 0, 0)
	love.graphics.circle("fill", self.cX, self.cY + width / 2, radius)

	love.graphics.print(self.text..tostring(self:value()), self.x, self.y - 75)

end

function Slider:mousepressed(x, y)
	if math.pow(x - self.cX, 2) + math.pow(y - self.cY, 2) <= math.pow(radius, 2) then		-- Pythagoras to see if mouse is within pointer
		self.active = true
		self.offsetX = x - self.cX
	end
end

function Slider:mousereleased(x, y)
	if self.active == false then return end
	self:adjustCircle()
	self.active = false
end

-- Ensures the circle pointer places itself on one of the slider's nodes:
function Slider:adjustCircle()
	r = (self.cX - self.x) % nodeDist								-- Checks how far the pointer is from a node
	if r < nodeDist / 2 then										-- Moves pointer to nearest node
		self.cX = self.cX - r
	else
		self.cX = self.cX + nodeDist - r
	end

	if self.cX <= self.x then 						-- Reposition to first node if pointer is on 0
		self.cX = self.x + nodeDist
	end
	return
end

function Slider:value()
	return self.nodeValue * (self.cX - self.x) / nodeDist						-- Returns the value selected on the slider
end
