-- local Obsidian = require("obsidian")
local search = require("obsidian.search")
local ui = require("obsidian.ui")
local api = require("obsidian.api")
local iter, string, table = vim.iter, string, table

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

local function enter_command()
  local actions = {
    {
      name = "link",
      find = function()
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
      end,
      callback = function(link)
        local note = vim.iter(require("vault.data").get_all_notes()):find(function(x)
          return x.id == link
        end)

        vim.cmd.edit(note.relative_path)
      end
    },
    {
      name = "footnote",
      find = function()
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
      end,
      callback = function(_)
        require("footnote").new_footnote()
      end
    },
    {
      name = "tag",
      find = function()
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
              return current_line:sub(m_start, m_end)
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
      end,
      callback = function(tag)
        require('vault.tag_search').single_tag(tag)
      end
    },
    {
      name = "checkbox",
      find = function()
        local current_line = vim.api.nvim_get_current_line()
        if current_line:match("^%s*- %[.%]") then
          return true
        end
        return false
      end,
      callback = function(_)
        require("obsidian.api").toggle_checkbox()
      end
    },
    {
      name = "ado",
      find = function()
        local current_line = vim.api.nvim_get_current_line()
        local ado = current_line:match("#([0-9]+)")

        return ado
      end,
      callback = function(ado)
        vim.fn.system({ "xdg-open", "https://banz-au.visualstudio.com/_workitems/edit/" .. ado })
      end
    }
  }

  local action = vim.iter(actions):find(function(v)
    v.value = v.find()
    return v.value
  end)

  vim.schedule(function () action.callback(action.value) end)
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

local get_visual_selection = function()
  local _, csrow, cscol, cerow, cecol
  local mode = vim.fn.mode()

  if mode == "v" or mode == "V" or mode == "" then
    -- if we are in visual mode use the live position
    _, csrow, cscol, _ = unpack(vim.fn.getpos ".")
    _, cerow, cecol, _ = unpack(vim.fn.getpos "v")
    if mode == "V" then
      -- visual line doesn't provide columns
      cscol, cecol = 0, 999
    end
    -- exit visual mode
    -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
  else
    -- otherwise, use the last known visual position
    _, csrow, cscol, _ = unpack(vim.fn.getpos "'<")
    _, cerow, cecol, _ = unpack(vim.fn.getpos "'>")
  end

  -- Swap vars if needed
  if cerow < csrow then
    csrow, cerow = cerow, csrow
    cscol, cecol = cecol, cscol
  elseif cerow == csrow and cecol < cscol then
    cscol, cecol = cecol, cscol
  end

  if mode == "V" then
    -- visual line doesn't provide columns
    cscol, cecol = 0, 999
  end

  local lines = vim.fn.getline(csrow, cerow)
  assert(type(lines) == "table", "lines is not a table")
  if vim.tbl_isempty(lines) then
    return
  end

  -- When the whole line is selected via visual line mode ("V"), cscol / cecol will be equal to "v:maxcol"
  -- for some odd reason. So change that to what they should be here. See ':h getpos' for more info.
  local maxcol = vim.api.nvim_get_vvar "maxcol"
  if cscol == maxcol then
    cscol = string.len(lines[1])
  end
  if cecol == maxcol then
    cecol = string.len(lines[#lines])
  end

  ---@type string
  local selection

  local n = #lines
  if n <= 0 then
    selection = ""
  elseif n == 1 then
    selection = string.sub(lines[1], cscol, cecol)
  elseif n == 2 then
    selection = string.sub(lines[1], cscol) .. "\n" .. string.sub(lines[n], 1, cecol)
  else
    selection = string.sub(lines[1], cscol)
        .. "\n"
        .. table.concat(lines, "\n", 2, n - 1)
        .. "\n"
        .. string.sub(lines[n], 1, cecol)
  end

  return {
    lines = lines,
    selection = selection,
    csrow = csrow,
    cscol = cscol,
    cerow = cerow,
    cecol = cecol,
  }
end

return {
  enter_command = enter_command,
  links_to_reference = links_to_reference,
  references_to_links = references_to_links,
  frontmatter_highlighting = frontmatter_highlighting,
  tag_highlighting = tag_highlighting,
  print_test = print_test,
  picker_opts = picker_opts,
  set_string_width = set_string_width,
  get_visual_selection = get_visual_selection,
}
