if not um.property.apartments then return end

if GetResourceState('ps-housing') ~= 'started' then return end

Debug('ps-housing for apartments', 'debug')

lib.callback.register('getApartments', function(source)
    local citizenid = GetCitizenID(GetPlayer(source))
    local apartments = MySQL.single.await('SELECT * FROM properties WHERE owner_citizenid = ? AND apartment IS NOT NULL',
        { citizenid })

    local found = apartments ~= nil
    Debug(found and 'Apartments: Found Apartments' or 'Apartments: Not Found')

    return found and apartments or false
end)
