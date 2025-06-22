--keeping
vim.loader.enable()
-- vim.lsp.set_log_level("debug")

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
