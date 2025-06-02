local abc = require "obsidian.abc"
local obsidian = require "obsidian"
local util = require "obsidian.util"
local iter = require("obsidian.itertools").iter
local Note = require "obsidian.note"

local source = abc.new_class()

local function filter(arr, func)
  local new_arr = {}
  for old_index, v in ipairs(arr) do
    if func(v, old_index) then
      new_arr[#new_arr + 1] = v
    end
  end
  return new_arr
end

local SOURCE_PATTERNS = {
  { pattern = "[%s%(]s_[A-Za-z0-9_/-]*$", offset = 1 },
  { pattern = "^s_[A-Za-z0-9_/-]*$",       offset = 0 },
}


local find_sources_start = function(input)
  for _, pattern in ipairs(SOURCE_PATTERNS) do
    local match = string.match(input, pattern.pattern)
    if match then
      return string.sub(match, pattern.offset + 1)
    end
  end
end

local get_frontmatter_boundaries = function(bufnr)
  local note = Note.from_buffer(bufnr)
  if note.frontmatter_end_line ~= nil then
    return 1, note.frontmatter_end_line
  end
end

source.new = function()
  return source.init()
end

source.get_trigger_characters = function()
  return { "_" }
end

source.get_keyword_pattern = function()
  return "s_[a-zA-Z0-9_/-]\\+"
end

source.complete = function(_, request, callback)
  local client = assert(obsidian.get_client())

  local in_frontmatter = false
  local line = request.context.cursor.line
  local frontmatter_start, frontmatter_end = get_frontmatter_boundaries(request.context.bufnr)
  if frontmatter_start ~= nil and frontmatter_start <= line and frontmatter_end ~= nil and line <= frontmatter_end then
    in_frontmatter = true
  end

  local search = find_sources_start(request.context.cursor_before_line)

  if (not search or string.len(search) == 0) or not in_frontmatter or search == nil then
    return callback { isIncomplete = true }
  end

  local notes = require("vault.search").get_notes()

  local source_notes = filter(notes, function(val, _)
    if val.metadata ~= nil then
      if val.metadata.type ~= nil then
        return val.metadata.type == "source"
      end
    else
      return false
    end
  end)

  local items = {}

  for _, source_val in pairs(source_notes) do
    items[#items + 1] = {
      sortText = source_val.id,
      label = "Source: " .. source_val.id,
      kind = 1, -- "Text"
      insertText = source_val.id,
      data = {
        bufnr = request.context.bufnr,
        line = request.context.cursor.line,
        sourcenote = source_val.id,
      },
    }
  end

  return callback {
    items = items,
    isIncomplete = false,
  }
end

return source
