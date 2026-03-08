local snacks_picker = require "snacks.picker"
local util = require("vault.util")
local search = require "obsidian.search"

local single_tag = function(data)
  local notes = NotesDatabase:get_ref_notes(data.note_refs)
  require("vault.search").pick_from(notes, "[" .. data.tag .. "] Notes")
end

local all_tags = function()
  local tags = NotesDatabase.tags.data

  local entries = vim.iter(tags):map(function(tag, note_refs)
    return {
      text = tag .. #note_refs,
      number = #note_refs,
      notes = table.concat(vim.tbl_map(function(n) return n.note_id end, note_refs), " "),
      score_add = #note_refs,
      tag = tag,
      data = { tag = tag, note_refs = note_refs },
    }
  end):totable()

  table.sort(entries, function(a, b)
    return a.number > b.number
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
      ret[#ret + 1] = { util.set_string_width(item.tag, 40) .. " ", "ObsidianTag" }
      ret[#ret + 1] = { item.notes, "Grey" }
      return ret
    end,
    win = {
      input = {
        keys = {
          ["<C-r>"] = { "rename_tag", mode = { "n", "i" }, desc = "Rename Tag" },
          ["<C-d>"] = { "delete_tag", mode = { "n", "i" }, desc = "Delete Tag" },
        },
      },
    },
    actions = {
      delete_tag = function(picker)
        local tag = picker:current().tag
        local tag_notes = vim.tbl_values(tags[tag])
          for _, note in ipairs(tag_notes) do
            local obs_note = search.resolve_note(note.note.id)[1];
            obs_note.tags = vim.tbl_filter(function(x) return x ~= tag end, obs_note.tags)
            obs_note:write()
          end
          picker:close()
          require("vault.data")
      end,
      rename_tag = function(picker)
        local tag = picker:current().tag
        local tag_notes = vim.tbl_values(tags[tag])
        vim.ui.input({ prompt = "Rename tag '" .. tag .. "'" }, function(new_tag)
          for _, note in ipairs(tag_notes) do
            local obs_note = search.resolve_note(note.note.id)[1];
            obs_note.tags = vim.tbl_filter(function(x) return x ~= tag end, obs_note.tags)
            obs_note:add_tag(new_tag)
            obs_note:write()
          end
          picker:close()
          require("vault.data")
        end)
      end,
    },
    confirm = function(picker, item)
      picker:close()
      single_tag(item.data)
    end,
  }
  snacks_picker.pick(pick_opts)
end

return {
  single_tag = single_tag,
  all_tags = all_tags
}
