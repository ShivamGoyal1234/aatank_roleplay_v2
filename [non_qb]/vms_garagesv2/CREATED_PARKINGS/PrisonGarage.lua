-- File generated with VMS Garages V2 - Parking Creator.

Config = Config or {}

while not Config.Garages do
    Citizen.Wait(100)
end

Config.Garages['PrisonGarage'] = {
    label = 'Prison Garage',
    type = 'vehicle',

    nameBlip = 'free_garage:vehicle',
    showBlip = true,
    blipCoords = vec3(1870.1684570312, 2584.853515625, 45.672019958496),

    garageZone = {
        vec2(1888.03125, 2596.1569824219),
        vec2(1851.5395507812, 2596.9753417969),
        vec2(1851.2758789062, 2534.8735351562),
        vec2(1888.9351806641, 2533.103515625),
    },
    minZ = 39.755718231201,
    maxZ = 104.80221176147,

    menuPoint = vec3(1870.1684570312, 2584.853515625, 45.672019958496),
    garageData = {
        pedCoords = vec4(1877.1636962891, 2558.3110351562, 44.672019958496, 40.0),
        vehicleCoords = vec4(1879.0980224609, 2556.9028320312, 45.258285522461, 19.999998092651),
        cameraCoords = vec3(1871.3493652344, 2563.8857421875, 46.674758911133),
        cameraFov = 50.0,
    },

    spawnPoint = vec4(1869.5843505859, 2588.390625, 45.258285522461, 90.0),
    checkAreaOccupied = true,
    returnVehiclePoint = vec3(1869.8984375, 2581.3330078125, 45.672019958496),
}