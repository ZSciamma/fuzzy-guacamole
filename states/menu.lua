-- This is the main menu. The teacher is brought here upon launching the application and can return after managing classes.

local state = {}

-- The list of state changes required is as follows (from the first state to the second state within each bracket):


menuButtons = {}
menuButtonInfo = {
	{ "Classes", "classesList" },			-- { Button text, state name }
	{ "New Class", "newClass" },
	{ "Log Out", function() Logout() end }
}

for i, button in ipairs(menuButtonInfo) do
	table.insert(menuButtons, sButton(button[1], 400, 50 + 100 * i, 300, 50, "menu", button[2]))				-- DRY: most parameters are common to every button in the menu
end



function state:new()
	return lovelyMoon.new(self)

end


function state:load()

end


function state:close()
end


function state:enable()
	SelectedClass = ""		-- If user is here, then no class has been selected yet
end


function state:disable()

end


function state:update(dt)

end


function state:draw()
	for i, button in ipairs(menuButtons) do
		button:draw()
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("line", button.x, button.y, button.width, button.height)

	end
end

function state:keypressed(key, unicode)
	if key == 's' then lovelyMoon.disableState("menu"); lovelyMoon.enableState("soloSetup") end
end

function state:keyreleased(key, unicode)

end

function state:mousepressed(x, y)
	for i, button in ipairs(menuButtons) do
		button:mousepressed(x, y)
	end

end

function state:mousereleased(x, y)
	for i, button in ipairs(menuButtons) do
		button:mousereleased(x, y)
	end
end

function Logout()					-- When the logout button is pressed, the program attempts to log out
	serv:tryLogout()
end

function LogoutComplete()			-- When the server confirms the logout, the program returns to the startup screen.
	lovelyMoon.switchState("menu", "startup")
end

return state
