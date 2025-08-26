if Config.Appearance ~= 'illenium' then return end

Debug('clothes:illenium', 'Using Illenium appearance system')
function SaveCurrentClothing()
    local appearance = exports['illenium-appearance']:getPedAppearance(PlayerPedId())
    TriggerServerEvent('illenium-appearance:server:saveAppearance', appearance)
    Debug('clothes:SaveCurrentClothing', 'Saving current clothing')
end
