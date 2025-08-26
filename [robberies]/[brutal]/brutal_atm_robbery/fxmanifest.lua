shared_script '@WaveShield/resource/include.lua'

fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

author 'Keres & Dév'
description 'Brutal Atm Robbery - store.brutalscripts.com'
version '1.4.4'

client_scripts {
	'config.lua',
	'core/client-core.lua',
	'client/*.lua',
	'cl_utils.lua',
}

server_scripts {
	'config.lua',
	'core/server-core.lua',
	'server/*.lua',
	'sv_utils.lua',
}

dependencies {
    '/server:5181',     -- ⚠️PLEASE READ⚠️; Requires at least SERVER build 5181
    '/gameBuild:2189',  -- ⚠️PLEASE READ⚠️; Requires at least GAME build 2189.
}

escrow_ignore {
    'config.lua',
    'sv_utils.lua',
    'cl_utils.lua',
    'core/client-core.lua',
    'core/server-core.lua',
}

--[[
-- locked
escrow_ignore {
    'config.lua',
    'sv_utils.lua',
    'cl_utils.lua',
    'core/client-core.lua',
    'core/server-core.lua',
}

-- open
escrow_ignore {
    'config.lua',
    'sv_utils.lua',
    'cl_utils.lua',
    'core/client-core.lua',
    'core/server-core.lua',
    'client/client.lua',
    'client/drilling.lua',
    'server/server.lua',
}
--]]
dependency '/assetpacks'