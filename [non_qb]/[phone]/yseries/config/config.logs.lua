Config = Config or {}


--[[
╔════════════════════════════════════════════════════════════════════════╗
║                          LOGS CONFIGURATION                            ║
╠════════════════════════════════════════════════════════════════════════╣
║       For detailed documentation and setup instructions, visit:        ║
║       https://docs.teamsgg.dev/paid-scripts/phone/configure/logs       ║
╚════════════════════════════════════════════════════════════════════════╝
--]]


Config.Logs = {}         -- The webhook that will be used to send the posts to the discord channel.
Config.Logs.Timeout = 60 -- The amount of time in seconds that the logs will be queued before being sent to the discord channel.
Config.Logs.Webhooks = {
    -- Logs webhooks are moved in - `server\apiKeys.lua`
}

Config.Logs.Avatars = { -- The avatar for the bot that will be used to send the posts to the discord channel.
    ['instashots'] = 'https://i.pinimg.com/736x/09/8a/9a/098a9afecfc2d8d0c98a41d8f13291fe.jpg',
    ['instashots_posts'] = 'https://i.pinimg.com/736x/09/8a/9a/098a9afecfc2d8d0c98a41d8f13291fe.jpg',
    ['instashots_messages'] = 'https://i.pinimg.com/736x/09/8a/9a/098a9afecfc2d8d0c98a41d8f13291fe.jpg',
    ['y'] = '',
    ['y_posts'] = '',
    ['y_messages'] = '',
    ['ypay'] = '',
    ['ybuy'] = '',
    ['companies'] = '',
    ['phone'] = '',
    ['messages'] = '',
    ['darkchat'] = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZyw5dzjtPdfoTnmX7XP_5oWSlq1Sp1HG4Ug&s',
    ['special'] = '',
    ['promoHub'] = '',
}

Config.Logs.Colors = { -- https://www.spycolor.com/
    ['instashots'] = 15884387,
    ['instashots_posts'] = 15884387,
    ['instashots_messages'] = 15884387,
    ['companies'] = 1940464,
    ['default'] = 14423100,
    ['ybuy'] = 15020857,
    ['ypay'] = 431319,
    ['y'] = 1940464,
    ['y_posts'] = 1940464,
    ['y_messages'] = 1940464,
    ['phone'] = 009966,
    ['messages'] = 0x1388d6,
    ['darkchat'] = 0x128b7d,
    ['special'] = 0xFF0000, 
    ['promoHub'] = 0xffc900,
}
