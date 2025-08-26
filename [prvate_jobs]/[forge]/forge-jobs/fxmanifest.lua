shared_script '@WaveShield/resource/include.lua'

fx_version 'cerulean'
game 'gta5'

description 'Essential Jobs - Rustic | Advanced resource featuring 6 countryside-themed jobs'
author 'CodeForge'
version '1.9.0'

client_scripts {
    'shared/config.lua',
    'client/client_open_functions.lua',
    'client/client.lua',
    'client/client_sound.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'shared/config.lua',
    'server/config_server.lua',
    'server/server.lua',
    'server/server_open_functions.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'shared/job_hooks.lua'
}

ui_page { 'html/index.html' }

files {
    'data.txt',
    'html/*',
    'html/assets/*',
    'html/assets/images/tools/*.png',
    'html/assets/**/**/**/**',
    'html/assets/images/*',
    'html/css/*',
    'html/js/*',
    'html/sounds/*.ogg'
}

escrow_ignore {
    'shared/config.lua',
    'shared/job_hooks.lua',
    'client/client_open_functions.lua',
    'server/server_open_functions.lua',
    'server/config_server.lua'
}

lua54 'yes'

dependency '/assetpacks'