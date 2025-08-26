if Config.Core ~= "QB-Core" then
    return
end

Migration = Migration or {}

local vehicleTypes = {
    ['automobile'] = 'vehicle',
    ['car'] = 'vehicle',
    ['vehicle'] = 'vehicle',
    ['bike'] = 'vehicle',

    ['heli'] = 'helicopter',
    ['helicopter'] = 'helicopter',
    
    ['plane'] = 'plane',

    ['boat'] = 'boat',
    ['submarine'] = 'boat',
}

local getType = function(hash)
    local hash = hash;
    for k, v in pairs(Core.Shared.Vehicles) do
        if GetHashKey(k) == hash then
            return vehicleTypes[v.type]
        end
    end
end

local coppiedVehiclesList = {}
Migration['qb-garages'] = function(oldTableName, migrationGarage, migrationToImpound)
    MySQL.Async.fetchAll(('SELECT * FROM `%s`'):format(oldTableName), {}, function(result)
        coppiedVehiclesList = result
        if coppiedVehiclesList[1] then
            for k, v in pairs(coppiedVehiclesList) do
                local vehicleType = getType(v.hash)
                MySQL.Async.execute(('INSERT INTO `%s` (`owner`, `plate`, `netid`, `vehicle`, `type`, `garage`, `parking_date`, `impound_date`, `impound_data`, `tuning_data`) VALUES (@owner, @plate, @netid, @vehicle, @type, @garage, @parking_date, @impound_date, @impound_data, @tuning_data)'):format(SV.Database['table:owned_vehicles']), {
                    ['@owner'] = v.citizenid, 
                    ['@plate'] = v.plate,
                    ['@netid'] = nil,
                    ['@vehicle'] = v.mods,
                    ['@type'] = vehicleType,
                    ['@garage'] = migrationToImpound and Config.VehicleTypes[vehicleType].defaultImpound or migrationGarage,
                    ['@parking_date'] = not migrationToImpound and os.time() or nil,
                    ['@impound_date'] = migrationToImpound and os.time() or nil,
                    ['@impound_data'] = migrationToImpound and json.encode({fine_amount = 0, }) or nil,
                    ['@tuning_data'] = v.tuning_data or nil,
                })
            end
            print('Successful migration '.. #coppiedVehiclesList ..' vehicles.')
        else
            print('No vehicles found in the table ^1' .. oldTableName .. '^7, remember to adjust ^5LAST_OWNED_GARAGES_TABLE^7 in vms_garagesv2/server/migration/_migration.lua')
        end
    end)
end