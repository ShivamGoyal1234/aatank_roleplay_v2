shared_script '@WaveShield/resource/include.lua'

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'anox-cardelivery'
author 'Anox Studio'
description 'Cardelivery script compatible with ESX, QBCore, and QBox'
version '1.0.1'

shared_scripts {
    '@ox_lib/init.lua',
    'bridge/loader.lua',
    'shared/*.lua'
}

client_scripts {
    'bridge/client/*.lua',
    'client/*.lua'
}

server_scripts {
    'bridge/server/*.lua',
    'server/*.lua'
}

files {
    'locales/*.json'
}

dependencies {
    'ox_lib'
}