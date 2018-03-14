local state = {}
local classButtons = {}

local backB = sButton("Back", 100, 100, 50, 50, "classesList", "menu")

local scroller = ScrollBar()

function state:new()
	return lovelyMoon.new(self)
end


function state:load()

end


function state:close()
end


function state:enable()
	classButtons = {}
	for i,class in ipairs(Class) do
		local classname = class.ClassName
		table.insert(classButtons, sButton(classname, 400 + 300 * ((i - 1) % 2), 100 + 150 * (math.floor((i - 1) / 2)), 200, 100, "classesList", function() goToClass(classname) end))
	end

	SelectedClass = ""			-- If user is here, then no class has been selected yet
	scroller:On()
	scroller:resetPosition()
end


function state:disable()
	scroller:Off()
end


function state:update(dt)
	scroller:update(dt)
end


function state:draw()
	scroller:draw()										-- Must be first so as to be unaffected by the translation

	love.graphics.translate(0, -scroller.y)				-- Makes scroller scroll down the page
	backB:draw()

	for i,class in ipairs(Class) do
		love.graphics.print(class.ClassName, 500, 200 + i * 20)
		love.graphics.print(class.JoinCode, 650, 200 + i * 20)
		love.graphics.print(studentNumber(class.ClassName), 800, 200 + i * 20)
	end

	for i,button in ipairs(classButtons) do
		button:draw()
	end
end

function state:keypressed(key, unicode)

end

function state:keyreleased(key, unicode)

end

function state:mousepressed(x, y, button)
	backB:mousepressed(x, y + scroller.y)
	for i,button in ipairs(classButtons) do
		button:mousepressed(x, y + scroller.y)
	end
end

function state:mousereleased(x, y, button)
	backB:mousereleased(x, y + scroller.y)
	for i,button in ipairs(classButtons) do
		button:mousereleased(x, y + scroller.y)
	end
end

function state:wheelmoved(x, y)
	scroller:wheelmoved(x, y)
end

function goToClass(classname)		-- Move to the 'class' screen, storing the name of the selected class in a global variable
	SelectedClass = classname

	lovelyMoon.disableState("classesList")
	lovelyMoon.enableState("class")
end

function scrollerMoving()
	if scroller:isMoving() then 
		return true
	else
		return false
	end
end

return state