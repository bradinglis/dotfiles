return {
  capabilities = require("lsp.capabilities"),
  on_attach = require("lsp.on_attach"),
  settings = {
    Lua = {
      codeLens = {
        enable = true
      },
      hint = {
        enable = true,
        arrayIndex = "Disable",
        semicolon = "Disable"
      }

    }
  },
}
