if Config.Inventory ~= 'qb-inventory' then
    return
end

function OpenStash(customData, uniq)
    local data = customData or Config.DefaultStashData
    local house = EnteredLab
    uniq = uniq or house
    uniq = uniq:gsub('-', '_')
    -- if you use old qb-inventory version, uncomment here and remove 'drugs:OpenStash' trigger.
    -- TriggerServerEvent('inventory:server:OpenInventory', 'stash', uniq, data)
    -- TriggerEvent('inventory:client:SetCurrentStash', uniq)
    TriggerServerEvent('drugs:OpenStash', uniq, data)
end
