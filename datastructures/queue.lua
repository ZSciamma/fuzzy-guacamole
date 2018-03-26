-- This file creates an object representing a queue (using FIFO: first in, last out).
-- The methods implemented here were considered necessary (or added for completeness);
-- some standard queue functions which were not considered useful for this program may have been omitted.

Queue = Object:extend()

function Queue:new() 		-- Called upon creating a new queue. Initialises the attributes needed.
	-- Head and tail pointers were unnecessary here because of the nature of tables in Lua
	self.items = {}
	self.length = 0
end

function Queue:enqueue(item)			-- Add an item to the end of the queue
	table.insert(self.items, item)		-- Adds value at end of list
	self.length = self.length + 1
	return true
end


function Queue:dequeue()				-- Remove and return the item at the front of the queue
	if self:isEmpty() then return 0 end
	local head = table.remove(self.items, 1)			-- First value removed
	self.length = self.length - 1
	return head
end


function Queue:peek() 					-- Return the item at the front of the queue without removing it
	if self:isEmpty() then return end
	return self.items[1]
end


function Queue:isEmpty()	-- True if no item is in the queue; false otherwise.
	if self.length == 0 then
		return true
	else
		return false
	end
end

-- Queue:isFull() function unnecessary as tables in Lua are dynamic
