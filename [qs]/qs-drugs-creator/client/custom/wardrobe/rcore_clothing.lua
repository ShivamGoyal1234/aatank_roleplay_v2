if Config.Wardrobe ~= 'rcore_clothing' then
    return
end

function OpenClotheMenu()
    TriggerEvent('rcore_clothing:openChangingRoom')
end
