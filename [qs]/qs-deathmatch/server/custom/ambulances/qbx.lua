if Config.Ambulance ~= 'qbx' then return end

function RevivePlayer(src)
    TriggerClientEvent('qbx_medical:client:playerRevived', src)
end
