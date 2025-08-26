--[[
    Usable Items & Inventory Utilities Module
    -------------------------------------------
    This module provides functions for:
      • Registering items as usable across different inventory systems (ESX, QBcore, QBX).
      • Retrieving an item's image as a NUI link.
      • Adding and removing items from a player's inventory.
      • Toggling items in inventory (with server event for exploit protection).
      • Checking for item duplication exploits.
      • Handling tool durability mechanics.
      • Checking item availability and retrieving inventory.
      • Granting random rewards from a reward pool.
      • Checking if a player can carry specific items based on weight.
]]
validTokens = {}

-------------------------------------------------------------
-- Registering Usable Items
-------------------------------------------------------------

--- Registers an item as usable for ESX, QBcore, or QBX.
---
--- @param item string The name of the item.
--- @param funct function The function to execute when the item is used.
---
--- @usage
--- ```lua
--- createUseableItem("health_potion", function(source)
---     -- Code to consume the health potion
--- end)
--- ```
function createUseableItem(item, funct)
    if doesItemExist(item) then
        local itemResource = ""
        if isStarted(ESXExport) then
            itemResource = ESXExport
            while not ESX do Wait(0) end
            ESX.RegisterUsableItem(item, funct)

        elseif isStarted(QBExport) and not isStarted(QBXExport) then
            itemResource = QBExport
            Core.Functions.CreateUseableItem(item, funct)

        elseif isStarted(QBXExport) then
            itemResource = QBXExport
            exports[QBXExport]:CreateUseableItem(item, funct)

        elseif isStarted(RSGExport) then
            itemResource = RSGExport
            Core.Functions.CreateUseableItem(item, funct)

        end

        if itemResource ~= "" then
            debugPrint("^6Bridge^7: ^2Registering ^3UsableItem^2 with ^4"..itemResource.."^7:", item)
        else
            debugPrint("^4ERROR^7: No supported framework detected for registering usable item: ^3"..item.."^7")
        end
    else
        print("^1ERROR^7: ^1Tried to make item usable but it didn't exist^7: "..item)
    end
end


-------------------------------------------------------------
-- Adding and Removing Items
-------------------------------------------------------------

--- Adds an item to a player's inventory.
---
--- Triggers a server event (or local event) to add the specified item.
---
--- @param item string The item name.
--- @param amount number The quantity to add.
--- @param info table|nil Additional metadata for the item.
--- @param src number|nil Optional player source; if nil, defaults to the caller.
---
--- @usage
--- ```lua
--- addItem("health_potion", 2, { quality = "high" })
--- ```
function addItem(item, amount, info, src)
    if not Items[item] then
        print("^6Bridge^7: ^1Error^7 - ^2Tried to give ^7'^3"..item.."^7'^2 but it doesn't exist")
        return
    end

    if src then
        TriggerEvent(getScript()..":server:toggleItem", true, item, amount, src, info)
    else
        TriggerServerEvent(getScript()..":server:toggleItem", true, item, amount, nil, info, nil, currentToken)
        currentToken = nil -- clear client cached token
    end
end

--- Removes an item from a player's inventory.
---
--- Triggers a server event (or local event) to remove the specified item.
---
--- @param item string The item name.
--- @param amount number The quantity to remove.
--- @param src number|nil Optional player source.
--- @param slot number|nil Optional inventory slot.
---
--- @usage
--- ```lua
--- removeItem("health_potion", 1)
--- ```
function removeItem(item, amount, src, slot)
    if not Items[item] then
        print("^6Bridge^7: ^1Error^7 - ^2Tried to remove ^7'^3"..item.."^7'^2 but it doesn't exist")
        return
    end

    if src then
        debugPrint(src)
        TriggerEvent(getScript()..":server:toggleItem", false, item, amount, src, nil, slot)
    else
        TriggerServerEvent(getScript()..":server:toggleItem", false, item, amount, nil, nil, slot)
    end
end

-------------------------------------------------------------
-- Toggle Items (Server Event)
-------------------------------------------------------------

