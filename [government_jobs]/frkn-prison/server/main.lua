cacheData = {}

RegisterNetEvent('frkn-prison:getData')
AddEventHandler('frkn-prison:getData', function()
    MySQL.Async.fetchAll("SELECT * FROM frkn_jail", {}, function(result)
        cacheData = {}
        for _, v in pairs(result) do
            local data = {
                id = v.id,
                jailed_by = v.jailed_by,
                player_id = v.player_id,
                duration = v.duration,
                player_name = v.player_name or "Unknown",
                reason = v.reason,
                severity = v.severity,
                respect = v.respect,
                timestamp = v.timestamp,
                status = v.status or 1,
                inventory = v.inventory and json.decode(v.inventory) or {},
                tasks_data = v.tasks_data and json.decode(v.tasks_data) or {},
                end_time = v.end_time or (os.time() * 1000) + (v.duration * 60 * 1000),
                player_photo = v.player_photo or '../html/images/face.png'
            }
            table.insert(cacheData, data)
        end
    end)
end)


RegisterNetEvent('frkn-prison:dataPostClient')
AddEventHandler('frkn-prison:dataPostClient', function()
    TriggerClientEvent('frkn-prison:setClient', -1, cacheData)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        TriggerEvent('frkn-prison:getData')
    end
end)

RegisterServerEvent("frkn-prison:escapeAttempt")
AddEventHandler("frkn-prison:escapeAttempt", function(identifier, timeToAdd) 
    local finalTimeToAdd = 10 

    MySQL.update([[
        UPDATE frkn_jail
        SET duration = duration + ?, 
            respect = GREATEST(respect - 20, 0)
        WHERE player_id = ?
        ORDER BY id DESC
        LIMIT 1
    ]], {finalTimeToAdd, identifier}, function(rowsChanged) 
        if rowsChanged > 0 then
            for i = #cacheData, 1, -1 do
                local record = cacheData[i]
                if record.player_id == identifier then
                    record.duration = record.duration + finalTimeToAdd 
                    record.respect = math.max((record.respect or 0) - 20, 0)
                    break
                end
            end
            TriggerClientEvent('frkn-prison:setClient', -1, cacheData)
        end
    end)
end)

RegisterServerEvent("frkn-prison:jailPlayer")
AddEventHandler("frkn-prison:jailPlayer", function(data)
    local src = source

    local targetIdentifier = data.playerIdentifier
    local targetName = data.playerName
    local jailTime = data.jailTime
    local reason = data.crimeType
    local severity = data.severity
    local notes = data.notes
    local actualTargetPlayerSrc = data.playerId
    local playerPhoto = data.playerPhoto or '../html/images/face.png'

    local jailedByPlayerName = GetPlayerName(src)
    local currentUnixTimestampSeconds = os.time()
    local fullReason = reason .. (notes ~= "" and " (" .. notes .. ")" or "")
    local inventoryData = GetAllItems(actualTargetPlayerSrc)
    local inventoryJson = json.encode(inventoryData or {})


    prisonTasks = {
        { name = "Washing Dishes", currentCount = 0, targetCount = 1, severity = "Low" },
        { name = "Exercise", currentCount = 0, targetCount = 4, severity = "Medium" },
        { name = "Poop Cleaning", currentCount = 0, targetCount = 4, severity = "High" }
    }

    local tasksJson = json.encode(prisonTasks)
    local endTime = os.time() + (jailTime * 60)

    for _, record in ipairs(cacheData) do
        if record.player_id == targetIdentifier and record.status == 1 then
            TriggerClientEvent('frkn-prison:teleportToPrison', actualTargetPlayerSrc)

            for k = 1, #FRKN.General.AddItems do
                AddItem(actualTargetPlayerSrc, FRKN.General.AddItems[k], 1)
            end

            if FRKN.General.ItemSystem then 
                ClearInventory(actualTargetPlayerSrc)
            end

            return
        end
    end

    MySQL.insert('INSERT INTO frkn_jail (jailed_by, player_id, player_name, duration, reason, severity, respect, timestamp, status, inventory, tasks_data,end_time,player_photo) VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), 1, ?, ?,?,?)', {
        jailedByPlayerName,
        targetIdentifier,
        targetName,
        jailTime,
        fullReason,
        severity,
        100,
        inventoryJson,
        tasksJson,
        endTime,
        playerPhoto
    }, function(result, affectedRows, lastInsertId)
        local insertId = lastInsertId or result
        if insertId then
            local newRecord = {
                id = insertId,
                jailed_by = jailedByPlayerName,
                player_id = targetIdentifier,
                player_name = targetName,
                duration = jailTime,
                reason = fullReason,
                severity = severity,
                respect = 100,
                timestamp = currentUnixTimestampSeconds * 1000,
                status = 1,
                inventory = inventoryData or {},
                tasks_data = prisonTasks,
                end_time = endTime,
                player_photo = playerPhoto
            }

            table.insert(cacheData, newRecord)

            TriggerClientEvent('frkn-prison:teleportToPrison', actualTargetPlayerSrc)
    
            for k , v in pairs(FRKN.General.AddItems) do
                AddItem(actualTargetPlayerSrc, k, v)
            end


            if FRKN.General.ItemSystem then 
                ClearInventory(actualTargetPlayerSrc)
            end

            TriggerClientEvent('frkn-prison:setClient', -1, cacheData)
        end
    end)
end)

