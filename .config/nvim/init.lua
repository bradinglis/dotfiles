--keeping
vim.loader.enable()

require('globals')

require('config.lazy')
require("globals").set_hl()

require('autocmd')

require('keybindings').general()
