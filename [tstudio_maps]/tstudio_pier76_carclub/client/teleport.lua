local locations = {
    {coords = vector4(540.74, -3063.51, 6.08, 88.37), label = "Teleport Zone A", target = vector4(556.16, -3067.61, -1.92, 86.73)},
    {coords = vector4(556.16, -3067.61, -1.92, 86.73), label = "Teleport Zone B", target = vector4(540.74, -3063.51, 6.08, 88.37)},
    {coords = vector4(840.9654, -905.3257, 25.2516, 357.7362), label = "Teleport Zone A", target = vector4(836.8960, -920.3951, 17.2471, 358.3346)},
    {coords = vector4(836.8960, -920.3951, 17.2471, 358.3346), label = "Teleport Zone B", target = vector4(840.9654, -905.3257, 25.2516, 357.7362)}
}

local blipRadius = 3.0 -- Activation radius for pressing E
local visibilityDistance = 5.0 -- Distance within which the checkpoint is visible
local checkpoints = {} -- Store checkpoint handles
local activeLocationIndex = nil -- To track the currently active teleport zone

-- Monitor player proximity and dynamically show/hide checkpoints
CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local nearestDistance = math.huge
        local nearestIndex = nil

        for index, location in ipairs(locations) do
            local distance = #(playerCoords - vector3(location.coords.x, location.coords.y, location.coords.z))

            -- Show checkpoint if close
            if distance < visibilityDistance then
                if not checkpoints[index] then
                    -- Create checkpoint
                    checkpoints[index] = CreateCheckpoint(
                        47, -- Checkpoint type (47 = Cylinder type)
                        location.coords.x, location.coords.y, location.coords.z - 1.0, -- Position (slightly below ground)
                        location.coords.x, location.coords.y, location.coords.z, -- Direction (not used here)
                        4.0, -- Radius
                        255, 0, 0, 100, -- Color (RGBA, red, semi-transparent)
                        0 -- Reserved, always set to 0
                    )
                    SetCheckpointCylinderHeight(checkpoints[index], 1.5, 1.5, 1.0) -- Adjust cylinder height
                end
            else
                if checkpoints[index] then
                    -- Delete checkpoint if far
                    DeleteCheckpoint(checkpoints[index])
                    checkpoints[index] = nil
                end
            end

            -- Track the nearest teleport zone
            if distance < nearestDistance then
                nearestDistance = distance
                nearestIndex = index
            end
        end

        -- Update active location index if within blipRadius
        if nearestDistance < blipRadius then
            activeLocationIndex = nearestIndex
        else
            activeLocationIndex = nil
        end

        Wait(100) -- Reduce script load
    end
end)

-- Handle teleportation when the player presses E
CreateThread(function()
    while true do
        if activeLocationIndex then
            ShowHelpNotification("Press ~INPUT_CONTEXT~ to teleport.") -- INPUT_CONTEXT = E key

            -- Check for input in case-insensitive manner
            if IsControlJustReleased(0, 38) then -- 38 = E key
                local playerPed = PlayerPedId()
                local location = locations[activeLocationIndex]
                local target = location.target

                if IsPedInAnyVehicle(playerPed, false) then
                    -- Teleport with the vehicle
                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    SetEntityCoords(vehicle, target.x, target.y, target.z, false, false, false, true)
                    SetEntityHeading(vehicle, target.w) -- Set vehicle heading
                else
                    -- Teleport the player on foot
                    SetEntityCoords(playerPed, target.x, target.y, target.z, false, false, false, true)
                    SetEntityHeading(playerPed, target.w) -- Set player heading
                end

                PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)
                Wait(5000) -- Cooldown to prevent repeated teleport
            end
        end

        Wait(0) -- Real-time detection for button press
    end
end)

-- Function to show help notification (on-screen prompt)
function ShowHelpNotification(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, -1)
end
