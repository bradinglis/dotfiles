local telescope = require "telescope.builtin"
local entry_display = require "telescope.pickers.entry_display"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values

local snacks_picker = require "snacks.picker"
local util = require("vault.util")

local grep = function()
  if not vim.wait(5000, function()
        return not vim.g.notes_refreshing
      end) then
    return
  end

  local lines = require("vault.data").get_lines()

  local entries = {}
  for _, entry in ipairs(lines) do
    table.insert(entries, {
      text = entry.note.title .. " " .. entry.text,
      search = entry.text,
      title = entry.note.title,
      icon = entry.note.icon,
      value = entry,
      id = entry.note.id,
      link = "[[" .. entry.note.id .. "|" .. entry.note.title .. "]]",
      file = entry.note.path,
      pos = {entry.num, 1},
      line = entry.num
    })
  end

  local pick_opts = vim.tbl_deep_extend('force', util.picker_opts or {}, {
    title = "Grep",
    items = entries,
    format = function(item, _)
      local ret = {}
      ret[#ret + 1] = { util.set_string_width(tostring(item.line), 5), "Grey" }
      ret[#ret + 1] = { util.set_string_width(item.id, 40) .. " ", "markdownBoldItalic" }
      ret[#ret + 1] = { item.search, "Fg" }
      return ret
    end
  })

  snacks_picker.pick(pick_opts)

end

return grep
