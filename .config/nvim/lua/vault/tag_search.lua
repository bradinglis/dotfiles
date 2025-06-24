local pickers = require "telescope.pickers"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local finders = require "telescope.finders"
local previewers = require "telescope.previewers"
local entry_display = require "telescope.pickers.entry_display"
local make_entry = require "telescope.make_entry"
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


local single_tag = function(tag)
  local notes = require("vault.data").get_notes()
  local tags = require("vault.data").get_tags()

  local tag_notes = vim.tbl_values(tags[tag])

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

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 2 },
      { width = 40 },
      { width = 20 },
      { remaining = true },
    },
  }

  pickers.new(require("telescope.themes").get_dropdown({ layout_config = { width = 0.9, height = 0.5, anchor_padding = 0, anchor = "S" } }), {
    prompt_title = tag,
    title = tag,
    finder = finders.new_table {
      results = tag_notes,
      entry_maker = function(entry)
        if entry.note.metadata.type == "author" then
          return make_entry.set_default_entry_mt({
            value = entry.note,
            display = function()
              return displayer {
                { "", "Fg" },
                { entry.note.title, "markdownBoldItalic" },
                { "", "Grey" },
                { entry.note.id, "Grey" },
              }
            end,
            ordinal = entry.note.title .. " " .. entry.note.id,
            title = entry.note.title,
            path = entry.note.path.filename,
            lnum = entry.line,
          }, {})
        end
        if entry.note.metadata.type == "source" then
          return make_entry.set_default_entry_mt({
            value = entry.note,
            display = function()
              return displayer {
                { "", "Fg" },
                { entry.note.title, "markdownBoldItalic" },
                { get_author(entry.note.metadata.author[1]), "markdownItalic" },
                { entry.note.id, "Grey" },
              }
            end,
            ordinal = entry.note.title ..
            " " .. entry.note.metadata.author[1] .. " " .. get_author(entry.note.metadata.author[1]),
            title = entry.note.title,
            path = entry.note.path.filename,
            lnum = entry.line,
          }, {})
        end
        if entry.note.metadata.type == "note" then
          return make_entry.set_default_entry_mt({
            value = entry.note,
            display = function()
              return displayer {
                { "", "Fg" },
                { entry.note.title, "markdownBoldItalic" },
                { "", "Grey" },
                { entry.note.id, "Grey" },
              }
            end,
            ordinal = entry.note.title,
            title = entry.note.title,
            path = entry.note.path.filename,
            lnum = entry.line,
          }, {})
        end
        return make_entry.set_default_entry_mt({
          value = entry.note,
          display = function()
            return displayer {
              { "Type",           "markdownBold" },
              { entry.note.title, "markdownBoldItalic" },
              { "",               "markdownItalic" },
              { entry.note.id,    "Grey" },
            }
          end,
          ordinal = entry.note.title .. " " .. entry.note.id,
          title = entry.note.title,
          path = entry.note.relative_path.filename,
          lnum = entry.line,
        }, {})
      end
    },
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end

local all_tags = function()
  local tags = require("vault.data").get_tags()
  local tag_keys = vim.tbl_keys(tags)

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 6 },
      { width = 20 },
      { remaining = true },
    },
  }

  pickers.new(require("telescope.themes").get_dropdown({ layout_config = { width = 0.9, height = 0.9, anchor_padding = 0, anchor = "S" } }), {
    prompt_title = "Tags",
    title = "Tags",
    finder = finders.new_table {
      results = tag_keys,
      entry_maker = function(entry)
        return make_entry.set_default_entry_mt({
          value = entry,
          display = function()
            local number = "[" .. vim.tbl_count(tags[entry]) .. "]"
            local notes =  table.concat(vim.tbl_keys(tags[entry]), " ")
            return displayer {
              { number,  "Fg" },
              { entry, "ObsidianTag" },
              { notes, "Grey" },
            }
          end,
          ordinal = entry,
        }, {})
      end
    },
    attach_mappings = function()
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        single_tag(selection.ordinal)
      end)
      return true
    end,
    sorter = conf.generic_sorter({}),
  }):find()
end

return {
  single_tag = single_tag,
  all_tags = all_tags
}
