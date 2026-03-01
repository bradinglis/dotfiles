local snacks_picker = require "snacks.picker"
local util = require("vault.util")

local single_tag = function(tag)
  local notes = require("vault.data").get_notes()
  local tags = require("vault.data").get_tags()

  local tag_notes = vim.tbl_values(tags[tag])

  local entries = {}
  for i, entry in ipairs(tag_notes) do
    table.insert(entries, {
      text = entry.note.title .. " " .. entry.note.author_string .. " " .. entry.note.id,
      ordinal = entry.note.title .. " " .. entry.note.author_string .. " " .. entry.note.id,
      title = entry.note.title,
      author = entry.note.author_string,
      tags = entry.note.tags,
      score_add = #tag_notes - i,
      icon = entry.note.icon,
      value = entry.note,
      file = entry.note.relative_path,
      id = entry.note.id,
      link = "[[" .. entry.note.id .. "|" .. entry.note.title .. "]]"
    })
  end

  local pick_opts = vim.tbl_deep_extend('force', util.picker_opts or {}, {
    title = "[" .. tag .. "] Notes",
    items = entries,
    format = function(item, _)
      local ret = {}
      ret[#ret + 1] = { item.icon .. "  ", "Fg" }
      ret[#ret + 1] = { util.set_string_width(item.title, 40) .. " ", "markdownBoldItalic" }
      ret[#ret + 1] = { util.set_string_width(item.author, 20) .. " ", "markdownItalic" }
      ret[#ret + 1] = { util.set_string_width(table.concat(item.tags, " "), 40) .. " ", "ObsidianTag" }
      ret[#ret + 1] = { item.id, "Grey" }
      return ret
    end
  })

  snacks_picker.pick(pick_opts)
end

local all_tags = function()
  if not vim.wait(5000, function()
        return not vim.g.notes_refreshing
      end) then
    return
  end

  local tags = require("vault.data").get_tags()
  local tag_keys = vim.tbl_keys(tags)

  local entries = {}
  for _, entry in ipairs(tag_keys) do
    table.insert(entries, {
      text = entry .. vim.tbl_count(tags[entry]),
      number = vim.tbl_count(tags[entry]),
      notes = table.concat(vim.tbl_keys(tags[entry]), " "),
      score_add = vim.tbl_count(tags[entry]),
      tag = entry,
    })
  end
  table.sort(entries, function(a, b)
    return a.number < b.number
  end)

  local pick_opts = {
    title = "Tags",
    items = entries,
    preview = "none",
    layout = {
      layout = {
        backdrop = false,
        width = 0.90,
        min_width = 80,
        height = 0.95,
        border = "none",
        box = "vertical",
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
    format = function(item, _)
      local ret = {}
      ret[#ret + 1] = { util.set_string_width("[" .. item.number .. "] ", 5) .. " ", "Fg" }
      ret[#ret + 1] = { util.set_string_width(item.tag, 20) .. " ", "ObsidianTag" }
      ret[#ret + 1] = { item.notes, "Grey" }
      return ret
    end,
    confirm = function(picker, item)
      picker:close()
      single_tag(item.tag)
    end,
  }
  snacks_picker.pick(pick_opts)
end

return {
  single_tag = single_tag,
  all_tags = all_tags
}
