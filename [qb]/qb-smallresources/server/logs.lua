local QBCore = exports['qb-core']:GetCoreObject()

local Webhooks = {
    ['default'] = '',
    ['testwebhook'] = '',
    ["playermoney"] = "https://discord.com/api/webhooks/1378984975210385468/t9SvC17epK9OuUhUnxyG2DNb-PhkW52FL1nigVsGfWXEmxr_rkf0oeZ8-veERRmQUeTh",
    -- ['playermoney'] = 'https://discord.com/api/webhooks/1378984975210385468/t9SvC17epK9OuUhUnxyG2DNb-PhkW52FL1nigVsGfWXEmxr_rkf0oeZ8-veERRmQUeTh'
    ['playerinventory'] = 'https://discord.com/api/webhooks/1378985361061183518/QhV5OU07XMX6zkOxwWKjIFnM9xHPSqmbeUXIyAHTjJS9lQJ419oWCXMAH5bmLzakODWS',
    ['robbing'] = 'https://discord.com/api/webhooks/1378988220813017128/20GiG-FgW9LoRh3aLP2iW5SR0L9qgeCLM93_KMe2OMGSM7Bnf5ax-MZLlL5OED0DPzIq',
    ['cuffing'] = 'https://discord.com/api/webhooks/1378988297531162704/jSaOnN2nqoGV6yihNiG0Ki5Kl8i6k-mJlz-ABIoZRvKoFxZ8MN2-LADav5PH1eIVk_pu',
    ['drop'] = 'https://discord.com/api/webhooks/1378988391131250769/eD4WOlNY1CTQWZitZM_RkSfdIAg3qQcY4TYLhNx6g2GvbOTMwQGAtbW-nD2nFj973UOn',
    ['trunk'] = 'https://discord.com/api/webhooks/1378988494977765489/BKnGQBCeBa05VR09GX0Xz64xSHnNWIBdZo4IU9RVgC1-SrfPvWhNdCnASsnGOThOe-mY',
    ['stash'] = 'https://discord.com/api/webhooks/1378988549864689695/NrOtNSqegcVPrL21SKUAwhX-FNsb9eW4iNXaZi8UgQvk7wb4DJXulgauk80_S3mhQ6KV',
    ['glovebox'] = 'https://discord.com/api/webhooks/1378988612007235645/d2X9Hq4Nmd3UYT9Ow6ZSzmjuzUzdRiw0x4qYk8gTZXGt1Jfvwkv8Ssy5NlIKmD2lRoNf',
    ['banking'] = 'https://discord.com/api/webhooks/1378988697701191712/vvyrE5r-doICtsMWM5QllTAEKwR0_HDJ-ihDUhuSWlV0u4PdiNXGx69InHQW0V7MHwyh',
    ['vehicleshop'] = 'https://discord.com/api/webhooks/1378988811954163764/NUkks0ZfO-89YnsyPPxWZVfPRh4MYCkXcwk9iF54lPK_nayi3VkgK4JNWM7WYEdnzJiq',
    ['vehicleupgrades'] = 'https://discord.com/api/webhooks/1378988862004527104/qCjGPQY9NN7vxnPfoPkpre-bXmPTNnjxh3wZA6VlHqRbc-v4iPUMRDNXi3lPak6YC6zT',
    ['shops'] = 'https://discord.com/api/webhooks/1378988952643567637/S7uFKfdWbAlRtkgv2lmxM9VusDDZokZ2jhyOcxdfzqQGwh6mNGolkUl6T9MsLHcZ_UxN',
    ['dealers'] = '',
    ['storerobbery'] = 'https://discord.com/api/webhooks/1378989425320661022/5t01HjaHVrL8QARwxJPC2Ny0Kqblit-uHdArb4aY8QEp5M_WYCT5pSCOXac68QJXOYq7',
    ['bankrobbery'] = 'https://discord.com/api/webhooks/1378989323407593472/HcWhZGxcSaTo0UPp8REETqwg4p7J-7RxmcJ7fpNvRu5ddxUxvxqkhr-Nmk8sAJojI66y',
    ['powerplants'] = '',
    ["death"] = "https://discord.com/api/webhooks/1378989571001552969/KmHkcwr7tVJgSDSzi3xaj8IIssde4d90R6BGhhymPUGDKHn4iTXmmZZoMRDdXZRZrO_l",
    ["joinleave"] = "https://discord.com/api/webhooks/1356027101773430824/kgLbVxPyJtnxUcrWhtNNPiKktvK9yx4TB7NtRmiey88IHmKAhbnaLDZZV3ua7PLzrQ34",
    
    -- ['death'] = 'https://discord.com/api/webhooks/1378989571001552969/KmHkcwr7tVJgSDSzi3xaj8IIssde4d90R6BGhhymPUGDKHn4iTXmmZZoMRDdXZRZrO_l',
    -- ['joinleave'] = 'https://discord.com/api/webhooks/1356027101773430824/kgLbVxPyJtnxUcrWhtNNPiKktvK9yx4TB7NtRmiey88IHmKAhbnaLDZZV3ua7PLzrQ34',
    ['ooc'] = 'https://discord.com/api/webhooks/1378990935823618138/hjCgfAsyg-_az7mg5VlybQ2m2yTPnUzRnR63NyNEGqWZBFHHySAaSmH_fDggjjy9ZUFE',
    ['report'] = 'https://discord.com/api/webhooks/1378990245848289300/buTGQMdwRoni0w1t4YBNl_xbxWepbP-YpWFTblUZN39ZGpPSVZ-0K5fndZ8fb8IjCmFT',
    ['me'] = 'https://discord.com/api/webhooks/1378990813773824071/BKQg1t4B-q3lAnxl-FeP-BV5fnb-6dlyRB-CYgq092ZigxZojjDYfqoPcj8kKjTvhXrj',
    ['pmelding'] = '',
    ['112'] = '',
    ['bans'] = 'https://discord.com/api/webhooks/1378991279106560010/O9Uo70MzCI2e2_zUw9yLH7DPAHE6QXNh382_YG6HwiFrAkp26XkYm9EYcdXx1yjuvS3R',
    ['anticheat'] = 'https://discord.com/api/webhooks/1378991417116069948/tmlQh_RbRgQ5FZsMF7LrR9HpP0vEKiNNG2-5EYMd13417nJscuPlA-PX6J8PDgXBICDR',
    ['weather'] = '',
    ['moneysafes'] = '',
    ['bennys'] = '',
    ['bossmenu'] = 'https://discord.com/api/webhooks/1378995950386679977/4JKf9F_TuOqXZgu8u0paiqHSLpzPcKH2VtcjTKSiepkEbxJLB5hEIwvkTOzPVqw1xr8U',
    ['robbery'] = '',
    ['casino'] = '',
    ['traphouse'] = '',
    ['911'] = '',
    ['palert'] = '',
    ['house'] = 'https://discord.com/api/webhooks/1378991632959017130/SqBs2xVnOlTntxov0aTw4Er4n0jzonWp3YZd2KtbNcMSOXF46G_DME0LqcheuHjVfTKz',
    ['qbjobs'] = '',
    ['ps-adminmenu'] = 'https://discord.com/api/webhooks/1378996507642171443/6OMD5giO-oT5pzKSyY0Q_UBF0YRE0EingAhSEAs8vLSBMAv6WISk1OnC1-1SiYARn9_-'
}

