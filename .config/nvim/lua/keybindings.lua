-- Key Bindings
local function general()
    local globs = require('globals').getglobs()
    local opts = { silent = true }
    local telescope = require('telescope.builtin') local telescope_ext = require'telescope'.extensions

    -- Common Locations
    vim.keymap.set('n', '<leader>ww', '<cmd>cd ' .. globs.notesdir .. '<CR>' .. ':e index.md<CR>', opts)
    vim.keymap.set('n', '<leader>ei', '<cmd>e $MYVIMRC<CR>', opts)

    -- Telescope
    local finder_hydra = require('hydras.default_find').hydra
    vim.keymap.set('n', '<leader>f', function() finder_hydra:activate() end, opts)

    -- Git
    local git_hydra = require('hydras.git').hydra
    vim.keymap.set('n', '<leader>g', function() git_hydra:activate() end, opts)

    -- Functional
    vim.keymap.set('n', '<leader>v', vim.cmd.NvimTreeToggle, opts)
    vim.keymap.set('n', '<leader>z', vim.cmd.ZenMode, opts)
    vim.keymap.set('n', '<leader>o', vim.diagnostic.open_float, opts)

    -- Buffer Tab Navigation
    vim.keymap.set('n', '<C-q>', vim.cmd.bd, opts)

    -- QuickFix Navigation 
    vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
    vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
    vim.keymap.set('n', '<leader>co', vim.cmd.copen, opts)
    vim.keymap.set('n', '<leader>cc', vim.cmd.cclose, opts)

    -- Cool Stuff
    vim.keymap.set("x", "<leader>p", [["_dP]])

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

    vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
    vim.keymap.set("n", "<leader>Y", [["+Y]])

    vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

    vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")
    vim.keymap.set('n', 'z=', require("telescope.builtin").spell_suggest, opts)
end

local function lsp()
    local opts = { silent = true }
    vim.keymap.set('n', '<C-CR>', require("telescope.builtin").lsp_definitions, opts)
    vim.keymap.set('n', 'gd', require("telescope.builtin").lsp_definitions, opts)
    vim.keymap.set('n', 'gr', require("telescope.builtin").lsp_references, opts)
    vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, opts)
    vim.keymap.set('n', '<leader>lc', vim.lsp.buf.code_action, opts)

    -- Telescope
    local finder_hydra = require('hydras.lsp_find').hydra
    vim.keymap.set('n', '<leader>f', function() finder_hydra:activate() end, opts)
end

local function quickfix_list()
    local opts = { silent = true, buffer = true }
    vim.keymap.set('n', '<C-k>', '<cmd>cprev<CR>zz<C-w>w', opts)
    vim.keymap.set('n', '<C-j>', '<cmd>cnext<CR>zz<C-w>w', opts)
    vim.keymap.set('n', '<leader>u', '<cmd>set modifiable<CR>', opts)
    vim.keymap.set('n', '<leader>w', '<cmd>cgetbuffer<CR>:cclose<CR>:copen<CR>', opts)
    vim.keymap.set('n', '<leader>r', ':cdo s/// | update<C-Left><C-Left><Left><Left><Left>', opts)
end

local function surround_visual(surround)
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

local function delete_surround(surround)
    for c in surround:gmatch(".") do
        vim.api.nvim_feedkeys("ds" .. c, "m", false)
    end
end

local function markdown()
    local vault_actions = require'vault_actions'
    local backlinks = require'backlinks'
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
    vim.api.nvim_create_user_command('ChangeAll', vault_actions.change_all, {})
    -- vim.api.nvim_create_user_command('SourceSearch', require'vault.source_search', {})

    vim.keymap.set('n', '<CR>', function () return vault_actions.enter_command() end, { buffer = true, expr = true })
    vim.keymap.set('n', '<leader>t', vim.cmd.ObsidianToggleCheckbox, { buffer = true })

    local finder_hydra = require('hydras.obs_find').hydra
    vim.keymap.set('n', '<leader>f', function() finder_hydra:activate() end, { buffer = true })

    local vis_new_hydra = require('hydras.obs_vis_new').hydra
    vim.keymap.set('v', '<leader>n', function() vis_new_hydra:activate() end, { buffer = true })

    local norm_new_hydra = require('hydras.obs_norm_new').hydra
    vim.keymap.set('n', '<leader>n', function() norm_new_hydra:activate() end, { buffer = true })

    vim.keymap.set('v', '<leader>h', function () surround_visual('==') end, { buffer = true })
    vim.keymap.set('v', '<leader>b', function () surround_visual('**') end, { buffer = true })
    vim.keymap.set('v', '<leader>e', function () surround_visual('*') end, { buffer = true })
    vim.keymap.set('v', '<leader>c', function () surround_visual('`') end, { buffer = true })

    local md_delete_hydra = require('hydras.md_delete').hydra
    vim.keymap.set('n', '<leader>d', function() md_delete_hydra:activate() end, { buffer = true })

    vim.keymap.set('n', '<leader>r', [[:%s/\v(\a\.) (\u)/\1\r\2/g|norm!``<CR>]], { buffer = true })
    vim.keymap.set('n', '<leader>R', [[:%s/\v(\a\.)\n(\u)/\1 \2/g|norm!``<CR>]], { buffer = true })

    vim.keymap.set('i', '--', '—', { buffer = true })
    vim.keymap.set('i', '->', '→', { buffer = true })
    vim.keymap.set('i', '<-', '←', { buffer = true })
    vim.keymap.set('i', '<<', '«', { buffer = true })
    vim.keymap.set('i', '>>', '»', { buffer = true })
    vim.keymap.set('i', '-!', '↓', { buffer = true })
    vim.keymap.set('i', '-^', '↑', { buffer = true })

end

return { general=general, markdown=markdown, lsp=lsp, quickfix_list=quickfix_list}
