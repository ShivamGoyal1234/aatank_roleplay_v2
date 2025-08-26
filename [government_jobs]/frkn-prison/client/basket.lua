basketball = nil
basketTasks = {}

local basketballZones = {}

Citizen.CreateThread(function()
    for _, zoneData in pairs(FRKN.General.BasketballZones) do
        local zone = PolyZone:Create(zoneData.points, {
            name = zoneData.label,
            minZ = zoneData.minZ,
            maxZ = zoneData.maxZ
        })
        table.insert(basketballZones, zone)
    end
end)

local basketballCommandUsed = 0
local basketballCommandLimit = FRKN.General.Limit or 5 

RegisterCommand(FRKN.General.Commands, function()
    if basketballCommandUsed >= basketballCommandLimit then
        Notify(Lang:t('error.max_basketball_limit', 'error'))
        return
    end

    local coords = GetEntityCoords(PlayerPedId())
    local insideZone = false

    for _, zone in pairs(basketballZones) do
        if zone:isPointInside(coords) then
            insideZone = true
            break
        end
    end

    if insideZone then
        local forward = GetEntityForwardVector(PlayerPedId())
        local entityCoords = coords + forward * 2
        local entity = CreateObject(GetHashKey(FRKN.General.PropModel), entityCoords, true, true, true)
        SetEntityVelocity(entity, 0.0001, 0.0, 0.0)
        SetEntityAsMissionEntity(entity, true, true)

        basketballCommandUsed += 1

        Notify(Lang:t('general.pick_up_ball'), 'info')
        Notify(Lang:t('general.change_play_style'), 'info')
        Notify(Lang:t('general.shoot_ball'), 'info')
        Notify(Lang:t('general.dribble_ball'), 'info')
        Notify(Lang:t('general.detach_ball'), 'info')
    else
        Notify(Lang:t('error.not_in_basketball_area'), 'error')
    end
end)


Citizen.CreateThread(function()
    while true do
        if IsControlJustReleased(0, FRKN.General.PickUpBall) then
            if not basketball then
                local closestEntity, closestEntityDistance = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.5, GetHashKey(FRKN.General.PropModel), false, false, false)
                local closestEntityDistance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(closestEntity))
                if GetEntityModel(closestEntity) == GetHashKey(FRKN.General.PropModel) and closestEntityDistance <= 1.5 then
                    PickupBasketball(closestEntity)
                end
            end
        end

        if IsControlJustReleased(0, FRKN.General.PlayStyleBall) then
            if basketball then
                if not basketTasks.isRolling then
                    basketTasks.isRolling = true
                    LoadAnim('amb@world_human_mobile_film_shocking@male@base')
                    TaskPlayAnim(PlayerPedId(), 'amb@world_human_mobile_film_shocking@male@base', 'base', 8.0, 8.0, -1, 51, 0, false, false, false)
                    local ballRotation = 0.0
                    Citizen.CreateThread(function()
                        while basketTasks.isRolling do
                            if ballRotation > 360 then
                                ballRotation = 0.0
                                AttachEntityToEntity(basketball, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, true, false, 0.0, false)
                            else
                                ballRotation = ballRotation + 60
                                AttachEntityToEntity(basketball, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, ballRotation, true, true, true, false, 0.0, false)
                            end
                            Citizen.Wait(0)
                        end
                    end)
                    Citizen.CreateThread(function()
                        Citizen.Wait(12000)
                        if basketTasks.isRolling then
                            DetachBasketball()
                            basketTasks.isRolling = false
                        end
                    end)
                else
                    ClearPedTasks(PlayerPedId())
                    basketTasks.isRolling = false
                end
            end
        end

        if IsDisabledControlPressed(0, FRKN.General.ShootBall) then
            if basketball then
                DrawPowerLine()
            
                if not basketTasks.normalShootForce then
                    basketTasks.normalShootForce = 0.1
                end
            
                if not basketTasks.lastUpdate then
                    basketTasks.lastUpdate = GetGameTimer()
                end
            
                SendNUIMessage({
                    action = "showPowerBar",
                    power = basketTasks.normalShootForce
                })
            
                if GetGameTimer() - basketTasks.lastUpdate > 30 then
                    basketTasks.normalShootForce = basketTasks.normalShootForce + 0.02
                    if basketTasks.normalShootForce >= 2.0 then
                        basketTasks.normalShootForce = 0.1
                    end
                
                    SendNUIMessage({
                        action = "updatePower",
                        power = basketTasks.normalShootForce
                    })
                
                    basketTasks.lastUpdate = GetGameTimer()
                end
            end
        end

        if IsDisabledControlJustReleased(0, FRKN.General.ShootBall) then
            basketTasks.lastUpdate = nil
        end


        if IsDisabledControlJustReleased(0, FRKN.General.ShootBall) then
            if basketball then
                if not basketTasks.isShooting then
                    basketTasks.isShooting = true

                    SendNUIMessage({
                        action = "hidePowerBar"
                    })

                    LoadAnim('amb@prop_human_movie_bulb@exit')
                    ClearPedTasksImmediately(PlayerPedId())
                    local forwardX = GetEntityForwardX(PlayerPedId())
                    local forwardY = GetEntityForwardY(PlayerPedId())

                    local camRot = GetGameplayCamRot(2)
                    local pitch = math.rad(camRot.x)
                    local yaw = math.rad(camRot.z)
                    local force = basketTasks.normalShootForce or 0.1

                    local direction = vector3(-math.sin(yaw) * math.cos(pitch), math.cos(yaw) * math.cos(pitch), math.sin(pitch))
                                    
                    DetachEntity(basketball)
                    SetEntityVelocity(basketball, direction.x * force * 8.0, direction.y * force * 8.0, direction.z * force * 8.0)

                    
                    basketball = nil
                    TaskPlayAnim(PlayerPedId(), 'amb@prop_human_movie_bulb@exit', 'exit', 8.0, 8.0, -1, 48, 1, false, false, false)

                    Citizen.Wait(1000)
                    ClearPedTasks(PlayerPedId())
                    basketTasks.isShooting = false
                    basketTasks.normalShootForce = 0.1
                    basketTasks.isDribbling = false
                end
            end
        end

        if IsControlPressed(0, FRKN.General.DribbleBall) then
            if basketball and not basketTasks.isDribbling then
                LoadAnim('anim@move_m@trash')
                TaskPlayAnim(PlayerPedId(), 'anim@move_m@trash', 'walk', 8.0, 8.0, -1, 51, 1, false, false, false)
                basketTasks.isDribbling = true
            end
        else
            if basketball and basketTasks.isDribbling then
                basketTasks.isDribbling = false
                StopAnimTask(PlayerPedId(), 'anim@move_m@trash', 'walk', 51)
                ClearPedTasksImmediately(PlayerPedId())
            end 
        end

        if IsControlJustReleased(0, FRKN.General.DetachBall) then
            if basketball then
                DetachBasketball()
            end
        end

        if basketball then
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 140, true)
        end

        Citizen.Wait(0)
    end
