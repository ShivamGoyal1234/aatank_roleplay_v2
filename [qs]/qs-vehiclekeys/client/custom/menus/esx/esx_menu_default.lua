if Config.MenuType ~= 'esx_menu_default' then
    return
end

if Config.Framework == 'qb' then
    return
end

if Config.InventoryScript == 'qs' then
    function GetPlateFromItem(item)
        return item.info and item.info.plate or nil
    end

    function GetModelFromItem(item)
        return item.info and item.info.description or nil
    end
elseif Config.InventoryScript == 'ox' then
    function GetPlateFromItem(item)
        local plate = item.metadata and item.metadata.plate or nil
        return plate
    end

    function GetModelFromItem(item)
        local model = item.metadata and item.metadata.model or nil
        return model
    end
elseif Config.InventoryScript == 'qb' then
    function GetPlateFromItem(item)
        return item.info and item.info.plate or nil
    end

    function GetModelFromItem(item)
        return item.info and item.info.description or nil
    end
elseif Config.InventoryScript == 'codem' then
    function GetPlateFromItem(item)
        return item.info and item.info.plate or nil
    end

    function GetModelFromItem(item)
        return item.info and item.info[1] and item.info[1].description or nil
    end
elseif Config.InventoryScript == 'core_inventory' then
    function GetPlateFromItem(item)
        return item.info and item.info.plate or nil
    end

    function GetModelFromItem(item)
        return item.info and item.info.description or nil
    end
else
    -- Handle other cases or provide a default implementation
    function GetPlateFromItem(item)
        return nil
    end

    function GetModelFromItem(item)
        return nil
    end
end

function OpenCopyKeys()
    local vehicleMenuElements = {
        {
            label = Lang("VEHICLEKEYS_MENU_OWNED_VEHICLES") .. ' - $' .. Config.CopyKeysCost,
            name = "owned_vehicles",
            icon = 'car',
        },
        {
            label = Lang("VEHICLEKEYS_MENU_OWNED_KEYS") .. ' - $' .. Config.InventoryCopyKeysCost,
            name = "owned_keys",
            icon = 'key',
        },
    }

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_keys_menu_choice', {
        title = Lang("VEHICLEKEYS_MENU_CHOICE_TITLE"),
        align = Config.MenuPlacement,
        elements = vehicleMenuElements,
    }, function(data, menu)
        -- Handle menu interactions here
        local currentElement = data.current

        if currentElement.name == "owned_vehicles" then
            OpenVehicleKeysMenu()
        elseif currentElement.name == "owned_keys" then
            OpenOwnedKeysMenu()
        end
    end, function(data, menu)
        menu.close()
    end)
end

function OpenVehicleKeysMenu()
    local vehicleMenuElements = {}
    TriggerServerCallback(Config.Eventprefix..':server:getVehicles', function(vehicles)
        if Config.Debug then
            print(json.encode(vehicles))
        end

        for _,v in pairs(vehicles) do
            local hashVehicle = v.vehicle.model
            local plate = v.vehicle.plate
            local vehicleName = GetDisplayNameFromVehicleModel(hashVehicle)

            print("Plate: " .. plate)
            print("Vehicle Name: " .. vehicleName)


            table.insert(vehicleMenuElements, {
                label = Lang("VEHICLEKEYS_MENU_MODEL").." " .. vehicleName .. ", ".. Lang("VEHICLEKEYS_MENU_PLATE").." " .. plate,
                icon = 'car',
                value = {plate = plate, model = vehicleName},
            })
        end

        table.insert(vehicleMenuElements, {
            label = Lang("BACK_TO_PREVIOUS_MENU"),
            icon = 'arrow-left',
            action = "back",
        })

        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_keys_menu', {
            title = Lang("VEHICLEKEYS_MENU_TITLE"),
            align = Config.MenuPlacement,
            elements = vehicleMenuElements,
        }, function(data, menu)
            local currentElement = data.current
            if currentElement.action == "back" then
                OpenCopyKeys()
            else
              clonekey(data.current.value.plate, data.current.value.model, true, Config.CopyKeysCost)
            end
        end, function(data, menu)
            menu.close()
        end)
    end)
end

