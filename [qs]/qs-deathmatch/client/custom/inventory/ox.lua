if Config.Inventory ~= 'ox' then
    return
end

local OxInventory = exports['ox_inventory']

-- Enable or disable the gta 5 weapon wheel
function WeaponWheel(toggle)
    print('WeaponWheel', toggle)
    OxInventory:weaponWheel(toggle)
end
