---@param account string
---@param amount integer
addAccountMoney = function(account, amount)
    if Config.banking == 'Renewed-Banking' then
        exports['Renewed-Banking']:addAccountMoney(account, amount)
    elseif Config.banking == 'esx_addonaccount' then
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..account, function(account)
            account.addMoney(amount)
        end)
    else
        exports[Config.banking]:AddMoney(account, amount)
    end
end

---@param account string
---@param amount integer
removeAccountMoney = function(account, amount)
    if Config.banking == 'Renewed-Banking' then
        exports['Renewed-Banking']:removeAccountMoney(account, amount)
    elseif Config.banking == 'esx_addonaccount' then
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..account, function(account)
            account.removeMoney(amount)
        end)
    else
        exports[Config.banking]:RemoveMoney(account, amount)
    end
end

---@param account string
---@return number
getAccountMoney = function(account)
    local value = 0
    if Config.banking == 'Renewed-Banking' then
        value = exports['Renewed-Banking']:getAccountMoney(account)
    elseif Config.banking == 'esx_addonaccount' then
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..account, function(account)
            value = account.money
        end)
    elseif Config.banking == 'qb-management' then
        value = exports[Config.banking]:GetMoney(account)
    else
        value = exports[Config.banking]:GetAccountBalance(account)
    end
    return value
end

---@param webhook string
---@param title string
---@param message string
---@param image string
createLog = function(webhook, title, message, image)
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        embeds = {
            {
                title = title,
                author = {
                    name = "MT Scripts - Dealerships",
                    icon_url = 'https://cdn.discordapp.com/attachments/1014907105733517442/1141400655450361916/Logo_PNG_8K.png?ex=66292c32&is=6616b732&hm=7f280578a3f1186b3778c2e828032df28d8f0b21debf468f126e0f5cb099e3d8&',
                    url = 'https://mt-scripts.tebex.io/',
                },
                color = '000000255',
                description = message,
                image = { url = image or '' },
                footer = { text = 'mt-scripts.tebex.io' },
            }
        }
    }), { ['Content-Type'] = 'application/json' })
end

---@param PlayerData table
---@param model string
---@param mods table
---@param plate string
---@param dealership table
addVehicleToGarage = function(PlayerData, model, mods, plate, dealership)
    local src = source 
    local owner = src

    exports['vms_garagesv2']:giveVehicle(
            source,
            owner,
            'vehicle',
            model,
            plate
    )
end