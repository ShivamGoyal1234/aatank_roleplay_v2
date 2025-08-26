if Config.Wardrobe ~= 'raid_clothes' then
    return
end

function OpenClotheMenu()
    TriggerEvent('raid_clothes:openmenu')
end
