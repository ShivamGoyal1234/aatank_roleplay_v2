Config.dealerships = Config.dealerships or {}

Config.dealerships.laryscars = { -- Dealership ID, NEEDS TO BE THE SAME AS THE JOB!!!
    enabled = false, -- true or false to enable or disable the dealership
    label = "Lary's Cars", -- Dealership label
    logo = 'https://i.ibb.co/nkBN3bs/logo.png', -- Dealership logo that'll show on UI
    job = 'laryscars', -- Dealership job or false to not player owned dealerships, NEEDS TO BE THE SAME AS THE ID!!!
    lockCatalogueJob = false, -- can be false for everyone to open the catalogue or a job if you want to lock it to some job
    currency = 'cash', -- bank, cash or money to ESX (Also to QBCore you can choose other currency like crypto and etc)
    useStock = true, -- When using job = false this will be ignored
    allowBuyCatalogue = true, -- If true players will be able to buy the vehicles on the catalogue
    allowChangeVehicle = true, -- If true players will be able to change the vehicles on the catalogue witout job
    needsMission = true, -- Set to false or true to disable/disable the needing of going pick up the car
    testDriveRoutingBucket = true, -- Set this to false if you don't want the test drive to be inside of a Routing Bucket
    testDriveTime = 50, -- Test drive time in seconds
    testDriveSpawn = vec4(1223.21, 2688.7, 37.56, 108.43), -- Test drive spawn coords
    truck = 'packer', -- The truck used on importation
    trailer = 'tr4', -- The trailer used on importation
    truckSpawn = vec4(1245.86, 2667.8, 37.55, 357.46), -- Importation truck spawn coords
    buySpawn = vec4(1210.15, 2719.98, 38.01, 178.31), -- Vehicle buy spawn coords
    comissions = { buyPercentage = 50, sellComission = 10 }, -- The dealership commisions (buyPercentage is the percentage of vehicle price that the dealership will buy it and the sellComission is the comission that the employee will earn on selling vehicles to players)
    blip = { enabled = true, coords = vec3(1223.71, 2722.84, 38.01), sprite = 523, color = 3, scale = 0.6, display = 4 }, -- Dealership map blip
    dashboards = { -- Dealership dashboards to import vehicles and see transations and etc
        { coords = vec3(1225.45, 2739.45, 38.25), radius = 0.5, includeBossMenu = true },
    },
    catalogues = { -- The catalogues to the players see the vehicle and emplooyes change the vehicle on showrrom
        { coords = vec3(1216.1, 2735.45, 38.15), radius = 0.25, vehicleCoords = vec4(1215.17, 2732.47, 37.1, 358.38), vehicle = 'premier', vehicleColor = 54 },
        { coords = vec3(1218.8, 2735.45, 38.15), radius = 0.25, vehicleCoords = vec4(1218.77, 2732.35, 37.1, 3.14), vehicle = 'mesa', vehicleColor = 0 },
        { coords = vec3(1229.35, 2735.4, 38.1), radius = 0.25, vehicleCoords = vec4(1229.48, 2733.08, 37.1, 356.21), vehicle = 'vacca', vehicleColor = 73 },
        { coords = vec3(1232.95, 2735.5, 38.15), radius = 0.25, vehicleCoords = vec4(1233.06, 2732.51, 38.1, 0.95), vehicle = 'cavalcade', vehicleColor = 4 },
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
        { label = 'Motorcycles', id = 'motorcycles' },
        { label = 'OffRoad', id = 'offroad' },
        { label = 'Industrial', id = 'industrial' },
        { label = 'Utility', id = 'utility' },
        { label = 'Vans', id = 'vans' },
        { label = 'Cycles', id = 'cycles' },
        { label = 'Service', id = 'service' },
        { label = 'Commercial', id = 'commercial' },
        { label = 'Open Wheel', id = 'openwheel' },
    },
    pickups = {
        vec4(1201.35, -3187.03, 5.98, 175.35)
    }
}