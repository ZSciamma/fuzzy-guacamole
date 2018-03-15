local state = {}

local createNewAccount = sButton("Create New Account", 400, 100, 300, 100, "startup", "createAccount")
local loginToAccount = sButton("Login to Account", 400, 300, 300, 100, "startup", "login")

function state:new()
	return lovelyMoon.new(self)
end


function state:load()

end


function state:close()
end


function state:enable()
	TeacherInfo = {						-- Reset to this if the teacher logs out
		TournamentRoundTime = 0,
		TournamentMatchQuestions = 0,
	}
end

function state:disable()

end


function state:update(dt)
end


function state:draw()
	createNewAccount:draw()
	loginToAccount:draw()	
end

function state:keypressed(key, unicode)

end

function state:keyreleased(key, unicode)

end

function state:mousepressed(x, y, button)
	createNewAccount:mousepressed(x, y)
	loginToAccount:mousepressed(x, y)
end

function state:mousereleased(x, y, button)
	createNewAccount:mousereleased(x, y)
	loginToAccount:mousereleased(x, y)
end

return state