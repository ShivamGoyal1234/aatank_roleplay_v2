if Config.Framework ~= "esx" then
    return
end

ESX = nil

ESX = exports['es_extended']:getSharedObject()

nh_trigger = 'nh-context:createMenu'

function TriggerServerCallback(name, cb, ...)
    ESX.TriggerServerCallback(name, cb, ...)
end

function GetVehicleProperties(vehicle)
	return ESX.Game.GetVehicleProperties(vehicle)
end

function GetPlateVeh(vehicle)
    local veh = ESX.Game.GetVehicleProperties(vehicle)
    if not veh then return false end
    return veh.plate
end

function GetClosestVehicle()
    return ESX.Game.GetClosestVehicle()
end

function GetJobFramework()
    return ESX.GetPlayerData().job
end

function GetGangFramework()
    if Config.Gangs == true then
        return exports['qs-gangs']:GetGang()
    else
        return nil
    end
end

function GetVehiclesInArea()
    return ESX.Game.GetVehiclesInArea(GetEntityCoords(PlayerPedId()), Config.LockDistance)
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
    if type == 'inform' then lib.notify({title = 'Information', description = msg, type = 'inform', id = msg}) end
    if type == 'error' then lib.notify({title = 'Error', description = msg, type = 'error', id = msg}) end
    if type == 'success' then lib.notify({title = 'Success', description = msg, type = 'success', id = msg}) end
end
