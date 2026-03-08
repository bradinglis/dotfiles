-- local snacks_picker = require "snacks.picker"
-- local util = require("vault.util")

local pick_all = function()
  require("vault.search").pick_from(NotesDatabase.notes.data, "All Notes")
end

local pick_sources = function()
  require("vault.search").pick_from(NotesDatabase.notes:get_type_dict("source"), "Sources")
end

local pick_authors = function()
  require("vault.search").pick_from(NotesDatabase.notes:get_type_dict("author"), "Authors")
end


-- local pick_from_all = function(notes)
--
--   local entries = {}
--   for i, entry in ipairs(notes) do
--     table.insert(entries, {
--       text = (entry.title or "") .. " " .. entry.author_string .. " " .. entry.id,
--       ordinal = (entry.title or "") .. " " .. entry.author_string .. " " .. entry.id,
--       title = (entry.title or ""),
--       author = entry.author_string,
--       tags = entry.tags,
--       line = (entry.search_line or ""),
--       pos = {entry.search_line, 0},
--       icon = entry.icon,
--       score_add = entry.search_score or 0,
--       value = entry,
--       file = entry.relative_path,
--       id = entry.id,
--       link = "[[" .. entry.id .. "|" .. (entry.title or "") .. "]]"
--     })
--   end
--
--   local pick_opts = vim.tbl_deep_extend('force', util.picker_opts or {}, {
--     title = "All Notes",
--     items = entries,
--     format = function(item, _)
--       local ret = {}
--       ret[#ret + 1] = { item.icon .. "  ", "Fg" }
--       ret[#ret + 1] = { util.set_string_width((item.title or ""), 50) .. " ", "markdownBold" }
--       ret[#ret + 1] = { util.set_string_width(item.author, 25) .. " ", "markdownItalic" }
--       ret[#ret + 1] = { util.set_string_width(table.concat(item.tags, " "), 40) .. " ", "ObsidianTag" }
--       ret[#ret + 1] = { item.id, "Grey" }
--       return ret
--     end,
--   })
--
--   snacks_picker.pick(pick_opts)
-- end


return {
  pick_all = pick_all,
  pick_sources = pick_sources,
  pick_authors = pick_authors,
  -- pick_from_all = pick_from_all
}
