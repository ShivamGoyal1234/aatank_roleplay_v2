registerItem(Config.WeaponLicense, function(src, item, xx)
    local found = false
    
    if Config.UseQbLicense then
        local player = getExtendedPlayer(src)
        local weaponLicense = player.PlayerData.metadata["licences"]["weapon"]

        if not weaponLicense or weaponLicense == 0 then
            TriggerClientEvent("0r_idcard:client:notify", src, "You don't have a weapon license.", "error")
            return
        end

        local slot = 0
        if xx then 
            slot = xx.slot
            if xx.slot then
                slot = xx.slot
            else
                slot = item.info
            end
        else
            slot = item.slot
        end

        if xx then 
            if xx.metadata then
                info = xx.metadata
            else
                info = xx.info
            end
        else 
            if item.metadata then
                info = item.metadata
            else 
                info = item.info
            end
        end
        if xx then
            if xx.name then
                TriggerClientEvent("0r_idcard:client:showCard", src, info, false, false, slot, xx.name)
            end
        else
            TriggerClientEvent("0r_idcard:client:showCard", src, info, false, false, slot, item.name)
        end
    elseif Config.UseEsxLicense then
        TriggerEvent('esx_license:getLicenses', src, function(licenses)
            for k, v in pairs(licenses) do
                if v.type == "weapon" or v.type == "weapon_license" then
                    local slot = 0
                    if xx then 
                        slot = xx.slot
                        if xx.slot then
                            slot = xx.slot
                        else
                            slot = item.info
                        end
                    else
                        slot = item.slot
                    end
                
                    if xx then 
                        if xx.metadata then
                            info = xx.metadata
                        else
                            info = xx.info
                        end
                    else 
                        if item.metadata then
                            info = item.metadata
                        else 
                            info = item.info
                        end
                    end
                    if xx then
                        if xx.name then
                            TriggerClientEvent("0r_idcard:client:showCard", src, info, false, false, slot, xx.name)
                        end
                    else
                        TriggerClientEvent("0r_idcard:client:showCard", src, info, false, false, slot, item.name)
                    end
                    return
                end
            end

            if not found then
                TriggerClientEvent("0r_idcard:client:notify", src, "You don't have a weapon license.", "error")
                return
            end
        end)
    else
        local slot = 0
        if xx then 
            slot = xx.slot
            if xx.slot then
                slot = xx.slot
            else
                slot = item.info
            end
        else
            slot = item.slot
        end
    
        if xx then 
            if xx.metadata then
                info = xx.metadata
            else
                info = xx.info
            end
        else 
            if item.metadata then
                info = item.metadata
            else 
                info = item.info
            end
        end
        if xx then
            if xx.name then
                TriggerClientEvent("0r_idcard:client:showCard", src, info, false, false, slot, xx.name)
            end
        else
            TriggerClientEvent("0r_idcard:client:showCard", src, info, false, false, slot, item.name)
        end
    end
end)

registerItem(Config.JobCard, function(src, item, xx)
    local slot = 0
    if xx then 
        slot = xx.slot
        if xx.slot then
            slot = xx.slot
        else
            slot = item.info
        end
    else
        slot = item.slot
    end

    if xx then 
        if xx.metadata then
            info = xx.metadata
        else
            info = xx.info
        end
    else 
        if item.metadata then
            info = item.metadata
        else 
            info = item.info
        end
    end
    if xx then
        if xx.name then
            TriggerClientEvent("0r_idcard:client:showCard", src, info, true, false, slot, item.name)
        end
    else
        TriggerClientEvent("0r_idcard:client:showCard", src, info, true, false, slot, item.name)
    end
end)

registerItem(Config.FakeIdCard, function(src, item, xx)
    local slot = 0
    if xx then 
        slot = xx.slot
        if xx.slot then
            slot = xx.slot
        else
            slot = item.info
        end
    else
        slot = item.slot
    end

    if xx then 
        if xx.metadata then
            info = xx.metadata
        else
            info = xx.info
        end
    else 
        if item.metadata then
            info = item.metadata
        else 
            info = item.info
        end
    end

    if xx then
        if xx.name then
            TriggerClientEvent("0r_idcard:client:showCard", src, info, true, false, slot, xx.name)
        end
    else
        TriggerClientEvent("0r_idcard:client:showCard", src, info, true, false, slot, item.name)
    end
end)

