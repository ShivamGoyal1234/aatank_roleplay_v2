CardsData = {}
FakeCardsData = {}
WeaponLicenseData = {}
DriverLicenseData = {}

RegisterNetEvent("0r_idcard:server:showCard", function(target, data, isJobCard, shown)
    TriggerClientEvent("0r_idcard:client:showCard", target, data, isJobCard, shown)
end)

-- User Drivers License
RegisterServerEvent("0r_idcard:server:useDriversLicense", function(data)
    local src = source
    TriggerClientEvent("0r_idcard:client:showCard", src, data, false, false)
end)

-- Use Weapon License
RegisterNetEvent("0r_idcard:server:useWeaponLicense", function(data)
    local src = source
    TriggerClientEvent("0r_idcard:client:showCard", src, data, false, false)
end)

-- Use Citizen Card
RegisterNetEvent("0r_idcard:server:useIdCard", function(data)
    local src = source
    TriggerClientEvent("0r_idcard:client:showCard", src, data, false, false)
end)

-- Use Job Card
RegisterNetEvent("0r_idcard:server:useJobCard", function(data)
    local data = {}
    local src = source
    TriggerClientEvent("0r_idcard:client:showCard", src, data, true, false)
end)

-- Use Fake Card
RegisterNetEvent("0r_idcard:server:useFakeCard", function(newData)
    local src = source
    TriggerClientEvent("0r_idcard:client:showCard", src, newData, false, false)
end)

-- Use Fake Job Card
RegisterNetEvent("0r_idcard:server:useFakeJobCard", function(data)
    local src = source
    
    TriggerClientEvent("0r_idcard:client:showCard", src, data, true, false)
end)