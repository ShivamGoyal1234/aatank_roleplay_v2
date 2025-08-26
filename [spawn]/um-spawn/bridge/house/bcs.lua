if not um.property.houses then return end

if GetResourceState('bcs_housing') ~= 'started' then return end

Debug('bcs_housing for house', 'debug')

lib.callback.register('getHouses', function(source)
    local citizenid = GetCitizenID(GetPlayer(source))
    local houses = exports.bcs_housing:GetOwnedHomeKeys(citizenid)

    local found = houses[1] ~= nil
    Debug(found and 'Houses: Found Houses' or 'Houses: Not Found')

    return found and houses or false
end)
