local search = require("obsidian.search")
local ui = require("obsidian.ui")
local iter = require("obsidian.itertools").iter
local util = require "obsidian.util"
local Note = require "obsidian.note"

local function print_test()
  local client = require("obsidian").get_client()
  local current_note = client:current_note()
  -- print(vim.inspect(current_note))
  print(vim.inspect(current_note:resolve_block('block')))
end

local function note_id_gen(name)
  return name:gsub("n_[()'\"*]", "")
      :gsub(" %l* ", " ")
      :gsub(" ", "-"):lower()
end

local function source_id_gen(name)
  return name:gsub("[()'\"*:?,]", "")
      :gsub(" %l* ", " ")
      :gsub(" . ", " ")
      :gsub("The ", ""):lower()
      :gsub(" the ", " ")
      :gsub("'s ", " ")
      :gsub(" ", "-")
end

-- local function source_id_gen(name)
--     return name:gsub("~[()'\"*]", "")
--         :gsub(" %l* ", " ")
--         :gsub(" ", "_")
-- end

local function filter(arr, func)
  local new_arr = {}
  for old_index, v in ipairs(arr) do
    if func(v, old_index) then
      new_arr[#new_arr + 1] = v
    end
  end
  return new_arr
end

local function change_name(note, i)
  local client = require("obsidian").get_client()

  local author = ""
  local sourceparents = {}
  if note.metadata.type == "source" then
    if note.metadata["source-parents"] ~= nil and not vim.tbl_isempty(note.metadata["source-parents"]) then
      for _, parent in ipairs(note.metadata["source-parents"]) do
        sourceparents[#sourceparents + 1] = parent
      end
    end
    author = note.metadata.author
  else
    print("Invalid current note type")
  end

  local longName = note.title

  local old_id = note.id


  local id = ""
  if i == 0 then
    for _, value in ipairs(author) do
      id = "s_" .. value:gsub("a_", "") .. "_" .. source_id_gen(longName)
    end
  else
    table.sort(sourceparents, function (a, b)
      return string.len(a) > string.len(b)
    end)
    id = sourceparents[1] .. "_" .. source_id_gen(longName)
  end

  note.id = id

  id = id:gsub("%%", "")

  client:open_note(note, {
    callback = function(bufnr)
      client:write_note_to_buffer(note, { bufnr = bufnr })
      vim.cmd.ObsidianRename(id)
      os.execute("find " ..
      client.dir.filename .. " -type f -name '*.md' -exec sed -i '' 's/" .. old_id .. "/" .. id .. "/g'  {} +")
    end,
    sync = true
  })
end

local function change_author(author_note)
  local client = require("obsidian").get_client()

  -- local author_note = client:find_notes(author)[1]
  local id_prefix = "a_"
  local old_id = author_note.id
  author_note.id = id_prefix .. old_id:gsub("%%", ""):lower()


  client:open_note(author_note, {
    callback = function(bufnr)
      client:write_note_to_buffer(author_note, { bufnr = bufnr })
      vim.cmd.ObsidianRename(author_note.id)
      vim.cmd.bdelete()
      os.execute("find " ..
      client.dir.filename ..
      " -type f -name '*.md' -exec sed -i '' 's/" .. old_id .. "/" .. author_note.id .. "/g'  {} +")
    end,
    sync = true
  })



  local notes = client:find_notes("")
  local source_notes = filter(notes, function(val, _)
    if val.metadata ~= nil then
      if val.metadata.author ~= nil and val.metadata.type ~= nil then
        return val.metadata.type == "source" and val.metadata.author[1] == author_note.id
      end
    else
      return false
    end
  end)

  for i = 0, 4, 1 do
    for index, note in ipairs(source_notes) do
      if #note.metadata["source-parents"] == i then
        local new_note = client:resolve_note(note.id)
        change_name(new_note, i)
      end
    end
  end
end

local function change_all()
  local client = require("obsidian").get_client()
  local notes = client:find_notes("")

  local author_notes = filter(notes, function(val, _)
    if val.metadata ~= nil then
      if val.metadata.type ~= nil then
        return val.metadata.type == "author"
      end
    else
      return false
    end
  end)

  for index, value in ipairs(author_notes) do
    change_author(value)
  end
end




local function new_source()
  local client = require("obsidian").get_client()
  local current_note = client:current_note()
  local dir = ""
  local author = ""
  local sourceparents = {}
  if current_note.metadata.type == "source" then
    dir = client.dir.filename .. "/sources/" .. current_note.metadata.author[1] .. "/"

    if current_note.metadata["source-parents"] ~= nil and not vim.tbl_isempty(current_note.metadata["source-parents"]) then
      for _, parent in ipairs(current_note.metadata["source-parents"]) do
        sourceparents[#sourceparents + 1] = parent
        local parent_note = client:resolve_note(parent)
        dir = dir .. source_id_gen(parent_note.id) .. "/"
      end
    end
    dir = dir .. source_id_gen(current_note.id) .. "/"

    sourceparents[#sourceparents + 1] = current_note.id

    author = current_note.metadata.author
  elseif current_note.metadata.type == "author" then
    dir = client.dir.filename .. "/sources/" .. current_note.id:gsub("%%", "") .. "/"
    author = current_note.id
  else
    print("Invalid current note type")
  end

  local longName = util.input "Enter source name: "
  if not longName then
    print("Aborted")
    return
  elseif longName == "" then
    print("Aborted")
    longName = nil
    return
  end

  local id = ""
  if #sourceparents == 0 then
    id = "s_" .. author:gsub("a_", "") .. "_" .. source_id_gen(longName)
  else
    table.sort(sourceparents, function (a, b)
      return string.len(a) > string.len(b)
    end)
    id = sourceparents[1] .. "_" .. source_id_gen(longName)
  end

  local new_note_dir = dir .. id .. ".md"
  local sourceNote = Note.new(id, { longName }, current_note.tags, new_note_dir)

  local note = client:write_note(sourceNote, { template = "source" })

  local viz
  if vim.endswith(vim.fn.mode():lower(), "v") then
    viz = util.get_visual_selection()
  end

  local link = client:format_link(note)
  local content = {}

  if viz then
    content = vim.split(viz.selection, "\n", { plain = true })
    vim.api.nvim_buf_set_text(0, viz.csrow - 1, viz.cscol - 1, viz.cerow - 1, viz.cecol, { link })
  else
    local cur_row, _ = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_lines(0, cur_row, cur_row, false, { link })
  end
  client:update_ui(0)

  note.metadata = {
    type = "source",
    ["source-parents"] = sourceparents,
    author = author
  }

  client:open_note(note, {
    callback = function(bufnr)
      client:write_note_to_buffer(note, { bufnr = bufnr })
    end,
    sync = true
  })

  vim.api.nvim_buf_set_lines(0, -1, -1, false, content)
end

local function append_to_note()
  local viz
  if vim.endswith(vim.fn.mode():lower(), "v") then
    viz = util.get_visual_selection()
  end
  if not viz then
    return
  end

  local client = require("obsidian").get_client()
  local current_note = client:current_note()
  local content = vim.split(viz.selection, "\n", { plain = true })

  -- Open picker
  client:resolve_note_async_with_picker_fallback("", function(dest_note)
    local link = client:format_link(dest_note)

    if current_note.metadata.type ~= "source" then
      return
    end

    vim.api.nvim_buf_set_text(0, viz.cerow - 1, viz.cecol, viz.cerow - 1, viz.cecol, { " — " .. link })
    vim.api.nvim_buf_set_text(0, viz.csrow - 1, -1, viz.csrow - 1, -1, { " ^" .. dest_note.id })

    local block_line = vim.api.nvim_buf_get_lines(0, viz.csrow - 1, viz.csrow, true)
    local block = { id = dest_note.id, line = viz.cerow - 1, block = block_line[1] }
    dest_note.metadata.references[#dest_note.metadata.references + 1] = current_note.id

    client:update_ui(0)

    client:open_note(dest_note, {
      callback = function(bufnr)
        client:write_note_to_buffer(dest_note, { bufnr = bufnr })
      end,
      sync = true
    })
    if vim.api.nvim_buf_get_lines(0, -2, -1, false)[1] ~= "" then
      vim.api.nvim_buf_set_lines(0, -1, -1, false, { "" })
    end

    vim.api.nvim_buf_set_lines(0, -1, -1, false, content)
  end)
end


local function new_note()
  local client = require("obsidian").get_client()
  local current_note = client:current_note()

  local longName = util.input "Enter note name: "

  if not longName then
    print("Aborted")
    return
  elseif longName == "" then
    print("Aborted")
    longName = nil
    return
  end

  -- local id = longName:lower():gsub(" ", "-"):gsub("[()]", "")
  local id = note_id_gen(longName)

  local dir = client.dir.filename .. "/notes/" .. id .. ".md"


  local newNote = Note.new(id, { longName }, {}, dir)
  local note = client:write_note(newNote, { template = "note" })


  local viz
  if vim.endswith(vim.fn.mode():lower(), "v") then
    viz = util.get_visual_selection()
  end

  local link = client:format_link(note)
  local content = {}

  note.metadata = { type = "note" }

  if viz then
    local linktonew = client:format_link(note)
    -- local linkback = client:format_link(current_note)

    content = vim.split(viz.selection, "\n", { plain = true })

    if current_note.metadata.type == "source" then
      vim.api.nvim_buf_set_text(0, viz.cerow - 1, viz.cecol, viz.cerow - 1, viz.cecol, { " — " .. link })
      vim.api.nvim_buf_set_text(0, viz.csrow - 1, -1, viz.csrow - 1, -1, { " ^" .. id })

      local block_line = vim.api.nvim_buf_get_lines(0, viz.csrow - 1, viz.csrow, true)
      local block = { id = id, line = viz.cerow - 1, block = block_line[1] }
      note.metadata.references = current_note.id
    elseif current_note.metadata.type == "note" then
      vim.api.nvim_buf_set_text(0, viz.csrow - 1, viz.cscol - 1, viz.cerow - 1, viz.cecol, { link })
      local linkback = client:format_link(current_note)
      table.insert(content, 1, linkback)
      table.insert(content, 2, "")
    end
  end
  client:update_ui(0)

  client:open_note(note, {
    callback = function(bufnr)
      client:write_note_to_buffer(note, { bufnr = bufnr })
    end,
    sync = true
  })

  vim.api.nvim_buf_set_lines(0, -1, -1, false, content)
end

local function new_author()
  local client = require("obsidian").get_client()
  local shortName = util.input "Enter author short name: "
  if not shortName then
    print("Aborted")
    return
  elseif shortName == "" then
    print("Aborted")
    shortName = nil
  end

  local id = "a_" .. shortName
  local dir = client.dir.filename .. "/sources/" .. shortName .. "/" .. id .. ".md"

  local longName = util.input "Enter author long name: "
  if not longName then
    print("Aborted")
    return
  elseif longName == "" then
    longName = nil
  end

  local authorNote = Note.new(id, { longName }, {}, dir)

  local note = client:write_note(authorNote, { template = "author" })

  local cur_row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local new_line = client:format_link(note)
  vim.api.nvim_buf_set_lines(0, cur_row, cur_row, false, { new_line })

  note.metadata = { type = "author" }

  client:open_note(note, {
    callback = function(bufnr)
      client:write_note_to_buffer(note, { bufnr = bufnr })
    end,
  })
end

local function find_frontmatter_links(line)
  local links = {}
  local pattern = "[as]_[A-Za-z]+[A-Za-z0-9_/-]*[A-Za-z0-9]+"

  local search_start = 1
  while search_start < #line do
    local m_start, m_end = string.find(line, pattern, search_start)
    if m_start ~= nil and m_end ~= nil then
      links[#links + 1] = { m_start, m_end }
      search_start = m_end
    else
      return links
    end
  end
  return links
end

local function find_frontmatter_tags(line)
  local tags = {}
  local pattern2 = "tags:.*"
  local pattern3 = "[A-Za-z]+[A-Za-z0-9_/-]*[A-Za-z0-9]+"

  local m_start, m_end = string.find(line, pattern2, 1)
  if m_start ~= nil and m_end ~= nil then
    local search_start = 4
    while search_start < #line do
      m_start, m_end = string.find(line, pattern3, search_start)
      if m_start ~= nil and m_end ~= nil then
        tags[#tags + 1] = { m_start, m_end }
        search_start = m_end
      else
        return tags
      end
    end
  end
  return tags
end

local function frontmatter_hightlighting(note)
  local client = require("obsidian").get_client()
  local ns_id = vim.api.nvim_create_namespace("ObsidianBrad")
  local lines = vim.api.nvim_buf_get_lines(note.bufnr, 0, note.frontmatter_end_line, true)
  for i, line in ipairs(lines) do
    local lnum = i - 1
    local links = find_frontmatter_links(line)
    for link in iter(links) do
      local m_start, m_end = unpack(link)
      ui.ExtMark.new(
        nil,
        lnum,
        m_start - 1,
        ui.ExtMarkOpts.from_tbl {
          end_row = lnum,
          end_col = m_end,
          hl_group = client.opts.ui.reference_text.hl_group,
          spell = false,
        }
      ):materialize(note.bufnr, ns_id)
    end
    local tags = find_frontmatter_tags(line)
    for tag in iter(tags) do
      local m_start, m_end = unpack(tag)
      ui.ExtMark.new(
        nil,
        lnum,
        m_start - 1,
        ui.ExtMarkOpts.from_tbl {
          end_row = lnum,
          end_col = m_end,
          hl_group = client.opts.ui.tags.hl_group,
          spell = false,
        }
      ):materialize(note.bufnr, ns_id)
    end
  end
end

local function cursor_on_link()
  local client = require("obsidian").get_client()
  local current_line = vim.api.nvim_get_current_line()
  local cur_row, cur_col = unpack(vim.api.nvim_win_get_cursor(0))
  cur_col = cur_col + 1

  local in_frontmatter = false
  local note = client.current_note(client)
  if note.frontmatter_end_line ~= nil then
    if cur_row < note.frontmatter_end_line then
      in_frontmatter = true
    end
  end

  if in_frontmatter then
    local links = find_frontmatter_links(current_line)
    for link in iter(links) do
      local m_start, m_end = unpack(link)
      if m_start <= cur_col and cur_col <= m_end then
        return current_line:sub(m_start, m_end)
      end
    end
  end

  return nil
end

local function cursor_on_tag()
  local client = require("obsidian").get_client()
  local current_line = vim.api.nvim_get_current_line()
  local cur_row, cur_col = unpack(vim.api.nvim_win_get_cursor(0))
  cur_col = cur_col + 1

  local in_frontmatter = false
  local note = client.current_note(client)
  if note.frontmatter_end_line ~= nil then
    if cur_row < note.frontmatter_end_line then
      in_frontmatter = true
    end
  end

  if in_frontmatter then
    local tags = find_frontmatter_tags(current_line)
    for tag in iter(tags) do
      local m_start, m_end = unpack(tag)
      if m_start <= cur_col and cur_col <= m_end then
        return "#" .. current_line:sub(m_start, m_end)
      end
    end
  end

  for match in
  iter(search.find_matches(current_line, { search.RefTypes.Tag }))
  do
    local open, close, _ = unpack(match)
    if open <= cur_col and cur_col <= close then
      return current_line:sub(open, close)
    end
  end

  return nil
end

local function enter_command()
  local tag = cursor_on_tag()
  local link = cursor_on_link()

  if tag then
    return "<cmd>ObsidianTags " .. tag:sub(2, -1) .. "<CR>"
  elseif link then
    return "<cmd>ObsidianQuickSwitch " .. link .. "<CR>"
  else
    return "<cmd>ObsidianFollowLink<CR>"
  end
end

return {
  enter_command = enter_command,
  frontmatter_hightlighting = frontmatter_hightlighting,
  new_author = new_author,
  new_source = new_source,
  new_note = new_note,
  print_test = print_test,
  append_to_note = append_to_note,
  change_name = change_name,
  change_author = change_author,
  change_all = change_all,
}
