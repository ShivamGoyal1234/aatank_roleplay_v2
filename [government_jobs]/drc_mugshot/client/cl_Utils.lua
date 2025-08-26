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

local function AutoDetectTarget()
    if GetResourceState("qtarget") == "started" then
        return "qtarget"
    elseif GetResourceState("qb-target") == "started" then
        return "qb-target"
    elseif GetResourceState("ox_target") == "started" then
        return "ox_target"
    end
end

if Config.Framework == "auto-detect" then
    Config.Framework = AutoDetectFramework()
end

if Config.Target == "auto-detect" then
    Config.Target = AutoDetectTarget()
end

if Config.Framework == "ESX" then
    if Config.NewESX then
        ESX = exports["es_extended"]:getSharedObject()
    else
        ESX = nil
        CreateThread(function()
            while ESX == nil do
                TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
                Wait(100)
            end
        end)
    end
elseif Config.Framework == "qbcore" then
    QBCore = nil
    QBCore = exports["qb-core"]:GetCoreObject()
elseif Config.Framework == "standalone" then
    -- ADD YOU FRAMEWORK
end


RegisterNetEvent('drc_mugshot:notify')
AddEventHandler('drc_mugshot:notify', function(type, title, text)
    Notify(type, title, text)
end)


-- Your notification type settings
-- •» You can edit a type of notifications, with chaning type or triggering your own.
Notify = function(type, title, text)
    if Config.NotificationType == "ESX" then
        ESX.ShowNotification(text)
    elseif Config.NotificationType == "ox_lib" then
        if type == "info" then
            lib.notify({
                title = title,
                description = text,
                type = "inform"
            })
        elseif type == "error" then
            lib.notify({
                title = title,
                description = text,
                type = "error"
            })
        elseif type == "success" then
            lib.notify({
                title = title,
                description = text,
                type = "success"
            })
        end
    elseif Config.NotificationType == "qbcore" then
        if type == "success" then
            QBCore.Functions.Notify(text, "success", 5000)
        elseif type == "info" then
            QBCore.Functions.Notify(text, "primary", 5000)
        elseif type == "error" then
            QBCore.Functions.Notify(text, "error", 5000)
        end
    elseif Config.NotificationType == "custom" then
        print("add your notification system! in cl_Utils.lua")
        -- ADD YOUR NOTIFICATION | TYPES ARE info, error, success
    end
end

ProgressBar = function(duration, label)
    if Config.Progress == "ox_lib" then
        lib.progressBar({
            duration = duration,
            label = label,
            useWhileDead = false,
            canCancel = false
        })
    elseif Config.Progress == "qbcore" then
        QBCore.Functions.Progressbar(label, label, duration, false, true, {
        }, {}, {}, {}, function()
        end)
        Wait(duration)
    elseif Config.Progress == "progressBars" then
        exports['progressBars']:startUI(duration, label)
        Wait(duration)
    end
end


SetTimeout(1000, function()
    target = Target()
    for k, v in pairs(Config.Mugshot) do
        if v.type == "Target" then
            CircleZone(target, k, v)
        elseif v.type == "Marker" then
            Marker(k, v)
        end
    end
end)

