return function(_, bufnr)
  vim.opt.signcolumn = "yes"
  require('keybindings').lsp()
  require "lsp_signature".on_attach({
    bind = true,
    handler_opts = {
      border = "none"
    }
  }, bufnr)
end
