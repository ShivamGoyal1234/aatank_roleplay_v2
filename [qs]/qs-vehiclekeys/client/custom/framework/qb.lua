if Config.Framework ~= "qb" then
    return
end

QBCore = nil

QBCore = exports['qb-core']:GetCoreObject()

qb_menu_name = 'qb-menu'
nh_trigger = 'nh-context:createMenu'

function TriggerServerCallback(name, cb, ...)
    QBCore.Functions.TriggerCallback(name, cb, ...)
end

function GetVehicleProperties(vehicle)
	return QBCore.Functions.GetVehicleProperties(vehicle)
end

function GetPlateVeh(vehicle)
    return QBCore.Functions.GetPlate(vehicle)
end

function GetClosestVehicle(vehicle)
    local veh = QBCore.Functions.GetClosestVehicle(vehicle)
    if not veh then return false end
    return veh
end

function GetJobFramework()
    return QBCore.Functions.GetPlayerData().job
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
    if type == 'inform' then
        QBCore.Functions.Notify(msg, 'primary', 5000)
    end
    if type == 'error' then
        QBCore.Functions.Notify(msg, 'error', 5000)
    end
    if type == 'success' then
        QBCore.Functions.Notify(msg, 'success', 5000)
    end
end
