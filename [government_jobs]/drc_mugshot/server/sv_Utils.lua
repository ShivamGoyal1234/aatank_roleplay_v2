lib.locale()

local function AutoDetectFramework()
    if GetResourceState("es_extended") == "started" then
        return "ESX"
    elseif GetResourceState("qb-core") == "started" then
        return "qbcore"
    else
        return "standalone"
    end
end

if Config.Framework == "auto-detect" then
    Config.Framework = AutoDetectFramework()
end

if Config.Framework == "ESX" then
    if Config.NewESX then
        ESX = exports["es_extended"]:getSharedObject()
    else
        ESX = nil
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
elseif Config.Framework == "qbcore" then
    QBCore = nil
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == "standalone" then
    -- ADD YOU FRAMEWORK
end

Logs = {
    ["DefaultMissionRow"] = { -- MUGSHOT NAME | NEEDS TO BE SAME LIKE IN SH_CONFIG.lua (example: police)
        UserName = "MUGSHOT - LSPD", -- UserName for discord Webhook
        Title = "MUGSHOT", -- Title for embed
        Avatar = "https://prod.cloud.rockstargames.com/crews/sc/0291/19566919/publish/emblem/emblem_512.png", -- Avatar for Discord Webhook
        Color = 1977945, -- Color of embed
        Webhook = "https://discord.com/api/webhooks/1366760428256100395/TLn5h9t90kY-lfoS8ZjVXsHHisl225GDKL2eA7VxtGhi5ikEUKG6Qyh_OkLNBlNJYOYy" -- Webhook for example: police
    },
    ["DefaultMissionRow1"] = { -- MUGSHOT NAME | NEEDS TO BE SAME LIKE IN SH_CONFIG.lua (example: police)
        UserName = "MUGSHOT - LSPD", -- UserName for discord Webhook
        Title = "MUGSHOT", -- Title for embed
        Avatar = "https://prod.cloud.rockstargames.com/crews/sc/0291/19566919/publish/emblem/emblem_512.png", -- Avatar for Discord Webhook
        Color = 1977945, -- Color of embed
        Webhook = "https://discord.com/api/webhooks/1366760428256100395/TLn5h9t90kY-lfoS8ZjVXsHHisl225GDKL2eA7VxtGhi5ikEUKG6Qyh_OkLNBlNJYOYy" -- Webhook for example: sheriff
    }, 
}

EvidenceLogs = {
    ["DefaultMissionRow"] = { -- EVIDENCE NAME | NEEDS TO BE SAME LIKE IN SH_CONFIG.lua (example: police)
        UserName = "MUGSHOT - EVIDENCE", -- UserName for discord Webhook
        Title = "MUGSHOT", -- Title for embed
        Avatar = "https://prod.cloud.rockstargames.com/crews/sc/0291/19566919/publish/emblem/emblem_512.png", -- Avatar for Discord Webhook
        Color = 1977945, -- Color of embed
        Webhook = "https://discord.com/api/webhooks/1401133323157242021/p2dROBhaAbOrbr5fqtgbJj59Xev000b5HxtLKmg9s7XURuVxdDUAcnP2V5KNzz4djezB" -- Webhook for example: police
    },
     ["DefaultMissionRow1"] = { -- EVIDENCE NAME | NEEDS TO BE SAME LIKE IN SH_CONFIG.lua (example: police)
        UserName = "MUGSHOT - EVIDENCE", -- UserName for discord Webhook
        Title = "MUGSHOT", -- Title for embed
        Avatar = "https://prod.cloud.rockstargames.com/crews/sc/0291/19566919/publish/emblem/emblem_512.png", -- Avatar for Discord Webhook
        Color = 1977945, -- Color of embed
        Webhook = "https://discord.com/api/webhooks/1401133323157242021/p2dROBhaAbOrbr5fqtgbJj59Xev000b5HxtLKmg9s7XURuVxdDUAcnP2V5KNzz4djezB" -- Webhook for example: police
    }, 
}

ImageStorage = 'https://discord.com/api/webhooks/1401838104473632860/a7zKn4zH89SIUKu5E9zhmeQIhZDdtbpKCna8PPbMwbmHBr4Azfs7lQdV0zjJ4VS70rKm' -- Webhook to send images to store them.

RegisterNetEvent('drc_mugshot:log', function(image, officer, name, dob, mugshot, desc)

    local Jobs = Config.Mugshot[mugshot].Jobs

    local names = ""

    for i, job in ipairs(Jobs) do
        names = names .. job.name
        if i < #Jobs then
            names = names .. ", "
        end
    end

    local id = MySQL.insert.await("INSERT INTO mugshot_evidence (suspect, dob, image, officer, time, jobs, description)   VALUES (?, ?, ?, ?, ?, ?, ?)", {
            name, dob, image, GetName(officer), os.date('%H:%M:%S - %d. %m. %Y', os.time()), names, tostring(desc)
    })

    local connect = {
        {
            ["color"] = Logs[mugshot].Color,
            ["title"] = Logs[mugshot].Title,
            ["image"] = {
                ["url"] = image
            },

            ["description"] =
            "Suspect: **" .. name ..
                "\n **DOB: **" .. dob ..
                "\n **MugShot ID: **" .. id ..
                "\n **Description: **" .. tostring(desc) ..
                "\n **Photo by officer: **" .. GetName(officer) .. "**",
            ["footer"] = {
                ["text"] = "Time: " .. os.date('%H:%M:%S - %d. %m. %Y', os.time()),
                ["icon_url"] = Logs[mugshot].Avatar,
            },
        }
    }
    PerformHttpRequest(Logs[mugshot].Webhook, function(err, text, headers) end, 'POST',
        json.encode({ username = Logs[mugshot].UserName, embeds = connect,
            avatar_url = Logs[mugshot].Avatar }), { ['Content-Type'] = 'application/json' })
end)

