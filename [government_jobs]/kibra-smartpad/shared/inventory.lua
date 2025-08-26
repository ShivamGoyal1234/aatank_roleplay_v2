Inventory = {}
Inventory.custom = true

if GetResourceState('qb-inventory') ~= 'missing' then
    Inventory.qb = true
    Inventory.custom = false
end

if GetResourceState('qs-inventory') ~= 'missing' then
    Inventory.qs = true
    Inventory.custom = false
end

if GetResourceState('core_inventory') ~= 'missing' then
    Inventory.core = true
    Inventory.custom = false
end

if GetResourceState('ps-inventory') ~= 'missing' then
    Inventory.ps = true
    Inventory.custom = false
end

if GetResourceState('lj-inventory') ~= 'missing' then
    Inventory.lj = true
    Inventory.custom = false
end

if GetResourceState('codem-inventory') ~= 'missing' then
    Inventory.codem = true
    Inventory.custom = false
end

if GetResourceState('ox_inventory') ~= 'missing' then
    Inventory.ox = true
    Inventory.custom = false
end
