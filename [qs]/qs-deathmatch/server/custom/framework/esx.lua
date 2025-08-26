if Config.Framework ~= 'esx' then
    return
end

ESX = exports['es_extended']:getSharedObject()

function RegisterServerCallback(name, cb)
    ESX.RegisterServerCallback(name, cb)
end

function GetPlayerFromId(source)
    return ESX.GetPlayerFromId(source)
end

function GetPlayerSource(player)
    return player.source
end

function GetIdentifier(source)
    local player = GetPlayerFromId(source)
    if not player then
        print('Player not found. Source: ', source)
        return false
    end
    return player.identifier
end
