Config.dealerships = Config.dealerships or {}

Config.dealerships.fmpdm = { -- Dealership ID, NEEDS TO BE THE SAME AS THE JOB!!!
    enabled = true, -- true or false to enable or disable the dealership
    label = 'Luxury Motorsports', -- Dealership label
    logo = 'https://i.ibb.co/nkBN3bs/logo.png', -- Dealership logo that'll show on UI
    job = 'fmpdm', -- Dealership job or false to not player owned dealerships, NEEDS TO BE THE SAME AS THE ID!!!
    lockCatalogueJob = false, -- can be false for everyone to open the catalogue or a job if you want to lock it to some job
    currency = 'bank', -- bank, cash or money to ESX (Also to QBCore you can choose other currency like crypto and etc)
    testDriveRoutingBucket = false, -- Set this to false if you don't want the test drive to be inside of a Routing Bucket
    allowChangeVehicle = false, -- If true players will be able to change the vehicles on the catalogue witout job
    testDriveTime = 120, -- Test drive time in seconds
    testDriveSpawn = vec4(-231.14, -1171.95, 22.84, 349.96), -- Test drive spawn coords
    buySpawn = vec4(-190.81, -1182.29, 23.03, 90.70),
 	comissions = { buyPercentage = 50, sellComission = 0 }, -- Vehicle buy spawn coords
    blip = { enabled = true, coords = vec3(-186.84, -1167.57, 22.94), sprite = 523, color = 3, scale = 0.6, display = 4 }, -- Dealership map blip
    dashboards = { -- Dealership dashboards to import vehicles and see transations and etc
        { coords = vec3(-196.1, -1167.5, 24.0), radius = 0.5, includeBossMenu = true },
    },
    catalogues = { -- The catalogues to the players see the vehicle and emplooyes change the vehicle on showrrom
        { coords = vec3(-177.42, -1164.93, 22.94), radius = 0.4 },
        { coords = vec3(-171.12, -1164.98, 22.94), radius = 0.4 },
        { coords = vec3(-165.14, -1164.98, 22.94), radius = 0.4 },
        { coords = vec3(-167.81, -1170.04, 22.94), radius = 0.4 },
        { coords = vec3(-168.38, -1173.74, 22.95), radius = 0.4 },
    },
    categories = { -- The categories that will show on the catalogue and dashboard (need to add the shop with the job name to the vehicles.lua too on the shops field otherwise it'll not show the vehicles!!)
        { label = 'Coupes', id = 'coupes' },
        { label = 'Muscle', id = 'muscle' },
        { label = 'Sedans', id = 'sedans' },
        { label = 'Super', id = 'super' },
        { label = 'SUVS', id = 'suvs' },
        { label = 'Offroad', id = 'offroad' },
        { label = 'Sports', id = 'sports' },
        { label = 'Super', id = 'super' },
        { label = 'luxury', id = 'luxury' },
        { label = 'Motorcycles', id = 'motorcycles' },
        { label = 'OffRoad', id = 'offroad' },
        { label = 'Industrial', id = 'industrial' },
        { label = 'Utility', id = 'utility' },
        { label = 'Vans', id = 'vans' },
        { label = 'Cycles', id = 'cycles' },
        { label = 'Service', id = 'service' },
        { label = 'Commercial', id = 'commercial' },
        { label = 'Open Wheel', id = 'openwheel' },
    }
}