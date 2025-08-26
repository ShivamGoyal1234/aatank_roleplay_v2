if Config.Housing ~= 'nolag_properties' or not Config.RegisterHouseGaragesAutomatically then
    return
end

RegisterNetEvent('nolag_properties:server:property:setInteractablePoint')
AddEventHandler('nolag_properties:server:property:setInteractablePoint', function(housingId, data)
    local housingId, data = housingId, data
    if data and data.name == 'OpenGarageMenu' and data.coords then
        CreateThread(function()
            exports[GetCurrentResourceName()]:registerHousingGarage(
                'nolag_property-' .. housingId,     --[[ File name - Garage ID will always be as "HouseGarage:nolag_property-ID" ]]
                'Garage '..housingId,               --[[ Garage Label ]]
                housingId,                          --[[ Housing ID ]]
                data.coords,                        --[[ Coordinates ]]
                1                                   --[[ Garage Interior ID (Config.ParkingCreator.HouseGarageInteriors) ]]
            )
        end)
    end
end)