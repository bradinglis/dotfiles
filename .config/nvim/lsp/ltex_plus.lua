return {
  capabilities = {},
  on_attach = function ()
    vim.opt.signcolumn = "yes"
    require('keybindings').lsp_short()
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
          LinkRef = "dummy",
        }
      }
    }
  }
}
