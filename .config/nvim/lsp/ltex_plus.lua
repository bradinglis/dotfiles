return {
  capabilities = {},
  on_attach = function ()
    vim.opt.signcolumn = "yes"
    vim.keymap.set({'n', 'x'}, '<leader>lc', vim.lsp.buf.code_action, { desc = 'lsp code action' })
    vim.keymap.set({'n', 'x'}, '<leader>lr', vim.lsp.buf.rename, { desc = 'lsp code action' })
    vim.keymap.set('n', '<leader>fD', require("snacks").picker.diagnostics, { desc = 'lsp diagnostics' })
    vim.keymap.set('n', '<leader>fd', require("snacks").picker.diagnostics_buffer, { desc = 'lsp diagnostics buffer' })
    require("ltex_extra").setup {
      load_langs = { "en-AU" }
    }
  end,
  settings = {
    ltex = {
      language = "en-AU",
      completionEnabled = true,
      diagnosticSeverity = {
        MORFOLOGIK_RULE_EN_AU = "error",
        default = "warning"
      },
      markdown = {
        nodes = {
          LinkRef = "ignore",
        }
      }
    }
  }
}
