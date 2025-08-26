Config = {}

-- ███████╗██████╗  █████╗ ███╗   ███╗███████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
-- ██╔════╝██╔══██╗██╔══██╗████╗ ████║██╔════╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
-- █████╗  ██████╔╝███████║██╔████╔██║█████╗  ██║ █╗ ██║██║   ██║██████╔╝█████╔╝
-- ██╔══╝  ██╔══██╗██╔══██║██║╚██╔╝██║██╔══╝  ██║███╗██║██║   ██║██╔══██╗██╔═██╗
-- ██║     ██║  ██║██║  ██║██║ ╚═╝ ██║███████╗╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
-- ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
local frameworkAutoFind = function()
    if GetResourceState('es_extended') ~= 'missing' then
        return "ESX"
    elseif GetResourceState('qb-core') ~= 'missing' then
        return "QB-Core"
    end
end

Config.Core = frameworkAutoFind()
Config.CoreExport = function()
    if Config.Core == "ESX" then
        return exports['es_extended']:getSharedObject()
    elseif Config.Core == "QB-Core" then
        return exports['qb-core']:GetCoreObject()
    end
end

---@field PlayerLoaded string: ESX: "esx:playerLoaded" / QB-Core: "QBCore:Client:OnPlayerLoaded"
Config.PlayerLoaded = Config.Core == "ESX" and "esx:playerLoaded" or "QBCore:Client:OnPlayerLoaded"

---@field PlayerLogoutServer string: ESX: "esx:playerDropped" / QB-Core: "QBCore:Server:OnPlayerUnload"
Config.PlayerLogoutServer = Config.Core == "ESX" and "esx:playerDropped" or "QBCore:Server:OnPlayerUnload"

---@field PlayerSetJob string: ESX: "esx:setJob" / QB-Core: "QBCore:Client:OnJobUpdate"
Config.PlayerSetJob = Config.Core == "ESX" and "esx:setJob" or "QBCore:Client:OnJobUpdate"

---@field PlayerSetGang string: ESX: "esx:setJob2" / QB-Core: "QBCore:Client:OnGangUpdate"
Config.PlayerSetGang = Config.Core == "ESX" and "esx:setJob2" or "QBCore:Client:OnGangUpdate"



-- ███╗   ███╗ █████╗ ██╗███╗   ██╗    ███████╗███████╗████████╗████████╗██╗███╗   ██╗ ██████╗ ███████╗
-- ████╗ ████║██╔══██╗██║████╗  ██║    ██╔════╝██╔════╝╚══██╔══╝╚══██╔══╝██║████╗  ██║██╔════╝ ██╔════╝
-- ██╔████╔██║███████║██║██╔██╗ ██║    ███████╗█████╗     ██║      ██║   ██║██╔██╗ ██║██║  ███╗███████╗
-- ██║╚██╔╝██║██╔══██║██║██║╚██╗██║    ╚════██║██╔══╝     ██║      ██║   ██║██║╚██╗██║██║   ██║╚════██║
-- ██║ ╚═╝ ██║██║  ██║██║██║ ╚████║    ███████║███████╗   ██║      ██║   ██║██║ ╚████║╚██████╔╝███████║
-- ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝    ╚══════╝╚══════╝   ╚═╝      ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝
---@field AutoExecuteQuery boolean: Automatic creation of tables required for vms_garagesv2
Config.AutoExecuteQuery = true

---@field Debug boolean
Config.Debug = false

---@field DebugPolyZone boolean
-- **[Developer Option]** Enables debug mode for PolyZone registration.
-- If set to true, developers will see visual outlines of parking zones, making it easier to create and adjust new parking areas.
-- If set to false, no debug visuals will be displayed.
Config.DebugPolyZone = false -- Enable debug mode for PolyZone (only for development)


---@field DefaultRoutingBucket number
-- Defines the default **routing bucket** for all players.
-- The routing bucket system isolates players into different "instances" (virtual worlds) within the server.
-- By default, all players share the same bucket (`0`), meaning they can see each other normally.
-- If modified, only players in the same bucket can interact with each other.
Config.DefaultRoutingBucket = 0 -- Default routing bucket (0 = shared world)


---@field VehiclePropertiesStateBag string
-- The **state bag** name used to update and synchronize vehicle properties.
-- This option should **not** be modified unless you're an advanced developer and know exactly what you're doing.
-- If you use a different vehicle state system, you might need to change this.
Config.VehiclePropertiesStateBag = "VehicleProperties" -- Recommended default


