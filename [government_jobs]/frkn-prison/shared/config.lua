FRKN = FRKN or {}

FRKN.General = {
	ServerCallbacks = {},

    --GENERAL CONFIG
    targetSystem = 'qb-target',
    PrisonNoteBook = 'prison_notebook',
    ItemSystem = false,--If you set this to true, your items will be deleted when you enter prison. They will be returned when you leave prison.
    AddItems = { --Items that will be automatically added to inventory upon entering prison
        ['bread'] = 1,
        ['water'] = 1,
        ['cigarette'] = 5,
        ['prison_notebook'] = 1
    },


    Job = {'police' , 'sheriff'},


    --COORDS CONFIG
    ReleaseTeleportCoords =  {
        from = vector3(1855.6772, 2610.3850, 45.6720), -- Prison release coords
        fromHeading = 281.5382, -- Prison release heading
        to = vector3(1762.2449, 2489.4612, 45.8450), --Inside the prison coords
        toHeading = 119.0463, -- Inside the prison heading
        visitCoords = vector3(1837.3680, 2578.2546, 45.8879), -- visit room coords
    },

    PrisonZoneCoords = {
        vector2(1842.5515, 2593.2415),
        vector2(1824.5754, 2476.2856),
        vector2(1792.2762, 2446.7007),
        vector2(1761.8538, 2408.7957),
        vector2(1658.8988, 2394.7749),
        vector2(1538.0464, 2467.8049),
        vector2(1534.8639, 2585.2930),
        vector2(1569.8887, 2680.0981),
        vector2(1649.0541, 2756.7358),
        vector2(1772.4791, 2763.3948),
        vector2(1848.4291, 2698.5896),
        vector2(1829.71, 2626.32)
    },
    PrisonZoneMinZ = 35.0,
    PrisonZoneMaxZ = 70.0,

   
    --PRISON VISIT PHONES CONFIG
    PhoneSystem = {
        phoneModels = { --Names of phones you can use for visits
            `hei_prop_hei_bank_phone_01`
        },
       qbTargetOptions = {
            options = {
                {
                    event = "frkn-prison:interactWithPhone",
                    icon = "fas fa-phone",
                    label = "Using the Phone",
                }
            },
            distance = 2.5, 
        },
        oxTargetOptions = {
            {
                event = "frkn-prison:interactWithPhone",
                icon = "fas fa-phone",
                label = "Using the Phone",
                distance = 2.5, 
            }
        },
    },


    --PRISON OUTFITS CONFIG
    PrisonOutfit = {
        enable = false, -- If you set this to false, you will not be able to change your outfit
        male = {
            mask        = { item = 0, texture = 0 },     
            arms        = { item = 4, texture = 0 },     
            ["t-shirt"] = { item = 15, texture = 0 },    
            ["torso2"]  = { item = 139, texture = 0 },   
            pants       = { item = 125, texture = 3 },   
            shoes       = { item = 18, texture = 0 },    
            accessories = { item = 0, texture = 0 }      
        },
        female = {
            mask        = { item = 0, texture = 0 },
            arms        = { item = 4, texture = 0 },
            ["t-shirt"] = { item = 2, texture = 0 },
            ["torso2"]  = { item = 229, texture = 0 },
            pants       = { item = 3, texture = 15 },
            shoes       = { item = 72, texture = 0 },
            accessories = { item = 0, texture = 0 }
        }
    },


    --ELECTRIC CONFIG
    panelLocations = {
        { x = 1752.9846, y = 2721.7998, z = 45.5649, w = 107.4926 , status = false},
        -- { x = 1642.5026, y = 2709.5242, z = 47.6257, w = 211.6357 , status = false},
        -- { x = 1608.5355, y = 2669.3428, z = 45.1276, w = 240.1695 , status = false},
        -- { x = 1608.4973, y = 2655.5276, z = 44.9814, w = 205.3672 , status = false},
        -- { x = 1613.7955, y = 2611.0867, z = 45.5648, w = 4.2597 , status = false}
    },
    TimeControl = false, -- If you set it to true, you can only cut off the electrical panels at night.


    --TUNNEL CONFIG
    digSpot = {
        coords = vector3(1671.8668, 2700.0352, 45.5649),
        heading = 72.9042,
        cleaned = false,
        progress = 0
    },
    TunelEntrance = { --Tunnel entrance
        coords = vector3(1770.2507, 2829.3689, 20.6350),
        heading = 112.4924
    },
    TunelExit = { --Exit at the end of the tunnel
        coords = vector3(1942.06921, 2687.84644, 32.8981743),
        heading = 0.0
    },
    TunelOut = { --The place where you will spawn after exiting the tunnel
        coords = vector3(1947.5433, 2683.4050, 42.7956),
        heading = 34.0733
    },

    --NPC DIALOGS CONFIG
    PrisonDialogs = {
        goodNpc = {
            greeting = "Hey, you new here?",
            firstOption = {
                type = "job_inquiry", -- DO NOT CHANGE THIS
                label = "How can I find work here?",
                playerText = "How can I find work here?",
                npcReply = {
                    "Check out the laundry room. No one likes going there, but they’re always short-handed and no one questions anything.",
                    "Heard they need a dishwasher near the canteen. You won’t draw attention, and you might find something useful.",
                    "Visit the library. The shelves are a mess. It’s quiet, but sometimes forgotten things remain there.",
                    "There might be cleaning work in the yard. Not sure if you’ll find anything valuable in the trash, but quiet corners tell stories."
                }
            },
            escapeOption = {
                label = "How can I escape from here?",
                playerText = "How can I escape from here?",
                npcReply = {
                    "Unless you want the guards to know, don’t bring this up again. Whatever you're planning will get you and me caught.",
                    "You? Escape? You struggle with dishes. Stop dreaming and live with reality.",
                    "I’ve seen others try. They got caught or disappeared. Escaping is impossible. Accept it.",
                    "Don’t drag me into this! If a guard hears my name, not even these walls can protect you!"
                },
                revealsEscapePlan = false,
                alertsGuards = true
            }
        },

        badNpc = {
            greeting = "What did you bring?",
            firstOption = {
                type = "item_delivery",  -- DO NOT CHANGE THIS
                label = "I brought the items.",
                playerText = "I brought the items.",
                npcReply = {
                    "Hmm... fine. This will do for now. Now disappear and don’t draw attention.",
                    "Is that all? Whatever... it'll work. You’ll learn what comes next at the right time.",
                    "Good, those are the parts I needed. But don’t bother me again. We might be watched.",
                    "Alright, keep it quiet. I’ll tell you the next step. For now, vanish."
                }
            },
            escapeOption = {
                label = "How can I escape from here?",
                playerText = "How can I escape from here?",
                npcReply = {
                    "If you gather the right parts, they might become more useful than you think. A skilled hand can turn them into tools. But the electric panels must be bypassed. Digging is a whole different story... Wait for nightfall.",
                    "Don’t waste time in your cell. Dishwashing, exercise, cleaning... all could be useful. Find someone to help. Without disabling the panels and having a shovel, there's no escape. Stay out of sight during the day.",
                    "Not everything here is junk. Work hard and you might find something useful. If you know someone who can combine parts, you’re lucky. Power grid is a problem. Tunnels need stealth. Night’s your best shot.",
                    "Some jobs give more than just money. If you find the right person, parts become tools. Without a blackout, you can’t even open the tunnel hatch. Daytime attempts are suicide.",
                    "Laundry, gym, cleaning... you’ll find usable parts there. Combine them to craft a cutter or digger. Without cutting the power, you won’t open the hatch. Shadows help at night."
                },
                revealsEscapePlan = true,
                alertsGuards = false
            }
        }
    },


	PrisonNPCs = {
        {
            coords = vector4(1687.6576, 2565.9609, 45.5649, 176.9481),
            npc = "s_m_y_prisoner_01",
            animDict = "amb@world_human_muscle_flex@arms_at_side@base",
            animName = "base",
            status = 1
        },
        {
            coords = vector4(1715.5906, 2566.9541, 45.5649, 217.1872),
            npc = "s_m_y_prisoner_01",
            animDict = "amb@world_human_hang_out_street@male_c@idle_a",
            animName = "idle_a",
            status = 0
        },
        {
            coords = vector4(1713.0642, 2525.9197, 45.5649, 78.0047),
            npc = "s_m_y_prisoner_01",
            animDict = "amb@world_human_broom@male@base",
            animName = "base",
            status = 1
        },
        {
            coords = vector4(1668.0442, 2487.8491, 45.5650, 4.1941),
            npc = "s_m_y_prisoner_01",
            animDict = "amb@prop_human_seat_chair_mp@male@base",
            animName = "base",
            status = 0
        },
        {
            coords = vector4(1655.0444, 2490.1084, 45.8569, 320.8080),
            npc = "s_m_y_prisoner_01",
            animDict = "amb@world_human_push_ups@male@base",
            animName = "base",
            status = 1
        },
        {
            coords = vector4(1628.3807, 2488.8989, 45.5649, 322.1718),
            npc = "s_m_y_prisoner_01",
            animDict = "amb@world_human_muscle_flex@arms_at_side@base",
            animName = "base",
            status = 0
        },
        {
            coords = vector4(1598.9648, 2551.2449, 45.5649, 285.9778),
            npc = "s_m_y_prisoner_01",
            animDict = "amb@world_human_leaning@male@wall@back@hands_together@base",
            animName = "base",
            status = 0
        },
        {
            coords = vector4(1608.9417, 2566.4163, 45.5649, 259.7844),
            npc = "s_m_y_prisoner_01",
            animDict = "amb@world_human_stand_guard@male@base",
            animName = "base",
            status = 1
        },
        {
            coords = vector4(1648.2981, 2564.8521, 45.5649, 167.6238),
            npc = "s_m_y_prisoner_01",
            animDict = "amb@world_human_aa_smoke@male@idle_a",
            animName = "idle_c",
            status = 0
        },
        {
            coords = vector4(1685.7369, 2549.4790, 45.5649, 98.3902),
            npc = "s_m_y_prisoner_01",
            animDict = "amb@world_human_leaning@male@wall@back@hands_together@base",
            animName = "base",
            status = 1
        },
        {
            coords = vector4(1770.1157, 2565.6213, 45.5650, 125.6973),
            npc = "s_m_y_prisoner_01",
            animDict = "amb@world_human_hang_out_street@male_c@idle_a",
            animName = "idle_b",
            status = 1
        },
        {
            coords = vector4(1756.1792, 2569.1584, 45.5650, 188.6035),
            npc = "s_m_y_prisoner_01",
            animDict = "amb@world_human_stand_guard@male@base",
            animName = "base",
            status = 0
        }
	},

    
    --BASKETBALL CONFIG
    BasketballZones = {
        {
            label = "Basketball Court",
            points = {
                vector2(1682.5226, 2528.4807),
                vector2(1695.7653, 2518.0359),
                vector2(1678.1663, 2497.4634),
                vector2(1664.8810, 2508.0171)
            },
            minZ = 44.5,
            maxZ = 47.0
        }
    },

    Limit = 5, -- Maximum number of basketballs that can be spawned at once

    CheckForUpdates            = true, -- Set it to true if you want to get the latest version update info
    PropModel                  = 'prop_bskball_01', -- Change here if you want to change the basketball prop model
    Commands                   = 'basketball', -- Change here if you want to change the command to bring up the basketball    
	PickUpBall                 = 38 ,  -- [E]
    PlayStyleBall              = 303 , -- [U]
    ShootBall                  = 263 , -- [R]
    DribbleBall                = 47  , -- [G]
    DetachBall                 = 73  , -- [X]

}

