local util = require "obsidian.util"
local log = require "obsidian.log"
local RefTypes = require("obsidian.search").RefTypes
local entry_display = require "telescope.pickers.entry_display"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values

local function filter(arr, func)
  local new_arr = {}
  for old_index, v in ipairs(arr) do
    if func(v, old_index) then
      new_arr[#new_arr + 1] = v
    end
  end
  return new_arr
end

local function find_references(client, note)
  local notes = require("vault.search").get_notes()
  local res = {}

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 10 },
      { width = 7 },
      { width = 40 },
      { width = 20 },
      { remaining = true },
    },
  }
  local author_notes = filter(notes, function(val, _)
    if val.metadata ~= nil then
      if val.metadata.type ~= nil then
        return val.metadata.type == "author"
      end
    else
      return false
    end
  end)

  local get_author = function(arg_id)
    for _, v in ipairs(author_notes) do
      if v.id == arg_id then
        return v.title
      end
    end
    return arg_id
  end

  for _, resnote in pairs(notes) do
    if resnote.metadata ~= nil and not vim.tbl_isempty(resnote.metadata) then
      if resnote.metadata.references ~= nil and not vim.tbl_isempty(resnote.metadata.references) then
        if vim.tbl_contains(resnote.metadata.references, note.id) then
          if resnote.metadata.type == "author" then
            res[#res + 1] = {
              value = { path = resnote.path, line = 1 },
              display = function()
                return displayer {
                  { "Reference",   "Grey" },
                  { "Author",      "markdownBold" },
                  { resnote.title, "markdownBoldItalic" },
                  { "",            "Grey" },
                  { resnote.id,    "Grey" },
                }
              end,
              ordinal = resnote.title .. " " .. resnote.id,
              title = resnote.title,
              path = resnote.path.filename,
              filename = tostring(resnote.path),
              lnum = 1,
            }
          elseif resnote.metadata.type == "source" then
            res[#res + 1] = {
              value = { path = resnote.path, line = 1 },
              display = function()
                return displayer {
                  { "Reference",                            "Grey" },
                  { "Source",                               "markdownBold" },
                  { resnote.title,                          "markdownBoldItalic" },
                  { get_author(resnote.metadata.author[1]), "markdownItalic" },
                  { resnote.id,                             "Grey" },
                }
              end,
              ordinal = resnote.title .. " " .. resnote.id,
              title = resnote.title,
              path = resnote.path.filename,
              filename = tostring(resnote.path),
              lnum = 1,
            }
          elseif resnote.metadata.type == "note" then
            res[#res + 1] = {
              value = { path = resnote.path, line = 1 },
              display = function()
                return displayer {
                  { "Reference",   "Grey" },
                  { "Note",        "markdownBold" },
                  { resnote.title, "markdownBoldItalic" },
                  { "",            "Grey" },
                  { resnote.id,    "Grey" },
                }
              end,
              ordinal = resnote.title .. " " .. resnote.id,
              title = resnote.title,
              path = resnote.path.filename,
              filename = tostring(resnote.path),
              lnum = 1,
            }
          else
            res[#res + 1] = {
              value = { path = resnote.path, line = 1 },
              display = function()
                return displayer {
                  { "Reference",   "Grey" },
                  { "Type",        "markdownBold" },
                  { resnote.title, "markdownBoldItalic" },
                  { "",            "markdownItalic" },
                  { resnote.id,    "Grey" },
                }
              end,
              ordinal = resnote.title .. " " .. resnote.id,
              title = resnote.title,
              path = resnote.path.filename,
              filename = tostring(resnote.path),
              lnum = 1,
            }
          end
        end
      end
    end
    if resnote.links ~= nil and resnote.metadata ~= nil and resnote.metadata.type ~= nil and not vim.tbl_isempty(resnote.links) then
      for _, value in ipairs(resnote.links) do
        if value[1] == note.id then
          if resnote.metadata.type == "author" then
            res[#res + 1] = {
              value = { path = resnote.path, line = value[2] },
              display = function()
                return displayer {
                  { "Reference",   "Grey" },
                  { "Author",      "markdownBold" },
                  { resnote.title, "markdownBoldItalic" },
                  { "",            "Grey" },
                  { resnote.id,    "Grey" },
                }
              end,
              ordinal = resnote.title .. " " .. resnote.id,
              title = resnote.title,
              path = resnote.path.filename,
              filename = tostring(resnote.path),
              lnum = value[2],
            }
          elseif resnote.metadata.type == "source" then
            res[#res + 1] = {
              value = { path = resnote.path, line = value[2] },
              display = function()
                return displayer {
                  { "Link [" .. value[2] .. "]",            "Grey" },
                  { "Source",                               "markdownBold" },
                  { resnote.title,                          "markdownBoldItalic" },
                  { get_author(resnote.metadata.author[1]), "markdownItalic" },
                  { resnote.id,                             "Grey" },
                }
              end,
              ordinal = resnote.title .. " " .. resnote.id,
              title = resnote.title,
              path = resnote.path.filename,
              filename = tostring(resnote.path),
              lnum = value[2],
            }
          elseif resnote.metadata.type == "note" then
            res[#res + 1] = {
              value = { path = resnote.path, line = value[2] },
              display = function()
                return displayer {
                  { "Link [" .. value[2] .. "]", "Grey" },
                  { "Note",                      "markdownBold" },
                  { resnote.title,               "markdownBoldItalic" },
                  { "",                          "Grey" },
                  { resnote.id,                  "Grey" },
                }
              end,
              ordinal = resnote.title .. " " .. resnote.id,
              title = resnote.title,
              path = resnote.path.filename,
              filename = tostring(resnote.path),
              lnum = value[2],
            }
          else
            res[#res + 1] = {
              value = { path = resnote.path, line = value[2] },
              display = function()
                return displayer {
                  { "Link [" .. value[2] .. "]", "Grey" },
                  { "Type",                      "markdownBold" },
                  { resnote.title,               "markdownBoldItalic" },
                  { "",                          "markdownItalic" },
                  { resnote.id,                  "Grey" },
                }
              end,
              ordinal = resnote.title .. " " .. resnote.id,
              title = resnote.title,
              path = resnote.path.filename,
              filename = tostring(resnote.path),
              lnum = value[2],
            }
          end
        end
      end
    end
  end
  return res
