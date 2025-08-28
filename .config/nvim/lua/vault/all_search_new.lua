local snacks_picker = require "snacks.picker"
local entry_display = require "telescope.pickers.entry_display"

local pick_all = function()
  -- if not vim.wait(5000, function ()
  --   return not vim.g.notes_refreshing
  -- end) then
  --   return
  -- end

  local all_notes = require("vault.data").get_all_notes()

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 2 },
      { width = 40 },
      { width = 20 },
      { width = 40 },
      { remaining = true },
    },
  }

  local entries = {}
  for _, entry in ipairs(all_notes) do
    table.insert(entries, {
      text = entry.title .. " " .. entry.author_string .. " " .. entry.id,
      ordinal = entry.title .. " " .. entry.author_string .. " " .. entry.id,
      title = entry.title,
      author = entry.author_string,
      tags = entry.tags,
      value = entry,
      file = entry.relative_path,
      id = entry.id,
      link = "[[" .. entry.id .. "|" .. entry.title .. "]]"
    })
  end

  local pick_opts = {
    title = "All Notes",
    items = entries,
    layout = {
      layout = {
        backdrop = false,
        -- row = 1,
        width = 0.9,
        min_width = 80,
        height = 0.95,
        border = "none",
        box = "vertical",
        { win = "preview", title = "{preview}", height = 0.7, border = "rounded" },
        {
          box = "vertical",
          border = "rounded",
          title = "{title} {live} {flags}",
          title_pos = "center",
          { win = "input", height = 1,     border = "bottom" },
          { win = "list",  border = "none" },
        },
      }
    },
    format = function(item, picker)
      local ret = {}
      ret[#ret + 1] = { item.title, "markdownBoldItalic" }
      ret[#ret + 1] = { item.author, "markdownItalic" }
      ret[#ret + 1] = { table.concat(item.tags, " "), "ObsidianTag" }
      ret[#ret + 1] = { item.id, "Grey" }
      return ret
    end
  }
  snacks_picker.pick(pick_opts)
end

return pick_all
