fx_version 'cerulean'
game 'gta5'

author 'Master Mind#8816'
description 'Police Tracker'
version '1.0'

shared_script 'config.lua'
shared_script '@ox_lib/init.lua'

client_script 'client/*.lua'

server_script 'server/*.lua'

lua54 'yes'

dependencies {
	'ox_lib'
}