SetTimeout(1000, function()
    target = Target()
    for k, v in pairs(Config.MugshotEvidence) do
        if v.type == "Target" then
        target:RemoveZone("MugShotEvidence" .. k)
        target:AddCircleZone("MugShotEvidence" .. k, v.coords, v.radius,
            { name = "MugShotEvidence" .. k, debugPoly = v.debug, useZ = true },
            { options = {
                { event = "drc_mugshot:evidencelocker", icon = v.TargetIcon, label = v.Label,
                    locker = k,
                    canInteract = function()
                        if CheckJob(Config.MugshotEvidence[k]) then
                            return true
                        end
                        return false
                    end
                },
                { event = "drc_mugshot:search", icon = v.TargetIcon, label = locale("Search"),
                    locker = k,
                    canInteract = function()
                        if CheckJob(Config.MugshotEvidence[k]) then
                            return true
                        end
                        return false
                    end
                },
            },
                distance = 3.5
            }
        )
        elseif v.type == "Marker" then
            lib.zones.sphere({
                coords = v.coords,
                radius = v.Marker.DrawDistance,
                debug = Config.Debug,
                inside = function(self)
                    DrawMarker(v.Marker.Type, self.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Marker.Size.x,
                        v.Marker.Size.y, v.Marker.Size.z, v.Marker.Color.r, v.Marker.Color.g, v.Marker.Color.b,
                        v.Marker.Color.a, false, true, 2, false, false, false, false)
                        if IsControlJustReleased(0, 74) then
                            if CheckJob(Config.MugshotEvidence[k]) then
                                TriggerEvent('drc_mugshot:search', { locker = k })
                                lib.hideTextUI()
                            end
                        end
                    if (IsControlJustReleased(1, 51)) then --Control E
                        if CheckJob(Config.MugshotEvidence[k]) then
                            TriggerEvent("drc_mugshot:evidencelocker", { locker = k })
                            lib.hideTextUI()
                        else
                            Notify("error", locale("error"), locale("RequiredJob"))
                        end
                    end

                    if Config.MarkerOption == "3dtext" then
                        Draw3DText(self.coords, '[~g~E~w~] - ' .. v.Label ..  "     \n [~g~H~w~] - " .. locale("Search"))
                    end
                end,
                onEnter = function()
                    if Config.MarkerOption == "textui" then
                        TextUIShow('[E] - ' .. v.Label ..  "    \n[~g~H~w~] - " .. locale("Search"))
                    end
                end,
                onExit = function()
                    if Config.MarkerOption == "textui" then
                        TextUIHide()
                    end
                end
            })
        end
    end
end)

Target = function()
    if Config.Target == "qtarget" then
        return exports['qtarget']
    end
    if Config.Target == "qb-target" then
        return exports['qb-target']
    end
    if Config.Target == "ox_target" then
        return exports['qtarget']
    end
end

Marker = function(k, v)
    lib.zones.sphere({
        coords = v.OfficerPosition.coords,
        radius = v.Marker.DrawDistance,
        debug = Config.Debug,
        inside = function(self)
            DrawMarker(v.Marker.Type, self.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Marker.Size.x,
                v.Marker.Size.y, v.Marker.Size.z, v.Marker.Color.r, v.Marker.Color.g, v.Marker.Color.b,
                v.Marker.Color.a, false, true, 2, false, false, false, false)
            if (IsControlJustReleased(1, 51)) then --Control E
                if CheckJob(Config.Mugshot[k]) then
                    TriggerEvent("drc_mugshot:photo", { mugshot = k })
                    lib.hideTextUI()
                else
                    Notify("error", locale("error"), locale("RequiredJob"))
                end
            end

            if Config.MarkerOption == "3dtext" then
               Draw3DText(self.coords, '[~g~E~w~] - ' .. v.Label)
           end
        end,
        onEnter = function()
            if Config.MarkerOption == "textui" then
                TextUIShow('[E] - ' .. v.Label)
            end
        end,
        onExit = function()
            if Config.MarkerOption == "textui" then
                TextUIHide()
            end
        end
    })
end

function PassPhotoToLog(webhook, officer, name, dob, mugshot, id)
    if Config.Fivemanage then
        local imageData = exports.fmsdk:takeImage()
        TriggerServerEvent('drc_mugshot:log', imageData.url, officer, name, dob, mugshot, id) 
        uploadMDT(imageData.url)
    else
        exports[Config.ScreenshotbasicResource]:requestScreenshotUpload(webhook, 'files[]', { encoding = 'jpg' }, function(data)
            local resp = json.decode(data)
            TriggerServerEvent('drc_mugshot:log', resp.attachments[1].url, officer, name, dob, mugshot, id) 
            uploadMDT(resp.attachments[1].url)
        end)
    end
end

uploadMDT = function(photo)
    if Config.PS_MDT then
        local MugshotArray = {}

        local citizenid = QBCore.Functions.GetPlayerData().citizenid
        table.insert(MugshotArray, photo)
        TriggerServerEvent('psmdt-mugshot:server:MDTupload', citizenid, MugshotArray)

        MugshotArray = nil
    elseif Config.HYPASTE_MDT or Config.REDUTZU_MDT then
        TriggerServerEvent('drc_mugshot:upload', photo)
    end
end


