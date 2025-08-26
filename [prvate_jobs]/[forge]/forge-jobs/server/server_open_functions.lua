--[[
    Server Utility Functions
    This file contains utility functions used by the server-side scripts
    for the Forge Jobs resource. These functions handle database operations,
    player data management, inventory interactions, and framework compatibility.
]]--

--[[
    IncreasePlayerMissionProgress - Increases a player's progress on a specific mission
    @param playerId - The server ID of the player
    @param jobName - The name of the job (e.g., "Mining", "Hunting")
    @param missionName - The identifier of the mission to update
    @param amount - The amount to increase the progress by
]]--
function IncreasePlayerMissionProgress(playerId, jobName, missionName, amount)
    local playerIdentifier = GetPlayerIdentifier(playerId)
    if #SqlFunc("fetchAll", "SELECT * FROM forge_jobs_missions WHERE job_name = ? and mission = ?", {jobName, missionName}) == 0 then return end
    SqlFunc("execute", "UPDATE forge_jobs_missions SET progress = progress + ? WHERE identifier = ? AND job_name = ? AND mission = ?", {amount, playerIdentifier, jobName, missionName})
    TriggerClientEvent("forge-jobs:client:UpdateMissionProgress", playerId, jobName, missionName, amount)
end

--[[
    IncreasePlayerXP - Adds experience points to a player for a specific job
    Handles level-up notifications and max level checks
    @param playerId - The server ID of the player
    @param jobName - The name of the job to add XP for
    @param xp - The amount of XP to add
]]--
function IncreasePlayerXP(playerId, jobName, xp)
    if GetPlayerLevel(playerId, jobName) >= Config.Levels.MaxLevel then
        return
    end
    local levelBefore = GetPlayerLevel(playerId, jobName)
    SqlFunc("execute", "UPDATE forge_jobs_xp SET xp = xp + ? WHERE identifier = ? AND job_name = ?",
            {xp, GetPlayerIdentifier(playerId), jobName})
    local levelAfter = GetPlayerLevelAndXp(playerId, jobName)
    if levelAfter[1] > levelBefore and levelAfter[1] == Config.Levels.MaxLevel then
        Notification(playerId, Config.Locales[Config.Locale].notifications.MaxLevelReached)
    elseif levelAfter[1] > levelBefore then
        Notification(playerId, Config.Locales[Config.Locale].notifications.LevelUp:gsub("{int}", levelAfter[1]))
    end
    TriggerClientEvent("forge-jobs:client:UpdateXp", playerId, jobName, levelAfter[1], levelAfter[2])
end

-- Utilities

--[[
    Notification - Sends a notification message to a specific player
    Triggers a client event which then uses the appropriate framework notification.
    @param playerId - The server ID of the player to notify
    @param message - The message to display
    @param type (optional for QB) - The type of notification (e.g., 'success', 'error', 'inform')
    @param duration (optional for QB) - Duration in milliseconds
]]--
function Notification(playerId, message, type, duration)
    TriggerClientEvent('forge-jobs:client:showNotification', playerId, message, type, duration)
end

--[[
    GetPlayerMoney - Retrieves the amount of money a player has in a specific account
    Compatible with ESX and QB frameworks
    @param source - The server ID of the player
    @param account - The account type to check ("cash", "bank", "black_money", etc.)
    @returns - The amount of money in the specified account
]]--
function GetPlayerMoney(source, account)
    if Config.Framework == "ESX" then
        if account == "cash" then account = "money" end
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.getAccount(account).money
    elseif Config.Framework == "QB" or Config.Framework == "QBOX" then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        return xPlayer.PlayerData.money[account]
    end
end

