-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

-- Customize this to customize notifications accross all Wasabi Scripts

-- Notifications
function WSB.showNotification(title, desc, style, icon, id)
    if GetResourceState('ox_lib') == 'started' then -- If using ox_lib and not wasabi_notfy automatic detection
        if style == 'info' then style = 'inform' end
        exports.ox_lib:notify({
            title = title,
            description = desc or false,
            id = id or false,
            position = 'top-right',
            icon = icon or false,
            duration = 3500,
            type = style or 'inform'
        })
        return
    end                                                     --

    return ShowNotification(title, desc, style, icon, id) -- Default bridge built-in notification system

    -- Edit Code above to use your own notification system
end

RegisterNetEvent('wasabi_bridge:notify', function(title, desc, style, icon, id)
    return WSB.showNotification(title, desc, style, icon, id)
end)

exports('showNotification', WSB.showNotification) -- Export for use in other scripts
