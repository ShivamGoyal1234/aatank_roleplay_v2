Core = nil

if Config.Core:upper() == 'ESX' then
    
    local _esx_ = 'new' -- 'new' / 'old'

    if _esx_ then
        Core = exports['es_extended']:getSharedObject()
    else
        while Core == nil do
            TriggerEvent('esx:getSharedObject', function(obj) Core = obj end)
            Citizen.Wait(0)
        end
    end
    
    TSCB = Core.TriggerServerCallback
    PlayerDiedHealth = 0

elseif Config.Core:upper() == 'QBCORE' then

    Core = exports['qb-core']:GetCoreObject()
    TSCB = Core.Functions.TriggerCallback
    PlayerDiedHealth = 100

end