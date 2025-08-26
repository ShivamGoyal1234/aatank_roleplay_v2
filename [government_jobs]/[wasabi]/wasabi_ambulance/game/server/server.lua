-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
if not wsb then return print((Strings.no_wsb):format(GetCurrentResourceName())) end

plyRequests, deadPlayers, DeathInjury, Outfits, PlayerInjury, HospitalBeds, DisconnectedPlayers = {}, {}, {}, {}, {}, {},
    {}

ActiveEMS = {}

CreateThread(function()
    for k, v in pairs(Config.Locations) do
        if v.CheckIn.Enabled then
            for i = 1, #v.CheckIn.HospitalBeds do
                local bed = v.CheckIn.HospitalBeds[i]
                if not HospitalBeds[k] then HospitalBeds[k] = {} end
                HospitalBeds[k][#HospitalBeds[k] + 1] = {
                    coords = bed.coords,
                    heading = bed.heading,
                    inUse = false
                }
            end
        end
    end
    if Config.EnableStandaloneCheckIns then
        for k, v in pairs(Config.StandaloneCheckIns) do
            if v.HospitalBeds then
                if #v.HospitalBeds > 0 then
                    for i = 1, #v.HospitalBeds do
                        local bed = v.HospitalBeds[i]
                        local hospID = 'standaloneCheckIn_' .. k
                        if not HospitalBeds[hospID] then HospitalBeds[hospID] = {} end
                        HospitalBeds[hospID][#HospitalBeds[hospID] + 1] = {
                            coords = bed.coords,
                            heading = bed.heading,
                            inUse = false
                        }
                    end
                end
            end
        end
    end
    if next(HospitalBeds) then
        GlobalState.HospitalBeds = HospitalBeds
    end
end)

wsb.registerCallback('wasabi_ambulance:requestBed', function(source, cb, hospital)
    local src = source
    if not HospitalBeds[hospital] then return cb(false) end
    for _, bedData in pairs(HospitalBeds[hospital]) do
        if not bedData.inUse then
            bedData.inUse = src
            return cb(bedData)
        end
    end
    cb(false)
end)

wsb.registerCallback('wasabi_ambulance:checkPreviousVitals', function(source, cb)
    local src = source
    local identifier = wsb.getIdentifier(src)
    if not identifier then return cb(false) end
    cb(DisconnectedPlayers[identifier] or false)
end)

RegisterNetEvent('wasabi_ambulance:setBedInUse', function(hospital)
    local src = source
    if not HospitalBeds[hospital] then return end
    for _, bedData in pairs(HospitalBeds[hospital]) do
        if bedData.inUse == src then
            bedData.inUse = false
            return true
        end
    end
    return false
end)


function ClearPlayerBeds(id)
    if not HospitalBeds or not next(HospitalBeds) then return end
    for _, beds in pairs(HospitalBeds) do
        for _, bedData in pairs(beds) do
            if bedData.inUse and bedData.inUse == id then
                bedData.inUse = false
            end
        end
    end
end

local function sendEMSCount(src)
    local count = 0
    if ActiveEMS and next(ActiveEMS) then
        for identifier, active in pairs(ActiveEMS) do
            if active then
                count = count + 1
            end
        end
    end

    TriggerClientEvent('wasabi_ambulance:setEMSOnline', src or -1, count)
end

AddEventHandler('playerDropped', function()
    local src = source
    local identifier = wsb.getIdentifier(src)
    local health = GetEntityHealth(GetPlayerPed(src))
    if identifier then
        DisconnectedPlayers[identifier] = {}
        if health and health < 200 then
            DisconnectedPlayers[identifier].health = health
        end
        if PlayerInjury[src] then
            DisconnectedPlayers[identifier].injuries = PlayerInjury[src]
        end
        if not DisconnectedPlayers[identifier].health and not DisconnectedPlayers[identifier].injuries then
            DisconnectedPlayers[identifier] = nil
        end

        if ActiveEMS[identifier] then
            ActiveEMS[identifier] = false
            sendEMSCount()
        end
    end
    if deadPlayers[src] then 
        TriggerEvent('wasabi_ambulance:logCombat', src) 
        deadPlayers[src] = nil end
    if DeathInjury[src] then DeathInjury[src] = nil end
    if PlayerInjury[src] then PlayerInjury[src] = nil end
    if plyRequests[src] then
        plyRequests[src] = nil
        TriggerClientEvent('wasabi_ambulance:syncRequests', -1, plyRequests, true)
    end
    ClearPlayerBeds(src)
end)