---@field RegisterStateBag boolean
-- In **ESX**, this is already built into the framework, so **no registration is required** (and should not be enabled to avoid conflicts).
-- In **QB-Core**, this does not exist by default, so it **must** be registered to ensure vehicle properties are correctly stored and synced.
-- **vms_garagesV2 automatically handles this for QB-Core**, so users should **not** modify this unless they fully understand the consequences.
-- **Warning:** Incorrect modifications can break vehicle property synchronization.
Config.RegisterStateBag = Config.Core == "QB-Core" -- Required for QB-Core, unnecessary for ESX

Config.UseMarkers = true                           -- Using a marker to display points
Config.UseText3D = false                           -- Using a 3D Text to display points
Config.UseHelpNotify = true                        -- Using a ESX.ShowHelpNotification (only for esx)

---@class Marker Below you can configure the markers for each point
Config.Marker = {
    ['management_business'] = {
        distanceSee = 10.0,
        distanceAccess = 1.8,
        type = 36,
        color = { 50, 168, 82, 175 },
        rotation = vec(0.0, 0.0, 0.0),
        scale = vec(0.5, 0.5, 0.5),
        bobUpAndDown = true,
        rotate = true,
        textureDict = nil,
        textureName = nil,
        drawOnEnts = false,
    },
    ['enter_garage_veh'] = {
        distanceSee = 10.0,
        distanceAccess = 1.8,
        type = 36,
        color = { 50, 168, 82, 175 },
        rotation = vec(0.0, 0.0, 0.0),
        scale = vec(0.5, 0.5, 0.5),
        bobUpAndDown = true,
        rotate = true,
        textureDict = nil,
        textureName = nil,
        drawOnEnts = false,
    },
    ['enter_garage'] = {
        distanceSee = 12.0,
        distanceAccess = 1.8,
        type = 20,
        color = { 50, 168, 82, 175 },
        rotation = vec(0.0, 0.0, 0.0),
        scale = vec(0.2, 0.2, 0.2),
        bobUpAndDown = true,
        rotate = true,
        textureDict = nil,
        textureName = nil,
        drawOnEnts = false,
    },
    ['exit_garage_veh'] = {
        distanceSee = 10.0,
        distanceAccess = 1.8,
        type = 36,
        color = { 255, 168, 82, 175 },
        rotation = vec(0.0, 0.0, 0.0),
        scale = vec(0.5, 0.5, 0.5),
        bobUpAndDown = true,
        rotate = true,
        textureDict = nil,
        textureName = nil,
        drawOnEnts = false,
    },
    ['exit_garage'] = {
        distanceSee = 12.0,
        distanceAccess = 1.8,
        type = 20,
        color = { 255, 168, 82, 175 },
        rotation = vec(0.0, 0.0, 0.0),
        scale = vec(0.2, 0.2, 0.2),
        bobUpAndDown = true,
        rotate = true,
        textureDict = nil,
        textureName = nil,
        drawOnEnts = false,
    },
    ['garage_menu'] = {
        distanceSee = 10.0,
        distanceAccess = 1.8,
        type = 20,
        color = { 50, 168, 82, 175 },
        rotation = vec(0.0, 180.0, 0.0),
        scale = vec(0.2, 0.2, 0.2),
        bobUpAndDown = true,
        rotate = true,
        textureDict = nil,
        textureName = nil,
        drawOnEnts = false,
    },
    ['return_vehicle'] = {
        distanceSee = 25.0,
        distanceAccess = 3.5,
        type = 21,
        color = { 50, 168, 82, 175 },
        rotation = vec(0.0, 180.0, 0.0),
        scale = vec(0.8, 0.8, 0.8),
        bobUpAndDown = false,
        rotate = true,
        textureDict = nil,
        textureName = nil,
        drawOnEnts = false,
    },
    ['impound'] = {
        distanceSee = 10.0,
        distanceAccess = 1.8,
        type = 29,
        color = { 50, 168, 82, 175 },
        rotation = vec(0.0, 0.0, 0.0),
        scale = vec(0.2, 0.2, 0.2),
        bobUpAndDown = true,
        rotate = true,
        textureDict = nil,
        textureName = nil,
        drawOnEnts = false,
    },
    ['parking_space'] = {
        distanceSee = 5.0,
        distanceAccess = 1.8,
        type = 21,
        color = { 20, 240, 10, 175 },
        rotation = vec(180.0, 0.0, 0.0),
        scale = vec(0.2, 0.2, 0.2),
        bobUpAndDown = false,
        rotate = true,
        textureDict = nil,
        textureName = nil,
        drawOnEnts = false,
    },
    ['pay_station'] = {
        distanceSee = 10.0,
        distanceAccess = 1.8,
        type = 29,
        color = { 50, 168, 82, 175 },
        rotation = vec(0.0, 0.0, 0.0),
        scale = vec(0.2, 0.2, 0.2),
        bobUpAndDown = false,
        rotate = true,
        textureDict = nil,
        textureName = nil,
        drawOnEnts = false,
    },
}

