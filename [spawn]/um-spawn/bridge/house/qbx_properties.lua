if not um.property.houses then return end

if GetResourceState('qbx_properties') ~= 'started' then return end

Debug('qbx_properties for houses', 'debug')

lib.callback.register('getHouses', function(source)
    local citizenid = GetCitizenID(GetPlayer(source))
    local houses = MySQL.query.await('SELECT id, property_name, coords FROM properties WHERE owner = ?',
        { citizenid })

    local found = houses[1] ~= nil
    Debug(found and 'Houses: Found Houses' or 'Houses: Not Found')

    return found and houses or false
end)