CircleZone = function(target, k, v)
    target:RemoveZone("MugShot" .. k)
    target:AddCircleZone("MugShot" .. k, v.OfficerPosition.coords, v.OfficerPosition.radius,
        { name = "MugShot" .. k, debugPoly = v.OfficerPosition.debug, useZ = true },
        { options = {
            { event = "drc_mugshot:photo", icon = v.TargetIcon, label = v.Label,
                mugshot = k,
                canInteract = function()
                    if CheckJob(Config.Mugshot[k]) then
                        return true
                    end
                    return false
                end
            },
        },
            distance = 3.5
        }
    )
end

function CheckJob(MugShot)
    if MugShot.JobResitrected then
        for k,v in pairs(MugShot.Jobs) do 
            if v.name then
                if Config.Framework == "ESX" then
                    if v.name == ESX.GetPlayerData().job.name then
                        if v.grade then
                            if v.grade <= ESX.GetPlayerData().job.grade then
                                return true
                            end
                        else
                            return true
                        end
                    end
                elseif Config.Framework == "qbcore" then
                    if v.name == QBCore.Functions.GetPlayerData().job.name or v.name ==
                        QBCore.Functions.GetPlayerData().gang.name then
                        if v.grade then
                            if v.grade <= QBCore.Functions.GetPlayerData().job.grade.level or
                                v.grade <= QBCore.Functions.GetPlayerData().gang.grade.level then
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

function ScaleFormBoard(name, dob, mugshot, id)
    main = Config.Mugshot[mugshot].State
    middle = name
    bottom = dob
    top = Config.Mugshot[mugshot].Shortcut
    CallScaleformMethod(board_scaleform, 'SET_BOARD', main, middle, bottom, top, 0, "", 116)
end

RegisterNetEvent("drc_mugshot:photo", function(data)
    if Config.AutomaticNames then
        if Config.Input == "qb-input" then
            local dialog = exports['qb-input']:ShowInput({
                header = "Mugshot - Suspect Info",
                submitText = "Submit",
                inputs = {
                    {
                        text = "Mugshot Description",
                        name = "desc",
                        type = "text",
                        isRequired = true,
                    }

                }
            })
            if dialog then
                if dialog["desc"] then
                    StartMugshotAutomatic(data.mugshot, dialog["desc"])
                end
            end
        elseif Config.Input == "ox_lib" then
            local input = lib.inputDialog('Mugshot - Suspect Info', {
                { type = "input", label = "Mugshot Description", placeholder = "Gender: Male..." },
            })
            if input then
                if input[1] then
                    StartMugshotAutomatic(data.mugshot, input[1])
                end
            end
        end
    else
        if Config.Input == "qb-input" then
            local dialog = exports['qb-input']:ShowInput({
                header = "Mugshot - Suspect Info",
                submitText = "Submit",
                inputs = {
                    {
                        text = "Full Name",
                        name = "name",
                        type = "text",
                        isRequired = true,
                    },
                    {
                        text = "Date Of Birth",
                        name = "dob",
                        type = "text",
                        isRequired = true,
                    },
                    {
                        text = "Mugshot Description",
                        name = "desc",
                        type = "text",
                        isRequired = true,
                    }

                }
            })
            if dialog then
                if dialog["dob"] and dialog["name"] and dialog["desc"] then
                    StartMugshot(dialog["dob"], dialog["name"], dialog["desc"], data.mugshot)
                end
            end

        elseif Config.Input == "ox_lib" then
            local input = lib.inputDialog('Mugshot - Suspect Info', {
                { type = "input", label = "Full Name", placeholder = "Firstname Surname" },
                { type = "input", label = "Date Of Birth", placeholder = "MM/DD/YYYY" },
                { type = "input", label = "Mugshot Description", placeholder = "Gender: Male..." },
            })
            if input then
                if (input[1] == nil or input[1] == "") and (input[2] == nil or input[2] == "") and (input[3] == nil or input[3] == "") then
                    Notify("error", locale("error"), locale("MugshotFill"))
                    return
                else
                    StartMugshot(input[1], input[2], input[3], data.mugshot)
                end
            end
        end
    end
end)

