-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
if not wsb then return print((Strings.no_wsb):format(GetCurrentResourceName())) end

function HideDeathNui()
	IsDispatched = false
	SendNUIMessage({ action = 'hideDeathScreen' })
end

function JobArrayToTarget(includeOffDuty)
	local data = {}
	for i = 1, #Config.ambulanceJobs do
		data[Config.ambulanceJobs[i]] = 0
	end
	if wsb.framework == 'esx' and includeOffDuty then
		for i = 1, #Config.ambulanceJobs do
			data['off' .. Config.ambulanceJobs[i]] = 0
		end
	end
	return data
end

function IsVehicleAmbulance(vehicle)
	if not vehicle then return false end
	local model = GetEntityModel(vehicle)
	for ambulanceModel, _ in pairs(Config.AmbulanceOffsets) do
		if model == GetHashKey(ambulanceModel) then
			return true
		end
	end
	return false
end

function CapitalizeEachWord(str)
	return (str:gsub("(%l)(%w*)", function(firstLetter, restOfString)
		return firstLetter:upper() .. restOfString:lower()
	end))
end

CreateBlip = function(output, sprite, color, text, scale, flash, type, short)
	type = type or 'coords'
	local blip
	if type == 'coords' then
		local x, y, z = table.unpack(output)
		blip = AddBlipForCoord(x, y, z)
	elseif type == 'entity' then
		blip = AddBlipForEntity(output)
	end

	SetBlipSprite(blip, sprite)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, scale)
	SetBlipColour(blip, color)
	SetBlipAsShortRange(blip, short)
	SetBlipFlashes(blip, flash)

	local blipStr = ('hospital_%s'):format(tostring(blip))
	AddTextEntry(blipStr, text)
	BeginTextCommandSetBlipName(blipStr)
	EndTextCommandSetBlipName(blip)

	return blip
end

addCommas = function(n)
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)", "%1,")
		:gsub(",(%-?)$", "%1"):reverse()
end

secondsToClock = function(seconds)
	seconds = tonumber(seconds)
	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format('%02.f', math.floor(seconds / 3600))
		local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))
		return mins, secs
	end
end

isPlayerDead = function(serverId)
	local playerDead
	if not serverId then
		playerDead = isDead or false
	else
		playerDead = Player(serverId).state.dead and true or false
	end
	return playerDead
end

exports('isPlayerDead', isPlayerDead)

