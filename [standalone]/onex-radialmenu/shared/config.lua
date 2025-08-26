Config = {}

Config.Settings = {
    toggle = true, -- If set to false, you will have to hold the button to show the menu
    UseWhilstWalking = false,
    controlsToDisable = { -- this is effective if UseWhilstWalking is true
        37,    -- Disable weapon wheel
        1,     -- Disable looking around
        2,     -- Disable moving camera
        106,   -- Disable vehicle mouse look behind
        24     -- Disable attack/punch
    },
    keyBind = 'F1', -- Keybind for opening menu
    uiHoverEffects = true, --  Weather the hover effect is enabled or not
    EditCommand = "editradialmenu", -- Command to edit the radial menu
    ResetCommand = "resetradialmenu", -- Command to reset the radial menu
    color = {
        boxColor = "#FF0039",
        textColor = "#FF0039",
        backBtnColor = "#FF0039",
        ShadowColor = "#FF0039"
    }
}

--[[ 
    This configuration file is not intended for QBCore or QBox users.
    If you are using QB/QBox, please refer to the appropriate configuration files below:
    
    QBCore: onex-radialmenu/bridge/qb-radialmenu/config.lua
    QBox: onex-radialmenu/bridge/qbx_radialmenu/config.lua
]]

-- Radial Menu Configuration for FiveM
-- This configuration defines the structure of the radial menu and its items

Config.menuItems = {{
    icon = {
        address = "fa-solid fa-user",
        width = "10px",
        height = "10px"
    },
    -- job = {
    --     name = "police", -- Job name to restrict access to this menu item
    --     grade = 2 -- Minimum job grade required to access this menu item
    -- },
    label = "General Actions", -- Display label for the menu item
    closeRadialMenu = false,
    trigger = {
        event = {
            name = "onex-radialmenu:client:general_actions",
            type = "client",
            args = "test"
        },
        onSelect = function()
            print('Performing general action')
        end,
        command = "general_action_cmd"
    },
    subMenu = {{
        icon = {
            address = "https://img.icons8.com/ios/50/car.png",
            width = "10px",
            height = "10px"
        },
        label = "Vehicle Options",
        closeSubMenu = true,
        closeRadialMenu = false,
        trigger = {
            event = {
                name = "onex-radialmenu:client:vehicle_options",
                type = "client",
                args = "test"
            },
            command = "vehicle_options_cmd"
        }
    }, {
        icon = {
            address = "https://img.icons8.com/ios/50/backpack.png",
            width = "10px",
            height = "10px"
        },
        label = "Inventory",
        closeSubMenu = true,
        closeRadialMenu = false,
        trigger = {
            event = {
                name = "onex-radialmenu:client:inventory",
                type = "client",
                args = "test"
            },
            command = "inventory_cmd"
        }
    }, {
        icon = {
            address = "https://img.icons8.com/ios/50/smartphone.png",
            width = "10px",
            height = "10px"
        },
        label = "Phone",
        closeSubMenu = true,
        closeRadialMenu = false,
        trigger = {
            event = {
                name = "onex-radialmenu:client:phone",
                type = "client",
                args = "test"
            },
            command = "phone_cmd"
        }
    }, {
        icon = {
            address = "https://img.icons8.com/ios/50/wallet.png",
            width = "10px",
            height = "10px"
        },
        label = "Wallet",
        closeSubMenu = true,
        closeRadialMenu = false,
        trigger = {
            event = {
                name = "onex-radialmenu:client:wallet",
                type = "client",
                args = "test"
            },
            command = "wallet_cmd"
        }
    }, {
        icon = {
            address = "https://img.icons8.com/ios/50/document.png",
            width = "10px",
            height = "10px"
        },
        label = "Documents",
        closeSubMenu = true,
        closeRadialMenu = false,
        trigger = {
            event = {
                name = "onex-radialmenu:client:documents",
                type = "client",
                args = "test"
            },
            command = "documents_cmd"
        }
    }, {
        icon = {
            address = "https://img.icons8.com/ios/50/t-shirt.png",
            width = "10px",
            height = "10px"
        },
        label = "Clothing",
        closeSubMenu = true,
        closeRadialMenu = false,
        trigger = {
            event = {
                name = "onex-radialmenu:client:clothing",
                type = "client",
                args = "test"
            },
            command = "clothing_cmd"
        }
    }, {
        icon = {
            address = "https://img.icons8.com/ios/50/key.png",
            width = "10px",
            height = "10px"
        },
        label = "Keys",
        closeSubMenu = true,
        closeRadialMenu = false,
        trigger = {
            event = {
                name = "onex-radialmenu:client:keys",
                type = "client",
                args = "test"
            },
            command = "keys_cmd"
        }
    }, {
        icon = {
            address = "https://img.icons8.com/ios/50/settings.png",
            width = "10px",
            height = "10px"
        },
        label = "Settings",
        closeSubMenu = true,
        closeRadialMenu = false,
        trigger = {
            event = {
                name = "onex-radialmenu:client:settings",
                type = "client",
                args = "test"
            },
            command = "settings_cmd"
        }
    }}
}, {
    icon = {
        address = "fa-solid fa-ambulance",
        width = "10px",
        height = "10px"
    },
    label = "Emergency Services",
    closeRadialMenu = false,
    trigger = {
        event = {
            name = "onex-radialmenu:client:emergency_services",
            type = "client",
            args = "test"
        },
        onSelect = function()
            print("Emergency services activated")
        end,
        command = "emergency_services_cmd"
    },
    type = "nested",
    subMenu = {{
        icon = {
            address = "https://img.icons8.com/ios/50/police-badge.png",
            width = "10px",
            height = "10px"
        },
        label = "Call Police",
        closeSubMenu = true,
        closeRadialMenu = false,
        trigger = {
            event = {
                name = "onex-radialmenu:client:call_police",
                type = "client",
                args = "test"
            },
            command = "call_police_cmd"
        }
    }, {
        icon = {
            address = "https://img.icons8.com/ios/50/ambulance.png",
            width = "10px",
            height = "10px"
        },
        label = "Call Ambulance",
        closeSubMenu = true,
        closeRadialMenu = false,
        trigger = {
            event = {
                name = "onex-radialmenu:client:call_ambulance",
                type = "client",
                args = "test"
            },
            command = "call_ambulance_cmd"
        }
    }}
}}

Config.TestingMode = true -- dont touch
