shared_script '@WaveShield/resource/include.lua'

fx_version 'cerulean'
game 'gta5'

name 'omes_scoreboard'
author 'omes'
description 'Player scoreboard system for FiveM'
version '1.1.0'
lua54 'yes'

shared_script 'config.lua'

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

