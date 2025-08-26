local podiumHash = joaat("hg_carclub_podium")
local tabletStandHash = joaat("hg_carclub_tabletstand")

-- Predefined fixed location for moving vehicles off the podium
local fixedLocation = { x = 528.33, y = -3066.1, z = 6.08, heading = 358.75 } -- Change this to your desired coordinates

-- Variable to store the last vehicle the player was in
local lastVehicle = nil

local function drawHelpNotify(message)
    SetTextComponentFormat('STRING')
    AddTextComponentString(message)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- Track the last vehicle the player was in
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local ped = PlayerPedId()
        local currentVehicle = GetVehiclePedIsIn(ped, false)

        if currentVehicle ~= 0 then
            lastVehicle = currentVehicle
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local closestTabletStand = GetClosestObjectOfType(coords, 2.5, tabletStandHash, false, true, true)

        -- Only show the marker if the player is very close (within 1.5 units)
        if closestTabletStand ~= 0 then
            local tabletStandCoords = GetEntityCoords(closestTabletStand)
            local distance = #(coords - tabletStandCoords)

            if distance < 1.5 then
                DrawMarker(20, tabletStandCoords.x, tabletStandCoords.y, tabletStandCoords.z + 0.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 39, 217, 39, 100, true, true, 2, false, false, false, false)
                drawHelpNotify("~b~Press ~INPUT_TALK~ to interact with the tablet stand")

                if IsControlJustReleased(1, 38) then
                    -- Check if there's a podium nearby
                    local closestPodium = GetClosestObjectOfType(coords, 10.0, podiumHash, false, true, true)

                    if closestPodium ~= 0 then
                        local podiumCoords = GetEntityCoords(closestPodium)
                        local vehicleOnPodium = GetClosestVehicle(podiumCoords.x, podiumCoords.y, podiumCoords.z, 2.5, 0, 71)

                        if DoesEntityExist(vehicleOnPodium) then
                            -- Move the existing vehicle on the podium to the fixed location
                            SetEntityCoords(vehicleOnPodium, fixedLocation.x, fixedLocation.y, fixedLocation.z)
                            SetEntityHeading(vehicleOnPodium, fixedLocation.heading)
                            FreezeEntityPosition(vehicleOnPodium, false)
                            drawHelpNotify("~g~Vehicle removed from podium and moved to the fixed location!")
                        else
                            -- Place the last vehicle the player was in on the podium
                            if lastVehicle and DoesEntityExist(lastVehicle) then
                                SetEntityCoords(lastVehicle, podiumCoords.x, podiumCoords.y, podiumCoords.z + 0.5)
                                SetEntityRotation(lastVehicle, 0.0, 0.0, GetEntityHeading(closestPodium), 2)
                                FreezeEntityPosition(lastVehicle, true)
                                drawHelpNotify("~g~Your last vehicle has been placed on the podium!")
                            else
                                drawHelpNotify("~r~No valid last vehicle found to place on the podium!")
                            end
                        end
                    else
                        drawHelpNotify("~r~No podium found nearby!")
                    end
                end
            end
        else
            Citizen.Wait(1000) -- Reduce checks when not near the tablet stand
        end
    end
end)