addCommas = function(n)
    return tostring(math.floor(n)):reverse():gsub("(%d%d%d)", "%1,")
        :gsub(",(%-?)$", "%1"):reverse()
end

local sqlSetDeathStatus = function(id, isDead)
    if wsb.framework == 'qb' then return end
    local xPlayer = wsb.getPlayer(id)
    if isDead then
        isDead = 1
    else
        isDead = 0
    end
    MySQL.Async.execute('UPDATE users SET is_dead = @is_dead WHERE identifier = @identifier', {
        ['@is_dead'] = isDead,
        ['@identifier'] = xPlayer.identifier
    })
end

RegisterNetEvent('wasabi_ambulance:setDeathStatus', function(isDead, sql, characterSwitch)
    local src = source
    deadPlayers[src] = isDead
    Player(src).state:set('dead', isDead, true)
    Player(src).state:set('isDead', isDead, true) -- ESX Compatibility
    if not isDead then
        DeathInjury[src] = nil
    end
    PlayerInjury[src] = nil
    if not isDead and plyRequests[src] then
        plyRequests[src] = nil
        TriggerClientEvent('wasabi_ambulance:syncRequests', -1, plyRequests, true)
    end

    local bool = false
    if isDead then bool = true end

    if Config.AntiCombatLog.enabled and wsb.framework == 'esx' then
        if sql then sqlSetDeathStatus(src, bool) end
    end

    if wsb.framework == 'qb' and not characterSwitch then
        local Player = wsb.getPlayer(src)
        Player.Functions.SetMetaData('isdead', bool)
        Player.Functions.SetMetaData('inlaststand', bool)
    end

    if Config.MuteDeadPlayers then
        MuteDeadPlayer(src, isDead)
    end
end)

local injurySyncTimer = {}
RegisterNetEvent('wasabi_ambulance:injurySync', function(injury)
    local src = source
    if not injurySyncTimer[source] then injurySyncTimer[source] = 0 end
    if GetGameTimer() - injurySyncTimer[source] < 500 and not injury then return end
    injurySyncTimer[source] = GetGameTimer()
    if not injury then
        PlayerInjury[src] = nil
        DeathInjury[src] = nil
        return
    end

    local name = wsb.getName(src)
    if not name then name = Strings.no_name end

    if injury.location then
        if PlayerInjury[src] then PlayerInjury[src] = nil end
        DeathInjury[src] = {
            injury = injury.injury,
            location = injury.location,
            name = name
        }
        return
    end

    PlayerInjury[src] = {
        injury = injury,
        name = name
    }
end)

RegisterNetEvent('wasabi_ambulance:onPlayerDistress', function()
    local src = source
    local name = wsb.getName(src)
    plyRequests[src] = name
    TriggerClientEvent('wasabi_ambulance:syncRequests', -1, plyRequests, false)
end)

local firstTrigger = false
RegisterNetEvent('wasabi_ambulance:requestSync', function(restartTrigger)
    if restartTrigger and firstTrigger then return end
    firstTrigger = true
    local src = source
    local hasJob = wsb.hasGroup(src, Config.ambulanceJobs)
    if hasJob then
        TriggerClientEvent('wasabi_ambulance:syncRequests', src, plyRequests, true)
        TriggerClientEvent('wasabi_ambulance:syncStretchers', src, ActiveStretchers)
    end
    local identifier = wsb.getIdentifier(src)
    if not identifier then return end

    if not hasJob and ActiveEMS[identifier] then
        ActiveEMS[identifier] = false
        sendEMSCount()
        return
    elseif hasJob then
        local player = wsb.getPlayer(src)
        if player and player.PlayerData and player.PlayerData.job then
            if not player.PlayerData.job.onduty then
                ActiveEMS[identifier] = false
                sendEMSCount()
                return
            end
        end
        ActiveEMS[identifier] = true
        sendEMSCount()
    else
        sendEMSCount(src)
    end
end)

