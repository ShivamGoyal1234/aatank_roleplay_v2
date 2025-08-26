Resmon = exports["0r_lib"]:GetCoreObject()
AntiSpamTrigger = false
Database = {}
OpenedAdminUI = false
ResourceName = GetCurrentResourceName()
WorkThread = false
RadiusValue = 10.0
AlertShowed = {}
Timer = 0
LastAlertId = 0
LastAlertCoord = nil
AlertBlips = {}
Alerts = {}
TempAlerts = 0
previousSpeed = 0
SelectedAlertId = 0
DispatchAlerts = {}
IsDispatchListOpened = false

Debug = function(string)
    print('^1[ERROR]^3 - '..string)
end

Settings = json.decode(LoadResourceFile(ResourceName, 'data/settings.json'))
Lang = json.decode(LoadResourceFile(ResourceName, "locales/"..KIBRA.Lang..".json"))
Zones = json.decode(LoadResourceFile(ResourceName, "data/zones.json"))
VehicleColours = json.decode(LoadResourceFile(ResourceName, "data/vehicle_colours.json"))
Weapons = require 'data.weapons'

RegisterNetEvent(Resmon.Lib.PlayerLoadedEvent, function()
    TriggerServerEvent('Kibra:Dispatch:RequestDispatchData')
end)

RegisterNetEvent('Kibra:Dispatch:GetDispatchData', function(data)
    DispatchAlerts = data
end)

VehicleClasses = {
    [0] = Lang.compacts,
    [1] = Lang.sedans,
    [2] = Lang.suvs,
    [3] = Lang.coupes,
    [4] = Lang.muscle,
    [5] = Lang.sportsclassics,
    [6] = Lang.sports,
    [7] = Lang.super,
    [8] = Lang.motorcycles,
    [9] = Lang.offroad,
    [10] = Lang.industrial,
    [11] = Lang.utility,
    [12] = Lang.vans,
    [13] = Lang.cycles,
    [14] = Lang.boats,
    [15] = Lang.helicopters,
    [16] = Lang.planes,
    [17] = Lang.service,
    [18] = Lang.emergency,
    [19] = Lang.military,
    [20] = Lang.commercial,
    [21] = Lang.trains,
    [22] = Lang.openWheel
}

local CooldownTimersooldownTimers = {}

local function ExecuteWithCooldown(identifier, callback, ...)
    if not CooldownTimersooldownTimers[identifier] then
        CooldownTimersooldownTimers[identifier] = true
        callback(...)
        WaitTimeX = GetSettingFromName('spamDelayTime').value * 1000
        Wait(WaitTimeX)
        CooldownTimersooldownTimers[identifier] = false
    end
end

RegisterCommand('xa', function()
    exports["kibra-dispatch"]:SendAlert("ATM Soygunu", "10-60", "fa-vehicle", {"police"}, 3)
end)

local function TimerThread(alertData)
    AlertShowed[alertData.id].Timer = 0
    while AlertShowed[alertData.id].Show == true do
        AlertShowed[alertData.id].Timer = AlertShowed[alertData.id].Timer + 1
        if AlertShowed[alertData.id].Timer == KIBRA.AlertScreenTime then
            SendNUIMessage({
                action = 'hideAlert',
                data = {id = alertData.id}  
            })
            AlertShowed[alertData.id].Timer = nil
            AlertShowed[alertData.id].Show = false
            break
        end
        Citizen.Wait(KIBRA.DurationNoticeOnScreen * 1000)
    end
end

local function CheckBlipZone(alertData)
    local Check = false 
    for k,v in pairs(AlertBlips) do
        if #(v.AlertData.coords - alertData.coords) <= 50.0 then
            return true
        end
    end
    return Check
end

