local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local previewers = require "telescope.previewers"
local entry_display = require "telescope.pickers.entry_display"
local make_entry = require "telescope.make_entry"
local conf = require("telescope.config").values
local themes = require("telescope.themes")

local pick_source = function()
  local source_notes = require("vault.data").get_source_notes()

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 40 },
      { width = 20 },
      { width = 40 },
      { remaining = true },
    },
  }

  pickers.new(require("telescope.themes").get_dropdown({ layout_config = { width = 0.9, height = 0.5, anchor_padding = 0, anchor = "S" } }), {
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
              { entry.author_string, "markdownItalic" },
              { table.concat(entry.tags, " "),          "ObsidianTag" },
              { entry.id, "Grey" },
            }
          end,
          ordinal = entry.title .. " " .. entry.author_string .. " " .. entry.id,
          title = entry.title,
          path = entry.relative_path.filename
        }, {})
      end
    },
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end

return pick_source
