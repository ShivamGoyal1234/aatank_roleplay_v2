--[[
    Hi dear customer or developer, here you can fully configure your server's
    framework or you could even duplicate this file to create your own framework.
    If you do not have much experience, we recommend you download the base version
    of the framework that you use in its latest version and it will work perfectly.
]]

if Config.Framework ~= 'qb' then
    return
end

QBCore = exports['qb-core']:GetCoreObject()

identifierTypes = 'citizenid'
vehiclesTable = 'player_vehicles'
plateTable = 'plate'
inventoryTrunk = 'inventory_trunk'
inventoryGlovebox = 'inventory_glovebox'

function RegisterServerCallback(name, cb)
    QBCore.Functions.CreateCallback(name, cb)
end

function GetPlayerIdentifier(player)
    return QBCore.Functions.GetPlayer(player).PlayerData.citizenid
end

function GetPlayerFromIdFramework(player)
    local Player = QBCore.Functions.GetPlayer(player)
    if Player then
        Player.citizenid = Player.PlayerData.citizenid
        Player.identifier = Player.PlayerData.citizenid
        Player.source = Player.PlayerData.source
    end
    return Player
end

function GetPlayers()
    return QBCore.Functions.GetPlayers()
end

function GetPlayerJob(player)
    local data = player.PlayerData.job
    return data.name
end

function GetPlayerDuty(player)
    local data = player.PlayerData.job
    return data.onduty
end

function PlayerIsAdmin(source)
    return QBCore.Functions.HasPermission(source, 'god') or IsPlayerAceAllowed(source, 'command') or QBCore.Functions.HasPermission(source, 'admin')
end

function GetMoney(player)
    return player.PlayerData.money['cash']
end

function GetAccountMoney(player, account)
    return player.PlayerData.money[account]
end

function RemoveAccountMoney(player, account, mount)
    return player.Functions.RemoveMoney(account, mount)
end

function RemoveMoney(player, mount)
    return player.Functions.RemoveMoney('cash', mount)
end

function RegisterUsableItem(name, cb)
    QBCore.Functions.CreateUseableItem(name, cb)
end

function GetItem(player, item)
    return player.Functions.GetItemByName(item)
end

function GetItemCount(player, item)
    if Config.InventoryScript == 'codem' then
        return player.getInventoryItem(item).amount
    else
        return player.Functions.GetItemByName(item).amount
    end
end

function AddItem(player, item, metadata)
    player.Functions.AddItem(item, 1, false, metadata)
end

function RemoveItem(player, item, metadata)
    player.Functions.RemoveItem(item, 1, false, metadata or nil)
end

function SetInventoryItem(player)
    player.Functions.SetInventory(player.PlayerData.items, true)
end

function AddItemMetadata(player, item, slot, metadata)
    if not player then return end
    if Config.InventoryScript == 'qs' then
        exports['qs-inventory']:AddItem(player.source, item, 1, nil, metadata)
    elseif Config.InventoryScript == 'qb' then
        player.Functions.AddItem(item, 1, false, metadata)
    elseif Config.InventoryScript == 'ox' then
        if exports.ox_inventory:CanCarryItem(player.source, item, 1, metadata) then
            exports.ox_inventory:AddItem(player.source, item, 1, metadata)
        end
    elseif Config.InventoryScript == 'origen' then
        exports['origen_inventory']:AddItem(player.source, item, 1, metadata)
    elseif Config.InventoryScript == 'core_inventory' then
        local inv = 'content-' .. player.identifier:gsub(':', '')
        exports['core_inventory']:addItem(inv, item, 1, metadata)
    elseif Config.InventoryScript == 'codem' then
        exports['codem-inventory']:AddItem(player.source, item, 1, nil, metadata)
    elseif Config.InventoryScript == 'tgiannInv' then
        exports['tgiann-inventory']:AddItem(player.source, item, 1, nil, metadata, false)
    elseif Config.InventoryScript == 'ak47' then
        exports['ak47_inventory']:AddItem(player.source, item, 1, nil, metadata)
    else
        print('Inventory not properly configured')
    end
end

function GetMetadata(player, item, slot, metadata)
    if not player then return end
    if Config.InventoryScript == 'qs' then
        return exports['qs-inventory']:GetInventory(player.source)
    elseif Config.InventoryScript == 'qb' then
        return player.PlayerData.items
    elseif Config.InventoryScript == 'origen' then
        return exports['origen_inventory']:GetInventoryItems(player.source)
    elseif Config.InventoryScript == 'ox' then
        return ox_inventory:GetInventoryItems(player.source)
    elseif Config.InventoryScript == 'core_inventory' then
        local inv = 'content-' .. player.identifier:gsub(':', '')
        return exports['core_inventory']:getInventory(inv)
    elseif Config.InventoryScript == 'codem' then
        return exports['codem-inventory']:GetInventory(false, player.source)
    elseif Config.InventoryScript == 'tgiannInv' then
        return exports['tgiann-inventory']:GetPlayerItems(player.source)
    elseif Config.InventoryScript == 'ak47' then
        return exports['ak47_inventory']:GetInventory(player.source)
    else
        print('Inventory not properly configured')
    end
end

function RemoveItemMetadata(player, item, slot, metadata)
    if not player then return end
    if Config.InventoryScript == 'qs' then
        exports['qs-inventory']:RemoveItem(player.source, item, 1, slot, metadata)
    elseif Config.InventoryScript == 'qb' then
        player.Functions.RemoveItem(item, 1, false)
    elseif Config.InventoryScript == 'ox' then
        ox_inventory:RemoveItem(player.source, item, 1, metadata, slot)
    elseif Config.InventoryScript == 'origen' then
        exports['origen_inventory']:RemoveItem(player.source, item, 1, metadata, slot)
    elseif Config.InventoryScript == 'core_inventory' then
        coreInventoryRemoveItemWithMetadata(player, item, metadata)
    elseif Config.InventoryScript == 'codem' then
        exports['codem-inventory']:RemoveItem(player.source, item, 1, slot)
    elseif Config.InventoryScript == 'tgiannInv' then
        exports['tgiann-inventory']:RemoveItem(player.source, item, 1, nil)
    elseif Config.InventoryScript == 'ak47' then
        exports['ak47_inventory']:RemoveItem(player.source, item, 1, slot, metadata)
    else
        print('Inventory not properly configured')
    end
end

function coreInventoryRemoveItemWithMetadata(player, item, metadata)
    local inv = 'content-' .. player.identifier:gsub(':', '')
    if metadata and type(metadata) == 'table' and metadata.id then
        exports['core_inventory']:removeItemExact(inv, metadata.id, 1)
    elseif metadata and type(metadata) ~= 'table' then
        local inventoryData = exports['core_inventory']:getInventory(inv)
        for k, v in pairs(inventoryData) do
            if v.name == item and v.metadata and v.metadata.plate then
                if string.find(v.metadata.plate, metadata) then
                    exports['core_inventory']:removeItemExact(inv, v.id, 1)
                    break
                end
            end
        end
    end
end
