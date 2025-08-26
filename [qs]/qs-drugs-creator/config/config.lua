Config = Config or {}
Locales = Locales or {}

--[[
    Choose your preferred language!

    In this section, you can select the main language for your asset. We have a wide
    selection of default languages available, located in the locales/* folder.

    If your language is not listed, don't worry! You can easily create a new one
    by adding a new file in the locales folder and customizing it to your needs.

    Default languages available:
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

--[[
    The current system will detect if you use qb-core or es_extended,
    but if you rename it, you can remove the value from Config.Framework
    and add it yourself after you have modified the framework files inside
    this script.

    Please keep in mind that this code is automatic, do not edit if
    you do not know how to do it.
]]

local frameworks = {
    ['es_extended'] = 'esx',
    ['qb-core'] = 'qb',
}

Config.Framework = DependencyCheck(frameworks) or 'none'

--[[
    Visual configuration of the drugs, you can eliminate
    the blips if you want the points to be hidden.

    Here you will find the visual of markers and blips!

    Please read each setting before
    edit it this way to avoid general errors.
]]

-- This money type will be used for when buying decoration object and buying a lab
---@type MoneyType
Config.MoneyType = 'money'          -- money, bank, black_money (black_money means markedbills for qb)

Config.LabMenu = 'labMenu'         -- Open lab complete menu.
Config.LabDecoration = 'labDeco'   -- Command or configuration for customizing the van's appearance or decorations.
Config.DecorationMappingKey = 'F9' -- The keybind used to open the decoration mapping interface.
Config.TimeInterior = 23           -- This is the time it will be when entering the shells (to avoid alternating shadows)
Config.TestRemTime = 1             -- Visiting time inside the house (1 = 1 minute)
Config.CreatorAlpha = 200          -- Ignore this if you don't want to edit the Alpha
Config.MinZOffset = 30             -- Minimum shell spawn offset

-- Decorate
Config.SpawnDistance = 100.0      -- Distance in meters for spawning related objects/entities
Config.DynamicDoors = true        -- Enable dynamic doors? Requires `setr game_enableDynamicDoorCreation "true"` in your server configuration.
Config.HideRadarInDecorate = true -- Hides the radar when in decoration mode.
Config.ModernDecorateMode = true  -- Enables modern decoration mode with an updated interface.

Config.HouseObjects = {
    [1] = { -- House 1
        model = 'shell_coke1',
    },
    [2] = { -- House 1
        model = 'shell_weed',
    }
}

-- Your currency symbol (https://www.telerik.com/blogs/javascript-intl-object)
Config.Intl = {
    locales = 'en-US',            -- 'en-US', 'pt-BR', 'es-ES', 'fr-FR', 'de-DE', 'ru-RU', 'zh-CN'
    options = {
        style = 'currency',       -- 'decimal', 'currency', 'percent', 'unit'
        currency = 'USD',         -- 'USD', 'EUR', 'BRL', 'RUB', 'CNY'
        minimumFractionDigits = 0 -- 0, 1, 2, 3, 4, 5
    }
}

-- Taxes configuration
Config.BankFee = function(price) return price / 100 * 0 end
Config.BrokerFee = function(price) return price / 100 * 5 end
Config.Taxes = function(price) return price / 100 * 5 end

Config.Shells = {
    [1] = {
        model = 'shell_coke1',
        limits = {
            weed = 10,
            meth = 10,
            cocaine = 10,
            money = 10
        },
        stash = {
            maxweight = 1000000,
            slots = 5,
        }

    },
    [2] = {
        model = 'shell_weed',
        limits = {
            weed = 10,
            meth = 10,
            cocaine = 10,
            money = 10
        },
        stash = {
            maxweight = 1000000,
            slots = 5,
        }
    }
}

Config.PoliceBlip = { -- Modify the Blip as you like
    sprite = 403,
    color = 1,
    scale = 1.2,
    alpha = 250,
    name = '[Drugs] Drug sales',
}

--[[
    Ignore this, as it is a debug to display everything inside the script.
]]

Config.Debug = false

Config.FreeModeKeys = {
    ChangeKey = Keys['LEFTCTRL'],       -- Key to toggle free mode controls.

    MoreSpeed = Keys['.'],              -- Increase movement speed.
    LessSpeed = Keys[','],              -- Decrease movement speed.

    MoveToTop = Keys['TOP'],            -- Move the object upward.
    MoveToDown = Keys['DOWN'],          -- Move the object downward.

    MoveToForward = Keys['TOP'],        -- Move the object forward.
    MoveToBack = Keys['DOWN'],          -- Move the object backward.
    MoveToRight = Keys['RIGHT'],        -- Move the object to the right.
    MoveToLeft = Keys['LEFT'],          -- Move the object to the left.

    RotateToTop = Keys['6'],            -- Rotate the object upward.
    RotateToDown = Keys['7'],           -- Rotate the object downward.
    RotateToLeft = Keys['8'],           -- Rotate the object to the left.
    RotateToRight = Keys['9'],          -- Rotate the object to the right.

    TiltToTop = Keys['Z'],              -- Tilt the object upward.
    TiltToDown = Keys['X'],             -- Tilt the object downward.
    TiltToLeft = Keys['C'],             -- Tilt the object to the left.
    TiltToRight = Keys['V'],            -- Tilt the object to the right.

    StickToTheGround = Keys['LEFTALT'], -- Snap the object to the ground.
}

ActionControls = {
    forward = { label = 'Forward +/-', codes = { 33, 32 } },             -- Moves the object forward or backward.
    right = { label = 'Right +/-', codes = { 35, 34 } },                 -- Moves the object left or right.
    up = { label = 'Up +/-', codes = { 52, 51 } },                       -- Adjusts vertical positioning.
    add_point = { label = 'Add Point', codes = { 24 } },                 -- Adds a new point in the editor.
    set_any = { label = 'Set', codes = { 24 } },                         -- Sets a generic property.
    undo_point = { label = 'Undo Last', codes = { 25 } },                -- Reverts the last added point.
    set_position = { label = 'Set Position', codes = { 24 } },           -- Sets the position of an object.
    add_garage = { label = 'Add Garage', codes = { 24 } },               -- Adds a garage to the map.
    rotate_z = { label = 'RotateZ +/-', codes = { 20, 73 } },            -- Rotates the object around the Z-axis.
    rotate_z_scroll = { label = 'RotateZ +/-', codes = { 17, 16 } },     -- Rotates Z-axis using scroll.
    increase_z = { label = 'Z Boundary +/-', codes = { 180, 181 } },     -- Increases the Z-axis boundary.
    decrease_z = { label = 'Z Boundary +/-', codes = { 21, 180, 181 } }, -- Decreases the Z-axis boundary.
    done = { label = 'Done', codes = { 191 } },                          -- Confirms actions and exits the editor.
    change_player = { label = 'Player +/-', codes = { 82, 81 } },        -- Cycles through available players.
    change_shell = { label = 'Change Shell +/-', codes = { 189, 190 } }, -- Switches between shell models.
    select_player = { label = 'Select Player', codes = { 191 } },        -- Selects a specific player.
    cancel = { label = 'Cancel', codes = { 194 } },                      -- Cancels the current action.
    change_outfit = { label = 'Outfit +/-', codes = { 82, 81 } },        -- Changes between outfits.
    delete_outfit = { label = 'Delete Outfit', codes = { 178 } },        -- Deletes the selected outfit.
    select_vehicle = { label = 'Vehicle +/-', codes = { 82, 81 } },      -- Cycles through vehicles.
    spawn_vehicle = { label = 'Spawn Vehicle', codes = { 191 } },        -- Spawns the selected vehicle.
    leftApt = { label = 'Previous Apartment', codes = { 174 } },         -- Navigates to the previous apartment.
    rightApt = { label = 'Next Apartment', codes = { 175 } },            -- Navigates to the next apartment.
    testPos = { label = 'Test Pos', codes = { 47 } },                    -- Tests the position of an object or point.
}

Config.HandleHud = {
    enable = function()
        Debug('Enable hud triggered')
        -- Place your code here to enable the HUD when needed.
    end,
    disable = function()
        Debug('Disable hud triggered')
        -- Place your code here to disable the HUD when needed.
    end
}

CameraOptions = {
    lookSpeedX = 500.0, -- Horizontal camera movement speed.
    lookSpeedY = 500.0, -- Vertical camera movement speed.
    moveSpeed = 10.0,   -- Speed at which the camera moves in free mode.
    climbSpeed = 10.0,  -- Speed for vertical camera movement (up/down).
    rotateSpeed = 50.0, -- Rotation speed of the camera in free mode.
}

Config.CollectItems = {           -- Modify the collectibles
    ['weed'] = {
        prop = 'prop_weed_01',    -- Prop
        name = 'Weed',            -- Visual name
        item = 'weed',            -- Item Name
        time = 4000,              -- Progressbar timer
        quantityMin = 1,          -- Minium Amount you will get when collecting
        quantityMax = 2,          -- Max Amount you will get when collecting
        requiredCops = true,      -- Require police online?
        requiredCopsQuantity = 0, -- Minimum of police on duty to collect drugs
        collect_label = 'Collecting marijuana...'
    },

    ['meth'] = {
        prop = 'prop_barrel_exp_01a', -- Prop
        name = 'Chemicals',           -- Visual name
        item = 'chemicals',           -- Item Name
        time = 4000,                  -- Progressbar timer
        quantityMin = 1,              -- Minium Amount you will get when collecting
        quantityMax = 5,              -- Max Amount you will get when collecting
        requiredCops = false,         -- Require police online?
        requiredCopsQuantity = 0,     -- Minimum of police on duty to collect drugs
        collect_label = 'Collecting chamicals...'
    },

    ['cocaine'] = {
        prop = 'prop_plant_cane_02b', -- Prop
        name = 'Cocaine',             -- Visual name
        item = 'cocaine',             -- Item Name
        time = 4000,                  -- Progressbar timer
        quantityMin = 1,              -- Minium Amount you will get when collecting
        quantityMax = 5,              -- Max Amount you will get when collecting
        requiredCops = false,         -- Require police online?
        requiredCopsQuantity = 0,     -- Minimum of police on duty to collect drugs
        collect_label = 'Collecting cocaine...'
    },

    -- This is an example custom drug. Please search for "heroine" by opening the entire file
    -- in your vscode and you will see where else to add it since we left these commented out as an example.
    --
    ['heroine'] = {
        prop = 'prop_barrel_exp_01a',
        name = 'Heroine',         -- Visual name
        item = 'sandwich',        -- Item Name
        time = 4000,              -- Progressbar timer
        quantityMin = 1,          -- Minium Amount you will get when collecting
        quantityMax = 5,          -- Max Amount you will get when collecting
        requiredCops = false,     -- Require police online?
        requiredCopsQuantity = 0, -- Minimum of police on duty to collect drugs
        collect_label = 'Collecting Heroine...'
    }
}

Config.FiveGuard = false -- Your fiveguard script name if exists, if not false.

-- Your custom drug animations
Config.DrugAnimations = {
    -- This is an example custom drug. Please search for "heroine" by opening the entire file
    -- in your vscode and you will see where else to add it since we left these commented out as an example.
    --
    ['heroine'] = {
        process = {
            dict = 'mp_player_intdrink',
            anim = 'loop_bottle',
            progressBarLabel = 'Processing Heroine...',
            notifyname = 'cocaine_cut',
            progressBarTime = 5000,
            requireRate = 1,
            requireItem = 'cocaine_cut',
            rewardItem = 'crack',
            rewardRate = 1,
            level = 1,
            prop = { -- optional
                model = `prop_ld_flow_bottle`,
                pos = vec3(0.03, 0.03, 0.02),
                rot = vec3(0.0, 0.0, -1.5)
            }
        }

    }
}

Config.LockpickingItem = 'lockpick'
Config.StormArmItem = 'police_stormram'
Config.EnableRaid = true

Config.SellObjectCommision = 0.3 -- Commission that will be charged when selling a piece of furniture

Config.PoliceJobs = {            -- Jobs that will be considered police
    'realestate',
    'police',
    'realestatejob'
}

Config.ExpMin = 1
Config.ExpMax = 3

---@type table<string, table<string, Process>>
Config.Process = { --Read slowly if you want to modify the processes, it is a somewhat tedious job
    meth = {
        process = {
            progText = 'Processing methamphetamine...',
            level = 5,
            requireRate = 5,
            requireItem = 'chemicals',
            notifyname = 'Chemicals',
            rewardItem = 'meth',
            rewardRate = 30,
            time = 50000,
            act = 'Meth',
            process = 'process',
            headingOffset = -180,
            coordsOffset = vector3(-1.0, -0.1, 1.0)
        },
        package = {
            progText = 'Packing methamphetamine...',
            level = 5,
            requireRate = 10,
            requireItem = 'meth',
            notifyname = 'Methanpheetamine',
            rewardItem = 'meth_packaged',
            rewardRate = 10,
            time = 38000,
            act = 'Meth',
            process = 'package',
            headingOffset = 0,
            coordsOffset = vector3(-1.2, 0.5, 1.05)
        }
    },

    cocaine = {
        process = {
            progText = 'Processing cocaine...',
            level = 5,
            requireRate = 1,
            requireItem = 'cocaine',
            notifyname = 'Cocaine',
            rewardItem = 'cocaine_cut',
            rewardRate = 1,
            time = 19000,
            act = 'Cocaine',
            process = 'process',
            headingOffset = -180,
            coordsOffset = vector3(-0.9, 0.0, 1.0),

        },
        package = {
            progText = 'Packing cocaine...',
            level = 5,
            requireRate = 1,
            requireItem = 'cocaine_cut',
            notifyname = 'Cocaine Cut',
            rewardItem = 'cocaine_packaged',
            rewardRate = 1,
            time = 42000,
            act = 'Cocaine',
            process = 'package',
            headingOffset = -180,
            coordsOffset = vector3(-0.8, 0.7, 1.0)
        }
    },

    weed = {
        process = {
            progText = 'Processing weed...',
            level = 5,
            requireRate = 5,
            requireItem = 'weed',
            notifyname = 'Weed',
            rewardItem = 'weed_packaged',
            rewardRate = 5,
            time = 30000,
            act = 'Weed',
            process = 'process',
            headingOffset = 0,
            coordsOffset = vector3(-0.9, 0.0, 0.95),
            extraProps = {
                {
                    model = 'bkr_Prop_weed_chair_01a',
                    pos = vec3(-0.7, 0.1, 0.0),
                    headingOffset = -180.0,
                }
            }
        },
    },

    money = {
        process = {
            progText = 'Cutting stolen money...',
            level = 5,
            requireRate = 100,
            requireMoney = true,
            notifyname = 'Black Money',
            rewardItem = 'sorted_money',
            rewardRate = 100,
            time = 32000,
            act = 'Money',
            process = 'process',
            headingOffset = 0,
            coordsOffset = vector3(-0.74, 0.32, 1.015)
        },
        package = {
            progText = 'Packaging stolen money...',
            level = 5,
            requireRate = 100,
            requireItem = 'sorted_money',
            notifyname = 'Sorted Money',
            rewardItem = 'package_money',
            rewardRate = 100,
            time = 18000,
            act = 'Money',
            process = 'package',
            headingOffset = 0,
            coordsOffset = vector3(-0.8, 0.3, 1.1),
            extraProps = {
                {
                    model = 'bkr_prop_money_counter',
                    pos = vec3(-0.25, -0.3, 0.45),
                    headingOffset = 0.0,
                },
            }
        },
        wash = {
            progText = 'Washing stolen money...',
            level = 5,
            requireRate = 100,
            requireItem = 'package_money',
            notifyname = 'Package Money',
            rewardMoney = true,
            rewardItem = 'money',
            rewardRate = 100,
            time = 20000,
            act = 'Money',
            process = 'wash',
            headingOffset = 60,
            coordsOffset = vector3(-1.0, 0.2, 1.0)
        }
    }
}

Config.Dispatch = 'default' -- client // represent a server side or client side execute!

-- Money types: black_money, money, bank. (if you are using qb black_money means markedbills for you. So if you want to use markedbills set black_money)
Config.SellerItems = {
    {
        id = 'weeds', -- Do not change this. And if you create new one be sure this is unique.
        label = 'Weed Items',
        description = 'All of the Weed items',
        items = {
            {
                label = 'Weed',
                description = 'Weed is a drug that is made from the cannabis plant. It is a mixture of dried and shredded leaves, stems, seeds, and flowers of the cannabis plant.',
                item = 'weed_packaged',
                price = 1000,
                moneyType = 'black_money' -- black_money (means markerbills for qb), money, bank
            }
        },
    },
    {
        id = 'meths', -- Do not change this. And if you create new one be sure this is unique.
        label = 'Meth Items',
        description = 'All of the Meth items',
        items = {
            {
                label = 'Meth',
                description = 'Methamphetamine is a powerful, highly addictive stimulant that affects the central nervous system.',
                item = 'meth_packaged',
                price = 200,
                moneyType = 'black_money'
            }
        },

    },
    {
        id = 'cocaines', -- Do not change this. And if you create new one be sure this is unique.
        label = 'Cocaine Items',
        description = 'All of the Cocaine items',
        items = {
            {
                label = 'Cocaine',
                description = 'Cocaine is a powerfully addictive stimulant drug made from the leaves of the coca plant native to South America.',
                item = 'cocaine_packaged',
                price = 300,
                moneyType = 'black_money'
            }
        }
    },
    {
        id = 'all',
        label = 'All Items',
        description = 'All of the items',
        items = {
            {
                label = 'Weed',
                description = 'Weed is a drug that is made from the cannabis plant. It is a mixture of dried and shredded leaves, stems, seeds, and flowers of the cannabis plant.',
                item = 'weed_packaged',
                price = 100,
                moneyType = 'black_money'
            },
            {
                label = 'Meth',
                description = 'Methamphetamine is a powerful, highly addictive stimulant that affects the central nervous system.',
                item = 'meth_packaged',
                price = 200,
                moneyType = 'black_money'
            },
            {
                label = 'Cocaine',
                description = 'Cocaine is a powerfully addictive stimulant drug made from the leaves of the coca plant native to South America.',
                item = 'cocaine_packaged',
                price = 300,
                moneyType = 'black_money'
            }
        },
    }
}

-- Check types.lua for more information about the DrugEffectType and DrugEffect
---@type {name: string, effectType: DrugEffectType, effectDuration: number, effects: DrugEffect[]}[]
Config.UseableDrugItems = {
    {
        name = 'weed',
        effectType = 'smoke',
        effectDuration = 10000,
        effects = {
            'pink_visual'
        }
    },
    {
        name = 'meth',
        effectType = 'pill',
        effectDuration = 10000,
        effectName = {
            'visual_shaking'
        }
    }
}

Config.SellerNPC = {
    model = 'a_m_m_farmer_01', -- Default seller npc model
}

-- If objects are collected, new ones appear every 5 minutes.
Config.FarmSpawnTimer = 1000 * 60 * 2 -- 5 minutes

local wardrobes = {
    ['qs-appearance'] = 'qs-appearance',
    ['esx_skin'] = 'esx_skin',
    ['qb-clothing'] = 'qb-clothing',
	['codem-appearance'] = 'codem-appearance',
	['ak47_clothing'] = 'ak47_clothing',
	['fivem-appearance'] = 'fivem-appearance',
	['illenium-appearance'] = 'illenium-appearance',
	['raid_clothes'] = 'raid_clothes',
	['rcore_clothes'] = 'rcore_clothes',
	['rcore_clothing'] = 'rcore_clothing',
	['sleek-clothestore'] = 'sleek-clothestore',
	['tgiann-clothing'] = 'tgiann-clothing',
    ['p_appearance'] = 'p_appearance'
}

Config.Wardrobe = DependencyCheck(wardrobes)

local inventories = {
    ['qs-inventory'] = 'qs-inventory',
    ['qb-inventory'] = 'qb-inventory',
    ['ps-inventory'] = 'ps-inventory',
    ['ox_inventory'] = 'ox_inventory',
    ['core_inventory'] = 'core_inventory',
    ['codem-inventory'] = 'codem-inventory',
    ['inventory'] = 'inventory',
    ['origen_inventory'] = 'origen_inventory'
}

Config.Inventory = DependencyCheck(inventories) or 'default'

Config.DefaultStashData = {
    maxweight = 1000000,
    slots = 30,
}
--[[
    Explanation about target system: This script supports only `ox_target` or `qb-target` for interactions.
    Other target systems are not compatible.
]]

Config.UseTarget = true    -- Enables or disables the use of the target system for interaction with objects or zones.
Config.TargetDistance = 5.0 -- Defines the interaction distance for the target system.
Config.TargetWidth = 5.0    -- Specifies the width of the interaction zone.
Config.TargetLength = 5.0   -- Specifies the length of the interaction zone.

-- Ignore this, only for development.
Config.ZoneDebug = false -- Toggles debugging for interaction zones (shows zone boundaries).
