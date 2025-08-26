local apartmentStart = GetConvar('um:NewPlayerApartmentInsideStart', 'false') == 'true'


-- The function `SetNui` is setting the NUI (Native UI) focus in Lua. It takes a boolean parameter
--`bool` and uses it to set the NUI focus using the `SetNuiFocus` function. The `Debug` function is
-- also called to print a debug message indicating whether the NUI focus is set to true or false.
function SetNui(bool)
    Debug('SetNui: ' .. tostring(bool))
    SetNuiFocus(bool, bool)
end

-- The `AdjustRainLevel` function is used to determine the rain level based on the weather type. It
-- takes a parameter `weatherType` which represents the current weather type.
local function AdjustRainLevel(weatherType)
    local rainLevel = 0
    if weatherType == 'RAIN' then
        rainLevel = 0.3
    elseif weatherType == 'THUNDER' then
        rainLevel = 0.5
    end
    return rainLevel
end

-- The `SetWeatherAndTime` function is used to set the weather and time in the game. It takes two
-- parameters: `weather` and `time`.
local function SetWeatherAndTime(weather, time)
    SetWeatherTypePersist(weather)
    SetWeatherTypeNow(weather)
    SetWeatherTypeNowPersist(weather)
    NetworkOverrideClockTime(time, 0, 0)
end

-- The `ToggleSync` function is used to toggle the synchronization of weather and time in the game. It
-- takes a boolean parameter `status` which indicates whether the synchronization should be enabled or disabled.
local function ToggleSync(status)
    if status then
        if um.weather.sc == 'qb' then
            TriggerEvent('qb-weathersync:client:DisableSync')
        elseif um.weather.sc == 'cd' then
            TriggerEvent('cd_easytime:PauseSync', true)
        end
        Debug('Custom Weather: true')
    else
        if um.weather.sc == 'qb' then
            TriggerEvent('qb-weathersync:client:EnableSync')
        elseif um.weather.sc == 'cd' then
            TriggerEvent('cd_easytime:PauseSync', false)
        end
        Debug('Custom Weather: false')
    end
end

-- The `SetTimeCustom` function is a function that sets the custom time and weather in the game.
function SetTimeCustom(bool)
    if um.weather.sync then return end
    status = bool
    ToggleSync(status)
    local rainLevel = AdjustRainLevel(um.weather.type)
    while status do
        SetRainLevel(rainLevel)
        SetWeatherAndTime(um.weather.type, um.weather.time)
        Wait(0)
    end
end

-- The `RequestCollision` function is used to request collision data at a specific set of coordinates.
-- It takes a parameter `coords` which represents the coordinates (x, y, z) where collision data is requested.
function RequestCollision(coords)
    local interior = GetInteriorAtCoords(coords.x, coords.y, coords.z)
    if interior ~= 0 then
        local attempt = 5
        LoadInterior(interior)
        Debug("Found interior, loading interior")
        while not IsInteriorReady(interior) and attempt > 0 do
            Debug("Waiting for interior to be ready...")
            attempt = attempt - 1
            Wait(500)
        end
        if IsInteriorReady(interior) then
            Debug("Interior is ready")
            return
        else
            Debug("Interior loading failed or timed out")
        end
    else
        Debug("No interior found at coordinates, requesting collision")
    end
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    while not HasCollisionLoadedAroundEntity(cache.ped) do
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        Debug('Collision Loading...')
        Wait(100)
    end
end

-- The `SelectSound` function is playing a sound effect in the game. It uses the `PlaySound` function
-- to play the sound with the following parameters:
function SelectSound()
    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false, 0, false)
end

local function normalize(text)
    if not text or type(text) == 'number' then return 'undefined' end
    return text:gsub("%s+", ""):gsub("%d", ""):lower()
end

local function findMatchingApartment(houseLabel)
    if not UM_apartments or not next(UM_apartments) then return nil end
    local normalizedHouseLabel = normalize(houseLabel)
    for apartmentName, apartmentData in pairs(UM_apartments) do
        if normalize(apartmentName):find(normalizedHouseLabel) then
            Debug('Found matching apartment for house: ' .. houseLabel .. ' -> ' .. apartmentName)
            return apartmentData
        end
    end

    return nil
end

function GetProperties()
    local function getPropertyStatusAndData(status, defaultData, callbackName)
        if not status then return false, false end

        local result = lib.callback.await(callbackName)
        if result and next(result) then
            if callbackName == 'getHouses' then
                local processedHouses = {}

                for i = 1, #result do
                    local houseData = result[i]
                    local houseLabel = houseData?.street or houseData?.house or houseData?.label or
                        houseData?.property_name or houseData?.name
                    local matchingApartment = findMatchingApartment(houseLabel)

                    processedHouses[#processedHouses + 1] = {
                        house = houseData.property_id or houseData.house or houseData.id or houseData.identifier,
                        label = houseLabel,
                        image = matchingApartment and matchingApartment.image or um.propertyDefaultImage
                    }
                end

                return processedHouses, false
            elseif callbackName == 'getBookmarks' then
                local processedBookmarks = {}
                for i = 1, #result do
                    local bookmarksData = result[i]
                    processedBookmarks[#processedBookmarks + 1] = {
                        label = bookmarksData.name,
                        image = bookmarksData.image,
                        location = bookmarksData.location
                    }
                end
                return processedBookmarks, false
            elseif callbackName == 'getApartments' then
                if GetResourceState('qbx_properties') == 'started' then
                    return false, false
                end

                if result?.type then
                    TriggerEvent("apartments:client:SetHomeBlip", result.type)
                end

                return result, false
            end
        end

        if apartmentStart then
            return defaultData, true
        end

        return false, false
    end

    local myApartments, forceApartAndUMApart = getPropertyStatusAndData(
        apartmentStart,
        UM_apartments,
        'getApartments'
    )

    local myHouses = getPropertyStatusAndData(
        um.property.houses,
        nil,
        'getHouses'
    )

    local myBookmarks = getPropertyStatusAndData(
        um.main.bookmark.status,
        nil,
        'getBookmarks'
    )

    return myApartments, myHouses, myBookmarks, forceApartAndUMApart
end

function CloseNui(place)
    SelectSound()
    SetNui(false)
    SendNUIMessage({ ui = false })
    if GetResourceState('qbx_properties') ~= 'started' and place == 'rentApartment' then return end
    TriggerServerEvent('um-spawn:server:setBucketDefault')
    local timeout = 0
    local getBuck = lib.callback.await('um-spawn:server:getBucket')
    while getBuck ~= 0 and timeout <= 50 do
        timeout += 1
        TriggerServerEvent('um-spawn:server:setBucketDefault')
        getBuck = lib.callback.await('um-spawn:server:getBucket')
        Debug('Bucket waiting for default: ' .. getBuck)
        Wait(100)
    end
    if getBuck ~= 0 then
        return Debug('Bucket not default: ' .. getBuck, 'error')
    end
    Debug('CloseNui | Bucket default: ' .. getBuck, 'info')
end
