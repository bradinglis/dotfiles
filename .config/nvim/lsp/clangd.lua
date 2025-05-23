return {
  root_markers = { '.clangd', 'compile_flags.txt' },
  capabilities = require("lsp.capabilities"), -- again, ensure that capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
  on_attach = function(_, bufnr)
    vim.opt.signcolumn = "yes"
    require('keybindings').lsp()
    require "lsp_signature".on_attach({
      bind = true,
      handler_opts = {
        border = "none"
      }
    }, bufnr)

    require("clangd_extensions.inlay_hints").setup_autocmd()
    require("clangd_extensions.inlay_hints").set_inlay_hints()
  end, -- configure your on attach config
}
