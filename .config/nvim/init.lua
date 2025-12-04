--keeping
vim.loader.enable()

local g = require('globals')
require('config.lazy')
g.set_hl()

vim.lsp.config('clangd', {
  capabilities = function() require("lsp.capabilities")() end,
  on_attach = function() require("lsp.on_attach")() end,
  root_markers = { '.clangd', 'compile_flags.txt' },
})

require('autocmd')
require('keybindings')
require('config.snippets')

vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    if (not vim.tbl_contains(g.parsers, ev.match)) then
      return
    end
    vim.treesitter.start(ev.buf)
  end,
})

