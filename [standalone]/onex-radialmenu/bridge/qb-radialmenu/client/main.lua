if GetResourceState('es_extended'):find('start') then
    return
end

if GetResourceState('qbx_core'):find('start') and GetResourceState('qb-core'):find('start') then
    return
end

QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData() -- Setting this for when you restart the resource in game
local jobIndex = nil

-----------------------
------ Funtions -------
-----------------------

local function getNearestVeh()
    local pos = GetEntityCoords(PlayerPedId())
    local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10,
        PlayerPedId(), 0)
    local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
    return vehicleHandle
end

local function IsPoliceOrEMS()
    return (PlayerData.job.name == 'police' or PlayerData.job.type == 'leo' or PlayerData.job.name == 'ambulance')
end

local function IsDowned()
    return (PlayerData.metadata['isdead'] or PlayerData.metadata['inlaststand'])
end

local function SetupJobMenu()
    local pdata = QBCore.Functions.GetPlayerData()
    local JobInteractionCheck = pdata.job.name
    if pdata.job.type == 'leo' then
        JobInteractionCheck = 'police'
    end
    local JobMenu = {
        id = 'jobinteractions',
        title = 'Work',
        icon = 'briefcase',
        items = {}
    }

    if qb_Config.JobInteractions[JobInteractionCheck] and next(qb_Config.JobInteractions[JobInteractionCheck]) and pdata.job.onduty then
        JobMenu.items = qb_Config.JobInteractions[JobInteractionCheck]
    end

    if #JobMenu.items == 0 then
        RemoveOption('jobinteractions')
    else
        AddOption(JobMenu)
    end
end