RespawnPed = function(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
	SetEntityInvincible(ped, false)
	ClearPedBloodDamage(ped)
	local playerId = PlayerId()
	if GetPlayerInvincible(playerId) then SetPlayerInvincible(playerId, false) end
	TriggerEvent('wasabi_ambulance:customInjuryClear')
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	if wsb.framework == 'esx' then
		TriggerEvent('esx:onPlayerSpawn')
	else
		TriggerEvent('wasabi_bridge:onPlayerSpawn')
	end
	if wsb.framework == 'qb' and wsb.playerData.metadata.injail > 0 then
		TriggerEvent("prison:client:Enter", wsb.playerData.metadata.injail)
	end
end

getClosestHospital = function(coords)
	local closestHospital
	local done
	for k, v in pairs(Config.Locations) do
		if not closestHospital then
			closestHospital = k
		else
			local oldCoords = Config.Locations[closestHospital].RespawnPoint.coords
			local newCoords = v.RespawnPoint.coords
			local oldDist = #(vector3(coords.x, coords.y, coords.z) - oldCoords)
			local newDist = #(vector3(coords.x, coords.y, coords.z) - newCoords)
			if newDist < oldDist then
				closestHospital = k
			end
		end
	end
	return closestHospital
end

StartRPDeath = function()
	DoScreenFadeOut(800)
	while not IsScreenFadedOut() do
		Wait(100)
	end
	if wsb.framework == 'esx' then ESX.SetPlayerData('loadout', {}) end
	local closestHospital = getClosestHospital(GetEntityCoords(wsb.cache.ped))
	if Config.removeItemsOnDeath then
		TriggerServerEvent('wasabi_ambulance:removeItemsOnDeath')
	end
	HideDeathNui()
	DrugIntake = {}
	CreateThread(function()
		if wsb.framework == 'esx' then
			TriggerEvent('esx:onPlayerSpawn', true)
		else
			TriggerEvent('wasabi_bridge:onPlayerSpawn', true)
			TriggerServerEvent('wasabi_ambulance:resetThirstHunger')
		end
	end)
	if Config.CheckIfJailed.enabled then 
		if isPlayerInJail() then AttemptCheckIn('standalone', Config.CheckIfJailed.location) return end -- If player is in jail, respawn them in jail
	end
	Wait(1500)
	AttemptCheckIn(closestHospital, false, true, false, true)
end

-- Last Stand
local isCrawling, crwl = false, 'onfront'

local function movePedHeading(p, a, t)
	local ts = math.abs(a)
	local te = a / ts
	local w = t / ts
	for _i = 1, ts do
		Wait(w)
		SetEntityHeading(p, GetEntityHeading(p) + te)
	end
end

local function playAnimOnce(ped, animDict, animName, blendInSpeed, blendOutSpeed, duration, startTime)
	wsb.stream.animDict(animDict)
	TaskPlayAnim(ped, animDict, animName, blendInSpeed or 2.0, blendOutSpeed or 2.0, duration or -1, 0, startTime or 0.0,
		false, false, false)
	RemoveAnimDict(animDict)
end

local function lastStandCrawl(ped, crawl, d)
	isCrawling = true
	TaskPlayAnim(ped, "move_crawl", crawl .. "_" .. d, 8.0, -8.0, -1, 2, 0.0, false, false, false)
	local timeout = {
		["onfront"] = {
			["fwd"] = 820,
			["bwd"] = 990
		},
		["onback"] = {
			["fwd"] = 1200,
			["bwd"] = 1200
		}
	}
	SetTimeout(timeout[crawl][d], function()
		isCrawling = false
	end)
end

local function playIdleCrawlAnim(ped, heading, blend)
	local playerCoords = GetEntityCoords(ped)
	TaskPlayAnimAdvanced(ped, "move_crawl", crwl .. "_fwd", playerCoords.x, playerCoords.y, playerCoords.z, 0.0, 0.0,
		heading or GetEntityHeading(ped), blend or 2.0, 2.0, -1, 2, 1.0, false, false)
end

local function crawlFlip(ped)
	local heading = GetEntityHeading(ped)
	if crwl == "onfront" then
		crwl = "onback"
		playAnimOnce(ped, "get_up@directional_sweep@combat@pistol@front", "front_to_prone", 2.0)
		movePedHeading(ped, -18.0, 3600)
	else
		crwl = "onfront"

		playAnimOnce(ped, "move_crawlprone2crawlfront", "back", 2.0, nil, -1)
		movePedHeading(ped, 12.0, 1700)
	end

	playIdleCrawlAnim(ped, heading + 180.0)
	Wait(400)
end

local function startLastStandAnim()
	if wsb.framework == 'esx' then ESX.UI.Menu.CloseAll() end
	StartDeathTimer()
	while IsPedRagdoll(wsb.cache.ped) or GetEntitySpeed(wsb.cache.ped) > 0.5 do Wait(5) end
	while not DoesEntityExist(wsb.cache.ped) do Wait(500) end
	if IsPedDeadOrDying(wsb.cache.ped, false) then
		local coords = GetEntityCoords(wsb.cache.ped)
		local heading = GetEntityHeading(wsb.cache.ped)
		NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	end
	if GetEntityHealth(wsb.cache.ped) < 200 then SetEntityHealth(wsb.cache.ped, 200) end
	--if wsb.cache.vehicle and wsb.cache.seat then SetPedIntoVehicle(wsb.cache.ped, wsb.cache.vehicle, wsb.cache.seat) end
	TriggerEvent('wasabi_ambulance:resetStatus')
	wsb.stream.animDict('combat@damage@writhe')
	wsb.stream.animDict('move_crawl')
	wsb.stream.animDict('move_crawlprone2crawlfront')
	CreateThread(function()
		while true do
			Wait(500)
			::startover::
			if not DoesEntityExist(wsb.cache.ped) then goto startover end
			if isDead ~= 'laststand' then break end
			if not OccupyingStretcher and not IsCheckedIn then
				local currentHealth = GetEntityHealth(wsb.cache.ped)
				local decreaseThreshold = math.random(8, 15)
				SetEntityHealth(wsb.cache.ped, currentHealth - decreaseThreshold)
			end
			Wait(Config.LastStandTickTime)
		end
	end)
	while true do
		if isDead ~= 'laststand' then
			crwl = 'onfront'
			break
		end
		if IsCheckedIn
			or IsEntityPlayingAnim(wsb.cache.ped, 'nm', 'firemans_carry', 3)
			or OccupyingStretcher
			or IsPedInAnyVehicle(wsb.cache.ped, false) then
			Wait(2000)
		else
			local forward, backwards = IsControlPressed(0, 32), IsControlPressed(0, 33)
			local left, right = IsControlPressed(0, 34), IsControlPressed(0, 35)
			if not isCrawling then
				if forward then
					lastStandCrawl(wsb.cache.ped, crwl, "fwd")
				elseif backwards then
					lastStandCrawl(wsb.cache.ped, crwl, "bwd")
				end
			end
			if left then
				if isCrawling then
					local headingDiff = forward and 1.0 or -1.0
					SetEntityHeading(wsb.cache.ped, GetEntityHeading(wsb.cache.ped) + headingDiff)
				else
					if crwl == "onfront" then
						local playerCoords = GetEntityCoords(wsb.cache.ped)
						TaskPlayAnimAdvanced(wsb.cache.ped, "move_crawlprone2crawlfront", "left", playerCoords.x,
							playerCoords.y, playerCoords.z, 0.0, 0.0, GetEntityHeading(wsb.cache.ped), 2.0, 2.0, -1, 2,
							0.1,
							false, false)
						movePedHeading(wsb.cache.ped, -10.0, 300)
						Wait(700)
					else
						playAnimOnce(wsb.cache.ped, "get_up@directional_sweep@combat@pistol@left", "left_to_prone")
						movePedHeading(wsb.cache.ped, 25.0, 400)
						playIdleCrawlAnim(wsb.cache.ped)
						Wait(600)
					end
				end
			elseif right then
				if isCrawling then
					local headingDiff = backwards and 1.0 or -1.0
					SetEntityHeading(wsb.cache.ped, GetEntityHeading(wsb.cache.ped) + headingDiff)
				else
					if crwl == "onfront" then
						local playerCoords = GetEntityCoords(wsb.cache.ped)
						TaskPlayAnimAdvanced(wsb.cache.ped, "move_crawlprone2crawlfront", "right", playerCoords.x,
							playerCoords.y, playerCoords.z, 0.0, 0.0, GetEntityHeading(wsb.cache.ped), 2.0, 2.0, -1, 2,
							0.1,
							false, false)
						movePedHeading(wsb.cache.ped, 10.0, 300)
						Wait(700)
					else
						playAnimOnce(wsb.cache.ped, "get_up@directional_sweep@combat@pistol@right", "right_to_prone")
						movePedHeading(wsb.cache.ped, -25.0, 400)
						playIdleCrawlAnim(wsb.cache.ped)
						Wait(600)
					end
				end
			end
			if not isCrawling then
				if IsControlPressed(0, 22) then
					crawlFlip(wsb.cache.ped)
				end
				if crwl == 'onfront' and not IsEntityPlayingAnim(wsb.cache.ped, 'combat@damage@writhe', 'writhe_loop', 3) then
					local playerCoords = GetEntityCoords(wsb.cache.ped)
					TaskPlayAnimAdvanced(wsb.cache.ped, "combat@damage@writhe", "writhe_loop", playerCoords.x,
						playerCoords
						.y, playerCoords.z, 0.0, 0.0, GetEntityHeading(wsb.cache.ped) / 2, 8.0, 8.0, -1, 3, 0, false,
						false)
				end
			end
			Wait(0)
		end
	end
end

function OnLastStand()
	if isDead then
		OnPlayerDeath(true)
		return
	end
	isDead = 'laststand'
	TriggerServerEvent('wasabi_ambulance:setDeathStatus', 'laststand', true)
	DrugIntake = {}
	ResetAnimation()
	startLastStandAnim()
end

function ResetAnimation()
	if not Config.EnableAnimReset then return end
	CreateThread(function()
		while isDead do
			Wait(30000)
			ClearPedTasks(wsb.cache.ped)
		end
	end)
end

startDeathAnimation = function(dead)
	if Config.DisableDeathAnimation then return end
	while not DoesEntityExist(wsb.cache.ped) do Wait(500) end

	while IsPedRagdoll(wsb.cache.ped) or GetEntitySpeed(wsb.cache.ped) > 0.5 do Wait(5) end
	while not DoesEntityExist(wsb.cache.ped) do Wait(500) end

	if IsPedDeadOrDying(wsb.cache.ped, false) then
		local coords = GetEntityCoords(wsb.cache.ped)
		local heading = GetEntityHeading(wsb.cache.ped)
		NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	end
	if GetEntityHealth(wsb.cache.ped) < 200 then SetEntityHealth(wsb.cache.ped, 200) end
	if Config.StayInVehicleOnDeath ~= false and wsb.cache.vehicle and wsb.cache.seat then
		SetPedIntoVehicle(wsb.cache.ped,
			wsb.cache.vehicle, wsb.cache.seat)
	end
	TriggerEvent('wasabi_ambulance:resetStatus')
	wsb.stream.animDict(Config.DeathAnimation.anim)
	wsb.stream.animDict('veh@bus@passenger@common@idle_duck')
	ClearPedTasks(wsb.cache.ped)
	TaskPlayAnim(wsb.cache.ped, Config.DeathAnimation.anim, Config.DeathAnimation.lib, 8.0, 8.0, -1, 3, 0, false, false,
		false)
	if not dead then
		local playerId = PlayerId()
		CreateThread(function()
			while true do
				if not isDead then
					if GetPlayerInvincible(playerId) then
						SetPlayerInvincible(playerId, false)
					end
					if not Config.EnviMedic.enabled then
						ClearPedTasks(wsb.cache.ped)
					end
					break
				end
				local sleep = 1500
				if not GetPlayerInvincible(playerId) then
					SetPlayerInvincible(playerId, true)
				end
				if IsPedInAnyVehicle(wsb.cache.ped, false) then
					if not IsEntityPlayingAnim(wsb.cache.ped, 'veh@bus@passenger@common@idle_duck', 'sit', 3) then
						sleep = 0
						ClearPedTasks(wsb.cache.ped)
						TaskPlayAnim(wsb.cache.ped, 'veh@bus@passenger@common@idle_duck', 'sit', 8.0, -8, -1, 2, 0, false,
							false, false)
					end
				else
					if not IsEntityPlayingAnim(wsb.cache.ped, Config.DeathAnimation.anim, Config.DeathAnimation.lib, 3) then
						if not IsEntityPlayingAnim(wsb.cache.ped, 'nm', 'firemans_carry', 33)
							and not IsEntityPlayingAnim(wsb.cache.ped, 'anim@gangops@morgue@table@', 'body_search', 33) -- If on the stretcher
							and not OccupyingStretcher                                                                  -- If on the stretcher
							and not IsEntityPlayingAnim(wsb.cache.ped, 'anim@arena@celeb@flat@paired@no_props@', 'piggyback_c_player_b', 33) -- If being /piggyback
							and not IsCheckedIn then                                                                    -- If player is checked in to hospital
							sleep = 0
							ClearPedTasks(wsb.cache.ped)
							TaskPlayAnim(wsb.cache.ped, Config.DeathAnimation.anim, Config.DeathAnimation.lib, 8.0, 8.0,
								-1,
								3, 0, false, false, false)
						end
					end
				end
				Wait(sleep)
			end
		end)
	end
	RemoveAnimDict(Config.DeathAnimation.anim)
	RemoveAnimDict('veh@bus@passenger@common@idle_duck')
end

setRoute = function(data)
	local coords = wsb.awaitServerCallback('wasabi_ambulance:getDeathPos', data.plyId)
	SetNewWaypoint(coords.x, coords.y)
	TriggerEvent('wasabi_bridge:notify', Strings.route_set_title, Strings.route_set_desc, 'success', 'location-dot')
end

function GetSeverityString(level)
	local levels = {
		[0] = Strings.none,
		[1] = Strings.mild,
		[2] = Strings.moderate,
		[3] = Strings.severe,
		[4] = Strings.deadly
	}
	if level > 4 then level = 4 end
	return levels[level]
end

---@param servId number for checking player state
local function formatDeathInjuryReport(data, servId)
	local baseBPM = 70.0
	local bpmModifier = 0.0
	local bleedRate = 'none'

	if data.location == 'UNKNOWN' then
		bpmModifier = 0.0
		baseBPM = 0.0
	elseif data.location == 'head' then
		if data.injury == 'shot' or data.injury == 'stabbed' then
			bpmModifier = 0.0
			baseBPM = 0.0
			bleedRate = 'high'
		else
			bpmModifier = -30.0
		end
	else
		if data.injury == 'shot' then
			bpmModifier = 50.0
			if data.location == 'upper_body' or data.location == 'left_arm' or data.location == 'right_arm' or data.location == 'spine' then
				bleedRate = 'high'
			else
				bleedRate = 'medium'
			end
		elseif data.injury == 'stabbed' then
			bpmModifier = 40.0
			bleedRate = 'medium'
		elseif data.injury == 'beat' then
			bpmModifier = 20.0
			bleedRate = 'none'
		elseif data.injury == 'burned' then
			bpmModifier = 30.0
			bleedRate = 'none'
		end
	end

	local pulse = baseBPM + bpmModifier + math.random(-5.0, 5.0)
	pulse = math.floor(pulse * 100 + 0.5) / 100.0
	if pulse < 12 then pulse = 0 end
	if Player(servId).state.dead == 'dead' then pulse = 0 end

	if data.location == 'nothing' or data.location == 'none' then data.location = 'upper_body' end
	if data.location == 'upper_body' then data.location = 'upper' end
	if data.location == 'lower_body' then data.location = 'lower' end

	local options = {
		{
			title = Strings.full_name,
			description = data.name,
			icon = 'user',
		},
		{
			title = Strings.pulse,
			description = (Strings.bpm):format(pulse),
			icon = 'heart-pulse'
		},
		{
			title = Strings.bleed_rate,
			description = Strings['bleed_rate_' .. bleedRate] or Strings.none,
			icon = 'droplet'
		},
		{
			title = Strings.possible_cause,
			description = CapitalizeEachWord(Strings[data.injury] or Strings.other),
			icon = 'bandage',
		},
		{
			title = Strings.injury_report_locations,
			description = CapitalizeEachWord(Strings['ply_injury_' .. data.location] or Strings.other),
			icon = 'map-marker-alt',
		}
	}

	return options
end


local function formatInjuryReport(plyInjuries)
	if not plyInjuries or not plyInjuries.injury or not next(plyInjuries.injury) then
		return false
	end
	local blood = 0
	local bpm = 70.0        -- Starting BPM for a healthy, resting adult
	local maxBpmIncrease = 100 -- Maximum possible BPM increase due to injuries

	local options = {
		{
			title = Strings.full_name,
			description = plyInjuries.name,
			icon = 'user',
		},
		{
			title = Strings.pulse,
			description = '',
			icon = 'heart-pulse',
			iconAnimation = 'beat'

		},
		{
			title = Strings.injury_report_bleed,
			description = '',
			icon = 'droplet',

		},
		{
			title = Strings.injuries,
			description = '',
			icon = 'angles-down',
		}
	}

	for k, injury in pairs(plyInjuries.injury) do
		local severity = injury.data.level
		local percent = (severity / 4) * 100
		local injuryBpmIncrease = (maxBpmIncrease / 4) * severity

		bpm = bpm + injuryBpmIncrease
		if bpm > 180 then bpm = 180 end

		options[#options + 1] = {
			title = CapitalizeEachWord(injury.data.label),
			description = (Strings.injury_report_type):format(CapitalizeEachWord(Strings[injury.type])),
			progress = percent,
			icon = 'file-waveform',
			arrow = false,
		}

		if injury.type == 'shot' or injury.type == 'stabbed' and injury.data.bleed then
			blood = blood + injury.data
				.bleed
		end
	end

	if bpm < 12 then bpm = 0 end

	options[2].description = (Strings.bpm):format(math.floor(bpm))

	if blood > 4 then blood = 4 end
	local bloodPercent = (blood / 4) * 100
	options[3] = {
		title = Strings.injury_report_bleed,
		description = (Strings.injury_report_severity):format(GetSeverityString(blood)),
		progress = bloodPercent,
		icon = 'droplet',
		arrow = false,
	}

	return options
end


---@param targetPlayer boolean | number | nil
diagnosePlayer = function(targetPlayer)
	if isPlayerDead() then return end
	local player = targetPlayer or (wsb.getClosestPlayer(GetEntityCoords(wsb.cache.ped), 4.0))
	if targetPlayer == true then
		player = wsb.cache.serverId
	end
	if not player then
		TriggerEvent('wasabi_bridge:notify', Strings.no_nearby, Strings.no_nearby_desc, 'error')
		return
	end
	if type(targetPlayer) ~= 'nil' then
		local injuryData = wsb.awaitServerCallback('wasabi_ambulance:diagnosePlayer', player)
		return injuryData
	end
	local targetPed = GetPlayerPed(player)
	local tCoords = GetEntityCoords(targetPed)
	TaskTurnPedToFaceCoord(wsb.cache.ped, tCoords.x, tCoords.y, tCoords.z, 3000)
	Wait(1000)
	local progressUI
	if Config.ProgressCircle then progressUI = 'progressCircle' else progressUI = 'progressBar' end
	local servId = GetPlayerServerId(player)
	local plyInjury = wsb.awaitServerCallback('wasabi_ambulance:diagnosePlayer', servId)
	local flag = 49
	if plyInjury and plyInjury.location then flag = 0 end
	if wsb.progressUI({
			duration = Config.DiagnoseTime,
			label = Strings.diagnosing_patient_progress,
			position = Config.ProgressCircleLocation,
			useWhileDead = false,
			canCancel = true,
			disable = {
				car = true,
				move = true
			},
			anim = {
				dict = 'random@train_tracks',
				clip = 'idle_e',
				flag = flag
			},
			color = Config.UIColor 
		}, progressUI) then
		if not plyInjury then
			local message = Config.EnableLiveInjury and { Strings.no_injury, Strings.no_injury_desc } or
			{ Strings.player_not_unconscious, Strings.player_not_unconscious_desc }
			TriggerEvent('wasabi_bridge:notify', message[1], message[2], 'inform', 'stethoscope')
			return
		end

		local options = {}

		if plyInjury.location then
			options = formatDeathInjuryReport(plyInjury, servId) or {}
		else
			options = formatInjuryReport(plyInjury) or {}
		end

		if not next(options) then
			TriggerEvent('wasabi_bridge:notify', Strings.no_injury, Strings.no_injury_desc, 'inform',
				'stethoscope')
			return
		end

		wsb.showContextMenu({
			id = 'ems_diagnose_menu',
			color = Config.UIColor,
			title = Strings.injury_report,
			options = options
		})
	else
		TriggerEvent('wasabi_bridge:notify', Strings.action_cancelled, Strings.action_cancelled_desc, 'error')
	end
end

exports('diagnosePlayer', diagnosePlayer)


reviveTarget = function()
	if isPlayerDead() then return end
	local authorized = false
	local jobCheck = wsb.playerData.job.name
	if Config?.policeCanTreat?.enabled then
		for i = 1, #Config.policeCanTreat.jobs do
			if Config.policeCanTreat.jobs[i] == jobCheck then
				authorized = true
			end
		end
	end
	if authorized or wsb.hasGroup(Config.ambulanceJobs or Config.ambulanceJob) then
		local coords = GetEntityCoords(wsb.cache.ped)
		local player = wsb.getClosestPlayer(vec3(coords.x, coords.y, coords.z), 3.0)
		if not player then
			TriggerEvent('wasabi_bridge:notify', Strings.no_nearby, Strings.no_nearby_desc, 'error')
		elseif not isBusy then
			local quantity = wsb.awaitServerCallback('wasabi_ambulance:itemCheck', Config.EMSItems.revive.item)
			if quantity > 0 then
				local targetId = GetPlayerServerId(player)
				local isPlyDead = wsb.awaitServerCallback('wasabi_ambulance:isPlayerDead', targetId)
				if isPlyDead then
					isBusy = true
					local ped = wsb.cache.ped
					wsb.stream.animDict('mini@cpr@char_a@cpr_str')
					TriggerEvent('wasabi_bridge:notify', Strings.player_reviving, Strings.player_reviving_desc, 'success')
					local targetPed = GetPlayerPed(player)
					local tCoords = GetEntityCoords(targetPed)
					TaskTurnPedToFaceCoord(ped, tCoords.x, tCoords.y, tCoords.z, 3000)
					disableKeys, isReviving = true, true

					Wait(3000)
					local iterations = math.floor(Config.ReviveTime / 900)
					for i = 1, iterations do
						Wait(900)
						TaskPlayAnim(ped, 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest', 8.0, -8.0, -1, 0, 0.0, false, false,
							false)
					end
					disableKeys, isReviving = nil, nil

					RemoveAnimDict('mini@cpr@char_a@cpr_str')
					isBusy = nil
					TriggerServerEvent('wasabi_ambulance:revivePlayer', targetId)
				else
					TriggerEvent('wasabi_bridge:notify', Strings.player_not_unconscious,
						Strings.player_not_unconscious_desc, 'error')
				end
			else
				TriggerEvent('wasabi_bridge:notify', Strings.player_noitem, Strings.player_noitem_desc, 'error')
			end
		else
			TriggerEvent('wasabi_bridge:notify', Strings.player_busy, Strings.player_busy_desc, 'error')
		end
	end
end

exports('reviveTarget', reviveTarget)

healTarget = function()
	if isPlayerDead() then return end
	local progressUI
	if Config.ProgressCircle then progressUI = 'progressCircle' else progressUI = 'progressBar' end
	local coords = GetEntityCoords(wsb.cache.ped)
	local player = wsb.getClosestPlayer(vec3(coords.x, coords.y, coords.z), 2.0)
	if not player then
		local quantity = wsb.awaitServerCallback('wasabi_ambulance:itemCheck', Config.EMSItems.heal.item)
		if quantity > 0 then
			local isPlyDead = isDead
			if not isPlyDead then
				if wsb.progressUI({
						duration = Config.EMSItems.heal.duration,
						label = Strings.healing_self_prog,
						position = Config.ProgressCircleLocation,
						useWhileDead = false,
						canCancel = true,
						disable = {
							car = true,
						},
						anim = {
							dict = 'missheistdockssetup1clipboard@idle_a',
							clip = 'idle_a'
						},
						color = Config.UIColor 
					}, progressUI) then
					TriggerServerEvent('wasabi_ambulance:healPlayer', wsb.cache.serverId)
				else
					TriggerEvent('wasabi_bridge:notify', Strings.action_cancelled, Strings.action_cancelled_desc, 'error')
				end
			else
				TriggerEvent('wasabi_bridge:notify', Strings.player_unconscious, Strings.player_unconscious_desc, 'error')
			end
		else
			TriggerEvent('wasabi_bridge:notify', Strings.player_noitem, Strings.player_noitem_desc, 'error')
		end
	else
		local quantity = wsb.awaitServerCallback('wasabi_ambulance:itemCheck', Config.EMSItems.heal.item)
		if quantity > 0 then
			local targetId = GetPlayerServerId(player)
			local isPlyDead = wsb.awaitServerCallback('wasabi_ambulance:isPlayerDead', targetId)
			if not isPlyDead then
				local ped = wsb.cache.ped
				TriggerEvent('wasabi_bridge:notify', Strings.player_healing, Strings.player_healing_desc, 'success')
				wsb.stream.animDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
				local targetPed = GetPlayerPed(player)
				local tCoords = GetEntityCoords(targetPed)
				TaskTurnPedToFaceCoord(ped, tCoords.x, tCoords.y, tCoords.z, 3000)
				Wait(1000)
				if wsb.progressUI({
						duration = Config.EMSItems.heal.duration,
						label = Strings.healing_self_prog,
						position = Config.ProgressCircleLocation,
						useWhileDead = false,
						canCancel = true,
						disable = {
							car = true,
							move = true
						},
						anim = {
							dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
							clip = 'machinic_loop_mechandplayer'
						},
						color = Config.UIColor 
					}, progressUI) then
					TriggerServerEvent('wasabi_ambulance:healPlayer', targetId)
				else
					TriggerEvent('wasabi_bridge:notify', Strings.action_cancelled, Strings.action_cancelled_desc, 'error')
				end
			else
				TriggerEvent('wasabi_bridge:notify', Strings.player_unconscious, Strings.player_unconscious_desc, 'error')
			end
		else
			TriggerEvent('wasabi_bridge:notify', Strings.player_noitem, Strings.player_noitem_desc, 'error')
		end
	end
end

exports('healTarget', healTarget)

useSedative = function()
	if isPlayerDead() then return end
	local coords = GetEntityCoords(wsb.cache.ped)
	local player = wsb.getClosestPlayer(vec3(coords.x, coords.y, coords.z), 2.0)
	if not player then
		TriggerEvent('wasabi_bridge:notify', Strings.no_nearby, Strings.no_nearby_desc, 'error')
	else
		local quantity = wsb.awaitServerCallback('wasabi_ambulance:itemCheck', Config.EMSItems.sedate.item)
		if quantity > 0 then
			TriggerServerEvent('wasabi_ambulance:sedatePlayer', GetPlayerServerId(player))
		else
			TriggerEvent('wasabi_bridge:notify', Strings.player_noitem, Strings.player_noitem_desc, 'error')
		end
	end
end

exports('useSedative', useSedative)


NearestVehicle = function()
	local dist = 50.0
	local pedCoords = GetEntityCoords(wsb.cache.ped)
	local vehicle = 0
	for k, data in pairs(GetGamePool('CVehicle')) do
		local vehCoords = GetEntityCoords(data)
		local temp = #(vector3(vehCoords.x, vehCoords.y, vehCoords.z) - vector3(pedCoords.x, pedCoords.y, pedCoords.z))

		if temp < dist then
			dist = temp
			vehicle = data
		end
	end

	return vehicle
end
exports('NearestVehicle', NearestVehicle)




openOutfits = function(hospital)
	if isPlayerDead() then return end
	if Config.skinScript == 'qb' then
		TriggerEvent('qb-clothing:client:openMenu')
	else
		local data = Config.Locations[hospital].Cloakroom.Uniforms
		local Options = {
			{
				title = Strings.civilian_wear,
				description = '',
				arrow = false,
				event = 'wasabi_ambulance:changeClothes',
				args = 'civ_wear'
			}
		}
		for i = 1, #data do
			if data[i].minGrade then
				local _job, grade = wsb.hasGroup(Config.ambulanceJobs or Config.ambulanceJob)
				if grade and grade >= data[i].minGrade then
					Options[#Options + 1] = {
						title = data[i].label,
						description = '',
						arrow = false,
						event = 'wasabi_ambulance:changeClothes',
						args = { male = data[i].male, female = data[i].female }
					}
				end
			else
				Options[#Options + 1] = {
					title = data[i].label,
					description = '',
					arrow = false,
					event = 'wasabi_ambulance:changeClothes',
					args = { male = data[i].male, female = data[i].female }
				}
			end
		end
		if Config.MobileMenu.enabled then
			wsb.showMenu({
				id = 'ems_cloakroom',
				color = Config.UIColor,
				position = Config.MobileMenu.position,
				title = Strings.cloakroom,
				options = Options
			})
		else
			wsb.showContextMenu({
				id = 'ems_cloakroom',
				color = Config.UIColor,
				title = Strings.cloakroom,
				options = Options
			})
		end
	end
end

exports('openOutfits', openOutfits)

function RequestCivilianOutfit()
	wsb.serverCallback('wasabi_ambulance:requestCivilianOutfit', function(outfit)
		if not outfit then return end
		if outfit.clothing and next(outfit.clothing) then
			for _, clothingData in pairs(outfit.clothing) do
				SetPedComponentVariation(wsb.cache.ped, clothingData.component, clothingData.drawable,
					clothingData.texture,
					0)
			end
		end
		if not outfit.props or not next(outfit.props) then return end
		for _, propData in pairs(outfit.props) do
			SetPedPropIndex(wsb.cache.ped, propData.component, propData.drawable, propData.texture, true)
		end
	end)
end

function SaveCivilianOutfit()
	local civilianOutfit = { clothing = {}, props = {} }
	for i = 0, 11 do
		local drawable = GetPedDrawableVariation(wsb.cache.ped, i)
		local texture = GetPedTextureVariation(wsb.cache.ped, i)
		civilianOutfit.clothing[#civilianOutfit.clothing + 1] = {
			component = i,
			drawable = drawable,
			texture = texture
		}
	end
	for i = 0, 7 do
		local drawable = GetPedPropIndex(wsb.cache.ped, i)
		local texture = GetPedPropTextureIndex(wsb.cache.ped, i)
		civilianOutfit.props[#civilianOutfit.props + 1] = {
			component = i,
			drawable = drawable,
			texture = texture
		}
	end
	TriggerServerEvent('wasabi_ambulance:saveOutfit', civilianOutfit)
end

function RemoveClothingProps()
	SetPedPropIndex(wsb.cache.ped, 0, -1, 0, true)
	for i = 0, 11 do
		ClearPedProp(wsb.cache.ped, i)
	end
	for i = 0, 7 do
		ClearPedProp(wsb.cache.ped, i)
	end
end

treatPatient = function(injury)
	if isPlayerDead() then return end
	local coords = GetEntityCoords(wsb.cache.ped)
	local player = wsb.getClosestPlayer(vec3(coords.x, coords.y, coords.z), 2.0)
	if not player then
		TriggerEvent('wasabi_bridge:notify', Strings.no_nearby, Strings.no_nearby_desc, 'error')
	elseif wsb.hasGroup(Config.ambulanceJobs or Config.ambulanceJob) or Authorized then
		local progressUI
		if Config.ProgressCircle then progressUI = 'progressCircle' else progressUI = 'progressBar' end
		local targetId = GetPlayerServerId(player)
		local plyInjury = wsb.awaitServerCallback('wasabi_ambulance:diagnosePlayer', targetId)
		if plyInjury then
			if plyInjury and plyInjury.injury and plyInjury.injury == 'bleedout' then plyInjury.injury = 'stabbed' end
			if plyInjury and plyInjury.injury == injury then
				local ped = wsb.cache.ped
				local targetPed = GetPlayerPed(player)
				local tCoords = GetEntityCoords(targetPed)
				TaskTurnPedToFaceCoord(ped, tCoords.x, tCoords.y, tCoords.z, 3000)
				Wait(1000)
				TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
				Wait(Config.TreatmentTime)
				ClearPedTasks(ped)
				TriggerServerEvent('wasabi_ambulance:treatPlayer', targetId, injury)
			elseif plyInjury and type(plyInjury.injury) == 'table' then
				local found
				---@diagnostic disable-next-line: param-type-mismatch
				for _, v in pairs(plyInjury.injury) do
					if v.type == injury then
						found = true
						break
					end
				end
				if not found then
					TriggerEvent('wasabi_bridge:notify', Strings.wrong_equipment, Strings.wrong_equipment_desc, 'error')
				else
					local ped = wsb.cache.ped
					local targetPed = GetPlayerPed(player)
					local tCoords = GetEntityCoords(targetPed)
					TaskTurnPedToFaceCoord(ped, tCoords.x, tCoords.y, tCoords.z, 3000)
					Wait(1000)
					if wsb.progressUI({
							duration = Config.TreatmentTime,
							label = Strings.treating_patient_progress,
							position = Config.ProgressCircleLocation,
							useWhileDead = false,
							canCancel = true,
							disable = {
								car = true,
								move = true
							},
							anim = {
								dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
								clip = 'machinic_loop_mechandplayer'
							},
							color = Config.UIColor 
						}, progressUI) then
						TriggerServerEvent('wasabi_ambulance:treatPlayer', targetId, injury)
					else
						TriggerEvent('wasabi_bridge:notify', Strings.action_cancelled, Strings.action_cancelled_desc,
							'error')
					end
				end
			else
				TriggerEvent('wasabi_bridge:notify', Strings.wrong_equipment, Strings.wrong_equipment_desc, 'error')
			end
		else
			TriggerEvent('wasabi_bridge:notify', Strings.player_not_injured, Strings.player_not_injured_desc, 'error')
		end
	else
		TriggerEvent('wasabi_bridge:notify', Strings.not_medic, Strings.not_medic_desc, 'error')
	end
end

exports('treatPatient', treatPatient)

gItem = function(data)
	local item = data.item
	local cb = wsb.awaitServerCallback('wasabi_ambulance:gItem', item)
	if cb then
		TriggerEvent('wasabi_bridge:notify', Strings.successful, Strings.item_grab, 'success')
	else
		TriggerEvent('wasabi_bridge:notify', Strings.successful, Strings.medbag_pickup_civ, 'success')
	end
end

deleteObj = function(entity)
	if DoesEntityExist(entity) then
		SetEntityAsMissionEntity(entity, true, true)
		DeleteObject(entity)
		DeleteEntity(entity)
	end
end

pickupBag = function()
	if isPlayerDead() then return end
	local ped = wsb.cache.ped
	local coords = GetEntityCoords(ped)
	local bagHash = Config.BagProp
	local closestBag = GetClosestObjectOfType(coords.x, coords.y, coords.z, 3.0, bagHash, false, false, false)
	local bagCoords = GetEntityCoords(closestBag)
	TaskTurnPedToFaceCoord(ped, bagCoords.x, bagCoords.y, bagCoords.z, 2000)
	TaskPlayAnim(ped, 'pickup_object', 'pickup_low', 8.0, 8.0, 1000, 50, 0, false, false, false)
	Entity(closestBag).state.useable = false
	Wait(1000)
	TriggerServerEvent('wasabi_ambulance:removeObj', ObjToNet(closestBag))
	Wait(500)
	if not DoesEntityExist(closestBag) then
		local cb = wsb.awaitServerCallback('wasabi_ambulance:gItem', Config.EMSItems.medbag)
		if cb then
			TriggerEvent('wasabi_bridge:notify', Strings.successful, Strings.medbag_pickup, 'success')
		else
			TriggerEvent('wasabi_bridge:notify', Strings.successful, Strings.medbag_pickup_civ, 'success')
		end
	end
end

medicalSuppliesMenu = function(id)
    if isPlayerDead() then return end
    if wsb.hasGroup(Config.ambulanceJobs or Config.ambulanceJob) then
        local supplies = Config.Locations[id].MedicalSupplies.Supplies
        if wsb.inventorySystem then
            wsb.inventory.openShop({
                identifier = id .. '_medsupplies',
                name = Strings.request_supplies_target,
            })
            return
        end
        local Options = {}
        for i = 1, #supplies do
            if wsb.inventorySystem then
                Options[#Options + 1] = {
                    name = supplies[i].item,
                    price = supplies[i].price or 0,
                }
            else
                if supplies[i].price then
                    Options[#Options + 1] = {
                        title = supplies[i].label .. ' - ' .. Strings.currency .. '' .. addCommas(supplies[i].price),
                        description = '',
                        arrow = false,
                        event = 'wasabi_ambulance:buyItem',
                        args = { hospital = id, item = supplies[i].item, price = supplies[i].price }
                    }
                else
                    Options[#Options + 1] = {
                        title = supplies[i].label,
                        description = '',
                        arrow = false,
                        event = 'wasabi_ambulance:buyItem',
                        args = { hospital = id, item = supplies[i].item }
                    }
                end
            end
        end
        if Config.MobileMenu.enabled then
            wsb.showMenu({
                id = 'ems_supply_menu',
                position = Config.MobileMenu.position,
                title = Strings.request_supplies_target,
                color = Config.UIColor,
                options = Options
            })
            return
        end
        wsb.showContextMenu({
            id = 'ems_supply_menu',
            color = Config.UIColor,
            title = Strings.request_supplies_target,
            options = Options
        })
    end
end


--PersonalLocker
function OpenPersonalStash(station)
	if not Config.Locations[station] or not Config.Locations[station].PersonalLocker then return end
	if not wsb.inventorySystem then return end
	if not wsb.hasGroup(Config.ambulanceJobs or Config.ambulanceJob) then return end
	local stashid = station .. '_' .. wsb.getIdentifier()
	if wsb.awaitServerCallback('wasabi_ambulance:registerStash', {
        name = stashid,
        slots = 30,
        maxWeight = 50000,
        station = station,
        location = 'PersonalLocker'
        
    }) then 
	wsb.inventory.openStash({
		name = stashid,
		maxWeight = Config.Locations[station].PersonalLocker.maxWeight,
		slots = Config.Locations[station].PersonalLocker.slots
	})
	end
end

openVehicleMenu = function(hosp)
	if isPlayerDead() then return end
	if not wsb.hasGroup(Config.ambulanceJobs or Config.ambulanceJob) then return end
	local data, grade
	local _, level = wsb.getGroup()
	if level > #Config.Locations[hosp].Vehicles.Options then
		grade = #Config.Locations[hosp].Vehicles.Options
		data = Config.Locations[hosp].Vehicles.Options[#Config.Locations[hosp].Vehicles.Options]
	elseif not Config.Locations[hosp].Vehicles.Options[level] then
		print('[wasabi_ambulance] : Ambulance garage not set up properly for job grade: ' .. level)
		return
	else
		grade = level
		data = Config.Locations[hosp].Vehicles.Options[level]
	end
	local Options = {}
	for k, v in pairs(data) do
		if v.category == 'land' then
			Options[#Options + 1] = {
				title = v.label,
				description = '',
				icon = 'car',
				arrow = true,
				event = 'wasabi_ambulance:spawnVehicle',
				args = { hospital = hosp, model = k, grade = grade }
			}
		elseif v.category == 'air' then
			Options[#Options + 1] = {
				title = v.label,
				description = '',
				icon = 'helicopter',
				arrow = true,
				event = 'wasabi_ambulance:spawnVehicle',
				args = { hospital = hosp, model = k, grade = grade, category = v.category }
			}
		end
	end
	if Config.MobileMenu.enabled then
		wsb.showMenu({
			id = 'ems_garage_menu',
			position = Config.MobileMenu.position,
			onExit = function()
				inMenu = false
			end,
			title = Strings.hospital_garage,
			color = Config.UIColor,
			options = Options
		})
	else
		wsb.showContextMenu({
			id = 'ems_garage_menu',
			color = Config.UIColor,
			onExit = function()
				inMenu = false
			end,
			title = Strings.hospital_garage,
			options = Options
		})
	end
end

InteractWithMedbag = function(obj)
	if isPlayerDead() then return end
	if not DoesEntityExist(obj) then return end
	local Options = {
		{
			title = Strings.pickup_bag_target,
			arrow = false,
			event = 'wasabi_ambulance:pickupBag',
		},
		{
			title = Strings.interact_bag_target,
			arrow = false,
			event = 'wasabi_ambulance:interactBag',
		}
	}
	if Config.MobileMenu.enabled then
		wsb.showMenu({
			id = 'interact_medbag_menu',
			position = Config.MobileMenu.position,
			title = Strings.medbag,
			color = Config.UIColor,
			options = Options
		})
	else
		wsb.showContextMenu({
			id = 'interact_medbag_menu',
			title = Strings.medbag,
			color = Config.UIColor,
			options = Options
		})
	end
end

medBagPlaced = function(obj)
	if not DoesEntityExist(obj) then return end
	local coords = GetEntityCoords(obj)
	targetPlaced = false
	local textUI = false
	CreateThread(function()
		while true do
			local sleep = 1500
			if DoesEntityExist(obj) then
				local plyCoords = GetEntityCoords(wsb.cache.ped)
				local dist = #(vector3(plyCoords.x, plyCoords.y, plyCoords.z) - vector3(coords.x, coords.y, coords.z))
				if dist <= 2.0 then
					if not textUI then
						wsb.showTextUI(Strings.interact_stretcher_ui)
						textUI = true
					end
					sleep = 0
					if IsControlJustPressed(0, 38) then
						InteractWithMedbag(obj)
					end
				else
					if textUI then
						wsb.hideTextUI()
						textUI = false
					end
				end
			else
				if textUI then
					wsb.hideTextUI()
					textUI = false
				end
				break
			end
			Wait(sleep)
		end
	end)
end

local medbagObj
useMedbag = function()
	if isPlayerDead() then return end
	local ped = wsb.cache.ped
	local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.55))
	wsb.stream.model(Config.BagProp, 7000)
	medbagObj = CreateObjectNoOffset(Config.BagProp, x, y, z, true, false, false)
	TriggerServerEvent('wasabi_ambulance:setBagState', ObjToNet(medbag))
	SetModelAsNoLongerNeeded(Config.BagProp)
	SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, false)
	NetworkRequestControlOfEntity(medbagObj)
	AttachEntityToEntity(medbagObj, ped, GetPedBoneIndex(ped, 57005), 0.42, 0, -0.05, 0.10, 270.0, 60.0, true, true,
		false, true, 1, true)
	local bagEquipped = true
	local text_ui
	CreateThread(function()
		while bagEquipped do
			Wait(0)
			if not text_ui then
				wsb.showTextUI(Strings.drop_bag_ui)
				text_ui = true
			end
			if IsControlJustReleased(0, 38) then
				TaskPlayAnim(ped, 'pickup_object', 'pickup_low', 8.0, 8.0, 1000, 50, 0, false, false, false)
				bagEquipped = false
				text_ui = nil
				wsb.hideTextUI()
				Wait(1000)
				DetachEntity(medbagObj, false, true)
				PlaceObjectOnGroundProperly(medbagObj)
				Entity(medbagObj).state.useable = true
				if not Config.targetSystem then
					medBagPlaced(medbagObj)
				end
			end
		end
	end)