function OpenOwnedKeysMenu()
    local elements = {}

    TriggerServerCallback(Config.Eventprefix .. ':server:GetPlayerItems', function(items)
        if items then
            local keysFound = false

            for _, item in pairs(items) do
            local plate = GetPlateFromItem(item)
            local model = GetModelFromItem(item)

            print("Plate:", plate)
            print("Model:", model)

                if plate and model then
                    table.insert(elements, {
                        label  = Lang("VEHICLEKEYS_MENU_MODEL").." " .. model .. ", ".. Lang("VEHICLEKEYS_MENU_PLATE").." " .. plate,
                        icon = 'key',
                        value = {plate = plate, model = model},
                    })

                    keysFound = true
                end
            end

            if not keysFound then
                table.insert(elements, {
                    label = Lang("NO_KEYS_FOUND"),
                    icon = 'exclamation-circle',
                    disabled = true,
                    action = "none",
                })
            end
        end

        table.insert(elements, {
            label = Lang("BACK_TO_PREVIOUS_MENU"),
            icon = 'arrow-left',
            action = "back",
        })

        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_keys_menu', {
            title = Lang("VEHICLEKEYS_MENU_TITLE"),
            align = Config.MenuPlacement,
            elements = elements,
        }, function(data, menu)
            -- Handle menu interactions here
            local currentElement = data.current

            if currentElement.action == "back" then
                OpenCopyKeys()
            elseif currentElement.action == "none" then
                    return
            else
              clonekey(data.current.value.plate, data.current.value.model, true, Config.InventoryCopyKeysCost)
            end
        end, function(data, menu)
            menu.close()
        end)
    end)
end

function OpenPlateMenu()
    if Config.PlateType == 'menu' then
        local plateMenuElements = {
            {
                label = Lang('VEHICLEKEYS_MENU_BUY_PLATE_DESCRIPTION') .. ' - $' .. Config.PlatePrice['price'],
                name = "buy_plate",
                icon = 'car',
                onSelect = function(args, menu)
                    TriggerEvent(Config.Eventprefix .. ':buyPlate')
                end,
            },
            {
                label = Lang('VEHICLEKEYS_MENU_BUY_CHANGEPLATE_DESCRIPTION') .. ' - $' .. Config.ChangePlateItemPrice['price'],
                name = "buy_change_plate",
                icon = 'screwdriver',
                onSelect = function(args, menu)
                    TriggerEvent(Config.Eventprefix .. ':buyScrewdriver')
                end,
            },
        }

        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_keys_menu_plate', {
            title = Lang('VEHICLEKEYS_MENU_TITLE_PLATE'),
            align = Config.MenuPlacement,
            elements = plateMenuElements,
        }, function(data, menu)
            -- Handle menu interactions here
            local currentElement = data.current

            if currentElement.name == "buy_plate" then
                TriggerEvent(Config.Eventprefix .. ':buyPlate')
            elseif currentElement.name == "buy_change_plate" then
                TriggerEvent(Config.Eventprefix .. ':buyScrewdriver')
            end
        end, function(data, menu)
            menu.close()
        end)
    elseif Config.PlateType == 'shop' then
        local generatePlate = GeneratePlate()
        local plate = {
            plate = generatePlate,
        }
        local shop = Lang('VEHICLEKEYS_PLATE_SHOP_NAME')
        local shopItems = {
            label = Lang('VEHICLEKEYS_PLATE_SHOP_LABEL'),
            items = {
                {name = Config.PlateItem, amount = 1, price = Config.PlatePrice['price'], slot = 1, info = plate},
                {name = Config.ChangePlateItem, amount = 1, price = Config.ChangePlateItemPrice['price'], slot = 2},
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
                    label = string.format(Lang('VEHICLEKEYS_TRACKER_MENU_DESC'), v.plate),
                    icon = 'car',
                    value = v.plate
                })
                addedVehicles[v.plate] = true
            end
        end

        if #elements == 0 then
            table.insert(elements, {
                label = Lang('VEHICLEKEYS_TRACKER_NO_VEHICLES'),
                disabled = true
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehiclekeys_gps_menu', {
            title = Lang('VEHICLEKEYS_TRACKER_MENU_TITLE'),
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            if data.current.value then
                TriggerEvent(Config.Eventprefix..':client:LocateVehicleWithPlate', data.current.value)
            end
        end, function(data, menu)
            menu.close()
        end)
    end)
end
