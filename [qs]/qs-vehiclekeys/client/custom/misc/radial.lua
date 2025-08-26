--[[
██████╗░░█████╗░██████╗░██╗░█████╗░██╗░░░░░  ███╗░░░███╗███████╗███╗░░██╗██╗░░░██╗
██╔══██╗██╔══██╗██╔══██╗██║██╔══██╗██║░░░░░  ████╗░████║██╔════╝████╗░██║██║░░░██║
██████╔╝███████║██║░░██║██║███████║██║░░░░░  ██╔████╔██║█████╗░░██╔██╗██║██║░░░██║
██╔══██╗██╔══██║██║░░██║██║██╔══██║██║░░░░░  ██║╚██╔╝██║██╔══╝░░██║╚████║██║░░░██║
██║░░██║██║░░██║██████╔╝██║██║░░██║███████╗  ██║░╚═╝░██║███████╗██║░╚███║╚██████╔╝
╚═╝░░╚═╝╚═╝░░╚═╝╚═════╝░╚═╝╚═╝░░╚═╝╚══════╝  ╚═╝░░░░░╚═╝╚══════╝╚═╝░░╚══╝░╚═════╝░
]]--

-- Check if Radial is enabled in the configuration
if not Config.Radial then return end

function GetClosestVehicle()
	local playerCoords = GetEntityCoords(PlayerPedId())
	local vehicles = GetGamePool("CVehicle")

	local closestVehicle, closestDistance

	for _, vehicle in ipairs(vehicles) do
		local distance = #(playerCoords - GetEntityCoords(vehicle))^2

		if not closestDistance or distance < closestDistance then
			closestVehicle = vehicle
			closestDistance = math.sqrt(distance)
		end
	end

	return closestVehicle, closestDistance
end

CreateThread(function()
    local radialItemAdded = false
    lib.removeRadialItem('carkeys')

    while true do
        Wait(1000)
        local maxDistance = 4.0
        local vehicle, distance = GetClosestVehicle()

        if vehicle and distance < maxDistance then
            local plate = GetVehicleNumberPlateText(vehicle)
            local hasKey = exports['qs-vehiclekeys']:GetKey(plate)

            if hasKey and not radialItemAdded then
                lib.addRadialItem({
                    {
                        id = 'carkeys',
                        label = Lang('VEHICLEKEYS_RADIAL_VEHICLEKEYS_LABEL'),
                        icon = "key",
                        onSelect = function()
                            exports["qs-vehiclekeys"]:DoorLogic(vehicle)
                        end
                    }
                })
                radialItemAdded = true
            elseif not hasKey and radialItemAdded then
                lib.removeRadialItem('carkeys')
                radialItemAdded = false
            end
        else
            if radialItemAdded then
                lib.removeRadialItem('carkeys')
                radialItemAdded = false
            end
        end
    end
end)


--[[
█▀▀ ▄▀█ █▀█   █▀▄ █▀█ █▀█ █▀█ █▀
█▄▄ █▀█ █▀▄   █▄▀ █▄█ █▄█ █▀▄ ▄█
]]--

lib.registerRadial({
    id = 'car_doors',
    items = {
        {
            label = Lang('VEHICLEKEYS_RADIAL_REARRIGHT_LABEL'),
            icon = 'car-side',
            onSelect = function()
                doorToggle(3)
            end
        },
        {
            label = Lang('VEHICLEKEYS_RADIAL_TRUNK_LABEL'),
            icon = 'car-rear',
            onSelect = function()
                doorToggle(5)
            end
        },
        {
            label = Lang('VEHICLEKEYS_RADIAL_PASSENGER_LABEL'),
            icon = 'car-side',
            onSelect = function()
                doorToggle(1)
            end
        },
        {
            label = Lang('VEHICLEKEYS_RADIAL_DRIVER_LABEL'),
            icon = 'car-side',
            onSelect = function()
                doorToggle(0)
            end
        },
        {
            label = Lang('VEHICLEKEYS_RADIAL_HOOD_LABEL'),
            icon = 'car',
            onSelect = function()
                doorToggle(4)
            end
        },
        {
            label = Lang('VEHICLEKEYS_RADIAL_REARLEFT_LABEL'),
            icon = 'car-side',
            onSelect = function()
                doorToggle(2)
            end
        },
    }
})

--[[
█▀▀ ▄▀█ █▀█   █░█░█ █ █▄░█ █▀▄ █▀█ █░█░█ █▀
█▄▄ █▀█ █▀▄   ▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀ ▄█
]]--

lib.registerRadial({
    id = 'car_windows',
    items = {
        {
            label = Lang('VEHICLEKEYS_RADIAL_REARRIGHT_LABEL'),
            icon = 'caret-right',
            onSelect = function()
                windowToggle(2, 3)
            end
        },
        {
            label = Lang('VEHICLEKEYS_RADIAL_PASSENGER_LABEL'),
            icon = 'caret-up',
            onSelect = function()
                windowToggle(1, 1)
            end
        },
        {
            label = Lang('VEHICLEKEYS_RADIAL_DRIVER_LABEL'),
            icon = 'caret-up',
            onSelect = function()
                windowToggle(0, 0)
            end
        },
        {
            label = Lang('VEHICLEKEYS_RADIAL_REARLEFT_LABEL'),
            icon = 'caret-left',
            onSelect = function()
                windowToggle(3, 2)
            end
        },
    }
})

