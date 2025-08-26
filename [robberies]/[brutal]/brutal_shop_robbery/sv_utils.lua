local YourWebhook = 'WEBHOOK-HERE'  -- help: https://docs.brutalscripts.com/site/others/discord-webhook

function GetWebhook()
    return YourWebhook
end

function PlayerNameFunction(source)
    return GetPlayerName(source)
end

RegisterServerEvent('brutal_shop_robbery:server:PoliceAlert')
AddEventHandler('brutal_shop_robbery:server:PoliceAlert', function(coords, index)
    local Players = GetPlayersFunction()
	for i = 1, #Players do
        for ii=1, #Config.CopsJobs do
            if GetPlayerJobFunction(Players[i]) == Config.CopsJobs[ii] then
                TriggerClientEvent('brutal_shop_robbery:client:PoliceAlert', Players[i], coords, index)
             end
         end
	end
end)