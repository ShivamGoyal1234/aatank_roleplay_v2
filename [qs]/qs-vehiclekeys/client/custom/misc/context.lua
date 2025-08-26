-- Check if Context Menu is enabled in the configuration
if not Config.Context then return end

function OpenMainMenu()
    local elements = {}

    table.insert(elements, {
        title = Lang("VEHICLEKEYS_MENU_CLEAN_KEYS_TITLE"),
        description = Lang("VEHICLEKEYS_MENU_CLEAN_KEYS_DESCRIPTION"),
        icon = 'wrench',
        onSelect = function(args)
            CleanVehicleKeys()
        end,
    })
    table.insert(elements, {
        title = Lang("VEHICLEKEYS_MENU_ACCESS_ALL_KEYS_TITLE"),
        description = Lang("VEHICLEKEYS_MENU_ACCESS_ALL_KEYS_DESCRIPTION"),
        icon = 'key',
        onSelect = function(args)
            OpenAllKeysMenu()
        end,
    })

    lib.registerContext({
        id = 'MAIN_MENU_TITLE',
        title = Lang("VEHICLEKEYS_MAIN_MENU_TITLE"),
        options = elements,
    })
    lib.showContext('MAIN_MENU_TITLE')
end


function OpenAllKeysMenu()
    local elements = {}
    local function AddKeyToAllKeysMenu(title, plate, model)
        table.insert(elements, {
            title = title,
            icon = 'key',
            onSelect = function(args)
                CreateKeyMenuItem(title, plate, model)
            end,
        })
    end
    TriggerServerCallback(Config.Eventprefix .. ':server:GetPlayerItems', function(items)
        if items then
            local keysFound = false
            for _, item in pairs(items) do
                local plate = GetPlateFromItem(item)
                local model = GetModelFromItem(item)
                if plate and model then
                    keysFound = true
                    AddKeyToAllKeysMenu(Lang("VEHICLEKEYS_MENU_MODEL").." " .. model .. ", ".. Lang("VEHICLEKEYS_MENU_PLATE").." " .. plate, plate, model)
                end
            end
            if not keysFound then
                table.insert(elements, {
                    title = Lang("NO_KEYS_FOUND"),
                    icon = 'exclamation-circle',
                    disabled = true,
                })
            end
        end

        table.insert(elements, {
            title = Lang("BACK_TO_PREVIOUS_MENU"),
            icon = 'arrow-left',
            onSelect = function(args)
                OpenMainMenu()
            end,
        })

        lib.registerContext({
            id = 'ALL_KEYS_MENU',
            title = Lang("VEHICLEKEYS_ALL_KEYS_MENU_TITLE"),
            options = elements,
        })
        lib.showContext('ALL_KEYS_MENU')
    end)
end


function CreateKeyMenuItem(title, plate, model)
    lib.registerContext({
        id = 'keysactions',
        title = 'Actions',
        options = {
            {
                title = Lang("VEHICLEKEYS_MENU_KEY_MENU_HEADER"),
                icon = "info",
                disabled = true,
                description = Lang("VEHICLEKEYS_MENU_KEY_MENU_MODEL") .. " " .. model .. " " ..
                              Lang("VEHICLEKEYS_MENU_KEY_MENU_PLATE") .. " " .. plate

            },
            {
                title = Lang("VEHICLEKEYS_MENU_USE_KEY_TITLE"),
                description = Lang("VEHICLEKEYS_MENU_USE_KEY_DESCRIPTION"),
                icon = "check",
                metadata = {
                    { label = 'Action', value = Lang("VEHICLEKEYS_MENU_USE_KEY_DESCRIPTION") },
                },
                onSelect = function(args)
                    handleDoorLock(plate, model)
                end
            },
            {
                title = Lang("VEHICLEKEYS_MENU_GIVE_KEY_TITLE"),
                icon = "handshake",
                description = Lang("VEHICLEKEYS_MENU_GIVE_KEY_DESCRIPTION"),
                metadata = {
                    { label = 'Action', value = Lang("VEHICLEKEYS_MENU_GIVE_KEY_DESCRIPTION") },
                },
                onSelect = function(args)
                    ShowNearbyPlayersMenu(plate, model)
                end
            },
            {
                title = Lang("VEHICLEKEYS_MENU_TRASH_KEY_TITLE"),
                icon = "trash",
                description = Lang("VEHICLEKEYS_MENU_TRASH_KEY_DESCRIPTION"),
                metadata = {
                    { label = 'Action', value = Lang("VEHICLEKEYS_MENU_TRASH_KEY_DESCRIPTION") },
                },
                onSelect = function(args)
                    exports['qs-vehiclekeys']:RemoveKeys(plate, model)
                end
            },
            {
                title = Lang("BACK_TO_PREVIOUS_MENU"),
                icon = "arrow-left",
                onSelect = function(args)
                    OpenAllKeysMenu()
                end
            },
        }
    })
    lib.showContext('keysactions')
