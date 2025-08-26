


----------------------------------------------------------------------------------------------
----------------------------------| BRUTAL SHOP ROBBERY :) |----------------------------------
----------------------------------------------------------------------------------------------

--[[
Hi, thank you for buying our script, We are very grateful!

For help join our Discord server:     https://discord.gg/85u2u5c8q9
More informations about the script:   https://docs.brutalscripts.com
--]]

Config = {
    Core = 'QBCORE',  -- ESX / QBCORE | Other core setting on the 'core' folder and the client and server utils.lua
    TextUI = 'ox_lib', -- false / 'brutal_textui' / 'ox_lib' / 'okokTextUI' / 'ESXTextUI' / 'QBDrawText' // Custom can be add in the cl_utils.lua!!!
    Target = 'qb-target', -- 'oxtarget' / 'qb-target' // if the TextUI is set to false target will step its place. | The Target cannot be false.
    ProgressBar = 'ox_lib', -- 'progressBars' / 'pogressBar' / 'mythic_progbar' / 'ox_lib' // Custom can be add in the cl_utils.lua!!!
    BrutalNotify = false, -- Buy here: (4€+VAT) https://store.brutalscripts.com | Or set up your own notify >> cl_utils.lua

    CopsJobs = {'police', 'fbi'}, -- Add the cops jobs
    RequiredCopsCount = 2, -- This is how many cops are needed to be in the server to start a robbery
    NotifyToRobbery = true,
    Cooldown = 15, -- The time between robberies after finished.
    RobberyEndCoolDown = 60, -- The robbery ends automatically when the time runs out (in minutes). Set to false to disable.
    PoliceAlertBlip = {label = 'Shop Robbery', size = 2.0, sprite = 161, color = 1},
    RobberyBlips = {Use = false, label = 'Shop Robbery', size = 0.8, sprite = 156, color = 62},
    NpcAttack = {chance = 25, weapon = 'WEAPON_PISTOL'}, -- if you don't want to the shopkeepers to attact >> chance = 0
    DrillItem = {item = 'drill', label = 'Drill'}, -- Drill item [YOU NEED TO CREATE IT FOR YOURSELF!!]
    DisableControls = {177, 200, 202, 322}, -- Disables controls when the player drills | More keys: https://docs.fivem.net/docs/game-references/controls/
    WeaponAnimation = false, -- If your server has preemption/unload weapon animation, set this to true. | true / false [EDITABLE >> cl_utils.lua]
    MaxDistance = 50, -- The robbery ends after this distance.
    BagNumber = 45,
    AddonCashRegister = false, -- Set this value to true if you're not using the default cashregister prop.

    ItemsSellToBoss = {
        use = true, -- Use item sell functions? | you can use your custom too
        availableTime = 30, -- in minutes [That's how long the player have to deliver the items after the robbery]
        coords = vector4(-274.8105, 167.8665, 77.9090, 84.9507), -- Sell coords
        model = 'a_m_m_eastsa_01', -- Sell NPC model
        blip = {use = true, label = 'Items Sell', size = 0.9, sprite = 500, color = 2} -- Sell Blip
    },
    
    ShopRobberys = {
        [1] = {
            ShopName = 'Shop 1', -- Shop Name
            NPC = {model = 'mp_m_shopkeep_01', coords = vector4(24.0687, -1346.2, 28.4970, 270.0)}, -- Shopkeeper Position [x,y,z,heading]
            SecondsRemaining = 60, -- After all these seconds the player can drill the safe [thus the cops have enough time]
            CashRegisterMoney = {15000, 20000}, -- Minimum, Maximum money amount
            SafeMoney = {20000, 25000}, -- Minimum, Maximum money amount
            SafeRewardItems = { -- Safe rewards items
                -- {label = ITEM LABEL, item = ITEM NAME, count = {MINIMUM, MAXIMUM}, sellPrice = SALE PRICE},
                {label = 'Gold', item = 'gold', count = {5, 10}, sellPrice = 1000},
                {label = 'Diamond', item = 'diamond', count = {5, 10}, sellPrice = 2000},
            },
            SafeCoords = {
                [1] = vector4(30.5760, -1339.8638, 28.4970, 270.3186), -- Safe positions [x,y,z,heading]
            },
            CashRegisters = { -- Cash Registers positions
                [1] = {coords = vector4(24.4118, -1344.8802, 29.4970, 264.7126)},
                [2] = {coords = vector4(24.3867, -1347.2975, 29.4970, 268.5292)},
            }
        },
        [2] = {
            ShopName = 'Shop 2',
            NPC = {model = 'mp_m_shopkeep_01', coords = vector4(372.658, 327.282, 102.566, 250.0)},
            SecondsRemaining = 60,
CashRegisterMoney = {15000, 20000}, -- Minimum, Maximum money amount
            SafeMoney = {20000, 25000}, -- Minimum, Maximum money amount
            SafeRewardItems = {
                {label = 'Gold', item = 'gold', count = {5, 10}, sellPrice = 1000},
                {label = 'Diamond', item = 'diamond', count = {5, 10}, sellPrice = 2000},
            },
            SafeCoords = {
                [1] = vector4(379.960, 331.858, 102.566, 255.50),
            },
            CashRegisters = {
                [1] = {coords = vector4(373.0525, 328.7198, 103.5664, 252.8959)},
                [2] = {coords = vector4(372.3297, 326.4221, 103.5664, 260.9140)},
            }
        }, 
        [3] = {
            ShopName = 'Shop 3',
            NPC = {model = 'mp_m_shopkeep_01', coords = vector4(1391.73, 3606.31, 33.9808, 200.0)},
            SecondsRemaining = 60,
            CashRegisterMoney = {15000, 20000}, -- Minimum, Maximum money amount
            SafeMoney = {20000, 25000}, -- Minimum, Maximum money amount
            SafeRewardItems = {
                {label = 'Gold', item = 'gold', count = {5, 10}, sellPrice = 1000},
                {label = 'Diamond', item = 'diamond', count = {5, 10}, sellPrice = 2000},
            },
            SafeCoords = {
                [1] = vector4(1394.57, 3608.57, 33.9808, 200.50),
            },
            CashRegisters = {
                [1] = {coords = vector4(1392.8512, 3606.4951, 34.9809, 197.1289)},
            }
        }, 
        [4] = {
            ShopName = 'Shop 4',
            NPC = {model = 'mp_m_shopkeep_01', coords = vector4(-46.675, -1758.3, 28.4210, 50.0)},
            SecondsRemaining = 60,
            CashRegisterMoney = {15000, 20000}, -- Minimum, Maximum money amount
            SafeMoney = {20000, 25000}, -- Minimum, Maximum money amount
            SafeRewardItems = {
                {label = 'Gold', item = 'gold', count = {5, 10}, sellPrice = 1000},
                {label = 'Diamond', item = 'diamond', count = {5, 10}, sellPrice = 2000},
            },
            SafeCoords = {
                [1] = vector4(-41.688, -1749.3, 28.4210, 320.50),
            },
            CashRegisters = {
                [1] = {coords = vector4(-47.8668, -1759.3733, 29.4210, 48.8711)},
                [2] = {coords = vector4(-46.6810, -1758.0726, 29.4210, 50.2749)},
            }
        },
        [5] = {
            ShopName = 'Shop 5',
            NPC = {model = 'mp_m_shopkeep_01', coords = vector4(1165.26, -322.95, 68.2050, 100.0)},
            SecondsRemaining = 60,
            CashRegisterMoney = {15000, 20000}, -- Minimum, Maximum money amount
            SafeMoney = {20000, 25000}, -- Minimum, Maximum money amount
            SafeRewardItems = {
                {label = 'Gold', item = 'gold', count = {5, 10}, sellPrice = 1000},
                {label = 'Diamond', item = 'diamond', count = {5, 10}, sellPrice = 2000},
            },
            SafeCoords = {
                [1] = vector4(1161.55, -313.43, 68.2050, 10.50),
            },
            CashRegisters = {
                [1] = {coords = vector4(1165.1122, -324.5011, 69.2050, 103.7801)},
                [2] = {coords = vector4(1164.8171, -322.7833, 69.2050, 98.2290)},
            }
        }, 
        [6] = {
            ShopName = 'Shop 6',
            NPC = {model = 'mp_m_shopkeep_01', coords = vector4(-705.62, -913.89, 18.2155, 90.0)},
            SecondsRemaining = 60,
            CashRegisterMoney = {15000, 20000}, -- Minimum, Maximum money amount
            SafeMoney = {20000, 25000}, -- Minimum, Maximum money amount
            SafeRewardItems = {
                {label = 'Gold', item = 'gold', count = {5, 10}, sellPrice = 1000},
                {label = 'Diamond', item = 'diamond', count = {5, 10}, sellPrice = 2000},
            },
            SafeCoords = {
                [1] = vector4(-707.70, -904.08, 18.2155, 0.50),
            },
            CashRegisters = {
                [1] = {coords = vector4(-706.1139, -913.7576, 19.2156, 82.0735)},
                [2] = {coords = vector4(-706.0679, -915.4430, 19.2156, 96.1415)},
            }
        }, 
        [7] = {
            ShopName = 'Shop 7',
            NPC = {model = 'mp_m_shopkeep_01', coords = vector4(1728.06, 6416.29, 34.0372, 240.0)},
            SecondsRemaining = 60,
            CashRegisterMoney = {100, 200},
            SafeMoney = {1000, 2000},
            SafeRewardItems = {
                {label = 'Gold', item = 'gold', count = {5, 10}, sellPrice = 1000},
                {label = 'Diamond', item = 'diamond', count = {5, 10}, sellPrice = 2000},
            },
            SafeCoords = {
                [1] = vector4(1736.66, 6419.02, 34.0372, 243.0),
            },
            CashRegisters = {
                [1] = {coords = vector4(1728.9253, 6417.3052, 35.0372, 244.5403)},
                [2] = {coords = vector4(1727.7891, 6415.2930, 35.0372, 248.8461)},
            }
        }, 
        [8] = {
            ShopName = 'Shop 8',
            NPC = {model = 'mp_m_shopkeep_01', coords = vector4(549.554, 2670.23, 41.1564, 100.0)},
            SecondsRemaining = 60,
            CashRegisterMoney = {100, 200},
            SafeMoney = {1000, 2000},
            SafeRewardItems = {
                {label = 'Gold', item = 'gold', count = {5, 10}, sellPrice = 1000},
                {label = 'Diamond', item = 'diamond', count = {5, 10}, sellPrice = 2000},
            },
            SafeCoords = {
                [1] = vector4(545.07, 2663.47, 41.1564, 97.0),
            },
            CashRegisters = {
                [1] = {coords = vector4(549.3412, 2669.0034, 42.1565, 92.7990)},
                [2] = {coords = vector4(549.1663, 2671.2646, 42.1565, 91.3275)},
            }
        }, 
        [9] = {
            ShopName = 'Shop 9',
            NPC = {model = 'mp_m_shopkeep_01', coords = vector4(-3243.3, 999.759, 11.8307, 350.0)},
            SecondsRemaining = 60,
            CashRegisterMoney = {100, 200},
            SafeMoney = {1000, 2000},
            SafeRewardItems = {
                {label = 'Gold', item = 'gold', count = {5, 10}, sellPrice = 1000},
                {label = 'Diamond', item = 'diamond', count = {5, 10}, sellPrice = 2000},
            },
            SafeCoords = {
                [1] = vector4(-3249.02, 1006.04, 11.8307, 0.50),
            },
            CashRegisters = {
                [1] = {coords = vector4(-3244.7192, 1000.1409, 12.8307, 352.6251)},
                [2] = {coords = vector4(-3242.3438, 999.9642, 12.8307, 356.2621)},
            }
        }, 
        [10] = {
            ShopName = 'Shop 10',
            NPC = {model = 'mp_m_shopkeep_01', coords = vector4(-1819.5, 794.251, 137.079, 140.0)},
            SecondsRemaining = 60,
            CashRegisterMoney = {100, 200},
            SafeMoney = {1000, 2000},
            SafeRewardItems = {
                {label = 'Gold', item = 'gold', count = {5, 10}, sellPrice = 1000},
                {label = 'Diamond', item = 'diamond', count = {5, 10}, sellPrice = 2000},
            },
            SafeCoords = {
                [1] = vector4(-1828.23, 799.83, 137.1, 44.50),
            },
            CashRegisters = {
                [1] = {coords = vector4(-1820.0228, 794.2722, 138.0869, 130.0219)},
                [2] = {coords = vector4(-1818.8097, 792.9395, 138.0804, 127.9903)},
            }
        }, 
        [11] = {
            ShopName = 'Shop 11',
            NPC = {model = 'mp_m_shopkeep_01', coords = vector4(1697.57, 4922.87, 41.0636, 320.0)},
            SecondsRemaining = 60,
            CashRegisterMoney = {100, 200},
            SafeMoney = {1000, 2000},
            SafeRewardItems = {
                {label = 'Gold', item = 'gold', count = {5, 10}, sellPrice = 1000},
                {label = 'Diamond', item = 'diamond', count = {5, 10}, sellPrice = 2000},
            },
            SafeCoords = {
                [1] = vector4(1706.87, 4919.76, 41.0636, 237.50),
            },
            CashRegisters = {
                [1] = {coords = vector4(1696.5485, 4923.9009, 42.0636, 324.7522)},
                [2] = {coords = vector4(1697.8932, 4922.8638, 42.0636, 327.1393)},
            }
        }, 
        [12] = {
            ShopName = 'Shop 12',
            NPC = {model = 'mp_m_shopkeep_01', coords = vector4(1959.32, 3740.79, 31.3437, 300.0)},
            SecondsRemaining = 60,
            CashRegisterMoney = {100, 200},
            SafeMoney = {1000, 2000},
            SafeRewardItems = {
                {label = 'Gold', item = 'gold', count = {5, 10}, sellPrice = 1000},
                {label = 'Diamond', item = 'diamond', count = {5, 10}, sellPrice = 2000},
            },
            SafeCoords = {
                [1] = vector4(1961.32, 3749.37, 31.3437, 300.50),
            },
            CashRegisters = {
                [1] = {coords = vector4(1959.9600, 3740.0596, 32.3437, 298.1317)},
                [2] = {coords = vector4(1958.9476, 3742.0571, 32.3437, 300.2418)},
            }
        }, 
        [13] = {
            ShopName = 'Shop 13',
            NPC = {model = 'mp_m_shopkeep_01', coords = vector4(2676.91, 3279.72, 54.2411, 330.0)},
            SecondsRemaining = 60,
            CashRegisterMoney = {100, 200},
            SafeMoney = {1000, 2000},
            SafeRewardItems = {
                {label = 'Gold', item = 'gold', count = {5, 10}, sellPrice = 1000},
                {label = 'Diamond', item = 'diamond', count = {5, 10}, sellPrice = 2000},
            },
            SafeCoords = {
                [1] = vector4(2674.24, 3287.99, 54.2411, 330.50),
            },
            CashRegisters = {
                [1] = {coords = vector4(2675.9114, 3280.5500, 55.2411, 328.1966)},
                [2] = {coords = vector4(2678.0488, 3279.4409, 55.2411, 328.9059)},
            }
        }, 
        [14] = {
            ShopName = 'Shop 14',
            NPC = {model = 'mp_m_shopkeep_01', coords = vector4(2555.68, 380.539, 107.623, 350.0)},
            SecondsRemaining = 60,
            CashRegisterMoney = {100, 200},
            SafeMoney = {1000, 2000},
            SafeRewardItems = {
                {label = 'Gold', item = 'gold', count = {5, 10}, sellPrice = 1000},
                {label = 'Diamond', item = 'diamond', count = {5, 10}, sellPrice = 2000},
            },
            SafeCoords = {
                [1] = vector4(2550.09, 386.529, 107.623, 357.50),
            },
            CashRegisters = {
                [1] = {coords = vector4(2557.1335, 380.7466, 108.6230, 356.7479)},
                [2] = {coords = vector4(2554.7847, 380.8927, 108.6230, 351.0061)},
            }
        }, 
        [15] = {
            ShopName = 'Shop 15',
            NPC = {model = 'mp_m_shopkeep_01', coords = vector4(-3040.2, 583.874, 6.90893, 25.0)},
            SecondsRemaining = 60,
            CashRegisterMoney = {100, 200},
            SafeMoney = {1000, 2000},
            SafeRewardItems = {
                {label = 'Gold', item = 'gold', count = {5, 10}, sellPrice = 1000},
                {label = 'Diamond', item = 'diamond', count = {5, 10}, sellPrice = 2000},
            },
            SafeCoords = {
                [1] = vector4(-3047.88, 588.16, 6.90893, 17.50),
            },
            CashRegisters = {
                [1] = {coords = vector4(-3041.2917, 583.8245, 7.9089, 11.2701)},
                [2] = {coords = vector4(-3039.0171, 584.5056, 7.9089, 24.9740)},
            }
        }, 
        [16] = {
            ShopName = 'Shop 16',
            NPC = {model = 'mp_m_shopkeep_01', coords = vector4(1166.06, 2710.83, 37.16, 178.0)},
            SecondsRemaining = 60,
            CashRegisterMoney = {100, 200},
            SafeMoney = {1000, 2000},
            SafeRewardItems = {
                {label = 'Gold', item = 'gold', count = {5, 10}, sellPrice = 1000},
                {label = 'Diamond', item = 'diamond', count = {5, 10}, sellPrice = 2000},
            },
            SafeCoords = {
                [1] = vector4(1169.0, 2719.89, 36.16, 350.50),
            },
            CashRegisters = {
                [1] = {coords = vector4(1165.9950, 2710.7939, 38.1577, 173.7385)},
            }
        },

        -- You can add more...
    },
    
-----------------------------------------------------------
-----------------------| TRANSLATE |-----------------------
-----------------------------------------------------------

    MoneyForm = '$',
    SecondForm = 'second',

    Progressbar = {
        GrabMoney = 'Grabbing money...',
    },

    Targets = {
        [1] = {'Grab the money', 'fa-solid fa-gun'},
        [2] = {'Drill the Safe', 'fa-solid fa-vault'},
        [3] = {'Sell the items', 'fa-solid fa-user-secret'},
    },

    Texts = {
        [1] = {'[E] to grab the money', 38},
        [2] = {'[E] to drill the Safe', 38},
        [3] = {'[E] to sell the items', 38},
    },

    Notify = {
        [1] =  {'Notification', "There is already a robbery in progress.", 5000, 'error'},
        [2] =  {'Notification', "Not enough cops in the City!", 5000, 'error'},
        [3] =  {'Notification', "The robbery has started!", 5000, 'success'},
        [4] =  {'Notification', "Drilling failed!", 5000, 'error'},
        [5] =  {'Notification', "The drill head broke off!", 5000, 'error'},
        [6] =  {'Notification', "You already drilled the safe!", 5000, 'error'},
        [7] =  {'Notification', "Shoot the cash register!", 5000, 'error'},
        [8] =  {'Notification', "There was a robbery a while ago, please wait!", 5000, 'error'},
        [9] =  {'Notification', "You need item:", 5000, 'error'},
        [10] =  {'Notification', "You got:", 5000, 'success'},
        [11] =  {'Notification', "Time's up! The Boss has left!", 5000, 'error'},
        [12] =  {'Notification', "You sold:", 8000, 'success'},
        [13] =  {'Notification', "You have nothing useful!", 5000, 'error'},
        [14] =  {'Notification', "Sell the items in the designated place!", 10000, 'info'},
        [15] =  {'Notification', "The robbery is finished:", 5000, 'info'},
        [16] =  {'Notification', "You have to wait:", 5000, 'info'},
        [17] =  {'Notification', "Point your gun at the NPC to rob the shop!", 7000, 'info'},
        [18] =  {'Notification', "Put the gun away!", 5000, 'error'},
    },

    SuccessRobbery = {
        Use = true,
        missionTextLabel = "~y~SHOP ROBBERY~s~", 
        passFailTextLabel = "COMPLETED.",
        messageLabel = "Run away from the police.",
        
        totalPayOut = "Total Payout",
    },

    FailedRobbery = {
        Use = true,
        missionTextLabel = "~y~SHOP ROBBERY~s~", 
        passFailTextLabel = "FAILED.",
        messageLabel = "This time it failed."
    },

    IdentifierType = 'license',  -- steam / license / discord
    Webhooks = {
        Locale = {
            ['robberyProcess'] = '⌛ Robbery started...',
            ['robberyFinished'] = '✅ Robbery finished.',

            ['HasStarted'] = 'started the Shop Robbery!',
            ['HasFinished'] = 'finished the Shop Robbery!',
            ['RobberHasQuit'] = '**The robber has quit the game!\nThe robbery is finished!**',

            ['Shop'] = 'Shop Name',
            ['Identifier'] = 'Identifier',

            ['Time'] = 'Time ⏲️'
        },

        -- To change a webhook color you need to set the decimal value of a color, you can use this website to do that - https://www.mathsisfun.com/hexadecimal-decimal-colors.html
        Colors = {
            ['robberyProcess'] = 3145631, 
            ['robberyFinished'] = 16711680
        }
    },
}