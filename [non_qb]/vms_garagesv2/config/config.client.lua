CL = {}

CL.DrawText3D = function(coords, text, textScale) -- This is the function used when using Config.UseText3D
    local textScale = textScale or 0.45
    local camCoords = GetFinalRenderedCamCoord()
    local distance = #(coords.xyz - camCoords)
    local scale = (textScale / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    SetTextScale(0.0 * scale, 0.55 * scale)
    SetTextFont(4)
    SetTextDropShadow()
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end


-- ███╗   ██╗ ██████╗ ████████╗██╗███████╗██╗ ██████╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗███████╗
-- ████╗  ██║██╔═══██╗╚══██╔══╝██║██╔════╝██║██╔════╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
-- ██╔██╗ ██║██║   ██║   ██║   ██║█████╗  ██║██║     ███████║   ██║   ██║██║   ██║██╔██╗ ██║███████╗
-- ██║╚██╗██║██║   ██║   ██║   ██║██╔══╝  ██║██║     ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║╚════██║
-- ██║ ╚████║╚██████╔╝   ██║   ██║██║     ██║╚██████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║███████║
-- ╚═╝  ╚═══╝ ╚═════╝    ╚═╝   ╚═╝╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
CL.Notification = function(message, time, type)
    if type == "success" then
        if GetResourceState("vms_notify") == 'started' then
            exports['vms_notify']:Notification("PARKING", message, time, "#36f230", "fa-solid fa-square-parking")
        else
            TriggerEvent('esx:showNotification', message)
            TriggerEvent('QBCore:Notify', message, 'success', time)
        end
    elseif type == "error" then
        if GetResourceState("vms_notify") == 'started' then
            exports['vms_notify']:Notification("PARKING", message, time, "#f23030", "fa-solid fa-square-parking")
        else
            TriggerEvent('esx:showNotification', message)
            TriggerEvent('QBCore:Notify', message, 'error', time)
        end
    elseif type == "info" then
        if GetResourceState("vms_notify") == 'started' then
            exports['vms_notify']:Notification("PARKING", message, time, "#4287f5", "fa-solid fa-square-parking")
        else
            TriggerEvent('esx:showNotification', message)
            TriggerEvent('QBCore:Notify', message, 'primary', time)
        end
    end
end


-- ██╗  ██╗██╗   ██╗██████╗ 
-- ██║  ██║██║   ██║██╔══██╗
-- ███████║██║   ██║██║  ██║
-- ██╔══██║██║   ██║██║  ██║
-- ██║  ██║╚██████╔╝██████╔╝
-- ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
CL.Hud = {
    Enable = function()
        if GetResourceState('vms_hud') ~= 'missing' then
            -- exports['vms_hud']:Display(true)
        end
    end,
    Disable = function()
        if GetResourceState('vms_hud') ~= 'missing' then
            -- exports['vms_hud']:Display(false)
        end
    end
}


-- ████████╗███████╗██╗  ██╗████████╗██╗   ██╗██╗
-- ╚══██╔══╝██╔════╝╚██╗██╔╝╚══██╔══╝██║   ██║██║
--    ██║   █████╗   ╚███╔╝    ██║   ██║   ██║██║
--    ██║   ██╔══╝   ██╔██╗    ██║   ██║   ██║██║
--    ██║   ███████╗██╔╝ ██╗   ██║   ╚██████╔╝██║
--    ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝
CL.TextUI = {
    Enabled = true,
    Open = function(message)
        if GetResourceState('vms_notifyv2') == 'started' then
            exports['vms_notifyv2']:ShowTextUI(message)
        elseif GetResourceState('interact') == 'started' then
            exports["interact"]:Open("E", message) -- Here you can use your TextUI or use my free one - https://github.com/vames-dev/interact
        end
    end,
    Close = function()
        if GetResourceState('vms_notifyv2') == 'started' then
            exports['vms_notifyv2']:HideTextUI()
        elseif GetResourceState('interact') == 'started' then
            exports["interact"]:Close() -- Here you can use your TextUI or use my free one - https://github.com/vames-dev/interact
        end
    end
}


-- ███████╗██████╗  █████╗ ███╗   ███╗███████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
-- ██╔════╝██╔══██╗██╔══██╗████╗ ████║██╔════╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
-- █████╗  ██████╔╝███████║██╔████╔██║█████╗  ██║ █╗ ██║██║   ██║██████╔╝█████╔╝ 
-- ██╔══╝  ██╔══██╗██╔══██║██║╚██╔╝██║██╔══╝  ██║███╗██║██║   ██║██╔══██╗██╔═██╗ 
-- ██║     ██║  ██║██║  ██║██║ ╚═╝ ██║███████╗╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
-- ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
CL.GetPlayerData = function(type)
    if Config.Core == "ESX" then
        return ESX.GetPlayerData()
    elseif Config.Core == "QB-Core" then
        return QBCore.Functions.GetPlayerData()
    end
end

CL.GetPlayerIdentifier = function()
    if Config.Core == "ESX" then
        return PlayerData.identifier
    elseif Config.Core == "QB-Core" then
        return PlayerData.citizenid
    end
end

CL.GetPlayerJob = function(type)
    if Config.Core == "ESX" and PlayerData.job then
        if type == "table" then
            return PlayerData.job
        end
        if type == "name" then
            return PlayerData.job.name
        end
        if type == "label" then
            return PlayerData.job.label
        end
        if type == "grade" then
            return PlayerData.job.grade
        end
        if type == "grade_name" then
            return PlayerData.job.grade_name
        end
    elseif Config.Core == "QB-Core" and PlayerData.job then
        if type == "table" then
            return PlayerData.job
        end
        if type == "name" then
            return PlayerData.job.name
        end
        if type == "label" then
            return PlayerData.job.label
        end
        if type == "grade" then
            return PlayerData.job.grade.level
        end
        if type == "grade_name" then
            return PlayerData.job.grade.name
        end
    end
    return nil
end

CL.GetPlayerGang = function(type)
    if Config.Core == "ESX" and PlayerData.job2 then
        if type == "table" then
            return PlayerData.job2
        end
        if type == "name" then
            return PlayerData.job2.name
        end
        if type == "label" then
            return PlayerData.job2.label
        end
        if type == "grade" then
            return PlayerData.job2.grade
        end
        if type == "grade_name" then
            return PlayerData.job2.grade_name
        end
    elseif Config.Core == "QB-Core" and PlayerData.gang then
        if type == "table" then
            return PlayerData.gang
        end
        if type == "name" then
            return PlayerData.gang.name
        end
        if type == "label" then
            return PlayerData.gang.label
        end
        if type == "grade" then
            return PlayerData.gang.grade.level
        end
        if type == "grade_name" then
            return PlayerData.gang.grade.name
        end
    end
    return nil
end

CL.GetClosestPlayer = function()
    if Config.Core == "ESX" then
        return ESX.Game.GetClosestPlayer(GetEntityCoords(PlayerPedId()), 6.0) -- ESX
    elseif Config.Core == "QB-Core" then
        return QBCore.Functions.GetClosestPlayer(GetEntityCoords(PlayerPedId())) -- QB-Core
    end
end

CL.GetClosestPlayers = function()
    if Config.Core == "ESX" then
        local playerInArea = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 5.0)
        return playerInArea
    elseif Config.Core == "QB-Core" then
        local playerInArea = QBCore.Functions.GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), 5.0)
        return playerInArea
    end
