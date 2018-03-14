-- Not mine (sources given in report):
lovelyMoon = require("lib.lovelyMoon")
Object = require "lib.classic"
require 'lib.tableSer'

-- Mine:
require 'items.stateButton'
require 'items.ansButton'
require 'items.slider'
require 'items.textInput'
require 'items.scrollBar'
require 'items.notification'
require 'items.confirmation'
require 'items.slideAlert'

require 'comm'
require 'database.tables'

require 'datastructures.queue'


-- Some useful extension functions for strings:

local metaT = getmetatable("")

metaT.__add = function(string1, string2)	--  + 
	return string1.."....."..string2
end

metaT.__mul = function(string1, toAdd)		--  * Adds t after the (i-1)th letter; toAdd = { letter, index }
	local length = string.len(string1)
	return string.sub(string1, 1, toAdd[2] - 1)..toAdd[1]..string.sub(string1, toAdd[2])
end

metaT.__div = function(string1, i)			-- / Removes the ith letter
	local length = string.len(string1)
	return string.sub(string1, 1, i - 1)..string.sub(string1, i + 1)
end


function isSub(table, subTable)				-- Check if every item in subTable is in table (recursive)
	if subTable == {} then return true end
	for i, j in ipairs(table) do 
		if j == subTable[1] then
			table.remove(subTable, 1)
			return isSub(table, subTable)
		end
	end
end

function itemIn(table, item)		-- Is the item in the table?
	for i,j in ipairs(table) do
		if j == item then return true end
	end
	return false
end



states = {}

NoAlertStates = {}

local serverTime = 0.1
local serverTimer = serverTime

-- Global variables:


SelectedClass = ""					-- The class currently being viewed by the teacher
CurrentAlert = 0						-- The alert currently onscreen						
alerts = Queue()						-- The queue of alerts to be shown to the user. Each of these may be a confirmation or a notification.
TournamentRoundTime = 0
TeacherInfo = {}


serverLoc = "localhost:6789"	-- Will change when server is fixed

function love.load()
	love.window.setMode(1100, 600)
	love.graphics.setBackgroundColor(66, 167, 244)

	love.window.setTitle("Interval Teaching")

	font = love.graphics.newFont("RobotoMono-Regular.ttf", 15)
	love.graphics.setFont(font)

	states.startup = lovelyMoon.addState("states.startup", "startup")
	states.createAccount = lovelyMoon.addState("states.createAccount", "createAccount")
	states.login = lovelyMoon.addState("states.login", "login")
	states.menu = lovelyMoon.addState("states.menu", "menu")
	states.classes = lovelyMoon.addState("states.classesList", "classesList")
	states.options = lovelyMoon.addState("states.options", "options")
	states.statistics = lovelyMoon.addState("states.statistics", "statistics")
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

	--[[
	-- Scrollbar Debug:
	love.graphics.setColor(255, 0, 0)
	if scrollBarMoving() then love.graphics.rectangle("fill", 300, 300, 300, 300) end
	love.graphics.setColor(0, 0, 255)
	if scrollerMoving() then love.graphics.rectangle("fill", 300, 300, 300, 300) end
	--]]
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

function love.quit()
	if serverPeer ~= 0 then serverPeer:disconnect_later(); serv:update() end
end

function addAlert(alertType, message, width, height, arg1, arg2)			-- Type is 'notif' or 'conf' or 'slide'
	local newAlert
	if alertType == "conf" then			
		newAlert = Confirmation(width, height, arg1, arg2)
	elseif alertType == "notif" then 
		newAlert = Notification(width, height, arg1 or (function() return end))
	elseif alertType == "slide" then
		newAlert = SlideAlert(width, height, arg1, arg2)
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
	if checkAlertQueue() then return end
	CurrentAlert = 0
end

