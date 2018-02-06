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

require 'comm'
require 'database.tables'

	--************ SAVED IN FILE: *************--
	-- Make student input this upon opening the app:
if not love.filesystem.exists("TeacherInfoSave") then
	teacherInfo = {
		new = true,						-- True if the user has never opened the app (and so not set the profile and class information)
		myForename = "Mr",
		mySurname = "Bob",
		myEmail = "blub.blub@gmail.com",	
		profileComplete = true, 			-- Default to true
		ClassName = "",
		serverLoc = "localhost:6789",	-- Will change when server is fixed
		TeacherID = "",
		myPassword = "Borgalorg",			-- Teacher's password, set upon starting the app for the first time
		classes = {},
	}
else
	teacherInfo = loadstring(love.filesystem.read("TeacherInfoSave"))()
end
	--******************************************--

-- Some useful extension functions for strings:

local metaT = getmetatable("")

metaT.__add = function(string1, string2)	--  + 
	return string1..", "..string2
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

serverTime = 1
serverTimer = serverTime
selectedClass = ""					-- The class currently being viewed by the teacher


function love.load()
	love.window.setMode(1100, 600)
	love.graphics.setBackgroundColor(66, 167, 244)

	love.window.setTitle("Interval Teaching")

	states.menu = lovelyMoon.addState("states.menu", "menu")
	states.classes = lovelyMoon.addState("states.classesList", "classesList")
	states.options = lovelyMoon.addState("states.options", "options")
	states.stats = lovelyMoon.addState("states.stats", "stats")
	states.newClass = lovelyMoon.addState("states.newClass", "newClass")
	states.class = lovelyMoon.addState("states.class", "class")
	states.class = lovelyMoon.addState("states.tournament", "tournament")

	lovelyMoon.enableState("menu")

	serv = Server()

	serv.on = true							-- Comment to speed up the app and smooth the scrollbar
end


function love.update(dt)
	lovelyMoon.events.update(dt)
	if serverTimer <= 0 and not scrollBarMoving() and not scrollerMoving() then
		serverTimer = serverTime
		if serv.on then serv:update(dt) end
	else 
		serverTimer = serverTimer - dt
	end
end


function love.draw()
	love.graphics.setColor(0, 0, 0)
	lovelyMoon.events.draw()
	if serv.on then serv:draw() end
	love.graphics.setColor(255, 0, 0)
	if scrollBarMoving() then love.graphics.rectangle("fill", 300, 300, 300, 300) end
	love.graphics.setColor(0, 0, 255)
	if scrollerMoving() then love.graphics.rectangle("fill", 300, 300, 300, 300) end
end

function love.keyreleased(key)
	lovelyMoon.events.keyreleased(key)
end

function love.keypressed(key)
	lovelyMoon.events.keypressed(key)
end

function love.mousepressed(x, y, button)
	lovelyMoon.events.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	lovelyMoon.events.mousereleased(x, y, button)
end 

function love.wheelmoved(x, y)
	lovelyMoon.events.wheelmoved(x, y)
end

function love.quit()
	love.filesystem.write("TeacherInfoSave", table.serialize(teacherInfo))

	love.filesystem.write("StudentAccountSave", table.serialize(StudentAccount))
	love.filesystem.write("ClassSave", table.serialize(Class))
	love.filesystem.write("TournamentSave", table.serialize(Tournament))

	if serverPeer ~= 0 then serverPeer:disconnect_later(); serv:update() end
end