end

CL.GetClosestVehicle = function(myCoords)
    if Config.Core == "ESX" then
        local closestVehicle, closestDistance = ESX.Game.GetClosestVehicle(myCoords);
        if closestDistance >= 6.0 then
            return nil
        end
        return closestVehicle;
        
    elseif Config.Core == "QB-Core" then
        local closestVehicle, closestDistance = QBCore.Functions.GetClosestVehicle(myCoords);
        if closestDistance >= 6.0 then
            return nil
        end
        return closestVehicle;
        
    end
end

CL.IsAreaClear = function(coords, distance)
    if Config.Core == "ESX" then
        return ESX.Game.IsSpawnPointClear(coords.xyz, distance)
    else
        return QBCore.Functions.SpawnClear(coords.xyz, distance)
    end
end

CL.GetVehicleProperties = function(vehicle)
    if Config.Core == "ESX" then
        return ESX.Game.GetVehicleProperties(vehicle)
    elseif Config.Core == "QB-Core" then
        return QBCore.Functions.GetVehicleProperties(vehicle)
    end
end

CL.SetVehicleProperties = function(vehicle, properties)
    if Config.Core == "ESX" then
        ESX.Game.SetVehicleProperties(vehicle, properties)
    elseif Config.Core == "QB-Core" then
        QBCore.Functions.SetVehicleProperties(vehicle, properties)
    end
