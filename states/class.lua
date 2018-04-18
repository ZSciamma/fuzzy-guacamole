local state = {}
local students = {}

local backB = sButton("Back", 100, 100, 100, 50, "class", "classesList")
local nextB = sButton("Tournaments", love.graphics.getWidth() - 200, 100, 150, 50, "class", "tournament")

local scroller = ScrollBar()


-------------------- LOCAL FUNCTIONS:

local function StrongestInt(ratings)
	local highest = 0
	local interval = 0
	local current = 1
	for int in string.gmatch(ratings, "[^.]+") do
		if tonumber(int) > highest and tonumber(int) ~= 0 then
			highest = tonumber(int)
			interval = current
		end
		current = current + 1
	end
	return intervals[math.floor((interval + 1) / 2)]
end

local function WeakestInt(ratings)
	local lowest = 1000
	local interval = 0
	local current = 1
	for int in string.gmatch(ratings, "[^.]+") do
		if tonumber(int) < lowest and tonumber(int) ~= 0 then
			lowest = tonumber(int)
			interval = current
		end
		current = current + 1
	end
	return intervals[math.floor((interval + 1) / 2)]
end


-------------------- GLOBAL FUNCTIONS:

function state:new()
	return lovelyMoon.new(self)
end

function state:load()

end

function state:close()
end

function state:enable()
	students = studentList(SelectedClass)

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
	nextB:draw()

	love.graphics.print("Student", 100, 200 )
	love.graphics.print("Level", 400, 200)
	love.graphics.print("Strongest Interval", 500, 200)
	love.graphics.print("Weakest Interval", 700, 200)
	love.graphics.print("Correct", 900, 200)
	for i,student in ipairs(students) do
		love.graphics.print(student.Forename.." "..student.Surname, 100, 220 + 40 * i)
		love.graphics.print(student.Level, 400, 220 + 40 * i)
		love.graphics.print(StrongestInt(student.Ratings), 500, 220 + 40 * i)
		love.graphics.print(WeakestInt(student.Ratings), 700, 220 + 40 * i)
		if student.Statistics[1] == 0 then
			love.graphics.print("100%", 900, 220 + 40 * i)
		else
			love.graphics.print(math.floor((100 * student.Statistics[2] / student.Statistics[1]) + 0.5).."%", 900, 220 + 40 * i)
		end
	end
end

function state:keypressed(key, unicode)

end

function state:keyreleased(key, unicode)

end

function state:mousepressed(x, y, button)
	backB:mousepressed(x, y + scroller.y)
	nextB:mousepressed(x, y + scroller.y)
end

function state:mousereleased(x, y, button)
	backB:mousereleased(x, y + scroller.y)
	nextB:mousereleased(x, y + scroller.y)
end

function state:wheelmoved(x, y)
	scroller:wheelmoved(x, y)
end

function scrollBarMoving()
	if scroller:isMoving() then
		return true
	else
		return false
	end
end

return state
