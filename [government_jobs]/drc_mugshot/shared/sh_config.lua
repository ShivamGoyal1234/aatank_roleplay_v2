Config = {}

-- ALL WEBHOOK SETTINGS ARE IN FOLDER SERVER / SV_UTILS.lua

Config.Debug = false
--SERVER SETTINGS
Config.Framework = "qbcore" -- Set your framework! "auto-detect, qbcore, ESX, standalone
Config.NewESX = false
Config.Target = "qb-target" -- Which Target system do u use? qb-target, qtarget, ox_target
Config.MarkerOption = "textui" --3dtext or textui | Works only if type of mugshot is Marker
Config.Input = "ox_lib" -- Input | types: ox_lib, qb-input
Config.TextUI = "qb-core" -- TextUI | types: ox_lib, qb-core
Config.NotificationType = "qbcore" -- Notifications | types: ESX, ox_lib, qbcore
Config.Progress = "qbcore" -- ProgressBars | types: progressBars, ox_lib, qbcore
Config.AutomaticNames = true -- no need for name and dob filling
Config.ScreenshotbasicResource = 'screenshot-basic' --name of your screenshot basic resource

--FIVEMANAGE
Config.Fivemanage = false --if you want to use fivemanage

--MDT upload
Config.PS_MDT = false --only for qbcore users

Config.HYPASTE_MDT = false

Config.REDUTZU_MDT = false

--Mugshots
Config.MugshotEvidence = {
--[[     ["GabzMRPD"] = {
        JobResitrected = true,   
        type = "Target", -- Target (CircleZone), Marker (Marker Can be changed in Marker Setting)
        coords = vec3(-596.83, -425.19, 36.04),
        radius = 1.4, -- for target
        debug = false,
        Label = "Mugshot Evidence", --Label for Marker and Target
        TargetIcon = "fas fa-camera", -- Icon for Target
        JobResitrected = true,
        Jobs = { --jobs and grades that can look into mugshot evidence
            { name = "police", grade = 0 },
            { name = "sheriff", grade = 0 }, 
        },
        EditJobs = { --jobs and grades that can edit mugshot evidence
            { name = "police", grade = 3 },
            { name = "sheriff", grade = 3 }, 
        },
        Marker = { -- Only needed when you use type Marker | Marker Settings
            DrawDistance = 3.0, -- How far should be Marker draw
            Type = 21, -- Type of Marker
            Size = { x = 0.7, y = 0.7, z = 0.7 }, -- Sizes of Marker
            Color = { r = 8, g = 137, b = 255, a = 150 } -- Color of Marker
        },
    }, ]]
    ["DefaultMissionRow"] = {
        JobResitrected = true,   
        type = "Target", -- Target (CircleZone), Marker (Marker Can be changed in Marker Setting)
        coords = vec3(-596.81, -425.14, 36.04),
        radius = 1.4, -- for target
        debug = false,
        Label = "Mugshot Evidence", --Label for Marker and Target
        TargetIcon = "fas fa-camera", -- Icon for Target
        JobResitrected = true,
        Jobs = { --jobs and grades that can look into mugshot evidence
            { name = "police", grade = 0 },
        },
        EditJobs = { --jobs and grades that can edit mugshot evidence
            { name = "police", grade = 9 },
        },
        Marker = { -- Only needed when you use type Marker | Marker Settings
            DrawDistance = 3.0, -- How far should be Marker draw
            Type = 21, -- Type of Marker
            Size = { x = 0.7, y = 0.7, z = 0.7 }, -- Sizes of Marker
            Color = { r = 8, g = 137, b = 255, a = 150 } -- Color of Marker
        },
    },
}

