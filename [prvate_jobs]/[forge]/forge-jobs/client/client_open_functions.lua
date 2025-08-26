--[[
    Client Utility Functions
    This file contains utility functions used by the client-side scripts
    for the Forge Jobs resource. These functions handle various common operations
    like notifications, target creation, animations, and framework compatibility.
]]--

-- Utilities

--[[
    RandomFloat - Generates a random float number between lower and greater bounds
    @param lower - Lower bound of the random number
    @param greater - Upper bound of the random number
    @returns - Random float between lower and greater
]]--
function RandomFloat(lower, greater)
    return lower + math.random()  * (greater - lower);
end

--[[
    Notification - Displays a notification message to the player
    Uses framework-specific notifications if available (ESX, QB/QBOX).
    @param message - The message to display
    @param type (optional for QB) - The type of notification (e.g., 'success', 'error', 'inform')
    @param duration (optional for QB) - Duration in milliseconds
]]--
function Notification(message, type, duration)
    if Config.Framework == "ESX" and ESX ~= nil then
        ESX.ShowNotification(message)
    elseif (Config.Framework == "QB" or Config.Framework == "QBOX") and QBCore ~= nil then
        local notificationType = type
        if notificationType == 1 then
            notificationType = 'primary'
        end
        QBCore.Functions.Notify(message, notificationType or 'primary', duration or 5000)
    else
        -- Fallback to chat message if framework is not recognized or not loaded
        TriggerEvent('chat:addMessage', {
            args = {'[Notification]', message} 
        })
    end
end

--[[
    CoordsFaceCoords - Calculates the heading needed for point 1 to face point 2
    @param p1 - Starting coordinates (vector3)
    @param p2 - Target coordinates (vector3)
    @returns - Heading angle in degrees
]]--
function CoordsFaceCoords(p1, p2)
    -- Check if either coordinate is nil or invalid
    if not p1 or not p2 then
        -- If coordinates are invalid, return current player heading as fallback
        return GetEntityHeading(PlayerPedId())
    end
    
    -- Check if p2 has valid x and y properties
    if not p2.x or not p2.y then
        -- If p2 is not a proper vector3, return current heading
        return GetEntityHeading(PlayerPedId())
    end
    
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y

    local heading = GetHeadingFromVector_2d(dx, dy)
    return heading
end

--[[
    MoveClicked - Detects if any movement control was pressed by the player
    Used to interrupt animations or actions when player moves
    @returns - true if any movement key was just released, false otherwise
]]--
function MoveClicked()
    if IsControlJustReleased(0, 22) or IsControlJustReleased(0, 32) or IsControlJustReleased(0, 33) or IsControlJustReleased(0, 34) or IsControlJustReleased(0, 35) then return true end
    return false
end

--[[
    SkillCheck - Performs a skill check minigame using forge-key
    Displays notification if player fails the check
    @returns - true if player passed the skill check, false otherwise
]]--
function SkillCheck()
    --  if you want to use ox_lib, uncomment the following and delete the forge-key minigame part:
    -- local result = lib.skillCheck({'easy'}, {'e'})
    -- if not result then Notification(Config.Locales[Config.Locale].notifications.SkillCheckFailed) end
    -- return result
    
    -- Start forge-key minigame
    local success = false 
    local difficulty = 1 -- 1 is easy, 2 is medium, 3 is hard
    local title = Config.Locales[Config.Locale].minigames.SkillCheckTitle -- Title of the minigame
    
    -- Create a promise to make the async call synchronous
    local p = promise.new()
    
    -- forge-key export
    exports['forge-key']:forgeKeyStart(difficulty, title, function(result)
        success = result
        p:resolve(result)
    end)
    
    -- Wait for the promise to resolve
    Citizen.Await(p)
    
    SetNuiFocus(false, false)
    
    
    return success -- finish forge-key minigame
end

--[[
    GetCharacterName - Retrieves the character's first and last name
    Works with different frameworks (ESX, QB, QBOX)
    @returns - Table with {firstName, lastName}
]]--
function GetCharacterName()
    local firstName = ""
    local lastName = ""
    if Config.Framework == "ESX" then
        local playerData = ESX.PlayerData
        firstName = playerData.firstName
        lastName = playerData.lastName
    elseif Config.Framework == "QB" or Config.Framework == "QBOX" then
        local playerData = QBCore.Functions.GetPlayerData()
        firstName = playerData.charinfo.firstname
        lastName = playerData.charinfo.lastname
    end

    return {firstName, lastName}
end

--[[
    HasItem - Checks if the player has a specified item in their inventory
    Compatible with ox_inventory, qb-inventory, and quasar-inventory
    @param item - The item name to check for
    @returns - true if player has at least 1 of the item, false otherwise
]]--
function HasItem(item)
    if Config.Inventory == "ox_inventory" then
        return exports.ox_inventory:GetItemCount(item) > 0

    elseif Config.Inventory == "qb-inventory" then
        return QBCore.Functions.HasItem(item, 1)

    elseif Config.Inventory == "quasar-inventory" then
        if Config.Framework == "ESX" then
            local data = ESX.GetPlayerData()
            if data and data.inventory then
                for _, invItem in ipairs(data.inventory) do
                    if invItem.name == item and (invItem.count or invItem.amount or 0) > 0 then
                        return true
                    end
                end
            end
            return false

        elseif Config.Framework == "QB" or Config.Framework == "QBOX" then
            return QBCore.Functions.HasItem(item, 1)
        end
    end

    return false
