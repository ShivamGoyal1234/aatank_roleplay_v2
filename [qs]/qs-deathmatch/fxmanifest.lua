shared_script '@WaveShield/resource/include.lua'
shared_script '@WaveShield/resource/waveshield.js'

fx_version 'adamant'

games { 'gta5' }

lua54 'yes'

version '1.0.5'

ui_page 'html/index.html'

files {
	'html/**/**/**'
}

shared_scripts {
	'shared/*',
	'locales/*',
	'utils.lua'
}

client_scripts {
	'client/custom/**/*.lua',
	'client/main.lua'
}

server_scripts {
	'server/**/**.lua'
}

escrow_ignore {
	'apiExamples.lua',
	'shared/*.lua',
	'locales/*.lua',
	'client/custom/**/**.lua',
    'server/custom/**/**.lua'
}

dependency '/assetpacks'