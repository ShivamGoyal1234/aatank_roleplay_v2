if Config.InventoryScript == 'ox' then
    return
end

RegisterUsableItem(Config.LockpickItem, function(source)
    local src = source
    TriggerClientEvent(Config.Eventprefix..":client:useLockpick", src, false)
end)

RegisterUsableItem(Config.AdvancedLockpickItem, function(source)
    local src = source
    TriggerClientEvent(Config.Eventprefix..":client:useLockpick", src, true)
end)

RegisterUsableItem(Config.VehicleKeysItem, function(source, item, itemData)
    local plate = item.info.plate
    local model = item.info.description
    TriggerClientEvent(Config.Eventprefix .. ':client:UseKey', source, plate, model)
end)

RegisterUsableItem(Config.PlateItem, function(source, item)
    local plate = item.info.plate
    TriggerClientEvent(Config.Eventprefix..':client:UsePlate', source, plate)
end)

RegisterUsableItem(Config.GPSItem, function(source)
    TriggerClientEvent(Config.Eventprefix..':client:UseGPS', source)
end)

RegisterUsableItem(Config.TrackerItem, function(source)
    TriggerClientEvent(Config.Eventprefix..':client:UseTracker', source)
end)
