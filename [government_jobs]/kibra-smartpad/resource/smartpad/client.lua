isTabletOpened = false
tabletData = {}
OpenedTabletSerialNumber = nil
Shared.ScriptName = GetCurrentResourceName()
Shared.LangData = json.decode(LoadResourceFile(Shared.ScriptName, "locales/"..Shared.Lang..".json"))
classes = json.decode(LoadResourceFile(Shared.ScriptName, "data/classes.json"))
Resmon = exports["0r_lib"]:GetCoreObject()
CameraMode = false
PlayerHandTablet = nil
MiniGameStarted = false
MDTDATABASE = {}
AllNotes = json.decode(LoadResourceFile(Shared.ScriptName, "data/notes.json"))
SharedLocations = json.decode(LoadResourceFile(Shared.ScriptName, "data/sharedlocations.json"))
EMSChat = json.decode(LoadResourceFile(Shared.ScriptName, "data/ems_chat.json"))
MDTChat = json.decode(LoadResourceFile(Shared.ScriptName, "data/mdt_chat.json"))
AllInvoices = {}
AllMails = {}
AllNews = {}
coordsList = {}
AllNewsApplications =  {}
AllCharges = json.decode(LoadResourceFile(Shared.ScriptName, "data/charges.json"))
EMSDATABASE = {}
INSURANCEDATABASE = {}
OpenedTabletLang = {}
ShowedGunLicense = false
RCloudDb = {}
MapOpened = false
SharedLocs = {}
Zones = json.decode(LoadResourceFile(Shared.ScriptName, "data/zones.json"))

-- RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
--     print(('[QBCore] Job değişti: %s - Grade: %s'):format(job.name, job.grade.level))
-- end)

RegisterNetEvent('Kibra:SmartPad:Client:ShareLocationEveryone', function(tabOwner, pCid)
    if not SharedLocations[tabOwner] then SharedLocations[tabOwner] = {} end
    SharedLocations[tabOwner][pCid] = true
end)

-- RegisterNetEvent('esx:setJob', function(job)
--     print(('[ESX] Job değişti: %s - Grade: %s'):format(job.name, job.grade))
-- end)

function GetBlipName(blip)
    BeginTextCommandGetBlipNameForVar("STRING")
    AddTextComponentSubstringBlipName(blip)
    return EndTextCommandGetBlipNameForVar()
end

blips = {}

PoliceCall = function ()
    exports["kibra-dispatch"]:SendAlert("10-15 - Store Robbery", "10-15", "fa-vehicle", {"police"}, 431)
end

CreateThread(function()
    for sprite=0,802 do
        local b=GetFirstBlipInfoId(sprite)
        while DoesBlipExist(b) do
            local x,y,z=table.unpack(GetBlipInfoIdCoord(b))
            local label = GetBlipInfoIdDisplay(b)
            local name  = GetLabelText(label)

            table.insert(blips,{id=b,t=GetBlipInfoIdType(b),sprite=sprite,x=x,y=y,z=z,name=name})
            b=GetNextBlipInfoId(sprite)
        end
    end
end)


function RenderClient()
    Wait(1000)
    while true  do
        Citizen.Wait(1)	 
        if NetworkIsPlayerActive(PlayerId()) then
            TriggerServerEvent('Kibra:SmartPad:Server:RequestData')
        end
        break
    end
end

RegisterNetEvent('Kibra:SmartPad:ShowNotificationInTablet', function(data)
    data.opened = isTabletOpened
    data.location = Shared.TabletNotificationLocationInCloseTablet
    SendNUIMessage({
        action = 'tabletNotification',
        data = data
    })
end)

RegisterNetEvent('Kibra:SmartPad:UpdateChargeLevel', function(serial, charge)
    AllCharges[serial] = charge
    if OpenedTabletSerialNumber == serial then
        SendNUIMessage({action = 'updateCharge', data = {batteryLevel = charge}})
    end
end)

RegisterCommand('dx', function()
    TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'mdt', {
        title = 'Yeni Bir Mesaj',
        only = true,
        message = 'Silah lisansı eklendi',
        icon = 'mdt'
    })
end)


function TabletNotification(title, message, options)
    SendNUIMessage({
        action = 'tabletNotify',
        data = {title = title, msg = message, opts = options}
    })
end

