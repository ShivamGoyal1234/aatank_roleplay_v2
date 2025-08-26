shared_script '@WaveShield/resource/include.lua'

fx_version 'cerulean'
lua54 'yes'
game "gta5"

author 'tstudio - HG-Designs'
description 'Pier76 Car Club'
version '2.0.0'

this_is_a_map "yes"

dependencies {
    '/server:4960',     -- ⚠️PLEASE READ⚠️; Requires at least SERVER build 4960.
    '/gameBuild:2545',  -- ⚠️PLEASE READ⚠️; Requires at least GAME build 2545.
    'tstudio_zmapdata',  -- ⚠️PLEASE READ⚠️; Requires to be started before this resource.
}

client_scripts {
  'client/client.lua',
  'client/teleport.lua'
}

escrow_ignore {
  'stream/ytd/*.ytd',
  'stream/vanilla/*.*',
  'client/client.lua',
  'client/teleport.lua'
}
dependency '/assetpacks'