local function SetupVehicleMenu(veh)
    local VehicleMenu = {
        id = 'vehicle',
        title = 'Vehicle',
        icon = 'car',
        items = {}
    }

    VehicleMenu.items[#VehicleMenu.items + 1] = qb_Config.VehicleDoors
    if qb_Config.EnableExtraMenu then
        VehicleMenu.items[#VehicleMenu.items + 1] = qb_Config.VehicleExtras
    end

    if not IsVehicleOnAllWheels(veh) then
        VehicleMenu.items[#VehicleMenu.items + 1] = {
            id = 'vehicle-flip',
            title = 'Flip Vehicle',
            icon = 'car-burst',
            type = 'client',
            event = 'qb-radialmenu:flipVehicle',
            shouldClose = true
        }
    end

    local seatIndex = #VehicleMenu.items + 1
    VehicleMenu.items[seatIndex] = deepcopy(qb_Config.VehicleSeats)

    local seatTable = {
        [1] = Lang:t('options.driver_seat'),
        [2] = Lang:t('options.passenger_seat'),
        [3] = Lang:t('options.rear_left_seat'),
        [4] = Lang:t('options.rear_right_seat')
    }

    local AmountOfSeats = GetVehicleModelNumberOfSeats(GetEntityModel(veh))
    for i = 1, AmountOfSeats do
        local newIndex = #VehicleMenu.items[seatIndex].items + 1
        VehicleMenu.items[seatIndex].items[newIndex] = {
            id = i - 2,
            title = seatTable[i] or Lang:t('options.other_seats'),
            icon = 'caret-up',
            type = 'client',
            event = 'qb-radialmenu:client:ChangeSeat',
            shouldClose = false
        }
    end

    AddOption(VehicleMenu)
end

function SetupQB_RadialMenu()

    Wait(0)

    clearRadialItems()
    local ped = PlayerPedId()
    local modified_menu_data = ConvertToOnexRadial(qb_Config.MenuItems)
    onexMenuData = modified_menu_data

    SetupJobMenu()
    if IsPedInAnyVehicle(ped) then
        SetupVehicleMenu(GetVehiclePedIsIn(ped))
    end
end

-----------------------
-------- Events -------
-----------------------

RegisterNetEvent('qb-radialmenu:client:noPlayers', function()
    QBCore.Functions.Notify(Lang:t('error.no_people_nearby'), 'error', 2500)
end)

RegisterNetEvent('qb-radialmenu:client:openDoor', function(data)
    local string = data.id
    local replace = string:gsub('door', '')
    local door = tonumber(replace)
    local ped = PlayerPedId()
    local closestVehicle = GetVehiclePedIsIn(ped) ~= 0 and GetVehiclePedIsIn(ped) or getNearestVeh()
    if closestVehicle ~= 0 then
        if closestVehicle ~= GetVehiclePedIsIn(ped) then
            local plate = QBCore.Functions.GetPlate(closestVehicle)
            if GetVehicleDoorAngleRatio(closestVehicle, door) > 0.0 then
                if not IsVehicleSeatFree(closestVehicle, -1) then
                    TriggerServerEvent('qb-radialmenu:trunk:server:Door', false, plate, door)
                else
                    SetVehicleDoorShut(closestVehicle, door, false)
                end
            else
                if not IsVehicleSeatFree(closestVehicle, -1) then
                    TriggerServerEvent('qb-radialmenu:trunk:server:Door', true, plate, door)
                else
                    SetVehicleDoorOpen(closestVehicle, door, false, false)
                end
            end
        else
            if GetVehicleDoorAngleRatio(closestVehicle, door) > 0.0 then
                SetVehicleDoorShut(closestVehicle, door, false)
            else
                SetVehicleDoorOpen(closestVehicle, door, false, false)
            end
        end
    else
        QBCore.Functions.Notify(Lang:t('error.no_vehicle_found'), 'error', 2500)
    end
end)

RegisterNetEvent('qb-radialmenu:client:setExtra', function(data)
    local string = data.id
    local replace = string:gsub('extra', '')
    local extra = tonumber(replace)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)
    if veh ~= nil then
        if GetPedInVehicleSeat(veh, -1) == ped then
            SetVehicleAutoRepairDisabled(veh, true) -- Forces Auto Repair off when Toggling Extra [GTA 5 Niche Issue]
            if DoesExtraExist(veh, extra) then
                if IsVehicleExtraTurnedOn(veh, extra) then
                    SetVehicleExtra(veh, extra, 1)
                    QBCore.Functions.Notify(Lang:t('error.extra_deactivated', {
                        extra = extra
                    }), 'error', 2500)
                else
                    SetVehicleExtra(veh, extra, 0)
                    QBCore.Functions.Notify(Lang:t('success.extra_activated', {
                        extra = extra
                    }), 'success', 2500)
                end
            else
                QBCore.Functions.Notify(Lang:t('error.extra_not_present', {
                    extra = extra
                }), 'error', 2500)
            end
        else
            QBCore.Functions.Notify(Lang:t('error.not_driver'), 'error', 2500)
        end
    end
end)

RegisterNetEvent('qb-radialmenu:trunk:client:Door', function(plate, door, open)
    local veh = GetVehiclePedIsIn(PlayerPedId())
    if veh ~= 0 then
        local pl = QBCore.Functions.GetPlate(veh)
        if pl == plate then
            if open then
                SetVehicleDoorOpen(veh, door, false, false)
            else
                SetVehicleDoorShut(veh, door, false)
            end
        end
    end
end)

-- RegisterNetEvent('qb-radialmenu:client:ChangeSeat', function(data)
--     local Veh = GetVehiclePedIsIn(PlayerPedId())
--     local IsSeatFree = IsVehicleSeatFree(Veh, data.id)
--     local speed = GetEntitySpeed(Veh)
--     local HasHarnass = exports['envi-hud']:GetHarnessLevel()
--     print('HasHarnass: ', HasHarnass)
--     if not HasHarnass then
--         local kmh = speed * 3.6
--         if IsSeatFree then
--             if kmh <= 100.0 then
--                 SetPedIntoVehicle(PlayerPedId(), Veh, data.id)
--                 QBCore.Functions.Notify(Lang:t('info.switched_seats', {
--                     seat = data.title
--                 }))
--             else
--                 QBCore.Functions.Notify(Lang:t('error.vehicle_driving_fast'), 'error')
--             end
--         else
--             QBCore.Functions.Notify(Lang:t('error.seat_occupied'), 'error')
--         end
--     else
--         QBCore.Functions.Notify(Lang:t('error.race_harness_on'), 'error')
--     end
-- end)

RegisterNetEvent('qb-radialmenu:client:ChangeSeat', function(data)
    local Veh = GetVehiclePedIsIn(PlayerPedId())
    local IsSeatFree = IsVehicleSeatFree(Veh, data.id)
    local speed = GetEntitySpeed(Veh)
    local harnessLevel = exports['envi-hud']:GetHarnessLevel()
    print('Harness Level: ', harnessLevel)

    local isWearingSeatbelt = exports['envi-hud']:GetSeatbeltStatus()
    print('Is player wearing a seatbelt:', isWearingSeatbelt)

    if not isWearingSeatbelt or harnessLevel == 0 then
        local kmh = speed * 3.6
        if IsSeatFree then
            if kmh <= 100.0 then
                SetPedIntoVehicle(PlayerPedId(), Veh, data.id)
                QBCore.Functions.Notify(Lang:t('info.switched_seats', {
                    seat = data.title
                }))
            else
                QBCore.Functions.Notify(Lang:t('error.vehicle_driving_fast'), 'error')
            end
        else
            QBCore.Functions.Notify(Lang:t('error.seat_occupied'), 'error')
        end
    else
        QBCore.Functions.Notify(Lang:t('error.race_harness_on'), 'error')
    end
end)

RegisterNetEvent('qb-radialmenu:flipVehicle', function()
    QBCore.Functions.Progressbar('pick_grape', Lang:t('progress.flipping_car'), qb_Config.Fliptime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true
    }, {
        animDict = 'mini@repair',
        anim = 'fixing_a_ped',
        flags = 1
    }, {}, {}, function() -- Done
        local vehicle = getNearestVeh()
        SetVehicleOnGroundProperly(vehicle)
        StopAnimTask(PlayerPedId(), 'mini@repair', 'fixing_a_ped', 1.0)
    end, function() -- Cancel
        QBCore.Functions.Notify(Lang:t('task.cancel_task'), 'error')
        StopAnimTask(PlayerPedId(), 'mini@repair', 'fixing_a_ped', 1.0)
    end)
end)

RegisterNetEvent('QBCore:Client:VehicleInfo', function(data)
    if LocalPlayer.state.isLoggedIn and data.event == 'Entered' then
        SetupVehicleMenu(data.vehicle)
    else
        RemoveOption('vehicle')
    end
end)

-- Sets the metadata when the player spawns
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(100)
    SetupQB_RadialMenu()
end)

-- Sets the playerdata to an empty table when the player has quit or did /logout
RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

-- This will update all the PlayerData that doesn't get updated with a specific event other than this like the metadata
RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    Wait(100)
    PlayerData = val
    -- SetupQB_RadialMenu()
    onexRemoveRadialItem('jobinteractions')
    Wait(0)
    SetupJobMenu()
end)

--! No need i guess!!
-- RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
--     -- Wait(2000)
--     -- SetupQB_RadialMenu()
-- end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        if LocalPlayer.state['isLoggedIn'] then
            SetupQB_RadialMenu()
        end
    end
end)
