if not Config.UseTarget then
    return
end

local target = exports['qtarget']

Target = {}

CreateThread(function()
    Wait(1250) -- Wait for initialize the dynamic things.
    target:Ped({
        options = {
            {
                label = Lang('DRUGS_TARGET_SELLER_MENU'),
                icon = 'fas fa-cog',
                action = function(entity)
                    local sellerData = table.find(SellerPeds, function(v)
                        return v.ped == entity
                    end)
                    OpenSellerMenu(CSellers[sellerData.id])
                end,
                canInteract = function(entity)
                    return table.find(SellerPeds, function(v)
                        return v.ped == entity
                    end)
                end
            },
        },
        distance = Config.TargetDistance
    })

    local drugModels = {}
    for k, v in pairs(Config.CollectItems) do
        table.insert(drugModels, joaat(v.prop))
    end
    target:AddTargetModel(drugModels, {
        options = {
            {
                label = Lang('DRUGS_TARGET_COLLECT_DRUG'),
                icon = 'fas fa-cog',
                action = function(entity)
                    local drugObjectData = table.find(ClosestDrugObjects, function(v)
                        return v.handle == entity
                    end)
                    local ped = PlayerPedId()
                    local drugData = Config.CollectItems[drugObjectData.drugType]
                    TaskStartScenarioInPlace(ped, 'world_human_gardener_plant', 0, false)
                    ProgressBar('collection', drugData.collect_label, drugData.time, false, false, false, false, false, false)
                    ClearPedTasks(ped)
                    Wait(1500)
                    DeleteEntity(drugObjectData.handle)
                    TriggerServerEvent('drugs:collectDrug', drugObjectData.drugType)
                end,
                canInteract = function(entity)
                    local ped = PlayerPedId()
                    if not InsideFarm then
                        return false
                    end
                    if IsPedUsingScenario(ped, 'WORLD_HUMAN_GARDENER_PLANT') then
                        return false
                    end
                    return table.find(ClosestDrugObjects, function(v)
                        return v.handle == entity
                    end)
                end
            },
        },
        distance = Config.TargetDistance
    })

    local hashes = {}
    for a, x in pairs(Config.DynamicFurnitures) do
        table.insert(hashes, joaat(a))
    end
    target:AddTargetModel(hashes, {
        options = {
            {
                icon = 'fa-solid fa-magnifying-glass',
                label = Lang('DRUGS_TARGET_INTERACT_OBJECT'),
                action = function(entity) -- This is the action it has to perform, this REPLACES the event and this is OPTIONAL
                    local decorations = ObjectList
                    if not decorations then
                        Debug('No decorations')
                        return
                    end
                    local decorationData = table.find(decorations, function(decoration)
                        return joaat(decoration.modelName) == GetEntityModel(entity) and decoration.handle == entity
                    end)
                    local objectData = table.find(Config.DynamicFurnitures, function(furniData, key)
                        return GetHashKey(key) == GetEntityModel(entity)
                    end)
                    if not objectData then return print('No objectData') end
                    if not decorationData then return print('No decorationData') end
                    if objectData.fn then
                        objectData.fn(entity, decorationData.id)
                        return
                    end
                    if objectData.type == 'stash' then
                        OpenStash(objectData.stash, 'van_object_' .. decorationData.id)
                    elseif objectData.type == 'gardrobe' then
                        OpenClotheMenu()
                    end
                end,
                canInteract = function(entity, distance, data)
                    local enteredLab = EnteredLab
                    if not enteredLab then
                        return false
                    end
                    return true
                end,
            }
        },
        distance = Config.TargetDistance
    })
end)

function Target:clearInsideLab()
    Debug('[Target] clearInsideLab')
    target:RemoveZone('lab_exit')
    target:RemoveZone('lab_stash')
    target:RemoveZone('lab_wardrobe')
end

