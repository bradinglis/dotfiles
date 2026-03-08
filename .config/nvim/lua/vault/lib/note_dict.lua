local abc = require "obsidian.abc"
local NoteRef = require "vault.lib.note_ref"
local search = require("obsidian.search")
local async = require("obsidian.async")

---@alias NoteType "note"|"author"|"source"|""

---A class that represents the tag dictionary
---
---@toc_entry obsidian.NoteDict
---
---@class obsidian.NoteDict : obsidian.ABC
---
---@field data table<string, obsidian.Note>
local NoteDict = abc.new_class {
  __tostring = function(self)
    return ""
    -- return string.format("TagDict(%s)", vim.iter(self.data):fold("{\n", function (acc, tag, noteref)
    --   return acc .. '    "' .. tag .. '": '-- .. noteref.__tostring()
    -- end) .. "\n}")
  end,
}

NoteDict.new_all = function()
  local self = NoteDict.init()
  self.data = NoteDict.get_new()
  return self
end

NoteDict.get_new = function()
  local opts = { search = { sort = true, sort_by = "modified", sort_reversed = true, fixed_strings = true, }, notes = { load_contents = true } }
  return search.get_notes(opts)
end

--- comment
---@param self obsidian.NoteDict
---@param type NoteType
---@return table<string, obsidian.Note>
NoteDict.get_type_dict = function(self, type)
  return vim.tbl_filter(function(v)
    return v.metadata.type == type
  end, self.data)
end


return NoteDict
