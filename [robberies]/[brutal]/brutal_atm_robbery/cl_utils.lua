-- Buy here: (4€+VAT) https://store.brutalscripts.com
function notification(title, text, time, type)
    if Config.BrutalNotify then
        exports['brutal_notify']:SendAlert(title, text, time, type)
    else
        -- Put here your own notify and set the Config.BrutalNotify to false
        SetNotificationTextEntry("STRING")
        AddTextComponentString(text)
        DrawNotification(0,1)

        -- Default ESX Notify:
        --TriggerEvent('esx:showNotification', text)

        -- Default QB Notify:
        TriggerEvent('QBCore:Notify', text, 'info', 5000)

        -- OKOK Notify:
        -- exports['okokNotify']:Alert(title, text, time, type, false)

    end
end

RegisterNetEvent('brutal_atm_robbery:client:PoliceAlertBlip')
AddEventHandler('brutal_atm_robbery:client:PoliceAlertBlip', function(coords)

    -- notify function
    notification(Config.Notify[2][1], Config.Notify[2][2], Config.Notify[2][3], Config.Notify[2][4])
    
    -- blip for the cops
    AlertAtm = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(AlertAtm, Config.Blip['sprite'])
    SetBlipScale(AlertAtm, Config.Blip['size'])
    SetBlipColour(AlertAtm, Config.Blip['colour'])
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Config.Blip['label'])
    EndTextCommandSetBlipName(AlertAtm)

    Citizen.Wait(1000*60*Config.BlipTime)
    RemoveBlip(AlertAtm)
end)