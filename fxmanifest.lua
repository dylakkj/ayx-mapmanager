fx_version 'cerulean'
game 'gta5'

lua54 'yes'

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',

    'adapter/ymaps.client.lua',
    'adapter/core.client.lua'
}

server_scripts {
    'adapter/core.server.lua',
    "updater/_version.lua",
    "updater/_server.lua"
}

files {
    'data/*.xml',
    'data/**/*'
}

escrow_ignore {
    "updater/_version.lua",
}

use_experimental_fxv2_oal 'yes'