registerItem(Config.FakeJobCard, function(src, item, xx)
    local slot = 0
    if xx then 
        slot = xx.slot
        if xx.slot then
            slot = xx.slot
        else
            slot = item.info
        end
    else
        slot = item.slot
    end

    if xx then 
        if xx.metadata then
            info = xx.metadata
        else
            info = xx.info
        end
    else 
        if item.metadata then
            info = item.metadata
        else 
            info = item.info
        end
    end
    if xx then
        if xx.name then
            TriggerClientEvent("0r_idcard:client:showCard", src, info, true, false, slot, xx.name)
        end
    else
        TriggerClientEvent("0r_idcard:client:showCard", src, info, true, false, slot, item.name)
    end
end)

registerItem(Config.DriverLicense, function(src, item, xx)
    local found = false

    if Config.UseQbLicense then
        local player = getExtendedPlayer(src)
        local driverLicense = player.PlayerData.metadata["licences"]["driver"]

        if not driverLicense or driverLicense == 0 then
            TriggerClientEvent("0r_idcard:client:notify", src, "You don't have a driver license.", "error")
            return
        end

        local slot = 0
        if xx then 
            slot = xx.slot
            if xx.slot then
                slot = xx.slot
            else
                slot = item.info
            end
        else
            slot = item.slot
        end

        if xx then 
            if xx.metadata then
                info = xx.metadata
            else
                info = xx.info
            end
        else 
            if item.metadata then
                info = item.metadata
            else 
                info = item.info
            end
        end
        if xx then
            if xx.name then
                TriggerClientEvent("0r_idcard:client:showCard", src, info, false, false, slot, xx.name)
            end
        else
            TriggerClientEvent("0r_idcard:client:showCard", src, info, false, false, slot, item.name)
        end
    elseif Config.UseEsxLicense then
        TriggerEvent('esx_license:getLicenses', src, function(licenses)
            for k, v in pairs(licenses) do
                if v.type == "driver" or v.type == "driver_license" then
                    local slot = 0
                    if xx then 
                        slot = xx.slot
                        if xx.slot then
                            slot = xx.slot
                        else
                            slot = item.info
                        end
                    else
                        slot = item.slot
                    end
            
                    if xx then 
                        if xx.metadata then
                            info = xx.metadata
                        else
                            info = xx.info
                        end
                    else 
                        if item.metadata then
                            info = item.metadata
                        else 
                            info = item.info
                        end
                    end
                    if xx then
                        if xx.name then
                            TriggerClientEvent("0r_idcard:client:showCard", src, info, false, false, slot, xx.name)
                        end
                    else
                        TriggerClientEvent("0r_idcard:client:showCard", src, info, false, false, slot, item.name)
                    end
                    return
                end
            end
            if not found then
                TriggerClientEvent("0r_idcard:client:notify", src, "You don't have a driver license.", "error")
                return
            end
        end)
    else
        local slot = 0
        if xx then 
            slot = xx.slot
            if xx.slot then
                slot = xx.slot
            else
                slot = item.info
            end
        else
            slot = item.slot
        end

        if xx then 
            if xx.metadata then
                info = xx.metadata
            else
                info = xx.info
            end
        else 
            if item.metadata then
                info = item.metadata
            else 
                info = item.info
            end
        end
        if xx then
            if xx.name then
                TriggerClientEvent("0r_idcard:client:showCard", src, info, false, false, slot, xx.name)
            end
        else
            TriggerClientEvent("0r_idcard:client:showCard", src, info, false, false, slot, item.name)
        end
    end
end)

registerItem(Config.IdCard, function(src, item, xx)
    local slot = 0
    if xx then 
        slot = xx.slot
        if xx.slot then
            slot = xx.slot
        else
            slot = item.info
        end
    else
        slot = item.slot
    end

    if xx then 
        if xx.metadata then
            info = xx.metadata
        else
            info = xx.info
        end
    else 
        if item.metadata then
            info = item.metadata
        else 
            info = item.info
        end
    end

    if xx then
        if xx.name then
            TriggerClientEvent("0r_idcard:client:showCard", src, info, false, false, slot, xx.name)
        end
    else
        TriggerClientEvent("0r_idcard:client:showCard", src, info, false, false, slot, item.name)
    end
end)

function getPlayerName(player)
    if Config.Framework == "qb" then
        return { firstname = player.PlayerData.charinfo.firstname, lastname = player.PlayerData.charinfo.lastname }
    elseif Config.Framework == "esx" then
        local name = player.getName()
        local names = splitString(name, " ")
        if #names > 1 then
            local lastname = ""
            for i = 2, #names do
                if names[i] ~= nil then
                    lastname = lastname .. names[i] .. " "
                end
            end

            return { firstname = names[1], lastname = lastname }
        else
            return { firstname = name, lastname = "" }
        end
    end
