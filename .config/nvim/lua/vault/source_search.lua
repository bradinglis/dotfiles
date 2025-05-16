local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local previewers = require "telescope.previewers"
local entry_display = require "telescope.pickers.entry_display"
local make_entry = require "telescope.make_entry"
local conf = require("telescope.config").values
local themes = require("telescope.themes")

local function filter(arr, func)
  local new_arr = {}
  for old_index, v in ipairs(arr) do
    if func(v, old_index) then
      new_arr[#new_arr + 1] = v
    end
  end
  return new_arr
end



local pick_source = function()
  local notes = require("vault.search").get_notes()

  local source_notes = filter(notes, function(val, _)
    if val.metadata ~= nil then
      if val.metadata.type ~= nil then
        return val.metadata.type == "source"
      end
    else
      return false
    end
  end)

  local author_notes = filter(notes, function (val, _)
      if val.metadata ~= nil then
          if val.metadata.type ~= nil then
              return val.metadata.type == "author"
          end
      else
          return false
      end
  end)

  local get_author = function(arg_id)
    for i, v in ipairs(author_notes) do
      if v.id == arg_id then
        return v.title
      end
    end
    return arg_id
  end

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 40 },
      { width = 20 },
      { remaining = true },
    },
  }

  pickers.new({}, {
    prompt_title = "Sources",
    title = "Sources",
    finder = finders.new_table {
      results = source_notes,
      entry_maker = function(entry)
        return make_entry.set_default_entry_mt({
          value = entry,
          display = function()
            return displayer {
              { entry.title, "markdownBold" },
              { get_author(entry.metadata.author[1]), "markdownItalic" },
              { entry.id, "Grey" },
            }
          end,
          ordinal = entry.title .. " " .. entry.metadata.author[1] .. " " .. get_author(entry.metadata.author[1]),
          title = entry.title,
          path = entry.path.filename
        }, {})
      end
    },
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end

return pick_source
