fx_version 'cerulean'
game 'gta5'

files {
  'data/water/*.xml',
  'data/xml/*.xml'
}

server_scripts {
  '@vrp/lib/utils.lua',
  "updater/_version.lua",
  "updater/_server.lua",
  'adapter/core.server.lua'
  --[[ 'adapter/startup.server.lua', ]]
}

client_scripts {
  'adapter/ymaps.client.lua',
  'adapter/core.client.lua',
  '@PolyZone/client.lua',
  '@PolyZone/BoxZone.lua',
  '@PolyZone/CircleZone.lua',
  '@PolyZone/ComboZone.lua'
}

data_file 'TIMECYCLEMOD_FILE' 'data/xml/timecycle_mods_lc.xml'