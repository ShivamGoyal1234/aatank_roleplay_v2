FRKN = FRKN or {}

FRKN.Job = {
    --GENERAL JOB SETTINGS
    JobPrisonControl = false, --If this is true, only those in prison can do jobs in prison. If it is "false", those jobs can be done by people who are not in prison.

    --TASKS PRICE AND ITEMS CONFIG
    Tasks = { --Do not change the item names because the escape process proceeds accordingly.
        poop = {
            decraseTime = 5,
            money = 100,
            rewardItems = {
                {
                    name = "prison_rustynail",
                    label = "Rusty Nail",
                    amount = 1
                },
                {
                    name = "prison_tornglove",
                    label = "Torn Glove",
                    amount = 1
                }
            }
        },
        dish = {
            decraseTime = 10,
            money = 200,
            rewardItems = {
                {
                    name = "prison_soapresidue",
                    label = "Soap Residue",
                    amount = 1
                },
                {
                    name = "prison_plateshard",
                    label = "Broken Plate Shard",
                    amount = 1
                }
            }
        },
        gym = {
            decraseTime = 15,
            money = 300,
            rewardItems = {
                {
                    name = "prison_barbellrod",
                    label = "Bent Barbell Rod",
                    amount = 1
                },
                {
                    name = "prison_sweatytowel",
                    label = "Sweaty Towel",
                    amount = 1
                }
            }
        }
    },



    --CLEANING JOB CONFIG
    poopModel = "prop_big_shit_01",
    cleaningTool = "prop_tool_broom",
    maxPoops = 5,
    cleanupTime = 10000,
    respawnDelay = 10 * 60 * 10,
    cleanupZones = {
        {
            x1 = 1685.0,
            y1 = 2475.0,
            z1 = 44.55,
            x2 = 1695.0,
            y2 = 2485.0,
            z2 = 44.55
        },
    },

    --DISH JOB CONFIG
    washCoords = vector3(1788.6066, 2567.5662, 45.6232),
    cupboardCoords = vector3(1781.3596, 2568.1255, 45.5032),
    placedPropCount = 5, --So, once you place 5 props, the task is complete.
    dishDefinitions = {
        {
            model = 'prop_whiskey_glasses',
            coords = vector3(1784.82, 2564.17, 45.59),
            isWashedModel = 'prop_wine_glass',
            offset = vector3(0.13, 0.02, -0.02),
            rotation = vector3(-90.0, 0.0, 90.0),
            bone = 57005 -- Right Hand
        },
        {
            model = 'prop_copper_pan',
            coords = vector3(1782.71, 2565.83, 45.61),
            isWashedModel = 'prop_copper_pan',
            offset = vector3(0.1, 0.0, -0.1),
            rotation = vector3(0.0, 0.0, 0.0),
            bone = 57005
        },
        {
            model = 'prop_kettle',
            coords = vector3(1783.16, 2568.4, 45.53),
            isWashedModel = 'prop_kettle',
            offset = vector3(0.1, 0.0, -0.1),
            rotation = vector3(0.0, 0.0, 0.0),
            bone = 57005
        },
        {
            model = 'prop_foodprocess_01',
            coords = vector3(1785.58, 2568.41, 45.52),
            isWashedModel = 'prop_foodprocess_01',
            offset = vector3(0.1, 0.0, -0.1),
            rotation = vector3(0.0, 0.0, 0.0),
            bone = 57005
        },
        {
            model = 'prop_copper_pan',
            coords = vector3(1781.32, 2563.21, 44.66),
            isWashedModel = 'prop_copper_pan',
            offset = vector3(0.1, 0.0, -0.1),
            rotation = vector3(0.0, 0.0, 0.0),
            bone = 57005
        },
    },

    -- GYM JOB CONFIG
    changeClothesCoords = vector4(1732.0748, 2499.8147, 49.2287, 170.3239), -- Prison change clothes coords
    SportOutfits = {
    male = {
           {
               components = {
                   { component_id = 3, drawable = 15, texture = 0 },  
                   { component_id = 4, drawable = 14, texture = 0 },  
                   { component_id = 6, drawable = 7, texture = 0 },  
                   { component_id = 8, drawable = 15, texture = 0 },  
                   { component_id = 11, drawable = 15, texture = 0 }, 
                   { component_id = 7, drawable = 0, texture = 0 }, 
                   { component_id = 10, drawable = 0, texture = 0 }, 
               }
           }
       },

       female = {
           {
               components = {
                   { component_id = 3, drawable = 14, texture = 0 },
                   { component_id = 4, drawable = 37, texture = 0 },
                   { component_id = 6, drawable = 4, texture = 0 },
                   { component_id = 8, drawable = 15, texture = 0 },
                   { component_id = 11, drawable = 15, texture = 0 },
               }
           }
       }
    },
    pullupSpots = {
        {
            coords = vector3(1727.3789, 2497.2597, 45.8447),
            heading = 121.3913
        },
        {
            coords = vector3(1731.7228, 2489.8123, 45.8254),
            heading = 123.0902
        }
    },
    barbellPickupCoords = vector3(1737.94, 2491.54, 45.02),
    barbellHeading = 261.11,
    barbellModel = "prop_barbell_30kg", 


}