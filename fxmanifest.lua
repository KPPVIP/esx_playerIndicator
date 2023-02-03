fx_version 'cerulean'
game 'gta5'

author 'Pedaret'

lua54 'yes'

description 'Eshgh'

client_scripts {
    'Client/*.lua',
}

server_scripts {
    'Server/*.lua',
}

shared_scripts {
    '@essentialmode/locale.lua',
    'locales/en.lua',
    'Config.lua',
}

ui_page {
    'html/index.html',
}

files {
	'html/index.html',
	'html/app.js', 
    'html/style.css',
    'html/dist/**'
}

exports {
    'Alert'
}

escrow_ignore {
    'Config.lua',
    'Client/MiniMap.lua',
    'locales/*.lua',
}