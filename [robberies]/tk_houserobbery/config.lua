Config = {} -- You can place webhook link for logs in server/main_editable.lua

Config.Framework = 'qb' -- 'esx' | 'qb'
Config.NotificationType = 'qb' -- 'esx' | 'qb' | 'ox' | 'mythic'
Config.Locale = 'en' -- 'en' | 'fi'
Config.ImagePath = 'nui://qs-inventory/html/images' -- path for images used in UI (for QB: nui://qb-inventory/html/images) (for ox_inventory: nui://ox_inventory/web/images)
Config.DebugMode = false -- false | true

Config.Inventory = 'qs' -- 'default' | 'ox' | 'qs'
Config.Target = 'qb' -- 'none' | 'ox' | 'qb'
Config.Dispatch = 'default' -- 'default' | 'tk' | 'cd'
Config.UseOxLib = false -- false | true, remember to add " shared_script '@ox_lib/init.lua' " to fxmanifest.lua if set to true

Config.Controls = {
    interact = 38, -- E
}

Config.Anims = {
    search = {
        dict = 'missexile3',
        name = 'ex03_dingy_search_case_base_michael',
        duration = 5000,
        flag = 1,
    },
    hack = {
        scenario = 'PROP_HUMAN_ATM',
        duration = 5000,
    },
}

Config.UsePhoneBooths = true
Config.PhoneBoothModels = {`prop_phonebox_04`, `prop_phonebox_01b`, `prop_phonebox_01a`, `p_phonebox_01b_s`, `prop_phonebox_01c`, `p_phonebox_02_s`, `sf_prop_sf_phonebox_01b_s`}

Config.RobAtNightOnly = true
Config.ShowLockpickInstructions = true

Config.Items = { -- required items for different actions
    door = 'lockpick',
    safe = 'lockpick',
    diamond = 'cutter',
    painting = 'WEAPON_SWITCHBLADE',
}

Config.Blip = { -- Settings for house robbery police blip, only used if Config.Dispatch is set to 'default'
    color = 1, -- https://docs.fivem.net/docs/game-references/blips/ (Scroll to the bottom)
    scale = 1.0, -- This needs to be a float (eg. 1.0, 1.2, 2.0)
    sprite = 40, -- https://docs.fivem.net/docs/game-references/blips/
    time = 60, -- How long the blip will stay in map (in seconds)
    playSound = true -- Should there be a sound for the police when the blip shows up (true / false)
}

Config.Cooldown = {
    user = 1000 * 60 * 0, -- cooldown for single player for robbing houses (in minutes), 0 = no cooldown, if using phone booths then this is the cooldown for taking a job
    house = 1000 * 60 * 5, -- time for a house to be robbable again (in minutes)
}

Config.NPC = {
    spawnChance = 100, -- Chance for an NPC to spawn inside the house (in percentages00)
    alertChance = 50, -- Chance for NPC to alert the police when waking up
    models = { -- Model for the NPC that spawns inside the house
        `a_m_m_beach_02`,
        `a_m_m_bevhills_01`,
        `a_m_m_bevhills_02`,
        `a_m_m_business_01`,
    },
    weapons = { -- Weapon that the NPC should get when spawned (leave empty if you don't want a weapon) 
        `WEAPON_KNIFE`,
        `WEAPON_BAT`,
    }
}
Config.DogSpawnChance = 50 -- Chance for dog to spawn outside the house when player leaves the house (0-1, 0 = never, 100 = always00)

Config.LockpickAlertChance = {
    start = 10, -- Chance for police to get alert when you start lockpicking
    fail = 100, -- Chance for police to get alert when you fail lockpicking
    success = 10, -- Chance for police to get alert when you successfully lockpick the door
}
Config.LockpickLoseChance = {
    fail = 100, -- Chance to lose lockpick on failed attempt
    success = 20, -- Chance to lose lockpick on successful attempt
}

Config.ValuableItemLoseChance = {
    painting = 50,
    diamond = 10,
    safe = 20,
}

Config.PoliceRequired = 1 -- Police required to rob houses
Config.PoliceJobs = {
    police = 0, -- job name, minimum grade
}

Config.CarryItems = {
    television = {
        anim = {
            dict = 'anim@heists@box_carry@',
            name = 'idle',
            flag = 51
        },
        prop = {
            bone = 60309,
            model = `prop_tv_flat_03`,
            position = vector3(0.025, 0.080, 0.255),
            rotation = vector3(-120.0, 100.0, 10.0),
        },
        reward = 'television', -- Item to give when stored in vehicle
    },
    music_player = {
        anim = {
            dict = 'anim@heists@box_carry@',
            name = 'idle',
            flag = 51
        },
        prop = {
            bone = 60309,
            model = `v_res_j_radio`,
            position = vector3(0.125, -0.10, 0.255),
            rotation = vector3(-120.0, 100.0, 10.0),
        },
        reward = 'music_player',
    },
    microwave = {
        anim = {
            dict = 'anim@heists@box_carry@',
            name = 'idle',
            flag = 51
        },
        prop = {
            bone = 60309,
            model = `prop_microwave_1`,
            position = vector3(0.085, -0.080, 0.255),
            rotation = vector3(-120.0, 100.0, 10.0),
        },
        reward = 'microwave',
    },
    computer = {
        anim = {
            dict = 'anim@heists@box_carry@',
            name = 'idle',
            flag = 51
        },
        prop = {
            bone = 60309,
            model = `xm_prop_x17_res_pctower`,
            position = vector3(0.125, -0.130, 0.255),
            rotation = vector3(-120.0, 100.0, 10.0),
        },
        reward = 'computer',
    },
    coffee_machine = {
        anim = {
            dict = 'anim@heists@box_carry@',
            name = 'idle',
            flag = 51
        },
        prop = {
            bone = 60309,
            model = `apa_mp_h_acc_coffeemachine_01`,
            position = vector3(0.125, -0.180, 0.255),
            rotation = vector3(-120.0, 100.0, 10.0),
        },
        reward = 'coffee_machine',
    },
}

Config.SearchTime = 5000 -- Time to search one place
Config.FindItemChance = 100 -- Overall chance to find item when searching (percentage)
Config.LootItems = { -- Items that you can find inside
    { name = 'silver_coin', chance = 50, min = 1, max = 10 },
    { name = 'gold_coin', chance = 50, min = 1, max = 5 },
    { name = 'charlotte_ring', chance = 50, min = 1, max = 3 },
    { name = 'simbolos_chain', chance = 50, min = 1, max = 7 },
    { name = 'action_figure', chance = 10, min = 1, max = 5 },
    { name = 'nominos_ring', chance = 50, min = 1, max = 4 },
    { name = 'boss_chain', chance = 40, min = 1, max = 8 },
    { name = 'branded_cigarette', chance = 30, min = 1, max = 10 },
    { name = 'branded_cigarette_box', chance = 20, min = 1, max = 5 },
    { name = 'ninja_figure', chance = 50, min = 1, max = 3 },
    { name = 'trading_painting', chance = 50, min = 1, max = 5 },
    { name = 'trading_statue', chance = 50, min = 1, max = 6 },
    { name = 'ancient_egypt_artifact', chance = 20, min = 1, max = 8 },
    { name = 'danburite', chance = 70, min = 1, max = 1 },
    { name = 'money', chance = 60, min = 1000, max = 15000 },
    { name = 'pistol_ammo', chance = 50, min = 2, max = 3 },

}

Config.Shops = {
    {
        name = 'Equipment',
        coords = vec4(-43.80, -1231.39, 29.34, 276.85),
        ped = 's_m_y_robber_01',
        moneyType = 'money',
        items = {
            --[[ {
                name = 'lockpick',
                price = 10,
                amount = 1,
            }, ]]
            {
                name = 'cutter',
                price = 20000,
                amount = 1,
            },
             {
                name = 'WEAPON_SWITCHBLADE',
                price = 5000,
                amount = 1,
            }, 
        }
    },
}

Config.SellShops = {
    {
        name = 'Dealer',
        coords = vec4(-354.28, 4825.27, 144.30, 145.63),
        ped = 's_m_y_dealer_01',
        moneyType = 'money',
        items = {
            {name = 'diamond', price = 100000},
            {name = 'ruby', price = 100000},
            {name = 'danburite', price = 300},
            {name = 'painting', price = 250},
            {name = 'silver_coin', price = 750},
            {name = 'gold_coin', price = 100},
            {name = 'charlotte_ring', price = 120},
            {name = 'simbolos_chain', price = 110},
            {name = 'action_figure', price = 900},
            {name = 'nominos_ring', price = 120},
            {name = 'boss_chain', price = 130},
            {name = 'branded_cigarette', price = 150},
            {name = 'branded_cigarette_box', price = 350},
            {name = 'ninja_figure', price = 900},
            {name = 'trading_painting', price = 150},
            {name = 'trading_statue', price = 140},
            {name = 'ancient_egypt_artifact', price = 200},
            {name = 'television', price = 180},
            {name = 'music_player', price = 100},
            {name = 'microwave', price = 800},
            {name = 'computer', price = 220},
            {name = 'coffee_machine', price = 600},
        }
    },
}

Config.Conversations = {
    {
      "Hey, I might have something for you. Interested?",
      "Yeah, I need cash. What's the job?",
      "Got a nice house in the suburbs. Owner's away for the weekend.",
      "Send me the location. I'll check it out."
    },
    {
      "Got a tip about an empty place with some valuables.",
      "Sounds good. Any details?",
      "Rich neighborhood, minimal security. Should be easy in and out.",
      "Perfect. Share the coordinates."
    },
    {
      "Need someone for a quick job tonight. You available?",
      "Always available for the right price.",
      "There's this place with a nice collection of antiques. Owner's out of town.",
      "I'm in. Just tell me where."
    },
    {
      "Got a lucrative opportunity if you're looking for work.",
      "You know I am. What's the score?",
      "Fancy house on the hill, should be empty for the next few hours.",
      "Sounds promising. Text me the address."
    }
}

Config.Houses = {
    {
        doorCoords = vector4(151.43, -1007.66, -99.0, 0.0),
        loot = {
            {coords = vector3(155.37, -1005.8, -99.35)},
            {coords = vector3(150.95, -1002.97, -99.07)},
            {coords = vector3(151.1, -1000.64, -99.18)},
            {coords = vector3(154.06, -1000.09, -99.03)},
            {coords = vector3(155.18, -1003.33, -99.37)},
            {coords = vector3(150.84, -1004.61, -97.99), item = 'television'}, -- item: 'television' | 'music_player' | 'microwave' | 'computer' | 'coffee_machine'
        },
        NPC = vector4(154.19, -1004.59, -98.42, 180.0),
        valuables = {
            {
                spawnChance = 50,
                coords = vector3(150.395, -1006.49, -99.0),
                rotation = vector3(0.0, 0.0, 90.0),
                type = 'painting',
                objects = {
                    {model = `ch_prop_vault_painting_01f`, offset = vector3(0.0, 0.0, 0.0)},
                },
                totalItems = 1,
                items = {
                    {name = 'painting', min = 1, max = 1, chance = 100},
                },
            },
        },
    },
    {
        doorCoords = vector4(266.18, -1007.23, -101.01, 0.0),
        loot = {
            {coords = vector3(266.31, -999.43, -98.94)},
            {coords = vector3(266.14, -996.73, -98.98)},
            {coords = vector3(263.68, -994.67, -99.02)},
            {coords = vector3(262.64, -1000.56, -99.23)},
            {coords = vector3(262.44, -995.37, -99.15)},
            {coords = vector3(266.2, -994.96, -98.98), item = 'microwave'},
            {coords = vector3(261.3, -1004.64, -99.52)},
            {coords = vector3(263.15, -1001.83, -99.39)},
        },
        NPC = vector4(262.56, -1004.17, -98.26, 180.0),
        lasers = {
            {startPos = vector3(264.31, -1001.62, -98.26), endPos = vector3(265.81, -1001.62, -98.26), flashInterval = 1500},
            {startPos = vector3(264.31, -1001.62, -99.26), endPos = vector3(265.81, -1001.62, -99.26), flashInterval = 1500},
        },
        securityPanel = {
            coords = vector3(264.16, -1003.13, -98.5),
            rotation = vector3(0.0, 0.0, 90.0),
            model = `prop_ld_keypad_01`
        },
        valuables = {
            {
                spawnChance = 15,
                coords = vector3(258.4, -1001.48, -98.6),
                rotation = vector3(0.0, 0.0, 180.0),
                type = 'painting',
                objects = {
                    {model = `ch_prop_vault_painting_01f`, offset = vector3(0.0, 0.0, 0.0)},
                },
                totalItems = 1,
                items = {
                    {name = 'painting', min = 1, max = 1, chance = 100},
                },
            },
            {
                spawnChance = 5,
                coords = vector3(259.9, -1003.81, -99.01),
                rotation = vector3(0.0, 0.0, 180.0),
                type = 'diamond',
                objects = {
                    {model = `h4_prop_h4_diamond_01a`, offset = vector3(0.0, 0.0, 0.0)},
                    {model = `h4_prop_h4_diamond_disp_01a`, offset = vector3(0.0, 0.0, 0.0)},
                    {model = `h4_prop_h4_glass_disp_01a`, offset = vector3(0.0, 0.0, -1.0)},
                },
                totalItems = 1,
                items = {
                    {name = 'ruby', min = 1, max = 1, chance = 25},
                    { name = 'weapon_combatpistol', min = 1, max = 1, chance = 25},
                },
            },
            {
                spawnChance = 10,
                coords = vector3(256.9, -997.93, -99.35),
                rotation = vector3(0.0, 0.0, 90.0),
                type = 'safe',
                objects = {
                    {model = `p_v_43_safe_s`, offset = vector3(0.0, 0.0, 0.0)},
                },
                totalItems = 1,
                items = {
                    {name = 'money', min = 5, max = 25, chance = 100},
                },
            },
        },
    },
    {
        doorCoords = vector4(1173.59, -3196.5, -39.01, 90.0),
        loot = {
            {coords = vector3(1172.9, -3193.9, -39.06)},
            {coords = vector3(1172.83, -3199.46, -39.3)},
            {coords = vector3(1169.74, -3199.01, -39.31)},
            {coords = vector3(1166.32, -3199.45, -39.26)},
            {coords = vector3(1160.42, -3197.05, -39.1)},
            {coords = vector3(1161.87, -3193.03, -39.33)},
            {coords = vector3(1157.22, -3192.92, -39.07)},
            {coords = vector3(1156.79, -3199.4, -39.58)},
            {coords = vector3(1169.72, -3199.61, -38.95), item = 'computer'},
        },
        NPC = vector4(1166.27, -3196.29, -39.01, 15.0),
        lasers = {
            {startPos = vector3(1156.78, -3193.29, -39.14), endPos = vector3(1166.41, -3193.29, -39.14)},
            {startPos = vector3(1156.78, -3193.29, -38.54), endPos = vector3(1166.41, -3193.29, -38.54)},
            {startPos = vector3(1156.78, -3193.29, -37.94), endPos = vector3(1166.41, -3193.29, -37.94)},
            {startPos = vector3(1156.78, -3193.29, -37.34), endPos = vector3(1166.41, -3193.29, -37.34)},
            {startPos = vector3(1156.78, -3193.29, -36.74), endPos = vector3(1166.41, -3193.29, -36.74)},
        },
        securityPanel = {
            coords = vector3(1172.18, -3193.47, -38.5),
            rotation = vector3(0.0, 0.0, 0.0),
            model = 'prop_ld_keypad_01b'
        },
        valuables = {
            {
                spawnChance = 15,
                coords = vector3(1158.49, -3191.67, -39.01),
                rotation = vector3(0.0, 0.0, 90.0),
                type = 'diamond',
                objects = {
                    {model = `h4_prop_h4_diamond_01a`, offset = vector3(0.0, 0.0, 0.2)},
                    {model = `h4_prop_h4_diamond_disp_01a`, offset = vector3(0.0, 0.0, 0.0)},
                    {model = `h4_prop_h4_glass_disp_01a`, offset = vector3(0.0, 0.0, -1.0)},
                },
                totalItems = 1,
                items = {
                    {name = 'ruby', min = 1, max = 1, chance = 25},
                    { name = 'weapon_combatpistol', min = 1, max = 1, chance = 25},
                },
            },
            {
                spawnChance = 10,
                coords = vector3(1164.92, -3191.65, -39.01),
                rotation = vector3(0.0, 0.0, 270.0),
                type = 'safe',
                objects = {
                    {model = `p_v_43_safe_s`, offset = vector3(0.0, 0.0, 0.0)},
                },
                totalItems = 1,
                items = {
                    {name = 'money', min = 5, max = 25, chance = 100},
                },
            },
        },
    },
    --[[ {
        doorCoords = vector4(346.51, -1012.69, -99.2, 0.0),
        loot = {
            {coords = vector3(345.74, -993.33, -99.3)},
            {coords = vector3(345.8, -995.75, -99.66)},
            {coords = vector3(341.8, -996.57, -99.98)},
            {coords = vector3(337.68, -997.75, -99.49)},
            {coords = vector3(337.64, -995.0, -99.02)},
            {coords = vector3(343.83, -1003.71, -99.61)},
            {coords = vector3(340.65, -1003.96, -99.85)},
            {coords = vector3(351.55, -999.95, -99.14)},
            {coords = vector3(348.65, -994.87, -99.37)},
            {coords = vector3(346.8, -994.24, -99.42)},
            {coords = vector3(342.77, -1003.74, -99.14), item = 'coffee_machine'},
        },
        NPC = vector4(349.78, -996.3, -98.54, 360.0),
        lasers = {
            {startPos = vector3(351.26, -1008.68, -98.08), endPos = vector3(345.26, -1004.8, -99.33), flashInterval = 1200},
            {startPos = vector3(345.3, -1001.49, -97.97), endPos = vector3(348.88, -997.74, -99.5), flashInterval = 1000},
            {startPos = vector3(349.23, -1000.42, -98.52), endPos = vector3(353.13, -993.71, -98.49), flashInterval = 900},
            {startPos = vector3(353.05, -998.47, -99.51), endPos = vector3(348.36, -995.36, -98.56), flashInterval = 800},
        },
        securityPanel = {
            coords = vector3(351.05, -1007.59, -98.6),
            rotation = vector3(0.0, 0.0, 270.0),
            model = 'prop_ld_keypad_01b'
        },
        valuables = {
            {
                spawnChance = 40,
                coords = vector3(345.35, -1004.59, -99.2),
                rotation = vector3(0.0, 0.0, 90.0),
                type = 'painting',
                objects = {
                    {model = `ch_prop_vault_painting_01f`, offset = vector3(0.0, 0.0, 0.0)},
                },
                totalItems = 1,
                items = {
                    {name = 'painting', min = 1, max = 1, chance = 100},
                },
            },
            {
                spawnChance = 10,
                coords = vector3(351.95, -994.59, -99.6),
                rotation = vector3(0.0, 0.0, 0.0),
                type = 'safe',
                objects = {
                    {model = `p_v_43_safe_s`, offset = vector3(0.0, 0.0, 0.0)},
                },
                totalItems = 1,
                items = {
                    {name = 'money', min = 5, max = 25, chance = 100},
                },
            },
        },
    } ]]
}

Config.Entrances = { -- All robbable house entrances
    -- {coords = vector3(1060.49, -378.22, 68.23), interior = 2}, -- "interior" allows you to specify the interior that will be used for this entrance
    {coords = vector3(1090.43, -484.34, 65.66), interior = 1},
     {coords = vector3(1046.25, -498.14, 64.28), interior = 2},
    {coords = vector3(1009.57, -572.53, 60.59), interior = 3},
    {coords = vector3(919.71, -569.63, 58.37), interior = 1},
    {coords = vector3(279.61, -1993.90, 20.80), interior = 2},
    {coords = vector3(325.29, -1989.71, 24.17), interior = 3},
    {coords = vector3(324.44, -1937.35, 25.02), interior = 1},
    {coords = vector3(368.66, -1895.63, 25.18), interior = 2},
    {coords = vector3(424.42, -1890.35, 26.36), interior = 3},
    {coords = vector3(427.11, -1842.05, 28.46), interior = 1},
    {coords = vector3(495.22, -1823.31, 28.87), interior = 2},
    {coords = vector3(512.53, -1790.59, 28.92), interior = 3},
    {coords = vector3(474.46, -1757.66, 29.09), interior = 1},
    {coords = vector3(-842.69, 466.84, 87.60), interior = 2},
    {coords = vector3(-884.50, 517.78, 92.44), interior = 3},
    {coords = vector3(-904.38, 588.00, 101.19), interior = 1},
    {coords = vector3(-947.91, 567.80, 101.51), interior =2},
    {coords = vector3(-1883.31, -578.97, 11.82), interior = 3},
    {coords = vector3(-1918.71, -542.57, 11.83), interior = 1},
    {coords = vector3(-1034.70, -1147.19, 2.16), interior = 2},
    {coords = vector3(-991.78, -1103.47, 2.15), interior = 3},
    {coords = vector3(-978.03, -1108.20, 2.15), interior = 1},
    {coords = vector3(-948.38, -1107.70, 2.17), interior = 2},
    {coords = vector3(-952.47, -1077.57, 2.67), interior = 3}, 
    
}