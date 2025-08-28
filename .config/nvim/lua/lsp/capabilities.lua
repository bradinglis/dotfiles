local capabilities = require('blink.cmp').get_lsp_capabilities()

capabilities.workspace = {
  didChangeWatchedFiles = {
    dynamicRegistration = true,
  },
}

return capabilities
