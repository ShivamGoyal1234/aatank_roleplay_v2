Config.dealerships = Config.dealerships or {}

Config.dealerships.cardealer = { -- Dealership ID, NEEDS TO BE THE SAME AS THE JOB!!!
    enabled = true, -- true or false to enable or disable the dealership
    label = 'Premium Deluxe Motorsports', -- Dealership label
    logo = 'https://i.ibb.co/nkBN3bs/logo.png', -- Dealership logo that'll show on UI
    job = 'cardealer', -- Dealership job or false to not player owned dealerships, NEEDS TO BE THE SAME AS THE ID!!!
    lockCatalogueJob = false, -- can be false for everyone to open the catalogue or a job if you want to lock it to some job
    currency = 'bank', -- bank, cash or money to ESX (Also to QBCore you can choose other currency like crypto and etc)
    useStock = false, -- When using job = false this will be ignored
    allowBuyCatalogue = false, -- If true players will be able to buy the vehicles on the catalogue
    allowChangeVehicle = false, -- If true players will be able to change the vehicles on the catalogue witout job
    needsMission = false, -- Set to false or true to disable/disable the needing of going pick up the car
    testDriveRoutingBucket = false, -- Set this to false if you don't want the test drive to be inside of a Routing Bucket
    testDriveTime = 120, -- Test drive time in seconds
    testDriveSpawn = vec4(-1018.7, -1526.45, 5.57, 37.58), -- Test drive spawn coords
    truck = 'packer', -- The truck used on importation
    trailer = 'tr4', -- The trailer used on importation
    truckSpawn = vec4(-970.31, -1483.81, 5.01, 22.41), -- Importation truck spawn coords
    buySpawn = vec4(-1021.33, -1528.35, 5.57, 33.05), -- Vehicle buy spawn coords
    comissions = { buyPercentage = 50, sellComission = 10 }, -- The dealership commisions (buyPercentage is the percentage of vehicle price that the dealership will buy it and the sellComission is the comission that the employee will earn on selling vehicles to players)
    blip = { enabled = true, coords = vec3(-1006.97, -1508.64, 5.79), sprite = 523, color = 3, scale = 0.9, display = 4 }, -- Dealership map blip
    dashboards = { -- Dealership dashboards to import vehicles and see transations and etc
        { coords = vec3(-995.5, -1501.5, 6.0), radius = 0.5, includeBossMenu = true },
        { coords = vec3(-1000.0, -1505.5, 6.0), radius = 0.5,},
        { coords = vec3(-1002.0, -1503.0, 6.0), radius = 0.5,},
    },
    catalogues = { -- The catalogues to the players see the vehicle and emplooyes change the vehicle on showrrom
        { coords = vec3(-1004.25, -1511.5, 6.0), radius = 0.3, vehicleCoords = vec4(-1003.62, -1514.67, 5.45, 123.12), vehicle = 'xa21', vehicleColor = 54 },
        { coords = vec3(-1012.05, -1517.65, 5.9), radius = 0.3, vehicleCoords = vec4(-1009.03, -1517.86, 5.45, 16.32), vehicle = 'sultan', vehicleColor = 0 },
        { coords = vec3(-1015.75, -1511.0, 5.75), radius = 0.3, vehicleCoords = vec4(-1016.04, -1507.85, 5.46, 251.87), vehicle = 'cyclone', vehicleColor = 73 },
        { coords = vec3(-1006.5, -1503.3, 5.8), radius = 0.3, vehicleCoords = vec4(-1009.83, -1503.47, 5.75, 171.25), vehicle = 'cheetah2', vehicleColor = 4 },
    },
    categories = { -- The categories that will show on the catalogue and dashboard (need to add the shop with the job name to the vehicles.lua too on the shops field otherwise it'll not show the vehicles!!)
        { label = 'Compacts', id = 'compacts' },
        { label = 'Sedans', id = 'sedans' },
        { label = 'SUVs', id = 'suvs' },
        { label = 'Coupes', id = 'coupes' },
        { label = 'Muscle', id = 'muscle' },
        { label = 'Sports Classics', id = 'classics' },
        { label = 'Sports', id = 'sports' },
        { label = 'Super', id = 'super' },
        -- { label = 'luxury', id = 'luxury' },
        -- { label = 'Motorcycles', id = 'motorcycles' },
        { label = 'OffRoad', id = 'offroad' },
        -- { label = 'Industrial', id = 'industrial' },
        -- { label = 'Utility', id = 'utility' },
        { label = 'Vans', id = 'vans' },
        -- { label = 'Cycles', id = 'cycles' },
        -- { label = 'Service', id = 'service' },
        -- { label = 'Commercial', id = 'commercial' },
        -- { label = 'Open Wheel', id = 'openwheel' },
    },
    pickups = {
        vec4(1201.35, -3187.03, 5.98, 175.35)
    }
}