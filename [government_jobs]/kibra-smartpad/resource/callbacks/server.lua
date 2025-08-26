Resmon.Lib.Callback.Register('Kibra:SmartPad:RegisterWeaponLicense', function(source, cb, data)
    local playerLicenseCheck = false
    local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
    local ResmonSource = Resmon.Lib.GetPlayerByIdentifier(data.selectedCid)
    local licenses = MDTDATABASE.mdtData_weaponLicenses
    local plus = #MDTDATABASE.mdtData_weaponLicenses + 1
    for k,v in pairs(licenses) do
        if v.citizen_id == data.selectedCid then
            if v.weapon_type == data.licenseType then
                playerLicenseCheck = true
            end
        end
    end
    local date = os.date("%d/%m/%Y")
    if type(ResmonSource) ~= 'number' then ResmonSource = 0 end
    local citizenIdData = Resmon.Lib.GetPlayerOfflineData(ResmonSource, data.selectedCid)
    if playerLicenseCheck then return cb('alreadyHas') end

    MDTDATABASE.mdtData_weaponLicenses[plus] = {
        citizen_id = data.selectedCid,
        playername = data.search,
        dob = citizenIdData.birthdate,
        license_number = data.licenseCode,
        weapon_type = data.licenseType,
        expiration_date = data.expirationDate,
        status = 1,
        issued_by = xPlayer.name
    }

    MySQL.insert('INSERT INTO kibra_smartpad_weapon_licenses (citizen_id, playername, dob, license_number, weapon_type, expiration_date, status, issued_by) VALUES(?, ?, ?, ?, ?, ?, ?, ?)', {
        data.selectedCid,
        data.search,
        citizenIdData.birthdate,
        data.licenseCode,
        data.licenseType,
        data.expirationDate,
        1,
        xPlayer.name
    }, function()
        cb(MDTDATABASE.mdtData_weaponLicenses)
        UpdateClientData('mdtData_weaponLicenses', MDTDATABASE.mdtData_weaponLicenses[plus])
    end)

    MetaData = {
        Owner = citizenIdData.name,
        OwnerCid = data.selectedCid,
        PrintingDate = date,
        Type = data.licenseType,
        License = data.licenseCode,
        ExpireDate = data.expirationDate
    }
  
    AddInventoryItem(source, Shared.WeaponLicenseItemName, 1, nil, MetaData)
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:AddNewHaber', function(source, cb, data, serial)
    local newNew = #AllNews+1
    local tabOwner = getTabletOwner(serial)
    local xName = Resmon.Lib.GetPlayerOfflineName(tabOwner)
    local status = 1
    local timestamp = os.time()
    AllNews[newNew] = {
        data = {
            summary = data.newArticle.summary,
            headline = data.newArticle.headline,
            content = data.newArticle.content
        },
        code = Resmon.Lib.GenerateHash(),
        author = xName,
        media = data.selectedMedias,
        category = data.newArticle.category,
        tags = data.newArticleTags or {},
        status = status,
        timestamp = timestamp,
        comments = {},
        likes = {}
    }

    MySQL.insert('INSERT INTO kibra_smartpad_news (data, code, author, media, category, tags, status, timestamp, comments, likes) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
        json.encode(AllNews[newNew].data),
        AllNews[newNew].code,
        xName,
        json.encode(AllNews[newNew].media),
        AllNews[newNew].category,
        json.encode(AllNews[newNew].tags),
        status,
        timestamp,
        '[]',
        0
    })

    cb(true)
    TriggerClientEvent('Kibra:SmartPad:Client:UpdateNews', -1, AllNews[newNew])
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:ApproveCase', function(source, cb, crimeid, serial)
    local crimeId = 0
    local date = os.date("%d/%m/%Y")
    local tabData = GetTabData(serial)
    local tcache = {}
    for k,v in pairs(MDTDATABASE.mdtData_crimeRecords) do
        if v.crime_id == crimeid then
            v.status = 1
            v.approved_by = tabData.data.ownername
            v.casedate = date
            v.timeline[#v.timeline+1] = {step = #v.timeline+1, type = 'approved', date = date}
            tcache = v.timeline
            crimeId = k
        end
    end

    MySQL.Async.execute('UPDATE kibra_smartpad_crime_records SET status = ?, approved_by = ?, casedate = ?, timeline = ? WHERE crime_id = ?', {1, tabData.data.ownername, date, json.encode(tcache), crimeid})
    UpdateClientData('mdtData_crimeRecords', MDTDATABASE.mdtData_crimeRecords[crimeId])
    cb(MDTDATABASE.mdtData_crimeRecords[crimeId])
end)

