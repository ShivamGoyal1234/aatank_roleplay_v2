Core = nil
CoreName = nil
CoreReady = false
Citizen.CreateThread(function()
    for k, v in pairs(Cores) do
        if GetResourceState(v.ResourceName) == "starting" or GetResourceState(v.ResourceName) == "started" then
            CoreName = v.ResourceName
            Core = v.GetFramework()
            CoreReady = true
            PlayerData = GetPlayerData()
        end
    end
end)


function TriggerCallback(name, cb, ...)
    FRKN.General.ServerCallbacks[name] = cb
    TriggerServerEvent('frkn-prison:server:triggerCallback', name, ...)
end

RegisterNetEvent('frkn-prison:client:triggerCallback', function(name, ...)
    if FRKN.General.ServerCallbacks[name] then
        FRKN.General.ServerCallbacks[name](...)
        FRKN.General.ServerCallbacks[name] = nil
    end
end)

function Notify(text, type, length)
    length = length or 5000
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        Core.Functions.Notify(text, type, length)
    elseif CoreName == "es_extended" then
        Core.ShowNotification(text)
    end
end

function GetPlayerData()
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayerData()
        return player
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerData()
        return player
    end
end

function GetPlayerName()
    local playerData

    if CoreName == "qb-core" or CoreName == "qbx_core" then
        playerData = Core.Functions.GetPlayerData()
        return playerData and playerData.charinfo and playerData.charinfo.firstname .. " " .. playerData.charinfo.lastname or nil
    elseif CoreName == "es_extended" then
        playerData = Core.GetPlayerData()
        return playerData and playerData.firstname
    end

    return nil
end

function GetPlayerMoney()
    local playerData

    if CoreName == "qb-core" or CoreName == "qbx_core" then
        playerData = Core.Functions.GetPlayerData()
        return playerData and playerData.money["cash"] or nil
    elseif CoreName == "es_extended" then
        playerData = Core.GetPlayerData()
        return playerData and playerData.getMoney() or nil
    end

    return nil
end


function GetPlayerJob()
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayerData()
        return player.job.name
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerData()
        return player.job.name
    end
end

function GetPlayerIdentifier()
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayerData()
        return player.citizenid
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerData()
        return player.identifier
    end
end

function getVehiclePlate(vehicle)
    return GetVehicleNumberPlateText(vehicle) or "UNKNOWN"
end
