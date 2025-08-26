shared_script '@WaveShield/resource/include.lua'

fx_version 'adamant'
game 'gta5'
description 'Ak47 Handling'
author 'MenanAk47'
version '1.2'

ui_page "nui/index.html"

client_scripts {
    "config.lua",
    "client/main.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server/main.lua"
}

files {
    "nui/**/*",
}

escrow_ignore {
    "config.lua",
}

lua54 'yes'
dependency '/assetpacks'