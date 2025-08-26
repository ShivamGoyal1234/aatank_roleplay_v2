--[[
    Welcome to the **Advanced Shops Configuration**!

    This configuration file includes the essential parameters to personalize and fine-tune your **advancedshops** system. Before making any modifications, we strongly recommend reviewing the corresponding sections of the documentation linked below. It provides step-by-step guidance and detailed explanations for every configurable feature.

    The settings provided here are built for adaptability. You are encouraged to tailor them to match your server’s framework and economy, ensuring a smooth and immersive shopping experience for your players.

    Most editable configurations can be found in the **client/custom/** and **server/custom/** directories, allowing for a clean and organized setup process.

    🛒 **Direct Documentation Link:**
    For full details and usage instructions, visit the official documentation here: https://docs.quasar-store.com/
]]

Config = Config or {}
Locales = Locales or {}

--[[
    Choose your preferred language!

    In this section, you can select the main language for your asset. We have a wide
    selection of default languages available, located in the locales/* folder.

    If your language is not listed, don't worry! You can easily create a new one
    by adding a new file in the locales folder and customizing it to your needs.

    🌐 Default languages available:
        'ar'     -- Arabic
        'bg'     -- Bulgarian
        'ca'     -- Catalan
        'cs'     -- Czech
        'da'     -- Danish
        'de'     -- German
        'el'     -- Greek
        'en'     -- English
        'es'     -- Spanish
        'fa'     -- Persian
        'fr'     -- French
        'hi'     -- Hindi
        'hu'     -- Hungarian
        'it'     -- Italian
        'ja'     -- Japanese
        'ko'     -- Korean
        'nl'     -- Dutch
        'no'     -- Norwegian
        'pl'     -- Polish
        'pt'     -- Portuguese
        'ro'     -- Romanian
        'ru'     -- Russian
        'sl'     -- Slovenian
        'sv'     -- Swedish
        'th'     -- Thai
        'tr'     -- Turkish
        'zh-CN'  -- Chinese (Simplified)
        'zh-TW'  -- Chinese (Traditional)

    After selecting your preferred language, be sure to save your changes and test
    the asset to ensure everything works as expected!
]]

Config.Language = 'en'

Config.UseTarget = false                                    -- Set to true to enable targeting with either 'qb-target' or 'ox_target', or false to disable entirely.
Config.InventoryFolder = 'nui://qs-inventory/html/images/' -- Images will be taken from the inventory.

--[[
    Framework Detection and Configuration Guide for Advanced Shops

    The advancedshops system is designed to automatically detect whether your server uses `qb-core`, `es_extended`, or `qbx_core`
    as its main framework, assigning it to `Config.Framework` accordingly. However, if you have renamed
    these resources or are using a customized framework setup, manual configuration may be required.

    To configure manually:
        1. Clear the automatic detection logic by removing the current value assigned to `Config.Framework`.
        2. Set it manually to the name of your custom or modified framework.
        3. Adjust any framework-dependent logic inside the script's client and server files accordingly.

    Warning:
    ⚠️ The automatic detection is optimized for standard framework setups. Avoid modifying this section
    unless you fully understand your framework structure, as incorrect edits can cause critical issues.

    Make sure your base framework (`qb-core`, `es_extended`, `qbx_core`, or equivalent) is properly started
    before advancedshops, to ensure correct integration and functionality.
]]

local frameworks = {
    ['es_extended'] = 'esx',
    ['qb-core'] = 'qb',
}

Config.Framework = DependencyCheck(frameworks) or 'none'

--[[
    Shop Configuration Overview

    This section defines all shop locations and their respective settings. Each shop can have:
    - A unique name and label.
    - Blip configuration for the map.
    - Job and grade restrictions (optional).
    - Multiple item categories, each with its own list of products, prices, and descriptions.
    - Ped model and animation for visual immersion.
    - Multiple physical coordinates to spawn shop NPCs.

    💡 You can create general stores, hardware shops, weapon shops, or even job-restricted shops like police armories. Simply customize the `categories` and `items` per location.

    Tip: For job-restricted shops, use `jobName` or the `jobs` and `grades` options to control access.
]]


Config.Shops = {
    {

        
        name = '247market',
        label = '[E] - 24/7 Market',
        blip = true,
        blipSprite = 52,
        blipColor = 2,
        blipScale = 0.6,
        -- requiredLicense = 'police_license',
        -- jobs = { 'police' },
        -- grades = { 2, 3, 4 },
        categories = {
            [1] = {
                name = 'General',
                description = 'Everyday Essentials',
                icon = 'fa-solid fa-wallet',
                items = {
                    { name = 'water_bottle',  label = 'Water',         perPrice = 150, description = 'Refreshment' },
                    { name = 'sandwich',      label = 'Sandwich',      perPrice = 150, description = 'Quick Meal' },
                    { name = 'snikkel_candy', label = 'Snikkel Candy', perPrice = 150, description = 'Sweet Snack' },
                    { name = 'tosti',         label = 'Tosti',         perPrice = 150, description = 'Toasted Snack' },
                    -- { name = 'whiskey',       label = 'Whiskey',       perPrice = 400, description = 'Alcohol' },
                    { name = 'lighter',       label = 'Lighter',       perPrice = 200, description = 'For Lighting' },
                    -- { name = 'beer',          label = 'Beer',          perPrice = 350, description = 'Alcohol' },
                    { name = 'kurkakola',          label = 'Cola',          perPrice = 150, description = 'Soft Drink' },
                    { name = 'twerks_candy',  label = 'Twerks Candy',  perPrice = 150, description = 'Sweet Snack' }
                }
            },
            [2] = {
                name = 'Medical',
                description = 'Health Supplies',
                icon = 'fa-solid fa-notes-medical',
                items = {
                    { name = 'bandage', label = 'Bandage', perPrice = 150, description = 'First Aid' }
                }
            },
            -- [3] = {
            --     name = 'Alcohol',
            --     description = 'Alcoholic Beverages',
            --     icon = 'fa-solid fa-wine-bottle',
            --     items = {
            --         { name = 'vodka',   label = 'Vodka',   perPrice = 150, description = 'Spirits' },
            --         { name = 'whiskey', label = 'Whiskey', perPrice = 150, description = 'Spirits' },
            --         { name = 'beer',    label = 'Beer',    perPrice = 150, description = 'Beer' }
            --     }
            -- },
            [4] = {
                name = 'Snacks',
                description = 'Snacks & Sweets',
                icon = 'fa-solid fa-cookie-bite',
                items = {
                    { name = 'tosti',         label = 'Tosti',         perPrice = 150, description = 'Toasted Snack' },
                    { name = 'snikkel_candy', label = 'Snikkel Candy', perPrice = 150, description = 'Sweet Snack' },
                    { name = 'twerks_candy',  label = 'Twerks Candy',  perPrice = 150, description = 'Sweet Snack' }
                }
            }
        },
        pedHash = 'mp_m_shopkeep_01', -- You can delete this so the ped does not appear.
        scenario = 'WORLD_HUMAN_STAND_MOBILE',
        coords = {
            { ped = nil, coords = vector4(24.47, -1346.62, 29.5, 271.66) },
            { ped = nil, coords = vector4(-3039.54, 584.38, 7.91, 17.27) },
            { ped = nil, coords = vector4(-3242.97, 1000.01, 12.83, 357.57) },
            { ped = nil, coords = vector4(1728.07, 6415.63, 35.04, 242.95) },
            { ped = nil, coords = vector4(1959.82, 3740.48, 32.34, 301.57) },
            { ped = nil, coords = vector4(549.13, 2670.85, 42.16, 99.39) },
            { ped = nil, coords = vector4(2677.47, 3279.76, 55.24, 335.08) },
            { ped = nil, coords = vector4(2556.66, 380.84, 108.62, 356.67) },
            { ped = nil, coords = vector4(372.66, 326.98, 103.57, 253.73) }
        }
    },
    {
        name = 'gasoline',
        label = '[E] - LTD Gasoline',
        blip = true,
        blipSprite = 52,
        blipColor = 2,
        blipScale = 0.6,
        -- requiredLicense = 'police_license',
        -- jobs = { 'police' },
        -- grades = { 2, 3, 4 },
        categories = {
            [1] = {
                name = 'General',
                description = 'Everyday Essentials',
                icon = 'fa-solid fa-wallet',
                items = {
                    { name = 'water_bottle',  label = 'Water',         perPrice = 150, description = 'Refreshment' },
                    { name = 'sandwich',      label = 'Sandwich',      perPrice = 150, description = 'Quick Meal' },
                    { name = 'snikkel_candy', label = 'Snikkel Candy', perPrice = 150, description = 'Sweet Snack' },
                    -- { name = 'tosti',         label = 'Tosti',         perPrice = 150, description = 'Toasted Snack' },
                    -- { name = 'whiskey',       label = 'Whiskey',       perPrice = 400, description = 'Alcohol' },
                    { name = 'lighter',       label = 'Lighter',       perPrice = 200, description = 'For Lighting' },
                    -- { name = 'beer',          label = 'Beer',          perPrice = 350, description = 'Alcohol' },
                    { name = 'kurkakola',          label = 'Cola',          perPrice = 150, description = 'Soft Drink' },
                    { name = 'twerks_candy',  label = 'Twerks Candy',  perPrice = 150, description = 'Sweet Snack' }
                }
            },
            -- [2] = {
            --     name = 'Medical',
            --     description = 'Health Supplies',
            --     icon = 'fa-solid fa-notes-medical',
            --     items = {
            --         { name = 'bandage', label = 'Bandage', perPrice = 100, description = 'First Aid' }
            --     }
            -- },
            -- [3] = {
            --     name = 'Alcohol',
            --     description = 'Alcoholic Beverages',
            --     icon = 'fa-solid fa-wine-bottle',
            --     items = {
            --         { name = 'vodka',   label = 'Vodka',   perPrice = 150, description = 'Spirits' },
            --         { name = 'whiskey', label = 'Whiskey', perPrice = 150, description = 'Spirits' },
            --         { name = 'beer',    label = 'Beer',    perPrice = 150, description = 'Beer' }
            --     }
            -- },
            [2] = {
                name = 'Snacks',
                description = 'Snacks & Sweets',
                icon = 'fa-solid fa-cookie-bite',
                items = {
                    { name = 'tosti',         label = 'Tosti',         perPrice = 150, description = 'Toasted Snack' },
                    { name = 'snikkel_candy', label = 'Snikkel Candy', perPrice = 150, description = 'Sweet Snack' },
                    { name = 'twerks_candy',  label = 'Twerks Candy',  perPrice = 150, description = 'Sweet Snack' }
                }
            }
        },
        pedHash = 'mp_m_shopkeep_01', -- You can delete this so the ped does not appear.
        scenario = 'WORLD_HUMAN_STAND_MOBILE',
        coords = {
            { ped = nil, coords = vector4(-47.02, -1758.23, 29.42, 45.05) },
            { ped = nil, coords = vector4(-706.06, -913.97, 19.22, 88.04) },
            { ped = nil, coords = vector4(-1820.02, 794.03, 138.09, 135.45) },
            { ped = nil, coords = vector4(1164.71, -322.94, 69.21, 101.72) },
            { ped = nil, coords = vector4(1697.87, 4922.96, 42.06, 324.71) }
        }
    },

    
    {
        name = 'robs',
        label = "[E] - Rob's Liqour",
        blip = true,
        blipSprite = 52,
        blipColor = 2,
        blipScale = 0.7,
        -- requiredLicense = 'police_license',
        -- jobs = { 'police' },
        -- grades = { 2, 3, 4 },
        categories = {
            [1] = {
                name = 'General',
                description = '24/7',
                icon = 'fa-solid fa-wine-bottle',
                items = {
                    { name = 'water_bottle',  label = 'Water',         perPrice = 150, description = 'Drinks' },
                    -- { name = 'sandwich',      label = 'Sandwich',      perPrice = 150, description = 'Food' },
                    -- { name = 'snikkel_candy', label = 'Snikkel Candy', perPrice = 150, description = 'General' },
                    -- { name = 'tosti',         label = 'Tosti',         perPrice = 150, description = 'General' },
                    { name = 'beer',          label = 'Beer',          perPrice = 350, description = 'Alcohol' },
                    { name = 'kurkakola',          label = 'Cola',          perPrice = 150, description = 'Drinks' },
                    -- { name = 'twerks_candy',  label = 'Twerks Candy',  perPrice = 150, description = 'Candy' },
                    { name = 'whiskey',       label = 'Whiskey',       perPrice = 400, description = 'Alcohol' }
                }
            },
            -- [2] = {
            --     name = 'Snacks',
            --     description = 'Snacks & Sweets',
            --     icon = 'fa-solid fa-cookie-bite',
            --     items = {
            --         { name = 'tosti',         label = 'Tosti',         perPrice = 200, description = 'Snacks' },
            --         { name = 'snikkel_candy', label = 'Snikkel Candy', perPrice = 200, description = 'Candy' },
            --         { name = 'twerks_candy',  label = 'Twerks Candy',  perPrice = 150, description = 'Candy' }
            --     }
            -- }
        },
        pedHash = 'mp_m_shopkeep_01', -- You can delete this so the ped does not appear.
        scenario = 'WORLD_HUMAN_STAND_MOBILE',
        coords = {
            { ped = nil, coords = vector4(-1221.58, -908.15, 12.33, 35.49) },
            { ped = nil, coords = vector4(-1486.59, -377.68, 40.16, 139.51) },
            { ped = nil, coords = vector4(-2966.39, 391.42, 15.04, 87.48) },
            { ped = nil, coords = vector4(1165.17, 2710.88, 38.16, 179.43) },
            { ped = nil, coords = vector4(1134.2, -982.91, 46.42, 277.24) }
        }
    },
    {
        name = 'hardware',
        label = '[E] - Hardware and Tools',
        blip = true,
        blipSprite = 402,
        blipColor = 3,
        blipScale = 0.8,
        -- requiredLicense = 'police_license',
        -- jobs = { 'police' },
        -- grades = { 2, 3, 4 },
        categories = {
            [1] = {
                name = 'General',
                description = 'Hardware Tools',
                icon = 'fa-solid fa-wallet',
                items = {
                    -- { name = 'lockpick',       label = 'Lockpick',        perPrice = 200, description = 'Tools' },
                    { name = 'weapon_wrench',  label = 'Wrench',          perPrice = 350, description = 'Tools' },
                    { name = 'weapon_hammer',  label = 'Hammer',          perPrice = 350, description = 'Tools' },
                    { name = 'screwdriverset', label = 'Screwdriver Set', perPrice = 350, description = 'Tools' },
                    { name = 'cleaningkit',    label = 'Cleaning Kit',    perPrice = 450, description = 'Tools' },
                    { name = 'duffle1',    label = 'Small Bag',    perPrice = 10000, description = 'Tools' },
                    { name = 'duffle2',    label = 'Traveler Bag',    perPrice = 20000, description = 'Tools' },
                }
            },
            [2] = {
                name = 'Fireworks',
                description = 'Fireworks for Fun',
                icon = 'fa-solid fa-fire',
                items = {
                    { name = 'firework1', label = 'Firework 1', perPrice = 50, description = 'Fun' },
                    { name = 'firework2', label = 'Firework 2', perPrice = 50, description = 'Fun' },
                    { name = 'firework3', label = 'Firework 3', perPrice = 50, description = 'Fun' },
                    { name = 'firework4', label = 'Firework 4', perPrice = 50, description = 'Fun' }
                }
            },
            [3] = {
                name = 'Repair Kits',
                description = 'Repair and Maintenance',
                icon = 'fa-solid fa-toolbox',
                items = {
                    { name = 'repairkit', label = 'Repair Kit', perPrice = 25000, description = 'Maintenance' }
                }
            }
        },
        pedHash = 'mp_m_waremech_01', -- You can delete this so the ped does not appear.
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        coords = {
            { ped = nil, coords = vector4(45.68, -1749.04, 29.61, 53.13) },
            { ped = nil, coords = vector4(2747.71, 3472.85, 55.67, 255.08) },
            { ped = nil, coords = vector4(-421.83, 6136.13, 31.88, 228.2) }
        }
    },
    {
        name = 'shopammunation',
        label = '[E] - Ammunation',
        blip = true,
        blipSprite = 110,
        blipColor = 5,
        blipScale = 0.7,
        -- requiredLicense = 'police_license',
        -- jobs = { 'police' },
        -- grades = { 2, 3, 4 },
        categories = {
            [1] = {
                name = 'General',
                description = 'Ammunations',
                icon = 'fa-solid fa-gun',
                items = {
                    { name = 'weapon_knife',         label = 'Knife',          perPrice = 1200,  description = 'General' },
                    { name = 'weapon_bat',           label = 'Bat',            perPrice = 1500,  description = 'General' },
                    { name = 'weapon_hatchet',       label = 'Hatchet',        perPrice = 1300,  description = 'General' },
                    -- { name = 'weapon_pistol',        label = 'Pistol',         perPrice = 2500, description = 'General' },
                    -- { name = 'weapon_snspistol',     label = 'SNS Pistol',     perPrice = 1500, description = 'General' },
                    -- { name = 'weapon_vintagepistol', label = 'Vintage Pistol', perPrice = 4000, description = 'General' }
                }
            },
            -- [2] = {
            --     name = 'Ammunition',
            --     description = 'Ammunations for Weapons',
            --     icon = 'fa-solid fa-list',
            --     -- items = {
            --     --     { name = 'pistol_ammo',  label = 'Pistol Ammo',  perPrice = 250, description = 'Ammunition' },
            --     --     { name = 'rifle_ammo',   label = 'Rifle Ammo',   perPrice = 350, description = 'Ammunition' },
            --     --     { name = 'smg_ammo',     label = 'SMG Ammo',     perPrice = 300, description = 'Ammunition' },
            --     --     { name = 'shotgun_ammo', label = 'Shotgun Ammo', perPrice = 400, description = 'Ammunition' },
            --     --     { name = 'mg_ammo',      label = 'MG Ammo',      perPrice = 450, description = 'Ammunition' }
            --     -- }
            -- }
        },
        pedHash = 's_m_y_ammucity_01', -- You can delete this so the ped does not appear.
        scenario = 'WORLD_HUMAN_COP_IDLES',
        coords = {
            { ped = nil, coords = vector4(-3173.31, 1088.85, 20.84, 244.18) },
            { ped = nil, coords = vector4(-1304.19, -395.12, 36.7, 75.03) },
            { ped = nil, coords = vector4(841.92, -1035.32, 28.19, 1.56) },
            { ped = nil, coords = vector4(-1118.59, 2700.05, 18.55, 221.89) },
            { ped = nil, coords = vector4(2567.48, 292.59, 108.73, 349.68) },
            { ped = nil, coords = vector4(23.0, -1105.67, 29.8, 162.91) },
            { ped = nil, coords = vector4(253.63, -51.02, 69.94, 72.91) },
            { ped = nil, coords = vector4(-331.23, 6085.37, 31.45, 228.02) },
            { ped = nil, coords = vector4(1692.67, 3761.38, 34.71, 227.65) },
            { ped = nil, coords = vector4(809.68, -2159.13, 29.62, 1.43) },
            { ped = nil, coords = vector4(-661.96, -933.53, 21.83, 177.05) }
        }
    },
    {
        name = 'weed',
        label = '[E] - Smoke On The Water',
        blip = true,
        blipSprite = 140,
        blipColor = 0,
        blipScale = 0.6,
        -- requiredLicense = 'police_license',
        -- jobs = { 'police' },
        -- grades = { 2, 3, 4 },
        categories = {
            [1] = {
                name = 'General',
                description = 'Ammunations',
                icon = 'fa-solid fa-cannabis',
                items = {
                    { name = 'weapon_knife',   label = 'Knife',          perPrice = 1200, description = 'General' },
                    { name = 'joint',          label = 'Joint',          perPrice = 150,  description = 'Weed' },
                    { name = 'weapon_poolcue', label = 'Pool Cue',       perPrice = 500, description = 'Weed Accessories' },
                    -- { name = 'weed_nutrition', label = 'Weed Nutrition', perPrice = 20,  description = 'Weed Accessories' },
                    -- { name = 'empty_weed_bag', label = 'Empty Weed Bag', perPrice = 10,   description = 'Weed Packaging' },
                    { name = 'rolling_paper',  label = 'Rolling Paper',  perPrice = 30,   description = 'Weed Accessories' }
                }
            }
        },
        pedHash = 'a_m_y_hippy_01', -- You can delete this so the ped does not appear.
        scenario = 'WORLD_HUMAN_AA_SMOKE',
        coords = {
            { ped = nil, coords = vector4(-1168.26, -1573.2, 4.66, 105.24) }
        }
    },
    {
        name = 'blackmark',
        label = '[E] - Illicit Goods & Tools',
        blip = false,
        -- requiredLicense = 'police_license',
        -- jobs = { 'police' },
        -- grades = { 2, 3, 4 },
        categories = {
            [1] = {
                name = 'General',
                description = '24/7 Access',
                icon = 'fa-solid fa-clipboard',
                -- items = {
                --     { name = 'pistol_ammo',   label = 'Pistol Ammo',    perPrice = 150,  description = 'PD Items' },
                --     {
                --         name = 'security_card_01',
                --         label = 'Security Card 01',
                --         perPrice = 5000,
                --         description = 'Access Card'
                --     },
                --     {
                --         name = 'security_card_02',
                --         label = 'Security Card 02',
                --         perPrice = 5000,
                --         description = 'Access Card'
                --     },
                --     { name = 'electronickit', label = 'Electronic Kit', perPrice = 5000, description = 'Hacking Tools' },
                --     { name = 'thermite',      label = 'Thermite',       perPrice = 5000, description = 'Explosive' },
                --     { name = 'drill',         label = 'Drill',          perPrice = 5000, description = 'Drilling Tool' },
                --     { name = 'radioscanner',  label = 'Radio Scanner',  perPrice = 5000, description = 'Listening Device' },
                --     { name = 'cryptostick',   label = 'Crypto Stick',   perPrice = 5000, description = 'Cryptographic Tool' },
                --     { name = 'joint',         label = 'Joint',          perPrice = 5000, description = 'Weed Product' },
                --     { name = 'crack_baggy',   label = 'Crack Baggy',    perPrice = 5000, description = 'Crack Product' },
                --     { name = 'coke_brick',    label = 'Coke Brick',     perPrice = 5000, description = 'Coke Product' },
                --     { name = 'weed_brick',    label = 'Weed Brick',     perPrice = 5000, description = 'Weed Product' },
                --     {
                --         name = 'coke_small_brick',
                --         label = 'Coke Small Brick',
                --         perPrice = 5000,
                --         description = 'Coke Product'
                --     },
                --     { name = 'oxy',  label = 'Oxy',  perPrice = 5000, description = 'Oxy Product' },
                --     { name = 'meth', label = 'Meth', perPrice = 5000, description = 'Meth Product' }
                -- }
            }
        },
        pedHash = 'a_m_y_smartcaspat_01', -- You can delete this so the ped does not appear.
        scenario = 'WORLD_HUMAN_AA_SMOKE',
        coords = {
            { ped = nil, coords = vector4(-594.7032, -1616.3647, 33.0105, 170.6846) }
        }
    },
    -- Job Stores
    {
        name = 'lspdmarket',
        label = '[E] - LSPD Ammunation',
        blip = false,
        -- requiredLicense = 'police_license',
        jobs = { 'police' },
        -- grades = { 2, 3, 4 },
        categories = {
            [1] = {
                name = 'General',
                description = 'Random items',
                icon = 'fa-solid fa-gun',
                items = {

                    -- {name = 'evidence_camera',label = 'Evidence Camera', description = 'PD Evidence Camera', perPrice = 50},
                    {name = 'megaphone',label = 'Megaphone', description = 'PD Megaphone', perPrice = 50},
                    -- {name = 'wheel_clamp',label = 'Wheel Clamp', description = 'PD Wheel Clamp', perPrice = 50},
                    -- {name = 'breathalyzer',label = 'Breathalyzer', description = 'PD Breathalyzer', perPrice = 50},
                     {name = 'bandage',label = 'Bandage', description = 'Bandage', perPrice = 50},
                     {name = 'ifaks',label = 'Ifaks', description = 'PD Lover ', perPrice = 50},
                    -- {name = 'tracking_band',label = 'GPS Band', description = 'PD GPS Band', perPrice = 50},
                    -- {name = 'spike_strip',label = 'Spike strip', description = 'PD Spike strip', perPrice = 50},
                    -- {name = 'gps',label = 'GPS', description = 'PD GPS', perPrice = 50},
                    {name = 'police_stormram',label = 'Storman', description = 'PD Storman', perPrice = 50},
                    {name = 'empty_evidence_bag', label = 'Evidence Bag', description = 'Empty Evidence Bag for Collect evidence', perPrice = 50},
                    {name = 'specialbadge', label = 'PD Badge', description = 'Special Badge of Law Enforcements', perPrice = 50},
                    {name = 'dslrcamera',label = 'Camera', description = 'PD Camera', perPrice = 50},
                    {name = 'radio',label = 'Radio', description = 'PD Radio', perPrice = 50},
                    {name = 'goverment_bodycam',label = 'Government Issued Bodycam', description = 'PD Bodycam', perPrice = 50},
                    {name = 'handcuffs',label = 'Handcuffs', description  = 'PD Handcuffs', perPrice = 50},
                    {name = 'heavyarmor',label = 'Strong Bulletproof Vest', description = 'PD Strong Bulletproof Vest', perPrice = 100},
                    {name = 'weapon_flashlight',label = 'Flashlight', description = 'PD Flashlight', perPrice = 100},
                    {name = 'weapon_nightstick',label = 'Nightstick', description = 'PD Nightstick', perPrice = 100, metadata = {registered = true, serial = 'POL'}},
                    {name = 'weapon_stungun',label = 'Taser', description = 'PD Taser', perPrice = 1000, metadata = {registered = true, serial = 'POL'}},
                    -- weapon
                    --{name = 'weapon_combatpistol',label = 'Combat Pistol', description = 'PD Combat Pistol', perPrice = 1000, license = 'weapon', grade = 1, metadata = {registered = true, serial = 'POL'}},   
                    -- Ammo
                    --{name = 'pistol_ammo',label = 'Pistol ammo', description = 'PD Pistol ammo', perPrice = 5},
            
                
                
                
                
                
                
                }
            },
        },
        pedHash = 'mp_m_securoguard_01', -- You can delete this so the ped does not appear.
        scenario = 'WORLD_HUMAN_COP_IDLES',
        coords = {
            { ped = nil, coords = vector4(-601.12, -412.74, 35.17, 273.98) }
        }
    },
       {
        name = 'lspdmarket1',
        label = '[E] - LSPD Food & Drinks',
        blip = false,
        -- requiredLicense = 'police_license',
        jobs = { 'police' },
        -- grades = { 2, 3, 4 },
        categories = {
            [1] = {
                name = 'General',
                description = 'Random items',
                icon = 'fa-solid fa-burger-soda',
                items = {
                
                    { name = 'water_bottle',  label = 'Water',         perPrice = 200, description = 'Drinks' },
                    { name = 'sandwich',      label = 'Sandwich',      perPrice = 200, description = 'Food' },
                    { name = 'snikkel_candy', label = 'Snikkel Candy', perPrice = 200, description = 'General' },
                    { name = 'tosti',         label = 'Tosti',         perPrice = 200, description = 'General' },
                    { name = 'beer',          label = 'Beer',          perPrice = 350, description = 'Alcohol' },
                    { name = 'kurkakola',          label = 'Cola',          perPrice = 200, description = 'Drinks' },
                    { name = 'twerks_candy',  label = 'Twerks Candy',  perPrice = 200, description = 'Candy' },
                    { name = 'whiskey',       label = 'Whiskey',       perPrice = 400, description = 'Alcohol' },

                
                
                }
            },
        },
        pedHash = 'mp_m_securoguard_01', -- You can delete this so the ped does not appear.
        scenario = 'WORLD_HUMAN_COP_IDLES',
        coords = {
            { ped = nil, coords = vector4(-595.85, -427.27, 39.63, 277.87) }
        }
    },
       {
        name = 'EMS Market',
        label = '[E] - EMS Ammunation',
        blip = false,
        -- requiredLicense = 'police_license',
        jobs = { 'ambulance' },
        -- grades = { 2, 3, 4 },
        categories = {
            [1] = {
                name = 'Tools',
                description = 'Tools items',
                icon = 'fa-solid fa-burger-soda',
                items = {
                { name = 'medbag',     label = 'Medical Bag',   perPrice = 5000, description = 'A bag of medic tools' },
                { name = 'medikit',    label = 'First-Aid Kit', perPrice = 100 , description = 'A first aid kit for healing injured people.'},
                { name = 'bandage', label = 'Bandage', perPrice = 100, description = 'Bandage' }
                }
            },
            [2] = {
                name = 'Medicines',
                description = 'Medicines items',
                icon = 'fa-solid fa-burger-soda',
                items = {
                { name = 'morphine30', label = 'Morphine 30MG', perPrice = 100 , description = 'A controlled substance to control pain'},
                { name = 'morphine15', label = 'Morphine 15MG', perPrice = 45, description = 'A controlled substance to control pain' },
                { name = 'perc30',     label = 'Percocet 30MG', perPrice = 60, description = 'A controlled substance to control pain' },
                { name = 'perc10',     label = 'Percocet 10MG', perPrice = 40 , description = 'A controlled substance to control pain'},
                { name = 'perc5',      label = 'Percocet 5MG',  perPrice = 30 , description = 'A controlled substance to control pain'},
                { name = 'vic10',      label = 'Vicodin 10MG',  perPrice = 30 , description = 'A controlled substance to control pain'},
                { name = 'vic5',       label = 'Vicodin 5MG',   perPrice = 15, description = 'A controlled substance to control pain' },
                }
            },
        },
        pedHash = 's_m_m_doctor_01', -- You can delete this so the ped does not appear.
        scenario = 'WORLD_HUMAN_COP_IDLES',
        coords = {
            { ped = nil, coords = vector4(-813.45, -1246.77, 11.31, 328.53) }
        }
    },
  --[[       {
        name = 'mechanicmarket',
        label = '[E] - Mechanic Market',
        blip = false,
        -- requiredLicense = 'police_license',
        jobs = { 'mechanic' },
        -- grades = { 2, 3, 4 },
        categories = {
           [1] = {
                name = 'Nos Items',
                description = 'Random items',
                icon = 'fa-solid fa-spray-can-sparkles',
                items = {
                    --{ name = "nos",       label = 'NOS Bottle',          description = 'A full bottle of NOS',  perPrice = 0, },
                    --{ name = "noscolour", label = 'NOS Colour Injector', description = 'Make that purge spray', perPrice = 0, },

                }
            },
            [2] = {
                name = 'Repair Items',
                description = 'Random items',
                icon = 'fa-solid fa-toolbox',
                items = {
                    { name = "mechanic_tools", label = 'Mechanic tools', description = 'Needed for vehicle repairs', perPrice = 0, },
                    { name = "sparetire",      label = 'Spare Tire',     description = 'Spare Tire',                 perPrice = 0, },
                    { name = "axleparts",      label = 'Axle Parts',     description = 'Axle Parts',                 perPrice = 0, },
                    { name = "carbattery",     label = 'Car Battery',    description = 'Car Battery',                perPrice = 0, },
                    { name = "sparkplugs",     label = 'Spark Plugs',    description = 'Spark Plugs',                perPrice = 0, },
                    { name = "newoil",         label = 'Car Oil',        description = 'Car Oil',                    perPrice = 0, },

                }
            },
            [3] = {
                name = 'Tool Items',
                description = 'Random items',
                icon = 'fa-solid fa-screwdriver-wrench',
                items = {
                    { name = "toolbox",              label = 'Toolbox',           description = 'Needed for Performance part removal',                                perPrice = 0, },
                    { name = "advancedrepairkit",    label = 'Advanced Repairkit',description = 'A nice toolbox with stuff to repair your vehicle',                   perPrice = 0, },
                    { name = "paintcan",             label = 'Vehicle Spray Can', description = 'Vehicle Spray Can',                                                  perPrice = 0, },
                    { name = "tint_supplies",        label = 'Window Tint Kit',   description = 'Window Tint Kit',                                                    perPrice = 0, },
                    { name = "underglow_controller", label = 'Neon Controller',   description = 'RGB LED Vehicle Remote',                                             perPrice = 0, },
                    { name = "cleaningkit",          label = 'Cleaning Kit',      description = 'A microfiber cloth with some soap will let your car sparkle again!', perPrice = 0, },
                    --{ name = "newplate",             label = 'New Plate',         description = 'A Customizable licence plate',                                       perPrice = 0, },

                }
            },
            [4] = {
                name = 'Perform Items',
                description = 'Random items',
                icon = 'fa-solid fa-chart-simple',
                items = {
                    { name = "turbo",         label = 'Supercharger Turbo',    description = 'Turbo',                                                perPrice = 0, },
                    { name = "car_armor",     label = 'Vehicle Armor',         description = 'Armor',                                                perPrice = 0, },
                    { name = "bprooftires",   label = 'Bulletproof Tires',     description = 'Bulletproof Tires',                                    perPrice = 0, },
                    { name = "drifttires",    label = 'Drift Tires',           description = 'Drift Tires',                                          perPrice = 0, },
                    { name = "harness",       label = 'Race Harness',          description = 'Racing Harness so no matter what you stay in the car', perPrice = 0, },
                    { name = "antilag",       label = 'AntiLag',               description = 'AntiLag',                                              perPrice = 0, },

                    { name = "engine1",       label = 'Tier 1 Engine',         description = 'Class A',                                              perPrice = 0, }, -- Basic
                    { name = "engine2",       label = 'Tier 2 Engine',         description = 'Class B',                                              perPrice = 0, }, -- Standard
                    { name = "engine3",       label = 'Tier 3 Engine',         description = 'Class C',                                              perPrice = 0, }, -- Enhanced
                    { name = "engine4",       label = 'Tier 4 Engine',         description = 'Class D',                                              perPrice = 0, }, -- Performance
                    { name = "engine5",       label = 'Tier 5 Engine',         description = 'Class S',                                              perPrice = 0, }, -- Elite

                    { name = "transmission1", label = 'Tier 1 Transmission',   description = 'Class A',                                              perPrice = 0, },      -- Basic
                    { name = "transmission2", label = 'Tier 2 Transmission',   description = 'Class B',                                              perPrice = 0, },      -- Standard
                    { name = "transmission3", label = 'Tier 3 Transmission',   description = 'Class C',                                              perPrice = 0, }, -- Enhanced
                    { name = "transmission4", label = 'Tier 4 Transmission',   description = 'Class D',                                              perPrice = 0, },      -- Performance

                    { name = "brakes1",       label = 'Tier 1 Brakes',         description = 'Class A',                                              perPrice = 0, }, -- Basic
                    { name = "brakes2",       label = 'Tier 2 Brakes',         description = 'Class B',                                              perPrice = 0, }, -- Standard
                    { name = "brakes3",       label = 'Tier 3 Brakes',         description = 'Class C',                                              perPrice = 0, }, -- Enhanced

                    { name = "suspension1",   label = 'Tier 1 Suspension',     description = 'Class A',                                              perPrice = 0, },      -- Basic
                    { name = "suspension2",   label = 'Tier 2 Suspension',     description = 'Class B',                                              perPrice = 0, }, -- Standard
                    { name = "suspension3",   label = 'Tier 3 Suspension',     description = 'Class C',                                              perPrice = 0, }, -- Enhanced
                    { name = "suspension4",   label = 'Tier 4 Suspension',     description = 'Class D',                                              perPrice = 0, }, -- Performance
                    { name = "suspension5",   label = 'Tier 5 Suspension',     description = 'Class S',                                              perPrice = 0, }, -- Elite

                    { name = "oilp1",         label = 'Tier 1 Oil Pump',       description = 'Class A',                                              perPrice = 0, }, -- Basic
                    { name = "oilp2",         label = 'Tier 2 Oil Pump',       description = 'Class B',                                              perPrice = 0, }, -- Standard
                    { name = "oilp3",         label = 'Tier 3 Oil Pump',       description = 'Class C',                                              perPrice = 0, }, -- Enhanced

                    { name = "drives1",       label = 'Tier 1 Drive Shaft',    description = 'Class A',                                              perPrice = 0, }, -- Basic
                    { name = "drives2",       label = 'Tier 2 Drive Shaft',    description = 'Class B',                                              perPrice = 0, }, -- Standard
                    { name = "drives3",       label = 'Tier 3 Drive Shaft',    description = 'Class C',                                              perPrice = 0, }, -- Enhanced

                    { name = "cylind1",       label = 'Tier 1 Cylinder Head',  description = 'Class A',                                              perPrice = 0, }, -- Basic
                    { name = "cylind2",       label = 'Tier 2 Cylinder Head',  description = 'Class B',                                              perPrice = 0, }, -- Standard
                    { name = "cylind3",       label = 'Tier 3 Cylinder Head',  description = 'Class C',                                              perPrice = 0, }, -- Enhanced

                    { name = "cables1",       label = 'Tier 1 Battery Cables', description = 'Class A',                                              perPrice = 0, }, -- Basic
                    { name = "cables2",       label = 'Tier 2 Battery Cables', description = 'Class B',                                              perPrice = 0, }, -- Standard
                    { name = "cables3",       label = 'Tier 3 Battery Cables', description = 'Class C',                                              perPrice = 0, }, -- Enhanced

                    { name = "fueltank1",     label = 'Tier 1 Fuel Tank',      description = 'Class A',                                              perPrice = 0, }, -- Basic
                    { name = "fueltank2",     label = 'Tier 2 Fuel Tank',      description = 'Class B',                                              perPrice = 0, }, -- Standard
                    { name = "fueltank3",     label = 'Tier 3 Fuel Tank',      description = 'Class C',                                              perPrice = 0, }, -- Enhanced

                }
            },
            [5] = {
                name = 'Cosmetic Items',
                description = 'Random items',
                icon = 'fa-solid fa-chair',
                items = {
                    { name = "hood",             label = 'Vehicle Hood',        description = 'Vehicle Hood',                    perPrice = 0, },
                    { name = "roof",             label = 'Vehicle Roof',        description = 'Vehicle Roof',                    perPrice = 0, },
                    { name = "spoiler",          label = 'Vehicle Spoiler',     description = 'Vehicle Spoiler',                 perPrice = 0, },
                    { name = "bumper",           label = 'Vehicle Bumper',      description = 'Vehicle Bumper',                  perPrice = 0, },
                    { name = "skirts",           label = 'Vehicle Skirts',      description = 'Vehicle Skirts',                  perPrice = 0, },
                    { name = "exhaust",          label = 'Vehicle Exhaust',     description = 'Vehicle Exhaust',                 perPrice = 0, },
                    { name = "seat",             label = 'Seat Cosmetics',      description = 'Seat Cosmetics',                  perPrice = 0, },
                    { name = "livery",           label = 'Livery Roll',         description = 'Livery Roll',                     perPrice = 0, },
                    { name = "tires",            label = 'Drift Smoke Tires',   description = 'Drift Smoke Tires',               perPrice = 0, },
                    { name = "horn",             label = 'Custom Vehicle Horn', description = 'Custom Vehicle Horn',             perPrice = 0, },
                    { name = "internals",        label = 'Internal Cosmetics',  description = 'Internal Cosmetics',              perPrice = 0, },
                    { name = "externals",        label = 'Exterior Cosmetics',  description = 'Exterior Cosmetics',              perPrice = 0, },
                    { name = "customplate",      label = 'Customized Plates',   description = 'Customized Plates',               perPrice = 0, },
                    { name = "headlights", label = 'Xenon Headlights',    description = 'Xenon Headlights',                perPrice = 0, },
                    { name = "rims",             label = 'Custom Wheel Rims',   description = 'Custom Wheel Rims',               perPrice = 0, },
                    { name = "rollcage",         label = 'Roll Cage',           description = 'Roll Cage',                       perPrice = 0, },
                    { name = "underglow",        label = 'Underglow LEDS',      description = 'Underglow addition for vehicles', perPrice = 0, },
                    { name = "stancerkit",       label = 'Stancer Kit',         description = 'Stancer Kit for vehicles',        perPrice = 0, },

                }
            },
                [6] = {
                name = 'Repair Material',
                description = 'Random items',
                icon = 'fa-solid fa-toolbox',
                items = {
                    { name = "steel",             label = 'Steel',        description = 'Nice piece of metal that you can probably use for something',                    perPrice = 0, },
                    { name = "iron",             label = 'Iron',        description = 'Handy piece of metal that you can probably use for something',                    perPrice = 0, },
                    { name = "plastic",          label = 'Plastic',     description = 'RECYCLE! - Greta Thunberg 2019',                 perPrice = 0, },

                }
            },
        },
        pedHash = 's_m_m_dockwork_01', -- You can delete this so the ped does not appear.
        scenario = 'WORLD_HUMAN_COP_IDLES',
        coords = {
            { ped = nil, coords = vector4(-328.86, -140.75, 39.01, 344.68) }
        }
    }, ]]
    {
        name = 'Digital Den',
        label = '[E] - Digital Den',
        blip = true,
        blipSprite = 521,
        blipColor = 29,
        blipScale = 0.8,
        -- requiredLicense = 'police_license',
        -- jobs = { 'police' },
        -- grades = { 2, 3, 4 },
        categories = {
            [1] = {
                name = 'Electrpnics',
                description = '24/7 Access',
                icon = 'fa-solid fa-bolt',
               items = {
                    { name = 'phone',      label = 'Phone',      perPrice = 1000, description = 'Electronics' },
                    { name = 'radio',      label = 'Radio',      perPrice = 800, description = 'Electronics' },
                    { name = 'binoculars', label = 'Binoculars', perPrice = 500,  description = 'Electronics' },
                    { name = 'fitbit',     label = 'Fitbit',     perPrice = 500, description = 'Electronics' },
                    { name = 'vehiclegps',     label = 'Vehicle GPS',     perPrice = 10000, description = 'To track your vehicles' },
                    { name = 'vehicletracker',     label = 'Vehicle Tracker',     perPrice = 5000, description = 'GPS device for vehicles' },
                    { name = 'ys_sim_card', label = 'Sim Card', perPrice = 1000,  description = 'A sim card'},
					{ name = 'powerbank', label = 'Powerbank', perPrice = 1000,  description = 'Capacity: 10000mAh | Output: 5V/2.1A | USB Type-C.'},
                    -- { name = 'usb_cable', label = 'USB Type-C', perPrice = 5000,  description = 'USB cable for charging'},
                }
            }
        },

        pedHash = 'mp_m_waremech_01', -- You can delete this so the ped does not appear.
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        coords = {
            { ped = nil, coords = vector4(84.51, -230.26, 54.63, 338.70) }
        }
    },
    {
        name = 'Car Race',
        label = '[E] - Car Race',
        blip = false,
        blipSprite = 590,
        blipColor = 45,
        blipScale = 0.6,
        -- requiredLicense = 'police_license',
        -- jobs = { 'police' },
        -- grades = { 2, 3, 4 },
        categories = {
            [1] = {
                name = 'Electrpnics',
                description = '24/7 Access',
                icon = 'fa-solid fa-bolt',
               items = {
                    { name = 'racing_gps',      label = 'Racing Tablet',      perPrice = 10000, description = 'Electronics' },

                }
            }
        },
        pedHash = 'mp_m_waremech_01', -- You can delete this so the ped does not appear.
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        coords = {
            { ped = nil, coords = vector4(918.84, -2409.17, 22.52, 4.15) }
        }
    },
}

for k, v in pairs(Config.Shops) do
    if table.find(Config.Shops, function(shop, id)
            return shop.name == v.name and id ~= k
        end) then
        LoopError(('Shop %s already exists! You need to use uniq name. Otherwise the shop is not working properly.'):format(v.name))
    end
end

--[[
    Stash Configuration Guide

    This section defines static stashes across the map, which can be used for police armories, personal storage, restricted areas, or hidden locations.

    Each stash includes:
    - `coords`: World position where the stash is located.
    - `targetLabel`: The interaction label shown to players.
    - `size`: Configurable weight and slot capacity.
    - `blip`: Optional map blip with name, icon, color, and scale.
    - `label`: Internal stash identifier.
    - `requiredJobs`: Restrict access to specific jobs (e.g., police, ambulance).
    - `requiredJobsGrades`: Optional rank restriction for allowed jobs.
    - `requiredLicense`: Restrict access using an item-based license (e.g., 'weapon_license').
    - `personal`: If true, the stash is unique to each player.
    - `distance`: Interaction range.

    💡 Tip: Use `personal = true` for player-specific storage and leave `requiredJobs` as `nil` for public access.
]]

Config.Stashes = {
    [1] = {
        ['coords'] = vector3(-598.81, -425.97, 35.17),
        ['targetLabel'] = '[E] - Open Stash',
        ['size'] = {
            weight = 50000,
            slots = 15
        },
        -- ['blip'] = {
        --     name = 'Police Stash',
        --     coords = vector3(-598.81, -425.97, 35.17),
        --     sprite = 1,
        --     color = 38,
        --     size = 0.5
        -- },
        ['label'] = 'police_stash',
        ['requiredJobs'] = { 'police' }, -- nil or example { 'police', 'ambulance' }
        ['requiredJobsGrades'] = { 0,1,2, 3, 4,5,6,7,8,9,10,11,12 },
        ['requiredLicense'] = nil,       -- nil or example 'itemname',
        ['personal'] = true,
        ['distance'] = 5.0
    },
    [2] = {
        ['coords'] = vector3(306.303284, -1457.709839, 29.953857),
        ['targetLabel'] = '[E] - Open Stash',
        ['size'] = {
            weight = 9500,
            slots = 15
        },
        ['blip'] = nil,
        ['label'] = 'doctor_stash',
        ['requiredJobs'] = { 'ambulance' }, -- nil or example { 'police', 'ambulance' }
        ['requiredJobsGrades'] = nil,       -- nil or grade tables example { 2, 3, 4},
        ['requiredLicense'] = nil,          -- nil or example 'itemname',
        ['personal'] = false,
        ['distance'] = 5.0
    },
    [3] = {
        ['coords'] = vector3(237.481323, -1354.747192, 31.032227),
        ['targetLabel'] = '[E] - Open Stash',
        ['size'] = {
            weight = 10000,
            slots = 50
        },
        ['blip'] = nil,
        ['label'] = 'mysterious_shed',
        ['requiredJobs'] = nil,       -- nil or example { 'police', 'ambulance' }
        ['requiredJobsGrades'] = nil, -- nil or grade tables example { 2, 3, 4},
        ['requiredLicense'] = nil,    -- nil or example 'itemname',
        ['personal'] = true,
        ['distance'] = 5.0
    },
   
    [4] = {
        ['coords'] = vector3(-921.68, -2043.10, 9.84),
        ['targetLabel'] = '[E] - Guest Stash',
        ['size'] = {
            weight = 10000,
            slots = 50
        },
        ['blip'] = nil,
        ['label'] = 'mysterious_shed',
        ['requiredJobs'] = nil,       -- nil or example { 'police', 'ambulance' }
        ['requiredJobsGrades'] = nil, -- nil or grade tables example { 2, 3, 4},
        ['requiredLicense'] = nil,    -- nil or example 'itemname',
        ['personal'] = false,
        ['distance'] = 5.0
    },

    [5] = {
        ['coords'] = vector3(-925.17, -2047.47, 9.50),
        ['targetLabel'] = '[E] - Guest Stash 2',
        ['size'] = {
            weight = 10000,
            slots = 50
        },
        ['blip'] = nil,
        ['label'] = 'mysterious_shed',
        ['requiredJobs'] = nil,       -- nil or example { 'police', 'ambulance' }
        ['requiredJobsGrades'] = nil, -- nil or grade tables example { 2, 3, 4},
        ['requiredLicense'] = nil,    -- nil or example 'itemname',
        ['personal'] = false,
        ['distance'] = 5.0
    },
    [6] = {
        ['coords'] = vector3(-913.37, -2020.01, 10.29),
        ['targetLabel'] = '[E] - Guest Stash 3',
        ['size'] = {
            weight = 10000,
            slots = 50
        },
        ['blip'] = nil,
        ['label'] = 'mysterious_shed',
        ['requiredJobs'] = nil,       -- nil or example { 'police', 'ambulance' }
        ['requiredJobsGrades'] = nil, -- nil or grade tables example { 2, 3, 4},
        ['requiredLicense'] = nil,    -- nil or example 'itemname',
        ['personal'] = false,
        ['distance'] = 5.0
    },
}

--[[
    Debug Configuration:

    This section is primarily for development purposes, enabling debug mode allows you to view
    various logs and prints related to script actions, events, and errors. This is useful for
    identifying issues and fine-tuning the script during the development stage.

    NOTE: Enable these options only if you are actively developing or troubleshooting,
    as they may increase server load and provide detailed output that isn’t necessary
    for standard gameplay.
]]

Config.Debug = false -- Enables detailed print logs for debugging; leave off for production
