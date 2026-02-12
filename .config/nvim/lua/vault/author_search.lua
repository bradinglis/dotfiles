local snacks_picker = require "snacks.picker"
local util = require("vault.util")

local pick_author = function()
  if not vim.wait(5000, function()
        return not vim.g.notes_refreshing
      end) then
    return
  end

  local author_notes = require("vault.data").get_author_notes()

  local entries = {}
  for i, entry in ipairs(author_notes) do
    table.insert(entries, {
      text = entry.title .. " " .. entry.author_string .. " " .. entry.id,
      ordinal = entry.title .. " " .. entry.author_string .. " " .. entry.id,
      title = entry.title,
      author = entry.author_string,
      tags = entry.tags,
      icon = entry.icon,
      score_add = (#author_notes - i) * 0.1,
      value = entry,
      file = entry.relative_path,
      id = entry.id,
      link = "[[" .. entry.id .. "|" .. entry.title .. "]]"
    })
  end

  local pick_opts = vim.tbl_deep_extend('force', util.picker_opts or {}, {
    title = "Author Notes",
    items = entries,
    format = function(item, _)
      local ret = {}
      ret[#ret + 1] = { util.set_string_width(item.title, 40) .. " ", "markdownItalic" }
      ret[#ret + 1] = { util.set_string_width(table.concat(item.tags, " "), 40) .. " ", "ObsidianTag" }
      ret[#ret + 1] = { item.id, "Grey" }
      return ret
    end
  })

  snacks_picker.pick(pick_opts)

end

return pick_author
