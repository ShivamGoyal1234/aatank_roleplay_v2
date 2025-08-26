-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

local DISCORD_IMAGE = 'https://i.imgur.com/m0Pfykr.png'

LogPlayerInfo = function(src)
    local playerOnline = wsb.getPlayer(src)
    if not playerOnline then return end

    local identifiers = {
        name = GetPlayerName(src),
        identifier = wsb.getIdentifier(src),
        steam = Strings.unknown,
        ip = Strings.unknown,
        discord = Strings.unknown,
        license = Strings.unknown,
        license2 = Strings.unknown,
        xbl = Strings.unknown,
        fivem = Strings.unknown
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, 'steam:') then
            identifiers.steam = id:gsub('steam:', '')
        elseif string.find(id, 'ip:') then
            identifiers.ip = id:gsub('ip:', '')
        elseif string.find(id, 'discord:') then
            identifiers.discord = id:gsub('discord:', '')
        elseif string.find(id, 'license:') then
            identifiers.license = id:gsub('license:', '')
        elseif string.find(id, 'license2:') then
            identifiers.license2 = id:gsub('license2:', '')
        elseif string.find(id, 'xbl:') then
            identifiers.xbl = id:gsub('xbl:', '')
        elseif string.find(id, 'live:') then
            identifiers.live = id:gsub('live:', '')
        elseif string.find(id, 'fivem:') then
            identifiers.fivem = id:gsub('fivem:', '')
        end
    end

    -- Apply defaults if necessary
    identifiers.steam = identifiers.steam or Strings.unknown
    identifiers.ip = Config.LogIPs and identifiers.ip or Strings.unknown
    identifiers.ip = identifiers.ip or Strings.unknown
    identifiers.discord = identifiers.discord or Strings.unknown
    identifiers.license = identifiers.license or Strings.unknown
    identifiers.license2 = identifiers.license2 or Strings.unknown
    identifiers.xbl = identifiers.xbl or Strings.unknown
    identifiers.fivem = identifiers.fivem or Strings.unknown

    return identifiers
end

local sendDeathToDiscord = function(victim, cause, killer)
    if not Config.DeathLogs then return end
    if SConfig.deathLogs.webhook == 'CHANGE_ME' or SConfig.deathLogs.webhook == '' then
        print('[wasabi_ambulance] - Death logs enabled but webhook link is not set in config!')
        return
    end
    local victimInfo = LogPlayerInfo(victim)
    local description, title
    if killer and killer > 0 then
        local killerInfo = LogPlayerInfo(killer)
        title = Strings.log_killed_title
        description = Strings.log_killed_desc:format(
            killerInfo.name, killer, 
            victimInfo.name, victim, 
            killerInfo.name, killer, 
            killerInfo.identifier, killerInfo.steam, killerInfo.discord, 
            killerInfo.license, killerInfo.license2, killerInfo.xbl, 
            killerInfo.fivem, killerInfo.ip, 
            victimInfo.name, victim, 
            victimInfo.identifier, victimInfo.steam, victimInfo.discord, 
            victimInfo.license, victimInfo.license2, victimInfo.xbl, 
            victimInfo.fivem, victimInfo.ip, 
            weaponNames[cause] or Strings.unknown
        )
    else
        title = Strings.log_suicide_title
        description = Strings.log_suicide_desc:format(
            victimInfo.name, victim, 
            victimInfo.name, victim, 
            victimInfo.identifier, victimInfo.steam, victimInfo.discord, 
            victimInfo.license, victimInfo.license2, victimInfo.xbl, 
            victimInfo.fivem, victimInfo.ip, 
            weaponNames[cause] or Strings.unknown
        )
    end
    
    local embed = {
        {
            ['color'] = SConfig.deathLogs.color,
            ['title'] = '**' .. title .. '**',
            ['description'] = description,
            ['footer'] = { ['text'] = 'Wasabi Ambulance' }
        }
    }
    
    PerformHttpRequest(SConfig.deathLogs.webhook, function() end, 'POST', json.encode({username = Strings.log_death_logs, embeds = embed, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end

local sendReviveToDiscord = function(source, target)
    if not Config.ReviveLogs then return end
    if not source or source == 0 then return end
    if SConfig.reviveLogs.webhook == 'CHANGE_ME' or SConfig.reviveLogs.webhook == '' then
        print('[wasabi_ambulance] - Revive logs enabled but webhook link is not set in config!')
        return
    end

    local adminInfo = LogPlayerInfo(source)
    local description, title

    if target then
        local targetInfo = LogPlayerInfo(target)
        title = Strings.log_admin_revive_title
        description = Strings.log_admin_revive_desc:format(
            adminInfo.name, source, 
            targetInfo.name, target, 
            targetInfo.name, target, 
            targetInfo.identifier, targetInfo.steam, targetInfo.discord, 
            targetInfo.license, targetInfo.license2, targetInfo.xbl, 
            targetInfo.fivem, targetInfo.ip, 
            adminInfo.name, source, 
            adminInfo.identifier, adminInfo.steam, adminInfo.discord, 
            adminInfo.license, adminInfo.license2, adminInfo.xbl, 
            adminInfo.fivem, adminInfo.ip
        )
    else
        title = Strings.log_self_revive_title
        description = Strings.log_self_revive_desc:format(
            adminInfo.name, source, 
            adminInfo.name, source, 
            adminInfo.identifier, adminInfo.steam, adminInfo.discord, 
            adminInfo.license, adminInfo.license2, adminInfo.xbl, 
            adminInfo.fivem, adminInfo.ip
        )
    end

    local embed = {
        {
            ['color'] = SConfig.reviveLogs.color,
            ['title'] = '**' .. title .. '**',
            ['description'] = description,
            ['footer'] = { ['text'] = 'Wasabi Ambulance' }
        }
    }

    PerformHttpRequest(SConfig.reviveLogs.webhook, function() end, 'POST', json.encode({username = Strings.log_revive_logs, embeds = embed, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end

local function sendCombatLogToDiscord(player)
    if not Config.CombatLogs then return end
    if SConfig.combatLogs.webhook == 'CHANGE_ME' or SConfig.combatLogs.webhook == '' then
        print('[wasabi_ambulance] - Combat logs enabled but webhook link is not set in config!')
        return
    end

    local playerInfo = LogPlayerInfo(player)
    local title = Strings.log_combatlog_title
    local description = Strings.log_combatlog_desc:format(
        playerInfo.name, player, 
        playerInfo.name, player, 
        playerInfo.identifier, playerInfo.steam, playerInfo.discord, 
        playerInfo.license, playerInfo.license2, playerInfo.xbl, 
        playerInfo.fivem, playerInfo.ip
    )

    local embed = {
        {
            ['color'] = SConfig.combatLogs.color,
            ['title'] = '**' .. title .. '**',
            ['description'] = description,
            ['footer'] = { ['text'] = 'Wasabi Ambulance' }
        }
    }

    PerformHttpRequest(SConfig.combatLogs.webhook, function() end, 'POST', json.encode({username = Strings.log_combat_logs, embeds = embed, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end


RegisterNetEvent('wasabi_ambulance:logRevive', function(source, target)
    sendReviveToDiscord(source, target ~= source and target or nil)
end)

RegisterNetEvent('wasabi_ambulance:logDeath', function(cause, killer)
    local playerState = Player(source).state
    if not playerState.dead then
        sendDeathToDiscord(source, cause, killer)
    end
end)

RegisterNetEvent('wasabi_ambulance:logCombat', function(player)
    sendCombatLogToDiscord(player)
end)


