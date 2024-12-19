fx_version 'cerulean'

game 'gta5'

author 'MadCap / Yume'
version '0.1.3'
description 'WIP - FiveM Global Loot Tables'

lua54 'yes'

shared_scripts {
  '@ox_core/lib/init.lua',
}

server_scripts {
  'server/generateloot.lua',
  'server/loottables.lua',
}