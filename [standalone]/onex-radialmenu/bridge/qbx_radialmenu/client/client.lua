if GetResourceState('es_extended'):find('start') then
    return
end

if not GetResourceState('qbx_core'):find('start') then
    return
end

local qbx_config = require 'bridge.qbx_radialmenu.config'

lib.locale()

-----------------------
------ Funtions -------
-----------------------

local function setupVehicleMenu()
    local vehicleMenu = {
        id = 'vehicle',
        label = 'vehicle',
        icon = 'car',
        menu = 'vehicleMenu',
        items = {}
    }
    local vehicleItems = {{
        id = 'vehicle-flip',
        label = locale('options.flip'),
        icon = 'car-burst',
        onSelect = function()
            TriggerEvent('radialmenu:flipVehicle')
        end
    }}
    vehicleItems[#vehicleItems + 1] = qbx_config.vehicleDoors
    if qbx_config.enableExtraMenu then
        vehicleItems[#vehicleItems + 1] = qbx_config.vehicleExtras
    end

    vehicleMenu.items = vehicleItems
    return vehicleMenu
end

lib.onCache('vehicle', function(vehicle)
    if vehicle then
        local vehMenu = setupVehicleMenu()
        addRadialItem(vehMenu)

        if qbx_config.vehicleSeats then
            if vehicle then
                local vehicleSeats = deepcopy(qbx_config.vehicleSeats)
                vehicleSeats.items = {}
                local veh = vehicle
                local amountOfSeats = GetVehicleModelNumberOfSeats(GetEntityModel(veh))

                local seatTable = {
                    [1] = locale('options.driver_seat'),
                    [2] = locale('options.passenger_seat'),
                    [3] = locale('options.rear_left_seat'),
                    [4] = locale('options.rear_right_seat')
                }

                for i = 1, amountOfSeats do
                    vehicleSeats.items[#vehicleSeats.items + 1] = {
                        id = 'vehicleSeat' .. i,
                        label = seatTable[i] or locale('options.other_seats'),
                        icon = 'caret-up',
                        onSelect = function()
                            if cache.vehicle then
                                TriggerEvent('radialmenu:client:ChangeSeat', i,
                                    seatTable[i] or locale('options.other_seats'))
                            else
                                exports.qbx_core:Notify(locale('error.not_in_vehicle'), 'error')
                            end
                        end
                    }
                end
                addRadialItem(vehicleSeats, 'vehicle')
            end
        end

    else
        removeRadialItem('vehicle')
    end
end)

local function isPolice()
    return QBX.PlayerData.job.type == 'leo' and QBX.PlayerData.job.onduty
end

local function isEMS()
    return QBX.PlayerData.job.type == 'ems' and QBX.PlayerData.job.onduty
end

local SetupQBXJobMenu = function()
    if qbx_config.jobItems[QBX.PlayerData.job.name] and QBX.PlayerData.job.onduty then
        addRadialItem({
            id = 'jobInteractions',
            label = locale('general.job_radial'),
            icon = 'briefcase',
            items = qbx_config.jobItems[QBX.PlayerData.job.name]
        })

    end
end

local SetupQBXGangMenu = function()
    if qbx_config.gangItems[QBX.PlayerData.gang.name] then
        addRadialItem({
            id = 'gangInteractions',
            label = locale('general.gang_radial'),
            icon = 'skull-crossbones',
            items = qbx_config.gangItems[QBX.PlayerData.gang.name]
        })
    end
end

function SetupQBXRadialMenu()
    clearRadialItems()
    local modified_menu_data = ConvertToOnexRadial(qbx_config.menuItems)
    onexMenuData = modified_menu_data

    SetupQBXJobMenu()
    SetupQBXGangMenu()
end

-----------------------
-------- Events -------
-----------------------

-- [##] == Vehicle Seats Stuff

RegisterNetEvent('radialmenu:client:ChangeSeat', function(id, label)
    local isSeatFree = IsVehicleSeatFree(cache.vehicle, id - 2)
    local speed = GetEntitySpeed(cache.vehicle)
    local hasHarness = GetResourceState('qbx_seatbelt'):find('start') and exports.qbx_seatbelt:HasHarness()
    if hasHarness then
        return exports.qbx_core:Notify(locale('error.race_harness_on'), 'error')
    end

    if not isSeatFree then
        return exports.qbx_core:Notify(locale('error.seat_occupied'), 'error')
    end

    local kmh = speed * 3.6

    if kmh > 100.0 then
        return exports.qbx_core:Notify(locale('error.vehicle_driving_fast'), 'error')
    end

    SetPedIntoVehicle(cache.ped, cache.vehicle, id - 2)
    exports.qbx_core:Notify(locale('info.switched_seats', label))
end)

RegisterNetEvent('qb-radialmenu:trunk:client:Door', function(plate, door, open)
    if not cache.vehicle then
        return
    end

    local pl = GetVehicleNumberPlateText(cache.vehicle)
    if pl ~= plate then
        return
    end

    if open then
        SetVehicleDoorOpen(cache.vehicle, door, false, false)
    else
        SetVehicleDoorShut(cache.vehicle, door, false)
    end
end)

RegisterNetEvent('qb-radialmenu:client:noPlayers', function()
    exports.qbx_core:Notify(locale('error.no_people_nearby'), 'error', 2500)
end)

RegisterNetEvent('qb-radialmenu:client:openDoor', function(id)
    local door = id
    local coords = GetEntityCoords(cache.ped)
    local closestVehicle = cache.vehicle or lib.getClosestVehicle(coords, 5.0, false)
    if closestVehicle ~= 0 then
        if closestVehicle ~= cache.vehicle then
            local plate = GetVehicleNumberPlateText(closestVehicle)
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
        exports.qbx_core:Notify(locale('error.no_vehicle_found'), 'error', 2500)
    end
end)

RegisterNetEvent('radialmenu:client:setExtra', function(id)
    local extra = id
    if cache.vehicle ~= nil then
        if cache.seat == -1 then
            SetVehicleAutoRepairDisabled(cache.vehicle, true) -- Forces Auto Repair off when Toggling Extra [GTA 5 Niche Issue]
            if DoesExtraExist(cache.vehicle, extra) then
                if IsVehicleExtraTurnedOn(cache.vehicle, extra) then
                    SetVehicleExtra(cache.vehicle, extra, false)
                    exports.qbx_core:Notify(locale('error.extra_deactivated', extra), 'error', 2500)
                else
                    SetVehicleExtra(cache.vehicle, extra, true)
                    exports.qbx_core:Notify(locale('success.extra_activated', extra), 'success', 2500)
                end
            else
                exports.qbx_core:Notify(locale('error.extra_not_present', extra), 'error', 2500)
            end
        else
            exports.qbx_core:Notify(locale('error.not_driver'), 'error', 2500)
        end
    end
end)

RegisterNetEvent('radialmenu:flipVehicle', function()
    if cache.vehicle then
        return
    end
    local coords = GetEntityCoords(cache.ped)
    local vehicle = lib.getClosestVehicle(coords)
    if not vehicle then
        return exports.qbx_core:Notify(locale('error.no_vehicle_nearby'), 'error')
    end
    if lib.progressBar({
        label = locale('progress.flipping_car'),
        duration = qbx_config.flipTime,
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            mouse = false,
            combat = true
        },
        anim = {
            dict = 'mini@repair',
            clip = 'fixing_a_ped'
        }
    }) then
        SetVehicleOnGroundProperly(vehicle)
        exports.qbx_core:Notify(locale('success.flipped_car'), 'success')
    else
        exports.qbx_core:Notify(locale('error.cancel_task'), 'error')
    end
end)

RegisterNetEvent('radialmenu:client:deadradial', function(isDead)
    if isDead then
        local ispolice, isems = isPolice(), isEMS()
        if not ispolice or isems then
            return disableRadial(true)
        end
        clearRadialItems()
        addRadialItem({
            id = 'emergencybutton2',
            label = locale('options.emergency_button'),
            icon = 'circle-exclamation',
            onSelect = function()
                if ispolice then
                    TriggerEvent('police:client:SendPoliceEmergencyAlert')
                elseif isems then
                    TriggerServerEvent('hospital:server:emergencyAlert')
                end
            end
        })
    else
        clearRadialItems()
        SetupQBXRadialMenu()
        disableRadial(false)
    end
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(onDuty)
    if onDuty and qbx_config.jobItems[QBX.PlayerData.job.name] then
        onexRemoveRadialItem('jobinteractions')
        addRadialItem({
            id = 'jobInteractions',
            label = locale('general.job_radial'),
            icon = 'briefcase',
            items = qbx_config.jobItems[QBX.PlayerData.job.name]
        })
    end
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(gang)
    onexRemoveRadialItem('gangInteractions')
    SetupQBXGangMenu()
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    SetupQBXRadialMenu()
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function()
    -- SetupQBXRadialMenu()
    onexRemoveRadialItem('jobinteractions')
    onexRemoveRadialItem('gangInteractions')
    Wait(0)
    SetupQBXJobMenu()
    SetupQBXGangMenu()
end)

-- ! No Longer Needed
-- RegisterNetEvent('QBCore:Client:OnJobUpdate', function()
--     SetupQBXRadialMenu()
-- end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        if LocalPlayer.state['isLoggedIn'] then
            SetupQBXRadialMenu()
        end
    end
end)
