--keeping
vim.loader.enable()

require('globals')

require('plugins')
require('autocmd')

require('keybindings').general()

-- require('obsidian_alters')
require('vault_actions')