RegisterNetEvent('Kibra:SmartPad:AddComment', function(code, datax)
    for k,v in pairs(AllNews) do
        if v.code == code then
            v.comments[#v.comments+1] = datax
        end
    end

    if isTabletOpened then
        SendNUIMessage({action = 'addNewComments', data = {code = code, datax = datax}})
    end
end)

RegisterNetEvent('Kibra:SmartPad:Client:SendTabletData', function(data, mdtDb, emsDb, invoices, mails, rcloud, news, applications, insuranceDb)
    for k,v in pairs(data) do
        Shared.Tablets[k] = v
    end
    AllInvoices = invoices
    AllMails = mails
    EMSDATABASE = emsDb
    MDTDATABASE = mdtDb
    INSURANCEDATABASE = insuranceDb or {}
    RCloudDb = rcloud
    AllNews = news
    AllNewsApplications = applications
end)

RegisterNetEvent('SmartPad:Ox:Notification', function(title, text, type)
    lib.notify({
        title = title,
        description = text,
        type = type                         
    })
end)   

RegisterNetEvent('Kibra:SmartPad:Client:UpdateNews', function(data)
    local new = #AllNews + 1
    AllNews[new] = data
    if isTabletOpened then
        SendNUIMessage({action = 'setAllNews', data = AllNews[new]})
    end
end)

function TabletNotify(title, msg, options)
    SendNUIMessage({
        action = 'tabletNotify',
        data = {message = msg, title = title},
        options = options
    })
end

function FindTabletData(serialNumber)
    local data = {}
    for k,v in pairs(Shared.Tablets) do
        if v.serialnumber == serialNumber then
            table.insert(data, v)
        end
    end
    return data
end

function GetTabletLang(lang)
    local curlang = json.decode(LoadResourceFile(Shared.ScriptName, "locales/en.json"))
    if lang then
        curlang = json.decode(LoadResourceFile(Shared.ScriptName, "locales/"..lang..".json"))
    end
    return curlang
end

function BringApps(tabOwnerJob, tabOwnerJobGrade, hackMode)
    local apps = {}

    for _, v in pairs(Shared.Apps) do
        if v.AppHash == "bossdesk" then
            if tabOwnerJob and Resmon.Lib.Contains(v.Jobs, tabOwnerJob) and tabOwnerJobGrade == 4 then
                apps[#apps + 1] = v
            end
        elseif v.AppHash == "dojapp" and Shared.JudicialMode == false then
            -- geç
        elseif not v.Jobs or Resmon.Lib.Contains(v.Jobs, tabOwnerJob) then
            apps[#apps + 1] = v
        end
    end

    if hackMode then
        local maxSlot = 0
        for _, v in ipairs(apps) do
            if v.Slot and v.Slot > maxSlot then
                maxSlot = v.Slot
            end
        end

        apps[#apps + 1] = {
            App = Shared.LangData.hackingapp,
            Icon = 'hacking.png',
            AppHash = 'minigame',
            Default = false,
            Jobs = false,
            Slot = maxSlot + 1,
            Widget = false
        }
    end

    table.sort(apps, function(a, b)
        return (a.Slot or 999) < (b.Slot or 999)
    end)

    return apps
end



function GiveTabletPlayerHand()
    RequestAnimDict("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a")
    while not HasAnimDictLoaded("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a") do
        Citizen.Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a" ,8.0, -8.0, -1, 50, 0, false, false, false)
    tab = CreateObject(GetHashKey("prop_cs_tablet"), 0, 0, 0, true, true, true)
	AttachEntityToEntity(tab, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), -0.05, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
end

function RemoveTabletPHand()
	StopAnimTask(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a" ,8.0, -8.0, -1, 50, 0, false, false, false)
	DeleteObject(tab)
end

function CheckApp(tabApps, appname)
    local found = false
    for k,v in pairs(tabApps) do
        if appname == v.AppHash then
            return true
        end
    end
    return found
end

function GetAddress(coords)
    if coords == nil then return Shared.LangData.unkownLocation end
    local AddressHash = GetNameOfZone(coords.x, coords.y, coords.z)
    local Address = GetLabelText(AddressHash) 
    local StreetNameAtCoord = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local StreetNameFinal = GetStreetNameFromHashKey(StreetNameAtCoord)
    local Result = Address..' | '..StreetNameFinal
    if not Result then Result = Shared.LangData.unkownLocation end
    return Result
end

RegisterCommand("araba", function(source, args)
    local modelName = args[1]
    if not modelName then
        return
    end

    local model = GetHashKey(modelName)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, GetEntityHeading(ped), true, false)
    TaskWarpPedIntoVehicle(ped, vehicle, -1)
end)

function GetTabletNotes(serialNumber)
    local allnotes = AllNotes
    local notes = {}

    for k, v in pairs(allnotes) do
        if v.owner == serialNumber then
            v.id = k
            notes[#notes+1] = v
        end
    end

    return notes
end

RegisterNetEvent('Kibra:SmartPad:Client:UpdateNotes', function(id, data)
    AllNotes[id] = data
end)

RegisterNetEvent('Kibra:SmartPad:UpdateNotesSelf', function()
    SendNUIMessage({
        action = 'updateallNote',
        data = {data = GetTabletNotes(OpenedTabletSerialNumber)}
    })
end)

RegisterNetEvent('Kibra:SmartPad:Client:AddNewMail', function(data)
    AllMails[#AllMails+1] = data
end)

RegisterNetEvent('Kibra:SmartPad:Client:NewMail', function()
    if isTabletOpened then
        local mails, sented = GetTabletMails(OpenedTabletSerialNumber)
        SendNUIMessage({
            action = 'updateMails',
            data = {data = mails, data2 = sented}
        })
    end
    TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'mail', {
        title = OpenedTabletLang.success,
        only = false,
        message = OpenedTabletLang.newma,
        icon = 'mail'
    })
end)

function CheckInvoiceJob(tabOwnerJob, Grade)
    if Shared.InvoiceAllowedJobs[tabOwnerJob] then
        for k,v in ipairs(Shared.InvoiceAllowedJobs[tabOwnerJob]) do
            if v == Grade then
                return true
            end
        end
    end

    return false
end

function GetTabletBillings(serial)
    local f = FindTabletData(serial)
    local d = f[1]
    local bills = {}

    for k,v in pairs(AllInvoices) do
        if v.owner == d.owner then
            bills[#bills+1] = v
        end
    end

    return bills
end

function GetAllEmails()
    local mails = {}
    for k,v in pairs(Shared.Tablets) do
        mails[#mails+1] = v.email
    end
    return mails
end

function GetTabletMails(serial)
    local f = FindTabletData(serial)
    local d = f[1]
    local mails = {}
    local sentmails = {}

    for k,v in pairs(AllMails) do
        if v.receiver == d.email then
            mails[#mails+1] = v
        end
    end

    for k,v in pairs(AllMails) do
        if v.from == d.email then
            sentmails[#sentmails+1] = v
        end
    end

    return mails, sentmails
end

function GetCourtRooms()
    local rooms = Shared.CourtRooms
    for k,v in pairs(rooms) do
        v.location = GetAddress(v.Coords)
    end
    return rooms
end

function ineedallmeyils()
    local m = {}
    for k,v in pairs(RCloudDb) do
        m[#m+1] = v.mail
    end
    return m
end

function checkNewsBoss(tabOwnerJob)
    if tabOwnerJob == Shared.JournalistJob then
        return true
    else
        return false
    end
end

RegisterNetEvent('Kibra:SmartPad:OpenTablet', function(serialNumber, isNew, date, time, ctime, tabOwnerJob, tabOwnerJobGrade, hackMode)
    if isTabletOpened then return end
    OpenedTabletSerialNumber = serialNumber
    isTabletOpened = true
    SetNuiFocus(true, true)
    myJobGrade = nil
    local tabletData = FindTabletData(serialNumber)
    local pAdress = GetAddress(GetEntityCoords(PlayerPedId()))
    local tabApps = BringApps(tabOwnerJob, tabOwnerJobGrade, hackMode)
    local billings = {}
    local langData = GetTabletLang('en')
    
    if #tabletData > 0 and tabletData[1] then
        langData = GetTabletLang(tabletData[1].data.lang)
    end

    local getTabletNotes = GetTabletNotes(serialNumber)
    if #tabletData == 0 or not tabletData[1] then
        OpenedTabletLang = json.decode(LoadResourceFile(Shared.ScriptName, "locales/en.json"))
    else
        OpenedTabletLang = GetTabletLang(tabletData[1].data.lang)
    end
    
    local checkInvoice = CheckInvoiceJob(tabOwnerJob, tabOwnerJobGrade)
    local isMdtApp = CheckApp(tabApps, 'mdt')
    local isEmsApp = CheckApp(tabApps, 'ems')
    local isDojApp = CheckApp(tabApps, 'dojapp')
    local mdtData = {}
    local emsData = {}
    local dispatches = {}
    local tabCharge = 100
    local currentData = {}
    local currentLocation, currentWeather, currentWeatherString = GetFormattedWeather()
    currentData.location = currentLocation
    currentData.weather = currentWeather
    currentData.wstring = currentWeatherString

    if isMdtApp or isDojApp then
        mdtData = lib.callback.await('Kibra:SmartPad:GetMDTData', false)
        for k,v in pairs(mdtData.vehicles) do
            v.class = OpenedTabletLang[classes[tostring(GetVehicleClassFromName(v.orgmodel))]]
        end
        mdtData.vehcrimes = vehicleCrimes
        mdtData.cidcrimes = personalCrimes
        dispatches = Shared.GetDispatches(ctime, langData, 'police')
        myJobGrade = Resmon.Lib.GetPlayerData().job.grade_level
        mdtData.mdtchat = MDTChat
    end

    if not isNew and tabletData[1] then
        billings = GetTabletBillings(serialNumber)
        tabletData[1].invoices = billings
        SharedLocs = GetMyShareers(serialNumber)
        allEmails = GetAllEmails()
        tabletMails, sentedMails = GetTabletMails(serialNumber)
        tabletData[1].mails = tabletMails
        tabletData[1].sented = sentedMails
        TriggerServerEvent('Kibra:SmartPad:TabletState', serialNumber, true)
    end

    if isEmsApp then
        emsData = lib.callback.await('Kibra:SmartPad:GetEMSData', false)
        emsData.druglist = drugsList
        emsData.emsDispatches = Shared.GetEmsDispatches(ctime, langData)
        emsData.emschat = EMSChat
    end

    GiveTabletPlayerHand()

    if tabletData[1] then 
        tabletData[1].job = tabOwnerJob
    end
    
    SendNUIMessage({
        action = 'openTablet',
        data = {
            newTablet = isNew,
            time = {date = date, time = time},
            gunler = { langData.sunday, langData.monday, langData.tuesday, langData.wednesday, langData.thursday, langData.friday, langData.saturday },
            aylar = { langData.january, langData.february, langData.march, langData.april, langData.may, langData.june, langData.july, langData.august, langData.september, langData.october, langData.november, langData.december },
            lang = langData,
            apps = tabApps,
            myJobGrade = myJobGrade,
            prefix = Shared.Domain,
            allmails = allEmails,
            policeMail=Shared.MDTMail.Mail,
            dojMail=Shared.DOJAppMail.Mail,
            dataMails=AllMails,
            chargeDrainInterval = Shared.ChargeDrainInterval,
            sentedMails = sentedMails,
            hackMode = hackMode,
            anyMdt= isMdtApp,
            newsBoss=checkNewsBoss(tabOwnerJob),
            news = AllNews,
            applicationsnews = AllNewsApplications,
            dbmails = RCloudDb,
            anyEms=isEmsApp,
            anyLaw=isDojApp,
            checkInvoice = checkInvoice,
            padress = pAdress,
            courtrooms = GetCourtRooms(),
            tabCharge = AllCharges[serialNumber] or 100,
            currentData = currentData,
            noteLimit = Shared.MaxNoteNumber,
            allNotes=getTabletNotes,
            dispatches = dispatches,
            judMode = Shared.JudicialMode,
            mdtData = mdtData,
            emsData = emsData,
            insuranceData = tabletData[1] and INSURANCEDATABASE[tabletData[1].owner] or {},
            backgrounds = Shared.Backgrounds,
            allLang = Shared.Languages,
            tabletData = tabletData[1],
            tabletDefaultData = {
                defaultTheme = 'default'
            }
        }
    })
    local pedShot = GetMugShotBase64(PlayerPedId())
    TriggerServerEvent('Kibra:SmartPad:SavePlayerMugShot', pedShot)
    if not isNew and tabletData[1] then UseTabletWalking(tabletData[1].data.walkanduse) end
end)

RegisterNetEvent('Kibra:SmartPad:AddNewDevice', function(deviceId, data)
    RCloudDb[deviceId] = data
end)

RegisterNetEvent('Kibra:SmartPad:Client:UpdateInvoiceStatus', function(key, status)
    for k,v in pairs(AllInvoices) do
        if v.ikey == key then
            v.status = 1
        end
    end
end)

AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        local victim = args[1]
        if victim == PlayerPedId() and IsEntityDead(PlayerPedId()) then
            SendNUIMessage({action = 'closeTablet'})
        end
    end
end)

RegisterNetEvent('Kibra:SmartPad:ResetedTablet', function(serial, notes)
    AllNotes = notes
    for k,v in pairs(Shared.Tablets) do
        if v.serialnumber == serial then
            table.remove(Shared.Tablets, k)
        end
    end
end)

RegisterNetEvent('Kibra:SmartPad:UpdateEMSChat', function(data)
    EMSChat[#EMSChat+1] = data
    if isTabletOpened then
        SendNUIMessage({
            action = 'updateMessages',
            data = {messageData = data}
        })
    end
end)

RegisterNetEvent('Kibra:SmartPad:UpdateMDTChat', function(data)
    MDTChat[#MDTChat+1] = data
    if isTabletOpened then
        SendNUIMessage({
            action = 'updateMessagesMdt',
            data = {messageData = data}
        })
    end
end)



RegisterNetEvent('Kibra:SmartPad:AddNewAnnounce', function(data, datanumber)
    if isTabletOpened then
        local mdtData = lib.callback.await('Kibra:SmartPad:GetSelectedMDTData', false, 'mdtData_announcements')
        SendNUIMessage({
            action = 'newAnnouncements',
            data = {data = mdtData}
        })
        TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'mdt', {
            title = OpenedTabletLang.success,
            only = true,
            message = OpenedTabletLang.createdNewAnnounce,
            icon = 'mdt'
        })
    end
end)

RegisterNetEvent('Kibra:SmartPad:Client:UpdateAlbums', function(serial, getAlbumData, albumName)
    for k,v in pairs(Shared.Tablets) do
        if v.serialnumber == serial then
            for q,s in pairs(v.albums) do
                if s.name == albumName then
                    s.medias[#s.medias+1] = getAlbumData
                end
            end
        end
    end
end)

RegisterNetEvent('Kibra:SmartPad:Client:UpdateReceiverGallery', function(data, serial)
    for k,v in pairs(Shared.Tablets) do
        if v.serialnumber == serial then
            v.gallery[#v.gallery+1] = data
        end
    end
end)

RegisterNetEvent('Kibra:SmartPad:Client:UpdateReceiverGallerySelf', function(x)
    if isTabletOpened then
        SendNUIMessage({
            action = 'addGalleryNewPhoto',
            data = {data = x}
        })

        TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'gallery', {
            title = OpenedTabletLang.success,
            only = false,
            message = OpenedTabletLang.yougotphoto,
            icon = 'gallery'
        })
    end
end)



RegisterCommand('closeguncard',function()
    if ShowedGunLicense then
        SendNUIMessage({
            action = 'closeGunCard'
        })
        ShowedGunLicense = false
    end
end,false)

RegisterKeyMapping('closeguncard','Backspace basılınca print at','keyboard','back')

RegisterNetEvent('Kibra:SmartPad:UseWeaponIDCard', function(data)
    ShowedGunLicense = true
    SendNUIMessage({
        action = 'showGunCard',
        data = {data = data, lang = Shared.LangData}
    })
end)

RegisterNetEvent('Kibra:SmartPad:Client:UpdateAlbumData', function(datatype, albumData, serial)
    for k,v in pairs(Shared.Tablets) do
        if v.serialnumber == serial then
            v.albums[#v.albums+1] = albumData
        end
    end
end)



function UpdateTabletData(SerialNumber, data)
    for k,v in pairs(Shared.Tablets) do
        if v.serialnumber == SerialNumber then
            v.apps = data
        end
    end
end



RegisterNetEvent('Kibra:SmartPad:UpdateTabletGallery', function(serial, data)
    for k,v in pairs(Shared.Tablets) do
        if v.serialnumber == serial then
            v.gallery = data
        end
    end

    if isTabletOpened then
        SendNUIMessage({
            action = 'newGallery',
            data = {data = data}
        })
    end
end)

function getTabletOwner(serial)
    if not serial then return end
    local findTabletData = FindTabletData(serial)
    if findTabletData[1] then
        return findTabletData[1].owner
    end
    return nil
end

function updateEmsData(type, datax)
    SendNUIMessage({
        action = 'updateEmsData',
        data = {type = type, data = datax}
    })
end

RegisterNetEvent('Kibra:SmartPad:UpdateTabletMiniData', function(data)
    for k,v in pairs(Shared.Tablets) do
        if v.serialnumber == data.serial then
            v.data[data.datatype] = data.result
        end
    end
end)

RegisterNetEvent('Kibra:SmartPad:UpdateTabletData', function(data, serialNumber)
    UpdateTabletData(serialNumber, data.data.apps)
    SendNUIMessage({
        action = 'updateTabletData',
        data = {apps = data.data.apps, alldata = data}
    })
end)

RegisterNetEvent('Kibra:SmartPad:RegisterNewTablet', function(data, allCharges)
    Shared.Tablets[#Shared.Tablets+1] = data
    AllCharges = allCharges
end)

RegisterCommand('tt', function()
    TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'mdt', {
        title = 'Success',
        only = true,
        message = 'Haritada işaretlendi.',
        icon = 'mdt'
    })
end)

function GetFormattedWeather()
    local weatherType = GetPrevWeatherTypeHashName()
    local temperatureC = 25
    local weatherTypeC = OpenedTabletLang.unkown
    if weatherType == `CLEAR` or weatherType == `EXTRASUNNY` then
        temperatureC = math.random(30, 38)
        weatherTypeC = OpenedTabletLang.clear
    elseif weatherType == `CLOUDS` or weatherType == `OVERCAST` then
        temperatureC = math.random(24, 30)
        weatherTypeC = OpenedTabletLang.clouds
    elseif weatherType == `FOGGY` then
        temperatureC = math.random(18, 24)
        weatherTypeC = OpenedTabletLang.foggy
    elseif weatherType == `RAIN` or weatherType == `THUNDER` then
        temperatureC = math.random(16, 22)
        weatherTypeC = OpenedTabletLang.rainy
    elseif weatherType == `SMOG` then
        temperatureC = math.random(20, 26)
        weatherTypeC = OpenedTabletLang.smog
    elseif weatherType == `SNOW` or weatherType == `BLIZZARD` then
        temperatureC = math.random(-5, 2)
        weatherTypeC = OpenedTabletLang.snow
    end

    local temperatureF = math.floor((temperatureC * 9/5) + 32)
    local locationName = GetAddress(GetEntityCoords(PlayerPedId()))

    if Shared.TemperatureUnit == "C" then
        return locationName, temperatureC, weatherTypeC
    elseif Shared.TemperatureUnit == "F" then
        return locationName, temperatureF, weatherTypeC
    end
end


CameraBlockThread = function()
    while CameraMode do
        Citizen.Wait(0)

        -- Sadece saldırıyı engelle (Hareket serbest)
        DisableControlAction(0, 24, true)  -- Ateş etme (Sol Tık)
        DisableControlAction(0, 25, true)  -- Nişan alma (Sağ Tık)
        DisableControlAction(0, 68, true)  -- Sol Mouse (Araç içi saldırı)
        DisableControlAction(0, 69, true)  -- Sağ Mouse (Araç içi saldırı)
        DisableControlAction(0, 70, true)  -- Araç içi saldırı
        DisableControlAction(0, 91, true)  -- Araç içi nişan alma
        DisableControlAction(0, 140, true) -- Yakın dövüş (R)
        DisableControlAction(0, 141, true) -- Yakın dövüş (Q)
        DisableControlAction(0, 142, true) -- Yakın dövüş (E)
        DisableControlAction(0, 143, true) -- Yakın dövüş (Boşluk)
        DisableControlAction(0, 257, true) -- Yumruk (Sol Tık)
        DisableControlAction(0, 263, true) -- Yakın dövüş (Sol Tık)
        DisableControlAction(0, 264, true) -- Yakın dövüş (Sağ Tık)

        if IsPedArmed(PlayerPedId(), 6) then
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
        end
    end
end

RegisterNetEvent('Kibra:SmartPad:UpdateMDTDatabase', function(which, data)
    MDTDATABASE[which][#MDTDATABASE[which]+1] = data
end)

RegisterNetEvent('Kibra:SmartPad:UpdateEMSDatabase', function(which, data)
    EMSDATABASE[which][#EMSDATABASE[which]+1] = data
end)

RegisterNetEvent('Kibra:SmartPad:Client:AddInvoice', function(data)
    AllInvoices[#AllInvoices+1] = data
end)

RegisterNetEvent('Kibra:SmartPad:ReceiverNewBill', function()
    if isTabletOpened then
        local newBills = GetTabletBillings(OpenedTabletSerialNumber)
        SendNUIMessage({
            action = 'updateBills',
            data = {data = newBills}
        })
    end
end)

RegisterNetEvent('Kibra:SmartPad:CreateJobApplication', function(id, datax)
    AllNewsApplications[id] = datax
    if isTabletOpened then
        SendNUIMessage({
            action = 'updateApplications',
            data = {data = datax}
        })
    end
end)

UseTabletWalking = function(mode)
    SetNuiFocusKeepInput(mode)
    if mode == false then return end
    while mode and isTabletOpened and not CameraMode do
        Citizen.Wait(0)
        DisableControlAction(0, 1, true)   -- disable mouse look
        DisableControlAction(0, 2, true)   -- disable mouse look
        DisableControlAction(0, 3, true)   -- disable mouse look
        DisableControlAction(0, 4, true)   -- disable mouse look
        DisableControlAction(0, 5, true)   -- disable mouse look
        DisableControlAction(0, 6, true)   -- disable mouse look
        DisableControlAction(0, 263, true) -- disable melee
        DisableControlAction(0, 264, true) -- disable melee
        DisableControlAction(0, 257, true) -- disable melee
        DisableControlAction(0, 140, true) -- disable melee
        DisableControlAction(0, 141, true) -- disable melee
        DisableControlAction(0, 142, true) -- disable melee
        DisableControlAction(0, 143, true) -- disable melee
        DisableControlAction(0, 177, true) -- disable escape
        DisableControlAction(0, 200, true) -- disable escape
        DisableControlAction(0, 202, true) -- disable escape
        DisableControlAction(0, 322, true) -- disable escape
        DisableControlAction(0, 245, true) -- disable chat

        -- Silah çekmeyi tamamen engelle
        if IsPedArmed(PlayerPedId(), 6) then
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
        end
    end
end

-- CameraBlockThread = function()
--     DisableControlAction(0, 1, true)   -- disable mouse look
--     DisableControlAction(0, 2, true)   -- disable mouse look
--     DisableControlAction(0, 3, true)   -- disable mouse look
--     DisableControlAction(0, 4, true)   -- disable mouse look
--     DisableControlAction(0, 5, true)   -- disable mouse look
--     DisableControlAction(0, 6, true)   -- disable mouse look
--     DisableControlAction(0, 263, true) -- disable melee
--     DisableControlAction(0, 264, true) -- disable melee
--     DisableControlAction(0, 257, true) -- disable melee
--     DisableControlAction(0, 140, true) -- disable melee
--     DisableControlAction(0, 141, true) -- disable melee
--     DisableControlAction(0, 142, true) -- disable melee
--     DisableControlAction(0, 143, true) -- disable melee
--     DisableControlAction(0, 177, true) -- disable escape
--     DisableControlAction(0, 200, true) -- disable escape
--     DisableControlAction(0, 202, true) -- disable escape
--     DisableControlAction(0, 322, true) -- disable escape
--     DisableControlAction(0, 245, true) -- disable chat
-- end

function GetTabletGallery(serial)
    local gallery = {}
    for k,v in pairs(Shared.Tablets) do
        if v.serialnumber == serial then
            gallery = v.gallery
        end
    end
    return gallery
end

function getLocation()
    local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
    local zone = GetNameOfZone(x, y, z)
    local zoneName = (type(Zones) == 'table' and Zones[zone] and Zones[zone].Name) or "UNKNOWN"
    return zoneName
end

RegisterNetEvent('Kibra:SmartPad:Client:UpdateSelectedAlbum', function(serial, newAlbum)
    for k,v in pairs(Shared.Tablets) do
        if v.serialnumber == serial then
            v.albums = newAlbum
        end
    end
end)

RegisterNetEvent('Kibra:SmartPad:Client:AddFavourite', function(serial, code, state)
    for k,v in pairs(Shared.Tablets) do
        if v.serialnumber == serial then
            for q,s in pairs(v.gallery) do
                if s.code == code then
                    s.liked = true
                end
            end
        end
    end
end)



RegisterNetEvent('Kibra:SmartPad:UpdateDirectData', function(data)
    local tableX = {} 
    local okay = false

    if data.type == 'crimepersonal' then
        for k,v in pairs(MDTDATABASE.mdtData_crimeRecords) do
            if v.crime_id == data.deletedData then
                table.remove(MDTDATABASE.mdtData_crimeRecords, k)
                tableX[1] = MDTDATABASE.mdtData_crimeRecords
                tableX[2] = 'crime_id'
            end
        end
    elseif data.type == 'crimevehicle' then
        for k,v in pairs(MDTDATABASE.mdtData_vehicleCrimes) do
            if v.case_id == data.deletedData then
                table.remove(MDTDATABASE.mdtData_vehicleCrimes, k)
                tableX[1] = MDTDATABASE.mdtData_vehicleCrimes
                tableX[2] = 'case_id'
            end
        end
    elseif data.type == 'wantedlist' then
        for k,v in pairs(MDTDATABASE.mdtData_wantedPeople) do
            if v.cid == data.deletedData then
                table.remove(MDTDATABASE.mdtData_wantedPeople, k)
                tableX[1] = MDTDATABASE.mdtData_wantedPeople
                tableX[2] = 'cid'
            end
        end
    elseif data.type == 'wantedlistveh' then
        for k,v in pairs(MDTDATABASE.mdtData_wantedVehicles) do
            if v.cid == data.deletedData then
                table.remove(MDTDATABASE.mdtData_wantedVehicles, k)
                tableX[1] = MDTDATABASE.mdtData_wantedVehicles
                tableX[2] = 'plate'
            end
        end
    end

    if isTabletOpened then
        SendNUIMessage({
            action = 'updateDirect',
            data = {type = data.type, data = {
                data = tableX[1], 
                history = MDTDATABASE.mdtData_history
            }}
        })
    end
end)

AddEventHandler("onResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        RenderClient()
    end
end)

                 
AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        RenderClient()
        RemoveTabletPHand()
        SetFollowPedCamViewMode(1)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    RenderClient()
end)

function GetMyShareers(serial)
    local f = FindTabletData(serial)
    local shareders = {}
    local d = f[1]

    for owner, locs in pairs(SharedLocations) do
        if owner == d.owner then
            local promises = {}

            for id in pairs(locs) do
                local p = promise.new()
                lib.callback('Kibra:SmartPad:GetCitizenCoords', false, function(result)
                    p:resolve(result)
                end, id)
                table.insert(promises, {promise = p, cid = id})
            end

            local list = {}
            for _, entry in ipairs(promises) do
                local result = Citizen.Await(entry.promise)
                if result and result.source ~= 0 then
                    list[#list + 1] = {
                        cid = entry.cid,
                        name = result.name,
                        source = result.source
                    }
                end
            end

            shareders = list
        end
    end

    return shareders
end


RegisterNUICallback('getSharedLocations', function(data, cb)
    if MapOpened then
        while MapOpened do
            local coordsList = {}
            for _, idx in ipairs(GetMyShareers(OpenedTabletSerialNumber)) do
                local player = GetPlayerFromServerId(idx.source)
                local ped = GetPlayerPed(player)
                if ped ~= 0 then
                    local x,y,z = table.unpack(GetEntityCoords(ped))
                    coordsList[#coordsList+1] = {x=x,y=y,z=z,name=idx.name,source=idx.source}
                end
            end
            cb(coordsList)
            Wait(1000)
        end
    end
end)


-- RegisterCommand('scan', function()
--     ScanVehiclePlate()
-- end)

function ScanVehiclePlate()
    local vehicle = GetVehicleInDirection()
    
    if vehicle and vehicle ~= 0 then
        local plate = GetVehicleNumberPlateText(vehicle)
        local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
        local vehClass = GetVehicleClass(vehicle)
        local coords = GetEntityCoords(vehicle)
        local distance = #(GetEntityCoords(PlayerPedId()) - coords)
        
        local vehicleData = {
            plate = string.gsub(plate, "%s+", ""), 
            model = model,
            class = vehClass,
            distance = math.floor(distance),
            coords = coords,
            health = GetEntityHealth(vehicle),
            maxHealth = GetEntityMaxHealth(vehicle),
            color = GetVehicleColours(vehicle)
        }
        
        print("=== PLAKA TARAMA SONUCU ===")
        print("Plaka: " .. vehicleData.plate)
        print("Model: " .. vehicleData.model)
        print("Sınıf: " .. GetVehicleClassName(vehicleData.class))
        print("Mesafe: " .. vehicleData.distance .. "m")
        print("Sağlık: " .. vehicleData.health .. "/" .. vehicleData.maxHealth .. " (" .. math.floor((vehicleData.health/vehicleData.maxHealth)*100) .. "%)")
        print("Koordinatlar: " .. string.format("%.2f, %.2f, %.2f", coords.x, coords.y, coords.z))
        print("Entity ID: " .. vehicle)
        print("========================")
        
        TriggerEvent('tablet:plateScanned', vehicleData)
    else
        print("=== PLAKA TARAMA SONUCU ===")
        print("HATA: Hedef alanında araç bulunamadı!")
        print("========================")
    end
end

function GetVehicleInDirection()
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    local playerRot = GetEntityRotation(playerPed)
    
    local forwardVector = GetEntityForwardVector(playerPed)
    local endPos = playerPos + (forwardVector * 25.0) -- 25 metre mesafe
    
    local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(
        playerPos.x, playerPos.y, playerPos.z,
        endPos.x, endPos.y, endPos.z,
        10, -- Vehicle flag
        playerPed,
        0
    )
    
    local _, hit, _, _, entity = GetShapeTestResult(rayHandle)
    
    if hit and IsEntityAVehicle(entity) then
        return entity
    end
    
    local vehicle = GetClosestVehicle(playerPos.x, playerPos.y, playerPos.z, 15.0, 0, 71)
    
    if vehicle and vehicle ~= 0 then
        local vehiclePos = GetEntityCoords(vehicle)
        local toVehicle = vehiclePos - playerPos
        local distance = #toVehicle
        
        local forwardNorm = forwardVector / #forwardVector
        local toVehicleNorm = toVehicle / distance
        
        local dot = forwardNorm.x * toVehicleNorm.x + forwardNorm.y * toVehicleNorm.y
        
        if dot > 0.3 and distance <= 15.0 then -- 0.3 ≈ 70 derece
            return vehicle
        end
    end
    
    return nil
end

function GetVehicleClassName(class)
    local classes = {
        [0] = "Kompakt", [1] = "Sedan", [2] = "SUV", [3] = "Coupe",
        [4] = "Muscle", [5] = "Spor Klasik", [6] = "Spor", [7] = "Super",
        [8] = "Motosiklet", [9] = "Off-road", [10] = "Endüstriyel", [11] = "Utility",
        [12] = "Van", [13] = "Bisiklet", [14] = "Tekne", [15] = "Helikopter",
        [16] = "Uçak", [17] = "Servis", [18] = "Acil Durum", [19] = "Askeri",
        [20] = "Ticari", [21] = "Tren", [22] = "Açık Tekerlek"
    }
    return classes[class] or "Bilinmeyen"
end