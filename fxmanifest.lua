fx_version 'cerulean'
game 'gta5'

author 'PhoQ'
description 'Smooth Perspective Zoom'
version '1.0.0'

shared_script '@ox_lib/init.lua'

shared_script 'config.lua'
client_script 'client/zoom.lua'

dependencies {
    'ox_lib'
}