RegisterNetEvent('frkn-prison:releasePlayer')
AddEventHandler('frkn-prison:releasePlayer', function(playerId)
    local src = source
    local playerIdStr = GetPlayerCid(src)
    local foundRecord = nil

    for i, record in ipairs(cacheData) do
        if record.player_id == playerIdStr and record.status == 1 then
            foundRecord = record
            break
        end
    end

    local recordId = foundRecord.id
    local playerInventory = foundRecord.inventory

    if type(playerInventory) ~= 'table' then
        playerInventory = {}
    end
    MySQL.Async.execute("UPDATE frkn_jail SET status = 0 WHERE id = ?", {recordId}, function(rowsAffected)
        if rowsAffected > 0 then
            foundRecord.status = 0

            local playerSource = GetSourceFromIdentifier(playerIdStr)

            if FRKN.General.ItemSystem then 
                if playerSource and #playerInventory > 0 then
                    for _, itemData in ipairs(playerInventory) do
                        AddItem(playerSource, itemData.name, itemData.amount)
                    end
                end
            end

            TriggerClientEvent('frkn-prison:teleportFromPrison', playerSource)
            TriggerClientEvent('frkn-prison:setClient', -1, cacheData)
        end
    end)
end)



RegisterNetEvent('frkn-prison:releasePrisoner')
AddEventHandler('frkn-prison:releasePrisoner', function(recordId, playerId)
    local src = source
    local playerInventory = {}
    local foundRecord = nil

    local recordId = tonumber(recordId)
    local playerId = tostring(playerId)
    for i, record in ipairs(cacheData) do
        if record.id == recordId and record.player_id == playerId then
            foundRecord = record
            break
        end
    end

    if foundRecord then
        playerInventory = foundRecord.inventory 

        if type(playerInventory) ~= 'table' then
            playerInventory = {}
        end

        MySQL.Async.execute("UPDATE frkn_jail SET status = 0 WHERE id = ?", {recordId}, function(rowsAffected)
            if rowsAffected > 0 then
                foundRecord.status = 0
                
                local playerSource = GetSourceFromIdentifier(playerId)

                if FRKN.General.ItemSystem then 
                    if playerSource and #playerInventory > 0 then
                        for _, itemData in ipairs(playerInventory) do
                            AddItem(playerSource, itemData.name, itemData.amount)
                        end
                    end
                end

                TriggerClientEvent('frkn-prison:teleportFromPrison', playerSource)

                TriggerClientEvent('frkn-prison:setClient', -1, cacheData)
            end
        end)
    end
end)

RegisterNetEvent('frkn-prison:s_requestVisit')
AddEventHandler('frkn-prison:s_requestVisit', function(recordId, playerId)
    local src = source
    local playerSource = GetSourceFromIdentifier(playerId)
    if recordId and playerId then
        TriggerClientEvent('frkn-prison:c_requestVisit', playerSource, {
            sender = GetPlayerName(src),
            senderId = src,
        })
    end
end)