---@class Blips Below you can configure blips for each garage and impound
Config.Blips = {
    ['impound:vehicle'] = {
        sprite = 317,
        display = 4,
        scale = 0.9,
        color = 41,
        name = "Impound"
    },

    ['free_garage:vehicle'] = {
        sprite = 357,
        display = 4,
        scale = 0.9,
        color = 3,
        name = "Garage"
    },
    ['free_garage:boat'] = {
        sprite = 356,
        display = 4,
        scale = 0.9,
        color = 3,
        name = "Garage"
    },
    ['free_garage:plane'] = {
        sprite = 359,
        display = 4,
        scale = 0.9,
        color = 3,
        name = "Hangar"
    },
    ['free_garage:helicopter'] = {
        sprite = 360,
        display = 4,
        scale = 0.9,
        color = 3,
        name = "Garage"
    },

    ['paid_garage:vehicle'] = {
        sprite = 369,
        display = 4,
        scale = 0.9,
        color = 11,
        name = "Paid Garage"
    },
    ['paid_garage:boat'] = {
        sprite = 371,
        display = 4,
        scale = 0.9,
        color = 11,
        name = "Paid Garage"
    },
    ['paid_garage:plane'] = {
        sprite = 372,
        display = 4,
        scale = 0.9,
        color = 11,
        name = "Paid Garage"
    },
    ['paid_garage:helicopter'] = {
        sprite = 370,
        display = 4,
        scale = 0.9,
        color = 11,
        name = "Paid Garage"
    },

    ['rent_garage:vehicle'] = {
        sprite = 369,
        display = 4,
        scale = 0.9,
        color = 12,
        name = "Rent Garage"
    },
    ['rent_garage:boat'] = {
        sprite = 371,
        display = 4,
        scale = 0.9,
        color = 12,
        name = "Rent Garage"
    },
    ['rent_garage:plane'] = {
        sprite = 372,
        display = 4,
        scale = 0.9,
        color = 12,
        name = "Rent Garage"
    },
    ['rent_garage:helicopter'] = {
        sprite = 370,
        display = 4,
        scale = 0.9,
        color = 12,
        name = "Rent Garage"
    },

    ['job_garage'] = {
        sprite = 357,
        display = 4,
        scale = 0.9,
        color = 38,
        name = "Job Garage"
    },
}



--  ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗ ██╗   ██╗██████╗  █████╗ ████████╗██╗ ██████╗ ███╗   ██╗
-- ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝ ██║   ██║██╔══██╗██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║
-- ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗██║   ██║██████╔╝███████║   ██║   ██║██║   ██║██╔██╗ ██║
-- ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║██║   ██║██╔══██╗██╔══██║   ██║   ██║██║   ██║██║╚██╗██║
-- ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝╚██████╔╝██║  ██║██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║
--  ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
---@field AllowAllToParking boolean
-- Determines whether **any** player can park a vehicle in public parking lots, regardless of ownership.
-- If set to `true`, players can park any vehicle they enter, even if they do not own it.
-- If set to `false`, only the vehicle owner (or authorized job members) can park the vehicle.
Config.AllowAllToParking = false -- Restrict parking to vehicle owners only


---@field AllowAllToPullOut boolean
-- Determines whether **any** player can pull out a vehicle from a parking lot.
Config.AllowAllToPullOut = false -- Only the vehicle owner can take out their parked vehicle


---@field AllowParkingCompanyVehiclesEverywhere boolean
-- Allows company/gang vehicles (e.g., ambulances, police cars) to be parked **anywhere**, not just in designated company parking areas.
-- If set to `true`, job vehicles can be parked in any parking lot.
-- If set to `false`, job vehicles can only be parked in their designated **company/gang garages**.
Config.AllowParkingCompanyVehiclesEverywhere = true -- Enable parking of company vehicles anywhere


---@field PreventExplosionOfParkedVehicles boolean
-- Prevents **explosions** from affecting parked vehicles.
-- If set to `true`, parked vehicles will not be destroyed by explosions.
-- If set to `false`, parked vehicles may be destroyed when affected by explosions.
Config.PreventExplosionOfParkedVehicles = true -- Protect parked vehicles from explosions


---@field AllowRecoveryBurnedVehicles boolean
-- Allows players to **recover burned vehicles** from impound.
-- If set to `true`, even destroyed vehicles can be retrieved.
-- If set to `false`, burned vehicles cannot be recovered.
Config.AllowRecoveryBurnedVehicles = true -- Allow recovering burned vehicles