end

CL.GetVehicleLabel = function(model)
    if not model then return nil end;
    
    local model = tonumber(model) and model or joaat(model)
    
	for k, v in pairs(Config.CustomVehicleLabels) do
		if model == k then
			return v
		end
	end

    local vehLabel = GetLabelText(GetDisplayNameFromVehicleModel(model))
    if vehLabel == 'NULL' then
        return GetDisplayNameFromVehicleModel(model)
    end

	return vehLabel
end

---@field SetOnVehicleSpawn fun(): This function is activated when you enter a vehicle or select a vehicle in the garages menu
CL.SetOnVehicleSpawn = function(vehicle, properties, garageId)
    CL.SetVehicleFuel(vehicle, properties['fuelLevel'])

    if garageId == "MissionRow" and properties.RaceHarness then
        print("working")
        TriggerClientEvent('jim-mechanic:client:applyHarness', -1, { client = { remove = false } })
    end

    if GetResourceState('kq_wheeldamage') == 'started' then
        if properties.wheelHealth and next(properties.wheelHealth) then
            for wheelIndex, damageValue in pairs(properties.wheelHealth) do
                if damageValue == 0.0 then
                    TriggerServerEvent('kq_wheeldamage:setState', NetworkGetNetworkIdFromEntity(vehicle), true)
                    TriggerServerEvent('kq_wheeldamage:setBroken', NetworkGetNetworkIdFromEntity(vehicle), tonumber(wheelIndex), true)
                end
            end
        elseif properties.tireHealth and next(properties.tireHealth) then
            for wheelIndex, damageValue in pairs(properties.tireHealth) do
                if damageValue == 0.0 then
                    TriggerServerEvent('kq_wheeldamage:setState', NetworkGetNetworkIdFromEntity(vehicle), true)
                    TriggerServerEvent('kq_wheeldamage:setBroken', NetworkGetNetworkIdFromEntity(vehicle), tonumber(wheelIndex), true)
                end
            end
        end
    end

    if GetResourceState('VehicleDeformation') == 'started' then
        if properties.deformation and next(properties.deformation) then
            exports["VehicleDeformation"]:SetVehicleDeformation(vehicle, properties.deformation)
        end
    end
end

---@field SetOnVehicleSpawnLocally fun(): This function is activated when you enter the parking PolyZone area or you select a vehicle in the garage menu
---# It is not a function that is activated when the vehicle is taken from the parking lot!
CL.SetOnVehicleSpawnLocally = function(vehicle, properties)
    if Config.PreventExplosionOfParkedVehicles then
        SetEntityInvincible(vehicle, true)
    end

    if GetResourceState('kq_wheeldamage') == 'started' then
        if properties.wheelHealth and next(properties.wheelHealth) then
            for wheelIndex, damageValue in pairs(properties.wheelHealth) do
                if damageValue ~= nil and damageValue == 0.0 then
                    BreakOffVehicleWheel(vehicle, tonumber(wheelIndex), true, true, true, false)
                end
            end
        elseif properties.tireHealth and next(properties.tireHealth) then
            for wheelIndex, damageValue in pairs(properties.tireHealth) do
                if damageValue ~= nil and damageValue == 0.0 then
                    BreakOffVehicleWheel(vehicle, tonumber(wheelIndex), true, true, true, false)
                end
            end
        end
    end
    
    if GetResourceState('VehicleDeformation') == 'started' then
        if properties.deformation and next(properties.deformation) then
            exports["VehicleDeformation"]:SetVehicleDeformation(vehicle, properties.deformation)
        end
    end
end


