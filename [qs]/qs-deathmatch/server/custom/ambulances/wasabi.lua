if Config.Ambulance ~= 'wasabi' then return end

function RevivePlayer(src)
    TriggerClientEvent('wasabi_ambulance:revive', src)
end