---@field AllowRecoveryVehiclesFromWater boolean
-- Allows recovery of **submerged** vehicles from impound.
-- ⚠ **Note:** This is in **beta mode** and only works with **oceans** (not lakes or rivers).
Config.AllowRecoveryVehiclesFromWater = true -- Allow recovering sunken vehicles (oceans only)


---@field AllowTransferBetweenGarages boolean
-- Enables the ability to transfer a vehicle **between garages** using an in-game menu.
-- If set to `true`, players can move vehicles from one garage to another for a fee.
Config.AllowTransferBetweenGarages = true -- Enable garage transfers
Config.TransferBetweenGaragesPrice = 5000 -- Cost of transferring a vehicle to another garage


---@field AllowLockpickParkedVehicle boolean
-- Determines whether players can **lockpick** parked vehicles and drive them away.
-- **This does not disable lockpicking entirely**—it only affects whether a **lockpicked** vehicle can be driven away.
-- If `false`, players will be unable to drive a stolen parked vehicle, even if they successfully lockpick it.
-- If you want to **completely disable lockpicking**, you must modify your lockpick script.
Config.AllowLockpickParkedVehicle = false -- Allow stolen parked vehicles to be driven


---@field VehiclesLoadDistance number
-- The **render distance** for parked vehicles (in meters).
-- - **Recommended:** `25m` (Best performance vs. visibility balance)
-- - Lower values improve performance but make vehicles disappear sooner.
-- - Higher values keep vehicles visible from further away but may impact performance.
Config.VehiclesLoadDistance = 10 -- Distance at which parked vehicles become visible


---@field ClearCacheOfVehicleModels boolean
-- Clears the **vehicle model cache** after spawning vehicles.
-- **Recommended for large servers** with add-on vehicles to prevent texture loss over time.
Config.ClearCacheOfVehicleModels = false -- Prevent texture loss from vehicle caching


---@field InstantVehicleLoading boolean
-- Instantly loads **all parked vehicles** when entering a parking PolyZone, instead of loading them progressively.
-- - **Beta Feature:** Performance impact is unknown for servers with a very large number of parked add-on vehicles.
-- - **Use with caution:** May cause spikes in resource usage or minor freezes if too many vehicles are spawned at once.
Config.InstantVehicleLoading = true


---@field WaitForProperties boolean
-- **(QB-Core/QBX-Core Only)** Ensures that vehicle properties (e.g., damage, mods, paint) are correctly applied.
-- If vehicles are missing modifications when spawned, **enable this**.
Config.WaitForProperties = true -- Ensures vehicle properties are properly applied


---@field WaitForPropertiesTime number
-- The **delay (in milliseconds)** before vehicle properties are applied.
-- If properties are **not loading correctly**, increase this value.
-- **Recommended value:** 500 (half a second).
Config.WaitForPropertiesTime = 500 -- Delay before applying vehicle properties


---@field DisplayParkingTimer boolean
-- Displays a **timer** indicating how long a vehicle has been parked.
-- This can be useful for tracking parking durations, especially for roleplay.
Config.DisplayParkingTimer = true -- Enable parking duration display
Config.ParkingTimerScale = 0.95   -- Scaling factor for the parking timer UI


