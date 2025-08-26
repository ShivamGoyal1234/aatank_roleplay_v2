
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
games {'gta5'}

name 'kibra-smartpad'
author "0Resmon Studio's"
version '1.0.1'
license 'LGPL-3.0-or-later'
description 'Created by 0Resmon'

dependencies {
    '/server:7290',
    '/onesync',
}

ui_page 'web/build/index.html'

files {
    'locales/*.json',
    'web/build/index.html',
    'web/build/*.png',
    'web/build/*.jpg',
    'web/build/assets/*.css',
    'web/build/assets/*.js',
    'web/build/fonts/*.OTF',
    'web/build/fonts/*.otf',
    'web/build/fonts/*.ttf',
    'web/build/assets/*.webp',
    'web/build/appicons/*.png',
    'web/build/appicons/*.jpg',
    'web/build/assets/*.png',
    'web/build/assets/*.jpg',
    'web/build/assets/*.png',
    'web/build/assets/*.jpg',
    'web/build/assets/*.webp',
    'web/src/utils/pedshot.js',
    'web/pimg/*.png',
    'web/modvehicles/*.png',
    'data/zones.json',
    'data/vehicles.json',
    'data/colors.json',
    'data/weapons.json',
    'web/build/notify.mp3',
    'data/classes.json',
    'data/notes.json',
    'data/ems_chat.json',
    'data/mdt_chat.json',
    'data/sharedlocations.json',
    'data/charges.json',
    'shared/camera.json'
}

shared_scripts {
    '@ox_lib/init.lua',
    'shared/inventory.lua',
    'shared/config.lua',
    'shared/apps.lua',
    'shared/crimes.lua',
    'shared/drugs.lua'
}

client_scripts {
    -- 'editable/client.lua',
    'shared/client_editable.lua',
    'resource/smartpad/client.lua',
    'resource/callbacks/client.lua',
    'resource/utils/pedshot.lua',
    'resource/smartpad/exports_cl.lua',
    'resource/other/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'resource/smartpad/auto.lua',
    'editable/server.lua',
    'resource/smartpad/server.lua',
    'resource/callbacks/server.lua',
    'resource/smartpad/exports_sv.lua',
    'resource/other/server.lua'
}

escrow_ignore {
    'editable/server.lua',
    'shared/*',
    'resource/smartpad/client.lua',
    'resource/callbacks/client.lua',
    'resource/utils/pedshot.lua',
    'resource/smartpad/exports_cl.lua',
    'resource/smartpad/auto.lua',
    'resource/smartpad/server.lua',
    'resource/callbacks/server.lua',
    'resource/smartpad/exports_sv.lua',
}
dependency '/assetpacks'