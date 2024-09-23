local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local previewers = require "telescope.previewers"
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

local source_notes = filter(notes, function (val, _)
    if val.metadata ~= nil then
        if val.metadata.type ~= nil then
            return val.metadata.type == "source"
        end
    else
        return false
    end
end)

local pick_source = function()
  pickers.new({}, {
    prompt_title = "Sources",
    title = "Sources",
    finder = finders.new_table {
      results = source_notes,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.metadata.author[1] .. ": " .. entry.title,
          ordinal = entry.title .. " " .. " " .. entry.metadata.author[1],
          title = entry.title,
          path = entry.path.filename
        }
      end
    },
    previewer = conf.grep_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end

return pick_source


