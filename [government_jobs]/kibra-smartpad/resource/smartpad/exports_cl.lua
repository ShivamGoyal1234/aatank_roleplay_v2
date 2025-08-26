exports('GetPlayerEmail', function()
    local xPlayer = Resmon.Lib.GetPlayerData()
    local Tablets = Shared.Tablets
    local checked = 'notFound'
    for k,v in pairs(Tablets) do
        if v.owner == xPlayer.identifier then
            return v.email
        end
    end
    return checked
end)

exports('GetPlayerUnpaidInvoices', function(identifier)
    local billings = {}
    for k,v in pairs(AllInvoices) do
        if v.owner == identifier then
            if v.status == 0 then
                billings[#billings+1] = v
            end
        end
    end
    return billings
end)


exports('StartMiniGame', function(CloseTablet,CloseApp)
    local hasTab, tabData = lib.callback.await('Kibra:SmartPad:CheckTablet',false)
    if not hasTab then
        TriggerEvent('SmartPad:Ox:Notification', Shared.LangData.error, Shared.LangData.donthavetab, Shared.LangData.error)
        return false
    end

    exports['kibra-smartpad']:OpenTablet(tabData.info.SerialNumber)
    SendNUIMessage({action='openMiniGame'})

    local p = promise.new()
    local cbName = 'getMiniGameResult'
    local handler
    handler = function(data, cb)
        cb(true)
        if CloseTablet then SendNUIMessage({action='closeTablet'}) end
        if CloseApp then cb(true) end
        p:resolve(data.result)
    end
    RegisterNUICallback(cbName, handler)

    return Citizen.Await(p)
end)


exports('OpenTablet', function(SerialNumber)
    TriggerServerEvent('Kibra:SmartPad:OpenTablet', SerialNumber)
end)

RegisterCommand('startminigame', function()
    local CloseTablet = true
    local CloseApp = false
    local result = exports['kibra-smartpad']:StartMiniGame(CloseTablet, CloseApp)
    if result then
       print('Minigame was successfull.')
    else
       print('Mini game failed.')
    end
end)