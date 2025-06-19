local telescope = require "telescope.builtin"
local entry_display = require "telescope.pickers.entry_display"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values

local grep = function()
  local lines = require("vault.search").get_lines()
  local cwd = require("obsidian"):get_client().dir

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 4 },
      { width = 20, right_justify = true },
      { remaining = true },
    },
  }

  pickers.new(
  require("telescope.themes").get_dropdown({ layout_config = { width = 0.9, height = 0.5, anchor_padding = 0, anchor = "S" } }),
    {
      prompt_title = "Sources",
      title = "Sources",
      finder = finders.new_table {
        results = lines,
        entry_maker = function(entry)
          return make_entry.set_default_entry_mt({
            value = entry,
            display = function()
              return displayer {
                { entry.num, "Grey" },
                { entry.note.id, "markdownBoldItalic" },
                { entry.text, "Grey" },
              }
            end,
            ordinal = entry.text,
            path = entry.note.path,
            lnum = entry.num,
          }, {})
        end
      },
      previewer = conf.grep_previewer({}),
      sorter = conf.generic_sorter({}),
    }):find()
end


return grep
