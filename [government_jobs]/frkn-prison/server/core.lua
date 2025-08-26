Core = nil
CoreName = nil
CoreReady = false
Inventory = nil

Citizen.CreateThread(function()
    for k, v in pairs(Cores) do
        if GetResourceState(v.ResourceName) == "starting" or GetResourceState(v.ResourceName) == "started" then
            CoreName = v.ResourceName
            Core = v.GetFramework()
            CoreReady = true
        end
    end
     local inventories = {
        {Name = "qb-inventory"},
        {Name = "ox_inventory"},
        {Name = "qs-inventory"},
        {Name = "ps-inventory"},
        {Name = "lj-inventory"},
    }
    for k, v in pairs(inventories) do
        if GetResourceState(v.Name) == "starting" or GetResourceState(v.Name) == "started" then
            Inventory = v.Name
        end
    end
end)


function GetActiveInventory()
    if GetResourceState("qb-inventory") == "started" then
        return "qb-inventory"
    elseif GetResourceState("qs-inventory") == "started" then
        return "qs-inventory"
    elseif GetResourceState("ps-inventory") == "started" then
        return "ps-inventory"
    elseif GetResourceState("lj-inventory") == "started" then
        return "lj-inventory"
    elseif GetResourceState("ox_inventory") == "started" then
        return "ox_inventory"
    end
    return nil
end

function GetPlayer(source)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayer(source)
        return player
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(source)
        return player
    end
end

function GetPlayerIgName(source)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayer(source)
        return player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(source)
        return player.getName() or player.firstname 
    end
end

function Notify(text, length, type)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        Core.Functions.Notify(message, type, time)
    elseif CoreName == "es_extended" then
        Core.ShowNotification(text)
    end
end


function AddMoney(src, type, amount, description)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayer(src)
        player.Functions.AddMoney(type, amount, description)
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(src)
        if type == "bank" then
            player.addAccountMoney("bank", amount, description)
        elseif type == "cash" then
            player.addMoney(amount, description)
        end
    end
end


function RemoveMoney(src, type, amount, description)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayer(src)
        player.Functions.RemoveMoney(type, amount, description)
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(src)
        if type == "bank" then
            player.removeAccountMoney("bank", amount, description)
        elseif type == "cash" then
            player.removeMoney(amount, description)
        else
            --CUSTOM ACCOUNT REMOVE MONEY FUNCTION HERE
        end
    end
end




function GetPlayerMoney(src, type)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayer(src)
        return player.PlayerData.money[type]
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(src)
        local acType = "bank"
        if type == "cash" then
            acType = "money"
        end
        local account = player.getAccount(acType).money
        return account
    end
end

function TransferVehicle(loserIdentifier, winnerIdentifier, carPlate, loserLicense)
    if not loserIdentifier or not winnerIdentifier or not carPlate then return end

    if CoreName == "qb-core" then
        local vehicles = MySQL.Sync.fetchAll("SELECT * FROM player_vehicles WHERE citizenid = @citizenid AND plate = @plate", {
            ['@citizenid'] = loserIdentifier,
            ['@plate'] = carPlate
        })

        for _, veh in pairs(vehicles) do
            MySQL.Sync.execute("DELETE FROM player_vehicles WHERE id = @id", {
                ['@id'] = veh.id
            })

            MySQL.Sync.execute("INSERT INTO player_vehicles (license, citizenid, plate, vehicle, mods, hash, garage, state) VALUES (@license, @cid, @plate, @vehicle, @mods, @hash, @garage, @state)", {
                ['@license'] = loserLicense or veh.license or "UNKNOWN_LICENSE",
                ['@cid'] = winnerIdentifier,
                ['@plate'] = veh.plate,
                ['@vehicle'] = veh.vehicle,
                ['@mods'] = veh.mods,
                ['@hash'] = veh.hash,
                ['@garage'] = veh.garage or "pillboxgarage",
                ['@state'] = veh.state or 0
            })
        end

    elseif CoreName == "es_extended" then
        local vehicles = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @owner AND plate = @plate", {
            ['@owner'] = loserIdentifier,
            ['@plate'] = carPlate
        })

        for _, veh in pairs(vehicles) do
            MySQL.Sync.execute("DELETE FROM owned_vehicles WHERE id = @id", {
                ['@id'] = veh.id
            })

            MySQL.Sync.execute("INSERT INTO owned_vehicles (owner, plate, vehicle, stored, type) VALUES (@owner, @plate, @vehicle, @stored, @type)", {
                ['@owner'] = winnerIdentifier,
                ['@plate'] = veh.plate,
                ['@vehicle'] = veh.vehicle,
                ['@stored'] = veh.stored or 1,
                ['@type'] = veh.type or "car"
            })
        end
    end
