RegisterNetEvent('frkn-prison:openNotebook')
AddEventHandler('frkn-prison:openNotebook',function(item)
    local note = item.metadata or item.info
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openNotebook",
        note = note,
        slot = item.slot
    })
end)

RegisterNUICallback('noteBookSave',function(data,cb)
    TriggerServerEvent('frkn-prison:noteBookSave', data)
    SetNuiFocus(false, false)
end)