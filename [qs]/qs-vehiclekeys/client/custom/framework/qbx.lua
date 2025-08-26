if Config.Framework ~= 'qbx' then
    return
end

QBCore = exports['qb-core']:GetCoreObject()

qb_menu_name = 'qb-menu'

function TriggerServerCallback(name, cb, ...) -- Sadly have to keep this for compatibility
    QBCore.Functions.TriggerCallback(name, cb, ...)
end

function GetPlayerData()
    return exports.qbx_core:GetPlayerData()
end

function GetIdentifier()
    return GetPlayerData().citizenid
end

function GetPlayers()
    return GetActivePlayers()
end

function GetVehicleProperties(vehicle)
    return lib.getVehicleProperties(vehicle)
end

function GetPlateVeh(vehicle)
    return QBCore.Functions.GetPlate(vehicle)
end

function GetClosestVehicle(coords, maxDistance, includePlayerVehicle)
    local vehicle, vehicleCoords = lib.getClosestVehicle(coords, maxDistance, includePlayerVehicle)
    if not vehicle then
        return false
    end
    return vehicle
end

function GetJobFramework()
    return GetPlayerData()?.job?.name
end

function GetGangFramework()
    if Config.Gangs == true then
        return exports['qs-gangs']:GetGang()
    else
        return nil
    end
end

function GetVehiclesInArea()
    local result = {}
    table.clear(result)
    local vehicles = QBCore.Functions.GetVehicles()
    local playerCoords = GetEntityCoords(PlayerPedId())
    for k, v in pairs(vehicles) do
        local vehicleCoords = GetEntityCoords(v)
        local distance = #(playerCoords - vehicleCoords)
        if distance <= Config.LockDistance then
            table.insert(result, v)
        end
    end
    return result
end

function CheckPolice()
    if Config.ReqPolice then
        local canRob = nil
        TriggerServerCallback(Config.Eventprefix..':server:GetPolice', function(check)
            canRob = check
        end)
        repeat Wait(250) until canRob ~= nil
        return canRob
    else
        return true
    end
end

function ProgressBar(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
    local onFinishCallback = onFinish or function() end
    local onCancelCallback = onCancel or function() end

    local success = lib.progressCircle({
        duration = duration,
        position = 'bottom',
        label = label,
        useWhileDead = useWhileDead,
        canCancel = canCancel,
        disable = disableControls,
        anim = animation,
        prop = prop,
        propTwo = propTwo,
    })

    if success then
        onFinishCallback()
    else
        onCancelCallback()
    end
end

function SendTextMessage(msg, type)
  if type == 'inform' or type == 'error' or type == 'success' then lib.notify({title = 'Vehicle keys', description = msg, type = type}) end
end