RegisterNetEvent('wasabi_ambulance:revivePlayer', function(targetId)
    if not deadPlayers[targetId] then return end
    local src = source
    if wsb.hasItem(src, Config.EMSItems.revive.item) > 0 then
        if Config.EMSItems.revive.remove then
            wsb.removeItem(src, Config.EMSItems.revive.item, 1)
        end
        if Config.ReviveRewards.enabled then
            local reward = 0
            if not DeathInjury[targetId] or not DeathInjury[targetId].injury then
                reward = Config.ReviveRewards.no_injury
            else
                reward = Config.ReviveRewards[DeathInjury[targetId].injury] or Config.ReviveRewards.no_injury
            end
            if reward > 0 then
                wsb.addMoney(src, Config.ReviveRewards.paymentAccount, reward)
                TriggerClientEvent('wasabi_bridge:notify', src, Strings.player_successful_revive,
                    (Strings.player_successful_revive_reward_desc):format(reward), 'success')
            else
                TriggerClientEvent('wasabi_bridge:notify', src, Strings.player_successful_revive,
                    Strings.player_successful_revive_desc, 'success')
            end
        else
            TriggerClientEvent('wasabi_bridge:notify', src, Strings.player_successful_revive,
                Strings.player_successful_revive_desc, 'success')
        end
        TriggerClientEvent('wasabi_ambulance:revivePlayer', targetId,
            DeathInjury[targetId] and DeathInjury[targetId].injury or false)
    end
end)

RegisterNetEvent('wasabi_ambulance:healPlayer', function(targetId)
    local src = source
    local authorized = false
    if Config?.policeCanTreat?.enabled and wsb.hasGroup(src, Config.policeCanTreat.jobs) then
        authorized = true
    end
    if targetId == src then
        if wsb.hasItem(src, Config.EMSItems.heal.item) > 0 then
            wsb.removeItem(src, Config.EMSItems.heal.item, 1)
            local trainedProfessional = wsb.hasGroup(src, Config.ambulanceJob) or authorized or false
            TriggerClientEvent('wasabi_ambulance:heal', src, trainedProfessional, true)
            TriggerClientEvent('wasabi_bridge:notify', src, Strings.used_meditkit, Strings.used_medikit_desc, 'success')
        end
    elseif wsb.hasGroup(src, Config.ambulanceJobs or Config.ambulanceJob) or authorized then
        if wsb.hasItem(src, Config.EMSItems.heal.item) > 0 then
            if Config.EMSItems.heal.remove then
                wsb.removeItem(src, Config.EMSItems.heal.item, 1)
            end
            TriggerClientEvent('wasabi_bridge:notify', src, Strings.player_successful_heal,
                Strings.player_successful_heal_desc, 'success')
            TriggerClientEvent('wasabi_ambulance:heal', targetId, true, false)
        end
    end
end)

RegisterNetEvent('wasabi_ambulance:treatPlayer', function(target, injury)
    local src = source
    if target > 0 then
        local authorized = false
        if Config?.policeCanTreat?.enabled and wsb.hasGroup(src, Config.policeCanTreat.jobs) then
            authorized = true
        end
        if wsb.hasGroup(src, Config.ambulanceJobs or Config.ambulanceJob) or authorized then
            if wsb.hasItem(src, Config.TreatmentItems[injury]) > 0 then
                wsb.removeItem(src, Config.TreatmentItems[injury], 1)
                if DeathInjury[target] then DeathInjury[target] = nil end
                if PlayerInjury[target] and PlayerInjury[target].injury and next(PlayerInjury[target].injury) then
                    local plyInjury = {}
                    for k, v in pairs(PlayerInjury[target].injury) do
                        if v.type ~= injury then
                            plyInjury[k] = v
                        end
                    end
                    PlayerInjury[target].injury = plyInjury
                    TriggerClientEvent('wasabi_ambulance:syncInjury', target, plyInjury, true)
                end
                TriggerClientEvent('wasabi_bridge:notify', src, Strings.player_treated, Strings.player_treated_desc,
                    'success')
            end
        end
    end
end)

RegisterNetEvent('wasabi_ambulance:sedatePlayer', function(target)
    local src = source
    if target > 0 then
        local authorized = false
        if Config?.policeCanTreat?.enabled then
            if wsb.hasGroup(src, Config.policeCanTreat.jobs) then
                authorized = true
            end
        end
        if wsb.hasGroup(src, Config.ambulanceJobs or Config.ambulanceJob) or authorized then
            if wsb.hasItem(src, Config.EMSItems.sedate.item) > 0 then
                if Config.EMSItems.sedate.remove then
                    wsb.removeItem(src, Config.EMSItems.sedate.item, 1)
                end
                TriggerClientEvent('wasabi_bridge:notify', target, Strings.target_sedated, Strings.target_sedated_desc,
                    'inform')
                TriggerClientEvent('wasabi_bridge:notify', src, Strings.target_sedated,
                    Strings.player_successful_sedate_desc, 'success')
                TriggerClientEvent('wasabi_ambulance:sedate', target)
            end
        end
    end
end)