end

function splitString(text)
    local t = {}
    for str in string.gmatch(text, "([^%s]+)") do
        table.insert(t, str)
    end
    return t
end

function getBirthDate(player)
    if Config.Framework == "qb" then
        return player.PlayerData.charinfo.birthdate
    elseif Config.Framework == "esx" then
        return player.variables.dateofbirth
    end
end

function getPlayerLicense(player)
    if Config.Framework == "qb" then
        return player.PlayerData.citizenid
    elseif Config.Framework == "esx" then
        return player.getIdentifier()
    end
end

function getGender(player)
    if Config.Framework == "qb" then
        return player.PlayerData.charinfo.gender == 0 and "Male" or "Female"
    elseif Config.Framework == "esx" then
        return player.variables.sex == "m" and "Male" or "Female"
    end
end

function getPlayerJob(src)
    local player = getExtendedPlayer(src)

    while player == nil do
        Citizen.Wait(100)
        player = getExtendedPlayer(src)
    end

    if Config.Framework == "qb" then
        return { name = player.PlayerData.job.name, grade = player.PlayerData.job.grade.level }
    elseif Config.Framework == "esx" then
        return { name = player.job.name, grade = player.job.grade }
    end
end

function getPlayerNation(src)
    local player = getExtendedPlayer(src)

    while player == nil do
        Citizen.Wait(100)
        player = getExtendedPlayer(src)
    end

    if Config.Framework == "qb" then
        return doesNationIncludesFlag(player.PlayerData.charinfo.nationality)
    elseif Config.Framework == "esx" then
        return doesNationIncludesFlag(player.variables.nationality)
    end
end

function doesNationIncludesFlag(nation)
    if not nation then
        return "us"
    end

    for k, v in pairs(Nations) do
        if string.lower(k) == string.lower(nation) then
            return v
        end
    end

    return 'us'
end

RegisterNetEvent("0r_idcard:server:createFakeCard", function(name, surname, job, date, male, female, shot, cardtype)
    local src = source
    local gender = male and "Male" or "Female"

    if removeMoney(src, Config.FakeCardPrice) then
        local player = getExtendedPlayer(src)
        local license = getPlayerLicense(player)
        local updated = false

        local timestamp = math.floor(date / 1000)
        local birthdate = os.date('%Y-%m-%d', timestamp)

        local card_metadata = {}
        card_metadata.card_name = name
        card_metadata.card_surname = surname
        card_metadata.card_birthdate = birthdate
        card_metadata.card_photo = shot
        card_metadata.license = license
        card_metadata.card_sex = gender
        card_metadata.card_type = job
        card_metadata.nationality = getPlayerNation(src)
        card_metadata.jobGrade = 0
        card_metadata.jobName = job
        if Config.Inventory == 'ox_inventory' then
            exports.ox_inventory:AddItem(src, cardtype == 'citizen' and Config.FakeIdCard or Config.FakeJobCard, 1, card_metadata, nil, false)
        elseif Config.Inventory == 'qb-inventory' then
            exports['qb-inventory']:AddItem(src, cardtype == 'citizen' and Config.FakeIdCard or Config.FakeJobCard, 1, nil, card_metadata)
        elseif Config.Inventory == 'codem-inventory' then
            exports['codem-inventory']:AddItem(src, cardtype == 'citizen' and Config.FakeIdCard or Config.FakeJobCard, 1, nil, card_metadata)
        elseif Config.Inventory == 'quasar-inventory' then
            exports['qs-inventory']:AddItem(src, cardtype == 'citizen' and Config.FakeIdCard or Config.FakeJobCard, 1, nil, card_metadata)
        end
    else
        TriggerClientEvent("0r_idcard:client:notify", src, "You don't have enough money", "error")
    end
end)

