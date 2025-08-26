local globalHudSettings = nil
local function getGlobalHudSettings()
    if globalHudSettings and globalHudSettings.globalSettings then
        if Config.Debug then print('Returning cached global settings') end
        return globalHudSettings
    end

    local result = Database.single([[SELECT settings, disabled_elements FROM envi_hud_settings_global]])
    if not result then
        if Config.Debug then print('No Global Settings Found') end
        GlobalState.doesEnviHudHaveGlobalSettings = false
        return nil
    end

    if Config.Debug then print('Global Settings (raw): ', result.settings and result.settings:sub(1, 100) .. '...' or 'nil') end
    local success, decodedSettings = false, nil
    if result.settings then
        success, decodedSettings = pcall(function()
            return json.decode(result.settings)
        end)
    end

    if not success then
        if Config.Debug then print('Error decoding global settings:', decodedSettings) end
        GlobalState.doesEnviHudHaveGlobalSettings = false
        return { globalSettings = nil, disabledElements = result.disabled_elements }
    end

    if Config.Debug then print('Global Settings (decoded): Successfully decoded') end
    GlobalState.doesEnviHudHaveGlobalSettings = true
    return { globalSettings = decodedSettings, disabledElements = result.disabled_elements }
end

CreateThread(function()
    if Bridge.Framework == 'esx' then
        Database.query([[
            ALTER TABLE owned_vehicles
            ADD COLUMN IF NOT EXISTS HarnessInstalled INT DEFAULT 0
        ]])
    elseif Bridge.Framework == 'qb' or Bridge.Framework == 'qbox' then
        Database.query([[
            ALTER TABLE player_vehicles 
            ADD COLUMN IF NOT EXISTS HarnessInstalled INT DEFAULT 0
        ]])
    else
        error('No Compatible Framework found by envi-bridge - Please install envi-bridge and use a compatible Framework as shown on documentation - alternatively, you can make your own edits to envi-hud/server/server_open.lua')
    end
    Database.query([[
        CREATE TABLE IF NOT EXISTS envi_hud_settings_global (
            id INT PRIMARY KEY DEFAULT 1 CHECK (id = 1),
            updated_by VARCHAR(255),
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            settings TEXT,
            disabled_elements TEXT
        )
    ]])
    Database.query([[
        CREATE TABLE IF NOT EXISTS envi_hud_settings (
            identifier VARCHAR(255) PRIMARY KEY,
            settings TEXT
        )
    ]])

    globalHudSettings = getGlobalHudSettings()
end)

-- NEW IN v1.6.0
function Notify(source, data)
    data.duration = data.duration or 5000
    TriggerClientEvent('envi-hud:notify', source, data)
end

Framework.CreateCallback('envi-hud:getDisabledHudElements', function(source, cb)
    local result = Database.single([[SELECT disabled_elements FROM envi_hud_settings_global]])
    if result then
        local disabledElements = json.decode(result.disabled_elements)
        if Config.Debug then print('Disabled Elements: ', json.encode(disabledElements)) end
        cb(disabledElements)
    else
        cb(false)
    end
end)

