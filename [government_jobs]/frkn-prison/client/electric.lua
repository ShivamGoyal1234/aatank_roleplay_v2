local panelResultHandled = false
local allPanelsReported = false
electricFinished = false

function initTargetElectricPanels()
    for i, loc in ipairs(FRKN.General.panelLocations) do
        local zoneName = "prison_panel_" .. i

        if FRKN.General.targetSystem == "qb-target" then
            exports['qb-target']:AddBoxZone(zoneName, vector3(loc.x, loc.y, loc.z), 1.5, 1.5, {
                name = zoneName,
                heading = loc.w,
                debugPoly = false,
                minZ = loc.z - 1,
                maxZ = loc.z + 1
            }, {
                options = {
                    {
                        icon = "fas fa-bolt",
                        label = Lang:t("general.cut_electric_panel"),
                        action = function()
                            onCutPanel(i, loc)
                        end
                    }
                },
                distance = 2.0
            })

        elseif FRKN.General.targetSystem == "ox_target" then
            exports.ox_target:addBoxZone({
                coords = vec3(loc.x, loc.y, loc.z),
                size = vec3(1.5, 1.5, 2.0),
                rotation = loc.w,
                debug = false,
                options = {
                    {
                        name = zoneName,
                        icon = "fas fa-bolt",
                        label = Lang:t("general.cut_electric_panel"),
                        distance = 2.0,
                        onSelect = function()
                            onCutPanel(i, loc)
                        end
                    }
                }
            })
        end
    end
end

CreateThread(function()
    while true do
        local sleep = 1000
        local playerCoords = GetEntityCoords(PlayerPedId())

        for i, panel in ipairs(FRKN.General.panelLocations) do
            local dist = #(playerCoords - vector3(panel.x, panel.y, panel.z))
            if dist < 20.0 then
                sleep = 0
                DrawMarker(2, panel.x, panel.y, panel.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, 0.4, 255, 50, 50, 180, false, true, 2, nil, nil, false)
            end
        end

        Wait(sleep)
    end
end)


function checkAllPanelsCompleted()
    for _, panel in ipairs(FRKN.General.panelLocations) do
        if not panel.status then
            return
        end
    end

    if not allPanelsReported then
        allPanelsReported = true
        TriggerServerEvent('frkn-prison:allPanelsCut')
    end
end

function electricControl() 
    return electricFinished
end

RegisterNetEvent("frkn-prison:shutdownElectricity")
AddEventHandler("frkn-prison:shutdownElectricity", function()
    electricFinished = true

    Notify(Lang:t("success.cut_finish"), "success")

    SetNewWaypoint(FRKN.General.digSpot.coords.x, FRKN.General.digSpot.coords.y)

    local lights = GetGamePool('CObject')
    for _, obj in pairs(lights) do
        local coords = GetEntityCoords(obj)
        if PrisonZone:isPointInside(coords) then
            local model = GetEntityModel(obj)
            if model == GetHashKey("prop_streetlight_01") or model == GetHashKey("prop_streetlight_03") then
                SetEntityVisible(obj, false, false)
                SetArtificialLightsState(true)
                SetArtificialLightsStateAffectsVehicles(false)
            end
        end
    end

end)

RegisterNetEvent('prison:client:JailAlarm', function(toggle)
    if toggle then
        sounds()
        local alarmIpl = GetInteriorAtCoordsWithType(1787.004, 2593.1984, 45.7978, 'int_prison_main')

        RefreshInterior(alarmIpl)
        EnableInteriorProp(alarmIpl, 'prison_alarm')

        CreateThread(function()
            while not PrepareAlarm('PRISON_ALARMS') do
                Wait(100)
            end
            StartAlarm('PRISON_ALARMS', true)
        end)
    else
        local alarmIpl = GetInteriorAtCoordsWithType(1787.004, 2593.1984, 45.7978, 'int_prison_main')

        RefreshInterior(alarmIpl)
        DisableInteriorProp(alarmIpl, 'prison_alarm')

        CreateThread(function()
            while not PrepareAlarm('PRISON_ALARMS') do
                Wait(100)
            end
            StopAllAlarms(true)
        end)
    end
end)

function sounds() 
    PlaySound(-1, 'Lose_1st', 'GTAO_FM_Events_Soundset', 0, 0, 1)
    Wait(100)
    PlaySoundFrontend(-1, 'Beep_Red', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', 1)
    Wait(100)
    PlaySound(-1, 'Lose_1st', 'GTAO_FM_Events_Soundset', 0, 0, 1)
    Wait(100)
    PlaySoundFrontend(-1, 'Beep_Red', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', 1)
end

function onCutPanel(panelIndex, loc)

    
    if not isInPrison() then
        Notify(Lang:t('error.not_in_jail'), 'error')
        return
    end


    TriggerCallback('frkn-prison:ItemControl', function(result)
        if not result then
            Notify(Lang:t("error.missing_cutter_items"), "error")
            return
        end

        if FRKN.General.panelLocations[panelIndex].status then
            Notify(Lang:t("error.already_cut"), "error")
            return
        end

        if FRKN.General.TimeControl then 
            local hour = GetClockHours()
            if hour > 5 and hour < 20 then
                Notify(Lang:t("error.not_night"), "error")
                return
            end
        end

        panelResultHandled = false

        RequestAnimDict("amb@prop_human_parking_meter@male@base")
        while not HasAnimDictLoaded("amb@prop_human_parking_meter@male@base") do Wait(10) end
        TaskPlayAnim(PlayerPedId(), "amb@prop_human_parking_meter@male@base", "base", 8.0, -8, -1, 1, 0, false, false, false)


        SendNUIMessage({
            action = "cutElectricPanel",
            panelIndex = panelIndex,
            coords = loc
        })

        SetNuiFocus(true, true)

        TriggerServerEvent('frkn-prison:cutElectricPanel', panelIndex, loc)
    end, "prison_cutter")
end


RegisterNUICallback('failedCut', function(data, cb)
    if panelResultHandled then return end
    panelResultHandled = true

    SetNuiFocus(false, false)
    Notify(Lang:t("error.escape_prison"), "error")
    cb({})

    ClearPedTasksImmediately(PlayerPedId())

end)

RegisterNUICallback('successCut', function(data, cb)
    if panelResultHandled then return end
    panelResultHandled = true

    SetNuiFocus(false, false)

    local panelIndex = data.panelIndex
    if panelIndex and FRKN.General.panelLocations[panelIndex] then
        FRKN.General.panelLocations[panelIndex].status = true
        checkAllPanelsCompleted()
    end

    PlaySoundFrontend(-1, 'Beep_Red', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', 1)

    Notify(Lang:t("success.cut_success"), "success")
    sounds() 
    cb({})
    ClearPedTasksImmediately(PlayerPedId())
end)
