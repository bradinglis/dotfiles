return function(_, bufnr)
  vim.opt.signcolumn = "yes"

  local opts = { silent = true }
  vim.keymap.set('n', '<C-CR>', require("snacks").picker.lsp_definitions, opts)
  vim.keymap.set('n', 'gd', require("snacks").picker.lsp_definitions, { desc = 'lsp definition' })
  vim.keymap.set('n', 'gr', require("snacks").picker.lsp_references, { desc = 'lsp goto reference' })
  vim.keymap.set('n', '<leader>lc', vim.lsp.buf.code_action, { desc = 'lsp code action' })

  vim.keymap.set('n', '<leader>fi', require("snacks").picker.lsp_incoming_calls, { buffer = true, desc = 'lsp incoming' })
  vim.keymap.set('n', '<leader>fo', require("snacks").picker.lsp_outgoing_calls, { buffer = true, desc = 'lsp outgoing' })
  vim.keymap.set('n', '<leader>fD', require("snacks").picker.diagnostics, { desc = 'lsp diagnostics' })
  vim.keymap.set('n', '<leader>fd', require("snacks").picker.diagnostics_buffer, { desc = 'lsp diagnostics buffer' })
  vim.keymap.set('n', '<leader>fw', require("snacks").picker.lsp_workspace_symbols, { desc = 'lsp workplace symbols' })
  vim.keymap.set('n', '<leader>fs', require("snacks").picker.lsp_symbols, { desc = 'lsp document symbols' })
  vim.keymap.set('n', '<leader>fr', require("snacks").picker.lsp_references, { desc = 'lsp references' })
end