Framework.CreateCallback('envi-hud:saveGlobalHudSettings', function(source, cb, settings, disabledElements)
    local src = source
    local Player = Framework.GetPlayer(src)
    if not Player then
        cb(false)
        return
    end
    local hasPermission = Framework.HasPermission(src, Config.AdminRoles)
    if not hasPermission then
        cb(false)
        return
    end

    -- Debug logging
    if Config.Debug then
        print('[envi-hud] Saving global settings by:', Player.Identifier)
        if settings.elementPositions and next(settings.elementPositions) then
            print('[envi-hud] Server received global element positions:', json.encode(settings.elementPositions))
        else
            print('[envi-hud] Server received no global element positions')
        end
    end

    local dateAndTime = os.date('%Y-%m-%d %H:%M:%S')
    Database.query([[
        INSERT INTO envi_hud_settings_global (id, updated_by, updated_at, settings, disabled_elements)
        VALUES (1, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE
        updated_by = VALUES(updated_by),
        updated_at = VALUES(updated_at),
        settings = VALUES(settings),
        disabled_elements = VALUES(disabled_elements)
    ]], { Player.Identifier, dateAndTime, json.encode(settings), json.encode(disabledElements) })

    globalHudSettings = {
        globalSettings = settings,
        disabledElements = disabledElements
    }

    GlobalState.doesEnviHudHaveGlobalSettings = true
    cb(true)
end)

Framework.CreateCallback('envi-hud:isAdmin', function(source, cb)
    local src = source
    local Player = Framework.GetPlayer(src)
    if not Player then
        cb(false)
        return
    end
    local hasPermission = Framework.HasPermission(src, Config.AdminRoles)
    if not hasPermission then
        cb(false)
        return
    end
    cb(true)
end)

Framework.CreateCallback('envi-hud:getGlobalHudSettings', function(source, cb)
    local settings = getGlobalHudSettings()
    if not settings then
        cb(false, false)
        return
    end

    cb(settings.globalSettings or false, settings.disabledElements or false)
end)

local lastSaveTime = {}

-- Enhanced settings validation function for server
local function ValidateHudSettingsServer(settings)
    -- Basic validation checks
    if type(settings) ~= 'table' then
        return false
    end

    -- Check for required fields
    local requiredFields = {'theme', 'minimap', 'elementsVisibility'}
    for _, field in ipairs(requiredFields) do
        if settings[field] == nil then
            return false
        end
    end

    -- Validate minimap structure
    if type(settings.minimap) ~= 'table' then
        return false
    end

    if not settings.minimap.type or not settings.minimap.size then
        return false
    end

    -- Validate minimap buffer
    if not settings.minimap.buffer or type(settings.minimap.buffer) ~= 'table' then
        return false
    end

    if type(settings.minimap.buffer.x) ~= 'number' or type(settings.minimap.buffer.y) ~= 'number' then
        return false
    end

    -- Validate elementsVisibility
    if type(settings.elementsVisibility) ~= 'table' then
        return false
    end

    return true
end

Framework.CreateCallback('envi-hud:savePlayerHudSettings', function(source, cb, settings)
    local Player = Framework.GetPlayer(source)
    if not Player then
        cb(false)
        return
    end

    local currentTime = os.time()
    if lastSaveTime[source] and currentTime - lastSaveTime[source] < 3 then
        cb(false)
        return
    end
    lastSaveTime[source] = currentTime
    local identifier = Player.Identifier

    -- Debug logging
    if Config.Debug then
        print('[envi-hud] Saving player settings for:', identifier)
        if settings.elementPositions and next(settings.elementPositions) then
            print('[envi-hud] Server received element positions:', json.encode(settings.elementPositions))
        else
            print('[envi-hud] Server received no element positions')
        end
    end

    -- Enhanced validation
    if not ValidateHudSettingsServer(settings) then
        print('^1[envi-hud] ERROR Invalid settings structure for player:^0', identifier)
        cb(false)
        return
    end

    local success, encodedSettings = pcall(function()
        return json.encode(settings)
    end)
    if not success or not encodedSettings then
        print('^1[envi-hud] ERROR Failed to encode settings for player:^0', identifier)
        cb(false)
        return
    end

    -- Validate encoded settings can be decoded
    local decodeSuccess, decodedTest = pcall(function()
        return json.decode(encodedSettings)
    end)
    if not decodeSuccess or not ValidateHudSettingsServer(decodedTest) then
        print('^1[envi-hud] ERROR Settings validation failed after encoding for player:^0', identifier)
        cb(false)
        return
    end

    Database.query([[
        INSERT INTO envi_hud_settings (identifier, settings) VALUES (?, ?)
        ON DUPLICATE KEY UPDATE settings = VALUES(settings)
    ]], { identifier, encodedSettings })
    if Config.Debug then print('[envi-hud] Validated settings saved for player:', identifier) end
    cb(true)
end)

Framework.CreateCallback('envi-hud:getPlayerHudSettings', function(source, cb)
    local Player = Framework.GetPlayer(source)
    if not Player then
        cb(false)
        return
    end
    local identifier = Player.Identifier
    local result = Database.single([[SELECT settings FROM envi_hud_settings WHERE identifier = ?]], { identifier })
    if result and result.settings then
        local success, decodedSettings = pcall(function()
            return json.decode(result.settings)
        end)
        if success and decodedSettings then
            if Config.Debug then print('[envi-hud] Successfully retrieved settings for', identifier, '| Settings: ', json.encode(decodedSettings)) end
            cb(decodedSettings)
        else
            print('^1[envi-hud] Error decoding settings from database:^0', result.settings:sub(1, 100) .. '...')
            cb(false)
        end
    else
        cb(false)
    end
end)

Framework.CreateCallback('envi-hud:deletePlayerHudSettings', function(source, cb)
    local Player = Framework.GetPlayer(source)
    if not Player then
        cb(false)
        return
    end
    local identifier = Player.Identifier

    if Config.Debug then
        print('[envi-hud] Deleting personal HUD settings for:', identifier)
    end

    Database.query([[DELETE FROM envi_hud_settings WHERE identifier = ?]], { identifier })
    cb(true)
end)

local function isVehcileOwned(plate)
    if Bridge.Framework == 'esx' then
        return Database.single([[SELECT 1 FROM owned_vehicles WHERE plate = ?]], { plate })
    elseif Bridge.Framework == 'qb' or Bridge.Framework == 'qbox' then
        return Database.single([[SELECT 1 FROM player_vehicles WHERE plate = ?]], { plate })
    end
end

local function hasItem(source, item)
    return Framework.HasItem(source, item, 1)
end

Framework.CreateCallback('envi-hud:checkHarness', function(source, cb, plate, level)
    if Bridge.Framework == 'esx' then
        Database.query([[
            SELECT HarnessInstalled FROM owned_vehicles WHERE plate = ?
        ]], { plate }, function(result)
            if result and result[1] then
                local installed = result[1].HarnessInstalled or 0
                if level then
                    cb(installed >= level, installed)
                else
                    cb(installed >= 1, installed)
                end
            else
                cb(false)
            end
        end)
    elseif Bridge.Framework == 'qb' or Bridge.Framework == 'qbox' then
        Database.query([[
            SELECT HarnessInstalled FROM player_vehicles WHERE plate = ?
        ]], { plate }, function(result)
            if result and result[1] then
                local installed = result[1].HarnessInstalled or 0
                if level then
                    cb(installed >= level, installed)
                else
                    cb(installed >= 1, installed)
                end
            else
                cb(false)
            end
        end)
    else
       error('No Compatible Framework found by envi-bridge - Please install envi-bridge and use a compatible Framework as shown on documentation - alternatively, you can make your own edits to envi-hud/server/server_open.lua')
   end
end)


Framework.CreateCallback('envi-hud:installHarness', function(source, cb, plate, level)
    if not hasItem(source, Config.Items.Install[level].item) then
        Notify(source, {
            type = 'error',
            message = Config.Lang.NoInstallItem,
        })
        cb(false)
        return
    end
    if not isVehcileOwned(plate) then
        Notify(source, {
            type = 'success',
            message = Config.Lang.InstallSuccess,
        })
        Framework.RemoveItem(source, Config.Items.Install[level].item, 1)
        cb(false)
        return
    end

    if Bridge.Framework == 'esx' then
        Database.query([[
            UPDATE owned_vehicles SET HarnessInstalled = ? WHERE plate = ?
        ]], { level, plate }, function(result)
            if result.affectedRows > 0 then
                Notify(source, {
                    type = 'success',
                    message = Config.Lang.InstallSuccess,
                })
                local removed = Framework.RemoveItem(source, Config.Items.Install[level].item, 1)
                if removed then
                    cb(true)
                else
                    Notify(source, {
                        type = 'error',
                        message = Config.Lang.InstallFailed,
                    })
                    cb(false)
                end
            end
        end)
    elseif Bridge.Framework == 'qb' or Bridge.Framework == 'qbox' then
        Database.query([[
            UPDATE player_vehicles SET HarnessInstalled = ? WHERE plate = ?
        ]], { level, plate }, function(result)
            if result.affectedRows > 0 then
                Notify(source, {
                    type = 'success',
                    message = Config.Lang.InstallSuccess,
                })
                local removed = Framework.RemoveItem(source, Config.Items.Install[level].item, 1)
                if removed then
                    cb(true)
                else
                    Notify(source, {
                        type = 'error',
                        message = Config.Lang.InstallFailed,
                    })
                    cb(false)
                end
            end
        end)
    else
        error('No Compatible Framework found by envi-bridge - Please install envi-bridge and use a compatible Framework as shown on documentation - alternatively, you can make your own edits to envi-hud/server/server_open.lua')
    end
end)

Framework.CreateCallback('envi-hud:uninstallHarness', function(source, cb, plate, level)
    if not isVehcileOwned(plate) then
        Notify(source, {
            type = 'error',
            message = Config.Lang.NotOwnedVehicle,
        })
        cb(false)
        return
    end
    if not hasItem(source, Config.Items.Uninstall) then
        Notify(source, {
            type = 'error',
            message = Config.Lang.NoUninstallItem,
        })
        cb(false)
        return
    end
    if Bridge.Framework == 'esx' then
        Database.query([[
            UPDATE owned_vehicles SET HarnessInstalled = 0 WHERE plate = ?
        ]], { plate }, function(result)
            if result.affectedRows > 0 then
                Notify(source, {
                    type = 'success',
                    message = Config.Lang.UninstallSuccess,
                })
                local removed = Framework.RemoveItem(source, Config.Items.Uninstall, 1)
                if removed then
                    Framework.AddItem(source, Config.Items.Install[level].item, 1)
                    cb(true)
                else
                    Notify(source, {
                        type = 'error',
                        message = Config.Lang.UninstallFailed,
                    })
                    cb(false)
                end
            else
                Notify(source, {
                    type = 'error',
                    message = Config.Lang.UninstallFailed,
                })
                cb(false)
            end
        end)
    elseif Bridge.Framework == 'qb' or Bridge.Framework == 'qbox' then
        Database.query([[
            UPDATE player_vehicles SET HarnessInstalled = 0 WHERE plate = ?
        ]], { plate }, function(result)
            if result.affectedRows > 0 then
                Notify(source, {
                    type = 'success',
                    message = Config.Lang.UninstallSuccess,
                })
                local removed = Framework.RemoveItem(source, Config.Items.Uninstall, 1)
                if removed then
                    Framework.AddItem(source, Config.Items.Install[level].item, 1)
                    cb(true)
                else
                    Notify(source, {
                        type = 'error',
                        message = Config.Lang.UninstallFailed,
                    })
                    cb(false)
                end
            else
                Notify(source, {
                    type = 'error',
                    message = Config.Lang.UninstallFailed,
                })
                cb(false)
            end
        end)
    else
        error('No Compatible Framework found by envi-bridge - Please install envi-bridge and use a compatible Framework as shown on documentation - alternatively, you can make your own edits to envi-hud/server/server_open.lua')
    end
end)

-- QB-HUD Compatibility 
RegisterNetEvent('hud:server:GainStress', function(amount)
    local player = Framework.GetPlayer(source)
    if not player then
        return
    end
    local currentStress = player.GetStatus('stress') or 0
    local newStress = math.min(100, currentStress + amount)
    player.SetStatus('stress', newStress)
    TriggerClientEvent('envi-hud:UpdateStress', source)
end)

RegisterNetEvent('hud:server:RelieveStress', function(amount)
    local player = Framework.GetPlayer(source)
    if not player then
        return
    end
    local currentStress = player.GetStatus('stress') or 0
    local newStress = math.max(0, currentStress - amount)
    player.SetStatus('stress', newStress)
    TriggerClientEvent('envi-hud:UpdateStress', source)
end)


RegisterNetEvent('envi-hud:combatLog', function()
    local player = Framework.GetPlayer(source)
    if not player then
        return
    end
    local playerName = player.Name..'(Character: '..player.Firstname..' '..player.Lastname..')'
    print('^7' .. playerName .. ' HAS LOGGED OUT DURING COMBAT!!  | Identifier: '..player.Identifier..' | Server ID: '..source)
end)

-- EXAMPLE COMMAND TO DISABLE ALL COMBAT IN THE SERVER
-- THIS IS ONLY AVAILIABLE TO FIRE FROM THE SERVER (TXADMIN) CONSOLE
RegisterCommand('DisableAllCombat', function(source)
    if source ~= 0 then
        print('This command can only be used from the server (TXADMIN) console')
        return
    end
    GlobalState.AllCombatDisabled = true
    print('Disabled All Combat: ' .. tostring(GlobalState.AllCombatDisabled))
    TriggerClientEvent('envi-hud:syncPlayers', -1, 'disable')
    local messageData = {
        type = 'error',
        message = Config.Lang.AllCombatDisabled,
        title = '[ATTENTION!]',
        duration = 60000
    }
    Wait(2000)
    Notify(-1, messageData)
end, false)

-- EXAMPLE COMMAND TO ENABLE ALL COMBAT IN THE SERVER
-- THIS IS ONLY AVAILIABLE TO FIRE FROM THE SERVER (TXADMIN) CONSOLE
RegisterCommand('EnableAllCombat', function(source)
    if source ~= 0 then
        print('This command can only be used from the server (TXADMIN) console')
        return
    end
    GlobalState.AllCombatDisabled = false
    TriggerClientEvent('envi-hud:syncPlayers', -1, 'enable')
    print('Re-Enabled All Combat')
    local messageData = {
        type = 'success',
        message = Config.Lang.AllCombatEnabled,
        title = '[ATTENTION!]',
        duration = 60000
    }
    Wait(2000)
    Notify(-1, messageData)
end, false)

-- EXAMPLE COMMAND TO DISABLE COMBAT FOR A PLAYER
-- THIS IS ONLY AVAILIABLE TO FIRE FROM THE SERVER (TXADMIN) CONSOLE
RegisterCommand('DisableCombat', function(source, args)
    local target = tonumber(args[1])
    if not target then
        print('Please provide a valid player ID')
        return
    end
    TriggerClientEvent('envi-hud:syncPlayers', target, 'disable')
    print('Disabled Combat for ID: ' .. target)
    local message = {
        type = 'error',
        message = Config.Lang.CombatDisabled,
        title = '[ATTENTION!]',
        duration = 60000
    }
    Wait(2000)
    Notify(target, message)
end, false)

-- EXAMPLE COMMAND TO ENABLE COMBAT FOR A PLAYER
-- THIS IS ONLY AVAILIABLE TO FIRE FROM THE SERVER (TXADMIN) CONSOLE
RegisterCommand('EnableCombat', function(source, args)
    local target = tonumber(args[1])
    if not target then
        print('Please provide a valid player ID')
        return
    end
    TriggerClientEvent('envi-hud:syncPlayers', target, 'enable')
    print('Re-Enabled Combat for ID: ' .. target)
    local message = {
        type = 'success',
        message = Config.Lang.CombatEnabled,
        title = '[ATTENTION!]',
        duration = 60000
    }
    Wait(2000)
    Notify(target, message)
end, false)

-- ValidateHudSettings - Will check that all the settings in envi_hud_settings_global are validated
RegisterCommand('ValidateHudSettings', function(source)
    if source ~= 0 then
        print('This command can only be used from the server (TXADMIN) console')
        return
    end
    print('[envi-hud] Starting validation of global HUD settings...')
    local result = Database.single([[SELECT settings, disabled_elements FROM envi_hud_settings_global]])
    if not result then
        print('[envi-hud] No global settings found in database')
        return
    end
    local globalSettingsValid = true
    local settingsData = nil
    if result.settings then
        local success, decodedSettings = pcall(function()
            return json.decode(result.settings)
        end)

        if success and decodedSettings then
            if ValidateHudSettingsServer(decodedSettings) then
                print('[envi-hud] Global settings structure: VALID')
                settingsData = decodedSettings
            else
                print('[envi-hud] Global settings structure: INVALID')
                globalSettingsValid = false
            end
        else
            print('[envi-hud] Global settings JSON decode: FAILED')
            globalSettingsValid = false
        end
    else
        print('[envi-hud] Global settings data: MISSING')
        globalSettingsValid = false
    end

    local disabledElementsValid = true
    if result.disabled_elements then
        local success, decodedDisabled = pcall(function()
            return json.decode(result.disabled_elements)
        end)

        if success and type(decodedDisabled) == 'table' then
            print('[envi-hud] Disabled elements structure: VALID')
        else
            print('[envi-hud] Disabled elements structure: INVALID')
            disabledElementsValid = false
        end
    else
        print('[envi-hud] Disabled elements data: MISSING (this is optional)')
    end

    if globalSettingsValid and disabledElementsValid then
        print('[envi-hud] VALIDATION RESULT: ALL GLOBAL SETTINGS ARE VALID ✓')
        print('[envi-hud] Theme: ' .. (settingsData and settingsData.theme or 'unknown'))
        print('[envi-hud] Minimap Type: ' .. (settingsData and settingsData.minimap and settingsData.minimap.type or 'unknown'))
        print('[envi-hud] Minimap Size: ' .. (settingsData and settingsData.minimap and settingsData.minimap.size or 'unknown'))
        if settingsData and settingsData.minimap and settingsData.minimap.buffer then
            print('[envi-hud] Minimap Buffer X: ' .. settingsData.minimap.buffer.x)
            print('[envi-hud] Minimap Buffer Y: ' .. settingsData.minimap.buffer.y)
        end
    else
        print('[envi-hud] VALIDATION RESULT: GLOBAL SETTINGS HAVE ISSUES ✗')
        print('[envi-hud] Use "FixHudSettings" command to attempt automatic repair')
    end
end, false)

-- FixHudSettings - Will validate and auto-delete any invalid entries in envi_hud_settings
RegisterCommand('FixHudSettings', function(source)
    if source ~= 0 then
        print('This command can only be used from the server (TXADMIN) console')
        return
    end
    print('[envi-hud] Starting automatic repair of HUD settings...')
    local globalResult = Database.single([[SELECT settings, disabled_elements FROM envi_hud_settings_global]])
    local globalFixed = false

    if globalResult then
        local settingsValid = false
        if globalResult.settings then
            local success, decodedSettings = pcall(function()
                return json.decode(globalResult.settings)
            end)

            if success and ValidateHudSettingsServer(decodedSettings) then
                settingsValid = true
            end
        end

        if not settingsValid then
            print('[envi-hud] Global settings invalid, clearing...')
            Database.query([[DELETE FROM envi_hud_settings_global WHERE id = 1]])
            globalFixed = true
        end
    end

    local playerResults = Database.query([[SELECT identifier, settings FROM envi_hud_settings]])
    local deletedCount = 0
    local totalCount = 0

    if playerResults then
        totalCount = #playerResults
        print('[envi-hud] Checking ' .. totalCount .. ' player settings...')

        for _, row in ipairs(playerResults) do
            local isValid = false

            if row.settings then
                local success, decodedSettings = pcall(function()
                    return json.decode(row.settings)
                end)

                if success and ValidateHudSettingsServer(decodedSettings) then
                    isValid = true
                end
            end

            if not isValid then
                print('[envi-hud] Deleting invalid settings for: ' .. row.identifier)
                Database.query([[DELETE FROM envi_hud_settings WHERE identifier = ?]], { row.identifier })
                deletedCount = deletedCount + 1
            end
        end
    end

    print('[envi-hud] ═══════════════════════════════════════')
    print('[envi-hud] REPAIR SUMMARY:')
    if globalFixed then
        print('[envi-hud] ✓ Global settings cleared (were invalid)')
    else
        print('[envi-hud] ✓ Global settings were valid or not present')
    end
    print('[envi-hud] ✓ Checked ' .. totalCount .. ' player settings')
    print('[envi-hud] ✓ Deleted ' .. deletedCount .. ' invalid entries')
    print('[envi-hud] ✓ ' .. (totalCount - deletedCount) .. ' valid entries remain')
    print('[envi-hud] ═══════════════════════════════════════')

    if deletedCount > 0 or globalFixed then
        print('[envi-hud] Players with deleted settings will get fresh defaults on next login')
        print('[envi-hud] Consider running "ValidateHudSettings" to verify the repair')
    else
        print('[envi-hud] No repairs were necessary - all settings were valid!')
    end
end, false)