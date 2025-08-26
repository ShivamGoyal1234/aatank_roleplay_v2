-- Discord webhook URL - Replace with your actual webhook URL
-- Example: "https://discord.com/api/webhooks/1234567890/abcdefghijklmnopqrstuvwxyz"
Config.WebhookUrl = "https://discord.com/api/webhooks/1378989425320661022/5t01HjaHVrL8QARwxJPC2Ny0Kqblit-uHdArb4aY8QEp5M_WYCT5pSCOXac68QJXOYq7"

-- Webhook configuration settings
Config.Webhook = {
    Color = 16753920,                -- Embed color in decimal (orange: 16753920, green: 5763719, red: 15548997, blue: 3447003)
    Title = "JOBS SYSTEM",           -- Title of the webhook message
    Author = "Forge JOBS",           -- Author name displayed in the webhook
    IconUrl = "https://ferko.pl/wp-content/uploads/2022/01/fivem-4.png", -- Icon URL for the webhook
    
    -- Enhanced webhook features
    EnableThumbnail = false,         -- Set to true to enable thumbnail in webhook
    ThumbnailUrl = "",               -- URL for thumbnail image (only used if EnableThumbnail is true)
    EnableTimestamp = true,          -- Set to false to disable timestamp in webhook
    EnablePlayerName = true,         -- Set to false to hide player names in logs
    EnableSteamLink = true,          -- Set to false to disable Steam profile links
    EnableDiscordMention = true,     -- Set to false to disable Discord mentions
    
    -- Debug settings
    EnableDebugLogs = false,         -- Set to true to enable webhook debug messages in console
}