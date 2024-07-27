local abc = require "obsidian.abc"
local obsidian = require "obsidian"
local completion = require "obsidian.completion.tags"
local util = require "obsidian.util"
local iter = require("obsidian.itertools").iter
local Note = require "obsidian.note"

local source = abc.new_class()

local get_frontmatter_boundaries = function(bufnr)
  local note = Note.from_buffer(bufnr)
  if note.frontmatter_end_line ~= nil then
    return 1, note.frontmatter_end_line
  end
end

source.new = function()
  return source.init()
end

source.get_trigger_characters = function ()
    return { "%" }
end

source.get_keyword_pattern = function ()
    return "%[a-zA-Z0-9_/-]\\+"
end

source.complete = function(_, request, callback)
  local client = assert(obsidian.get_client())

  local in_frontmatter = false
  local line = request.context.cursor.line
  local frontmatter_start, frontmatter_end = get_frontmatter_boundaries(request.context.bufnr)
  if frontmatter_start ~= nil and frontmatter_start <= line and frontmatter_end ~= nil and line <= frontmatter_end then
    in_frontmatter = true
  end

  local match = string.match(request.context.cursor_before_line, "^%[A-Za-z0-9_/-]*")

  print(vim.inspect(in_frontmatter))
  print(vim.inspect(match))

  if (not match or string.len(match) == 0) or not in_frontmatter then
    return callback { isIncomplete = true }
  end

  client:find_notes_async(match, function(notes)
    local sources = {}
    for sourcenote in iter(notes) do
      sources[sourcenote.id] = true
    end

    local items = {}
    for sourcenote, _ in pairs(sources) do
      items[#items + 1] = {
        sortText = sourcenote,
        label = "Source: " .. sourcenote,
        kind = 1, -- "Text"
        insertText = sourcenote,
        data = {
          bufnr = request.context.bufnr,
          line = request.context.cursor.line,
          sourcenote = sourcenote,
        },
      }
    end

    return callback {
      items = items,
      isIncomplete = false,
    }
  end, { search = { sort = false } })
end

source.execute = function(_, _, callback)
  return callback {}
end

return source
