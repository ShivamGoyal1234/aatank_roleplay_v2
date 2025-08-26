
-- Admin Car
RegisterNetEvent('ps-adminmenu:server:SaveCar', function(mods, vehicle, model, plate)
    local src = source
    local owner = src
 
    exports['vms_garagesv2']:giveVehicle(
        source,
        owner,
        'vehicle',
        model,
        plate
    )
end)

-- Give Car
local function GeneratePlate()
    local plate = ""
    local characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    for i = 1, 8 do
        local randomIndex = math.random(1, #characters)
        plate = plate .. string.sub(characters, randomIndex, randomIndex)
    end
    return plate
end

RegisterNetEvent("ps-adminmenu:server:givecar", function(data, selectedData)
    local owner = selectedData['Player'].value -- Set owner to the target player's citizen ID
    local model = selectedData['Vehicle'].value -- Extract the vehicle model from selectedData
    local plate = selectedData['Plate'] and selectedData['Plate'].value or '' -- Safely extract plate, default to empty string if nil

    if plate == nil or plate == '' then
        local generatedPlate = nil
        repeat
            generatedPlate = GeneratePlate()
            local result = MySQL.single.await("SELECT plate FROM owned_vehicles WHERE plate = ?", { generatedPlate })
            if result then
                generatedPlate = nil -- Reset to continue loop if plate exists
            end
        until generatedPlate ~= nil
        plate = generatedPlate
    end
    exports['vms_garagesv2']:giveVehicle(
        source,
        owner,
        'vehicle',
        model,
        plate
    ) 
end)

-- Change Car State
--[[ RegisterNetEvent("ps-adminmenu:server:SetVehicleState", function(data, selectedData)
    local src = source

    local data = CheckDataFromKey(data)
    if not data or not CheckPerms(source, data.perms) then
        QBCore.Functions.Notify(src, locale("no_perms"), "error", 5000)
        return
    end

    local plate = string.upper(selectedData['Plate'].value)
    local state = tonumber(selectedData['State'].value)

    if plate:len() > 8 then
        QBCore.Functions.Notify(src, locale("plate_max"), "error", 5000)
        return
    end

    if not CheckAlreadyPlate(plate) then
        QBCore.Functions.Notify(src, locale("plate_doesnt_exist"), "error", 5000)
        return
    end

    MySQL.update('UPDATE player_vehicles SET state = ?, depotprice = ? WHERE plate = ?', { state, 0, plate })

    QBCore.Functions.Notify(src, locale("state_changed"), "success", 5000)
end) ]]

-- Change Plate
RegisterNetEvent('ps-adminmenu:server:ChangePlate', function(newPlate, currentPlate)
    local newPlate = newPlate:upper()

    if Config.Inventory == 'ox_inventory' then
        exports.ox_inventory:UpdateVehicle(currentPlate, newPlate)
    end

    MySQL.Sync.execute('UPDATE owned_vehicles SET plate = ? WHERE plate = ?', { newPlate, currentPlate })
    MySQL.Sync.execute('UPDATE trunkitems SET plate = ? WHERE plate = ?', { newPlate, currentPlate })
    MySQL.Sync.execute('UPDATE gloveboxitems SET plate = ? WHERE plate = ?', { newPlate, currentPlate })
end)

lib.callback.register('ps-adminmenu:server:GetVehicleByPlate', function(source, plate)
    local result = MySQL.query.await('SELECT vehicle FROM owned_vehicles WHERE plate = ?', { plate })
    local veh = result[1] and result[1].vehicle or {}
    return veh
end)

-- Fix Vehicle for player
RegisterNetEvent('ps-adminmenu:server:FixVehFor', function(data, selectedData)
    local data = CheckDataFromKey(data)
    if not data or not CheckPerms(source, data.perms) then return end
    local src = source
    local playerId = selectedData['Player'].value
    local Player = QBCore.Functions.GetPlayer(tonumber(playerId))
    if Player then
        local name = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
        TriggerClientEvent('iens:repaira', Player.PlayerData.source)
        TriggerClientEvent('vehiclemod:client:fixEverything', Player.PlayerData.source)
        QBCore.Functions.Notify(src, locale("veh_fixed", name), 'success', 7500)
    else
        TriggerClientEvent('QBCore:Notify', src, locale("not_online"), "error")
    end
end)
