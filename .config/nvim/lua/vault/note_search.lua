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
            new_arr[#new_arr+1] = v
        end
    end
    return new_arr
end


local pick_note = function()
  local notes = require("vault.search").get_notes()
  local note_notes = filter(notes, function (val, _)
      if val.metadata ~= nil then
          if val.metadata.type ~= nil then
              return val.metadata.type == "note"
          end
      else
          return false
      end
  end)
  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 40 },
      { remaining = true },
    },
  }
  pickers.new(require("telescope.themes").get_dropdown({ layout_config = { width = 0.9, height = 0.5, anchor_padding = 0, anchor = "S" } }), {
    prompt_title = "Notes",
    title = "Notes",
    finder = finders.new_table {
      results = note_notes,
      entry_maker = function(entry)
        return make_entry.set_default_entry_mt({
          value = entry,
          display = function()
            return displayer {
              { entry.title, "markdownBold" },
              { entry.id, "Grey" },
            }
          end,
          ordinal = entry.title,
          title = entry.title,
          path = entry.relative_path.filename
        }, {})
      end
    },
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end

return pick_note