local function CreateAlertBlip(alertType)
    local CheckBlipZone = CheckBlipZone(alertType)
    if CheckBlipZone then return end
    local AlertBlip = AddBlipForCoord(alertType.coords.x, alertType.coords.y, alertType.coords.z)
    if not alertType.custom then
        local blipInfo = KIBRA.DispatchBlip[alertType.type] or {Color = 0, Id = 1, Scale = 0.7} -- Default values if nil
        SetBlipAlpha(AlertBlip, 255)
        SetBlipColour(AlertBlip, blipInfo.Color)
        SetBlipCategory(AlertBlip, 2)
        SetBlipSprite(AlertBlip, blipInfo.Id)
        SetBlipScale(AlertBlip, blipInfo.Scale)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(alertType.code..' | '..Lang[alertType.type])
        EndTextCommandSetBlipName(AlertBlip)
    else
        SetBlipAlpha(AlertBlip, 255)
        SetBlipColour(AlertBlip, 0)
        SetBlipCategory(AlertBlip, 2)
        SetBlipSprite(AlertBlip, alertType.blipOfcId)
        SetBlipScale(AlertBlip, 0.7)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(alertType.alertLabel)
        EndTextCommandSetBlipName(AlertBlip)
    end
    AlertBlips[#AlertBlips+1] = {BlipId = AlertBlip, AlertData = alertType}
    Wait(KIBRA.RemovalTimeOfAlertBlips * 1000)
    RemoveBlip(AlertBlip)
end

local function GetAddress(coords)
    if coords == nil then return Lang.unkownLocation end
    local AddressHash = GetNameOfZone(coords.x, coords.y, coords.z)
    local Address = GetLabelText(AddressHash) 
    local StreetNameAtCoord = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local StreetNameFinal = GetStreetNameFromHashKey(StreetNameAtCoord)
    local Result = Address..' | '..StreetNameFinal
    if not Result then Result = Lang.unkownLocation end
    return Result
end

local function IsPlayerInDisabledZone(ped)
    if not ped then return end 
    local PedCoord = GetEntityCoords(ped)
    local InZone = false
    local DisabledZones = GetSettingFromName('dispatchExclusion')
    for k,v in pairs(DisabledZones.coords) do
        local DisabledCoords = vec3(v.coord.x, v.coord.y, v.coord.z)
        if #(DisabledCoords - PedCoord) <= v.radius then
            InZone = true
        end
    end
    return InZone
end

local function GetPlayerGender()
    local Gender = Lang.unkown
    local PlayerPed = PlayerPedId()
    local PedModel = GetEntityModel(PlayerPed)
    if PedModel == KIBRA.PedModelsGender.Male then
        return Lang.male
    elseif PedModel == KIBRA.PedModelsGender.Female then
        return Lang.female
    end
    return Gender
end

local function CheckWitnesses(witnesses, witped)
    local state = false 

    for k,v in pairs(witnesses) do
        if IsPedAPlayer(v) then
            if v == witped then
                return true
            end
        end
    end

    return state
end

local function GetPlayerWeapon()
    local PlayerPed = PlayerPedId()
    return Weapons[GetSelectedPedWeapon(PlayerPed)].label
end

local function FindColor(id)
    local description = Lang.unkown
    for k,v in pairs(VehicleColours) do
        if v.ID == id then
            return v.Description
        end
    end
    return description
end

RegisterNetEvent('Kibra:Dispatch:SendCustomAlert', function(alertLabel, code, icon, jobs, blipId)
    local ped = PlayerPedId()
    local blipOfcId = 3
    if blipId then blipOfcId = blipId end
    local CheckPlayerZone = IsPlayerInDisabledZone(ped)
    if CheckPlayerZone then return end
    local PedGender = GetPlayerGender()
    local EventCoord = GetAddress(GetEntityCoords(ped))
    local GetWeapon = GetPlayerWeapon()
    local Vehicle = nil
    TriggerServerEvent('Kibra:Dispatch:SendAlert', 'custom', {
        address = EventCoord,
        gender = PedGender,
        alertLabel = alertLabel,
        blipOfcId = blipOfcId,
        jobs = jobs,
        custom = true,
        responders = {},
        coords = GetEntityCoords(ped),
        pressKey = KIBRA.RespondeButton,
        icon = icon or 'fa-hand',
        code = code,
    })
end)

exports('SendAlert', function(alertLabel, code, icon, jobs, blipId)
    local ped = PlayerPedId()
    local blipOfcId = 3
    if blipId then blipOfcId = blipId end
    local CheckPlayerZone = IsPlayerInDisabledZone(ped)
    if CheckPlayerZone then return end
    local PedGender = GetPlayerGender()
    local EventCoord = GetAddress(GetEntityCoords(ped))
    local GetWeapon = GetPlayerWeapon()
    local Vehicle = nil
    TriggerServerEvent('Kibra:Dispatch:SendAlert', type, {
        address = EventCoord,
        gender = PedGender,
        alertLabel = alertLabel,
        blipOfcId = blipOfcId,
        jobs = jobs,
        custom = true,
        responders = {},
        coords = GetEntityCoords(ped),
        pressKey = KIBRA.RespondeButton,
        icon = icon or 'fa-hand',
        code = code,
    })
end)

exports('GetDispatchAlerts', function()
    return DispatchAlerts
end)

exports('GetSelectedAlerts', function(job)
    local policeAlerts = {}
    for k,v in pairs(DispatchAlerts) do
        if v.type ~= 'emsWorkerInjured' then
            policeAlerts[#policeAlerts+1] = v
        end
    end
    return policeAlerts
end)

exports('GetSelectedEmsAlerts', function(job)
    local policeAlerts = {}
    for k,v in pairs(DispatchAlerts) do
        if v.job == job then
            policeAlerts[#policeAlerts+1] = v
        end
    end
    return policeAlerts
end)

local function GetEventVehicle(veh)
    local VehicleColor1, VehicleColor2 = GetVehicleColours(veh)
    return {
        vehicleClassName = VehicleClasses[GetVehicleClass(veh)] or Lang.unkown,
        vehicleColorName = FindColor(VehicleColor1) ..' | '..FindColor(VehicleColor2),
        vehiclePlate = GetVehicleNumberPlateText(veh)
    }
end

AddEventHandler('CEventGunShot', function(witnesses, ped)
    local type = 'shooting'
    local EventType = GetSettingFromName(type)
    if not EventType.state then return end
    if IsPedCurrentWeaponSilenced(ped) then return end
    if PlayerPedId() ~= ped then return end
    ExecuteWithCooldown(type, function()
        local CheckPlayerZone = IsPlayerInDisabledZone(ped)
        if CheckPlayerZone then return end
        if witnesses and not CheckWitnesses(witnesses, ped) then return end
        local PedGender = GetPlayerGender()
        local EventCoord = GetAddress(GetEntityCoords(ped))
        local GetWeapon = GetPlayerWeapon()
        local Vehicle = nil
        if IsPedInAnyVehicle(ped, false) and GetSettingFromName('vehicleshooting').state then Vehicle = GetVehiclePedIsIn(ped, false) end
        TriggerServerEvent('Kibra:Dispatch:SendAlert', type, {
            address = EventCoord,
            gender = PedGender,
            coords = GetEntityCoords(ped),
            title = Lang[type],
            witnesses = #witnesses,
            vehicle = Vehicle,
            responders = {},
            plateAccess = KIBRA.ShowVehiclePlate,
            eventVehicleData = GetEventVehicle(Vehicle) or {},
            pressKey = KIBRA.RespondeButton,
            weapon = GetWeapon,
            icon = 'fa-gun',
            code = KIBRA.AlertCodes[type]
        })
    end)
end)


AddEventHandler("gameEventTriggered", function(name, args)
    if name ~= "CEventNetworkEntityDamage" then return end
    local Victim = args[1]
    local IsDead = args[6] == 1
    if not IsDead then return end

    local idx = NetworkGetPlayerIndexFromPed(Victim)
    if idx ~= PlayerId() then return end  -- < burayı ekle

    local type = 'civilianInjured'
    local Settings = GetSettingFromName(type)
    if not Settings.state then return end
    if not IsPedAPlayer(Victim) then return end

    local pJob = lib.callback.await('Kibra:Dispatch:GetVictimJob', false, GetPlayerServerId(idx))
    if pJob == 'police' then
        type = 'DeathNotifications'
    elseif pJob == 'ambulance' then
        type = 'emsWorkerInjured'
    end
    ExecuteWithCooldown(type, function()
        local CheckPlayerZone = IsPlayerInDisabledZone(Victim)
        if CheckPlayerZone then return end
        local PedGender = GetPlayerGender()
        local EventCoord = GetAddress(GetEntityCoords(Victim))
        local GetWeapon = GetPlayerWeapon()
        TriggerServerEvent('Kibra:Dispatch:SendAlert', type, {
            address = EventCoord,
            gender = PedGender,
            victimIdx = idx,
            settingtype = type,
            coords = GetEntityCoords(Victim),
            title = Lang[type],
            witnesses = nil,
            playerJob = pJob,
            vehicle = false,
            responders = {},
            pressKey = KIBRA.RespondeButton,
            weapon = GetWeapon,
            icon = 'fa-kit-medical',
            code = KIBRA.AlertCodes[type]
        })
    end)
end)


AddEventHandler('CEventShockingSeenMeleeAction', function(witnesses, ped)
    local EventType = GetSettingFromName('fighting')
    local type = 'fighting'
    if not EventType.state then return end
    if PlayerPedId() ~= ped then return end
    ExecuteWithCooldown('fighting', function()
        local CheckPlayerZone = IsPlayerInDisabledZone(ped)
        if CheckPlayerZone then return end
        if witnesses and not CheckWitnesses(witnesses, ped) and not witnesses[1] == PlayerPedId() then return end
        if not IsPedInMeleeCombat(ped) then return end
        
        local targetPed = GetMeleeTargetForPed(ped)
        if not DoesEntityExist(targetPed) then return end
        
        local PedGender = GetPlayerGender()
        local EventCoord = GetAddress(GetEntityCoords(ped))
        local GetWeapon = GetPlayerWeapon()
        TriggerServerEvent('Kibra:Dispatch:SendAlert', 'fighting', {
            address = EventCoord,
            gender = PedGender,
            coords = GetEntityCoords(ped),
            witnesses = #witnesses,
            pressKey = KIBRA.RespondeButton,
            title = Lang[type],
            responders = {},
            weapon = GetWeapon,
            icon = 'fa-hands',
            code = KIBRA.AlertCodes['fighting']
        })
    end)
end)

AddEventHandler('CEventExplosionHeard', function(witnesses, ped)
    local EventType = GetSettingFromName('explosion')
    local type = 'explosion'
    if not EventType.state then return end
    ExecuteWithCooldown('explosion', function()
        local CheckPlayerZone = IsPlayerInDisabledZone(ped)
        if CheckPlayerZone then return end
        if witnesses and not CheckWitnesses(witnesses, ped) and not witnesses[1] == PlayerPedId() then return end
        local PedGender = GetPlayerGender()
        local EventCoord = GetAddress(GetEntityCoords(ped))
        TriggerServerEvent('Kibra:Dispatch:SendAlert', 'explosion', {
            address = EventCoord,
            gender = PedGender,
            coords = GetEntityCoords(ped),
            witnesses = #witnesses,
            responders = {},
            title = Lang[type],
            pressKey = KIBRA.RespondeButton,
            icon = 'fa-bomb',
            code = KIBRA.AlertCodes['explosion']
        })
    end)
end)

RegisterCommand('setalertcoord', function()
    if LastAlertId ~= 0 then
        if AlertShowed[LastAlertId].Show then
            Wait(100)
            SetNewWaypoint(LastAlertCoord.x, LastAlertCoord.y)
            KIBRA.Notification('success', string.format(Lang.succnewway, LastAlertId))
            SendNUIMessage({
                action = 'alertSiren',
                data = {id = LastAlertId}
            })
            TriggerServerEvent('Kibra:Dispatch:AddResponder', LastAlertId)
        end
    end
end)

RegisterNetEvent('Kibra:Dispatch:AddResponder', function(alertId, pName)
    if not DispatchAlerts[alertId] then
        DispatchAlerts[alertId] = {}
    end

    if not DispatchAlerts[alertId].responders then
        DispatchAlerts[alertId].responders = {}
    end

    table.insert(DispatchAlerts[alertId].responders, pName)
end)


RegisterNUICallback('respondAlert', function(data, cb)
    if data.alertId == nil then return end
    local AlertId = tonumber(data.alertId)
    local AlertData = DispatchAlerts[AlertId]
    SetNewWaypoint(AlertData.coords.x, AlertData.coords.y)
    KIBRA.Notification('success', string.format(Lang.succnewway, AlertId))
    TriggerServerEvent('Kibra:Dispatch:AddResponder', AlertId)
    cb('ok')
end)

RegisterKeyMapping('setalertcoord', 'Set Dispatch Coord', 'keyboard', KIBRA.RespondeButton)
RegisterKeyMapping('changealert', 'Next Alert', 'keyboard', KIBRA.NextAlertButton)

RegisterCommand('changealert', function()
    if LastAlertId ~= 0 and not AlertShowed[LastAlertId].Show then return end
    if TempAlerts == 0 then
        TempAlerts = #AlertShowed + 1
    end

    TempAlerts = TempAlerts - 1

    if TempAlerts == 0 then
        TempAlerts = #AlertShowed
    end

    LastAlertId = TempAlerts

    if #AlertShowed > 1 then 
        SendNUIMessage({
            action = 'changeAlert',
            data = {topalerts = TempAlerts}
        })
    end

end)

local function Duplicate(type)
    local AlertData = GetSettingFromName(type)
    local pData = Resmon.Lib.GetPlayerData()
    local check = 0
    for k,v in pairs(AlertData.receivers) do
        if v == pData.job.name then
            check = check + 1
        end
    end
    return check
end

local function CheckAlertJob(type, custom)
    local PlayerData = Resmon.Lib.GetPlayerData()
    local AlertData = GetSettingFromName(type)
    local Check = false
    if not custom or not AlertData then
        for setNo, setData in pairs(AlertData.receivers) do
            if setData == PlayerData.job.name then
                return true
            end
        end
    else
        for setNo, setData in pairs(type) do
            if setData == PlayerData.job.name then
                return true
            end
        end
    end

    return Check
end

local rec={}

RegisterNetEvent('Kibra:Dispatch:SendAlert',function(alertData)
    if AlertShowed[alertData.id]then return end
     if rec[alertData.id] then return end
    rec[alertData.id]=true

    if not alertData.custom then
        if not CheckAlertJob(alertData.type,false)then return end
    else
        if not alertData.jobs or not CheckAlertJob(alertData.jobs,true)then return end
    end
    if KIBRA.PoliceDontSendFireNotices then
        local receivers=GetSettingFromName(alertData.type).receivers
        for _,job in ipairs(receivers)do
            if job==alertData.job then return end
        end
    end
    DispatchAlerts[#DispatchAlerts+1]=alertData
    if IsDispatchListOpened then
        TriggerServerEvent('Kibra:Dispatch:OpenDispatchList',GetPlayerServerId(PlayerId()))
        return
    end
    AlertShowed[alertData.id]={Show=true}
    alertData.detail=KIBRA.DispatchAlertLessDetail
    LastAlertId=alertData.id
    DispatchAlert(alertData)
    LastAlertCoord=alertData.coords
    TimerThread(alertData)
    CreateAlertBlip(alertData)
end)

CurrentTime = function(kayitli_zaman, latest)
    local simdiki_zaman = latest
    local fark = simdiki_zaman - kayitli_zaman
    local fark_saniye = fark / 1000
    local fark_dakika = fark_saniye / 60
    local fark_saat = fark_dakika / 60

    if fark_saat >= 1 then
        return string.format(Lang.hourago, math.floor(fark_saat))
    elseif fark_dakika >= 1 then
        return string.format(Lang.minuteago, math.floor(fark_dakika))
    else
        return string.format(Lang.secondago, math.floor(fark_saniye))
    end
end

RegisterNetEvent('Kibra:Dispatch:OpenDispatchList', function(dataa, time)
    if OpenedAdminUI then return end
    SetNuiFocus(true, true)
    local Appreacite = {}
    IsDispatchListOpened = true

    for k,v in pairs(dataa) do
        Appreacite[#Appreacite+1] = v
    end

    for k,v in pairs(DispatchAlerts) do
        v.timestring = CurrentTime(v.time, time)
    end

    table.sort(DispatchAlerts, function(a, b)
        return a.time > b.time
    end)

    SendNUIMessage({
        action = 'OpenDispatchList',
        data = {lang = Lang, dispatchData = Appreacite, dispatchlist = DispatchAlerts, location = KIBRA.DispatchListUILocation}
    })
end)

if KIBRA.OpenDispatchMenuWithKey.CanBeOpenedWithKey then
    RegisterCommand(KIBRA.OpenDispatchMenuCommandName, function()
        TriggerServerEvent('Kibra:Dispatch:OpenDispatchList', GetPlayerServerId(PlayerId()))
    end)

    RegisterKeyMapping(KIBRA.OpenDispatchMenuCommandName, 'Open Dispatch List', 'keyboard', KIBRA.OpenDispatchMenuWithKey.Key)
end

RegisterNUICallback('deleteDispatches', function(data, cb)
    SendNUIMessage({action = 'closeDispatchList'})
    DispatchAlerts = {}
    for k,v in pairs(AlertBlips) do
        RemoveBlip(v.BlipId)
    end
    cb('ok')
end)

exports('VehicleTheft', function(Vehicle)
    local type = 'vehicletheft'
    local EventType = GetSettingFromName(type)
    local ped = PlayerPedId()
    if not EventType.state then return end
    ExecuteWithCooldown(type, function()
        local CheckPlayerZone = IsPlayerInDisabledZone(ped)
        if CheckPlayerZone then return end
        local PedGender = GetPlayerGender()
        local Vehicle = Vehicle
        TriggerServerEvent('Kibra:Dispatch:SendAlert', type, {
            address = GetAddress(GetEntityCoords(Vehicle)),
            gender = PedGender,
            coords = GetEntityCoords(Vehicle),
            witnesses = nil,
            vehicle = Vehicle,
            title = Lang[type],
            responders = {},
            plateAccess = KIBRA.ShowVehiclePlate,
            eventVehicleData = GetEventVehicle(Vehicle) or {},
            pressKey = KIBRA.RespondeButton,
            icon = 'fa-car',
            code = KIBRA.AlertCodes[type]
        })
    end)
end)

exports('HouseRobbery', function(HouseCoord)
    local type = 'houseRobbery'
    local EventType = GetSettingFromName(type)
    local ped = PlayerPedId()
    if not EventType.state then return end
    ExecuteWithCooldown(type, function()
        local CheckPlayerZone = IsPlayerInDisabledZone(ped)
        if CheckPlayerZone then return end
        local PedGender = GetPlayerGender()
        local Vehicle = nil
        TriggerServerEvent('Kibra:Dispatch:SendAlert', type, {
            address = GetAddress(HouseCoord),
            gender = PedGender,
            coords = HouseCoord,
            witnesses = nil,
            vehicle = Vehicle,
            title = Lang[type],
            responders = {},
            plateAccess = KIBRA.ShowVehiclePlate,
            pressKey = KIBRA.RespondeButton,
            icon = 'fa-house',
            code = KIBRA.AlertCodes[type]
        })
    end)
end)

exports('ShopRobbery', function(ShopCoord)
    local type = 'ShopRobbery'
    local EventType = GetSettingFromName(type)
    local ped = PlayerPedId()
    if not EventType.state then return end
    ExecuteWithCooldown(type, function()
        local CheckPlayerZone = IsPlayerInDisabledZone(ped)
        if CheckPlayerZone then return end
        local PedGender = GetPlayerGender()
        local Vehicle = nil
        TriggerServerEvent('Kibra:Dispatch:SendAlert', type, {
            address = GetAddress(ShopCoord),
            gender = PedGender,
            coords = ShopCoord,
            witnesses = nil,
            vehicle = Vehicle,
            title = Lang[type],
            responders = {},
            plateAccess = KIBRA.ShowVehiclePlate,
            pressKey = KIBRA.RespondeButton,
            icon = 'fa-shop',
            code = KIBRA.AlertCodes[type]
        })
    end)
end)


RegisterNetEvent('Kibra:Dispatch:OpenDispatchAdmin', function(auth)
    if not auth then return end
    if OpenedAdminUI or IsDispatchListOpened then return end
    OpenedAdminUI = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'OpenDispatchAdmin',
        data = {lang = Lang, settings = Settings}
    })
end)

function DispatchAlert(data)
    if data == nil then return end
    if KIBRA.NotifySound then
        PlaySoundFrontend(-1, "LOOSE_MATCH", "HUD_MINI_GAME_SOUNDSET", true)
    end
    SendNUIMessage({
        action = 'DispatchAlert',
        data = {lang = Lang, dispatchData = data, location = KIBRA.DispatchUILocation}
    })
end

RegisterNUICallback('updateDelayTime', function(data, cb)
    data.data = tonumber(data.data)
    Resmon.Lib.Callback.Client('Kibra:Dispatch:UpdateTimeZone', function(callbck)
        if callbck then
            KIBRA.Notification('success', string.format(Lang.updatedDelayTime, data.data))
        else
            KIBRA.Notification('error', Lang.hadProblem)
        end
        cb('ok')
    end, data)
end)

RegisterNUICallback('disableNUI', function(data, cb)
    SetNuiFocus(false, false)
    OpenedAdminUI = false
    IsDispatchListOpened = false
    cb('ok')
end)

GetSettingFromName = function(name)
    local returned = {}

    for k,v in pairs(Settings) do
        if v.type == name then
            return v 
        end
    end

    return returned
end

local function checkVehicleSpeed(witnesses, ped)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local type = 'vehiclespeed'
    local EventType = GetSettingFromName('vehiclespeed')
    if not EventType.state then return end
    if vehicle then
        local currentSpeed = GetEntitySpeed(vehicle)
        local speedKmh = currentSpeed * 3.6
        local speedMph = currentSpeed * 2.23694
        local EventType = GetSettingFromName('vehiclespeed')
        if not EventType.state then return end
        if PlayerPedId() ~= ped then return end
        ExecuteWithCooldown('vehiclespeed', function()
            local CheckPlayerZone = IsPlayerInDisabledZone(ped)
            if CheckPlayerZone then return end
            if witnesses and not CheckWitnesses(witnesses, ped) and not witnesses[1] == PlayerPedId() then return end
            local EventCoord = GetAddress(GetEntityCoords(ped))
            local Vehicle = GetVehiclePedIsIn(ped, false)
            TriggerServerEvent('Kibra:Dispatch:SendAlert', 'vehiclespeed', {
                address = EventCoord,
                coords = GetEntityCoords(ped),
                witnesses = #witnesses,
                gender = GetPlayerGender(),
                vehicle = Vehicle,
                plateAccess = KIBRA.ShowVehiclePlate,
                responders = {},
                eventVehicleData = GetEventVehicle(Vehicle) or {},
                title = Lang[type],
                pressKey = KIBRA.RespondeButton,
                icon = 'fa-car',
                code = KIBRA.AlertCodes['vehiclespeed']
            })
        end)
        -- if speedKmh > previousSpeed then
            
        --     print("Araç hızlanıyor. Hız (km/h): " .. speedKmh .. " | Hız (mph): " .. speedMph)
        -- end
        previousSpeed = speedKmh
    end
end

TheEvents = {
    'CEventShockingDrivingOnPavement',
    'CEventShockingMadDriverExtreme',
    'CEventShockingEngineRevved',
    'CEventCopCarBeingStolen',
    'CEventShockingCarChase'
}

for i = 1, #TheEvents do
    AddEventHandler(TheEvents[i], checkVehicleSpeed)
end

ToggleRadius = function(type)
    if type == false then
        if RadiusValue >= 1 then
            RadiusValue = RadiusValue - .5
        end
    else
        RadiusValue = RadiusValue + .5
    end

    ShowText()
end

RegisterKeyMapping('decradius', 'Decrease Radius Value', 'keyboard', KIBRA.Controls.decreaseRadius[2])
RegisterKeyMapping('incradius', 'Increase Radius Value', 'keyboard', KIBRA.Controls.increaseRadius[2])
RegisterKeyMapping('setcoord', 'Set Coord Area', 'keyboard', KIBRA.Controls.setCoord[2])
RegisterKeyMapping('closeCoordScreen', 'Close Zone Editor', 'keyboard', KIBRA.Controls.cancel[2])

RegisterCommand('decradius', function()
    if WorkThread then
        lib.hideTextUI()
        ToggleRadius(false)
    end
end)

RegisterCommand('closeCoordScreen', function()
    if WorkThread then
        lib.hideTextUI()
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'OpenDispatchAdmin',
            data = {lang = Lang, settings = Settings}
        })
        WorkThread = false
    end
end)

RegisterCommand('incradius', function()
    if WorkThread then
        ToggleRadius(true)
    end
end)

RegisterCommand('setcoord', function()
    if WorkThread then
        local input = lib.inputDialog(Lang.coordName, {  
            {type = 'input', label = Lang.coordName, description = Lang.infoZone, required = true, min = 4, max = 16}
        })
        if input == nil then return end 
        
        Resmon.Lib.Callback.Client('Kibra:Dispatch:AddNewZone', function(callbck)
            if callbck then
                KIBRA.Notification('success', Lang.addedArea, 3000)
                WorkThread = false
                lib.hideTextUI()
            else
                KIBRA.Notification('error', Lang.diffArea, 3000)
            end
        end, {coord = GetEntityCoords(PlayerPedId()), radius = RadiusValue, name = input[1]})
    end
end)

AddEventHandler('onClientResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        lib.hideTextUI()
    end
end)

AddEventHandler('onClientResourceStop',  function(resource)
    if resource == GetCurrentResourceName() then
        lib.hideTextUI()
    end
end)

RegisterNUICallback('addNewReceiver', function(data, cb)
    if data.data ~= '' and data.data ~= nil then
        Resmon.Lib.Callback.Client('Kibra:Dispatch:AddNewReceiver', function(exportData)
            if exportData then
                local settingData = GetSettingFromName(data.type)
                KIBRA.Notification('success', string.format(Lang.addedNewJob, data.type), 3000)
                cb(settingData.receivers)
            else
                cb(false)
                KIBRA.Notification('error', Lang.alreadyAdded, 3000)
            end
        end, data)
    else
        cb(false)
        KIBRA.Notification('error', Lang.cantBlank, 3000)
    end
end)

RegisterNUICallback('updateSettingState', function(data, cb)
    TriggerServerEvent('Kibra:Dispatch:UpdateSetting', data)
    cb('ok')
end)

RegisterNetEvent('Kibra:Dispatch:UpdateSetting', function(settingData)
    for k,v in pairs(Settings) do
        if v.type == settingData.type then
            v[settingData.datatype] = settingData.data
        end
    end
end)

RegisterNetEvent('Kibra:Dispatch:UpdateTime', function(data)
    for k,v in pairs(Settings) do
        if v.type == data.typex then
            v.value = data.data
        end
    end
end)

RegisterNUICallback('setAddCoordScreen', function(data, cb)
    SetNuiFocus(false, false)
    ShowText()
    WorkThread = true
    cb('ok')
end)

RegisterNUICallback('removeZone', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:Dispatch:RemoveZone', function(callback)
        if callback then
            local settingData = GetSettingFromName('dispatchExclusion')
            KIBRA.Notification('success', string.format(Lang.deletedZone, data.zone), 3000)
            cb(settingData)
        else
            KIBRA.Notification('error', Lang.hadProblem, 3000)
            cb(false)
        end
    end, data)
end)

