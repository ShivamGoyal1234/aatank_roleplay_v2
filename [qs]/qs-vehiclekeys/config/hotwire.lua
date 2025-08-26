-- ██╗░░██╗░█████╗░████████╗░██╗░░░░░░░██╗██╗██████╗░███████╗
-- ██║░░██║██╔══██╗╚══██╔══╝░██║░░██╗░░██║██║██╔══██╗██╔════╝
-- ███████║██║░░██║░░░██║░░░░╚██╗████╗██╔╝██║██████╔╝█████╗░░
-- ██╔══██║██║░░██║░░░██║░░░░░████╔═████║░██║██╔══██╗██╔══╝░░
-- ██║░░██║╚█████╔╝░░░██║░░░░░╚██╔╝░╚██╔╝░██║██║░░██║███████╗
-- ╚═╝░░╚═╝░╚════╝░░░░╚═╝░░░░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚═╝╚══════╝

local hotwireDifficultyMapping = {
    [0] = { 'easy', 'easy', 'easy', 'easy', 'easy' },           -- Compacts
    [1] = { 'easy', 'easy', 'easy', 'easy', 'easy' },           -- Sedans
    [2] = { 'easy', 'easy', 'easy', 'easy', 'easy' },           -- SUVs
    [3] = { 'easy', 'easy', 'easy', 'easy', 'easy' },           -- Coupes
    [4] = { 'easy', 'easy', 'easy', 'easy', 'easy' },           -- Muscle
    [5] = { 'easy', 'easy', 'easy', 'easy', 'easy' },           -- Sports Classics
    [6] = { 'medium', 'medium', 'medium', 'medium', 'medium' }, -- Sports
    [7] = { 'medium', 'medium', 'medium', 'medium', 'medium' }, -- Super
    [8] = { 'hard', 'hard', 'hard', 'hard', 'hard' },           -- Motorcycles
    [9] = { 'hard', 'hard', 'hard', 'hard', 'hard' },           -- Off-road
    [10] = { 'hard', 'hard', 'hard', 'hard', 'hard' },          -- Industrial
    [11] = { 'hard', 'hard', 'hard', 'hard', 'hard' },          -- Utility
    [12] = { 'hard', 'hard', 'hard', 'hard', 'hard' },          -- Vans
    [13] = { 'hard', 'hard', 'hard', 'hard', 'hard' },          -- Cycles
    [14] = { 'hard', 'hard', 'hard', 'hard', 'hard' },          -- Boats
    [15] = { 'hard', 'hard', 'hard', 'hard', 'hard' },          -- Helicopters
    [16] = { 'hard', 'hard', 'hard', 'hard', 'hard' },          -- Planes
    [17] = { 'hard', 'hard', 'hard', 'hard', 'hard' },          -- Service
    [18] = { 'hard', 'hard', 'hard', 'hard', 'hard' },          -- Emergency
    [19] = { 'hard', 'hard', 'hard', 'hard', 'hard' },          -- Military
    [20] = { 'hard', 'hard', 'hard', 'hard', 'hard' },          -- Commercial
    [21] = { 'hard', 'hard', 'hard', 'hard', 'hard' },          -- Trains
    [22] = { 'hard', 'hard', 'hard', 'hard', 'hard' },          -- Open Wheel
}

local inMinigame = false

function HandleHotwireProcess()
    if inMinigame then return end

    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if not vehicle or vehicle == 0 then return end

    local hasKeys = exports['qs-vehiclekeys']:GetKey(GetVehicleNumberPlateText(vehicle))
    local isEngineRunning = GetIsVehicleEngineRunning(vehicle)

    if hasKeys or isEngineRunning then return end

    inMinigame = true
    local vehicleClass = GetVehicleClass(vehicle)
    local difficultyArray = hotwireDifficultyMapping[vehicleClass] or { 'easy', 'easy', 'easy', 'easy', 'easy' }
    local VehicleKeysHotwireformattedString = GetFormattedHotwireString()
    local success = lib.skillCheck(difficultyArray)

    if success then
        TextClose(VehicleKeysHotwireformattedString)
        inMinigame = false
        Hotwire({ vehicle = vehicle })
    else
        isTextVisible = true
        inMinigame = false
        initKeys({ vehicle = vehicle })
    end
end

function CustomProgBarsHotWire(plates, vehicle_model, coords, time)
    local label = Lang('VEHICLEKEYS_HOTWIRE_TAKING_KEYS')
    local anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer' }
    local disableControls = { car = true }

    local function onFinish()
        if Config.GiveKeysOnHotwire then
            TriggerServerEvent(Config.Eventprefix .. ':server:givekey', plates, vehicle_model)
        end
        ClearPedTasks(PlayerPedId())
        Wait(5000)
        Dispatch({
            coords = coords,
            vehicle = GetVehiclePedIsIn(PlayerPedId(), false),
            message = Lang('VEHICLEKEYS_HOTWIRE_SUCCESS'),
            title = Lang('VEHICLEKEYS_HOTWIRE_TITLE'),
        })
    end

    ProgressBar('hotwire', label, time, false, false, disableControls, anim, nil, nil, onFinish, nil)
end

function CustomProgBarsDeadPed(plates, vehicle_model)
    local label = Lang('VEHICLEKEYS_HOTWIRE_STEAL')
    local anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a' }
    local disableControls = { car = true }

    local function onFinish()
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent(Config.Eventprefix .. ':server:givekey', plates, vehicle_model)
    end

    ProgressBar('deadped', label, 10000, false, false, disableControls, anim, nil, nil, onFinish, nil)
end
