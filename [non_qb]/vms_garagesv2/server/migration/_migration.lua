Migration = {}

local LAST_OWNED_GARAGES_TABLE = 'copy-owned_vehicles'

local GARAGE_AFTER_MIGRATION = ''
local MIGRATION_TO_IMPOUND = true

RegisterCommand('migrate', function(source, args, rawCommand)
    if source ~= 0 then
        print('The command can only be used in the console.')
        return
    end

    if Migration[args[1]] then
        Migration[args[1]](LAST_OWNED_GARAGES_TABLE, GARAGE_AFTER_MIGRATION, MIGRATION_TO_IMPOUND)
        print('Started migration from ' .. args[1] .. ' to vms_garagesv2.')
    else
        print('Garage system ' .. args[1] .. ' is not supported for migration.')
        print('You can add migration command in the vms_garagesv2/server/migration/')
    end
end, true)