if Config.MenuType ~= 'qb' then
    return
end

if Config.Framework == 'esx' then
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

    -- Ensure Config is defined and has the expected properties
    if not Config or not Config.MenuType or not Config.CopyKeysCost or not Config.InventoryCopyKeysCost then
        print("Error: Config is not properly defined.")
        return
    end

    -- Add the menu header
    table.insert(elements, {
        header = Lang("VEHICLEKEYS_MENU_CHOICE_TITLE"),
        icon = 'fa-solid fa-infinity',
        isMenuHeader = true,
    })

    -- Add menu options
    table.insert(elements, {
        header = Lang("VEHICLEKEYS_MENU_OWNED_VEHICLES") .. ' - $' .. Config.CopyKeysCost,
        icon = 'car',
        params = {
            isAction = true,
            event = OpenVehicleKeysMenu, -- Reference to the function without ()
            args = {}
        }
    })

    table.insert(elements, {
        header = Lang("VEHICLEKEYS_MENU_OWNED_KEYS") .. ' - $' .. Config.InventoryCopyKeysCost,
        icon = 'key',
        params = {
            isAction = true,
            event = OpenOwnedKeysMenu, -- Reference to the function without ()
            args = {}
        }
    })

    -- Ensure 'qb-menu' is set correctly
    if not exports['qb-menu'] then
        print("Error: qb-menu resource not found.")
        return
    end

    exports['qb-menu']:openMenu(elements)
end


function OpenVehicleKeysMenu()
    local elements = {}

    TriggerServerCallback(Config.Eventprefix..':server:getVehicles', function(vehicles)
        table.insert(elements, {
            isMenuHeader  = true,
            header = Lang("VEHICLEKEYS_MENU_TITLE"),
            icon = 'fa-solid fa-infinity'
        })

        for k,v in pairs(vehicles) do -- loop through our table
            if not v.vehicle then
                return print('Missing vehicle:', v.vehicle)
            elseif not v.plate then
                return print('Missing plate:', v.plate, ' Vehicle:', v.vehicle)
            end

            if not QBCore.Shared.Vehicles or not QBCore.Shared.Vehicles[v.vehicle] or not QBCore.Shared.Vehicles[v.vehicle]['name'] then
                return print('Missing vehicle details:', v.vehicle, 'QBShared : ', QBCore.Shared.Vehicles[v.vehicle] and QBCore.Shared.Vehicles[v.vehicle]['name'] or 'nil')
            end

            table.insert(elements, {
                header = Lang("VEHICLEKEYS_MENU_MODEL").." " .. QBCore.Shared.Vehicles[v.vehicle]['name'] .. " ",
                txt = Lang("VEHICLEKEYS_MENU_PLATE").." " .. v.plate,
                icon = 'fa-solid fa-face-grin-tears',
                params = {
                    isAction = true,
                    event = function()
                        clonekey(v.plate, QBCore.Shared.Vehicles[v.vehicle]['model'], true, Config.CopyKeysCost)
                    end,
                    args = {}
                }
            })


            table.insert(elements, {
                header = Lang("BACK_TO_PREVIOUS_MENU"),
                icon = 'arrow-left',
                params = {
                    isAction = true,
                    event = OpenCopyKeys,
                    args = {}
                }
            })
        end

        exports[qb_menu_name]:openMenu(elements) -- open our menu
    end)
end

function OpenOwnedKeysMenu()
    local elements = {}

    TriggerServerCallback(Config.Eventprefix .. ':server:GetPlayerItems', function(items)
        if items and next(items) ~= nil then -- Check if items is not empty
            local keysFound = false
            for _, item in pairs(items) do
                local plate = GetPlateFromItem(item)
                local model = GetModelFromItem(item)
                if plate and model then
                    keysFound = true
                    table.insert(elements, {
                        header = Lang("VEHICLEKEYS_MENU_MODEL").." " .. model .. " ",
                        txt = Lang("VEHICLEKEYS_MENU_PLATE").." " .. plate,
                        icon = 'fa-solid fa-face-grin-tears',
                        params = {
                            isAction = true,
                            event = function()
                                clonekey(plate, model, true, Config.InventoryCopyKeysCost)
                            end,
                            args = {}
                        }
                    })
                end
            end

            if not keysFound then
                table.insert(elements, {
                    header = Lang("NO_KEYS_FOUND"),
                    icon = 'exclamation-circle',
                    disabled = true,
                })
            end
        else
            table.insert(elements, {
                header = Lang("NO_KEYS_FOUND"),
                icon = 'exclamation-circle',
                disabled = true,
            })
        end

        table.insert(elements, {
            header = Lang("BACK_TO_PREVIOUS_MENU"),
            icon = 'arrow-left',
            params = {
                isAction = true,
                event = OpenCopyKeys,
                args = {}
            }
        })

        -- Adapt the following lines for qb-menu
        exports['qb-menu']:openMenu(elements) -- open our menu
    end)
end



function OpenPlateMenu()
    if Config.PlateType == 'menu' then
        local elements = {}
        table.insert(elements, {
            isHeader = true,
            header = Lang("VEHICLEKEYS_MENU_TITLE_PLATE"),
            icon = 'fa-solid fa-toolbox',
            isMenuHeader = true,
        })
        table.insert(elements, {
            header = Lang("VEHICLEKEYS_MENU_BUY_PLATE"),
            txt = Lang("VEHICLEKEYS_MENU_BUY_PLATE_DESCRIPTION")..Config.PlatePrice['price'],
            icon = 'fa-solid fa-face-grin-tears',
            params = {
                event = Config.Eventprefix..':buyPlate',
            }
        })
        table.insert(elements, {
        header = Lang("VEHICLEKEYS_MENU_BUY_SCREWDRIVER"),
        txt = Lang('VEHICLEKEYS_MENU_BUY_CHANGEPLATE_DESCRIPTION') .. Config.ChangePlateItemPrice['price'],
        icon = 'fa-solid fa-screwdriver',
        params = {
            event = Config.Eventprefix..':buyScrewdriver',
        }
        })
        exports[qb_menu_name]:openMenu(elements)
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
                    header = string.format(Lang('VEHICLEKEYS_TRACKER_MENU_DESC'), v.plate),
                    txt = v.model,
                    icon = 'car',
                    params = {
                        isAction = true,
                        event = function()
                            TriggerEvent(Config.Eventprefix..':client:LocateVehicleWithPlate', v.plate)
                        end,
                        args = {}
                    }
                })
                addedVehicles[v.plate] = true
            end
        end

        if #elements == 0 then
            table.insert(elements, {
                header = Lang('VEHICLEKEYS_TRACKER_NO_VEHICLES'),
                icon = 'exclamation-circle',
                disabled = true,
            })
        end

        table.insert(elements, {
            header = Lang('BACK_TO_PREVIOUS_MENU'),
            icon = 'arrow-left',
            params = {
                isAction = true,
                event = OpenPreviousMenu,  -- Cambiar a la función para regresar al menú anterior
                args = {}
            }
        })

        -- Open the menu using qb-menu
        exports['qb-menu']:openMenu(elements) -- Abre el menú
    end)
end
