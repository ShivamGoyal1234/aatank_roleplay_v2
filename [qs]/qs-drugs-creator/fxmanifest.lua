shared_script '@WaveShield/resource/include.lua'
shared_script '@WaveShield/resource/waveshield.js'

fx_version 'cerulean'

games { 'gta5' }

version '1.1.61'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/utils.lua',
    'shared/functions.lua',
    'config/scenes.lua',
    'config/config.lua',
    'config/furniture.lua',
    'locales/*.lua'
}

client_scripts {
    'custom/client.lua',
    'client/custom/**',
    'client/modules/**',
    'client/main.lua'
}

ox_libs {
    'table',
}

ui_page 'html/index.html'

files {
    'html/**',
    'locales/**',
    'custom/**'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'custom/server.lua',
    'server/custom/**',
    'server/modules/**/*.lua',
    'server/main.lua'
}

dependencies {
    '/onesync',
    'ox_lib',
}

escrow_ignore {
    'client/custom/**',
    'custom/**/*',
    'shared/**/*',
    'config/*',
    'types.lua',
    'locales/*',
    'server/custom/missions.lua'
}

dependency '/assetpacks'