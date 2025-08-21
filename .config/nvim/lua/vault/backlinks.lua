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

local function find_references(noteid)
  local notes = require("vault.data").get_all_notes()
  local res = {}

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 10 },
      { width = 2 },
      { width = 40 },
      { width = 20 },
      { remaining = true },
    },
  }

  for _, resnote in pairs(notes) do
    if resnote.metadata ~= nil and not vim.tbl_isempty(resnote.metadata) then
      if resnote.metadata.references ~= nil and not vim.tbl_isempty(resnote.metadata.references) then
        if vim.tbl_contains(resnote.metadata.references, noteid) then
          res[#res + 1] = {
            value = { path = resnote.path, lnum = 1 },
            display = function()
              return displayer {
                { "Reference",           "Grey" },
                { resnote.icon,          "Fg" },
                { resnote.title,         "markdownBoldItalic" },
                { resnote.author_string, "markdownItalic" },
                { resnote.id,            "Grey" },
              }
            end,
            ordinal = resnote.title .. " " .. resnote.author_string .. resnote.id,
            title = resnote.title,
            path = resnote.path.filename,
            filename = tostring(resnote.path),
            id = resnote.id,
          }
        end
      end
    end
    if resnote.links ~= nil and resnote.metadata ~= nil and resnote.metadata.type ~= nil and not vim.tbl_isempty(resnote.links) then
      for _, value in ipairs(resnote.links) do
        if value[1] == noteid then
          local line = value[2]
          res[#res + 1] = {
            value = { path = resnote.path, lnum = line },
            display = function()
              return displayer {
                { "Link [" .. line .. "]", "Grey" },
                { resnote.icon,                "Fg" },
                { resnote.title,               "markdownBoldItalic" },
                { resnote.author_string,       "markdownItalic" },
                { resnote.id,                  "Grey" },
              }
            end,
            ordinal = resnote.title .. " " .. resnote.author_string .. resnote.id,
            title = resnote.title,
            path = resnote.path.filename,
            filename = tostring(resnote.path),
            lnum = line,
            id = resnote.id,
          }
        end
      end
    end
  end
  return res
end

local function collect_backlinks(noteid, opts)
  opts = opts or {}

  local references = {}
  references = find_references(noteid)

  if vim.tbl_isempty(references) then
    log.info("No backlinks found for note '%s'", noteid)
    return
  end

  local prompt_title = string.format("Backlinks to '%s'", noteid)

  pickers.new(require("telescope.themes").get_dropdown({ layout_config = { width = 0.9, height = 0.5, anchor_padding = 0, anchor = "S" } }),
    {
      prompt_title = prompt_title,
      title = prompt_title,
      finder = finders.new_table {
        results = references,
        entry_maker = function(entry)
          return make_entry.set_default_entry_mt(entry)
        end
      },
      previewer = conf.grep_previewer({}),
      sorter = conf.generic_sorter({}),
      attach_mappings = require("vault.pick_mappings")
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

    -- local search_note = {}
    -- for key, value in pairs(require("vault.data").get_all_notes()) do
    --   if(value.id == location) then
    --     search_note = value
    --     break
    --   end
    -- end

    local opts = { anchor = anchor_link, block = block_link }
    collect_backlinks(location, opts)

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
      collect_backlinks(note.id, opts)
    end
  end
end

return { backlink_search = main }