--[[
    AddPlayerMoney - Adds money to a player's specific account
    Compatible with ESX and QB frameworks
    @param source - The server ID of the player
    @param moneyType - The account type to add money to ("cash", "bank", etc.)
    @param amount - The amount of money to add
]]--
function AddPlayerMoney(source, moneyType, amount)
    if Config.Framework == "ESX" then
        if moneyType == "cash" then moneyType = "money" end
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addAccountMoney(moneyType, amount)
    elseif Config.Framework == "QB" or Config.Framework == "QBOX" then
        moneyType = "bank"
        local xPlayer = QBCore.Functions.GetPlayer(source)
        xPlayer.Functions.AddMoney(moneyType, amount)
    end
end

--[[
    RemovePlayerMoney - Removes money from a player's specific account
    Compatible with ESX and QB frameworks
    @param source - The server ID of the player
    @param moneyType - The account type to remove money from ("cash", "bank", etc.)
    @param amount - The amount of money to remove
]]--
function RemovePlayerMoney(source, moneyType, amount)
    if Config.Framework == "ESX" then
        if moneyType == "cash" then moneyType = "money" end
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeAccountMoney(moneyType, amount)
    elseif Config.Framework == "QB" or Config.Framework == "QBOX" then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        xPlayer.Functions.RemoveMoney(moneyType, amount)
    end
end

--[[
    GetItemCount - Gets the count of a specific item in a player's inventory
    Compatible with ESX, QB frameworks and different inventory systems
    @param source - The server ID of the player
    @param itemName - The name of the item to count
    @returns - The quantity of the specified item, 0 if none found
]]--
function GetItemCount(source, itemName)
    ----------------------------------------------------------
    -- ESX
    ----------------------------------------------------------
    if Config.Framework == "ESX" then
        -- Quasar inventory uses server export only
        if Config.Inventory == "quasar-inventory" then
            return exports['qs-inventory']:GetItemTotalAmount(source, itemName) or 0
        end

        -- ESX native / ox_inventory
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return 0 end

        -- ESX can hold several stacks of the same item – sum them
        local total = 0
        for _, itm in pairs(xPlayer.getInventory() or {}) do
            if itm.name == itemName then
                total = total + (itm.count or 0)
            end
        end
        return total
    end

    ----------------------------------------------------------
    -- QB / QBOX
    ----------------------------------------------------------
    if Config.Framework == "QB" or Config.Framework == "QBOX" then
        if Config.Inventory == "quasar-inventory" then
            return exports['qs-inventory']:GetItemTotalAmount(source, itemName) or 0
        elseif Config.Inventory == "ox_inventory" then
            return exports.ox_inventory:GetItemCount(source, itemName)
        else                                    -- qb-inventory
            local Player = QBCore.Functions.GetPlayer(source)
            if not Player then return 0 end
            local item = Player.Functions.GetItemByName(itemName)
            return item and item.amount or 0
        end
    end

    return 0
end

--[[
    HasEnoughInventorySpace - Checks if a player has enough inventory space for an item
    Compatible with ESX, QB frameworks and different inventory systems
    @param source - The server ID of the player
    @param itemName - The name of the item to check space for
    @param count - The quantity of the item
    @returns - true if player has enough space, false otherwise
]]--
function HasEnoughInventorySpace(source, itemName, count)
    if Config.Framework == "ESX" then
        if Config.Inventory == "quasar-inventory" then
            return exports['qs-inventory']:CanCarryItem(source, itemName, count)
        end
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return false end
        return xPlayer.canCarryItem(itemName, count)
    elseif Config.Framework == "QB" or Config.Framework == "QBOX" then
        if Config.Inventory == "ox_inventory" then
            -- Use ox_inventory export
            return exports.ox_inventory:CanCarryItem(source, itemName, count)
        elseif Config.Inventory == "quasar-inventory" then
            -- Use qs-inventory export
            return exports['qs-inventory']:CanCarryItem(source, itemName, count)
        else
            -- Use original QB logic (assuming qb-inventory or similar)
            -- Note: qb-inventory export might need the player object loaded, ensure QBCore is ready
            local Player = QBCore.Functions.GetPlayer(source)
            if not Player then return false end -- Ensure player is loaded
            local canCarry = exports['qb-inventory']:CanAddItem(source, itemName, count) -- Assuming source ID is sufficient
            return canCarry -- qb-inventory export returns true/false directly
        end
    end
    return false -- Default return