lib.callback.register('drc_mugshot:GetEvidence', function(source, locker, search, search2, search3)
    local match_found = false
    local evidence = {}
    local result = {}
    Jobs = Config.MugshotEvidence[locker].Jobs
    if search or search2 or search3 then
        local conditions = {}
        local values = {}

        if search then
            table.insert(conditions, 'suspect = ?')
            table.insert(values, search)
        end

        if search2 then
            table.insert(conditions, 'id = ?')
            table.insert(values, search2)
        end

        if search3 then
            table.insert(conditions, 'dob = ?')
            table.insert(values, search3)
        end

        local condition_str = table.concat(conditions, ' OR ')
        local query = 'SELECT * FROM mugshot_evidence WHERE ' .. condition_str
        result = MySQL.query.await(query, values)
    else
        result = MySQL.query.await('SELECT * FROM mugshot_evidence', {})
    end
    if result then
        for i = 1, #result do
            local row = result[i]
            local jobs = {}
            for job in row.jobs:gmatch("[^,%s]+") do
                table.insert(jobs, job)
            end
            for _, job in ipairs(jobs) do
                for _, jobConfig in ipairs(Jobs) do
                    if job == jobConfig.name then
                        match_found = true
                        if not table.contains(evidence, row.id, 'id') then
                            table.insert(evidence, {
                                id = row.id,
                                suspect = row.suspect,
                                dob = row.dob,
                                image = row.image,
                                officer = row.officer,
                                time = row.time,
                                desc = row.description,
                            })
                        end
                    end
                end
            end
            
        end
        if match_found then
            return evidence
        end
    end
end)

lib.callback.register('drc_mugshot:GetAutomaticData', function(source, suspect)
    local src = suspect
    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(src)
        local data = { name = xPlayer.variables.firstName .. ' ' .. xPlayer.variables.lastName, dob  = xPlayer.variables.dateofbirth }
        return data
    elseif Config.Framework == "qbcore" then
        local xPlayer = QBCore.Functions.GetPlayer(src)
         local data = { name = xPlayer.PlayerData.charinfo.firstname .. ' ' .. xPlayer.PlayerData.charinfo.lastname, dob = xPlayer.PlayerData.charinfo.birthdate }
         return data
    elseif Config.Framework == "standalone" then
        -- ADD YOU FRAMEWORK
    end

end)


function GetName(source)
    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.getName()
    elseif Config.Framework == "qbcore" then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        return xPlayer.PlayerData.charinfo.firstname .. ' ' .. xPlayer.PlayerData.charinfo.lastname
    elseif Config.Framework == "standalone" then
        -- ADD YOU FRAMEWORK
    end
end

function GetJob(source)
    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.job.name
    elseif Config.Framework == "qbcore" then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        return xPlayer.PlayerData.job.name
    elseif Config.Framework == "standalone" then
        -- ADD YOU FRAMEWORK
    end
end

local ver = '1.1.0'

CreateThread(function()
    if GetResourceState(GetCurrentResourceName()) == 'started' then
        print('DRC_MUGSHOT STARTED ON VERSION: ' .. ver)
    end
end)

function table.contains(table, element, field)
    for _, value in pairs(table) do
        if value[field] == element then
            return true
        end
    end
    return false
end

RegisterNetEvent('drc_mugshot:removeevidence', function(data)
    local src = source
    if CheckJob(src, data.locker) then
        local result = MySQL.query.await('SELECT * FROM mugshot_evidence WHERE id = ?', {data.id})
        if result then
            for i = 1, #result do
                local row = result[i]
                FirstValue = row.suspect

                local connect = {
                    {
                        ["color"] = EvidenceLogs[data.locker].Color,
                        ["title"] = EvidenceLogs[data.locker].Title,
                        ["image"] = {
                            ["url"] = row.image
                        },

                        ["description"] =
                        "**THIS MUGSHOT WAS DELETE BY: " .. GetName(src) .."**"..
                        "\nSuspect: **" .. row.suspect ..
                            "\n **DOB: **" .. row.dob ..
                            "\n **MugShot ID: **" .. row.id ..
                            "\n **Photo by officer: **" .. row.officer .. "**",
                        ["footer"] = {
                            ["text"] = "Time of deletion: " .. os.date('%H:%M:%S - %d. %m. %Y', os.time()),
                            ["icon_url"] = EvidenceLogs[data.locker].Avatar,
                        },
                    }
                }
                PerformHttpRequest(EvidenceLogs[data.locker].Webhook, function(err, text, headers) end, 'POST',
                    json.encode({ username = EvidenceLogs[data.locker].UserName, embeds = connect,
                        avatar_url = EvidenceLogs[data.locker].Avatar }), { ['Content-Type'] = 'application/json' })
                MySQL.update('DELETE FROM mugshot_evidence WHERE id = ?', {data.id})
                TriggerClientEvent('drc_mugshot:notify', src, "info", locale("info"), locale("MugshotDeleted"))
            end
        end
    else
        TriggerClientEvent('drc_mugshot:notify', src, "error", locale("error"), locale("RequiredJob"))
    end
end)

