local snacks_picker = require "snacks.picker"
local entry_display = require "telescope.pickers.entry_display"

local set_width = function(text, width)

  if(vim.fn.strdisplaywidth(text) > width) then
    return string.sub(text, 1, width-1) .. "…"
  elseif vim.fn.strdisplaywidth(text) < width then
    return text .. string.rep(" ", width - vim.fn.strdisplaywidth(text))
  else
    return text
  end

end


local pick_all = function()
  if not vim.wait(5000, function ()
    return not vim.g.notes_refreshing
  end) then
    return
  end

  local all_notes = require("vault.data").get_all_notes()

  local entries = {}
  for _, entry in ipairs(all_notes) do
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

  local pick_opts = {
    title = "All Notes",
    items = entries,
    layout = {
      layout = {
        backdrop = false,
        width = 0.90,
        min_width = 80,
        height = 0.95,
        border = "none",
        box = "vertical",
        { win = "preview", title = "{preview}", height = 0.5, border = "rounded" },
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
      ret[#ret + 1] = { item.icon .. " ", "Fg" }
      ret[#ret + 1] = { set_width(item.title, 40) .. " ", "markdownBoldItalic" }
      ret[#ret + 1] = { set_width(item.author, 20) .. " ", "markdownItalic" }
      ret[#ret + 1] = { set_width(table.concat(item.tags, " "), 20) .. " ", "ObsidianTag" }
      ret[#ret + 1] = { item.id, "Grey" }
      return ret
    end
  }
  snacks_picker.pick(pick_opts)
end

return pick_all