end

openDispatchMenu = function()
	if isPlayerDead() then return end
	if wsb.hasGroup(Config.ambulanceJobs or Config.ambulanceJob) then
		local Options = {
			{
				title = Strings.GoBack,
				description = '',
				icon = 'chevron-left',
				arrow = false,
				event = 'wasabi_ambulance:emsJobMenu',
				disabled = isPlayerDead() == true
			},
		}
		for k, v in pairs(plyRequests) do
			Options[#Options + 1] = {
				title = v,
				description = '',
				arrow = true,
				event = 'wasabi_ambulance:setRoute',
				args = { plyId = k },
				disabled = isPlayerDead() == true
			}
		end
		if #Options < 2 then
			Options[#Options + 1] = {
				title = Strings.no_requests,
				description = '',
				arrow = false,
				event = '',
				disabled = isPlayerDead() == true
			}
		end
		if Config.MobileMenu.enabled then
			wsb.showMenu({
				id = 'ems_dispatch_menu',
				position = Config.MobileMenu.position,
				title = Strings.DispatchMenuTitle,
				color = Config.UIColor,
				options = Options
			})
		else
			wsb.showContextMenu({
				id = 'ems_dispatch_menu',
				color = Config.UIColor,
				title = Strings.DispatchMenuTitle,
				options = Options
			})
		end
	end