--- Server event handler to toggle (add or remove) an item from a player's inventory.
---
--- This function validates the item, then calls the appropriate export functions based on the active inventory system.
--- It also includes exploit protection via the dupeWarn function.
---
--- @param give boolean True to add the item, false to remove.
--- @param item string The item name.
--- @param amount number The quantity.
--- @param newsrc number|nil The player source; defaults to event source.
--- @param info table|nil Additional metadata.
--- @param slot number|nil Optional inventory slot.
---
--- @usage
--- ```lua
--- TriggerServerEvent(getScript()..":server:toggleItem", true, "health_potion", 1)
--- ```
RegisterNetEvent(getScript()..":server:toggleItem", function(give, item, amount, newsrc, info, slot, token)
    --debugPrint(GetInvokingResource())
	if GetInvokingResource() and GetInvokingResource() ~= getScript() and GetInvokingResource() ~= "qb-core" then
        debugPrint("^1Error^7: ^1Possible exploit^7, ^1vital function was called from an external resource^7")
        return
    end
    if not Items[item] then
        print("^6Bridge^7: ^1Error^7 - ^2Tried to "..(tostring(give) == "true" and "add" or "remove").." '^3"..item.."^7' but it doesn't exist")
        return
    end

    local src = newsrc or source
    if (give == true or give == 1) then
        if newsrc == nil then -- this must be coming from client this would be blank
            if not checkToken(src, token, "item", item) then
                return
            end
        end
    end

    local action = (tostring(give) == "true" and "addItem" or "removeItem")
    local remamount = amount or 1
    if item == nil then return end

    -- Grab the current inventory (you can expand usage of 'inv' if needed)
    local invName = ""
    if give == 0 or give == false then
        if not hasItem(item, amount or 1, src) then
            dupeWarn(src, item, amount)

        else
            if isStarted(OXInv) then
                invName = OXInv
                exports[OXInv]:RemoveItem(src, item, remamount, nil)

            elseif isStarted(QSInv) then
                invName = QSInv
                exports[QSInv]:RemoveItem(src, item, remamount)

            elseif isStarted(CoreInv) then
                invName = CoreInv
                exports[CoreInv]:removeItem(src, item, remamount)

            elseif isStarted(OrigenInv) then
                invName = OrigenInv
                exports[OrigenInv]:removeItem(src, item, remamount)

            elseif isStarted(CodeMInv) then
                invName = CodeMInv
                exports[CodeMInv]:RemoveItem(src, item, remamount)

            elseif isStarted(TgiannInv) then
                invName = TgiannInv
                exports[TgiannInv]:RemoveItem(src, item, remamount)

            elseif isStarted(JPRInv) then
                invName = JPRInv
                while remamount > 0 do
                    if Core.Functions.GetPlayer(src).Functions.RemoveItem(item, 1, slot) then
                        remamount -= 1
                    else
                        print("^1Error removing "..item.." Amount left: "..remamount)
                        break
                    end
                end
                if Config.Crafting ~= nil and Config.Crafting.showItemBox then
                    TriggerClientEvent("inventory:client:ItemBox", src, Items[item], "remove", amount or 1)
                end

            elseif isStarted(QBInv) then
                invName = QBInv
                while remamount > 0 do
                    if Core.Functions.GetPlayer(src).Functions.RemoveItem(item, 1, slot) then
                        remamount -= 1
                    else
                        print("^1Error removing "..item.." Amount left: "..remamount)
                        break
                    end
                end
                if Config.Crafting ~= nil and Config.Crafting.showItemBox then
                    TriggerClientEvent((isStarted(QBInv) and QBInvNew and "qb-" or "").."inventory:client:ItemBox", src, Items[item], "remove", amount or 1)
                end

            elseif isStarted(PSInv) then
                invName = PSInv
                while remamount > 0 do
                    if Core.Functions.GetPlayer(src).Functions.RemoveItem(item, 1, slot) then
                        remamount -= 1
                    else
                        print("^1Error removing "..item.." Amount left: "..remamount)
                        break
                    end
                end
                if Config.Crafting ~= nil and Config.Crafting.showItemBox then
                    TriggerClientEvent("inventory:client:ItemBox", src, Items[item], "remove", amount or 1)
                end

            elseif isStarted(RSGInv) then invName = RSGInv
                while remamount > 0 do
                    if Core.Functions.GetPlayer(src).Functions.RemoveItem(item, 1, slot) then
                        remamount -= 1
                    else
                        print("^1Error removing "..item.." Amount left: "..remamount)
                        break
                    end
                end
                if Config.Crafting ~= nil and Config.Crafting.showItemBox then
                    TriggerClientEvent("rsg-inventory:client:ItemBox", src, Items[item], "remove", amount or 1)
                end

            end
            -----
            -- Fallback for if no inventory found:
            -----
            if invName == "" then
                if isStarted(QBExport) or isStarted(QBXExport) then -- if qbcore or qbxcore, just use core functions
                    invName = isStarted(QBXExport) and QBXExport or isStarted(QBExport) and QBExport
                    Core.Functions.GetPlayer(src).Functions.RemoveItem(item, remamount, slot)

                elseif ESX and isStarted(ESXExport) then  -- if esx then use core functions
                    invName = ESX
                    ESX.GetPlayerFromId(src).removeInventoryItem(item, remamount)

                end
            end
            -- Final check for if inventory was found
            if invName == "" then
                print("^4ERROR^7: No Inventory detected - Check starter.lua")
            else
                debugPrint("^6Bridge^7: ^3"..action.."^7["..invName.."] Player("..src..") "..Items[item].label.."("..item..") x"..(amount or 1))
            end
        end
    else
        local amountToAdd = amount or 1
        if isStarted(OXInv) then invName = OXInv
            exports[OXInv]:AddItem(src, item, amountToAdd, info, slot)

        elseif isStarted(QSInv) then invName = QSInv
            exports[QSInv]:AddItem(src, item, amountToAdd, slot, info)

        elseif isStarted(CoreInv) then invName = CoreInv
            exports[CoreInv]:addItem(src, item, amountToAdd, info)

        elseif isStarted(CodeMInv) then invName = CodeMInv
            exports[CodeMInv]:AddItem(src, item, amountToAdd, slot, info)

        elseif isStarted(OrigenInv) then invName = OrigenInv
            exports[OrigenInv]:addItem(src, item, amountToAdd, info, slot)

        elseif isStarted(TgiannInv) then invName = TgiannInv
            exports[TgiannInv]:AddItem(src, item, amountToAdd, slot, info)

        elseif isStarted(JPRInv) then invName = JPRInv
            if Core.Functions.GetPlayer(src).Functions.AddItem(item, amountToAdd, nil, info) then
                if Config.Crafting ~= nil and Config.Crafting.showItemBox then
                    TriggerClientEvent("ps-inventory:client:ItemBox", src, Items[item], "add", amountToAdd)
                end
            end

        elseif isStarted(QBInv) then invName = QBInv
            if Core.Functions.GetPlayer(src).Functions.AddItem(item, amountToAdd, nil, info) then
                TriggerClientEvent((isStarted(QBInv) and QBInvNew and "qb-" or "").."inventory:client:ItemBox", src, Items[item], "add", amountToAdd)
            end

        elseif isStarted(PSInv) then invName = PSInv
            if Core.Functions.GetPlayer(src).Functions.AddItem(item, amountToAdd, nil, info) then
                if Config.Crafting ~= nil and Config.Crafting.showItemBox then
                    TriggerClientEvent("ps-inventory:client:ItemBox", src, Items[item], "add", amountToAdd)
                end
            end

        elseif isStarted(RSGInv) then invName = RSGInv
            if Core.Functions.GetPlayer(src).Functions.AddItem(item, amountToAdd, nil, info) then
                TriggerClientEvent("rsg-inventory:client:ItemBox", src, Items[item], "add", amountToAdd)
            end

        end

        if invName == "" then
            if isStarted(QBExport) or isStarted(QBXExport) then -- if qbcore or qbxcore, just use core functions
                invName = isStarted(QBXExport) and QBXExport or isStarted(QBExport) and QBExport
                Core.Functions.GetPlayer(src).Functions.AddItem(item, amountToAdd, nil, info)

            elseif ESX and isStarted(ESXExport) then  -- if esx then use core functions
                invName = ESX
                ESX.GetPlayerFromId(src).addInventoryItem(item, amountToAdd)
            end
        end

        -- Final check for if inventory was found
        if invName == "" then
            print("^4ERROR^7: No Inventory detected - Check starter.lua")
        else
            debugPrint("^6Bridge^7: ^3"..action.."^7["..invName.."] Player("..src..") "..Items[item].label.."("..item..") x"..(amount or 1))
        end
    end
end)

