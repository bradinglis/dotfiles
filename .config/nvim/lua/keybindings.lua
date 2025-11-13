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

  -- Telescope
  wk.add({ { "<leader>f", group = "find" } })
  vim.keymap.set('n', '<leader>ff', snacks.picker.smart, { desc = "files" })
  vim.keymap.set('n', '<leader>fx', snacks.picker.files, { desc = "files" })
  vim.keymap.set('n', '<leader>fg', snacks.picker.grep, { desc = "grep" })
  vim.keymap.set('n', '<leader>fb', snacks.picker.buffers, { desc = "buffers" })
  vim.keymap.set('n', '<leader>f<Enter>', function() snacks.explorer() end, { desc = 'explorer' })

  -- Git
  wk.add({ { "<leader>g", group = "git" } })
  vim.keymap.set('n', '<leader>gb', snacks.picker.git_branches, { desc = 'git branches' })
  vim.keymap.set('n', '<leader>gl', snacks.picker.git_log, { desc = 'git log' })
  vim.keymap.set('n', '<leader>gs', snacks.picker.git_status, { desc = 'git status' })
  vim.keymap.set('n', '<leader>gd', function() require("diffview").open() end, { desc = 'diffview open' })
  vim.keymap.set('n', '<leader>gc', function() require("diffview").close() end, { desc = 'diffview close' })

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

  vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")
  vim.keymap.set('n', 'z=', snacks.picker.spelling, opts)

  vim.keymap.set('i', '<C-Space>', '<Space>')
  vim.keymap.set('n', '<leader>lf', require("conform").format, { desc = 'format' })
end

local function lsp()
  local opts = { silent = true }
  vim.keymap.set('n', '<C-CR>', snacks.picker.lsp_definitions, opts)
  vim.keymap.set('n', 'gd', snacks.picker.lsp_definitions, { desc = 'lsp definition' })
  vim.keymap.set('n', 'gr', snacks.picker.lsp_references, { desc = 'lsp goto reference' })
  -- vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { desc = 'lsp format' })
  vim.keymap.set('n', '<leader>lc', vim.lsp.buf.code_action, { desc = 'lsp code action' })

  -- vim.keymap.set('n', '<leader>fi', snacks.picker.lsp_incoming_calls, { buffer = true, desc = 'lsp incoming' })
  -- vim.keymap.set('n', '<leader>fo', snacks.picker.lsp_outgoing_calls, { buffer = true, desc = 'lsp outgoing' })
  vim.keymap.set('n', '<leader>fD', snacks.picker.diagnostics, { desc = 'lsp diagnostics' })
  vim.keymap.set('n', '<leader>fd', snacks.picker.diagnostics_buffer, { desc = 'lsp diagnostics buffer' })
  vim.keymap.set('n', '<leader>fw', snacks.picker.lsp_workspace_symbols, { desc = 'lsp workplace symbols' })
  vim.keymap.set('n', '<leader>fs', snacks.picker.lsp_symbols, { desc = 'lsp document symbols' })
  vim.keymap.set('n', '<leader>fr', snacks.picker.lsp_references, { desc = 'lsp references' })
end

local function lsp_short()
  local opts = { silent = true }
  vim.keymap.set('n', '<leader>lc', vim.lsp.buf.code_action, { desc = 'lsp code action' })

  vim.keymap.set('n', '<leader>fD', snacks.picker.diagnostics, { desc = 'lsp diagnostics' })
  vim.keymap.set('n', '<leader>fd', snacks.picker.diagnostics_buffer, { desc = 'lsp diagnostics buffer' })
  vim.keymap.set('n', '<leader>fw', snacks.picker.lsp_workspace_symbols, { desc = 'lsp workplace symbols' })
  vim.keymap.set('n', '<leader>fr', snacks.picker.lsp_references, { desc = 'lsp references' })
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
  local endloc = { col = viz.cecol, row = viz.cerow - 1 }

  vim.api.nvim_buf_set_text(0, endloc.row, endloc.col, endloc.row, endloc.col, { surround })
  vim.api.nvim_buf_set_text(0, startloc.row, startloc.col, startloc.row, startloc.col, { surround })
end

local function delete_surround(surround)
  for c in surround:gmatch(".") do
    vim.api.nvim_feedkeys("gsd" .. c, "m", false)
  end
end

