---@param data DispatchData
RegisterNetEvent('vehiclekeys:server:dispatch', function(data)
    if Config.Debug then
        print('vehiclekeys:server:dispatch event called with data:', json.encode(data))
    end
    if Config.Dispatch == 'default' then
        TriggerClientEvent('qs-vehiclekeys:client:dispatch', -1, data)
    elseif Config.Dispatch == 'qs-smartphone' then
        TriggerEvent('vehiclekeys:server:phoneDispatch', data.coords, data.message)
    elseif Config.Dispatch == 'qs' then
        TriggerEvent('qs-dispatch:server:CreateDispatchCall', {
            job = { Config.JobPolice },
            callLocation = data.coords,
            callCode = { code = '10-42', snippet = 'Vehicle Theft' },
            message = data.message .. ' near ' .. data.street,
            flashes = false,
            image = nil,
            blip = {
                sprite = 490,
                scale = 1.5,
                colour = 1,
                flashes = false,
                text = 'Vehicle Theft',
                time = (3 * 60 * 1000),
            },
            otherData = {
                {
                    text = 'Vehicle Theft',
                    icon = 'fas fa-car-side',
                }
            }
        })
    elseif Config.Dispatch == 'origen' then
        TriggerEvent('SendAlert:police', {
            coords = data.coords,
            title = data.title,
            type = 'GENERAL',
            message = data.message .. ' near ' .. data.street,
            job = Config.JobPolice,
        })
    end
end)
