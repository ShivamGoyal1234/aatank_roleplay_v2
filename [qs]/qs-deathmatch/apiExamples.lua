-- Client-Side Export & Event
-- Export: IsPlayerInDM()
-- Example:

if exports['qs-deathmatch']:IsPlayerInDM() then
	print('Player is in a Deathmatch match')
end

-- Event Name: deathmatch:inDeathmatch
-- Example:

local inDeathmatch = false
AddEventHandler('deathmatch:inDeathmatch', function(state)
	inDeathmatch = state
end)

-- Server-Side Export
-- Export: IsPlayerInDM(source)
-- Example:

if exports['qs-deathmatch']:IsPlayerInDM(source) then
	print('Player: ' .. source .. ' is in a Deathmatch match')
end
