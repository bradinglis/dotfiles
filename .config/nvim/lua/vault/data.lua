local client = require("obsidian").get_client()

local notes = {}
local all_notes = {}
local note_notes = {}
local author_notes = {}
local source_notes = {}
local lines = {}
local tags = {}

local get_lines = function()
  if lines == {} then
    return lines
  else
    return lines
  end
end

local get_notes = function()
  if notes == {} then
    return {}
  else
    return notes
  end
end

local get_all_notes = function()
  if all_notes == {} then
    return {}
  else
    return all_notes
  end
end

local get_note_notes = function()
  if note_notes == {} then
    return {}
  else
    return note_notes
  end
end

local get_source_notes = function()
  if source_notes == {} then
    return {}
  else
    return source_notes
  end
end

local get_author_notes = function()
  if author_notes == {} then
    return {}
  else
    return author_notes
  end
end

local get_tags = function()
  if tags == {} then
    return {}
  else
    return tags
  end
end


local handle_tag = function(tag, note,  t_tags, line)
  if line == nil then
    line = 1
  end
  if t_tags[tag] == nil then
    t_tags[tag] = {}
  end
  if t_tags[tag][note.id] == nil then
    t_tags[tag][note.id] = { note = note, line = line }
  end
end

local handle_body = function(note, t_lines, t_tags)
  for num, line in ipairs(note.contents) do
    local endline = note.frontmatter_end_line or 0
    if (num > (endline)) then
      if #line > 1 then
        table.insert(t_lines, { note = { id = note.id, path = note.path.filename }, text = line, num = num })
      end

      for link in line:gmatch("%[%[[%w-_.',]*[|%]]") do
        table.insert(note.links, { link:sub(3, -2), num })
      end
      for tag in line:gmatch("#[%w-]+") do
        tag = tag:sub(2, -1)
        table.insert(note.body_tags, { tag, num })
        handle_tag(tag, note,  t_tags, num)
      end
    end
  end
end

local handle_note = function(note, t_lines, t_tags)
  note["relative_path"] = client:vault_relative_path(note.path.filename)
  note["links"] = {}
  note["body_tags"] = {}

  handle_body(note, t_lines, t_tags)

  for _, tag in ipairs(note.tags) do
    handle_tag(tag, note, t_tags)
  end
end

local refresh_notes = function()
  if vim.g.notes_refreshing then
    return
  end
  vim.g.notes_refreshing = true

  local t_all_notes = {}
  local t_note_notes = {}
  local t_author_notes = {}
  local t_source_notes = {}
  local t_lines = {}
  local t_tags = {}

  client:find_notes_async("",
    function(x)
      for _, value in ipairs(x) do
        if value.metadata ~= nil and value.metadata.type ~= nil and (value.metadata.type == "source" or value.metadata.type == "note" or value.metadata.type == "author") then
          handle_note(value, t_lines, t_tags)
          value.icon = ""
          value.author_string = ""
          if value.metadata.type == "author" then
            table.insert(t_author_notes, value)
            value.icon = ""
          elseif value.metadata.type == "note" then
            table.insert(t_note_notes, value)
            value.icon = ""
          end

          table.insert(t_all_notes, value)
        end
      end
      for _, value in ipairs(t_all_notes) do
        if value.metadata ~= nil and value.metadata.type ~= nil and value.metadata.type == "source" then
          value.icon = ""
          for _, v in ipairs(t_author_notes) do
            if v.id == value.metadata.author[1] then
              value.author_string = v.title
            end
          end
          table.insert(t_source_notes, value)
        end
      end
      all_notes = t_all_notes
      note_notes = t_note_notes
      author_notes = t_author_notes
      source_notes = t_source_notes
      lines = t_lines
      tags = t_tags
      vim.g.notes_refreshing = false
    end,
    { search = { sort = true, sort_by = "modified", sort_reversed = true, fixed_strings = true, }, notes = { load_contents = true } })
end

return {
  get_notes = get_notes,
  get_all_notes = get_all_notes,
  get_note_notes = get_note_notes,
  get_author_notes = get_author_notes,
  get_source_notes = get_source_notes,
  get_tags = get_tags,
  get_lines = get_lines,
  refresh_notes = refresh_notes,

}
