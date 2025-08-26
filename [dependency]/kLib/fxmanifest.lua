shared_script '@WaveShield/resource/include.lua'

;fx_version 'cerulean'
game 'gta5'
author 'kypos'
description 'Kypos Util Lib'
version '1.0.0'
lua54 'yes'
use_experimental_fxv2_oal "yes"

ui_page 'nui/index.html'

files {
    'nui/index.html',
    'nui/*.mp3',
    'nui/static/js/*.js',
    'nui/static/css/*.css',
}

client_scripts {
    'client/client.lua',
    'callbacks/client.lua'
}

server_scripts {
    'server/server.lua',
    'callbacks/server.lua'
}

dependency '/assetpacks'