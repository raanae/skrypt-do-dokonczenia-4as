fx_version 'cerulean'
game 'gta5'

shared_script '@es_extended/imports.lua'

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

dependencies {
    'es_extended',
    'oxmysql' 
}
