CreateThread(function()
    if Config.Garages ~= 'vms_garagesv2' then
        return
    end

    debugPrint("Using vms_garagesv2")
    local database = {
        ['table:owned_vehicles'] = 'owned_vehicles', -- for qb-core: player_vehicles
        ['column:owner'] = 'owner', -- for qb-core: citizenid
        ['column:vehicle'] = 'vehicle', -- for qb-core: mods
        ['column:plate'] = 'plate'

    }
    
    function GetPlayerVehicles(source)
        local vehicles = MySQL.query.await(('SELECT * FROM `%s` WHERE `%s` = ? AND `company` IS NULL'):format(database['table:owned_vehicles'], database['column:owner']), {
            Framework.GetPlayerFromId(source)?.identifier
        })
        
        local vehiclesList = {}
        if not vehicles then
            return nil
        end

        for _, v in pairs(vehicles) do
            local garageLabel, garageCoords = "Out of Garage", nil
            if v.garage then
                garageLabel, garageCoords = exports['vms_garagesv2']:getGarageInfo(v.garage)
                if garageLabel == 'house' then
                    garageLabel = "House" -- You can adjust your language here.
                end
            end

            local currentVehicle = {
                plate = v.plate,
                type = v.type,
                location = garageLabel,
                statistics = {}
            }

            local vehicle = v[database['column:vehicle']] and json.decode(v[database['column:vehicle']]) or nil
            if vehicle then
                if vehicle.fuelLevel then
                    currentVehicle.statistics.fuel = math.floor(vehicle.fuelLevel + 0.5)
                end
                if vehicle.engineHealth then
                    currentVehicle.statistics.engine = math.floor(vehicle.engineHealth / 10 + 0.5)
                end

                if vehicle.bodyHealth then
                    currentVehicle.statistics.body = math.floor(vehicle.bodyHealth / 10 + 0.5)
                end

                currentVehicle.model = vehicle.model or "Unknown Model"
            else
                currentVehicle.model = "Unknown Model"
            end

            vehiclesList[#vehiclesList + 1] = currentVehicle
        end

        return vehiclesList
    end

    function GetVehicle(plate)
        local src = source
        local identifier = Framework.GetPlayerFromId(src).identifier

        local vehicleData = MySQL.query.await(([[
            SELECT garage, garageSpotID, plate, `%s` FROM `%s` WHERE `%s` = ? AND plate = ? AND garage IS NOT NULL AND impound_data IS NULL
        ]]):format(database['column:vehicle'], database['table:owned_vehicles'], database['column:owner']),
            {identifier, plate})
        if not vehicleData or #vehicleData == 0 then
            return nil
        end

        MySQL.query.await(
            ('UPDATE `%s` SET garage = NULL, garageSpotID = NULL, parking_date = NULL WHERE plate = ?'):format(
                database['table:owned_vehicles']), {plate})

        TriggerEvent('vms_garagesv2:vehicleTakenByPhone', vehicleData[1].garage, vehicleData[1].garageSpotID)
        Citizen.CreateThread(function()
            Citizen.Wait(3000)
            local allVehicles = GetAllVehicles()
            for i = 1, #allVehicles do
                if DoesEntityExist(allVehicles[i]) then
                    local vehPlate = GetVehicleNumberPlateText(allVehicles[i])
                    local cleanedPlate = vehPlate:match("^%s*(.-)%s*$")
                    if cleanedPlate == plate then
                        MySQL.query.await(('UPDATE `%s` SET netid = ? WHERE plate = ?'):format(
                            database['table:owned_vehicles']), {NetworkGetNetworkIdFromEntity(allVehicles[i]), plate})
                        break
                    end
                end
            end
        end)

        return vehicleData[1]
    end

    local function IsVehicleOut(plate, vehicles)
        if not vehicles then
            vehicles = GetAllVehicles()
        end

        for i = 1, #vehicles do
            local vehicle = vehicles[i]
            if DoesEntityExist(vehicle) and GetVehicleNumberPlateText(vehicle):gsub('%s+', '') == plate:gsub('%s+', '') then
                return true, vehicle
            end
        end

        return false
    end

    lib.callback.register('yseries:server:garage:get-vehicles', function(source)
        local vehicles = GetPlayerVehicles(source)

        return vehicles
    end)

    lib.callback.register('yseries:server:garage:find-vehicle-by-plate', function(source, plate)
        local out, vehicle = IsVehicleOut(plate)

        if out and vehicle then
            return GetEntityCoords(vehicle)
        else
            local vehicles

            vehicles = MySQL.query.await(('SELECT garage FROM `%s` WHERE `%s` = ?'):format(
                database['table:owned_vehicles'], database['column:plate']), {plate})
            if vehicles and vehicles[1] then
                local garageLabel, garageCoords = exports['vms_garagesv2']:getGarageInfo(vehicles[1].garage)
                return garageCoords
            end
        end
    end)
end)