end

function GetSourceFromIdentifier(identifier)
    for _, playerId in ipairs(GetPlayers()) do
        local src = tonumber(playerId)
        
        if CoreName == "qb-core" or CoreName == "qbx_core" then
            local player = Core.Functions.GetPlayer(src)
            if player and player.PlayerData.citizenid == identifier then
                return src
            end
        elseif CoreName == "es_extended" then
            local player = Core.GetPlayerFromId(src)
            if player and player.identifier == identifier then
                return src
            end
        end
    end
    return nil
end


function GetPlayerCid(source)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayer(source)
        if player ~= nil then
            return player.PlayerData.citizenid
        else
            return nil
        end
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(source)
        if player ~= nil and player.getIdentifier ~= nil then
            return player.getIdentifier()
        else
            return nil
        end    
    else
        --CUSTOM GET PLAYER CID FUNCTION HERE
    end
end

function GetIdentifier(source)
    local source = tonumber(source)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayer(source)
        return player.PlayerData.citizenid
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(source)
        return player.identifier
    end
end

function Notify(source, text, length, type)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        Core.Functions.Notify(source, text, type, length)
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(source)
        player.showNotification(text)
    end
end

function GetPlayerJob(source)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayer(source)
        return player.PlayerData.job
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(source)
        return player.job
    end
end

function GetPlayerGrade(source)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayer(source)
        return player.PlayerData.job.grade.level
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(source)
        return player.job.grade
    end
end

function RemoveItem(source, name, amount, metadata)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayer(source)
        player.Functions.RemoveItem(name, amount, metadata)
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(source)
        local hasQs = GetResourceState('qs-inventory') == 'started'
        local hasEsx = GetResourceState('esx_inventoryhud') == 'started'
        local hasOx = GetResourceState('qb-inventory') == 'started'

        if hasQs then
            return exports['qs-inventory']:RemoveItem(source, name, amount, metadata)
        elseif hasEsx then
            return player.removeInventoryItem(name, amount)
        elseif hasOx then
            return exports["qb-inventory"]:RemoveItem(source, name, amount, metadata)
        else
            --CUSTOM INVENTORY REMOVE ITEM FUNCTION HERE
        end
    end
end

function AddItem(source, name, amount, metadata)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayer(source)
        player.Functions.AddItem(name, amount, metadata)
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(source)
        local hasQs = GetResourceState('qs-inventory') == 'started'
        local hasEsx = GetResourceState('esx_inventoryhud') == 'started'
        local hasOx = GetResourceState('ox_inventory') == 'started'

        if hasQs then
            return exports['qs-inventory']:AddItem(source, name, amount)
        elseif hasEsx then
            return player.addInventoryItem(name, amount)
        elseif hasOx then
            return exports["ox_inventory"]:AddItem(source, name, amount, metadata)
        else
            --CUSTOM INVENTORY ADD ITEM FUNCTION HERE
        end

    end
end

function GetItemByName(player, name)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        -- local player = Core.Functions.GetPlayer(source)
        return player.Functions.GetItemByName(name)
    elseif CoreName == "es_extended" then
        -- local player = Core.GetPlayerFromId(source)
        local hasQs = GetResourceState('qs-inventory') == 'started'
        local hasEsx = GetResourceState('esx_inventoryhud') == 'started'
        local hasOx = GetResourceState('qb-inventory') == 'started'

        if hasQs then
            return exports['qs-inventory']:GetItem(source, name)
        elseif hasEsx then
            return player.getInventoryItem(name)
        elseif hasOx then
            return exports["qb-inventory"]:GetItem(source, name)
        else
            --CUSTOM INVENTORY GET ITEM FUNCTION HERE
        end
    end
end


function GetItemBySlot (player, slot)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        return player.Functions.GetItemBySlot(slot)
    elseif CoreName == "es_extended" then
        local hasQs = GetResourceState('qs-inventory') == 'started'
        local hasEsx = GetResourceState('esx_inventoryhud') == 'started'
        local hasOx = GetResourceState('qb-inventory') == 'started'

        if hasQs then
            return exports['qs-inventory']:GetItemBySlot(source, slot)
        elseif hasEsx then
            return player.getInventoryItemBySlot(slot)
        elseif hasOx then
            return exports["qb-inventory"]:GetItemBySlot(source, slot)
        else
            --CUSTOM INVENTORY GET ITEM BY SLOT FUNCTION HERE
        end
    end
end

function HasAnyItem(xPlayer, items)
    if type(items) == 'string' then
        items = { items }
    end

    for _, itemName in pairs(items) do
        local item = nil
        if CoreName == 'es_extended' then
            item = xPlayer.hasItem(itemName)
        else
            item = xPlayer.Functions.GetItemByName(itemName)
        end
        if item and (item.amount or item.count or 0) > 0 then
            return true
        end
    end
    return false 