-- ███████╗██╗   ██╗███████╗██╗     
-- ██╔════╝██║   ██║██╔════╝██║     
-- █████╗  ██║   ██║█████╗  ██║     
-- ██╔══╝  ██║   ██║██╔══╝  ██║     
-- ██║     ╚██████╔╝███████╗███████╗
-- ╚═╝      ╚═════╝ ╚══════╝╚══════╝
CL.SetVehicleFuel = function(vehicle, level)
    local oxFuel = GetResourceState('ox_fuel') == 'started'
    if oxFuel then
        Entity(vehicle).state.fuel = level
    end

    local legacyFuel = GetResourceState('LegacyFuel') == 'started'
    if legacyFuel then
        exports["LegacyFuel"]:SetFuel(vehicle, level)
    end

    local ndFuel = GetResourceState('ND_Fuel') == 'started'
    if ndFuel then
        exports['ND_Fuel']:SetFuel(vehicle, level)
    end

    local cdnFuel = GetResourceState('cdn-fuel') == 'started'
    if cdnFuel then
        exports['cdn-fuel']:SetFuel(vehicle, level)
    end

    local qsFuel = GetResourceState('qs-fuelstations') == 'started'
    if qsFuel then
        exports['qs-fuelstations']:SetFuel(vehicle, level)
    end

    local okokGasStation = GetResourceState('okokGasStation') == 'started'
    if okokGasStation then
        exports['okokGasStation']:SetFuel(vehicle, level)
    end

    local psFuel = GetResourceState('ps-fuel') == 'started'
    if psFuel then
        exports['ps-fuel']:SetFuel(vehicle, level)
    end

    local esxSnaFuel = GetResourceState('esx-sna-fuel') == 'started'
    if esxSnaFuel then
        exports['esx-sna-fuel']:SetFuel(vehicle, level)
    end

    local qbSnaFuel = GetResourceState('qb-sna-fuel') == 'started'
    if qbSnaFuel then
        exports['qb-sna-fuel']:SetFuel(vehicle, level)
    end
    
    local frFuel = GetResourceState('FRFuel') == 'started'
    if frFuel then
        exports['FRFuel']:setFuel(vehicle, level)
    end

end


-- ██╗   ██╗███████╗██╗  ██╗██╗ ██████╗██╗     ███████╗    ██╗  ██╗███████╗██╗   ██╗███████╗
-- ██║   ██║██╔════╝██║  ██║██║██╔════╝██║     ██╔════╝    ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔════╝
-- ██║   ██║█████╗  ███████║██║██║     ██║     █████╗      █████╔╝ █████╗   ╚████╔╝ ███████╗
-- ╚██╗ ██╔╝██╔══╝  ██╔══██║██║██║     ██║     ██╔══╝      ██╔═██╗ ██╔══╝    ╚██╔╝  ╚════██║
--  ╚████╔╝ ███████╗██║  ██║██║╚██████╗███████╗███████╗    ██║  ██╗███████╗   ██║   ███████║
--   ╚═══╝  ╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝╚══════╝╚══════╝    ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝
CL.GiveVehicleKeys = function(vehicle, plate)
    local qsVehicleKeys = GetResourceState('qs-vehiclekeys') == 'started'
    if qsVehicleKeys then
        local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
        exports['qs-vehiclekeys']:GiveKeys(plate, model)
    end
    
    local qbVehicleKeys = GetResourceState('qb-vehiclekeys') == 'started'
    local qbxVehicleKeys = GetResourceState('qbx_vehiclekeys') == 'started'
    if qbVehicleKeys or qbxVehicleKeys then
        TriggerEvent("vehiclekeys:client:SetOwner", plate)
    end

    local wasabiCarLock = GetResourceState('wasabi_carlock') == 'started'
    if wasabiCarLock then
        exports['wasabi_carlock']:GiveKey(plate)
    end

end

CL.RemoveVehicleKeys = function(vehicle, plate)
    local qsVehicleKeys = GetResourceState('qs-vehiclekeys') == 'started'
    if qsVehicleKeys then
        local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
        exports['qs-vehiclekeys']:RemoveKeys(plate, model)
    end
    
    local qbVehicleKeys = GetResourceState('qb-vehiclekeys') == 'started'
    local qbxVehicleKeys = GetResourceState('qbx_vehiclekeys') == 'started'
    if qbVehicleKeys or qbxVehicleKeys then
        TriggerEvent("qb-vehiclekeys:client:RemoveKeys", plate)
    end

    local wasabiCarLock = GetResourceState('wasabi_carlock') == 'started'
    if wasabiCarLock then
        exports['wasabi_carlock']:RemoveKey(plate)
    end
    
end