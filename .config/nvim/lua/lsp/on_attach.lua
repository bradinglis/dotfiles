return function(_, bufnr)
  vim.opt.signcolumn = "yes"
  require('keybindings').lsp()
end
