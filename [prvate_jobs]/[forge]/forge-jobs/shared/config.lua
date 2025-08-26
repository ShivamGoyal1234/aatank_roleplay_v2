--[[
    Please do not modify the values unless you know what you are doing.
]]

-- General Settings
Config = {}

-- Core Settings
Config.Debug = false -- Set to true only for testing. Keep false for better performance as it disables debug messages
Config.Locale = 'en' -- Default language ('en', 'es', 'fr', 'de', 'pt', 'tr', 'ar', 'it', 'ru') - To translate the UI, navigate through the front end, in the HTML and the .JS files
Config.CurrencySymbol = "$" -- Currency symbol used in the game

-- Configuration for screen fades
Config.EnableScreenFades = true -- Enable or disable black screen fades during job actions. Enabled is more immersive because prop dont dissappear abruptly.
Config.ScreenFadeDuration = 500 -- Duration of the screen fades in milliseconds.

-- Framework and System Settings
Config.Framework = "QB" -- Options: "ESX", "QB" or "QBOX"
Config.SQL = "OXMYSQL" -- Options: "OXMYSQL", "MYSQL-ASYNC", "GHMATTIMYSQL"
Config.Inventory = "quasar-inventory" -- Options: "ox_inventory", "qb-inventory", "quasar-inventory", "rs-inventory" (https://refined-solution.tebex.io/package/6731388)
Config.Target = "" -- Options: "qb-target", "ox_target", or "" (empty for floating text). Using a target system is recommended for better performance.
Config.InteractKey = 38 -- Interaction key (used only if target is none)
Config.InteractKeyChar = 'E' -- Interaction key character
Config.DailySellLimit = 500 -- Max amount of items that can be sold daily. If you want to disable this feature, set it to a high number like 9999999

-- Core Export Configuration - Change export names here if needed
-- IMPORTANT: If your server uses different export names, change them here:
-- Example: If your ESX export is "esx:getSharedObject" instead of "es_extended:getSharedObject"
-- Just change ESX = "esx" below and the script will work automatically
Config.CoreExports = {
    ESX = "es_extended", -- ESX export name
    QB = "qb-core" -- QB-Core export name
}
-- Core Export Function - Returns the appropriate core object based on framework
-- This function automatically detects your framework and returns the correct core object
-- You don't need to modify this function, just change the export names above if needed
Config.CoreExport = function()
    if Config.Framework == "ESX" then
        return exports[Config.CoreExports.ESX]:getSharedObject()
    elseif Config.Framework == "QB" or Config.Framework == "QBOX" then
        return exports[Config.CoreExports.QB]:GetCoreObject()
    end
end

-- Job System Configuration
Config.Jobs = {
    ["Mining"] = {
        Enabled = true, -- Set to false to disable this job completely
        UseSkillCheck = true, -- Set to false to disable the skill check during preprocessing/processing
        UseProgressBar = false, -- Set to true to use a progress bar instead of Skill Check (if UseSkillCheck is false)
        -- Job restrictions for this activity
        JobRestrictions = {
            enabled = false, -- Set to true to enable job restrictions
            allowedJobs = { "miner", "mining_boss" } -- List of jobs allowed to use this activity
        },
        -- Camera control options – I don't recommend setting it to false, or the process will feel less immersive and more clunky
        EnableFarmingCamera = true, -- Enable/disable camera effects during mining
        EnablePreProcessingCamera = true, -- Enable/disable camera effects during pre-processing
        -- Location Settings
        PreProcessingPosition = {
            vector3(1880.3469, 399.7037, 159.7695),
            vector(1875.9863, 402.0613, 159.9526),
            vector3(1884.1266, 398.7093, 160.1845),
            vector3(1887.9449, 394.6761, 160.4102)
            -- Add more vector3(...) entries here if needed
        },
        ProcessingPosition = vector3(2619.9331, 2781.8237, 32.7626),
        
        -- NPC Configuration
        NPC = {
            Enabled = true,
            Type = 1, -- Do not modify
            Name = "Miner",
            Position = vector3(2952.1035, 2751.0454, 42.4592),
            Heading = 25.0,
            Model = "S_M_Y_Construct_01",
            Animation = {"", ""}, -- Animation settings
            Scenario = "WORLD_HUMAN_SMOKING", -- Scenario settings
            Blip = {
                Text = "[JOB] Mining",
                Sprite = 618,
                Color = 46
            }
        },
        
        -- Blip Configuration
        Blips = {
            {
                Text = "[JOB] Mining",
                Sprite = 618,
                Color = 46,
                Position = vector3(1880.3469, 399.7037, 159.7695),
            },
            {
                Text = "[JOB] Mining",
                Sprite = 618,
                Color = 46,
                Position = vector3(2619.9331, 2781.8237, 32.7626),
            },
            {
                Text = "[JOB] Mining",
                Sprite = 618,
                Color = 46,
                Area = {
                    Alpha = 155,
                    Color = 46
                }
            }
        },
        
        -- Experience System
        XPActions = {
            DigRock = {1, 5}
        },
        
        -- Item Configuration
        -- IMPORTANT: Item1 must be obtainable from RockItems to allow processing
        -- This is the main resource that will be processed through the chain
        Item1 = "stone", -- First processing item (must be obtainable from mining)
        Item2 = "washed_stone", -- Result of first processing
        Item3 = "final_stone_product", -- Final product
        
        -- Processing Settings
        PreProcessingProp = "rock_4_cl_2_2",
        PreProcessingPropRotation = vector3(0, 0, 90),
        PreProcessingHandProp = "", -- Optional. If empty, no hand prop will be attached
        PreProcessingHandPropOptions = { -- Options for the hand prop
            bone = 18905, -- SKEL_R_Hand
            offsetX = 0.15,
            offsetY = 0.0,
            offsetZ = 0.0,
            rotationX = 0.0,
            rotationY = 0.0,
            rotationZ = 0.0
        },
        PreProcessingExtraProp = "", -- Optional. If empty, no extra prop will be added on top of the preprocessing prop
        PreProcessingExtraPropOffset = vector3(0.0, 0.0, 1.0), -- Offset from the preprocessing prop position
        ProcessingProp = "fury_cfs_scrapper",
        ProcessingPropRotation = vector3(0, 0, 150),
        PreProcessingTime = 5000,
        ProcessingTime = 10000,
        ProcessingRequiredItems = 5,
        ProcessingGiveItems = 3,
        
        -- Visual Effects
        PreProcessingParticles = "water_splash_animal_wade",
        ProcessingParticles = "ent_amb_smoke_factory_white",
        ProcessingMeatParticles = "ent_amb_smoke_factory_white",
        
        -- Work Zones
        Zones = { -- You can add more zones to the list if you want
            {vector3(-605.35, 2105.99, 126.54), 50.0},
            {vector3(2941.58, 2794.75, 40.09), 50.0}
        },
        
        -- Rock Spawn Points
        RockPositions = { -- You can add more rock positions to the list if you want. Every time script restarts, it will choose a random rock zone from the list
            {
                vector4(-615.42, 2104.61, 124.49, 0.0),
                vector4(-602.70, 2102.26, 126.87, 0.0),
                vector4(-609.70, 2102.78, 125.20, 0.0),
                vector4(-611.31, 2108.12, 124.44, 0.0),
                vector4(-624.20, 2106.64, 124.79, 0.0),
                vector4(-628.32, 2110.19, 123.84, 0.0),
                vector4(-635.37, 2113.09, 122.83, 0.0),
                vector4(-632.45, 2114.90, 122.71, 0.0),
                vector4(-618.12, 2120.00, 124.78, 0.0),
                vector4(-614.44, 2119.35, 125.59, 0.0),
                vector4(-607.58, 2122.71, 127.03, 0.0),
                vector4(-605.57, 2127.05, 127.38, 0.0),
                vector4(-607.21, 2129.44, 127.73, 0.0),
                vector4(-606.57, 2132.96, 128.03, 0.0),
                vector4(-603.87, 2134.34, 128.29, 0.0),
                vector4(-591.72, 2132.95, 128.10, 0.0),
                vector4(-585.56, 2134.38, 128.83, 0.0),
                vector4(-583.96, 2129.66, 129.17, 0.0),
                vector4(-585.51, 2122.31, 129.11, 0.0),
                vector4(-584.27, 2115.22, 129.68, 0.0),
                vector4(-585.53, 2110.82, 129.98, 0.0),
                vector4(-587.07, 2104.80, 130.62, 0.0),
                vector4(-590.09, 2102.27, 130.34, 0.0),
                vector4(-593.70, 2101.79, 129.73, 0.0),
                vector4(-601.45, 2092.84, 130.21, 0.0),
                vector4(-613.09, 2087.39, 131.41, 0.0),
                vector4(-617.76, 2087.77, 133.24, 0.0)
            },
            {
                vector4(2967.82, 2791.08, 39.10, 0.0),
                vector4(2964.24, 2793.49, 39.55, 0.0),
                vector4(2960.54, 2798.07, 40.13, 0.0),
                vector4(2956.26, 2803.68, 40.90, 0.0),
                vector4(2950.15, 2810.69, 40.72, 0.0),
                vector4(2943.92, 2814.18, 41.39, 0.0),
                vector4(2938.67, 2817.45, 42.77, 0.0),
                vector4(2932.28, 2814.47, 43.14, 0.0),
                vector4(2926.76, 2807.52, 41.83, 0.0),
                vector4(2924.72, 2801.67, 40.72, 0.0),
                vector4(2930.23, 2794.54, 39.65, 0.0),
                vector4(2936.50, 2791.17, 39.23, 0.0),
                vector4(2942.03, 2792.17, 39.41, 0.0),
                vector4(2946.84, 2794.94, 39.67, 0.0),
                vector4(2949.76, 2787.26, 40.01, 0.0),
                vector4(2949.55, 2783.43, 39.19, 0.0),
                vector4(2948.24, 2778.01, 38.33, 0.0),
                vector4(2944.45, 2773.56, 38.24, 0.0),
                vector4(2939.29, 2776.59, 38.27, 0.0)
            }
        },
        
        -- Rock Models and Properties
        RockModels = {
            "rock_1",
            "rock_2",
            "rock_3",
            "rock_4",
            "rock_5",
            "rock_6",
            "rock_4_cl_2_2" 
        },
        
        -- Loot Configuration
        LootProps = {
            "fury_cfm_copper_01",
            "fury_cfm_copper_02",
            "fury_cfm_copper_03",
            "fury_cfm_copper_04",
            "fury_cfm_dia_01",
            "fury_cfm_dia_02",
            "fury_cfm_dia_03",
            "fury_cfm_esm_01",
            "fury_cfm_esm_02",
            "fury_cfm_esm_03",
            "fury_cfm_gold_01",
            "fury_cfm_gold_02",
            "fury_cfm_gold_03",
            "fury_cfm_gold_04",
            "fury_cfm_iron_01",
            "fury_cfm_iron_02",
            "fury_cfm_iron_04",
            "fury_crm_rub_01",
            "fury_crm_rub_02",
            "fury_crm_rub_03"
        },
        
        -- Loot Props Spawn Configuration (Controls where rock props appear when using pickaxe)
        LootPropOffset = vector3(0.0, 1.5, 0.3), -- X: Left/Right, Y: Forward/Back, Z: Up/Down from player position
        
        -- Gameplay Settings
        Particles = "ent_amb_smoke_factory_white",
        RockRespawn = 60000,
        -- IMPORTANT: At least one item here must match Item1 to allow processing
        -- This is where players get their resources from mining
        RockItems = {
            {name = "stone", chance = 80}, -- Must match Item1 to allow processing
            {name = "gold", chance = 20},   -- Bonus item
            {name = "diamond", chance = 5}  -- Rare bonus item
        }
    },
    ["Hunting"] = {
        Enabled = true, -- Set to false to disable this job completely
        UseSkillCheck = true, -- Set to false to disable the skill check during preprocessing/processing
        UseProgressBar = false, -- Set to true to use a progress bar instead of Skill Check (if UseSkillCheck is false)
        -- Job restrictions for this activity
        JobRestrictions = {
            enabled = false, -- Set to true to enable job restrictions
            allowedJobs = { "hunter", "hunting_boss" } -- List of jobs allowed to use this activity
        },
        -- Camera control options – I don't recommend setting it to false, or the process will feel less immersive and more clunky
        EnableFarmingCamera = true, -- Enable/disable camera effects during skinning
        EnablePreProcessingCamera = true, -- Enable/disable camera effects during pre-processing
        -- Location Settings
        WorkingPosition = vector3(-864.55, 5032.42, 200.14),
        PreProcessingPosition = {
            vector3(974.3501, -2166.3530, 29.7654),
            vector3(973.6429, -2165.4233, 29.4700),
            vector3(975.5598, -2165.8308, 29.4703)
             -- Add more vector3(...) entries here if needed
        },
        ProcessingPosition = vector3(996.8793, -2149.3584, 28.4764),
        
        -- NPC Configuration
        NPC = {
            Enabled = true,
            Type = 2, -- Do not modify
            Name = "Hunter",
            Position = vector3(-780.0961, 5593.6221, 32.6303),
            Heading = 225.7714,
            Model = "ig_hunter",
            Animation = {"", ""},
            Scenario = "WORLD_HUMAN_STAND_IMPATIENT",
            Blip = {
                Text = "[JOB] Hunting",
                Sprite = 141,
                Color = 17
            }
        },
        
        -- Blip Configuration
        Blips = {
            -- {
            --     Text = "[JOB] Hunting",
            --     Sprite = 141,
            --     Color = 17,
            --     Position = vector3(-864.55, 5032.42, 200.14),
            --     Area = {
            --         Alpha = 155,
            --         Color = 17,
            --         Size = 300.0
            --     }
            -- },
            -- {
            --     Text = "[JOB] Hunting",
            --     Sprite = 141,
            --     Color = 17,
            --     Position = vector3(974.3501, -2166.3530, 29.7654),
            -- },
            -- {
            --     Text = "[JOB] Hunting",
            --     Sprite = 141,
            --     Color = 17,
            --     Position = vector3(996.8793, -2149.3584, 28.4764),
            -- },
        },
        
        -- Experience System
        XPActions = {
            AnimalHunted = {5, 10},
            AnimalSkinned = {1, 5}
        },
        
        -- Item Configuration
        Item1 = "raw_meat", -- First processing item (obtained from skinning)
        Item2 = "clean_meat", -- Result of first processing
        Item3 = "final_meat_product", -- Final product
        
        -- Processing Settings
        PreProcessingProp = "",
        PreProcessingPropRotation = vector3(0, 0, 90),
        PreProcessingHandProp = "", -- Optional. If empty, no hand prop will be attached 
        PreProcessingHandPropOptions = { -- Options for the hand prop
            bone = 18905, -- SKEL_R_Hand
            offsetX = 0.15,
            offsetY = 0.0,
            offsetZ = 0.0,
            rotationX = 0.0,
            rotationY = 0.0,
            rotationZ = 0.0
        },
        PreProcessingExtraProp = "", -- Optional. If empty, no extra prop will be added on top of the preprocessing prop
        PreProcessingExtraPropOffset = vector3(0.0, 0.0, 1.0), -- Offset from the preprocessing prop position
        ProcessingProp = "fury_cfs_scrapper",
        ProcessingPropRotation = vector3(0, 0, 150),
        PreProcessingTime = 5000,
        ProcessingTime = 10000,
        ProcessingRequiredItems = 5,
        ProcessingGiveItems = 3,
        
        -- Visual Effects
        PreProcessingParticles = "trail_splash_blood",
        ProcessingParticles = "ent_amb_abattoir_saw_blood",
        ProcessingMeatParticles = "blood_chopper",
        
        -- Hunting Settings
        WeaponModel = "WEAPON_MUSKET", -- You can change - https://docs.fivem.net/docs/game-references/weapon-models/
        AreaSize = 300.0,
        ShowAnimalMarkers = true, -- Set to false to disable visual markers over animals during hunting
        RequireKnifeToSkin = false, -- Set to false to disable knife requirement for skinning
        KnifeItemName = "weapon_knife", -- Item name required to skin animals
        
        -- Animal Spawner Configuration
        AnimalSpawner = {
            AnimalModels = {"A_C_Coyote", "A_C_Deer", "A_C_Boar", "A_C_Rabbit_01", "A_C_MtLion", "A_C_Wolf"},
            MinimumAnimalsInArea = 3
        }
    },
    ["Fishing"] = {
        Enabled = true, -- Set to false to disable this job completely
        UseSkillCheck = true, -- Set to false to disable the skill check during preprocessing/processing
        UseProgressBar = false, -- Set to true to use a progress bar instead of Skill Check (if UseSkillCheck is false)
        -- Job restrictions for this activity
        JobRestrictions = {
            enabled = false, -- Set to true to enable job restrictions
            allowedJobs = { "fisher", "fishing_boss" } -- List of jobs allowed to use this activity
        },
        -- Camera control options – I don't recommend setting it to false, or the process will feel less immersive and more clunky
        EnableFarmingCamera = true, -- Enable/disable camera effects during fishing/catching
        EnablePreProcessingCamera = true, -- Enable/disable camera effects during pre-processing
        -- Location Settings
        PreProcessingPosition = {
            vector3(-1598.2839, 5188.8149, 3.3101),
            vector3(-1594.1589, 5189.3818, 3.3101),
            vector3(-1593.1399, 5193.5000, 3.3101)
            -- Add more vector3(...) entries here if needed
        },
        ProcessingPosition = vector3(-173.7217, 6556.5195, 10.0863),
        
        -- NPC Configuration
        NPC = {
            Enabled = true,
            Type = 3, -- Do not modify
            Name = "Fisherman",
            Position = vector3(-1594.0479, 5205.0532, 3.3101),
            Heading = 345.2729,
            Model = "A_M_M_RurMeth_01",
            Animation = {"", ""},
            Scenario = "WORLD_HUMAN_DRINKING",
            Blip = {
                Text = "[JOB] Fishing",
                Sprite = 68,
                Color = 38
            }
        },
        
        -- Blip Configuration
        Blips = {
            {
                Text = "[JOB] Fishing",
                Sprite = 68,
                Color = 38,
                Position = vector3(-1598.9175, 5190.0957, 3.3101),
            },
            {
                Text = "[JOB] Fishing",
                Sprite = 68,
                Color = 38,
                Position = vector3(-173.7217, 6556.5195, 10.0863),
            },
        },
        
        -- Experience System
        XPActions = {
            FishCaught = {5, 10},
            FishDiscarded = {1, 5}
        },
        
        -- Item Configuration
        -- IMPORTANT: Item1 is obtained by processing caught fish
        -- This is the main resource that will be processed through the chain
        Item1 = "fish_meat", -- First processing item (obtained from fish)
        Item2 = "clean_fish_meat", -- Result of first processing
        Item3 = "final_fish_product", -- Final product
        
        -- Processing Settings
        PreProcessingProp = "prop_rub_table_02",
        PreProcessingPropRotation = vector3(0, 0, 21.9273),
        PreProcessingHandProp = "prop_knife", -- Optional. If empty, no hand prop will be attached
        PreProcessingHandPropOptions = { -- Options for the hand prop
            bone = 18905, -- SKEL_R_Hand
            offsetX = 0.14,
            offsetY = 0.03,
            offsetZ = 0.03,
            rotationX = -50.0,
            rotationY = -88.0,
            rotationZ = 0.0
        },
        PreProcessingExtraProp = "a_c_fish", -- Optional. If empty, no extra prop will be added on top of the preprocessing prop
        PreProcessingExtraPropOffset = vector3(0.0, 0.0, 0.6), -- Offset from the preprocessing prop position
        ProcessingProp = "fury_cfs_scrapper",
        ProcessingPropRotation = vector3(0, 0, 150),
        PreProcessingTime = 5000,
        ProcessingTime = 10000,
        ProcessingRequiredItems = 5,
        ProcessingGiveItems = 3,
        
        -- Visual Effects
        PreProcessingParticles = "ent_amb_smoke_factory_white",
        ProcessingParticles = "ent_amb_abattoir_saw_blood",
        ProcessingMeatParticles = "blood_chopper",
        
        -- Fishing Settings
        PickupFishKey = 38,
        DiscardFishKey = 47,
        MaxDistanceWaterCheck = 10.0,
        CatchFishCheckTime = 6000,
        CatchFishChance = 0.30,
        
        -- Minigame Configuration
        UseFishingMinigame = true, -- Set to false to disable the fishing minigame (will auto-catch)
        MinigameOptions = {
            Difficulty = 1,
            Time = 5000
        },
        
        -- Fish Types Configuration
        -- 'name': Extra item ID given to player in addition to base item (Item1), like a extra bonus item
        -- 'displayName': Name shown in notifications
        -- 'chance': Catch probability
        Fishes = {
            {name = "fish_oilslimy", displayName = "Fish Small", chance = 80},
            {name = "fish_gemscale", displayName = "Fish Big", chance = 5},
            {name = "fish_oceanpearl", displayName = "Fish Medium", chance = 15},
        }
    },
    ["Lumberjack"] = {
        Enabled = true, -- Set to false to disable this job completely
        UseSkillCheck = true, -- Set to false to disable the skill check during preprocessing/processing
        UseProgressBar = false, -- Set to true to use a progress bar instead of Skill Check (if UseSkillCheck is false)
        -- Job restrictions for this activity
        JobRestrictions = {
            enabled = false, -- Set to true to enable job restrictions
            allowedJobs = { "lumberjack", "lumberjack_boss" } -- List of jobs allowed to use this activity
        },
        -- Camera control options – I don't recommend setting it to false, or the process will feel less immersive and more clunky
        EnableFarmingCamera = true, -- Enable/disable camera effects during chopping
        EnablePreProcessingCamera = true, -- Enable/disable camera effects during pre-processing
        -- Location Settings
        PreProcessingPosition = {
            vector3(-472.5624, 5300.8643, 84.9849),
            vector3(-474.6830, 5294.2305, 85.1144),
            vector3(-463.5078, 5326.4717, 83.3465),
            vector3(-481.7439, 5274.5864, 85.8514)
            -- Add more vector3(...) entries here if needed
        },
        ProcessingPosition = vector3(-535.3254, 5272.7886, 73.1743),
        
        -- NPC Configuration
        NPC = {
            Enabled = true,
            Type = 4, -- Do not modify
            Name = "Lumberjack",
            Position = vector3(-468.8142, 5351.8555, 79.7185),
            Heading = 20.9624,
            Model = "S_M_M_AutoShop_01",
            Animation = {"", ""},
            Scenario = "WORLD_HUMAN_CLIPBOARD",
            Blip = {
                Text = "[JOB] Lumberjack",
                Sprite = 501,
                Color = 21
            }
        },
        
        -- Blip Configuration
        Blips = {
            {
                Text = "[JOB] Lumberjack",
                Sprite = 501,
                Color = 21,
                Position = vector3(-472.1246, 5301.0962, 86.9544),
            },
            {
                Text = "[JOB] Lumberjack",
                Sprite = 501,
                Color = 21,
                Position = vector3(-535.3254, 5272.7886, 73.1743),
            },
            {
                Text = "[JOB] Lumberjack",
                Sprite = 501,
                Color = 21,
                Area = {
                    Alpha = 155,
                    Color = 21
                }
            }
        },
        
        -- Experience System
        XPActions = {
            CutTree = {1, 5}
        },
        
        -- Item Configuration
        -- IMPORTANT: Item1 must be obtainable from TreeItems to allow processing
        -- This is the main resource that will be processed through the chain
        Item1 = "wood", -- First processing item (must be obtainable from trees)
        Item2 = "processed_wood", -- Result of first processing
        Item3 = "plank", -- Final product
        
        -- Processing Settings
        PreProcessingProp = "prop_tablesaw_01",
        PreProcessingPropRotation = vector3(0, 0, 264.5698),
        PreProcessingHandProp = "", -- Optional. If empty, no hand prop will be attached
        PreProcessingHandPropOptions = { -- Options for the hand prop
            bone = 18905, -- SKEL_R_Hand
            offsetX = 0.15,
            offsetY = 0.0,
            offsetZ = 0.0,
            rotationX = 0.0,
            rotationY = 0.0,
            rotationZ = 0.0
        },
        PreProcessingExtraProp = "prop_fncwood_16g", -- Optional. If empty, no extra prop will be added on top of the preprocessing prop
        PreProcessingExtraPropOffset = vector3(0.0, 0.0, 0.6), -- Offset from the preprocessing prop position
        ProcessingProp = "fury_cfs_scrapper",
        ProcessingPropRotation = vector3(0, 0, 150),
        PreProcessingTime = 5000,
        ProcessingTime = 10000,
        ProcessingRequiredItems = 5,
        ProcessingGiveItems = 3,
        
        -- Visual Effects
        PreProcessingParticles = "proj_flare_trail",
        ProcessingParticles = "ent_amb_smoke_factory_white",
        ProcessingMeatParticles = "ent_dst_wood_planks",
        
        -- Work Zones
        Zones = {
            {vector3(-550.0, 5450.0, 60.0), 150.0}
        },
        
        -- Tree Spawn Points
        TreePositions = {
            {
                vector4(-506.4149, 5422.7739, 66.4265, 245.8004),
                vector4(-462.2708, 5405.2007, 77.8349, 221.1253),
                vector4(-469.7106, 5401.0811, 77.6851, 200.5666),
                vector4(-476.8665, 5402.4058, 77.0369, 92.6976),
                vector4(-478.9376, 5398.4888, 77.2654, 167.4716),
                vector4(-480.9810, 5393.4604, 77.4101, 133.2418),
                vector4(-485.7825, 5388.5029, 77.1959, 122.5797),
                vector4(-481.7130, 5382.5771, 77.8758, 268.7437),
                vector4(-474.8594, 5385.4121, 78.2931, 270.3004),
                vector4(-519.3566, 5389.5957, 70.1531, 158.9551),
                vector4(-521.1146, 5382.3066, 69.7850, 197.3064),
                vector4(-533.6187, 5423.1348, 62.8351, 140.3463),
                vector4(-538.5312, 5424.8140, 62.4257, 86.6299),
                vector4(-539.5583, 5429.2583, 62.5534, 276.6881),
                vector4(-545.3347, 5422.5801, 62.2414, 163.7841),
                vector4(-550.9695, 5433.4131, 61.2620, 355.7010),
                vector4(-558.5081, 5442.5195, 60.6498, 29.3748),
                vector4(-581.8939, 5436.4062, 58.2859, 87.4889),
                vector4(-596.8672, 5442.1333, 56.4531, 77.3193),
                vector4(-608.1646, 5441.0454, 54.3386, 74.4572),
                vector4(-633.5281, 5458.6504, 52.2836, 30.0384),
                vector4(-611.4819, 5491.7036, 51.1352, 322.4153),
                vector4(-598.2730, 5502.5952, 50.9180, 302.4981),
                vector4(-586.5624, 5509.6895, 51.5398, 285.9352),
                vector4(-574.0059, 5517.4146, 53.5929, 306.8859),
                vector4(-521.0458, 5505.5156, 67.9121, 226.0905),
                vector4(-479.7084, 5456.1372, 82.7059, 304.2137),
                vector4(-474.3721, 5481.0859, 83.9705, 348.3716),
                vector4(-471.8301, 5467.5449, 84.2288, 353.5591),
                vector4(-450.9370, 5493.8989, 81.5848, 315.1301),
            }
        },
        
        -- Tree Models and Properties
        TreeModels = {"prop_w_r_cedar_dead"},
        LootProps = {"prop_log_03"},
        Particles = "proj_flare_trail",
        TreeRespawn = 300000,
        -- This is where players get their resources from cutting trees
        TreeItems = {{name = "wood", chance = 100}} -- Must match Item1 to allow processing
    },
    ["Farming"] = {
        Enabled = true, -- Set to false to disable this job completely
        UseSkillCheck = true, -- Set to false to disable the skill check during preprocessing/processing
        UseProgressBar = false, -- Set to true to use a progress bar instead of Skill Check (if UseSkillCheck is false)
        -- Job restrictions for this activity
        JobRestrictions = {
            enabled = false, -- Set to true to enable job restrictions
            allowedJobs = { "farmer", "farming_boss" } -- List of jobs allowed to use this activity
        },
        -- Camera control options – I don't recommend setting it to false, or the process will feel less immersive and more clunky
        EnableFarmingCamera = true, -- Enable/disable camera effects during farming/harvesting
        EnablePreProcessingCamera = true, -- Enable/disable camera effects during pre-processing
        -- Location Settings
        PreProcessingPosition = {
            vector3(1901.4156, 4920.6616, 47.7389),
            vector3(1906.7777, 4925.8291, 47.9090),
            vector3(1901.6012, 4915.2690, 47.8485)
            -- Add more vector3(...) entries here if needed
        },
        ProcessingPosition = vector3(2004.6807, 4987.1631, 40.4520),
        
        -- NPC Configuration
        NPC = {
            Enabled = true,
            Type = 5, -- Do not modify
            Name = "Farmer",
            Position = vector3(2029.8420, 4980.7832, 41.0983),
            Heading = 252.3459,
            Model = "A_M_M_Farmer_01",
            Animation = {"", ""},
            Scenario = "WORLD_HUMAN_AA_SMOKE",
            Blip = {
                Text = "[JOB] Farming",
                Sprite = 514,
                Color = 25
            }
        },
        
        -- Blip Configuration
        Blips = {
            {
                Text = "[JOB] Farming",
                Sprite = 514,
                Color = 25,
                Position = vector3(1901.4156, 4920.6616, 47.7389),
            },
            {
                Text = "[JOB] Farming",
                Sprite = 514,
                Color = 25,
                Position = vector3(2004.6807, 4987.1631, 40.4520),
            },
            {
                Text = "[JOB] Farming",
                Sprite = 514,
                Color = 25,
                Area = {
                    Alpha = 155,
                    Color = 25
                }
            }
        },
        
        -- Experience System
        XPActions = {
            Harvest = {1, 5}
        },
        
        -- Item Configuration
        -- IMPORTANT: Item1 must be obtainable from CropItems to allow processing
        -- This is the main resource that will be processed through the chain
        Item1 = "crop", -- First processing item (must be obtainable from crops)
        Item2 = "processed_crop", -- Result of first processing
        Item3 = "packaged_produce", -- Final product
        
        -- Processing Settings
        PreProcessingProp = "prop_rub_table_02",
        PreProcessingPropRotation = vector3(0, 0, 72.4469),
        PreProcessingHandProp = "prop_knife", -- Optional. If empty, no hand prop will be attached
        PreProcessingHandPropOptions = { -- Options for the hand prop
            bone = 18905, -- SKEL_R_Hand
            offsetX = 0.14,
            offsetY = 0.03,
            offsetZ = 0.03,
            rotationX = -50.0,
            rotationY = -88.0,
            rotationZ = 0.0
        },
        PreProcessingExtraProp = "bzzz_plants_onion_04", -- Optional. If empty, no extra prop will be added on top of the preprocessing prop
        PreProcessingExtraPropOffset = vector3(0.0, 0.0, 0.85), -- Offset from the preprocessing prop position
        ProcessingProp = "fury_cfs_scrapper",
        ProcessingPropRotation = vector3(0, 0, 150),
        PreProcessingTime = 5000,
        ProcessingTime = 10000,
        ProcessingRequiredItems = 5,
        ProcessingGiveItems = 3,
        
        -- Visual Effects
        PreProcessingParticles = "ent_amb_wind_grass",
        ProcessingParticles = "proj_flare_trail",
        ProcessingMeatParticles = "blood_chopper",
        
        -- Work Zones
        Zones = {
            {vector3(2044.5, 4942.0, 40.1), 30.0},
            {vector3(2023.0, 4868.0, 41.9), 30.0}
        },
        
        -- Crop Spawn Points
        CropPositions = {
            {
                vector4(2040.8528, 4960.2544, 40.1164, 222.6280),
                vector4(2043.4781, 4957.4473, 40.0989, 222.5336),
                vector4(2047.1073, 4953.8057, 40.0832, 226.9562),
                vector4(2050.5750, 4950.1997, 40.0766, 221.1212),
                vector4(2055.1199, 4945.7832, 40.0650, 221.1726),
                vector4(2061.9299, 4939.5396, 40.1062, 241.5012),
                vector4(2058.2903, 4937.5962, 40.1165, 93.6779),
                vector4(2055.0024, 4940.6353, 40.1103, 44.4489),
                vector4(2051.6592, 4944.1523, 40.1071, 44.9447),
                vector4(2046.8865, 4948.4307, 40.0978, 49.5278),
                vector4(2042.8328, 4952.6406, 40.0765, 35.5786),
                vector4(2038.6830, 4957.0132, 40.0928, 46.3338),
                vector4(2034.9779, 4951.8428, 40.0267, 187.1496),
                vector4(2039.9248, 4947.4263, 40.1099, 231.2356),
                vector4(2045.7189, 4941.1201, 40.0886, 221.4800),
                vector4(2051.3433, 4936.1362, 40.1128, 225.4887),
                vector4(2052.8562, 4931.1289, 40.0845, 207.1074),
                vector4(2050.1868, 4925.5059, 40.0782, 181.3751),
                vector4(2047.1792, 4928.7251, 40.1029, 43.7243),
                vector4(2043.2705, 4932.9053, 40.1339, 42.4809),
                vector4(2039.5979, 4936.6060, 40.1368, 43.1584),
                vector4(2035.0389, 4940.9087, 40.0811, 50.9032),
                vector4(2029.3416, 4941.0156, 40.1115, 92.9202),
                vector4(2036.9576, 4933.2793, 40.1314, 138.3223),
                vector4(2043.2278, 4926.5596, 40.0601, 227.0999),
                vector4(2044.1527, 4923.5361, 40.1132, 211.4805),
                vector4(2039.6602, 4924.8140, 40.1192, 44.4286),
                vector4(2030.0767, 4931.2539, 40.1039, 53.8530)
            },
            {
                vector4(2031.1759, 4860.6421, 41.8236, 177.9633),
                vector4(2026.9822, 4864.7822, 41.9028, 40.1412),
                vector4(2022.7609, 4869.2896, 41.9001, 41.5981),
                vector4(2017.1376, 4874.4565, 41.8785, 49.1429),
                vector4(2010.4969, 4877.5425, 41.9094, 4.4220),
                vector4(2015.1927, 4873.3589, 41.8579, 221.6734),
                vector4(2020.8210, 4867.5684, 41.8490, 225.2699),
                vector4(2025.6423, 4862.5562, 41.8652, 221.6171),
                vector4(2029.7075, 4858.3032, 41.8800, 222.9320),
                vector4(2026.3169, 4859.3447, 41.8467, 72.8708),
                vector4(2018.8533, 4867.0728, 41.8520, 50.2525),
                vector4(2019.8247, 4877.1729, 41.8744, 10.1153),
                vector4(2027.0228, 4872.9946, 41.8550, 235.0842),
                vector4(2027.4045, 4878.3257, 41.8739, 59.5427),
                vector4(2034.5201, 4874.2593, 41.8951, 222.2704)
            }
        },
        
        -- Crop Models and Properties
        CropModels = {
            "prop_veg_crop_02",
            "prop_veg_crop_04_leaf",
            "bzzz_plants_onion_03",
        },
        
        LootProps = {
            "bzzz_plants_onion_04",
        },
        
        Particles = "ent_amb_wind_grass",
        CropRespawn = 300000,
        -- This is where players get their resources from harvesting crops
        CropItems = {{name = "crop", chance = 100}} -- Must match Item1 to allow processing
    },
    ["Recycling"] = {
        Enabled = true, -- Set to false to disable this job completely
        EnableTrashCollection = true, -- Set to false to disable trash collection and searching specifically
        RequireToolForTrashSearch = false, -- Set to false to allow trash searching without tools
        ToollessTrashReward = { -- These amounts will be given when the use of tools for trash searching is disabled. If tool usage is enabled, it will use the amounts based on the tool level configured further below in Config.Tools.
            minReward = 1,
            maxReward = 2
        },
        UseSkillCheck = true, -- Set to false to disable the skill check during preprocessing/processing
        UseProgressBar = false, -- Set to true to use a progress bar instead of Skill Check (if UseSkillCheck is false) 
        -- Job restrictions for this activity
        JobRestrictions = {
            enabled = false, -- Set to true to enable job restrictions
            allowedJobs = { "recycler", "recycling_boss" } -- List of jobs allowed to use this activity
        },
        -- Camera control options – I don't recommend setting it to false, or the process will feel less immersive and more clunky
        EnableFarmingCamera = true, -- Enable/disable camera effects during searching
        EnablePreProcessingCamera = true, -- Enable/disable camera effects during pre-processing
        -- Location Settings
        PreProcessingPosition = {
            vector3(-559.1318, -1800.9478, 21.6261),
            vector3(-553.9603, -1792.8105, 21.4101),
            vector3(-548.4241, -1782.5773, 20.8504)
            -- Add more vector3(...) entries here if needed
        },
        ProcessingPosition = vector3(-509.1765, -1735.8180, 18.1157),
        
        -- NPC Configuration
        NPC = {
            Enabled = true,
            Type = 6, -- Do not modify
            Name = "Dustman",
            Position = vector3(-483.2332, -1731.1321, 18.5493),
            Heading = 99.8284,
            Model = "S_M_Y_Garbage",
            Animation = {"", ""},
            Scenario = "WORLD_HUMAN_HANG_OUT_STREET",
            Blip = {
                Text = "[JOB] Recycling",
                Sprite = 365,
                Color = 2
            }
        },
        
        -- Blip Configuration
        Blips = {
            {
                Text = "[JOB] Recycling",
                Sprite = 365,
                Color = 2,
                Position = vector3(-559.1318, -1800.9478, 21.6261),
            },
            {
                Text = "[JOB] Recycling",
                Sprite = 365,
                Color = 2,
                Position = vector3(-509.1765, -1735.8180, 18.1157),
            },
            {
                Text = "[JOB] Recycling",
                Sprite = 365,
                Color = 2,
                Area = {
                    Alpha = 155,
                    Color = 2
                }
            }
        },
        
        -- Experience System
        XPActions = {
            SearchTrash = {1, 5},
            SearchScrapVehicle = {5, 10}
        },
        
        -- Item Configuration
        -- IMPORTANT: Item1 must be obtainable from ScrapItems to allow processing
        -- This is the main resource that will be processed through the chain
        Item1 = "iron", -- First processing item (must be obtainable from scrap)
        Item2 = "processed_iron", -- Result of first processing
        Item3 = "recycled_material", -- Final product
        
        -- Processing Settings
        PreProcessingProp = "prop_byard_machine03",
        PreProcessingPropRotation = vector3(0, 0, 149.8345), 
        PreProcessingHandProp = "", -- Optional. If empty, no hand prop will be attached
        PreProcessingHandPropOptions = { -- Options for the hand prop
            bone = 18905, -- SKEL_R_Hand
            offsetX = 0.15,
            offsetY = 0.0,
            offsetZ = 0.0,
            rotationX = 0.0,
            rotationY = 0.0,
            rotationZ = 0.0
        },
        PreProcessingExtraProp = "", -- Optional. If empty, no extra prop will be added on top of the preprocessing prop
        PreProcessingExtraPropOffset = vector3(0.0, 0.0, 1.0), -- Offset from the preprocessing prop position
        ProcessingProp = "fury_cfs_scrapper",
        ProcessingPropRotation = vector3(0, 0, 150),
        PreProcessingTime = 5000,
        ProcessingTime = 10000,
        ProcessingRequiredItems = 5,
        ProcessingGiveItems = 3,
        
        -- Visual Effects
        PreProcessingParticles = "ent_amb_sparking_wires",
        ProcessingParticles = "proj_flare_trail",
        ProcessingMeatParticles = "ent_brk_sparking_wires",
        
        -- Work Zones
        Zones = {
            {vector3(-450.0, -1680.0, 18.0), 40.0},
            {vector3(-530.0, -1690.0, 18.0), 50.0}
        },
        
        -- Scrap Vehicle Configuration
        ScrapVehiclePositions = {
            {
                vector4(-469.2401, -1673.0015, 18.0743, 180.2205),
                vector4(-468.9325, -1681.0719, 17.9984, 132.6104),
                vector4(-469.9391, -1689.3417, 17.9377, 180.2151),
                vector4(-464.9588, -1692.5735, 17.9187, 245.8539),
                vector4(-460.0424, -1664.5122, 18.0345, 271.9679),
                vector4(-450.3448, -1667.8490, 18.0291, 247.0388),
                vector4(-426.3660, -1676.6365, 18.0291, 209.9910),
                vector4(-425.8274, -1686.1599, 18.0291, 171.4211)
            },
            {
                vector4(-531.6277, -1715.6570, 18.1981, 74.5679),
                vector4(-517.5980, -1709.7047, 18.3199, 288.4510),
                vector4(-509.2293, -1715.6913, 18.3180, 234.9351),
                vector4(-510.5320, -1722.9036, 18.3116, 183.7283),
                vector4(-515.5330, -1705.9902, 18.2806, 2.4118),
                vector4(-521.7052, -1699.0203, 18.1615, 48.8373),
                vector4(-526.4152, -1690.0702, 18.1919, 26.6609),
                vector4(-538.0284, -1677.8762, 18.1878, 65.4265),
                vector4(-546.4670, -1668.9551, 18.1875, 16.4345),
                vector4(-551.7164, -1659.5791, 18.2526, 57.4223),
                vector4(-548.5882, -1640.6174, 17.9944, 326.6821)
            }
        },
        
        -- Vehicle Models and Properties
        ScrapVehicleModels = {
            "prop_rub_carwreck_12",
            "prop_rub_carwreck_13",
            "prop_rub_carwreck_14"
        },
        ScrapVehicleParticles = "proj_flare_trail",
        ScrapVehicleRespawn = 300000,
        
        -- Loot Configuration
        -- IMPORTANT: At least one item here must match Item1 to allow processing
        -- This is where players get their resources from scrapping vehicles
        ScrapItems = {
            {name = "petrol", chance = 10},
            {name = "broken_glass", chance = 50},
			{name = "iron", chance = 50},
			{name = "steel", chance = 50},
			{name = "plastic", chance = 50},
        },
        LootableProps = {
            "prop_dumpster_01a", "prop_dumpster_02a", "prop_dumpster_02b", "prop_dumpster_3a", "prop_dumpster_4a", "prop_dumpster_4b",
            "prop_bin_05a", "prop_bin_06a", "prop_bin_07a", "prop_bin_07b", "prop_bin_07c", "prop_bin_07d", "prop_bin_08a", "prop_bin_08open",
            "prop_bin_09a", "prop_bin_10a", "prop_bin_10b", "prop_bin_11a", "prop_bin_12a", "prop_bin_13a", "prop_bin_14a", "prop_bin_14b",
            "prop_bin_beach_01d", "prop_bin_delpiero", "prop_bin_delpiero_b", "prop_recyclebin_01a", "prop_recyclebin_02_c", "prop_recyclebin_02_d",
            "prop_recyclebin_02a", "prop_recyclebin_02b", "prop_recyclebin_03_a", "prop_recyclebin_04_a", "prop_recyclebin_04_b", "prop_recyclebin_05_a",
            "zprop_bin_01a_old", "hei_heist_kit_bin_01", "ch_prop_casino_bin_01a", "vw_prop_vw_casino_bin_01a", "mp_b_kit_bin_01"
        },
        LootableLockTime = 300000,
        -- Items that can be found when searching through trash containers
        TrashItems = {
            {name = "iron", chance = 15},
			{name = "steel", chance = 15},
			{name = "plastic", chance = 15},
            {name = "tin_can", chance = 80},
            {name = "scrap_paper", chance = 90},
            {name = "dirty_cloth", chance = 50},
            {name = "lockpick", chance = 10},
            {name = "carlockpick", chance = 10},
            {name = "caradvancedlockpick", chance = 10},
        }
    }
}

-- Animation System Configuration
Config.Animations = {
    ["Mining"] = {
        -- Animation Definitions
        Animations = {
            DigRock = {"melee@large_wpn@streamed_core", "ground_attack_0", 7000},
            Pickup = {"pickup_object", "pickup_low", 1250},
            PreProcess = {"amb@world_human_bum_wash@male@high@idle_a", "idle_a", -1},
            ProcessPour = {"anim@mp_player_intupperspray_champagne", "idle_a", -1},
            Process = {"anim@amb@business@cfm@cfm_cut_sheets@", "cut_guilotine_v1_billcutter", -1},
        },
        
        -- Prop Configuration
        Props = {
            ProcessingBag = "prop_cs_sack_01",
            ProcessingMeat = "prop_vintage_filmcan",
            Pickaxe = "prop_tool_pickaxe"
        },
        
        -- Tool Prop Settings
        ToolPropOptions = {
            bone = 18905, -- Bone index from GetPedBoneIndex
            offsetX = 0.2,
            offsetY = -0.1,
            offsetZ = 0.1,
            rotationX = 240.0,
            rotationY = 50.0,
            rotationZ = 710.0
        },
        
        -- Sounds Configuration (Custom Audio System)
        Sounds = {
            Enabled = true,           -- Enable/disable mining sounds
            Pickaxe = {
                File = "pickaxe_sound", -- Sound file in the sounds folder (without extension)
                Volume = 0.2           -- Volume (0.0 to 1.0)
            }
        }
    },
    ["Hunting"] = {
        -- Animation Definitions
        Animations = {
            SkinEnter = {"amb@world_human_gardener_plant@male@enter", "enter", -1},
            SkinBase = {"amb@world_human_gardener_plant@male@base", "base", -1},
            SkinExit = {"amb@world_human_gardener_plant@male@exit", "exit", 2000},
            PreProcess = {"anim@amb@business@cfm@cfm_cut_sheets@", "load_and_tune_guilotine_v1_billcutter", -1},
            ProcessPour = {"anim@mp_player_intupperspray_champagne", "idle_a", -1},
            Process = {"anim@amb@business@cfm@cfm_cut_sheets@", "cut_guilotine_v1_billcutter", -1},
        },
        
        -- Prop Configuration
        Props = {
            SkinPropModel = "prop_w_me_knife_01",
            ProcessingBag = "prop_cs_sack_01",
            ProcessingMeat = "prop_cs_steak",
            BoneProps = {
                "fury_cfh_bone_01",
                "fury_cfh_bone_02", 
                "fury_cfh_bone_03"
            }
        },
        
        -- Skin Prop Settings
        SkinPropOptions = {
            bone = 0xdead, -- SKEL_R_Hand
            offsetX = 0.11,
            offsetY = 0.02,
            offsetZ = -0.02,
            rotationX = 135.0,
            rotationY = 0.0,
            rotationZ = 0.0
        }
    },
    ["Fishing"] = {
        -- Animation Definitions
        Animations = {
            FishingBase = {"amb@world_human_stand_fishing@idle_a", "idle_a", -1},
            FishingCatching = {"amb@world_human_stand_fishing@idle_a", "idle_c", -1},
            PreProcess = {"anim@amb@business@cfm@cfm_cut_sheets@", "load_and_tune_guilotine_v2_billcutter", -1},
            ProcessPour = {"anim@mp_player_intupperspray_champagne", "idle_a", -1},
            Process = {"anim@amb@business@cfm@cfm_cut_sheets@", "cut_guilotine_v1_billcutter", -1},
        },
        
        -- Prop Configuration
        Props = {
            ProcessingBag = "prop_cs_sack_01",
            ProcessingMeat = "a_c_fish",
            FishingRodModel = "prop_fishing_rod_01",
            Fish = "a_c_fish"
        },
        
        -- Fishing Rod Settings
        FishingRodPropOptions = {
            bone = 18905, -- SKEL_R_Hand
            offsetX = 0.1,
            offsetY = 0.05,
            offsetZ = 0.0,
            rotationX = 70.0,
            rotationY = 120.0,
            rotationZ = 160.0
        }
    },
    ["Lumberjack"] = {
        -- Animation Definitions
        Animations = {
            CutTree = {"anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 5000},
            Pickup = {"pickup_object", "pickup_low", 1250},
            PreProcess = {"anim@amb@business@cfm@cfm_cut_sheets@", "load_and_tune_guilotine_v2_billcutter", -1},
            ProcessPour = {"anim@mp_player_intupperspray_champagne", "idle_a", -1},
            Process = {"anim@amb@business@cfm@cfm_cut_sheets@", "cut_guilotine_v1_billcutter", -1},
        },

        -- Prop Configuration
        Props = {
            ProcessingBag = "prop_cs_sack_01",
            ProcessingMeat = "prop_rub_planks_04",
            Axe = "fury_cf_chainsaw_01"
        },
        ToolPropOptions = {
            bone = 18905,
            offsetX = 0.36,
            offsetY = 0.04,
            offsetZ = -0.08,
            rotationX = 158.0,
            rotationY = 54.0,
            rotationZ = -10.0
        },

        -- Sounds Configuration (Custom Audio System)
        Sounds = {
            Enabled = true,           -- Enable/disable tree chopping sounds
            ChainSaw = {
                File = "chainsaw_sound", -- Sound file in the sounds folder (without extension)
                Volume = 0.1          -- Volume (0.0 to 1.0)
            }
        }
    },
    ["Farming"] = {
        -- Animation Definitions
        Animations = {
            Farm = {"amb@world_human_gardener_plant@male@base", "base", 5000},
            Pickup = {"pickup_object", "pickup_low", 1250},
            PreProcess = {"anim@amb@business@cfm@cfm_cut_sheets@", "load_and_tune_guilotine_v2_billcutter", -1},
            ProcessPour = {"anim@mp_player_intupperspray_champagne", "idle_a", -1},
            Process = {"anim@amb@business@cfm@cfm_cut_sheets@", "cut_guilotine_v1_billcutter", -1},
        },

        -- Prop Configuration
        Props = {
            ProcessingBag = "prop_cs_sack_01",
            ProcessingMeat = "bzzz_plants_onion_04",
            Hoe = "prop_cs_trowel"
        },
        ToolPropOptions = {
            bone = 0xdead,
            offsetX = 0.11,
            offsetY = 0.02,
            offsetZ = -0.02,
            rotationX = 135.0,
            rotationY = 0.0,
            rotationZ = 0.0
        },
    },
    ["Recycling"] = {
        -- Animation Definitions
        Animations = {
            SearchingTrash = {"amb@prop_human_bum_bin@base", "base", 5000},
            SearchingScrapVehicle = {"amb@prop_human_bum_bin@base", "base", 8000},
            Pickup = {"pickup_object", "pickup_low", 1250},

            PreProcess = {"anim@gangops@morgue@table@", "player_search", -1},
            ProcessPour = {"anim@mp_player_intupperspray_champagne", "idle_a", -1},
            Process = {"anim@amb@business@cfm@cfm_cut_sheets@", "cut_guilotine_v1_billcutter", -1},
        },  

        -- Prop Configuration
        Props = {
            ProcessingBag = "prop_cs_sack_01",
            ProcessingMeat = "prop_car_exhaust_01",
            Recycler = "fury_cfg_grinder_01"
        },

        -- Recycler Prop Settings
        RecyclerPropOptions = {
            bone = 18905,
            offsetX = 0.2,
            offsetY = 0.2,
            offsetZ = 0.0,
            rotationX = 250.0,
            rotationY = 40.0,
            rotationZ = 70.0
        },
        
        -- Sounds Configuration (Custom Audio System)
        Sounds = {
            Enabled = true,           -- Enable/disable recycling sounds
            Grinder = {
                File = "grinder_sound", -- Sound file in the sounds folder (without extension)
                Volume = 0.2           -- Volume (0.0 to 1.0)
            }
        }
    }
}

-- Level System Configuration
Config.Levels = {
    MaxLevel = 10, -- Maximum achievable level
    ExpPerLevel = 1000 -- Experience points required per level
}

-- Daily Missions System Configuration
Config.DailyMissions = {
    RefreshHours = 24, -- Time in hours for mission refresh
    MaxMissions = 3, -- Maximum missions per player per day

    -- Mining Missions
    ["Mining"] = {
        {
            Name = 'use_pickaxe',
            Label = 'USE THE PICKAXE {int} TIMES',
            MinMax = {5, 15},
            Prize = {50, 150}
        },
        {
            Name = 'dig_rock',
            Label = 'Mine <span>{int}</span> stones',
            MinMax = {5, 15},
            Prize = {50, 150}
        },
        {
            Name = 'process',
            Label = 'Wash <span>{int}</span> stones',
            MinMax = {5, 15},
            Prize = {50, 150}
        },
        {
            Name = 'sell_wholesale',
            Label = 'SELL {int} ITEMS IN WHOLESALE MODE',
            MinMax = {1000, 2000},
            Prize = {300, 500}
        },
        {
            Name = 'sell_retail',
            Label = 'SELL {int} ITEMS IN RETAIL MODE',
            MinMax = {3, 10},
            Prize = {100, 300}
        }
    },

    -- Hunting Missions
    ["Hunting"] = {
        {
            Name = 'use_shotgun',
            Label = 'USE THE SHOTGUN {int} TIMES',
            MinMax = {5, 15},
            Prize = {50, 150}
        },
        {
            Name = 'hunt_animal',
            Label = 'SUCCESSFULLY HUNT {int} ANIMALS',
            MinMax = {3, 10},
            Prize = {100, 300}
        },
        {
            Name = 'skin_animal',
            Label = 'SKIN {int} ANIMALS',
            MinMax = {5, 15},
            Prize = {50, 150}
        },
        {
            Name = 'process',
            Label = 'PROCESS {int} ITEMS',
            MinMax = {5, 15},
            Prize = {50, 150}
        },
        {
            Name = 'sell_wholesale',
            Label = 'SELL {int} ITEMS IN WHOLESALE MODE',
            MinMax = {1000, 2000},
            Prize = {300, 500}
        },
        {
            Name = 'sell_retail',
            Label = 'SELL {int} ITEMS IN RETAIL MODE',
            MinMax = {3, 10},
            Prize = {100, 300}
        }
    },

    -- Fishing Missions
    ["Fishing"] = {
        {
            Name = 'use_fishingrod',
            Label = 'USE THE FISHING ROD {int} TIMES',
            MinMax = {5, 15},
            Prize = {50, 150}
        },
        {
            Name = 'catch_fish',
            Label = 'CATCH FISH {int} TIMES',
            MinMax = {3, 10},
            Prize = {100, 150}
        },
        {
            Name = 'process',
            Label = 'PROCESS {int} ITEMS',
            MinMax = {5, 15},
            Prize = {50, 150}
        },
        {
            Name = 'sell_wholesale',
            Label = 'SELL {int} ITEMS IN WHOLESALE MODE',
            MinMax = {1000, 2000},
            Prize = {300, 500}
        },
        {
            Name = 'sell_retail',
            Label = 'SELL {int} ITEMS IN RETAIL MODE',
            MinMax = {3, 10},
            Prize = {100, 300}
        }
    },

    -- Lumberjack Missions
    ["Lumberjack"] = {
        {
            Name = 'use_axe',
            Label = 'Chop <span>{int}</span> wood',
            MinMax = {5, 15},
            Prize = {50, 150}
        },
        {
            Name = 'chop_wood',
            Label = 'Chop <span>{int}</span> wood',
            MinMax = {5, 15},
            Prize = {50, 150}
        },
        {
            Name = 'process',
            Label = 'PROCESS {int} ITEMS',
            MinMax = {5, 15},
            Prize = {50, 150}
        },
        {
            Name = 'sell_wholesale',
            Label = 'SELL {int} ITEMS IN WHOLESALE MODE',
            MinMax = {1000, 2000},
            Prize = {300, 500}
        },
        {
            Name = 'sell_retail',
            Label = 'SELL {int} ITEMS IN RETAIL MODE',
            MinMax = {3, 10},
            Prize = {100, 300}
        }
    },

    -- Farming Missions
    ["Farming"] = {
        {
            Name = 'harvest_crops',
            Label = 'Harvest {int} crops',
            MinMax = {5, 15},
            Prize = {50, 150}
        },
        {
            Name = 'sell_wholesale',
            Label = 'SELL {int} ITEMS IN WHOLESALE MODE',
            MinMax = {1000, 2000},
            Prize = {300, 500}
        },
        {
            Name = 'sell_retail',
            Label = 'SELL {int} ITEMS IN RETAIL MODE',
            MinMax = {3, 10},
            Prize = {100, 300}
        }
    },

    -- Recycling Missions
    ["Recycling"] = {
        {
            Name = 'use_recycler',
            Label = 'USE THE RECYCLER {int} TIMES',
            MinMax = {5, 15},
            Prize = {50, 150}
        },
        {
            Name = 'search_trash',
            Label = 'SEARCH TRASH {int} TIMES',
            MinMax = {5, 15},
            Prize = {50, 150}
        },
        {
            Name = 'scrap_vehicle',
            Label = 'SCRAP VEHICLE {int} TIMES',
            MinMax = {3, 10},
            Prize = {100, 300}
        },
        {
            Name = 'process',
            Label = 'PROCESS {int} ITEMS',
            MinMax = {5, 15},
            Prize = {50, 150}
        },
        {
            Name = 'sell_wholesale',
            Label = 'SELL {int} ITEMS IN WHOLESALE MODE',
            MinMax = {1000, 2000},
            Prize = {300, 500}
        },
        {
            Name = 'sell_retail',
            Label = 'SELL {int} ITEMS IN RETAIL MODE',
            MinMax = {3, 10},
            Prize = {100, 300}
        }
    }
}

-- Tools System Configuration
Config.Tools = {
    -- Mining Tools
    {
        {
            item = "pickaxe_1",
            image = "pickaxe_1.png", -- MODIFIED
            label = "Pickaxe I",
            level = 1,
            price = 500,
            prop = "prop_pickaxe_1",
            minReward = 1,
            maxReward = 2
        },
        {
            item = "pickaxe_2",
            image = "pickaxe_2.png", -- MODIFIED
            label = "Pickaxe II",
            level = 5,
            price = 2000,
            prop = "prop_pickaxe_2",
            minReward = 2,
            maxReward = 3
        },
        {
            item = "pickaxe_3",
            image = "pickaxe_3.png", -- MODIFIED
            label = "Pickaxe III",
            level = 10,
            price = 7500,
            prop = "prop_pickaxe_2",
            minReward = 4,
            maxReward = 5
        }
    },
    -- Hunting Tools
    {
        {
            item = "hunting_rifle_1",
            image = "hunting_rifle_1.png", -- MODIFIED
            label = "Rifle I",
            level = 1,
            price = 500,
            minReward = 1,
            maxReward = 2
        },
        {
            item = "hunting_rifle_2",
            image = "hunting_rifle_2.png", -- MODIFIED
            label = "Rifle II",
            level = 5,
            price = 2000,
            minReward = 2,
            maxReward = 3
        },
        {
            item = "hunting_rifle_3",
            image = "hunting_rifle_3.png", -- MODIFIED
            label = "Rifle III",
            level = 10,
            price = 7500,
            minReward = 4,
            maxReward = 5
        }
    },
    -- Fishing Tools
    {
        {
            item = "fishing_rod_1",
            image = "fishing_rod_1.png", -- MODIFIED
            label = "Rod I",
            level = 1,
            price = 500,
            minReward = 1,
            maxReward = 2
        },
        {
            item = "fishing_rod_2",
            image = "fishing_rod_2.png", -- MODIFIED
            label = "Rod II",
            level = 5,
            price = 2000,
            minReward = 2,
            maxReward = 3
        },
        {
            item = "fishing_rod_3",
            image = "fishing_rod_3.png", -- MODIFIED
            label = "Rod III",
            level = 10,
            price = 7500,
            minReward = 4,
            maxReward = 5
        }
    },
    -- Lumberjack Tools
    {
        {
            item = "axe_1",
            image = "axe_1.png", -- MODIFIED
            label = "Saw I",
            level = 1,
            price = 500,
            minReward = 1,
            maxReward = 2
        },
        {
            item = "axe_2",
            image = "axe_2.png", -- MODIFIED
            label = "Saw II",
            level = 5,
            price = 2000,
            minReward = 2,
            maxReward = 3
        },
        {
            item = "axe_3",
            image = "axe_3.png", -- MODIFIED
            label = "Saw III",
            level = 10,
            price = 7500,
            minReward = 4,
            maxReward = 5
        }
    },
    -- Farming Tools
    {
        {
            item = "hoe_1",
            image = "hoe_1.png", -- MODIFIED
            label = "Hoe I",
            level = 1,
            price = 500,
            minReward = 1,
            maxReward = 2
        },
        {
            item = "hoe_2",
            image = "hoe_2.png", -- MODIFIED
            label = "Hoe II",
            level = 5,
            price = 2000,
            minReward = 2,
            maxReward = 3
        },
        {
            item = "hoe_3",
            image = "hoe_3.png", -- MODIFIED
            label = "Hoe III",
            level = 10,
            price = 7500,
            minReward = 4,
            maxReward = 5
        }
    },
    -- Recycling Tools
    {
        {
            item = "recycler_1",
            image = "recycler_1.png", -- MODIFIED
            label = "Recycler I",
            level = 1,
            price = 500,
            minReward = 1,
            maxReward = 2
        },
        {
            item = "recycler_2",
            image = "recycler_2.png", -- MODIFIED
            label = "Recycler II",
            level = 5,
            price = 2000,
            minReward = 2,
            maxReward = 3
        },
        {
            item = "recycler_3",
            image = "recycler_3.png", -- MODIFIED
            label = "Recycler III",
            level = 10,
            price = 7500,
            minReward = 4,
            maxReward = 5
        }
    }
}

-- Sell Shop Configuration
Config.SellShop = {
    -- Shop Settings
    EnableSellShop = true,
    RetailItemQuantity = 10,    -- Maximum items for retail sales
    WholesaleItemQuantity = 100, -- Maximum items for wholesale sales

    -- Items that can be sold for each job
    ItemsForSale = {
        -- Mining Job Items
        ["Mining"] = {

            ["final_stone_product"] = {
                image = "final_stone_product.png", 
                priceRetail = 1200,
                priceWholesale = 1400
            },
            ["gold"] = {
                image = "gold.png", 
                priceRetail = 1200,     
                priceWholesale = 1400
            },
            ["diamond"] = {
                image = "diamond.png", 
                priceRetail = 2100,     
                priceWholesale = 2500
            },
            ["stone"] = {
                image = "stone.png", 
                priceRetail = 800,     
                priceWholesale = 1000
            },
        },
    
        -- Hunting Job Items
        ["Hunting"] = {
            ["final_meat_product"] = {
                image = "final_meat_product.png", 
                priceRetail = 1000, 
                priceWholesale = 1500
            },
            ["raw_meat"] = {
                image = "raw_meat.png", 
                priceRetail = 500,     
                priceWholesale = 800
            }
        },
    
        -- Fishing Job Items
        ["Fishing"] = {
            ["final_fish_product"] = {
                image = "final_fish_product.png", 
                priceRetail = 1000,     
                priceWholesale = 1500
            },
            ["fish_meat"] = {
                image = "fish_meat.png", 
                priceRetail = 600,     
                priceWholesale = 800
            },
            ["fish_oilslimy"] = {
                image = "fish_oilslimy.png", 
                priceRetail = 500,     
                priceWholesale = 800
            },
            ["fish_oceanpearl"] = {
                image = "fish_oceanpearl.png", 
                priceRetail = 1000,     
                priceWholesale = 1500
            },
            ["fish_gemscale"] = {
                image = "fish_gemscale.png", 
                priceRetail = 1500,     
                priceWholesale = 2000
            }
        },
    
        -- Lumberjack Job Items 
        ["Lumberjack"] = {
            ["plank"] = {
                image = "plank.png", 
                priceRetail = 1200,     
                priceWholesale = 1500
            },
            ["wood"] = {
                image = "wood.png", 
                priceRetail = 400,     
                priceWholesale = 600
            },
            ["processed_wood"] = {
                image = "processed_wood.png", 
                priceRetail = 800,     
                priceWholesale = 1000
            }
        },

    
        -- Farming Job Items
        ["Farming"] = {
            ["packaged_produce"] = {
                image = "packaged_produce.png", 
                priceRetail = 1300,     
                priceWholesale = 1500
            },
            ["crop"] = {
                image = "crop.png", 
                priceRetail = 300,     
                priceWholesale = 400
            },
            ["processed_crop"] = {
                image = "processed_crop.png", 
                priceRetail = 800,     
                priceWholesale = 1000
            }
        },
    
        -- Recycling Job Items
        ["Recycling"] = {
            ["recycled_material"] = {
                image = "recycled_material.png", 
                priceRetail = 2000,     
                priceWholesale = 2200
            },
            ["petrol"] = {
                image = "petrol.png", 
                priceRetail = 300,     
                priceWholesale = 500
            },
            ["iron"] = {
                image = "iron.png", 
                priceRetail = 30,     
                priceWholesale = 50
            },
            ["steel"] = {
                image = "iron.png", 
                priceRetail = 30,     
                priceWholesale = 50
            },
            ["plastic"] = {
                image = "iron.png", 
                priceRetail = 20,     
                priceWholesale = 30
            },
            ["tin_can"] = {
                image = "tin_can.png", 
                priceRetail = 80,
                priceWholesale = 100
            },
            ["scrap_paper"] = {
                image = "scrap_paper.png", 
                priceRetail = 60,     
                priceWholesale = 80
            },
            ["broken_glass"] = {
                image = "broken_glass.png", 
                priceRetail = 70,     
                priceWholesale = 90
            },
            ["plastic_debris"] = {
                image = "plastic_debris.png", 
                priceRetail = 10,     
                priceWholesale = 20
            },
            ["dirty_cloth"] = {
                image = "dirty_cloth.png", 
                priceRetail = 75,     
                priceWholesale = 85
            }
        }
    }
}

-- Localization System Configuration
Config.Locales = {
    -- English Translations
    ['en'] = {
        -- Notification Messages
        notifications = {
            NotEnoughItems = "You don't have enough items for this action.",
            RequiredItems = "You need {int} items to complete this action.",
            InventoryFull = "Your inventory is full.",
            MaxLevelReached = "You have reached the maximum level for this job.",
            LevelUp = "Congratulations! You have reached level {int}.",
            MissionCompleted = "Mission completed! You received {int} XP.",
            ToolClaimed = "You have claimed your {string}.",
            ToolUsed = "Using tool...",
            ToolMissing = "You are missing the required tool to perform this action.",
            ToolNotAvailableOutsideZone = "This tool can only be used within designated zones.",
            ToolRemoved = "The tool has been removed as you left the area.",
            ToolRemovedInventory = "You do not longer have tool in your inventory.",
            ProcessingStart = "Processing...",
            SkillCheckFailed = "You failed the skill check.",
            ProcessingComplete = "Processing complete! You received {int}.",
            SaleXP = "You gained %d XP from selling items.",
            CannotUseTool = "You cannot use this tool yet. Reach level {int} to unlock it.",
            ItemReceived = "You have received {string} {int}.",
            NoMoreItemsToProcess = "You have no more items to process.",
            MachineInUse = "This machine is currently in use by another player.",
            AlreadyProcessing = "You are already using another machine.",
            NotInProcess = "You are not currently in this process.",
            AreaAlreadySearched = "It seems someone has already searched here.",
            NotNearWater = "You need to be near the sea to use the fishing rod.",
            SomethingBitten = "Something has bitten!",
            NoCatch = "Oh no, you didn't catch anything.",
            Caught = "Great! You have caught: [{string}]",
            CannotInteract = "You cannot interact with this right now.",
            NotEnoughMoney = "You don't have enough money to afford this.",
            PressToStop = "Press any move key to stop.",
            CantFarmMultiple = "You can't farm more than one at once.",
            SellLimitReached = "You have reached sell limit for today.",
            CantSellMoreItems = "You cannot sell more stuff today.",
            GoToWater = "You can fish in any body of water. Head to the nearest one!",
            JobRestricted = "You don't have the required job for this activity.",
            KnifeRequired = "You need {string} to skin the animal."
        },
        -- Target Interaction Messages
        target = {
            Talk = "Talk with {string}",
            Farm = "Interact with",
            Process1 = "Process [{string}]",
            Process2 = "Finalize [{string}]",
            SkinAnimal = "Skin Animal",
            PickupItem = "Pick Up",
            PickupFish = "Pickup fish",
            DiscardFish = "Discard fish",
            SearchTrash = "Search trash",
            Fish = "Press [E] to pickup\nPress [G] to discard"
        },
        -- Minigames
        minigames = {
            SkillCheckTitle = "Skill Check",
            FishCatchingTitle = "Fish catching!"
        }
    },

    -- Spanish Translations
    ['es'] = {
        -- Notification Messages
        notifications = {
            NotEnoughItems = "No tienes suficientes ítems para esta acción.",
            RequiredItems = "Necesitas {int} objetos para completar esta acción.",
            InventoryFull = "Tu inventario está lleno.",
            MaxLevelReached = "Has alcanzado el nivel máximo para este trabajo.",
            LevelUp = "¡Felicidades! Has alcanzado el nivel {int}.",
            MissionCompleted = "¡Misión completada! Has recibido {int} XP.",
            ToolClaimed = "Has reclamado tu {string}.",
            ToolUsed = "Usando herramienta...",
            ToolMissing = "Te falta la herramienta necesaria para realizar esta acción.",
            ToolNotAvailableOutsideZone = "Esta herramienta solo se puede usar en zonas designadas.",
            ToolRemoved = "La herramienta ha sido eliminada al salir del área.",
            ToolRemovedInventory = "Ya no tienes la herramienta en tu inventario.",
            ProcessingStart = "Procesando...",
            SkillCheckFailed = "Has fallado la prueba de habilidad.",
            ProcessingComplete = "¡Procesamiento completo! Has recibido {int}.",
            SaleXP = "Has ganado %d XP por vender ítems.",
            CannotUseTool = "No puedes usar esta herramienta aún. Alcanza el nivel {int} para desbloquearla.",
            ItemReceived = "Has recibido {string} x{int}.",
            NoMoreItemsToProcess = "No tienes más ítems para procesar.",
            MachineInUse = "Esta máquina está siendo utilizada por otro jugador.",
            AlreadyProcessing = "Ya estás usando otra máquina.",
            NotInProcess = "No estás actualmente en este proceso.",
            AreaAlreadySearched = "Parece que alguien ya ha buscado aquí.",
            NotNearWater = "Necesitas estar cerca del mar para usar la caña de pescar.",
            SomethingBitten = "¡Ha picado algo!",
            NoCatch = "Oh vaya, no has pescado nada.",
            Caught = "¡Genial! Has pescado: [{string}]",
            CannotInteract = "No puedes interactuar con esto ahora mismo.",
            NotEnoughMoney = "No tienes suficiente dinero para permitirte esto.",
            PressToStop = "Presiona cualquier tecla de movimiento para detenerte.",
            CantFarmMultiple = "No puedes farmear más de uno a la vez.",
            SellLimitReached = "Has alcanzado el límite de venta para hoy.",
            CantSellMoreItems = "No puedes vender más cosas hoy.",
            GoToWater = "Puedes pescar en cualquier masa de agua. ¡Dirígete a la más cercana!",
            JobRestricted = "No tienes el trabajo requerido para esta actividad.",
            KnifeRequired = "Necesitas {string} para despellejar el animal."
        },
        -- Target Interaction Messages
        target = {
            Talk = "Hablar con {string}",
            Farm = "Interactuar con",
            Process1 = "Procesar {string}",
            Process2 = "Finalizar {string}",
            SkinAnimal = "Despellejar Animal",
            PickupItem = "Recoger",
            PickupFish = "Recoger pescado",
            DiscardFish = "Descartar pescado",
            SearchTrash = "Buscar en la Basura",
            Fish = "Presiona [E] para recoger\nPresiona [G] para descartar"
        },
        -- Minigames
        minigames = {
            SkillCheckTitle = "Prueba de Habilidad",
            FishCatchingTitle = "¡Pescando!"
        }
    },

    -- French Translations (fr)
    ['fr'] = {
        notifications = {
            NotEnoughItems = "Vous n'avez pas assez d'objets pour cette action.",
            RequiredItems = "Vous avez besoin de {int} objets pour terminer cette action.",
            InventoryFull = "Votre inventaire est plein.",
            MaxLevelReached = "Vous avez atteint le niveau maximum pour ce métier.",
            LevelUp = "Félicitations ! Vous avez atteint le niveau {int}.",
            MissionCompleted = "Mission terminée ! Vous avez reçu {int} XP.",
            ToolClaimed = "Vous avez réclamé votre {string}.",
            ToolUsed = "Utilisation de l'outil...",
            ToolMissing = "Il vous manque l'outil requis pour effectuer cette action.",
            ToolNotAvailableOutsideZone = "Cet outil ne peut être utilisé que dans les zones désignées.",
            ToolRemoved = "L'outil a été retiré car vous avez quitté la zone.",
            ToolRemovedInventory = "Vous n'avez plus l'outil dans votre inventaire.",
            ProcessingStart = "Traitement en cours...",
            SkillCheckFailed = "Vous avez échoué au test d'habileté.",
            ProcessingComplete = "Traitement terminé ! Vous avez reçu {int}.",
            SaleXP = "Vous avez gagné %d XP en vendant des objets.",
            CannotUseTool = "Vous ne pouvez pas encore utiliser cet outil. Atteignez le niveau {int} pour le débloquer.",
            ItemReceived = "Vous avez reçu {string} {int}.",
            NoMoreItemsToProcess = "Vous n'avez plus d'objets à traiter.",
            MachineInUse = "Cette machine est actuellement utilisée par un autre joueur.",
            AlreadyProcessing = "Vous êtes déjà en train de traiter un autre objet.",
            NotInProcess = "Vous n'êtes pas actuellement en train de traiter un objet.",
            AreaAlreadySearched = "Il semble que quelqu'un ait déjà cherché ici.",
            NotNearWater = "Vous devez être près de la mer pour utiliser la canne à pêche.",
            SomethingBitten = "Quelque chose a mordu !",
            NoCatch = "Oh non, vous n'avez rien attrapé.",
            Caught = "Super ! Vous avez attrapé : [{string}]",
            CannotInteract = "Vous ne pouvez pas interagir avec ceci pour le moment.",
            NotEnoughMoney = "Vous n'avez pas assez d'argent pour cela.",
            PressToStop = "Appuyez sur n'importe quelle touche de mouvement pour arrêter.",
            CantFarmMultiple = "Vous ne pouvez pas farmer plus d'un à la fois.",
            SellLimitReached = "Vous avez atteint la limite de vente pour aujourd'hui.",
            CantSellMoreItems = "Vous ne pouvez plus vendre d'articles aujourd'hui.",
            GoToWater = "Vous pouvez pêcher dans n'importe quel point d'eau. Dirigez-vous vers le plus proche !",
            JobRestricted = "Vous n'avez pas l'emploi requis pour cette activité.",
            KnifeRequired = "Vous avez besoin de {string} pour dépecer l'animal."
        },
        target = {
            Talk = "Parler avec {string}",
            Farm = "Interagir avec",
            Process1 = "Traiter [{string}]",
            Process2 = "Finaliser [{string}]",
            SkinAnimal = "Dépecer l'animal",
            PickupItem = "Ramasser",
            PickupFish = "Ramasser le poisson",
            DiscardFish = "Jeter le poisson",
            SearchTrash = "Fouiller la poubelle",
            Fish = "Appuyez sur [E] pour ramasser\nAppuyez sur [G] pour jeter"
        },
        minigames = {
            SkillCheckTitle = "Test d'habileté",
            FishCatchingTitle = "Pêche en cours !"
        }
    },

    -- German Translations (de)
    ['de'] = {
        notifications = {
            NotEnoughItems = "Du hast nicht genügend Gegenstände für diese Aktion.",
            RequiredItems = "Du benötigst {int} Gegenstände, um diese Aktion abzuschließen.",
            InventoryFull = "Dein Inventar ist voll.",
            MaxLevelReached = "Du hast das maximale Level für diesen Job erreicht.",
            LevelUp = "Herzlichen Glückwunsch! Du hast Level {int} erreicht.",
            MissionCompleted = "Mission abgeschlossen! Du hast {int} EP erhalten.",
            ToolClaimed = "Du hast dein {string} erhalten.",
            ToolUsed = "Werkzeug wird benutzt...",
            ToolMissing = "Dir fehlt das erforderliche Werkzeug für diese Aktion.",
            ToolNotAvailableOutsideZone = "Dieses Werkzeug kann nur in ausgewiesenen Zonen verwendet werden.",
            ToolRemoved = "Das Werkzeug wurde entfernt, da du das Gebiet verlassen hast.",
            ToolRemovedInventory = "Du hast das Werkzeug nicht mehr im Inventar.",
            ProcessingStart = "Verarbeitung läuft...",
            SkillCheckFailed = "Du hast den Skill-Check nicht bestanden.",
            ProcessingComplete = "Verarbeitung abgeschlossen! Du hast {int} erhalten.",
            SaleXP = "Du hast %d EP durch den Verkauf von Gegenständen erhalten.",
            CannotUseTool = "Du kannst dieses Werkzeug noch nicht benutzen. Erreiche Level {int}, um es freizuschalten.",
            ItemReceived = "Du hast {string} {int} erhalten.",
            NoMoreItemsToProcess = "Du hast keine weiteren Gegenstände zum Verarbeiten.",
            MachineInUse = "Diese Maschine wird gerade von einem anderen Spieler benutzt.",
            AlreadyProcessing = "You are already using another machine.",
            NotInProcess = "You are not currently in this process.",
            AreaAlreadySearched = "Es scheint, als hätte hier schon jemand gesucht.",
            NotNearWater = "Du musst dich in der Nähe des Meeres befinden, um die Angel zu benutzen.",
            SomethingBitten = "Etwas hat angebissen!",
            NoCatch = "Oh nein, du hast nichts gefangen.",
            Caught = "Großartig! Du hast gefangen: [{string}]",
            CannotInteract = "Du kannst hiermit gerade nicht interagieren.",
            NotEnoughMoney = "Du hast nicht genug Geld dafür.",
            PressToStop = "Drücke eine Bewegungstaste, um zu stoppen.",
            CantFarmMultiple = "Du kannst nicht mehr als eines gleichzeitig farmen.",
            SellLimitReached = "Du hast das Verkaufslimit für heute erreicht.",
            CantSellMoreItems = "Du kannst heute keine weiteren Artikel verkaufen.",
            GoToWater = "Du kannst in jedem Gewässer angeln. Geh zum nächstgelegenen!",
            JobRestricted = "Du hast nicht den erforderlichen Job für diese Aktivität.",
            KnifeRequired = "Du brauchst {string}, um das Tier zu häuten."
        },
        target = {
            Talk = "Sprechen mit {string}",
            Farm = "Interagieren mit",
            Process1 = "Verarbeiten [{string}]",
            Process2 = "Fertigstellen [{string}]",
            SkinAnimal = "Tier häuten",
            PickupItem = "Aufheben",
            PickupFish = "Fisch aufheben",
            DiscardFish = "Fisch wegwerfen",
            SearchTrash = "Müll durchsuchen",
            Fish = "Drücke [E] zum Aufheben\nDrücke [G] zum Wegwerfen"
        },
        minigames = {
            SkillCheckTitle = "Skill-Check",
            FishCatchingTitle = "Fischfang!"
        }
    },

    -- Portuguese Translations (pt)
    ['pt'] = {
        notifications = {
            NotEnoughItems = "Você não tem itens suficientes para esta ação.",
            RequiredItems = "Você precisa de {int} itens para completar esta ação.",
            InventoryFull = "Seu inventário está cheio.",
            MaxLevelReached = "Você atingiu o nível máximo para este trabalho.",
            LevelUp = "Parabéns! Você atingiu o nível {int}.",
            MissionCompleted = "Missão concluída! Você recebeu {int} XP.",
            ToolClaimed = "Você reivindicou seu {string}.",
            ToolUsed = "Usando ferramenta...",
            ToolMissing = "Você não tem a ferramenta necessária para realizar esta ação.",
            ToolNotAvailableOutsideZone = "Esta ferramenta só pode ser usada em zonas designadas.",
            ToolRemoved = "A ferramenta foi removida ao sair da área.",
            ToolRemovedInventory = "Você não tem mais a ferramenta no inventário.",
            ProcessingStart = "Processando...",
            SkillCheckFailed = "Você falhou no teste de habilidade.",
            ProcessingComplete = "Processamento concluído! Você recebeu {int}.",
            SaleXP = "Você ganhou %d XP vendendo itens.",
            CannotUseTool = "Você ainda não pode usar esta ferramenta. Alcance o nível {int} para desbloqueá-la.",
            ItemReceived = "Você recebeu {string} {int}.",
            NoMoreItemsToProcess = "Você não tem mais itens para processar.",
            MachineInUse = "Esta máquina está sendo usada por outro jogador.",
            AlreadyProcessing = "You are already using another machine.",
            NotInProcess = "You are not currently in this process.",
            AreaAlreadySearched = "Parece que alguém já procurou aqui.",
            NotNearWater = "Você precisa estar perto do mar para usar a vara de pescar.",
            SomethingBitten = "Algo mordeu!",
            NoCatch = "Oh não, você não pegou nada.",
            Caught = "Ótimo! Você pegou: [{string}]",
            CannotInteract = "Você não pode interagir com isto agora.",
            NotEnoughMoney = "Você não tem dinheiro suficiente para isso.",
            PressToStop = "Pressione qualquer tecla de movimento para parar.",
            CantFarmMultiple = "Você não pode farmar mais de um de cada vez.",
            SellLimitReached = "Você atingiu o limite de venda para hoje.",
            CantSellMoreItems = "Você não pode vender mais itens hoje.",
            GoToWater = "Você pode pescar em qualquer corpo de água. Vá para o mais próximo!",
            JobRestricted = "Você não tem o trabalho necessário para esta atividade.",
            KnifeRequired = "Você precisa de {string} para esfolar o animal."
        },
        target = {
            Talk = "Falar com {string}",
            Farm = "Interagir com",
            Process1 = "Processar [{string}]",
            Process2 = "Finalizar [{string}]",
            SkinAnimal = "Esfolar Animal",
            PickupItem = "Pegar",
            PickupFish = "Pegar peixe",
            DiscardFish = "Descartar peixe",
            SearchTrash = "Procurar no lixo",
            Fish = "Pressione [E] para pegar\nPressione [G] para descartar"
        },
        minigames = {
            SkillCheckTitle = "Teste de Habilidade",
            FishCatchingTitle = "Pescando!"
        }
    },

    -- Turkish Translations (tr)
    ['tr'] = {
        notifications = {
            NotEnoughItems = "Bu eylem için yeterli eşyanız yok.",
            RequiredItems = "Bu eylemi tamamlamak için {int} eşyaya ihtiyacınız var.",
            InventoryFull = "Envanteriniz dolu.",
            MaxLevelReached = "Bu meslek için maksimum seviyeye ulaştınız.",
            LevelUp = "Tebrikler! Seviye {int} oldunuz.",
            MissionCompleted = "Görev tamamlandı! {int} XP kazandınız.",
            ToolClaimed = "{string} aletinizi aldınız.",
            ToolUsed = "Alet kullanılıyor...",
            ToolMissing = "Bu eylemi gerçekleştirmek için gerekli alete sahip değilsiniz.",
            ToolNotAvailableOutsideZone = "Bu alet yalnızca belirlenmiş bölgelerde kullanılabilir.",
            ToolRemoved = "Bölgeden ayrıldığınız için alet kaldırıldı.",
            ToolRemovedInventory = "Artık envanterinizde alet bulunmuyor.",
            ProcessingStart = "İşleniyor...",
            SkillCheckFailed = "Beceri testinde başarısız oldunuz.",
            ProcessingComplete = "İşlem tamamlandı! {int} aldınız.",
            SaleXP = "Eşya satarak %d XP kazandınız.",
            CannotUseTool = "Bu aleti henüz kullanamazsınız. Kilidi açmak için seviye {int}'e ulaşın.",
            ItemReceived = "{string} {int} aldınız.",
            NoMoreItemsToProcess = "İşlenecek başka eşyanız yok.",
            MachineInUse = "Bu makine şu anda başka bir oyuncu tarafından kullanılıyor.",
            AlreadyProcessing = "You are already using another machine.",
            NotInProcess = "You are not currently in this process.",
            AreaAlreadySearched = "Görünüşe göre birisi burayı zaten aramış.",
            NotNearWater = "Olta kullanmak için denize yakın olmalısınız.",
            SomethingBitten = "Bir şey ısırdı!",
            NoCatch = "Oh hayır, hiçbir şey yakalayamadınız.",
            Caught = "Harika! Yakaladınız: [{string}]",
            CannotInteract = "Şu anda bununla etkileşim kuramazsınız.",
            NotEnoughMoney = "Bunu karşılayacak kadar paranız yok.",
            PressToStop = "Durdurmak için herhangi bir hareket tuşuna basın.",
            CantFarmMultiple = "Aynı anda birden fazla farm yapamazsınız.",
            SellLimitReached = "Bugünkü satış limitine ulaştınız.",
            CantSellMoreItems = "Bugün daha fazla eşya satamazsınız.",
            GoToWater = "Herhangi bir su kütlesinde balık tutabilirsiniz. En yakındakine gidin!",
            JobRestricted = "Bu etkinlik için gerekli işe sahip değilsiniz.",
            KnifeRequired = "Hayvanı yüzmek için {string} gerekiyor."
        },
        target = {
            Talk = "{string} ile konuş",
            Farm = "Etkileşime gir",
            Process1 = "İşle [{string}]",
            Process2 = "Sonlandır [{string}]",
            SkinAnimal = "Hayvanı Yüz",
            PickupItem = "Al",
            PickupFish = "Balığı al",
            DiscardFish = "Balığı at",
            SearchTrash = "Çöpü ara",
            Fish = "Almak için [E] tuşuna basın\nAtmak için [G] tuşuna basın"
        },
        minigames = {
            SkillCheckTitle = "Beceri Testi",
            FishCatchingTitle = "Balık tutma!"
        }
    },

    -- Arabic Translations (ar)
    ['ar'] = {
        notifications = {
            NotEnoughItems = "ليس لديك عناصر كافية لهذا الإجراء.",
            RequiredItems = "أنت بحاجة إلى {int} عناصر لإكمال هذا الإجراء.",
            InventoryFull = "مخزونك ممتلئ.",
            MaxLevelReached = "لقد وصلت إلى المستوى الأقصى لهذه الوظيفة.",
            LevelUp = "تهانينا! لقد وصلت إلى المستوى {int}.",
            MissionCompleted = "اكتملت المهمة! لقد تلقيت {int} XP.",
            ToolClaimed = "لقد استلمت {string} الخاص بك.",
            ToolUsed = "جارٍ استخدام الأداة...",
            ToolMissing = "أنت تفتقد الأداة المطلوبة لتنفيذ هذا الإجراء.",
            ToolNotAvailableOutsideZone = "لا يمكن استخدام هذه الأداة إلا في المناطق المخصصة.",
            ToolRemoved = "تمت إزالة الأداة لأنك غادرت المنطقة.",
            ToolRemovedInventory = "لم تعد الأداة موجودة في مخزونك.",
            ProcessingStart = "جارٍ المعالجة...",
            SkillCheckFailed = "لقد فشلت في اختبار المهارة.",
            ProcessingComplete = "اكتملت المعالجة! لقد تلقيت {int}.",
            SaleXP = "لقد كسبت %d XP من بيع العناصر.",
            CannotUseTool = "لا يمكنك استخدام هذه الأداة بعد. قم بالوصول إلى المستوى {int} لفتحها.",
            ItemReceived = "لقد تلقيت {string} {int}.",
            NoMoreItemsToProcess = "ليس لديك المزيد من العناصر لمعالجتها.",
            MachineInUse = "هذه الآلة قيد الاستخدام حاليًا من قبل لاعب آخر.",
            AlreadyProcessing = "You are already using another machine.",
            NotInProcess = "You are not currently in this process.",
            AreaAlreadySearched = "يبدو أن شخصًا ما قد بحث هنا بالفعل.",
            NotNearWater = "يجب أن تكون بالقرب من البحر لاستخدام صنارة الصيد.",
            SomethingBitten = "شيء ما قد عض!",
            NoCatch = "أوه لا، لم تصطد أي شيء.",
            Caught = "رائع! لقد اصطدت: [{string}]",
            CannotInteract = "لا يمكنك التفاعل مع هذا الآن.",
            NotEnoughMoney = "ليس لديك ما يكفي من المال لتحمل هذا.",
            PressToStop = "اضغط على أي مفتاح حركة للتوقف.",
            CantFarmMultiple = "لا يمكنك جمع أكثر من عنصر في نفس الوقت.",
            SellLimitReached = "لقد وصلت إلى حد البيع لهذا اليوم.",
            CantSellMoreItems = "لا يمكنك بيع المزيد من الأشياء اليوم.",
            GoToWater = "يمكنك الصيد في أي مسطح مائي. توجه إلى الأقرب!",
            JobRestricted = "ليس لديك الوظيفة المطلوبة لهذا النشاط.",
            KnifeRequired = "تحتاج إلى {string} لسلخ الحيوان."
        },
        target = {
            Talk = "تحدث مع {string}",
            Farm = "تفاعل مع",
            Process1 = "معالجة [{string}]",
            Process2 = "إنهاء [{string}]",
            SkinAnimal = "سلخ الحيوان",
            PickupItem = "التقاط",
            PickupFish = "التقاط السمكة",
            DiscardFish = "تجاهل السمكة",
            SearchTrash = "بحث في القمامة",
            Fish = "اضغط [E] للالتقاط\nاضغط [G] للتجاهل"
        },
        minigames = {
            SkillCheckTitle = "اختبار المهارة",
            FishCatchingTitle = "صيد السمك!"
        }
    },

    -- Italian Translations (it)
    ['it'] = {
        notifications = {
            NotEnoughItems = "Non hai abbastanza oggetti per questa azione.",
            RequiredItems = "Hai bisogno di {int} oggetti per completare questa azione.",
            InventoryFull = "Il tuo inventario è pieno.",
            MaxLevelReached = "Hai raggiunto il livello massimo per questo lavoro.",
            LevelUp = "Congratulazioni! Hai raggiunto il livello {int}.",
            MissionCompleted = "Missione completata! Hai ricevuto {int} XP.",
            ToolClaimed = "Hai reclamato il tuo {string}.",
            ToolUsed = "Utilizzo dello strumento...",
            ToolMissing = "Ti manca lo strumento necessario per eseguire questa azione.",
            ToolNotAvailableOutsideZone = "Questo strumento può essere utilizzato solo nelle zone designate.",
            ToolRemoved = "Lo strumento è stato rimosso perché hai lasciato l'area.",
            ToolRemovedInventory = "Non hai più lo strumento nel tuo inventario.",
            ProcessingStart = "Elaborazione in corso...",
            SkillCheckFailed = "Hai fallito il test di abilità.",
            ProcessingComplete = "Elaborazione completata! Hai ricevuto {int}.",
            SaleXP = "Hai guadagnato %d XP vendendo oggetti.",
            CannotUseTool = "Non puoi ancora usare questo strumento. Raggiungi il livello {int} per sbloccarlo.",
            ItemReceived = "Hai ricevuto {string} {int}.",
            NoMoreItemsToProcess = "Non hai più oggetti da elaborare.",
            MachineInUse = "Questa macchina è attualmente in uso da un altro giocatore.",
            AlreadyProcessing = "You are already using another machine.",
            NotInProcess = "You are not currently in this process.",
            AreaAlreadySearched = "Sembra che qualcuno abbia già cercato qui.",
            NotNearWater = "Devi essere vicino al mare per usare la canna da pesca.",
            SomethingBitten = "Qualcosa ha abboccato!",
            NoCatch = "Oh no, non hai pescato niente.",
            Caught = "Fantastico! Hai pescato: [{string}]",
            CannotInteract = "Non puoi interagire con questo ora.",
            NotEnoughMoney = "Non hai abbastanza soldi per questo.",
            PressToStop = "Premi un tasto qualsiasi di movimento per fermarti.",
            CantFarmMultiple = "Non puoi raccogliere più di uno alla volta.",
            SellLimitReached = "Hai raggiunto il limite di vendita per oggi.",
            CantSellMoreItems = "Non puoi vendere altri oggetti oggi.",
            GoToWater = "Puoi pescare in qualsiasi specchio d'acqua. Dirigiti a quello più vicino!",
            JobRestricted = "Non hai il lavoro richiesto per questa attività.",
            KnifeRequired = "Hai bisogno di {string} per scuoiare l'animale."
        },
        target = {
            Talk = "Parla con {string}",
            Farm = "Interagisci con",
            Process1 = "Elabora [{string}]",
            Process2 = "Finalizza [{string}]",
            SkinAnimal = "Scuoia Animale",
            PickupItem = "Raccogli",
            PickupFish = "Raccogli pesce",
            DiscardFish = "Scarta pesce",
            SearchTrash = "Cerca nella spazzatura",
            Fish = "Premi [E] per raccogliere\nPremi [G] per scartare"
        },
        minigames = {
            SkillCheckTitle = "Test di Abilità",
            FishCatchingTitle = "Pesca!"
        }
    },

    -- Russian Translations (ru)
    ['ru'] = {
        notifications = {
            NotEnoughItems = "У вас недостаточно предметов для этого действия.",
            RequiredItems = "Вам нужно {int} предметов, чтобы завершить это действие.",
            InventoryFull = "Ваш инвентарь полон.",
            MaxLevelReached = "Вы достигли максимального уровня для этой работы.",
            LevelUp = "Поздравляем! Вы достигли {int} уровня.",
            MissionCompleted = "Миссия выполнена! Вы получили {int} XP.",
            ToolClaimed = "Вы забрали свой {string}.",
            ToolUsed = "Использование инструмента...",
            ToolMissing = "У вас отсутствует необходимый инструмент для выполнения этого действия.",
            ToolNotAvailableOutsideZone = "Этот инструмент можно использовать только в обозначенных зонах.",
            ToolRemoved = "Инструмент был удален, так как вы покинули зону.",
            ToolRemovedInventory = "У вас больше нет инструмента в инвентаре.",
            ProcessingStart = "Обработка...",
            SkillCheckFailed = "Вы провалили проверку навыка.",
            ProcessingComplete = "Обработка завершена! Вы получили {int}.",
            SaleXP = "Вы получили %d XP за продажу предметов.",
            CannotUseTool = "Вы еще не можете использовать этот инструмент. Достигните {int} уровня, чтобы разблокировать его.",
            ItemReceived = "Вы получили {string} {int}.",
            NoMoreItemsToProcess = "У вас больше нет предметов для обработки.",
            MachineInUse = "Эта машина в настоящее время используется другим игроком.",
            AlreadyProcessing = "You are already using another machine.",
            NotInProcess = "You are not currently in this process.",
            AreaAlreadySearched = "Кажется, кто-то уже искал здесь.",
            NotNearWater = "Вам нужно быть рядом с морем, чтобы использовать удочку.",
            SomethingBitten = "Что-то клюнуло!",
            NoCatch = "О нет, вы ничего не поймали.",
            Caught = "Отлично! Вы поймали: [{string}]",
            CannotInteract = "Вы не можете взаимодействовать с этим прямо сейчас.",
            NotEnoughMoney = "У вас недостаточно денег для этого.",
            PressToStop = "Нажмите любую клавишу движения, чтобы остановиться.",
            CantFarmMultiple = "Вы не можете фармить больше одного за раз.",
            SellLimitReached = "Вы достигли лимита продаж на сегодня.",
            CantSellMoreItems = "Вы не можете продать больше вещей сегодня.",
            GoToWater = "Вы можете ловить рыбу в любом водоеме. Направляйтесь к ближайшему!",
            JobRestricted = "У вас нет необходимой работы для этой деятельности.",
            KnifeRequired = "Вам нужен {string}, чтобы освежевать животное."
        },
        target = {
            Talk = "Поговорить с {string}",
            Farm = "Взаимодействовать с",
            Process1 = "Обработать [{string}]",
            Process2 = "Завершить [{string}]",
            SkinAnimal = "Освежевать животное",
            PickupItem = "Поднять",
            PickupFish = "Поднять рыбу",
            DiscardFish = "Выбросить рыбу",
            SearchTrash = "Обыскать мусор",
            Fish = "Нажмите [E], чтобы поднять\nНажмите [G], чтобы выбросить"
        },
        minigames = {
            SkillCheckTitle = "Проверка Навыка",
            FishCatchingTitle = "Ловля рыбы!"
        }
    }
}