if Config.MenuType ~= 'ox_lib' then
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
    local elements = {}
    local vehicleMenu = {
        {
            title = Lang("VEHICLEKEYS_MENU_OWNED_VEHICLES") .. ' - $' .. Config.CopyKeysCost,
            icon = 'car',
            onSelect = function(args)
                OpenVehicleKeysMenu()
            end,
        },
        {
            title = Lang("VEHICLEKEYS_MENU_OWNED_KEYS") .. ' - $' .. Config.InventoryCopyKeysCost,
            icon = 'key',
            onSelect = function(args)
                OpenOwnedKeysMenu()
            end,
        },
    }
    lib.registerContext({
        id = 'VEHICLEKEYS_MENU_CHOICE',
        title = Lang("VEHICLEKEYS_MENU_CHOICE_TITLE"),
        options = vehicleMenu,
    })
    lib.showContext('VEHICLEKEYS_MENU_CHOICE')
end

function OpenVehicleKeysMenu()
    local elements = {}
    TriggerServerCallback(Config.Eventprefix..':server:getVehicles', function(vehicles)
        if Config.Debug then
            print(json.encode(vehicles))
        end
        for _,v in pairs(vehicles) do
            local hashVehicule = v.vehicle.model
            local plate = v.vehicle.plate
            local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)

            table.insert(elements, {
                title  = Lang("VEHICLEKEYS_MENU_MODEL").." " .. vehicleName .. ", ".. Lang("VEHICLEKEYS_MENU_PLATE").." " .. plate,
                icon = 'car',
                onSelect = function(args)
                    clonekey(plate, vehicleName, true, Config.CopyKeysCost)
                end,
            })
        end
        table.insert(elements, {
            title = Lang("BACK_TO_PREVIOUS_MENU"),
            icon = 'arrow-left',
            onSelect = function(args)
                OpenCopyKeys()
            end,
        })
        lib.registerContext({
            id = 'VEHICLEKEYS_MENU_TITLE',
            title = Lang("VEHICLEKEYS_MENU_TITLE"),
            options = elements,
        })
        lib.showContext('VEHICLEKEYS_MENU_TITLE')
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
                if plate and model then
                    keysFound = true
                    table.insert(elements, {
                        title  = Lang("VEHICLEKEYS_MENU_MODEL").." " .. model .. ", ".. Lang("VEHICLEKEYS_MENU_PLATE").." " .. plate,
                        icon = 'key',
                        onSelect = function(args)
                            clonekey(plate, model, true, Config.InventoryCopyKeysCost)
                        end,
                    })
                end
            end
            if not keysFound then
                table.insert(elements, {
                    title = Lang("NO_KEYS_FOUND"),
                    icon = 'exclamation-circle',
                    disabled = true,
                })
            end
        end
        table.insert(elements, {
            title = Lang("BACK_TO_PREVIOUS_MENU"),
            icon = 'arrow-left',
            onSelect = function(args)
                OpenCopyKeys()
            end,
        })
        lib.registerContext({
            id = 'VEHICLEKEYS_MENU_TITLE',
            title = Lang("VEHICLEKEYS_MENU_TITLE"),
            options = elements,
        })
        lib.showContext('VEHICLEKEYS_MENU_TITLE')
    end)
end

function OpenPlateMenu()
    if Config.PlateType == 'menu' then
        local elements = {}

        table.insert(elements, {
            title    = Lang('VEHICLEKEYS_MENU_BUY_PLATE_DESCRIPTION') .. ' - $' .. Config.PlatePrice['price'],
            icon     = 'car',
            onSelect = function(args)
                TriggerEvent(Config.Eventprefix .. ':buyPlate')
            end,
        })

        table.insert(elements, {
            title    = Lang('VEHICLEKEYS_MENU_BUY_CHANGEPLATE_DESCRIPTION') .. ' - $' .. Config.ChangePlateItemPrice['price'],
            icon     = 'screwdriver',
            onSelect = function(args)
                TriggerEvent(Config.Eventprefix .. ':buyScrewdriver')
            end,
        })

        lib.registerContext({
            id      = 'VEHICLEKEYS_MENU_TITLE_PLATE',
            title   = Lang('VEHICLEKEYS_MENU_TITLE_PLATE'),
            options = elements,
        })

        lib.showContext('VEHICLEKEYS_MENU_TITLE_PLATE')
    end

    if Config.PlateType == 'shop' then
        local generatePlate = GeneratePlate()
        local plate = { plate = generatePlate }
        local shop = Lang('VEHICLEKEYS_PLATE_SHOP_NAME')
        local ShopItems = {
            label = Lang('VEHICLEKEYS_PLATE_SHOP_LABEL'),
            items = {
                { name = Config.PlateItem, amount = 1, price = Config.PlatePrice['price'], slot = 1, info = plate },
                { name = Config.ChangePlateItem, amount = 1, price = Config.ChangePlateItemPrice['price'], slot = 2 },
            },
        }
        TriggerServerEvent("inventory:server:OpenInventory", "shop", shop, ShopItems)
    end
end

function OpenTrackerMenu(gpsdata)
    local addedVehicles = {}

    TriggerServerCallback(Config.Eventprefix..':server:GetPlayerIdentifier', function(PlayerIdentifier)
        lib.registerContext({
            id = 'vehiclekeys_gps_menu',
            title = Lang('VEHICLEKEYS_TRACKER_MENU_TITLE'),
            options = (function()
                local options = {}
                for _, v in ipairs(gpsdata) do
                    if v.Player == PlayerIdentifier and not addedVehicles[v.plate] then
                        table.insert(options, {
                            title = v.model,
                            description = string.format(Lang('VEHICLEKEYS_TRACKER_MENU_DESC'), v.plate),
                            icon = 'car',
                            onSelect = function() TriggerEvent(Config.Eventprefix..':client:LocateVehicleWithPlate', v.plate) end
                        })
                        addedVehicles[v.plate] = true
                    end
                end
                if #options == 0 then
                    table.insert(options, { title = Lang('VEHICLEKEYS_TRACKER_NO_VEHICLES'), disabled = true })
                end
                return options
            end)()
        })

        lib.showContext('vehiclekeys_gps_menu')
    end)
end