end

function GetItem(p, name)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = p
        return player.Functions.GetItemByName(name)
    elseif CoreName == "es_extended" then
        local player = p
        local hasQs = GetResourceState('qs-inventory') == 'started'
        local hasEsx = GetResourceState('esx_inventoryhud') == 'started'
        local hasOx = GetResourceState('qb-inventory') == 'started'

        if hasQs then
            return exports['qs-inventory']:GetItem(source, name)
        elseif hasEsx then
            return player.getInventoryItem(name)
        elseif hasOx then
            return exports["qb-inventory"]:GetItem(source, name)
        else
            --CUSTOM INVENTORY GET ITEM FUNCTION HERE
        end
    end
end

function GetItemCount(source,item)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayer(source)
        if player.Functions.GetItemByName(item) == nil then
            return 0
        end
        return player.Functions.GetItemByName(item).amount
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(source)
        local hasQs = GetResourceState('qs-inventory') == 'started'
        local hasEsx = GetResourceState('esx_inventoryhud') == 'started'
        local hasOx = GetResourceState('ox_inventory') == 'started'

        if hasQs then
            return exports['qs-inventory']:GetItem(source, item).amount
        elseif hasOx or hasEsx then
            return player.getInventoryItem(item).count
        elseif hasOx then
            return exports["ox_inventory"]:Search(source, item).count
        else
            --CUSTOM INVENTORY GET ITEM COUNT FUNCTION HERE
        end
    end
end

function GetAllItems(source)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayer(source)
        return player.PlayerData.items
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(source)
        local hasQs = GetResourceState('qs-inventory') == 'started'
        local hasEsx = GetResourceState('esx_inventoryhud') == 'started'
        local hasOx = GetResourceState('ox_inventory') == 'started'

        if hasQs then
            return exports['qs-inventory']:GetItems(source)
        elseif hasEsx then
            return player.getInventory()
        elseif hasOx then
            return exports["ox_inventory"]:Search(source, "all")
        else
            --CUSTOM INVENTORY GET ALL ITEMS FUNCTION HERE
        end
    end
end

function ClearInventory(source)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayer(source)
        if player and player.Functions and player.Functions.ClearInventory then
            player.Functions.ClearInventory()
        elseif player and player.PlayerData and player.PlayerData.items then
            for k, v in pairs(player.PlayerData.items) do
                player.Functions.RemoveItem(v.name, v.amount)
            end
        end
    elseif CoreName == "es_extended" then
        local hasQs = GetResourceState('qs-inventory') == 'started'
        local hasOx = GetResourceState('ox_inventory') == 'started'
        local xPlayer = Core.GetPlayerFromId(source)

        if hasQs then
            exports['qs-inventory']:ClearInventory(source)
        elseif hasOx then
            exports['ox_inventory']:ClearInventory(source)
        elseif xPlayer and xPlayer.getInventory then
            for _, item in pairs(xPlayer.getInventory()) do
                if item.count and item.count > 0 then
                    xPlayer.removeInventoryItem(item.name, item.count)
                end
            end
        end
    end
end



function RegisterUsableItem(name)
    while CoreReady == false do Citizen.Wait(0) end

    local hasQs = GetResourceState('qs-inventory') == 'started'
    if hasQs then
        exports['qs-inventory']:CreateUsableItem(name, function(source, item)
            if name == FRKN.General.PrisonNoteBook then
                TriggerClientEvent('frkn-prison:openNotebook', source, item)
            end
        end)
    elseif CoreName == "qb-core" or CoreName == "qbx_core" then
        Core.Functions.CreateUseableItem(name, function(source, item)
            if name == FRKN.General.PrisonNoteBook then
                TriggerClientEvent('frkn-prison:openNotebook', source, item)
            end
        end)
    elseif CoreName == "es_extended" then
        Core.RegisterUsableItem(name, function(source, item)
            if name == FRKN.General.PrisonNoteBook then
                TriggerClientEvent('frkn-prison:openNotebook', source, item)
            end
        end)
    end
end



FRKN.General.ServerCallbacks = {}
function CreateCallback(name, cb)
    FRKN.General.ServerCallbacks[name] = cb
end

function TriggerCallback(name, source, cb, ...)
    if not FRKN.General.ServerCallbacks[name] then return end
    FRKN.General.ServerCallbacks[name](source, cb, ...)
end

RegisterNetEvent('frkn-prison:server:triggerCallback', function(name, ...)
    local src = source
    TriggerCallback(name, src, function(...)
        TriggerClientEvent('frkn-prison:client:triggerCallback', src, name, ...)
    end, ...)
end)