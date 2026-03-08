local snacks_picker = require "snacks.picker"
local util = require("vault.util")

---comment
---@param notes table<string, obsidian.Note> | obsidian.FullNoteRef[]
---@param name string
local pick_from = function(notes, name)
  local entries = {}
  if vim.islist(notes) then
    entries = vim.tbl_map(function(n)
      return {
        text = (n.note.title or "") .. " " .. NotesDatabase:get_note_author_string(n.note) .. " " .. n.note.id,
        ordinal = (n.note.title or "") .. " " .. NotesDatabase:get_note_author_string(n.note) .. " " .. n.note.id,
        title = (n.note.title or ""),
        author = NotesDatabase:get_note_author_string(n.note),
        tags = n.note.tags,
        icon = n.note.icon,
        score_add = 70 + ((n.note.recency * -1)/10),
        file = n.note.relative_path,
        id = n.note.id,
        link = "[[" .. n.note.id .. "|" .. n.note.title .. "]]",
        pos = {n.line_num, 1},
      }
    end, notes)
  else
    entries = vim.tbl_map(function(note)
      return {
        text = (note.title or "") .. " " .. NotesDatabase:get_note_author_string(note) .. " " .. note.id,
        ordinal = (note.title or "") .. " " .. NotesDatabase:get_note_author_string(note) .. " " .. note.id,
        title = (note.title or ""),
        author = NotesDatabase:get_note_author_string(note),
        tags = note.tags,
        icon = note.icon,
        score_add = 70 + ((note.recency * -1)/10),
        file = note.relative_path,
        id = note.id,
        link = "[[" .. note.id .. "|" .. (note.title or "") .. "]]"
      }
    end, vim.tbl_values(notes))
  end

  table.sort(entries,
    function(a, b)
      return a.score_add > b.score_add
    end
  )

  local pick_opts = vim.tbl_deep_extend('force', util.picker_opts or {}, {
    title = name or "Notes",
    items = entries,
    format = function(item, _)
      return {
        { item.icon .. "  ", "Fg" },
        { util.set_string_width((item.title or ""), 50) .. " ", "markdownBold" },
        { util.set_string_width(item.author, 25) .. " ", "markdownItalic" },
        { util.set_string_width(table.concat(item.tags, " "), 40) .. " ", "ObsidianTag" },
        { item.id, "Grey" }
      }
    end,
  })

  snacks_picker.pick(pick_opts)
end

return {
  pick_from = pick_from,
}