RegisterNetEvent('wasabi_ambulance:removeObj', function(netObj)
    TriggerClientEvent('wasabi_ambulance:syncObj', -1, netObj)
end)

RegisterNetEvent('wasabi_ambulance:putInVehicle', function(target, bypass)
    local src = source
    if not target or target < 1 then return end
    if bypass then
        TriggerClientEvent('wasabi_ambulance:intoVehicle', target)
        return
    end
    local authorized = false
    if Config?.policeCanTreat?.enabled then
        if wsb.hasGroup(src, Config.policeCanTreat.jobs) then
            authorized = true
        end
    end
    if wsb.hasGroup(src, Config.ambulanceJobs or Config.ambulanceJob) or authorized then
        TriggerClientEvent('wasabi_ambulance:intoVehicle', target)
    end
end)

RegisterNetEvent('wasabi_ambulance:restock', function(data)
    local src = source
    if wsb.hasGroup(src, Config.ambulanceJobs or Config.ambulanceJob) then
        if not data.price then
            wsb.addItem(src, data.item, 1)
        else
            if wsb.getPlayerAccountFunds(src, 'money') < data.price then
                TriggerClientEvent('wasabi_bridge:notify', src, Strings.not_enough_funds, Strings.not_enough_funds_desc,
                    'error')
            else
                wsb.removeMoney(src, 'money', data.price)
                wsb.addItem(src, data.item, 1)
            end
        end
    end
end)

RegisterNetEvent('wasabi_ambulance:setBagState', function(netId)
    Entity(NetworkGetEntityFromNetworkId(netId)).state:set('useable', true, true)
end)


wsb.registerCallback('wasabi_ambulance:getIdentifier', function(source, cb)
    local src = source
    local identifier = wsb.getIdentifier(src)
    if not identifier then return cb(false) end
    cb(identifier)
end)

wsb.registerCallback('wasabi_ambulance:checkDeath', function(source, cb)
    local src = source
    local player = wsb.getPlayer(src)
    if wsb.framework == 'qb' then
        if not player then return cb(false) end
        cb(player.PlayerData.metadata['isdead'])
    else
        local isDead
        local response = MySQL.query.await('SELECT `is_dead` FROM `users` WHERE `identifier` = ?', {
            player.identifier
        })
        if response and response[1] then
            isDead = response[1].is_dead or false
        end
        while isDead == '' do Wait(0) end
        cb(isDead)
    end
end)


RegisterNetEvent('wasabi_ambulance:tryStandaloneRevive', function(locationID)
    local src = source
    local locationData = Config.StandaloneCheckIns[locationID]
    if not locationData then return end
    local cost, account = locationData.Cost, locationData.PayAccount
    if cost then
        local funds = wsb.getPlayerAccountFunds(src, account)
        if funds < cost then
            TriggerClientEvent('wasabi_bridge:notify', src, Strings.not_enough_funds, Strings.not_enough_funds_desc,
                'error')
        else
            wsb.removeMoney(src, account, cost)
            TriggerClientEvent('wasabi_ambulance:standaloneCheckIn', src, locationID)
        end
    else
        TriggerClientEvent('wasabi_ambulance:standaloneCheckIn', src, locationID)
    end
end)

