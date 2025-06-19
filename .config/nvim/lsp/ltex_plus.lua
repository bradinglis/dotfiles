<<<<<<< HEAD
return {
  capabilities = {},
  on_attach = function ()
    vim.opt.signcolumn = "yes"
    require('keybindings').lsp()
    require('keybindings').markdown()
    require("ltex_extra").setup {
      load_langs = { "en-AU" }
    }
  end,
  settings = {
    ltex = {
      language = "en-AU",
      -- completionEnabled = true,
      diagnosticSeverity = {
        MORFOLOGIK_RULE_EN_AU = "error",
        default = "warning"
      },
      markdown = {
        nodes = {
          LinkRef = "ignore",
          BlockQuote = "ignore",
        }
      }
    }
  }
}
=======
-- return {
--   capabilities = {},
--   on_attach = function ()
--     vim.opt.signcolumn = "yes"
--     require('keybindings').lsp()
--     require('keybindings').markdown()
--     require("ltex_extra").setup {
--       load_langs = { "en-AU" }
--     }
--   end,
--   settings = {
--     ltex = {
--       language = "en-AU",
--       enabled = {},
--       diagnosticSeverity = {
--         MORFOLOGIK_RULE_EN_AU = "error",
--         default = "warning"
--       },
--       markdown = {
--         nodes = {
--           LinkRef = "ignore",
--           BlockQuote = "ignore",
--         }
--       }
--     }
--   }
-- }
>>>>>>> 2f7eebefd8319a30d0b5021dd4c7524c022ca2a8
