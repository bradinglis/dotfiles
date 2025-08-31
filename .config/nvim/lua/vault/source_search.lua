local snacks_picker = require "snacks.picker"
local util = require("vault.util")

local pick_source = function()
  if not vim.wait(5000, function()
        return not vim.g.notes_refreshing
      end) then
    return
  end

  local source_notes = require("vault.data").get_source_notes()

  local entries = {}
  for _, entry in ipairs(source_notes) do
    table.insert(entries, {
      text = entry.title .. " " .. entry.author_string .. " " .. entry.id,
      ordinal = entry.title .. " " .. entry.author_string .. " " .. entry.id,
      title = entry.title,
      author = entry.author_string,
      tags = entry.tags,
      icon = entry.icon,
      value = entry,
      file = entry.relative_path,
      id = entry.id,
      link = "[[" .. entry.id .. "|" .. entry.title .. "]]"
    })
  end

  local pick_opts = vim.tbl_deep_extend('force', util.picker_opts or {}, {
    title = "Source Notes",
    items = entries,
    format = function(item, _)
      local ret = {}
      ret[#ret + 1] = { util.set_string_width(item.title, 40) .. " ", "markdownBoldItalic" }
      ret[#ret + 1] = { util.set_string_width(item.author, 20) .. " ", "markdownItalic" }
      ret[#ret + 1] = { util.set_string_width(table.concat(item.tags, " "), 40) .. " ", "ObsidianTag" }
      ret[#ret + 1] = { item.id, "Grey" }
      return ret
    end
  })

  snacks_picker.pick(pick_opts)

end

return pick_source
