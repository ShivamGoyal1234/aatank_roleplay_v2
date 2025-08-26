Citizen.CreateThread(function()
    while true do
        local Sleep = 2000
        if WorkThread then
            local pedPlayer = PlayerPedId()
            Sleep = 1
            local pedCoord = GetEntityCoords(pedPlayer)

            for angle = 0, 360, 5 do
                local radian = math.rad(angle)
                local x = pedCoord.x + RadiusValue * math.cos(radian)
                local y = pedCoord.y + RadiusValue * math.sin(radian)
                local z = pedCoord.z - 1.0
                
                DrawMarker(1, pedCoord.x, pedCoord.y, pedCoord.z - 1.0, 0, 0, 0, 0, 0, 0, RadiusValue, RadiusValue, 0.2, 255, 0, 0, 100, false, false, 2, nil, nil, false)
            end
        end

        Citizen.Wait(Sleep)
    end
end)

Location = function()
    while true do
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
        local zone = tostring(GetNameOfZone(x, y, z))
        if type(Zones) == 'table' then
            if not zone then
                zone = "UNKNOWN"
                Zones['UNKNOWN'].Name = zone
            elseif not Zones[zone] then
                if zone ~= nil and Zones[zone] ~= nil then
                    Zones[zone].Name = "Unkown"
                end
            end
            if zone ~= nil and Zones[zone] ~= nil then
                if Zones[zone].Name ~= nil then
                    PlayerClientLocation = Zones[zone].Name
                end
            end
        end
		Citizen.Wait(6000)
	end
end