end

function getClosestVehicle(coords, maxDistance, includePlayerVehicle)
    return lib.getClosestVehicle(coords, maxDistance, includePlayerVehicle)
end

function handleDoorLock(plate, model)
    local coords = GetEntityCoords(PlayerPedId())
    local vehicle, _ = getClosestVehicle(coords, 5.0, true)
    if vehicle then
        local vehiclePlate = GetVehicleNumberPlateText(vehicle)
        local vehicleModel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
        if vehiclePlate == plate and vehicleModel == model then
            local hasKey = exports['qs-vehiclekeys']:GetKey(plate)
            if hasKey then
                exports["qs-vehiclekeys"]:DoorLogic(vehicle)
                for door = 0, 5 do
                    SetVehicleDoorShut(vehicle, door, false, false)
                end
            else
                SendTextMessage(Lang('VEHICLEKEYS_NOTIFICATION_NO_KEYS'), 'error')
            end
        else
            SendTextMessage(Lang('VEHICLEKEYS_NOTIFICATION_NO_MATCH'), 'error')
        end
    else
        SendTextMessage(Lang('VEHICLEKEYS_NOTIFICATION_NO_VEHICLES'), 'error')
    end
end


function GetPlayersInRadius(x, y, z, radius)
    local currentPlayerId = GetPlayerServerId(PlayerId())
    local players = ""
    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            local playerPed = GetPlayerPed(i)
            local playerCoords = GetEntityCoords(playerPed, false)
            local distance = GetDistanceBetweenCoords(x, y, z, playerCoords, true)
            local playerId = GetPlayerServerId(i)
            if distance <= radius and playerId ~= currentPlayerId then
                if players == "" then
                    players = tostring(playerId)
                else
                    players = players .. "," .. tostring(playerId)
                end
            end
        end
    end
    return players
end

function ShowNearbyPlayersMenu(plate, model)
local playerPed = GetPlayerPed(-1) -- Get the player's ped
local x, y, z = table.unpack(GetEntityCoords(playerPed, false))
local nearbyPlayers = GetPlayersInRadius(x, y, z, 2.0)

    local elements = {}

    if #nearbyPlayers == 0 then
        table.insert(elements, {
            title = Lang("VEHICLEKEYS_NO_PLAYERS_FOUND"),
            icon = 'exclamation-circle',
            disabled = true,
        })
    else
        local playerIds = {}
        for playerId in nearbyPlayers:gmatch("[^,]+") do
            table.insert(playerIds, playerId)
        end

        for _, playerId in ipairs(playerIds) do
            table.insert(elements, {
                title = playerId,
                icon = 'user',
                onSelect = function()
                    CheckAndGiveKey(plate, model, playerId)
                end
            })
        end
    end

    table.insert(elements, {
        title = Lang("BACK_TO_PREVIOUS_MENU"),
        icon = 'arrow-left',
        onSelect = function(args)
            CreateKeyMenuItem(title, plate, model)
        end,
    })

    lib.registerContext({
        id = 'vehiclekeys_nearby_players',
        title = Lang("VEHICLEKEYS_NEARBY_PLAYERS_MENU_TITLE"),
        options = elements
    })
    lib.showContext('vehiclekeys_nearby_players')
end

