lovelyMoon = require("lib.lovelyMoon")
Object = require "lib.classic"

require 'items.stateButton'
require 'items.ansButton'
require 'items.slider'
require 'items.textInput'
require 'items.scrollBar'

require 'comm'

-- Some useful extension functions for strings:

local metaT = getmetatable("")

metaT.__add = function(string1, string2)	--  + 
	return string1..string2
end

metaT.__mul = function(string1, toAdd)		--  * Adds t after the (i-1)th letter; toAdd = { letter, index }
	local length = string.len(string1)
	return string.sub(string1, 1, toAdd[2] - 1) + toAdd[1] + string.sub(string1, toAdd[2])
end

metaT.__div = function(string1, i)			-- / Removes the ith letter
	local length = string.len(string1)
	return string.sub(string1, 1, i - 1) + string.sub(string1, i + 1)
end

states = {}


function love.load()
	love.window.setMode(1100, 600)
	love.graphics.setBackgroundColor(66, 167, 244)

	love.window.setTitle("Interval Teaching")

	states.menu = lovelyMoon.addState("states.menu", "menu")
	states.classes = lovelyMoon.addState("states.classes", "classesList")
	states.options = lovelyMoon.addState("states.options", "options")
	states.stats = lovelyMoon.addState("states.stats", "stats")
	states.newClass = lovelyMoon.addState("states.newClass", "newClass")

	lovelyMoon.enableState("menu")

	serv = Server()
end


function love.update(dt)
	lovelyMoon.events.update(dt)
	serv:update(dt)
end


function love.draw()
	lovelyMoon.events.draw()
	serv:draw()
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
	lovelyMoon.events.wheelmoved(x, y, button)
end
