local state = {}
local students = {}

local backB = sButton("Back", 100, 100, 50, 50, "class", "classesList")
local nextB = sButton("New Tournament", love.graphics.getWidth() - 150, 100, 50, 50, "class", function() newTournamentRequest() end)

local scroller = ScrollBar()


function state:new()
	return lovelyMoon.new(self)
end


function state:load()

end


function state:close()
end


function state:enable()
	students = studentList(selectedClass) 

	if IsInTournament(selectedClass) then		-- check if selected class has tournament going
		nextB:changeText("Tournament")
	else
		nextB:changeText("New Tournament")
	end

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
	for i,student in ipairs(students) do
		love.graphics.print(student.Forename, 200, 200 + i * 30)
		love.graphics.print(student.Surname, 400, 200 + i * 30)
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

function newTournamentRequest()
	if not IsInTournament(selectedClass) then 	
		RequestNewTournament(selectedClass, 10, 5)				-- DEBUG: ADJUST FOR USER INPUT
	else
		lovelyMoon.disableState("class")
		lovelyMoon.enableState("tournament")
	end
end

function newTournamentAccept()
	addTournament(selectedClass, 10, 5)							-- DEBUG: ADJUST FOR USER INPUT
	if lovelyMoon.isStateEnabled("class") then
		lovelyMoon.disableState("class")
		lovelyMoon.enableState("tournament")
	end
end

function scrollBarMoving()
	if scroller:isMoving() then 
		return true 
	else
		return false
	end
end

return state