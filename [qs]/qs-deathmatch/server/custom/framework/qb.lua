if Config.Framework ~= 'qb' then
    return
end

local QBCore = exports['qb-core']:GetCoreObject()

function RegisterServerCallback(name, cb)
    QBCore.Functions.CreateCallback(name, cb)
end

function GetPlayerFromId(source)
    return QBCore.Functions.GetPlayer(source)
end

function GetPlayerSource(player)
    return player.PlayerData.source
end

function GetIdentifier(source)
    local player = GetPlayerFromId(source)
    if not player then
        print('Player not found. Source: ', source)
        return false
    end
    return player.PlayerData.citizenid
end
