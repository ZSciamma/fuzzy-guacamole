local state = {}

--local thing = ""

local loginInputs = {
	Email = textInput("Email", 400, 150, 300, 25),
	Password = textInput("Password", 400, 200, 300, 25, true)
}

local backB = sButton("Back", 100, 100, 50, 50, "login", "startup")
local enterB = sButton("Log In", 400, 450, 300, 75, "login", function() ValidateLogin() end)

local errorReason = ""					-- Why the user's account creation failed
local serverWaitTime = 5				-- Time after which the server is declared unavaliable
local serverWaitTimer = serverWaitTime
local serverTried = false				-- Are we trying to connect to the server?


function state:new()
	return lovelyMoon.new(self)
end

function state:load()

end

function state:close()
end

function state:enable()
	for i,input in pairs(loginInputs) do
		input:enable()
	end
end

function state:disable()
	for i,input in pairs(loginInputs) do
		input:disable()
	end
	LoginFailed() 					-- Reset errors and timers
end

function state:update(dt)
	for i,input in pairs(loginInputs) do
		input:update(dt)
	end

	if serverTried then
		if serverWaitTimer <= 0 then 
			LoginFailed("The server is currently unavaliable. Please try again later.")
		else
			serverWaitTimer = serverWaitTimer - dt
		end
	end
end

function state:draw()
	backB:draw()
	enterB:draw()

	for i,input in pairs(loginInputs) do
		input:draw()
	end

	love.graphics.setColor(255, 0, 0)
	love.graphics.print(errorReason, 400, 415)

	--love.graphics.print(thing, 300, 300)
end

function state:keypressed(key, unicode)
	for i,input in pairs(loginInputs) do
		input:keypressed(key)
	end
end

function state:keyreleased(key, unicode)
	for i,input in pairs(loginInputs) do
		input:keyreleased(key)
	end
end

function state:mousepressed(x, y, button)
	backB:mousepressed(x, y)
	enterB:mousepressed(x, y)
	for i,input in pairs(loginInputs) do
		input:mousepressed(x, y)
	end
end

function state:mousereleased(x, y, button)
	backB:mousereleased(x, y)
	enterB:mousereleased(x, y)
	for i,input in pairs(loginInputs) do
		input:mousereleased(x, y)
	end
end


function ValidateLogin()
	local email = loginInputs.Email.text
	local password = loginInputs.Password.text
	if email == "" or password == "" then
		LoginFailed("Please fill in all fields.")
		return
	end

	LoginFailed()
	serverTried = true
	serverWaitTimer = serverWaitTime

	local failureReason = serv:LoginToAccount(email, password)
	if failureReason then LoginFailed(failureReason) end
end

function CompleteLogin(students, classes, tournaments)
	--thing = classes
	StudentAccount = loadstring(students)() or {}
	Class = loadstring(classes)() or {}					--{ eg. { ClassName = "hi", JoinCode = 098 } }
	Tournament = loadstring(tournaments)() or {}
	--serv.on = false
	lovelyMoon.disableState("login")
	lovelyMoon.enableState("menu")
end

function LoginFailed(reason)
	errorReason = reason or ""
	serverTried = false
	serverWaitTimer = serverWaitTime
end

return state