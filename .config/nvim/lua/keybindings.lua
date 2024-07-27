-- Key Bindings
local opts = { silent = true }
local vault_actions = require'vault_actions'
local telescope = require('telescope.builtin')
local telescope_ext = require'telescope'.extensions
local globs = require('globals').getglobs()

local function general()
    vim.api.nvim_create_user_command('TagIndex', vault_actions.create_tag_index, {})
    vim.api.nvim_create_user_command('NewAuthor', vault_actions.new_author, {})
    vim.api.nvim_create_user_command('NewSource', vault_actions.new_source, {})
    vim.api.nvim_create_user_command('NewNote', vault_actions.new_note, {})

    vim.keymap.set('n', '<leader>ww', ':e ' .. globs.notesdir .. '/index.md<CR>:cd ' .. globs.notesdir .. '/<CR>', opts)
    vim.keymap.set('n', '<leader>fg', telescope.live_grep, opts)
    vim.keymap.set('v', '<leader>fg', telescope.grep_string, opts)
    vim.keymap.set('n', '<leader>z', ':Goyo<CR>', opts)
    vim.keymap.set('n', '<leader>pp', telescope_ext.projects.projects, opts)

    vim.keymap.set('n', '<leader>v', "<cmd>NvimTreeToggle<CR>", opts)

    vim.keymap.set('n', '<leader>ei', ':e $MYVIMRC<CR>', opts)
    vim.keymap.set('n', '<leader>h', ':wincmd h<CR>', opts)
    vim.keymap.set('n', '<leader>j', ':wincmd j<CR>', opts)
    vim.keymap.set('n', '<leader>k', ':wincmd k<CR>', opts)
    vim.keymap.set('n', '<leader>l', ':wincmd l<CR>', opts)
    vim.keymap.set('n', '<leader>ps', ':Rg<SPACE>', opts)
    vim.keymap.set('n', '<silent> <leader>+', ':vertical resize +5<CR>', opts)
    vim.keymap.set('n', '<silent> <leader>-', ':vertical resize -5<CR>', opts)
    vim.keymap.set('n', '<A-h>', '<Cmd>BufferPrevious<CR>', opts)
    vim.keymap.set('n', '<A-l>', '<Cmd>BufferNext<CR>', opts)
    vim.keymap.set('n', '<A-H>', '<Cmd>BufferMovePrevious<CR>', opts)
    vim.keymap.set('n', '<A-L>', '<Cmd>BufferMoveNext<CR>', opts)
    vim.keymap.set('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
    vim.keymap.set('n', '<A-q>', '<Cmd>BufferClose<CR>', opts)
end

local function lsp()
    vim.keymap.set('n', '<C-CR>', ':Lspsaga goto_definition<CR>', opts)
    vim.keymap.set('n', '<leader>o', ':Lspsaga outline<CR>', opts)
end

local function markdown()

    vim.keymap.set('i', '--', '—', { buffer = true })
    -- vim.keymap.set('n', '', ':Lspsaga goto_definition<CR>', {buffer = true})


    -- vim.keymap.set('n', '<Enter>', ':Lspsaga goto_definition<CR>', {buffer = true})
    -- vim.keymap.set('n', '<BS>', ':bd<CR>', {buffer = true})
    -- vim.keymap.set('n', '<TAB>', '/<Bslash>[.*](.*)<CR>', {buffer = true})
    -- vim.keymap.set('n', '<S-TAB>', '?<Bslash>[.*](.*)<CR>', {buffer = true})
    -- vim.keymap.set('i', ',n', '---<Enter><Enter>', {buffer = true})
    -- vim.keymap.set('i', ',b', '****<++><Esc>F*hi', {buffer = true})
    -- vim.keymap.set('i', ',s', '~~~~<++><Esc>F~hi', {buffer = true})
    -- vim.keymap.set('i', ',e', '**<++><Esc>F*i', {buffer = true})
    -- vim.keymap.set('i', ',h', '====<Space><++><Esc>F=hi', {buffer = true})
    -- vim.keymap.set('i', ',i', '![]()<++><Esc>F(a', {buffer = true})
    -- vim.keymap.set('i', ',a', '[]()<++><Esc>F(a', {buffer = true})
    -- vim.keymap.set('i', ',1', '#<Space><Enter><++><Esc>kA', {buffer = true})
    -- vim.keymap.set('i', ',2', '##<Space><Enter><++><Esc>kA', {buffer = true})
    -- vim.keymap.set('i', ',3', '###<Space><Enter><++><Esc>kA', {buffer = true})
    -- vim.keymap.set('i', ',li', '--------<Enter>', {buffer = true})
    -- vim.keymap.set('i', '--', '—', {buffer = true})
    -- vim.keymap.set('i', '<Space><Tab>', '<Esc>/<++><Enter>"_c4l', {buffer = true})
    -- vim.keymap.set('v', '<Space><Tab>', '<Esc>/<++><Enter>"_c4l', {buffer = true})
end

return { general=general, markdown=markdown, lsp=lsp }
