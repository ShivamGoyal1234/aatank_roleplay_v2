
fx_version 'cerulean'
game 'gta5'
use_experimental_fxv2_oa 'yes'
lua54 'yes'
name 'kibra-dispatch'
author "0Resmon Studio's | discord.gg/0resmon | 0resmon.tebex.io"
description 'Created by 0Resmon Studio | Advanced Dispatch System'
version '1.0.5'

client_scripts {
    "modules/client.lua",
    "modules/threads.lua",
}

server_scripts {'modules/server.lua', 'modules/version.lua'}

ui_page "web/build/index.html"

files {
    'data/*.json',
    'data/*.lua',
    'locales/*.json',
    'web/build/index.html',
    'web/build/assets/*.js',
    'web/build/assets/*.css',
    'web/build/assets/*.map' 
}

shared_scripts {
    '@ox_lib/init.lua',
    "config.lua",
}

escrow_ignore {
    'modules/client.lua',
    'modules/threads.lua',
    'modules/server.lua',
    'modules/version.lua',
    'config.lua',
    'data/weapons.lua'
}

dependencies {
    '/server:6116',
    '/onesync',
    'ox_lib',
}

dependency '/assetpacks'