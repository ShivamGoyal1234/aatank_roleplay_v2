um = {}

um.debug = false

um.lang = 'en' -- tr,en,es,zh,fr,hi [or add locales > .lua]

um.propertyDefaultImage = 'https://files.fivemerr.com/images/534eff8f-e6cb-473f-b441-bf0ac114e256.png'

um.property = {
    apartments = true,
    houses = true
}

-- If you want to show the logo, set it to true or hidden false
um.logo = {
    status = false,
    url = 'imageurl',
}

um.main = {
    onlyLastLocation = false,        -- If you want to only last location set true.
    forceDeadPedLastLocation = true, -- If you want force injured ped last location set true.
    camera = {
        radius = 2.0,                -- Camera distance from the character
        angle = 50,                  -- Camera angle
        point = 0.1,                 -- Camera point
        turning = true,              -- If you want to turn the camera, set it to true.
        skyspawnPos = -20,           -- -100 vertical, -20 horizontal
    },
    spawn = {
        type = 'playerFromSky', -- playerFromSky (um), gtaVNative
        cutScene = false,       -- If you want to show the cutscene, set it to true.
    },
    ped = {
        status = false, -- Make it true if you want your character to see and walk the path
    },
    bookmark = {
        status = false,   -- If you want to show the bookmark system, set it to true.
        money = {
            free = false, -- If you want to bookmark the free money, set it to true.
            amount = math.random(1000, 10000) or 500
        }
    },
}

--[[
   If your hud appears in spawn menu,
   this is nonsense, remember that hud is not shown without playerLoaded or LocalPlayer loaded,
   but that's ok, that's what this function was made for
--]]
um.hud = function(bool)
    if bool then
        -- Example: exports['myhud']:SetDisplay(false)
        Debug('Hud is hidden', 'debug')
    else
        -- Example: exports['myhud']:SetDisplay(true)
        Debug('Hud is show', 'debug')
    end
end

um.weather = {
    sync = true,   -- If you want to sync the weather, set it to true.
    sc = 'qb',     -- cd , qb
    type = 'XMAS', -- https://docs.fivem.net/docs/game-references/weather-types/
    time = 23,     -- 0 - 23
}

um.coords = {
    ['legion'] = {
        coords = vector4(190.12, -949.97, 30.96, 340.75),
        street = 'Meteor St',
        text = 'Legion Square'
    },
    ['hospital'] = {
        coords = vector4(-846.77, -1201.93, 6.14, 227.66),
        street = 'Elgin Ave Del Perro Fwy',
        text = 'Hospital Ave'
    },
    ['police'] = {
        coords = vector4(-580.96, -393.22, 35.18, 179.56),
        street = 'Sinner St Atlee St',
        text = 'Police Station'
    },
    ['sandy'] = {
        coords = vector4(1421.33, 3601.24, 34.85, 297.93),
        street = 'Algonquin Blvd',
        text = 'Sandy Shore'
    },
    ['paleto'] = {
        coords = vector4(-131.32, 6390.86, 31.5, 34.13),
        street = 'Paleto Blvd',
        text = 'Paleto Bay'
    }
}
