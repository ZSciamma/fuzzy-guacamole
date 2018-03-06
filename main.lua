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


teacherInfo = {}
StudentAccount = {}
Class = {}
Tournament = {}

serverLoc = "localhost:6789"	-- Will change when server is fixed

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

serverTime = 0.1
serverTimer = serverTime
selectedClass = ""					-- The class currently being viewed by the teacher
alert = 0

function love.load()
	love.window.setMode(1100, 600)
	love.graphics.setBackgroundColor(66, 167, 244)

	love.window.setTitle("Interval Teaching")

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

	if alert ~= 0 then alert:update(dt) end
end


function love.draw()
	love.graphics.setColor(0, 0, 0)
	lovelyMoon.events.draw()
	if serv.on then serv:draw() end
	--[[
	-- Scrollbar Debug:
	love.graphics.setColor(255, 0, 0)
	if scrollBarMoving() then love.graphics.rectangle("fill", 300, 300, 300, 300) end
	love.graphics.setColor(0, 0, 255)
	if scrollerMoving() then love.graphics.rectangle("fill", 300, 300, 300, 300) end
	--]]

	if alert ~= 0 then alert:draw() end
end

function love.keyreleased(key)
	-- Deal with alerts onscreen:
	if alert ~= 0 then
		return
	end
	-- No alerts:
	lovelyMoon.events.keyreleased(key)
end

function love.keypressed(key)
	-- Deal with alerts onscreen:
	if alert ~= 0 then
		return
	end
	-- No alerts:
	lovelyMoon.events.keypressed(key)
end

function love.mousepressed(x, y, button)
	-- Deal with alerts onscreen:
	if alert ~= 0 then
		alert:mousepressed(x, y)
		return
	end
	-- No alerts:
	lovelyMoon.events.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	-- Deal with alerts onscreen:
	if alert ~= 0 then
		alert:mousereleased(x, y)
		return
	end
	-- No alerts:
	lovelyMoon.events.mousereleased(x, y, button)
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