RegisterServerEvent('wasabi_ambulance:tryRevive', function(hospital)
    local src = source
    local hospitalData = Config.Locations[hospital].CheckIn
    if not hospitalData then return end
    local coords = hospitalData.Target.enabled and hospitalData.Target.coords or hospitalData.Coords
    if #(GetEntityCoords(GetPlayerPed(src)) - coords) > 30.0 then return end
    local max, cost, account = hospitalData.MaxOnDuty, hospitalData.Cost, hospitalData.PayAccount
    local players = GetPlayers()
    local ems = 0
    for i = 1, #players, 1 do
        local player = tonumber(players[i])
        if wsb.hasGroup(player, Config.ambulanceJobs or Config.ambulanceJob) then
            if wsb.framework == 'qb' then
                local qbPlayer = wsb.getPlayer(player)
                if qbPlayer and qbPlayer.PlayerData.job.onduty then ems = ems + 1 end
            else
                ems = ems + 1
            end
        end
    end
    if max then
        if ems >= max then
            TriggerClientEvent('wasabi_bridge:notify', src, Strings.max_ems, Strings.max_ems_desc, 'error')
            return
        end
    end
    if cost then
        local success = ChargePlayer(src, account, cost, hospitalData.PayHospital)
        if success then
            TriggerClientEvent('wasabi_ambulance:hospitalCheckIn', src, hospital)
        end
    else
        TriggerClientEvent('wasabi_ambulance:hospitalCheckIn', src, hospital)
    end
end)

RegisterNetEvent('wasabi_ambulance:chargeForRevive', function(PayHospital)
    ChargePlayer(source, Config.ChargeForRevive.payAccount, Config.ChargeForRevive.cost, PayHospital)
end)

wsb.registerCallback('wasabi_ambulance:getDeathPos', function(_source, cb, targetId)
    local coords = GetEntityCoords(GetPlayerPed(targetId))
    cb(vector3(coords.x, coords.y, coords.z))
end)


wsb.registerCallback('wasabi_ambulance:isPlayerDead', function(_source, cb, target)
    if deadPlayers[target] or Player(target).state.laststand then
        return cb(true)
    else
        return cb(false)
    end
end)

wsb.registerCallback('wasabi_ambulance:diagnosePlayer', function(_source, cb, target)
    if deadPlayers[target] and DeathInjury[target] then
        return cb(DeathInjury[target])
    end
    if PlayerInjury[target] then return cb(PlayerInjury[target]) end
    cb(false)
end)

wsb.registerCallback('wasabi_ambulance:itemCheck', function(source, cb, item)
    local src = source
    cb(wsb.hasItem(src, item))
end)

wsb.registerCallback('wasabi_ambulance:removeItem', function(source, cb, item)
    local src = source
    if wsb.hasItem(src, item) then
        wsb.removeItem(src, item, 1)
        return cb(true)
    end
    cb(false)
end)

wsb.registerCallback('wasabi_ambulance:gItem', function(source, cb, item)
    local src = source
    local authorized = false
    if Config?.policeCanTreat?.enabled then
        if wsb.hasGroup(src, Config.policeCanTreat.jobs) then
            authorized = true
        end
    end
    if wsb.hasGroup(src, Config.ambulanceJobs or Config.ambulanceJob) or authorized then
        wsb.addItem(src, item, 1)
        return cb(true)
    else
        return cb(false)
    end
end)


RegisterNetEvent('wasabi_ambulance:billPlayer', function(target, amount)
    local src = source
    local player = wsb.getPlayer(target)
    local hasJob, _grade = wsb.hasGroup(src, Config.ambulanceJobs or Config.ambulanceJob)
    if player then
        local identifier = wsb.getIdentifier(player)
        exports.pefcl:createInvoice(src,
            {
                to = player.getName(),
                toIdentifier = identifier,
                from = 'Hospital',
                fromIdentifier = nil,
                amount = amount,
                message =
                'Medical Bills',
                receiverAccountIdentifier = hasJob,
                expiresAt = nil
            })
    end
end)

RegisterNetEvent('wasabi_ambulance:svToggleDuty', function()
    local jobs = Config.ambulanceJobs or Config.ambulanceJob
    if wsb.framework == 'esx' then
        if type(jobs) == 'table' then
            local jobLength = #jobs
            for i = 1, jobLength do
                jobs[jobLength + i] = 'off' .. jobs[i]
            end
        else
            jobs = {jobs, 'off' .. jobs }
        end
    end
    local hasJob, grade = wsb.hasGroup(source, jobs)
    if not hasJob or not grade then return end

    local onDuty = wsb.toggleDuty(source, hasJob, grade)
    if not onDuty then return end
    if onDuty == 'on' then
        TriggerClientEvent('wasabi_bridge:notify', source, Strings.on_duty, Strings.on_duty_desc, 'success')
        TriggerEvent('wasabi_ambulance:addEMSToGPS', source)
    else
        TriggerEvent('wasabi_ambulance:removeEMSFromGPS', source)
        TriggerClientEvent('wasabi_bridge:notify', source, Strings.off_duty, Strings.off_duty_desc, 'error')
    end
end)