end

SetHealthDefaults = function()
	while not DoesEntityExist(PlayerPedId()) do Wait(100) end
	local player = PlayerId()
	SetPlayerHealthRechargeMultiplier(player, 0.0)
	SetPlayerHealthRechargeLimit(player, 0.0)
	local health = GetEntityHealth(PlayerPedId())
	if health == 200 then return end
	SetEntityMaxHealth(PlayerPedId(), 200)
	SetEntityHealth(PlayerPedId(), 200)
end

function SetPlayerLimp(state)
	local clipSet = `move_m@injured`
	if state then
		if not HasAnimSetLoaded(clipSet) then
			RequestAnimSet(clipSet)
			while not HasAnimSetLoaded(clipSet) do Wait(5) end
		end
		SetPedMovementClipset(wsb.cache.ped, clipSet, 1.0)
	else
		ResetPedMovementClipset(wsb.cache.ped, 0)
	end
end

function IsPedWalkingWithLimp()
	local movement = GetPedMovementClipset(wsb.cache.ped)
	return movement == `move_m@injured`
end

local function getInjuryData(ped)
	local injuryData
	for k, v in pairs(InjuryReasons) do
		for _, weapon in pairs(v) do
			if HasPedBeenDamagedByWeapon(ped, weapon, 0) then
				local bypassWeapon = false
				if Config.BypassInjuryWeapons and #Config.BypassInjuryWeapons > 0 then
					for _, whitelistWeapon in pairs(Config.BypassInjuryWeapons) do
						if weapon == whitelistWeapon then
							bypassWeapon = true
							break
						end
					end
				end
				if not bypassWeapon then
					local hit, bone = GetPedLastDamageBone(ped)
					local bodypart = Bones[bone]
					if hit and bodypart then
						injuryData = { type = k, weapon = weapon, location = bodypart, data = PlayerSkeleton[bodypart] }
					end
				else
					injuryData = 'UNARMED'
				end
				ClearEntityLastDamageEntity(ped)
				break
			end
		end
		if injuryData then break end
	end
	if not injuryData then
		if IsEntityOnFire(ped) then
			injuryData = {
				type = 'burned',
				weapon = 'unknown',
				location = 'upper_body',
				data = PlayerSkeleton
					.upper_body
			}
		else
			injuryData = {
				type = 'beat',
				weapon = 'unknown',
				location = 'upper_body',
				data = PlayerSkeleton
					.upper_body
			}
		end
	end
	if injuryData == 'UNARMED' then injuryData = nil end
	return injuryData