---@field MaxSpeedToPark number
-- The **maximum speed** (in GTA's `GetEntitySpeed` units) at which a player can park a vehicle.
-- This prevents players from parking while driving at high speeds.
-- - 3.0 is approximately **11 km/h (7 mph)**, simulating a slow parking maneuver.
Config.MaxSpeedToPark = 3.0 -- Maximum speed at which players can park


---@class VehicleTypes
-- Defines different vehicle categories and their default impound locations.
Config.VehicleTypes = {
    ['vehicle'] = {
        name = "vehicle",                   -- Internal name (from database column `type`)
        label = "vehicle",                  -- Display label
        defaultImpound = "Impound1",        -- The impound lot where unparked vehicles are moved
        autoAddToImpoundAfterRestart = true -- Automatically move unparked vehicles to impound after a restart
    },
    ['boat'] = {
        name = "boat",
        label = "boat",
        defaultImpound = "ImpoundBoat",
        autoAddToImpoundAfterRestart = true
    },
    ['plane'] = {
        name = "plane",
        label = "plane",
        defaultImpound = "ImpoundPlane",
        autoAddToImpoundAfterRestart = true
    },
    ['helicopter'] = {
        name = "helicopter",
        label = "helicopter",
        defaultImpound = "ImpoundHeli",
        autoAddToImpoundAfterRestart = true
    }
}


---@class CustomVehicleLabels
-- Defines custom display names for specific vehicles using their model hashes.
-- Useful for replacing default in-game vehicle names with real-world branding.
Config.CustomVehicleLabels = {
    [joaat('2ncsbmwm8')] = 'M8',
    [joaat('16charger')] = 'SRT Charger H1000',
    [joaat('17mansorypnmr')] = 'Turbo E-Hybrid',
    [joaat('18performante')] = 'Huracan Athens',
    [joaat('20xb7')] = 'Alpina XB7',
    [joaat('abhawk')] = 'Seminal Hawk XZ',
    [joaat('autobio')] = 'AutoBiography',
    [joaat('ben17')] = 'Continental Supersports ISR',
    [joaat('centuria')] = 'Chiron',
    [joaat('dawnonyx')] = 'Dawn',
    [joaat('gmcev2')] = 'Hummer EV',
    [joaat('kln')] = 'Cullinan',
    [joaat('oycdefender')] = 'Defender',
    [joaat('wraith')] = 'Wraith',
    [joaat('terzo')] = 'Terzo Millennio',
    [joaat('zm_rocket900')] = 'Brabus Rocket 900 Edition',
    [joaat('DL_G900')] = 'AMG G900',
    [joaat('mach1')] = 'Shelby Super Snake',
    [joaat('rmodgtr')] = 'GT-R',
    [joaat('g63')] = 'AMG G63',


    -- PD Cars

    [joaat('van_killer')] = 'Van 1',
    [joaat('comni_killer')] = 'Obey',
    [joaat('vapid_killer')] = 'Vapid',
    [joaat('Rebla_killer')] = 'Rebla',
    [joaat('Astron_killer')] = 'Pfister',
    [joaat('bravado_killer')] = 'Bravado',
    [joaat('lampadati_killer')] = 'Lampadati',
    [joaat('Motor1_killer')] = 'Nagasaki',
    [joaat('Motor2_killer')] = 'Maibatus',
    [joaat('vapidtruck_killer')] = 'Vapid Truck',
    [joaat('Declasse_killer')] = 'Declasse',

    -- ems Cars
    [joaat('Killer_ems1')] = 'Buckingham',
    [joaat('Killer_ems2')] = 'Gallivanter',
    [joaat('Killer_ems3')] = 'Ocelot',
    [joaat('Killer_ems4')] = 'Coil',
    [joaat('Killer_ems5')] = 'Vapid',
    [joaat('Killer_ems6')] = 'Van',


}


---@class AddVehicleKeysOn
-- Specifies when players should receive vehicle keys.
-- Controlled via config.client.lua - CL.GiveVehicleKeys.
Config.AddVehicleKeysOn = {
    -- Receiving keys when pulling out vehicles from an **impound lot**
    companyVehFromImpound = true, -- Company vehicle
    gangVehFromImpound = true,    -- Gang vehicle
    privateVehFromImpound = true, -- Privately owned vehicle

    -- Receiving keys when pulling out vehicles from **public parking lots**
    companyVehFromParking = true,
    gangVehFromParking = true,
    privateVehFromParking = true,

    -- Receiving keys when taking a vehicle from **a garage**
    companyOwnedVehFromGarage = true, -- A company-owned vehicle
    companyVehFromGarage = true,      -- A generic company vehicle
    gangOwnedVehFromGarage = true,    -- A gang-owned vehicle
    gangVehFromGarage = true,         -- A generic gang vehicle
    privateVehFromGarage = true       -- A privately owned vehicle
}


---@class RemoveVehicleKeysOn
-- Specifies when players' vehicle keys should be **removed**.
-- Controlled via config.client.lua - CL.RemoveVehicleKeys
Config.RemoveVehicleKeysOn = {
    -- Removing keys when parking a vehicle in **public parking lots**
    companyVehToParking = true,
    gangVehToParking = true,
    privateVehToParking = true,

    -- Removing keys when parking a vehicle in **a garage**
    companyOwnedVehToGarage = true, -- A company-owned vehicle
    companyVehToGarage = true,      -- A generic company vehicle
    gangOwnedVehToGarage = true,    -- A gang-owned vehicle
    gangVehToGarage = true,         -- A generic gang vehicle
    privateVehToGarage = true       -- A privately owned vehicle
}


---@class CompanyGrades Here you need to enter information about the works that will have the ability to transcribe a private vehicle to a company vehicle and a registered job garage in Config.Garages
Config.CompanyGrades = {
    ['police'] = {
        ['0'] = { -- Recruit
            label = "Cadet",
        },
        ['1'] = { -- Officer
            label = "Solo cadet",
        },
        ['2'] = { -- Sergeant
            label = "Officer",
        },
        ['3'] = { -- lieutenant
            label = "Senior officer",
        },
        ['4'] = {
            label = "Corporal",
        },
        ['5'] = {
            label = "Seargent",
        },
        ['6'] = {
            label = "Lieutenant",
        },
        ['7'] = {
            label = "Captain",
        },
        ['8'] = {
            label = "Asst Chief",
        },
        ['9'] = {
            label = "Chief",
        },
        ['10'] = {
            label = "State Trooper",
        },
        ['11'] = {
            label = "State Captain",
        },
        ['12'] = {
            label = "State commissioner",
        },
    },
    ['ambulance'] = {
        ['0'] = {
            label = "Recruit",
        },
        ['1'] = {
            label = "Doctor",
        },
        ['2'] = {
            label = "Chief Doctor",
        },
        ['3'] = {
            label = "Boss",
            isBoss = true, -- This will enable this rank to order and transfer vehicles for employees
        },
    }
}

---@class GangGrades Here you need to enter information about the works that will have the ability to transcribe a private vehicle to a company vehicle and a registered job garage in Config.Garages
Config.GangGrades = {
    ['ballas'] = {
        ['0'] = { -- Member
            label = "Member",
        },
        ['1'] = {          -- Boss
            label = "Boss",
            isBoss = true, -- This will enable this rank to order and transfer vehicles for employees
        },
    },
}


---@class RandomGarageAnims
-- Defines **random animations** that play when a player enters a **garage or impound lot**.
-- This helps make interactions **more immersive** instead of having players stand still.
Config.RandomGarageAnims = {
    { "rcmnigel1a",                                       "base" },
    { "rcmjosh1",                                         "idle" },
    { "anim@heists@humane_labs@finale@strip_club",        "ped_b_celebrate_loop" },
    { "random@street_race",                               "_car_b_lookout" },
    { "anim@amb@casino@hangout@ped_male@stand@02b@idles", "idle_a" }
}


---@class GiveVehicleCommand
Config.GiveVehicleCommand = {
    enabled = true,
    oldESX = false,
    name = "givecar",
    groups = 'admin',
    help = "Add a vehicle to the garage",
    suggestions = {
        { label = "Player ID or Job Name for company" },
        { label = "Vehicle Type (vehicle/boat/helicopter/plane)" },
        { label = "Vehicle Model" },
        { label = "License Plate Number (_ = space) (* Max 8 characters, special characters cannot be used!)" },
    }
}



-- ██╗███╗   ███╗██████╗  ██████╗ ██╗   ██╗███╗   ██╗██████╗
-- ██║████╗ ████║██╔══██╗██╔═══██╗██║   ██║████╗  ██║██╔══██╗
-- ██║██╔████╔██║██████╔╝██║   ██║██║   ██║██╔██╗ ██║██║  ██║
-- ██║██║╚██╔╝██║██╔═══╝ ██║   ██║██║   ██║██║╚██╗██║██║  ██║
-- ██║██║ ╚═╝ ██║██║     ╚██████╔╝╚██████╔╝██║ ╚████║██████╔╝
-- ╚═╝╚═╝     ╚═╝╚═╝      ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═════╝
---@field TowMenuCommand string
-- The command that allows players to open the **tow menu**.
-- Example: If set to `'tow'`, players can type `/tow` in chat to access the menu.
Config.TowMenuCommand = 'impound' -- Default command to open the tow menu


---@field MaxTowFineAmount number
-- The **maximum** fine amount that can be set when impounding a vehicle.
-- Ensures that players cannot impose excessive fines.
Config.MaxTowFineAmount = 10000 -- Maximum fine allowed when towing a vehicle


---@field MinTowFineAmount number
-- The **minimum** fine amount that can be set when impounding a vehicle.
-- Prevents fines from being set to negative values or zero if a minimum fine is required.
Config.MinTowFineAmount = 5000 -- Minimum fine allowed (set to `0` to allow free impounds)


---@field MaxTowFineCharacters number
-- The **maximum** number of characters allowed in the fine **description/title**.
-- Prevents excessively long fine descriptions.
Config.MaxTowFineCharacters = 250 -- Maximum length of fine description


---@field MinTowFineCharacters number
-- The **minimum** number of characters allowed in the fine **description/title**.
-- Ensures players provide a proper reason for the fine.
Config.MinTowFineCharacters = 5 -- Minimum length of fine description


---@class AllowJobImpoundsTakeVehWithoutPaying
-- Defines which **jobs** can use the tow menu and access impound lots.
-- Each job has access to specific impound locations.
Config.TowMenuJobsAccess = {
    ['mechanic'] = {
        label = "Mechanic",
        impoundsAvailable = {
            ['vehicle'] = 'Impound1', -- Default vehicle impound lot
            --[[             ['boat'] = 'ImpoundBoat', -- Boat impound lot
            ['plane'] = 'ImpoundPlane', -- Plane impound lot
            ['helicopter'] = 'ImpoundHeli' -- Helicopter impound lot ]]
        },
    },
    ['police'] = {
        label = "Police",
        impoundsAvailable = {
            ['vehicle'] = {
                'ImpoundPolice',
				'Impound1',
            },
            --[[             ['boat'] = 'ImpoundBoat',
            ['plane'] = 'ImpoundPlane',
            ['helicopter'] = 'ImpoundHeli', ]]
        },
    },
}

---@field AllowJobImpoundsTakeVehWithoutPaying boolean: This will enable the vehicle to be removed from the impound without the customer having to pay.
Config.AllowJobImpoundsTakeVehWithoutPaying = true

---@class AutomaticImpound
Config.AutomaticImpound = {
    ['vehicle'] = {
        impounded_by = "City Services",
        fine_title = "Leaving a vehicle in a place not intended for it.",
        fine_amount = 5000,
    },
    ['boat'] = {
        impounded_by = "City Services",
        fine_title = "Leaving a vehicle in a place not intended for it.",
        fine_amount = 5000,
    },
    ['plane'] = {
        impounded_by = "City Services",
        fine_title = "Leaving a vehicle in a place not intended for it.",
        fine_amount = 5000,
    },
    ['helicopter'] = {
        impounded_by = "City Services",
        fine_title = "Leaving a vehicle in a place not intended for it..",
        fine_amount = 5000,
    },
}



-- ██████╗  █████╗ ██╗██████╗     ██████╗  █████╗ ██████╗ ██╗  ██╗██╗███╗   ██╗ ██████╗ ███████╗
-- ██╔══██╗██╔══██╗██║██╔══██╗    ██╔══██╗██╔══██╗██╔══██╗██║ ██╔╝██║████╗  ██║██╔════╝ ██╔════╝
-- ██████╔╝███████║██║██║  ██║    ██████╔╝███████║██████╔╝█████╔╝ ██║██╔██╗ ██║██║  ███╗███████╗
-- ██╔═══╝ ██╔══██║██║██║  ██║    ██╔═══╝ ██╔══██║██╔══██╗██╔═██╗ ██║██║╚██╗██║██║   ██║╚════██║
-- ██║     ██║  ██║██║██████╔╝    ██║     ██║  ██║██║  ██║██║  ██╗██║██║ ╚████║╚██████╔╝███████║
-- ╚═╝     ╚═╝  ╚═╝╚═╝╚═════╝     ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝
---@field NeedPayForParking boolean: Does the player have to pay at the parking meter for parking (In future updates there will be additional options for this)
Config.NeedPayForParking = true



-- ██╗  ██╗ ██████╗ ██╗   ██╗███████╗███████╗     ██████╗  █████╗ ██████╗  █████╗  ██████╗ ███████╗███████╗
-- ██║  ██║██╔═══██╗██║   ██║██╔════╝██╔════╝    ██╔════╝ ██╔══██╗██╔══██╗██╔══██╗██╔════╝ ██╔════╝██╔════╝
-- ███████║██║   ██║██║   ██║███████╗█████╗      ██║  ███╗███████║██████╔╝███████║██║  ███╗█████╗  ███████╗
-- ██╔══██║██║   ██║██║   ██║╚════██║██╔══╝      ██║   ██║██╔══██║██╔══██╗██╔══██║██║   ██║██╔══╝  ╚════██║
-- ██║  ██║╚██████╔╝╚██████╔╝███████║███████╗    ╚██████╔╝██║  ██║██║  ██║██║  ██║╚██████╔╝███████╗███████║
-- ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝     ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝
local housingAutoFind = function()
    local housingList = {
        'vms_housing',
        'nolag_properties',
        'qs-housing',
        -- 'add_your_custom',
    }

    for _, housing in ipairs(housingList) do
        if GetResourceState(housing) == 'started' then
            return housing
        end
    end

    return nil
end

---@field Housing string:
--[[
    - vms_housing
    - nolag_properties
    - qs-housing

    * If your housing is not in the above list, it can be customized in ./server/[housing]/
]]
Config.Housing = housingAutoFind()

---@field DebugHouseGaragesZones boolean: You can debug areas to which garages belong to houses
Config.DebugHouseGaragesZones = false

---@field VehiclesHouseGaragesAlwaysOpen boolean: Whether all vehicles in the garage belonging to the house should always be open (If true, then when a player steals a vehicle from another player, he will be able to use it)
Config.VehiclesHouseGaragesAlwaysOpen = true

---@field RegisterHouseGaragesAutomatically boolean
--[[
    Automatically registers **housing garages** when a new house is created using a supported housing system.
    - It listens to the events of creating a house and immediately creates a usable garage for the new property.
    - **No need for manual registration** via the VMS Garages menu.
    - Add support for other housing systems manually by adding a listener in vms_garagesv2/server/[housing]/.
    - **Recommended:** Enable (`true`) if you're using or planning to integrate a supported housing system.
    - Disable (`false`) if you prefer manual control or have no automatic housing integration.
]]
Config.RegisterHouseGaragesAutomatically = true -- Auto-register garages on house creation



-- ███████╗ █████╗ ██╗     ███████╗     █████╗  ██████╗ ██████╗ ███████╗███████╗███╗   ███╗███████╗███╗   ██╗████████╗
-- ██╔════╝██╔══██╗██║     ██╔════╝    ██╔══██╗██╔════╝ ██╔══██╗██╔════╝██╔════╝████╗ ████║██╔════╝████╗  ██║╚══██╔══╝
-- ███████╗███████║██║     █████╗      ███████║██║  ███╗██████╔╝█████╗  █████╗  ██╔████╔██║█████╗  ██╔██╗ ██║   ██║
-- ╚════██║██╔══██║██║     ██╔══╝      ██╔══██║██║   ██║██╔══██╗██╔══╝  ██╔══╝  ██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║
-- ███████║██║  ██║███████╗███████╗    ██║  ██║╚██████╔╝██║  ██║███████╗███████╗██║ ╚═╝ ██║███████╗██║ ╚████║   ██║
-- ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝    ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝
---@field UseSaleAgreement boolean: Do you want to use the script built-in option to sell your vehicle
Config.UseSaleAgreement = true

Config.AgreementPaymentMethods = { 'cash', 'bank' }

---@field UseSaleAgreementItem boolean: The ability to open a vehicle sales agreement with item.
Config.UseSaleAgreementItem = false
Config.SaleAgreementItem = 'sale_agreement_vehicle'
Config.RemoveSaleAgreementItem = true -- after the sale is completed, the item will be removed from the seller

---@field UseSaleAgreementCommand boolean: The ability to open a vehicle sales agreement with command.
Config.UseSaleAgreementCommand = true
Config.SaleAgreementCommand = 'sellvehicle'

---@class SaleBlacklistVehicles You can prevent players from selling individual vehicles
Config.SaleBlacklistVehicles = {
    [GetHashKey('rhino')] = true,
    [GetHashKey('police')] = true,
    [GetHashKey('police2')] = true,
    [GetHashKey('police3')] = true,
}



-- ██╗      ██████╗  ██████╗ █████╗ ████████╗ ██████╗ ██████╗
-- ██║     ██╔═══██╗██╔════╝██╔══██╗╚══██╔══╝██╔═══██╗██╔══██╗
-- ██║     ██║   ██║██║     ███████║   ██║   ██║   ██║██████╔╝
-- ██║     ██║   ██║██║     ██╔══██║   ██║   ██║   ██║██╔══██╗
-- ███████╗╚██████╔╝╚██████╗██║  ██║   ██║   ╚██████╔╝██║  ██║
-- ╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝
---@field AllowImpoundLocator boolean: This will allow players to locate a vehicle when it is currently spawned on the server.
Config.AllowImpoundLocator = true
Config.PriceOfLocationCheck = 250

---@field UseVMSTuningLocator boolean: If you are using vms_tuning min. v2.0.4, you can use the required locator installation.
Config.UseVMSTuningLocator = false

Config.LocatorBlip = {
    usePreciseLocation = true,

    radiusNotPrecise = 200.0,

    showTime = 20000,

    sprite = 465,
    display = 4,
    scale = 0.9,
    color = 15,

    name = "Located Vehicle"
}


-- ██╗   ██╗███╗   ███╗███████╗     ██████╗██╗████████╗██╗   ██╗██╗  ██╗ █████╗ ██╗     ██╗
-- ██║   ██║████╗ ████║██╔════╝    ██╔════╝██║╚══██╔══╝╚██╗ ██╔╝██║  ██║██╔══██╗██║     ██║
-- ██║   ██║██╔████╔██║███████╗    ██║     ██║   ██║    ╚████╔╝ ███████║███████║██║     ██║
-- ╚██╗ ██╔╝██║╚██╔╝██║╚════██║    ██║     ██║   ██║     ╚██╔╝  ██╔══██║██╔══██║██║     ██║
--  ╚████╔╝ ██║ ╚═╝ ██║███████║    ╚██████╗██║   ██║      ██║   ██║  ██║██║  ██║███████╗███████╗
--   ╚═══╝  ╚═╝     ╚═╝╚══════╝     ╚═════╝╚═╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝
Config.VMSCityHallResource = 'vms_cityhall'
Config.UseVMSCityHall = GetResourceState(Config.VMSCityHallResource) == 'started'

---@field UseCityHallVIN boolean: If a player orders a vehicle using the management menu in the garage, the VIN will be automatically generated
Config.UseCityHallVIN = true
