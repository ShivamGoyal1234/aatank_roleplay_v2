Core = nil

if Config['Core']:upper() == 'ESX' then
--------------------------------------------------------------------------
---------------------------------| ESX |----------------------------------
--------------------------------------------------------------------------

    local _esx_ = 'new' -- 'new' / 'old'
        
    if _esx_ == 'new' then
        Core = exports['es_extended']:getSharedObject()
    else
        Core = nil
        TriggerEvent('esx:getSharedObject', function(obj) Core = obj end)
        while Core == nil do
            Citizen.Wait(0)
        end
    end

    RESCB = Core.RegisterServerCallback
    GETPFI = Core.GetPlayerFromId
    RUI = Core.RegisterUsableItem

    function GetPlayersFunction()
        return Core.GetPlayers()
    end

    function AddMoneyFunction(source, amount)
        local xPlayer = GETPFI(source)
        xPlayer.addAccountMoney('money', amount) -- NORMAL MONEY
        --xPlayer.addAccountMoney('black_money', amount) -- BLACK MONEY
    end

    function GetPlayerJobFunction(source)
        local xPlayer = GETPFI(source)
        if xPlayer ~= nil then
            PlayerJob = xPlayer.job.name
        else
            PlayerJob = ''
        end
        return PlayerJob
    end

    function GetItemCount(source, item)
        local xPlayer = GETPFI(source)

        if _esx_ == 'new' then
            return xPlayer.getInventoryItem(item).count
        else
            if string.sub(item, 0, 6):lower() == 'weapon' then
                local loadoutNum, weapon = xPlayer.getWeapon(item:upper())

                if weapon then
                    return true
                else
                    return false
                end
            else
                return xPlayer.getInventoryItem(item).count
            end
        end
    end

    function AddItem(source, item, count)
        local xPlayer = GETPFI(source)
        if _esx_ == 'new' then
            xPlayer.addInventoryItem(item, count)
        else
            if string.sub(item, 0, 6):lower() == 'weapon' then
                xPlayer.addWeapon(item, 90)
            else
                xPlayer.addInventoryItem(item, count)
            end
        end
    end

    function RemoveItem(source, item, amount)
        local xPlayer = GETPFI(source)
        if _esx_ == 'new' then
            xPlayer.removeInventoryItem(item, amount)
        else
            if string.sub(item, 0, 6):lower() == 'weapon' then
                xPlayer.removeWeapon(item)
            else
                xPlayer.removeInventoryItem(item, amount)
            end
        end
    end

    function GetIdentifier(source)
        local xPlayer = GETPFI(source)
        while xPlayer == nil do
            Citizen.Wait(1000)
            xPlayer = GETPFI(source) 
        end
        return xPlayer.identifier
    end

elseif Config['Core']:upper() == 'QBCORE' then
--------------------------------------------------------------------------
--------------------------------| QBCORE |--------------------------------
--------------------------------------------------------------------------

    Core = exports['qb-core']:GetCoreObject()
    
    RESCB = Core.Functions.CreateCallback
    GETPFI = Core.Functions.GetPlayer
    RUI = Core.Functions.CreateUseableItem

    function GetPlayersFunction()
        return Core.Functions.GetPlayers()
    end

    function AddMoneyFunction(source, amount)
        local xPlayer = GETPFI(source)
        xPlayer.Functions.AddMoney('cash', amount)
    end

    function GetPlayerJobFunction(source)
        local xPlayer = GETPFI(source)
        PlayerJob = xPlayer.PlayerData.job.name
        return PlayerJob
    end

    function GetItemCount(source, item)
        local xPlayer = GETPFI(source)

        local items = xPlayer.Functions.GetItemByName(item)
        local item_count = 0
        if items ~= nil then
            item_count = items.amount
        else
            item_count = 0
        end
        return item_count
    end

    function AddItem(source, item, count)
        local xPlayer = GETPFI(source)
        xPlayer.Functions.AddItem(item, count)
    end

    function RemoveItem(source, item, amount)
        local xPlayer = GETPFI(source)
        xPlayer.Functions.RemoveItem(item, amount)
    end

    function GetIdentifier(source)
        local xPlayer = GETPFI(source)
        while xPlayer == nil do
            Citizen.Wait(1000)
            xPlayer = GETPFI(source) 
        end
        return xPlayer.PlayerData.citizenid
    end
    
end