end

local setActiveInjuryNotification
function SetActiveInjury(data)
	if not PlayerInjury[data.location] then
		PlayerInjury[data.location] = { type = data.type, data = data.data }
	else
		local foundInjury = PlayerInjury[data.location]
		if (foundInjury.type == 'stabbed' and data.type == 'shot') or foundInjury.type ~= 'shot' then
			foundInjury.type = data.type
		end
		foundInjury.data.limp = foundInjury.data.limp or data.data.limp
		foundInjury.data.level = foundInjury.data.level + data.data.level
		if foundInjury.data.level > 4 then foundInjury.data.level = 4 end
		foundInjury.data.bleed = foundInjury.data.bleed + data.data.bleed
		if foundInjury.data.bleed > 4 then foundInjury.data.bleed = 4 end
		PlayerInjury[data.location] = foundInjury
	end
	TriggerServerEvent('wasabi_ambulance:injurySync', PlayerInjury)
	if not setActiveInjuryNotification then setActiveInjuryNotification = GetGameTimer() end
	if (GetGameTimer() - setActiveInjuryNotification) < 4500 then return end
	setActiveInjuryNotification = GetGameTimer()
	local severity = PlayerInjury[data.location].data.level
	if severity == 1 then
		TriggerEvent('wasabi_bridge:notify', Strings.light_injury_title,
			(Strings.light_injury_desc):format(PlayerInjury[data.location].data.label), 'error', 'bandage')
	elseif severity >= 2 and severity <= 3 then
		TriggerEvent('wasabi_bridge:notify', Strings.moderate_injury_title,
			(Strings.moderate_injury_desc):format(PlayerInjury[data.location].data.label), 'error', 'kit-medical')
	elseif severity >= 4 then
		TriggerEvent('wasabi_bridge:notify', Strings.extreme_injury_title,
			(Strings.extreme_injury_desc):format(PlayerInjury[data.location].data.label), 'error', 'skull')
	end
