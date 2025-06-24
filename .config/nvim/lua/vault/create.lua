local util = require "obsidian.util"
local Note = require "obsidian.note"

local function note_id_gen(name)
  return name:gsub("[()'\"*,:]", "")
      :gsub(" %l* ", " ")
      :gsub("A ", "")
      :gsub("An ", "")
      :gsub("I ", "")
      :gsub("The ", ""):lower()
      :gsub("'s ", " ")
      :gsub(" ", "-")
end

local function source_id_gen(name)
  return name:gsub("[()'\"*:?,]", "")
      :gsub(" %l* ", " ")
      :gsub("A ", "")
      :gsub("An ", "")
      :gsub("I ", "")
      :gsub(" . ", " ")
      :gsub("The ", ""):lower()
      :gsub("'s ", " ")
      :gsub(" ", "-")
end

local function new_source()
  local client = require("obsidian").get_client()
  local current_note = client:current_note()
  local dir = ""
  local author = ""
  local sourceparents = {}

  dir = client.dir.filename .. "/sources/"

  if current_note.metadata.type == "source" then
    sourceparents[#sourceparents + 1] = current_note.id
    author = current_note.metadata.author
  elseif current_note.metadata.type == "author" then
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
    table.sort(sourceparents, function(a, b)
      return string.len(a) > string.len(b)
    end)
    id = sourceparents[1] .. "_" .. source_id_gen(longName)
  end

  vim.ui.input({ prompt = "Enter source id: ", default = id }, function(input)
    input = string.lower(input)

    local new_note_dir = dir .. input .. ".md"

    local sourceNote = Note.new(input, { longName }, current_note.tags, new_note_dir)

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
      vim.api.nvim_buf_set_lines(0, cur_row - 1, cur_row - 1, false, { link })
    end

    client:update_ui(0)
    vim.cmd.write()

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
  end)
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
    vim.cmd.write()

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

  vim.ui.input({ prompt = "Enter note name: " }, function(input)
    if input == nil or input == "" then
      print("Aborted")
      return
    end

    local id = note_id_gen(input)

    local dir = client.dir.filename .. "/notes/" .. id .. ".md"

    local newNote = Note.new(id, { input }, {}, dir)
    local note = client:write_note(newNote, { template = "note" })

    local viz
    if vim.endswith(vim.fn.mode():lower(), "v") then
      viz = util.get_visual_selection()
    end

    local link = client:format_link(note)
    local content = {}

    note.metadata = { type = "note" }

    if viz then
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
    vim.cmd.write()

    client:open_note(note, {
      callback = function(bufnr)
        client:write_note_to_buffer(note, { bufnr = bufnr })
      end,
      sync = true
    })

    vim.api.nvim_buf_set_lines(0, -1, -1, false, content)
  end)
end

local function new_author()
  local client = require("obsidian").get_client()

  local longName = util.input "Enter author long name: "
  if not longName then
    print("Aborted")
    return
  elseif longName == "" then
    return
  end

  local temp = {}
  for s in longName:gmatch("%S+") do
    table.insert(temp, s)
  end

  local shortNameP = "a_" .. string.lower(temp[#temp])

  vim.ui.input({ prompt = "Enter author id: ", default = shortNameP }, function(input)
    input = input:lower()
    local id = input
    local dir = client.dir.filename .. "/authors/" .. id .. ".md"

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
  end)
end

return {
  new_author = new_author,
  new_source = new_source,
  new_note = new_note,
  append_to_note = append_to_note,
}
