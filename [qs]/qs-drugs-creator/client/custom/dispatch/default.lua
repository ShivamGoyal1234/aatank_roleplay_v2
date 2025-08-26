if Config.Dispatch ~= 'default' then return end

-- CLIENT SIDE TRIGGER // If use Config.Dispatch = 'client'
function DispatchNotify(coords)
    --[[
	Codesing Dispatch Exmaple:

		local data = exports['cd_dispatch']:GetPlayerInfo()
		TriggerServerEvent('cd_dispatch:AddNotification', {
			job_table = {'police'},
			coords = data.coords,
			title = '10-15 - Drug sell',
			message = 'A '..data.sex..' is selling drug in '..data.street,
			flash = 0,
			unique_id = tostring(math.random(0000000,9999999)),
			blip = {
				sprite = 431,
				scale = 1.2,
				colour = 3,
				flashes = false,
				text = '911 - Drug',
				time = (5*60*1000),
				sound = 1,
			}
		})
	]]
end

-- -- SERVER SIDE TRIGGER // If use Config.Dispatch = 'server'
-- RegisterNetEvent('drugs:server:NotifyCops')
-- AddEventHandler('drugs:server:NotifyCops', function(coords)
--     --[[
-- 		ADD YOUR DISPATCH HERE:

-- 		if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
-- 			street = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
-- 			street2 = GetStreetNameFromHashKey(street)
--         	Notification(Lang("DRUGS_NOTIFICATION_POLICE_NOTIFY")..street2, 'info')

-- 			blipcops = AddBlipForCoord(coords.x, coords.y, coords.z)
-- 			SetBlipSprite(blipcops,  Config.PoliceBlip.sprite)
-- 			SetBlipColour(blipcops,  Config.PoliceBlip.colour)
-- 			SetBlipAlpha(blipcops, Config.PoliceBlip.alpha)
-- 			SetBlipScale(blipcops, Config.PoliceBlip.scale)
-- 			BeginTextCommandSetBlipName("STRING")
-- 			AddTextComponentString(Config.PoliceBlip.name)
-- 			EndTextCommandSetBlipName(blipcops)
--         	Wait(35000)
--         	RemoveBlip(blipcops)
-- 		end
-- 	]]
-- end)
