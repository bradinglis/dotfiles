local snacks_picker = require "snacks.picker"
local util = require("vault.util")
local api = require "obsidian.api"

local function find_references(noteid)
  local notes = require("vault.data").get_all_notes()
  local res = {}

  for _, resnote in pairs(notes) do
    if resnote.metadata ~= nil and not vim.tbl_isempty(resnote.metadata) then
      if resnote.metadata.references ~= nil and not vim.tbl_isempty(resnote.metadata.references) then
        if vim.tbl_contains(resnote.metadata.references, noteid) then
          res[#res + 1] = {
            note = resnote,
            qual = "Reference",
          }
        end
      end
      if resnote.links ~= nil and not vim.tbl_isempty(resnote.links) then
        for _, value in ipairs(resnote.links) do
          if value[1] == noteid then
            res[#res + 1] = {
              note = resnote,
              line = value[2],
              qual = "Link [" .. value[2] .. "]",
            }
          end
        end
      end
    end
  end
  return res
end

local function collect_backlinks(noteid)
  local references = {}
  references = find_references(noteid)

  if vim.tbl_isempty(references) then
    return
  end

  local entries = {}
  for _, entry in ipairs(references) do
    table.insert(entries, {
      text = entry.note.title .. " " .. entry.note.author_string .. " " .. entry.note.id,
      ordinal = entry.note.title .. " " .. entry.note.author_string .. " " .. entry.note.id,
      title = entry.note.title,
      author = entry.note.author_string,
      tags = entry.note.tags,
      icon = entry.note.icon,
      value = entry,
      pos = entry.line and { entry.line, 1 } or nil,
      qual = entry.qual,
      file = entry.note.relative_path,
      id = entry.note.id,
      link = "[[" .. entry.note.id .. "|" .. entry.note.title .. "]]"
    })
  end

  local pick_opts = vim.tbl_deep_extend('force', util.picker_opts or {}, {
    title = "Backlinks",
    items = entries,
    format = function(item, _)
      local ret = {}
      ret[#ret + 1] = { util.set_string_width(item.qual, 10) .. " ", "Fg" }
      ret[#ret + 1] = { item.icon .. " ", "Fg" }
      ret[#ret + 1] = { util.set_string_width(item.title, 40) .. " ", "markdownBoldItalic" }
      ret[#ret + 1] = { util.set_string_width(item.author, 20) .. " ", "markdownItalic" }
      ret[#ret + 1] = { util.set_string_width(table.concat(item.tags, " "), 40) .. " ", "ObsidianTag" }
      ret[#ret + 1] = { item.id, "Grey" }
      return ret
    end
  })

  snacks_picker.pick(pick_opts)
end

local function main()
  local note = api.current_note()

  if note == nil then
    return
  else
    collect_backlinks(note.id)
  end
end

return { backlink_search = main }
