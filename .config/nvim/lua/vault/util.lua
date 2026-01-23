-- local Obsidian = require("obsidian")
local search = require("obsidian.search")
local ui = require("obsidian.ui")
local api = require("obsidian.api")
local iter = vim.iter

local picker_opts = {
  layout = {
    layout = {
      backdrop = false,
      width = 0.90,
      min_width = 80,
      height = 0.95,
      border = "none",
      box = "vertical",
      { win = "preview", title = "{preview}", height = 0.5, border = "single" },
      {
        box = "vertical",
        border = "single",
        title = "{title} {live} {flags}",
        title_pos = "center",
        { win = "input", height = 1,     border = "bottom" },
        { win = "list",  border = "none" },
      },
    }
  },
  win = {
    input = {
      keys = {
        ["<C-l>"] = { "put_link", mode = { "n", "i" }, desc = "Put Link" },
        ["<C-o>"] = { "put_id", mode = { "n", "i" }, desc = "Put ID" },
      },
    },
  },
  buffers = true,
  actions = {
    put_link = function(picker)
      local link = picker:current().link
      picker:close()
      vim.api.nvim_put({ link }, "", false, true)
    end,
    put_id = function(picker)
      local id = picker:current().id
      picker:close()
      vim.api.nvim_put({ id }, "", false, true)
    end,
  },
}

local set_string_width = function(text, width)
  if (vim.fn.strdisplaywidth(text) > width) then
    return vim.fn.strcharpart(text, -1, width) .. "…"
  elseif vim.fn.strdisplaywidth(text) < width then
    return text .. string.rep(" ", width - vim.fn.strdisplaywidth(text))
  else
    return text
  end
end

local function find_frontmatter_links(line)
  local links = {}
  local pattern = "[A-Za-z]+[A-Za-z0-9_/-]*[A-Za-z0-9]+"

  local patterns = { "^references:", "^source%-parents:", "^author:" }

  for _, value in ipairs(patterns) do
    local m_start, m_end = string.find(line, value, 1)
    if m_start ~= nil and m_end ~= nil then
      local search_start = m_end
      while search_start < #line do
        m_start, m_end = string.find(line, pattern, search_start)
        if m_start ~= nil and m_end ~= nil then
          links[#links + 1] = { m_start, m_end }
          search_start = m_end
        else
          return links
        end
      end
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

local function find_wiki_links(line)
  local links = {}
  local pattern = "%[%[([^|]+)|([^%]]+)%]%]"

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

local function get_wiki_image()
  local line = vim.api.nvim_get_current_line()
  local links = {}
  local pattern = "!%[%[(.*)%]%]"

  local m_start, m_end = string.find(line, pattern)
  links[#links + 1] = { m_start, m_end }
  local file = line:sub(m_start, m_end):match("%[%[(.*)%]%]")
  return file
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
  note.frontmatter_end_line = note.frontmatter_end_line or -1
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
          hl_group = Obsidian.opts.ui.reference_text.hl_group,
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
          hl_group = Obsidian.opts.ui.tags.hl_group,
          spell = false,
        }
      ):materialize(note.bufnr, ns_id)
    end
  end
end

local function tag_highlighting(note)
  note.frontmatter_end_line = note.frontmatter_end_line or 0
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
            hl_group = Obsidian.opts.ui.tags.hl_group,
            spell = false,
          }
        ):materialize(note.bufnr, ns_id)
      end
    end
  end
end

local function cursor_on_link()
  local current_line = vim.api.nvim_get_current_line()
  local cur_row, cur_col = unpack(vim.api.nvim_win_get_cursor(0))
  cur_col = cur_col + 1

  local in_frontmatter = false
  local note = api.current_note()
  if note and note.frontmatter_end_line ~= nil then
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
        for _, id in current_line:sub(m_start, m_end):gmatch("%[([^%]]+)%]%[(%d+)%]") do
          ref = id
        end
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        for _, value in pairs(lines) do
          local id, reference = string.match(value, "^%[([0-9]+)%]: (.+)")
          if id == ref then
            return reference
          end
        end
      end
    end
    local wiki_links = find_wiki_links(current_line)
    for link in iter(wiki_links) do
      local m_start, m_end = unpack(link)
      if m_start <= cur_col and cur_col <= m_end then
        for id, _ in current_line:sub(m_start, m_end):gmatch("%[%[([^|]+)|([^%]]+)%]%]") do
          return id
        end
      end
    end
  end

  return nil
