--keeping
vim.loader.enable()

local g = require('globals')

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

vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    if (not vim.tbl_contains(g.parsers, ev.match)) then
      return
    end
    vim.treesitter.start(ev.buf)
  end,
})
