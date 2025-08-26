shared_script '@WaveShield/resource/include.lua'

fx_version 'cerulean'

game 'gta5'

lua54 'yes'

shared_scripts {
    'config.lua',
    'locales.lua',
    'locales/*.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    'client/utils.lua',
    'client/nui.lua',
    'client/events.lua',
    'client/headshot.lua',
    'client/main.lua',
}

server_scripts {
    'server/utils.lua',
    'server/open.lua',
    'server/nationalities.lua',
    'server/events.lua',
    'server/callbacks.lua',
}

ui_page 'ui/index.html'

files {
    'ui/*.*',
    'ui/**/*.*',
}

escrow_ignore {

    "client/**/*",
    'client/**/*',
    'server/**/*',
    'config.lua',
    'locales.lua',
    'locales/**.lua',
    'server/nationalities.lua',
}
dependency '/assetpacks'
dependency '/assetpacks'