
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        CreateThread(function()

           if FRKN.General.targetSystem == 'qb-target' then
                for _, modelHash in ipairs(FRKN.General.PhoneSystem.phoneModels) do
                    exports['qb-target']:AddTargetModel(modelHash, FRKN.General.PhoneSystem.qbTargetOptions) 
                end
            elseif FRKN.General.targetSystem == 'ox_target' then
                for _, modelHash in ipairs(FRKN.General.PhoneSystem.phoneModels) do
                    exports.ox_target:addModel(modelHash, FRKN.General.PhoneSystem.oxTargetOptions) 
                end
            end
        end)
    end
end)

RegisterNetEvent('frkn-prison:interactWithPhone')
AddEventHandler('frkn-prison:interactWithPhone', function()

    local jailedPlayersList = {}
    for _, v in pairs(cacheData) do
        if v.status == 1 then
            table.insert(jailedPlayersList, v)
        end
    end

    local playerIdentifier = GetPlayerIdentifier()
    local isPlayerInJail = false

    for _, v in pairs(cacheData) do
        if v.player_id == playerIdentifier and v.status == 1 then
            isPlayerInJail = true
            break
        end
    end

    if not isPlayerInJail then
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "visitMenu",
            jailedPlayers = jailedPlayersList
        })
    end
end)

RegisterNUICallback('requestVisit', function(data, cb)
    local recordId = data.recordId
    local playerId = data.playerId
    if recordId and playerId then
        TriggerServerEvent('frkn-prison:s_requestVisit', recordId, playerId)
    end
end)

RegisterNUICallback('visitControl', function(data, cb)
    local visitSenderId = data.visitSenderId
    if visitSenderId then
        TriggerServerEvent('frkn-prison:s_visitcontrol', visitSenderId,data.success)
    end
    SetNuiFocus(false, false)
end)

RegisterNetEvent('frkn-prison:visiteleport')
AddEventHandler('frkn-prison:visiteleport', function()
    local coords = vector3(FRKN.General.ReleaseTeleportCoords.visitCoords.x, FRKN.General.ReleaseTeleportCoords.visitCoords.y, FRKN.General.ReleaseTeleportCoords.visitCoords.z)
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, true)
end)

RegisterNetEvent('frkn-prison:c_requestVisit')
AddEventHandler('frkn-prison:c_requestVisit', function(data)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "visitRequestResponse",
        success = true,
        data = data
    })
end)

RegisterNetEvent('frkn-prison:c_visitcontrol')
AddEventHandler('frkn-prison:c_visitcontrol', function(data)
    SendNUIMessage({
        action = "visitResponse",
        success = data,
    })
end)