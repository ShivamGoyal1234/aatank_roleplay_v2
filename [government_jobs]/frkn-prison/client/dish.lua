local placedCount = 0
local takeCount = 0

local currentDish = nil
local isWashing = false

local function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(10) end
end

local function PlayWashingFX()
    local coords = GetEntityCoords(PlayerPedId())
    UseParticleFxAssetNextCall("core")
    StartParticleFxLoopedAtCoord("ent_sht_water", coords.x+0.4, coords.y + 0.6, coords.z + 0.1, 0.0, 0.0, 0.0, 1.4, false, false, false, false)
end

local function AttachDishToHand(dish)
    local ped = PlayerPedId()
    RequestModel(dish.model)
    while not HasModelLoaded(dish.model) do Wait(10) end

    local obj = CreateObject(dish.model, 0, 0, 0, true, false, false)
    AttachEntityToEntity(obj, ped, GetPedBoneIndex(ped, dish.bone), dish.offset.x, dish.offset.y, dish.offset.z, dish.rotation.x, dish.rotation.y, dish.rotation.z, true, true, false, true, 1, true)

    currentDish = {
        definition = dish,
        entity = obj,
        isWashed = false
    }
end

local function StartWashing()
    if isWashing or not currentDish then return end
    isWashing = true

    local ped = PlayerPedId()
    ClearPedTasks(ped)
    LoadAnimDict("amb@prop_human_bbq@male@base")
    PlayWashingFX()
    TaskPlayAnim(ped, "amb@prop_human_bbq@male@base", "base", 8.0, -8.0, -1, 1, 0, false, false, false)

    -- Citizen.CreateThread(function()
    --     while isWashing do
    --         DisableAllControlActions(0)
    --         EnableControlAction(0, 1, true)
    --         EnableControlAction(0, 2, true)
    --         Wait(0)
    --     end
    -- end)

    Citizen.SetTimeout(8000, function()
        ClearPedTasks(ped)
        TriggerServerEvent("play:waterSound")
        currentDish.isWashed = true
        isWashing = false
    end)
end


function ShowHelpNotification(msg)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, 0, 1, -1)
end





