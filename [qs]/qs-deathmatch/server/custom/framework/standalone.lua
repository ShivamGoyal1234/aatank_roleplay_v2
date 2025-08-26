if Config.Framework ~= 'standalone' then
    return
end

local serverCallbacks = {}
local clientRequests = {}
local RequestId = 0

function RegisterServerCallback(eventName, callback)
    serverCallbacks[eventName] = callback
end

RegisterNetEvent('deathmatch:triggerServerCallback', function(eventName, requestId, invoker, ...)
    if not serverCallbacks[eventName] then
        return print(('[^1ERROR^7] Server Callback not registered, name: ^5%s^7, invoker resource: ^5%s^7'):format(eventName, invoker))
    end

    local source = source

    serverCallbacks[eventName](source, function(...)
        TriggerClientEvent('deathmatch:serverCallback', source, requestId, invoker, ...)
    end, ...)
end)

TriggerClientCallback = function(player, eventName, callback, ...)
    clientRequests[RequestId] = callback

    TriggerClientEvent('deathmatch:triggerClientCallback', player, eventName, RequestId, GetInvokingResource() or 'unknown', ...)

    RequestId = RequestId + 1
end

RegisterNetEvent('deathmatch:clientCallback', function(requestId, invoker, ...)
    if not clientRequests[requestId] then
        return print(('[^1ERROR^7] Client Callback with requestId ^5%s^7 Was Called by ^5%s^7 but does not exist.'):format(requestId, invoker))
    end

    clientRequests[requestId](...)
    clientRequests[requestId] = nil
end)

function GetPlayerFromId(source)
    return {
        source = source,
        identifier = GetIdentifier(source)
    }
end

function GetPlayerSource(player)
    return player.source
end

function GetIdentifier(source)
    for k, v in pairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len('license:')) == 'license:' then
            return v:gsub('license:', '')
        end
    end
    return nil
end
