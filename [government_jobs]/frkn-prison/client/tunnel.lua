

local dirtProp = nil
zoneControl = true

function spawnDirtProp()
    RequestModel("prop_pile_dirt_01")
    while not HasModelLoaded("prop_pile_dirt_01") do Wait(0) end

    dirtProp = CreateObject(`prop_pile_dirt_01`, FRKN.General.digSpot.coords.x, FRKN.General.digSpot.coords.y, FRKN.General.digSpot.coords.z - 1.0, false, false, false)
    SetEntityHeading(dirtProp, FRKN.General.digSpot.heading)
    FreezeEntityPosition(dirtProp, true)
end


function InitDigSpotTarget()
    spawnDirtProp()
    if not FRKN.General.digSpot or FRKN.General.digSpot.cleaned then return end

    local coords = FRKN.General.digSpot.coords
    local action = function()
        local playerPed = PlayerPedId()

        if not electricControl() then
            Notify(Lang:t("error.not_night"), "error")
            return
        end

        TriggerCallback("frkn-prison:ItemControl", function(hasShovel)
            if not hasShovel then
                Notify(Lang:t("error.no_shovel"))
                return
            end

            TaskStartScenarioInPlace(playerPed, "world_human_gardener_plant", 0, true)
            SendNUIMessage({ action = "tunnelGame" })
            SetNuiFocus(true, true)
        end, "prison_shovel")
    end

    if FRKN.General.targetSystem == "qb-target" then
        exports['qb-target']:AddBoxZone("prison_dig_spot", vector3(coords.x, coords.y, coords.z), 1.5, 1.5, {
            name = "prison_dig_spot",
            heading = coords.w or 0.0,
            debugPoly = false,
            minZ = coords.z - 1,
            maxZ = coords.z + 1,
        }, {
            options = {
                {
                    icon = "fas fa-shovel",
                    label = Lang:t("general.target_dig_spot"),
                    action = action
                }
            },
            distance = 2.0
        })

    elseif FRKN.General.targetSystem == "ox_target" then
        exports.ox_target:addBoxZone({
            coords = vec3(coords.x, coords.y, coords.z),
            size = vec3(1.5, 1.5, 2.0),
            rotation = coords.w or 0.0,
            debug = false,
            options = {
                {
                    name = "prison_dig_spot",
                    icon = "fas fa-shovel",
                    label = Lang:t("general.target_dig_spot"),
                    distance = 2.0,
                    onSelect = action
                }
            }
        })
    end

    CreateThread(function()
        local spot = vector3(coords.x, coords.y, coords.z)
        while true do
            local player = PlayerPedId()
            local dist = #(GetEntityCoords(player) - spot)
            if dist <= 25.0 then
                DrawMarker(2, coords.x, coords.y, coords.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 200, 50, 180, false, true, 2, false, nil, nil, false)
            end
            Wait(0)
        end
    end)

end


RegisterNUICallback('digGameSuccess', function(data, cb)
    local ped = PlayerPedId()
    FRKN.General.digSpot.progress += 1

    ClearPedTasks(ped)
    ClearPedTasksImmediately(ped)
    SetNuiFocus(false, false)

    if DoesEntityExist(dirtProp) then
        local curCoords = GetEntityCoords(dirtProp)
        SetEntityCoords(dirtProp, curCoords.x, curCoords.y, curCoords.z - 0.15, false, false, false, false)
    end

    if FRKN.General.digSpot.progress >= 4 then
        FRKN.General.digSpot.cleaned = true
        DeleteEntity(dirtProp)
        ClearPedTasksImmediately(ped)
        zoneControl = false
        SetEntityCoords(ped, FRKN.General.TunelEntrance.coords.x, FRKN.General.TunelEntrance.coords.y, FRKN.General.TunelEntrance.coords.z, false, false, false, true)
        Notify(Lang:t("success.clean_sand"))
    else
        Notify(Lang:t("general.clean_some"))
    end

    cb({})
end)

local pickaxe = nil

local wallModel = -1529768751
local wallCoords = vector3(1942.06921, 2687.84644, 32.8981743)
local wallHeading = 30.0
local pickaxeModel = `prop_tool_pickaxe`

function StartBreakingWall()
    local ped = PlayerPedId()

    if DoesEntityExist(pickaxe) then
        DeleteEntity(pickaxe)
        pickaxe = nil
    end

    local bone = GetPedBoneIndex(ped, 57005)
    pickaxe = CreateObject(pickaxeModel, GetEntityCoords(ped), true, true, false)
	DisableCamCollisionForObject(pickaxe)
	DisableCamCollisionForEntity(pickaxe)
	AttachEntityToEntity(pickaxe, ped, GetPedBoneIndex(ped, 57005), 0.09, -0.53, -0.22, 252.0, 180.0, 0.0, false, true, true, true, 0, true)

    ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.5)
	local dict, anim = "amb@world_human_hammering@male@base", "base"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) end
    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)

    Wait(5000)
    ShakeGameplayCam("LARGE_EXPLOSION_SHAKE", 1.0)
    Wait(1500)

    ClearPedTasksImmediately(ped)
    DeleteEntity(pickaxe)
    StopGameplayCamShaking(true)

    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do Wait(0) end

    SetEntityCoords(ped, FRKN.General.TunelOut.coords.x, FRKN.General.TunelOut.coords.y, FRKN.General.TunelOut.coords.z, false, false, false, true)
    SetEntityHeading(ped, FRKN.General.TunelOut.heading)

    TriggerServerEvent('frkn-prison:releasePlayer')

    Wait(500) 
    DoScreenFadeIn(1000)

    Notify(Lang:t("success.break_wall"))
end

function SetupWallBreakTarget()
    local option = {
        icon = "fas fa-hammer",
        label = Lang:t("general.target_break_wall"),
        action = StartBreakingWall
    }

    if FRKN.General.targetSystem == "qb-target" then
        exports['qb-target']:AddBoxZone("prison_break_wall", wallCoords, 2.0, 2.0, {
            name = "prison_break_wall",
            heading = wallHeading,
            debugPoly = false,
            minZ = wallCoords.z - 1,
            maxZ = wallCoords.z + 1,
        }, {
            options = { option },
            distance = 2.5
        })

    elseif FRKN.General.targetSystem == "ox_target" then
        exports.ox_target:addBoxZone({
            coords = wallCoords,
            size = vec3(2.0, 2.0, 2.0),
            rotation = wallHeading,
            debug = false,
            options = {
                {
                    name = "prison_break_wall",
                    icon = option.icon,
                    label = option.label,
                    distance = 2.5,
                    onSelect = option.action
                }
            }
        })
    end
end

CreateThread(function()
    SetupWallBreakTarget()
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if DoesEntityExist(dirtProp) then
            DeleteEntity(dirtProp)
        end
    end
end)


