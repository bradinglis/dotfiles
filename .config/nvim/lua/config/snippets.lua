local ls = require "luasnip"

-- local title = function(input)
--   return input:lower():gsub("^(%l)", string.upper)
--       :gsub("(%s%l)(%l%l%l)", function (f, s)
--         return string.upper(f) .. s
--       end)
-- end

local loop = {
  string.lower,
  string.upper,
  -- title
}

local default = ""
local function set_default(s)
  default = s
end

local s = 1;

local pos_jump = function(direction)
  local x = require("flash.plugins.treesitter").get_nodes(0)

  local sig_node = nil
  for _, value in ipairs(x) do
    local t = value.node:type()
    if t == "code_span" or t == "emphasis" then
      sig_node = value
    end
  end
  if not sig_node then
    sig_node = x[1]
  end

  if direction == -1 then
    vim.api.nvim_win_set_cursor(0, { sig_node.pos[1], sig_node.pos[2] })
    return 1
  else
    vim.api.nvim_win_set_cursor(0, { sig_node.end_pos[1], sig_node.end_pos[2] + 1 })
    return 1
  end
end


vim.snippet.expand = ls.lsp_expand

---@diagnostic disable-next-line: duplicate-set-field
vim.snippet.active = function(filter)
  filter = filter or {}
  filter.direction = filter.direction or 1

  if filter.direction == 1 then
    return ls.expand_or_jumpable()
  else
    return ls.jumpable(filter.direction)
  end
end

---@diagnostic disable-next-line: duplicate-set-field
vim.snippet.jump = function(direction)
  s = 1
  if direction == 1 then
    if ls.expandable() then
      return ls.expand_or_jump()
    else
      return ls.jumpable(1) and ls.jump(1) or pos_jump(1)
    end
  else
    return ls.jumpable(-1) and ls.jump(-1) or pos_jump(-1)
  end
end

vim.snippet.stop = ls.unlink_current

-- ================================================
--      My Configuration
-- ================================================
ls.config.set_config {
  history = true,
  updateevents = "TextChanged,TextChangedI",
  override_builtin = true,
  enable_autosnippets = true
}

for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/snippets/*.lua", true)) do
  loadfile(ft_path)()
end

vim.keymap.set({ "i", "s" }, "<c-l>", function()
  if vim.snippet.active { direction = 1 } then
    return vim.snippet.jump(1)
  else
    return pos_jump(1)
  end
end, { silent = true })


vim.api.nvim_create_user_command('InsertTabJump', function() vim.snippet.jump(1) end, {})

vim.keymap.set({ "i", "s" }, "<Tab>", function()
  return ls.locally_jumpable(1) and "<cmd>InsertTabJump<CR>" or "<Tab>"
end, { silent = true, expr = true })


vim.keymap.set({ "i", "s" }, "<c-h>", function()
  if vim.snippet.active { direction = -1 } then
    return vim.snippet.jump(-1)
  else
    return pos_jump(-1)
  end
end, { silent = true })

vim.keymap.set({ "s" }, "<c-u>", function()
  local viz = require("vault.util").get_visual_selection()
  if viz then
    local rep = ""
    if s == 0 then
      rep = default
    else
      if s == 1 then
        default = viz.selection
      end
      rep = loop[s](viz.selection)
    end
    if s == #loop then
      s = 0
    else
      s = s + 1
    end


    vim.api.nvim_buf_set_text(
      0,
      viz.csrow - 1,
      viz.cscol - 1,
      viz.cerow - 1,
      viz.cecol,
      { rep })
  end

  dd(viz)
end)

return {
  set_default = set_default
}

