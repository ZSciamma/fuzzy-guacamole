local state = {}

local ranking = {}

local backB = sButton("Back", 100, 100, 100, 50, "tournament", "class")
local nextB = sButton("New Tournament", love.graphics.getWidth() - 150, 100, 100, 50, "class", function() NewTournamentRequest() end)

local scroller = ScrollBar()


function state:new()
	return lovelyMoon.new(self)
end


function state:load()

end


function state:close()
end


function state:enable()
	local finalRanks = FetchTournamentRanking(SelectedClass)
	if finalRanks then ranking = ReturnRankedStudents(finalRanks) end

	scroller:On()
	scroller:resetPosition()
end


function state:disable()
	ranking = {}
	scroller:Off()
end


function state:update(dt)
	scroller:update(dt)
end


function state:draw()
	scroller:draw()
	backB:draw()
	if not IsInTournament(SelectedClass) then
		nextB:draw()
	end

	love.graphics.setColor(0, 0, 0)
	if ranking ~= {} then
		love.graphics.print("Position", 100, 200)
		love.graphics.print("Student", 200, 200 )
		love.graphics.print("Score", 600, 200)
		love.graphics.printf("Tournament Results: ", love.graphics.getWidth() / 2 - 10 * LetterWidth, 100, LetterWidth * 20, "center")
		for i,student in pairs(ranking) do
			love.graphics.print(i, 100, 220 + 40 * i)
			love.graphics.print(student.Name, 200, 220 + 40 * i)
			love.graphics.print(student.Score, 600, 220 + 40 * i)
		end
	else
		love.graphics.printf("Tournament ongoing. Check back later to see the final score!", love.graphics.getWidth() / 2 - LetterWidth * 30, 300, LetterWidth * 60, "center")
	end
end


function state:keypressed(key, unicode)

end


function state:keyreleased(key, unicode)

end


function state:mousepressed(x, y, button)
	backB:mousepressed(x, y)
	if not IsInTournament(SelectedClass) then
		nextB:mousepressed(x, y)
	end
end


function state:mousereleased(x, y, button)
	backB:mousereleased(x, y)
	if not IsInTournament(SelectedClass) then
		nextB:mousereleased(x, y)
	end
end

function NewTournamentRequest()		-- Request a new tournament from the server
	if not IsInTournament(SelectedClass) then
		addAlert("slide", "", 500, 500, 300, 1, 5, "Days per round: ", "Questions per match: ", function() TeacherInfo.TournamentRoundTime = CurrentAlert.slider1:value(); TeacherInfo.TournamentMatchQuestions = CurrentAlert.slider2:value(); serv:RequestNewTournament(SelectedClass, TeacherInfo.TournamentRoundTime, TeacherInfo.TournamentMatchQuestions) end, function() end)
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

function state:wheelmoved(x, y)
	scroller:wheelmoved(x, y)
end

return state