RegisterNetEvent("0r_idcard:server:createCard", function(photo, type)
    local src = source
    local player = getExtendedPlayer(src)

    local player = getExtendedPlayer(source)
    local job = getPlayerJob(source)
    local jobName = job.name
    local jobGrade = job.grade
    local name = getPlayerName(player)
    local nationality = getPlayerNation(source)

    if type == 'job' then
        local playerData = {
            card_name = name.firstname,
            card_surname = name.lastname,
            jobName = jobName,
            card_birthdate = getBirthDate(player),
            license = getPlayerLicense(player),
            card_sex = getGender(player),
            card_photo = photo,
            nationality = nationality,
            card_type = jobName,
            jobGrade = jobGrade
        }
        if Config.Inventory == 'ox_inventory' then
            exports.ox_inventory:AddItem(src, Config.JobCard, 1, playerData, nil, false)
        elseif Config.Inventory == 'qb-inventory' then
            exports['qb-inventory']:AddItem(src, Config.JobCard, 1, nil, playerData)
        elseif Config.Inventory == 'quasar-inventory' then
            exports['qs-inventory']:AddItem(src, Config.JobCard, 1, nil, playerData)
        elseif Config.Inventory == 'codem-inventory' then
            exports['codem-inventory']:AddItem(src, Config.JobCard, 1, nil, playerData)
        end
    elseif type == 'citizen' then
        local playerData = {
            card_name = name.firstname,
            card_surname = name.lastname,
            jobName = jobName,
            jobGrade = jobGrade,
            card_birthdate = getBirthDate(player),
            license = getPlayerLicense(player),
            card_sex = getGender(player),
            card_photo = photo,
            nationality = nationality,
            card_type = 'citizen'
        }
        if Config.Inventory == 'ox_inventory' then
            exports.ox_inventory:AddItem(src, Config.IdCard, 1, playerData, nil, false)
        elseif Config.Inventory == 'qb-inventory' then
            exports['qb-inventory']:AddItem(src, Config.IdCard, 1, nil, playerData)
        elseif Config.Inventory == 'quasar-inventory' then
            exports['qs-inventory']:AddItem(src, Config.IdCard, 1, nil, playerData)
        elseif Config.Inventory == 'codem-inventory' then
            exports['codem-inventory']:AddItem(src, Config.IdCard, 1, nil, playerData)
        end
    elseif type == 'driver' then
        local playerData = {
            card_name = name.firstname,
            card_surname = name.lastname,
            jobName = jobName,
            jobGrade = jobGrade,
            card_birthdate = getBirthDate(player),
            license = getPlayerLicense(player),
            card_sex = getGender(player),
            card_photo = photo,
            nationality = nationality,
            card_type = 'driver'
        }
        if Config.Inventory == 'ox_inventory' then
            exports.ox_inventory:AddItem(src, Config.DriverLicense, 1, playerData, nil, false)
        elseif Config.Inventory == 'qb-inventory' then
            exports['qb-inventory']:AddItem(src, Config.DriverLicense, 1, nil, playerData)
        elseif Config.Inventory == 'quasar-inventory' then
            exports['qs-inventory']:AddItem(src, Config.DriverLicense, 1, nil, playerData)
        elseif Config.Inventory == 'codem-inventory' then
            exports['codem-inventory']:AddItem(src, Config.DriverLicense, 1, nil, playerData)
        end
    elseif type == 'weapon' then
        local playerData = {
            card_name = name.firstname,
            card_surname = name.lastname,
            jobName = jobName,
            jobGrade = jobGrade,
            card_birthdate = getBirthDate(player),
            license = getPlayerLicense(player),
            card_sex = getGender(player),
            card_photo = photo,
            nationality = nationality,
            card_type = 'weapon'
        }
        if Config.Inventory == 'ox_inventory' then
            exports.ox_inventory:AddItem(src, Config.WeaponLicense, 1, playerData, nil, false)
        elseif Config.Inventory == 'qb-inventory' then
            exports['qb-inventory']:AddItem(src, Config.WeaponLicense, 1, nil, playerData)
        elseif Config.Inventory == 'quasar-inventory' then
            exports['qs-inventory']:AddItem(src, Config.WeaponLicense, 1, nil, playerData)
        elseif Config.Inventory == 'codem-inventory' then
            exports['codem-inventory']:AddItem(src, Config.WeaponLicense, 1, nil, playerData)
        end
    end
end)


