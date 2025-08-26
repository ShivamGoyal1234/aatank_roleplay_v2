-- ██████╗  █████╗ ██████╗ ██╗  ██╗██╗███╗   ██╗ ██████╗      ██████╗██████╗ ███████╗ █████╗ ████████╗ ██████╗ ██████╗ 
-- ██╔══██╗██╔══██╗██╔══██╗██║ ██╔╝██║████╗  ██║██╔════╝     ██╔════╝██╔══██╗██╔════╝██╔══██╗╚══██╔══╝██╔═══██╗██╔══██╗
-- ██████╔╝███████║██████╔╝█████╔╝ ██║██╔██╗ ██║██║  ███╗    ██║     ██████╔╝█████╗  ███████║   ██║   ██║   ██║██████╔╝
-- ██╔═══╝ ██╔══██║██╔══██╗██╔═██╗ ██║██║╚██╗██║██║   ██║    ██║     ██╔══██╗██╔══╝  ██╔══██║   ██║   ██║   ██║██╔══██╗
-- ██║     ██║  ██║██║  ██║██║  ██╗██║██║ ╚████║╚██████╔╝    ╚██████╗██║  ██║███████╗██║  ██║   ██║   ╚██████╔╝██║  ██║
-- ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝      ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝
Config.ParkingCreator = {}

---@field Enabled boolean: Do you want to enable Parking Creator
Config.ParkingCreator.Enabled = true

---@field AutomaticLoad boolean: Do you want it to automatically load on client-side for each player when you save the garage you created?
Config.ParkingCreator.AutomaticLoad = true

---@class Command # Command settings
Config.ParkingCreator.Command = {
    oldESX = false,
    name = "createparking",
    groups = "admin",
    help = "Create Parking",
}

---@class Controls # List of interaction keys in the menu
---# https://docs.fivem.net/docs/game-references/controls/
Config.ParkingCreator.Controls = {
    ['SELECT'] = {controlIndex = 24, controlName = '~INPUT_AIM~'},                     -- Default: Mouse Left
    ['BACK'] = {controlIndex = 70, controlName = '~INPUT_ATTACK~'},                     -- Default: Mouse Right
    ['SCROLL_DOWN'] = {controlIndex = 180, controlName = '~INPUT_WEAPON_WHEEL_PREV~'},  -- Default: Scroll Down
    ['SCROLL_UP'] = {controlIndex = 181, controlName = '~INPUT_WEAPON_WHEEL_NEXT~'},    -- Default: Scroll UP
    ['ARROW_LEFT'] = {controlIndex = 174, controlName = '~INPUT_CELLPHONE_LEFT~'},      -- Default: Arrow Left
    ['ARROW_RIGHT'] = {controlIndex = 175, controlName = '~INPUT_CELLPHONE_RIGHT~'},    -- Default: Arrow Right
    ['LEFT_CTRL'] = {controlIndex = 210, controlName = '~INPUT_FRONTEND_RS~'},          -- Default: Left CTRL
    ['ENTER'] = {controlIndex = 191, controlName = '~INPUT_FRONTEND_RDOWN~'},           -- Default: Enter
    ['CANCEL'] = {controlIndex = 202, controlName = '~INPUT_FRONTEND_CANCEL~'},         -- Default: BACKSPACE / ESC
}

---@class VehicleTypes # List of vehicle types available for selection
Config.ParkingCreator.VehicleTypes = {
    'vehicle',
    'boat',
    'plane',
    'helicopter',
}

---@class WaterVehicleTypes # Types of vehicles that are on the water
Config.ParkingCreator.WaterVehicleTypes = {
    ['boat'] = true,
}

---@class VehicleTypesModels # Default vehicle model to configure by vehicle type
Config.ParkingCreator.VehicleTypesModels = {
    ['vehicle'] = 'adder',
    ['boat'] = 'longfin',
    ['plane'] = 'luxor',
    ['helicopter'] = 'swift',
}

