local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local previewers = require "telescope.previewers"
local entry_display = require "telescope.pickers.entry_display"
local make_entry = require "telescope.make_entry"
local conf = require("telescope.config").values
local themes = require("telescope.themes")

local pick_note = function()
  local note_notes = require("vault.search").get_note_notes()
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


