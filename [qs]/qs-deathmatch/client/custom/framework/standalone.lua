if Config.Framework ~= 'standalone' then
    return
end

local RequestId = 0
local serverRequests = {}
local clientCallbacks = {}

function TriggerServerCallback(eventName, callback, ...)
    serverRequests[RequestId] = callback

    TriggerServerEvent('deathmatch:triggerServerCallback', eventName, RequestId, GetInvokingResource() or 'unknown', ...)

    RequestId = RequestId + 1
end

RegisterNetEvent('deathmatch:serverCallback', function(requestId, invoker, ...)
    if not serverRequests[requestId] then
        return print(('[^1ERROR^7] Server Callback with requestId ^5%s^7 Was Called by ^5%s^7 but does not exist.'):format(requestId, invoker))
    end

    serverRequests[requestId](...)
    serverRequests[requestId] = nil
end)

_RegisterClientCallback = function(eventName, callback)
    clientCallbacks[eventName] = callback
end

RegisterNetEvent('deathmatch:triggerClientCallback', function(eventName, requestId, invoker, ...)
    if not clientCallbacks[eventName] then
        return print(('[^1ERROR^7] Client Callback not registered, name: ^5%s^7, invoker resource: ^5%s^7'):format(eventName, invoker))
    end

    clientCallbacks[eventName](function(...)
        TriggerServerEvent('deathmatch:clientCallback', requestId, invoker, ...)
    end, ...)
end)

function SendTextMessage(msg, type)
    if type == 'inform' then
        SetNotificationTextEntry('STRING')
        AddTextComponentString(msg)
        DrawNotification(0, 1)
    end
    if type == 'error' then
        SetNotificationTextEntry('STRING')
        AddTextComponentString(msg)
        DrawNotification(0, 1)
    end
    if type == 'success' then
        SetNotificationTextEntry('STRING')
        AddTextComponentString(msg)
        DrawNotification(0, 1)
    end
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = text:len() / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end