-- File generated with VMS Garages V2 - Parking Creator.

Config = Config or {}

while not Config.Garages do
    Citizen.Wait(100)
end

Config.Garages['government'] = {
    label = 'government',
    type = 'vehicle',

    requiredJob = {
        ['government'] = true,
    },

    nameBlip = 'job_garage',
    showBlip = false,
    blipCoords = vec3(-165.86143493652, -1178.4061279296, 24.295366287232),

    garageZone = {
        vec2(-145.6157836914, -1186.4197998046),
        vec2(-172.4801940918, -1186.6528320312),
        vec2(-167.47305297852, -1158.7670898438),
        vec2(-154.02993774414, -1158.0258789062),
    },
    minZ = 19.487392425538,
    maxZ = 84.200649261474,
availableVehicles = {
        ['baller5'] = {
                model = 'baller5',
                gradesAccess = { 0, 1, 2, 3, 4, 5, 6, 7, 8 },
                customProperties = {
                    ['modEngine'] = 3,
                    ['modBrakes'] = 2,
                    ['modTransmission'] = 2,
                    ['modArmor'] = 4,
                    ['modTurbo'] = true,
                    ['windowTint'] = 3,
                    ['extras'] = {
                        [0] = true,
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
                        [5] = true,
                        [6] = true,
                        [7] = true,
                        [8] = true,
                        [9] = true,
                        [10] = true,
                        [11] = true,
                    },
                },
            },
        ['baller6'] = {
                model = 'baller6',
                gradesAccess = { 0, 1, 2, 3, 4, 5, 6, 7, 8 },
                customProperties = {
                    ['modEngine'] = 3,
                    ['modBrakes'] = 2,
                    ['modTransmission'] = 2,
                    ['modArmor'] = 4,
                    ['modTurbo'] = true,
                    ['windowTint'] = 3,
                    ['extras'] = {
                        [0] = true,
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
                        [5] = true,
                        [6] = true,
                        [7] = true,
                        [8] = true,
                        [9] = true,
                        [10] = true,
                        [11] = true,
                    },
                },
            },
    },
    menuPoint = vec3(-165.86143493652, -1178.4061279296, 24.295366287232),
    garageData = {
        pedCoords = vec4(-156.14, -1181.35, 24.95, 76.75),
        vehicleCoords = vec4(-153.54, -1182.52, 24.89, 38.10),
        cameraCoords = vec3(-159.84, -1177.56, 24.87),
        cameraFov = 50.0,
    },

    spawnPoint = vec4(-157.8478088379, -1174.998413086, 24.356304168702, 0.0),
    checkAreaOccupied = true,
    returnVehiclePoint = vec3(-157.92596435546, -1181.1485595704, 24.894708633422),
}