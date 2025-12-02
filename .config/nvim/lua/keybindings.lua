local wk = require("which-key")
local snacks = require("snacks")

-- Key Bindings
local function general()
  local globs = require('globals').getglobs()
  local opts = { silent = true }

  -- Common Locations
  vim.api.nvim_create_user_command('GotoNotes', function()
    vim.api.nvim_set_current_dir(globs.notesdir)
    vim.cmd('e index.md')
  end, {})
  vim.api.nvim_create_user_command('GotoConf', function()
    vim.cmd('e $MYVIMRC')
    vim.cmd('cd %:p:h')
  end, {})
  vim.keymap.set('n', '<leader>ww', vim.cmd.GotoNotes, {})
  vim.keymap.set('n', '<leader>ei', vim.cmd.GotoConf, {})

  wk.add({ { "<leader>f", group = "find" } })
  wk.add({ { "<leader>g", group = "git" } })

  -- Functional
  vim.keymap.set('n', '<leader>v', function() require("oil").toggle_float() end, { desc = 'file browser' })
  vim.keymap.set('n', '<leader>z', function() require("zen-mode").toggle() end, { desc = 'zen mode' })
  vim.keymap.set('n', '<leader>o', vim.diagnostic.open_float, { desc = 'diagnostics' })

  -- Buffer Tab Navigation
  vim.keymap.set('n', '<C-q>', vim.cmd.bd, opts)

  -- QuickFix Navigation
  vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
  vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
  vim.keymap.set('n', '<leader>co', vim.cmd.copen, opts)
  vim.keymap.set('n', '<leader>cc', vim.cmd.cclose, opts)

  -- Cool Stuff
  vim.keymap.set("x", "<leader>p", [["_dP]])
  vim.keymap.set("x", "<leader>s", [["ayGdgg"aP]])

  vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

  vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
  vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
  vim.keymap.set("v", "L", ">gv")
  vim.keymap.set("v", "H", "<gv")

  vim.keymap.set("n", "J", "mzJ`z")
  vim.keymap.set("n", "<C-d>", "<C-d>zz")
  vim.keymap.set("n", "<C-u>", "<C-u>zz")
  vim.keymap.set("n", "n", "nzzzv")
  vim.keymap.set("n", "N", "Nzzzv")
  vim.keymap.set("n", "#", "#zzzv")
  vim.keymap.set("n", "*", "*zzzv")

  vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
  vim.keymap.set("n", "<leader>Y", [["+Y]])

  vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

  vim.keymap.set('n', 'z=', snacks.picker.spelling, opts)

  vim.keymap.set('i', '<C-Space>', '<Space>')
  vim.keymap.set('n', '<leader>lf', function() require("conform").format() end, { desc = 'format' })
end

local function lsp()
  local opts = { silent = true }
  vim.keymap.set('n', '<C-CR>', snacks.picker.lsp_definitions, opts)
  vim.keymap.set('n', 'gd', snacks.picker.lsp_definitions, { desc = 'lsp definition' })
  vim.keymap.set('n', 'gr', snacks.picker.lsp_references, { desc = 'lsp goto reference' })
  vim.keymap.set('n', '<leader>lc', vim.lsp.buf.code_action, { desc = 'lsp code action' })

  vim.keymap.set('n', '<leader>fi', snacks.picker.lsp_incoming_calls, { buffer = true, desc = 'lsp incoming' })
  vim.keymap.set('n', '<leader>fo', snacks.picker.lsp_outgoing_calls, { buffer = true, desc = 'lsp outgoing' })
  vim.keymap.set('n', '<leader>fD', snacks.picker.diagnostics, { desc = 'lsp diagnostics' })
  vim.keymap.set('n', '<leader>fd', snacks.picker.diagnostics_buffer, { desc = 'lsp diagnostics buffer' })
  vim.keymap.set('n', '<leader>fw', snacks.picker.lsp_workspace_symbols, { desc = 'lsp workplace symbols' })
  vim.keymap.set('n', '<leader>fs', snacks.picker.lsp_symbols, { desc = 'lsp document symbols' })
  vim.keymap.set('n', '<leader>fr', snacks.picker.lsp_references, { desc = 'lsp references' })
end

local function lsp_short()
  vim.keymap.set('n', '<leader>lc', vim.lsp.buf.code_action, { desc = 'lsp code action' })

  vim.keymap.set('n', '<leader>fD', snacks.picker.diagnostics, { desc = 'lsp diagnostics' })
  vim.keymap.set('n', '<leader>fd', snacks.picker.diagnostics_buffer, { desc = 'lsp diagnostics buffer' })
  vim.keymap.set('n', '<leader>fw', snacks.picker.lsp_workspace_symbols, { desc = 'lsp workplace symbols' })
  vim.keymap.set('n', '<leader>fr', snacks.picker.lsp_references, { desc = 'lsp references' })
end

return {
  general = general,
  lsp = lsp,
  lsp_short = lsp_short,
}
