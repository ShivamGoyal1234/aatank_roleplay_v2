Shared.ScriptName = GetCurrentResourceName()
Shared.LangData = json.decode(LoadResourceFile(Shared.ScriptName, "locales/"..Shared.Lang..".json"))
OpenedTablets = {}
AllInvoices = {}
AllMails = {}
AllCharges = json.decode(LoadResourceFile(Shared.ScriptName, "data/charges.json"))
RCloudDb = {}
AllNews = {}
OpenedTabletLang = json.decode(LoadResourceFile(Shared.ScriptName, "locales/en.json"))
AllNewsApplications = {}
SharedLocations = json.decode(LoadResourceFile(Shared.ScriptName, "data/sharedlocations.json"))
MDTDATABASE = {
    mdtData_wantedPeople = {},
    mdtData_wantedVehicles = {},
    mdtData_weaponLicenses = {},
    mdtData_announcements = {},
    mdtData_crimeRecords = {},
    mdtData_vehicleCrimes = {},
    mdtData_history = {},
    governmentData_court_hearings= {}
}

EMSDATABASE = {
    emsData_treatments = {},
    emsData_allergies = {},
    emsData_notes = {}
}

INSURANCEDATABASE = {}

OfficerDutyStates = {}

function CheckApp(tabApps, appname)
    local found = false
    for k,v in pairs(tabApps) do
        if appname == v.AppHash then
            return true
        end
    end
    return found
end

