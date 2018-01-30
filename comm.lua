-- This file manages communication between the students. Students can only interact through their programs when the teacher app is running.
Server = Object:extend()

require "enet"

tempConnect = {}        -- Recent connections
clients = {}
events = {}

thing = "";

--StudentID: A student already in the class wants to connect to the class
--JoinRequest: An unknown student wants to join the class

function Server:new()
    host = enet.host_create (loc) --"172.28.198.21:63176"               -- 192.168.0.12:60472 at home on Mezon2G
                                                                -- "172.28.198.21:63176" 
    hostReceived = 0

    self.on = true
end

function Server:update(dt)
    event = host:service(100)
    if event then 
        table.insert(events, event)
        handleEvent(event) 
    end
end


function Server:draw()
    love.graphics.setColor(0, 0, 0)

    for i, event in ipairs(events) do
        love.graphics.print(event.peer:index().." says "..event.data, 10, 200 + 15 * i)
    end

    for i, client in ipairs(clients) do
        love.graphics.print(client[3], love.graphics.getWidth() - 100, 20)
    end

    for i, student in ipairs(StudentAccount) do
        love.graphics.print(student.Forename..", "..student.ClassName, love.graphics.getWidth() - 300, 50 + i * 20)
    end

    love.graphics.print(thing, 400, 400)
end


function handleEvent(event)
    if event.type == "connect" then
        hostReceived = hostReceived + 1
        table.insert(tempConnect, peer)
    elseif event.type == "receive" then 
        respondToMessage(event)
        --[[
        local newClientNo = newClientIndex(event.peer)
        if newClientNo then newClient(event.peer, event.data) end
        receiveInfo(event.peer, event.data)
        --]]
    elseif event.type == "disconnect" then
        removeClient(event.peer)
    end
end


function respondToMessage(event)   
    local messageTable = split(event.data)
    local first = messageTable[1]                   -- Find the description attached to the message
    table.remove(messageTable, 1)                   -- Remove the description, leaving only the rest of the data
    local messageResponses = {                      -- Table specfifying the appropriate response to each message description
        ["JoinRequest"] = function(peer, forename, surname, email, className) addNewStudent(peer, forename, surname, email, className) end,
        ["StudentID"] = function(StudentID) receiveStudentID(StudentID) end
    }
    if messageResponses[first] then messageResponses[first](event.peer, unpack(messageTable))end
end

--[[
function newClient(peer, greeting)                      -- Adds the new client to the list                 
    local info = { index = peer:index() }
    for i in string.gmatch(greeting, "[,]%S") do        -- Splits the hello message into forename, surname and email
        table.insert(info, i)
    end
    table.insert(clients, info)
end
--]]

function split(peerMessage)
    local messageTable = {}
    for word in peerMessage:gmatch("[^%s,]+") do         -- Possibly write a better expression - try some basic email regex?
        thing = word
        table.insert(messageTable, word)
    end
    return messageTable
end

function addNewStudent(peer, forename, surname, email, classname)
    if not ClassExists(classname) then 
        peer:send("FailedToJoinClass")
    end

    addStudentAccount(forename, surname, email, classname)
end

--[[

function receiveInfo(peer, data)

end


function removeClient(peer)                             -- Removes disconnected clients from the table
    local remove = findClientIndex(peer)
    if remove then table.remove(remove) end
end


function findClientIndex(peer)                          -- Uses peer index to locate them in clients table
    local index = peer:index()
    for i, client in ipairs(clients) do 
        if client.index == index then 
            return i
        end
    end
    return nil
end


function newClientIndex(peer)                           -- Returns the index of a client who has just connected
    local index = peer:index()
    for i, client in ipairs(tempConnect) do 
        if client.index == index then 
            return i
        end
    end
    return nil
end

--]]
function receiveStudentID(StudentID)
    -- Check for ID in database
    -- Add ID to clients list
    -- If ID is correct
    -- Reply "StudentID Received" or "StudentID Invalid"
    return true
end