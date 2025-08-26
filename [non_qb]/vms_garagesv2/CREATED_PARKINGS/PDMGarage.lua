-- File generated with VMS Garages V2 - Parking Creator.

Config = Config or {}

while not Config.Garages do
    Citizen.Wait(100)
end

Config.Garages['PDMGarage'] = {
    label = 'PDM Garage',
    type = 'vehicle',

    nameBlip = 'free_garage:vehicle',
    showBlip = true,
    blipCoords = vec3(-1027.6252441406, -1513.9396972656, 5.5907974243164),

    garageZone = {
        vec2(-1033.8833007812, -1514.650390625),
        vec2(-1025.0783691406, -1508.3725585938),
        vec2(-1019.8212280273, -1515.8399658203),
        vec2(-1029.9594726562, -1520.3131103516),
    },
    minZ = -0.16611528396606,
    maxZ = 64.853507041931,

    menuPoint = vec3(-1027.6252441406, -1513.9396972656, 5.5907974243164),
    garageData = {
        pedCoords = vec4(-1029.2121582031, -1514.9705810547, 4.5907974243164, 340.0),
        vehicleCoords = vec4(-1029.6755371094, -1516.4844970703, 5.1770620346069, 35.0),
        cameraCoords = vec3(-1026.7437744141, -1510.8684082031, 6.1330237388611),
        cameraFov = 50.0,
    },

    spawnPoint = vec4(-1024.3469238281, -1512.8511962891, 5.1770620346069, 215.00001525879),
    checkAreaOccupied = true,
    returnVehiclePoint = vec3(-1029.9544677734, -1516.2514648438, 6.7078561782837),
}