local function markdown()
  local vault_create = require 'vault.create'
  local vault_util = require 'vault.util'

  vim.keymap.set("n", "j", function()
    if vim.v.count > 0 then
      return "j"
    else
      return "gj"
    end
  end, { buffer = true, expr = true })

  vim.keymap.set("n", "k", function()
    if vim.v.count > 0 then
      return "k"
    else
      return "gk"
    end
  end, { buffer = true, expr = true })

  vim.api.nvim_create_user_command('PrintTest', vault_util.print_test, {})
  vim.api.nvim_create_user_command('NewSource', vault_create.new_source, {})
  vim.api.nvim_create_user_command('NewNote', vault_create.new_note, {})
  vim.api.nvim_create_user_command('FindBacklinks', require('vault.backlinks').backlink_search, {})

  vim.api.nvim_create_user_command('SourceSearch', require 'vault.source_search', {})
  vim.api.nvim_create_user_command('AuthorSearch', require 'vault.author_search', {})
  vim.api.nvim_create_user_command('NoteSearch', require 'vault.note_search', {})
  vim.api.nvim_create_user_command('AllSearch', require 'vault.all_search', {})
  vim.api.nvim_create_user_command('RefreshNotes', require 'vault.data'.refresh_notes, {})
  -- vim.api.nvim_create_user_command('SmartAction', require("obsidian.api").smart_action, {})

  vim.api.nvim_create_user_command('TagSearch', function(args)
    if #args.fargs == 0 then
      require('vault.tag_search').all_tags()
    else
      require('vault.tag_search').single_tag(args.fargs[1])
    end
  end, { nargs = '?' })

  vim.keymap.set('n', '<CR>', function() return vault_util.enter_command() end, { silent = true, buffer = true, expr = true })
  -- vim.keymap.set('n', '<leader>t', vim.cmd.ObsidianToggleCheckbox, { buffer = true })
  vim.keymap.set('n', '<leader>rr', vault_util.links_to_reference, { buffer = true })
  vim.keymap.set('n', '<leader>rl', vault_util.references_to_links, { buffer = true })

  vim.keymap.set('n', '<leader>fg', require('vault.grep_search'), { desc = 'find grep', buffer = true })
  vim.keymap.set('n', '<leader>fl', vim.cmd.FindBacklinks, { desc = 'find backlinks)', buffer = true })
  vim.keymap.set('n', '<leader>ft', vim.cmd.TagSearch, { desc = 'find tags', buffer = true })
  vim.keymap.set('n', '<leader>fn', require 'vault.note_search', { desc = 'find note', buffer = true })
  vim.keymap.set('n', '<leader>fs', require 'vault.source_search', { desc = 'find source', buffer = true })
  vim.keymap.set('n', '<leader>fa', require 'vault.author_search', { desc = 'find author', buffer = true })
  vim.keymap.set('n', '<leader>ff', require 'vault.all_search', { desc = 'find all notes', buffer = true })
  vim.keymap.set('n', '<leader>fx', require 'vault.all_search_new', { desc = 'find all notes', buffer = true })

  wk.add({ { "<leader>n", group = "new", icon = { cat = "filetype", name = "markdown" } } })
  vim.keymap.set({ "v", "n" }, '<leader>ns', vault_create.new_source, { desc = 'new source', buffer = true })
  vim.keymap.set({ "v", "n" }, '<leader>nn', vault_create.new_note, { desc = 'new note', buffer = true })
  vim.keymap.set({ "v", "n" }, '<leader>na', vault_create.new_author, { desc = 'new author', buffer = true })
  vim.keymap.set('x', '<leader>np', vault_create.append_to_note, { desc = 'append to note', buffer = true })

  vim.keymap.set('x', '<leader>h', function() surround_visual('==') end, { buffer = true })
  vim.keymap.set('x', '<leader>b', function() surround_visual('**') end, { buffer = true })
  vim.keymap.set('x', '<leader>e', function() surround_visual('*') end, { buffer = true })
  vim.keymap.set('x', '<leader>c', function() surround_visual('`') end, { buffer = true })

  wk.add({ { "<leader>d", group = "delete surround", icon = { cat = "filetype", name = "markdown" } } })
  vim.keymap.set('n', '<leader>dh', function() delete_surround('==') end, { buffer = true, desc = 'delete highlight' })
  vim.keymap.set('n', '<leader>db', function() delete_surround('**') end, { buffer = true, desc = 'delete bold' })
  vim.keymap.set('n', '<leader>de', function() delete_surround('*') end, { buffer = true, desc = 'delete italic' })
  vim.keymap.set('n', '<leader>dc', function() delete_surround('`') end, { buffer = true, desc = 'delete code' })

  vim.keymap.set('n', '<leader>r', function()
    vim.cmd.Markview("Toggle")
    vim.opt.conceallevel = 2
    vim.opt.concealcursor = ""
  end, { buffer = true })

  vim.keymap.set('i', '--', '—', { buffer = true })
  vim.keymap.set('i', '->', '→', { buffer = true })
  vim.keymap.set('i', '<-', '←', { buffer = true })
  vim.keymap.set('i', '<<', '«', { buffer = true })
  vim.keymap.set('i', '>>', '»', { buffer = true })
  vim.keymap.set('i', '-!', '↓', { buffer = true })
  vim.keymap.set('i', '-^', '↑', { buffer = true })

  -- vim.keymap.del('i', '<CR>')
  vim.keymap.set('i', '<CR>', '<Plug>(bullets-newline)', { buffer = true })
end

return {
  general = general,
  markdown = markdown,
  lsp = lsp,
  lsp_short = lsp_short,
  quickfix_list = quickfix_list
}