end

--[[
    GiveItem - Gives an item to a player if they have space in their inventory
    Compatible with ESX, QB frameworks and different inventory systems
    Sends notification if inventory is full
    @param source - The server ID of the player
    @param itemName - The name of the item to give
    @param count - The quantity of the item to give
    @returns - true if item was successfully given, false if inventory was full
]]--
function GiveItem(source, itemName, count)
    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return false end
        if xPlayer.canCarryItem(itemName, count) then
            xPlayer.addInventoryItem(itemName, count)
            return true
        else
            Notification(source, Config.Locales[Config.Locale].notifications.InventoryFull)
            return false
        end
    elseif Config.Framework == "QB" or Config.Framework == "QBOX" then
        if Config.Inventory == "ox_inventory" then
            -- Use ox_inventory exports
            local canCarry = exports.ox_inventory:CanCarryItem(source, itemName, count)
            if canCarry then
                local success, _ = exports.ox_inventory:AddItem(source, itemName, count)
                return success -- Return true if item added successfully
            else
                Notification(source, Config.Locales[Config.Locale].notifications.InventoryFull)
                return false
            end
        elseif Config.Inventory == "quasar-inventory" then
            -- Use qs-inventory exports
            local canCarry = exports['qs-inventory']:CanCarryItem(source, itemName, count)
            if canCarry then
                -- qs-inventory AddItem doesn't seem to return success state based on docs, assume it works if CanCarryItem is true
                exports['qs-inventory']:AddItem(source, itemName, count)
                return true
            else
                Notification(source, Config.Locales[Config.Locale].notifications.InventoryFull)
                return false
            end
        else
            -- Use original QB logic (assuming qb-inventory or similar)
            local xPlayer = QBCore.Functions.GetPlayer(source)
            if not xPlayer then return false end
            local canCarry = exports['qb-inventory']:CanAddItem(source, itemName, count) -- Check again if needed? Original code did.
            if canCarry then
                local added = xPlayer.Functions.AddItem(itemName, count) -- qb additem returns true/false
                if not added then -- Handle potential failure even if CanAddItem was true
                     Notification(source, Config.Locales[Config.Locale].notifications.InventoryFull .. " (AddItem failed)") -- More specific error
                     return false
                end
                return true
            else
                Notification(source, Config.Locales[Config.Locale].notifications.InventoryFull)
                return false
            end
        end
    end
    return false -- Default return
end

--[[
    RemoveItem - Removes an item from a player's inventory
    Compatible with ESX, QB frameworks and different inventory systems
    @param source - The server ID of the player
    @param itemName - The name of the item to remove
    @param count - The quantity of the item to remove
    @returns - true if item was successfully removed, false otherwise (e.g., not enough items)
]]--
function RemoveItem(source, itemName, count)
    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return false end
        -- ESX removeInventoryItem doesn't typically return success state easily, assume it works if player exists
        xPlayer.removeInventoryItem(itemName, count)
        return true
    elseif Config.Framework == "QB" or Config.Framework == "QBOX" then
        if Config.Inventory == "ox_inventory" then
            -- Use ox_inventory export
            local success, _ = exports.ox_inventory:RemoveItem(source, itemName, count)
            return success
        elseif Config.Inventory == "quasar-inventory" then
            -- Use qs-inventory export
            -- qs-inventory RemoveItem doesn't seem to return success state based on docs, assume it works
            exports['qs-inventory']:RemoveItem(source, itemName, count)
            return true -- Assuming success as qs export doesn't specify return
        else
            -- Use original QB logic (assuming qb-inventory or similar)
            local xPlayer = QBCore.Functions.GetPlayer(source)
            if not xPlayer then return false end
            local removed = xPlayer.Functions.RemoveItem(itemName, count) -- qb removeitem returns true/false
            return removed
        end
    end
    return false -- Default return
