if Config.Ambulance ~= 'qb' then return end

function RevivePlayer(src)
    TriggerClientEvent('hospital:client:Revive', src)
end
