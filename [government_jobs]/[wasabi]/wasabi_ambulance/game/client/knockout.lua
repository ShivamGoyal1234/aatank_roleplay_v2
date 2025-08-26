-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

if not Config.KnockoutFeature or not Config.KnockoutFeature.enabled then return end
local knockedOut

CreateThread(function()
    SetWeaponDamageModifier(`WEAPON_UNARMED`, (Config.KnockoutFeature.fistDamageModifier+0.0))
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        if IsPedInMeleeCombat(ped) and not knockedOut then
            sleep = 0
            if GetEntityHealth(ped) < Config.KnockoutFeature.healthForKnockout then
                TriggerEvent('wasabi_bridge:notify', Strings.knocked_out, Strings.knocked_out_desc, 'error')
                SetPedToRagdoll(ped, 1000, 1000, 0, false, false, false)
                ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', 2.5)
                knockedOut = true
                Wait(Config.KnockoutFeature.duration)
                knockedOut = false
            end
        end
        Wait(sleep)
    end
end)

local wasKnockedOut
local regainHealth = Config.KnockoutFeature.regainHealth
CreateThread(function()
    while true do
        local sleep = 1000
        if knockedOut then
            sleep = 0
            wasKnockedOut = true
            DisablePlayerFiring(PlayerId(), true)
            SetPedToRagdoll(wsb.cache.ped, 1000, 1000, 0, false, false, false)
            ResetPedRagdollTimer(wsb.cache.ped)
            SetTimecycleModifier('Bloom')
            SetTimecycleModifierStrength(2.8)
            ShakeGameplayCam('VIBRATE_SHAKE', 1.0)
            local health = GetEntityHealth(wsb.cache.ped)
            if regainHealth and health <= regainHealth then
                SetEntityHealth(wsb.cache.ped, (health+2))
            end
        elseif not knockedOut and wasKnockedOut then
            wasKnockedOut = nil
            ClearTimecycleModifier()
            knockedOut = false
        end
        Wait(sleep)
    end
end)