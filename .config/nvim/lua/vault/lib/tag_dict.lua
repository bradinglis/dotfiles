local abc = require "obsidian.abc"
local NoteRef = require "vault.lib.note_ref"
local NoteDict = require "vault.lib.note_dict"

---A class that represents the tag dictionary
---
---@toc_entry obsidian.Note
---
---@class obsidian.TagDict : obsidian.ABC
---
---@field data table<string, obsidian.NoteRef[]>
local TagDict = abc.new_class {
  __tostring = function(self)
    return string.format("TagDict(%s)", vim.iter(self.data):fold("{\n", function(acc, tag, noteref)
      return acc .. '    "' .. tag .. '": ' -- .. noteref.__tostring()
    end) .. "\n}")
  end,
}


--- test
TagDict.from_note_dict = function(note_dict)
  ---@type obsidian.TagDict
  local self = TagDict.init()
  self.data = {}

  ---@param id string
  ---@param note obsidian.Note
  vim.iter(note_dict):each(function(id, note)
    vim.iter(note.tags):each(
      function(x)
        self:add_ref(x, id)
      end
    )
    vim.iter(note.body_tags):each(
      function(x)
        self:add_ref(x.tag, id, x.line)
      end
    )
  end)

  return self
end

--- adds NoteRef to dictionary
---@param self obsidian.TagDict
---@param tag string
---@param id string
---@param line integer|?
TagDict.add_ref = function(self, tag, id, line)
  local new = NoteRef.new(id, line)
  if not self.data[tag] then
    self.data[tag] = { new }
  else
    table.insert(self.data[tag], new)
  end
end

return TagDict
