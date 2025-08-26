shared_script '@WaveShield/resource/include.lua'

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'vames™️'
description 'vms_garagesv2'
version '1.3.4'

shared_scripts {
	'config/config.lua',
	'config/config.garages.lua',
	'CREATED_PARKINGS/*.lua',
	'config/config.management.lua',
	'config/config.parkingcreator.lua',
	'config/config.translation.lua',
}

client_scripts {
	'client/lib.lua',
	'client/functions.lua',
	'client/main.lua',
	'client/nui.lua',
	'client/modules/*.lua',
	'config/config.client.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config/config.server.lua',
	'server/lib.lua',
	'server/main.lua',
	'server/version_check.lua',
	'server/migration/*.lua',
	'server/[housing]/*.lua'
}

ui_page 'html/ui.html'

files {
	'html/*.*',
	'html/**/*.*',
	'config/*.js',
	'config/translation.json',
}

escrow_ignore {
	'config/*.lua',
	'CREATED_PARKINGS/*.lua',

	'server/[housing]/*.lua',
	'server/migration/*.lua',
	'server/version_check.lua',
}
dependency '/assetpacks'