RegisterNetEvent('frkn-prison:s_visitcontrol')
AddEventHandler('frkn-prison:s_visitcontrol', function(visitSenderId,status)
    local src = source
    local playerName = GetPlayerName(src)

    if visitSenderId and visitSenderId > 0 then
        TriggerClientEvent('frkn-prison:c_visitcontrol', visitSenderId,status)

        if status then 
            TriggerClientEvent('frkn-prison:visiteleport',src)
        end

    end
end)

CreateCallback('frkn-prison:characterDetail', function(source, cb, targetId)
    local name, job

    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayer(tonumber(targetId))
        if player then
            local charinfo = player.PlayerData.charinfo
            local jobData = player.PlayerData.job
            name = charinfo.firstname .. " " .. charinfo.lastname
            job = jobData and jobData.label or "Unknown"
            identifier = player.PlayerData.citizenid or player.PlayerData.identifier
        end

    elseif CoreName == "es_extended" then
        local xPlayer = Core.GetPlayerFromId(tonumber(targetId))
        if xPlayer then
            name = xPlayer.getName()
            job = xPlayer.job and xPlayer.job.label or "Unknown"
            identifier = xPlayer.identifier
        end
    end

    cb({
        name = name or "Unknown",
        job = job or "Unknown",
        identifier = identifier or "Unknown"
    })
end)


RegisterNetEvent('frkn-prison:decrementJailDuration')
AddEventHandler('frkn-prison:decrementJailDuration', function(recordId, playerIdentifier)
    MySQL.Async.fetchAll("SELECT id, duration, timestamp, status FROM frkn_jail WHERE id = ? AND player_id = ? AND status = 1 LIMIT 1", {recordId, playerIdentifier}, function(records)
        if records and #records > 0 then
            local record = records[1]
            local currentDuration = tonumber(record.duration)

            if currentDuration > 0 then
                local newDuration = currentDuration - 1
                local newTimestamp = os.time() * 1000

                MySQL.Async.execute("UPDATE frkn_jail SET duration = ?, timestamp = ? WHERE id = ?", {
                    newDuration, newTimestamp, record.id
                }, function(rowsAffected)
                    if rowsAffected > 0 then
                        for i, cachedRec in ipairs(cacheData) do
                            if cachedRec.id == record.id then
                                cachedRec.duration = newDuration
                                cachedRec.timestamp = newTimestamp
                                break
                            end
                        end


                        if newDuration <= 0 then
                            TriggerEvent('frkn-prison:releasePrisoner', record.id, playerIdentifier)
                        end
                    end

                    TriggerClientEvent('frkn-prison:setClient', -1, cacheData)
                end)
            elseif currentDuration <= 0 then
                TriggerEvent('frkn-prison:releasePrisoner', record.id, playerIdentifier)
                TriggerClientEvent('frkn-prison:setClient', -1, cacheData)
            end
        else
            TriggerClientEvent('frkn-prison:setClient', -1, cacheData)
        end
    end)
end)

RegisterServerEvent("frkn-prison:taskCompleted")
AddEventHandler("frkn-prison:taskCompleted", function(taskType)
    local src = source
    local identifier = GetPlayerCid(src)
    if not identifier then return end

    local taskNameMap = {
        dish = "Washing Dishes",
        poop = "Poop Cleaning",
        gym = "Exercise"
    }

    local taskConfig = FRKN.Job.Tasks[taskType]
    if not taskConfig then return end

    local taskName = taskNameMap[taskType]
    local timeToDeduct = taskConfig.decraseTime or 3
    local reward = taskConfig.money or 100

    for i = 1, #cacheData do
        local record = cacheData[i]
        
        if record.player_id == identifier and record.status == 1 then
            local updated = false
            for j = 1, #record.tasks_data do
                local task = record.tasks_data[j]
                if task.name == taskName then
                    if task.currentCount < task.targetCount then
                        task.currentCount = task.currentCount + 1
                        updated = true
                    end
                    break
                end
            end

            if updated then
                local newTasksJson = json.encode(record.tasks_data)

                MySQL.update([[
                    UPDATE frkn_jail
                    SET tasks_data = ?, duration = GREATEST(duration - ?, 0)
                    WHERE id = ?
                ]], {newTasksJson, timeToDeduct, record.id}, function(rowsChanged)
                    if rowsChanged > 0 then
                        record.duration = math.max((record.duration or 0) - timeToDeduct, 0)

                        if taskType ~= "dish" then
                            AddMoney(src, 'bank', reward, taskName .. " Reward")
                        end

                        for _, item in ipairs(taskConfig.rewardItems) do
                            AddItem(src, item.name, item.amount or 1)
                        end

                        TriggerClientEvent("frkn-prison:setClient", -1, cacheData)
                    end
                end)
            end

            break
        end
    end
end)

