local YourWebhook = 'WEBHOOK-HERE'  -- help: https://docs.brutalscripts.com/site/others/discord-webhook

function GetWebhook()
    return YourWebhook
end

RegisterServerEvent("brutal_atm_robbery:server:PoliceAlert")
AddEventHandler("brutal_atm_robbery:server:PoliceAlert", function(coords)
    local source = source
	local xPlayers = GetPlayersFunction()
	
	for i=1, #xPlayers, 1 do
        for ii=1, #Config.CopJobs do
            if GetPlayerJobFunction(xPlayers[i]) == Config.CopJobs[ii] then
            TriggerClientEvent("brutal_atm_robbery:client:PoliceAlertBlip", xPlayers[i], coords)
            end
        end
    end
end)