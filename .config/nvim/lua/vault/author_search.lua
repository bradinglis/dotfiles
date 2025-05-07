local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local previewers = require "telescope.previewers"
local entry_display = require "telescope.pickers.entry_display"
local make_entry = require "telescope.make_entry"
local conf = require("telescope.config").values
local themes = require("telescope.themes")

local client = require("obsidian").get_client()

local function filter(arr, func)
    local new_arr = {}
    for old_index, v in ipairs(arr) do
        if func(v, old_index) then
            new_arr[#new_arr+1] = v
        end
    end
    return new_arr
end

local notes = client:find_notes("")

local author_notes = filter(notes, function (val, _)
    if val.metadata ~= nil then
        if val.metadata.type ~= nil then
            return val.metadata.type == "author"
        end
    else
        return false
    end
end)

local pick_author = function()
  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 20 },
      { remaining = true },
    },
  }
  pickers.new({}, {
    prompt_title = "Authors",
    title = "Authors",
    finder = finders.new_table {
      results = author_notes,
      entry_maker = function(entry)
        return make_entry.set_default_entry_mt({
          value = entry,
          display = function()
            return displayer {
              { entry.title, "markdownBold" },
              { entry.id, "Grey" },
            }
          end,
          ordinal = entry.title .. " " .. entry.id,
          title = entry.title,
          path = entry.path.filename
        }, {})
      end
    },
    previewer = conf.grep_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end

return pick_author


