if not um.property.houses then return end

if GetResourceState('nolag_properties') ~= 'started' then return end

Debug('nolag_properties for house', 'debug')

lib.callback.register('getHouses', function(source)
  local citizenid = GetCitizenID(GetPlayer(source))
  local houses = MySQL.query.await([[
        SELECT
          CASE
            WHEN p.type = 'mlo' THEN JSON_EXTRACT(p.metadata, '$.yardZone.center')
            WHEN p.buildingid IS NOT NULL THEN JSON_EXTRACT(b.metadata, '$.enterData')
            ELSE JSON_EXTRACT(p.metadata, '$.enterData')
          END AS camCoords,
          p.id,
          p.label
        FROM
            properties p
        LEFT JOIN
            buildings b ON p.buildingId = b.id
        INNER JOIN
            properties_owners po ON p.ownerid = po.id
        WHERE po.identifier = ?;
      ]], { citizenid })

  local found = houses[1] ~= nil
  Debug(found and 'Houses: Found Houses' or 'Houses: Not Found')

  return found and houses or false
end)