DiceActivePairs = {}


RegisterNetEvent('frkn-dice:s_switchTurn')
AddEventHandler('frkn-dice:s_switchTurn',function(cPlayer)
    TriggerClientEvent('frkn-dice:c_switchTurn', cPlayer.sendData['id'],cPlayer.sendData)
end)

RegisterServerEvent("frkn-dice:rollResult")
AddEventHandler("frkn-dice:rollResult", function(die1, die2, amount)
    local src = source
    local opponentId = DiceActivePairs[src]?.opponent or nil
    if not opponentId then return end

    TriggerClientEvent("frkn-dice:syncRoll", opponentId, die1, die2)

    DiceActivePairs[src].rolls = DiceActivePairs[src].rolls or {}
    DiceActivePairs[src].rolls[src] = {die1 = die1, die2 = die2}

    DiceActivePairs[opponentId] = DiceActivePairs[opponentId] or {}
    DiceActivePairs[opponentId].rolls = DiceActivePairs[opponentId].rolls or {}
    DiceActivePairs[opponentId].rolls[src] = {die1 = die1, die2 = die2}

    local oppRolls = DiceActivePairs[opponentId].rolls or {}
    local oppData = oppRolls[opponentId]

    if oppData then
        local myData = DiceActivePairs[src].rolls[src]
        local myTotal = myData.die1 + myData.die2
        local oppTotal = oppData.die1 + oppData.die2

        local winner
        if myTotal > oppTotal then winner = src
        elseif oppTotal > myTotal then winner = opponentId
        else winner = -1 end -- draw

        if winner ~= -1 then
            local loser = (winner == src) and opponentId or src

            RemoveMoney(loser, "cash", amount)
            AddMoney(winner, "cash", amount * 2)
        end

        TriggerClientEvent("frkn-dice:gameOver", src, {
            you = src, opponent = opponentId, myRoll = myData, oppRoll = oppData, winner = winner
        })
        TriggerClientEvent("frkn-dice:gameOver", opponentId, {
            you = opponentId, opponent = src, myRoll = oppData, oppRoll = myData, winner = winner
        })

        -- temizle
        DiceActivePairs[src] = nil
        DiceActivePairs[opponentId] = nil
    end
end)



RegisterServerEvent("frkn-dice:sendRequest")
AddEventHandler("frkn-dice:sendRequest", function(targetId, amount)
    local src = source

    if GetPlayerMoney(src,'cash') < tonumber(amount) then
        TriggerClientEvent("frkn-dice:notEnoughMoney", src)
        return
    end

    TriggerClientEvent("frkn-dice:requestReceived", targetId, src, amount)
end)

RegisterServerEvent("frkn-dice:respondRequest")
AddEventHandler("frkn-dice:respondRequest", function(requesterId, accepted,amount)
    local src = source
    if accepted then

        if GetPlayerMoney(src,'cash') < amount then
            TriggerClientEvent("frkn-dice:requestRejected", requesterId,true)
            return
        end

        RemoveMoney(src, "cash", amount)
        RemoveMoney(requesterId, "cash", amount)

        local srcName = GetPlayerIgName(src)
        local requesterName = GetPlayerIgName(requesterId)

        DiceActivePairs[src] = {
            opponent = requesterId,
            name = srcName,
            rolls = {}
        }

        DiceActivePairs[requesterId] = {
            opponent = src,
            name = requesterName,
            rolls = {}
        }

        TriggerClientEvent("frkn-dice:startGame", requesterId, {
            id = src,
            name = srcName
        }, requesterId)

        TriggerClientEvent("frkn-dice:startGame", src, {
            id = requesterId,
            name = requesterName
        }, requesterId)
    else
        TriggerClientEvent("frkn-dice:requestRejected", requesterId,false)
    end
end)


