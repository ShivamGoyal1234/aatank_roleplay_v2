if Config.Inventory ~= 'default' then
    return
end

local ESX = exports['es_extended']:getSharedObject()

local function BlackMoneyStorage()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'storage',
        {
            title = Lang('DRUGS_MENU_STASH_BLACK_MONEY'),
            align = 'right',
            elements = {
                { label = Lang('DRUGS_MENU_DEPOSIT'),  value = 's' },
                { label = Lang('DRUGS_MENU_WITHDRAW'), value = 'w' }
            },
        },
        function(data, menu)
            if data.current.value == 's' then
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'putAmount', { title = Lang('DRUGS_MENU_DEPOSIT') }, function(data3, menu3)
                    local amount = tonumber(data3.value)

                    if amount == nil then
                        Notification(Lang('DRUGS_NOTIFICATION_INVALID_AMOUNT'), 'error')
                    else
                        if amount >= 0 then
                            ESX.TriggerServerCallback('drugs:server:depositBlackMoney', function(success)
                                if success then
                                    Notification(Lang('DRUGS_NOTIFICATION_BLACK_MONEY_DEPOSIT'), 'success')
                                else
                                    Notification(Lang('DRUGS_NOTIFICATION_ACTION_FAILED'), 'error')
                                end
                            end, amount)
                            menu3.close()
                        else
                            Notification(Lang('DRUGS_NOTIFICATION_INVALID_AMOUNT'), 'error')
                        end
                    end
                end, function(data3, menu3)
                    menu3.close()
                end)
            elseif data.current.value == 'w' then
                ESX.TriggerServerCallback('drugs:server:getBlackMoney', function(count)
                    local elements = {}

                    table.insert(elements, { label = Lang('DRUGS_MENU_STASH_BLACK_MONEY') .. ' $' .. count, value = 'black_money' })

                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'withdrawItem', {
                        title = Lang('DRUGS_MENU_WITHDRAW'),
                        align = 'right',
                        elements = elements
                    }, function(data2, menu2)
                        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'putAmount', { title = Lang('DRUGS_MENU_WITHDRAW') }, function(data3, menu3)
                            local amount = tonumber(data3.value)

                            if amount == nil then
                                Notification(Lang('DRUGS_NOTIFICATION_INVALID_AMOUNT'), 'error')
                            else
                                if amount >= 0 then
                                    ESX.TriggerServerCallback('drugs:server:withdrawBlackMoney', function(success)
                                        if success then
                                            Notification(Lang('DRUGS_NOTIFICATION_SUCCESS_WITHDRAW'), 'success')
                                        else
                                            Notification(Lang('DRUGS_NOTIFICATION_ACTION_FAILED'), 'error')
                                        end
                                    end, amount)
                                    menu3.close()
                                    menu2.close()
                                else
                                    Notification(Lang('DRUGS_NOTIFICATION_INVALID_AMOUNT'), 'error')
                                end
                            end
                        end, function(data3, menu3)
                            menu3.close()
                        end)
                    end, function(data2, menu2)
                        menu2.close()
                    end)
                end, id)
            end
        end, function(data, menu)
            menu.close()
        end)
end

local function ItemStorage(id)
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'storage',
        {
            title = Lang('DRUGS_MENU_STASH_TITLE'),
            align = 'right',
            elements = {
                { label = Lang('DRUGS_MENU_DEPOSIT'),  value = 's' },
                { label = Lang('DRUGS_MENU_WITHDRAW'), value = 'w' }
            },
        },
        function(data, menu)
            if data.current.value == 's' then
                ESX.TriggerServerCallback('drugs:server:getInventory', function(inv)
                    local elements = {}

                    for k, v in pairs(inv['items']) do
                        if v['count'] >= 1 then
                            table.insert(elements, { label = ('x%s %s'):format(v['count'], v['label']), type = 'item', value = v['name'] })
                        end
                    end

                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'storeItem', {
                        title = Lang('DRUGS_MENU_STASH_TITLE'),
                        align = 'right',
                        elements = elements
                    }, function(data2, menu2)
                        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'putAmount', { title = Lang('DRUGS_MENU_AMOUNT') }, function(data3, menu3)
                            local amount = tonumber(data3.value)

                            if amount == nil then
                                Notification(Lang('DRUGS_NOTIFICATION_INVALID_AMOUNT'), 'error')
                            else
                                if amount >= 0 then
                                    TriggerServerEvent('drugs:server:storeItem', data2.current.type, data2.current.value, tonumber(data3.value), id)
                                    menu3.close()
                                    menu2.close()
                                else
                                    Notification(Lang('DRUGS_NOTIFICATION_INVALID_AMOUNT'), 'error')
                                end
                            end
                        end, function(data3, menu3)
                            menu3.close()
                        end)
                    end, function(data2, menu2)
                        menu2.close()
                    end)
                end)
            elseif data.current.value == 'w' then
                ESX.TriggerServerCallback('drugs:server:getHouseInventory', function(inv)
                    local elements = {}

                    for k, v in pairs(inv['items']) do
                        if v['count'] > 0 then
                            table.insert(elements, { label = ('x%s %s'):format(v['count'], v['label']), value = v['name'] })
                        end
                    end

                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'withdrawItem', {
                        title = Lang('DRUGS_MENU_STASH_WEAPONS'),
                        align = 'right',
                        elements = elements
                    }, function(data2, menu2)
                        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'putAmount', { title = Lang('DRUGS_MENU_AMOUNT') }, function(data3, menu3)
                            local amount = tonumber(data3.value)

                            if amount == nil then
                                Notification(Lang('DRUGS_NOTIFICATION_INVALID_AMOUNT'), 'error')
                            else
                                if amount >= 0 then
                                    TriggerServerEvent('drugs:server:withdrawItem', 'item', data2.current.value, tonumber(data3.value), id)
                                    menu3.close()
                                    menu2.close()
                                else
                                    Notification(Lang('DRUGS_NOTIFICATION_INVALID_AMOUNT'), 'error')
                                end
                            end
                        end, function(data3, menu3)
                            menu3.close()
                        end)
                    end, function(data2, menu2)
                        menu2.close()
                    end)
                end, id)
            end
        end, function(data, menu)
            menu.close()
        end)
