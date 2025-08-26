Config = Config or {}

-- For more info check: https://mt-scripts-documentations.gitbook.io/mt-script-documentation/

Config.debug = false -- if true it'll print some debug on F8/console and active all zones debug
Config.framework = 'qb' -- qb, qbx, esx (need to change the export on the Config.core)
Config.core = exports['qb-core']:GetCoreObject() -- Your core export (for qb is exports['qb-core']:GetCoreObject()) (for esx is exports.es_extended:getSharedObject()) (for qbx you can just delete this line and add '@qbx_core/modules/playerdata.lua', to the fxmanifest.lua client_scripts)
Config.target = 'qb-target' -- ox_target, qb-target, interact, ...
Config.banking = 'qb-banking' -- qb-banking, Renewed-Banking, (can change at server/functions.lua) ...
Config.keys = 'qs-vehiclekeys' -- qb-vehiclekeys, qbx_vehiclekeys, mk_vehiclekeys, qs-vehiclekeys
Config.locale = 'en'

Config.useTabletAnimation = true

Config.mInsurance = {
    enable = true, -- Enable use m-Insurance?
    inventory = "qb", -- "qb" or "ox" | If you use esx leave this "ox"
}

Config.webhooks = {
    vehicleImported = 'https://discord.com/api/webhooks/1392491053281579049/cY2XFUHYQInB92XOW6Rx19FBte7h8hbdC_eRdDML-PLqGW1HuS4cZsRWww0SvoB0SFRA',
    vehicleBought = 'https://discord.com/api/webhooks/1378988811954163764/NUkks0ZfO-89YnsyPPxWZVfPRh4MYCkXcwk9iF54lPK_nayi3VkgK4JNWM7WYEdnzJiq',
    adminCommand = 'https://discord.com/api/webhooks/1392491327991578664/FGTERydoByb4hFwI2HcenwJUPxuYDXy2JKnDVfEIExORRw2Xe5Zz5gzZ_MR41PHPPhqw'
}

Config.commands = {
    addStock = { command = 'addstock', restricted = 'group.admin' },
    removeStock = { command = 'removestock', restricted = 'group.admin' },
}