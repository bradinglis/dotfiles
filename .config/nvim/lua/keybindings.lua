-- Key Bindings
local vault_actions = require'vault_actions'
local backlinks = require'backlinks'
local telescope = require('telescope.builtin')
local telescope_ext = require'telescope'.extensions
local globs = require('globals').getglobs()

local function general()
    local opts = { silent = true }


    vim.keymap.set('n', '<leader>ww', ':cd ' .. globs.notesdir .. '<CR>' .. ':e index.md<CR>', opts)
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
    vim.keymap.set('n', '<silent> <leader>+', ':vertical resize +5<CR>', opts)
    vim.keymap.set('n', '<silent> <leader>-', ':vertical resize -5<CR>', opts)
    vim.keymap.set('n', '<A-h>', '<Cmd>BufferPrevious<CR>', opts)
    vim.keymap.set('n', '<A-l>', '<Cmd>BufferNext<CR>', opts)
    vim.keymap.set('n', '<A-H>', '<Cmd>BufferMovePrevious<CR>', opts)
    vim.keymap.set('n', '<A-L>', '<Cmd>BufferMoveNext<CR>', opts)
    vim.keymap.set('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
    vim.keymap.set('n', '<A-q>', '<Cmd>BufferClose<CR>', opts)
    vim.keymap.set('n', '[q', ':cprev<CR>', opts)
    vim.keymap.set('n', ']q', ':cnext<CR>', opts)
    vim.keymap.set('n', '<Leader>co', ':copen<CR>', opts)
    vim.keymap.set('n', '<Leader>cc', ':cclose<CR>', opts)
end

local function lsp()
    local opts = { silent = true }
    vim.keymap.set('n', '<C-CR>', ':Lspsaga goto_definition<CR>', opts)
    vim.keymap.set('n', '<leader>o', ':Lspsaga outline<CR>', opts)
end

local function surround_visual(surround)
    -- Have fucked with get_visual_selection in fork so this works nice now
    local util = require "obsidian.util"
    local viz = util.get_visual_selection()
    if not viz then
        return
    end
    local startloc = { col = viz.cscol - 1, row = viz.csrow - 1 }
    local endloc = { col = viz.cecol, row = viz.cerow - 1}

    vim.api.nvim_buf_set_text(0, endloc.row, endloc.col, endloc.row, endloc.col, { surround })
    vim.api.nvim_buf_set_text(0, startloc.row, startloc.col, startloc.row, startloc.col, { surround })
end

local function quickfix_list()
    local opts = { silent = true, buffer = true }
    vim.keymap.set('n', '<C-k>', ':cprev<CR>zz<C-w>w', opts)
    vim.keymap.set('n', '<C-j>', ':cnext<CR>zz<C-w>w', opts)
    vim.keymap.set('n', '<leader>u', ':set modifiable<CR>', opts)
    vim.keymap.set('n', '<leader>w', ':cgetbuffer<CR>:cclose<CR>:copen<CR>', opts)
    vim.keymap.set('n', '<leader>r', ':cdo s/// | update<C-Left><C-Left><Left><Left><Left>', opts)
end

local function markdown()
    vim.api.nvim_create_user_command('MdVisualSurround',
        function(opts)
            surround_visual(opts.fargs[1])
        end,
        { nargs = 1 })

    vim.api.nvim_create_user_command('PrintCurrentNote', vault_actions.print_test, {})
    vim.api.nvim_create_user_command('NewAuthor', vault_actions.new_author, {})
    vim.api.nvim_create_user_command('NewSource', vault_actions.new_source, {})
    vim.api.nvim_create_user_command('NewNote', vault_actions.new_note, {})
    vim.api.nvim_create_user_command('FindBacklinks', backlinks.backlink_search, {})

    vim.keymap.set({'n', 'v'}, '<leader>ns', '<cmd>NewSource<CR>', { buffer = true })
    vim.keymap.set({'n', 'v'}, '<leader>nn', '<cmd>NewNote<CR>', { buffer = true })
    vim.keymap.set({'n', 'v'}, '<leader>na', '<cmd>NewAuthor<CR>', { buffer = true })

    vim.keymap.set('v', '<leader>h', '<cmd>MdVisualSurround ==<CR>', { buffer = true })
    vim.keymap.set('v', '<leader>b', '<cmd>MdVisualSurround **<CR>', { buffer = true })
    vim.keymap.set('v', '<leader>i', '<cmd>MdVisualSurround *<CR>', { buffer = true })


    vim.keymap.set('i', '--', '—', { buffer = true })
end

return { general=general, markdown=markdown, lsp=lsp, quickfix_list=quickfix_list}