end

function ChanceInjury()
	if isDead then return end
	local injuryData = getInjuryData(wsb.cache.ped)
	if not injuryData then return nil end
	local severity = (WeaponInjuryTable[injuryData.data.weapon] or 1)

	local random = math.random(1, 100)
	if 10 > random then return end

	injuryData.data.level = severity
	injuryData.data.bleed = Config?.BleedMultiplier?[injuryData.type] or 0
	if injuryData.data.bleed > 4 then injuryData.data.bleed = 4 end
	SetActiveInjury(injuryData)
end

local lastStagger
function SimulatePedStagger(ped, duration)
	if not lastStagger then lastStagger = GetGameTimer() end
	if GetGameTimer() - lastStagger <= 16000 then return false end
	if IsPedInAnyVehicle(ped, false) then return false end
	ClearPedTasks(ped)
	CreateThread(function()
		wsb.stream.animDict('misscarsteal4@actor')
		TaskPlayAnim(ped, 'misscarsteal4@actor', 'stumble', 8.0, 8.0, -1, 3, 0, false, false, false)
		Wait(duration)
		ClearPedTasks(ped)
		RemoveAnimDict('misscarsteal4@actor')
	end)
	lastStagger = GetGameTimer()
	return true
end

function SimulateAimPain(ped)
	if not GameShake then
		local cameraShakeType = 'HAND_SHAKE'
		local cameraShakeAmplitude = 4.0
		ShakeGameplayCam(cameraShakeType, cameraShakeAmplitude)
		GameShake = cameraShakeAmplitude
	end

	if IsPedShooting(ped) then
		local deviation = math.random(10, 30) * 0.01
		local randomX = math.random(-1, 1) * deviation
		local randomY = math.random(-1, 1) * deviation

		local x, y, z = table.unpack(GetGameplayCamCoord())
		SetPedShootsAtCoord(ped, x + randomX, y + randomY, z, 0)
	end
end