end)


Citizen.CreateThread(function()
    while true do
        if basketball and basketTasks.isDribbling then
            local playerPed = PlayerPedId()
            if IsPedWalking(playerPed) or IsPedRunning(playerPed) then
                DetachEntity(basketball)
                local forwardX = GetEntityForwardX(playerPed)
                local forwardY = GetEntityForwardY(playerPed)
                SetEntityVelocity(basketball, forwardX * 2, forwardY * 2, -3.8)
                Citizen.Wait(300)
                forwardX = GetEntityForwardX(playerPed)
                forwardY = GetEntityForwardY(playerPed)
                SetEntityVelocity(basketball, forwardX * 1.9, forwardY * 1.9, 4.0)
                Citizen.Wait(450)
                AttachEntityToEntity(basketball, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, true, false, 0.0, true)
            elseif IsPedSprinting(playerPed) then
                DetachEntity(basketball)
                local forwardX = GetEntityForwardX(playerPed)
                local forwardY = GetEntityForwardY(playerPed)
                SetEntityVelocity(basketball, forwardX * 9, forwardY * 9, -10.0)
                Citizen.Wait(200)
                forwardX = GetEntityForwardX(playerPed)
                forwardY = GetEntityForwardY(playerPed)
                SetEntityVelocity(basketball, forwardX * 8, forwardY * 8, 3.0)
                Citizen.Wait(300)
                AttachEntityToEntity(basketball, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, true, false, 0.0, true)
            else 
                DetachEntity(basketball)
                SetEntityVelocity(basketball, 0.0, 0.0, -3.8)
                Citizen.Wait(250)
                SetEntityVelocity(basketball, 0, 0, 4.0)
                Citizen.Wait(450)
                AttachEntityToEntity(basketball, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, true, false, 0.0, true)
            end
        end 
        Citizen.Wait(0)
    end
end)

function PickupBasketball(entity)
    NetworkRequestControlOfEntity(entity)
    while (NetworkGetEntityOwner(entity) ~= PlayerId()) and (NetworkGetEntityOwner(entity) ~= -1) do
        Citizen.Wait(0)
    end
    LoadAnim('anim@mp_snowball')
    TaskPlayAnim(PlayerPedId(), 'anim@mp_snowball', 'pickup_snowball', 8.0, 8.0, -1, 32, 1, false, false, false)
    Citizen.Wait(150)
    AttachEntityToEntity(entity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, true, false, 0.0, true)
    basketball = entity
    SetEntityAsMissionEntity(entity, true, true)
    Citizen.Wait(1500)
    ClearPedTasksImmediately(PlayerPedId())
end

function DetachBasketball()
    DetachEntity(basketball)
    basketball = nil
    basketTasks = {}
end

function LoadAnim(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end
    return true
end

function DrawPowerLine()
    local ped = PlayerPedId()
    local start = GetPedBoneCoords(ped, 28422, 0.0, 0.0, 0.0)
    local camRot = GetGameplayCamRot(2)
    local force = basketTasks.normalShootForce or 0.1

    local pitch = math.rad(camRot.x)
    local yaw = math.rad(camRot.z)
    local direction = vector3(-math.sin(yaw) * math.cos(pitch), math.cos(yaw) * math.cos(pitch), math.sin(pitch))

    local velocity = direction * (force * 8.0)
    local gravity = vector3(0.0, 0.0, -9.81)
    local position = start
    local timeStep = 0.1
    local steps = 20

    for i = 1, steps do
        local nextPos = position + velocity * timeStep + 0.5 * gravity * timeStep * timeStep
        velocity = velocity + gravity * timeStep

        DrawMarker(28, nextPos.x, nextPos.y, nextPos.z, 0, 0, 0, 0, 0, 0, 0.15, 0.15, 0.15, 255, 255, 0, 180, false, true, 2, false, nil, nil, false)

        position = nextPos
    end
end
