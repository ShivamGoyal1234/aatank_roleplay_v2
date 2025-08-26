if not um.property.apartments then return end

if GetResourceState('qbx_properties') ~= 'started' then return end

Debug('qbx_properties for apartments', 'debug')

lib.callback.register('getApartments', function(source)
    local citizenid = GetCitizenID(GetPlayer(source))
    local apartments = MySQL.single.await('SELECT id, property_name, coords FROM properties WHERE owner = ?',
        { citizenid })
    local found = apartments ~= nil
    Debug(found and 'Apartments: Found Apartments' or 'Apartments: Not Found')

    return found and apartments or false
end)
