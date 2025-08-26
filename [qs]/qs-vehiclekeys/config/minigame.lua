-- ███╗░░░███╗██╗███╗░░██╗██╗░██████╗░░█████╗░███╗░░░███╗███████╗
-- ████╗░████║██║████╗░██║██║██╔════╝░██╔══██╗████╗░████║██╔════╝
-- ██╔████╔██║██║██╔██╗██║██║██║░░██╗░███████║██╔████╔██║█████╗░░
-- ██║╚██╔╝██║██║██║╚████║██║██║░░╚██╗██╔══██║██║╚██╔╝██║██╔══╝░░
-- ██║░╚═╝░██║██║██║░╚███║██║╚██████╔╝██║░░██║██║░╚═╝░██║███████╗
-- ╚═╝░░░░░╚═╝╚═╝╚═╝░░╚══╝╚═╝░╚═════╝░╚═╝░░╚═╝╚═╝░░░░░╚═╝╚══════╝

-- Choose from the following options for the minigame.
-- 'ox_lib' (basic dependency)
-- 't3_lockpick' https://github.com/T3development/t3_lockpick
-- 'rm_minigame' https://store.rainmad.com/package/6249324
Config.minigameType = 'ox_lib'

local lockpickDifficultyMapping = {
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

local openingDoor = false
local lockpicking = false
local vehLockpick

function LockpickDoor(isAdvanced)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local vehicle = GetClosestVehicle(playerCoords, 2.0, false)
    if vehicle ~= nil and vehicle ~= 0 then
        local vehLockpick = vehicle
        local vehpos = GetEntityCoords(vehLockpick)
        local pos = GetEntityCoords(PlayerPedId())

        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, vehpos.x, vehpos.y, vehpos.z, true) < 2.0 then
            local vehicleCoords = GetEntityCoords(vehicle)
            TaskTurnPedToFaceCoord(PlayerPedId(), vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, -1)

            local lockpickTime = math.random(15000, 30000)
            if isAdvanced then
                lockpickTime = math.ceil(lockpickTime * 0.5)
            end

            IsHotwiring = true
            LockpickDoorAnim(lockpickTime)
            lockpickMiniGame(isAdvanced)
        end
    end
end

function LockpickDoorAnim(time)
    local ped = PlayerPedId()
    time = time / 1000
    loadAnimDict('veh@break_in@0h@p_m_one@')
    TaskPlayAnim(ped, 'veh@break_in@0h@p_m_one@', 'low_force_entry_ds', 3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    CreateThread(
        function()
            while openingDoor do
                TaskPlayAnim(ped, 'veh@break_in@0h@p_m_one@', 'low_force_entry_ds', 3.0, 3.0, -1, 16, 0, 0, 0, 0)
                Wait(1000)
                time = time - 1
                if time <= 0 then
                    openingDoor = false
                    StopAnimTask(ped, 'veh@break_in@0h@p_m_one@', 'low_force_entry_ds', 1.0)
                end
            end
        end
    )
end

function lockpickMiniGame(isAdvanced)
    local success = false
    local coords = GetEntityCoords(PlayerPedId())
    local lucky = math.random(1, 100)

    if not vehLockpick then
        local playerCoords = GetEntityCoords(PlayerPedId())
        vehLockpick = GetClosestVehicle(playerCoords, 2.0, false)
    end

    local vehicleClass = GetVehicleClass(vehLockpick)
    local difficultyArray = lockpickDifficultyMapping[vehicleClass] or { 'easy', 'easy', 'easy', 'easy', 'easy' }

    if Config.minigameType == 'ox_lib' then
        success = lib.skillCheck(difficultyArray)
    end

    if Config.minigameType == 'rm_minigame' then -- https://store.rainmad.com/package/6249324
        success = exports['rm_minigames']:timedLockpick(200)
    end

    if Config.minigameType == 't3_lockpick' then
        local item = Config.LockpickItem
        local difficultyMapping = {
            ['easy'] = { difficulty = 1, pins = 2 },
            ['medium'] = { difficulty = 2, pins = 3 },
            ['hard'] = { difficulty = 3, pins = 4 }
        }

        local chosenDifficulty = difficultyMapping[difficultyArray[1]] or { difficulty = 3, pins = 3 }
        success = exports['t3_lockpick']:startLockpick(item, chosenDifficulty.difficulty, chosenDifficulty.pins)
    end

    local coords = GetEntityCoords(PlayerPedId())
    local lucky = math.random(1, 100)

    if not vehLockpick then
        local playerCoords = GetEntityCoords(PlayerPedId())
        vehLockpick = GetClosestVehicle(playerCoords, 2.0, false)
    end

    if success then
        finishLockpick = true

        if lucky >= Config.LockpickFail then
            lockpickLogic(joaat(vehLockpick))

            if Config.LockpickAlarm and lucky > Config.StartAlarmChance then
                startAlarm(vehLockpick)
            end

            if lucky > Config.LockpickKeepChance then
                SendTextMessage(Lang('VEHICLEKEYS_NOTIFICATION_LOCKPICK_BROKEN'), 'error')
                if isAdvanced then
                    if Config.RemoveAdvancedLockpick then
                        TriggerServerEvent(Config.Eventprefix .. ':server:RemoveLockpick', Config.AdvancedLockpickItem, 1)
                    end
                else
                    TriggerServerEvent(Config.Eventprefix .. ':server:RemoveLockpick', Config.LockpickItem, 1)
                end
            end

            SendTextMessage(Lang('VEHICLEKEYS_NOTIFICATION_LOCKPICK_SUCCESS'), 'success')
        else
            startAlarm(vehLockpick)
            SendTextMessage(Lang('VEHICLEKEYS_NOTIFICATION_LOCKPICK_FAIL'), 'error')
        end
    else
        startAlarm(vehLockpick)
        SendTextMessage(Lang('VEHICLEKEYS_NOTIFICATION_LOCKPICK_FAIL'), 'error')
    end

    Dispatch({
        coords = coords,
        vehicle = vehLockpick,
        message = success and 'Vehicle Lockpicked' or 'Vehicle Lockpick Failed',
        title = success and 'Vehicle Lockpick Success' or 'Vehicle Lockpick Failure',
    })
    StopAnimTask(PlayerPedId(), 'veh@break_in@0h@p_m_one@', 'low_force_entry_ds', 1.0)

    IsHotwiring = false
    openingDoor = false
    vehLockpick = nil
end