function initDishTarget()
    for _, dish in pairs(FRKN.Job.dishDefinitions) do
        if FRKN.General.targetSystem == 'qb-target' then
            local options = {
                {
                    label = Lang:t("general.take_wash"),
                    icon = "fas fa-hand",
                    canInteract = function()
                        return currentDish == nil
                    end,
                    action = function()
                        local object = GetClosestObjectOfType(dish.coords.x, dish.coords.y, dish.coords.z, 1.0, GetHashKey(dish.model), false, false, false)
                        if object and DoesEntityExist(object) then
                            NetworkRequestControlOfEntity(object)
                            Wait(100)
                            SetEntityAsMissionEntity(object, true, true)
                            DeleteObject(object)
                            AttachDishToHand(dish)
                        end
                    end
                }
            }

            exports['qb-target']:AddBoxZone("dish_zone_"..dish.model..dish.coords.x, dish.coords, 0.4, 0.4, {
                name = "dish_zone_"..dish.model..dish.coords.x,
                heading = 0,
                debugPoly = false,
                minZ = dish.coords.z - 0.5,
                maxZ = dish.coords.z + 1.0,
            }, {
                options = options,
                distance = 1.5
            })

        elseif FRKN.General.targetSystem == 'ox_target' then
            local options = {
                {
                    label = Lang:t("general.take_wash"),
                    icon = "fas fa-hand",
                    canInteract = function()
                        return currentDish == nil
                    end,
                    onSelect = function(data)
                        local object = GetClosestObjectOfType(dish.coords.x, dish.coords.y, dish.coords.z, 1.0, GetHashKey(dish.model), false, false, false)
                        print("Object found: ", object)
                        if object and DoesEntityExist(object) then
                            NetworkRequestControlOfEntity(object)
                            Wait(100)
                            SetEntityAsMissionEntity(object, true, true)
                            DeleteObject(object)
                            AttachDishToHand(dish)
                        end
                    end
                }
            }
            
            exports.ox_target:addBoxZone({
                name = "dish_zone_"..dish.model..dish.coords.x,
                coords = dish.coords,
                size = vec3(0.4, 0.4, 0.5),
                rotation = 0.0,
                debug = false,
                options = options
            })
        end
    end

    if FRKN.General.targetSystem == 'qb-target' then
        local options = {
            {
                label = Lang:t("general.wash_object"),
                icon = "fas fa-hand",
                canInteract = function()
                    return currentDish and not currentDish.isWashed and not isWashing
                end,
                action = function()
                    StartWashing()
                end
            }
        }

        exports['qb-target']:AddBoxZone("wash_zone_1", FRKN.Job.washCoords, 1.0, 1.0, {
            name = "wash_zone_1",
            heading = 270.0,
            debugPoly = false,
            minZ = FRKN.Job.washCoords.z - 1.0,
            maxZ = FRKN.Job.washCoords.z + 1.5,
        }, {
            options = options,
            distance = 2.0
        })

    elseif FRKN.General.targetSystem == 'ox_target' then
        local options = {
            {
                label = Lang:t("general.wash_object"),
                icon = "fas fa-hand",
                canInteract = function()
                    return  currentDish and not currentDish.isWashed and not isWashing
                end,
                onSelect = function(data)
                    StartWashing()
                end
            }
        }

            local zone =exports.ox_target:addSphereZone({
                name = "wash_zone_main",
                coords = FRKN.Job.washCoords,
                size = vec3(0.4, 0.4, 0.5),
                rotation = 0.0,
                debug = false,
                distance = 5.0,
                options = options
            })

    end

    if FRKN.General.targetSystem == 'qb-target' then
        local options = {
            {
                label = Lang:t("general.leave_object"),
                icon = "fas fa-box-open",
                canInteract = function()
                    print(currentDish and currentDish.isWashed)
                    return currentDish and currentDish.isWashed
                end,
                action = function()
                    local dish = currentDish.definition
                    RequestModel(dish.isWashedModel)
                    while not HasModelLoaded(dish.isWashedModel) do Wait(10) end

                    local offsetX = placedCount * 0.5
                    local finalPos = vec3(FRKN.Job.cupboardCoords.x + offsetX, FRKN.Job.cupboardCoords.y, FRKN.Job.cupboardCoords.z)

                    local placed = CreateObject(GetHashKey(dish.isWashedModel), finalPos.x, finalPos.y, finalPos.z, false, false, false)
                    FreezeEntityPosition(placed, true)

                    if currentDish.entity then
                        DeleteObject(currentDish.entity)
                    end

                    currentDish = nil
                    placedCount = placedCount + 1

                    if placedCount >= 5 then
                        TriggerServerEvent("frkn-prison:taskCompleted", "dish")
                    end
                end
            }
        }

        exports['qb-target']:AddBoxZone("cupboard_zone", FRKN.Job.cupboardCoords, 0.6, 0.6, {
            name = "cupboard_zone",
            heading = 0,
            debugPoly = false,
            minZ = FRKN.Job.cupboardCoords.z - 0.5,
            maxZ = FRKN.Job.cupboardCoords.z + 1.0,
        }, {
            options = options,
            distance = 1.5
        })

    elseif FRKN.General.targetSystem == 'ox_target' then
        local options = {
            {
                label = Lang:t("general.leave_object"),
                icon = "fas fa-box-open",
                canInteract = function()
                    return currentDish and currentDish.isWashed
                end,
                onSelect = function()
                    local dish = currentDish.definition
                    print(json.encode(currentDish))
                    RequestModel(dish.isWashedModel)
                    while not HasModelLoaded(dish.isWashedModel) do Wait(10) end
                    print("Dish model loaded: ", dish.isWashedModel)
                    local offsetX = placedCount * 0.5
                    local finalPos = vec3(FRKN.Job.cupboardCoords.x + offsetX, FRKN.Job.cupboardCoords.y, FRKN.Job.cupboardCoords.z)

                    local placed = CreateObject(GetHashKey(dish.isWashedModel), finalPos.x, finalPos.y, finalPos.z, true, false, false)
                    FreezeEntityPosition(placed, true)
                    print("Placed dish at: ", finalPos)
                    if currentDish.entity then
                        DeleteObject(currentDish.entity)
                    end

                    currentDish = nil
                    placedCount = placedCount + 1

                    if placedCount >= 5 then
                        TriggerServerEvent("frkn-prison:taskCompleted", "dish")
                    end
                end
            }
        }

        exports.ox_target:addBoxZone({
            name = "cupboard_zone",
            coords = FRKN.Job.cupboardCoords,
            size = vec3(0.6, 0.6, 0.5),
            rotation = 0.0,
            debug = false,
            options = options
        })
    end
end


