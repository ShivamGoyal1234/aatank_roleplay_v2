Resmon = exports["0r_lib"]:GetCoreObject()
ResourceName = GetCurrentResourceName()
Settings = json.decode(LoadResourceFile(ResourceName, 'data/settings.json'))
Lang = json.decode(LoadResourceFile(ResourceName, "locales/"..KIBRA.Lang..".json"))
if type(Lang) ~= 'table' then Debug('There is an error in the '..KIBRA.Lang..'.json file.') end
Reports = {}
Report = 0 

exports('Reports', function()
    return DispatchAlerts
end)

RegisterNetEvent('Kibra:Dispatch:RequestDispatchData', function()
    local src = source
    local Player = Resmon.Lib.GetPlayerFromSource(src)
    local AlertsCache = {}

    if #Reports > 0 then
        for k,v in pairs(Reports) do
            local AlertType = GetSettingFromName(v.type)
            if AlertType then
                if AlertType.receivers then
                    for q,s in pairs(AlertType.receivers) do
                        if s == Player.job.name then
                            AlertsCache[#AlertsCache+1] = v
                        end
                    end
                end
            else
                for q,s in pairs(AlertType.jobs) do
                    if s == Player.job.name then
                        AlertsCache[#AlertsCache+1] = v
                    end
                end
            end
        end
    end

    TriggerClientEvent('Kibra:Dispatch:GetDispatchData', src, AlertsCache)
end)

CheckIdentification = function(source)
    return Resmon.Lib.CheckPlayerPermission(source, KIBRA.DispatchMenuPermissionNames)
end

CheckDispatchMenuTypes = function(source)
    local Activation = {}
    local Player = Resmon.Lib.GetPlayerFromSource(source)

    if #Reports > 0 then
        for k,v in pairs(Reports) do
            if not v.custom then
                local AlertType = GetSettingFromName(v.type)
                for q,s in pairs(AlertType.receivers) do
                    if s == Player.job.name then
                        if not Activation[v.type] then
                            Activation[v.type] = true
                        end
                    end
                end
            else
                for q,s in pairs(v.jobs) do
                    if s == Player.job.name then
                        if not Activation[v.type] then
                            Activation[v.type] = true
                        end
                    end
                end
            end
        end
    end

    return Activation
end

exports('SendAlert', function(source, alertLabel, code, icon, jobs, blipId)
    TriggerClientEvent('Kibra:Dispatch:SendCustomAlert', source, alertLabel, code, icon, jobs, blipId)
end)

RegisterCommand('kax', function(source, args)
    exports["kibra-dispatch"]:SendAlert(source, "Atm Soygunu", "10-60", "fa-dollar-sign", {"police", "bcso", "paleto", "ranger", "sasp", "doj"}, 279)       
end)

RegisterNetEvent('Kibra:Dispatch:AddResponder', function(alertId)
    local src = source
    local Player = Resmon.Lib.GetPlayerFromSource(src)
    local found = false
    if Player then
        if alertId and alertId > 0 and Reports[alertId] then
            if Reports[alertId].responders then
                for k,v in pairs(Reports[alertId].responders) do
                    if v == Player.name then
                        found = true
                    end
                end

                if not found then
                    Reports[alertId].responders[#Reports[alertId].responders+1] = Player.name
                    TriggerClientEvent('Kibra:Dispatch:AddResponder', -1, alertId, Player.name)
                end
            end
        end
    end
end)

RegisterCommand(KIBRA.DispatchAdminCommandName, function(source)
    if (source > 0) then
        local CheckAuth = CheckIdentification(source)
        TriggerClientEvent('Kibra:Dispatch:OpenDispatchAdmin', source, CheckAuth)
    else
        print("This command was executed by the server console, RCON client, or a resource.")
    end
end, false)

function OpenDispatchList(source)
    local Accession = CheckDispatchMenuTypes(source)
    if next(Accession) ~= nil then
        TriggerClientEvent('Kibra:Dispatch:OpenDispatchList', source, Accession, os.time() * 1000)
    end
end

RegisterNetEvent('Kibra:Dispatch:OpenDispatchList', OpenDispatchList)
RegisterCommand(KIBRA.OpenDispatchMenuCommandName, OpenDispatchList)

GetSettingFromName = function(name)
    local returned = {}

    for k,v in pairs(Settings) do
        if v.type == name then
            return v 
        end
    end

    return returned
end

local function NearPlayersCount(source)
    local PedCoords = GetEntityCoords(GetPlayerPed(source))
    local MyNear = 1
    local Players = Resmon.Lib.AllPlayers()

    for k,v in pairs(Players) do
        if source ~= v then
            if type(v) == 'number' then
                local itemPlayer = Resmon.Lib.GetPlayerFromSource(v)
                if itemPlayer then
                    local itemPlayerCoord = vec3(itemPlayer.coords.x, itemPlayer.coords.y, itemPlayer.coords.z)
                    local nativePlayerCoord = PedCoords
                    if #(itemPlayerCoord - nativePlayerCoord) <= 1.5 then
                        MyNear += 1
                    end
                end
            end
        end
    end

    return MyNear
end

lib.callback.register('Kibra:Dispatch:GetVictimJob', function(source, victimid)
    return Resmon.Lib.GetPlayerFromSource(victimid).job.name
end)

local lastReportKey

RegisterNetEvent('Kibra:Dispatch:SendAlert', function(alertType, alertData)
    local src = source
    if not src then return end

    -- Server tarafı kaynak bilgisini de alertData'ya ekleyelim
    alertData.source = src

    if alertType == nil then
        alertType = 'custom'
    end


    -- Rapor ID ve zaman bilgisi ekleme
    local CurrentTime = os.time() * 1000
    Report = (Report or 0) + 1
    alertData.type = alertType
    alertData.id = Report
    alertData.time = CurrentTime
    alertData.responses = {}
    alertData.nearPlayers = NearPlayersCount(src)

    -- Oyuncu işini ekleyelim (mevcut kod)
    local Player = Resmon.Lib.GetPlayerFromSource(src)
    alertData.job = Player.job.name

    -- **Duplicate kontrolü için anahtar oluşturalım**
    -- Koordinatları biraz yuvarlayarak anahtarı basitleştiriyoruz
    local coords = alertData.coords
    local key = src
              .. '|' .. alertType
              .. '|' .. math.floor(coords.x * 10)
              .. '|' .. math.floor(coords.y * 10)
              .. '|' .. math.floor(coords.z * 10)

    -- Eğer anahtar geçtiğimiz raporla aynıysa, bildirim gönderme
    if key == lastReportKey then
        return
    end
    lastReportKey = key

    -- Raporu listeye ekle ve tüm client’lara gönder
    Reports = Reports or {}
    Reports[#Reports + 1] = alertData
    TriggerClientEvent('Kibra:Dispatch:SendAlert', -1, alertData)
end)

RegisterCommand('customalert', function()
    -- First Parameter: Alert Label
    -- Second Parameter: Alert Code Type
    -- Third Parameter: Alert Container Icon // You can search on: https://fontawesome.com/icons
    -- Receivers Parameter: {"police", ambulance"}
    -- Blip Id: https://docs.fivem.net/docs/game-references/blips/
    exports["kibra-dispatch"]:SendAlert("Vehicle Theft", "10-60", "fa-vehicle", {"police"}, 2)
  end)

RegisterCommand("alert", function(source, args, rawCommand)
    local blipId = 326 -- burayı sen ne istiyosan ayarla

    exports["kibra-dispatch"]:SendAlert(
        source,                  -- oyuncunun ID’si
        "Vehicle Theft",         -- başlık
        "10-60",                 -- kod
        "fa-vehicle",            -- ikon
        {"police"},              -- hangi joblar alacak
        blipId                   -- blip tipi
    )
end)

Resmon.Lib.Callback.Register('Kibra:Dispatch:UpdateTimeZone', function(source, cb, data)
    for k,v in pairs(Settings) do
        if v.type == data.typex then
            v.value = data.data
        end
    end

    SaveResourceFile(ResourceName, './data/settings.json', json.encode(Settings), -1)
    TriggerClientEvent('Kibra:Dispatch:UpdateTime', -1, data)
    cb(true)
end)

RegisterNetEvent('Kibra:Dispatch:UpdateSetting', function(settingData)
    for k,v in pairs(Settings) do
        if v.type == settingData.type then
            v[settingData.datatype] = settingData.data
        end
    end

    SaveResourceFile(ResourceName, './data/settings.json', json.encode(Settings), -1)
    TriggerClientEvent('Kibra:Dispatch:UpdateSetting', -1, settingData)
end)

Resmon.Lib.Callback.Register('Kibra:Dispatch:AddNewReceiver', function(source, cb, data)
    local addedType = data.type
    local addedJob = data.data

    for k, v in pairs(Settings) do
        if v.type == addedType then
            local jobExists = false
            
            for _, s in ipairs(v.receivers) do
                if s == addedJob then
                    jobExists = true
                    break
                end
            end

            if not jobExists then
                table.insert(v.receivers, addedJob)
            else
                return cb(false)
            end
        end 
    end

    SaveResourceFile(ResourceName, './data/settings.json', json.encode(Settings), -1)
    TriggerClientEvent('Kibra:Dispatch:UpdateReceiversSetting', -1, data, 'add')

    cb(addedType)
end)

Resmon.Lib.Callback.Register('Kibra:Dispatch:AddNewZone', function(source, cb, data)
    Settings = json.decode(LoadResourceFile(ResourceName, 'data/settings.json'))
    local foundName = true
    local success = false 

    for k,v in pairs(Settings) do
        if v.type == 'dispatchExclusion' then
            if #v.coords > 0 then
                for q,s in pairs(v.coords) do
                    if s.name == data.name then
                       foundName = false
                    end   
                end

                if foundName then
                    success = true
                    table.insert(v.coords, data)
                end
            else
                success = true
                table.insert(v.coords, data)
            end
        end
    end

    if success then
        SaveResourceFile(ResourceName, './data/settings.json', json.encode(Settings), -1)
        TriggerClientEvent('Kibra:Dispatch:UpdateNonZones', -1, data, 'add')
    end

    cb(foundName)
end)

Resmon.Lib.Callback.Register('Kibra:Dispatch:RemoveZone', function(source, cb, data)
    local zoneName = data.zone
    
    for k, v in pairs(Settings) do
        if v.type == 'dispatchExclusion' then
            for _, s in ipairs(v.coords) do
                if s.name == zoneName then
                    table.remove(v.coords, _)
                    break
                end
            end
        end 
    end

    SaveResourceFile(ResourceName, './data/settings.json', json.encode(Settings), -1)
    TriggerClientEvent('Kibra:Dispatch:RemoveZone', -1, data.zone)
    
    cb(zoneName)
end)

Resmon.Lib.Callback.Register('Kibra:Dispatch:RemoveReceiverJob', function(source, cb, data)
    local addedType = data.data
    local deletedJob = data.type
    
    for k, v in pairs(Settings) do
        if v.type == addedType then
            local jobExists = false

            for _, s in ipairs(v.receivers) do
                if s == deletedJob then
                    jobExists = true
                    table.remove(v.receivers, _)
                    break
                end
            end

            if not jobExists then
                return cb(false)
            end
        end 
    end

    SaveResourceFile(ResourceName, './data/settings.json', json.encode(Settings), -1)
    TriggerClientEvent('Kibra:Dispatch:UpdateReceiversSetting', -1, data, 'remove')

    cb(addedType)
end)