end

--[[
    GetPlayerIdentifier - Gets the unique identifier for a player
    Compatible with ESX (license) and QB (citizenid) frameworks
    @param source - The server ID of the player
    @returns - The player's unique identifier string
]]--
function GetPlayerIdentifier(source)
    local identifier = ""
    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(source)
        identifier = xPlayer.getIdentifier()
    elseif Config.Framework == "QB" or Config.Framework == "QBOX" then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        identifier = xPlayer.PlayerData.citizenid
    end

    return identifier
end

--[[
    RandomFloat - Generates a random float number between lower and greater bounds
    @param lower - Lower bound of the random number
    @param greater - Upper bound of the random number
    @returns - Random float between lower and greater
]]--
function RandomFloat(lower, greater)
    return lower + math.random()  * (greater - lower);
end

--[[
    ShuffleArray - Randomizes the order of elements in an array
    Uses the Fisher-Yates shuffle algorithm
    @param array - The array to shuffle
    @returns - A new array with the same elements in random order
]]--
function ShuffleArray(array)
    if #array == 1 then return array end

    local shuffled = {}
    local index = 1

    -- Copy the original array to avoid modifying it
    for i = 1, #array do
        shuffled[i] = array[i]
    end

    -- Fisher-Yates shuffle algorithm
    for i = #shuffled, 2, -1 do
        local j = math.random(1, i)
        shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
    end

    return shuffled
end

--[[
    SqlFunc - A universal SQL function that works with different database systems
    Supports MYSQL-ASYNC, GHMATTIMYSQL, and OXMYSQL
    @param type - The type of SQL operation ("fetchAll" or "execute")
    @param query - The SQL query string
    @param var - Variables to use in the SQL query
    @returns - The result of the SQL operation
]]--
function SqlFunc(type,query,var)
    local plugin = Config.SQL
    local wait = promise.new()
    if type == 'fetchAll' and plugin == 'MYSQL-ASYNC' then
        MySQL.Async.fetchAll(query, var, function(result)
            wait:resolve(result)
        end)
    end
    if type == 'execute' and plugin == 'MYSQL-ASYNC' then
        MySQL.Async.execute(query, var, function(result)
            wait:resolve(result)
        end)
    end
    if type == 'execute' and plugin == 'GHMATTIMYSQL' then
        exports['ghmattimysql']:execute(query, var, function(result)
            wait:resolve(result)
        end)
    end
    if type == 'fetchAll' and plugin == 'GHMATTIMYSQL' then
        exports.ghmattimysql:execute(query, var, function(result)
            wait:resolve(result)
        end)
    end
    if type == 'execute' and plugin == 'OXMYSQL' then
        exports.oxmysql:execute(query, var, function(result)
            wait:resolve(result)
        end)
    end
    if type == 'fetchAll' and plugin == 'OXMYSQL' then
        exports['oxmysql']:fetch(query, var, function(result)
            wait:resolve(result)
        end)
    end
    return Citizen.Await(wait)
end

