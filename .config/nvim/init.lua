--keeping
vim.loader.enable()
<<<<<<< HEAD
=======
vim.lsp.set_log_level("debug")
>>>>>>> 2f7eebefd8319a30d0b5021dd4c7524c022ca2a8

require('globals')

require('config.lazy')
require("globals").set_hl()

vim.lsp.config('clangd', {
  capabilities = require("lsp.capabilities"),
  on_attach = require("lsp.on_attach"),
  root_markers = { '.clangd', 'compile_flags.txt' },
})

require('autocmd')
require('keybindings').general()