RegisterNetEvent('drc_mugshot:change', function(id, type, change, locker)
    local src = source
    if CheckJob(src, locker) then
        if type == "name" then
            local result = MySQL.query.await('SELECT * FROM mugshot_evidence WHERE id = ?', {id})
            if result then
                for i = 1, #result do
                    local row = result[i]
                    FirstValue = row.suspect
                end
            end
            MySQL.update('UPDATE mugshot_evidence SET suspect = ? WHERE id = ?', {change, id}, function(affectedRows)

            end)
        elseif type == "dob" then
            local result = MySQL.query.await('SELECT * FROM mugshot_evidence WHERE id = ?', {id})
            if result then
                for i = 1, #result do
                    local row = result[i]
                    FirstValue = row.dob
                end
            end
            MySQL.update('UPDATE mugshot_evidence SET dob = ? WHERE id = ?', {change, id}, function(affectedRows)

            end)
        elseif type == "desc" then
            local result = MySQL.query.await('SELECT * FROM mugshot_evidence WHERE id = ?', {id})
            if result then
                for i = 1, #result do
                    local row = result[i]
                    FirstValue = row.description
                end
            end
            MySQL.update('UPDATE mugshot_evidence SET description = ? WHERE id = ?', {change, id}, function(affectedRows)

            end)
        end

        local connect = {
            {
                ["color"] = EvidenceLogs[locker].Color,
                ["title"] = EvidenceLogs[locker].Title,
                ["description"] =
                "**Change: ** from " .. FirstValue .. " to " .. change .."" ..
                    "\n **MugShot ID: **" .. id ..
                    "\n **Edited by officer: **" .. GetName(src),
                ["footer"] = {
                    ["text"] = "Time: " .. os.date('%H:%M:%S - %d. %m. %Y', os.time()),
                    ["icon_url"] = EvidenceLogs[locker].Avatar,
                },
            }
        }
        PerformHttpRequest(EvidenceLogs[locker].Webhook, function(err, text, headers) end, 'POST',
            json.encode({ username = EvidenceLogs[locker].UserName, embeds = connect,
                avatar_url = EvidenceLogs[locker].Avatar }), { ['Content-Type'] = 'application/json' })
        TriggerClientEvent('drc_mugshot:notify', src, "info", locale("info"), locale("MugshotChanged"))
    else
        TriggerClientEvent('drc_mugshot:notify', src, "error", locale("error"), locale("RequiredJob"))
    end
end)

RegisterNetEvent('drc_mugshot:upload', function(mugshot_photo)
    local src = source
    local char_id = GetIdent(src)
    local result = MySQL.Sync.fetchAll('SELECT * FROM `users` WHERE `id` = @id', {
        ['@id'] = char_id
    })
    local offender = result[1]

    if not offender then
        TriggerClientEvent('drc_mugshot:notify', src, "error", locale("error"), "This person no longer exists.")
        return
    end

    -- Upload mugshot photo
    if mugshot_photo then
        MySQL.Async.execute('UPDATE `user_mdt` SET `mugshot_url` = @mugshot_photo WHERE `char_id` = @id', {
            ['@mugshot_photo'] = mugshot_photo,
            ['@id'] = offender.id
        })
    end
end)

function GetIdent(source)
    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.getIdentifier()
    elseif Config.Framework == "qbcore" then
        return QBCore.Functions.GetIdentifier(source, 'license')

    end
end

function CheckJob(source, locker)
    locker = Config.MugshotEvidence[locker]
    if locker.JobResitrected then
        for k,v in pairs(locker.EditJobs) do 
            if v.name then
                if Config.Framework == "ESX" then
                    local xPlayer = ESX.GetPlayerFromId(source)
                    if v.name == xPlayer.job.name then
                        if v.grade then
                            if v.grade <= xPlayer.job.grade then
                                return true
                            end
                        else
                            return true
                        end
                    end
                elseif Config.Framework == "qbcore" then
                    local xPlayer = QBCore.Functions.GetPlayer(source)
                    if v.name == xPlayer.PlayerData.job.name or v.name ==
                        xPlayer.PlayerData.gang.name then
                        if v.grade then
                            if v.grade <=xPlayer.PlayerData.job.grade.level or
                                v.grade <= xPlayer.PlayerData.gang.grade.level then
                                return true
                            end
                        else
                            return true
                        end
                    end
                end
            else
                return true
            end
        end
    else
        return true
    end
end