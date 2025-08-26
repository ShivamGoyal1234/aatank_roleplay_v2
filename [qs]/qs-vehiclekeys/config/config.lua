Config = Config or {}
Locales = Locales or {}

--[[
    Welcome to the qs-vehiclekeys configuration!
    To start configuring your new asset, please read carefully
    each step in the documentation that we will attach at the end of this message.

    Each important part of the configuration will be highlighted with a box.
    like this one you are reading now, where I will explain step by step each
    configuration available within this file.

    This is not all, most of the settings, you are free to modify it
    as you wish and adapt it to your framework in the most comfortable way possible.
    The configurable files you will find all inside client/custom/*
    or inside server/custom/*.

    Direct link to the resource documentation, read it before you start:
    https://docs.quasar-store.com/information/welcome
]]

--[[
    The first thing will be to choose our main language, here you can choose
    between the default languages that you will find within locales/*,
    if yours is not there, feel free to create it!
]]

Config.Language = 'en' -- Available languages by default: 'es', 'en', 'fr', 'de', 'it', 'tr', 'zh-CN', 'jp'. You can create more if you wish.

--[[
 █▀▀ █▀█ ▄▀█ █▀▄▀█ █▀▀ █░█░█ █▀█ █▀█ █▄▀
 █▀░ █▀▄ █▀█ █░▀░█ ██▄ ▀▄▀▄▀ █▄█ █▀▄ █░█
]]

--[[
 This function automatically detects your framework script as long as it is named
 according to one of the expected names listed below. If no framework script is
 detected, it will return 'standalone' and print an error message indicating that
 the script may not work properly.

 The current system will detect if you use qb-core, es_extended, or qbox,
 but if you rename it, you can remove the value from Config.Framework
 and add it yourself after you have modified the framework files inside
 this script.

 Please keep in mind that this code is automatic, do not edit if
 you do not know how to do it.
]]

function detectFramework()
    local function checkResource(name)
        return GetResourceState(name) == 'started'
    end

    local esxHas = checkResource('es_extended')
    local qbHas = checkResource('qb-core')
    local qbxHas = checkResource('qbx_core')

    if Config.Debug then
        if esxHas then
            print('DEBUG: Detected framework: es_extended')
        elseif qbHas then
            print('DEBUG: Detected framework: qb-core')
        elseif qbxHas then
            print('DEBUG: Detected framework: qbx_core')
        else
            print('DEBUG: Error: No framework has been detected. The script will probably not work.')
        end
    end

    if esxHas then
        return 'esx'
    elseif qbxHas then
        return 'qbx'
    elseif qbHas then
        return 'qb'
    else
        return 'standalone'
    end
end

Config.Framework = detectFramework()


--[[
 █ █▄░█ █░█ █▀▀ █▄░█ ▀█▀ █▀█ █▀█ █▄█
 █ █░▀█ ▀▄▀ ██▄ █░▀█ ░█░ █▄█ █▀▄ ░█░
]]

--[[
 This function automatically detects your inventory script as long as it is named
 according to one of the expected names listed below. If no inventory script is
 detected, it will return 'default' and print an error message indicating that
 the script may not work properly.
]]

function detectInventory()
    local function checkResource(name)
        return GetResourceState(name) == 'started'
    end

    local origenInv = checkResource('origen_inventory')
    local qsInv = checkResource('qs-inventory')
    local qbInv = checkResource('qb-inventory')
    local coreInv = checkResource('core_inventory')
    local oxInv = checkResource('ox_inventory')
    local codemInv = checkResource('codem-inventory')
    local tgiannInv = checkResource('tgiann-inventory')

    if Config.Debug then
        if origenInv then
            print('DEBUG: Detected inventory script: origen_inventory')
        elseif qsInv then
            print('DEBUG: Detected inventory script: qs-inventory')
        elseif qbInv then
            print('DEBUG: Detected inventory script: qb-inventory')
        elseif coreInv then
            print('DEBUG: Detected inventory script: core_inventory')
        elseif oxInv then
            print('DEBUG: Detected inventory script: ox_inventory')
        elseif codemInv then
            print('DEBUG: Detected inventory script: codem-inventory')
        elseif tgiannInv then
            print('DEBUG: Detected inventory script: tgiann-inventory')
        else
            print('DEBUG: Error: No inventory script has been detected. The script will probably not work.')
        end
    end

    if origenInv then
        return 'origen'
    elseif qsInv then
        return 'qs'
    elseif qbInv then
        return 'qb'
    elseif coreInv then
        return 'core_inventory'
    elseif oxInv then
        return 'ox'
    elseif codemInv then
        return 'codem'
    elseif tgiannInv then
        return 'tgiannInv'
    else
        return 'default'
    end
end

Config.InventoryScript = detectInventory()


--[[
█▀█ █░█ █▀█ █▄░█ █▀▀
█▀▀ █▀█ █▄█ █░▀█ ██▄
]]

function detectPhone()
    local function checkResource(name)
        return GetResourceState(name) == 'started'
    end

    local qsPhone = checkResource('qs-smartphone')
    local qsPhonePro = checkResource('qs-smartphone-pro')
    local lbPhone = checkResource('lb-phone')

    if Config.Debug then
        if qsPhone then
            print('DEBUG: Detected phone script: qs-smartphone')
        elseif qsPhonePro then
            print('DEBUG: Detected phone script: qs-smartphone-pro')
        elseif lbPhone then
            print('DEBUG: Detected phone script: lb-phone')
        else
            print('DEBUG: Error: No phone script has been detected. The script will probably not work.')
        end
    end

    if qsPhone then
        return 'qs-smartphone'
    elseif qsPhonePro then
        return 'qs-smartphone-pro'
    elseif lbPhone then
        return 'lb-phone'
    else
        return 'default'
    end
end

Config.Smartphone = detectPhone()

--[[
 █▀▄▀█ █▀▀ █▄░█ █░█   ▀█▀ █▄█ █▀█ █▀▀
 █░▀░█ ██▄ █░▀█ █▄█   ░█░ ░█░ █▀▀ ██▄
]]

-- Choose from the following options.
--[[
        'ox_lib',
        'esx_context',
        'esx_menu_default',
        'qb'
    ]]
Config.MenuType = 'qb' -- Menu type that you will want to use. (Mainly for the copy of the keys and the buying of the plate, if you haven't selected the shop option.)

--[[
 ▀█▀ █▀▀ ▀▄▀ ▀█▀   █░█ █
 ░█░ ██▄ █░█ ░█░   █▄█ █
]]

-- Choose from the following options.
--[[
        'HelpNotification', --Basic FiveM HelpNotification
        'ox_lib', -- Most optimized.
        'esx_textui', -- not tested on the moment, please report any issues it will be fixed asap !
        'qb', -- not tested on the moment, please report any issues it will be fixed asap !
        'okokTextUI', -- Most optimized. (A bit loud...)
    ]]
Config.TextUI = 'qb' -- TextUI shown while getting close to the Peds, for copy of the keys and the buying of the plate.

--[[
 ▀█▀ ▄▀█ █▀█ █▀▀ █▀▀ ▀█▀
 ░█░ █▀█ █▀▄ █▄█ ██▄ ░█░
]]

-- Will be improved on fruther...
-- Installing of the plate trough target, stealing peds and much more are coming !

function isOxTargetEnabled()
    local function checkResource(name)
        return GetResourceState(name) == 'started'
    end

    local oxTargetHas = checkResource('ox_target')

    if Config.Debug then
        if oxTargetHas then
            print('DEBUG: ox_target is enabled.')
        else
            print('DEBUG: ox_target is not enabled.')
        end
    end

    return oxTargetHas
end

Config.EnableTarget = isOxTargetEnabled() -- Used for lock / unlocked of the cars, and for copy of the keys and the buying of the plate. (If enabled it will override the options of the TextUI)

Config.TargetDistance = 2.0               -- Distance
Config.TargetAdminOptions = true         -- Used for lock / unlocked of the cars and get keys from ox_target using job permissions.
Config.TargetAdminOptionsJobs = 'police'  -- or a table  { 'police', 'mechanic' }

--[[
█▀▀ █▀█ █▄░█ ▀█▀ █▀▀ ▀▄▀ ▀█▀
█▄▄ █▄█ █░▀█ ░█░ ██▄ █░█ ░█░
]]

Config.Context = false -- Specifies whether to enable the context menu. (Only supporting ox_lib context for the moment, let us know if you'd like more menus adapted)
--[[
    Set to true to enable, false to disable.
    When enabled, the context menu allows for various actions such as:
        * Giving keys to other players with an animation (removing the key from your inventory)
        * Using the key
        * Discarding the key
        * Clearing your inventory of keys from vehicles you don't own.
]]

--[[
 █▀█ ▄▀█ █▀▄ █ ▄▀█ █░░
 █▀▄ █▀█ █▄▀ █ █▀█ █▄▄
]]

Config.Radial = false
--[[
 Set to true to enable, false to disable.
 The radial menu can manage:
    * Opening nearby vehicle
    * Managing vehicle doors
    * Managing windows
    * Managing the vehicle engine
    * Switching between seats
]]


-- ░██████╗░███████╗███╗░░██╗███████╗██████╗░░█████╗░██╗░░░░░
-- ██╔════╝░██╔════╝████╗░██║██╔════╝██╔══██╗██╔══██╗██║░░░░░
-- ██║░░██╗░█████╗░░██╔██╗██║█████╗░░██████╔╝███████║██║░░░░░
-- ██║░░╚██╗██╔══╝░░██║╚████║██╔══╝░░██╔══██╗██╔══██║██║░░░░░
-- ██████╔╝███████╗ ██║░╚███║███████╗██║░░██║██║░░██║███████╗
-- ░╚═════╝░╚══════╝╚═╝░░╚══╝╚══════╝╚═╝░░╚═╝╚═╝░░╚═╝╚══════╝

Config.NpcVehiclesLocked = false -- bool : true or false, do you want npc vehicles spawned by GTA V to be blocked?

--[[
    Forces to all spawned vehicles to be locked.
    Normally fivem doing this
    but if you have issuing a problem with vehicles are spawned unlocked set this to true
]]
Config.ForceSpawnVehiclesAsLocked = true


-- List of vehicle models to ignore for locking and entry logic.
-- Vehicles specified in this table will not trigger any locking behavior, allowing you to exclude certain vehicles from the locking system.
-- Add model names or hashes of the vehicles you want to exempt.
Config.NoLockVehicles = { `taxi` }

Config.SendNotification = true           -- bool : true or false, true will send a notification when you open / close the vehicle. False will not send a notification.
Config.CustomDesignTextUI = true         -- bool : true or false, enable or disable custom design for the text UI
Config.CustomIcon = 'screwdriver-wrench' -- Specify the Font Awesome icon class, set to empty string for no custom icon https://fontawesome.com/

--[[
█▀▀ █▀█ █▄░█ ▀█▀ █▀█ █▀█ █░░ █▀
█▄▄ █▄█ █░▀█ ░█░ █▀▄ █▄█ █▄▄ ▄█
]]

-- client/custom/misc/commands.lua
-- List for the fivem keybinds if you want to change it. https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
Config.HotKeys = true            -- bool : true or false, enable or disable the engine on/off system.
Config.UseCommandKeyDistance = 5 -- Distance to search nearby vehicles.

Config.Controls = {
    UseKey = 'L',                   -- Key to lock / unlock the car.
    HotwireControl = 'H',           -- Start Hotwiring.
    EngineControlNumber = 115,      -- Necessary for ControlerSupport numbers can be found here https://docs.fivem.net/docs/game-references/controls/
    EngineControl = 'IOM_WHEEL_UP', -- Key to start or stop the engine. (Mouse wheel up) for better compatibility with the qs-dispatch already using the G keybind. And also better roleplay
}

Config.JobPolice = 'police'

Config.Hotwire = true           -- bool : true or false, enable or disable the hotwire functions.
Config.UseHotwire = 'H'         -- Key to start hotwiring the car.
Config.GiveKeysOnHotwire = true -- bool : true or false, enable or disable the giving of the keys when stealing.
Config.ControlerSupport = true -- bool : true or false, enable or disable the support for controlers. (Engine toggling blocked)

Config.ToggleEngineRequireKeys = true
Config.EngineInteriorLights = true

Config.KeepEngineOn = false          -- bool : true or false, enable or disable the function to keep the engine on while leaving the vehicle.
Config.MaintainSteeringAngle = true -- bool : true or false, enable or disable the function to maintain angle of wheel steering, upon exiting vehicles. (Relies on the KeepEngineOn value)

Config.DisableControlAction = false -- bool : true or false, enable or disable the function to prevent from starting the cars using the w keybind.

-- ██╗░░██╗███████╗██╗░░░██╗░██████╗
-- ██║░██╔╝██╔════╝╚██╗░██╔╝██╔════╝
-- █████═╝░█████╗░░░╚████╔╝░╚█████╗░
-- ██╔═██╗░██╔══╝░░░░╚██╔╝░░░╚═══██╗
-- ██║░╚██╗███████╗░░░██║░░░██████╔╝
-- ╚═╝░░╚═╝╚══════╝░░░╚═╝░░░╚═════╝░

Config.VehicleKeysItem = 'vehiclekeys' -- Name of the item with metadata to open the vehicle.
-- creates an admin item for the admin to use to lock/unlock vehicles (set false to disable)
Config.AdminKeyItem = 'adminvehiclekey'
-- only admins can use the admin key
Config.OnlyAdminsCanUseAdminKey = true
Config.LockDistance = 20.0
Config.Anim = 'fob_click_fp'                        -- Modify the animation when opening or closing the vehicle here.
Config.Animdict = 'anim@mp_player_intmenu@key_fob@' -- Modify the animation when opening or closing the vehicle here.
Config.Keymodel = 'p_car_keys_01'                   -- Modify the prop when opening or closing the vehicle here.

--[[
█▀▀ █░█ █▀ ▀█▀ █▀█ █▀▄▀█   █▀ █▀█ █░█ █▄░█ █▀▄ █▀
█▄▄ █▄█ ▄█ ░█░ █▄█ █░▀░█   ▄█ █▄█ █▄█ █░▀█ █▄▀ ▄█
]]

-- Dependency of InteractSound needed for this to work !
-- link here : https://github.com/plunkettscott/interact-sound
--[[

1. -- * Place this sound on the interact-sound folder like shown below :

dir : interact-sound/client/html/sounds/carkeys.ogg

2. -- * Add the file name to the fxmanifest.lua file of the interact-sound ressource.

Like shown below (This is only an example, you could have more sounds listed here):

-- Files needed for NUI
-- DON'T FORGET TO ADD THE SOUND FILES TO THIS!
files {
    'client/html/index.html',
    'client/html/sounds/demo.ogg',
    '/client/html/sounds/carkeys.ogg',
}
]]

Config.Sounds = true                   -- bool : true or false, use of custom sounds through InteractSound
Config.SoundsDisableDefault = false    -- bool : true or false, disable or enable the use of Fivem Default sounds.
Config.SoundsVolume = 0.3              -- Distance on where the sound can be heard
Config.SoundsFileName = 'carkeys'      -- Name of the file
Config.SoundsDistance = 2              -- Distance on where the sound can be heard

Config.RentalPaperItem = 'rentalpaper' -- Name of the item with metadata for the rentalpaper.

--[[
█▀▀ █▀█ █▀█ █▄█   █▄▀ █▀▀ █▄█ █▀
█▄▄ █▄█ █▀▀ ░█░   █░█ ██▄ ░█░ ▄█
]]

Config.CopyKeysMenu = true         -- bool : true or false.
Config.OpenCopyKeys = 'E'          -- Key to open the key copy menu.
Config.MenuPlacement = 'top-left'  -- Position of `esx_menu_default`.
Config.CopyKeysCost = 5000          -- Price of the copies of the keys, you can use 0 and it will be free.
Config.InventoryCopyKeysCost = 2500 -- Price of the copies of the keys, you can use 0 and it will be free.
Config.CopyKeysLocations = {       -- List of stores to copy keys.
    vector3(-31.402076721191, -1647.4393310547, 29.282875061035)
}

Config.Blip = true      -- bool : true or false, disable or enable the copy keys blip.
Config.CopyKeysBlip = { -- Blip of the key copy spot.
    BlipName = 'Copy keys',
    BlipSprite = 186,
    BlipColour = 3,
    BlipScale = 0.8,
}

--[[
█▀ █░█ ▄▀█ █▀█ █▀▀ █▀▄ █▄▀ █▀▀ █▄█ █▀
▄█ █▀█ █▀█ █▀▄ ██▄ █▄▀ █░█ ██▄ ░█░ ▄█
]]

-- Configuration table for shared keys among employees or gang members
Config.SharedKeys = {
    -- Police job: Officers can lock/unlock any vehicle listed under 'vehicles'
    ['police'] = {     -- Job name
        vehicles = {   -- List of vehicle models accessible to this job
            'van_killer',  -- Example vehicle model
            'comni_killer',
            'vapid_killer',
            'Rebla_killer',
            'Astron_killer',
            'bravado_killer',
            'lampadati_killer',
            'Motor1_killer',
            'Motor2_killer',
            'vapidtruck_killer',
            'Declasse_killer',
        },
    },

    -- Ballas gang: Members can lock/unlock any vehicle listed under 'vehicles'
    ['ballas'] = {    -- Gang name
        vehicles = {  -- List of vehicle models accessible to this gang
            'albany', -- Example vehicle model
        }
    }
}

Config.Gangs = false


-- ██████╗░██╗░░░░░░█████╗░████████╗███████╗░██████╗
-- ██╔══██╗██║░░░░░██╔══██╗╚══██╔══╝██╔════╝██╔════╝
-- ██████╔╝██║░░░░░███████║░░░██║░░░█████╗░░╚█████╗░
-- ██╔═══╝░██║░░░░░██╔══██║░░░██║░░░██╔══╝░░░╚═══██╗
-- ██║░░░░░███████╗██║░░██║░░░██║░░░███████╗██████╔╝
-- ╚═╝░░░░░╚══════╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═════╝░

Config.PlateLetters = 3     -- Modify here the type of plate.
Config.PlateNumbers = 3     -- Modify here the type of plate.
Config.PlateUseSpace = true -- bool : true or false, modify the type of plate.
Config.TimeToChange = 5000  -- Time to change the plate (ms)

exports('GetPlateFormat', function()
    return {
        PlateLetters = Config.PlateLetters,
        PlateNumbers = Config.PlateNumbers,
        PlateUseSpace = Config.PlateUseSpace
    }
end)


-- ░██████╗██╗░░██╗░█████╗░██████╗░
-- ██╔════╝██║░░██║██╔══██╗██╔══██╗
-- ╚█████╗░███████║██║░░██║██████╔╝
-- ░╚═══██╗██╔══██║██║░░██║██╔═══╝░
-- ██████╔╝██║░░██║╚█████╔╝██║░░░░░
-- ╚═════╝░╚═╝░░╚═╝░╚════╝░╚═╝░░░░░

Config.PlateType = 'menu' -- Shop or Menu
-- Choose from the following options.
--[[
        'shop' (qs-shop)
        'menu' (menu defined above)
    ]]


-- Both of these items will be present in the shop or menu accessible through Peds.
-- For ESX account should be money, for qbcore it should be cash or bank.

-- Choose from the following options. For the account.
--[[
        'money' (ESX ONLY)
        'cash' (QBCORE ONLY)
        'bank' (BOTH)
    ]]

Config.PlateItem = 'plate' -- Name of the item plate.
Config.UseBootForPlate = false
Config.PlatePrice = {
    price = 500,
    account = Config.Framework == 'esx' and 'money' or 'cash',
}

Config.ChangePlateItem = 'screwdriver' -- Item required to use the plate.
Config.ChangePlateItemPrice = {
    price = 150,
    account = Config.Framework == 'esx' and 'money' or 'cash',
}


-- ████████╗██╗░░██╗███████╗███████╗████████╗░██████╗
-- ╚══██╔══╝██║░░██║██╔════╝██╔════╝╚══██╔══╝██╔════╝
-- ░░░██║░░░███████║█████╗░░█████╗░░░░░██║░░░╚█████╗░
-- ░░░██║░░░██╔══██║██╔══╝░░██╔══╝░░░░░██║░░░░╚═══██╗
-- ░░░██║░░░██║░░██║███████╗██║░░░░░░░░██║░░░██████╔╝
-- ░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═╝░░░░░░░░╚═╝░░░╚═════╝░

-- You can edit here : qs-vehiclekeys/config/hotwire.lua
-- Find the ox_lib skillCheck documentation listed below :
-- https://overextended.dev/ox_lib/Modules/Interface/Client/skillcheck

Config.MiniGameHotWireStyle = 'easy' -- Available Style 'easy' or 'hard'

--[[
'easy' = lib.skillCheck({'easy', 'easy', 'easy', 'easy', 'easy'})
'hard' = lib.skillCheck({'easy', 'easy', {areaSize=70, speedMultiplier=1}, 'easy'}, {'z', 'q', 's', 'd'})
]]

Config.TimeMin = 1000 -- Minimum time to hotwire
Config.TimeMax = 5000 -- Maximun time to hotwire
Config.ChanceToHotwire = 70

Config.WhitelistVehicles = { -- This list of vehicles won't have hotwire.
    'bmx',
    'cruiser',
    'enduro',
    'fixter',
    'scorcher',
    'tribike',
    'tribike2',
    'tribike3',
}

Config.StealVehiclesPeds = true     -- bool : true or false, if you enable this, players can target an NPC driver to receive their keys.
Config.StealVehiclesPedsPolice = 50 -- This is the chance for the NPC to call the police after being robbed (1-100).

-- List of weapons you can steal a car with.
Config.StealWeapons = {
    'weapon_pistol',
    'weapon_pistol_mk2',
    'weapon_combatpistol',
    'weapon_appistol',
    'weapon_stungun',
    'weapon_pistol50',
    'weapon_snspistol',
    'weapon_snspistol_mk2',
    'weapon_heavypistol',
    'weapon_vintagepistol',
    'weapon_flaregun',
    'weapon_marksmanpistol',
    'weapon_revolver',
    'weapon_revolver_mk2',
    'weapon_doubleaction',
    'weapon_raypistol',
    'weapon_ceramicpistol',
    'weapon_navyrevolver',
    'weapon_gadgetpistol',
    'weapon_stungun_mp',
    'weapon_pistolxm3',
    'weapon_microsmg',
    'weapon_smg',
    'weapon_smg_mk2',
    'weapon_assaultsmg',
    'weapon_combatpdw',
    'weapon_machinepistol',
    'weapon_minismg',
    'weapon_raycarbine',
    'weapon_tecpistol',
    'weapon_pumpshotgun',
    'weapon_pumpshotgun_mk2',
    'weapon_sawnoffshotgun',
    'weapon_assaultshotgun',
    'weapon_bullpupshotgun',
    'weapon_musket',
    'weapon_heavyshotgun',
    'weapon_dbshotgun',
    'weapon_autoshotgun',
    'weapon_combatshotgun',
    'weapon_assaultrifle',
    'weapon_assaultrifle_mk2',
    'weapon_carbinerifle',
    'weapon_carbinerifle_mk2',
    'weapon_advancedrifle',
    'weapon_specialcarbine',
    'weapon_specialcarbine_mk2',
    'weapon_bullpuprifle',
    'weapon_bullpuprifle_mk2',
    'weapon_compactrifle',
    'weapon_militaryrifle',
    'weapon_heavyrifle',
    'weapon_tacticalrifle',
    'weapon_mg',
    'weapon_combatmg',
    'weapon_combatmg_mk2',
    'weapon_gusenberg',
    'weapon_sniperrifle',
    'weapon_heavysniper',
    'weapon_heavysniper_mk2',
    'weapon_marksmanrifle',
    'weapon_marksmanrifle_mk2',
    'weapon_precisionrifle'
}

-- ░██████╗░██████╗░░██████╗
-- ██╔════╝░██╔══██╗██╔════╝
-- ██║░░██╗░██████╔╝╚█████╗░
-- ██║░░╚██╗██╔═══╝░░╚═══██╗
-- ╚██████╔╝██║░░░░░██████╔╝
-- ░╚═════╝░╚═╝░░░░░╚═════╝░


Config.GPS = true                     -- bool : true or false, enable or disable the GPS system.

Config.TrackerItem = 'vehicletracker' -- Name of the item with metadata for the Tracker.

Config.GPSItem = 'vehiclegps'         -- Name of the item with metadata for the GPS.

Config.RemoveGPSGame = true           -- bool : true or false, enable or disable mini-game to remove the GPS.

Config.GPSTime = 1000                 -- Time to use the GPS in milliseconds (1000 = 1 second).

Config.RemoveGPSTime = 1000           -- Time to remove the GPS in milliseconds (1000 = 1 second).

Config.RefreshGPSData = 10000         -- Time to refresh the GPS data in milliseconds (1000 = 1 second).

Config.GPSBlip = {
    Sprite = 161,      -- You can change the blip sprite here https://docs.fivem.net/docs/game-references/blips/#blips
    Colour = 1,        -- You can change the color of the blip here https://docs.fivem.net/docs/game-references/blips/#blip-colors
    Display = 2,       -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
    Scale = 2.5,       -- Size of the blip
    ShortRange = true, -- bool : true or false, enable or disable the short range of the blip.
    Time = 10000       -- Time for the blip to disappear (1000 = 1 second).
}

-- ██████╗░░█████╗░██╗░░░░░██╗░█████╗░███████╗
-- ██╔══██╗██╔══██╗██║░░░░░██║██╔══██╗██╔════╝
-- ██████╔╝██║░░██║██║░░░░░██║██║░░╚═╝█████╗░░
-- ██╔═══╝░██║░░██║██║░░░░░██║██║░░██╗██╔══╝░░
-- ██║░░░░░╚█████╔╝███████╗██║╚█████╔╝███████╗
-- ╚═╝░░░░░░╚════╝░╚══════╝╚═╝░╚════╝░╚══════╝

Config.ReqPolice = false                            -- bool : true or false, do you want police in your city to enable robberies?
Config.ReqPoliceCount = 1                           -- Minimum police to start a robbery.
Config.ReqJobPolice = 'police'                      -- Police job name.
Config.RefreshPolice = 1000                         -- Ammount of time to check por police count again, higher for more performance, don't use below 1000ms.

Config.LockpickItem = 'carlockpick'                 -- Item required to start lockpicking.
Config.LockpickKeepChance = 50                      -- Chance of not brekaing the lockpick item and keeping your item (1-100).
Config.LockpickFail = 1
Config.AdvancedLockpickItem = 'caradvancedlockpick' -- Don't need police to lockpick
Config.RemoveAdvancedLockpick = true                -- bool : true or false, if you enable this option, the advanced lockpick item will be removed when the lockpick is broken.

Config.LockpickAlarm = true                         -- bool : true or false, if you enable this option, the policemen will receive dispatch when the alarm sounds.
Config.StartAlarmChance = 50                        -- Chance of the alarm going off, remember this will trigger dispatch to `Config.ReqJobPolice` (1-100).

Config.LockpickWhitelist = {                        -- These vehicles can't be lockpicked.
    'bmx',
    'cruiser',
    'enduro',
    'fixter',
    'scorcher',
    'tribike',
    'tribike2',
    'tribike3',
}

-- ██████╗░███████╗██████╗░░██████╗
-- ██╔══██╗██╔════╝██╔══██╗██╔════╝
-- ██████╔╝█████╗░░██║░░██║╚█████╗░
-- ██╔═══╝░██╔══╝░░██║░░██║░╚═══██╗
-- ██║░░░░░███████╗██████╔╝██████╔╝
-- ╚═╝░░░░░╚══════╝╚═════╝░╚═════╝░

-- Ped for copy the keys.
Config.CopyKeysNpcName = 's_m_y_xmech_01'
Config.CopyKeysPedLocation = vec4(-31.402076721191, -1647.4393310547, 29.282875061035, 68.450233459473)

-- Ped for buying the plate item.
Config.PlateNpcName = 'mp_m_waremech_01'
Config.PlateNPCLocation = vec4(-40.4748, -1674.6696, 29.4845, 153.7328)

-- Distance you want the ped to render.
Config.PedRenderDistance = 10.0

-- ███████╗███╗   ███╗ █████╗ ██████╗ ████████╗██████╗ ██╗  ██╗ ██████╗ ███╗   ██╗███████╗
-- ██╔════╝████╗ ████║██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██║  ██║██╔═══██╗████╗  ██║██╔════╝
-- ███████╗██╔████╔██║███████║██████╔╝   ██║   ██████╔╝███████║██║   ██║██╔██╗ ██║█████╗
-- ╚════██║██║╚██╔╝██║██╔══██║██╔══██╗   ██║   ██╔═══╝ ██╔══██║██║   ██║██║╚██╗██║██╔══╝
-- ███████║██║ ╚═╝ ██║██║  ██║██║  ██║   ██║   ██║     ██║  ██║╚██████╔╝██║ ╚████║███████╗
-- ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝

Config.Smartphone = false                   -- bool : true or false, if you have qs-smartphone, you can enable this function.
Config.ChargeCommand = 'chargephone'        -- Command to load or unload your qs-smartphone.
Config.ChargeStatusCommand = 'chargestatus' -- Command to display or hide the battery percentage while charging.

-- ██████╗░██╗░██████╗██████╗░░█████╗░████████╗░█████╗░██╗░░██╗
-- ██╔══██╗██║██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██║░░██║
-- ██║░░██║██║╚█████╗░██████╔╝███████║░░░██║░░░██║░░╚═╝███████║
-- ██║░░██║██║░╚═══██╗██╔═══╝░██╔══██║░░░██║░░░██║░░██╗██╔══██║
-- ██████╔╝██║██████╔╝██║░░░░░██║░░██║░░░██║░░░╚█████╔╝██║░░██║
-- ╚═════╝░╚═╝╚═════╝░╚═╝░░░░░╚═╝░░╚═╝░░░╚═╝░░░░╚════╝░╚═╝░░╚═╝

Config.Dispatch = 'default' -- Options available : "qs", "qs-smartphone", "default"

-- ██████╗░██╗░█████╗░░██████╗░███╗░░██╗░█████╗░░██████╗████████╗██╗░█████╗░
-- ██╔══██╗██║██╔══██╗██╔════╝░████╗░██║██╔══██╗██╔════╝╚══██╔══╝██║██╔══██╗
-- ██║░░██║██║███████║██║░░██╗░██╔██╗██║██║░░██║╚█████╗░░░░██║░░░██║██║░░╚═╝
-- ██║░░██║██║██╔══██║██║░░╚██╗██║╚████║██║░░██║░╚═══██╗░░░██║░░░██║██║░░██╗
-- ██████╔╝██║██║░░██║╚██████╔╝██║░╚███║╚█████╔╝██████╔╝░░░██║░░░██║╚█████╔╝
-- ╚═════╝░╚═╝╚═╝░░╚═╝░╚═════╝░╚═╝░░╚══╝░╚════╝░╚═════╝░░░░╚═╝░░░╚═╝░╚════╝░

Config.Diagnostic = true          -- bool : Set to 'true' to enable the diagnostic features; 'false' to disable them.
Config.DiagnosticJob = 'mechanic' -- string or string[] or table<string, number> : Specify which job(s) are allowed to use the diagnostic features. Can be a single job as a string, an array of job strings, or a table of job strings with priority levels.
Config.NeedKey = false            -- bool : Set to 'true' to require the key for using diagnostic functions; 'false' to allow diagnostics without the key.
Config.Fahrenheit = false         -- bool : Set to 'true' to display temperature in Fahrenheit (°F) in the diagnostic menu; 'false' to display it in Celsius (°C).

Config.TintsJob = 'police'        -- Which job will be allowed to use of the measurement of the windows tints. string or string[] or table<string, number>

--[[
█▀▀ █░█ █▀▀ █░░
█▀░ █▄█ ██▄ █▄▄
]]

--  This function automatically detects your fuel script as long as it is named
--  according to one of the expected names listed below. If no fuel script is
--  detected, it will return 'LegacyFuel' and print an error message indicating that
--  the script may not work properly.

function detectFuel()
    local function checkResource(name)
        return GetResourceState(name) == 'started'
    end

    local cdnFuel = checkResource('cdn-fuel')
    local esxSnaFuel = checkResource('esx-sna-fuel')
    local legacyFuel = checkResource('LegacyFuel')
    local ljFuel = checkResource('lj-fuel')
    local okokGasStation = checkResource('okokGasStation')
    local oxFuel = checkResource('ox_fuel')
    local psFuel = checkResource('ps-fuel')
    local qsFuelstations = checkResource('qs-fuelstations')
    local tiFuel = checkResource('ti_fuel')
    local xfuel = checkResource('x-fuel')

    if cdnFuel then
        if Config.Debug then
            print('DEBUG: Detected fuel script: cdn-fuel')
        end
        return 'cdn-fuel'
    elseif esxSnaFuel then
        if Config.Debug then
            print('DEBUG: Detected fuel script: esx-sna-fuel')
        end
        return 'esx-sna-fuel'
    elseif legacyFuel then
        if Config.Debug then
            print('DEBUG: Detected fuel script: LegacyFuel')
        end
        return 'LegacyFuel'
    elseif ljFuel then
        if Config.Debug then
            print('DEBUG: Detected fuel script: lj-fuel')
        end
        return 'lj-fuel'
    elseif okokGasStation then
        if Config.Debug then
            print('DEBUG: Detected fuel script: okokGasStation')
        end
        return 'okokGasStation'
    elseif oxFuel then
        if Config.Debug then
            print('DEBUG: Detected fuel script: ox_fuel')
        end
        return 'ox_fuel'
    elseif psFuel then
        if Config.Debug then
            print('DEBUG: Detected fuel script: ps-fuel')
        end
        return 'ps-fuel'
    elseif qsFuelstations then
        if Config.Debug then
            print('DEBUG: Detected fuel script: qs-fuelstations')
        end
        return 'qs-fuelstations'
    elseif tiFuel then
        if Config.Debug then
            print('DEBUG: Detected fuel script: ti_fuel')
        end
        return 'ti_fuel'
    elseif xfuel then
        if Config.Debug then
            print('DEBUG: Detected fuel script: x-fuel')
        end
        return 'x-fuel'
    else
        if Config.Debug then
            print('DEBUG: Error: No fuel script has been detected. The script will probably not work. The diagnostic module only will be affected.')
        end
        return 'default'
    end
end

Config.Fuel = detectFuel()


--[[
▄▀█ █▄░█ █▀▀ █░█ █▀█ █▀█
█▀█ █░▀█ █▄▄ █▀█ █▄█ █▀▄
]]

Config.Anchor = true -- bool : Set to 'true' to enable the anchor features; 'false' to disable them.
Config.AnchorKeybind = true

--[[
█▀▄▀█ █ █▀ █▀▀ █▀
█░▀░█ █ ▄█ █▄▄ ▄█
]]

-- Configuration Options
Config.df_nocardespawn = false -- bool : Set to 'true' if you want to disable car despawning; 'false' to allow it.
Config.AdvancedParking = false -- bool : Set to 'true' to enable advanced parking features; 'false' to disable them.
Config.OrigenParking = false   -- bool : Set to 'true' to enable Origen Parking integration; 'false' to disable it.

--[[
█▀▄ █▀▀ █▄▄ █░█ █▀▀
█▄▀ ██▄ █▄█ █▄█ █▄█
]]

Config.Debug = false                   -- bool : Set to 'true' to enable debug mode for more detailed internal script logging; 'false' to disable it.
Config.Eventprefix = 'qs-vehiclekeys' -- string : The event prefix used by the script. It is not recommended to change this as it may cause the script to break.
