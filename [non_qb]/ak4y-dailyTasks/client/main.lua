if AK4Y.Framework == "qb" then
    QBCore = exports['qb-core']:GetCoreObject()
elseif AK4Y.Framework == "oldqb" then 
    QBCore = nil
end

local mySelectedTask = nil
local openMenuSpamProtect = 0
local done = false
local started = false

Citizen.CreateThread(function()
    if AK4Y.Framework == "oldqb" then 
        while QBCore == nil do
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
            Citizen.Wait(200)
        end
	elseif AK4Y.Framework == "qb" then
		while QBCore == nil do
            Citizen.Wait(200)
        end
    end
	PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
	PlayerData = QBCore.Functions.GetPlayerData()
    Wait(1000)
	QBCore.Functions.TriggerCallback("ak4y-dailyTasks:playTimeCheck", function(result)
        if result then 
            mySelectedTask = json.decode(result.selectedTask)
            if result.done == 1 then 
                done = true 
            end
            playTime = GetGameTimer() + ((mySelectedTask.neededPlayTime - (mySelectedTask.neededPlayTime - result.playTime)) * 60000)
            Wait(1)
            playTimeMin = getNeededPlayTime()
            Wait(1)
            startTime()
        end
	end)
end)

RegisterCommand(AK4Y.MenuCommand, function()
    local remainingTime
    if playTimeMin ~= nil and playTimeMin > 0 then
        local sa = tonumber(getNeededPlayTime()*60)
        remainingTime = disp_time(sa)
    else
        remainingTime = "DONE"
    end
	SetNuiFocus(true,true)
	SendNUIMessage({
		action = 'show',
        tasks = AK4Y.Tasks, 
        playerDetails = mySelectedTask,
        playTime = playTimeMin,
        remaining = remainingTime,
        done = done,
        language = AK4Y.Language,
	})	
end)

RegisterNUICallback('closeMenu', function(data, cb)
	SetNuiFocus(false, false)
end)

RegisterNUICallback('selectTask', function(data, cb)
	QBCore.Functions.TriggerCallback("ak4y-dailyTasks:selectTask", function(result)
        if result then 
            mySelectedTask = data.itemDetails
            playTime = GetGameTimer() + ((mySelectedTask.neededPlayTime) * 60000)
            Wait(1)
            playTimeMin = getNeededPlayTime()
            Wait(1)
            if not started then 
                startTime()
            end
        end
        cb(result)
    end, data)
end)

RegisterNUICallback('cancelTask', function(data, cb)
	QBCore.Functions.TriggerCallback("ak4y-dailyTasks:cancelTask", function(result)
        if result then 
            mySelectedTask = nil
            done = false
            playTimeMin = nil
        end
        cb(result)
    end, data)
end)

RegisterNUICallback('getReward', function(data, cb)
	QBCore.Functions.TriggerCallback("ak4y-dailyTasks:getReward", function(result)
        if result then 
            mySelectedTask = nil
            done = false
            playTimeMin = nil
        end
        cb(result)
    end)
end)

function startTime()
    started = true
	Citizen.CreateThread(function()
		Wait(1000)
		while true do 
			playTimeMin = getNeededPlayTime()
            if not done then 
                if playTimeMin ~= nil and playTimeMin <= 0 then 
                    done = true
                    TriggerServerEvent('ak4y-dailyTasks:setDone')
                    started = false
                    break
                end
            else
                started = false
                break
            end
			Wait(5000)
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Wait(1 * 60000)
        if not done then
            if playTimeMin ~= nil and playTimeMin > 0 then 
                TriggerServerEvent('ak4y-dailyTasks:updateTime', playTimeMin)
            end
        end
	end
end)

getNeededPlayTime = function()
    return math.round((playTime - GetGameTimer()) / 60000)
end

function disp_time(time)
    local days = math.floor(time/86400)
    local remaining = time % 86400
    local hours = math.floor(remaining/3600)
    remaining = remaining % 3600
    local minutes = math.floor(remaining/60)
    remaining = remaining % 60
    local seconds = remaining
    if (hours < 10) then
        hours = "0" .. tostring(hours)
    end
    if (minutes < 10) then
        minutes = "0" .. tostring(minutes)
    end
    if (seconds < 10) then
        seconds = "0" .. tostring(seconds)
    end
    if hours ~= "00" then 
        answer = hours..'h '..minutes..'m'
    else
        answer = minutes..'m'

    end
    return answer
end