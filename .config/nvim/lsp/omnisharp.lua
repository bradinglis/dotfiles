return {
  -- root_dir = lspconfig.util.root_pattern('*.csproj'),
  handlers = {
    ["textDocument/definition"] = require('omnisharp_extended').definition_handler,
    ["textDocument/typeDefinition"] = require('omnisharp_extended').type_definition_handler,
    ["textDocument/references"] = require('omnisharp_extended').references_handler,
    ["textDocument/implementation"] = require('omnisharp_extended').implementation_handler,
  },
  capabilities = require("lsp.capabilities"),
  on_attach = require("lsp.on_attach")
}
