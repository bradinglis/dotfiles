-- Key Bindings
local vault_actions = require'vault_actions'
local telescope = require('telescope.builtin')
local telescope_ext = require'telescope'.extensions
local globs = require('globals').getglobs()

local function general()
    local opts = { silent = true }
    vim.api.nvim_create_user_command('TagIndex', vault_actions.create_tag_index, {})
    vim.api.nvim_create_user_command('NewAuthor', vault_actions.new_author, {})
    vim.api.nvim_create_user_command('NewSource', vault_actions.new_source, {})
    vim.api.nvim_create_user_command('NewNote', vault_actions.new_note, {})

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
    local opts = { silent = true }
    vim.keymap.set('n', '<C-CR>', ':Lspsaga goto_definition<CR>', opts)
    vim.keymap.set('n', '<leader>o', ':Lspsaga outline<CR>', opts)
end

local function sanitize_loc(row, col)
    local sanrow
    local sancol
    if col == 0 then
        sancol = 0
    elseif col == 999 then
        sancol = -1
    else
        sancol = col - 1
    end
    sanrow = row - 1
    return { col = sancol, row = sanrow }
end

local function surround_visual(surround)
    -- This sucks for multiline, and probs should just recreate get_visual_selection at this point
    local util = require "obsidian.util"
    local viz = util.get_visual_selection()
    if not viz then
        return
    end
    local startloc = {}
    local endloc = {}

    if viz.csrow > viz.cerow then
        startloc = sanitize_loc(viz.cerow, viz.cecol)
        endloc = sanitize_loc(viz.csrow, viz.cscol)
    elseif viz.csrow < viz.cerow then
        startloc = sanitize_loc(viz.csrow, viz.cscol)
        endloc = sanitize_loc(viz.cerow, viz.cecol)
    elseif viz.cscol > viz.cecol then
        startloc = sanitize_loc(viz.cerow, viz.cecol)
        endloc = sanitize_loc(viz.csrow, viz.cscol)
    else
        startloc = sanitize_loc(viz.csrow, viz.cscol)
        endloc = sanitize_loc(viz.cerow, viz.cecol)
    end

    vim.api.nvim_buf_set_text(0, endloc.row, endloc.col + 1, endloc.row, endloc.col + 1, { surround })
    vim.api.nvim_buf_set_text(0, startloc.row, startloc.col, startloc.row, startloc.col, { surround })
end

local function markdown()
    vim.api.nvim_create_user_command('MdVisualSurround',
        function(opts)
            surround_visual(opts.fargs[1])
        end,
        { nargs = 1 })

    vim.keymap.set('i', '--', '—', { buffer = true })
    vim.keymap.set('v', '<leader>h', '<cmd>MdVisualSurround ==<CR>', { buffer = true })
    vim.keymap.set('v', '<leader>b', '<cmd>MdVisualSurround **<CR>', { buffer = true })
    vim.keymap.set('v', '<leader>i', '<cmd>MdVisualSurround *<CR>', { buffer = true })
end

return { general=general, markdown=markdown, lsp=lsp }
