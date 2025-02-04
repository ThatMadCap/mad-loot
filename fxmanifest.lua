fx_version 'cerulean'
lua54 'yes'
use_experimental_fxv2_oal 'yes'
game 'gta5'

name 'mad-loot'
version '0.1.3'
description 'Global Loot Tables'
author 'MadCap'

shared_scripts {
  '@ox_lib/init.lua',
}

server_scripts {
  'server/generateloot.lua',
  'server/loottables.lua',
}
