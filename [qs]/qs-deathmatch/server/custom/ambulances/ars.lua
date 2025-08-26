if Config.Ambulance ~= 'ars' then return end

function RevivePlayer(src)
    for i = 1, 5 do
        TriggerClientEvent('ars_ambulancejob:healPlayer', src, {
            revive = true
        })
        Wait(500)
    end
end
