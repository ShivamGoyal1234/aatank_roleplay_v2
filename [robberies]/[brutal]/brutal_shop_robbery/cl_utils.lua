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
        --TriggerEvent('QBCore:Notify', text, 'info', 5000)

        -- OKOK Notify:
        -- exports['okokNotify']:Alert(title, text, time, type, false)

    end
end

function TextUIFunction(type, text)
    if type == 'open' then
        if Config.TextUI:lower() == 'ox_lib' then
            lib.showTextUI(text)
        elseif Config.TextUI:lower() == 'okoktextui' then
            exports['okokTextUI']:Open(text, 'darkblue', 'right')
        elseif Config.TextUI:lower() == 'esxtextui' then
            ESX.TextUI(text)
        elseif Config.TextUI:lower() == 'qbdrawtext' then
            exports['qb-core']:DrawText(text,'left')
        elseif Config.TextUI:lower() == 'brutal_textui' then
            exports['brutal_textui']:Open(text, "blue")
        end
    elseif type == 'hide' then
        if Config.TextUI:lower() == 'ox_lib' then
            lib.hideTextUI()
        elseif Config.TextUI:lower() == 'okoktextui' then
            exports['okokTextUI']:Close()
        elseif Config.TextUI:lower() == 'esxtextui' then
            ESX.HideUI()
        elseif Config.TextUI:lower() == 'qbdrawtext' then
            exports['qb-core']:HideText()
        elseif Config.TextUI:lower() == 'brutal_textui' then
            exports['brutal_textui']:Close()
        end
    end
end

function ProgressBarFunction(time, text)
    if Config.ProgressBar:lower() == 'progressbars' then --LINK: https://github.com/EthanPeacock/progressBars/releases/tag/1.0
        exports['progressBars']:startUI(time, text)
        Citizen.Wait(10000)
    elseif Config.ProgressBar:lower() == 'pogressbar' then -- LINK: https://github.com/SWRP-PUBLIC/pogressBar
        exports['pogressBar']:drawBar(time, text)
        Citizen.Wait(10000)
    elseif Config.ProgressBar:lower() == 'ox_lib' then
        lib.progressBar({
            duration = time,
            label = text,
            useWhileDead = false,
            canCancel = true,
        })
    end
end

RegisterNetEvent('brutal_shop_robbery:client:PoliceAlert')
AddEventHandler('brutal_shop_robbery:client:PoliceAlert', function(coords, index)

    if GetResourceState("brutal_policejob") == "started" then
        local streetLabel = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords[1], coords[2], coords[3]))
        TriggerServerEvent('brutal_policejob:server:citizencall', 'create', 'Robbery in progress at '.. Config.ShopRobberys[index].ShopName, {coords[1], coords[2], coords[3]}, streetLabel)
    end    

    notification('ROBBERY PROCESS', 'Robbery in progress at '.. Config.ShopRobberys[index].ShopName ..'. Marked on the map!', 10000, 'info')

    AlertPlace = AddBlipForCoord(coords[1], coords[2], coords[3])
    SetBlipSprite(AlertPlace, Config.PoliceAlertBlip.sprite)
    SetBlipScale(AlertPlace, Config.PoliceAlertBlip.size)
    SetBlipColour(AlertPlace, Config.PoliceAlertBlip.color)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Config.PoliceAlertBlip.label)
    EndTextCommandSetBlipName(AlertPlace)

    Citizen.Wait(1000*60*5)
    RemoveBlip(AlertPlace)
end)

function PlayerDied()
    if GetResourceState("brutal_ambulancejob") == "started" then
        return exports.brutal_ambulancejob:IsDead()
    elseif GetResourceState("wasabi_ambulance") == "started" then
        return exports.wasabi_ambulance:isPlayerDead()
    else
        if IsEntityDead(PlayerPedId()) then
            return true
        else
            return false
        end
    end
end

function NoCarryWeapon()
    if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_UNARMED') then
        return true
    else
        SendNotify(18)
        return false
    end
end