shared_script '@WaveShield/resource/include.lua'

fx_version 'cerulean'
lua54 'yes'
version '3.0'

game 'gta5'

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
}

client_scripts{
    'client/*.lua',
}

dependencies {
    'ox_lib',
    'qb-core',
}
