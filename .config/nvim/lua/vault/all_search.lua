local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
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

local pick_all = function()
  local notes = require("vault.search").get_notes()
  local all_notes = filter(notes, function(val, _)
    if val.metadata ~= nil then
      if val.metadata.type ~= nil then
        return val.metadata.type == "source" or val.metadata.type == "note" or val.metadata.type == "author"
      end
    else
      return false
    end
  end)

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
    prompt_title = "Sources",
    title = "Sources",
    finder = finders.new_table {
      results = all_notes,
      entry_maker = function(entry)
        if entry.metadata.type == "author" then
          return make_entry.set_default_entry_mt({
            value = entry,
            display = function()
              return displayer {
                { "", "Fg" },
                { entry.title, "markdownBoldItalic" },
                { "", "Grey" },
                { entry.id, "Grey" },
              }
            end,
            ordinal = entry.title .. " " .. entry.id,
            title = entry.title,
            path = entry.path.filename
          }, {})
        end
        if entry.metadata.type == "source" then
          return make_entry.set_default_entry_mt({
            value = entry,
            display = function()
              return displayer {
                { "", "Fg" },
                { entry.title, "markdownBoldItalic" },
                { get_author(entry.metadata.author[1]), "markdownItalic" },
                { entry.id, "Grey" },
              }
            end,
            ordinal = entry.title .. " " .. entry.metadata.author[1] .. " " .. get_author(entry.metadata.author[1]),
            title = entry.title,
            path = entry.path.filename
          }, {})
        end
        if entry.metadata.type == "note" then
          return make_entry.set_default_entry_mt({
            value = entry,
            display = function()
              return displayer {
                { "", "Fg" },
                { entry.title, "markdownBoldItalic" },
                { "", "Grey" },
                { entry.id, "Grey" },
              }
            end,
            ordinal = entry.title,
            title = entry.title,
            path = entry.path.filename
          }, {})
        end
        return make_entry.set_default_entry_mt({
          value = entry,
          display = function()
            return displayer {
              { "Type",                               "markdownBold" },
              { entry.title,                          "markdownBoldItalic" },
              { get_author(entry.metadata.author[1]), "markdownItalic" },
              { entry.id,                             "Grey" },
            }
          end,
          ordinal = entry.title .. " " .. entry.id,
          title = entry.title,
          path = entry.relative_path.filename
        }, {})
      end
    },
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end

return pick_all
