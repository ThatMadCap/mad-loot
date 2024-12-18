fx_version 'cerulean'

game 'gta5'

author 'MadCap / Yume'
version '0.1.2'
description 'WIP - FiveM Global Loot Tables'

lua54 'yes'

shared_scripts {
  '@ox_core/lib/init.lua',
  '@duff/shared/import.lua',
}

server_scripts {
  'server/generateloot.lua',
  'server/loottables.lua',
}