QBCore = exports['qb-core']:GetCoreObject()

local painkillerAmount = 0

local function DoBleedAlert()
    if not isDead and tonumber(isBleeding) > 0 then
        QBCore.Functions.Notify(Lang:t('info.bleed_alert', { bleedstate = Config.BleedingStates[tonumber(isBleeding)].label }), 'error', 5000)
    end
end

local function RemoveBleed(level)
    if isBleeding ~= 0 then
        if isBleeding - level < 0 then
            isBleeding = 0
        else
            isBleeding = isBleeding - level
        end
        DoBleedAlert()
    end
end

local function ApplyBleed(level)
    if isBleeding ~= 4 then
        if isBleeding + level > 4 then
            isBleeding = 4
        else
            isBleeding = isBleeding + level
        end
        DoBleedAlert()
    end
end


-- Bandage usage
RegisterNetEvent('consumables:client:useBandage', function()
    local ped = PlayerPedId()
    QBCore.Functions.Progressbar('use_bandage', 'Using Bandage...', 4000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
        anim = 'weed_inspecting_high_base_inspector',
        flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(ped, 'anim@amb@business@weed@weed_inspecting_high_dry@', 'weed_inspecting_high_base_inspector', 1.0)
        TriggerServerEvent('hospital:server:removeBandage')
        TriggerEvent('qb-inventory:client:ItemBox', QBCore.Shared.Items['bandage'], 'remove')
        SetEntityHealth(ped, GetEntityHealth(ped) + 10)
        if math.random(1, 100) < 50 then
          --  RemoveBleed(1)
        end
      --  if math.random(1, 100) < 7 then
         --   ResetPartial()
      --  end
    end, function() -- Cancel
        StopAnimTask(ped, 'anim@amb@business@weed@weed_inspecting_high_dry@', 'weed_inspecting_high_base_inspector', 1.0)
        QBCore.Functions.Notify('Canceled', 'error')
    end)
end)

-- IFAK usage
RegisterNetEvent('consumables:client:useIfak', function()
    local playerPed = PlayerPedId()
    QBCore.Functions.Progressbar("use_bandage", "Using IFAK...", 3000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = false
    }, {
        animDict = 'mp_suicide',
        anim = 'pill',
        flags = 49,
      }, {}, {}, function()
        StopAnimTask(playerPed, 'mp_suicide', 'pill', 1.0)
        TriggerServerEvent('hospital:server:removeIfaks')
        TriggerEvent('qb-inventory:client:ItemBox', QBCore.Shared.Items['ifaks'], 'remove')
        exports['envi-hud']:RemoveStress(math.random(12, 24))
        SetEntityHealth(playerPed, GetEntityHealth(playerPed) + 40)
		-- if painkillerAmount < 3 then
          --  painkillerAmount = painkillerAmount + 1
       -- end
        --PainKillerLoop()
        if math.random(1, 100) < 50 then
           -- RemoveBleed(1)
        end
    end, function()
        StopAnimTask(ped, 'mp_suicide', 'pill', 1.0)
        QBCore.Functions.Notify('IFAK use cancelled.', 'error', 3000)
    end)
end)
