-- local capabilities = require('blink.cmp').get_lsp_capabilities()
local capabilities = {}

capabilities.workspace = {
  didChangeWatchedFiles = {
    dynamicRegistration = true,
  },
}

return capabilities
