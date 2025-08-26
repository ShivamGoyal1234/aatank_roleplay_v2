KIBRA = {}

KIBRA.DispatchMenuPermissionNames = {
    'admin',
    'god'
} -- Type the names of the authorizations you want to access the Dispatch Admin menu.

KIBRA.NotifyTheNearestPoliceOfficer = false 
-- Incoming reports will only be forwarded from authorized officers to the nearest

KIBRA.DispatchAdminCommandName = 'disadmin'
-- Command name of the menu that opens the Dispatch admin.

KIBRA.PoliceDontSendFireNotices = false -- [NEW ADDED]
-- If you set true, police officers will no longer be notified if they shoot.

KIBRA.OpenDispatchMenuCommandName = 'openedlist' 
-- Command name of the menu that allows access to Dispatch history.

KIBRA.OpenDispatchMenuWithKey = {
    CanBeOpenedWithKey = true,
    Key = 'K'
}
-- If you want to open the Dispatch Menu with a key, you can mark the setting below as true and assign it to a key of your choice according to the FiveM keyboard key definitions.
-- https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/

KIBRA.Lang = 'en' -- en, tr, es, de, fr, ro, ru, pt

KIBRA.DispatchUILocation = 'top-left' -- top-right, top-left, top-center, top-vertical-center, top-right-vertical-center

KIBRA.DispatchListUILocation = 'top-left' -- top-right, top-left, top-center, top-vertical-center, top-right-vertical-center

KIBRA.NotificationSystem = 'qb' -- qb, esx, ox, 0r

KIBRA.DispatchAlertLessDetail = false
-- When you activate this setting, fewer details will appear in the dispatch.

KIBRA.RemovalTimeOfAlertBlips = 60 -- second

KIBRA.DurationNoticeOnScreen = 1 -- second

KIBRA.PedModelsGender = {
    Male = `mp_m_freemode_01`,
    Female = `mp_f_freemode_01`
}

KIBRA.RespondeButton = 'E'
-- A setting that allows you to select which button to use to send a notification. Check here to change it.
-- https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/

KIBRA.NotifySound = true

KIBRA.NextAlertButton = 'GRAVE' 
-- This button allows you to select the next call. Check here to change it.
-- https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/

KIBRA.ShowVehiclePlate = true
-- Adjusts the visibility of the license plate in crimes committed with vehicles.

KIBRA.AlertScreenTime = 5 
-- The setting that determines how many seconds the incoming notifications remain on the screen.

KIBRA.AlertCodes = {
    ["shooting"] = "10-31",
    ["explosion"] = "10-81",
    ["vehicletheft"] = "10-71",
    ["vehicleshooting"] = "10-94",
    --["fighting"] = "10-10",
    ["houseRobbery"] = "10-62",
    --["vehiclespeed"] = "10-80",
    ["vehicleAlarm"] = "10-60",
    ["DeathNotifications"] = "10-99",
    ["emsWorkerInjured"] = "10-99",
    ["civilianInjured"] = "10-99",
    ["ShopRobbery"] = "10-90"
}

KIBRA.DispatchBlip = {
    ['shooting'] = {
        Id = 110, -- https://docs.fivem.net/docs/game-references/blips/#blips
        Color = 37, -- https://docs.fivem.net/docs/game-references/blips/#blips
        Scale = 2.0 -- Starting from 0.1, you can enter the desired value.
    },

   -- ['fighting'] = {
    --    Id = 480, -- https://docs.fivem.net/docs/game-references/blips/#blips
     --   Color = 37, -- https://docs.fivem.net/docs/game-references/blips/#blips
     --   Scale = 2.0 -- Starting from 0.1, you can enter the desired value.
  --  },

    --['vehiclespeed'] = {
    --    Id = 620, -- https://docs.fivem.net/docs/game-references/blips/#blips
     --   Color = 37, -- https://docs.fivem.net/docs/game-references/blips/#blips
     --   Scale = 2.0 -- Starting from 0.1, you can enter the desired value.
   -- },

    ['vehicletheft'] = {
        Id = 530, -- https://docs.fivem.net/docs/game-references/blips/#blips
        Color = 37, -- https://docs.fivem.net/docs/game-references/blips/#blips
        Scale = 2.0 -- Starting from 0.1, you can enter the desired value.
    },

    ['explosion'] = {
        Id = 620, -- https://docs.fivem.net/docs/game-references/blips/#blips
        Color = 37, -- https://docs.fivem.net/docs/game-references/blips/#blips
        Scale = 2.0 -- Starting from 0.1, you can enter the desired value.
    },

    ['houseRobbery'] = {
        Id = 845, -- https://docs.fivem.net/docs/game-references/blips/#blips
        Color = 37, -- https://docs.fivem.net/docs/game-references/blips/#blips
        Scale = 2.0 -- Starting from 0.1, you can enter the desired value.
    },

    ['DeathNotifications'] = {
        Id = 305, -- https://docs.fivem.net/docs/game-references/blips/#blips
        Color = 1, -- https://docs.fivem.net/docs/game-references/blips/#blips
        Scale = 2.0 -- Starting from 0.1, you can enter the desired value.
    },

    ['civilianInjured'] = {
        Id = 305, -- https://docs.fivem.net/docs/game-references/blips/#blips
        Color = 1, -- https://docs.fivem.net/docs/game-references/blips/#blips
        Scale = 2.0 -- Starting from 0.1, you can enter the desired value.
    },

    ['emsWorkerInjured'] = {
        Id = 305, -- https://docs.fivem.net/docs/game-references/blips/#blips
        Color = 1, -- https://docs.fivem.net/docs/game-references/blips/#blips
        Scale = 2.0 -- Starting from 0.1, you can enter the desired value.
    },

    ['ShopRobbery'] = {
        Id = 305, -- https://docs.fivem.net/docs/game-references/blips/#blips
        Color = 1, -- https://docs.fivem.net/docs/game-references/blips/#blips
        Scale = 2.0 -- Starting from 0.1, you can enter the desired value.
    },

}

function capitalizeFirstLetter(str)
    return (str:gsub("^%l", string.upper))
end

KIBRA.Notification = function(type, text, time, title)
    if time == nil then time = 3000 end
    if title == nil then title = capitalizeFirstLetter(type) end
    if KIBRA.NotificationSystem == 'ox' then
        lib.notify({
            title = title,
            description = text,
            type = type
        })
    elseif KIBRA.NotificationSystem == 'qb' then
        TriggerEvent('QBCore:Notify', text, type, time)
    elseif KIBRA.NotificationSystem == '0r' then
        TriggerEvent('0R:Lib:Notify', {
            title = title, type = type, text = text
        })
    elseif KIBRA.NotificationSystem == 'esx' then
        TriggerEvent("esx:showNotification", text, type)
    end
end

KIBRA.Controls = {
    setCoord = {"[E]", "e"}, -- Button that allows you to select coordinates when creating a new disable zone.
    increaseRadius = {"[I]", "i"}, -- Button to increase the zone width when creating a new disable zone.
    decreaseRadius = {"[K]", "k"}, -- Button to reduce the zone width when creating a new disable zone.
    cancel = {"[DELETE]", "delete"} -- Button to cancel the operation when creating a new disable zone.
}