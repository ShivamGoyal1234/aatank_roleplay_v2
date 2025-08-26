local QBCore = exports["qb-core"]:GetCoreObject()

RegisterNetEvent('tn-rental:sv:rentVehicle', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid
    if data.payType == "cash" then
        if Player.Functions.GetMoney("cash") >= data.carPrice then
            Player.Functions.RemoveMoney('cash', data.carPrice, 'cash transfer')
            TriggerClientEvent('tn-rental:cl:spawnVehicle', src, data.carName, data.carDay, data.model)
            TriggerClientEvent('okokNotify', src,'Purchase transaction successful', 'success')
        else
            TriggerClientEvent('okokNotify', src,'You dont have enough funds', 'error')

        end
    else        
        if Player.PlayerData.money.bank >= data.carPrice then
            Player.Functions.RemoveMoney("bank", data.carPrice)
            TriggerClientEvent('tn-rental:cl:spawnVehicle', src, data.carName, data.carDay, data.model)
            TriggerClientEvent('okokNotify', src,'Purchase transaction successful', 'success')
        else
            TriggerClientEvent('okokNotify', src,'You dont have enough funds', 'error')
        end
    end

end)

RegisterNetEvent('tn-rental:sv:updatesql', function(plate,vehicle,time)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid
    local timeinday = time * 86400
    local endtime = tonumber(os.time() + timeinday)
    local timeTable = os.date('*t', endtime)
    local owner = src
    MySQL.insert('INSERT INTO rentvehs (citizenid, vehicle, plate, time) VALUES (?, ?, ?, ?)', {cid, vehicle, plate, endtime})
    local model = vehicle
    exports['vms_garagesv2']:giveVehicle(
        source,
        owner,
        'vehicle',
        model,
        plate
    )
    TriggerClientEvent('okokNotify', src, "you successfly rent this car until "..timeTable['day'].." / "..timeTable['month'].." / "..timeTable['year'], "success",10000)   
end)

RegisterNetEvent('tn-rental:sv:checktime', function()
    local sqlresult = MySQL.Sync.fetchAll('SELECT citizenid, vehicle, plate, time FROM rentvehs', {})
    local currentTime = os.time()

    for _, row in pairs(sqlresult) do
        local citizenid = tonumber(row.citizenid)
        local timeInDB = tonumber(row.time)

        if currentTime > timeInDB then
            MySQL.Sync.execute('DELETE FROM rentvehs WHERE citizenid = ? AND plate = ?', {row.citizenid, row.plate})
            MySQL.Sync.execute('DELETE FROM owned_vehicles WHERE owner = ? AND plate = ?', {row.citizenid,row.plate})
        end
    end
end)