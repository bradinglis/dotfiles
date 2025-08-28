local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local entry_display = require "telescope.pickers.entry_display"
local make_entry = require "telescope.make_entry"
local conf = require("telescope.config").values

local pick_all = function()

  if not vim.wait(5000, function ()
    return not vim.g.notes_refreshing
  end) then
    return
  end

  local all_notes = require("vault.data").get_all_notes()

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 2 },
      { width = 40 },
      { width = 20 },
      { width = 40 },
      { remaining = true },
    },
  }

  pickers.new(
  require("telescope.themes").get_dropdown({ layout_config = { width = 0.9, height = 0.5, anchor_padding = 0, anchor = "S" } }),
    {
      prompt_title = "All Notes",
      title = "All Notes",
      finder = finders.new_table {
        results = all_notes,
        entry_maker = function(entry)
          return make_entry.set_default_entry_mt({
            value = entry,
            display = function()
              return displayer {
                { entry.icon,          "Fg" },
                { entry.title, "markdownBoldItalic" },
                { entry.author_string,          "markdownItalic" },
                { table.concat(entry.tags, " "),          "ObsidianTag" },
                { entry.id,    "Grey" },
              }
            end,
            ordinal = entry.title .. " " .. entry.author_string .. " ".. entry.id,
            title = entry.title,
            path = entry.relative_path,
            id = entry.id,
            link = "[[".. entry.id .. "|".. entry.title .."]]"
          }, {})
        end
      },
      previewer = conf.file_previewer({}),
      sorter = conf.generic_sorter({}),
      attach_mappings = require("vault.pick_mappings")
    }):find()
end

return pick_all
