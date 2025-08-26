shared_script '@WaveShield/resource/include.lua'

--  ██████╗ ███╗   ██╗███████╗██╗  ██╗    ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗███████╗
-- ██╔═══██╗████╗  ██║██╔════╝╚██╗██╔╝    ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝██╔════╝
-- ██║   ██║██╔██╗ ██║█████╗   ╚███╔╝     ███████╗██║     ██████╔╝██║██████╔╝   ██║   ███████╗
-- ██║   ██║██║╚██╗██║██╔══╝   ██╔██╗     ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   ╚════██║
-- ╚██████╔╝██║ ╚████║███████╗██╔╝ ██╗    ███████║╚██████╗██║  ██║██║██║        ██║   ███████║
--  ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   ╚══════╝
-- ===================== Official Information ================================================
name 'Onex Resource Module : RadialMenu'
description 'Radialmenu , For interaction'
author 'frostfire575 , Hydra'
PowerdBy 'Onex Scripts'
-- ====================== Game Configuration =================================================
fx_version 'cerulean'
game 'gta5'
version '0.1.8'
-- ====================  Resource UI  ========================================================
ui_page 'web/dist/index.html'
--ui_page 'http://localhost:5173/'
files {
   'web/dist/*.*',
   'web/dist/assets/*.*',
   'bridge/qbx_radialmenu/config.lua',
   'locales/*.json'
}

-- ==================== Resource Configuration ===============================================
shared_scripts {
   -- '@es_extended/imports.lua', -- Uncomment this if you are using ESX
   '@qb-core/shared/locale.lua', -- Uncomment this if you are using qb-core
   -- '@ox_lib/init.lua', -- Uncomment this if you are using qbx_core
   'shared/config.lua',
   'bridge/qb-radialmenu/locales/en.lua',
   'bridge/qb-radialmenu/locales/*.lua',
   'bridge/qb-radialmenu/config.lua'
}

client_scripts {
   -- '@qbx_core/modules/playerdata.lua', -- Uncomment this if you are using qbx_core
   'client/client.lua',
   'client/classes/*.lua',
   'bridge/client.lua',
   'bridge/**/client/*.lua'
}

server_scripts {
   'version.lua',
   'bridge/qb-radialmenu/server/*.lua',
   'bridge/qbx_radialmenu/server/*.lua'
}

provide {"qbx_radialmenu", "qb-radialmenu"}

escrow_ignore {
   'shared/*.lua',
   'locales/*.*',
   'bridge/**/*.lua',
   'bridge/**/**/*.lua'
}

-- ==================== Resource Code Configuration  =============================================
lua54 'yes'
use_experimental_fxv2_oal 'yes'

dependency '/assetpacks'