RegisterNetEvent('fd-megaphones:server:addsubmix', function(source)
	TriggerClientEvent('fd-megaphones:client:addsubmix', -1, source)
end)

RegisterNetEvent('fd-megaphones:server:removesubmix', function(source)
	TriggerClientEvent('fd-megaphones:client:removesubmix', -1, source)
end)

-- Version Check

lib.versionCheck('FD-Scripts/fd-megaphones')