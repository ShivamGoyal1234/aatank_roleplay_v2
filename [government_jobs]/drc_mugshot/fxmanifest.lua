shared_script '@WaveShield/resource/include.lua'

fx_version 'cerulean'

game 'gta5'

author 'DRC Scripts'
description 'DRC MUGSHOT'

version '2.0.0'

lua54 'yes'

shared_scripts {
	'@ox_lib/init.lua',
	'shared/*.lua',
}

client_scripts {
	'client/*.lua',
}

server_scripts {
	'server/*.lua',
	'@oxmysql/lib/MySQL.lua'
}

files {
	'locales/*.json'
}

escrow_ignore {
	'shared/*.lua',
	'client/cl_Utils.lua',
	'server/sv_Utils.lua',
}

dependency '/assetpacks'