RegisterServerEvent('0r-idcard:fix-metadata', function(slot, photo, itemname)
    slot = tonumber(slot)
    if slot and slot > 0 then
        local src = source
        local player = getExtendedPlayer(src)

        local player = getExtendedPlayer(source)
        local job = getPlayerJob(source)
        local jobName = job.name
        local jobGrade = job.grade
        local name = getPlayerName(player)
        local nationality = getPlayerNation(source)
        removeitem(src, itemname, slot)
        if itemname == Config.JobCard then
            local playerData = {
                card_name = name.firstname,
                card_surname = name.lastname,
                jobName = jobName,
                card_birthdate = getBirthDate(player),
                license = getPlayerLicense(player),
                card_sex = getGender(player),
                card_photo = photo,
                nationality = nationality,
                card_type = jobName,
                jobGrade = jobGrade
            }
            if Config.Inventory == 'ox_inventory' then
                exports.ox_inventory:AddItem(src, Config.JobCard, 1, playerData, nil, false)
            elseif Config.Inventory == 'qb-inventory' then
                exports['qb-inventory']:AddItem(src, Config.JobCard, 1, nil, playerData)
            elseif Config.Inventory == 'quasar-inventory' then
                exports['qs-inventory']:AddItem(src, Config.JobCard, 1, nil, playerData)
            elseif Config.Inventory == 'codem-inventory' then
                exports['codem-inventory']:AddItem(src, Config.JobCard, 1, nil, playerData)
            end
        elseif itemname == Config.IdCard then
            local playerData = {
                card_name = name.firstname,
                card_surname = name.lastname,
                jobName = jobName,
                jobGrade = jobGrade,
                card_birthdate = getBirthDate(player),
                license = getPlayerLicense(player),
                card_sex = getGender(player),
                card_photo = photo,
                nationality = nationality,
                card_type = 'citizen'
            }
            if Config.Inventory == 'ox_inventory' then
                exports.ox_inventory:AddItem(src, Config.IdCard, 1, playerData, nil, false)
            elseif Config.Inventory == 'qb-inventory' then
                exports['qb-inventory']:AddItem(src, Config.IdCard, 1, nil, playerData)
            elseif Config.Inventory == 'quasar-inventory' then
                exports['qs-inventory']:AddItem(src, Config.IdCard, 1, nil, playerData)
            elseif Config.Inventory == 'codem-inventory' then
                exports['codem-inventory']:AddItem(src, Config.IdCard, 1, nil, playerData)
            end
        elseif itemname == Config.DriverLicense then
            local playerData = {
                card_name = name.firstname,
                card_surname = name.lastname,
                jobName = jobName,
                jobGrade = jobGrade,
                card_birthdate = getBirthDate(player),
                license = getPlayerLicense(player),
                card_sex = getGender(player),
                card_photo = photo,
                nationality = nationality,
                card_type = 'driver'
            }
            if Config.Inventory == 'ox_inventory' then
                exports.ox_inventory:AddItem(src, Config.DriverLicense, 1, playerData, nil, false)
            elseif Config.Inventory == 'qb-inventory' then
                exports['qb-inventory']:AddItem(src, Config.DriverLicense, 1, nil, playerData)
            elseif Config.Inventory == 'quasar-inventory' then
                exports['qs-inventory']:AddItem(src, Config.DriverLicense, 1, nil, playerData)
            elseif Config.Inventory == 'codem-inventory' then
                exports['codem-inventory']:AddItem(src, Config.DriverLicense, 1, nil, playerData)
            end
        elseif itemname == Config.WeaponLicense then
            local playerData = {
                card_name = name.firstname,
                card_surname = name.lastname,
                jobName = jobName,
                jobGrade = jobGrade,
                card_birthdate = getBirthDate(player),
                license = getPlayerLicense(player),
                card_sex = getGender(player),
                card_photo = photo,
                nationality = nationality,
                card_type = 'weapon'
            }
            if Config.Inventory == 'ox_inventory' then
                exports.ox_inventory:AddItem(src, Config.WeaponLicense, 1, playerData, nil, false)
            elseif Config.Inventory == 'qb-inventory' then
                exports['qb-inventory']:AddItem(src, Config.WeaponLicense, 1, nil, playerData)
            elseif Config.Inventory == 'quasar-inventory' then
                exports['qs-inventory']:AddItem(src, Config.WeaponLicense, 1, nil, playerData)
            elseif Config.Inventory == 'codem-inventory' then
                exports['codem-inventory']:AddItem(src, Config.WeaponLicense, 1, nil, playerData)
            end
        end
    else
        print('[0R-IDCARD] There is a error on fixing metadata please report this on ticket.')
    end
end)

function removeitem(src, name, slot)
    if Config.Inventory == 'ox_inventory' then
        exports.ox_inventory:RemoveItem(src, name, 1, nil, slot)
    elseif Config.Inventory == 'qb-inventory' then
        exports['qb-inventory']:RemoveItem(src, name, 1, slot)
    elseif Config.Inventory == 'quasar-inventory' then
        exports['qs-inventory']:RemoveItem(src, name, 1, slot)
    elseif Config.Inventory == 'codem-inventory' then
        exports['codem-inventory']:RemoveItem(src, name, 1, slot)
    end
end