function SendBlackoutNotify(location)
	local timeout = GetGameTimer()
	if (GetGameTimer() - timeout) < 4500 then return end
	TriggerEvent('wasabi_bridge:notify', Strings.blackout_title, (Strings.blackout_desc):format(location), 'error',
		'skull')
end

function SendInjuredNotification()
	local injuryMessages = {
		[1] = Strings.injury_msg_one,
		[2] = Strings.injury_msg_two,
		[3] = Strings.injury_msg_three,
		[4] = Strings.injury_msg_four
	}

	local bleedMessages = {
		[1] = Strings.bleed_msg_one,
		[2] = Strings.bleed_msg_two,
		[3] = Strings.bleed_msg_three
	}

	local combinedMessage = ""
	local totalBleed = 0
	local highestInjuryLevel = 0

	for k, v in pairs(PlayerInjury) do
		if v.data.level > highestInjuryLevel then highestInjuryLevel = v.data.level end
		totalBleed = totalBleed + v.data.bleed
	end

	if highestInjuryLevel > 4 then highestInjuryLevel = 4 end
	combinedMessage = combinedMessage .. injuryMessages[highestInjuryLevel] .. " "
	if totalBleed > 0 and totalBleed <= 2 then
		combinedMessage = combinedMessage .. bleedMessages[1] .. " "
	elseif totalBleed > 2 and totalBleed <= 5 then
		combinedMessage = combinedMessage .. bleedMessages[2] .. " "
	elseif totalBleed > 5 then
		combinedMessage = combinedMessage .. bleedMessages[3] .. " "
	end

	combinedMessage = combinedMessage:sub(1, -2)

	if combinedMessage ~= "" then
		local timeout = GetGameTimer()
		if (GetGameTimer() - timeout) < 4500 then return end
		TriggerEvent('wasabi_bridge:notify', Strings.injury_bleed_notify, combinedMessage, 'error', 'skull')
	end
end

local previousBlackout
function BlackoutEffect(fadeTime, duration)
	if not previousBlackout then previousBlackout = GetGameTimer() end
	if (GetGameTimer() - previousBlackout) <= 18000 then return false end
	fadeTime = fadeTime or 1000
	local totalTimeBlackout = duration or 5000
	CreateThread(function()
		DoScreenFadeOut(fadeTime)
		while not IsScreenFadedOut() do Wait(0) end
		Wait(totalTimeBlackout)
		DoScreenFadeIn(fadeTime)
		while not IsScreenFadedIn() do Wait(0) end
		previousBlackout = GetGameTimer()
	end)
	return true
end

local function nodOutThread()
	while true do
		if currentDrugEffect and currentDrugEffect >= 14 then
			if 70 <= math.random(1, 100) then
				local blackedOut = BlackoutEffect(700, 3000)
				if blackedOut then
					SetPedToRagdoll(wsb.cache.ped, 7000, 5000, 0, true, true, false)
					TriggerEvent('wasabi_bridge:notify', Strings.fainted_title, Strings.fainted_so_high_desc, 'error')
				end
			end
		else
			break
		end
		Wait(1000)
	end
end

function SetDrugEffect(ped, drugLevel)
	if not currentDrugEffect then
		wsb.stream.animSet('move_m@hobo@a')
		SetTimecycleModifier('spectator3')
		SetPedMotionBlur(ped, true)
		SetPedIsDrunk(ped, true)
		AnimpostfxPlay('HeistCelebPass', 0, true)
		SetPedMovementClipset(ped, 'move_m@hobo@a', 1.0)
	end
	if currentDrugEffect and currentDrugEffect >= drugLevel then return end
	currentDrugEffect = drugLevel
	if currentDrugEffect >= 1 and currentDrugEffect <= 3 then
		ShakeGameplayCam('DRUNK_SHAKE', 1.5)
	elseif currentDrugEffect >= 4 and currentDrugEffect <= 7 then
		ShakeGameplayCam('DRUNK_SHAKE', 3.0)
	elseif currentDrugEffect >= 8 then
		SetTimecycleModifier('Dax_TripBase')
		ShakeGameplayCam('DRUNK_SHAKE', 3.0)
		if currentDrugEffect >= 19 then
			if not nodOutRunning then
				nodOutRunning = true
				nodOutThread()
			end
		end
	end
end

function ClearDrugEffects(ped)
	StopScreenEffect("HeistCelebPass")
	ResetPedMovementClipset(ped, 0)
	ClearTimecycleModifier()
	ShakeGameplayCam('DRUNK_SHAKE', 0.0)
	RemoveAnimSet('move_m@hobo@a')
end

function PlayTakePillAnimation()
	local ped = wsb.cache.ped
	wsb.stream.animDict('mp_suicide')
	TaskPlayAnim(ped, 'mp_suicide', 'pill', 8.0, -8.0, -1, 49, 0, false, false, false)
	Wait(3000)
	StopAnimTask(ped, 'mp_suicide', 'pill', 1.0)
	RemoveAnimDict('mp_suicide')
end

function DisableJumpingOnFrame()
	if Config.DisableNoJumpInjury or IsPedInAnyVehicle(wsb.cache.ped, false) then return end
	math.randomseed(GetGameTimer())
	if math.random() < 20 / 100 then
		DisableControlAction(0, 22, true)
		if IsDisabledControlJustReleased(0, 22) then
			SetPedToRagdoll(wsb.cache.ped, 5000, 3000, 0, true, true, false)
			TriggerEvent('wasabi_bridge:notify', Strings.cant_jump_title, Strings.cant_jump_desc, 'error')
		end
	end
end

function ClearPatientSymptoms(restoreVitals)
	DrugIntake = {}
	nodOutRunning = false
	currentDrugEffect = false
	OnPainKillers = false
	isDead = false
	PlayerInjury = {}
	if restoreVitals then
		TriggerServerEvent('wasabi_ambulance:injurySync', false)
		TriggerServerEvent('wasabi_ambulance:setDeathStatus', false, true)
		TriggerServerEvent('wasabi_ambulance:resetThirstHunger')
	end
end

