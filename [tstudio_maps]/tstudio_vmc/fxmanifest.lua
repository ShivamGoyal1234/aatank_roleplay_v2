shared_script '@WaveShield/resource/include.lua'
shared_script '@WaveShield/resource/waveshield.js'

fx_version 'cerulean'
lua54 'yes'
game "gta5"

author 'tstudio - TurboSaif'
description 'Vespucci Medical Center'
version '1.0.0'

this_is_a_map "yes"

-- data_file "DLC_ITYP_REQUEST" "stream/turbosaif_vmc_int.ytyp"

client_scripts {
    'client/config.lua', 'locales/**/*.*', 'src/rageui.lua',
    'src/rageui_nui.lua', 'client/classes/*.*', 'client/main.lua'
}

ui_page 'src/web/dist/index.html'

files {'src/web/dist/**/*'}

escrow_ignore {
    'stream/vanilla/*.*',
    'stream/*.ytd',
    'stream/turbosaif_vmc_flag.yft',
    'client/classes/*.*',
    'client/*.lua',
    'locales/*.lua',
    'src/web/dist/**/*',
}

dependency '/assetpacks'