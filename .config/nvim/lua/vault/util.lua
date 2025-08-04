local search = require("obsidian.search")
local ui = require("obsidian.ui")
local iter = require("obsidian.itertools").iter

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

local function find_reference_links(line)
  local links = {}
  local pattern = "%[([^%]]+)%]%[(%d+)%]"

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

local function find_footnote(line)
  local links = {}
  local pattern = "%[%^[^%]]+%]"

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

local function frontmatter_highlighting(note)
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

local function tag_highlighting(note)
  local client = require("obsidian").get_client()
  local ns_id = vim.api.nvim_create_namespace("ObsidianBrad")
  local lines = vim.api.nvim_buf_get_lines(note.bufnr, note.frontmatter_end_line, -1, true)
  for i, line in ipairs(lines) do
    local lnum = i + note.frontmatter_end_line - 1
    local matches = search.find_refs(line, { include_naked_urls = false, include_tags = true, include_block_ids = false })
    for match in iter(matches) do
      local m_start, m_end, m_type = unpack(match)
      if m_type == search.RefTypes.Tag then
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
  else
    local links = find_reference_links(current_line)
    for link in iter(links) do
      local m_start, m_end = unpack(link)
      if m_start <= cur_col and cur_col <= m_end then
        local ref
        for text, id in current_line:sub(m_start, m_end):gmatch("%[([^%]]+)%]%[(%d+)%]") do
          ref = id
        end
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        for _, value in pairs(lines) do
          for id, reference in string.gmatch(value, "%[([0-9]+)%]: (.+)") do
            if id == ref then
              return reference
            end
          end
        end
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

local function cursor_on_footnote()
  local client = require("obsidian").get_client()
  local current_line = vim.api.nvim_get_current_line()
  local cur_row, cur_col = unpack(vim.api.nvim_win_get_cursor(0))
  cur_col = cur_col + 1

  for match in iter(find_footnote(current_line)) do
    local open, close, _ = unpack(match)
    if open <= cur_col and cur_col <= close then
      return true
    end
  end

  return nil
end

local function enter_command()
  local tag = cursor_on_tag()
  local link = cursor_on_link()
  local footnote = cursor_on_footnote()

  if footnote then
    return "<cmd>lua require('footnote').new_footnote()<CR>"
  elseif tag then
    return "<cmd>TagSearch " .. tag:sub(2, -1) .. "<CR>"
  elseif link then
    return "<cmd>ObsidianQuickSwitch " .. link .. "<CR>"
  else
    return "<cmd>ObsidianFollowLink<CR>"
  end
end

local function links_to_reference()
  local links = {}
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local new_lines = {}
  for _, value in pairs(lines) do
    for id, text in string.gmatch(value, "%[%[([^][%|]+)%|([^%]]+)%]%]") do
      if links[id] == nil then
        links[id] = vim.tbl_count(links)
      end
      value = string.gsub(value, "%[%[" .. id:gsub("%-", "%%-"):gsub("%(", "%%("):gsub("%)", "%%)") .. "%|" .. text:gsub("%-", "%%-"):gsub("%(", "%%("):gsub("%)", "%%)") .. "%]%]", "[" .. text .. "][" .. links[id] .. "]")
    end
    new_lines[#new_lines + 1] = value
  end


  local endline = #new_lines + 1
  for key, value in pairs(links) do
    new_lines[endline + value] = "[" .. value .. "]: " .. key
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
end

local function references_to_links()
  local references = {}
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local new_lines = {}
  for _, value in pairs(lines) do
    local count = vim.tbl_count(references)
    for id, reference in string.gmatch(value, "%[([0-9]+)%]: (.+)") do
      references[id] = reference
    end
    if count == vim.tbl_count(references) then
      new_lines[#new_lines + 1] = value
    end
  end

  for i, value in pairs(new_lines) do
    for text, id in string.gmatch(value, "%[([^%]]+)%]%[(%d+)%]") do
      value = string.gsub(value, "%[" .. text:gsub("%-", "%%-"):gsub("%(", "%%("):gsub("%)", "%%)") .. "%]%[" .. id:gsub("%-", "%%-"):gsub("%(", "%%("):gsub("%)", "%%)") .. "%]", "[[" .. references[id] .. "|" .. text .. "]]")
    end
    new_lines[i] = value
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
end

local function print_test()
  local notes = require("vault.data").get_all_notes()
  print(vim.inspect(notes[1]))
  print(vim.inspect(vim.tbl_map(function (value)
    return value.id
  end, notes)))
end

return {
  enter_command = enter_command,
  links_to_reference = links_to_reference,
  references_to_links = references_to_links,
  frontmatter_highlighting = frontmatter_highlighting,
  tag_highlighting = tag_highlighting,
  print_test = print_test,
}