end

--[[
    GetItemCount - Gets the count of a specific item in player\'s inventory
    Works with different frameworks (ESX, QB, QBOX) and inventory systems
    @param itemName - The name of the item to count
    @returns - The quantity of the specified item, 0 if none found
]]--
function GetItemCount(itemName)
    ----------------------------------------------------------
    -- ESX + Quasar inventory → ask the server
    ----------------------------------------------------------
    if Config.Framework == "ESX" and Config.Inventory == "quasar-inventory" then
        local p = promise.new()
        ESX.TriggerServerCallback('forge-jobs:getItemCount', function(qty)
            p:resolve(qty or 0)
        end, itemName)
        return Citizen.Await(p)                 -- real value
    end

    ----------------------------------------------------------
    -- ESX native / ox_inventory
    ----------------------------------------------------------
    if Config.Framework == "ESX" then
        local total = 0
        local pdata = ESX.GetPlayerData()
        for _, itm in pairs(pdata.inventory or {}) do
            if itm.name == itemName then
                total = total + (itm.count or itm.amount or 0)
            end
        end
        return total
    end

    ----------------------------------------------------------
    -- QB / QBOX
    ----------------------------------------------------------
    if Config.Framework == "QB" or Config.Framework == "QBOX" then
        -- qs-inventory
        if Config.Inventory == "quasar-inventory" then
            local p = promise.new()
            QBCore.Functions.TriggerCallback('forge-jobs:getItemCount', function(qty)
                p:resolve(qty or 0)
            end, itemName)
            return Citizen.Await(p)                 -- real value

        -- ox_inventory
        elseif Config.Inventory == "ox_inventory" then
            return exports.ox_inventory:GetItemCount(itemName)

        -- qb-inventory  
        else
            local total = 0
            local pdata = QBCore.Functions.GetPlayerData()
            for _, itm in pairs(pdata.items or {}) do
                if itm.name == itemName then
                    total = total + (itm.amount or 0)
                end
            end
            return total
        end
    end

    return 0
end

--[[
    GiveTempWeapon - Gives the player a temporary weapon and enables weapon wheel
    Compatible with multiple inventory systems
    @param weaponHash - The hash of the weapon to give
]]--
function GiveTempWeapon(weaponHash)
    if Config.Inventory == "ox_inventory" then
        exports.ox_inventory:weaponWheel(true)
        Wait(100)
        GiveWeaponToPed(PlayerPedId(), weaponHash, -1, false, true)
    elseif Config.Inventory == "qb-inventory" then
        exports["qb-smallresources"]:removeDisableControls(37)
        exports["qb-smallresources"]:removeDisableHudComponents(19)
        Wait(100)
        GiveWeaponToPed(PlayerPedId(), weaponHash, -1, false, true)
    elseif Config.Inventory == "quasar-inventory" then
        exports['qs-inventory']:WeaponWheel(true)
        Wait(100)
        GiveWeaponToPed(PlayerPedId(), weaponHash, -1, false, true)
    end
end

--[[
    RemoveTempWeapon - Removes a temporary weapon from the player and disables weapon wheel
    Compatible with multiple inventory systems
    @param weaponHash - The hash of the weapon to remove
]]--
function RemoveTempWeapon(weaponHash)
    if Config.Inventory == "ox_inventory" then
        exports.ox_inventory:weaponWheel(false)
        RemoveWeaponFromPed(PlayerPedId(), weaponHash)
    elseif Config.Inventory == "qb-inventory" then
        exports["qb-smallresources"]:addDisableControls(37)
        exports["qb-smallresources"]:addDisableHudComponents(19)
        RemoveWeaponFromPed(PlayerPedId(), weaponHash)
    elseif Config.Inventory == "quasar-inventory" then
        exports['qs-inventory']:WeaponWheel(false)
        RemoveWeaponFromPed(PlayerPedId(), weaponHash)
    end
end

--[[
    CreateBlipOnEntity - Creates a blip attached to an entity on the map
    @param sprite - The sprite (icon) ID for the blip
    @param text - The text displayed when hovering over the blip
    @param color - The color ID for the blip
    @param entity - The entity to attach the blip to
    @param activity - The job activity name for job restriction validation
]]--
function CreateBlipOnEntity(sprite, text, color, entity, activity)
    -- Check if JobRestrictions are enabled for this activity
    local cfg = Config.Jobs[activity]
    if cfg and cfg.JobRestrictions and cfg.JobRestrictions.enabled then
        -- Restrictions are enabled - check if player has the required job
        if not HasJob(activity) then
            if Config.Debug then
                print(("[DEBUG] Skipping entity blip for activity '%s': Player does not have a permitted job."):format(activity or "unknown"))
            end
            return
        end
    end
    -- Either no restrictions OR player has the required job - create blip

    local blip = AddBlipForEntity(entity)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 2)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    AddTextEntry('MYBLIP', text)
    BeginTextCommandSetBlipName("MYBLIP")
    AddTextComponentSubstringPlayerName("me")
    EndTextCommandSetBlipName(blip)

    table.insert(blips, blip)

    if Config.Debug then
        local blipExists = DoesBlipExist(blip)
        print(("[DEBUG] Created entity blip for activity '%s' | BlipID: %s | Exists: %s"):format(
            activity or "unknown", tostring(blip), tostring(blipExists)
        ))
    end