function AttemptCheckIn(hospital, standaloneID, onBleedout, bedsFull, setDeath)
	local progressUI
	if Config.ProgressCircle then progressUI = 'progressCircle' else progressUI = 'progressBar' end
	local checkIn, useCheckInInstead
	if hospital == 'standalone' then
		checkIn = Config.StandaloneCheckIns[standaloneID]
		if not checkIn then return end
		hospital = 'standaloneCheckIn_' .. standaloneID
		useCheckInInstead = false
	else
		local hospitalData = Config.Locations[hospital]
		if not hospitalData then return end
		useCheckInInstead = not hospitalData.RespawnPoint.useCheckInInstead and vec4(hospitalData.RespawnPoint.coords.x, hospitalData.RespawnPoint.coords.y, hospitalData.RespawnPoint.coords.z, hospitalData.RespawnPoint.heading) or false
		checkIn = hospitalData.CheckIn
	end
	if setDeath then
		TriggerServerEvent('wasabi_ambulance:setDeathStatus', false, true)
	end
	if not checkIn.DisableHospitalBeds and not bedsFull then
		if onBleedout and Config.Locations[hospital] then
			if not Config.Locations[hospital].RespawnPoint.useCheckInInstead then
				AttemptCheckIn(hospital, standaloneID, onBleedout, true)
				return
			end
		end
		local foundBed = wsb.awaitServerCallback('wasabi_ambulance:requestBed', hospital)
		if not foundBed then
			AttemptCheckIn(hospital, standaloneID, onBleedout, true)
			return
		end
		IsCheckedIn = foundBed
		local inProcess = true
		if not IsScreenFadedOut() then DoScreenFadeOut(2000) end
		while not IsScreenFadedOut() do Wait(500) end

		local coords = GetEntityCoords(wsb.cache.ped, true)
		local heading = GetEntityHeading(wsb.cache.ped)
		TriggerEvent('wasabi_ambulance:customInjuryClear')
		if IsPedDeadOrDying(wsb.cache.ped, false) then
			NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
		end
		Wait(100)
		---@diagnostic disable-next-line: missing-parameter
		SetEntityCoords(wsb.cache.ped, IsCheckedIn.coords.x, IsCheckedIn.coords.y, IsCheckedIn.coords.z + 0.02)
		ClearPedBloodDamage(wsb.cache.ped)
		ClearPedEnvDirt(wsb.cache.ped)
		CreateThread(function()
			while inProcess do
				if not IsEntityPlayingAnim(wsb.cache.ped, 'anim@gangops@morgue@table@', 'body_search', 3) then
					TaskPlayAnim(wsb.cache.ped, 'anim@gangops@morgue@table@', 'body_search', 8.0, 1.0, -1, 1, 0, false,
						false,
						false)
				end
				Wait(100)
			end
		end)
		wsb.stream.animDict('anim@gangops@morgue@table@')
		FreezeEntityPosition(wsb.cache.ped, true)
		ClearPedTasks(wsb.cache.ped)
		TaskPlayAnim(wsb.cache.ped, 'anim@gangops@morgue@table@', 'body_search', 8.0, 1.0, -1, 1, 0, false, false, false)
		local playerHeading = (IsCheckedIn.heading > 180) and IsCheckedIn.heading - 180 or IsCheckedIn.heading + 180
		SetEntityHeading(wsb.cache.ped, playerHeading)
		IsCheckedIn.cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
		SetCamActive(IsCheckedIn.cam, true)
		RenderScriptCams(true, false, 1, true, true)
		AttachCamToPedBone(IsCheckedIn.cam, wsb.cache.ped, 31085, 0, 1.0, 1.0, true)
		SetCamFov(IsCheckedIn.cam, 90.0)
		SetEnableHandcuffs(wsb.cache.ped, false)
		local heading = GetEntityHeading(wsb.cache.ped)
		heading = (heading > 180) and heading - 180 or heading + 180
		SetCamRot(IsCheckedIn.cam, -45.0, 0.0, heading, 2)
		TriggerEvent('wasabi_bridge:notify', Strings.checkin_hospital, Strings.checkin_hospital_desc, 'success')
		HideDeathNui()
		ClearPatientSymptoms(true)
		DoScreenFadeIn(1200)
		while not IsScreenFadedIn do Wait(100) end
		if Config.ChargeForRevive and Config.ChargeForRevive.enabled and onBleedout then
			TriggerServerEvent('wasabi_ambulance:chargeForRevive', checkIn.PayHospital)
		end
		if wsb.progressUI({
				duration = checkIn.Duration,
				label = Strings.recovering_progress,
				position = Config.ProgressCircleLocation,
				useWhileDead = true,
				canCancel = false,
				disable = {
					car = true,
					move = true
				},
				color = Config.UIColor 
			}, progressUI) then
			inProcess = false
			wsb.stream.animDict('switch@franklin@bed')
			FreezeEntityPosition(wsb.cache.ped, false)
			local playerId = PlayerId()
			if GetPlayerInvincible(playerId) then SetPlayerInvincible(playerId, false) end
			SetEntityHeading(wsb.cache.ped, IsCheckedIn.heading - 90.0)
			TaskPlayAnim(wsb.cache.ped, 'switch@franklin@bed', 'sleep_getup_rubeyes', 100.0, 1.0, -1, 8, -1, false, false,
				false)
			Wait(4000)
			ClearPedTasks(wsb.cache.ped)
			RenderScriptCams(false, true, 200, true, true)
			DestroyCam(IsCheckedIn.cam, false)
			local health = GetEntityHealth(wsb.cache.ped)
			if health < 200 then SetEntityHealth(wsb.cache.ped, 200) end
			if wsb.framework == 'esx' then
				TriggerServerEvent('esx:onPlayerSpawn')
				TriggerEvent('esx:onPlayerSpawn')
			elseif wsb.framework == 'qb' then
				TriggerServerEvent('hospital:server:resetHungerThirst') -- qb-ambulancejob compatibility
				TriggerServerEvent('hud:server:RelieveStress', 100)
				TriggerEvent('wasabi_bridge:onPlayerSpawn')
			end
			TriggerEvent('wasabi_ambulance:resetStatus')
			TriggerServerEvent('wasabi_ambulance:resetThirstHunger')
			TriggerServerEvent('wasabi_ambulance:setBedInUse', hospital, false)
			if Config.wasabi_crutch.crutchOnCheckIn.enabled then
				Wait(3000)
				TriggerServerEvent('wasabi_crutch:giveCrutch', wsb.cache.serverId,
					Config.wasabi_crutch.crutchOnCheckIn.duration)
			end
			IsCheckedIn = false
		end
	else
		if not onBleedout then
			if not wsb.progressUI({
					duration = checkIn.Duration,
					label = Strings.checkingin_progress,
					position = Config.ProgressCircleLocation,
					useWhileDead = true,
					canCancel = false,
					disable = {
						car = true,
						move = true
					},
					color = Config.UIColor
				}, progressUI) then
				return
			end
		end
		inProcess = false
		DoScreenFadeOut(2000)
		while not IsScreenFadedOut() do Wait(100) end
		if Config.ChargeForRevive and Config.ChargeForRevive.enabled and onBleedout then
			TriggerServerEvent('wasabi_ambulance:chargeForRevive', checkIn.PayHospital)
		end
		local coords = useCheckInInstead and useCheckInInstead.xyz or checkIn.RespawnNoBedLocation.coords
		local heading = useCheckInInstead and useCheckInInstead.w or checkIn.RespawnNoBedLocation.heading
		if IsPedDeadOrDying(wsb.cache.ped, false) then
			NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
		end
		TriggerEvent('wasabi_ambulance:customInjuryClear')
		if GetEntityHealth(wsb.cache.ped) < 200 then
			SetEntityHealth(wsb.cache.ped, 200)
		end
		---@diagnostic disable-next-line: missing-parameter
		SetEntityCoords(wsb.cache.ped, coords.x, coords.y, coords.z)
		SetEntityHeading(wsb.cache.ped, heading)
		SetEntityInvincible(wsb.cache.ped, false)
		ClearPedBloodDamage(wsb.cache.ped)
		ClearPedEnvDirt(wsb.cache.ped)
		local playerId = PlayerId()
		if GetPlayerInvincible(playerId) then SetPlayerInvincible(playerId, false) end
		IsCheckedIn = true
		TriggerEvent('wasabi_bridge:notify', Strings.checkin_hospital, Strings.checkin_hospital_desc, 'success')
		ClearPatientSymptoms(true)
		if wsb.framework == 'esx' then
			TriggerServerEvent('esx:onPlayerSpawn')
			TriggerEvent('esx:onPlayerSpawn')
		elseif wsb.framework == 'qb' then
			TriggerServerEvent('hospital:server:resetHungerThirst') -- qb-ambulancejob compatibility
			TriggerServerEvent('hud:server:RelieveStress', 100)
			TriggerEvent('wasabi_bridge:onPlayerSpawn')
		end
		TriggerEvent('wasabi_ambulance:resetStatus')
		TriggerServerEvent('wasabi_ambulance:resetThirstHunger')
		IsCheckedIn = false
		ClearPedTasks(wsb.cache.ped)
		DoScreenFadeIn(1200)
		if Config?.wasabi_crutch?.crutchOnCheckIn?.enabled then
			Wait(3000)
			TriggerServerEvent('wasabi_crutch:giveCrutch', wsb.cache.serverId,
				Config.wasabi_crutch.crutchOnCheckIn.duration)
		end
	end
	if Config.UseRadialMenu then
		DisableRadial(false)
	end
end

function GetDeadPlayerInsideVehicle(vehicleEntity)
	local players = GetActivePlayers()
	for _, player in ipairs(players) do
		local ped = GetPlayerPed(player)
		if IsPedInVehicle(ped, vehicleEntity, false) then
			local serverID = GetPlayerServerId(player)
			if Player(serverID).state.dead then
				return serverID
			end
		end
	end
	return false
end

function CheckWeaponType(weaponHash)
	local weaponCategory
	if IsWeaponValid(weaponHash) then
		local weaponGroup = GetWeapontypeGroup(weaponHash)
		-- Categories based on weapon groups
		local shot = {
			416676503, -- handgun
			860033945, -- shotgun
			970310034, -- assault_rifle
			1159398588, -- mg
			-1212426201 -- sniper_rifle
		}

		for i = 1, #shot do
			if shot[i] == weaponGroup then
				return 'shot'
			end
		end
	end
	return false
end

RegisterNetEvent('wasabi_ambulance:clearPlayerInjury', ClearPatientSymptoms)

exports('clearPlayerInjury', ClearPatientSymptoms)

RegisterNetEvent('wasabi_ambulance:sleepOnBed')
AddEventHandler('wasabi_ambulance:sleepOnBed', function(data)
    local ped = wsb.cache.ped
    local bedCoords = data.bedCoords
    local bedHeading = data.bedHeading

    if IsPedInAnyVehicle(ped, false) then return end
    -- removed isPlayerDead check so dead players can also use bed

    -- Position and freeze the player
    SetEntityCoords(ped, bedCoords.x, bedCoords.y, bedCoords.z + 0.0, false, false, false, false)
    SetEntityHeading(ped, bedHeading)
    FreezeEntityPosition(ped, true)
    ClearPedTasksImmediately(ped)

    -- Load and play sleep animation looping infinitely
    wsb.stream.animDict('anim@gangops@morgue@table@')
    TaskPlayAnim(ped, 'anim@gangops@morgue@table@', 'body_search', 8.0, 1.0, -1, 1, 0, false, false, false)

    -- Handle waiting for key press in a separate thread
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            -- If player presses E, wake up
            if IsControlJustReleased(0, 38) then
                break
            end
        end

        -- After E is pressed:
        -- TriggerEvent('wasabi_bridge:notify', 'Rested', 'You feel well rested!', 'success', 'bed')
       -- SetEntityHealth(ped, GetEntityMaxHealth(ped)) -- also revives if they were dead

        FreezeEntityPosition(ped, false)
        ClearPedTasksImmediately(ped)
        RemoveAnimDict('anim@gangops@morgue@table@')
    end)
end)