function CleanVehicleKeys()
    if Config.Framework == "esx" then
        -- ESX Framework logic
        TriggerServerCallback(Config.Eventprefix .. ':server:getVehicles', function(vehicles)
            if vehicles then
                local ownedVehicles = {}
                for _, v in pairs(vehicles) do
                    local hashVehicle = v.vehicle.model
                    local plate = v.vehicle.plate
                    local vehicleName = GetDisplayNameFromVehicleModel(hashVehicle)
                    ownedVehicles[plate] = vehicleName
                end
                TriggerServerCallback(Config.Eventprefix .. ':server:GetPlayerItems', function(items)
                    if items then
                        local keysRemoved = true
                        for _, item in pairs(items) do
                            local plate = GetPlateFromItem(item)
                            local model = GetModelFromItem(item)
                            if plate and model then
                                if not ownedVehicles[plate] or ownedVehicles[plate] ~= model then
                                    exports['qs-vehiclekeys']:RemoveKeys(plate, model)
                                    keysRemoved = false
                                end
                            end
                        end
                        if keysRemoved then
                            SendTextMessage(Lang('VEHICLEKEYS_MENU_CLEAN_KEYS_ERROR'), 'error')
                        else
                            SendTextMessage(Lang('VEHICLEKEYS_MENU_CLEAN_KEYS_SUCCESS'), 'inform')
                        end
                    else
                        SendTextMessage(Lang('VEHICLEKEYS_MENU_CLEAN_KEYS_ERROR'), 'error')
                    end
                end)
            end
        end)
    elseif Config.Framework == "qb" then
        -- QBCore Framework logic
        TriggerServerCallback(Config.Eventprefix .. ':server:getVehicles', function(vehicles)
            if not vehicles then
                print('No vehicles received from server callback')
                return
            end

            local ownedVehicles = {}
            for _, v in pairs(vehicles) do
                if v.vehicle and v.plate then
                    local vehicleName = GetDisplayNameFromVehicleModel(v.vehicle.model)
                    ownedVehicles[v.plate] = vehicleName
                else
                    print('Missing vehicle or plate information:', v.vehicle, v.plate)
                end
            end

            TriggerServerCallback(Config.Eventprefix .. ':server:GetPlayerItems', function(items)
                if items then
                    local keysRemoved = true
                    for _, item in pairs(items) do
                        local plate = GetPlateFromItem(item)
                        local model = GetModelFromItem(item)
                        if plate and model then
                            if not ownedVehicles[plate] or ownedVehicles[plate] ~= model then
                                exports['qs-vehiclekeys']:RemoveKeys(plate, model)
                                keysRemoved = false
                            end
                        end
                    end
                    if keysRemoved then
                        SendTextMessage(Lang('VEHICLEKEYS_MENU_CLEAN_KEYS_ERROR'), 'error')
                    else
                        SendTextMessage(Lang('VEHICLEKEYS_MENU_CLEAN_KEYS_SUCCESS'), 'inform')
                    end
                else
                    SendTextMessage(Lang('VEHICLEKEYS_MENU_CLEAN_KEYS_ERROR'), 'error')
                end
            end)
        end)
    else
        print("Invalid framework specified in configuration.")
    end
end

function PlayGiveAnimation()
    local EmoteData = {
        Animation = 'givetake1_a',
        Dictionary = 'mp_common',
        Options = {
            Duration = 2000,
            Flags = {
                Move = true,
            },
        },
    }
    PlayEmote(EmoteData)
end

function CheckAndGiveKey(plate, model, targetPlayerId)
    PlayGiveAnimation()

    exports['qs-vehiclekeys']:RemoveKeys(plate, model)
    TriggerServerEvent('vehiclekeys:server:givekeyother', plate, model, targetPlayerId)
end

RegisterNetEvent('vehiclekeys:client:givekeyclient')
AddEventHandler('vehiclekeys:client:givekeyclient', function(plate, model)
    PlayGiveAnimation()

    exports['qs-vehiclekeys']:GiveKeys(plate, model)
end)


function PlayEmote(animationData)
    local dict = animationData.Dictionary
    local anim = animationData.Animation

    local function LoadAnimationDict(dict, timeout)
        RequestAnimDict(dict)
        local startTick = GetGameTimer()
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(0)
            if GetGameTimer() - startTick > timeout then
                print("Failed to load animation dictionary: " .. dict)
                return false
            end
        end
        return true
    end

    local function PlayAnimation()
        if not LoadAnimationDict(dict, 500) then
            return
        end
        TaskPlayAnim(PlayerPedId(), dict, anim, 2.0, 2.0, animationData.Options.Duration, 0, 0, false, false, false)
        RemoveAnimDict(dict)
    end

    PlayAnimation()
end


RegisterCommand("openkeys", function(source, args, rawCommand)
    OpenMainMenu()
end, false)