end

local function cursor_on_tag()
  local current_line = vim.api.nvim_get_current_line()
  local cur_row, cur_col = unpack(vim.api.nvim_win_get_cursor(0))
  cur_col = cur_col + 1

  local in_frontmatter = false
  local note = api.current_note()
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

local function cursor_ado_tag()
  local current_line = vim.api.nvim_get_current_line()
  local ado = current_line:match("#([0-9]+)")
  return ado
end

local function cursor_check_line()
  local current_line = vim.api.nvim_get_current_line()
  if current_line:match("^%s*- %[.%]") then
    return true
  end
  return false
end

local function enter_command()

  local link = cursor_on_link()
  if link then
    local path = table.foreach(require("vault.data").get_all_notes(), function (key, value)
      if(value.id == link) then
        return value.relative_path
      end
    end)
    return ":e " .. path .. "<CR>"
  else
    local image = get_wiki_image()
    if image then
      print(image:gsub(" ", "\\ "))
      vim.system({'explorer.exe', '.\\assets\\imgs\\' .. image })
    end
  end

  local footnote = cursor_on_footnote()
  if footnote then
    return "<cmd>lua require('footnote').new_footnote()<CR>"
  end

  local tag = cursor_on_tag()
  if tag then
    return "<cmd>TagSearch " .. tag:sub(2, -1) .. "<CR>"
  end

  local checkbox = cursor_check_line()
  if checkbox then
    return "<cmd>Obsidian toggle_checkbox<CR>"
  end

  local ado = cursor_ado_tag()
  if ado then
    return "lua vim.fn.system({\"xdg-open\", \"https://banz-au.visualstudio.com/Avenir%20SSC/_workitems/edit/\"" .. ado .. "})"
  end

end

local function goto_ado ()
  local ado = cursor_ado_tag()

  if ado then
    vim.fn.system({"xdg-open", "https://banz-au.visualstudio.com/Avenir%20SSC/_workitems/edit/" .. ado })
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
      value = string.gsub(value,
        "%[%[" ..
        id:gsub("%-", "%%-"):gsub("%(", "%%("):gsub("%)", "%%)") ..
        "%|" .. text:gsub("%-", "%%-"):gsub("%(", "%%("):gsub("%)", "%%)") .. "%]%]",
        "[" .. text .. "][" .. links[id] .. "]")
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
    local id, reference = string.match(value, "^%[([0-9]+)%]: (.+)")
    if id ~= nil then
      references[id] = reference
    end
    if count == vim.tbl_count(references) then
      new_lines[#new_lines + 1] = value
    end
  end

  for i, value in pairs(new_lines) do
    for text, id in string.gmatch(value, "%[([^%]]+)%]%[(%d+)%]") do
      value = string.gsub(value,
        "%[" ..
        text:gsub("%-", "%%-"):gsub("%(", "%%("):gsub("%)", "%%)") ..
        "%]%[" .. id:gsub("%-", "%%-"):gsub("%(", "%%("):gsub("%)", "%%)") .. "%]",
        "[[" .. references[id] .. "|" .. text .. "]]")
    end
    new_lines[i] = value
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
end

local function print_test()
  vim.print(vim.inspect(api.current_note()))
end

return {
  enter_command = enter_command,
  goto_ado = goto_ado,
  links_to_reference = links_to_reference,
  references_to_links = references_to_links,
  frontmatter_highlighting = frontmatter_highlighting,
  tag_highlighting = tag_highlighting,
  print_test = print_test,
  picker_opts = picker_opts,
  set_string_width = set_string_width,
}