-------------------------------------------------------------
-- Exploit Protection
-------------------------------------------------------------

--- Warns and kicks a player if they try to remove an item they don't have.
---
--- @param src number The player's source ID.
--- @param item string The item name.
---
--- @usage
--- ```lua
--- dupeWarn(playerId, "health_potion")
--- ```
function dupeWarn(src, item, message)
    local name = getPlayer(src).name
    print(message or "^5DupeWarn^7: "..name.." (^1"..tostring(src).."^7) ^2Tried to remove item '^3"..item.."^7'^2 but it wasn't there^7")
    if not debugMode then
        DropPlayer(src, name.."("..tostring(src)..") kicked by exploit protection")
    end
    print("^5DupeWarn^7: "..name.."(^1"..tostring(src).."^7) ^2Dropped from server - exploit protection^7")
end

-------------------------------------------------------------
-- Tool Durability & Metadata
-------------------------------------------------------------

--- Reduces the durability of a tool by a specified damage amount.
---
--- If durability reaches zero or below, the tool is removed and a break sound is played.
---
--- @param data table Contains:
---   - item (string): The tool's name.
---   - damage (number): The damage % to apply.
---
--- @usage
--- ```lua
--- breakTool({ item = "drill", damage = 10 })
--- ```
function breakTool(data)
    local metadata, slot = getItemMetadata(data.item)
    metadata = metadata or {}
    if not metadata.durability then metadata.durability = 100 end
    metadata.durability -= data.damage
    if metadata.durability <= 0 then
        removeItem(data.item, 1, nil, slot)
        local breakId = GetSoundId()
        PlaySoundFromEntity(breakId, "Drill_Pin_Break", PlayerPedId(), "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
    else
        TriggerServerEvent(getScript()..":server:setItemMetaData", { item = data.item, slot = slot, metadata = metadata })
    end
end


--- Reduces the uses of a tool by a specified damage amount.
---
--- If uses reaches zero or below, the tool is removed and a break sound is played.
---
--- @param data table Contains:
---   - item (string): The tool's name.
---   - damage (number): The damage % to apply.
---
--- @usage
--- ```lua
--- useToolDegrade({ item = "drill", maxUse = 10 })
--- ```
function useToolDegrade(data) -- WIP
    local metadata, slot = getItemMetadata(data.item)
    metadata = metadata or {}
    if not metadata["Uses Left"] then metadata["Uses Left"] = data.maxUse end
    metadata["Uses Left"] -= 1
    if metadata["Uses Left"] <= 0 then
        removeItem(data.item, 1, nil, slot)
        local breakId = GetSoundId()
        PlaySoundFromEntity(breakId, "Drill_Pin_Break", PlayerPedId(), "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
    else
        TriggerServerEvent(getScript()..":server:setItemMetaData", { item = data.item, slot = slot, metadata = metadata })
    end
end

function getItemMetadata(item, slot, src)
    local lowestSlot = 100
    local chosenSlot = slot
    local metadata = {}

    local itemcheck = getPlayerInv(src)

    if chosenSlot then
        for k, v in pairs(itemcheck) do
            if v.name == item and v.slot == chosenSlot then
                lowestSlot = v.slot
                metadata = itemcheck[k].info or itemcheck[k].metadata or {}
                debugPrint("^6Bridge^7: ^2Found metadata for item ^3"..item.." ^2in slot ^3"..lowestSlot.."^7")
            end
        end
    else
        for k, v in pairs(itemcheck) do
            if v.name == item then
                if v.slot <= lowestSlot then
                    lowestSlot = v.slot
                    metadata = itemcheck[k].info or itemcheck[k].metadata or {}
                end
            end
        end
    end
    return metadata, lowestSlot
end

--- Server event handler to set metadata for an item.
---
--- Updates item metadata (e.g. durability) for the player's inventory based on slot.
---
--- @param data table Contains:
---   - item (string): The item name.
---   - slot (number): The inventory slot.
---   - metadata (table): The metadata to set.
---
--- @usage
--- ```lua
--- TriggerServerEvent("script:server:setItemMetaData", { item = "drill", slot = 5, metadata = { durability = 80 } })
--- ```
RegisterNetEvent(getScript()..":server:setItemMetaData", function(data, src)
    local src = src or source
    if isStarted(QBInv) or isStarted(PSInv) or isStarted(RSGInv) or isStarted(JPRInv) then
        --debugPrint(src, data.item, 1, data.slot)
        local Player = Core.Functions.GetPlayer(src)
        Player.PlayerData.items[data.slot].info = data.metadata
        if data.metadata.durability then
            Player.PlayerData.items[data.slot].description = "HP : "..data.metadata.durability
        end
        Player.Functions.SetInventory(Player.PlayerData.items)

    elseif isStarted(OXInv) then
        exports[OXInv]:SetMetadata(src, data.slot, data.metadata)

    elseif isStarted(QSInv) then
        exports[QSInv]:SetItemMetadata(src, data.slot, data.metadata)

    elseif isStarted(CoreInv) then
        exports[CoreInv]:setMetadata(src, data.slot, data.metadata)

    elseif isStarted(CodeMInv) then
        exports[CodeMInv]:SetItemMetadata(src, data.slot, data.metadata)

    elseif isStarted(OrigenInv) then
        exports[OrigenInv]:setMetadata(src, data.slot, data.metadata)

    elseif isStarted(TgiannInv) then
        exports[TgiannInv]:UpdateItemMetadata(src, data.item, data.slot, data.metadata)
    end
end)

-------------------------------------------------------------
-- Random Reward
-------------------------------------------------------------

--- Grants a random reward from a predefined reward pool if the player is eligible.
---
--- Checks if the item qualifies for a reward, removes the item, then calculates a random reward based on rarity.
---
--- @param itemName string The item name to check.
---
---@usage
--- ```lua
--- getRandomReward("gold_ring")
--- ```
function getRandomReward(itemName)
    if Config.Rewards.RewardPool then
        local reward = false
        if type(Config.Rewards.RewardItem) == "string" then
            Config.Rewards.RewardItem = { Config.Rewards.RewardItem }
        end
        for k, v in pairs(Config.Rewards.RewardItem) do
            if v == itemName then
                reward = true
                break
            end
        end
        if reward then
            removeItem(itemName, 1)
            local totalRarity = 0
            for i = 1, #Config.Rewards.RewardPool do
                totalRarity += Config.Rewards.RewardPool[i].rarity
            end
            debugPrint("^6Bridge^7: ^3getRandomReward^7: Total Rarity '"..totalRarity.."'")
            local randomNum = math.random(1, totalRarity)
            debugPrint("^6Bridge^7: ^3getRandomReward^7: Random Number '"..randomNum.."'")
            local currentRarity = 0
            for i = 1, #Config.Rewards.RewardPool do
                currentRarity += Config.Rewards.RewardPool[i].rarity
                if randomNum <= currentRarity then
                    debugPrint("^6Bridge^7: ^3getRandomReward^7: ^2Selected toy ^7'^6"..Config.Rewards.RewardPool[i].item.."^7'")
                    addItem(Config.Rewards.RewardPool[i].item, 1)
                    return
                end
            end
        end
    end
end

-------------------------------------------------------------
-- Carry Capacity Check
-------------------------------------------------------------

--- Checks if a player can carry the specified items based on weight.
---
--- Calculates the current total weight in the player's inventory and determines whether adding the new items would exceed capacity.
---
--- @param itemTable table A table where keys are item names and values are required quantities.
--- @param src number The player's source ID.
--- @return table A table mapping each item to a boolean indicating if it can be carried.
---
--- @usage
--- local carryCheck = canCarry({ ["health_potion"] = 2, ["mana_potion"] = 3 }, playerId)
--- if carryCheck["health_potion"] and carryCheck["mana_potion"] then
---     -- Player can carry items.
--- else
---     -- Notify player.
--- end
function canCarry(itemTable, src)
    local resultTable = {}
    if src then
        if isStarted(OXInv) then
            for k, v in pairs(itemTable) do
                resultTable[k] = exports[OXInv]:CanCarryItem(src, k, v)
            end

        elseif isStarted(QSInv) then
            for k, v in pairs(itemTable) do
                resultTable[k] = exports[QSInv]:CanCarryItem(src, k, v)
            end

        elseif isStarted(CoreInv) then
            for k, v in pairs(itemTable) do
                resultTable[k] = exports[CoreInv]:canCarry(src, k, v)
            end

        elseif isStarted(CodeMInv) then  --- This really needs updating, their docs are confusing..
            local items = getPlayerInv(src)
            local totalWeight = 0
            if not items then return false end
            for _, item in pairs(items) do
                totalWeight += (item.weight * item.amount)
            end
            for k, v in pairs(itemTable) do
                local itemInfo = Items[k]
                if not itemInfo then
                    resultTable[k] = true
                else
                    resultTable[k] = (totalWeight + (itemInfo.weight * v)) <= InventoryWeight
                end
            end

        elseif isStarted(OrigenInv) then
            for k, v in pairs(itemTable) do
                resultTable[k] = exports[OrigenInv]:canCarryItem(src, k, v)
            end

        elseif isStarted(TgiannInv) then
            for k, v in pairs(itemTable) do
                resultTable[k] = exports[TgiannInv]:CanCarryItem(src, k, v)
            end

        elseif isStarted(JPRInv) then
            local items = getPlayerInv(src)
            local totalWeight = 0
            if not items then return false end
            for _, item in pairs(items) do
                totalWeight += (item.weight * item.amount)
            end
            for k, v in pairs(itemTable) do
                local itemInfo = Items[k]
                if not itemInfo then
                    resultTable[k] = true
                else
                    resultTable[k] = (totalWeight + (itemInfo.weight * v)) <= InventoryWeight
                end
            end

        elseif isStarted(QBInv) then
            if QBInvNew then
                for k, v in pairs(itemTable) do
                    resultTable[k] = exports[QBInv]:CanAddItem(src, k, v)
                end
            else
                local items = getPlayerInv(src)
                local totalWeight = 0
                if not items then return false end
                for _, item in pairs(items) do
                    totalWeight += (item.weight * item.amount)
                end
                for k, v in pairs(itemTable) do
                    local itemInfo = Items[k]
                    if not itemInfo then
                        resultTable[k] = true
                    else
                        resultTable[k] = (totalWeight + (itemInfo.weight * v)) <= InventoryWeight
                    end
                end
            end

        elseif isStarted(PSInv) then
            local items = getPlayerInv(src)
            local totalWeight = 0
            if not items then return false end
            for _, item in pairs(items) do
                totalWeight += (item.weight * item.amount)
            end
            for k, v in pairs(itemTable) do
                local itemInfo = Items[k]
                if not itemInfo then
                    resultTable[k] = true
                else
                    resultTable[k] = (totalWeight + (itemInfo.weight * v)) <= InventoryWeight
                end
            end
        end
    end
    return resultTable
end

-------------------------------------------------------------
-- Server Callback Registration
-------------------------------------------------------------
if isServer() then
    createCallback(getScript()..":server:canCarry", function(source, itemTable)
        local result = canCarry(itemTable, source)
        return result
    end)

    createCallback(getScript()..":server:getMaxCarryCraft", function(source, data)
        local src = source
        local item = data.item
        local max = data.max or 100

        local maxCanCarry = 0
        for i = 1, max do
            local checkTable = {
                [item] = i
            }
            local result = canCarry(checkTable, src)
            if result[item] == true then
                maxCanCarry = i
            else
                break
            end
        end
        return maxCanCarry
    end)
end

function getMaxInvWeight()
    local weight = 0
    if isStarted(QBInv) then
        if checkExportExists(QBInv, "GetMaxWeight") then
            return exports[QBInv]:GetMaxWeight()
        else
            return InventoryWeight
        end
    end
    if isStarted(PSInv) then
        if checkExportExists(PSInv, "GetMaxWeight") then
            return exports[PSInv]:GetMaxWeight()
        else
            return InventoryWeight
        end
    end
    if isStarted(RSGInv) then
        if checkExportExists(RSGInv, "GetMaxWeight") then
            return exports[RSGInv]:GetMaxWeight()
        else
            return InventoryWeight
        end
    end
    if isStarted(JPRInv) then
        if checkExportExists(JPRInv, "GetMaxWeight") then
            return exports[JPRInv]:GetMaxWeight()
        else
            return InventoryWeight
        end
    end

    if isStarted(OXInv) then
        return exports[OXInv]:GetPlayerMaxWeight()
    end

    if isStarted(QSInv) then
        return InventoryWeight
    end

    if isStarted(CoreInv) then
        return InventoryWeight
    end

    if isStarted(CodeMInv) then
        return InventoryWeight
    end

    if isStarted(OrigenInv) then
        return InventoryWeight
    end

    if isStarted(TgiannInv) then
        return InventoryWeight
    end

    -- For ESX default inventory (es_extended)
    if ESX and isStarted(ESXExport) then
        return InventoryWeight
    end

    return InventoryWeight
end

function getCurrentInvWeight()
    local weight = 0
    if isStarted(QBInv) or isStarted(PSInv) or isStarted(RSGInv) or isStarted(JPRInv) then
        local itemcheck = Core.Functions.GetPlayerData().items
        for _, v in pairs(itemcheck) do
            weight += ((v.weight * v.amount) or 0)
        end
    end

    if isStarted(OXInv) then
        weight = exports[OXInv]:GetPlayerWeight()
    end

    if isStarted(QSInv) then
        local itemcheck = exports[QSInv]:getUserInventory()
        for _, v in pairs(itemcheck) do
            weight += ((v.weight * v.amount) or 0)
        end
    end

    if isStarted(CoreInv) then
        local itemcheck = exports[CoreInv]:getInventory()
        for _, v in pairs(itemcheck) do
            weight += ((v.weight * v.amount) or 0)
        end
    end

    if isStarted(CodeMInv) then
        local itemcheck = exports[CodeMInv]:GetClientPlayerInventory()
        for _, v in pairs(itemcheck) do
            weight += ((v.weight * v.amount) or 0)
        end
    end

    if isStarted(OrigenInv) then
        local itemcheck = exports[OrigenInv]:getPlayerInventory()
        for _, v in pairs(itemcheck) do
            weight += ((v.weight * v.amount) or 0)
        end
    end

    if isStarted(TgiannInv) then
        local itemcheck = exports[TgiannInv]:GetPlayerItems()
        for _, v in pairs(itemcheck) do
            weight += ((v.weight * v.amount) or 0)
        end
    end

    -- For ESX default inventory (es_extended)
    if ESX and isStarted(ESXExport) then
        local xPlayer = ESX.GetPlayerData() or {}
        if xPlayer.inventory then
            for _, v in pairs(xPlayer.inventory) do
                weight += ((v.weight * v.amount) or 0)
            end
        end
    end

    return weight
end

function hasFreeInventorySlots(slots, src)
    local inv = getPlayerInv(src)
    if (countTable(inv) + slots) <= InventorySlots then
        return true
    end
    return false
end

-------------------------------------------------------------
-- Check Item Existance - return boolean(true,false)
-------------------------------------------------------------

--- checks whether an item exists in your item database
---
--- @param item string The item name.
---
--- @usage
--- ```lua
--- local item = "apple"
--- if doesItemExist(item) then print("item exists") end
--- ```
function doesItemExist(item)
    if not item or item == "" then
        return false
    end
    if not Items or not next(Items) then
        return item.." (Missing)"
    end
    if Items[item] ~= nil then
        return Items[item]
    end
    return false
end


function getItemLabel(item)
    if not item or item == "" then
        return ""
    end
    if not Items or not next(Items) then
        return item.." (Missing)"
    end
    if Items[item] ~= nil then
        return Items[item].label
    end
    return item.." (Missing)"
end