end

local function WeaponStorage(id)
    ESX.UI.Menu.CloseAll()
    ESX.TriggerServerCallback('drugs:server:getInventory', function(inv)
        local elements = {}

        for k, v in pairs(inv['weapons']) do
            table.insert(elements, { label = v['label'], weapon = v['name'], ammo = v['ammo'] })
        end
    end)

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'storage',
        {
            title = Lang('DRUGS_MENU_STASH_WEAPONS'),
            align = 'right',
            elements = {
                { label = Lang('DRUGS_MENU_DEPOSIT'),  value = 's' },
                { label = Lang('DRUGS_MENU_WITHDRAW'), value = 'w' }
            },
        },
        function(data, menu)
            if data.current.value == 's' then
                ESX.TriggerServerCallback('drugs:server:getInventory', function(inv)
                    local elements = {}

                    for k, v in pairs(inv['weapons']) do
                        table.insert(elements, { label = v['label'], weapon = v['name'], ammo = v['ammo'] })
                    end

                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'storeItem', {
                        title = Lang('DRUGS_MENU_STASH_WEAPONS'),
                        align = 'right',
                        elements = elements
                    }, function(data2, menu2)
                        TriggerServerEvent('drugs:server:storeItem', 'weapon', data2.current.weapon, data2.current.ammo, id)
                        menu2.close()
                    end, function(data2, menu2)
                        menu2.close()
                    end)
                end)
            elseif data.current.value == 'w' then
                ESX.TriggerServerCallback('drugs:server:getHouseInventory', function(inv)
                    local elements = {}

                    for k, v in pairs(inv['weapons']) do
                        table.insert(elements, { label = ('%s | x%s %s'):format(ESX.GetWeaponLabel(v['name']), v['ammo'], 'bullets'), weapon = v['name'], ammo = v['ammo'] })
                    end

                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'withdrawItem', {
                        title = Lang('DRUGS_MENU_STASH_WEAPONS'),
                        align = 'right',
                        elements = elements
                    }, function(data2, menu2)
                        TriggerServerEvent('drugs:server:withdrawItem', 'weapon', data2.current.weapon, data2.current.ammo, id)
                        menu2.close()
                    end, function(data2, menu2)
                        menu2.close()
                    end)
                end, id)
            end
        end, function(data, menu)
            menu.close()
        end)
end

local function DefaultQbcoreStash(customData, uniq)
    local data = customData or Config.DefaultStashData
    local house = EnteredLab
    uniq = uniq or house
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', uniq, data)
    TriggerEvent('inventory:client:SetCurrentStash', uniq)
end

function OpenStash(customData, uniq)
    if Config.Framework == 'qb' then
        return DefaultQbcoreStash(customData, uniq)
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'storage',
        {
            title = Lang('DRUGS_MENU_STASH_TITLE'),
            align = 'right',
            elements = {

                { label = Lang('DRUGS_MENU_STASH_ITEMS'),       value = 'i' },
                { label = Lang('DRUGS_MENU_STASH_WEAPONS'),     value = 'w' },
                { label = Lang('DRUGS_MENU_STASH_BLACK_MONEY'), value = 'b' }
            },
        },
        function(data, menu)
            if data.current.value == 'i' then
                ItemStorage()
            elseif data.current.value == 'w' then
                WeaponStorage()
            elseif data.current.value == 'b' then
                BlackMoneyStorage()
            end
        end,
        function(data, menu)
            menu.close()
        end)
end
