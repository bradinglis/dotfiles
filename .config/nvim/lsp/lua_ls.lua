return {
  capabilities = require("lsp.capabilities"),
  on_attach = require("lsp.on_attach"),
  settings = {
    Lua = {
      codeLens = {
        enable = false
      },
      hint = {
        enable = false,
        arrayIndex = "Disable",
        semicolon = "Disable"
      }
    }
  },
}
