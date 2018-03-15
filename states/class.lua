local state = {}
local students = {}

local backB = sButton("Back", 100, 100, 50, 50, "class", "classesList")
local nextB = sButton("New Tournament", love.graphics.getWidth() - 150, 100, 50, 50, "class", function() NewTournamentRequest() end)

local scroller = ScrollBar()


function state:new()
	return lovelyMoon.new(self)
end


function state:load()

end


function state:close()
end


function state:enable()
	students = studentList(SelectedClass) 

	if IsInTournament(SelectedClass) then		-- check if selected class has tournament going
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

function NewTournamentRequest()		-- Request a new tournament from the server
	if not IsInTournament(SelectedClass) then
		addAlert("slide", "Hey", 500, 500, 300, function() TeacherInfo.TournamentRoundTime = CurrentAlert.slider1:value(1); TeacherInfo.TournamentMatchQuestions = CurrentAlert.slider2:value(5); serv:RequestNewTournament(SelectedClass, TeacherInfo.TournamentRoundTime, TeacherInfo.TournamentMatchQuestions) end)				
	else
		lovelyMoon.switchState("class", "tournament")
	end
end

function NewTournamentAccept(classname, roundTime)	-- Once the new tournament has been accepted by the server, it is added to the teacher's data
	addTournament(classname, roundTime)	
	nextB:changeText("Tournament")
	if lovelyMoon.isStateEnabled("class") then
		lovelyMoon.switchState("class", "tournament")
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