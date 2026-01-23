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

vim.wo.wrap = true
vim.wo.linebreak = true
vim.wo.breakindent = true
vim.opt_local.shiftwidth = 2
vim.o.breakat = " ^!-+;:,./?"
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

vim.api.nvim_create_user_command('TagSearch', function(args)
  if #args.fargs == 0 then
    require('vault.tag_search').all_tags()
  else
    require('vault.tag_search').single_tag(args.fargs[1])
  end
end, { nargs = '?' })

vim.keymap.set('n', '<CR>', function() return vault_util.enter_command() end, { silent = true, buffer = true, expr = true })

vim.keymap.set('n', 'ga', function() return vault_util.goto_ado() end, { silent = true, buffer = true, expr = true })
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

-- wk.add({ { "<leader>n", group = "new", icon = { cat = "filetype", name = "markdown" } } })
vim.keymap.set({ "v", "n" }, '<leader>ns', vault_create.new_source, { desc = 'new source', buffer = true })
vim.keymap.set({ "v", "n" }, '<leader>nn', vault_create.new_note, { desc = 'new note', buffer = true })
vim.keymap.set({ "v", "n" }, '<leader>na', vault_create.new_author, { desc = 'new author', buffer = true })
vim.keymap.set('x', '<leader>np', vault_create.append_to_note, { desc = 'append to note', buffer = true })

vim.keymap.set('x', '<leader>h', function() surround_visual('==') end, { buffer = true })
vim.keymap.set('x', '<leader>b', function() surround_visual('**') end, { buffer = true })
vim.keymap.set('x', '<leader>e', function() surround_visual('*') end, { buffer = true })
vim.keymap.set('x', '<leader>c', function() surround_visual('`') end, { buffer = true })

-- wk.add({ { "<leader>d", group = "delete surround", icon = { cat = "filetype", name = "markdown" } } })
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

vim.keymap.set('i', '<CR>', function()
    local enter = vim.api.nvim_eval("v:lua.require'nvim-autopairs'.completion_confirm()")
    if enter == "\r" then
      return vim.api.nvim_replace_termcodes("<Plug>(bullets-newline)", true, true, true)
    else
      return enter
    end
  end,
  { replace_keycodes=false, expr = true, noremap = true, buffer = true })

