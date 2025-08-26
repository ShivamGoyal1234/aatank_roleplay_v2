cacheData = {}
playerData = {}
tasks = false

pedImage = nil

RegisterNetEvent('frkn-prison:setClient')
AddEventHandler('frkn-prison:setClient',function(data)
    cacheData = data
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    playerData = GetPlayerData()
    TriggerServerEvent('frkn-prison:dataPostClient')
    initTarget()
    initTargetElectricPanels()
    InitDigSpotTarget()
    -- initDishTarget()
end)

RegisterNetEvent('esx:playerLoaded', function()
    playerData = GetPlayerData()
    TriggerServerEvent('frkn-prison:dataPostClient')
    initTarget()
    initTargetElectricPanels()
    InitDigSpotTarget()
    -- initDishTarget()
end)

Citizen.CreateThread(function()
    while true do
         Citizen.Wait(1000)
         if NetworkIsPlayerActive(PlayerId()) then 
            playerData = GetPlayerData()
            TriggerServerEvent('frkn-prison:dataPostClient')
            initTarget()
            initTargetElectricPanels()
            InitDigSpotTarget()
            -- initDishTarget()
            break
        end 
    end
end)


RegisterNetEvent('frkn-prison:teleportFromPrison')
AddEventHandler('frkn-prison:teleportFromPrison', function()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed,  FRKN.General.ReleaseTeleportCoords.from.x , FRKN.General.ReleaseTeleportCoords.from.y , FRKN.General.ReleaseTeleportCoords.from.z, false, false, false, false)
    SetEntityHeading(playerPed, FRKN.General.ReleaseTeleportCoords.fromHeading)
end)

RegisterNetEvent('frkn-prison:teleportToPrison')
AddEventHandler('frkn-prison:teleportToPrison', function()
    local playerPed = PlayerPedId()
    zoneControl = true
    TriggerEvent("frkn-prison:applyPrisonOutfit")
    SetEntityCoords(playerPed, FRKN.General.ReleaseTeleportCoords.to.x, FRKN.General.ReleaseTeleportCoords.to.y, FRKN.General.ReleaseTeleportCoords.to.z, false, false, false, false)
    SetEntityHeading(playerPed, FRKN.General.ReleaseTeleportCoords.toHeading)
end)



function GetNearbyPlayers(radius, cb)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local nearbyPlayers = {}
    local activePlayers = GetActivePlayers()
    local totalToCheck = 0
    local completed = 0

    for _, playerId in ipairs(activePlayers) do
        local targetPed = GetPlayerPed(playerId)
        local targetCoords = GetEntityCoords(targetPed)
        local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, targetCoords.x, targetCoords.y, targetCoords.z)

        if distance <= radius and playerId ~= PlayerId() then
            local serverId = GetPlayerServerId(playerId)
            totalToCheck = totalToCheck + 1

            TriggerCallback("frkn-prison:characterDetail", function(data)
                -- local photo = GetMugShotBase64(targetPed, true)
                table.insert(nearbyPlayers, {
                    id = serverId,
                    name = data.name or "Unknown",
                    job = data.job or "Unknown",
                    identifier = data.identifier or "Unknown",
                    -- photo = photo or "../html/images/face.png"
                })

                completed = completed + 1
                if completed == totalToCheck then
                    cb(nearbyPlayers)
                end
            end, serverId)
        end
    end

    if totalToCheck == 0 then
        cb({})
    end
end



RegisterCommand('jailmenu', function()
    if not isAuthorized() then return end

    fixTimestamps()

    GetNearbyPlayers(15.0, function(nearbyPlayers)
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "openJailMenu",
            playerData = playerData,
            cacheData = cacheData,
            nearbyPlayers = nearbyPlayers
        })
    end)
end)

RegisterCommand('jailList', function()
    if not isAuthorized() then return end

    fixTimestamps()

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openJailList",
        cacheData = cacheData
    })
end)

function isAuthorized()
    local job = GetPlayerJob()
    for _, allowedJob in pairs(FRKN.General.Job) do
        if job == allowedJob then
            return true
        end
    end
    return false
end

