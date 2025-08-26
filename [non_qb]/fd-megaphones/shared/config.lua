Config = {
    proximityDistances = {
        vehicle = 50.0,             -- Proximity distance for vehicles
        handHeld = 30.0,            -- Proximity distance for handheld megaphone
        stage = 100.0,              -- Proximity distance for mics as objects
    },
    models = {                      -- Find object here - https://forge.plebmasters.de/objects
        `v_club_roc_micstd`, 
        `prop_table_mic_01` 
    },
    volume = -1.0,                  -- A value between 0.0 and 1.0. -1 for the default volume.
    specifyVehicles = false,        -- If false it will default to all vehicles under the emergency class
    vehicles = { "washington" },    -- If the above is true, these will be the only vehicles which have a vehicle megaphone.
    framework = 'qb',             -- none / qb / qbox / esx
    keybind = 'F12',                -- Default keybind for vehicle megaphone
    debug = false,                  -- Enables printing of basic debug info / polys
}

notify = function(text)
    lib.notify({title = text, type = 'inform'})
end