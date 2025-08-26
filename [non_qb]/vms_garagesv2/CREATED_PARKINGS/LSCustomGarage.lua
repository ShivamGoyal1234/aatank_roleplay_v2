-- File generated with VMS Garages V2 - Parking Creator.

Config = Config or {}

while not Config.Garages do
    Citizen.Wait(100)
end

Config.Garages['LSCustomGarage'] = {
    label = 'LS Custom Garage',
    type = 'vehicle',

    nameBlip = 'free_garage:vehicle',
    showBlip = true,
    blipCoords = vec3(-378.17630004883, -147.0905456543, 38.684455871582),

    garageZone = {
        vec2(-379.18060302734, -150.39001464844),
        vec2(-365.39743041992, -143.53684997559),
        vec2(-385.35485839844, -110.66555023193),
        vec2(-397.77703857422, -117.03302764893),
    },
    minZ = 32.618110656738,
    maxZ = 101.7271156311,

    menuPoint = vec3(-378.17630004883, -147.0905456543, 38.684455871582),
    garageData = {
        pedCoords = vec4(-388.27423095703, -122.53612518311, 37.686664581299, 260.0),
        vehicleCoords = vec4(-389.85592651367, -121.23415374756, 38.2414894104, 270.0),
        cameraCoords = vec3(-383.24014282227, -125.26891326904, 39.551338195801),
        cameraFov = 50.0,
    },

    spawnPoint = vec4(-384.72494506836, -130.66830444336, 38.271263122559, 299.99996948242),
    checkAreaOccupied = true,
    returnVehiclePoint = vec3(-383.10903930664, -137.89454650879, 38.684989929199),
}