end

local function collect_backlinks(client, picker, note, opts)
  opts = opts or {}

  local references = {}
  local noteissource = false
  if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
    if note.metadata.type ~= nil then
      noteissource = note.metadata.type == "source"
    end
  end

  references = find_references(client, note)

  if vim.tbl_isempty(references) then
    if opts.anchor then
      log.info("No backlinks found for anchor '%s' in note '%s'", opts.anchor, note.id)
    elseif opts.block then
      log.info("No backlinks found for block '%s' in note '%s'", opts.block, note.id)
    else
      log.info("No backlinks found for note '%s'", note.id)
    end
    return
  end


  local prompt_title
  if opts.anchor then
    prompt_title = string.format("Backlinks to '%s ❯ %s'", note.title, opts.anchor)
  elseif opts.block then
    prompt_title = string.format("Backlinks to '%s ❯ %s'", note.title, util.standardize_block(opts.block))
  elseif noteissource then
    prompt_title = string.format("Backlinks and references to '%s'", note.title)
  else
    prompt_title = string.format("Backlinks to '%s'", note.title)
  end

  pickers.new({}, {
    prompt_title = prompt_title,
    title = prompt_title,
    finder = finders.new_table {
      results = references,
      entry_maker = function(entry)
        return make_entry.set_default_entry_mt(entry)
      end
    },
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end

local function main()
  local client = require("obsidian").get_client()
  local picker = assert(client:picker())
  if not picker then
    log.err "No picker configured"
    return
  end

  local location, _, ref_type = util.parse_cursor_link { include_block_ids = true }

  if location ~= nil and ref_type ~= RefTypes.NakedUrl and ref_type ~= RefTypes.FileUrl and ref_type ~= RefTypes.BlockID then
    local block_link
    location, block_link = util.strip_block_links(location)

    local anchor_link
    location, anchor_link = util.strip_anchor_links(location)

    -- Assume 'location' is current buffer path if empty, like for TOCs.
    if string.len(location) == 0 then
      location = vim.api.nvim_buf_get_name(0)
    end

    local opts = { anchor = anchor_link, block = block_link }

    vim.print("test")
    client:resolve_note_async(location, function(...)
      local notes = { ... }

      if #notes == 0 then
        log.err("No notes matching '%s'", location)
        return
      elseif #notes == 1 then
        return collect_backlinks(client, picker, notes[1], opts)
      else
        return vim.schedule(function()
          picker:pick_note(notes, {
            prompt_title = "Select note",
            callback = function(note)
              collect_backlinks(client, picker, note, opts)
            end,
          })
        end)
      end
    end)
  else
    local opts = {}
    local load_opts = {}

    if ref_type == RefTypes.BlockID then
      opts.block = location
    else
      load_opts.collect_anchor_links = true
    end

    local note = client:current_note(0, load_opts)

    -- Check if cursor is on a header, if so, use that anchor.
    local header_match = util.parse_header(vim.api.nvim_get_current_line())
    if header_match then
      opts.anchor = header_match.anchor
    end

    if note == nil then
      log.err "Current buffer does not appear to be a note inside the vault"
    else
      collect_backlinks(client, picker, note, opts)
    end
  end
end

return { backlink_search = main }
