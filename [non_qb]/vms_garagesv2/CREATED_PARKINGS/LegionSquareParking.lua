-- File generated with VMS Garages V2 - Parking Creator.

Config = Config or {}

while not Config.Garages do
    Citizen.Wait(100)
end

Config.Garages['LegionSquareParking'] = {
    label = 'Legion Square Parking',
    type = 'vehicle',

    nameBlip = 'free_garage:vehicle',
    showBlip = true,
    blipCoords = vec3(213.50350952148, -809.388671875, 31.01490020752),

    garageZone = {
        vec2(199.64167785645, -806.15356445312),
        vec2(240.16513061523, -821.11767578125),
        vec2(259.14617919922, -768.07427978516),
        vec2(217.26467895508, -757.08013916016),
    },
    minZ = 24.843563079834,
    maxZ = 90.84132194519,

    menuPoint = vec3(213.50350952148, -809.388671875, 31.01490020752),
    garageData = {
        pedCoords = vec4(212.47610473633, -797.39471435547, 29.882572174072, 185.0),
        vehicleCoords = vec4(212.92594909668, -794.51837158203, 30.468658447266, 174.99998474121),
        cameraCoords = vec3(219.72808837891, -803.88317871094, 31.121242523193),
        cameraFov = 50.0,
    },

    spawnPoint = vec4(211.57695007324, -786.66027832031, 30.493726730347, 250.0),
    checkAreaOccupied = true,
    returnVehiclePoint = vec3(221.27151489258, -791.11169433594, 31.880168914795),
}