function Target:InitializeInsideLab(exitCoords)
    self:clearInsideLab()
    Debug('[Target] InitializeInsideLab')

    -- Initialize Exit
    target:AddBoxZone('lab_exit', exitCoords, Config.TargetLength, Config.TargetWidth, {
        name = 'lab_exit',
        heading = 90.0,
        debugPoly = Config.ZoneDebug,
        minZ = exitCoords.z - 15.0,
        maxZ = exitCoords.z + 5.0,
    }, {
        options = {
            {
                icon = 'fa-solid fa-door-open',
                label = Lang('DRUGS_TARGET_EXIT_LAB'),
                action = function()
                    LeaveLab()
                end,
                canInteract = function(entity, distance, data)
                    return true
                end,
            },
            {
                icon = 'fa-solid fa-bell',
                label = Lang('DRUGS_TARGET_DOOR_BELL_IN'),
                action = function()
                    Debug('Opened Door')
                    TriggerServerEvent('drugs:openDoor', CurrentLabData.shell.entry, CurrentDoorBell, EnteredLab)
                    CurrentDoorBell = 0
                end,
                canInteract = function(entity, distance, data)
                    return CurrentDoorBell ~= 0
                end,
            }
        },
        distance = Config.TargetLength
    })

    Debug('[Target] CurrentLabData', CurrentLabData)
    -- Initialize Stash
    local stashCoords = CurrentLabData.stash
    if stashCoords then
        Debug('[Target] InitializeInsideLab - Stash')
        target:AddBoxZone('lab_stash', stashCoords, Config.TargetLength, Config.TargetWidth, {
            name = 'lab_stash',
            heading = 90.0,
            debugPoly = Config.ZoneDebug,
            minZ = stashCoords.z - 15.0,
            maxZ = stashCoords.z + 5.0,
        }, {
            options = {
                {
                    icon = 'fa-solid fa-box',
                    label = Lang('DRUGS_TARGET_STASH'),
                    action = function()
                        OpenStash()
                    end,
                    canInteract = function(entity, distance, data)
                        return true
                    end,
                }
            },
            distance = Config.TargetLength
        })
    end

    -- Initialize Wardrobe
    local wardrobeCoords = CurrentLabData.wardrobe
    if wardrobeCoords then
        Debug('[Target] InitializeInsideLab - Wardrobe')
        target:AddBoxZone('lab_wardrobe', wardrobeCoords, Config.TargetLength, Config.TargetWidth, {
            name = 'lab_wardrobe',
            heading = 90.0,
            debugPoly = Config.ZoneDebug,
            minZ = wardrobeCoords.z - 15.0,
            maxZ = wardrobeCoords.z + 5.0,
        }, {
            options = {
                {
                    icon = 'fa-solid fa-tshirt',
                    label = Lang('DRUGS_TARGET_WARDROBE'),
                    action = function()
                        OpenClotheMenu()
                    end,
                    canInteract = function(entity, distance, data)
                        return true
                    end,
                }
            },
            distance = Config.TargetLength
        })
    end
end

local outsideTargets = {}
function Target:clearOutsideLab()
    Debug('[Target] clearOutsideLab')
    for k, v in pairs(outsideTargets) do
        target:RemoveZone(v)
    end
    outsideTargets = {}
end

function Target:InitializeOutsideLab()
    self:clearOutsideLab()
    Debug('[Target] InitializeOutsideLab')
    for k, v in pairs(CLabs) do
        local entryCoords = vec3(v.shell.entry.x, v.shell.entry.y, v.shell.entry.z)
        local id = 'lab_entry_' .. k
        target:AddBoxZone(id, entryCoords, Config.TargetLength, Config.TargetWidth, {
            name = id,
            heading = 90.0,
            debugPoly = Config.ZoneDebug,
            minZ = entryCoords.z - 15.0,
            maxZ = entryCoords.z + 5.0,
        }, {
            options = {
                -- buy
                {
                    icon = 'fa-solid fa-door-open',
                    label = Lang('DRUGS_TARGET_INSPECT'),
                    action = function()
                        InspectHouse(v.name)
                    end,
                    canInteract = function(entity, distance, data)
                        return not v.owner
                    end,
                },
                {
                    icon = 'fa-solid fa-door-open',
                    label = Lang('DRUGS_TARGET_SHOW_CONTRACT'),
                    action = function()
                        TriggerServerEvent('drugs:viewLabContract', v.name)
                    end,
                    canInteract = function(entity, distance, data)
                        return not v.owner
                    end,
                },

                -- Owned by player
                {
                    icon = 'fa-solid fa-door-open',
                    label = Lang('DRUGS_TARGET_ENTER_LAB'),
                    action = function()
                        local hasKey = HasLabKey(v)
                        EnterLab(v.name, hasKey and true or false)
                    end,
                    canInteract = function(entity, distance, data)
                        return HasLabKey(v) or not v.locked
                    end,
                },
                {
                    icon = 'fa-solid fa-door-open',
                    label = Lang('DRUGS_TARGET_RING_DOOR'),
                    action = function()
                        TriggerServerEvent('drugs:ringDoor', v.name)
                        Notification(Lang('DRUGS_NOTIFICATION_BELL_RANG'), 'info')
                    end,
                    canInteract = function(entity, distance, data)
                        if not v.owner then
                            return false
                        end
                        if not v.locked then
                            return false
                        end
                        return not HasLabKey(v)
                    end,
                }
            },
            distance = Config.TargetLength
        })
        outsideTargets[#outsideTargets + 1] = id
    end
end
