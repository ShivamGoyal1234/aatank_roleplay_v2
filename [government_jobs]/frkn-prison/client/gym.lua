local gymState = {
    barbell = false,
    dumbbell = false,
    pullup = false
}

local changeClothesCoords = FRKN.Job.changeClothesCoords

local isExercising = false
local barbellObj = nil
local originalBarbell = nil
local dumbbellLeft, dumbbellRight = nil, nil

local isDoingPullup = false

local hasChangedClothes = false

local previousOutfit = {}


function gymCompleted()
    TriggerServerEvent("frkn-prison:taskCompleted", "gym")
    gymState = {
        barbell = false,
        dumbbell = false,
        pullup = false
    }
    hasChangedClothes = false
    -- restoreOutfit()
    Notify(Lang:t('success.gym_finished'))

    TriggerServerEvent('frkn-prison:giveItem', 'prison_gym_complete', 1)

end

function checkGymCompletion()
    if gymState.barbell and gymState.dumbbell and gymState.pullup then
        gymCompleted()
    end
end

function toggleOutfit()
    if hasChangedClothes then
        restoreOutfit()
    else
        changeOutfit()
    end
end

function initTarget()
    if FRKN.General.targetSystem == "qb-target" then
        exports['qb-target']:AddBoxZone("prison_clothes_change", vector3(changeClothesCoords.x, changeClothesCoords.y, changeClothesCoords.z), 1.5, 1.5, {
            name = "prison_clothes_change",
            heading = changeClothesCoords.w,
            debugPoly = false,
            minZ = changeClothesCoords.z - 1,
            maxZ = changeClothesCoords.z + 1,
        }, {
            options = {
                {
                    icon = "fas fa-tshirt",
                    label = Lang:t('general.toggle_gym_outfit'),
                    distance = 2.0,
                    action = function()
                        toggleOutfit()
                        Notify(hasChangedClothes and Lang:t('success.changed_to_gym') or Lang:t('success.changed_to_normal'))
                    end,
                }
            },
            distance = 2.0
        })

        exports['qb-target']:AddBoxZone("gym_dumbbell", vector3(1734.0, 2488.4, 45.0), 1.5, 1.5, {
            name = "gym_dumbbell",
            heading = 210.0,
            debugPoly = false,
            minZ = 44.0,
            maxZ = 46.0
        }, {
            options = {
                {
                    icon = "fas fa-dumbbell",
                    label = Lang:t('general.dumbbell_exercise'),
                    canInteract = function()
                        return not isExercising and not gymState.dumbbell
                    end,
                    action = function()
                        if not hasChangedClothes then
                            Notify(Lang:t('general.change_clothes_first'))
                            return
                        end
                        StartDumbbellExercise()
                    end
                }
            },
            distance = 2.0
        })

        for i, spot in pairs(FRKN.Job.pullupSpots) do
            exports['qb-target']:AddBoxZone("gym_pullup_" .. i, spot.coords, 1.2, 1.2, {
                name = "gym_pullup_" .. i,
                heading = spot.heading,
                debugPoly = false,
                minZ = spot.coords.z - 1.0,
                maxZ = spot.coords.z + 1.0,
            }, {
                options = {
                    {
                        icon = "fas fa-dumbbell",
                        label = Lang:t('general.pullup_exercise'),
                        canInteract = function()
                            return not isDoingPullup and not gymState.pullup
                        end,
                        action = function()
                            if not hasChangedClothes then
                                Notify(Lang:t('general.change_clothes_first'))
                                return
                            end
                            StartPullupExercise(spot.coords, spot.heading)
                        end
                    }
                },
                distance = 2.0
            })
        end

        exports['qb-target']:AddBoxZone("gym_barbell", FRKN.Job.barbellPickupCoords, 1.5, 1.5, {
            name = "gym_barbell",
            heading = FRKN.Job.barbellHeading,
            debugPoly = false,
            minZ = FRKN.Job.barbellPickupCoords.z - 1,
            maxZ = FRKN.Job.barbellPickupCoords.z + 1,
        }, {
            options = {
                {
                    icon = "fas fa-dumbbell",
                    label = Lang:t('general.barbell_exercise'),
                    canInteract = function()
                        return not isExercising and not gymState.barbell
                    end,
                    action = function()
                        if not hasChangedClothes then
                            Notify(Lang:t('general.change_clothes_first'))
                            return
                        end
                        StartBarbellExercise(FRKN.Job.barbellPickupCoords, FRKN.Job.barbellHeading)
                    end
                }
            },
            distance = 2.0
        })


    elseif FRKN.General.targetSystem == "ox_target" then
        exports.ox_target:addBoxZone({
            coords = vec3(changeClothesCoords.x, changeClothesCoords.y, changeClothesCoords.z),
            size = vec3(1.5, 1.5, 2.0),
            rotation = changeClothesCoords.w,
            debug = false,
            options = {
                {
                    name = "prison_clothes_change",
                    icon = "fas fa-tshirt",
                    label = Lang:t('general.toggle_gym_outfit'),
                    distance = 2.0,
                    onSelect = function()
                        toggleOutfit()
                        Notify(hasChangedClothes and Lang:t('success.changed_to_gym') or Lang:t('success.changed_to_normal'))
                    end,
                }
            }
        })

        exports.ox_target:addBoxZone({
            coords = vec3(1734.0, 2488.4, 45.0),
            size = vec3(1.5, 1.5, 2.0),
            rotation = 210.0,
            debug = false,
            options = {
                {
                    name = "gym_dumbbell",
                    icon = "fas fa-dumbbell",
                    label = Lang:t('general.dumbbell_exercise'),
                    distance = 2.0,
                    canInteract = function()
                        return not isExercising and not gymState.dumbbell
                    end,
                    onSelect = function()
                        if not hasChangedClothes then
                            Notify(Lang:t('general.change_clothes_first'))
                            return
                        end
                        StartDumbbellExercise()
                    end
                }
            }
        })

        exports.ox_target:addBoxZone({
            coords = FRKN.Job.barbellPickupCoords,
            size = vec3(1.5, 1.5, 2.0),
            rotation = FRKN.Job.barbellHeading,
            debug = false,
            options = {
                {
                    name = "gym_barbell",
                    icon = "fas fa-dumbbell",
                    label = Lang:t('general.barbell_exercise'),
                    distance = 2.0,
                    canInteract = function()
                        return not isExercising and not gymState.barbell
                    end,
                    onSelect = function()
                        if not hasChangedClothes then
                            Notify(Lang:t('general.change_clothes_first'))
                            return
                        end
                        StartBarbellExercise(FRKN.Job.barbellPickupCoords, FRKN.Job.barbellHeading)
                    end
                }
            }
        })


        for i, spot in pairs(FRKN.Job.pullupSpots) do
            exports.ox_target:addBoxZone({
                coords = spot.coords,
                size = vec3(1.2, 1.2, 2.0),
                rotation = spot.heading,
                debug = false,
                options = {
                    {
                        name = "gym_pullup_" .. i,
                        icon = "fas fa-dumbbell",
                        label = Lang:t('general.pullup_exercise'),
                        distance = 2.0,
                        canInteract = function()
                            return not isDoingPullup and not gymState.pullup
                        end,
                        onSelect = function()
                            if not hasChangedClothes then
                                Notify(Lang:t('general.change_clothes_first'))
                                return
                            end
                            StartPullupExercise(spot.coords, spot.heading)
                        end
                    }
                }
            })
        end
    end
