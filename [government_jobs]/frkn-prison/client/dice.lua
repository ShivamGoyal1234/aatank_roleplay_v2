local pendingDiceRequest = nil
local amount = 0


RegisterCommand("dicesend", function(_, args)
    local targetId = tonumber(args[1])
    local amount = tonumber(args[2])

    if not targetId or not amount or amount <= 0 then
        Notify(Lang:t("error.dice_invalid_target"))
        return
    end

    GetNearbyPlayers(3.0, function(players)
        local isNearby = false
        for _, player in ipairs(players) do
            if player.id == targetId then
                isNearby = true
                break
            end
        end

        if isNearby then
            TriggerServerEvent("frkn-dice:sendRequest", targetId, amount)
        else
            Notify(Lang:t("error.dice_not_nearby"))
        end
    end)
end)

RegisterCommand("diceaccept", function()
    if pendingDiceRequest then
        TriggerServerEvent("frkn-dice:respondRequest", pendingDiceRequest, true, amount)
        pendingDiceRequest = nil
    else
        Notify(Lang:t("error.dice_no_pending_request"))
    end
end)

RegisterCommand("dicedeny", function()
    if pendingDiceRequest then
        TriggerServerEvent("frkn-dice:respondRequest", pendingDiceRequest, false)
        pendingDiceRequest = nil
    else
        Notify(Lang:t("error.dice_no_pending_request"))
    end
end)

RegisterNUICallback('switchTurn', function(data)
    TriggerServerEvent("frkn-dice:s_switchTurn", data)
end)

RegisterNetEvent('frkn-dice:c_switchTurn')
AddEventHandler('frkn-dice:c_switchTurn', function(data)
    SendNUIMessage({
        action = "switchTurn",
        player = data
    })
end)
RegisterNetEvent("frkn-dice:requestReceived", function(fromId, amount)
    pendingDiceRequest = fromId
    amount = amount or 0
    local rawText = Lang:t("general.dice_info")
    local formatted = rawText
        :gsub("{sender}", tostring(fromId))
        :gsub("{amount}", tostring(amount))

    Notify(formatted)
end)

RegisterNUICallback("rollResult", function(data, cb)
    TriggerServerEvent("frkn-dice:rollResult", data.die1, data.die2,amount)
    cb({})
end)

RegisterNetEvent("frkn-dice:syncRoll", function(die1, die2)
    SendNUIMessage({
        action = "syncRoll",
        die1 = die1,
        die2 = die2
    })
end)

RegisterNetEvent('frkn-dice:gameOver',function(data)
   SendNUIMessage({
        action = "diceResult",
        result = data
    })
end)


RegisterNetEvent("frkn-dice:startGame", function(data, firstTurnId)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openDice",
        players = {
            me = {
                id = GetPlayerServerId(PlayerId()),
                name = GetPlayerName(PlayerId())
            },
            opponent = {
                id = data.id,
                name = data.name
            }
        },
        firstTurnId = firstTurnId
    })
end)

RegisterNetEvent('frkn-dice:notEnoughMoney', function()
    Notify(Lang:t("error.dice_my_not_enough_money"))
end)

RegisterNetEvent("frkn-dice:requestRejected", function(bool)
    if bool then 
        Notify(Lang:t("error.dice_not_enough_money"))
    else
        Notify(Lang:t("error.dice_request_rejected"))
    end
end)
