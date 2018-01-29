-- This file manages communication between the students. Students can only interact through their programs when the teacher app is running.
Server = Object:extend()

require "enet"

tempConnect = {}        -- Recent connections
clients = {}
events = {}

function Server:new()
    host = enet.host_create "192.168.0.12:60472"                -- 192.168.0.12:60472 at home on Mezon2G
    
    hostReceived = 0
end

function Server:update(dt)
    event = host:service(100)
    if event then 
        table.insert(events, event)
        handleEvent(event) 
    end
end


function Server:draw()
    for i, event in ipairs(events) do
        love.graphics.print(event.peer:index().." says "..event.data, 10, 200 + 15 * i)
    end

    for i, client in ipairs(clients) do
        love.graphics.print(client[3], love.graphics.width() - 100, 20)
    end
end


function handleEvent(event)
    if event.type == "connect" then
        hostReceived = hostReceived + 1
        table.insert(tempConnect, peer)
    elseif event.type == "receive" then 
        local newClientNo = newClientIndex(event.peer)
        if newClientNo then newClient(event.peer, event.data) end

        receiveInfo(event.peer, event.data)
    elseif event.type == "disconnect" then
        removeClient(event.peer)
    end
end


function newClient(peer, greeting)                          -- Adds the new client to the list                 
    local info = { index = peer:index() }
    for i in string.gmatch(greeting, "[,]%S") do            -- Splits the hello message into forename, surname and email
        table.insert(info, i)
    end
    table.insert(clients, info)
end


function receiveInfo(peer, data)

end


function removeClient(peer)                                 -- Removes disconnected clients from the table
    local remove = findClientIndex(peer)
    if remove then table.remove(remove) end
end


function findClientIndex(peer)                              -- Uses peer index to locate them in clients table
    local index = peer:index()
    for i, client in ipairs(clients) do 
        if client.index == index then 
            return i
        end
    end
    return nil
end


function newClientIndex(peer)
    local index = peer:index()
    for i, client in ipairs(tempConnect) do 
        if client.index == index then 
            return i
        end
    end
    return nil
end