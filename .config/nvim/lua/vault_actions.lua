local search = require("obsidian.search")
local ui = require("obsidian.ui")
local iter = require("obsidian.itertools").iter
local util = require "obsidian.util"
local Note = require "obsidian.note"

local function pseudo_assert(s)
    if s == nil then
        s = {}
    end
    return s
end

local function new_source()
    local client = require("obsidian").get_client()
    local current_note = client:current_note()
    local dir = ""
    local author = ""
    local sourceparents = {}
    if current_note.metadata.type == "source" then
        dir = client.dir.filename .. "/sources/" .. current_note.metadata.author[1]:gsub("%%","") .. "/"

        if current_note.metadata["source-parents"] ~= nil and not vim.tbl_isempty(current_note.metadata["source-parents"]) then
            for _, parent in ipairs(current_note.metadata["source-parents"]) do
                sourceparents[#sourceparents+1] = parent
                dir = dir .. parent:gsub("~","") .. "/"
            end
        end
        dir = dir .. current_note.id:gsub("~","") .. "/"

        sourceparents[#sourceparents+1] = current_note.id

        author = current_note.metadata.author
    elseif current_note.metadata.type == "author" then
        dir = client.dir.filename .. "/sources/" .. current_note.id:gsub("%%","") .. "/"
        author = current_note.id
    else
        print("Invalid current note type")
    end

    local shortName = util.input "Enter source short name: ~"
    if not shortName then
      print("Aborted")
      return
    elseif shortName == "" then
      print("Aborted")
      return
    end

    local id = "~" .. shortName

    local longName = util.input "Enter source long name: "
    if not longName then
      print("Aborted")
      return
    elseif longName == "" then
      longName = shortName
    end

    local new_note_dir = dir .. id .. ".md"
    local sourceNote = Note.new(id, { longName }, current_note.tags, new_note_dir)

    local note = client:write_note(sourceNote, { template = "source" })
    note.metadata = {
        type = "source",
        ["source-parents"] = sourceparents,
        author = author
    }

    client:open_note(note, {
        callback = function(bufnr)
            client:write_note_to_buffer(note, { bufnr = bufnr })
        end,
    })

end

local function new_note()
    local client = require("obsidian").get_client()
    local longName = util.input "Enter note name: "

    if not longName then
      print("Aborted")
      return
    elseif longName == "" then
      print("Aborted")
      longName = nil
      return
    end

    local id = longName:lower():gsub(" ", "-"):gsub("[()]", "")
    local dir = client.dir.filename .. "/notes/" .. id .. ".md"

    local newNote = Note.new(id, { longName }, {}, dir)

    local note = client:write_note(newNote, { template = "note" })
    note.metadata = { type = "note" }

    client:open_note(note, {
        callback = function(bufnr)
            client:write_note_to_buffer(note, { bufnr = bufnr })
        end,
    })
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

    local id = "%" .. shortName
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
    note.metadata = { type = "author" }

    client:open_note(note, {
        callback = function(bufnr)
            client:write_note_to_buffer(note, { bufnr = bufnr })
        end,
    })
end

local function find_frontmatter_links(line)
    local links = {}
    local pattern = "[~%%][A-Za-z]+[A-Za-z0-9_/-]*[A-Za-z0-9]+"

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
        return "<cmd>ObsidianQuickSwitch " .. link.. "<CR>"
    else
        return "<cmd>ObsidianFollowLink<CR>"
    end
end

local function create_tag_index()
    local client = require("obsidian").get_client()
    local taglist = {}
    local tags = client.list_tags(client)
    local vaultdir = client.dir

    for _, tag in ipairs(tags) do
        local instances = client.find_tags(client, tag)
        local taginstances = {}
        for _, instance in ipairs(instances) do
            if instance.tag == tag then
                if instance.note.metadata == nil then
                    taginstances['nil'] = pseudo_assert(taginstances['nil'])
                    if taginstances['nil'][instance.note.id] == nil then
                        taginstances['nil'][instance.note.id] = { id = instance.note.id, metadata = instance.note.metadata }
                    end
                else
                    if instance.note.metadata.type == nil then
                        taginstances['nil'] = pseudo_assert(taginstances['nil'])
                        if taginstances['nil'][instance.note.id] == nil then
                            taginstances['nil'][instance.note.id] = { id = instance.note.id, metadata = instance.note.metadata }
                        end
                    else
                        taginstances[instance.note.metadata.type] = pseudo_assert(taginstances[instance.note.metadata.type])
                        if taginstances[instance.note.metadata.type][instance.note.id] == nil then
                            taginstances[instance.note.metadata.type][instance.note.id] = { id = instance.note.id, metadata = instance.note.metadata }
                        end
                    end
                end
            end
        end
        taglist[tag] = { tag = tag, instances = taginstances }
    end

    -- REAL documents
    for tagname, tagobject in pairs(taglist) do
        local file = assert(io.open(vaultdir.filename .. "/tag_index/!" .. tagname .. ".md", "w"))

        file:write("---\nid: !" .. tagname .. "\ntags: []\naliases: []\ntype: tag_index\n---\n\n")

        file:write("# " .. tagname:gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end), "\n")
        file:write("\n")
        file:write("## References", "\n")
        file:write("\n")
        for type, instancetype in pairs(tagobject.instances) do
            file:write("### " .. type:gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end) .. "s", "\n")
            for _, instance in pairs(instancetype) do
                file:write("- [[" .. instance.id .. "]]", "\n")
            end
            file:write("\n")
        end
        file:write("\n")
        file:close()
    end
end

return {
    create_tag_index = create_tag_index,
    enter_command = enter_command,
    frontmatter_hightlighting = frontmatter_hightlighting,
    new_author = new_author,
    new_source = new_source,
    new_note = new_note,
}