TextUIShow = function(text)
    if Config.TextUI == "ox_lib" then
        lib.showTextUI(text)
    elseif Config.TextUI == "esx" then
        exports["esx_textui"]:TextUI(text)
    elseif Config.TextUI == "luke" then
        TriggerEvent('luke_textui:ShowUI', text)
    elseif Config.TextUI == "qb-core" then
        exports['qb-core']:DrawText(text)
    elseif Config.TextUI == "custom" then
        print("add your textui system! in cl_Utils.lua")
        -- ADD YOUR TEXTUI | TO SHOW
    end
end

IsTextUIShowed = function()
    if Config.TextUI == "ox_lib" then
        return lib.isTextUIOpen()
    elseif Config.TextUI == "esx" then
        --exports["esx_textui"]:TextUI(text)
    elseif Config.TextUI == "luke" then
        --TriggerEvent('luke_textui:ShowUI', text)
    elseif Config.TextUI == "custom" then
        print("add your textui system! in cl_Utils.lua")
        -- ADD YOUR TEXTUI | TO SHOW
    end
end

TextUIHide = function()
    if Config.TextUI == "ox_lib" then
        lib.hideTextUI()
    elseif Config.TextUI == "esx" then
        exports["esx_textui"]:HideUI()
    elseif Config.TextUI == "luke" then
        TriggerEvent('luke_textui:HideUI')
    elseif Config.TextUI == "qb-core" then
        exports['qb-core']:HideText()
    elseif Config.TextUI == "custom" then
        print("add your textui system! in cl_Utils.lua")
        -- ADD YOUR TEXTUI | TO HIDE
    end
end

