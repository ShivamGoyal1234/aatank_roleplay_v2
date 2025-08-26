QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem('bandage', function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        Player.Functions.RemoveItem('bandage', 1)
        TriggerClientEvent('consumables:client:useBandage', source)
    end
end)

QBCore.Functions.CreateUseableItem('ifaks', function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        Player.Functions.RemoveItem('ifaks', 1)
        TriggerClientEvent('consumables:client:useIfak', source)
    end
end)