function BringApps(tabOwnerJob, tabOwnerJobGrade)
    local apps = {}

    for _, v in pairs(Shared.Apps) do
        if v.AppHash == "bossdesk" then
            if tabOwnerJob and Resmon.Lib.Contains(v.Jobs, tabOwnerJob) and tabOwnerJobGrade == 4 then
                apps[#apps + 1] = v
            end
        elseif v.AppHash == "dojapp" and Shared.JudicialMode == false then
        elseif not v.Jobs or Resmon.Lib.Contains(v.Jobs, tabOwnerJob) then
            apps[#apps + 1] = v
        end
    end

    return apps
end

function Render()
    local padsData = MySQL.Sync.fetchAll("SELECT * FROM kibra_smartpad_tablets")
    AllInvoices = MySQL.Sync.fetchAll('SELECT * FROM kibra_smartpad_invoices')
    RCloudDb = MySQL.Sync.fetchAll('SELECT * FROM kibra_smartpad_resmoncloud')
    AllMails = MySQL.Sync.fetchAll('SELECT * FROM kibra_smartpad_mails')
    AllNews = MySQL.Sync.fetchAll('SELECT * FROM kibra_smartpad_news')
    AllNewsApplications = MySQL.Sync.fetchAll('SELECT * FROM kibra_smartpad_newsapplications')

    for _, data in pairs(AllNews) do
        data.data = json.decode(data.data)
        data.media = json.decode(data.media)
        data.comments = json.decode(data.comments)
        data.tags = json.decode(data.tags)
    end

    for _,data in pairs(AllInvoices) do
        data.content = json.decode(data.content)
        data.name = Resmon.Lib.GetPlayerOfflineName(data.owner)
    end

    for _,p in pairs(RCloudDb) do
        p.devices = json.decode(p.devices)
    end

    for _,mailData in pairs(AllMails) do
        mailData.data = json.decode(mailData.data)
    end
    
    for k,v in pairs(padsData) do
        local owJob, owGrade = Resmon.Lib.GetPlayerFromCid(v.owner)
        local apps = BringApps(owJob, owGrade)

        if type(v.data)=="string" then v.data=json.decode(v.data) else v.data={} end
        if type(v.notifications)=="string" then v.notifications=json.decode(v.notifications) else v.notifications={} end
        if type(v.gallery)=="string" then v.gallery=json.decode(v.gallery) else v.gallery={} end
        if type(v.albums)=="string" then v.albums=json.decode(v.albums) else v.albums = {} end
        if type(v.favourites)=="string" then v.favourites=json.decode(v.favourites) else v.favourites={} end        

        if CheckApp(apps,"mdt") or CheckApp(apps, "dojapp") then
            local mdtWantedPeople        = MySQL.Sync.fetchAll("SELECT * FROM kibra_smartpad_wanted_people")        or {}
            local mdtWantedVehicles      = MySQL.Sync.fetchAll("SELECT * FROM kibra_smartpad_wanted_vehicles")      or {}
            local mdtWeaponLicenses      = MySQL.Sync.fetchAll("SELECT * FROM kibra_smartpad_weapon_licenses")      or {}
            local mdtAnnouncements       = MySQL.Sync.fetchAll("SELECT * FROM kibra_smartpad_mdt_announcements ORDER BY id DESC") or {}
            local mdtCrimeRecords        = MySQL.Sync.fetchAll("SELECT * FROM kibra_smartpad_crime_records")       or {}
            local mdtVehicleCrimeRecords = MySQL.Sync.fetchAll("SELECT * FROM kibra_smartpad_vehicle_crimes")      or {}
            local mdtHistory             = MySQL.Sync.fetchAll("SELECT * FROM kibra_smartpad_mdt_history")         
            local dojAppCourtHearings    = MySQL.Sync.fetchAll("SELECT * FROM kibra_smartpad_court_hearings")      or {}

            if #mdtWantedPeople>0 then
                for _,p in ipairs(mdtWantedPeople) do
                    p.medias = type(p.medias) == "string" and json.decode(p.medias) or {}
                end
            end

            if #mdtWantedVehicles>0 then
                for _,veh in ipairs(mdtWantedVehicles) do
                    if type(veh.medias)=="string" then veh.medias=json.decode(veh.medias) else veh.medias={} end
                end
            end

            if #mdtCrimeRecords>0 then
                for _,c in ipairs(mdtCrimeRecords) do
                    if type(c.media)=="string" then c.media=json.decode(c.media) else c.media={} end
                    if type(c.offenders)=="string" then c.offenders=json.decode(c.offenders) end
                    if type(c.articles)=="string" then c.articles=json.decode(c.articles) end
                    if type(c.timeline)=="string" then c.timeline =json.decode(c.timeline) else c.timeline = {} end
                end
            end

            if #mdtVehicleCrimeRecords>0 then
                for _,vc in ipairs(mdtVehicleCrimeRecords) do
                    if type(vc.media)=="string" then vc.media=json.decode(vc.media) else vc.media={} end
                end
            end

            if #dojAppCourtHearings > 0 then
                for _, dh in pairs(dojAppCourtHearings) do
                    if type(dh.courtroom) == 'string' then dh.courtroom = json.decode(dh.courtroom) else dh.courtroom = {} end
                    if type(dh.assigned_judge) == 'string' then dh.assigned_judge = json.decode(dh.assigned_judge) else dh.assigned_judge = {} end
                end
            end

            v.mdtData = 'yeah'
            MDTDATABASE.mdtData_wantedPeople        = mdtWantedPeople
            MDTDATABASE.mdtData_wantedVehicles      = mdtWantedVehicles
            MDTDATABASE.mdtData_weaponLicenses      = mdtWeaponLicenses
            MDTDATABASE.mdtData_announcements       = mdtAnnouncements
            MDTDATABASE.mdtData_crimeRecords        = mdtCrimeRecords
            MDTDATABASE.mdtData_vehicleCrimes       = mdtVehicleCrimeRecords
            MDTDATABASE.mdtData_history             = mdtHistory
            MDTDATABASE.governmentData_court_hearings = dojAppCourtHearings
        end

        if CheckApp(apps, "ems") then
            local treatments = MySQL.Sync.fetchAll("SELECT * FROM kibra_smartpad_treatments") or {}
            local allergies = MySQL.Sync.fetchAll('SELECT * FROM kibra_smartpad_allergies') or {}
            local doctorNotes = MySQL.Sync.fetchAll('SELECT * FROM kibra_smartpad_doctor_notes') or {}
            EMSDATABASE.emsData_treatments = treatments
            EMSDATABASE.emsData_allergies = allergies
            EMSDATABASE.emsData_notes = doctorNotes

            if #allergies > 0 then
                for _,vc in ipairs(allergies) do
                    if type(vc.media)=="string" then vc.media=json.decode(vc.media) else vc.media={} end
                end
            end
        end

        -- Always initialize insurance data for all users
        local policies = MySQL.Sync.fetchAll("SELECT * FROM kibra_smartpad_health_insurance WHERE citizen_id = ?", {v.owner}) or {}
        local claims = MySQL.Sync.fetchAll("SELECT * FROM kibra_smartpad_insurance_claims WHERE citizen_id = ?", {v.owner}) or {}
        -- Use medical_records table for medical history instead of medical_history table
        local medicalHistory = MySQL.Sync.fetchAll("SELECT * FROM kibra_smartpad_medical_records WHERE citizen_id = ? ORDER BY date DESC", {v.owner}) or {}
        
        INSURANCEDATABASE[v.owner] = {
            insuranceData_policies = policies,
            insuranceData_claims = claims,
            insuranceData_medicalHistory = medicalHistory
        }

        Shared.Tablets[k] = v

    end
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

function getTabletOwner(serial)
    if not serial then return end
    local findTabletData = FindTabletData(serial)
    if findTabletData[1] then
        return findTabletData[1].owner
    end
    return nil
end

function GetTabletLang(lang)
    local curlang = json.decode(LoadResourceFile(Shared.ScriptName, "locales/en.json"))
    if lang then
        curlang = json.decode(LoadResourceFile(Shared.ScriptName, "locales/"..lang..".json"))
    end
    return curlang
end

function GetPolices(app)
    local allApps = Shared.Apps 
    for k,v in pairs(allApps) do
        if v.AppHash == app then
            return v.Jobs
        end
    end
end

function IsHasTablet(citizenid)
    local found = false
    for k,v in pairs(Shared.Tablets) do
        if v.owner == citizenid then
            return true
        end
    end
    return found
end

function GetRequiredUsers(app)
    local getPolices = GetPolices(app)
    local allPlayers = Resmon.Lib.AllPlayers()
    local getSources = {}
    for k,v in pairs(allPlayers) do
        local xPlayer = Resmon.Lib.GetPlayerFromSource(v)
        local isHasTablet = IsHasTablet(xPlayer.identifier)
        if isHasTablet then
            if app == 'mdt' then
                for q,s in pairs(getPolices) do
                    if s == xPlayer.job.name then
                        getSources[#getSources+1] = v
                    end
                end
            else
                if xPlayer.job.name == Shared.JournalistJob then
                    getSources[#getSources+1] = v
                end
            end
        end
    end
    return getSources
end

lib.callback.register('Kibra:SmartPad:GetSelectedMDTData', function(source, selectedpart)
    return MDTDATABASE[selectedpart]
end)

FindTabletSerialFromOwner = function(cid)
    local tablets = MySQL.Sync.fetchAll('SELECT serialnumber FROM kibra_smartpad_tablets WHERE owner = ?', {cid})
    if #tablets > 0 then
       return tablets[1].serialnumber
    else
        return false
    end
end


function capitalize(str)
    return (str:gsub("^%l", string.upper))
end


GetUserWantedLevel = function(citizenid)
    local wantedLevel = nil
    for k,v in pairs(MDTDATABASE.mdtData_wantedPeople) do
        if v.cid == citizenid then
            wantedLevel = v.danger_level
        end
    end
    return wantedLevel
end

GetUserWeaponLicense = function(citizenid)
    local weaponLicense = nil
    for k,v in pairs(MDTDATABASE.mdtData_weaponLicenses) do
        if v.citizen_id == citizenid then
            weaponLicense = capitalize(v.weapon_type)
        end
    end
    return weaponLicense
end

GetUserWeapons = function(citizenid)
    local weapons = {}
    for k,v in pairs(MDTDATABASE.mdtData_weaponLicenses) do
        if v.citizen_id == citizenid then
            weapons[#weapons+1] = {
                type = v.weapon_type,
                code = v.license_number
            }
        end
    end
    return weapons
end

GetVehicleWantedLevel= function(plate)
    local wantedLevel = OpenedTabletLang.vehicleNotWanted
    for k,v in pairs(MDTDATABASE.mdtData_wantedVehicles) do
        if v.plate == plate then
            wantedLevel = v.danger_level
        end
    end
    return wantedLevel
end

GetServerPlayers = function()
    local citizenPlayers = Resmon.Lib.GetMysqlPlayers()
    for k,v in pairs(citizenPlayers) do
        if not v.phone then
            v.phone = GetPlayerPhoneNumber(v.cid)
        end
        if not v.dlicense then
            v.dlicense = GetPlayerDriverLicense(v.cid)
        end
        v.house = GetPlayerHouse(v.cid)
        v.apartment = GetPlayerApartment(v.cid)
        v.wantedlevel = GetUserWantedLevel(v.cid)
        v.wlicense = GetUserWeaponLicense(v.cid)
    end

    return citizenPlayers
end

local function unsigned(signed)
    signed = tonumber(signed)
    if not signed then return 0 end
    if signed < 0 then
        return signed + 4294967296
    end
    return signed
end

  


RegisterNetEvent('Kibra:SmartPad:SavePlayerMugShot')
AddEventHandler('Kibra:SmartPad:SavePlayerMugShot',function(data)
    local src = source
    local xPlayer = Resmon.Lib.GetPlayerFromSource(src)
    local full = xPlayer.identifier
    local editIdentifier = string.gsub(full,":","_")
    if Resmon.Lib.GetFramework()=="ESX" then
        editIdentifier = string.gsub(xPlayer.identifier,":","_")
    end
    local filePath = 'web/pimg/'..editIdentifier..'.png'
    Resmon.Lib.SaveImage(GetCurrentResourceName(),data,filePath)
    TriggerClientEvent('Kibra:SmartPad:RefreshMugShot',src,editIdentifier)
end)

GetServerVehicles = function()
    local allVehicles = {}
    local serverVehicles = {}
    local getmods = 'mods'
    local ident = 'citizenid'
    local stored = 'state'
    if Resmon.Lib.GetFramework() == 'ESX' then
        getmods = 'vehicle'
        ident = 'owner'
        stored = 'stored'
        serverVehicles = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles')
    else
        getmods = 'vehicle'
        ident = 'owner'
        stored = 'garage'
        serverVehicles = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles')
    end

    local jsoVehicles = json.decode(LoadResourceFile(Shared.ScriptName, "data/vehicles.json"))
    for k,v in pairs(serverVehicles) do
        local vColor1, vColor2, vColor3, modelName = GetVehicleColorNames(v.plate)
        local vehicleType = OpenedTabletLang.civilian
        if v.job ~= nil then vehicleType = v.job end
        local getExpert = json.decode(v[getmods])
        allVehicles[#allVehicles+1] = {
            plate = v.plate,                                                                                                                                                                                                                                                         
            orgmodel = getExpert.model,
            model = jsoVehicles[tostring(unsigned(getExpert.model))].model,
            modelname = jsoVehicles[tostring(unsigned(getExpert.model))].label,
            owner = v[ident],
            type = vehicleType,
            vehicleColor = vColor1,
            wantedlevel = GetVehicleWantedLevel(v.plate),
            ownerName = Resmon.Lib.GetPlayerOfflineName(v[ident]),
            state = v[stored]
        }
    end

    return allVehicles
end


RegisterNetEvent('Kibra:SmartPad:SendNewNotification', function(app, data)
    local src = source
    if data.only then
        local receivers = GetRequiredUsers(app)
        if #receivers > 0 then
            for k,v in pairs(receivers) do
                TriggerClientEvent('Kibra:SmartPad:ShowNotificationInTablet', v, data)
            end
        end
    else
        TriggerClientEvent('Kibra:SmartPad:ShowNotificationInTablet', src, data)
    end
end)

RegisterNetEvent('Kibra:SmartPad:AddNewAnnounce', function(data, seri)
    local currentAnnouncesData = MySQL.Sync.fetchAll('SELECT * FROM `kibra_smartpad_mdt_announcements`')
    local tabletData = FindTabletData(seri)
    local currentDataFormating = os.date('%d.%m.%Y')
    local newIndex = #MDTDATABASE.mdtData_announcements + 1
    local tabletOwnerName = tabletData[1] and Resmon.Lib.GetPlayerOfflineName(tabletData[1].owner) or "Unknown"
    MDTDATABASE.mdtData_announcements[newIndex] = {
        title = data.title,
        message = data.message,
        announcement_type = 'normal',
        created_at = currentDataFormating,
        created_by = tabletOwnerName
    }

    MySQL.Async.execute('INSERT INTO `kibra_smartpad_mdt_announcements` (title, message, announcement_type, created_at, created_by) VALUES (?, ?, ?, ?, ?)', {
        data.title,
        data.message,
        1,
        currentDataFormating,
        tabletOwnerName
    }, function()
        local getUsers = GetRequiredUsers('mdt')
        for k, v in pairs(getUsers) do
            TriggerClientEvent('Kibra:SmartPad:AddNewAnnounce', v, currentAnnouncesData[newIndex], newIndex)
        end
    end)
end)

RegisterNetEvent('Kibra:SmartPad:TabletState', function(serial, state) 
    if serial then
        local d = FindTabletData(serial)
        if d and d[1] and d[1].data and d[1].data.deviceName then
            OpenedTablets[serial] = {
                tabName = d[1].data.deviceName,
                state = state,
                serial = serial,
                source = source
            }
        end
    end
end)

   
RegisterNetEvent('Kibra:SmartPad:Server:RequestData', function()
    TriggerClientEvent('Kibra:SmartPad:Client:SendTabletData', source, Shared.Tablets, MDTDATABASE, EMSDATABASE, AllInvoices, AllMails, RCloudDb, AllNews, AllNewsApplications, INSURANCEDATABASE)
end)

AddEventHandler("onResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        Render()
    end
end)

function FindPhotoData(serial, code)
    local f = FindTabletData(serial)
    if f[1] and f[1].gallery then
        local c = f[1]
        for k,v in pairs(c.gallery) do
            if v.code == code then
                return v
            end
        end
    end
    return nil
end

function GetSelectedPhotos(codes, serial)
    local c = {}
    local f = FindTabletData(serial) 
    if f[1] and f[1].gallery then
        local d = f[1]
        for k,v in pairs(d.gallery) do
            for q,s in pairs(codes) do
                if s == v.code then
                    c[#c+1] = v
                end
            end
        end
    end

    return c
end

function generateSerialNumber()
    local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"  
    function randomString(length)
        local result = {}
        for i = 1, length do
            local randIndex = math.random(1, #charset)
            table.insert(result, charset:sub(randIndex, randIndex))
        end
        return table.concat(result)
    end

    return string.format("%s%s%s%s",
        randomString(4),
        randomString(4),
        randomString(4),
        randomString(4)
    )
end

function isSerialNumberUnique(serial, tablets)
    for _, tablet in pairs(tablets) do
        if tablet.serialnumber == serial then
            return false
        end
    end
    return true
end

function getUniqueSerialNumber()
    local serial
    repeat
        serial = generateSerialNumber()
    until isSerialNumberUnique(serial, Shared.Tablets)
    return serial
end

function GiveUniqueTablet(source, args)
    local src = source
    if args and args[1] then 
        src = tonumber(args[1])
    end

    local xPlayer = Resmon.Lib.GetPlayerFromSource(src)
    if xPlayer then
        local newSerialNumber = getUniqueSerialNumber()
        AddInventoryItem(source, Shared.TabletItemName, 1, nil, {SerialNumber = newSerialNumber})
        TriggerClientEvent('SmartPad:Ox:Notification', source, Shared.LangData.successfull, string.format(Shared.LangData.gaveNewTablet, src, newSerialNumber), 'success')
    else
        TriggerClientEvent('SmartPad:Ox:Notification', source, Shared.LangData.error, Shared.LangData.invalidSource, 'error')
    end
end



RegisterNetEvent('Kibra:SmartPad:Server:SavePlayerMugShot', function(data)
    local src = source
    local xPlayer = Resmon.Lib.GetPlayerFromSource(src)
    local full = xPlayer.identifier
    local base64Image = data
    local editIdentifier = string.gsub(full, ":", "_")
    local filePath = '/web/pimg/'..editIdentifier..'.png'
    local file = io.open(filePath, "r")

    if Resmon.Lib.GetFramework() == 'ESX' then
        editIdentifier = string.gsub(xPlayer.identifier, ":", "_")
    end

    local filePath = '/web/pimg/'..editIdentifier..'.png'
    Resmon.Lib.SaveImage(GetCurrentResourceName(),  base64Image, filePath)
end)

function CheckPad(serialNumber) 
    local found = true
    local tablets = Shared.Tablets
    for k,v in pairs(tablets) do
        if v.serialnumber == serialNumber then 
            return false
        end
    end
    return found
end

function GetTabData(serialNumber)
    local tabData = {}
    for k,v in pairs(Shared.Tablets) do
        if v.serialnumber == serialNumber then
            tabData = v
        end
    end
    return tabData
end

function getTime()
    local hour, minute = os.date("%H"), os.date("%M")
    return string.format("%02d:%02d", hour, minute)
end

function bugunun_tarihi(lang)
    local langData = GetTabletLang(lang)
    local gunler = { langData.sunday, langData.monday, langData.tuesday, langData.wednesday, langData.thursday, langData.friday, langData.saturday }
    local aylar = { langData.january, langData.february, langData.march, langData.april, langData.may, langData.june, langData.july, langData.august, langData.september, langData.october, langData.november, langData.december }
    
    local zaman = os.date("*t")
    local gun = zaman.day
    local ay = aylar[zaman.month]
    local yil = zaman.year
    local hafta_gunu = gunler[zaman.wday]
    local saat = getTime()

    return string.format("%d %s %d, %s", gun, ay, yil, hafta_gunu), saat
end

exports('useTablet', function(event, item, inventory, slot, data)
    if event == 'usingItem' then
        local source = inventory.id
        local itemSlot = exports.ox_inventory:GetSlot(inventory.id, slot)
        if itemSlot.metadata == nil then return end
        local SerialNumber = itemSlot.metadata.Serial
        local isNew = CheckPad(SerialNumber)
        local tabData = GetTabData(SerialNumber)
        local date, time = bugunun_tarihi('en')
        if #tabData > 0 then
            date, time = bugunun_tarihi(tabData.data.lang)
        end
        local currentTime = os.time() * 1000
        if tabData.data == nil then
            OpenedTabletLang = json.decode(LoadResourceFile(Shared.ScriptName, "locales/en.json"))
        else
            OpenedTabletLang = GetTabletLang(tabData.data.lang)
        end
        local owJob, owGrade = Resmon.Lib.GetPlayerFromCid(tabData.owner)
        TriggerClientEvent('Kibra:SmartPad:OpenTablet', source, SerialNumber, isNew, date, time, currentTime, owJob, owGrade)
    end
end)

exports('useWeaponLicense', function(event, item, inventory, slot, data)
    if event == 'usingItem' then
        local source = inventory.id
        local itemSlot = exports.ox_inventory:GetSlot(inventory.id, slot)
        if itemSlot.metadata == nil then return end
        local itemData = itemSlot.metadata
        local citizenIdData = Resmon.Lib.GetPlayerOfflineData(0, itemData.OwnerCid)
        local WLicenseData = {
            Owner = itemData.Owner,
            PrintingDate = itemData.PrintingDate,
            Gender = citizenIdData.gender,
            Birthdate = citizenIdData.birthdate,
            OwnerCid = itemData.OwnerCid,
            Type = itemData.Type,
            License = itemData.License,
            ExpireDate = itemData.ExpireDate
        }
        TriggerClientEvent('Kibra:SmartPad:UseWeaponIDCard', source, WLicenseData)
    end
end)

if not Shared.MetaDataSystem then
    RegisterCommand(Shared.OpenTabletCommand, function(source, args)
        local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
        local f = MySQL.Sync.fetchAll('SELECT * FROM kibra_smartpad_tablets WHERE owner = ?', {xPlayer.identifier})
        local isNew = false
        local snumber = nil
        if #f == 0 then 
            isNew = true
            snumber = getUniqueSerialNumber()
        else
            snumber = f[1].serialnumber
        end
        local tabData = GetTabData(snumber)
        local date, time = bugunun_tarihi('en')
        if #tabData > 0 then
            date, time = bugunun_tarihi(tabData.data.lang)
        end
        local currentTime = os.time() * 1000
        if tabData.data == nil then
            OpenedTabletLang = json.decode(LoadResourceFile(Shared.ScriptName, "locales/en.json"))
        else
            OpenedTabletLang = GetTabletLang(tabData.data.lang)
        end
        
        local owJob, owGrade = Resmon.Lib.GetPlayerFromCid(tabData.owner)
        TriggerClientEvent('Kibra:SmartPad:OpenTablet', source, snumber, isNew, date, time, currentTime, owJob, owGrade)
    end)
end

CreateUsableItem(Shared.TabletItemName, function(source, itemData)
    if itemData.info == nil and itemData.info.SerialNumber == nil then return end
    local isNew = CheckPad(itemData.info.SerialNumber)
    local tabData = GetTabData(itemData.info.SerialNumber)
    local date, time = bugunun_tarihi('en')
    if #tabData > 0 then
        date, time = bugunun_tarihi(tabData.data.lang)
    end
    local currentTime = os.time() * 1000
    if tabData.data == nil then
        OpenedTabletLang = json.decode(LoadResourceFile(Shared.ScriptName, "locales/en.json"))
    else
        OpenedTabletLang = GetTabletLang(tabData.data.lang)
    end
    
    local owJob, owGrade = Resmon.Lib.GetPlayerFromCid(tabData.owner)
    TriggerClientEvent('Kibra:SmartPad:OpenTablet', source, itemData.info.SerialNumber, isNew, date, time, currentTime, owJob, owGrade)
end)

if Shared.MetaDataSystem then
    CreateUsableItem(Shared.WeaponLicenseItemName, function(source, itemData)
        if itemData.info == nil then return end
        local citizenIdData = Resmon.Lib.GetPlayerOfflineData(0, itemData.info.OwnerCid)
        local WLicenseData = {
            Owner = itemData.info.Owner,
            PrintingDate = itemData.info.PrintingDate,
            Gender = citizenIdData.gender,
            Birthdate = citizenIdData.birthdate,
            OwnerCid = itemData.info.OwnerCid,
            Type = itemData.info.Type,
            License = itemData.info.License,
            ExpireDate = itemData.info.ExpireDate
        }

        TriggerClientEvent('Kibra:SmartPad:UseWeaponIDCard', source, WLicenseData)
    end)
end

function bringDefaultApps()
    local dapps = {}
    for k,v in pairs(Shared.Apps) do
        if v.Default then
            dapps[#dapps+1] = v
        end
    end
    return dapps
end

RegisterNetEvent('Kibra:SmartPad:UpdateTabletMiniData', function(data, serialno)
    data.serial = serialno 
    local myData = {}
    for k,v in pairs(Shared.Tablets) do
        if v.serialnumber == data.serial then
            v.data[data.datatype] = data.result
            myData = v.data
        end
    end

    MySQL.update('UPDATE kibra_smartpad_tablets SET data = ? WHERE serialnumber = ?', {json.encode(myData), data.serial}, function(result)
        if result then
            TriggerClientEvent('Kibra:SmartPad:UpdateTabletMiniData', -1, data)
        end
    end)
end)

function GetOnlineOfficers(Jobs, mode) -- mode: 'mdt', 'ems', 'news', 'doj', vs.
    local allPlayers = Resmon.Lib.GetUsersFromJobs(Jobs)
    local users, added = {}, {}

    for _, v in ipairs(allPlayers) do
        local cid = v.cid or v.identifier or v.citizenid
        if cid and not added[cid] then
            local src = Resmon.Lib.GetPlayerByIdentifier(cid) or v.source
            local p = Resmon.Lib.GetPlayerFromSource(src)

            local showPlayer = false
            if p then
                if mode == 'mdt' then
                    showPlayer = Shared.ShownOnMDTMap[p.job.name] or false
                elseif mode == 'ems' then
                    showPlayer = Shared.ShownOnEMSMap[p.job.name] or false
                else
                    -- news, doj, vs. için sadece oyuncu varsa al
                    showPlayer = true
                end
            end

            if p and showPlayer then
                local c = p.coords
                users[#users+1] = {
                    cid = p.identifier,
                    coords = { x = c.x, y = c.y, z = c.z },
                    name = p.name,
                    grade = v.gradename,
                    job = p.job.name,
                    online = true
                }
            elseif not p then
                users[#users+1] = {
                    cid = cid,
                    name = v.name,
                    grade = v.gradename,
                    job = v.joborg,
                    online = false
                }
            end

            added[cid] = true
        end
    end

    return users
end

RegisterNetEvent('Kibra:SmartPad:OpenTablet', function(serial)
    local src = source
    local SerialNumber = serial
    local isNew = CheckPad(SerialNumber)
    local tabData = GetTabData(SerialNumber)
    local date, time = bugunun_tarihi('en')
    if #tabData > 0 then
        date, time = bugunun_tarihi(tabData.data.lang)
    end
    local currentTime = os.time() * 1000
    if tabData.data == nil then
        OpenedTabletLang = json.decode(LoadResourceFile(Shared.ScriptName, "locales/en.json"))
    else
        OpenedTabletLang = GetTabletLang(tabData.data.lang)
    end
    local owJob, owGrade = Resmon.Lib.GetPlayerFromCid(tabData.owner)
    TriggerClientEvent('Kibra:SmartPad:OpenTablet', src, SerialNumber, isNew, date, time, currentTime, owJob, owGrade, true)
end)

function checkGradeLevel(gradelevel, requestedJob, pJob)
    local check = false
    if Shared.DojAppJobs[requestedJob][pJob] then
        for k,v in pairs(Shared.DojAppJobs[requestedJob][pJob]) do
            if v == gradelevel then
                return true
            end
        end
    end
    return check
end 

function GetJudges(requestedJob)
    local theJobs = {}
    for k,v in pairs(Shared.DojAppJobs[requestedJob]) do
        theJobs[#theJobs+1] = k
    end
    local allPlayers = Resmon.Lib.GetUsersFromJobs(theJobs)
    local users, added = {}, {}
    for _, v in ipairs(allPlayers) do
        local cid = v.cid or v.identifier or v.citizenid
        if cid and not added[cid] then
            local src = Resmon.Lib.GetPlayerByIdentifier(cid) or v.source
            local p = Resmon.Lib.GetPlayerFromSource(src)
            local checkGradeLevel = checkGradeLevel(v.gradelevel, requestedJob, v.joborg)
            if checkGradeLevel then
                if p then
                    local c = p.coords
                    users[#users+1] = {
                        cid = p.identifier,
                        coords = { x = c.x, y = c.y, z = c.z },
                        name = p.name,
                        grade = v.gradename,
                        job = p.job.name,
                        online = true
                    }
                else
                    users[#users+1] = {
                        cid = cid,
                        name = v.name,
                        grade = v.gradename,
                        job = v.joborg,
                        online = false
                    }
                end
                added[cid] = true
            end
        end
    end

    return users
end

RegisterCommand('GetJudges', function(source, args)
    GetJudges('lawyers')
end)

lib.callback.register('Kibra:SmartPad:GetDojUsers', function(source, typ)
   return {data = GetJudges(typ)}
end)

function FindColorName(colorId1, colorId2, colorId3)
    local colors = json.decode(LoadResourceFile(Shared.ScriptName, 'data/colors.json'))
    local cName1, cName2, cName3 = nil, nil, nil

    for k,v in pairs(colors) do
        for q,s in pairs(v) do
            if colorId1 == s.index then
                cName1 = s.renkname
            end

            if colorId2 == s.index then
                cName2 = s.renkname
            end

            if colorId3 == s.index then
                cName3 = s.renkname
            end
        end
    end

    return cName1, cName2, cName3
end

function GetVehicleColorNames(plate)
    local getFramework = Resmon.Lib.GetFramework()

    -- fetch the vehicle row from DB
    local result = MySQL.Sync.fetchAll(
        'SELECT vehicle, mods FROM player_vehicles WHERE plate = ?',
        { plate }
    )

    -- no results found
    if not result or not result[1] then
        return nil, nil, nil, nil
    end

    local vehicleData

    if getFramework == 'QBCore' then
        -- in QBCore, data is stored in `mods`
        if not result[1].mods then
            return nil, nil, nil, nil
        end
        vehicleData = json.decode(result[1].mods)
    else
        -- in ESX/other frameworks, data is in `vehicle`
        if not result[1].vehicle then
            return nil, nil, nil, nil
        end
        vehicleData = json.decode(result[1].vehicle)
    end

    -- safety check: if decode failed
    if not vehicleData then
        return nil, nil, nil, nil
    end

    -- model + colors
    local modelName = FindVehicleModel(vehicleData.model)
    local colorName1, colorName2, colorName3 = FindColorName(
        vehicleData.color1 or 0,
        vehicleData.color2 or 0,
        vehicleData.pearlescentColor or 0
    )

    -- return with translations
    return OpenedTabletLang[colorName1] or colorName1,
           OpenedTabletLang[colorName2] or colorName2,
           OpenedTabletLang[colorName3] or colorName3,
           modelName
end



RegisterNetEvent('Kibra:SmartPad:SendChatMessage', function(data, serial)
    local type = data.type
    local tabletOwner = getTabletOwner(serial)
    local dateAndTime = os.date("%d/%m/%Y - %H:%M")
    local messages = {}
    if data.type == 'ems' then
        messages = json.decode(LoadResourceFile(Shared.ScriptName, "data/ems_chat.json"))
    else
        messages = json.decode(LoadResourceFile(Shared.ScriptName, "data/mdt_chat.json"))
    end

    local newMessage = #messages+1
    messages[newMessage] = {
        senderCid = tabletOwner,
        sender = Resmon.Lib.GetPlayerOfflineName(tabletOwner),
        message = data.message,
        time = dateAndTime 
    }

    if data.type == 'ems' then
        SaveResourceFile(Shared.ScriptName, 'data/ems_chat.json', json.encode(messages, { indent = true }), -1)
        UpdateChatChannel('ems', messages[newMessage])
    else
        SaveResourceFile(Shared.ScriptName, 'data/mdt_chat.json', json.encode(messages, { indent = true }), -1)
        UpdateChatChannel('mdt', messages[newMessage])
    end
end)

AddNewHistory = function(xPlayer, data)
    local dateAndTime = os.date("%d/%m/%Y - %H:%M")
    local pName = Resmon.Lib.GetPlayerOfflineName(xPlayer)
    local message = nil
    if data.type == 'crimepersonal' then
        message = string.format(OpenedTabletLang.crimeDeleted, pName, data.deletedData)
    elseif data.type == 'crimevehicle' then
        message = string.format(OpenedTabletLang.crimeDeleted, pName, data.deletedData)
    elseif data.type == 'wantedlist' then
        message = string.format(OpenedTabletLang.wantedDeleted, pName, data.deletedData)
    elseif data.type == 'wantedlistveh' then
        message = string.format(OpenedTabletLang.wantedVehDeleted, pName, data.deletedData)
    end

    local plus = #MDTDATABASE.mdtData_history + 1
    MDTDATABASE.mdtData_history[plus] = {
        created_by = pName,
        transaction = message,
        casenumber = data.deletedData,
        date = dateAndTime
    }

    MySQL.Async.execute('INSERT INTO kibra_smartpad_mdt_history (created_by, transaction, casenumber, date) VALUES(?, ?, ?, ?)', {
        pName,
        message,
        data.deletedData,
        dateAndTime
    })

    UpdateClientData('mdtData_history', MDTDATABASE.mdtData_history[plus])
end

lib.callback.register('Kibra:SmartPad:CheckTablet', function(source)
    local xp = Resmon.Lib.GetPlayerFromSource(source)
    if xp then
        local item = Shared.TabletItemName
        local hasItem, itemData = GetInventoryItemAmount(source, item, 1)
        if hasItem then
            local tabletData = FindTabletData(itemData.info.SerialNumber)
            if #tabletData > 0 then
                return true, itemData
            else
                return false, nil
            end
        end
    end
    return false, nil
end)



lib.callback.register('Kibra:SmartPad:GetMDTData', function()
    local onlineOfficers = GetOnlineOfficers(Shared.MDTOfficers, 'mdt')
    return {
        officers = onlineOfficers, 
        mdtDatabase = MDTDATABASE, 
        players = GetServerPlayers(), 
        vehicles = GetServerVehicles(), 
        weapons = json.decode(LoadResourceFile(Shared.ScriptName, 'data/weapons.json')),
        allgrades = Resmon.Lib.GetJobGrades(Shared.MDTOfficers),
        bosslevels = Shared.MDTAppBossGradeLevels
    }
end)

RegisterNetEvent('Kibra:SmartPad:ToggleDuty', function(state)
    local src = source
    local xPlayer = Resmon.Lib.GetPlayerFromSource(src)
    if not xPlayer then return end
    local cid = xPlayer.identifier
    local newState = state ~= nil and state or not OfficerDutyStates[cid]
    OfficerDutyStates[cid] = newState and true or false
    TriggerClientEvent('Kibra:SmartPad:ShowNotificationInTablet', src, { title = OpenedTabletLang.success, only = false, message = newState and OpenedTabletLang.onduty or OpenedTabletLang.offduty, icon = 'mdt' })
    -- Optionally broadcast to all MDT users for presence badges
    local receivers = GetRequiredUsers('mdt')
    for _, v in pairs(receivers) do
        TriggerClientEvent('sendReactMessage', v, { action = 'updateOfficerDuty', data = { cid = cid, state = newState } })
    end
    -- respond to NUI caller with current state via NUI callback response occurs client-side
end)

lib.callback.register('Kibra:SmartPad:GetDutyState', function(source)
    local xp = Resmon.Lib.GetPlayerFromSource(source)
    if not xp then return false end
    if xp.job and type(xp.job.onduty) ~= 'nil' then
        return xp.job.onduty and true or false
    end
    return false
end)

exports('IsOfficerOnDuty', function(identifier)
    return OfficerDutyStates[identifier] and true or false
end)

-- lib.callback.register('Kibra:SmartPad:GetDojData', function()
--     Shared.DojAppJobs
-- end)

lib.callback.register('Kibra:SmartPad:GetCitizenCoords', function(source, citizenid)
    local xSource=0
    local xName = 'Unkown'
    local player=Resmon.Lib.GetPlayerByIdentifier(citizenid)
    if player and player>0 then xSource=player end
    local xp = Resmon.Lib.GetPlayerFromSource(player)
    if xp then 
        xName = xp.name
    end
    return {source=xSource, name = xName}
end)

getNearestPlayers = function(source)
    local mainPlayer = Resmon.Lib.GetPlayerFromSource(source)
    local allPlayers = Resmon.Lib.AllPlayers()
    local Players = {}
    for k,v in pairs(allPlayers) do
        local xPlayer = Resmon.Lib.GetPlayerFromSource(v)
        if xPlayer then
            if #(xPlayer.coords - mainPlayer.coords) <= 10.0 then
                Players[#Players+1] = {
                    name = xPlayer.name,
                    source = v,
                    cid = xPlayer.identifier,
                    hisTabletCode = FindTabletSerialFromOwner(xPlayer.identifier)
                }
            end
        end
    end

    return {
        data = Players
    }
end


lib.callback.register('Kibra:SmartPad:GetNearPlayers', function(source)
    local mainPlayer = Resmon.Lib.GetPlayerFromSource(source)
    local allPlayers = Resmon.Lib.AllPlayers()
    local Players = {}
    for k,v in pairs(allPlayers) do
        local xPlayer = Resmon.Lib.GetPlayerFromSource(v)
        if xPlayer then
            if #(xPlayer.coords - mainPlayer.coords) <= 10.0 then
                Players[#Players+1] = {
                    name = xPlayer.name,
                    source = v,
                    cid = xPlayer.identifier,
                    hisTabletCode = FindTabletSerialFromOwner(xPlayer.identifier)
                }
            end
        end
    end

    return {
        data = Players
    }
end)

lib.callback.register('Kibra:SmartPad:GetOpenedTablets', function()
    return {
        data = OpenedTablets
    }
end)

lib.callback.register('Kibra:SmartPad:GetEMSData', function()
    local onlineOfficers = GetOnlineOfficers(Shared.EMSParamedics, 'ems')
    return {
        officers = onlineOfficers, 
        mdtDatabase = EMSDATABASE, 
        players = GetServerPlayers(), 
        allgrades = Resmon.Lib.GetJobGrades(Shared.EMSParamedics),
        bosslevels = Shared.EMSAppBossGradeLevels
    }
end)

function GetPlayerEmails(identifier)
    local Tablets = Shared.Tablets
    local checked = {}
    for k,v in pairs(Tablets) do
        if v.owner == identifier then
            checked[#checked+1] = v.email
        end
    end
    return checked
end

RegisterNetEvent('Kibra:SmartPad:AddFavourite', function(data, serial, state)
    local f = FindTabletData(serial)
    local d = f[1]
    local code = data.photoCode
    for k,v in pairs(d.gallery) do
        if v.code == code then
            v.liked = state
        end
    end

    MySQL.Async.execute('UPDATE kibra_smartpad_tablets SET gallery = ? WHERE serialnumber = ?', {json.encode(d.gallery), serial})
    TriggerClientEvent('Kibra:SmartPad:Client:AddFavourite', -1, serial, code, state)
end)

function GetTabletOwnerFromMail(mail)
    local serial = nil
    for k,v in pairs(Shared.Tablets) do
        if v.email == mail then
            return v.owner
        end
    end
    return serial
end 

function generateEmail(name)
    local localPart = name:lower():gsub("%s+",".")
    local domain = Shared.Domain
    local email = localPart.."@"..domain
    local exists = false
    for _,v in pairs(Shared.Tablets) do
        if v.email == email then exists = true break end
    end
    local counter = 1
    while exists do
        local candidate = localPart..counter.."@"..domain
        exists = false
        for _,v in pairs(Shared.Tablets) do
            if v.email == candidate then exists = true break end
        end
        if not exists then
            email = candidate
        else
            counter = counter + 1
        end
    end
    return email
end

RegisterNetEvent('Kibra:SmartPad:UpdateTabletCharge', function(serial, value)
    if not serial or value == nil then return end
    value = math.max(math.min(value, 100), 0)
    AllCharges[serial] = value
    SaveResourceFile(Shared.ScriptName, 'data/charges.json', json.encode(AllCharges), -1)
    TriggerClientEvent('Kibra:SmartPad:UpdateChargeLevel', -1, serial, AllCharges[serial])
end)

RegisterNetEvent('Kibra:SmartPad:RegisterNewTablet', function(serialNo, data)
    local serialNumber = serialNo
    local src = source
    local defApps = bringDefaultApps()
    local Player = Resmon.Lib.GetPlayerFromSource(src)
    local newTabletData = {
        theme = data.theme,
        deviceName = data.deviceName,
        passcode = tonumber(data.passcode),
        lang = data.lang,
        apps = defApps,
        widgets = false,
        planemode = false,
        email = data.icloudAccount,
        notifications = true,
        ownername = Player.name,
        walkanduse = false,
        background = 'default',
        security = {
            question = data.securityQuest,
            answer = data.secAnswer
        }
    }

    if not data.selectedTab and data.icloudData then
        local devices = {}
        local newDevice = #RCloudDb+1
        devices[#devices+1] = serialNo 
        MySQL.insert('INSERT into kibra_smartpad_resmoncloud (devices, owner, firstname, lastname, birthdate, password, mail) VALUES(?,?,?,?,?,?,?)', {
            json.encode(devices),
            Player.identifier,
            data.icloudData.firstName,
            data.icloudData.lastName,
            data.icloudData.birthDate,
            data.icloudData.password,
            data.icloudAccount,
        })

        RCloudDb[newDevice] = {
            devices = devices,
            owner = Player.identifier,
            firstname = data.icloudData.firstName,
            lastname = data.icloudData.lastName,
            birthdate = data.icloudData.birthDate,
            password = data.icloudData.password,
            mail = data.icloudData.mail
        }

        TriggerClientEvent('Kibra:SmartPad:AddNewDevice', -1, newDevice, RCloudDb[newDevice])
    end

    SaveResourceFile(Shared.ScriptName, 'data/charges.json', json.encode({AllCharges}, { indent = true }), -1)

    if not data.selectedTab then
        MySQL.insert('INSERT INTO kibra_smartpad_tablets (serialnumber, owner, data, notifications, gallery, albums, email) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            serialNumber,
            Player.identifier,
            json.encode(newTabletData),
            '[]',
            '[]',
            '[]',
            data.icloudAccount
        }, function()
            local tempTable = {
                serialnumber = serialNumber,
                owner = Player.identifier,
                data = newTabletData,
                apps = defApps,
                mail = data.icloudAccount,
                notifications = {},
                albums = {},
                gallery = {}
            }
            Shared.Tablets[#Shared.Tablets+1] = tempTable
            TriggerClientEvent('Kibra:SmartPad:RegisterNewTablet', -1, tempTable, AllCharges)
            TriggerClientEvent('Kibra:SmartPad:UpdateTabletData', src, tempTable, serialNumber)
        end)
    else
        local selectedTab = FindTabletData(data.selectedTab)
        local owJob, owGrade = Resmon.Lib.GetPlayerFromCid(selectedTab.owner)
        local apps = BringApps(owJob, owGrade)
        MySQL.insert('INSERT INTO kibra_smartpad_tablets (serialnumber, owner, data, notifications, gallery, albums, email) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            data.selectedTab,
            Player.identifier,
            json.encode(selectedTab.data),
            json.encode(selectedTab.notifications),
            json.encode(selectedTab.gallery),
            json.encoded(selectedTab.albums),
            data.email
        }, function()
            local tempTable = {
                serialnumber = data.selectedTab,
                owner = Player.identifier,
                data = selectedTab.data,
                apps = apps,
                email = data.icloudAccount,
                notifications = selectedTab.notifications,
                gallery = selectedTab.gallery,
                albums = selectedTab.albums
            }
            Shared.Tablets[#Shared.Tablets+1] = tempTable
            TriggerClientEvent('Kibra:SmartPad:RegisterNewTablet', -1, tempTable, AllCharges)
            TriggerClientEvent('Kibra:SmartPad:UpdateTabletData', src, tempTable, serialNumber)
        end)
    end

end)

UpdateClientData = function(which, data)
    local getRequired = GetRequiredUsers('mdt')
    for k,v in pairs(getRequired) do
        TriggerClientEvent('Kibra:SmartPad:UpdateMDTDatabase', v, which, data)
    end
end


UpdateClientDataForEms = function(which, data)
    local getRequired = GetRequiredUsers('ems')
    for k,v in pairs(getRequired) do
        TriggerClientEvent('Kibra:SmartPad:UpdateEMSDatabase', v, which, data)
    end
end

UpdateChatChannel = function(channel, messageData)
    if channel == 'ems' then
        local getRequired = GetRequiredUsers('ems')
        for k,v in pairs(getRequired) do
            TriggerClientEvent('Kibra:SmartPad:UpdateEMSChat', v, messageData)
        end
    else
        local getRequired = GetRequiredUsers('mdt')
        for k,v in pairs(getRequired) do
            TriggerClientEvent('Kibra:SmartPad:UpdateMDTChat', v, messageData)
        end
    end
end

FindVehicleModel = function(model)
    local models = json.decode(LoadResourceFile(Shared.ScriptName, "data/vehicles.json"))
    return models[tostring(unsigned(model))].label
end

RegisterCommand(Shared.GiveTabletCommandName, GiveUniqueTablet)

CreateThread(function()
    local path = 'shared/camera.json'
    local file = LoadResourceFile(GetCurrentResourceName(), path)

    if file then
        local data = json.decode(file)
        if data then
            if data.photoUrl == '' or data.videoUrl == '' then
                print('^1[WARNING]^0 photoUrl or videoUrl in shared/camera.json is empty! Please configure them.')
            end
        else
            print('^1[ERROR]^0 Failed to decode JSON: shared/camera.json')
        end
    else
        print('^1[ERROR]^0 File not found: shared/camera.json')
    end
end)