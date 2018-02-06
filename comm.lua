-- This file manages communication between the students. Students can only interact through their programs when the teacher app is running.
Server = Object:extend()

require "enet"

local tempConnect = {}        -- Recent connections
local clients = {}
local events = {}

serverPeer = 0


--StudentID: A student already in the class wants to connect to the class
--JoinRequest: An unknown student wants to join the class

function Server:new()
    host = enet.host_create()  --"172.28.198.21:63176"               -- 192.168.0.12:60472 at home on Mezon2G
                                                                -- "172.28.198.21:63176" 
    host:connect(teacherInfo.serverLoc)

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

    love.graphics.print("TeacherID: "..teacherInfo.TeacherID, love.graphics.getWidth()/2 - 30, 50)

    for i, event in ipairs(events) do
        love.graphics.print(event.peer:index().." says "..event.data, 10, 200 + 15 * i)
    end

    for i, client in ipairs(clients) do
        love.graphics.print(client[3], love.graphics.getWidth() - 100, 20)
    end
end


function handleEvent(event)
    if event.type == "connect" then
        serverPeer = event.peer
        if teacherInfo.TeacherID == "" then
            event.peer:send("NewTeacher" + teacherInfo.myForename + teacherInfo.mySurname + teacherInfo.myEmail + teacherInfo.myPassword)
        else 
            event.peer:send("OfferTeacherID" + teacherInfo.TeacherID + teacherInfo.myPassword)
        end
    elseif event.type == "receive" then 
        respondToMessage(event)
        --[[
        local newClientNo = newClientIndex(event.peer)
        if newClientNo then newClient(event.peer, event.data) end
        receiveInfo(event.peer, event.data)
        --]]
    elseif event.type == "disconnect" then
        --removeClient(event.peer)
    end
end


function respondToMessage(event)   
    local messageTable = split(event.data)
    local first = messageTable[1]                   -- Find the description attached to the message
    table.remove(messageTable, 1)                   -- Remove the description, leaving only the rest of the data
    local messageResponses = {                      -- Table specfifying the appropriate response to each message description
        ["NewClassReject"] = function (peer, classname, reason) RejectNewClass(classname, reason) end,
        ["NewClassAccept"] = function(peer, classname, classJoinCode) AddNewClass(classname, classJoinCode) end,
        ["NewStudentAccept"] = function(peer, forename, surname, email, classname) NewStudentAccepted(peer, forename, surname, email, classname) end,
        ["NewTeacherAccept"] = function(peer, newTeacherID) AcceptTeacherID(peer, newTeacherID) end,
        ["NewTournamentAccept"] = function(peer, classname) newTournamentAccept(classname) end,
        ["NewTournamentReject"] = function(peer, classname) RejectNewTournament(classname) end,
        ["WelcomeBackTeacher"] = function(peer) end
    }
    if messageResponses[first] then messageResponses[first](event.peer, unpack(messageTable)) end
end


function split(peerMessage)
    local messageTable = {}
    for word in peerMessage:gmatch("[^%s,]+") do         -- Possibly write a better expression - try some basic email regex?
        table.insert(messageTable, word)
    end
    return messageTable
end

function ConfirmNewClass(classname)
    serverPeer:send("NewClass" + classname)
end

function ConfirmNewTournament()

end

function AddNewClass(classname, classJoinCode)
    addClass(classname, classJoinCode)
end

function RejectNewClass(classname, reason)
    -- Tell teacher class is rejected
end

function RejectNewTournament(classname, reason)
    -- Tell teacher tournament is rejected
end


function AcceptTeacherID(peer, newTeacherID)
    teacherInfo.TeacherID = newTeacherID
end

function NewStudentAccepted(peer, forename, surname, email, classname)
    addStudentAccount(forename, surname, email, classname)
end

function RequestNewTournament(ClassName, MaxDuration, Matches)
    serverPeer:send("NewTournament" + ClassName + MaxDuration + Matches)
end