end

--[[
    CreateBlipAtCoords - Creates a blip at specified coordinates on the map
    @param sprite - The sprite (icon) ID for the blip
    @param text - The text displayed when hovering over the blip
    @param color - The color ID for the blip
    @param coords - Table containing the x,y,z coordinates for the blip
    @param activity - The job activity name for job restriction validation
]]--
function CreateBlipAtCoords(sprite, text, color, coords, activity)
    -- Check if JobRestrictions are enabled for this activity
    local cfg = Config.Jobs[activity]
    if cfg and cfg.JobRestrictions and cfg.JobRestrictions.enabled then
        -- Restrictions are enabled - check if player has the required job
        if not HasJob(activity) then
            if Config.Debug then
                print(("[DEBUG] Skipping blip for activity '%s': Player does not have a permitted job."):format(activity or "unknown"))
            end
            return
        end
    end
    -- Either no restrictions OR player has the required job - create blip

    local blip = AddBlipForCoord(coords[1], coords[2], coords[3])
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 2)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    AddTextEntry('MYBLIP', text)
    BeginTextCommandSetBlipName("MYBLIP")
    AddTextComponentSubstringPlayerName("me")
    EndTextCommandSetBlipName(blip)

    table.insert(blips, blip)

    if Config.Debug then
        local blipExists = DoesBlipExist(blip)
        print(("[DEBUG] Created blip for activity '%s' at coords: [%.2f, %.2f, %.2f] | BlipID: %s | Exists: %s"):format(
            activity or "unknown", coords[1], coords[2], coords[3], tostring(blip), tostring(blipExists)
        ))
    end
end

--[[
    CreateBlipAreaAtCoords - Creates a circular area blip at specified coordinates
    @param color - The color ID for the blip area
    @param alpha - The transparency of the blip area (0-255)
    @param size - The radius of the circle
    @param coords - Vector3 containing the center coordinates for the blip area
    @param activity - The job activity name for job restriction validation
]]--
function CreateBlipAreaAtCoords(color, alpha, size, coords, activity)
    -- Check if JobRestrictions are enabled for this activity
    local cfg = Config.Jobs[activity]
    if cfg and cfg.JobRestrictions and cfg.JobRestrictions.enabled then
        -- Restrictions are enabled - check if player has the required job
        if not HasJob(activity) then
            if Config.Debug then
                print(("[DEBUG] Skipping area blip for activity '%s': Player does not have a permitted job."):format(activity or "unknown"))
            end
            return
        end
    end
    -- Either no restrictions OR player has the required job - create blip

    local blip = AddBlipForRadius(coords.x, coords.y, coords.z, size)
    SetBlipRotation(blip, 0)
    SetBlipColour(blip, color)
    SetBlipAlpha(blip, alpha)
    SetBlipAsShortRange(blip, true)

    table.insert(blips, blip)

    if Config.Debug then
        local blipExists = DoesBlipExist(blip)
        print(("[DEBUG] Created area blip for activity '%s' | BlipID: %s | Exists: %s"):format(
            activity or "unknown", tostring(blip), tostring(blipExists)
        ))
    end
end

--[[
    CreateTargetBox - Creates an interaction zone at coordinates
    Compatible with ox_target and qb-target systems
    @param coords - Vector3 coordinates where to create the zone
    @param label - Text label for the interaction
    @param _function - Function to call when the target is selected
    @param distance - Maximum distance for interaction
    @param icon - Icon to display for the interaction
]]--
function CreateTargetBox(coords, label, _function, distance, icon)
    if Config.Target == 'ox_target' then 
        exports.ox_target:addBoxZone({
            coords = coords,
            size = vec3(distance, distance, 2.0),
            rotation = 0,
            options = {
                {
                    name = label,
                    label = label,
                    icon = icon,
                    onSelect = _function,
                }
            }
        })
    elseif Config.Target == 'qb-target' then 
        exports['qb-target']:AddBoxZone(label, coords, 2.0, 2.0, {
            name = label,
            heading = 0.0,
            debugPoly = false,
            minZ = coords.z - 2.0,
            maxZ = coords.z + 2.0,
        }, {
            options = {
                {
                    type = 'client',
                    label = label,
                    action = _function,
                    icon = icon,
                }
            },
            distance = distance
        })
    end
end

--[[
    RemoveTargetBox - Removes a previously created target box zone
    Compatible with ox_target and qb-target systems
    @param label - The label/name of the target zone to remove
]]--
function RemoveTargetBox(label)
    if Config.Target == 'ox_target' then 
        exports.ox_target:removeZone(label)
    elseif Config.Target == 'qb-target' then 
        exports['qb-target']:RemoveZone(label)
    end
end

