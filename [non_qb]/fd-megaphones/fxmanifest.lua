shared_script '@WaveShield/resource/include.lua'

fx_version 'cerulean'
game 'gta5'

name 'fd-megaphones'
author 'pen'
description 'A simple free megaphone resource for FiveM'
repository 'https://github.com/FD-Scripts/fd-megaphones'
version '1.0.4'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    'client/framework.lua',
    'client/functions.lua',
    'client/megaphone.lua',
    'client/microphones.lua'
}

server_scripts {
    'server/framework.lua',
    'server/main.lua'
}

dependencies {
    'ox_lib',
    'qb-target',
    'pma-voice',
    'PolyZone'
}