RegisterUsableItem("prison_notebook")

RegisterNetEvent('frkn-prison:noteBookSave', function(data)
    local src = source
    local Player = GetPlayer(src)
    if not Player then return end

    local slot = data.slot
    local content = data.text or ""
    if Inventory == "qb-inventory" or Inventory == "qs-inventory" or Inventory == "ps-inventory" or Inventory == "lj-inventory" then
        local notebookSlot = Player.PlayerData.items[slot]
        if notebookSlot and notebookSlot.name == FRKN.General.PrisonNoteBook then
            notebookSlot.info = notebookSlot.info or {}
            notebookSlot.info.content = content
        end
        Player.Functions.SetInventory(Player.PlayerData.items, true)

    elseif Inventory == "ox_inventory" then
        local notebookItem = exports.ox_inventory:Search(src, slot, FRKN.General.PrisonNoteBook)
        if notebookItem then
            notebookItem.metadata = notebookItem.metadata or {}
            notebookItem.metadata.content = content
            exports.ox_inventory:SetMetadata(src, notebookItem.slot, notebookItem.metadata)
        end
    end
end)

CreateCallback('frkn-prison:deliveredItems', function(source, cb)
    local xPlayer = GetPlayer(source)
    if not xPlayer then return cb(false) end

    local shovelItems = {
        prison_barbellrod = true,
        prison_soapresidue = true,
        prison_plateshard = true
    }

    local cutterItems = {
        prison_rustynail = true,
        prison_tornglove = true
    }

    local function checkItems(requiredItems)
        local missing = {}
        for itemName in pairs(requiredItems) do
            if not HasAnyItem(xPlayer, itemName) then
                table.insert(missing, itemName)
            end
        end
        return #missing == 0, missing
    end

    local function removeItems(requiredItems)
        for itemName in pairs(requiredItems) do
            RemoveItem(source, itemName, 1)
        end
    end

    local shovelReady, shovelMissing = checkItems(shovelItems)
    local cutterReady, cutterMissing = checkItems(cutterItems)

    local crafted = {}

    if shovelReady then
        removeItems(shovelItems)
        AddItem(source, "prison_shovel", 1)
        crafted.shovel = true
    end

    if cutterReady then
        removeItems(cutterItems)
        AddItem(source, "prison_cutter", 1)
        crafted.cutter = true
    end

    if crafted.shovel or crafted.cutter then
        cb(true, crafted)
    else
        cb(false, {
            shovel = {
                success = false,
                missing = shovelMissing
            },
            cutter = {
                success = false,
                missing = cutterMissing
            }
        })
    end
end)


CreateCallback('frkn-prison:ItemControl',function(source, cb, itemName)
    local xPlayer = GetPlayer(source)
    if not xPlayer then return cb(false) end
    local item = HasAnyItem(xPlayer, itemName)
    if item then
        return cb(true)
    else
        return cb(false)
    end
end)

RegisterServerEvent("frkn-prison:allPanelsCut")
AddEventHandler("frkn-prison:allPanelsCut", function()
    TriggerClientEvent("frkn-prison:setBlackout", -1, true)
    TriggerClientEvent("frkn-prison:shutdownElectricity", -1)
end)

RegisterNetEvent('frkn-prison:electricOpen')
AddEventHandler('frkn-prison:electricOpen', function(panelIndex, loc)
    TriggerClientEvent("frkn-prison:setBlackout", -1, false)
end)


RegisterServerEvent("prison:shutdownElectricity")
AddEventHandler("prison:shutdownElectricity", function()
    TriggerClientEvent("prison:shutdownElectricityClient", -1)
end)

RegisterServerEvent("prison:restoreElectricity")
AddEventHandler("prison:restoreElectricity", function()
    TriggerClientEvent("prison:restoreElectricityClient", -1)
end)