--[[
    CreateTargetEntity - Creates an interaction option for a specific entity
    Compatible with ox_target and qb-target systems
    @param entity - The entity to attach the target to
    @param label - Text label for the interaction
    @param _function - Function to call when the target is selected
    @param distance - Maximum distance for interaction
    @param icon - Icon to display for the interaction
]]--
function CreateTargetEntity(entity, label, _function, distance, icon)
    if Config.Target == 'ox_target' then 
        exports.ox_target:addLocalEntity(entity, {
            {
                name = label,--name,
                label = label,
                icon = icon,
                onSelect = _function,
                distance = distance
            }
        })
    elseif Config.Target == 'qb-target' then 
        exports['qb-target']:AddTargetEntity(entity, {
            options = {
                {
                    type = 'client',
                    label = label,
                    action = _function,

                    icon = icon,
                }
            },
            distance = 2.5
        })
    end
end

--[[
    RemoveTargetEntity - Removes interaction options from a specific entity
    Compatible with ox_target and qb-target systems
    @param entity - The entity to remove the target from
    @param name - The name/label of the target to remove
]]--
function RemoveTargetEntity(entity, name)
    if Config.Target == 'ox_target' then -- Remove by name
        exports.ox_target:removeLocalEntity(entity, name)
    elseif Config.Target == 'qb-target' then --Remove by label
        exports['qb-target']:RemoveTargetEntity(entity, name)
    end
end

--[[
    MyDrawMarker - Draws a marker at specified coordinates
    @param coords - The coordinates where to draw the marker
]]--
function MyDrawMarker(coords)
    DrawMarker(2, coords.x, coords.y, coords.z+1, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 
        255, 0, 0, 70, false, true, 2, nil, nil, false)
end

