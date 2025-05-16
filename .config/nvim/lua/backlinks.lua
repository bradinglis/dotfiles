local util = require "obsidian.util"
local log = require "obsidian.log"
local RefTypes = require("obsidian.search").RefTypes

local function find_references(client, note)
  local notes = require("vault.search").get_notes()
  local res = {}
  for _, resnote in pairs(notes) do
    if resnote.metadata ~= nil and not vim.tbl_isempty(resnote.metadata) then
      if resnote.metadata.references ~= nil and not vim.tbl_isempty(resnote.metadata.references) then
        if vim.tbl_contains(resnote.metadata.references, note.id) then
          res[#res + 1] = {
            display = "Reference: " .. resnote.title,
            value = { path = resnote.path, line = 1 },
            filename = tostring(resnote.path),
            lnum = 1,
          }
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

  if not (opts.anchor or opts.block) and noteissource then
    references = find_references(client, note)
  end

  client:find_backlinks_async(note, function(backlinks)
    if vim.tbl_isempty(backlinks) then
      if opts.anchor then
        log.info("No backlinks found for anchor '%s' in note '%s'", opts.anchor, note.id)
      elseif opts.block then
        log.info("No backlinks found for block '%s' in note '%s'", opts.block, note.id)
      else
        log.info("No backlinks found for note '%s'", note.id)
      end
      return
    end

    local entries = {}
    for _, matches in ipairs(backlinks) do
      for _, match in ipairs(matches.matches) do
        entries[#entries + 1] = {
          display = "Backlink: " .. matches.note.title,
          value = { path = matches.path, line = match.line },
          filename = tostring(matches.path),
          lnum = match.line,
        }
      end
    end

    local prompt_title
    if opts.anchor then
      prompt_title = string.format("Backlinks to '%s ❯ %s'", note.title, opts.anchor)
    elseif opts.block then
      prompt_title = string.format("Backlinks to '%s ❯ %s'", note.title, util.standardize_block(opts.block))
    elseif noteissource then
      prompt_title = string.format("Backlinks and references to '%s'", note.title)
      if not vim.tbl_isempty(references) then
        for _, ref in ipairs(references) do
          entries[#entries + 1] = ref
        end
      end
    else
      prompt_title = string.format("Backlinks to '%s'", note.title)
    end

    vim.schedule(function()
      picker:pick(entries, {
        prompt_title = prompt_title,
        callback = function(value)
          util.open_buffer(value.path, { line = value.line })
        end,
      })
    end)
  end, { search = { sort = true }, anchor = opts.anchor, block = opts.block })
end

local function main()
  local client = require("obsidian").get_client()
  local picker = assert(client:picker())
  if not picker then
    log.err "No picker configured"
    return
  end

  local location, _, ref_type = util.parse_cursor_link { include_block_ids = true }

  if
      location ~= nil
      and ref_type ~= RefTypes.NakedUrl
      and ref_type ~= RefTypes.FileUrl
      and ref_type ~= RefTypes.BlockID
  then
    local block_link
    location, block_link = util.strip_block_links(location)

    local anchor_link
    location, anchor_link = util.strip_anchor_links(location)

    -- Assume 'location' is current buffer path if empty, like for TOCs.
    if string.len(location) == 0 then
      location = vim.api.nvim_buf_get_name(0)
    end

    local opts = { anchor = anchor_link, block = block_link }

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
