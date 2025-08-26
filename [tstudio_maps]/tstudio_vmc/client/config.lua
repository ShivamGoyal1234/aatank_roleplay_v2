Locales = {}

Config = {
    Locale = "en",
    Marker = { -- https://docs.fivem.net/docs/game-references/markers/
        type = 2,
        r = 52,
        g = 235,
        b = 183,
        alpha = 50
    },
    Elevators = {
        {
            floors = { -- left elevator
                [1] = {
                    name = "2. Floor",
                    pos = vector4(-799.164, -1243.154, 11.314, 52.592)
                },
                [2] = {
                    name = "1. Floor",
                    pos = vector4(-799.395, -1243.015, 6.720, 50.103)
                }
            }
        }, {
            floors = { -- right elevator
            [1] = {
                name = "2. Floor",
                pos = vector4(-801.178, -1245.363, 11.314, 56.841)
            },
            [2] = {
                name = "1. Floor",
                pos = vector4(-801.561, -1245.693, 6.720, 54.621)
            }
            }
        }, {
            floors = { -- heli elevator
            [1] = {
                name = "Helipad",
                pos = vector4(-836.430, -1254.273, 13.127, 332.033)
            },
            [2] = {
                name = "1. Floor",
                pos = vector4(-839.186, -1251.753, 6.720, 316.017)
            }
            }
        }
    }
}
