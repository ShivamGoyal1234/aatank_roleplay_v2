shared_script '@WaveShield/resource/include.lua'

author 'Envi-Scripts'
fx_version 'cerulean'

game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

version '1.6.1'

ui_page 'web/build/index.html'

client_scripts {
    'client/*.lua',
}

shared_scripts {
    '@envi-bridge/bridge.lua',
    'shared/*.lua',
}

server_scripts {
    'server/*.lua',
}

files {
    'web/build/index.html',
    'web/build/**/*',
    'web/build/config/**/*',
    'web/build/sounds/*.mp3',
    'web/build/images/*.png'
}

escrow_ignore {
    'shared/*.lua',
    'client/client_open.lua',
    'client/progressbar.lua',
    'server/server_open.lua',
}

dependencies {
    'envi-bridge',
}

bridge 'envi-bridge'

-- UNCOMMENT THE LINE BELOW IF YOU DO NOT HAVE A TARGET RESOURCE INSTALLED - ALSO MAKE SURE TO SET Config.Interactions.Target TO false IN config.lua
-- bridge_disable { 'target' }

-- Shoutout to Renewed for Native Audio Tool
files {
    'data/hud_sounds.dat54.rel',
    'audiodirectory/envi.awc'
}

data_file 'AUDIO_WAVEPACK'  'audiodirectory'
data_file 'AUDIO_SOUNDDATA' 'data/hud_sounds.dat'

provide 'progressbar'
dependency '/assetpacks'
dependency '/assetpacks'