-- ██████╗░██╗░██████╗██████╗░░█████╗░████████╗░█████╗░██╗░░██╗
-- ██╔══██╗██║██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██║░░██║
-- ██║░░██║██║╚█████╗░██████╔╝███████║░░░██║░░░██║░░╚═╝███████║
-- ██║░░██║██║░╚═══██╗██╔═══╝░██╔══██║░░░██║░░░██║░░██╗██╔══██║
-- ██████╔╝██║██████╔╝██║░░░░░██║░░██║░░░██║░░░╚█████╔╝██║░░██║
-- ╚═════╝░╚═╝╚═════╝░╚═╝░░░░░╚═╝░░╚═╝░░░╚═╝░░░░╚════╝░╚═╝░░╚═╝


---@class DispatchData
---@field title string
---@field message string
---@field coords vector3
---@field vehicle? number
---@field street? string

---@param data DispatchData
function Dispatch(data)
    if Config.Debug then
        print('Dispatch event called with data:', json.encode(data))
    end
    if not data or not data.title or not data.message or not data.coords then
        print('Invalid dispatch data provided.')
        return
    end

    data.street = data.street or GetStreetNameFromHashKey(GetStreetNameAtCoord(data.coords.x, data.coords.y, data.coords.z))
    TriggerServerEvent('vehiclekeys:server:dispatch', data)
end

---@param data DispatchData
RegisterNetEvent('qs-vehiclekeys:client:dispatch', function(data)
    local jobFramework = GetJobFramework()
    if jobFramework and jobFramework.name ~= Config.ReqJobPolice then
        print('Dispatch event called default, but player is not a police officer.')
        return
    end
    if Config.Debug then print('Dispatch event called default') end

    local transG = 300 * 2
    local blip = AddBlipForCoord(data.coords)
    SetBlipSprite(blip, 161)
    SetBlipColour(blip, 3)
    SetBlipDisplay(blip, 4)
    SetBlipAlpha(blip, transG)
    SetBlipScale(blip, 1.5)
    SetBlipFlashes(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(Lang('VEHICLEKEYS_NOTIFICATION_TITLE'))
    EndTextCommandSetBlipName(blip)

    SendTextMessage(data.message, 'inform')

    while transG ~= 0 do
        Citizen.Wait(500)
        transG = transG - 1
        SetBlipAlpha(blip, transG)
        if transG == 0 then
            SetBlipSprite(blip, 2)
            RemoveBlip(blip)
            return
        end
    end
end)
