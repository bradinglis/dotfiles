local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local previewers = require "telescope.previewers"
local entry_display = require "telescope.pickers.entry_display"
local make_entry = require "telescope.make_entry"
local conf = require("telescope.config").values
local themes = require("telescope.themes")

local pick_note = function()

  if not vim.wait(5000, function ()
    return not vim.g.notes_refreshing
  end) then
    return
  end

  local note_notes = require("vault.data").get_note_notes()
  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 40 },
      { width = 60 },
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
              { table.concat(entry.tags, " "),          "ObsidianTag" },
              { entry.id, "Grey" },
            }
          end,
          ordinal = entry.title,
          title = entry.title,
          path = entry.relative_path
        }, {})
      end
    },
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
    attach_mappings = require("vault.pick_mappings")
  }):find()
end

return pick_note


