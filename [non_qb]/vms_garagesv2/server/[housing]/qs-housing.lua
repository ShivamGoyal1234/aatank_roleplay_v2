if Config.Housing ~= 'qs-housing' or not Config.RegisterHouseGaragesAutomatically then
    return
end

RegisterNetEvent('qb-houses:server:addGarage')
AddEventHandler('qb-houses:server:addGarage', function(name, coords)
    local name, coords = name, coords
    if name and coords and coords.x then
        CreateThread(function()
            exports[GetCurrentResourceName()]:registerHousingGarage(
                'qs-housing-' .. name,                            --[[ File name - Garage ID will always be as "HouseGarage:nolag_property-ID" ]]
                'Garage',                                         --[[ Garage Label ]]
                name,                                             --[[ Housing ID ]]
                vector4(coords.x, coords.y, coords.z, coords.h),  --[[ Coordinates ]]
                1                                                 --[[ Garage Interior ID (Config.ParkingCreator.HouseGarageInteriors) ]]
            )
        end)
    end
end)