function fixTimestamps()
    for _, rec in ipairs(cacheData or {}) do
        if rec.timestamp ~= rec.timestamp then
            rec.timestamp = nil
        end
    end
end


RegisterNUICallback('jailPlayer', function(data, cb)

    local clientId = GetPlayerFromServerId(data.playerId)
    local targetPed = GetPlayerPed(clientId)
    local photo = GetMugShotBase64(targetPed, false)

    local playerPhoto = photo
    data.playerPhoto = playerPhoto

    local playerIdentifier = data.playerIdentifier
    local playerId = data.playerId
    local playerName = data.playerName
    local crimeType = data.crimeType
    local severity = data.severity
    local jailTime = data.jailTime
    local notes = data.notes
    local playerPhoto = photo
    TriggerServerEvent("frkn-prison:jailPlayer", data)

    Notify(Lang:t("success.jail_success"))

    cb({ success = true, message = "Jail işlemi başlatıldı." })
end)

RegisterNetEvent("frkn-prison:applyPrisonOutfit")
AddEventHandler("frkn-prison:applyPrisonOutfit", function()

    if not FRKN.General.PrisonOutfit.enable then
        return
    end

    local ped = PlayerPedId()
    local gender = IsPedMale(ped) and "male" or "female"
    local outfit = FRKN.General.PrisonOutfit[gender]

    if not outfit then return end

    for k, v in pairs(outfit) do
        if k == "mask" then
            SetPedComponentVariation(ped, 1, v.item, v.texture, 2)
        elseif k == "arms" then
            SetPedComponentVariation(ped, 3, v.item, v.texture, 2)
        elseif k == "pants" then
            SetPedComponentVariation(ped, 4, v.item, v.texture, 2)
        elseif k == "shoes" then
            SetPedComponentVariation(ped, 6, v.item, v.texture, 2)
        elseif k == "accessories" then
            SetPedComponentVariation(ped, 7, v.item, v.texture, 2)
        elseif k == "t-shirt" then
            SetPedComponentVariation(ped, 8, v.item, v.texture, 2)
        elseif k == "torso2" then
            SetPedComponentVariation(ped, 11, v.item, v.texture, 2)
        end
    end
end)



function IsPedMale(ped)
    local model = GetEntityModel(ped)
    return model == GetHashKey("mp_m_freemode_01")
end


RegisterCommand("testj", function()
    
    local playerId = GetPlayerServerId(PlayerId())

    TriggerServerEvent("frkn-prison:jailPlayer", {
        playerIdentifier = "ABP07892", 
        playerId = playerId,
        playerName = "Test User",
        crimeType = "Theft",
        severity = "Medium",
        jailTime = 1000, 
        notes = "Stole a police vehicle",
        -- playerPhoto = GetMugShotBase64(playerId)
    })

    TriggerEvent("frkn-prison:applyPrisonOutfit")
end)

-- RegisterCommand('releasePrisoner', function(soource, args, rawCommand)
--     TriggerServerEvent('frkn-prison:releasePrisoner',args[1],"RVB28897")
-- end)


RegisterNUICallback('releasePrisoner',function(data,cb)
    local recordId = data.prisonerId
    local playerId = data.playerId

    TriggerServerEvent("frkn-prison:releasePrisoner", recordId, playerId)

    Notify(Lang:t("success.prisoner_released"))

    Wait(500)

    SendNUIMessage({
        action = "openJailList",
        cacheData = cacheData
    })

    -- cb({ success = true, message = "Prisoner released successfully." })
end)

RegisterNUICallback('closeJailUI', function(data, cb)
    SetNuiFocus(false, false)
end)

PrisonZone = PolyZone:Create(FRKN.General.PrisonZoneCoords, {
    name = "prison_zone",
    minZ = FRKN.General.PrisonZoneMinZ,
    maxZ = FRKN.General.PrisonZoneMaxZ,
    debugPoly = false
})


local wasInZone = true
local lastGameTimerCheck = 0
local addedTargetZones = false
globalJailRecord = {}

