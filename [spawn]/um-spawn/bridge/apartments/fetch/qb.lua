if not um.property.apartments then return end

if GetResourceState('qb-apartments') ~= 'started' then return end

Debug('qb apartments for apartments', 'debug')

lib.callback.register('getApartments', function(source)
    local citizenid = GetCitizenID(GetPlayer(source))
    local apartments = MySQL.single.await('SELECT * FROM apartments WHERE citizenid = ?', { citizenid })

    local found = apartments ~= nil
    Debug(found and 'Apartments: Found Apartments' or 'Apartments: Not Found')

    return found and apartments or false
end)