function GetTabletMailFromOwner(citizenid)
    local mails = {}
    for k,v in pairs(Shared.Tablets) do
        if v.owner == citizenid then
            mails[#mails+1] = v.email
        end
    end
    return mails
end

Resmon.Lib.Callback.Register('Kibra:SmartPad:RejectCase', function(source, cb, serial, data)
    local crimeId = 0
    local crimeid = data.id
    local reason = data.reason
    local date = os.date("%d/%m/%Y")
    local tabData = GetTabData(serial)
    local officerCid = nil 
    local tcache = {}

    for k,v in pairs(MDTDATABASE.mdtData_crimeRecords) do
        if v.crime_id == crimeid then
            v.status = 3
            v.approved_by = tabData.data.ownername
            crimeId = k
            v.reason = reason
            v.casedate = date
            v.timeline[#v.timeline+1] = {step = #v.timeline+1, type = 'rejected', date = date}
            tcache = v.timeline
            officerCid = v.officer_id -- burada kaldık
        end
    end

    local MailContent = {
        subject = string.format(OpenedTabletLang.caserejected, crimeid),
        message = string.format(OpenedTabletLang.mailMessage, crimeid, tabData.data.ownername, data.reason)
    }
    
    local From_Name = tabData.data.ownername
    local From = tabData.email
    local Type = 0
    for k,v in pairs(GetTabletMailFromOwner(officerCid)) do
        exports['kibra-smartpad']:CreateNewMail(v, MailContent, From_Name, From, Type)    
    end
    MySQL.Async.execute('UPDATE kibra_smartpad_crime_records SET status = ?, approved_by = ?, reason = ?, casedate = ?, timeline = ? WHERE crime_id = ?', {3, tabData.data.ownername, reason, date, json.encode(tcache), crimeid})
    UpdateClientData('mdtData_crimeRecords', MDTDATABASE.mdtData_crimeRecords[crimeId])
    cb(MDTDATABASE.mdtData_crimeRecords[crimeId])
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:UsePowerBank', function(source, cb, serial)
    local getItemName = Shared.PowerBankItemName
    local chargeValue = Shared.PowerBankChargeValue
    local getItemFromInventory = GetInventoryItemAmount(source, getItemName, 1)
    if getItemFromInventory then
        RemoveInventoryItem(source, getItemName, 1)
        cb(chargeValue) 
    else
        cb(false)
    end
end)

function GetCrimeData(crimeId, typ)
    local data = {}
    if typ ~= 'vehicle' then
        for k, v in pairs(MDTDATABASE.mdtData_crimeRecords) do
            if v.crime_id == crimeId then 
                data = json.decode(json.encode(v))
                data.id = k
                break
            end
        end
    else
        for k, v in pairs(MDTDATABASE.mdtData_vehicleCrimes) do
            if v.case_id == crimeId then
                data = json.decode(json.encode(v))
                data.id = k
                break
            end
        end
    end
    return data
end


function checkCourt(crime)
    local found = false
    for k,v in pairs(MDTDATABASE.governmentData_court_hearings) do
        if v.case_id == crime then
            return true
        end
    end
    return false
end

function getTa(email) 
    local tablets = {}
    local tab = {}
    for k,v in pairs(RCloudDb) do
        if v.mail == email then
            tablets = v.devices
        end
    end

    for qu,cu in ipairs(Shared.Tablets) do
        for _,data in pairs(tablets) do
            if cu.serialnumber == data then
                tab[#tab+1] = {
                    serial = cu.serialnumber,
                    tabname = cu.data.deviceName
                }
            end
        end
    end

    return tab
end

lib.callback.register('Kibra:SmartPad:GetJournalist', function(source)
    rata = {}
    rata[1] = Shared.JournalistJob
    local players = getNearestPlayers(source)
    return {data = GetOnlineOfficers(rata, 'news'), getGrades = Resmon.Lib.GetJobGrades({Shared.JournalistJob})[Shared.JournalistJob], players = players.data}
end)

lib.callback.register('Kibra:SmartPad:NewsAddComment', function(source, data, serial)
    local getTabOwner = getTabletOwner(serial)
    local xName = Resmon.Lib.GetPlayerOfflineName(getTabOwner)
    local timestamp = os.time()
    local cacheComments = {}
    for k,v in pairs(AllNews) do
        if v.code == data.postId then
            local commentH = #v.comments + 1
            v.comments[commentH] = {author = xName, content = data.comment, timestamp = timestamp}
            cacheComments = v.comments
        end
    end

    MySQL.insert('UPDATE kibra_smartpad_news SET comments = ? WHERE code = ?', {json.encode(cacheComments), data.postId})
    TriggerClientEvent('Kibra:SmartPad:AddComment', -1, data.postId, {author = xName, content = data.comment, timestamp = timestamp})
    return {author = xName, content = data.comment, timestamp = timestamp}
end)

lib.callback.register('Kibra:SmartPad:CreateJobApplication', function(source, data, serial)
    local checkAlready = false
    local getTabOwner = getTabletOwner(serial)
    for k,v in pairs(AllNewsApplications) do
        if v.cid == getTabOwner then
            checkAlready = true
        end
    end
    if checkAlready then return false end

    local newApplication = #AllNewsApplications + 1
    AllNewsApplications[newApplication] = {
        name = data.name,
        age = data.age,
        role = data.role,
        experience = data.experience,
        motivation = data.motivation,
        cid = getTabOwner
    }

    MySQL.insert('INSERT INTO kibra_smartpad_newsapplications (name, age, role, experience, motivation, cid) VALUES(?, ?, ?, ?, ?, ?)', {
        data.name,
        data.age,
        data.role,
        data.experience,
        data.motivation,
        getTabOwner
    })

    local getRequired = GetRequiredUsers('weazel')
    for k,v in pairs(getRequired) do
        TriggerClientEvent('Kibra:SmartPad:CreateJobApplication', v, newApplication, AllNewsApplications[newApplication])
    end
    return true
end)

lib.callback.register('Kibra:SmartPad:RemoveJournalist', function(source, staffId)
    rata = {}
    rata[1] = Shared.JournalistJob
    Resmon.Lib.SetPlayerJob(staffId, Shared.UnemployedJobData.name, Shared.UnemployedJobData.grade)
    return {data = GetOnlineOfficers(rata, 'news')}
end)

lib.callback.register('Kibra:SmartPad:CheckLogin', function(source, datax)
    local matched = false
    for k,v in pairs(RCloudDb) do
        if v.mail == datax.email and v.password == datax.password then
            matched = true
        end
    end
    
    return {export = matched, data = getTa(datax.email)}
end)

lib.callback.register('Kibra:SmartPad:AddNewJournalist', function(source, data)
    rata = {}
    rata[1] = Shared.JournalistJob
    Resmon.Lib.SetPlayerJob(data.cid, Shared.JournalistJob, data.role)
    return {data = GetOnlineOfficers(rata, 'news')}
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:AddNewCourt', function(source, cb, data)
    local crimeId = data.caseid
    local checked = checkCourt(crimeId)
    if checked then return cb(false) end
    data.judge = json.decode(data.judge)
    local judgeCid, judgeName = data.judge.cid, data.judge.name
    local date = data.courtDate
    local dateX = os.date("%d/%m/%Y")
    local time = data.courtTime
    data.courtData = json.decode(data.courtData)
    local courtSaloon, courtSaloonName, courtSaloonLocation = data.courtData.id, data.courtData.name, data.courtData.location
    local courtSaloonData = Shared.CourtRooms[courtSaloon]
    local notes = data.notes
    local newCourt = #MDTDATABASE.governmentData_court_hearings + 1
    local getCrimeData = GetCrimeData(crimeId, 'citizen') 

    MDTDATABASE.governmentData_court_hearings[newCourt] = {
        case_id = crimeId,
        date = date,
        time = time,
        assinged_judge = {cid = judgeCid, name = judgeName},
        courtroom = {
            x = courtSaloonData.Coords.x, y = courtSaloonData.Coords.y, z = courtSaloonData.Coords.z, salonName = courtSaloonName, location = courtSaloonLocation,
        },
        notes = notes,
        created_at = dateX
    }

    MySQL.insert('INSERT INTO kibra_smartpad_court_hearings (case_id, date, time, assigned_judge, courtroom, notes, created_at) VALUES(?,?,?,?,?,?,?)', {
        crimeId,
        date,
        time,
        json.encode(MDTDATABASE.governmentData_court_hearings[newCourt].assinged_judge),
        json.encode(MDTDATABASE.governmentData_court_hearings[newCourt].courtroom),
        notes,
        dateX
    })

    if data.type == 'citizen' then
        table.insert(getCrimeData.timeline, {step = #getCrimeData.timeline + 1, date = dateX, type = 'hourtcreated'})
        
        for k,v in pairs(MDTDATABASE.mdtData_crimeRecords) do
            if v.crime_id == crimeId then 
                v.timeline = getCrimeData.timeline
            end
        end

        MySQL.update('UPDATE kibra_smartpad_crime_records SET timeline = ? WHERE crime_id = ?', {json.encode(getCrimeData.timeline), crimeId})
        UpdateClientData('mdtData_crimeRecords', MDTDATABASE.mdtData_crimeRecords[getCrimeData.id])
        UpdateClientData('governmentData_court_hearings', MDTDATABASE.governmentData_court_hearings[newCourt])
        cb(MDTDATABASE.mdtData_crimeRecords[getCrimeData.id], MDTDATABASE.governmentData_court_hearings[newCourt])
        local From_Name = Shared.DOJAppMail.AccountName
        local From = Shared.DOJAppMail.Mail
        local Type = 0
        local crimeNames = {}
        for _, c in pairs(getCrimeData.articles or {}) do
            table.insert(crimeNames, c.name)
        end
        -- FOR CITIZEN
        for k, v in pairs(getCrimeData.offenders) do
            local MailContent = {
                subject = OpenedTabletLang.courtsubject,
                message = string.format(
                    OpenedTabletLang.courtmessage,
                    v.name,      -- %s1
                    crimeId,     -- %s2 (veya caseName)
                    date,        -- %s3
                    judgeName,   -- %s4
                    table.concat(crimeNames, ", ") -- %s5
                )
            }
            local getOffenderMails = GetPlayerEmails(v.cid)
            for q, s in pairs(getOffenderMails) do
                exports["kibra-smartpad"]:CreateNewMail(s, MailContent, From_Name, From, Type)
            end
        end

        -- FOR JUDGE
        local offenderNames = {}
        for _, v in pairs(getCrimeData.offenders or {}) do
            table.insert(offenderNames, v.name)
        end

        local JudgeMailContent = {
            subject = OpenedTabletLang.courtsubject_judge,
            message = string.format(
                OpenedTabletLang.courtmessage_judge,
                judgeName,                                  -- %s1
                crimeId,                                    -- %s2 (veya caseName)
                date,                                       -- %s3
                table.concat(offenderNames, ", "),          -- %s4
                table.concat(crimeNames, ", ")              -- %s5
            )
        }
        local getJudgeMails = GetPlayerEmails(judgeCid)
        for q, s in pairs(getJudgeMails) do
            exports["kibra-smartpad"]:CreateNewMail(s, JudgeMailContent, From_Name, From, Type)
        end
    end
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:CreateWanted', function(source, cb, data)
    local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
    local date = os.date("%d/%m/%Y")
    if data.type == 'citizen' then
        local check = false

        for k,v in pairs(MDTDATABASE.mdtData_wantedPeople) do
            fullName = v.first_name..' '..v.last_name
            fullName2 = data.firstname..' '..data.lastname
            if fullName == fullName2 then
                check = true
            end
        end
        
        if check then return cb('already') end

        local new = #MDTDATABASE.mdtData_wantedPeople + 1
        MDTDATABASE.mdtData_wantedPeople[new] = {
            cid = data.cid,
            first_name = data.firstname,
            last_name = data.lastname,
            crime_description = data.details,
            wanted_since = date,
            last_seen_location = data.location,
            danger_level = data.dangerlevel,
            medias = data.medias,
            added_by = xPlayer.name
        }

        if Shared.JudicialMode == 'POLICE' then
            MDTDATABASE.mdtData_wantedPeople[new].status = 1
        end

        MySQL.Async.execute('INSERT INTO kibra_smartpad_wanted_people (cid, first_name, last_name, crime_description, wanted_since, last_seen_location, danger_level, added_by, medias) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)', {
            data.cid,
            data.firstname,
            data.lastname,
            data.details,
            date,
            data.location,
            data.dangerlevel,
            xPlayer.name,
            json.encode(data.medias)
        }, function()
            cb(MDTDATABASE.mdtData_wantedPeople)
            UpdateClientData('mdtData_wantedPeople', MDTDATABASE.mdtData_wantedPeople[new])
        end)
    else
        local new = #MDTDATABASE.mdtData_wantedVehicles + 1
        local findModel = FindVehicleModel(data.orgModel)
        MDTDATABASE.mdtData_wantedVehicles[new] = {
            plate = data.plate,
            model = data.vehicleModel,
            modellabel = findModel,
            color = data.vehicleColor,
            last_seen_location = data.location,
            reason = data.details,
            wanted_since = date,
            danger_level = data.dangerlevel,
            added_by = xPlayer.name,
            medias = {}
        }

        MySQL.Async.execute('INSERT INTO kibra_smartpad_wanted_vehicles (plate, model, modellabel, color, last_seen_location, wanted_since, danger_level, reason, added_by, medias) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
            data.plate,
            data.vehicleModel,
            findModel,
            data.selectedColor,
            data.location,
            date,
            data.dangerlevel,
            data.details,
            xPlayer.name,
            json.encode(data.medias)
        }, function()
            cb(MDTDATABASE.mdtData_wantedVehicles)
            UpdateClientData('mdtData_wantedPeople', MDTDATABASE.mdtData_wantedVehicles[new])
        end)
        
    end
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:UpdateMainData', function(source, cb, serial, data)
    local xData = {}
    data.serial = serial

    for k,v in pairs(Shared.Tablets) do
        if v.serialnumber == serial then
            if data.datatype == 'passcode' then
                if data.result ~= 'nopass' then
                    data.result = tonumber(data.result)
                end
            end
            v.data[data.datatype] = data.result
            xData = v
        end
    end

    MySQL.update('UPDATE kibra_smartpad_tablets SET data = ? WHERE serialnumber = ?', {json.encode(xData.data), serial}, function(result)
        if result then
            TriggerClientEvent('Kibra:SmartPad:UpdateTabletMiniData', -1, data)
            cb(xData)
        end
    end)
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:CreateNewAlbum', function(source, cb, data, serial)
    local tabletData = FindTabletData(serial) 
    local newAlbum = #tabletData[1].albums + 1
    tabletData[1].albums[newAlbum] = {
        name = data.albumName,
        medias = {}
    }

    MySQL.Async.execute('UPDATE kibra_smartpad_tablets SET albums = ? WHERE serialnumber = ?', {json.encode(tabletData[1].albums), serial})
    TriggerClientEvent('Kibra:SmartPad:Client:UpdateAlbumData', -1, false, tabletData[1].albums[newAlbum], serial)
    cb(true)
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:UpdatePlayerJob', function(source, cb, data)
    -- Resmon.Lib.SetPlayerJob(data.cid, data.job, data.gradelevel)
    cb('ok')
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:Server:SendAirDrop', function(source, cb, data)
    local sender = data.sender
    local receiver = data.receiverTab
    local code = tonumber(data.photoCode)
    local receiverSrc = tonumber(data.receiverSource)

    if sender ~= receiver then
        local findPhotoData = FindPhotoData(sender, code)
        local findData = FindTabletData(receiver)
        local newPhoto = #findData[1].gallery + 1
        findData[1].gallery[newPhoto] = {
            type = findPhotoData.type,
            url = findPhotoData.url,
            code = math.random(111111,999999)
        }

        MySQL.Async.execute('UPDATE kibra_smartpad_tablets SET gallery = ? WHERE serialnumber = ?', {json.encode(findData[1].gallery), receiver})
        TriggerClientEvent('Kibra:SmartPad:Client:UpdateReceiverGallery', -1, findData[1].gallery[newPhoto], receiver)
        TriggerClientEvent('Kibra:SmartPad:Client:UpdateReceiverGallerySelf', receiverSrc, findData[1].gallery[newPhoto])
        cb(true)
    else
        cb(false)
    end
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:Client:AddAlbum', function(source, cb, data, serial)
    local f = FindTabletData(serial)
    local d = f[1]
    local photos = GetSelectedPhotos(data.photoCodes, serial)
    local getAlbumData = {}
    local newData = {}
    for k,v in pairs(d.albums) do
        if v.name == data.albumName then
            for q,s in pairs(photos) do
                v.medias[#v.medias+1] = s
                getAlbumData = d.albums
                newData = v
            end
        end
    end

    MySQL.Async.execute('UPDATE kibra_smartpad_tablets SET albums = ? WHERE serialnumber = ?', {json.encode(getAlbumData), serial})
    TriggerClientEvent('Kibra:SmartPad:Client:UpdateAlbums', -1, serial, newData, data.albumName)
    cb(newData)
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:CreateVehicleCrime', function(source, cb, data)
    local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
    local cars = data.offenders
    local caseNumber = data.caseNumber
    local witnesses = data.witnesses
    local reason = data.reason
    local medias = data.medias
    local driverName = data.driverName
    local date = data.date
    local money = data.money
    local time = data.time
    local location = data.location
    local crimes = data.crimes
    local vehicleData = {}

    local newVehicleCrime = #MDTDATABASE.mdtData_vehicleCrimes + 1
    MDTDATABASE.mdtData_vehicleCrimes[newVehicleCrime] = {
        case_id = caseNumber,
        cars = cars,
        crimes = json.encode(crimes),
        date = date,
        dname = driverName,
        fine_amount = tonumber(data.money),
        location = location,
        officer_id = xPlayer.identifier,
        officer_name = xPlayer.name,
        notes = data.reason,
        media = json.encode(medias),
        vehicle_data = {}
    }

    for k,v in pairs(MDTDATABASE.mdtData_vehicleCrimes[newVehicleCrime].cars) do
        vColor1, vColor2, vColor3, modelName = GetVehicleColorNames(v.plate)
        table.insert(MDTDATABASE.mdtData_vehicleCrimes[newVehicleCrime].vehicle_data, json.encode({
            plate = v.plate,
            model = v.model,
            color = vColor1
        }))
    end
    

    MySQL.insert('INSERT INTO kibra_smartpad_vehicle_crimes (case_id, cars, crimes, date, dname, fine_amount, location, officer_id, officer_name, notes, media, vehicle_data) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
        caseNumber,
        json.encode(cars),
        json.encode(crimes),
        date,
        driverName,
        tonumber(data.money),
        location,
        xPlayer.identifier,
        xPlayer.name,
        reason,
        json.encode(medias),
        json.encode(MDTDATABASE.mdtData_vehicleCrimes[newVehicleCrime].vehicle_data)
    }, function()
        cb(MDTDATABASE.mdtData_vehicleCrimes[newVehicleCrime])
        UpdateClientData('mdtData_vehicleCrimes', MDTDATABASE.mdtData_vehicleCrimes[newVehicleCrime])
    end)
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:AddTreatment', function(source, cb, data, owner)
    local xPlayerDataName = Resmon.Lib.GetPlayerOfflineName(owner)
    local date = os.date("%d/%m/%Y")
    local newtreat = #EMSDATABASE.emsData_treatments+1
    EMSDATABASE.emsData_treatments[newtreat] = {
        patient_id = data.selectedPerson,
        drug = data.selectedDrug,
        responsible = xPlayerDataName,
        date = date
    }

    MySQL.insert('INSERT INTO kibra_smartpad_treatments (patient_id, drug, responsible, date) VALUES(?, ?, ?, ?)', {
        data.selectedPerson,
        data.selectedDrug,
        xPlayerDataName,
        date
    }, function()
        cb(EMSDATABASE.emsData_treatments)
        UpdateClientDataForEms('emsData_treatments', EMSDATABASE.emsData_treatments[newtreat])
    end)
end)

RegisterCommand('testmail', function(source, args)
    local Receiver = 'boruhan.naster@0resmon.com'
    local MailContent = {
        subject = 'Urgent: You Have Unpaid Debts',
        message = "Hello, you have unpaid invoices to our mechanical company. We kindly ask you to pay.",
    }
    local From_Name = 'Los Santos Mechanic'
    local From = 'lossantos@0resmon.com'
    local Type = 0
    exports["kibra-smartpad"]:CreateNewMail(Receiver, MailContent, From_Name, From, Type)
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:Server:SendMail', function(source, cb, data, serial)
    local f = FindTabletData(serial)
    local d = f[1]
    local date = os.date("%d/%m/%Y")
    local newMail = #AllMails + 1
    local Player = nil
    local f = FindTabletData(serial)
    local tabOwner = GetTabletOwnerFromMail(data.receiver)
    local d = f[1]
    local src = Resmon.Lib.GetPlayerByIdentifier(tabOwner)
    if src then
        Player = Resmon.Lib.GetPlayerFromSource(src)
    end

    AllMails[newMail] = {
        receiver = data.receiver,
        data = {
            subject = data.subject,
            message = data.message
        },
        from_name = d.data.ownername,
        from = data.fromMail,
        type = data.type,
        date = date,
    }

    MySQL.Async.execute([[
        INSERT INTO kibra_smartpad_mails (`receiver`, `data`, `from`, `from_name`, `type`, `date`)
        VALUES (?, ?, ?, ?, ?, ?)
    ]],  {
        AllMails[newMail].receiver,
        json.encode(AllMails[newMail].data),
        AllMails[newMail].from,
        AllMails[newMail].from_name,
        AllMails[newMail].type,
        AllMails[newMail].date
    })


    TriggerClientEvent('Kibra:SmartPad:Client:AddNewMail', -1, AllMails[newMail])
    if Player then
        TriggerClientEvent('Kibra:SmartPad:Client:NewMail', Player.source)
    end

    cb(true)
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:AddDoctorNote', function(source, cb, data, owner)
    local xPlayerDataName = Resmon.Lib.GetPlayerOfflineName(owner)
    local date = os.date("%d/%m/%Y")
    local newtreat = #EMSDATABASE.emsData_notes +1
    EMSDATABASE.emsData_notes[newtreat] = {
        citizen_id = data.selectedPerson,
        doctor_name = xPlayerDataName,
        note = data.note,
        created_at = date
    }

    MySQL.insert('INSERT INTO kibra_smartpad_doctor_notes (citizen_id, doctor_name, note, created_at) VALUES(?, ?, ?, ?)', {
        data.selectedPerson,
        data.responsible,
        data.note,
        date
    }, function()
        cb(EMSDATABASE.emsData_notes)
        UpdateClientDataForEms('emsData_notes', EMSDATABASE.emsData_notes[newtreat])
    end)
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:CreateNewNote', function(source, cb, data, tabserial)
  -- JS'ten gönderilen id’yi al
  local id = data.id
  if not id then
    print('Hata: CreateNewNote’da id gelmedi!')
    return cb('error')
  end

  local note      = data.note       -- JS’ten { date, text, label, drawing }
  local resource  = GetCurrentResourceName()

  -- JSON’u yüklerken artık array ([]) değil, object ({}) mantığıyla
  local jsonStr   = LoadResourceFile(resource, 'data/notes.json') or '{}'
  local notesTable= json.decode(jsonStr)

  if notesTable[id] == nil then
    print('Yeni not eklendi: ' .. id)
    -- boştan yeni bir tablo oluştur
    notesTable[id] = {}
  else
    print('Mevcut not güncellendi: ' .. id)
  end

  -- Gelen note bilgisini doğrudan string-hash key’i altında sakla
  notesTable[id].text    = note.text
  notesTable[id].label   = note.label
  notesTable[id].date    = note.date
  notesTable[id].drawing = note.drawing
  notesTable[id].owner   = tabserial

  -- JSON’a geri yaz
  SaveResourceFile(Shared.ScriptName, 'data/notes.json', json.encode(notesTable, { indent = true }), -1)
  TriggerClientEvent('Kibra:SmartPad:Client:UpdateNotes', -1, id, notesTable[id])
  TriggerClientEvent('Kibra:SmartPad:UpdateNotesSelf', source)
  cb('ok')
end)


Resmon.Lib.Callback.Register('Kibra:SmartPad:CreateNewCrime', function(source, cb, data, serial)
    local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
    local tabOwner = getTabletOwner(serial)
    local xName = Resmon.Lib.GetPlayerOfflineName(tabOwner)
    local offenders = data.offenders
    local caseNumber = data.caseNumber
    local witnesses = data.witnesses
    local reason = data.reason
    local medias = data.medias
    local plate = data.plate
    local prisonTime = data.prisonTime
    local location = data.location
    local crimes = data.crimes
    local date = data.date
    local money = data.money
    local time = data.time
    local newCrime = #MDTDATABASE.mdtData_crimeRecords + 1
    local status = 0

    if Shared.JudicialMode == 'POLICE' then
        status = 1
    end
    
    MDTDATABASE.mdtData_crimeRecords[newCrime] = {
        crime_id = caseNumber,
        offenders = offenders,
        date = date,
        officer_name = xName,
        officer_id = tabOwner,
        description = reason,
        location = location,
        articles = crimes,
        fine_amount = money,
        jail_time = prisonTime,
        created_at = date,
        media = medias,
        witnesses = witnesses,
        vehicle_data = {},
        status = status,
        timeline = {
            {
                step = 1,
                type = 'created',
                date = date
            }
        }
    }

    if plate ~= nil and plate ~= '' then
        vColor1, vColor2, vColor3, modelName = GetVehicleColorNames(plate)
        MDTDATABASE.mdtData_crimeRecords[newCrime].vehicle_data = {
            modelName = modelName,
            color1 = vColor1,
            color2 = vColor2,
            color3 = vColor3
        }
    end

    local Products = {}
    local MailContent = {
       subject = Shared.MDTMail.AccountName,
       fines = {}
    }

    local totalFine = 0
    
    for q,s in pairs(crimes) do
        totalFine = totalFine + s.fine
        Products[#Products+1] = {
            Description = s.name,
            Quantity = 1,
            Price = s.fine
        }

        MailContent.fines[#MailContent.fines+1] = {
            fineLabel = s.name,
            price = s.fine,
        }
    end
    
    if Shared.JudicialMode == 'POLICE' then
        MailContent.totalPrice = totalFine
        local allMails = GetPlayerEmails(xPlayer.identifier)
        for k,v in pairs(allMails) do
            exports['kibra-smartpad']:CreateNewMail(v, MailContent, Shared.MDTMail.AccountName, Shared.MDTMail.Mail, 1)
        end

        for k,v in pairs(offenders) do
            exports["kibra-smartpad"]:CreateNewBill(v.cid, Resmon.Lib.AddDaysToDate(Shared.PoliceFinesDueDate), Products, 0, reason, 'police')
        end

        MySQL.insert('INSERT INTO kibra_smartpad_crime_records (offenders, crime_id, date, officer_name, officer_id, articles, description, location, fine_amount, jail_time, created_at, media, witnesses, vehicle_data, timeline) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
            json.encode(offenders),
            caseNumber,
            date,
            xName,
            tabOwner,
            json.encode(crimes),
            reason,
            location,
            money,
            prisonTime,
            date,
            json.encode(medias),
            witnesses,
            json.encode(MDTDATABASE.mdtData_crimeRecords[newCrime].vehicle_data),
            json.encode(MDTDATABASE.mdtData_crimeRecords[newCrime].timeline)
        }, function()
            cb(MDTDATABASE.mdtData_crimeRecords[newCrime])
            UpdateClientData('mdtData_crimeRecords', MDTDATABASE.mdtData_crimeRecords[newCrime])
        end)
    else
        MySQL.insert('INSERT INTO kibra_smartpad_crime_records (offenders, crime_id, date, officer_name, officer_id, articles, description, location, fine_amount, jail_time, created_at, media, witnesses, vehicle_data, timeline) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
            json.encode(offenders),
            caseNumber,
            date,
            xName,
            tabOwner,
            json.encode(crimes),
            reason,
            location,
            money,
            prisonTime,
            date,
            json.encode(medias),
            witnesses,
            json.encode(MDTDATABASE.mdtData_crimeRecords[newCrime].vehicle_data),
            json.encode(MDTDATABASE.mdtData_crimeRecords[newCrime].timeline)
        }, function()
            cb(MDTDATABASE.mdtData_crimeRecords[newCrime])
            UpdateClientData('mdtData_crimeRecords', MDTDATABASE.mdtData_crimeRecords[newCrime])
        end)
    end
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:VerdictCase', function(source, cb, data)
    local getCrimeData = GetCrimeData(data.crimeId, 'citizen')
    local prison = data.prison 
    local tcache = {}
    local date = os.date("%d/%m/%Y")
    local tid = 0
    local jailTime = 0
    if prison then
        jailTime = data.jailtime
    end

    local Products = {}
    local MailContent = {
       subject = Shared.MDTMail.AccountName,
       fines = {}
    }

    local totalFine = 0
    
    for q,s in pairs(data.crimes) do
        totalFine = totalFine + s.fine
        Products[#Products+1] = {
            Description = s.name,
            Quantity = 1,
            Price = s.fine
        }

        MailContent.fines[#MailContent.fines+1] = {
            fineLabel = s.name,
            price = s.fine,
        }
    end


    for k,v in pairs(MDTDATABASE.mdtData_crimeRecords) do
        if v.crime_id == data.crimeId then
            v.articles = data.crimes 
            v.fine_amount = tonumber(data.totalFine)
            v.jail_time = jailTime 
            v.status = 4
            v.timeline[#v.timeline+1] = {step = 4, date = date, type = 'verdicted'}
            tcache = v.timeline
            tid = k
        end
    end

    MySQL.update('UPDATE kibra_smartpad_crime_records SET articles = ?, fine_amount = ?, jail_time = ?, status = ?, timeline = ? WHERE crime_id = ?', {
        json.encode(data.crimes),
        tonumber(data.totalFine),
        jailTime, 
        4,
        json.encode(tcache),
        data.crimeId
    })

    MailContent.totalPrice = totalFine

    for k,v in pairs(getCrimeData.offenders) do
        exports["kibra-smartpad"]:CreateNewBill(v.cid, Resmon.Lib.AddDaysToDate(Shared.PoliceFinesDueDate), Products, 0, getCrimeData.description, 'police')
        local allMails = GetPlayerEmails(v.cid)
        for q,s in pairs(allMails) do
            exports['kibra-smartpad']:CreateNewMail(s, MailContent, Shared.MDTMail.AccountName, Shared.MDTMail.Mail, 1)
        end
    end

    cb(MDTDATABASE.mdtData_crimeRecords[tid])
    UpdateClientData('mdtData_crimeRecords', MDTDATABASE.mdtData_crimeRecords[tid])
end)

checkLoc = function(paylasan, paylasilacak)
    if SharedLocations[paylasan] then
        if SharedLocations[paylasan][paylasilacak] then return true else return false end
    end
end

Resmon.Lib.Callback.Register('Kibra:SmartPad:ShareLocation', function(source, cb, data, serial)
    local tabOwner = getTabletOwner(serial)
    local f = FindTabletData(serial)
    local checkVar = checkLoc(tabOwner, data.pcid)
    local paylasilan = Resmon.Lib.GetPlayerByIdentifier(data.pcid)

    if checkVar then return cb(false) end
    if not SharedLocations[tabOwner] then SharedLocations[tabOwner] = {} end
    SharedLocations[tabOwner][data.pcid] = true
    SaveResourceFile(Shared.ScriptName, 'data/sharedlocations.json', json.encode(SharedLocations, { indent = true }), -1)
    TriggerClientEvent('Kibra:SmartPad:Client:ShareLocationEveryone', -1, tabOwner, data.pcid)
    cb(true)
    if paylasilan > 0 then
        -- rp = Resmon.Lib.GetPlayerFromSource(paylasilan)
        TriggerClientEvent('Kibra:SmartPad:Client:ShareLocation', paylasilan, f[1].ownername)
    end
end)

RegisterCommand('testbill', function(source)
    local Player = Resmon.Lib.GetPlayerFromSource(source)
    local DueDate = '2025-06-29'
    local Products = {
        {
            Description = 'Car Repair',
            Quantity = 1,
            Price = 1000
        }
    }
    local Status = 0 -- Pending || 1 : Paid
    local Note = 'Please pay your invoice.'
    exports["kibra-smartpad"]:CreateNewBill(Player.identifier, DueDate, Products, Status, Note, Player.job.name)
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:CreateNewBill', function(source, cb, data)
    local receiver = Resmon.Lib.GetPlayerByIdentifier(data.selectedPlayer)
    if receiver > 0 then
        ReceiverData = Resmon.Lib.GetPlayerFromSource(receiver)
    end

    local newInvoice = #AllInvoices+1
    AllInvoices[newInvoice] = {
        ikey = Resmon.Lib.GenerateHash(),
        owner = data.selectedPlayer,
        date = data.invoiceDate,
        duedate = data.dueDate,
        content = data.items,
        totalamount = tonumber(data.total),
        status = data.status,
        notes = data.notes,
        job = data.ownerJob,
        name = Resmon.Lib.GetPlayerOfflineName(data.selectedPlayer)
    }

    MySQL.insert([[
        INSERT INTO `kibra_smartpad_invoices`
            (`ikey`,`owner`,`date`,`duedate`,`content`,`totalamount`,`status`,`notes`,`job`)
        VALUES(?,?,?,?,?,?,?,?,?)
        ]], {
        AllInvoices[newInvoice].ikey,
        AllInvoices[newInvoice].owner,
        AllInvoices[newInvoice].date,
        AllInvoices[newInvoice].duedate,
        json.encode(AllInvoices[newInvoice].content),
        AllInvoices[newInvoice].totalamount,
        AllInvoices[newInvoice].status,
        AllInvoices[newInvoice].notes,
        AllInvoices[newInvoice].job
    })

    local MailContent = {}
    MailContent.getProducts = {}
    local TotalPrice = 0
    for k,v in pairs(AllInvoices[newInvoice].content) do
        MailContent.getProducts[#MailContent.getProducts+1] = {
            label = v.Description.. ' x'..v.Quantity,
            fine = v.Price,
        }   
        TotalPrice = TotalPrice + v.Price
    end
    MailContent.DueDate = AllInvoices[newInvoice].duedate
    MailContent.totalPrice = AllInvoices[newInvoice].totalamount
    local allMails = GetPlayerEmails(AllInvoices[newInvoice].owner)
    local From = AllInvoices[newInvoice].job..'@'..Shared.Domain
    if Shared.BillingCompanies[AllInvoices[newInvoice].job] then
        From = Shared.BillingCompanies[AllInvoices[newInvoice].job]
    end

    for k,v in pairs(allMails) do
        exports['kibra-smartpad']:CreateNewMail(v, MailContent, From.AccountName, From.Mail, 2)
    end

    TriggerClientEvent('Kibra:SmartPad:Client:AddInvoice', -1, AllInvoices[newInvoice])

    if receiver > 0 then
        TriggerClientEvent('Kibra:SmartPad:ReceiverNewBill', receiver)
    end

    cb(true)
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:PayInvoice', function(source, cb, data, serial)
    local tabletOwner = getTabletOwner(serial)
    local payment = Resmon.Lib.RemoveMoneyOfflineOrOnline(tabletOwner, tonumber(data.invoicePrice))
    if payment then
        for k,v in pairs(AllInvoices) do
            if v.ikey == data.invoiceKey then
                v.status = 1
            end
        end

        MySQL.Async.execute('UPDATE kibra_smartpad_invoices SET status = ? WHERE ikey = ?', {1, data.invoiceKey})
        TriggerClientEvent('Kibra:SmartPad:Client:UpdateInvoiceStatus', -1, data.invoiceKey, 1)
        TriggerClientEvent('Kibra:SmartPad:ReceiverNewBill', source)
        -- Add Society Money [Soon]
        cb(true)
    else
        cb(false)
    end
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:DeleteMdtData', function(source, cb, data)
    local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
    local tableX = {} 
    local okay = false

    if data.type == 'crimepersonal' then
        for k,v in pairs(MDTDATABASE.mdtData_crimeRecords) do
            if v.crime_id == data.deletedData then
                table.remove(MDTDATABASE.mdtData_crimeRecords, k)
                tableX[1] = 'MDTDATABASE.mdtData_crimeRecords'
                tableX[2] = 'crime_id'
                tableX[3] = 'kibra_smartpad_crime_records'
            end
        end
    elseif data.type == 'crimevehicle' then
        for k,v in pairs(MDTDATABASE.mdtData_vehicleCrimes) do
            if v.case_id == data.deletedData then
                table.remove(MDTDATABASE.mdtData_vehicleCrimes, k)
                tableX[1] = 'MDTDATABASE.mdtData_vehicleCrimes'
                tableX[2] = 'case_id'
                tableX[3] = 'kibra_smartpad_vehicle_crimes'
            end
        end
    elseif data.type == 'wantedlist' then
        for k,v in pairs(MDTDATABASE.mdtData_wantedPeople) do
            if v.cid == data.deletedData then
                table.remove(MDTDATABASE.mdtData_wantedPeople, k)
                tableX[1] = 'MDTDATABASE.mdtData_wantedPeople'
                tableX[2] = 'cid'
                tableX[3] = 'kibra_smartpad_wanted_people'
            end
        end
    elseif data.type == 'wantedlistveh' then
        for k,v in pairs(MDTDATABASE.mdtData_wantedVehicles) do
            if v.cid == data.deletedData then
                table.remove(MDTDATABASE.mdtData_wantedVehicles, k)
                tableX[1] = 'MDTDATABASE.mdtData_wantedVehicles'
                tableX[2] = 'plate'
                tableX[3] = 'kibra_smartpad_wanted_vehicles'
            end
        end
    end

    AddNewHistory(xPlayer.identifier, data)
    MySQL.Async.execute('DELETE FROM '..tableX[3]..' WHERE '..tableX[2].. ' = ?', {data.deletedData}, function()
        local getRequired = GetRequiredUsers('mdt')
        for k,v in pairs(getRequired) do
            TriggerClientEvent('Kibra:SmartPad:UpdateDirectData', v, data)
        end
    end)

    cb(true)
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:ResetTablet', function(source, cb, serial)
    for k,v in pairs(Shared.Tablets) do
        if v.serialnumber == serial then
            table.remove(Shared.Tablets, k)
        end
    end

    local jsonStr   = LoadResourceFile(Shared.ScriptName, 'data/notes.json') or '{}'
    local notesTable= json.decode(jsonStr)
    
    for q,s in pairs(notesTable) do
        if s.owner == serial then
            notesTable[q] = nil
        end
    end


    SaveResourceFile(Shared.ScriptName, 'data/notes.json', json.encode(notesTable, { indent = true }), -1)
    MySQL.Async.execute('DELETE FROM kibra_smartpad_tablets WHERE serialnumber = ?', {serial})
    TriggerClientEvent('Kibra:SmartPad:ResetedTablet', -1, serial, notesTable)
    cb(true)
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:AddMediaGallery', function(source, cb, serial, data)
    local newGallery = {}
    local src = source
    local date = os.date("%d/%m/%Y")

    for k,v in pairs(Shared.Tablets) do
        if v.serialnumber == serial then
            v.gallery[#v.gallery+1] = {
                type = data.type,
                url = data.url,
                date =  date,
                location = data.location,
                code = math.random(111111,999999)
            }
            newGallery = v.gallery
        end
    end

    MySQL.update('UPDATE kibra_smartpad_tablets SET gallery = ? WHERE serialnumber = ?', {json.encode(newGallery), serial}, function()
        TriggerClientEvent('Kibra:SmartPad:UpdateTabletGallery', src, serial, newGallery)
        cb(true)
    end)
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:DeletePhoto', function(source, cb, serial, data)
    local newGallery = {}
    local src = source
    
    for k,v in pairs(Shared.Tablets) do
        if v.serialnumber == serial then
            for q,s in pairs(v.gallery) do
                if s.code == data.code then
                    table.remove(v.gallery, q)
                end
            end

            if data.type == 2 then
                local newAlbum = {}
                for _, album in pairs(v.albums) do
                    for __, albumData in pairs(album.medias) do
                        if albumData.code == data.code then
                            table.remove(album.medias, __)
                        end
                    end
                    newAlbum = v.albums
                end

                MySQL.Async.execute('UPDATE kibra_smartpad_tablets SET albums = ? WHERE serialnumber = ?', {json.encode(newAlbum), serial})
                TriggerClientEvent('Kibra:SmartPad:Client:UpdateSelectedAlbum', source, serial, newAlbum)
            end
            newGallery = v.gallery
        end
    end

    MySQL.update('UPDATE kibra_smartpad_tablets SET gallery = ? WHERE serialnumber = ?', {json.encode(newGallery), serial}, function()
        TriggerClientEvent('Kibra:SmartPad:UpdateTabletGallery', src, serial, newGallery)
        cb(true)
    end)
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:DeleteSelectedNote', function(source, cb, data, serial)
    local jsonStr   = LoadResourceFile(Shared.ScriptName, 'data/notes.json') or '{}'
    local notesTable= json.decode(jsonStr)

    if notesTable[data.id] and notesTable[data.id].owner==serial then
        notesTable[data.id]=nil
    end

    SaveResourceFile(Shared.ScriptName, 'data/notes.json', json.encode(notesTable, { indent = true }), -1)
    TriggerClientEvent('Kibra:SmartPad:Client:UpdateNotes', -1, data.id, notesTable[data.id])
    cb(true)
end)

-- Insurance Callbacks
Resmon.Lib.Callback.Register('Kibra:SmartPad:CreateInsurancePolicy', function(source, cb, data)
    local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
    local citizenId = xPlayer.identifier
    local citizenName = xPlayer.name
    
    local newPolicy = {
        citizen_id = citizenId,
        citizen_name = citizenName,
        insurance_type = data.insurance_type,
        policy_number = data.policy_number,
        start_date = data.start_date,
        end_date = data.end_date,
        monthly_premium = data.monthly_premium,
        coverage_amount = data.coverage_amount,
        status = 'Active',
        emergency_contact = data.emergency_contact,
        emergency_phone = data.emergency_phone,
        created_at = os.date('%Y-%m-%d %H:%M:%S')
    }

    MySQL.insert('INSERT INTO kibra_smartpad_health_insurance (citizen_id, citizen_name, insurance_type, policy_number, start_date, end_date, monthly_premium, coverage_amount, status, emergency_contact, emergency_phone) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
        citizenId,
        citizenName,
        data.insurance_type,
        data.policy_number,
        data.start_date,
        data.end_date,
        data.monthly_premium,
        data.coverage_amount,
        'Active',
        data.emergency_contact,
        data.emergency_phone
    }, function(insertId)
        newPolicy.id = insertId
        
        -- Update the database
        local policies = MySQL.Sync.fetchAll("SELECT * FROM kibra_smartpad_health_insurance WHERE citizen_id = ?", {citizenId}) or {}
        if not INSURANCEDATABASE[citizenId] then
            INSURANCEDATABASE[citizenId] = {}
        end
        INSURANCEDATABASE[citizenId].insuranceData_policies = policies
        
        cb(newPolicy)
    end)
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:CreateInsuranceClaim', function(source, cb, data)
    local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
    local citizenId = xPlayer.identifier
    
    local newClaim = {
        citizen_id = citizenId,
        policy_number = data.policy_number,
        claim_number = data.claim_number,
        date = data.date,
        amount = data.amount,
        description = data.description,
        notes = data.notes,
        status = 'Pending',
        created_at = os.date('%Y-%m-%d %H:%M:%S')
    }

    MySQL.insert('INSERT INTO kibra_smartpad_insurance_claims (citizen_id, policy_number, claim_number, date, amount, description, notes, status) VALUES(?, ?, ?, ?, ?, ?, ?, ?)', {
        citizenId,
        data.policy_number,
        data.claim_number,
        data.date,
        data.amount,
        data.description,
        data.notes,
        'Pending'
    }, function(insertId)
        newClaim.id = insertId
        
        -- Update the database
        local claims = MySQL.Sync.fetchAll("SELECT * FROM kibra_smartpad_insurance_claims WHERE citizen_id = ?", {citizenId}) or {}
        if not INSURANCEDATABASE[citizenId] then
            INSURANCEDATABASE[citizenId] = {}
        end
        INSURANCEDATABASE[citizenId].insuranceData_claims = claims
        
        cb(newClaim)
    end)
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:GetInsuranceData', function(source, cb)
    local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
    local citizenId = xPlayer.identifier
    
    local policies = MySQL.Sync.fetchAll("SELECT * FROM kibra_smartpad_health_insurance WHERE citizen_id = ?", {citizenId}) or {}
    local claims = MySQL.Sync.fetchAll("SELECT * FROM kibra_smartpad_insurance_claims WHERE citizen_id = ?", {citizenId}) or {}
    -- Use medical_records table for medical history instead of medical_history table
    local medicalHistory = MySQL.Sync.fetchAll("SELECT * FROM kibra_smartpad_medical_records WHERE citizen_id = ? ORDER BY date DESC", {citizenId}) or {}
    
    -- Everyone has all permissions
    local canApproveClaims = true
    local canAccessMedicalRecords = true
    local canWriteMedicalRecords = true
    local canSeeMedicalRecordsTab = true
    
    cb({
        policies = policies,
        claims = claims,
        medicalHistory = medicalHistory,
        playerJob = xPlayer.job.name,
        canApproveClaims = canApproveClaims,
        canAccessMedicalRecords = canAccessMedicalRecords,
        canWriteMedicalRecords = canWriteMedicalRecords,
        canSeeMedicalRecordsTab = canSeeMedicalRecordsTab
    })
end)

-- New Insurance Callbacks
Resmon.Lib.Callback.Register('Kibra:SmartPad:ApproveInsuranceClaim', function(source, cb, data)
    local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
    local approverName = xPlayer.name
    
    -- Everyone can approve claims
    local hasPermission = true
    
    if not hasPermission then
        cb({success = false, message = 'You do not have permission to approve insurance claims'})
        return
    end
    
    MySQL.update('UPDATE kibra_smartpad_insurance_claims SET status = ?, approved_amount = ?, approved_by = ?, approved_date = ? WHERE id = ?', {
        data.status,
        data.approved_amount,
        approverName,
        data.approved_date,
        data.claim_id
    }, function(affectedRows)
        if affectedRows > 0 then
            -- Create transaction record for approved claims
            if data.status == 'Approved' and data.approved_amount > 0 then
                local transactionId = 'TXN-' .. math.random(100000, 999999)
                MySQL.insert('INSERT INTO kibra_smartpad_insurance_transactions (transaction_id, policy_number, type, amount, description, status) VALUES(?, ?, ?, ?, ?, ?)', {
                    transactionId,
                    data.policy_number,
                    'Claim Payout',
                    data.approved_amount,
                    'Claim payout for ' .. data.claim_number,
                    'Completed'
                })
            end
            
            cb({success = true, message = 'Claim processed successfully'})
        else
            cb({success = false, message = 'Failed to process claim'})
        end
    end)
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:CreateMedicalRecord', function(source, cb, data)
    local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
    local citizenId = xPlayer.identifier
    local playerName = xPlayer.name
    
    -- Everyone can create medical records
    local hasPermission = true
    
    if not hasPermission then
        cb({success = false, message = 'You do not have permission to create medical records'})
        return
    end
    
    MySQL.insert('INSERT INTO kibra_smartpad_medical_records (citizen_id, player_name, `condition`, diagnosis, treatment, doctor, notes, severity, status) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)', {
        citizenId,
        playerName,
        data.condition,
        data.diagnosis,
        data.treatment,
        data.doctor,
        data.notes,
        data.severity,
        'Active'
    }, function(insertId)
        if insertId then
            cb({success = true, id = insertId})
        else
            cb({success = false, message = 'Failed to create medical record'})
        end
    end)
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:GetInsuranceTransactions', function(source, cb)
    local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
    local citizenId = xPlayer.identifier
    
    -- Get all policies for this citizen
    local policies = MySQL.Sync.fetchAll("SELECT policy_number FROM kibra_smartpad_health_insurance WHERE citizen_id = ?", {citizenId}) or {}
    local policyNumbers = {}
    for _, policy in pairs(policies) do
        table.insert(policyNumbers, policy.policy_number)
    end
    
    local transactions = {}
    if #policyNumbers > 0 then
        local placeholders = string.rep('?,', #policyNumbers - 1) .. '?'
        transactions = MySQL.Sync.fetchAll("SELECT * FROM kibra_smartpad_insurance_transactions WHERE policy_number IN (" .. placeholders .. ") ORDER BY date DESC", policyNumbers) or {}
    end
    
    cb({transactions = transactions})
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:ProcessPremiumPayment', function(source, cb, data)
    local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
    local citizenId = xPlayer.identifier
    
    -- Check if player has enough money (you can integrate with your banking system)
    local playerMoney = xPlayer.getMoney() -- Adjust based on your framework
    if playerMoney < data.amount then
        cb({success = false, message = 'Insufficient funds'})
        return
    end
    
    -- Deduct money from player
    xPlayer.removeMoney(data.amount)
    
    -- Create transaction record
    local transactionId = 'TXN-' .. math.random(100000, 999999)
    MySQL.insert('INSERT INTO kibra_smartpad_insurance_transactions (transaction_id, policy_number, type, amount, description, status) VALUES(?, ?, ?, ?, ?, ?)', {
        transactionId,
        data.policy_number,
        'Premium Payment',
        -data.amount, -- Negative for outgoing payment
        'Monthly premium payment for ' .. data.policy_type,
        'Completed'
    }, function(insertId)
        if insertId then
            cb({success = true, transaction_id = transactionId})
        else
            cb({success = false, message = 'Failed to process payment'})
        end
    end)
end)

Resmon.Lib.Callback.Register('Kibra:SmartPad:ProcessPolicyRefund', function(source, cb, data)
    local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
    local citizenId = xPlayer.identifier
    
    -- Add money to player (you can integrate with your banking system)
    xPlayer.addMoney(data.amount)
    
    -- Create transaction record
    local transactionId = 'TXN-' .. math.random(100000, 999999)
    MySQL.insert('INSERT INTO kibra_smartpad_insurance_transactions (transaction_id, policy_number, type, amount, description, status) VALUES(?, ?, ?, ?, ?, ?)', {
        transactionId,
        data.policy_number,
        'Policy Refund',
        data.amount, -- Positive for incoming refund
        'Policy refund for ' .. data.policy_number,
        'Completed'
    }, function(insertId)
        if insertId then
            cb({success = true, transaction_id = transactionId})
        else
            cb({success = false, message = 'Failed to process refund'})
        end
    end)
end)

-- New Insurance Plans Callback
Resmon.Lib.Callback.Register('Kibra:SmartPad:GetInsurancePlans', function(source, cb)
    local plans = MySQL.Sync.fetchAll("SELECT * FROM kibra_smartpad_insurance_plans WHERE is_active = 1 ORDER BY category, monthly_premium") or {}
    
    cb({
        plans = plans
    })
end)

-- New Insurance Providers Callback
Resmon.Lib.Callback.Register('Kibra:SmartPad:GetInsuranceProviders', function(source, cb)
    local providers = MySQL.Sync.fetchAll("SELECT * FROM kibra_smartpad_insurance_providers WHERE is_active = 1") or {}
    
    cb({
        providers = providers
    })
end)

-- Create Insurance Plan Callback
Resmon.Lib.Callback.Register('Kibra:SmartPad:CreateInsurancePlan', function(source, cb, data)
    local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
    
    -- Everyone can create insurance plans for now
    local hasPermission = true
    
    if not hasPermission then
        cb({success = false, message = 'You do not have permission to create insurance plans'})
        return
    end
    
    MySQL.insert('INSERT INTO kibra_smartpad_insurance_plans (plan_name, category, monthly_premium, coverage_amount, description, features, deductible, max_claims_per_year, is_active, created_by) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
        data.plan_name,
        data.category,
        data.monthly_premium,
        data.coverage_amount,
        data.description or '',
        data.features or '',
        data.deductible or 0,
        data.max_claims_per_year or 10,
        1,
        xPlayer.name
    }, function(insertId)
        if insertId then
            cb({success = true, id = insertId, message = 'Insurance plan created successfully'})
        else
            cb({success = false, message = 'Failed to create insurance plan'})
        end
    end)
end)

-- New Policy Renewal Callback
Resmon.Lib.Callback.Register('Kibra:SmartPad:RenewInsurancePolicy', function(source, cb, data)
    local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
    local citizenId = xPlayer.identifier
    
    -- Update the policy end date
    MySQL.update('UPDATE kibra_smartpad_health_insurance SET end_date = ?, monthly_premium = ? WHERE id = ? AND citizen_id = ?', {
        data.new_end_date,
        data.renewal_amount,
        data.policy_id,
        citizenId
    }, function(affectedRows)
        if affectedRows > 0 then
            -- Create renewal record
            MySQL.insert('INSERT INTO kibra_smartpad_policy_renewals (policy_id, renewal_date, new_end_date, renewal_amount, status) VALUES(?, ?, ?, ?, ?)', {
                data.policy_id,
                os.date('%Y-%m-%d'),
                data.new_end_date,
                data.renewal_amount,
                'Completed'
            }, function(insertId)
                -- Update the database
                local policies = MySQL.Sync.fetchAll("SELECT * FROM kibra_smartpad_health_insurance WHERE citizen_id = ?", {citizenId}) or {}
                if not INSURANCEDATABASE[citizenId] then
                    INSURANCEDATABASE[citizenId] = {}
                end
                INSURANCEDATABASE[citizenId].insuranceData_policies = policies
                
                cb(true)
            end)
        else
            cb(false)
        end
    end)
end)

-- New Get Policy Renewals Callback
Resmon.Lib.Callback.Register('Kibra:SmartPad:GetPolicyRenewals', function(source, cb)
    local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
    local citizenId = xPlayer.identifier
    
    local renewals = MySQL.Sync.fetchAll([[
        SELECT pr.*, hi.policy_number, hi.insurance_type 
        FROM kibra_smartpad_policy_renewals pr
        JOIN kibra_smartpad_health_insurance hi ON pr.policy_id = hi.id
        WHERE hi.citizen_id = ?
        ORDER BY pr.renewal_date DESC
    ]], {citizenId}) or {}
    
    cb({
        renewals = renewals
    })
end)

-- Get Medical Records with Permission Check
Resmon.Lib.Callback.Register('Kibra:SmartPad:GetMedicalRecords', function(source, cb, targetPlayerId)
    local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
    
    -- Everyone can access medical records
    local hasPermission = true
    
    if not hasPermission then
        cb({success = false, message = 'You do not have permission to access medical records'})
        return
    end
    
    -- Get medical records for the target player
    local records = MySQL.Sync.fetchAll("SELECT * FROM kibra_smartpad_medical_records WHERE citizen_id = ? ORDER BY date DESC", {targetPlayerId}) or {}
    
    cb({
        success = true,
        records = records
    })
end)

-- Get All Medical Records (for medical staff dashboard)
Resmon.Lib.Callback.Register('Kibra:SmartPad:GetAllMedicalRecords', function(source, cb)
    local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
    
    -- Everyone can access medical records
    local hasPermission = true
    
    if not hasPermission then
        cb({success = false, message = 'You do not have permission to access medical records'})
        return
    end
    
    -- Get all medical records
    local records = MySQL.Sync.fetchAll("SELECT * FROM kibra_smartpad_medical_records ORDER BY date DESC LIMIT 100") or {}
    
    cb({
        success = true,
        records = records
    })
end)

-- Search Player by Name or Citizen ID
Resmon.Lib.Callback.Register('Kibra:SmartPad:SearchPlayer', function(source, cb, searchQuery)
    local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
    
    -- Trim the search query using Lua string manipulation
    local query = searchQuery and string.gsub(searchQuery, "^%s*(.-)%s*$", "%1") or ""
    
    if not query or query == '' then
        cb({success = false, message = 'Please provide a search query'})
        return
    end
    local results = {}
    
    -- First, try to find online players by name or citizen ID
    local players = GetPlayers()
    for _, playerId in pairs(players) do
        local player = Resmon.Lib.GetPlayerFromSource(tonumber(playerId))
        if player then
            local playerName = player.name or ''
            local citizenId = player.identifier or ''
            
            -- Check if search query matches player name or citizen ID
            if string.lower(playerName):find(string.lower(query)) or 
               string.lower(citizenId):find(string.lower(query)) then
                table.insert(results, {
                    name = playerName,
                    citizen_id = citizenId,
                    online = true,
                    source = tonumber(playerId)
                })
            end
        end
    end
    
    -- If no online players found, search in database for offline players
    if #results == 0 then
        -- First, try to find players in the medical records table (players who have records)
        local offlinePlayers = MySQL.Sync.fetchAll([[
            SELECT DISTINCT citizen_id, player_name 
            FROM kibra_smartpad_medical_records 
            WHERE LOWER(player_name) LIKE ? OR LOWER(citizen_id) LIKE ?
            LIMIT 10
        ]], {
            '%' .. string.lower(query) .. '%',
            '%' .. string.lower(query) .. '%'
        }) or {}
        
        for _, player in pairs(offlinePlayers) do
            table.insert(results, {
                name = player.player_name or 'Unknown',
                citizen_id = player.citizen_id,
                online = false,
                source = nil,
                hasRecords = true
            })
        end
        
        -- If still no results, check if the exact citizen ID exists in the system
        if #results == 0 then
            -- Try to find the player by exact citizen ID match
            local exactMatch = MySQL.Sync.fetchAll([[
                SELECT citizen_id, player_name 
                FROM kibra_smartpad_medical_records 
                WHERE citizen_id = ?
                LIMIT 1
            ]], {query}) or {}
            
            if #exactMatch > 0 then
                -- Player exists but no name match, add them
                table.insert(results, {
                    name = exactMatch[1].player_name or 'Unknown',
                    citizen_id = exactMatch[1].citizen_id,
                    online = false,
                    source = nil,
                    hasRecords = true
                })
            else
                -- Check if this might be a valid citizen ID format (you can customize this)
                if string.len(query) >= 5 then -- Basic check for valid citizen ID length
                    table.insert(results, {
                        name = 'Unknown Player',
                        citizen_id = query,
                        online = false,
                        source = nil,
                        hasRecords = false,
                        canCreateRecord = true
                    })
                end
            end
        end
    end
    
    cb({
        success = true,
        players = results,
        count = #results
    })
end)