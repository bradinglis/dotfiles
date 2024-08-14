-- Key Bindings
local function general()
    local globs = require('globals').getglobs()
    local opts = { silent = true }
    local telescope = require('telescope.builtin') local telescope_ext = require'telescope'.extensions

    -- Common Locations
    vim.keymap.set('n', '<leader>ww', '<cmd>cd ' .. globs.notesdir .. '<CR>' .. ':e index.md<CR>', opts)
    vim.keymap.set('n', '<leader>ei', '<cmd>e $MYVIMRC<CR>', opts)

    -- Telescope
    vim.keymap.set('n', '<leader>ff', telescope.find_files, opts)
    vim.keymap.set('n', '<leader>fg', telescope.live_grep, opts)
    vim.keymap.set('v', '<leader>fg', telescope.grep_string, opts)
    vim.keymap.set('n', '<leader>pp', telescope_ext.projects.projects, opts)

    -- Functional
    vim.keymap.set('n', '<leader>v', vim.cmd.NvimTreeToggle, opts)
    vim.keymap.set('n', '<leader>z', vim.cmd.ZenMode, opts)

    -- Split Navigation
    vim.keymap.set('n', '<leader>h', '<cmd>wincmd h<CR>', opts)
    vim.keymap.set('n', '<leader>j', '<cmd>wincmd j<CR>', opts)
    vim.keymap.set('n', '<leader>k', '<cmd>wincmd k<CR>', opts)
    vim.keymap.set('n', '<leader>l', '<cmd>wincmd l<CR>', opts)
    vim.keymap.set('n', '<leader>+', '<cmd>vertical resize +5<CR>', opts)
    vim.keymap.set('n', '<leader>-', '<cmd>vertical resize -5<CR>', opts)

    -- Buffer Tab Navigation
    vim.keymap.set('n', '<A-h>', vim.cmd.BufferPrevious, opts)
    vim.keymap.set('n', '<A-l>', vim.cmd.BufferNext, opts)
    vim.keymap.set('n', '<A-H>', vim.cmd.BufferMovePrevious, opts)
    vim.keymap.set('n', '<A-L>', vim.cmd.BufferMoveNext, opts)
    vim.keymap.set('n', '<A-p>', vim.cmd.BufferPin, opts)
    vim.keymap.set('n', '<A-q>', vim.cmd.BufferClose, opts)
-- QuickFix Navigation vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
    vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
    vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
    vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

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
end

local function lsp()
    local opts = { silent = true }
    vim.keymap.set('n', '<C-CR>', '<cmd>Lspsaga goto_definition<CR>', opts)
    vim.keymap.set('n', '<leader>o', '<cmd>Lspsaga outline<CR>', opts)
end

local function quickfix_list()
    local opts = { silent = true, buffer = true }
    vim.keymap.set('n', '<C-k>', '<cmd>cprev<CR>zz<C-w>w', opts)
    vim.keymap.set('n', '<C-j>', '<cmd>cnext<CR>zz<C-w>w', opts)
    vim.keymap.set('n', '<leader>u', '<cmd>set modifiable<CR>', opts)
    vim.keymap.set('n', '<leader>w', '<cmd>cgetbuffer<CR>:cclose<CR>:copen<CR>', opts)
    vim.keymap.set('n', '<leader>r', '<cmd>cdo s/// | update<C-Left><C-Left><Left><Left><Left>', opts)
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
        vim.api.nvim_feedkeys("ds" .. c, "n", false)
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

    vim.keymap.set('n', '<CR>', function () return vault_actions.enter_command() end, { buffer = true, expr = true })

    vim.keymap.set('n', '<leader>fb', vim.cmd.FindBacklinks, { buffer = true })
    vim.keymap.set('n', '<leader>ft', vim.cmd.ObsidianTags, { buffer = true })
    vim.keymap.set('n', '<leader>fn', vim.cmd.ObsidianQuickSwitch, { buffer = true })
    vim.keymap.set('n', '<leader>fs', "<cmd>ObsidianQuickSwitch ~<CR>", { buffer = true })
    vim.keymap.set('n', '<leader>fa', "<cmd>ObsidianQuickSwitch %<CR>", { buffer = true })

    vim.keymap.set({'n', 'v'}, '<leader>ns', vault_actions.new_source, { buffer = true })
    vim.keymap.set({'n', 'v'}, '<leader>nn', vault_actions.new_note, { buffer = true })
    vim.keymap.set({'n', 'v'}, '<leader>na', vault_actions.new_author, { buffer = true })
    vim.keymap.set('v', '<leader>an', vault_actions.append_to_note, { buffer = true })

    vim.keymap.set('v', '<leader>h', function () surround_visual('==') end, { buffer = true })
    vim.keymap.set('v', '<leader>b', function () surround_visual('**') end, { buffer = true })
    vim.keymap.set('v', '<leader>e', function () surround_visual('*') end, { buffer = true })
    vim.keymap.set('v', '<leader>c', function () surround_visual('`') end, { buffer = true })

    vim.keymap.set('n', '<leader>h', function () delete_surround('==') end, { buffer = true })
    vim.keymap.set('n', '<leader>b', function () delete_surround('**') end, { buffer = true })
    vim.keymap.set('n', '<leader>e', function () delete_surround('*') end, { buffer = true })
    vim.keymap.set('n', '<leader>c', function () delete_surround('`') end, { buffer = true })

    vim.keymap.set('i', '--', '—', { buffer = true })

end

return { general=general, markdown=markdown, lsp=lsp, quickfix_list=quickfix_list}
