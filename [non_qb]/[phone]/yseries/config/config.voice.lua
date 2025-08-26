Config = Config or {}

Config.Voice = {}
Config.Voice.System = "pma"
--[[
    Supported voice systems:
        * pma: pma-voice - RECOMMENDED
        * mumble: mumble-voip - Not recommended, use pma-voice
        * salty: saltychat - Not recommended, use pma-voice
        * toko: tokovoip - Not recommended, use pma-voice
]]

-- Loudspeaker configuration
Config.Voice.Loudspeaker = {
    Enabled = true,           -- Enable/disable loudspeaker functionality
    Range = 5.0,              -- Range in meters for nearby players to hear the call
    UpdateInterval = 1000,    -- How often to check for nearby players (ms). 1000ms = 1 second
    MaxParticipants = 10      -- Maximum number of additional participants in a call. Not recommended to change this.
}

Config.Radio = {}

Config.Radio.MaxFrequency = 500

Config.Radio.RestrictedChannels = {
    [1] = { -- [ channel ] = { Allowed jobs }
        police = true,
        ambulance = true
    },
}