Config.Mugshot = {
--[[     ["GabzMissionRow"] = { -- MUGSHOT NAME | NEEDS TO BE SAME LIKE IN ERVER / SV_UTILS.lua     GABZ MISSION ROW | TARGET EXAMPLE
        JobResitrected = true,    
        Jobs = { --jobs and grades that can look into mugshot evidence
            { name = "police", grade = 0 },
            { name = "sheriff", grade = 0 }, 
        }, -- Job and Grade to be able to Register Mugshot info
        type = "Target", -- Target (CircleZone), Marker (Marker Can be changed in Marker Setting)
        OfficerPosition = {
            coords = vec3(-571.13616943359, -448.24911499023, 31.780750274658), -- Place where you register new suspect
            radius = 0.4, -- Radius for CircleZone
            debug = false -- DebugPoly To see CircleZone
        },
        TargetPosition = {
            coords = vec3(-567.87, -448.19, 31.16), -- Where should suspect stand
            heading = 175.55, -- Suspect heading
            radius = 3.0 -- Radius how far from this point can suspect be
        },
        CameraPosition = {
            coords = vec3(-570.04, -448.24, 31.16), -- Postion of camera
            heading = 0.5, -- Heading to suspect
            fov = 45.0 -- Field of View to camera you can edit zoom with this
        },
        Label = "Take MugShot", --Label for Marker and Target
        TargetIcon = "fas fa-camera", -- Icon for Target
        State = "AATANK", -- Board text
        Shortcut = "LSPD", -- Board text
        Marker = { -- Only needed when you use type Marker | Marker Settings
            DrawDistance = 3.0, -- How far should be Marker draw
            Type = 21, -- Type of Marker
            Size = { x = 0.7, y = 0.7, z = 0.7 }, -- Sizes of Marker
            Color = { r = 8, g = 137, b = 255, a = 150 } -- Color of Marker
        },
    }, ]]

    --[[["GabzMissionMarker"] = { -- MUGSHOT NAME | NEEDS TO BE SAME LIKE IN ERVER / SV_UTILS.lua     GABZ MISSION ROW | MARKER EXAMPLE
        JobResitrected = true,    
        Jobs = { --jobs and grades that can look into mugshot evidence
            { name = "police", grade = 0 },
            { name = "sheriff", grade = 0 }, 
            { name = "police", grade = 0 }, 
        }, -- Job and Grade to be able to Register Mugshot info
        type = "Marker", -- Target (CircleZone), Marker (Marker Can be changed in Marker Setting)
        OfficerPosition = {
            coords = vec3(474.87, -1015.013, 26.17), -- Place where you register new suspect
            radius = 0.4, -- Radius for CircleZone
            debug = false -- DebugPoly To see CircleZone
        },
        TargetPosition = {
            coords = vec3(472.95, -1011.27, 25.27), -- Where should suspect stand
            heading = 175.55, -- Suspect heading
            radius = 3.0 -- Radius how far from this point can suspect be
        },
        CameraPosition = {
            coords = vec3(473.00, -1012.47, 26.79), -- Postion of camera
            heading = 0.5, -- Heading to suspect
            fov = 45.0 -- Field of View to camera you can edit zoom with this
        },
        Label = "Take MugShot", --Label for Marker and Target
        TargetIcon = "fas fa-camera", -- Icon for Target
        State = "San Andreas", -- Board text
        Shortcut = "LSPD", -- Board text
        Marker = { -- Only needed when you use type Marker | Marker Settings
            DrawDistance = 3.0, -- How far should be Marker draw
            Type = 21, -- Type of Marker
            Size = { x = 0.7, y = 0.7, z = 0.7 }, -- Sizes of Marker
            Color = { r = 8, g = 137, b = 255, a = 150 } -- Color of Marker
        },
    },]]

    --[[["GabzSheriffTarget"] = { -- MUGSHOT NAME | NEEDS TO BE SAME LIKE IN ERVER / SV_UTILS.lua     GABZ SHERIFF | TARGET EXAMPLE
        JobResitrected = true,    
        Jobs = { --jobs and grades that can look into mugshot evidence
            { name = "police", grade = 0 },
            { name = "sheriff", grade = 0 }, 
            { name = "police", grade = 0 }, 
        }, -- Job and Grade to be able to Register Mugshot info
        type = "Target", -- Target (CircleZone), Marker (Marker Can be changed in Marker Setting)
        OfficerPosition = {
            coords = vec3(1818.66, 3665.42, 34.077), -- Place where you register new suspect
            radius = 0.4, -- Radius for CircleZone
            debug = false -- DebugPoly To see CircleZone
        },
        TargetPosition = {
            coords = vec3(1813.41, 3663.96, 33.18), -- Where should suspect stand
            heading = 299.25, -- Suspect heading
            radius = 5.0 -- Radius how far from this point can suspect be
        },
        CameraPosition = {
            coords = vec3(1815.67, 3665.4, 34.58), -- Postion of camera
            heading = 119.5, -- Heading to suspect
            fov = 5.0 -- Field of View to camera you can edit zoom with this
        },
        Label = "Take MugShot", --Label for Marker and Target
        TargetIcon = "fas fa-camera", -- Icon for Target
        State = "San Andreas", -- Board text
        Shortcut = "LSSD", -- Board text
        Marker = { -- Only needed when you use type Marker | Marker Settings
            DrawDistance = 3.0, -- How far should be Marker draw
            Type = 21, -- Type of Marker
            Size = { x = 0.7, y = 0.7, z = 0.7 }, -- Sizes of Marker
            Color = { r = 8, g = 137, b = 255, a = 150 } -- Color of Marker
        },
    },]]

 --[[    ["GabzSheriffMarker"] = { -- MUGSHOT NAME | NEEDS TO BE SAME LIKE IN ERVER / SV_UTILS.lua     GABZ SHERIFF | MARKER EXAMPLE
        JobResitrected = true,    
        Jobs = { --jobs and grades that can look into mugshot evidence
            { name = "police", grade = 0 },
            { name = "sheriff", grade = 0 }, 
            { name = "police", grade = 0 }, 
        }, -- Job and Grade to be able to Register Mugshot info
        type = "Marker", -- Target (CircleZone), Marker (Marker Can be changed in Marker Setting)
        OfficerPosition = {
            coords = vec3(1817.54, 3665.96, 34.0), -- Place where you register new suspect
            radius = 0.4, -- Radius for CircleZone
            debug = false -- DebugPoly To see CircleZone
        },
        TargetPosition = {
            coords = vec3(1813.41, 3663.96, 33.18), -- Where should suspect stand
            heading = 299.25, -- Suspect heading
            radius = 5.0 -- Radius how far from this point can suspect be
        },
        CameraPosition = {
            coords = vec3(1815.67, 3665.4, 34.58), -- Postion of camera
            heading = 119.5, -- Heading to suspect
            fov = 30.0 -- Field of View to camera you can edit zoom with this
        },
        Label = "Take MugShot", --Label for Marker and Target
        TargetIcon = "fas fa-camera", -- Icon for Target
        State = "San Andreas", -- Board text
        Shortcut = "LSSD", -- Board text
        Marker = { -- Only needed when you use type Marker | Marker Settings
            DrawDistance = 3.0, -- How far should be Marker draw
            Type = 21, -- Type of Marker
            Size = { x = 0.7, y = 0.7, z = 0.7 }, -- Sizes of Marker
            Color = { r = 8, g = 137, b = 255, a = 150 } -- Color of Marker
        },
    }, ]]
   ["DefaultMissionRow"] = { -- MUGSHOT NAME | NEEDS TO BE SAME LIKE IN ERVER / SV_UTILS.lua (example: police)    DEFAULT MISSION ROW
        JobResitrected = true,
        Jobs = { --jobs and grades that can look into mugshot evidence
            { name = "police", grade = 0 },
        },
        type = "Target", -- Target, Marker
        OfficerPosition = { coords = vec3(-571.13616943359, -448.24911499023, 31.780750274658), radius = 0.4, debug = false },
        TargetPosition = { coords = vec3(-567.87, -448.19, 30.16), heading = 90.55, radius = 3.0 },
        CameraPosition = { coords = vec3(-569.96, -448.68, 31.80), heading = 273.00, fov = 38.0 },
        Label = "Take MugShot",
        TargetIcon = "fas fa-camera",
        State = "AATANK RP",
        Shortcut = "LSPD",
        Marker = { DrawDistance = 3.0, Type = 21, Size = { x = 0.7, y = 0.7, z = 0.7 },
            Color = { r = 8, g = 137, b = 255, a = 150 } },
    },
    ["DefaultMissionRow1"] = { -- MUGSHOT NAME | NEEDS TO BE SAME LIKE IN ERVER / SV_UTILS.lua (example: police)    DEFAULT MISSION ROW
        JobResitrected = true,
        Jobs = { --jobs and grades that can look into mugshot evidence
            { name = "police", grade = 0 },
        },
        type = "Target", -- Target, Marker
        OfficerPosition = { coords = vec3(-583.9423828125, -448.21081542969, 31.780750274658), radius = 0.4, debug = false },
        TargetPosition = { coords = vec3(-580.79278564453, -448.09725952148, 30.16), heading = 90.55, radius = 3.0 },
        CameraPosition = { coords = vec3(-582.89, -448.34, 31.80), heading = 273.00, fov = 38.0 },
        Label = "Take MugShot",
        TargetIcon = "fas fa-camera",
        State = "San Andreas",
        Shortcut = "LSPD",
        Marker = { DrawDistance = 3.0, Type = 21, Size = { x = 0.7, y = 0.7, z = 0.7 },
            Color = { r = 8, g = 137, b = 255, a = 150 } },
    },
}
