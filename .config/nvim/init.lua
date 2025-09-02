--keeping
vim.loader.enable()

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
require('config.snippets')