--[[
█▀▀ ▄▀█ █▀█   █▀ █▀▀ ▄▀█ ▀█▀ █▀
█▄▄ █▀█ █▀▄   ▄█ ██▄ █▀█ ░█░ ▄█
]]--

lib.registerRadial({
    id = 'car_seats',
    items = {
        {
            label = Lang('VEHICLEKEYS_RADIAL_REARRIGHT_LABEL'),
            icon = 'caret-right',
            onSelect = function()
                changeSeat(2)
            end
        },
        {
            label = Lang('VEHICLEKEYS_RADIAL_PASSENGER_LABEL'),
            icon = 'caret-up',
            onSelect = function()
                changeSeat(0)
            end
        },
        {
            label = Lang('VEHICLEKEYS_RADIAL_DRIVER_LABEL'),
            icon = 'caret-up',
            onSelect = function()
                changeSeat(-1)
            end
        },
        {
            label = Lang('VEHICLEKEYS_RADIAL_REARLEFT_LABEL'),
            icon = 'caret-left',
            onSelect = function()
                changeSeat(1)
            end
        },
    }
})

--[[
█░█ █▀▀ █░█ █ █▀▀ █░░ █▀▀   █▀▄▀█ █▀▀ █▄░█ █░█
▀▄▀ ██▄ █▀█ █ █▄▄ █▄▄ ██▄   █░▀░█ ██▄ █░▀█ █▄█
]]--

lib.registerRadial({
    id = 'vehicle_menu',
    items = {
        {
            label = Lang('VEHICLEKEYS_RADIAL_VEHICLEENGINE_LABEL'),
            icon = 'power-off',
            onSelect = function()
                toggleEngine()
            end
        },
        {
            label = Lang('VEHICLEKEYS_RADIAL_VEHICLEDOORS_LABEL'),
            icon = 'door-closed',
            menu = 'car_doors'
        },
        {
            label = Lang('VEHICLEKEYS_RADIAL_VEHICLEWINDOWS_LABEL'),
            icon = 'window-maximize',
            menu = 'car_windows'
        },
        {
            label = Lang('VEHICLEKEYS_RADIAL_VEHICLECHAIRS_LABEL'),
            icon = 'chair',
            menu = 'car_seats'
        },
        }
})

--[[
█░█ █▀▀ █░█ █ █▀▀ █░░ █▀▀   █▀▀ █░█ █▀▀ █▀▀ █▄▀
▀▄▀ ██▄ █▀█ █ █▄▄ █▄▄ ██▄   █▄▄ █▀█ ██▄ █▄▄ █░█
]]--

lib.onCache('vehicle', function(value)
    if value then
        lib.addRadialItem({
            {
                id = 'vehicle',
                label = Lang('VEHICLEKEYS_RADIAL_VEHICLE_LABEL'),
                icon = 'car',
                menu = 'vehicle_menu'
            }
        })
      lib.removeRadialItem('carkeys')
    else
        lib.removeRadialItem('vehicle')
    end
end)

--[[
█▀▀ █░█ █▄░█ █▀▀ ▀█▀ █ █▀█ █▄░█   █▀▄ █▀█ █▀█ █▀█ ▀█▀ █▀█ █▀▀ █▀▀ █░░ █▀▀
█▀░ █▄█ █░▀█ █▄▄ ░█░ █ █▄█ █░▀█   █▄▀ █▄█ █▄█ █▀▄ ░█░ █▄█ █▄█ █▄█ █▄▄ ██▄
]]--

function doorToggle(door)
    if GetVehicleDoorAngleRatio(cache.vehicle, door) > 0.0 then
        SetVehicleDoorShut(cache.vehicle, door, false, false)
    else
        SetVehicleDoorOpen(cache.vehicle, door, false, false)
    end
end

--[[
█▀▀ █░█ █▄░█ █▀▀ ▀█▀ █ █▀█ █▄░█   █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █▀▀ █▀ █▀▀ ▄▀█ ▀█▀
█▀░ █▄█ █░▀█ █▄▄ ░█░ █ █▄█ █░▀█   █▄▄ █▀█ █▀█ █░▀█ █▄█ ██▄ ▄█ ██▄ █▀█ ░█░
]]--

function changeSeat(seat)
    if IsVehicleSeatFree(cache.vehicle, seat) then
        lib.progressCircle({
            duration = 1000,
            position = 'bottom',
            label = Lang("VEHICLEKEYS_RADIAL_CHANGE_SEAT_PROGRESS"),
            useWhileDead = false,
            canCancel = true,
            disable = { car = true },
            anim = {
                dict = 'anim@veh@low@vigilante@front_ps@enter_exit',
                clip = 'shuffle_seat',
                flag = 16
            },
        })
        SetPedIntoVehicle(cache.ped, cache.vehicle, seat)
    end
end

--[[
█▀▀ █░█ █▄░█ █▀▀ ▀█▀ █ █▀█ █▄░█   █░█░█ █ █▄░█ █▀▄ █▀█ █░█░█ ▀█▀ █▀█ █▀▀ █▀▀ █░░ █▀▀
█▀░ █▄█ █░▀█ █▄▄ ░█░ █ █▄█ █░▀█   ▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀ ░█░ █▄█ █▄█ █▄█ █▄▄ ██▄
]]--

local windows = { true, true, true, true }

function windowToggle(window, door)
    if GetIsDoorValid(cache.vehicle, door) and windows[window + 1] then
        RollDownWindow(cache.vehicle, window)
        windows[window + 1] = false
    else
        RollUpWindow(cache.vehicle, window)
        windows[window + 1] = true
    end
end