--[[
    SendWebhook - Sends a webhook message to Discord
    @param url - The Discord webhook URL
    @param title - The title of the webhook message
    @param description - The description/content of the message
    @param src - The player source ID
    @returns - None, performs HTTP request to Discord
]]--
function SendWebhook(url, title, description, src)
    -- Skip if webhook URL is not configured
    if not url or url == "" or url == "https://discord.com/api/webhooks/" then
        if Config.Debug then
            print("[Forge-Jobs] Webhook skipped: URL not configured")
        end
        return
    end
    
    -- Get player information
    local playerName = Config.Webhook.EnablePlayerName and (GetPlayerName(src) or "Unknown Player") or "Hidden"
    local identifiers = GetIdentifiers(src)
    local identifier = GetPlayerIdentifier(src) or "Unknown"
    local steamId = identifiers[1] or ""
    local discordId = identifiers[2] or ""
    
    -- Format Discord mention - only if enabled and we have a valid Discord ID
    local discordMention = ""
    if Config.Webhook.EnableDiscordMention then
        if discordId and discordId ~= "" and discordId ~= "0" then
            discordMention = "<@" .. discordId .. ">"
        else
            discordMention = "Not linked"
        end
    else
        discordMention = "Hidden"
    end
    
    -- Format Steam profile link - only if enabled and we have a valid Steam ID
    local steamLink = ""
    if Config.Webhook.EnableSteamLink then
        if steamId and steamId ~= "" and steamId ~= "0" then
            steamLink = "[" .. steamId .. "](https://steamcommunity.com/profiles/" .. steamId .. ")"
        else
            steamLink = "Not available"
        end
    else
        steamLink = "Hidden"
    end
    
    -- Build message components
    local messageComponents = {
        "📋 **Action:** " .. description,
        "🆔 **Player ID:** " .. tostring(src)
    }
    
    -- Add optional components based on configuration
    if Config.Webhook.EnablePlayerName then
        table.insert(messageComponents, "👤 **Player Name:** " .. playerName)
    end
    
    table.insert(messageComponents, "🔗 **Identifier:** `" .. identifier .. "`")
    
    if Config.Webhook.EnableDiscordMention then
        table.insert(messageComponents, "💬 **Discord:** " .. discordMention)
    end
    
    if Config.Webhook.EnableSteamLink then
        table.insert(messageComponents, "🎮 **Steam:** " .. steamLink)
    end
    
    -- Create the final message
    local message = table.concat(messageComponents, "\n")
    
    -- Create the embed structure for Discord webhook
    local embed = {
        ["color"] = Config.Webhook.Color,
        ["title"] = "🔔 " .. Config.Webhook.Title,
        ["description"] = message,
        ["author"] = {
            ["name"] = Config.Webhook.Author,
            ["icon_url"] = Config.Webhook.IconUrl
        },
        ["footer"] = {
            ["text"] = "Forge Jobs System • " .. os.date("%Y.%m.%d"),
            ["icon_url"] = Config.Webhook.IconUrl
        }
    }
    
    -- Add optional thumbnail
    if Config.Webhook.EnableThumbnail and Config.Webhook.ThumbnailUrl ~= "" then
        embed["thumbnail"] = {
            ["url"] = Config.Webhook.ThumbnailUrl
        }
    end
    
    -- Add optional timestamp
    if Config.Webhook.EnableTimestamp then
        embed["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
    end
    
    -- Send the HTTP request to Discord with error handling
    PerformHttpRequest(url, function(err, text, headers)
        local debugEnabled = Config.Debug or Config.Webhook.EnableDebugLogs
        if debugEnabled then
            if err ~= 200 then
                print("[Forge-Jobs] Webhook Error: " .. tostring(err) .. " - " .. tostring(text))
            else
                print("[Forge-Jobs] Webhook sent successfully for player " .. playerName .. " (ID: " .. src .. ")")
            end
        end
    end, 'POST', json.encode({embeds = {embed}}), { ['Content-Type'] = 'application/json' })
end

--[[
    GetIdentifiers - Retrieves player identifiers (Steam ID and Discord ID)
    @param playerId - The player source ID
    @returns - Table containing Steam ID and Discord ID
]]--
function GetIdentifiers(playerId)
    local steamid = ""
    local discord = ""
    local license = ""
    
    -- Get all player identifiers
    local playerIdentifiers = GetPlayerIdentifiers(playerId)
    
    if not playerIdentifiers then
        if Config.Debug then
            print("[Forge-Jobs] Warning: No identifiers found for player " .. tostring(playerId))
        end
        return {"", ""}
    end

    -- Loop through all player identifiers
    for _, identifier in pairs(playerIdentifiers) do
        if identifier then
            -- Extract Steam ID and convert from hex to decimal
            if string.find(identifier, "steam:") then
                steamid = identifier:gsub("steam:", "")
                -- Convert hex to decimal for Steam64 ID
                local steamHex = steamid
                local steamDecimal = tonumber(steamHex, 16)
                if steamDecimal then
                    steamid = tostring(steamDecimal)
                else
                    steamid = steamHex -- Fallback to original if conversion fails
                end
                
            -- Extract Discord ID without prefix
            elseif string.find(identifier, "discord:") then
                discord = identifier:gsub("discord:", "")
                -- Validate Discord ID (should be numeric and 17-19 digits)
                if not string.match(discord, "^%d+$") or string.len(discord) < 17 or string.len(discord) > 19 then
                    if Config.Debug then
                        print("[Forge-Jobs] Warning: Invalid Discord ID format for player " .. tostring(playerId) .. ": " .. discord)
                    end
                    discord = ""
                end
                
            -- Store license as backup identifier
            elseif string.find(identifier, "license:") then
                license = identifier:gsub("license:", "")
            end
        end
    end
    
    -- Debug information
    if Config.Debug then
        print("[Forge-Jobs] Player " .. tostring(playerId) .. " identifiers - Steam: " .. (steamid ~= "" and steamid or "Not found") .. ", Discord: " .. (discord ~= "" and discord or "Not found"))
    end

    -- Return Steam ID and Discord ID
    return {steamid, discord}
end

--[[
    GetItemLabel - Gets the display label of an item based on its name
    @param itemName - The name of the item
    @returns - The display label of the item
]]--
function GetItemLabel(itemName)
    -- Attempt to get item label based on the framework
    if Config.Framework == "ESX" then
        local item = ESX.GetItemLabel(itemName)
        if item and item ~= "" then
            return item
        end
    elseif Config.Framework == "QB" or Config.Framework == "QBOX" then
        local item = QBCore.Shared.Items[itemName]
        if item and item.label then
            return item.label
        end
    end
    
    -- If we can't get the label from the framework, look for it in our sellable items
    for jobName, jobItems in pairs(Config.SellShop.ItemsForSale) do
        if jobItems[itemName] then
            -- Use the image filename without extension as fallback label
            local image = jobItems[itemName].image
            if image and image ~= "" then
                -- Remove file extension and convert underscores to spaces
                local label = image:gsub("%.png$", ""):gsub("%.jpg$", ""):gsub("_", " ")
                -- Capitalize first letter of each word
                label = label:gsub("(%a)([%w_']*)", function(first, rest) return first:upper()..rest end)
                return label
            end
        end
    end
    
    -- Last resort: make the item name more presentable
    local label = itemName:gsub("_", " ")
    -- Capitalize first letter of each word
    label = label:gsub("(%a)([%w_']*)", function(first, rest) return first:upper()..rest end)
    
    return label
end


--[[
    HasJob - Checks if a player has a specific job
    Works with different frameworks (ESX, QB, QBOX)
    For QB/QBOX also checks if player is on duty if applicable
    @param source - The server ID of the player
    @param jobName - The name of the job to check
    @returns - true if player has the job (and is on duty if applicable), false otherwise
]]--
function HasJob(source, activity)
    local cfg = Config.Jobs[activity]
    if not cfg then return false end

    local restrict = cfg.JobRestrictions
    if not restrict or not restrict.enabled then
        return true
    end

    local allowed = {}
    for _, j in ipairs(restrict.allowedJobs or {}) do
        allowed[string.lower(j)] = true
    end

    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(source)
        local job = xPlayer and string.lower(xPlayer.job.name or "")
        return allowed[job] or false

    elseif Config.Framework == "QB" or Config.Framework == "QBOX" then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if not xPlayer then return false end
        local job = string.lower(xPlayer.PlayerData.job.name or "")
        if not allowed[job] then return false end
        if xPlayer.PlayerData.job.onduty ~= nil then
            return xPlayer.PlayerData.job.onduty
        end
        return true
    end

    return false
end

-- HUNTING OPEN FUNCTIONS

--[[
    HandleAnimalKilled - Server-side function called when an animal is killed by the player
    This function can be modified to add custom logic when animals are killed.
    @param source - The player source ID who killed the animal
    @param netPed - The network ID of the killed animal
]]--
function HandleAnimalKilled(source, netPed)
    local animalPed = NetworkGetEntityFromNetworkId(netPed)
    local rewardAmountToSet
    local playerToolItemName = playersHuntingTool[source] and GetToolByName(playersHuntingTool[source]) and GetToolByName(playersHuntingTool[source]).item or "nil"

    -- Check if animal was killed with correct weapon and player has hunting tool
    if GetPedCauseOfDeath(animalPed) ~= tonumber(GetHashKey(Config.Jobs["Hunting"].WeaponModel)) or playersHuntingTool[source] == nil then
        rewardAmountToSet = math.random(Config.Tools[2][1].minReward, Config.Tools[2][1].maxReward)
        if Config.Debug then
            print(("[FORGE_JOBS_DEBUG] AnimalKilled - Src: %s, AnimalNetID: %s, CauseOfDeathHash: %s, PlayerEquippedTool: %s, ConfigWeaponHash: %s. Setting MINIMAL reward: %s"):format(source, netPed, GetPedCauseOfDeath(animalPed), playerToolItemName, tonumber(GetHashKey(Config.Jobs["Hunting"].WeaponModel)), rewardAmountToSet))
        end
        huntingAnimalsReward[animalPed] = rewardAmountToSet
        return 
    end

    -- Only give XP if the correct weapon was used
    IncreasePlayerXP(source, "Hunting", math.random(Config.Jobs["Hunting"].XPActions.AnimalHunted[1], Config.Jobs["Hunting"].XPActions.AnimalHunted[2]))
    
    local tool = GetToolByName(playersHuntingTool[source])
    if tool then
        rewardAmountToSet = math.random(tool.minReward, tool.maxReward)
        if Config.Debug then
            print(("[FORGE_JOBS_DEBUG] AnimalKilled - Src: %s, AnimalNetID: %s, CauseOfDeathHash: %s, PlayerEquippedTool: %s, ConfigWeaponHash: %s. Setting REGULAR reward: %s (Tool: %s)"):format(source, netPed, GetPedCauseOfDeath(animalPed), playerToolItemName, tonumber(GetHashKey(Config.Jobs["Hunting"].WeaponModel)), rewardAmountToSet, tool.item))
        end
    else
        rewardAmountToSet = math.random(Config.Tools[2][1].minReward, Config.Tools[2][1].maxReward) 
        if Config.Debug then
            print(("[FORGE_JOBS_DEBUG] AnimalKilled - Src: %s, AnimalNetID: %s, PlayerEquippedTool: %s was not found by GetToolByName. Setting MINIMAL reward: %s"):format(source, netPed, playersHuntingTool[source] or "nil", rewardAmountToSet))
        end
    end
    huntingAnimalsReward[animalPed] = rewardAmountToSet
    IncreasePlayerMissionProgress(source, "Hunting", "hunt_animal", 1)
    
    -- You can add custom logic here:
    -- - Custom notifications
    -- - Additional rewards
    -- - Integration with other systems
    -- - Custom webhook logging
    
    -- Example of custom additions:
    -- Notification(source, "You successfully hunted an animal!")
    -- GiveItem(source, "bonus_item", 1)
end

--[[
    HandleAnimalSkinned - Server-side function called when an animal is skinned by the player
    This function can be modified to add custom logic when animals are skinned.
    @param source - The player source ID who skinned the animal
    @param netPed - The network ID of the skinned animal
]]--
function HandleAnimalSkinned(source, netPed)
    IncreasePlayerXP(source, "Hunting", math.random(Config.Jobs["Hunting"].XPActions.AnimalSkinned[1], Config.Jobs["Hunting"].XPActions.AnimalSkinned[2]))
    local animalPed = NetworkGetEntityFromNetworkId(netPed)
    local reward = huntingAnimalsReward[animalPed]

    if Config.Debug then
        print(("[FORGE_JOBS_DEBUG] SkinAnimal - Src: %s, AnimalNetID: %s, RewardFound: %s, ItemToGive: %s, CountFromReward: %s"):format(source, netPed, reward or "nil", Config.Jobs["Hunting"].Item1, reward or "nil"))
    end
    
    local giveItemSuccess = GiveItem(source, Config.Jobs["Hunting"].Item1, reward) 
    
    if Config.Debug then
        print(("[FORGE_JOBS_DEBUG] SkinAnimal - GiveItem call for (Item: %s, Count: %s) Result: %s for Src: %s"):format(Config.Jobs["Hunting"].Item1, reward or "nil", tostring(giveItemSuccess), source))
    end

    DeleteEntity(animalPed)
    huntingAnimalsReward[animalPed] = nil
    
    if not giveItemSuccess then 
        if Config.Debug then
            print(("[FORGE_JOBS_DEBUG] SkinAnimal - Src: %s, AnimalNetID: %s - Returning early because GiveItem failed or reward was nil/zero."):format(source, netPed))
        end
        return 
    end
    
    local text = Config.Locales[Config.Locale].notifications.ItemReceived:gsub("{string}", GetItemLabel(Config.Jobs["Hunting"].Item1))
    text = text:gsub("{int}", reward)
    Notification(source, text)
    IncreasePlayerMissionProgress(source, "Hunting", "skin_animal", 1)
    
    TriggerEvent("forge-jobs:JobActionServer", "Hunting", 1)
    
    -- You can add custom logic here:
    -- - Additional item rewards
    -- - Custom notifications
    -- - Integration with other systems
    -- - Custom webhook logging
    
    -- Example of custom additions:
    -- GiveItem(source, "animal_hide", 1)
    -- Notification(source, "You obtained animal hide!")
end

--[[
    DisableInventoryServer - Blocks inventory access from server side
    Universal function that works with ox_inventory, qb-inventory, and quasar-inventory
    @param source - The server ID of the player
]]--
function DisableInventoryServer(source)
    if Config.Inventory == "ox_inventory" then
        -- Use ox_inventory state bag system from server
        local player = Player(source)
        player.state.invBusy = true
    elseif Config.Inventory == "qb-inventory" then
        -- Use qb-inventory state bag system from server
        local player = Player(source)
        player.state.inv_busy = true
    elseif Config.Inventory == "quasar-inventory" then
        -- Trigger client to disable quasar-inventory (no server export available)
        TriggerClientEvent('forge-jobs:client:disableInventory', source)
    end
    
    if Config.Debug then
        print("[Forge-Jobs] Inventory disabled for player " .. source .. " (" .. Config.Inventory .. ")")
    end
end

--[[
    EnableInventoryServer - Restores inventory access from server side
    Universal function that works with ox_inventory, qb-inventory, and quasar-inventory
    @param source - The server ID of the player
]]--
function EnableInventoryServer(source)
    if Config.Inventory == "ox_inventory" then
        -- Restore ox_inventory access from server
        local player = Player(source)
        player.state.invBusy = false
    elseif Config.Inventory == "qb-inventory" then
        -- Restore qb-inventory access from server
        local player = Player(source)
        player.state.inv_busy = false
    elseif Config.Inventory == "quasar-inventory" then
        -- Trigger client to enable quasar-inventory (no server export available)
        TriggerClientEvent('forge-jobs:client:enableInventory', source)
    end
    
    if Config.Debug then
        print("[Forge-Jobs] Inventory enabled for player " .. source .. " (" .. Config.Inventory .. ")")
    end
end
