if not um.property.apartments then return end

if GetResourceState('bcs_housing') ~= 'started' then return end

Debug('bcs_housing for apartments', 'debug')

lib.callback.register('getApartments', function(source)
    local citizenid = GetCitizenID(GetPlayer(source))
    local apartments = MySQL.single.await('SELECT identifier, apartment FROM house_apartment WHERE owner = ?',
        { citizenid })

    local found = apartments?.apartment and true or false

    Debug(found and 'Apartments: Found Apartments' or 'Apartments: Not Found')

    return found and apartments or false
end)
