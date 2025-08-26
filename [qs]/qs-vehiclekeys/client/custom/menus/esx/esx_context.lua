if Config.MenuType ~= 'esx_context' then
    return
end

if Config.Framework == 'qb' then
    return
end

function OpenCopyKeys()
    local elements = {}
    TriggerServerCallback(Config.Eventprefix..':server:getVehicles', function(vehicles)
        table.insert(elements, {
            title = Lang("VEHICLEKEYS_MENU_TITLE")
        })
        for _,v in pairs(vehicles) do
            local hashVehicule = v.vehicle.model
            local plate = v.vehicle.plate
            local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
            table.insert(elements, {
                title = Lang("VEHICLEKEYS_MENU_MODEL").." " .. vehicleName .. " ".. Lang("VEHICLEKEYS_MENU_PLATE").." " .. plate ,
                name = "take",
                metadata = {vehicleName, plate}
            })
        end
        ESX.OpenContext("right" , elements, function(menu,element)
            if element.name == "take" then
                clonekey(element.metadata[2], element.metadata[1])
                ESX.CloseContext()
            end
        end, function(menu)
            ESX.CloseContext()
        end)
    end)
end

function OpenPlateMenu()

if Config.PlateType == 'menu' then


    local elements = {}
    table.insert(elements, {
        title = Lang("VEHICLEKEYS_MENU_BUY_PLATE")
    })
    table.insert(elements, {
        title = Lang("VEHICLEKEYS_MENU_BUY_PLATE_DESCRIPTION")..Config.NPCPlatePrice['price'],
        name = "take",
    })
    table.insert(elements, {
        title = Lang('VEHICLEKEYS_MENU_BUY_CHANGEPLATE_DESCRIPTION') .. Config.ChangePlateItemPrice['price'],
        name = "screwdriver",
})   
    ESX.OpenContext("right" , elements, function(menu,element)
        if element.name == "take" then
            TriggerEvent(Config.Eventprefix..':buyPlate')
            ESX.CloseContext()
        elseif element.name == "screwdriver" then
            TriggerEvent(Config.Eventprefix..':buyScrewdriver')
            ESX.CloseContext()
        end
    end, function(menu)
        ESX.CloseContext()
    end)

end

if Config.PlateType == 'shop' then

local generatePlate = GeneratePlate()
local plate = {
    plate = generatePlate,
}
    local shop = Lang('VEHICLEKEYS_PLATE_SHOP_NAME')
    local ShopItems = {
        label = Lang('VEHICLEKEYS_PLATE_SHOP_LABEL'),
        items = {
            {name = Config.PlateItem ,amount = 1, price = Config.PlatePrice['price'], slot= 1, info = plate },
            {name = Config.ChangePlateItem, amount = 1, price = Config.ChangePlateItemPrice['price'], slot = 2 },
        },
    }
    TriggerServerEvent("inventory:server:OpenInventory", "shop", shop, ShopItems)

end

end

function OpenTrackerMenu(gpsdata)
    local addedVehicles = {}

    TriggerServerCallback(Config.Eventprefix..':server:GetPlayerIdentifier', function(PlayerIdentifier)
        local elements = {}

        for _, v in ipairs(gpsdata) do
            if v.Player == PlayerIdentifier and not addedVehicles[v.plate] then
                table.insert(elements, {
                    icon = 'car',
                    title = string.format(Lang('VEHICLEKEYS_TRACKER_MENU_DESC'), v.plate),
                    value = v.plate
                })
                addedVehicles[v.plate] = true
            end
        end

        if #elements == 0 then
            table.insert(elements, {
                icon = 'times',
                title = Lang('VEHICLEKEYS_TRACKER_NO_VEHICLES'),
                disabled = true
            })
        end

        ESX.OpenContext("right" , elements, function(data)
            if data.current.value then
                TriggerEvent(Config.Eventprefix..':client:LocateVehicleWithPlate', data.current.value)
            end
        end)
    end)
end
