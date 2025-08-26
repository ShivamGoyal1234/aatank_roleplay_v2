if Config.Ambulance ~= 'esx' then return end

function RevivePlayer(src)
    TriggerClientEvent('esx_ambulancejob:revive', src)
end
