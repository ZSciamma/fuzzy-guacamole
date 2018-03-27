-- Not mine (sources given in report):
lovelyMoon = require("lib.lovelyMoon")
Object = require "lib.classic"
require 'lib.tableSer'

-- Mine:
require 'items.stateButton'
require 'items.slider'
require 'items.textInput'
require 'items.scrollBar'
require 'items.notification'
require 'items.confirmation'
require 'items.slideAlert'

require 'comm'
require 'database.tables'

require 'datastructures.queue'


-- Some useful extension functions:

local metaT = getmetatable("")

metaT.__add = function(string1, string2)	--  +
	return string1.."....."..string2
end

function round(number)
	return math.floor(number + 0.5)
end

states = {}

NoAlertStates = {}

local serverTime = 0.1
local serverTimer = serverTime

-- Global variables:


SelectedClass = ""					-- The class currently being viewed by the teacher
CurrentAlert = 0						-- The alert currently onscreen
alerts = Queue()						-- The queue of alerts to be shown to the user. Each of these may be a confirmation or a notification.
TeacherInfo = {}
LetterWidth = 9							-- The width of every letter in the font used
LetterHeight = 8						-- Approximately the average height for letter


serverLoc = "localhost:6789"	-- Will change when server is fixed

function love.load()
	love.window.setMode(1100, 600)
	love.graphics.setBackgroundColor(66, 167, 244)

	love.window.setTitle("Interval Teaching")
	love.keyboard.setKeyRepeat(true)

	font = love.graphics.newFont("RobotoMono-Regular.ttf", 15)
	love.graphics.setFont(font)

	states.startup = lovelyMoon.addState("states.startup", "startup")
	states.createAccount = lovelyMoon.addState("states.createAccount", "createAccount")
	states.login = lovelyMoon.addState("states.login", "login")
	states.menu = lovelyMoon.addState("states.menu", "menu")
	states.classes = lovelyMoon.addState("states.classesList", "classesList")
	states.newClass = lovelyMoon.addState("states.newClass", "newClass")
	states.class = lovelyMoon.addState("states.class", "class")
	states.class = lovelyMoon.addState("states.tournament", "tournament")

	lovelyMoon.enableState("startup")

	serv = Server()
end


function love.update(dt)
	lovelyMoon.events.update(dt)
	if not serv.on then return end
	--if serverTimer <= 0 and not scrollBarMoving() and not scrollerMoving() then
	if serverTimer <= 0 then
		serverTimer = serverTime
		serv:update(dt)
	else
		serverTimer = serverTimer - dt
	end

	if CurrentAlert ~= 0 then CurrentAlert:update(dt) end
end


function love.draw()
	love.graphics.setColor(0, 0, 0)
	lovelyMoon.events.draw()
	if serv.on then serv:draw() end

	if CurrentAlert ~= 0 then CurrentAlert:draw() end

	-- Scrollbar Debug:
	love.graphics.setColor(255, 0, 0)
	if scrollBarMoving() then love.graphics.rectangle("fill", 300, 300, 300, 300) end
	love.graphics.setColor(0, 0, 255)
	if scrollerMoving() then love.graphics.rectangle("fill", 300, 300, 300, 300) end
end

function love.keyreleased(key)
	-- Deal with alert onscreen:
	if CurrentAlert ~= 0 then
		return
	end
	-- No alerts:
	lovelyMoon.events.keyreleased(key)
end

function love.keypressed(key)
	-- Deal with alert onscreen:
	if CurrentAlert ~= 0 then
		return
	end
	-- No alerts:
	lovelyMoon.events.keypressed(key)
end

function love.mousepressed(x, y, button)
	-- Deal with alert onscreen:
	if CurrentAlert ~= 0 then
		CurrentAlert:mousepressed(x, y)
		return
	end
	-- No alerts:
	lovelyMoon.events.mousepressed(x, y)
end

function love.mousereleased(x, y, button)
	-- Deal with alert onscreen:
	if CurrentAlert ~= 0 then
		CurrentAlert:mousereleased(x, y)
		return
	end
	-- No alerts:
	lovelyMoon.events.mousereleased(x, y)
end

function love.wheelmoved(x, y)
	-- Deal with alerts onscreen:
	if alert ~= 0 then
		return
	end
	-- No alerts:
	lovelyMoon.events.wheelmoved(x, y)
end

function love.textinput(text)
	lovelyMoon.events.textinput(text)
end

function love.quit()
	if serverPeer ~= 0 then serverPeer:disconnect_later(); serv:update() end
end

function addAlert(alertType, message, width, height, ...)			-- Type is 'notif' or 'conf' or 'slide'
	local args = {...}						-- Holds variable number of parameters
	local newAlert
	if alertType == "conf" then
		newAlert = Confirmation(message, width, height, args[1], args[2])
	elseif alertType == "notif" then
		newAlert = Notification(message, width, height, args[1] or (function() return end))
	elseif alertType == "slide" then
		newAlert = SlideAlert("", width, height, args[1], args[2], args[3], args[4], args[5], args[6], args[7])
	end
	alerts:enqueue(newAlert)
	checkAlertQueue()
end

function checkAlertQueue()				-- Checks whether it is appropriate to send the next alert in the queue
	if CurrentAlert ~= 0 then return false end 			-- Return if an alert is already onscreen
	for i,s in ipairs(NoAlertStates) do
		if lovelyMoon.isStateEnabled(s) then
			return false
		end
	end
	CurrentAlert = alerts:dequeue()			-- 0 if the alert queue is empty
	return true
end

function voidAlert()					-- Throws away the current alert when the user is done with it
	CurrentAlert = 0
	checkAlertQueue()
end