RegisterNetEvent('wasabi_ambulance:setEntityState', function(netId, state, value)
    Entity(NetworkGetEntityFromNetworkId(netId)).state:set(state, value, true)
end)

RegisterNetEvent('wasabi_ambulance:saveOutfit', function(outfit)
    local src = source
    local identifier = wsb.getIdentifier(src)
    if not identifier then return end
    if Outfits[identifier] then return end
    Outfits[identifier] = outfit
end)

RegisterNetEvent('wasabi_ambulance:hospitalBedSync', function(beds)
    HospitalBeds = beds
    GlobalState.HospitalBeds = beds
end)

wsb.registerCallback('wasabi_ambulance:requestCivilianOutfit', function(source, cb)
    local src = source
    local identifier = wsb.getIdentifier(src)
    if not identifier then return end
    if not Outfits[identifier] then return cb(false) end
    local outfit = Outfits[identifier]
    Outfits[identifier] = nil
    cb(outfit)
end)

wsb.registerCallback('wasabi_ambulance:registerStash', function(source, cb, data)
    local station = data.station
    local location = Config.Locations[station][data.location]
    if not Config.Locations[station] or not location then return end
    local coords = location.target.enabled and location.target.coords or location.coords
    if #(GetEntityCoords(GetPlayerPed(source)) - coords) > 8 then return end
    if not wsb.hasGroup(source, Config.ambulanceJobs or Config.ambulanceJob) then return end
    TriggerEvent('wasabi_bridge:registerStash', data)
    return true
end)

wsb.registerUsableItem(Config.EMSItems.medbag, function(source)
    local src = source
    wsb.removeItem(src, Config.EMSItems.medbag, 1)
    TriggerClientEvent('wasabi_ambulance:useMedbag', src)
end)

wsb.registerUsableItem(Config.EMSItems.revive.item, function(source)
    local src = source
    TriggerClientEvent('wasabi_ambulance:reviveTarget', src)
end)

wsb.registerUsableItem(Config.EMSItems.heal.item, function(source)
    local src = source
    TriggerClientEvent('wasabi_ambulance:healTarget', src)
end)

wsb.registerUsableItem(Config.EMSItems.sedate.item, function(source)
    local src = source
    TriggerClientEvent('wasabi_ambulance:useSedative', src)
end)

if Config.Bandages.enabled then
    wsb.registerUsableItem(Config.Bandages.item, function(source)
        local src = source
        TriggerClientEvent('wasabi_ambulance:useBandage', src)
    end)

    RegisterNetEvent('wasabi_ambulance:useBandage', function(target)
        wsb.removeItem(target, Config.Bandages.item, 1)
    end)
end

for id, hospital in pairs(Config.Locations) do
    if hospital.MedicalSupplies.Enabled then
        local items = hospital.MedicalSupplies.Supplies
        for _, item in pairs(items) do
            item.name = item.name or item.item
            item.amount = item.amount or 99
        end

        local jobLock = {}
        for i = 1, #Config.ambulanceJobs do
            local job = Config.ambulanceJobs[i]
            jobLock[job] = 0
        end
        TriggerEvent('wasabi_bridge:registerShop', {
            identifier = id .. '_medsupplies',
            groups = jobLock,
            name = Strings.request_supplies_target,
            inventory = items,
            location = { hospital.MedicalSupplies.Coords },
        })
    end
end

CreateThread(function()
    for k, v in pairs(Config.TreatmentItems) do
        wsb.registerUsableItem(v, function(source)
            local src = source
            TriggerClientEvent('wasabi_ambulance:treatPatient', src, k)
        end)
    end
end)

if Config.EnablePainPills then
    CreateThread(function()
        for k, v in pairs(Config.PainPills) do
            wsb.registerUsableItem(k, function(source)
                local src = source
                TriggerClientEvent('wasabi_ambulance:intakePills', src, k, v)
            end)
        end
    end)
end

exports('clearPlayerInjury', function(target)
    if not target then return end
    TriggerClientEvent('wasabi_ambulance:clearPlayerInjury', target)
end)

exports('diagnosePlayer', function(target)
    if not target then return false end
    if DeathInjury[target] then return DeathInjury[target] end
    if PlayerInjury[target] then return PlayerInjury[target] end
    return false
end)
