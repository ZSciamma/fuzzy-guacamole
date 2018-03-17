-- This file manages communication between the students. Students can only interact through their programs when the teacher app is running.
Server = Object:extend()

require "enet"

local tempConnect = {}        -- Recent connections
local clients = {}
local events = {}

local Info = ""                  -- The information created by the student in order to create a new account or log in.
local creatingNewAccount = false        -- Are we creating a new account or joining an old one?

serverPeer = 0


--StudentID: A student already in the class wants to connect to the class
--JoinRequest: An unknown student wants to join the class


-------------------- LOCAL FUNCTIONS:

local function split(peerMessage)
    local messageTable = {}
    peerMessage = peerMessage..".....9"
    local length = #peerMessage
    local dots = 0
    local last = 1
    for i = 1,length do
        local c = string.sub(peerMessage, i, i)
        if c == '.' then
            dots = dots + 1
        else
            if dots >= 5 then
                local word = string.sub(peerMessage, last, i - 6)
                if word == "0" then word = "" end                     -- Account for the server sending blank info
                last = i 
                table.insert(messageTable, word)
            end
            dots = 0
        end
    end
    return messageTable
end

local function completeNewAccount()
    creatingNewAccount = false
    CompleteNewAccount()
end

local function accountFailed(reason)
    creatingNewAccount = false
    AccountFailed(reason)
end

local function StudentJoinedClass(forename, surname, studentID, classname, level)
    addStudentAccount(forename, surname, studentID, classname, level)
end


local function RejectNewClass(classname, reason)
    -- Tell teacher class is rejected
end

local function RejectNewTournament(classname, reason)
    -- Tell teacher tournament is rejected
end

local function AcceptTeacherID(peer, newTeacherID)
    teacherInfo.TeacherID = newTeacherID
end

local function NewStudentAccepted(peer, forename, surname, email, classname)
    addStudentAccount(forename, surname, email, classname)
end

local function DisplayTournamentRanking(classname, ranking)
    UpdateTournamentRanking(classname, ranking)
end

local function respondToMessage(event)   
    local messageTable = split(event.data)
    local first = messageTable[1]                   -- Find the description attached to the message
    table.remove(messageTable, 1)                   -- Remove the description, leaving only the rest of the data
    local messageResponses = {                      -- Table specfifying the appropriate response to each message description
        ["NewAccountAccept"] = function(peer) completeNewAccount() end,
        ["NewAccountReject"] = function(peer, reason) accountFailed(reason) end,
        ["LoginSuccess"] = function(peer, students, classes, tournaments) CompleteLogin(students, classes, tournaments) end,
        ["LoginFail"] = function(peer, reason) LoginFailed(reason) end,
        ["NewClassReject"] = function (peer, classname, reason) RejectNewClass(classname, reason) end,
        ["NewClassAccept"] = function(peer, classname, classJoinCode) CompleteNewClass(classname, classJoinCode) end,
        ["StudentJoinedClass"] = function(peer, studentID, forename, surname, classname, level) StudentJoinedClass(studentID, forename, surname, classname, level) end,
        ["LogoutSuccess"] = function(peer) LogoutComplete() end,
        ["NewTournamentAccept"] = function(peer, classname, roundTime) NewTournamentAccept(classname, roundTime) end,
        ["TournamentFinished"] = function(peer, classname, ranking) DisplayTournamentRanking(classname, ranking) end,
        
        --["NewStudentAccept"] = function(peer, forename, surname, email, classname) NewStudentAccepted(peer, forename, surname, email, classname) end,
        --["NewTeacherAccept"] = function(peer, newTeacherID) AcceptTeacherID(peer, newTeacherID) end,
        --["NewTournamentAccept"] = function(peer, classname) newTournamentAccept(classname) end,
        --["NewTournamentReject"] = function(peer, classname) RejectNewTournament(classname) end,
        --["WelcomeBackTeacher"] = function(peer) end
    }
    if messageResponses[first] then messageResponses[first](event.peer, unpack(messageTable)) end
end

local function handleEvent(event)
    if event.type == "connect" then
        serverPeer = event.peer
        if creatingNewAccount then
            serverPeer:send("NewTeacherAccount" + Info)
        else
            serverPeer:send("TeacherLogin" + Info)
        end
    elseif event.type == "receive" then 
        respondToMessage(event)
    elseif event.type == "disconnect" then
        --removeClient(event.peer)
    end
end


-------------------- GLOBAL FUNCTIONS:

function Server:new()
    self.on = false
end

function Server:update(dt)
    event = host:service(2)
    if event then 
        table.insert(events, event)
        handleEvent(event) 
    end
end


function Server:draw()
    ---[[
    love.graphics.setColor(0, 0, 0)

    for i, event in ipairs(events) do
        love.graphics.print(event.peer:index().." says "..event.data, 10, 200 + 15 * i)
    end

    for i, client in ipairs(clients) do
        love.graphics.print(client[3], love.graphics.getWidth() - 100, 20)
    end
    --]]
end

function Server:connect()
    host = enet.host_create()
    self.server = host:connect(serverLoc)
end

function Server:CreateNewAccount(name, surname, email, password)
    Info = name + surname + email + password
    creatingNewAccount = true

    if self.server then 
        serverPeer:send("NewTeacherAccount" + Info)
    else
        self:connect() 
    end

    self.on = true
end

function Server:LoginToAccount(email, password)
    Info = email + password
    creatingNewAccount = false

    if self.server then
        serverPeer:send("TeacherLogin" + Info)
    else
        self:connect()
    end

    self.on = true
end

function Server:RequestNewTournament(ClassName, RoundTime, QsPerMatch)
    serverPeer:send("NewTournament" + ClassName + RoundTime + QsPerMatch)
end

function Server:tryLogout()
    if not serverPeer then 
        setAlert("confirmation", "The server cannot be found. Would you like to log out anyway?")
    else
        serverPeer:send("TeacherLogout")
    end
end

function ConfirmNewClass(classname)
    serverPeer:send("NewClass" + classname)
end

function ConfirmNewTournament()

end





