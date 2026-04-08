local function surround_visual(surround)
  local viz = require("markdown_db-nvim.util").get_visual_selection()
  if not viz then
    return
  end
  local ls = require("luasnip")
  local s = ls.snippet
  local i = ls.insert_node
  local fmt = require("luasnip.extras.fmt").fmt
  vim.api.nvim_feedkeys("d", "nx", false)

  ls.snip_expand(
    s({}, fmt("{}{}{}{}", { surround, i(1, viz.selection), surround, i(0) })
    )
  )

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

vim.keymap.set({ "n", "x" }, "j", function()
  if vim.v.count > 0 then
    return "j"
  else
    return "gj"
  end
end, { buffer = true, expr = true })

vim.keymap.set({ "n", "x" }, "k", function()
  if vim.v.count > 0 then
    return "k"
  else
    return "gk"
  end
end, { buffer = true, expr = true })

vim.keymap.set('x', '<leader>h', function() surround_visual('==') end, { buffer = true })
vim.keymap.set('x', '<leader>b', function() surround_visual('**') end, { buffer = true })
vim.keymap.set('x', '<leader>e', function() surround_visual('*') end, { buffer = true })
vim.keymap.set('x', '<leader>c', function() surround_visual('`') end, { buffer = true })

-- wk.add({ { "<leader>d", group = "delete surround", icon = { cat = "filetype", name = "markdown" } } })
vim.keymap.set('n', '<leader>dh', function() delete_surround('==') end, { buffer = true, desc = 'delete highlight' })
vim.keymap.set('n', '<leader>db', function() delete_surround('**') end, { buffer = true, desc = 'delete bold' })
vim.keymap.set('n', '<leader>de', function() delete_surround('*') end, { buffer = true, desc = 'delete italic' })
vim.keymap.set('n', '<leader>dc', function() delete_surround('`') end, { buffer = true, desc = 'delete code' })

vim.keymap.set('n', '<leader>do', function()
  dd("huh")
  local x = vim.split(vim.system({ "nu", "-c", "source ~/ado_api.nu; get_activity" }):wait().stdout, '\n')
  vim.api.nvim_buf_set_lines(0, -1, -1, false, x)
end, { buffer = true, desc = 'delete code' })

vim.keymap.set('i', '<CR>', function()
    local enter = vim.api.nvim_eval("v:lua.require'nvim-autopairs'.completion_confirm()")
    if enter == "\r" then
      return vim.api.nvim_replace_termcodes("<Plug>(bullets-newline)", true, true, true)
    else
      return enter
    end
  end,
  { replace_keycodes = false, expr = true, noremap = true, buffer = true })
