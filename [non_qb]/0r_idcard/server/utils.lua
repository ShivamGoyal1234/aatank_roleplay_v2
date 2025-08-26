Framework = Config.CoreExport()


function registerItem(...)
    if Config.Framework == "qb" then
        Framework.Functions.CreateUseableItem(...)
    else
        Framework.RegisterUsableItem(...)
    end
end

function registerServerCallback(...)
    if Config.Framework == "qb" then
        Framework.Functions.CreateCallback(...)
    else
        Framework.RegisterServerCallback(...)
    end
end

function getExtendedPlayer(src)
    if Config.Framework == "qb" then
        return Framework.Functions.GetPlayer(src)
    elseif Config.Framework == "esx" then
        return Framework.GetPlayerFromId(src)
    end
end

function hasMoney(src, money)
    local player = getExtendedPlayer(src)

    while player == nil do
        Citizen.Wait(100)
        player = getExtendedPlayer(src)
    end

    if Config.Framework == "qb" then
        return player.Functions.GetMoney("cash") >= money
    elseif Config.Framework == "esx" then
        return player.getMoney() >= money
    end
end

function removeMoney(src, amount)
    local player = getExtendedPlayer(src)

    while player == nil do
        Citizen.Wait(100)
        player = getExtendedPlayer(src)
    end

    if hasMoney(src, amount) then
        if Config.Framework == "qb" then
            player.Functions.RemoveMoney("cash", amount)
        elseif Config.Framework == "esx" then
            player.removeMoney(amount)
        end

        return true
    end

    return false
end