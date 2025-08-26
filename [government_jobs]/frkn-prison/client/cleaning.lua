local poopProps = {}


local firstSpawn = true

local isCleaning = false
local hasTool = nil

local respawnTimer = nil

Citizen.CreateThread(function()
    while true do
        if #poopProps == 0 and respawnTimer == nil then
            respawnTimer = GetGameTimer() + FRKN.Job.respawnDelay
        end

        if #poopProps == 0 and respawnTimer and GetGameTimer() >= respawnTimer then
            local spawned = 0
            while spawned < FRKN.Job.maxPoops do
                local zone = FRKN.Job.cleanupZones[math.random(1, #FRKN.Job.cleanupZones)]
                local randomX = math.random(zone.x1 * 100, zone.x2 * 100) / 100
                local randomY = math.random(zone.y1 * 100, zone.y2 * 100) / 100
                local randomZ = zone.z1
                local randomHeading = math.random(0, 360)

                RequestModel(FRKN.Job.poopModel)
                while not HasModelLoaded(FRKN.Job.poopModel) do Wait(0) end
                
                local obj = CreateObject(GetHashKey(FRKN.Job.poopModel), randomX, randomY, randomZ, false, false, false)
                SetEntityHeading(obj, randomHeading)
                FreezeEntityPosition(obj, true)

                if FRKN.General.targetSystem == 'qb-target' then
                    exports['qb-target']:AddTargetEntity(obj, {
                        options = {
                            {
                                icon = "fas fa-broom",
                                label = Lang:t('general.clean_poop'),
                                canInteract = function()
                                    return not isCleaning
                                end,
                                action = function(entity)
                                    for i = 1, #poopProps do
                                        if poopProps[i] == entity then
                                            CleanPoop(entity, i)
                                            break
                                        end
                                    end
                                end
                            }
                        },
                        distance = 3.0
                    })

                elseif FRKN.General.targetSystem == 'ox_target' then
                    exports.ox_target:addLocalEntity(obj, {
                        {
                            icon = "fas fa-broom",
                            label = Lang:t('general.clean_poop'),
                            canInteract = function(entity)
                                return not isCleaning
                            end,
                            onSelect = function(data)
                                for i = 1, #poopProps do
                                    if poopProps[i] == data.entity then
                                        CleanPoop(data.entity, i)
                                        break
                                    end
                                end
                            end
                        }
                    })
                end

                table.insert(poopProps, obj)
                spawned = spawned + 1
            end

            respawnTimer = nil
        end

        Wait(1000)
    end
end)


CreateThread(function()
    while true do
        local sleep = 1000

        if tasks then 
            local playerCoords = GetEntityCoords(PlayerPedId())

            for _, obj in ipairs(poopProps) do
                if DoesEntityExist(obj) then
                    local coords = GetEntityCoords(obj)
                    if #(playerCoords - coords) < 20.0 then
                        sleep = 0
                        DrawMarker(2, coords.x, coords.y, coords.z + 0.3, 0, 0, 0, 0, 0, 0, 0.35, 0.35, 0.35, 150, 75, 75, 150, false, true, 2, false, nil, nil, false)
                    end
                end
            end
        end

        if respawnTimer and GetGameTimer() >= respawnTimer then
            poopProps = {}
            respawnTimer = nil
        end

        Wait(sleep)
    end
end)



function CleanPoop(obj, index)
    if isCleaning then return end

    if not isInPrison() then
        Notify(Lang:t('error.not_in_jail'), 'error')
        return
    end


    if globalJailRecord then 
        for _, v in pairs(globalJailRecord.tasks_data or {}) do
            if v.name == 'Poop Cleaning' then 
                if v.currentCount >= v.targetCount then 
                    Notify(Lang:t('error.clean_full'), 'error')
                    return
                end
            end
        end
    end


    isCleaning = true 
    local ped = PlayerPedId()
    local animDict = "amb@world_human_janitor@male@idle_a"
    local animName = "idle_a"

    hasTool = CreateCleaningProp()

    CreateThread(function()
        DisableAllControlActions(0)
        EnableControlAction(0, 1, true)
        EnableControlAction(0, 2, true)
    end)

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Wait(10) end

    TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)

    SetTimeout(FRKN.Job.cleanupTime, function()
        StopCleaning(obj, index)
    end)
end

function isInPrison()
    if not FRKN.Job.JobPrisonControl then
        return true
    end

    local playerIdentifier = GetPlayerIdentifier()
    for _, v in pairs(cacheData or {}) do
        if v.player_id == playerIdentifier then
            if v.status == 1 then
                playerJailRecord = v
                return true
            end
        end
    end
    return false
end


function StopCleaning(targetObj, index)
    ClearPedTasks(PlayerPedId())

    if hasTool then
        DeleteObject(hasTool)
        hasTool = nil
    end

    if targetObj and DoesEntityExist(targetObj) then 
        if FRKN.General.targetSystem == 'qb-target' then
            exports['qb-target']:RemoveTargetEntity(targetObj)
        elseif FRKN.General.targetSystem == 'ox_target' then
            exports.ox_target:removeLocalEntity(targetObj)
        end

        DeleteObject(targetObj)
        if index then table.remove(poopProps, index) end
    end

    isCleaning = false

    if #poopProps == 0 then
        TriggerServerEvent('frkn-prison:taskCompleted', 'poop')
        respawnTimer = GetGameTimer() + FRKN.Job.respawnDelay
    end
end


function CreateCleaningProp()
    local ped = PlayerPedId()
    RequestModel(FRKN.Job.cleaningTool)
    while not HasModelLoaded(FRKN.Job.cleaningTool) do Wait(10) end

    local tool = CreateObject(GetHashKey(FRKN.Job.cleaningTool), 0.0, 0.0, 0.0, true, true, false)
    SetEntityCollision(tool, false, false)
    AttachEntityToEntity(tool, ped, GetPedBoneIndex(ped, 28422), -0.005, 0.0, 0.0, 360.0, 360.0, 0.0, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(FRKN.Job.cleaningTool)

    return tool
end


AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for _, obj in ipairs(poopProps) do
            if DoesEntityExist(obj) then
                if FRKN.General.targetSystem == 'qb-target' then
                    exports['qb-target']:RemoveTargetEntity(obj)
                elseif FRKN.General.targetSystem == 'ox_target' then
                    exports.ox_target:removeLocalEntity(obj)
                end
                DeleteObject(obj)
            end
        end

        poopProps = {}

        if hasTool and DoesEntityExist(hasTool) then
            DeleteObject(hasTool)
            hasTool = nil
        end
    end
end)
