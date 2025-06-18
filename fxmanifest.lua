fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

description 'Park Assist'
author 'xT Development'

shared_scripts { '@ox_lib/init.lua' }

client_scripts {
    'client/*.lua'
}

ui_page 'ui/index.html'

files {
    'configs/*.lua',
    'modules/*.lua',
    'ui/index.html',
    'ui/script.js',
    'ui/style.css'
}