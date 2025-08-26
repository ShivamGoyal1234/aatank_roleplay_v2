if Config.HotKeys then
    if not Config.ControlerSupport then
        lib.addKeybind({
            name = 'engine',
            description = Lang('VEHICLEKEYS_ENGINE_TOGGLE'),
            defaultKey = Config.Controls.EngineControl,
            onPressed = function()
                toggleEngine()
            end
        })
    end

    lib.addKeybind({
        name = 'usekey',
        description = Lang('VEHICLEKEYS_USE_KEY'),
        defaultKey = Config.Controls.UseKey,
        onPressed = function()
            UseCommandKey()
        end
    })

    RegisterKeyMapping('hotwire', Lang('VEHICLEKEYS_HOTWIRE'), 'keyboard', Config.Controls.HotwireControl)

    if Config.AnchorKeybind then
        lib.addKeybind({
            name = 'anchor',
            description = Lang('VEHICLEKEYS_ANCHOR_BOAT'),
            defaultKey = '',
            onPressed = function()
                ExecuteCommand('anchor')
            end
        })
    end
end

RegisterCommand('usekey', function()
    UseCommandKey()
end, false)

RegisterCommand('hotwire', function()
    HandleHotwireProcess()
end, false)
