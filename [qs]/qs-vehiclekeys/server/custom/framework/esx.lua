--[[
    Hi dear customer or developer, here you can fully configure your server's
    framework or you could even duplicate this file to create your own framework.
    If you do not have much experience, we recommend you download the base version
    of the framework that you use in its latest version and it will work perfectly.
]]

if Config.Framework ~= 'esx' then
    return
end

local version = GetResourceMetadata('es_extended', 'version', 0)

if version == '1.1.0' or version == '1.2.0' or version == 'legacy' then
    ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
else
    ESX = exports['es_extended']:getSharedObject()
end

identifierTypes = 'owner'
vehiclesTable = 'owned_vehicles'
plateTable = 'plate'
inventoryTrunk = 'inventory_trunk'
inventoryGlovebox = 'inventory_glovebox'

function RegisterServerCallback(name, cb)
    ESX.RegisterServerCallback(name, cb)
end

function GetPlayerFromIdFramework(player)
    local Player = ESX.GetPlayerFromId(player)
    return Player
end

function GetPlayerIdentifier(player)
    return ESX.GetPlayerFromId(player).identifier
end

function GetPlayerJob(player)
    return player.getJob().name
end

function GetPlayerDuty(player)
    return true
end

function PlayerIsAdmin(source)
    local player = GetPlayerFromIdFramework(source)
    return player.getGroup() == 'admin' or player.getGroup() == 'superadmin'
end

function GetPlayers()
    return ESX.GetPlayers()
end

function GetMoney(player)
    return player.getMoney()
end

function RemoveMoney(player, mount)
    return player.removeMoney(mount)
end

function GetAccountMoney(player, account)
    return player.getAccount(account).money
end

function RemoveAccountMoney(player, account, mount)
    return player.removeAccountMoney(account, mount)
end

function RegisterUsableItem(name, cb)
    ESX.RegisterUsableItem(name, cb)
end

function GetItem(player, item)
    return player.getInventoryItem(item)
end

function GetItemCount(player, item)
    if Config.InventoryScript == 'codem' then
        return player.getInventoryItem(item).amount
    else
        return player.getInventoryItem(item).count
    end
end

function AddItem(player, item, metadata)
    player.addInventoryItem(item, 1, metadata)
end

function RemoveItem(player, item)
    player.removeInventoryItem(item, 1, metadata)
end

function SetInventoryItem(player)
    return true
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

RegisterServerEvent('CheckPlayerItem')
AddEventHandler('CheckPlayerItem', function(item)
    local source = source
    local hasItem = CheckIfPlayerHasItem(source, item)
    TriggerClientEvent('CheckPlayerItemResult', source, hasItem)
end)
