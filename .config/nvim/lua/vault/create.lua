local util = require "obsidian.util"
local ui = require "obsidian.ui"
local api = require "obsidian.api"
local globs = require "globals"
local Note = require "obsidian.note"
local glob_dir = globs.getglobs().notesdir
local snacks_picker = require "snacks.picker"

local function note_id_gen(name)
  return name:gsub("[()'\"*,:]", "")
      :gsub(" %l+", " ")
      :gsub("A ", "")
      :gsub("An ", "")
      :gsub("I ", "")
      :gsub("The ", ""):lower()
      :gsub("'s ", " ")
      :gsub("[ ]+", "-")
end

local function source_id_gen(name)
  return name:gsub("[()'\"*:?,]", "")
      :gsub(" %l+", " ")
      :gsub("A ", "")
      :gsub("Lecture ", "")
      :gsub("An ", "")
      :gsub("I ", "")
      :gsub(" . ", " ")
      :gsub("The ", ""):lower()
      :gsub("'s ", " ")
      :gsub("[ ]+", "-")
end

local function new_source()
  local current_note = util.current_note()
  local dir = ""
  local author = ""
  local sourceparents = {}
  local id = ""

  dir = glob_dir .. "/sources/"

  if current_note.metadata.type == "source" then
    sourceparents[#sourceparents + 1] = current_note.id
    author = current_note.metadata.author
    id = current_note.id .. "_"
  elseif current_note.metadata.type == "author" then
    author = current_note.id
    id = "s_" .. author:gsub("a_", "") .. "_"
  else
    print("Invalid current note type")
  end

  vim.ui.input({ prompt = "Enter source name: " }, function(longName)
    if not longName or longName == "" then
      print("Aborted")
      return
    end

    id = id .. source_id_gen(longName)

    vim.ui.input({ prompt = "Enter source id: ", default = id }, function(input)
      input = string.lower(input)

      local new_note_dir = dir .. input .. ".md"

      local note = Note.new(input, { longName }, current_note.tags, new_note_dir)

      local viz
      if vim.endswith(vim.fn.mode():lower(), "v") then
        viz = util.get_visual_selection()
      end

      local link = "[[" .. input .. "|" .. longName .. "]]"
      local content = {}

      if viz then
        content = vim.split(viz.selection, "\n", { plain = true })
        vim.api.nvim_buf_set_text(0, viz.csrow - 1, viz.cscol - 1, viz.cerow - 1, viz.cecol, { link })
      else
        local cur_row, _ = unpack(vim.api.nvim_win_get_cursor(0))
        vim.api.nvim_buf_set_lines(0, cur_row - 1, cur_row - 1, false, { link })
      end

      ui.update(0)
      vim.cmd.write()

      note.metadata = {
        type = "source",
        ["source-parents"] = sourceparents,
        author = author
      }

      note.title = longName

      table.insert(content, 1, "# " .. longName)

      note:write():open({ sync = true })

      vim.api.nvim_buf_set_lines(0, -2, -1, false, content)
      vim.cmd.write()
      -- ui.update(0)
    end)
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

  local current_note = util.current_note()
  local content = vim.split(viz.selection, "\n", { plain = true })

  if not vim.wait(5000, function()
        return not vim.g.notes_refreshing
      end) then
    return
  end

  local all_notes = require("vault.data").get_all_notes()

  local entries = {}
  for _, entry in ipairs(all_notes) do
    table.insert(entries, {
      text = entry.title .. " " .. entry.author_string .. " " .. entry.id,
      ordinal = entry.title .. " " .. entry.author_string .. " " .. entry.id,
      title = entry.title,
      author = entry.author_string,
      tags = entry.tags,
      icon = entry.icon,
      value = entry,
      file = entry.relative_path,
      id = entry.id,
      link = "[[" .. entry.id .. "|" .. entry.title .. "]]"
    })
  end

  local set_width = function(text, width)
    if (vim.fn.strdisplaywidth(text) > width) then
      return string.sub(text, 1, width - 1) .. "…"
    elseif vim.fn.strdisplaywidth(text) < width then
      return text .. string.rep(" ", width - vim.fn.strdisplaywidth(text))
    else
      return text
    end
  end


  local pick_opts = {
    title = "All Notes",
    items = entries,
    layout = {
      layout = {
        backdrop = false,
        width = 0.90,
        min_width = 80,
        height = 0.95,
        border = "none",
        box = "vertical",
        { win = "preview", title = "{preview}", height = 0.5, border = "rounded" },
        {
          box = "vertical",
          border = "rounded",
          title = "{title} {live} {flags}",
          title_pos = "center",
          { win = "input", height = 1,     border = "bottom" },
          { win = "list",  border = "none" },
        },
      }
    },
    format = function(item, picker)
      local ret = {}
      ret[#ret + 1] = { item.icon .. "  ", "Fg" }
      ret[#ret + 1] = { set_width(item.title, 40) .. " ", "markdownBoldItalic" }
      ret[#ret + 1] = { set_width(item.author, 20) .. " ", "markdownItalic" }
      ret[#ret + 1] = { set_width(table.concat(item.tags, " "), 20) .. " ", "ObsidianTag" }
      ret[#ret + 1] = { item.id, "Grey" }
      return ret
    end,
    confirm = function(picker, item)
      picker:close()
      local dest_note = item.value

      local link = "[[" .. dest_note.id .. "|" .. dest_note.title .. "]]"

      if current_note.metadata.type ~= "source" then
        return
      end

      vim.api.nvim_buf_set_text(0, viz.cerow - 1, viz.cecol, viz.cerow - 1, viz.cecol, { " — " .. link })

      dest_note.metadata.references[#dest_note.metadata.references + 1] = current_note.id

      ui.update(0)
      vim.cmd.write()

      dest_note:open({ sync = true })
      dest_note:write_to_buffer()

      if vim.api.nvim_buf_get_lines(0, -2, -1, false)[1] ~= "" then
        vim.api.nvim_buf_set_lines(0, -1, -1, false, { "" })
      end

      vim.api.nvim_buf_set_lines(0, -1, -1, false, content)
      vim.cmd.write()
      ui.update(0)
    end
  }

  snacks_picker.pick(pick_opts)
end


local function new_note()
  local current_note = util.current_note()

  vim.ui.input({ prompt = "Enter note name: " }, function(input)
    if input == nil or input == "" then
      print("Aborted")
      return
    end

    local id = note_id_gen(input)

    local dir = glob_dir .. "/notes/" .. id .. ".md"

    local note = Note.new(id, { input }, {}, dir)


    local viz
    if vim.endswith(vim.fn.mode():lower(), "v") then
      viz = util.get_visual_selection()
    end

    local link = "[[" .. note.id .. "|" .. input .. "]]"
    local content = {}

    note.metadata = { type = "note" }
    note.title = input

    if viz then
      content = vim.split(viz.selection, "\n", { plain = true })

      if current_note.metadata.type == "source" then
        vim.api.nvim_buf_set_text(0, viz.cerow - 1, viz.cecol, viz.cerow - 1, viz.cecol, { " — " .. link })

        local block_line = vim.api.nvim_buf_get_lines(0, viz.csrow - 1, viz.csrow, true)
        local block = { id = id, line = viz.cerow - 1, block = block_line[1] }
        note.metadata.references = current_note.id
      elseif current_note.metadata.type == "note" then
        vim.api.nvim_buf_set_text(0, viz.csrow - 1, viz.cscol - 1, viz.cerow - 1, viz.cecol, { link })
        local linkback = "[[" .. current_note.id .. "|" .. current_note.title .. "]]"
        table.insert(content, 1, linkback)
        table.insert(content, 2, "")
      end
    end

    ui.update(0)
    vim.cmd.write()

    note:write()

    table.insert(content, 1, "# " .. input)

    note:open({ sync = true })

    vim.api.nvim_buf_set_lines(0, -2, -1, false, content)
    vim.cmd.write()
    -- ui.update(0)
  end)
end

local function new_author()
  vim.ui.input({ prompt = "Enter author name: " }, function(longName)
    if not longName or longName == "" then
      print("Aborted")
      return
    end

    local temp = vim.split(longName, " ")
    local shortNameP = "a_" .. string.lower(temp[#temp])

    vim.ui.input({ prompt = "Enter author id: ", default = shortNameP }, function(input)
      input = input:lower()
      local id = input
      local dir = glob_dir .. "/authors/" .. id .. ".md"

      local note = Note.new(id, { longName }, {}, dir)

      local cur_row, _ = unpack(vim.api.nvim_win_get_cursor(0))
      local new_line = "[[" .. note.id .. "|" .. longName .. "]]"
      vim.api.nvim_buf_set_lines(0, cur_row, cur_row, false, { new_line })
      vim.cmd.write()

      note.metadata = { type = "author" }
      note.title = longName
      note:write()
      note:open({ sync = true })

      vim.api.nvim_buf_set_lines(0, -2, -1, false, { "# " .. longName })
      vim.cmd.write()
    end)
  end)
end

local function prompt_query()
  local data = require("vault.data").get_all_notes()

  vim.ui.input({ prompt = "Enter query" }, function(query_string)
    local output = {}

    local result = {}
    vim.system({ "qmd", "vsearch", "--json", query_string }, { text = true }, function(o)
      output = vim.json.decode(o.stdout)
      for _, value in ipairs(output) do
        for _, doc in ipairs(data) do
          if doc.docid == value.docid then
            table.insert(result, vim.tbl_extend("force", doc, { search_line = tonumber(string.match(value.snippet, "@@ %-([0-9]*)")), search_score = value.score }))
            break
          end
        end
      end
    end):wait()
    require("vault.all_search").pick_from_all(result)
  end)
end


return {
  new_author = new_author,
  new_source = new_source,
  new_note = new_note,
  append_to_note = append_to_note,
  prompt_query = prompt_query,
}
