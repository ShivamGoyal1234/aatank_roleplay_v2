if Config.Framework == 'esx' then
    ESX.RegisterCommand(Lang("ADMINCOMMAND_COMMAND"), Lang("ADMINCOMMAND_RANGE"), function(xPlayer, args, showError)
        if args.playerId then 
            local target = args.playerId == "me" and xPlayer.source or args.playerId
            local PedVehicle = GetVehiclePedIsIn(GetPlayerPed(xPlayer.source), false)
      
            if DoesEntityExist(PedVehicle) then
                local plate = GetVehicleNumberPlateText(PedVehicle)
                local model = GetEntityModel(PedVehicle)
                TriggerClientEvent(Config.Eventprefix..":client:sendMessage", xPlayer.source, Lang("ADMINCOMMAND_GIVED_VEHICLE"), "success")
                target.triggerEvent(Config.Eventprefix..":admin:giveKeys", plate, model, true)
            else
                TriggerClientEvent(Config.Eventprefix..":client:sendMessage", src, Lang("ADMINCOMMAND_NO_VEHICLE"), "error")
            end
        else
            TriggerClientEvent(Config.Eventprefix..":client:sendMessage", xPlayer.source, Lang("ADMINCOMMAND_NO_PLAYER"), "success")
        end
    end, false, {help = Lang("ADMINCOMMAND_HELP"), validate = true, arguments = {
        {name = 'playerId', validate = true, help = Lang("ADMINCOMMAND_PLAYER"), type = 'player'}
    }})
    
elseif Config.Framework == 'qb' then
    QBCore.Commands.Add(Lang("ADMINCOMMAND_COMMAND"), Lang("ADMINCOMMAND_HELP"), { { name = Lang("ADMINCOMMAND_PLAYER"), help = Lang("ADMINCOMMAND_PLAYER") } }, true, function(source, args)
        local target = args[1] == "me" and source or tonumber(args[1])
        if target ~= 0 then
            local PedVehicle = GetVehiclePedIsIn(GetPlayerPed(source), false)
   
            if DoesEntityExist(PedVehicle) then
                local plate = GetVehicleNumberPlateText(PedVehicle)
                local model = GetEntityModel(PedVehicle)
        
                TriggerClientEvent(Config.Eventprefix..":client:sendMessage", source, Lang("ADMINCOMMAND_GIVED_VEHICLE"), "success")
                TriggerClientEvent(Config.Eventprefix..":admin:giveKeys", target, plate, model, true)
            else
                TriggerClientEvent(Config.Eventprefix..":client:sendMessage", source, Lang("ADMINCOMMAND_NO_VEHICLE"), "error")
            end
        else
            TriggerClientEvent(Config.Eventprefix..":client:sendMessage", source, Lang("ADMINCOMMAND_NO_PLAYER"), "success")
        end
    end, Lang("ADMINCOMMAND_RANGE"))
elseif Config.Framework == 'qbx' then
    lib.addCommand(Lang("ADMINCOMMAND_COMMAND"), {
        help = Lang("ADMINCOMMAND_HELP"),
        params = {
            { name = Lang("ADMINCOMMAND_PLAYER"), help = Lang("ADMINCOMMAND_PLAYER"), optional = true },
        },
        restricted = 'group.admin'
    }, function(source, args)
        local target = args[1] == "me" and source or tonumber(args[1])
        if target == nil then
            target = source
        end
        if target ~= 0 then
            local PedVehicle = GetVehiclePedIsIn(GetPlayerPed(source), false)
    
            if DoesEntityExist(PedVehicle) then
                local plate = GetVehicleNumberPlateText(PedVehicle)
                local model = GetEntityModel(PedVehicle)
        
                TriggerClientEvent(Config.Eventprefix..":client:sendMessage", source, Lang("ADMINCOMMAND_GIVED_VEHICLE"), "success")
                TriggerClientEvent(Config.Eventprefix..":admin:giveKeys", target, plate, model, true)
            else
                TriggerClientEvent(Config.Eventprefix..":client:sendMessage", source, Lang("ADMINCOMMAND_NO_VEHICLE"), "error")
            end
        else
            TriggerClientEvent(Config.Eventprefix..":client:sendMessage", source, Lang("ADMINCOMMAND_NO_PLAYER"), "success")
        end
    end)
end