RegisterNetEvent('Kibra:Dispatch:RemoveZone', function(zoneName)
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
end)

ShowText = function()
    local text = KIBRA.Controls.setCoord[1]..' || '..Lang.setAreaCoord..' || '..KIBRA.Controls.increaseRadius[1]..' - '..Lang.incRadius..' || '..KIBRA.Controls.decreaseRadius[1]..' || '..Lang.cancel..' '..KIBRA.Controls.cancel[1]..' - '..Lang.decRadius..' || '..string.format(Lang.radiusValue, RadiusValue)
    lib.showTextUI(text, {
        position = "top-center",
        icon = 'globe',
    })
end

RegisterNUICallback('removeJobInSettings', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:Dispatch:RemoveReceiverJob', function(callbck)
        if callbck then
            local settingData = GetSettingFromName(data.data)
            KIBRA.Notification('success', string.format(Lang.deletedJob, data.type), 3000)
            cb(settingData.receivers)
        else
            cb(false)
            KIBRA.Notification('error', Lang.hadProblem, 3000)
        end
    end, data)
end)

RegisterNetEvent('Kibra:Dispatch:UpdateReceiversSetting', function(settingData, typee)
    for k,v in pairs(Settings) do
        if typee == 'add' then
            if v.type == settingData.type then
                v.receivers[#v.receivers+1] = settingData.data
            end
        else
            if v.type == settingData.data then
                for q,s in pairs(v.receivers) do
                    if s == settingData.type then
                        table.remove(v.receivers, q)
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('Kibra:Dispatch:UpdateNonZones', function(settingData, typee)
    for k,v in pairs(Settings) do
        if typee == 'add' then
            if v.type == 'dispatchExclusion' then
                v.coords[#v.coords+1] = settingData
            end
        else
            if v.type == 'dispatchExclusion' then
                for q,s in pairs(v.coords) do
                    if s == settingData then
                        table.remove(v.coords, q)
                    end
                end
            end
        end
    end
end)

