local wk = require("which-key")
local globs = require('globals').getglobs()
local opts = { silent = true }

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
wk.add({ { "<leader>gd", group = "diffview open" } })

-- Functional
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

vim.keymap.set('i', '<C-Space>', '<Space>')