Draw3DText = function(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    
    if onScreen then
        SetTextFont(Config.FontId)
        SetTextScale(0.33, 0.30)
        SetTextDropshadow(10, 100, 100, 100, 255)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 350
        DrawRect(_x,_y+0.0135, 0.025+ factor, 0.03, 0, 0, 0, 10)
    end
end


RegisterNetEvent('drc_mugshot:evidencelocker', function(data)
    lib.callback('drc_mugshot:GetEvidence', false, function(data2)
        if data2 then
            options = {}
            for k, v in pairs(data2) do
                options["ID: " ..tostring(v.id) .. " - " .. tostring(v.suspect)] = {
                    arrow = true,
                    
                    metadata = {
                        {label = 'ID', value = v.id},
                        {label = 'NAME', value = v.suspect},
                        {label = 'DOB', value = v.dob},
                        {label = 'OFFICER', value = v.officer},
                        {label = 'DESCRIPTION', value = (v.desc == nil or v.desc == "") and "none" or v.desc},
                        {label = 'TIME', value = v.time}
                    },
                    image = v.image,
                    icon = "box-archive",
                    event = 'drc_mugshot:submenu',
                    args = { id = v.id, locker = data.locker }
                }
            end
            lib.registerContext({
                id = 'EvidenceMenu',
                title = locale("Evidence"),
                options = options
            })
            lib.showContext('EvidenceMenu')
        else
            Notify("error", locale("error"), locale("EvidenceEmpty"))
        end
    end, data.locker)
end)

RegisterNetEvent('drc_mugshot:submenu', function(data)
  lib.registerContext({
    id = 'mugshot_submenu',
    title = locale("Evidence") .. " ID: " ..data.id,
    menu = 'EvidenceMenu',
    options = {
    {
        title = locale("DeleteEvidence"),
        serverEvent = 'drc_mugshot:removeevidence',
        args = {
            id = data.id,
            locker = data.locker
        }
    },
    {
        title = locale('ChangeName'),
        event = 'drc_mugshot:change',
        args = {
            id = data.id,
            type = "name",
            locker = data.locker
        }
    },
    {
        title = locale('ChangeDOB'),
        event = 'drc_mugshot:change',
        args = {
            id = data.id,
            type = "dob",
            locker = data.locker
        }
    },
    {
        title = locale('ChangeDescription'),
        event = 'drc_mugshot:change',
        args = {
            id = data.id,
            type = "desc",
            locker = data.locker
        }
    },
    }
  })

  lib.showContext('mugshot_submenu')
end)

RegisterNetEvent('drc_mugshot:change', function(data)
    if Config.Input == "qb-input" then
        local dialog = exports['qb-input']:ShowInput({
            header = locale("ChangeInfo"),
            submitText = "Submit",
            inputs = {
                {
                    text = locale("Change"),
                    name = "change",
                    type = "text",
                    isRequired = true,
                }

            }
        })
        if dialog then
            if dialog["change"] then
                TriggerServerEvent('drc_mugshot:change', data.id, data.type, dialog["change"], data.locker)
            end
        end
    elseif Config.Input == "ox_lib" then
        local input = lib.inputDialog(locale("ChangeInfo"), {
            { type = "input", label = locale("Change"), placeholder = locale("YourChange") },
        })
        if input then
            if input[1] then
                TriggerServerEvent('drc_mugshot:change', data.id, data.type, input[1], data.locker)
            end
        end
    end
end)

RegisterNetEvent('drc_mugshot:search', function(data)
    if Config.Input == "qb-input" then
        local dialog = exports['qb-input']:ShowInput({
            header = locale("SearchInfo"),
            submitText = "Submit",
            inputs = {
                {
                    text = "NAME",
                    name = "search",
                    type = "text",
                    isRequired = true,
                },
                {
                    text = "ID",
                    name = "search2",
                    type = "text",
                    isRequired = true,
                },
                {
                    text = "DOB",
                    name = "search3",
                    type = "text",
                    isRequired = true,
                },

            }
        })
        if dialog then
            if dialog["search"] or dialog["search2"] or dialog["search3"] then
                    lib.callback('drc_mugshot:GetEvidence', false, function(data2)
                    options = {}
                    if data2 then
                        for k, v in pairs(data2) do
                            options["ID: " ..tostring(v.id) .. " - " .. tostring(v.suspect)] = {
                                arrow = true,
                                
                                metadata = {
                                    {label = 'ID', value = v.id},
                                    {label = 'NAME', value = v.suspect},
                                    {label = 'DOB', value = v.dob},
                                    {label = 'OFFICER', value = v.officer},
                                    {label = 'DESCRIPTION', value = (v.desc == nil or v.desc == "") and "none" or v.desc},
                                    {label = 'TIME', value = v.time}
                                },
                                image = v.image,
                                icon = "box-archive",
                                event = 'drc_mugshot:submenu',
                                args = { id = v.id }
                            }
                        end
                        lib.registerContext({
                            id = 'EvidenceMenu',
                            title = locale("Evidence"),
                            options = options
                        })
                    lib.showContext('EvidenceMenu')
                    else
                        Notify("error", locale("error"), locale("EvidenceEmpty"))
                    end
                end, data.locker, dialog["search"], dialog["search2"], dialog["search3"])
            end
        end
    elseif Config.Input == "ox_lib" then
        local input = lib.inputDialog(locale("SearchInfo"), {
            { type = "input", label = locale("Search"), placeholder = "Name" },
            { type = "input", label = locale("Search"), placeholder = "ID" },
            { type = "input", label = locale("Search"), placeholder = "DOB" },
        })
        if input then
            if input[1] or input[2] or input[3] then
                    lib.callback('drc_mugshot:GetEvidence', false, function(data2)
                    options = {}
                        if data2 then
                            for k, v in pairs(data2) do
                                options["ID: " ..tostring(v.id) .. " - " .. tostring(v.suspect)] = {
                                    arrow = true,
                                    metadata = {
                                        {label = 'ID', value = v.id},
                                        {label = 'NAME', value = v.suspect},
                                        {label = 'DOB', value = v.dob},
                                        {label = 'OFFICER', value = v.officer},
                                        {label = 'DESCRIPTION', value = (v.desc == nil or v.desc == "") and "none" or v.desc},
                                        {label = 'TIME', value = v.time}
                                    },
                                    image = v.image,
                                    icon = "box-archive",
                                    event = 'drc_mugshot:submenu',
                                    args = { id = v.id }
                                }
                            end
                            lib.registerContext({
                                id = 'EvidenceMenu',
                                title = locale("Evidence"),
                                options = options
                            })
                            lib.showContext('EvidenceMenu')
                        else
                            Notify("error", locale("error"), locale("EvidenceEmpty"))
                        end
                end, data.locker, input[1], input[2], input[3])
            end
        end
    end
end)