if Config.framework == 'esx' then
    lib.callback.register('mt_dealerships:server:getPlayerJobESX', function(source)
        local src = source
        local Player = Config.core.GetPlayerFromId(src)
        if not Player then return end
        return Player.getJob().name
    end)

    lib.callback.register('mt_dealerships:server:getPlayerJobIsBossESX', function(source)
        local src = source
        local Player = Config.core.GetPlayerFromId(src)
        if not Player then return end
        return (Player.getJob().grade_name == 'boss')
    end)
end