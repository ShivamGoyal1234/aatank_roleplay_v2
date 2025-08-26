RegisterNetEvent(Config.Eventprefix .. ':client:toggleEngine', function(forcestate)
    toggleEngine(forcestate)
end)

function toggleEngine(forcestate)

    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if not vehicle or vehicle == 0 or IsPauseMenuActive() then return end

    local isDriver = GetPedInVehicleSeat(vehicle, -1) == playerPed
    local hasKey = exports['qs-vehiclekeys']:GetKey(GetVehicleNumberPlateText(vehicle)) or not Config.ToggleEngineRequireKeys
    local isJobShared = AreKeysJobShared(vehicle)

    if not (isDriver and (hasKey or isJobShared)) then
        return SendTextMessage(Lang('VEHICLEKEYS_NOTIFICATION_NO_PERMISSION'), 'error')
    end

    local engineRunning = GetIsVehicleEngineRunning(vehicle)
    if forcestate ~= nil then
        if Config.EngineInteriorLights then
            SetVehicleInteriorlight(vehicle, forcestate)
        end
        SetVehicleEngineOn(vehicle, forcestate, false, true)
    else
        if engineRunning then
            if Config.EngineInteriorLights then
                SetVehicleInteriorlight(vehicle, false)
            end
            SetVehicleEngineOn(vehicle, false, false, true)
            SendTextMessage(Lang('VEHICLEKEYS_NOTIFICATION_ENGINE_STOPPED'), 'error')
        else
            if Config.EngineInteriorLights then
                SetVehicleInteriorlight(vehicle, true)
            end
            SetVehicleEngineOn(vehicle, true, false, true)
            SendTextMessage(Lang('VEHICLEKEYS_NOTIFICATION_ENGINE_STARTED'), 'success')
        end
    end
end

exports('toggleEngine', toggleEngine)

if Config.ControlerSupport then
    CreateThread(function()
        while true do
            local waitTime = 1000
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(ped, false)
    
            if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped then
                waitTime = 0
                if IsControlPressed(0, Config.Controls.EngineControlNumber) and IsUsingKeyboard(Config.Controls.EngineControlNumber) then
                    toggleEngine()
                    Wait(500)
                end
            end
    
            Wait(waitTime)
        end
    end)
end

function isEngineRunning(vehicle)
    local playerPed = PlayerPedId()
    vehicle = vehicle or GetVehiclePedIsIn(playerPed, false)
    if vehicle and vehicle ~= 0 then
        local engineRunning = GetIsVehicleEngineRunning(vehicle)
        if engineRunning == '1' then
        engineRunning = true
        end
        return engineRunning
    else
        return false
    end
end

exports('isEngineRunning', isEngineRunning)