--[[
    Draw3DText - Draws 3D text at specified world coordinates
    The text scales based on distance from the camera
    @param x - X coordinate in the world
    @param y - Y coordinate in the world
    @param z - Z coordinate in the world
    @param text - The text to display
]]--
function Draw3DText(x, y, z, text)
    local scl_factor = 0.25
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov * scl_factor
    if onScreen then
        SetTextScale(0.0, scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

--[[
    Draw2DText - Draws 2D text on the screen at specified screen coordinates
    @param x - X coordinate on screen (0.0-1.0)
    @param y - Y coordinate on screen (0.0-1.0)
    @param text - The text to display
    @param scale - The scale of the text
]]--
function Draw2DText(x, y, text, scale)
    SetTextFont(4)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

--[[
    RefreshJobBlips - Removes all current blips and recreates them based on current job permissions
    Called when player job changes to update blip visibility
]]--
function RefreshJobBlips()
    if Config.Debug then
        print("[DEBUG] Refreshing job blips due to job change")
    end
    
    -- Remove all existing blips from map and clear array
    for _, blip in pairs(blips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
            if Config.Debug then
                print("[DEBUG] Removed existing blip")
            end
        end
    end
    blips = {} -- Clear the entire array
    
    -- Recreate job blips immediately - no timeout needed for performance
    -- First recreate zone-based blips (like mining area) using stored zone indices
    local jobConfigs = {
        { name = "Mining", zoneIndex = _G.miningZoneIndex },
        { name = "Lumberjack", zoneIndex = _G.lumberjackZoneIndex },
        { name = "Farming", zoneIndex = _G.farmingZoneIndex },
        { name = "Recycling", zoneIndex = _G.scrapZoneIndex },
        { name = "Hunting", zoneIndex = nil },
        { name = "Fishing", zoneIndex = nil }
    }

    for _, jobInfo in ipairs(jobConfigs) do
        local jobName = jobInfo.name
        local jobConfig = Config.Jobs[jobName]
        
        if jobConfig and jobConfig.Enabled then
            local zone = nil
            if jobInfo.zoneIndex and jobConfig.Zones then 
                zone = jobConfig.Zones[jobInfo.zoneIndex]
            end

            -- Create area blip if applicable and zone exists
            if zone then 
                for _, blip in pairs(jobConfig.Blips) do
                    if blip.Position == nil and blip.Area ~= nil then
                        CreateBlipAtCoords(blip.Sprite, blip.Text, blip.Color, zone[1], jobName)
                        CreateBlipAreaAtCoords(blip.Area.Color, blip.Area.Alpha, zone[2], zone[1], jobName)
                        break
                    end
                end
            elseif (jobName == "Hunting" or jobName == "Fishing") and jobConfig.Blips then
                for _, blip in pairs(jobConfig.Blips) do
                    if blip.Position and blip.Area ~= nil then
                        CreateBlipAtCoords(blip.Sprite, blip.Text, blip.Color, blip.Position, jobName)
                        CreateBlipAreaAtCoords(blip.Area.Color, blip.Area.Alpha, blip.Area.Size, blip.Position, jobName)
                        break
                    end
                end
            end
        end
    end
    
    -- Then recreate NPC and fixed position blips
    for jobName, job in pairs(Config.Jobs) do
        if job.Enabled then
            -- Find the NPC for this job
            for _, npc in pairs(npcs) do
                for jName, jData in pairs(Config.Jobs) do
                    if jData.NPC and jData.NPC.Name == npc.name and jData.NPC.Type == npc.type and jName == jobName then
                        CreateBlipOnEntity(jData.NPC.Blip.Sprite, jData.NPC.Blip.Text, jData.NPC.Blip.Color, npc.ped, jobName)
                        break
                    end
                end
            end
            
            -- Recreate fixed position blips (without area)
            for _, blip in pairs(job.Blips) do
                if blip.Position ~= nil and blip.Area == nil then
                    CreateBlipAtCoords(blip.Sprite, blip.Text, blip.Color, blip.Position, jobName)
                end
            end
        end
    end
    
    if Config.Debug then
        print("[DEBUG] Job blips refresh completed")
    end
end

-- Add event handler to receive notification calls from server
RegisterNetEvent('forge-jobs:client:showNotification')
AddEventHandler('forge-jobs:client:showNotification', function(message, type, duration)
    Notification(message, type, duration) -- Call the local Notification function
end)



--[[
    StartProgressBar - Initiates a progress bar for a specified duration.
    Only when you put UseProgressBar to true in the config and UseSkillCheck to false.
    @param duration - The duration of the progress bar in milliseconds.
    @param label - The text label to display on the progress bar.
    @returns - true if the progress bar completes successfully, false if cancelled or ox_lib is not found.
]]--
function StartProgressBar(duration, label)
    local success = false -- Default to false

    -- ox_lib (Default recommended)
    if exports.ox_lib then
        -- If you want to use a different progress bar library,
        -- you can comment out or remove this ox_lib block and uncomment/
        -- You can also add your own.
        success = exports.ox_lib:progressBar({
            duration = duration,
            label = label,
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = true,
                car = true,
                combat = true,
            },
        })
        return success -- Return result from ox_lib
    
    else
        -- This block runs if ox_lib is not found AND no alternative was successfully configured above.
        print("[Forge-Jobs] ERROR: Compatible progress bar library (ox_lib or alternative) not found or configured. Install/configure one or disable UseProgressBar in config.")
        Notification(Config.Locales[Config.Locale].notifications.CannotInteract or "Action failed: Missing dependency.") -- Notify user
        return false -- Action fails if no progress bar runs
    end
end

--[[
    HasJob - Checks if a player has a specific job
    Works with different frameworks (ESX, QB, QBOX)
    For QB/QBOX also checks if player is on duty if applicable
    @param jobName - The name of the job to check
    @returns - true if player has the job (and is on duty if applicable), false otherwise
]]--
function HasJob(activity)
    local cfg = Config.Jobs[activity]
    if not cfg then return false end

    local restrict = cfg.JobRestrictions
    if not restrict or not restrict.enabled then
        return true                   
    end

    local allowed = {}
    for _, j in ipairs(restrict.allowedJobs or {}) do
        allowed[string.lower(j)] = true
    end

    if Config.Framework == "ESX" then
        local pd = ESX.GetPlayerData()
        local job = pd.job and string.lower(pd.job.name or "")
        local hasAccess = allowed[job] or false
        
        if Config.Debug then
            print(("[DEBUG] HasJob check for '%s': Current job='%s', Allowed jobs=%s, Access=%s"):format(
                activity, job, table.concat(restrict.allowedJobs or {}, ","), tostring(hasAccess)
            ))
        end
        
        return hasAccess

    elseif Config.Framework == "QB" or Config.Framework == "QBOX" then
        local pd = QBCore.Functions.GetPlayerData()
        local job = pd.job and string.lower(pd.job.name or "")
        if not allowed[job] then 
            if Config.Debug then
                print(("[DEBUG] HasJob check for '%s': Job '%s' not in allowed list %s"):format(
                    activity, job, table.concat(restrict.allowedJobs or {}, ",")
                ))
            end
            return false 
        end

        if pd.job.onduty ~= nil then
            local hasAccess = pd.job.onduty
            if Config.Debug then
                print(("[DEBUG] HasJob check for '%s': Job='%s', On duty=%s"):format(
                    activity, job, tostring(hasAccess)
                ))
            end
            return hasAccess
        end
        return true
    end

    return false
end

-- HUNTING OPEN FUNCTIONS

--[[
    HandleAnimalKilled - Client-side function called when an animal is killed by the player
    This function can be modified to add custom logic when animals are killed.
    @param animalPed - The animal entity that was killed
    @param playerPed - The player entity who killed the animal
]]--
function HandleAnimalKilled(animalPed, playerPed)
    -- Default behavior: Send to server
    TriggerServerEvent("forge-jobs:server:AnimalKilled", PedToNet(animalPed))
    
    -- You can add custom logic here:
    -- - Custom notifications
    -- - Additional effects
    -- - Custom reward calculations
    -- - Integration with other systems
    
    -- Example of custom additions:
    -- Notification(Config.Locales[Config.Locale].notifications.Caught:gsub("{string}", "Animal"))
    -- Add custom particle effects, sounds, etc.
end

--[[
    HandleAnimalSkinning - Client-side function that handles the complete animal skinning process
    This function can be modified to customize the skinning animation, effects, and interactions.
    @param animalPed - The animal entity to be skinned
]]--
function HandleAnimalSkinning(animalPed)
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)

    if not DoesEntityExist(animalPed) or not IsEntityAPed(animalPed) then
        if Config.Debug then
            print(("[FORGE_JOBS_CLIENT_DEBUG] SkinAnimal (Client) - Event received for INVALID animalPed: %s. Aborting early."):format(animalPed))
        end
        return
    end

    -- Check knife requirement for skinning animals
    if Config.Jobs["Hunting"].RequireKnifeToSkin then
        if not HasItem(Config.Jobs["Hunting"].KnifeItemName) then
            -- Request knife label from server and show notification
            TriggerServerEvent("forge-jobs:server:RequestKnifeLabel", Config.Jobs["Hunting"].KnifeItemName)
            return
        end
    end

    local initialNetId = NetworkGetNetworkIdFromEntity(animalPed)
    if initialNetId == 0 then
        if Config.Debug then
            print(("[FORGE_JOBS_CLIENT_DEBUG] SkinAnimal (Client) - animalPed: %s HAS NO NetworkID at start. Aborting."):format(animalPed))
        end
        return
    end

    SetEntityAsMissionEntity(animalPed, true, true)

    if Config.Debug then
        print(("[FORGE_JOBS_CLIENT_DEBUG] SkinAnimal (Client) - Event received for animalPed: %s, DoesEntityExist: %s, IsEntityAPed: %s, NetworkID: %s. Reinforced as mission entity."):format(animalPed, DoesEntityExist(animalPed), IsEntityAPed(animalPed), initialNetId))
    end

    SetEntityHeading(ped, CoordsFaceCoords(pedCoords, GetEntityCoords(animalPed)))

    -- Disable inventory during skinning process
    DisableInventory()

    -- Camera control
    local cam = nil
    local createdCam = nil
    if Config.Jobs["Hunting"].EnableFarmingCamera then
        local camCoords = GetOffsetFromEntityInWorldCoords(ped, 1.5, 1.0, -0.6)
        local camHeading = CoordsFaceCoords(GetOffsetFromEntityInWorldCoords(ped, 3.5, 0.0, 0.0), pedCoords)
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camCoords.x, camCoords.y, camCoords.z, 0, 0, camHeading, 90.0, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 2000, true, true, 0)
        createdCam = cam
    end

    Wait(350)

    -- Create skinning tool prop
    local anim = Config.Animations["Hunting"]
    local prop = CreateObject(GetHashKey(anim.Props.SkinPropModel), pedCoords.x, pedCoords.y, pedCoords.z, true, false, false)
    while not DoesEntityExist(prop) do Wait(100) end
    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, anim.SkinPropOptions.bone), anim.SkinPropOptions.offsetX, anim.SkinPropOptions.offsetY, anim.SkinPropOptions.offsetZ,
        anim.SkinPropOptions.rotationX, anim.SkinPropOptions.rotationY, anim.SkinPropOptions.rotationZ, false, false, false, true, 1, true)

    -- Start skinning animation sequence
    TaskPlayAnim(ped, anim.Animations.SkinEnter[1], anim.Animations.SkinEnter[2], 1.0, 1.0, anim.Animations.SkinEnter[3], 0, 0, false, false, false)
    Wait(100)
    while IsEntityPlayingAnim(ped, anim.Animations.SkinEnter[1], anim.Animations.SkinEnter[2], 3) do Wait(10) end
    
    -- Blood effects
    local bloodParticles = {}
    local bloodEffects = {
        "cs_bankheist_blood_sec",
        "blood_chopper",
        "td_blood_shotgun"
    }

    for _, effect in ipairs(bloodEffects) do
        UseParticleFxAssetNextCall("core")
        local blood = StartParticleFxLoopedOnEntity(effect, animalPed, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, false, false, false)
        table.insert(bloodParticles, blood)
    end

    TaskPlayAnim(ped, anim.Animations.SkinBase[1], anim.Animations.SkinBase[2], 100.0, 1.0, anim.Animations.SkinBase[3], 1, 0, false, false, false)
    
    Wait(100)
    local exit = false
    Citizen.CreateThread(function() Wait(5000) exit = true end)
    while IsEntityPlayingAnim(ped, anim.Animations.SkinBase[1], anim.Animations.SkinBase[2], 3) and not exit do Wait(0) end

    -- Stop blood effects
    for _, particle in ipairs(bloodParticles) do
        StopParticleFxLooped(particle, 0)
    end

    Wait(100)
    -- Screen fade out
    if Config.EnableScreenFades then
        DoScreenFadeOut(Config.ScreenFadeDuration)
        Wait(Config.ScreenFadeDuration)
    end

    -- Exit animation
    TaskPlayAnim(ped, anim.Animations.SkinExit[1], anim.Animations.SkinExit[2], 100.0, 1.0, anim.Animations.SkinExit[3], 0, 0, false, false, false)
    Wait(100)
    while IsEntityPlayingAnim(ped, anim.Animations.SkinExit[1], anim.Animations.SkinExit[2], 3) do Wait(10) end

    -- Create bone props
    local boneProps = Config.Animations["Hunting"].Props.BoneProps
    local randomBoneProp = boneProps[math.random(#boneProps)]
    
    local animalBones = CreateObject(GetHashKey(randomBoneProp), GetEntityCoords(animalPed), true, false, false)
    SetEntityHeading(animalBones, GetEntityHeading(animalPed))
    PlaceObjectOnGroundProperly(animalBones)

    -- System to delete bones after a time
    Citizen.CreateThread(function()
        local timeToDelete = 120000 -- 2 minutes
        local startTime = GetGameTimer()
        
        while DoesEntityExist(animalBones) do
            Wait(1000)
            local currentPlayerCoords = GetEntityCoords(PlayerPedId())
            local bonesCoords = GetEntityCoords(animalBones)
            local distance = #(currentPlayerCoords - bonesCoords)
            
            if distance > 100.0 or (GetGameTimer() - startTime) > timeToDelete then
                DeleteEntity(animalBones)
                break
            end
        end
    end)

    -- Cleanup props and camera
    DeleteEntity(prop)
    if createdCam then
        DestroyCam(createdCam, true)
        createdCam = nil
        RenderScriptCams(false, true, 1, true, true, 0)
    end

    -- Screen fade in
    if Config.EnableScreenFades then
        DoScreenFadeIn(Config.ScreenFadeDuration)
    end

    if Config.Debug then
        print(("[FORGE_JOBS_CLIENT_DEBUG] SkinAnimal (Client) - About to TriggerServerEvent. animalPed: %s (local handle), DoesEntityExistLocally: %s, initialNetIdToSend: %s, CurrentPedToNetForLocaHandle: %s"):format(animalPed, DoesEntityExist(animalPed), initialNetId, PedToNet(animalPed)))
    end

    if not DoesEntityExist(animalPed) then 
        if Config.Debug then
            print(("[FORGE_JOBS_CLIENT_DEBUG] SkinAnimal (Client) - Local animal entity handle %s no longer exists. Proceeding to trigger server event with initialNetId %s."):format(animalPed, initialNetId))
        end
    end
    
    -- Call hunting hook for integrations
    if JobActionClient then
        pcall(JobActionClient, "Hunting", 1)
    end
    
    -- Send event to server for server-side hooks
    TriggerServerEvent("forge-jobs:JobActionServer", "Hunting", 1)
    
    -- Send to server
    TriggerServerEvent("forge-jobs:server:SkinAnimal", initialNetId) 

    if Config.Debug then
        print(("[FORGE_JOBS_CLIENT_DEBUG] SkinAnimal (Client) - TriggerServerEvent for forge-jobs:server:SkinAnimal has been CALLED with NetID: %s (from initialNetId)"):format(initialNetId))
    end

    -- Enable inventory after skinning process
    EnableInventory()
end

--[[
    DisableInventory - Blocks inventory access during job actions like animations, cameras, etc.
    Universal function that works with ox_inventory, qb-inventory, and quasar-inventory
    Called before starting job actions to prevent inventory access during immersive moments
]]--
function DisableInventory()
    if Config.Inventory == "ox_inventory" then
        -- Use ox_inventory state bag system
        LocalPlayer.state.invBusy = true
    elseif Config.Inventory == "qb-inventory" then
        -- Use qb-inventory state bag system
        LocalPlayer.state:set('inv_busy', true, true)
    elseif Config.Inventory == "quasar-inventory" then
        -- Use quasar-inventory export
        exports['qs-inventory']:setInventoryDisabled(true)
    end
    
    if Config.Debug then
        print("[Forge-Jobs] Inventory disabled (" .. Config.Inventory .. ")")
    end
end

--[[
    EnableInventory - Restores inventory access after job actions complete
    Universal function that works with ox_inventory, qb-inventory, and quasar-inventory
    Called after job actions finish to restore normal inventory functionality
]]--
function EnableInventory()
    if Config.Inventory == "ox_inventory" then
        -- Restore ox_inventory access
        LocalPlayer.state.invBusy = false
    elseif Config.Inventory == "qb-inventory" then
        -- Restore qb-inventory access
        LocalPlayer.state:set('inv_busy', false, true)
    elseif Config.Inventory == "quasar-inventory" then
        -- Restore quasar-inventory access
        exports['qs-inventory']:setInventoryDisabled(false)
    end
    
    if Config.Debug then
        print("[Forge-Jobs] Inventory enabled (" .. Config.Inventory .. ")")
    end
end

--[[
    Hands Up Command Override System
    Problem: Players use X key (hands up) to cancel job animations and skip work
    Solution: Override hands up commands with controlled versions that check ForgeJobsHandsUpBlocked
    
    QB Framework: Overrides 'hu' command from qb-smallresources 
    ESX Framework: Overrides common emote commands (handsup, hu, hands, surrender)
    
    Benefits: Universal blocking during jobs, perfect restoration after, no conflicts
]]--

-- Variables for control management
local controlsDisabled = false
local controlThread = nil

-- Global variable to control hands up - accessible by overridden command
ForgeJobsHandsUpBlocked = false

-- Common problematic animations that should be blocked
local problematicAnimations = {
    {'missminuteman_1ig_2', 'handsup_base'},           -- QB hands up
    {'random@mugging3', 'handsup_standing_base'},      -- Surrender
    {'mp_arrest_paired', 'crook_p2_back_right'},       -- Arrest
    {'mp_arresting', 'idle'},                          -- Arrest idle
    {'anim@mp_player_intuppersurrender', 'idle'},      -- Surrender emote
}

if (Config.Framework == "QB" or Config.Framework == "QBOX") and GetResourceState('qb-smallresources') == 'started' then
    -- QB: Override the 'hu' command from qb-smallresources
    RegisterCommand('hu', function()
        if ForgeJobsHandsUpBlocked then
            if Config.Debug then
                print('[Forge-Jobs] Hands up command blocked during job action')
            end
            return -- Do nothing if blocked
        end
        
        -- Execute original hands up logic when not blocked
        local ped = PlayerPedId()
        if not HasAnimDictLoaded('missminuteman_1ig_2') then
            RequestAnimDict('missminuteman_1ig_2')
            while not HasAnimDictLoaded('missminuteman_1ig_2') do
                Wait(10)
            end
        end
        
        -- Check if already doing hands up
        local handsUp = IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_base', 3)
        
        if not handsUp then
            -- Start hands up
            if exports['qb-policejob']:IsHandcuffed() then return end
            TaskPlayAnim(ped, 'missminuteman_1ig_2', 'handsup_base', 8.0, 8.0, -1, 50, 0, false, false, false)
        else
            -- Stop hands up
            ClearPedTasks(ped)
        end
    end, false)
    
    RegisterKeyMapping('hu', 'Hands Up', 'keyboard', 'X')
    
elseif Config.Framework == "ESX" then
    -- ESX: Override common emote commands with controlled versions
    local esxEmoteCommands = {'handsup', 'hu', 'hands', 'surrender'}
    
    for _, cmd in ipairs(esxEmoteCommands) do
        RegisterCommand(cmd, function()
            if ForgeJobsHandsUpBlocked then
                if Config.Debug then
                    print('[Forge-Jobs] ESX emote command "' .. cmd .. '" blocked during job action')
                end
                return -- Do nothing if blocked
            end
            
            -- Execute hands up logic when not blocked
            local ped = PlayerPedId()
            if not HasAnimDictLoaded('missminuteman_1ig_2') then
                RequestAnimDict('missminuteman_1ig_2')
                while not HasAnimDictLoaded('missminuteman_1ig_2') do
                    Wait(10)
                end
            end
            
            -- Check if already doing hands up
            local handsUp = IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_base', 3)
            
            if not handsUp then
                -- Start hands up
                TaskPlayAnim(ped, 'missminuteman_1ig_2', 'handsup_base', 8.0, 8.0, -1, 50, 0, false, false, false)
            else
                -- Stop hands up
                ClearPedTasks(ped)
            end
        end, false)
    end
    
    -- Register X key for hands up in ESX
    RegisterKeyMapping('handsup', 'Hands Up', 'keyboard', 'X')
end

--[[
    DisableAllControls - Universal control blocking system for job actions
    Works with both QB (with qb-smallresources) and ESX frameworks
    Prevents players from using hands-up or other interrupting actions
]]--
function DisableAllControls()
    if controlsDisabled then return end
    controlsDisabled = true
    
    -- Block hands up for both QB and ESX using global variable
    ForgeJobsHandsUpBlocked = true
    
    -- Main control blocking thread
    controlThread = Citizen.CreateThread(function()
        while controlsDisabled do
            local ped = PlayerPedId()
            
            -- Block all controls aggressively
            for i = 0, 350 do
                DisableControlAction(0, i, true)
                DisableControlAction(1, i, true) 
                DisableControlAction(2, i, true)
            end
            
            -- ENHANCED detection and cancellation for ESX
            -- Check every frame for hands up animation and cancel immediately
            if IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_base', 1) then
                if Config.Debug then
                    print('[Forge-Jobs] Hands up animation detected and cancelled (ESX)')
                end
                ClearPedTasks(ped)
                StopAnimTask(ped, 'missminuteman_1ig_2', 'handsup_base', 3.0)
                -- Force clear multiple times for ESX
                Citizen.Wait(1)
                ClearPedTasks(ped)
            end
            
            -- Detect and cancel other problematic animations
            for _, anim in ipairs(problematicAnimations) do
                if anim[1] ~= 'missminuteman_1ig_2' then -- Skip already handled above
                    if IsEntityPlayingAnim(ped, anim[1], anim[2], 3) then
                        if Config.Debug then
                            print('[Forge-Jobs] Blocked animation: ' .. anim[1] .. ' -> ' .. anim[2])
                        end
                        ClearPedTasks(ped)
                        StopAnimTask(ped, anim[1], anim[2], 1.0)
                    end
                end
            end
            
            Wait(0)
        end
        controlThread = nil
    end)
    
    if Config.Debug then
        print('[Forge-Jobs] Advanced control blocking activated')
    end
end

--[[
    EnableAllControls - Re-enables all controls and hands up functionality
]]--
function EnableAllControls()
    if not controlsDisabled then return end
    controlsDisabled = false
    
    -- Re-enable QB hands up command
    ForgeJobsHandsUpBlocked = false
    
    if Config.Debug then
        print('[Forge-Jobs] All controls re-enabled')
    end
end


-- Network events for server-triggered inventory control (mainly for Quasar)
RegisterNetEvent('forge-jobs:client:disableInventory')
AddEventHandler('forge-jobs:client:disableInventory', function()
    DisableInventory()
end)

RegisterNetEvent('forge-jobs:client:enableInventory')
AddEventHandler('forge-jobs:client:enableInventory', function()
    EnableInventory()
end)
