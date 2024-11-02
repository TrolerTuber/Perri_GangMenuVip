fx_version 'cerulean'
lua54 'yes'
game 'gta5'

author 'perrituber'
description 'https://discord.gg/nqY4QNrXv3'

--Client Scripts-- 
client_scripts {
    'Client/*.lua',
}

--Server Scripts-- 
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'Server/*.lua',
}

--Shared Scripts-- 
shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    'config.lua'
}

ui_page {
    'html/ui.html',
}

files {
    'html/ui.html',
    'html/app.js', 
    'html/style.css',
    'html/img/bolsa.png'
}


