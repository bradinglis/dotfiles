local opts = { silent = true, buffer = true }
vim.keymap.set('n', '<C-k>', '<cmd>cprev<CR>zz<C-w>w', opts)
vim.keymap.set('n', '<C-j>', '<cmd>cnext<CR>zz<C-w>w', opts)
vim.keymap.set('n', '<leader>u', '<cmd>set modifiable<CR>', opts)
vim.keymap.set('n', '<leader>w', '<cmd>cgetbuffer<CR>:cclose<CR>:copen<CR>', opts)
vim.keymap.set('n', '<leader>r', ':cdo s/// | update<C-Left><C-Left><Left><Left><Left>', opts)