local colors = { -- https://www.spycolor.com/
    ['default'] = 14423100,
    ['blue'] = 255,
    ['red'] = 16711680,
    ['green'] = 65280,
    ['white'] = 16777215,
    ['black'] = 0,
    ['orange'] = 16744192,
    ['yellow'] = 16776960,
    ['pink'] = 16761035,
    ['lightgreen'] = 65309,
}

local logQueue = {}

RegisterNetEvent('qb-log:server:CreateLog', function(name, title, color, message, tagEveryone, imageUrl)
    local tag = tagEveryone or false

    if Config.Logging == 'discord' then
        if not Webhooks[name] then
            print('Tried to call a log that isn\'t configured with the name of ' .. name)
            return
        end
        local webHook = Webhooks[name] ~= '' and Webhooks[name] or Webhooks['default']
        local embedData = {
            {
                ['title'] = title,
                ['color'] = colors[color] or colors['default'],
                ['footer'] = {
                    ['text'] = os.date('%c'),
                },
                ['description'] = message,
                ['author'] = {
                    ['name'] = 'AATANK LOGS',
                    ['icon_url'] = 'https://cdn.discordapp.com/attachments/1365378558738042890/1368225784564551690/Comp1.gif?ex=683bb44f&is=683a62cf&hm=793478218c2dde3cea2613de878ef9e4ad88fe6c27361233a156ae1d88a5a5e0&',
                },
                ['image'] = imageUrl and imageUrl ~= '' and { ['url'] = imageUrl } or nil,
            }
        }

        if not logQueue[name] then logQueue[name] = {} end
        logQueue[name][#logQueue[name] + 1] = { webhook = webHook, data = embedData }

        if #logQueue[name] >= 10 then
            local postData = { username = 'QB Logs', embeds = {} }

            if tag then
                postData.content = '@everyone'
            end

            for i = 1, #logQueue[name] do postData.embeds[#postData.embeds + 1] = logQueue[name][i].data[1] end
            PerformHttpRequest(logQueue[name][1].webhook, function() end, 'POST', json.encode(postData), { ['Content-Type'] = 'application/json' })
            logQueue[name] = {}
        end
    elseif Config.Logging == 'fivemanage' then
        local FiveManageAPIKey = GetConvar('FIVEMANAGE_LOGS_API_KEY', 'false')
        if FiveManageAPIKey == 'false' then
            print('You need to set the FiveManage API key in your server.cfg')
            return
        end
        local extraData = {
            level = tagEveryone and 'warn' or 'info', -- info, warn, error or debug
            message = title,                          -- any string
            metadata = {                              -- a table or object with any properties you want
                description = message,
                playerId = source,
                playerLicense = GetPlayerIdentifierByType(source, 'license'),
                playerDiscord = GetPlayerIdentifierByType(source, 'discord')
            },
            resource = GetInvokingResource(),
        }
        PerformHttpRequest('https://api.fivemanage.com/api/logs', function(statusCode, response, headers)
            -- Uncomment the following line to enable debugging
            -- print(statusCode, response, json.encode(headers))
        end, 'POST', json.encode(extraData), {
            ['Authorization'] = FiveManageAPIKey,
            ['Content-Type'] = 'application/json',
        })
    end
end)

Citizen.CreateThread(function()
    local timer = 0
    while true do
        Wait(1000)
        timer = timer + 1
        if timer >= 60 then -- If 60 seconds have passed, post the logs
            timer = 0
            for name, queue in pairs(logQueue) do
                if #queue > 0 then
                    local postData = { username = 'QB Logs', embeds = {} }
                    for i = 1, #queue do
                        postData.embeds[#postData.embeds + 1] = queue[i].data[1]
                    end
                    PerformHttpRequest(queue[1].webhook, function() end, 'POST', json.encode(postData), { ['Content-Type'] = 'application/json' })
                    logQueue[name] = {}
                end
            end
        end
    end
end)

QBCore.Commands.Add('testwebhook', 'Test Your Discord Webhook For Logs (God Only)', {}, false, function()
    TriggerEvent('qb-log:server:CreateLog', 'testwebhook', 'Test Webhook', 'default', 'Webhook setup successfully')
end, 'god')
