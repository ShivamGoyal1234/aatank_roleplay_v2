GetPlayerPhoneNumber = function(citizenid)
    local phoneNumber = nil
    local result = MySQL.Sync.fetchAll(
        'SELECT charinfo FROM players WHERE citizenid = ? LIMIT 1',
        { citizenid }
    )
    if result[1] and result[1].charinfo then
        local ok, charinfo = pcall(json.decode, result[1].charinfo)
        if ok and charinfo and charinfo.phone then
            phoneNumber = charinfo.phone
        end
    end
    return phoneNumber
end


GetPlayerDriverLicense = function(citizenid)
    local hasDriverLicense = false

    if Resmon.Lib.Framework == "QBCore" then
        local result = MySQL.Sync.fetchAll('SELECT metadata FROM players WHERE citizenid = ?', {citizenid})
        if result[1] then
            local metadata = json.decode(result[1].metadata)
            if metadata.licenses and metadata.licenses.driver == true then
                hasDriverLicense = true
            end
        end

    elseif Resmon.Lib.Framework == "ESX" then
        local getUser = MySQL.Sync.fetchAll('SELECT * FROM user_licenses WHERE owner = ?', {citizenid})
        if getUser[1] and getUser[1].type == 'dmv' then
            hasDriverLicense = true
        end
    end

    return hasDriverLicense
end

GetPlayerHouse = function(citizenid)
    local houseData = {name = 'Unknown', coords = nil}

    if GetResourceState('0r_houses') ~= 'missing' then
        local getPlayerHouse = exports["0r_houses"]:GetPlayerHousesByCitizenId(citizenid)
        if getPlayerHouse and #getPlayerHouse > 0 then
            houseData.name = getPlayerHouse[1].HouseName
            houseData.coords = getPlayerHouse[1].coords
        end
    elseif GetResourceState('qb-houses') ~= 'missing' then
        local getPlayerHouse = MySQL.Sync.fetchAll('SELECT * FROM player_houses WHERE citizenid = ?', {citizenid})
        if getPlayerHouse and #getPlayerHouse > 0 then
            houseData.name = getPlayerHouse[1].house
        end
   elseif GetResourceState('esx_property') ~= 'missing' then
        local file = LoadResourceFile('esx_property', 'properties.json')
        if file then
            local properties = json.decode(file)
            for _, property in pairs(properties) do
                if property.Owner == citizenid then
                    houseData.name = property.Name
                    houseData.coords = property.Entrance
                    break
                end
            end
        end
    elseif GetResourceState('qbx-houses') ~= 'missing' then
        local result = MySQL.Sync.fetchAll('SELECT * FROM players_houses WHERE citizenid = ?', {citizenid})
        if result and #result > 0 then
            houseData.name = result[1].house
        end
    end
    
    return houseData
end


GetPlayerApartment = function(citizenid)
    local apartmentData = {name = 'Unkown', room = 0}
    if GetResourceState('0r_motels') ~= 'missing' then
        local getApartment = exports["0r_motels"]:GetPlayerMotelRoom(citizenid)
        if #getApartment > 0 then
            apartmentData.name = getApartment.name
            apartmentData.room = getApartment.room
        end
    elseif GetResourceState('qb-apartment') ~= 'missing' then
        local getApartments = MySQL.Sync.fetchAll('SELECT * FROM apartments WHERE citizenid = ?', {citizenid})
        if #getApartments > 0 then
            apartmentData.name = getApartments[1].label 
            apartmentData.room = getApartments[1].name
        end
    end

    return apartmentData
end

GetInventoryItemAmount = function(source, item, count)
    if Inventory.ox then
        local itemCount = exports.ox_inventory:Search(source, 'count', item)
        if itemCount >= count then
            local itemData = exports.ox_inventory:Search(source, 'slots', item)
            return true, itemData
        end
    elseif Inventory.qb or Inventory.ps or Inventory.lj then
        local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
        local itemData = xPlayer.Functions.GetItemByName(item)
        if itemData and itemData.amount >= count then
            return true, itemData
        end
    elseif Inventory.core then
        local itemData = exports.core_inventory:getItem(source, item)
        if itemData and itemData.count >= count then
            return true, itemData
        end
    elseif Inventory.qs then
        local hasItemAmount = exports['qs-inventory']:GetItemTotalAmount(source, item)
        if hasItemAmount >= count then
            return true, { amount = hasItemAmount, name = item }
        end
    elseif Inventory.codem then
        local itemData = exports['codem-inventory']:GetItemByName(source, item)
        if itemData and itemData.amount >= count then
            return true, itemData
        end     
    elseif Inventory.custom then
        print('No defined inventory found. You can integrate your own inventory.')
    end

    return false, nil
end


AddInventoryItem = function(source, item, count, slot, meta)
    if Inventory.ox then
        local metax = {}
        if item == Shared.TabletItemName then
            metax = {Serial = meta.SerialNumber, description = 'SmartPad SerialNumber: '..meta.SerialNumber}
        elseif item == Shared.WeaponLicenseItemName then
            metax = meta
            metax.description = 'Weapon License: '..metax.License.. '\n Owner: '..metax.Owner
        end
        exports.ox_inventory:AddItem(source, item, count, metax)
    elseif Inventory.qb or Inventory.ps or Inventory.lj then
        local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
        xPlayer.AddItem(item, count, nil, meta)
    elseif Inventory.core then
        exports.core_inventory:addItem(source, item, count, meta)
    elseif Inventory.codem then
        exports['codem-inventory']:AddItem(source, item, count, nil, meta) 
    elseif Inventory.qs then
        exports['qs-inventory']:AddItem(source, item, count, nil, meta) 
    end
end

RemoveInventoryItem = function(source, item, count, meta)
    if Inventory.ox then
        exports.ox_inventory:RemoveItem(source, item, count, meta)
    elseif Inventory.qb or Inventory.ps or Inventory.lj then
        local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
        xPlayer.RemoveItem(item, count, nil, meta)
    elseif Inventory.core then
        exports.core_inventory:removeItem(source, item, count, meta)
    elseif Inventory.codem then
        exports['codem-inventory']:RemoveItem(source, item, count, nil, meta) 
    elseif Inventory.qs then
        exports['qs-inventory']:RemoveItem(source, item, count, nil, meta) 
    end
end

CreateUsableItem = function(item, cb)
    if Inventory.qb or Inventory.core or Inventory.core or Inventory.lj or Inventory.ps then
        Resmon.Lib.RegisterUsableItem(item, cb)
    elseif Inventory.qs then
        exports['qs-inventory']:CreateUsableItem(item, cb)
    end
end