end



function changeOutfit()
    local ped = PlayerPedId()
    local genderHash = GetEntityModel(ped)
    local gender = (genderHash == `mp_m_freemode_01`) and "male" or "female"

    for i = 0, 11 do
        table.insert(previousOutfit, {
            component_id = i,
            drawable = GetPedDrawableVariation(ped, i),
            texture = GetPedTextureVariation(ped, i)
        })
    end

    local outfitList = FRKN.Job.SportOutfits[gender]
    if not outfitList or #outfitList == 0 then return end

    local outfit = outfitList[math.random(1, #outfitList)]
    for _, comp in pairs(outfit.components) do
        if IsPedComponentVariationValid(ped, comp.component_id, comp.drawable, comp.texture) then
            SetPedComponentVariation(ped, comp.component_id, comp.drawable, comp.texture, 2)
        end
    end

    hasChangedClothes = true
end

function restoreOutfit()
    local ped = PlayerPedId()
    for _, comp in pairs(previousOutfit) do
        if IsPedComponentVariationValid(ped, comp.component_id, comp.drawable, comp.texture) then
            SetPedComponentVariation(ped, comp.component_id, comp.drawable, comp.texture, 2)
        end
    end

    -- Notify(Lang:t('success.gym_finished'))

    hasChangedClothes = false
end



function StartBarbellExercise(pos, heading)

    if not isInPrison() then
        Notify(Lang:t('error.not_in_jail'), 'error')
        return
    end

    if isExercising then return end
    isExercising = true

    local ped = PlayerPedId()

    local animDict = "pickup_object"
    local animName = "pickup_low"

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Wait(10) end

    TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, 1500, 1, 0, false, false, false)
    Wait(1500)

    originalBarbell = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.5, GetHashKey(FRKN.Job.barbellModel), false, false, false)
    if originalBarbell and DoesEntityExist(originalBarbell) then
                      NetworkRequestControlOfEntity(originalBarbell)
                        Wait(100)
                        SetEntityAsMissionEntity(originalBarbell, true, true)
                        DeleteObject(originalBarbell)
    end

    RequestModel(FRKN.Job.barbellModel)
    while not HasModelLoaded(FRKN.Job.barbellModel) do Wait(0) end

    barbellObj = CreateObject(GetHashKey(FRKN.Job.barbellModel), 0.0, 0.0, 0.0, true, false, false)
    AttachEntityToEntity(barbellObj, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

    local workoutDict = "amb@world_human_muscle_free_weights@male@barbell@base"
    local workoutAnim = "base"

    RequestAnimDict(workoutDict)
    while not HasAnimDictLoaded(workoutDict) do Wait(10) end

    TaskPlayAnim(ped, workoutDict, workoutAnim, 8.0, -8.0, -1, 1, 0, false, false, false)

    SetTimeout(15000, function()
        ClearPedTasks(ped)

        if DoesEntityExist(barbellObj) then
            DeleteObject(barbellObj)
        end
        barbellObj = nil

        RequestModel(FRKN.Job.barbellModel)
        while not HasModelLoaded(FRKN.Job.barbellModel) do Wait(10) end

        local restored = CreateObject(GetHashKey(FRKN.Job.barbellModel), FRKN.Job.barbellPickupCoords.x, FRKN.Job.barbellPickupCoords.y, FRKN.Job.barbellPickupCoords.z + 0.1, true, false, false)
        SetEntityHeading(restored, FRKN.Job.barbellHeading)
        PlaceObjectOnGroundProperly(restored)
        FreezeEntityPosition(restored, true)
        SetModelAsNoLongerNeeded(FRKN.Job.barbellModel)

        isExercising = false
        gymState.barbell = true
        checkGymCompletion()
    end)
end




function StartDumbbellExercise()
    if not isInPrison() then
        Notify(Lang:t('error.not_in_jail'), 'error')
        return
    end

    if isExercising then return end
    isExercising = true

    local ped = PlayerPedId()
    local animDict = "amb@world_human_muscle_free_weights@male@barbell@idle_a"
    local animName = "idle_a"

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Wait(10) end

    RequestModel("prop_barbell_01")
    while not HasModelLoaded("prop_barbell_01") do Wait(10) end

    dumbbellLeft = CreateObject(`prop_barbell_01`, 0, 0, 0, true, false, false)
    dumbbellRight = CreateObject(`prop_barbell_01`, 0, 0, 0, true, false, false)

    AttachEntityToEntity(dumbbellLeft, ped, GetPedBoneIndex(ped, 60309), 0.08, 0.01, 0.0, 0.0, 90.0, 30.0, true, true, false, true, 1, true)
    AttachEntityToEntity(dumbbellRight, ped, GetPedBoneIndex(ped, 28422), -0.2, 0.01, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)


    local workoutDict = "amb@world_human_muscle_free_weights@male@barbell@base"
    local workoutAnim = "base"

    RequestAnimDict(workoutDict)
    while not HasAnimDictLoaded(workoutDict) do Wait(10) end

    TaskPlayAnim(ped, workoutDict, workoutAnim, 8.0, -8.0, -1, 1, 0, false, false, false)

    SetTimeout(15000, function()
        ClearPedTasks(ped)
        if DoesEntityExist(dumbbellLeft) then DeleteObject(dumbbellLeft) end
        if DoesEntityExist(dumbbellRight) then DeleteObject(dumbbellRight) end
        dumbbellLeft, dumbbellRight = nil, nil
        isExercising = false
        gymState.dumbbell = true
        checkGymCompletion()
    end)
end




function StartPullupExercise(coords, heading)

    if not isInPrison() then
        Notify(Lang:t('error.not_in_jail'), 'error')
        return
    end

    if isDoingPullup then return end
    isDoingPullup = true

    local ped = PlayerPedId()
    local animDict = "amb@prop_human_muscle_chin_ups@male@base"
    local animName = "base"

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Wait(10) end

    SetEntityCoords(ped, coords.x, coords.y, coords.z - 1.0, false, false, false, false)
    SetEntityHeading(ped, heading)

    TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, 1, 0.0, false, false, false)

    SetTimeout(15000, function()
        ClearPedTasks(ped)
        isDoingPullup = false
        gymState.pullup = true
        checkGymCompletion()
    end)
end
