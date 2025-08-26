if Config.framework == 'qb' then
    QBCore = exports['qb-core']:GetCoreObject()

    QBCore.Functions.CreateUseableItem('megaphone', function(source)
        local Player = QBCore.Functions.GetPlayer(source)

        if Player then
            TriggerClientEvent('fd-megaphones:client:usemegaphone', source)
        end
    end)
elseif Config.framework == 'qbox' then
    exports.qbx_core:CreateUseableItem('megaphone', function(source)
        local Player = exports.qbx_core:GetPlayer(source)
    
        if Player then
            TriggerClientEvent('fd-megaphones:client:usemegaphone', source)
        end
    end)  
elseif Config.framework == 'esx' then
    ESX = exports["es_extended"]:getSharedObject()

    ESX.RegisterUsableItem('megaphone', function(playerId)
        local xPlayer = ESX.GetPlayerFromId(playerId)

        if xPlayer then
            TriggerClientEvent('fd-megaphones:client:usemegaphone', playerId)
        end
    end)
end
