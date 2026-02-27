local Path = require("obsidian.path")
local search = require("obsidian.search")

local notes = {}
local all_notes = {}
local note_notes = {}
local author_notes = {}
local source_notes = {}
local lines = {}
local tags = {}
local cmp = {}
local qmd_id_lookup = {}

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

local get_cmp = function()
  if cmp == {} then
    return {}
  else
    return cmp
  end
end

local handle_tag = function(tag, note, t_tags, line)
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
  local r_links = {}
  local references = {}
  for num, line in ipairs(note.contents) do
    local endline = note.frontmatter_end_line or 0
    if (num > (endline)) then
      if #line > 1 then
        table.insert(t_lines,
          {
            note = { id = note.id, path = note.path.filename, title = note.title, icon = note.icon },
            text = line,
            num =
                num
          })
      end

      for link in line:gmatch("%[%[[%w-_.',]*[|%]]") do
        table.insert(note.links, { link:sub(3, -2), num })
      end
      for tag in line:gmatch("#[%w-]+") do
        tag = tag:sub(2, -1)
        table.insert(note.body_tags, { tag, num })
        handle_tag(tag, note, t_tags, num)
      end

      local id, reference = line:match("^%[([0-9]+)%]: (.+)")
      if id ~= nil then
        references[id] = reference
      else
        for _, r in line:gmatch("%[([^%]]+)%]%[(%d+)%]") do
          table.insert(r_links, { r, num })
        end
      end
    end
  end
  for _, value in ipairs(r_links) do
    table.insert(note.links, { references[value[1]], value[2] })
  end
end

local handle_note = function(note, t_lines, t_tags, t_cmp)
  note["relative_path"] = Path.vault_relative_path(note.path)
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
  local t_cmp = {}

  search.find_notes_async("",
    function(x)
      for _, value in ipairs(x) do
        if value.metadata ~= nil and value.metadata.type ~= nil and (value.metadata.type == "source" or value.metadata.type == "note" or value.metadata.type == "author") then
          handle_note(value, t_lines, t_tags, t_cmp)
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
      cmp = t_cmp

      vim.system({ "qmd", "search", "--files", "--all", "md" }, { text = true }, function(o)
        local stdout = string.gsub(o.stdout, "qmd://[^\n]*/", ""):gsub(".md", ""):gsub("-", "")
        local qmd_lines = vim.split(stdout, "\n")
        local lookup = {}

        for _, line in pairs(qmd_lines) do
          if line ~= "" then
            local sep = vim.split(line, ",0.00,")
            lookup[sep[2]] = sep[1]
          end
        end

        all_notes = vim.tbl_map(function(note)
          local id_changed = note.id:gsub("[-_]", "")
          note.docid = lookup[id_changed]
          return note
        end, t_all_notes)

        local with_lengths = vim.iter(all_notes):map(function(notei)
              return {
                note = notei.id,
                length = string.len(table.concat(notei.contents, "\n"):gsub("  ", " "))
              }
            end)
            :totable()

        table.sort(with_lengths, function(a, b) return a.length > b.length end)

        dd(with_lengths)

        vim.g.notes_refreshing = false
      end)
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
  get_cmp = get_cmp,
  refresh_notes = refresh_notes,
}
