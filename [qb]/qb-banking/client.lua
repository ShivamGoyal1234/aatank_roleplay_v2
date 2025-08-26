local QBCore = exports['qb-core']:GetCoreObject()

local zones = {}

local isPlayerInsideBankZone = false

-- Functions

local function OpenBank()
    QBCore.Functions.TriggerCallback('qb-banking:server:openBank', function(accounts, statements, playerData)
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'openBank',
            accounts = accounts,
            statements = statements,
            playerData = playerData
        })
    end)
end

local function OpenATM()
    QBCore.Functions.Progressbar('accessing_atm', Lang:t('progress.atm'), 1500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = false,
    }, {
        animDict = 'amb@prop_human_atm@male@enter',
        anim = 'enter',
    }, {
        model = 'prop_cs_credit_card',
        bone = 28422,
        coords = vector3(0.1, 0.03, -0.05),
        rotation = vector3(0.0, 0.0, 180.0),
    }, {}, function()
        QBCore.Functions.TriggerCallback('qb-banking:server:openATM', function(response)
            if response.success then
                SetNuiFocus(true, true)
                SendNUIMessage({
                    action = 'openATM',
                    accounts = response.accounts,
                    playerData = response.playerData
                })
            else
                TriggerClientEvent('QBCore:Notify', PlayerId(), response.message, 'error')
            end
        end)
    end)
end

local function NearATM()
    local playerCoords = GetEntityCoords(PlayerPedId())
    for _, v in pairs(Config.atmModels) do
        local hash = joaat(v)
        local atm = IsObjectNearPoint(hash, playerCoords.x, playerCoords.y, playerCoords.z, 1.5)
        if atm then
            return true
        end
    end
end

-- NUI Callback

RegisterNUICallback('getNearbyPlayers', function(_, cb)
    QBCore.Functions.TriggerCallback('qb-banking:server:getNearbyPlayers', function(response)
        SendNUIMessage({
            action = 'setNearbyPlayers',
            players = response.players
        })
        cb('ok')
    end, {})
end)

RegisterNUICallback('closeApp', function(_, cb)
    Wait(250) -- Add a small delay to ensure UI is ready to close
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('withdraw', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-banking:server:withdraw', function(status)
        cb(status)
    end, data)
end)

RegisterNUICallback('deposit', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-banking:server:deposit', function(status)
        cb(status)
    end, data)
end)

RegisterNUICallback('internalTransfer', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-banking:server:internalTransfer', function(status)
        cb(status)
    end, data)
end)

RegisterNUICallback('externalTransfer', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-banking:server:externalTransfer', function(status)
        cb(status)
    end, data)
end)

RegisterNUICallback('orderCard', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-banking:server:orderCard', function(status)
        cb(status)
    end, data)
end)

RegisterNUICallback('openAccount', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-banking:server:openAccount', function(status)
        cb(status)
    end, data)
end)

RegisterNUICallback('renameAccount', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-banking:server:renameAccount', function(status)
        cb(status)
    end, data)
end)

RegisterNUICallback('deleteAccount', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-banking:server:deleteAccount', function(status)
        cb(status)
    end, data)
end)

RegisterNUICallback('addUser', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-banking:server:addUser', function(status)
        cb(status)
    end, data)
end)

RegisterNUICallback('removeUser', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-banking:server:removeUser', function(result) cb(result) end, data)
end)

RegisterNUICallback('changeDebitCardPin', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-banking:server:changeDebitCardPin', function(result) cb(result) end, data)
end)

RegisterNUICallback('checkDebitCardInInventory', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-banking:server:checkDebitCardInInventory', function(result)
        cb(result)
    end, data)
end)

RegisterNUICallback('buyLostDebitCard', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-banking:server:buyLostDebitCard', function(result) cb(result) end, data)
end)

-- New NUI Callback to check if card is in inventory client-side
RegisterNUICallback('checkDebitCardInInventoryClient', function(data, cb)
    local cardNumber = data.cardNumber
    local foundCard = false
    local Player = QBCore.Functions.GetPlayerData()

    if Player and Player.items then
        for _, item in pairs(Player.items) do
            if item.name == 'bank_card' and item.info and item.info.cardNumber == cardNumber then
                foundCard = true
                break
            end
        end
    end
    cb({ isInInventory = foundCard })
end)

-- New NUI Callback to directly verify card PIN
RegisterNUICallback('verifyCardPin', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-banking:server:verifyCardPin', function(result) 
        cb(result) -- Send server result back to UI
    end, data)
end)

-- New NUI Callback for fetching player name by citizen ID
RegisterNUICallback('getPlayerNameByCitizenId', function(data, cb)
    local citizenid = data.citizenid
    QBCore.Functions.TriggerCallback('qb-banking:server:getPlayerNameByCitizenId', function(result)
        cb(result)
    end, citizenid)
end)

-- TEMP NUI TEST CALLBACK
RegisterNUICallback('testNui', function(data, cb)
    cb('ok')
end)

-- Events

RegisterNetEvent('qb-banking:client:useCard', function()
    if NearATM() then OpenATM() end
end)

-- Threads

CreateThread(function()
    for i = 1, #Config.locations do
        local blip = AddBlipForCoord(Config.locations[i])
        SetBlipSprite(blip, Config.blipInfo.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.blipInfo.scale)
        SetBlipColour(blip, Config.blipInfo.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(tostring(Config.blipInfo.name))
        EndTextCommandSetBlipName(blip)
    end
end)

if Config.useTarget then
    CreateThread(function()
        for i = 1, #Config.locations do
            exports['qb-target']:AddCircleZone('bank_' .. i, Config.locations[i], 1.0, {
                name = 'bank_' .. i,
                useZ = true,
                debugPoly = false,
            }, {
                options = {
                    {
                        icon = 'fas fa-university',
                        label = 'Open Bank',
                        action = function()
                            OpenBank()
                        end,
                    }
                },
                distance = 1.5
            })
        end
    end)

    CreateThread(function()
        for i = 1, #Config.atmModels do
            local atmModel = Config.atmModels[i]
            exports['qb-target']:AddTargetModel(atmModel, {
                options = {
                    {
                        icon = 'fas fa-university',
                        label = 'Open ATM',
                        item = 'bank_card',
                        action = function()
                            OpenATM()
                        end,
                    }
                },
                distance = 1.5
            })
        end
    end)
end

if not Config.useTarget then
    CreateThread(function()
        for i = 1, #Config.locations do
            local zone = CircleZone:Create(Config.locations[i], 3.0, {
                name = 'bank_' .. i,
                debugPoly = false,
            })
            zones[#zones + 1] = zone
        end

        local combo = ComboZone:Create(zones, {
            name = 'bank_combo',
            debugPoly = false,
        })

        combo:onPlayerInOut(function(isPointInside)
            isPlayerInsideBankZone = isPointInside
            if isPlayerInsideBankZone then
                exports['qb-core']:DrawText('Open Bank')
                CreateThread(function()
                    while isPlayerInsideBankZone do
                        Wait(0)
                        if IsControlJustPressed(0, 38) then
                            OpenBank()
                        end
                    end
                end)
            else
                exports['qb-core']:HideText()
            end
        end)
    end)
end
