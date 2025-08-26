shared_script '@WaveShield/resource/include.lua'

fx_version 'cerulean'
game 'gta5'
lua54 'yes'
escrow_ignore {
	'client/*.lua',
	'shared/config.lua'
}
shared_scripts {
    'shared/config.lua'
}
client_scripts {
	'@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
	'client/*.lua'
}
ui_page 'html/index.html'
files {
	'html/index.html',
	'html/style.css',
	'html/index.js'
}
dependency '/assetpacks'
dependency '/assetpacks'
dependency '/assetpacks'