---@class HouseGarageInteriors # List of prepared interiors to choose from in the menu for house garage
Config.ParkingCreator.HouseGarageInteriors = {
    [1] = {
        camCoords = vector3(170.29, -1006.51, -97.74),
        exitCoords = vector4(178.74, -1006.61, -99.0, 89.23),
        parkingSpaces = {
            [1] = {coords = vector4(175.26, -1004.05, -100.02, 179.98)},
            [2] = {coords = vector4(171.35, -1004.15, -100.02, 178.67)},
        }
    },
    [2] = {
        camCoords = vector3(198.44, -995.25, -97.95),
        exitCoords = vector4(207.15, -999.03, -99.0, 90.74),
        parkingSpaces = {
            [1] = {coords = vector4(203.2, -998.07, -100.02, 147.81)},
            [2] = {coords = vector4(198.73, -997.18, -100.02, 148.61)},
            [3] = {coords = vector4(194.48, -996.95, -100.02, 148.52)},
            [4] = {coords = vector4(202.72, -1003.23, -100.02, 147.44)},
            [5] = {coords = vector4(197.76, -1003.06, -100.02, 149.85)},
            [6] = {coords = vector4(193.22, -1003.15, -100.02, 149.96)},
        }
    },
    [3] = {
        camCoords = vector3(223.58, -1004.31, -97.87),
        exitCoords = vector4(228.05, -1005.52, -99.0, 0.46),
        parkingSpaces = {
            [1] = {coords = vector4(233.44, -998.65, -100.02, 121.72)},
            [2] = {coords = vector4(233.38, -994.87, -100.02, 124.62)},
            [3] = {coords = vector4(233.24, -991.16, -100.02, 127.59)},
            [4] = {coords = vector4(233.18, -987.34, -100.02, 130.14)},
            [5] = {coords = vector4(233.28, -983.14, -100.02, 129.06)},
            [6] = {coords = vector4(223.89, -998.69, -100.02, 238.26)},
            [7] = {coords = vector4(223.85, -994.79, -100.02, 237.37)},
            [8] = {coords = vector4(223.7, -990.64, -100.02, 238.73)},
            [9] = {coords = vector4(223.54, -986.43, -100.02, 239.08)},
            [10] = {coords = vector4(223.68, -982.79, -100.02, 235.46)},
        }
    },
    [4] = {
        requiredGameBuild = 2802, -- To use this interior, you must have a gamebuild minimum of 2802 (https://docs.fivem.net/docs/server-manual/server-commands/#sv_enforcegamebuild-build)
        camCoords = vector3(513.81, -2638.03, -47.09),
        exitCoords = vector4(519.9, -2636.3, -50.42, 359.73),
        parkingSpaces = {
            [1] = {coords = vec4(524.21270751954, -2615.6223144532, -49.4136428833, 135.0), rotation = vector3(-0.10547954589128, -2.9348520911298e-06, 135.0)},
            [2] = {coords = vec4(524.28369140625, -2619.9240722656, -49.4136428833, 135.0), rotation = vector3(-0.105482801795, -2.5846704829746e-06, 135.0)},
            [3] = {coords = vec4(524.26263427734, -2624.421875, -49.4136428833, 135.0), rotation = vector3(-0.10548608005046, -6.7701688521992e-07, 135.0)},
            [4] = {coords = vec4(524.28326416016, -2628.8833007812, -49.4136428833, 135.0), rotation = vector3(-0.10548608005046, -6.7701688521992e-07, 135.0)},
            [5] = {coords = vec4(524.27923583984, -2633.5700683594, -49.4136428833, 135.0), rotation = vector3(-0.10547954589128, -5.8563637139742e-06, 135.0)},
            [6] = {coords = vec4(515.50305175782, -2615.5830078125, -49.4136428833, 225.0), rotation = vector3(-0.10548935085536, -2.5846704829746e-06, 225.0)},
            [7] = {coords = vec4(515.45294189454, -2619.75, -49.4136428833, 225.0), rotation = vector3(-0.10548608005046, 6.7701688521992e-07, 225.0)},
            [8] = {coords = vec4(515.52630615234, -2624.5278320312, -49.4136428833, 225.0), rotation = vector3(-0.10548608005046, 6.7701688521992e-07, 225.0)},
            [9] = {coords = vec4(515.50396728516, -2629.0385742188, -49.4136428833, 225.0), rotation = vector3(-0.10548608005046, 6.7701688521992e-07, 225.0)},
            [10] = {coords = vec4(515.48742675782, -2633.8227539062, -49.4136428833, 225.0), rotation = vector3(-0.10548935085536, -2.5846704829746e-06, 225.0)},
        }
    },
}

---@class GarageInteriors # List of prepared interiors to choose from in the menu for underground garages
Config.ParkingCreator.GarageInteriors = {
    [1] = {
        camCoords = vector3(1375.02, 207.91, -47.14),
        exitOnFoot = vec4(1380.2, 178.5, -48.99, 358.12),
        exitWithVehicle = vec4(1339.74, 190.82, -48.31, 269.62),
        parkingSpaces = {
            [1] = {coords = vector4(1366.35, 200.26, -50.41, 89.89)},
            [2] = {coords = vector4(1366.19, 204.52, -50.41, 90.23)},
            [3] = {coords = vector4(1366.29, 208.72, -50.41, 89.73)},
            [4] = {coords = vector4(1366.17, 212.78, -50.41, 90.47)},
            [5] = {coords = vector4(1366.24, 217.12, -50.41, 90.5)},
            [6] = {coords = vector4(1366.29, 221.18, -50.41, 90.51)},
            [7] = {coords = vector4(1366.4, 225.26, -50.41, 90.71)},
            [8] = {coords = vector4(1366.32, 229.57, -50.41, 89.25)},
            [9] = {coords = vector4(1366.11, 233.65, -50.41, 90.8)},
            [10] = {coords = vector4(1366.32, 237.86, -50.41, 90.33)},
            [11] = {coords = vector4(1366.51, 242.11, -50.41, 90.15)},
            [12] = {coords = vector4(1366.17, 246.21, -50.41, 90.67)},
            [13] = {coords = vector4(1365.58, 250.31, -50.41, 90.67)},
            [14] = {coords = vector4(1366.25, 254.62, -50.41, 90.19)},
            [15] = {coords = vector4(1379.88, 246.12, -50.41, 270.47)},
            [16] = {coords = vector4(1379.76, 241.98, -50.41, 269.62)},
            [17] = {coords = vector4(1379.66, 237.93, -50.41, 268.93)},
            [18] = {coords = vector4(1379.87, 233.71, -50.41, 270.0)},
            [19] = {coords = vector4(1379.64, 229.47, -50.41, 268.58)},
            [20] = {coords = vector4(1379.7, 225.43, -50.41, 269.4)},
            [21] = {coords = vector4(1379.58, 221.2, -50.41, 270.27)},
            [22] = {coords = vector4(1379.52, 217.14, -50.41, 269.09)},
            [23] = {coords = vector4(1379.63, 212.79, -50.41, 269.1)},
            [24] = {coords = vector4(1379.67, 208.79, -50.41, 269.95)},
            [25] = {coords = vector4(1394.02, 200.28, -50.41, 270.33)},
            [26] = {coords = vector4(1394.28, 204.47, -50.41, 271.19)},
            [27] = {coords = vector4(1394.05, 208.6, -50.41, 270.11)},
            [28] = {coords = vector4(1394.06, 212.82, -50.41, 269.88)},
            [29] = {coords = vector4(1394.05, 216.96, -50.41, 270.4)},
            [30] = {coords = vector4(1394.04, 221.2, -50.41, 268.96)},
            [31] = {coords = vector4(1394.18, 225.29, -50.41, 269.61)},
            [32] = {coords = vector4(1394.07, 229.6, -50.41, 270.3)},
            [33] = {coords = vector4(1394.23, 233.68, -50.41, 270.01)},
            [34] = {coords = vector4(1394.02, 237.91, -50.41, 270.62)},
            [35] = {coords = vector4(1393.98, 242.01, -50.41, 270.75)},
            [36] = {coords = vector4(1394.14, 246.31, -50.41, 270.22)},
            [37] = {coords = vector4(1394.41, 250.46, -50.41, 270.67)},
            [38] = {coords = vector4(1394.09, 254.66, -50.41, 271.25)},
        },
    },
}