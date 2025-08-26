shared_script '@WaveShield/resource/include.lua'

fx_version 'cerulean'
lua54 'yes'
game "gta5"

author 'TStudio - mandatory mapdata'
description 'TStudio Mapdata - important for TStudio maps'
version '1.0'

this_is_a_map 'yes'

dependencies { 
    '/server:4960',     -- ⚠️PLEASE READ⚠️; Requires at least SERVER build 4960.
    '/gameBuild:2545',  -- ⚠️PLEASE READ⚠️; Requires at least GAME build 2545.
}

data_file 'TIMECYCLEMOD_FILE' 'tstudio_timecycles.xml'

shared_scripts {
    'config.lua',
    'utils/utils.lua',
    'utils/misc.lua',
}

client_scripts {
    'client/activate_ipl.lua',
    'client/entitysets_loader.lua',
    'client/ipl_blocker.lua',
    'client/privacy_glass.lua',
}

server_scripts {
    'server/patch_loader.lua',
    'server/resource_monitor.lua',
}

files {
    'tstudio_timecycles.xml',
}

escrow_ignore {
    'stream/*/*.*',
    'locales/*.lua', 
    'config.lua',
}

dependency '/assetpacks'