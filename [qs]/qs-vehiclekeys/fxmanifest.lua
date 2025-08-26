shared_script '@WaveShield/resource/include.lua'

fx_version 'cerulean'

games { 'gta5' }

lua54 'yes'

version '4.0.29'

name 'qs-vehiclekeys'
author 'Quasar Store'

shared_scripts {
	'@ox_lib/init.lua',
	'shared/*.lua',
	'config/*.lua',
	'locales/*.lua',
	'client/utils.lua',
}

client_scripts {
	'client/utils.lua',
	'client/custom/**/*.lua',
	'client/modules/*.lua',
	'client/functions.lua',
	'client/main.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/version.lua',
	'server/utils.lua',
	'server/custom/**/*.lua',
	'server/modules/*.lua',
	'server/main.lua',
}

escrow_ignore {
	'config/*.lua',
	'locales/*.lua',
	'client/custom/framework/*.lua',
	'server/custom/framework/*.lua',
	'client/custom/**/*.lua',
	'server/custom/**/*.lua',
	'client/custom/menus/**/*.lua',
	'gps.json',
}

dependencies {
	'/server:4752', -- ⚠️PLEASE READ⚠️ This requires at least server build 4752 or higher
	'/gameBuild:3095',
	'ox_lib',    -- https://github.com/overextended/ox_lib NEED AT LEAST v3.0.0 for the radial menu
}

dependency '/assetpacks'