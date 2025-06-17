local client = require("obsidian").get_client()

local notes = nil
local tags = {}

local get_notes = function()
  if notes == nil then
    notes = client:find_notes("")
    for _, value in ipairs(notes) do
      value["relative_path"] = client:vault_relative_path(value.path.filename)
    end
    return notes
  else
    return notes
  end
end

local get_tags = function()
  if tags == {} then
    return {}
  else
    return tags
  end
end


local handle_tag = function(tag, note, line)
  if line == nil then
    line = 1
  end
    if tags[tag] == nil then
      tags[tag] = {}
    end
    if tags[tag][note.id] == nil then
      tags[tag][note.id] = { note = note, line = line }
    end
end

local handle_body = function(note)
  for num, line in ipairs(note.contents) do
    for link in line:gmatch("%[%[[%w-_.',]*[|%]]") do
      table.insert(note.links, { link:sub(3, -2), num })
    end
    for tag in line:gmatch("#[%w-]+") do
      tag = tag:sub(2, -1)
      table.insert(note.body_tags, { tag, num })
      handle_tag(tag, note, num)
    end
  end
end

local handle_note = function(note)

  note["relative_path"] = client:vault_relative_path(note.path.filename)
  note["links"] = {}
  note["body_tags"] = {}

  handle_body(note)

  for _, tag in ipairs(note.tags) do
    handle_tag(tag, note)
  end

end

local refresh_notes = function()
  client:find_notes_async("", function(x)
      for _, value in ipairs(x) do
        if value.metadata ~= nil and value.metadata.type ~= nil and (value.metadata.type == "source" or value.metadata.type == "note" or value.metadata.type == "author") then
          handle_note(value)
        end
      end
      notes = x
    end,
    { search = { sort = true, sort_by = "modified", sort_reversed = true, fixed_strings = true, }, notes = { load_contents = true } })
end

return {
  get_notes = get_notes,
  get_tags = get_tags,
  refresh_notes = refresh_notes
}