CreateThread(function()
    while true do
        Wait(1000)

        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local isInZone = PrisonZone:isPointInside(coords)

        local playerIdentifier = GetPlayerIdentifier()
        local playerJailRecords = {}

        for _, v in pairs(cacheData) do
            if v.player_id == playerIdentifier then
                table.insert(playerJailRecords, v)
            end
        end

        for _, playerJailRecord in pairs(playerJailRecords) do
            if playerJailRecord and playerJailRecord.status == 1 then
                tasks = true

                for _, v in pairs(playerJailRecord.tasks_data or {}) do
                    if v.name == 'Washing Dishes' then
                        if v.currentCount <= 0 and not addedTargetZones then
                            print("Adding target zones for washing dishes")
                            initDishTarget()
                            addedTargetZones = true
                        end
                    end
                end

                globalJailRecord = playerJailRecord
                -- print("Player is in prison with ID: " , json.encode(playerJailRecord.id))

                local remainingMinutes = tonumber(playerJailRecord.duration) or 0
                local totalSeconds = remainingMinutes * 60

                local hours = math.floor(totalSeconds / 3600)
                local minutes = math.floor((totalSeconds % 3600) / 60)
                local seconds = totalSeconds % 60

                local currentTimeInMs = GetGameTimer()

                SendNUIMessage({
                    action = "activejailmenu",
                    pData = {
                        id = playerJailRecord.id,
                        tasks_data = playerJailRecord.tasks_data,
                        duration = remainingMinutes,
                        total_seconds = currentTimeInMs - lastGameTimerCheck,
                        time = string.format("%02d:%02d:%02d", hours, minutes, seconds),
                    }
                })

                if (currentTimeInMs - lastGameTimerCheck) >= 60000 then
                    TriggerServerEvent("frkn-prison:decrementJailDuration", playerJailRecord.id, playerIdentifier)
                    lastGameTimerCheck = currentTimeInMs
                end

                if not isInZone and wasInZone and zoneControl then
                    SetEntityCoords(playerPed, FRKN.General.ReleaseTeleportCoords.to.x, FRKN.General.ReleaseTeleportCoords.to.y, FRKN.General.ReleaseTeleportCoords.to.z, false, false, false, false)
                    SetEntityHeading(playerPed, FRKN.General.ReleaseTeleportCoords.toHeading)

                    TriggerServerEvent("frkn-prison:escapeAttempt", playerIdentifier)

                    Notify(Lang:t("error.escape_prison"))

                    wasInZone = false
                elseif isInZone and not wasInZone then
                    wasInZone = true
                end

                goto continueLoop
            end
        end

        wasInZone = true
        lastGameTimerCheck = GetGameTimer()

        SendNUIMessage({
            action = "closeJailMenu"
        })

        ::continueLoop::
    end
end)


local id = 0
local MugshotsCache = {}
local Answers = {}

function GetMugShotBase64(Ped, Transparent)
    if not Ped then return "../html/images/face.png" end
    id = id + 1
    local Handle = RegisterPedheadshot(Ped)
    local timer = 2000
    while ((not Handle or not IsPedheadshotReady(Handle) or not IsPedheadshotValid(Handle)) and timer > 0) do
        Citizen.Wait(10)
        timer = timer - 10
    end
    local MugShotTxd = 'none'
    if IsPedheadshotReady(Handle) and IsPedheadshotValid(Handle) then
        MugshotsCache[id] = Handle
        MugShotTxd = GetPedheadshotTxdString(Handle)
    end
    if MugShotTxd == 'none' then
        return "../html/images/face.png"
    end
    SendNUIMessage({
        action = 'convert',
        pMugShotTxd = MugShotTxd,
        removeImageBackGround = Transparent or false,
        id = id,
    })
    local p = promise.new()
    Answers[id] = p
    return Citizen.Await(p)
end

exports("GetMugShotBase64", GetMugShotBase64)

RegisterNUICallback('Answer', function(data)
    if MugshotsCache[data.Id] then
        UnregisterPedheadshot(MugshotsCache[data.Id])
        MugshotsCache[data.Id] = nil
    end
    Answers[data.Id]:resolve(data.Answer)
    Answers[data.Id] = nil
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    for k,v in pairs(MugshotsCache) do
        UnregisterPedheadshot(v)
    end
    MugshotsCache = {}
    id = 0
end)
