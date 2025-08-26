local function isPlayerInVehicle()
    local playerPed = PlayerPedId()
    return IsPedInAnyVehicle(playerPed, false)
end

local function isAllowedVehicle()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle == 0 then
        return false
    end

    local model = GetEntityModel(vehicle)

    if Config.specifyVehicles then
        for _, allowedVehicle in ipairs(Config.vehicles) do
            if model == GetHashKey(allowedVehicle) then
                return true
            end
        end
    else
        local vehicleClass = GetVehicleClass(vehicle)
        if vehicleClass == 18 then
            return true
        end
    end
    return false
end

local megaphoneEnabled = false

CreateThread(function()
    while true do
        Wait(1000)
        if megaphoneEnabled and (not isPlayerInVehicle() or not isAllowedVehicle()) then
            toggleMegaphone("vehicle", false)
            megaphoneEnabled = false
        end
    end
end)

RegisterCommand("vehmega", function()
    if isPlayerInVehicle() and isAllowedVehicle() then
        megaphoneEnabled = not megaphoneEnabled
        toggleMegaphone("vehicle", megaphoneEnabled) 
    end
end)

RegisterKeyMapping('vehmega', '(Voice) Vehicle Megaphone', 'keyboard', Config.keybind)
